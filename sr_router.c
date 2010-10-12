/**********************************************************************
 * file:  sr_router.c 
 * date:  Mon Feb 18 12:50:42 PST 2002  
 * Contact: casado@stanford.edu 
 *
 * Description:
 * 
 * This file contains all the functions that interact directly
 * with the routing table, as well as the main entry method
 * for routing.
 *
 **********************************************************************/

#include <stdio.h>
#include <assert.h>


#include "sr_if.h"
#include "sr_rt.h"
#include "sr_router.h"
#include "sr_protocol.h"

/*--------------------------------------------------------------------- 
 * Method: sr_init(void)
 * Scope:  Global
 *
 * Initialize the routing subsystem
 * 
 *---------------------------------------------------------------------*/

void sr_init(struct sr_instance* sr) 
{
    /* REQUIRES */
    assert(sr);

    /* Add initialization code here! */

} /* -- sr_init -- */

struct sr_instance* get_sr() {

  return &global_sr;

}

/*---------------------------------------------------------------------
 * Method: sr_handlepacket(uint8_t* p,char* interface)
 * Scope:  Global
 *
 * This method is called each time the router receives a packet on the
 * interface.  The packet buffer, the packet length and the receiving
 * interface are passed in as parameters. The packet is complete with
 * ethernet headers.
 *
 * Note: Both the packet buffer and the character's memory are handled
 * by sr_vns_comm.c that means do NOT delete either.  Make a copy of the
 * packet instead if you intend to keep it around beyond the scope of
 * the method call.
 *
 *---------------------------------------------------------------------*/

void sr_handlepacket(struct sr_instance* sr, 
        uint8_t * packet/* lent */,
        unsigned int len,
        char* interface/* lent */)
{
    /* REQUIRES */
    assert(sr);
    assert(packet);
    assert(interface);

    printf("*** -> Received packet of length %d \n",len);

}/* end sr_ForwardPacket */

uint32_t sr_integ_findsrcip(uint32_t dest /* nbo */) {

    fprintf(stderr, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    fprintf(stderr, "!!! Tranport layer called ip_findsrcip(..) this must be !!!\n");
    fprintf(stderr, "!!! defined to return the correct source address        !!!\n");
    fprintf(stderr, "!!! given a destination                                 !!!\n ");
    fprintf(stderr, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

    assert(0);

    /* --
     * e.g.
     *
     * struct sr_instance* sr = sr_get_global_instance();
     * struct my_router* mr = (struct my_router*)
     *                              sr_get_subsystem(sr);
     * return my_findsrcip(mr, dest);
     * -- */

    return 0;
}

uint32_t sr_integ_ip_output(uint8_t* payload /* given */,
                            uint8_t  proto,
                            uint32_t src, /* nbo */
                            uint32_t dest, /* nbo */
                            int len)
{
    fprintf(stderr, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    fprintf(stderr, "!!! Tranport layer called sr_integ_ip_output(..)        !!!\n");
    fprintf(stderr, "!!! this must be defined to handle the network          !!!\n ");
    fprintf(stderr, "!!! level functionality of transport packets            !!!\n ");
    fprintf(stderr, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

    assert(0);

    /* --
     * e.g.
     *
     * struct sr_instance* sr = sr_get_global_instance();
     * struct my_router* mr = (struct my_router*)
     *                              sr_get_subsystem(sr);
     * return my_ip_output(mr, payload, proto, src, dest, len);
     * -- */

    return 0;
} /* -- ip_integ_route -- */

/*--------------------------------------------------------------------- 
 * Method:
 *
 *---------------------------------------------------------------------*/
