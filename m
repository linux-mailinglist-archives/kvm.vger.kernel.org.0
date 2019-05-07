Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3618616BA1
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEGTpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:45:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726426AbfEGTpA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 May 2019 15:45:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x47JiLOx026973
        for <kvm@vger.kernel.org>; Tue, 7 May 2019 15:44:59 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sberamfgw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 May 2019 15:44:59 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Tue, 7 May 2019 20:44:59 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 May 2019 20:44:56 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x47JitI91966422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 May 2019 19:44:55 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56D8F78060;
        Tue,  7 May 2019 19:44:55 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C772E7805E;
        Tue,  7 May 2019 19:44:54 +0000 (GMT)
Received: from [9.56.58.73] (unknown [9.56.58.73])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  7 May 2019 19:44:54 +0000 (GMT)
Subject: Re: [PATCH v1 1/2] vfio-ccw: Set subchannel state STANDBY on open
To:     Pierre Morel <pmorel@linux.ibm.com>, cohuck@redhat.com
Cc:     pasic@linux.vnet.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
 <1557148270-19901-2-git-send-email-pmorel@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Tue, 7 May 2019 15:44:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <1557148270-19901-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050719-0016-0000-0000-000009AE4898
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011067; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01200012; UDB=6.00629607; IPR=6.00980895;
 MB=3.00026774; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-07 19:44:58
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050719-0017-0000-0000-0000431F3902
Message-Id: <3a55983d-c304-ec7e-f53d-8380576b9a42@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-07_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905070124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/06/2019 09:11 AM, Pierre Morel wrote:
> When no guest is associated with the mediated device,
> i.e. the mediated device is not opened, the state of
> the mediated device is VFIO_CCW_STATE_NOT_OPER.
> 
> The subchannel enablement and the according setting to the
> VFIO_CCW_STATE_STANDBY state should only be done when all
> parts of the VFIO mediated device have been initialized
> i.e. after the mediated device has been successfully opened.
> 
> Let's stay in VFIO_CCW_STATE_NOT_OPER until the mediated
> device has been opened.
> 
> When the mediated device is closed, disable the sub channel
> by calling vfio_ccw_sch_quiesce() no reset needs to be done
> the mediated devce will be enable on next open.

s/devce/device

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c | 10 +---------
>   drivers/s390/cio/vfio_ccw_ops.c | 36 ++++++++++++++++++------------------
>   2 files changed, 19 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index ee8767f..a95b6c7 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -143,26 +143,18 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>   	dev_set_drvdata(&sch->dev, private);
>   	mutex_init(&private->io_mutex);
>   
> -	spin_lock_irq(sch->lock);
>   	private->state = VFIO_CCW_STATE_NOT_OPER;
>   	sch->isc = VFIO_CCW_ISC;
> -	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
> -	spin_unlock_irq(sch->lock);
> -	if (ret)
> -		goto out_free;
>   
>   	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
>   	atomic_set(&private->avail, 1);
> -	private->state = VFIO_CCW_STATE_STANDBY;
>   
>   	ret = vfio_ccw_mdev_reg(sch);
>   	if (ret)
> -		goto out_disable;
> +		goto out_free;
>   
>   	return 0;
>   
> -out_disable:
> -	cio_disable_subchannel(sch);
>   out_free:
>   	dev_set_drvdata(&sch->dev, NULL);
>   	if (private->cmd_region)
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 5eb6111..497419c 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -115,14 +115,10 @@ static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>   	struct vfio_ccw_private *private =
>   		dev_get_drvdata(mdev_parent_dev(mdev));
>   
> -	if (private->state == VFIO_CCW_STATE_NOT_OPER)
> -		return -ENODEV;
> -
>   	if (atomic_dec_if_positive(&private->avail) < 0)
>   		return -EPERM;
>   
>   	private->mdev = mdev;
> -	private->state = VFIO_CCW_STATE_IDLE;
>   
>   	return 0;
>   }
> @@ -132,12 +128,7 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
>   	struct vfio_ccw_private *private =
>   		dev_get_drvdata(mdev_parent_dev(mdev));
>   
> -	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
> -	    (private->state != VFIO_CCW_STATE_STANDBY)) {
> -		if (!vfio_ccw_sch_quiesce(private->sch))
> -			private->state = VFIO_CCW_STATE_STANDBY;
> -		/* The state will be NOT_OPER on error. */
> -	}
> +	vfio_ccw_sch_quiesce(private->sch);
>   
>   	cp_free(&private->cp);
>   	private->mdev = NULL;
> @@ -151,6 +142,7 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
>   	struct vfio_ccw_private *private =
>   		dev_get_drvdata(mdev_parent_dev(mdev));
>   	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
> +	struct subchannel *sch = private->sch;
>   	int ret;
>   
>   	private->nb.notifier_call = vfio_ccw_mdev_notifier;
> @@ -165,6 +157,20 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
>   		vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>   					 &private->nb);
>   	return ret;
> +
> +	spin_lock_irq(private->sch->lock);
> +	if (cio_enable_subchannel(sch, (u32)(unsigned long)sch))
> +		goto error;
> +
> +	private->state = VFIO_CCW_STATE_STANDBY;

I don't think we should set the state to STANDBY here, because with just 
this patch applied, any VFIO_CCW_EVENT_IO_REQ will return an error (due 
to fsm_io_error).

It might be safe to set it to IDLE in this patch.


> +	spin_unlock_irq(sch->lock);
> +	return 0;
> +
> +error:
> +	spin_unlock_irq(sch->lock);
> +	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> +				 &private->nb);
> +	return -EFAULT;
>   }
>   
>   static void vfio_ccw_mdev_release(struct mdev_device *mdev)
> @@ -173,20 +179,14 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
>   		dev_get_drvdata(mdev_parent_dev(mdev));
>   	int i;
>   
> -	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
> -	    (private->state != VFIO_CCW_STATE_STANDBY)) {
> -		if (!vfio_ccw_mdev_reset(mdev))
> -			private->state = VFIO_CCW_STATE_STANDBY;
> -		/* The state will be NOT_OPER on error. */
> -	}
> -
> -	cp_free(&private->cp);
> +	vfio_ccw_sch_quiesce(private->sch);
>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>   				 &private->nb);
>   
>   	for (i = 0; i < private->num_regions; i++)
>   		private->region[i].ops->release(private, &private->region[i]);
>   
> +	cp_free(&private->cp);
>   	private->num_regions = 0;
>   	kfree(private->region);
>   	private->region = NULL;
> 

