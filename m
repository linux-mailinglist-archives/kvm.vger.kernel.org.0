Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B784C54E760
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 18:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiFPQeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 12:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiFPQeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 12:34:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7710A28E1B;
        Thu, 16 Jun 2022 09:34:16 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GG0EWe015227;
        Thu, 16 Jun 2022 16:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ci/a7I63QJU+Pc7s+bkHePJfXI1vWQ2/kGBX5DvlM3Q=;
 b=YEEPUATk8V8IqRE4TbVHePsHnfmDnXjohoyabbBow6ltx/hlAOtS8E43gYAvbGmpUxly
 L+qaP2VGIT9w9AweW1NAuI+HMT6u9Y0ejbn51ZRYeEl3YAHukbqry+87KkkoIsrXEUFv
 fyGluTWu/h5tvn8jI4egMddkMAn+ELRKQPHDbO9ekemMSMSQ+zaWManJwRNmsG/jyp6Q
 dD6/xJ0dTtKYLzj4Wpk/W6piWt+fefIJgDxpJRqyeNodMN+5kGQNkepc7DZ2gyN/PFWX
 AoXA0tz87aFC6fHytYp7Ps53KhC4+VHG+QVazId2I2tuzSf7uYho1mijpum7OkCPxuTL 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqhbdku8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 16:34:14 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25GGWLLW002316;
        Thu, 16 Jun 2022 16:34:14 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqhbdku85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 16:34:14 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25GGL9Xs020643;
        Thu, 16 Jun 2022 16:34:13 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 3gmjpabmp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 16:34:13 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25GGYBxC33161480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 16:34:11 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91643136053;
        Thu, 16 Jun 2022 16:34:11 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F14A513604F;
        Thu, 16 Jun 2022 16:33:55 +0000 (GMT)
Received: from [9.211.56.136] (unknown [9.211.56.136])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jun 2022 16:33:55 +0000 (GMT)
Message-ID: <0816ab3a-8601-0462-6c2b-4ba7fa8a1e2b@linux.ibm.com>
Date:   Thu, 16 Jun 2022 12:33:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 07/10] vfio/ccw: Create an OPEN FSM Event
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220615203318.3830778-1-farman@linux.ibm.com>
 <20220615203318.3830778-8-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220615203318.3830778-8-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GSDu_1LVU3yCzKwkroV2dBdSOXD4Ug7w
X-Proofpoint-GUID: 5qb3tBapchWviQP6DXBGDX-wRC93J5Zr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_12,2022-06-16_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160068
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
> Move the process of enabling a subchannel for use by vfio-ccw
> into the FSM, such that it can manage the sequence of lifecycle
> events for the device.
> 
> That is, if the FSM state is NOT_OPER(erational), then do the work
> that would enable the subchannel and move the FSM to STANDBY state.
> An attempt to perform this event again from any of the other operating
> states (IDLE, CP_PROCESSING, CP_PENDING) will convert the device back
> to NOT_OPER so the configuration process can be started again.

Except STANDBY, which ignores the event via fsm_nop.  I wonder though, 
whether that's the right thing to do.  For each of the other states 
you're saying 'if it's already open, go back to NOT_OPER so we can start 
over' -- In this case a STANDBY->STANDBY is also a case of 'it's already 
open' so shouldn't we also go back to NOT_OPER so we can start over? 
Seems to me really we just don't expect to ever get an OPEN event unless 
we are in NOT_OPER.

If there's a reason to keep STANDBY->STANDBY as a nop, but we don't 
expect to see it and don't' want to WARN because of it, then maybe a log 
entry at least would make sense.

As for the IDLE/CP_PROCESSING/CP_PENDING cases, going fsm_notoper 
because this is unexpected probably makes sense, but the logging is 
going to be really confusing (before this change, you know that you 
called fsm_notoper because you got VFIO_CCW_EVENT_NOT_OPER -- now you'll 
see a log entry cut for NOT_OPER but won't be sure if it was for 
EVENT_NOT_OPER or EVENT_OPEN).  Maybe you can look at 'event' inside 
fsm_notoper and cut a slightly different trace entry when arriving here 
for EVENT_OPEN?

...

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

nit: could get rid of 'ret' and just do

if (!cio_enable...)
      private->state = VFIO_CCW_STATE_STANDBY;

> +	spin_unlock_irq(sch->lock);
> +}
> +
>   /*
>    * Device statemachine
>    */
> @@ -373,29 +389,34 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
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
> +		[VFIO_CCW_EVENT_OPEN]		= fsm_nop,
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

