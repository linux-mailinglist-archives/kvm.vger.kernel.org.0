Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146155677D3
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 21:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiGET3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 15:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiGET3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 15:29:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE55F12A8A;
        Tue,  5 Jul 2022 12:29:19 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265IiAkH016083;
        Tue, 5 Jul 2022 19:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HEuoq2YSHBBN4rV0SRyFCJwjn/AL8CFvlcHD7NbAQZg=;
 b=I0h9Fb8j6X6UsZ7BPvMSiPcf0BsySkZNZLdssoRs5kp3z2Hdr7z3bhnFBivaS0DLuCfV
 oOyf/nj80d0vgQypcy2CdzCwB9IsbQF7HCKUpQ4mOmw2GgU7EBmyIBX1aEFR0aLZtZ+z
 PsRs3j6XDdY7QSh2rt+VzVMjDu4Fo/u+KWsWF4i7DGaxKvMCXhxAMETNhrbHFqyV4fTv
 g/y2P9rCDn9I5YRi00CDtIwR4byQouP7LivHWrLYNmaqYlvcTSoNBvTZBlVy1cv9H+/a
 hVNwvs54hzz6JwPvpUanPHajxgaiM2QgoTOsv1GRptYbAB7NHqoNl+85VBFT753jv28h VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4rpa4mg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:17 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 265ItLNm012319;
        Tue, 5 Jul 2022 19:29:17 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4rpa4mfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:17 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265JTG2C021479;
        Tue, 5 Jul 2022 19:29:16 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3h4ugf000m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:16 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265JTEVN25690480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 19:29:15 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0820BE053;
        Tue,  5 Jul 2022 19:29:14 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25E6CBE04F;
        Tue,  5 Jul 2022 19:29:14 +0000 (GMT)
Received: from [9.211.36.1] (unknown [9.211.36.1])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 19:29:14 +0000 (GMT)
Message-ID: <02420b8e-d775-e544-33fb-736a956c3010@linux.ibm.com>
Date:   Tue, 5 Jul 2022 15:29:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 08/11] vfio/ccw: Create an OPEN FSM Event
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630203647.2529815-9-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220630203647.2529815-9-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R5OhekzkID28RP6bjbtBD0ApSyFbBaFA
X-Proofpoint-ORIG-GUID: yh8HrHJQxOg5kTKizS05MzE0COs-AQdH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_16,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 adultscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/22 4:36 PM, Eric Farman wrote:
> Move the process of enabling a subchannel for use by vfio-ccw
> into the FSM, such that it can manage the sequence of lifecycle
> events for the device.
> 
> That is, if the FSM state is NOT_OPER(erational), then do the work
> that would enable the subchannel and move the FSM to STANDBY state.
> An attempt to perform this event again from any of the other operating
> states (IDLE, CP_PROCESSING, CP_PENDING) will convert the device back
> to NOT_OPER so the configuration process can be started again.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/s390/cio/vfio_ccw_drv.c     |  9 ++-------
>   drivers/s390/cio/vfio_ccw_fsm.c     | 21 +++++++++++++++++++++
>   drivers/s390/cio/vfio_ccw_private.h |  1 +
>   3 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index fe87a2652a22..7d9189640da3 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -231,15 +231,10 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>   
>   	dev_set_drvdata(&sch->dev, private);
>   
> -	spin_lock_irq(sch->lock);
> -	sch->isc = VFIO_CCW_ISC;
> -	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
> -	spin_unlock_irq(sch->lock);
> -	if (ret)
> +	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
> +	if (private->state == VFIO_CCW_STATE_NOT_OPER)
>   		goto out_free;
>   
> -	private->state = VFIO_CCW_STATE_STANDBY;
> -
>   	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
>   	if (ret)
>   		goto out_disable;
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index 88e529a2e184..2811b2040490 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -11,6 +11,8 @@
>   
>   #include <linux/vfio.h>
>   
> +#include <asm/isc.h>
> +
>   #include "ioasm.h"
>   #include "vfio_ccw_private.h"
>   
> @@ -368,6 +370,20 @@ static void fsm_irq(struct vfio_ccw_private *private,
>   		complete(private->completion);
>   }
>   
> +static void fsm_open(struct vfio_ccw_private *private,
> +		     enum vfio_ccw_event event)
> +{
> +	struct subchannel *sch = private->sch;
> +	int ret;
> +
> +	spin_lock_irq(sch->lock);
> +	sch->isc = VFIO_CCW_ISC;
> +	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
> +	if (!ret)
> +		private->state = VFIO_CCW_STATE_STANDBY;
> +	spin_unlock_irq(sch->lock);
> +}
> +
>   /*
>    * Device statemachine
>    */
> @@ -377,29 +393,34 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
>   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
>   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
>   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
> +		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
>   	},
>   	[VFIO_CCW_STATE_STANDBY] = {
>   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
>   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
>   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
>   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> +		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
>   	},
>   	[VFIO_CCW_STATE_IDLE] = {
>   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
>   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_request,
>   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
>   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> +		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
>   	},
>   	[VFIO_CCW_STATE_CP_PROCESSING] = {
>   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
>   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_retry,
>   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_retry,
>   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> +		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
>   	},
>   	[VFIO_CCW_STATE_CP_PENDING] = {
>   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
>   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_busy,
>   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
>   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> +		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
>   	},
>   };
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index 4cfdd5fc0961..8dff1699a7d9 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -142,6 +142,7 @@ enum vfio_ccw_event {
>   	VFIO_CCW_EVENT_IO_REQ,
>   	VFIO_CCW_EVENT_INTERRUPT,
>   	VFIO_CCW_EVENT_ASYNC_REQ,
> +	VFIO_CCW_EVENT_OPEN,
>   	/* last element! */
>   	NR_VFIO_CCW_EVENTS
>   };

