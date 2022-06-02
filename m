Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6C553BF21
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbiFBTvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbiFBTvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:51:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAEF22F;
        Thu,  2 Jun 2022 12:51:18 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252Ja32L000608;
        Thu, 2 Jun 2022 19:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pkNR0AvAdOPHbWhxsTIhuSoE4M6ya54DTHKhfD82Wrg=;
 b=SPbMqdk9wHd20uqQ9ZZ531RfkrqJUQwkS47UImvGuBRP3KhJnM8nXZ8VaVHahRcRZKmn
 i3QFxj+RJKkvcQDgkNupC9l0FCM6nbk2uN7NbVH/t1ExfqbSE/k0YshmbGgDpYiHORbi
 qYnLGoqO+hNiz9udlm2qv9jBJoJpy+b/JK3RZx/zDvsaQ4YVWXLkdKdAtb086WTlMEZm
 35pGe8L6CuqntJuG/oHwcZ9SGVFlAgnu2SWYBHp4uMkvWL3yRiG/1GiXWb2nN2o0ZzJm
 FHSlzMBqenZIBVqf6oMWFopyBlKA6NWVhzouAEIbQsIHAslAxpm2nX5YdyQ+baVmsCNM WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gew9cqvnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:51:16 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252JaJvA002088;
        Thu, 2 Jun 2022 19:51:16 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gew9cqvnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:51:16 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252JZgBY006922;
        Thu, 2 Jun 2022 19:51:15 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3gds40ee4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:51:14 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252JpDVF30671306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 19:51:13 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CDF36A057;
        Thu,  2 Jun 2022 19:51:13 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94B086A051;
        Thu,  2 Jun 2022 19:51:12 +0000 (GMT)
Received: from [9.211.104.178] (unknown [9.211.104.178])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jun 2022 19:51:12 +0000 (GMT)
Message-ID: <715c1356-b700-f529-f7a8-bb917c8d95d5@linux.ibm.com>
Date:   Thu, 2 Jun 2022 15:51:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1 01/18] vfio/ccw: Remove UUID from s390 debug log
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Michael Kawano <mkawano@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-2-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220602171948.2790690-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kXBYNRdeCQfV1ca3CWFHPk_fYenqW0VO
X-Proofpoint-ORIG-GUID: d12coq0nn8a8-4m7Mzde5ZpRxZ8fkB7F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020083
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/22 1:19 PM, Eric Farman wrote:
> From: Michael Kawano <mkawano@linux.ibm.com>
> 
> As vfio-ccw devices are created/destroyed, the uuid of the associated
> mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost as
> they are created using pointers passed by reference.
> 
> This is a deliberate design point of s390dbf, but it leaves the uuid

This wording is confusing, maybe some re-wording would help here.

Basically, s390dbf doesn't support values passed by reference today 
(e.g. %pUl), it will just store that pointer (e.g. &mdev->uuid) and not 
its contents -- so a subsequent viewing of the s390dbf log at any point 
in the future will go peek at that referenced memory -- which might have 
been freed (e.g. mdev was removed).  So this change will fix potential 
garbage data viewed from the log or worse an oops when viewing the log 
-- the latter of which should probably be mentioned in the commit message.

I'm not sure if it was a deliberate design decision of s390dbf or just a 
feature that was never implemented, so I'd omit that altogether -- but 
it IS pointed out in the s390dbf documentation as a limitation anyway.

