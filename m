Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E48929A4DE
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 07:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389474AbgJ0GtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 02:49:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64696 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729266AbgJ0GtK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Oct 2020 02:49:10 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09R6XW72018967;
        Tue, 27 Oct 2020 02:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pdQzz4sR2w6POddytidGqkZM0aAsPfylQnOQkzgba4c=;
 b=QtEnD40bxnO/KGNWp0sJoZ2cG9xxtS/DUCO4Bh1Id2+QVn56tUQGUTr7hlKC6yYXvy7s
 M9raI/DTbsXJkFYBCpxmE3U942en/nkXHcvDuAoZQTxmEjV7WIM4jwq+SblYZFK/RZR0
 ttega+OgLCZt7kVZwv3nHTrihkbR3P9JAvKUZS/3tQuS2KlkBr//nz9P9MNR947Ojcwk
 2sGNN4/kbNYf8CCejqRUMvsgoHia1Veiun8LuXpdhZ6E5ECrx9r4eirkMW4aG4MlYXiG
 mM9UaqdJpxr4muhSLvheGknxgaiO6QMEA02vkeSzOjL+4rh9ToKDS78pB03riN+Ckjo9 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dw51wewa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 02:49:04 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09R6n3P0058335;
        Tue, 27 Oct 2020 02:49:04 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dw51wevh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 02:49:03 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09R6XZpa009435;
        Tue, 27 Oct 2020 06:49:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 34cbw7u1e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 06:49:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09R6mxgD29294852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 06:48:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B32411C05B;
        Tue, 27 Oct 2020 06:48:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EF8511C04A;
        Tue, 27 Oct 2020 06:48:58 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.77.212])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Oct 2020 06:48:58 +0000 (GMT)
Date:   Tue, 27 Oct 2020 07:48:46 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
Message-ID: <20201027074846.30ee0ddc.pasic@linux.ibm.com>
In-Reply-To: <20201022171209.19494-2-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-27_01:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=2
 phishscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 13:11:56 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The queues assigned to a matrix mediated device are currently reset when:
> 
> * The VFIO_DEVICE_RESET ioctl is invoked
> * The mdev fd is closed by userspace (QEMU)
> * The mdev is removed from sysfs.

What about the situation when vfio_ap_mdev_group_notifier() is called to
tell us that our pointer to KVM is about to become invalid? Do we need to
clean up the IRQ stuff there?

> 
> Immediately after the reset of a queue, a call is made to disable
> interrupts for the queue. This is entirely unnecessary because the reset of
> a queue disables interrupts, so this will be removed.

Makes sense.

> 
> Since interrupt processing may have been enabled by the guest, it may also
> be necessary to clean up the resources used for interrupt processing. Part
> of the cleanup operation requires a reference to KVM, so a check is also
> being added to ensure the reference to KVM exists. The reason is because
> the release callback - invoked when userspace closes the mdev fd - removes
> the reference to KVM. When the remove callback - called when the mdev is
> removed from sysfs - is subsequently invoked, there will be no reference to
> KVM when the cleanup is performed.

Please see below in the code.

> 
> This patch will also do a bit of refactoring due to the fact that the
> remove callback, implemented in vfio_ap_drv.c, disables the queue after
> resetting it. Instead of the remove callback making a call into the
> vfio_ap_ops.c to clean up the resources used for interrupt processing,
> let's move the probe and remove callbacks into the vfio_ap_ops.c
> file keep all code related to managing queues in a single file.
>

It would have been helpful to split out the refactoring as a separate
patch. This way it is harder to review the code that got moved, because
it is intermingled with the changes that intend to change behavior.
 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     | 45 +------------------
