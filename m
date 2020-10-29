Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10D029F91A
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 00:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgJ2X3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 19:29:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgJ2X3q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 19:29:46 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09TN2Vhk006353;
        Thu, 29 Oct 2020 19:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wd9yrL9fXSVqxlXI2NfKvi9+qSKMBRx8K1nH+W29hfk=;
 b=YIQeeumpJdb2Mhpd7FypxHsMGjCpn0h6KWcYeAaERJCVT8EsDTPof2hzjlUfWKBS1SqY
 sTnr8V6bdvB/vKIn2kaTyW4c94Nzgm6XK4ojt0N15PlHTCxn9xAgV8yuamWs0AzKm/tt
 PkIgeJ1BPWMB64MpGvCzscqke6daUhA2zRdyc988NyK1riqXn+4eMDPYdqwxqbhmsGkG
 n45NHKYe+nFkKP0E8L9UZGH+28jG/7rJLstj3pbw5TAeNbgXISrAP7hkLJjsuI1bYA3O
 wtQbY7ky8v56YO8scczvQojKWsYfLPfOuXUcX0xNWo4nyDlzmLZnA3f2SQCxf8oBHrZQ UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34fnh0br8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 19:29:42 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09TN2dFJ007184;
        Thu, 29 Oct 2020 19:29:41 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34fnh0br80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 19:29:41 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09TNSApC010613;
        Thu, 29 Oct 2020 23:29:40 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 34fy75kkkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 23:29:40 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09TNTWG416450230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 23:29:32 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 608416A04D;
        Thu, 29 Oct 2020 23:29:37 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C13416A047;
        Thu, 29 Oct 2020 23:29:35 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 29 Oct 2020 23:29:35 +0000 (GMT)
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-2-akrowiak@linux.ibm.com>
 <20201027074846.30ee0ddc.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
Date:   Thu, 29 Oct 2020 19:29:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201027074846.30ee0ddc.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_12:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 impostorscore=0
 suspectscore=13 priorityscore=1501 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290155
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/20 2:48 AM, Halil Pasic wrote:
> On Thu, 22 Oct 2020 13:11:56 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The queues assigned to a matrix mediated device are currently reset when:
>>
>> * The VFIO_DEVICE_RESET ioctl is invoked
>> * The mdev fd is closed by userspace (QEMU)
>> * The mdev is removed from sysfs.
> What about the situation when vfio_ap_mdev_group_notifier() is called to
> tell us that our pointer to KVM is about to become invalid? Do we need to
> clean up the IRQ stuff there?

After reading this question, I decided to do some tracing using
printk's and learned that the vfio_ap_mdev_group_notifier()
function does not get called when the guest is shutdown. The reason
for this is because the vfio_ap_mdev_release() function, which is called
before the KVM pointer is invalidated, unregisters the group notifier.

I took a look at some of the other drivers that register a group
notifier in the mdev_parent_ops.open callback and each unregistered
the notifier in the mdev_parent_ops.release callback.

So, to answer your question, there is no need to cleanup the IRQ
stuff in the vfio_ap_mdev_group_notifier() function since it will
not get called when the KVM pointer is invalidated. The cleanup
should be done in the vfio_ap_mdev_release() function that gets
called when the mdev fd is closed.

>
>> Immediately after the reset of a queue, a call is made to disable
>> interrupts for the queue. This is entirely unnecessary because the reset of
>> a queue disables interrupts, so this will be removed.
> Makes sense.
>
>> Since interrupt processing may have been enabled by the guest, it may also
>> be necessary to clean up the resources used for interrupt processing. Part
>> of the cleanup operation requires a reference to KVM, so a check is also
>> being added to ensure the reference to KVM exists. The reason is because
>> the release callback - invoked when userspace closes the mdev fd - removes
>> the reference to KVM. When the remove callback - called when the mdev is
>> removed from sysfs - is subsequently invoked, there will be no reference to
>> KVM when the cleanup is performed.
> Please see below in the code.
>
>> This patch will also do a bit of refactoring due to the fact that the
>> remove callback, implemented in vfio_ap_drv.c, disables the queue after
>> resetting it. Instead of the remove callback making a call into the
>> vfio_ap_ops.c to clean up the resources used for interrupt processing,
>> let's move the probe and remove callbacks into the vfio_ap_ops.c
>> file keep all code related to managing queues in a single file.
>>
> It would have been helpful to split out the refactoring as a separate
> patch. This way it is harder to review the code that got moved, because
> it is intermingled with the changes that intend to change behavior.