The code itself is fine:

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> in these traces less than useful. Since the subchannels are more
> constant, and are mapped 1:1 with the mdevs, the associated mdev can
> be discerned by looking at the device configuration (e.g., mdevctl)
> and places, such as kernel messages, where it is statically stored.
> 
> Thus, let's just remove the uuid from s390dbf traces. As we were
> the only consumer of mdev_uuid(), remove that too.
> 
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Signed-off-by: Michael Kawano <mkawano@linux.ibm.com>
> Fixes: 60e05d1cf0875 ("vfio-ccw: add some logging")
> Fixes: b7701dfbf9832 ("vfio-ccw: Register a chp_event callback for vfio-ccw")
> [farman: reworded commit message, added Fixes: tags]
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c |  5 ++---
>   drivers/s390/cio/vfio_ccw_fsm.c | 24 ++++++++++++------------
>   drivers/s390/cio/vfio_ccw_ops.c |  8 ++++----
>   include/linux/mdev.h            |  4 ----
>   4 files changed, 18 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index ee182cfb467d..35055eb94115 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -14,7 +14,6 @@
>   #include <linux/init.h>
>   #include <linux/device.h>
>   #include <linux/slab.h>
> -#include <linux/uuid.h>
>   #include <linux/mdev.h>
>   
>   #include <asm/isc.h>
> @@ -358,8 +357,8 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
>   		return 0;
>   
>   	trace_vfio_ccw_chp_event(private->sch->schid, mask, event);
> -	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
> -			   mdev_uuid(private->mdev), sch->schid.cssid,
> +	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: mask=0x%x event=%d\n",
> +			   sch->schid.cssid,
>   			   sch->schid.ssid, sch->schid.sch_no,
>   			   mask, event);
>   
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index e435a9cd92da..86b23732d899 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -256,8 +256,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>   		if (orb->tm.b) {
>   			io_region->ret_code = -EOPNOTSUPP;
>   			VFIO_CCW_MSG_EVENT(2,
> -					   "%pUl (%x.%x.%04x): transport mode\n",
> -					   mdev_uuid(mdev), schid.cssid,
> +					   "sch %x.%x.%04x: transport mode\n",
> +					   schid.cssid,
>   					   schid.ssid, schid.sch_no);
>   			errstr = "transport mode";
>   			goto err_out;
> @@ -266,8 +266,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>   					      orb);
>   		if (io_region->ret_code) {
>   			VFIO_CCW_MSG_EVENT(2,
> -					   "%pUl (%x.%x.%04x): cp_init=%d\n",
> -					   mdev_uuid(mdev), schid.cssid,
> +					   "sch %x.%x.%04x: cp_init=%d\n",
> +					   schid.cssid,
>   					   schid.ssid, schid.sch_no,
>   					   io_region->ret_code);
>   			errstr = "cp init";
> @@ -277,8 +277,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>   		io_region->ret_code = cp_prefetch(&private->cp);
>   		if (io_region->ret_code) {
>   			VFIO_CCW_MSG_EVENT(2,
> -					   "%pUl (%x.%x.%04x): cp_prefetch=%d\n",
> -					   mdev_uuid(mdev), schid.cssid,
> +					   "sch %x.%x.%04x: cp_prefetch=%d\n",
> +					   schid.cssid,
>   					   schid.ssid, schid.sch_no,
>   					   io_region->ret_code);
>   			errstr = "cp prefetch";
> @@ -290,8 +290,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>   		io_region->ret_code = fsm_io_helper(private);
>   		if (io_region->ret_code) {
>   			VFIO_CCW_MSG_EVENT(2,
> -					   "%pUl (%x.%x.%04x): fsm_io_helper=%d\n",
> -					   mdev_uuid(mdev), schid.cssid,
> +					   "sch %x.%x.%04x: fsm_io_helper=%d\n",
> +					   schid.cssid,
>   					   schid.ssid, schid.sch_no,
>   					   io_region->ret_code);
>   			errstr = "cp fsm_io_helper";
> @@ -301,16 +301,16 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>   		return;
>   	} else if (scsw->cmd.fctl & SCSW_FCTL_HALT_FUNC) {
>   		VFIO_CCW_MSG_EVENT(2,
> -				   "%pUl (%x.%x.%04x): halt on io_region\n",
> -				   mdev_uuid(mdev), schid.cssid,
> +				   "sch %x.%x.%04x: halt on io_region\n",
> +				   schid.cssid,
>   				   schid.ssid, schid.sch_no);
>   		/* halt is handled via the async cmd region */
>   		io_region->ret_code = -EOPNOTSUPP;
>   		goto err_out;
>   	} else if (scsw->cmd.fctl & SCSW_FCTL_CLEAR_FUNC) {
>   		VFIO_CCW_MSG_EVENT(2,
> -				   "%pUl (%x.%x.%04x): clear on io_region\n",
> -				   mdev_uuid(mdev), schid.cssid,
> +				   "sch %x.%x.%04x: clear on io_region\n",
> +				   schid.cssid,
>   				   schid.ssid, schid.sch_no);
>   		/* clear is handled via the async cmd region */
>   		io_region->ret_code = -EOPNOTSUPP;
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index d8589afac272..bebae21228aa 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -131,8 +131,8 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>   	private->mdev = mdev;
>   	private->state = VFIO_CCW_STATE_IDLE;
>   
> -	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: create\n",
> -			   mdev_uuid(mdev), private->sch->schid.cssid,
> +	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
> +			   private->sch->schid.cssid,
>   			   private->sch->schid.ssid,
>   			   private->sch->schid.sch_no);
>   
> @@ -154,8 +154,8 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
>   {
>   	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
>   
> -	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
> -			   mdev_uuid(mdev), private->sch->schid.cssid,
> +	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: remove\n",
> +			   private->sch->schid.cssid,
>   			   private->sch->schid.ssid,
>   			   private->sch->schid.sch_no);
>   
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 15d03f6532d0..a5788f592817 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -139,10 +139,6 @@ static inline void mdev_set_drvdata(struct mdev_device *mdev, void *data)
>   {
>   	mdev->driver_data = data;
>   }
> -static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
> -{
> -	return &mdev->uuid;
> -}
>   
>   extern struct bus_type mdev_bus_type;
>   