>  drivers/s390/crypto/vfio_ap_ops.c     | 63 +++++++++++++++++++--------
>  drivers/s390/crypto/vfio_ap_private.h |  7 +--
>  3 files changed, 52 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index be2520cc010b..73bd073fd5d3 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -43,47 +43,6 @@ static struct ap_device_id ap_queue_ids[] = {
>  
>  MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>  
> -/**
> - * vfio_ap_queue_dev_probe:
> - *
> - * Allocate a vfio_ap_queue structure and associate it
> - * with the device as driver_data.
> - */
> -static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
> -{
> -	struct vfio_ap_queue *q;
> -
> -	q = kzalloc(sizeof(*q), GFP_KERNEL);
> -	if (!q)
> -		return -ENOMEM;
> -	dev_set_drvdata(&apdev->device, q);
> -	q->apqn = to_ap_queue(&apdev->device)->qid;
> -	q->saved_isc = VFIO_AP_ISC_INVALID;
> -	return 0;
> -}
> -
> -/**
> - * vfio_ap_queue_dev_remove:
> - *
> - * Takes the matrix lock to avoid actions on this device while removing
> - * Free the associated vfio_ap_queue structure
> - */
> -static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
> -{
> -	struct vfio_ap_queue *q;
> -	int apid, apqi;
> -
> -	mutex_lock(&matrix_dev->lock);
> -	q = dev_get_drvdata(&apdev->device);
> -	dev_set_drvdata(&apdev->device, NULL);
> -	apid = AP_QID_CARD(q->apqn);
> -	apqi = AP_QID_QUEUE(q->apqn);
> -	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> -	vfio_ap_irq_disable(q);
> -	kfree(q);
> -	mutex_unlock(&matrix_dev->lock);
> -}
> -
>  static void vfio_ap_matrix_dev_release(struct device *dev)
>  {
>  	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
> @@ -186,8 +145,8 @@ static int __init vfio_ap_init(void)
>  		return ret;
>  
>  	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
> -	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
> -	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
> +	vfio_ap_drv.probe = vfio_ap_mdev_probe_queue;
> +	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
>  	vfio_ap_drv.ids = ap_queue_ids;
>  
>  	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..c471832f0a30 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -119,7 +119,8 @@ static void vfio_ap_wait_for_irqclear(int apqn)
>   */
>  static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>  {
> -	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
> +	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev &&
> +	    q->matrix_mdev->kvm)

Here is the check that the kvm reference exists, you mentioned in the
cover letter. You make only the gisc_unregister depend on it, because
that's what is going to explode.

But I'm actually wondering if "KVM is gone but we still haven't cleaned
up our aqic resources" is valid. I argue that it is not. The two
resources we manage are the gisc registration and the pinned page. I
argue that it makes on sense to keep what was the guests page pinned,
if here is no guest associated (we don't have KVM).

I assume the cleanup is supposed to be atomic from the perspective of
other threads/contexts, so I expect the cleanup either to be fully done
or not not entered the critical section.

So !kvm && (q->saved_isc != VFIO_AP_ISC_INVALID || q->saved_pfn) is a
bug. Isn't it?

In that sense this change would only hide the actual problem.

Is the scenario we are talking about something that can happen, or is
this just about programming defensively?

In any case, I don't think this is a good idea. We can be defensive
about it, but we have to do it differently.


>  		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
>  	if (q->saved_pfn && q->matrix_mdev)
>  		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> @@ -144,7 +145,7 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>   * Returns if ap_aqic function failed with invalid, deconfigured or
>   * checkstopped AP.
>   */
> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
> +static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>  {
>  	struct ap_qirq_ctrl aqic_gisa = {};
>  	struct ap_queue_status status;
> @@ -297,6 +298,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	if (!q)
>  		goto out_unlock;
>  
> +	q->matrix_mdev = matrix_mdev;

What is the purpose of this? Doesn't the preceding vfio_ap_get_queue()
already set q->matrix_mdev?

>  	status = vcpu->run->s.regs.gprs[1];
>  
>  	/* If IR bit(16) is set we enable the interrupt */
> @@ -1114,20 +1116,6 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> -static void vfio_ap_irq_disable_apqn(int apqn)
> -{
> -	struct device *dev;
> -	struct vfio_ap_queue *q;
> -
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (dev) {
> -		q = dev_get_drvdata(dev);
> -		vfio_ap_irq_disable(q);
> -		put_device(dev);
> -	}
> -}
> -
>  int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>  			     unsigned int retry)
>  {
> @@ -1162,6 +1150,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  {
>  	int ret;
>  	int rc = 0;
> +	struct vfio_ap_queue *q;
>  	unsigned long apid, apqi;
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> @@ -1177,7 +1166,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  			 */
>  			if (ret)
>  				rc = ret;
> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
> +			q = vfio_ap_get_queue(matrix_mdev,
> +					      AP_MKQID(apid, apqi));
> +			if (q)
> +				vfio_ap_free_aqic_resources(q);

Is it safe to do vfio_ap_free_aqic_resources() at this point? I don't
think so. I mean does the current code (and vfio_ap_mdev_reset_queue()
in particular guarantee that the reset is actually done when we arrive
here)? BTW, I think we have a similar problem with the current code as
well.

Under what circumstances do we expect !q? If we don't, then we need to
complain one way or another.

I believe that each time we call vfio_ap_mdev_reset_queue(), we will
also want to call vfio_ap_free_aqic_resources(q) to clean up our aqic
resources associated with the queue -- if any. So I would really prefer
having a function that does both.

>  		}
>  	}
>  
> @@ -1302,3 +1294,40 @@ void vfio_ap_mdev_unregister(void)
>  {
>  	mdev_unregister_device(&matrix_dev->device);
>  }
> +
> +int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
> +{
> +	struct vfio_ap_queue *q;
> +	struct ap_queue *queue;
> +
> +	queue = to_ap_queue(&apdev->device);
> +
> +	q = kzalloc(sizeof(*q), GFP_KERNEL);
> +	if (!q)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(&queue->ap_dev.device, q);
> +	q->apqn = queue->qid;
> +	q->saved_isc = VFIO_AP_ISC_INVALID;
> +
> +	return 0;
> +}
> +
> +void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
> +{
> +	struct vfio_ap_queue *q;
> +	struct ap_queue *queue;
> +	int apid, apqi;
> +
> +	queue = to_ap_queue(&apdev->device);

What is the benefit of rewriting this? You introduced
queue just to do queue->ap_dev to get to the apdev you
have in hand in the first place.

> +
> +	mutex_lock(&matrix_dev->lock);
> +	q = dev_get_drvdata(&queue->ap_dev.device);
> +	dev_set_drvdata(&queue->ap_dev.device, NULL);
> +	apid = AP_QID_CARD(q->apqn);
> +	apqi = AP_QID_QUEUE(q->apqn);
> +	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> +	vfio_ap_free_aqic_resources(q);
> +	kfree(q);
> +	mutex_unlock(&matrix_dev->lock);
> +}
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index f46dde56b464..d9003de4fbad 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -90,8 +90,6 @@ struct ap_matrix_mdev {
>  
>  extern int vfio_ap_mdev_register(void);
>  extern void vfio_ap_mdev_unregister(void);
> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> -			     unsigned int retry);
>  
>  struct vfio_ap_queue {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -100,5 +98,8 @@ struct vfio_ap_queue {
>  #define VFIO_AP_ISC_INVALID 0xff
>  	unsigned char saved_isc;
>  };
> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
> +
> +int vfio_ap_mdev_probe_queue(struct ap_device *queue);
> +void vfio_ap_mdev_remove_queue(struct ap_device *queue);
> +
>  #endif /* _VFIO_AP_PRIVATE_H_ */

