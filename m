Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDD453D214
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 21:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347932AbiFCTDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 15:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346017AbiFCTDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 15:03:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76C130F53;
        Fri,  3 Jun 2022 12:03:10 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253Go841010916;
        Fri, 3 Jun 2022 19:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=PgxYIG8PJJLALUpiAGKfgFkESXEXvrlas7ZMyunsupc=;
 b=RWeun5R6Ojfnt1ojIi3+PG+hT9SUvhzsRWuHHkBl1rwRQq7IbqwHDOuPWMNTGHYY+D9M
 BqCm6y1wsTE4lrcddBEoRwChcp/zuX1C6hbgS60GLgRi51j+WZCj25/IcHxMkVSl1uKD
 qEUuYeuNjE26lVV7drWMW5ec/IkfugNWbkUOeY2XB3MARCenLpY0z/yuSh3t2B8e/xme
 ao8eyjz08DaQamianmjmIkuczNNEL07f9Pr2r6ctUX6/m8s5i6XzPlq05o9t1w97jGd6
 ImUpX8dvKMW2MPM7DUYMEoErriK74rrY0heQ+4kFdsmrr5YpqAPC/FIDZLlUYh+ZdA3n mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgu78pur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 19:03:08 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253J1i4G014750;
        Fri, 3 Jun 2022 19:03:07 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgu78pu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 19:03:07 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253IaE7d016411;
        Fri, 3 Jun 2022 19:03:06 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3gcxt652rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 19:03:06 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253J355E34537838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 19:03:05 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 316F9C605D;
        Fri,  3 Jun 2022 19:03:05 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31DA1C6057;
        Fri,  3 Jun 2022 19:03:04 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.94.47])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 19:03:04 +0000 (GMT)
Message-ID: <a9ff5850a4964fe0238261c35591c3c18a4a8df3.camel@linux.ibm.com>
Subject: Re: [PATCH v1 01/18] vfio/ccw: Remove UUID from s390 debug log
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Michael Kawano <mkawano@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Date:   Fri, 03 Jun 2022 15:03:02 -0400
In-Reply-To: <715c1356-b700-f529-f7a8-bb917c8d95d5@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
         <20220602171948.2790690-2-farman@linux.ibm.com>
         <715c1356-b700-f529-f7a8-bb917c8d95d5@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RLhEcyZeta-WO1VooYtfL2nZ3Kbchc1R
X-Proofpoint-GUID: JMfMq6xaRFN1vq2XLWrcMFBBKk5KEhww
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-02 at 15:51 -0400, Matthew Rosato wrote:
> On 6/2/22 1:19 PM, Eric Farman wrote:
> > From: Michael Kawano <mkawano@linux.ibm.com>
> > 
> > As vfio-ccw devices are created/destroyed, the uuid of the
> > associated
> > mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost
> > as
> > they are created using pointers passed by reference.
> > 
> > This is a deliberate design point of s390dbf, but it leaves the
> > uuid
> 
> This wording is confusing, maybe some re-wording would help here.
> 
> Basically, s390dbf doesn't support values passed by reference today 
> (e.g. %pUl), it will just store that pointer (e.g. &mdev->uuid) and
> not 
> its contents -- so a subsequent viewing of the s390dbf log at any
> point 
> in the future will go peek at that referenced memory -- which might
> have 
> been freed (e.g. mdev was removed).  So this change will fix
> potential 
> garbage data viewed from the log or worse an oops when viewing the
> log 
> -- the latter of which should probably be mentioned in the commit
> message.
> 
> I'm not sure if it was a deliberate design decision of s390dbf or
> just a 
> feature that was never implemented, so I'd omit that altogether --
> but 
> it IS pointed out in the s390dbf documentation as a limitation
> anyway.

@Jason, @Matt...  All fair, I obviously got too verbose in whatever I
was writing at the time. I've changed this to:

As vfio-ccw devices are created/destroyed, the uuid of the associated
mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost.
This is because a pointer to the UUID is stored instead of the UUID
itself, and that memory may have been repurposed if/when the logs are
examined. The result is usually garbage UUID data in the logs, though
there is an outside chance of an oops happening here.

Simply remove the UUID from the traces, as the subchannel number will
provide useful configuration information for problem determination,
and is stored directly into the log instead of a pointer.

