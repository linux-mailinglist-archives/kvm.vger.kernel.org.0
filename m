Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3F92A5A48
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 23:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgKCWtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 17:49:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60014 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729575AbgKCWte (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 17:49:34 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3MYLdd145259;
        Tue, 3 Nov 2020 17:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XIP1bTq5gfgrog1uyEnHHiP+0Qi8t7oENI2pqfdvzZQ=;
 b=Ik0YmSZiGBU7zPT79oH7/oR7JUyUccty4VVIj8uTW84feLHo+9S/rUAIC+F/QwlKAEk5
 vonpm9L6vP8dsN17kJwDZHsHtAYwIP5czcxG/RgOI0E1Up7TLRf7g6u1E0Q9q2y74nH1
 y5+zVZq5m2JON2GU0AnKFJ7gplONbFutyBNTBQsECwaOfL4Dqa2Qg5vdB+n83q2SUFn7
 Mg/nIkwhmuNgRrYEaFg4rDfvN92a+Gqu+Uc3lCjpYIYUm+hAVV4jglqKJ2aYE0XYs56m
 oo4wncX5+7SVs/2LnTS3ZOde+pDaqAIBWaartT9XimuAds5ytj/qTaTJ81vl/y8ExznS cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ke1uby7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 17:49:28 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A3MYSPW145366;
        Tue, 3 Nov 2020 17:49:27 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ke1uby7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 17:49:27 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3MWD0A016470;
        Tue, 3 Nov 2020 22:49:27 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 34h0ew1bw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 22:49:27 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3MnO5Z8061502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 22:49:24 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FDA0C606D;
        Tue,  3 Nov 2020 22:49:24 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BBC0C6065;
        Tue,  3 Nov 2020 22:49:22 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 22:49:21 +0000 (GMT)
Subject: Re: [PATCH v11 08/14] s390/vfio-ap: hot plug/unplug queues on
 bind/unbind of queue device
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-9-akrowiak@linux.ibm.com>
 <20201028145725.1a81c5cf.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <055284df-87d8-507a-d7d7-05a73459322d@linux.ibm.com>
Date:   Tue, 3 Nov 2020 17:49:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201028145725.1a81c5cf.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_14:2020-11-03,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=3 adultscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/28/20 9:57 AM, Halil Pasic wrote:
> On Thu, 22 Oct 2020 13:12:03 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> In response to the probe or remove of a queue device, if a KVM guest is
>> using the matrix mdev to which the APQN of the queue device is assigned,
>> the vfio_ap device driver must respond accordingly. In an ideal world, the
>> queue device being probed would be hot plugged into the guest. Likewise,
>> the queue corresponding to the queue device being removed would
>> be hot unplugged from the guest. Unfortunately, the AP architecture
>> precludes plugging or unplugging individual queues. We must also
>> consider the fact that the linux device model precludes us from passing a
>> queue device through to a KVM guest that is not bound to the driver
>> facilitating the pass-through. Consequently, we are left with the choice of
>> plugging/unplugging the adapter or the domain. In the latter case, this
>> would result in taking access to the domain away for each adapter the
>> guest is using. In either case, the operation will alter a KVM guest's
>> access to one or more queues, so let's plug/unplug the adapter on
>> bind/unbind of the queue device since this corresponds to the hardware
>> entity that may be physically plugged/unplugged - i.e., a domain is not
>> a piece of hardware.
>>
>> Example:
>> =======
>> Queue devices bound to vfio_ap device driver:
>>     04.0004
>>     04.0047
>>     04.0054
>>
>>     05.0005
>>     05.0047
>>
>> Adapters and domains assigned to matrix mdev:
>>     Adapters  Domains  -> Queues
>>     04        0004        04.0004
>>     05        0047        04.0047
>>               0054        04.0054
>>                           05.0004
>>                           05.0047
>>                           05.0054
>>
>> KVM guest matrix at is startup:
>>     Adapters  Domains  -> Queues
>>     04        0004        04.0004
>>               0047        04.0047
>>               0054        04.0054
>>
>>     Adapter 05 is filtered because queue 05.0054 is not bound.
>>
>> KVM guest matrix after queue 05.0054 is bound to the vfio_ap driver:
>>     Adapters  Domains  -> Queues
>>     04        0004        04.0004
>>     05        0047        04.0047
>>               0054        04.0054
>>                           05.0004
>>                           05.0047
>>                           05.0054
>>
>>     All queues assigned to the matrix mdev are now bound.
>>
>> KVM guest matrix after queue 04.0004 is unbound:
>>
>>     Adapters  Domains  -> Queues
>>     05        0004        05.0004
>>               0047        05.0047
>>               0054        05.0054
>>
>>     Adapter 04 is filtered because 04.0004 is no longer bound.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 158 +++++++++++++++++++++++++++++-
>>   1 file changed, 155 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 7bad70d7bcef..5b34bc8fca31 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -312,6 +312,13 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>   	return 0;
>>   }
>>   
>> +static void vfio_ap_matrix_clear_masks(struct ap_matrix *matrix)
>> +{
>> +	bitmap_clear(matrix->apm, 0, AP_DEVICES);
>> +	bitmap_clear(matrix->aqm, 0, AP_DOMAINS);
>> +	bitmap_clear(matrix->adm, 0, AP_DOMAINS);
>> +}
>> +
>>   static void vfio_ap_matrix_init(struct ap_config_info *info,
>>   				struct ap_matrix *matrix)
>>   {
>> @@ -601,6 +608,104 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
>>   	return 0;
>>   }
>>   
>> +static bool vfio_ap_mdev_matrixes_equal(struct ap_matrix *matrix1,
>> +					struct ap_matrix *matrix2)
>> +{
>> +	return (bitmap_equal(matrix1->apm, matrix2->apm, AP_DEVICES) &&
>> +		bitmap_equal(matrix1->aqm, matrix2->aqm, AP_DOMAINS) &&
>> +		bitmap_equal(matrix1->adm, matrix2->adm, AP_DOMAINS));
>> +}
>> +
>> +/**
>> + * vfio_ap_mdev_filter_matrix
>> + *
>> + * Filters the matrix of adapters, domains, and control domains assigned to
>> + * a matrix mdev's AP configuration and stores the result in the shadow copy of
>> + * the APCB used to supply a KVM guest's AP configuration.
>> + *
>> + * @matrix_mdev:  the matrix mdev whose AP configuration is to be filtered
>> + *
>> + * Returns true if filtering has changed the shadow copy of the APCB used
>> + * to supply a KVM guest's AP configuration; otherwise, returns false.
>> + */
>> +static int vfio_ap_mdev_filter_guest_matrix(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	struct ap_matrix shadow_apcb;
>> +	unsigned long apid, apqi, apqn;
>> +
>> +	memcpy(&shadow_apcb, &matrix_mdev->matrix, sizeof(struct ap_matrix));
>> +
>> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
>> +		/*
>> +		 * If the APID is not assigned to the host AP configuration,
>> +		 * we can not assign it to the guest's AP configuration
>> +		 */
>> +		if (!test_bit_inv(apid,
>> +				  (unsigned long *)matrix_dev->info.apm)) {
>> +			clear_bit_inv(apid, shadow_apcb.apm);
>> +			continue;
>> +		}
>> +
>> +		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>> +				     AP_DOMAINS) {
>> +			/*
>> +			 * If the APQI is not assigned to the host AP
>> +			 * configuration, then it can not be assigned to the
>> +			 * guest's AP configuration
>> +			 */
>> +			if (!test_bit_inv(apqi, (unsigned long *)
>> +					  matrix_dev->info.aqm)) {
>> +				clear_bit_inv(apqi, shadow_apcb.aqm);
>> +				continue;
>> +			}
>> +
>> +			/*
>> +			 * If the APQN is not bound to the vfio_ap device
>> +			 * driver, then we can't assign it to the guest's
>> +			 * AP configuration. The AP architecture won't
>> +			 * allow filtering of a single APQN, so let's filter
>> +			 * the APID.
>> +			 */
>> +			apqn = AP_MKQID(apid, apqi);
>> +			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
>> +				clear_bit_inv(apid, shadow_apcb.apm);
>> +				break;
>> +			}
>> +		}
>> +
>> +		/*
>> +		 * If all APIDs have been cleared, then clear the APQIs from the
>> +		 * shadow APCB and quit filtering.
>> +		 */
>> +		if (bitmap_empty(shadow_apcb.apm, AP_DEVICES)) {
>> +			if (!bitmap_empty(shadow_apcb.aqm, AP_DOMAINS))
>> +				bitmap_clear(shadow_apcb.aqm, 0, AP_DOMAINS);
>> +
>> +			break;
>> +		}
>> +
>> +		/*
>> +		 * If all APQIs have been cleared, then clear the APIDs from the
>> +		 * shadow APCB and quit filtering.
>> +		 */
>> +		if (bitmap_empty(shadow_apcb.aqm, AP_DOMAINS)) {
>> +			if (!bitmap_empty(shadow_apcb.apm, AP_DEVICES))
>> +				bitmap_clear(shadow_apcb.apm, 0, AP_DEVICES);
>> +
>> +			break;
>> +		}
> We do this to show the no queues but bits set output in show? We could
> get rid of some code if we were to not z

