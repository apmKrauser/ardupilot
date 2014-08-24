/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-
#ifndef __ARDUCOPTER_USERVAR_H__
#define __ARDUCOPTER_USERVAR_H__

// user defined variables

// example variables used in Wii camera testing - replace with your own
// variables
#ifdef USERHOOK_VARIABLES

#if WII_CAMERA == 1
WiiCamera           ircam;
int                 WiiRange=0;
int                 WiiRotation=0;
int                 WiiDisplacementX=0;
int                 WiiDisplacementY=0;
#endif  // WII_CAMERA

#endif  // USERHOOK_VARIABLES



#define msg_toNano_size 9
#define msg_fromNano_size 4
#define LOG_ADDSENSORS_MSG 0xF0

struct PACKED log_AddSensors {
    LOG_PACKET_HEADER;
    int16_t val1;
    int16_t val2;   
};

// byte = unsigned char

int16_t remote_RPM;
uint8_t nano_frontlight_auto = 1;
uint8_t nano_frontlight_on = 0;
uint8_t nanoRXi = 0;
uint8_t msg_toNano[msg_toNano_size] = {0};
uint8_t msg_fromNano[msg_fromNano_size] = {0};

#endif