As we were the only consumer of mdev_uuid(), remove that too.

> 
> The code itself is fine:
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> > in these traces less than useful. Since the subchannels are more
> > constant, and are mapped 1:1 with the mdevs, the associated mdev
> > can
> > be discerned by looking at the device configuration (e.g., mdevctl)
> > and places, such as kernel messages, where it is statically stored.
> > 
> > Thus, let's just remove the uuid from s390dbf traces. As we were
> > the only consumer of mdev_uuid(), remove that too.
> > 
> > Cc: Kirti Wankhede <kwankhede@nvidia.com>
> > Signed-off-by: Michael Kawano <mkawano@linux.ibm.com>
> > Fixes: 60e05d1cf0875 ("vfio-ccw: add some logging")
> > Fixes: b7701dfbf9832 ("vfio-ccw: Register a chp_event callback for
> > vfio-ccw")
> > [farman: reworded commit message, added Fixes: tags]
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   drivers/s390/cio/vfio_ccw_drv.c |  5 ++---
> >   drivers/s390/cio/vfio_ccw_fsm.c | 24 ++++++++++++------------
> >   drivers/s390/cio/vfio_ccw_ops.c |  8 ++++----
> >   include/linux/mdev.h            |  4 ----
> >   4 files changed, 18 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> > b/drivers/s390/cio/vfio_ccw_drv.c
> > index ee182cfb467d..35055eb94115 100644
> > --- a/drivers/s390/cio/vfio_ccw_drv.c
> > +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > @@ -14,7 +14,6 @@
> >   #include <linux/init.h>
> >   #include <linux/device.h>
> >   #include <linux/slab.h>
> > -#include <linux/uuid.h>
> >   #include <linux/mdev.h>
> >   
> >   #include <asm/isc.h>
> > @@ -358,8 +357,8 @@ static int vfio_ccw_chp_event(struct subchannel
> > *sch,
> >   		return 0;
> >   
> >   	trace_vfio_ccw_chp_event(private->sch->schid, mask, event);
> > -	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x
> > event=%d\n",
> > -			   mdev_uuid(private->mdev), sch->schid.cssid,
> > +	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: mask=0x%x event=%d\n",
> > +			   sch->schid.cssid,
> >   			   sch->schid.ssid, sch->schid.sch_no,
> >   			   mask, event);
> >   
> > diff --git a/drivers/s390/cio/vfio_ccw_fsm.c
> > b/drivers/s390/cio/vfio_ccw_fsm.c
> > index e435a9cd92da..86b23732d899 100644
> > --- a/drivers/s390/cio/vfio_ccw_fsm.c
> > +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> > @@ -256,8 +256,8 @@ static void fsm_io_request(struct
> > vfio_ccw_private *private,
> >   		if (orb->tm.b) {
> >   			io_region->ret_code = -EOPNOTSUPP;
> >   			VFIO_CCW_MSG_EVENT(2,
> > -					   "%pUl (%x.%x.%04x):
> > transport mode\n",
> > -					   mdev_uuid(mdev),
> > schid.cssid,
> > +					   "sch %x.%x.%04x: transport
> > mode\n",
> > +					   schid.cssid,
> >   					   schid.ssid, schid.sch_no);
> >   			errstr = "transport mode";
> >   			goto err_out;
> > @@ -266,8 +266,8 @@ static void fsm_io_request(struct
> > vfio_ccw_private *private,
> >   					      orb);
> >   		if (io_region->ret_code) {
> >   			VFIO_CCW_MSG_EVENT(2,
> > -					   "%pUl (%x.%x.%04x):
> > cp_init=%d\n",
> > -					   mdev_uuid(mdev),
> > schid.cssid,
> > +					   "sch %x.%x.%04x:
> > cp_init=%d\n",
> > +					   schid.cssid,
> >   					   schid.ssid, schid.sch_no,
> >   					   io_region->ret_code);
> >   			errstr = "cp init";
> > @@ -277,8 +277,8 @@ static void fsm_io_request(struct
> > vfio_ccw_private *private,
> >   		io_region->ret_code = cp_prefetch(&private->cp);
> >   		if (io_region->ret_code) {
> >   			VFIO_CCW_MSG_EVENT(2,
> > -					   "%pUl (%x.%x.%04x):
> > cp_prefetch=%d\n",
> > -					   mdev_uuid(mdev),
> > schid.cssid,
> > +					   "sch %x.%x.%04x:
> > cp_prefetch=%d\n",
> > +					   schid.cssid,
> >   					   schid.ssid, schid.sch_no,
> >   					   io_region->ret_code);
> >   			errstr = "cp prefetch";
> > @@ -290,8 +290,8 @@ static void fsm_io_request(struct
> > vfio_ccw_private *private,
> >   		io_region->ret_code = fsm_io_helper(private);
> >   		if (io_region->ret_code) {
> >   			VFIO_CCW_MSG_EVENT(2,
> > -					   "%pUl (%x.%x.%04x):
> > fsm_io_helper=%d\n",
> > -					   mdev_uuid(mdev),
> > schid.cssid,
> > +					   "sch %x.%x.%04x:
> > fsm_io_helper=%d\n",
> > +					   schid.cssid,
> >   					   schid.ssid, schid.sch_no,
> >   					   io_region->ret_code);
> >   			errstr = "cp fsm_io_helper";
> > @@ -301,16 +301,16 @@ static void fsm_io_request(struct
> > vfio_ccw_private *private,
> >   		return;
> >   	} else if (scsw->cmd.fctl & SCSW_FCTL_HALT_FUNC) {
> >   		VFIO_CCW_MSG_EVENT(2,
> > -				   "%pUl (%x.%x.%04x): halt on
> > io_region\n",
> > -				   mdev_uuid(mdev), schid.cssid,
> > +				   "sch %x.%x.%04x: halt on
> > io_region\n",
> > +				   schid.cssid,
> >   				   schid.ssid, schid.sch_no);
> >   		/* halt is handled via the async cmd region */
> >   		io_region->ret_code = -EOPNOTSUPP;
> >   		goto err_out;
> >   	} else if (scsw->cmd.fctl & SCSW_FCTL_CLEAR_FUNC) {
> >   		VFIO_CCW_MSG_EVENT(2,
> > -				   "%pUl (%x.%x.%04x): clear on
> > io_region\n",
> > -				   mdev_uuid(mdev), schid.cssid,
> > +				   "sch %x.%x.%04x: clear on
> > io_region\n",
> > +				   schid.cssid,
> >   				   schid.ssid, schid.sch_no);
> >   		/* clear is handled via the async cmd region */
> >   		io_region->ret_code = -EOPNOTSUPP;
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> > b/drivers/s390/cio/vfio_ccw_ops.c
> > index d8589afac272..bebae21228aa 100644
> > --- a/drivers/s390/cio/vfio_ccw_ops.c
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -131,8 +131,8 @@ static int vfio_ccw_mdev_probe(struct
> > mdev_device *mdev)
> >   	private->mdev = mdev;
> >   	private->state = VFIO_CCW_STATE_IDLE;
> >   
> > -	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: create\n",
> > -			   mdev_uuid(mdev), private->sch->schid.cssid,
> > +	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
> > +			   private->sch->schid.cssid,
> >   			   private->sch->schid.ssid,
> >   			   private->sch->schid.sch_no);
> >   
> > @@ -154,8 +154,8 @@ static void vfio_ccw_mdev_remove(struct
> > mdev_device *mdev)
> >   {
> >   	struct vfio_ccw_private *private = dev_get_drvdata(mdev-
> > >dev.parent);
> >   
> > -	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
> > -			   mdev_uuid(mdev), private->sch->schid.cssid,
> > +	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: remove\n",
> > +			   private->sch->schid.cssid,
> >   			   private->sch->schid.ssid,
> >   			   private->sch->schid.sch_no);
> >   
> > diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> > index 15d03f6532d0..a5788f592817 100644
> > --- a/include/linux/mdev.h
> > +++ b/include/linux/mdev.h
> > @@ -139,10 +139,6 @@ static inline void mdev_set_drvdata(struct
> > mdev_device *mdev, void *data)
> >   {
> >   	mdev->driver_data = data;
> >   }
> > -static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
> > -{
> > -	return &mdev->uuid;
> > -}
> >   
> >   extern struct bus_type mdev_bus_type;
> >   