I'm not sure what you are saying/asking here. The reason for this
is because there is no point in setting bits in the APCB if no queues
will be made available to the guest which is the case if the APM or
AQM are cleared.

>
>> +	}
>> +
>> +	if (vfio_ap_mdev_matrixes_equal(&matrix_mdev->shadow_apcb,
>> +					&shadow_apcb))
>> +		return false;
>> +
>> +	memcpy(&matrix_mdev->shadow_apcb, &shadow_apcb,
>> +	       sizeof(struct ap_matrix));
>> +
>> +	return true;
>> +}
>> +
>>   enum qlink_type {
>>   	LINK_APID,
>>   	LINK_APQI,
>> @@ -1256,9 +1361,8 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>>   		return NOTIFY_DONE;
>>   
>> -	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
>> -	       sizeof(matrix_mdev->shadow_apcb));
>> -	vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>> +	if (vfio_ap_mdev_filter_guest_matrix(matrix_mdev))
>> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>   
>>   	return NOTIFY_OK;
>>   }
>> @@ -1369,6 +1473,18 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>>   		matrix_mdev->kvm = NULL;
>>   	}
>>   
>> +	/*
>> +	 * The shadow_apcb must be cleared.
>> +	 *
>> +	 * The shadow_apcb is committed to the guest only if the masks resulting
>> +	 * from filtering the matrix_mdev->matrix differs from the masks in the
>> +	 * shadow_apcb. Consequently, if we don't clear the masks here and a
>> +	 * guest is subsequently started, the filtering may not result in a
>> +	 * change to the shadow_apcb which will not get committed to the guest;
>> +	 * in that case, the guest will be left without any queues.
>> +	 */
>> +	vfio_ap_matrix_clear_masks(&matrix_mdev->shadow_apcb);
>> +
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>> @@ -1466,6 +1582,16 @@ static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
>>   	}
>>   }
>>   
>> +static void vfio_ap_mdev_hot_plug_queue(struct vfio_ap_queue *q)
>> +{
>> +
>> +	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
>> +		return;
>> +
>> +	if (vfio_ap_mdev_filter_guest_matrix(q->matrix_mdev))
>> +		vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
> Here we do more work than necessary. At this point we now, that
> we either put the APID of the queue in the shadow_apcb or do nothing. To
> decide if we have to put the APID in the shadow apcb we need to
> check for the cartesian product of shadow_apcb.aqm with the APID, if the
> queues identified by those APQNs are bound to the vfio_ap driver. The
> vfio_ap_mdev_filter_guest_matrix() is going to do a lookup for each
> assigned APQN.

That is true and I believe in the previous iteration that is what was
done. In the interest of keeping things simple and consistent across
the various interfaces that require filtering, I decided to use one
function instead of duplicating function in multiple places. Let me think
on this and maybe I can come up with a way to kill many birds with one
stone so. The question is, how often is type of thing going to happen 
(i.e.,
is performance really an issue here?).

>
>> +}
>> +
>>   int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>>   {
>>   	struct vfio_ap_queue *q;
>> @@ -1482,11 +1608,36 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>>   	q->apqn = queue->qid;
>>   	q->saved_isc = VFIO_AP_ISC_INVALID;
>>   	vfio_ap_queue_link_mdev(q);
>> +	vfio_ap_mdev_hot_plug_queue(q);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return 0;
>>   }
>>   
>> +void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
>> +{
>> +	unsigned long apid = AP_QID_CARD(q->apqn);
>> +
>> +	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
>> +		return;
>> +
>> +	/*
>> +	 * If the APID is assigned to the guest, then let's
>> +	 * go ahead and unplug the adapter since the
>> +	 * architecture does not provide a means to unplug
>> +	 * an individual queue.
>> +	 */
>> +	if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm)) {
>> +		clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
> Shouldn't we check aqm as well? I mean it may be clear at this point
> bacause of info->aqm. If the bit is clear, we don't have to remove
> the apm bit.

The rule we agreed upon is that if a queue is removed, we unplug
the card because we can't unplug an individual queue, so this code
is consistent with the stated rule. Typically, a queue is unplugged
because the adapter has been deconfigured or is broken which means
that all queues for that adapter will be removed in succession. On the
other hand, that situation would be handled when the last queue is
removed if we check the AQM, so I'm not adverse to making that
check if you insist. Of course, if the queue is manually unbound from
the vfio driver, what you are asking for makes sense I suppose. I'll have
to think about this one some more, but feel free to respond to this.

>
>> +
>> +		if (bitmap_empty(q->matrix_mdev->shadow_apcb.apm, AP_DEVICES))
>> +			bitmap_clear(q->matrix_mdev->shadow_apcb.aqm, 0,
>> +				     AP_DOMAINS);
>> +
>> +		vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
>> +	}
>> +}
>> +
>>   void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>>   {
>>   	struct vfio_ap_queue *q;
>> @@ -1497,6 +1648,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>>   
>>   	mutex_lock(&matrix_dev->lock);
>>   	q = dev_get_drvdata(&queue->ap_dev.device);
>> +	vfio_ap_mdev_hot_unplug_queue(q);
> Puh this is ugly. In an ideal world the guest would be guaranteed to not
> get any writes to the notifier byte after it has seen that the queue is
> gone (or the interrupts were disabled).
>
> The reset below might too late as the vcpus may go back immediately.
>
> I don't have a good solution for this with the tools currently at
> our disposal. We could simulate an external reset for the queue before
> the update do the APCB, or just disable the interrupts. These are ugly
> in their own way.
>
> Switching to emulation mode might be something for the future, but right
> now it is also ugly.
>
> Any thoughts? Am I just dreaming up a problem here?

I realize that we shouldn't make any assumptions about the OS
running on the guest, but in the world as it exists today the only
OS supported as a guest of linux is linux. Consequently, when
the adapter is unplugged from the guest, the zcrypt driver will
reset the queues associated with it thus disabling interrupts.
Unfortuately we can't control the flow between the host and the
guest, so there is a possibility the vfio driver could be first to
reset the queue in question. I'm not sure this is a problem
because either the vfio driver or the zcrypt driver on the guest
will get a response code indicating a reset is in progress at which
time it will wait for completion before trying again.

The bottom line is, in my opinion you are dreaming up a problem
here. Ultimately, when an adapter is removed from the guest,
the guest will no longer access any queue on that adapter and
the adapter will be reset before giving it back to the host.

>
> Regards,
> Halil
>
>
>>   	dev_set_drvdata(&queue->ap_dev.device, NULL);
>>   	apid = AP_QID_CARD(q->apqn);
>>   	apqi = AP_QID_QUEUE(q->apqn);

