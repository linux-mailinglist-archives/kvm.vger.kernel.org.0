Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3418654E80E
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377090AbiFPQs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 12:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378519AbiFPQsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 12:48:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F08274;
        Thu, 16 Jun 2022 09:48:45 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GFgWsq013004;
        Thu, 16 Jun 2022 16:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/eQCzarlfdsOw2sh7xIbiRlakkDqEkJ1fs8yTubQsnc=;
 b=jZG6Ej7LlUX0jlbqc/BpzpiTGAP1WF+X0ug4zxhFWM/4FGOhu0jtn6OKSJBFcJ1GfVY6
 utd/C0mdwwEiPvZrO9evh8NHH+1bIYckixa6fvNIXVKgHtQJ2icKfj2VNnrd4aFDJo/Q
 OOUs2S6I913CurH7Le4J7vmL4FwVzrgfMJ1aAsjaiPtpRanTxwWGz5eLQ46CJpXl5K6P
 k9eLmABxJNgiSxSXQ21p14AF10kITeSCRLar6Lest6BZ7P0I5DKQUUqlGbdpePClRQuS
 SYA6+/fjSrIFg3FQxA5sXnigsF8qnPEL9GhjVQ4qPFzVwKuV56OAQHfmO71scPbZxa+w HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqr2prgmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 16:48:43 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25GFii2M006561;
        Thu, 16 Jun 2022 16:48:42 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqr2prgm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 16:48:42 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25GGamEN031796;
        Thu, 16 Jun 2022 16:48:42 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3gmjpak3sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 16:48:42 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25GGmf5I8520110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 16:48:41 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24F54136051;
        Thu, 16 Jun 2022 16:48:41 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4692D136059;
        Thu, 16 Jun 2022 16:48:40 +0000 (GMT)
Received: from [9.211.56.136] (unknown [9.211.56.136])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jun 2022 16:48:40 +0000 (GMT)
Message-ID: <75e251c7-f239-a0d6-4ee6-51b7cdfb5b83@linux.ibm.com>
Date:   Thu, 16 Jun 2022 12:48:38 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 08/10] vfio/ccw: Create a CLOSE FSM event
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220615203318.3830778-1-farman@linux.ibm.com>
 <20220615203318.3830778-9-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220615203318.3830778-9-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IpdH8gqToE_6gaFYSBBcKFGrboTAOe-n
X-Proofpoint-ORIG-GUID: HnqfNTPoQtXMnfKINjvXD_KC4MQfj4WY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_12,2022-06-16_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=991 phishscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160068
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/22 4:33 PM, Eric Farman wrote:
> Refactor the vfio_ccw_sch_quiesce() routine to extract the bit that
> disables the subchannel and affects the FSM state. Use this to form
> the basis of a CLOSE event that will mirror the OPEN event, and move
> the subchannel back to NOT_OPER state.

Similar comments here related to previous patch.  If a close event can 
trigger fsm_notoper then it should probably should cut a different trace 
entry when event == CLOSE

> 
> A key difference with that mirroring is that while OPEN handles the
> transition from NOT_OPER => STANDBY, the later probing of the mdev
> handles the transition from STANDBY => IDLE. On the other hand,
> the CLOSE event will move from one of the operating states {IDLE,
> CP_PROCESSING, CP_PENDING} => NOT_OPER. That is, there is no stop
> in a STANDBY state on the deconfigure path.
> 
> Add a call to cp_free() in this event, such that it is captured for
> the various permutations of this event.
> 
> In the unlikely event that cio_disable_subchannel() returns -EBUSY,
> the remaining logic of vfio_ccw_sch_quiesce() can still be used.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c     | 17 +++++------------
>   drivers/s390/cio/vfio_ccw_fsm.c     | 26 ++++++++++++++++++++++++++
>   drivers/s390/cio/vfio_ccw_ops.c     | 14 ++------------
>   drivers/s390/cio/vfio_ccw_private.h |  1 +
>   4 files changed, 34 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 52249c40a565..62bd6f969b76 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -41,13 +41,6 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
>   	DECLARE_COMPLETION_ONSTACK(completion);
>   	int iretry, ret = 0;
>   
> -	spin_lock_irq(sch->lock);
> -	if (!sch->schib.pmcw.ena)
> -		goto out_unlock;
> -	ret = cio_disable_subchannel(sch);
> -	if (ret != -EBUSY)
> -		goto out_unlock;
> -
>   	iretry = 255;
>   	do {
>   
> @@ -74,9 +67,7 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
>   		spin_lock_irq(sch->lock);
>   		ret = cio_disable_subchannel(sch);
>   	} while (ret == -EBUSY);
> -out_unlock:
> -	private->state = VFIO_CCW_STATE_NOT_OPER;
> -	spin_unlock_irq(sch->lock);
> +
>   	return ret;
>   }
>   
> @@ -258,7 +249,7 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
>   {
>   	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
>   
> -	vfio_ccw_sch_quiesce(sch);
> +	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
>   	mdev_unregister_device(&sch->dev);
>   
>   	dev_set_drvdata(&sch->dev, NULL);
> @@ -272,7 +263,9 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
>   
>   static void vfio_ccw_sch_shutdown(struct subchannel *sch)
>   {
> -	vfio_ccw_sch_quiesce(sch);
> +	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
> +
> +	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
>   }
>   
>   /**
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index 7e7ed69e1461..fa546d33e595 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -380,6 +380,27 @@ static void fsm_open(struct vfio_ccw_private *private,
>   	spin_unlock_irq(sch->lock);
>   }
>   
> +static void fsm_close(struct vfio_ccw_private *private,
> +		      enum vfio_ccw_event event)
> +{
> +	struct subchannel *sch = private->sch;
> +	int ret;
> +
> +	spin_lock_irq(sch->lock);
> +
> +	if (!sch->schib.pmcw.ena)
> +		goto out_unlock;
> +
> +	ret = cio_disable_subchannel(sch);
> +	if (ret == -EBUSY)
> +		vfio_ccw_sch_quiesce(sch);
> +
> +out_unlock:
> +	private->state = VFIO_CCW_STATE_NOT_OPER;
> +	spin_unlock_irq(sch->lock);
> +	cp_free(&private->cp);
> +}
> +
>   /*
>    * Device statemachine
>    */
> @@ -390,6 +411,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
>   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
>   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
>   		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
> +		[VFIO_CCW_EVENT_CLOSE]		= fsm_nop,
>   	},
>   	[VFIO_CCW_STATE_STANDBY] = {
>   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
> @@ -397,6 +419,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
>   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
>   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
>   		[VFIO_CCW_EVENT_OPEN]		= fsm_nop,
> +		[VFIO_CCW_EVENT_CLOSE]		= fsm_notoper,

But if we are in STANDBY doesn't that imply we already did the OPEN? 
Don't we need to close it now before going NOT_OPER?


