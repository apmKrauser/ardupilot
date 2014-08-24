/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

#ifdef USERHOOK_INIT
void userhook_init()
{
    // put your initialisation code here
    // this will be called once at start-up
    
    hal.uartC->begin(38400, 32, 32);
    hal.uartC->set_blocking_writes(false);
    
}
#endif

#ifdef USERHOOK_FASTLOOP
void userhook_FastLoop()
{
    // put your 100Hz code here
}
#endif

#ifdef USERHOOK_50HZLOOP
void userhook_50Hz()
{
    // put your 50Hz code here
	static uint8_t cnt = 0;
	cnt++;
	if ( (cnt == 1) || (cnt == (1 + 25)) ) read_from_Nano();
	if ( (cnt == 7) || (cnt == (7 + 25)) ) parse_from_Nano();
	if ( (cnt == 13) || (cnt == (13 + 25)) ) pack_msg_for_Nano();
	if ( (cnt == 19) || (cnt == (19 + 25)) ) write_to_Nano();
	if (cnt >= 50) {
		cnt = 0;
	} 
}
#endif

#ifdef USERHOOK_MEDIUMLOOP
void userhook_MediumLoop()
{
    // put your 10Hz code here
}
#endif

#ifdef USERHOOK_SLOWLOOP
void userhook_SlowLoop()
{
    // put your 3.3Hz code here
    // Log_Write_AddSensors();
}
#endif

#ifdef USERHOOK_SUPERSLOWLOOP
void userhook_SuperSlowLoop()
{
    // put your 1Hz code here
    Log_Write_AddSensors();
}
#endif

void parse_from_Nano() 
{
	uint8_t ap_bitflags = 0;
    uint16_t _rpm = 0;
	if (nanoRXi != msg_fromNano_size) return;
	nanoRXi = 0;
	if (msg_fromNano[0] != 0xFF) return;
    _rpm = msg_fromNano[2];
    _rpm <<= 8;
    _rpm += msg_fromNano[1];
	remote_RPM = (int16_t) _rpm;
	ap_bitflags = msg_fromNano[3];
}

void read_from_Nano()
{
	int      c;
	while ((hal.uartC->available() > 0) && (nanoRXi < msg_fromNano_size))
	{
		c = hal.uartC->read();
		msg_fromNano[nanoRXi] = (uint8_t) c;
		nanoRXi++;
	}
	while (hal.uartC->available() > 0) c = hal.uartC->read(); // clear buffer
}

void write_to_Nano()
{
    hal.uartC->write(msg_toNano, msg_toNano_size);
}


void pack_msg_for_Nano()
{
	uint8_t ap_bitflags = 0;
	uint16_t alt_by_sonar = 0;
	uint16_t alt_over_home = 0;
	if (ap.home_is_set) ap_bitflags |= (1 << 0);
    if (motors.armed() == true) ap_bitflags |= (1 << 1);
    if (nano_frontlight_auto) ap_bitflags |= (1 << 2);
    if (nano_frontlight_on) ap_bitflags |= (1 << 3);
	alt_by_sonar = (uint16_t) sonar_alt;
    alt_over_home = (uint16_t) (( current_loc.alt - home.alt ) / 100);
	msg_toNano[0] = 0xFF;
	msg_toNano[1] = ap_bitflags;
	msg_toNano[2] = (uint8_t) (alt_by_sonar & 0x00FF);
	msg_toNano[3] = (uint8_t) ((alt_by_sonar & 0xFF00) >> 8);
	msg_toNano[4] = (uint8_t) (alt_over_home & 0x00FF);
	msg_toNano[5] = (uint8_t) ((alt_over_home & 0xFF00) >> 8);
    msg_toNano[6] = (uint8_t) (g.mnt_autortrct_h);
    msg_toNano[7] = (uint8_t) (control_mode);
    msg_toNano[8] = 0x00;

}


static void Log_Write_AddSensors()
{
    struct log_AddSensors pkt = {
        LOG_PACKET_HEADER_INIT(LOG_ADDSENSORS_MSG),
        val1              : remote_RPM,
        val2              : 0
    };
    DataFlash.WriteBlock(&pkt, sizeof(pkt));
}





