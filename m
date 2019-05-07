Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457F616BDF
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 22:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEGUHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 16:07:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726428AbfEGUHF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 May 2019 16:07:05 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x47K1t4Y021919
        for <kvm@vger.kernel.org>; Tue, 7 May 2019 16:07:04 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sbfxht2cf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 May 2019 16:07:03 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Tue, 7 May 2019 21:07:03 +0100
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 May 2019 21:07:01 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x47K6xe944826782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 May 2019 20:06:59 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBBA47805E;
        Tue,  7 May 2019 20:06:59 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 590E57805C;
        Tue,  7 May 2019 20:06:59 +0000 (GMT)
Received: from [9.56.58.73] (unknown [9.56.58.73])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  7 May 2019 20:06:59 +0000 (GMT)
Subject: Re: [PATCH v1 2/2] vfio-ccw: rework sch_event
To:     Pierre Morel <pmorel@linux.ibm.com>, cohuck@redhat.com
Cc:     pasic@linux.vnet.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
 <1557148270-19901-3-git-send-email-pmorel@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Tue, 7 May 2019 16:06:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <1557148270-19901-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050720-0012-0000-0000-0000173345A4
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011067; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01200020; UDB=6.00629611; IPR=6.00980902;
 MB=3.00026775; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-07 20:07:02
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050720-0013-0000-0000-0000572C7B1D
Message-Id: <3fac544d-897c-03ec-6a3f-709685f280a8@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-07_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=964 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905070126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/06/2019 09:11 AM, Pierre Morel wrote:
> Set the mediated device as non operational when the
> subchannel went non operational.
> Otherwise keep the current state.
> 
> Since we removed the last use of VFIO_CCW_STATE_STANDBY
> remove this state from the state machine.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c     | 11 +----------
>   drivers/s390/cio/vfio_ccw_fsm.c     |  7 +------
>   drivers/s390/cio/vfio_ccw_ops.c     |  2 +-
>   drivers/s390/cio/vfio_ccw_private.h |  1 -
>   4 files changed, 3 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index a95b6c7..2f6140d5 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -210,17 +210,8 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
>   	if (work_pending(&sch->todo_work))
>   		goto out_unlock;
>   
> -	if (cio_update_schib(sch)) {
> +	if (cio_update_schib(sch))
>   		vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
> -		rc = 0;
> -		goto out_unlock;
> -	}
> -
> -	private = dev_get_drvdata(&sch->dev);
> -	if (private->state == VFIO_CCW_STATE_NOT_OPER) {
> -		private->state = private->mdev ? VFIO_CCW_STATE_IDLE :
> -				 VFIO_CCW_STATE_STANDBY;
> -	}
>   	rc = 0;
>   
>   out_unlock:
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index 49d9d3d..a6524ca 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -88,6 +88,7 @@ static int fsm_do_halt(struct vfio_ccw_private *private)
>   
>   	/* Issue "Halt Subchannel" */
>   	ccode = hsch(sch->schid);
> +	pr_warn("ccode = hsch(sch->schid);\n");


I am not sure what's the purpose of logging this? Was it for your 
debugging purpose?

>   
>   	switch (ccode) {
>   	case 0:
> @@ -326,12 +327,6 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
>   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
>   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
>   	},
> -	[VFIO_CCW_STATE_STANDBY] = {
> -		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
> -		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
> -		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
> -		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> -	},
>   	[VFIO_CCW_STATE_IDLE] = {
>   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
>   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_request,
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 497419c..35445ca 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -162,7 +162,7 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
>   	if (cio_enable_subchannel(sch, (u32)(unsigned long)sch))
>   		goto error;
>   
> -	private->state = VFIO_CCW_STATE_STANDBY;
> +	private->state = VFIO_CCW_STATE_IDLE;
>   	spin_unlock_irq(sch->lock);
>   	return 0;
>   
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index f1092c3..ece6a75 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -105,7 +105,6 @@ extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
>    */
>   enum vfio_ccw_state {
>   	VFIO_CCW_STATE_NOT_OPER,
> -	VFIO_CCW_STATE_STANDBY,
>   	VFIO_CCW_STATE_IDLE,
>   	VFIO_CCW_STATE_CP_PROCESSING,
>   	VFIO_CCW_STATE_CP_PENDING,
> 