I suppose I can do that.

>   
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     | 45 +------------------
>>   drivers/s390/crypto/vfio_ap_ops.c     | 63 +++++++++++++++++++--------
>>   drivers/s390/crypto/vfio_ap_private.h |  7 +--
>>   3 files changed, 52 insertions(+), 63 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>> index be2520cc010b..73bd073fd5d3 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -43,47 +43,6 @@ static struct ap_device_id ap_queue_ids[] = {
>>   
>>   MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>>   
>> -/**
>> - * vfio_ap_queue_dev_probe:
>> - *
>> - * Allocate a vfio_ap_queue structure and associate it
>> - * with the device as driver_data.
>> - */
>> -static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>> -{
>> -	struct vfio_ap_queue *q;
>> -
>> -	q = kzalloc(sizeof(*q), GFP_KERNEL);
>> -	if (!q)
>> -		return -ENOMEM;
>> -	dev_set_drvdata(&apdev->device, q);
>> -	q->apqn = to_ap_queue(&apdev->device)->qid;
>> -	q->saved_isc = VFIO_AP_ISC_INVALID;
>> -	return 0;
>> -}
>> -
>> -/**
>> - * vfio_ap_queue_dev_remove:
>> - *
>> - * Takes the matrix lock to avoid actions on this device while removing
>> - * Free the associated vfio_ap_queue structure
>> - */
>> -static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>> -{
>> -	struct vfio_ap_queue *q;
>> -	int apid, apqi;
>> -
>> -	mutex_lock(&matrix_dev->lock);
>> -	q = dev_get_drvdata(&apdev->device);
>> -	dev_set_drvdata(&apdev->device, NULL);
>> -	apid = AP_QID_CARD(q->apqn);
>> -	apqi = AP_QID_QUEUE(q->apqn);
>> -	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>> -	vfio_ap_irq_disable(q);
>> -	kfree(q);
>> -	mutex_unlock(&matrix_dev->lock);
>> -}
>> -
>>   static void vfio_ap_matrix_dev_release(struct device *dev)
>>   {
>>   	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
>> @@ -186,8 +145,8 @@ static int __init vfio_ap_init(void)
>>   		return ret;
>>   
>>   	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
>> -	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
>> -	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
>> +	vfio_ap_drv.probe = vfio_ap_mdev_probe_queue;
>> +	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
>>   	vfio_ap_drv.ids = ap_queue_ids;
>>   
>>   	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index e0bde8518745..c471832f0a30 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -119,7 +119,8 @@ static void vfio_ap_wait_for_irqclear(int apqn)
>>    */
>>   static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>>   {
>> -	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
>> +	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev &&
>> +	    q->matrix_mdev->kvm)
> Here is the check that the kvm reference exists, you mentioned in the
> cover letter. You make only the gisc_unregister depend on it, because
> that's what is going to explode.
>
> But I'm actually wondering if "KVM is gone but we still haven't cleaned
> up our aqic resources" is valid. I argue that it is not. The two
> resources we manage are the gisc registration and the pinned page. I
> argue that it makes on sense to keep what was the guests page pinned,
> if here is no guest associated (we don't have KVM).
>
> I assume the cleanup is supposed to be atomic from the perspective of
> other threads/contexts, so I expect the cleanup either to be fully done
> or not not entered the critical section.
>
> So !kvm && (q->saved_isc != VFIO_AP_ISC_INVALID || q->saved_pfn) is a
> bug. Isn't it?
>
> In that sense this change would only hide the actual problem.
>
> Is the scenario we are talking about something that can happen, or is
> this just about programming defensively?
>
> In any case, I don't think this is a good idea. We can be defensive
> about it, but we have to do it differently.
>
>
>>   		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
>>   	if (q->saved_pfn && q->matrix_mdev)
>>   		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
>> @@ -144,7 +145,7 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>>    * Returns if ap_aqic function failed with invalid, deconfigured or
>>    * checkstopped AP.
>>    */
>> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>> +static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>>   {
>>   	struct ap_qirq_ctrl aqic_gisa = {};
>>   	struct ap_queue_status status;
>> @@ -297,6 +298,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>   	if (!q)
>>   		goto out_unlock;
>>   
>> +	q->matrix_mdev = matrix_mdev;
> What is the purpose of this? Doesn't the preceding vfio_ap_get_queue()
> already set q->matrix_mdev?

You are correct, it shall be removed.

>
>>   	status = vcpu->run->s.regs.gprs[1];
>>   
>>   	/* If IR bit(16) is set we enable the interrupt */
>> @@ -1114,20 +1116,6 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	return NOTIFY_OK;
>>   }
>>   
>> -static void vfio_ap_irq_disable_apqn(int apqn)
>> -{
>> -	struct device *dev;
>> -	struct vfio_ap_queue *q;
>> -
>> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>> -				 &apqn, match_apqn);
>> -	if (dev) {
>> -		q = dev_get_drvdata(dev);
>> -		vfio_ap_irq_disable(q);
>> -		put_device(dev);
>> -	}
>> -}
>> -
>>   int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>>   			     unsigned int retry)
>>   {
>> @@ -1162,6 +1150,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>   {
>>   	int ret;
>>   	int rc = 0;
>> +	struct vfio_ap_queue *q;
>>   	unsigned long apid, apqi;
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>> @@ -1177,7 +1166,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>   			 */
>>   			if (ret)
>>   				rc = ret;
>> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>> +			q = vfio_ap_get_queue(matrix_mdev,
>> +					      AP_MKQID(apid, apqi));
>> +			if (q)
>> +				vfio_ap_free_aqic_resources(q);
> Is it safe to do vfio_ap_free_aqic_resources() at this point? I don't
> think so. I mean does the current code (and vfio_ap_mdev_reset_queue()
> in particular guarantee that the reset is actually done when we arrive
> here)? BTW, I think we have a similar problem with the current code as
> well.

If the return code from the vfio_ap_mdev_reset_queue() function
is zero, then yes, we are guaranteed the reset was done and the
queue is empty.  The function returns a non-zero return code if
the reset fails or the queue the reset did not complete within a given
amount of time, so maybe we shouldn't free AQIC resources when
we get a non-zero return code from the reset function?

There are three occasions when the vfio_ap_mdev_reset_queues()
is called:
1. When the VFIO_DEVICE_RESET ioctl is invoked from userspace
     (i.e., when the guest is started)
2. When the mdev fd is closed (vfio_ap_mdev_release())
3. When the mdev is removed (vfio_ap_mdev_remove())

The IRQ resources are initialized when the PQAP(AQIC)
is intercepted to enable interrupts. This would occur after
the guest boots and the AP bus initializes. So, 1 would
presumably occur before that happens. I couldn't find
anywhere in the AP bus or zcrypt code where a PQAP(AQIC)
is executed to disable interrupts, so my assumption is
that IRQ disablement is accomplished by a reset on
the guest. I'll have to ask Harald about that. So, 2 would
occur when the guest is about to terminate and 3
would occur only after the guest is terminated. In any
case, it seems that IRQ resources should be cleaned up.
Maybe it would be more appropriate to do that in the
vfio_ap_mdev_release() and vfio_ap_mdev_remove()
functions themselves?

>
> Under what circumstances do we expect !q? If we don't, then we need to
> complain one way or another.

In the current code (i.e., prior to introducing the subsequent hot
plug patches), an APQN can not be assigned to an mdev unless it
references a queue device bound to the vfio_ap device driver; however,
there is nothing preventing a queue device from getting unbound
while the guest is running (one of the problems mostly resolved by this
series). In that case, q would be NULL.

>
> I believe that each time we call vfio_ap_mdev_reset_queue(), we will
> also want to call vfio_ap_free_aqic_resources(q) to clean up our aqic
> resources associated with the queue -- if any. So I would really prefer
> having a function that does both.

As stated above, I don't believe PQAP(AQIC) is ever called by
the AP bus or zcrypt to disable IRQs, but I could be wrong about
that so I'll verify with Harald. If that is the case, then it would
make sense to free IRQ resources when a queue completes.
I can either add a function that does both and call it instead of
vfio_ap_mdev_reset_queue(). What say you?

>
>>   		}
>>   	}
>>   
>> @@ -1302,3 +1294,40 @@ void vfio_ap_mdev_unregister(void)
>>   {
>>   	mdev_unregister_device(&matrix_dev->device);
>>   }
>> +
>> +int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>> +{
>> +	struct vfio_ap_queue *q;
>> +	struct ap_queue *queue;
>> +
>> +	queue = to_ap_queue(&apdev->device);
>> +
>> +	q = kzalloc(sizeof(*q), GFP_KERNEL);
>> +	if (!q)
>> +		return -ENOMEM;
>> +
>> +	dev_set_drvdata(&queue->ap_dev.device, q);
>> +	q->apqn = queue->qid;
>> +	q->saved_isc = VFIO_AP_ISC_INVALID;
>> +
>> +	return 0;
>> +}
>> +
>> +void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>> +{
>> +	struct vfio_ap_queue *q;
>> +	struct ap_queue *queue;
>> +	int apid, apqi;
>> +
>> +	queue = to_ap_queue(&apdev->device);
> What is the benefit of rewriting this? You introduced
> queue just to do queue->ap_dev to get to the apdev you
> have in hand in the first place.

I'm not quite sure what you're asking. This function is
the callback function specified via the function pointer
specified via the remove field of the struct ap_driver
when the vfio_ap device driver is registered with the
AP bus. That callback function takes a struct ap_device
as a parameter. What am I missing here?

>
>> +
>> +	mutex_lock(&matrix_dev->lock);
>> +	q = dev_get_drvdata(&queue->ap_dev.device);
>> +	dev_set_drvdata(&queue->ap_dev.device, NULL);
>> +	apid = AP_QID_CARD(q->apqn);
>> +	apqi = AP_QID_QUEUE(q->apqn);
>> +	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>> +	vfio_ap_free_aqic_resources(q);
>> +	kfree(q);
>> +	mutex_unlock(&matrix_dev->lock);
>> +}
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index f46dde56b464..d9003de4fbad 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -90,8 +90,6 @@ struct ap_matrix_mdev {
>>   
>>   extern int vfio_ap_mdev_register(void);
>>   extern void vfio_ap_mdev_unregister(void);
>> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>> -			     unsigned int retry);
>>   
>>   struct vfio_ap_queue {
>>   	struct ap_matrix_mdev *matrix_mdev;
>> @@ -100,5 +98,8 @@ struct vfio_ap_queue {
>>   #define VFIO_AP_ISC_INVALID 0xff
>>   	unsigned char saved_isc;
>>   };
>> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
>> +
>> +int vfio_ap_mdev_probe_queue(struct ap_device *queue);
>> +void vfio_ap_mdev_remove_queue(struct ap_device *queue);
>> +
>>   #endif /* _VFIO_AP_PRIVATE_H_ */

