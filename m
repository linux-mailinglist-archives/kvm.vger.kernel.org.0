Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CADA49949
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 08:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfFRGtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 02:49:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbfFRGtm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jun 2019 02:49:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5I6mnL9133562
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 02:49:39 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t6s533spd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 02:49:38 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <freude@linux.ibm.com>;
        Tue, 18 Jun 2019 07:49:37 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 07:49:33 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5I6nVuQ59310190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 06:49:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D12D42041;
        Tue, 18 Jun 2019 06:49:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85D554203F;
        Tue, 18 Jun 2019 06:49:30 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jun 2019 06:49:30 +0000 (GMT)
Subject: Re: [PATCH v4 5/7] s390: vfio-ap: allow assignment of unavailable AP
 resources to mdev device
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, mjrosato@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
 <1560454780-20359-6-git-send-email-akrowiak@linux.ibm.com>
 <21cdd1ec-27aa-5f9a-8ac2-db2b2cef7d61@linux.ibm.com>
 <8c029b68-1084-8d17-6064-3209910c04b9@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Tue, 18 Jun 2019 08:49:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8c029b68-1084-8d17-6064-3209910c04b9@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19061806-0020-0000-0000-0000034B05B2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061806-0021-0000-0000-0000219E50D3
Message-Id: <80639474-8d9f-2f95-be0b-ae44cbbac3fe@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.06.19 17:07, Tony Krowiak wrote:
> On 6/17/19 6:05 AM, Harald Freudenberger wrote:
>> On 13.06.19 21:39, Tony Krowiak wrote:
>>> The AP architecture does not preclude assignment of AP resources that are
>>> not available. Let's go ahead and implement this facet of the AP
>>> architecture for linux guests.
>>>
>>> The current implementation does not allow assignment of AP adapters or
>>> domains to an mdev device if the APQNs resulting from the assignment
>>> reference AP queue devices that are not bound to the vfio_ap device
>>> driver. This patch allows assignment of AP resources to the mdev device as
>>> long as the APQNs resulting from the assignment are not reserved by the AP
>>> BUS for use by the zcrypt device drivers and the APQNs are not assigned to
>>> another mdev device.
>>>
>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> ---
>>>   drivers/s390/crypto/vfio_ap_ops.c | 231 ++++++++------------------------------
>>>   1 file changed, 44 insertions(+), 187 deletions(-)
>>>
>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>> index 60efd3d7896d..9db86c0db52e 100644
>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>> @@ -406,122 +406,6 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
>>>       NULL,
>>>   };
>>>   -struct vfio_ap_queue_reserved {
>>> -    unsigned long *apid;
>>> -    unsigned long *apqi;
>>> -    bool reserved;
>>> -};
>>> -
>>> -/**
>>> - * vfio_ap_has_queue
>>> - *
>>> - * @dev: an AP queue device
>>> - * @data: a struct vfio_ap_queue_reserved reference
>>> - *
>>> - * Flags whether the AP queue device (@dev) has a queue ID containing the APQN,
>>> - * apid or apqi specified in @data:
>>> - *
>>> - * - If @data contains both an apid and apqi value, then @data will be flagged
>>> - *   as reserved if the APID and APQI fields for the AP queue device matches
>>> - *
>>> - * - If @data contains only an apid value, @data will be flagged as
>>> - *   reserved if the APID field in the AP queue device matches
>>> - *
>>> - * - If @data contains only an apqi value, @data will be flagged as
>>> - *   reserved if the APQI field in the AP queue device matches
>>> - *
>>> - * Returns 0 to indicate the input to function succeeded. Returns -EINVAL if
>>> - * @data does not contain either an apid or apqi.
>>> - */
>>> -static int vfio_ap_has_queue(struct device *dev, void *data)
>>> -{
>>> -    struct vfio_ap_queue_reserved *qres = data;
>>> -    struct ap_queue *ap_queue = to_ap_queue(dev);
>>> -    ap_qid_t qid;
>>> -    unsigned long id;
>>> -
>>> -    if (qres->apid && qres->apqi) {
>>> -        qid = AP_MKQID(*qres->apid, *qres->apqi);
>>> -        if (qid == ap_queue->qid)
>>> -            qres->reserved = true;
>>> -    } else if (qres->apid && !qres->apqi) {
>>> -        id = AP_QID_CARD(ap_queue->qid);
>>> -        if (id == *qres->apid)
>>> -            qres->reserved = true;
>>> -    } else if (!qres->apid && qres->apqi) {
>>> -        id = AP_QID_QUEUE(ap_queue->qid);
>>> -        if (id == *qres->apqi)
>>> -            qres->reserved = true;
>>> -    } else {
>>> -        return -EINVAL;
>>> -    }
>>> -
>>> -    return 0;
>>> -}
>>> -
>>> -/**
>>> - * vfio_ap_verify_queue_reserved
>>> - *
>>> - * @matrix_dev: a mediated matrix device
>>> - * @apid: an AP adapter ID
>>> - * @apqi: an AP queue index
>>> - *
>>> - * Verifies that the AP queue with @apid/@apqi is reserved by the VFIO AP device
>>> - * driver according to the following rules:
>>> - *
>>> - * - If both @apid and @apqi are not NULL, then there must be an AP queue
>>> - *   device bound to the vfio_ap driver with the APQN identified by @apid and
>>> - *   @apqi
>>> - *
>>> - * - If only @apid is not NULL, then there must be an AP queue device bound
>>> - *   to the vfio_ap driver with an APQN containing @apid
>>> - *
>>> - * - If only @apqi is not NULL, then there must be an AP queue device bound
>>> - *   to the vfio_ap driver with an APQN containing @apqi
>>> - *
>>> - * Returns 0 if the AP queue is reserved; otherwise, returns -EADDRNOTAVAIL.
>>> - */
>>> -static int vfio_ap_verify_queue_reserved(unsigned long *apid,
>>> -                     unsigned long *apqi)
>>> -{
>>> -    int ret;
>>> -    struct vfio_ap_queue_reserved qres;
>>> -
>>> -    qres.apid = apid;
>>> -    qres.apqi = apqi;
>>> -    qres.reserved = false;
>>> -
>>> -    ret = driver_for_each_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>>> -                     &qres, vfio_ap_has_queue);
>>> -    if (ret)
>>> -        return ret;
>>> -
>>> -    if (qres.reserved)
>>> -        return 0;
>>> -
>>> -    return -EADDRNOTAVAIL;
>>> -}
>>> -
>>> -static int
>>> -vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
>>> -                         unsigned long apid)
>>> -{
>>> -    int ret;
>>> -    unsigned long apqi;
>>> -    unsigned long nbits = matrix_mdev->matrix.aqm_max + 1;
>>> -
>>> -    if (find_first_bit_inv(matrix_mdev->matrix.aqm, nbits) >= nbits)
>>> -        return vfio_ap_verify_queue_reserved(&apid, NULL);
>>> -
>>> -    for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, nbits) {
>>> -        ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
>>> -        if (ret)
>>> -            return ret;
>>> -    }
>>> -
>>> -    return 0;
>>> -}
>>> -
>>>   /**
>>>    * vfio_ap_mdev_verify_no_sharing
>>>    *
>>> @@ -529,18 +413,26 @@ vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
>>>    * and AP queue indexes comprising the AP matrix are not configured for another
>>>    * mediated device. AP queue sharing is not allowed.
>>>    *
>>> - * @matrix_mdev: the mediated matrix device
>>> + * @mdev_apm: the mask identifying the adapters assigned to mdev
>>> + * @mdev_apm: the mask identifying the adapters assigned to mdev
>> I assume you wanted to write @mdev_aqm ... queues ... at the 2nd line.
>
> You assumed correctly. I also mean to say "domains assigned to mdev".
>
>>>    *
>>>    * Returns 0 if the APQNs are not shared, otherwise; returns -EADDRINUSE.
>>>    */
>>> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>> +static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>>> +                      unsigned long *mdev_aqm)
>>>   {
>>>       struct ap_matrix_mdev *lstdev;
>>>       DECLARE_BITMAP(apm, AP_DEVICES);
>>>       DECLARE_BITMAP(aqm, AP_DOMAINS);
>>>         list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
>>> -        if (matrix_mdev == lstdev)
>>> +        /*
>>> +         * If either of the input masks belongs to the mdev to which an
>>> +         * AP resource is being assigned, then we don't need to verify
>>> +         * that mdev's masks.
>>> +         */
>>> +        if ((mdev_apm == lstdev->matrix.apm) ||
>>> +            (mdev_aqm == lstdev->matrix.aqm))
>>>               continue;
>>>             memset(apm, 0, sizeof(apm));
>>> @@ -550,12 +442,10 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>>            * We work on full longs, as we can only exclude the leftover
>>>            * bits in non-inverse order. The leftover is all zeros.
>>>            */
>>> -        if (!bitmap_and(apm, matrix_mdev->matrix.apm,
>>> -                lstdev->matrix.apm, AP_DEVICES))
>>> +        if (!bitmap_and(apm, mdev_apm, lstdev->matrix.apm, AP_DEVICES))
>>>               continue;
>>>   -        if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
>>> -                lstdev->matrix.aqm, AP_DOMAINS))
>>> +        if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
>>>               continue;
>>>             return -EADDRINUSE;
>>> @@ -564,6 +454,17 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>>       return 0;
>>>   }
>>>   +static int vfio_ap_mdev_validate_masks(unsigned long *apm, unsigned long *aqm)
>>> +{
>>> +    int ret;
>>> +
>>> +    ret = ap_apqn_in_matrix_owned_by_def_drv(apm, aqm);
>>> +    if (ret)
>>> +        return (ret == 1) ? -EADDRNOTAVAIL : ret;
>>> +
>>> +    return vfio_ap_mdev_verify_no_sharing(apm, aqm);
>>> +}
>>> +
>>>   /**
>>>    * assign_adapter_store
>>>    *
>>> @@ -602,6 +503,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>>>   {
>>>       int ret;
>>>       unsigned long apid;
>>> +    DECLARE_BITMAP(apm, AP_DEVICES);
>>>       struct mdev_device *mdev = mdev_from_dev(dev);
>>>       struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>>   @@ -616,32 +518,19 @@ static ssize_t assign_adapter_store(struct device *dev,
>>>       if (apid > matrix_mdev->matrix.apm_max)
>>>           return -ENODEV;
>>>   -    /*
>>> -     * Set the bit in the AP mask (APM) corresponding to the AP adapter
>>> -     * number (APID). The bits in the mask, from most significant to least
>>> -     * significant bit, correspond to APIDs 0-255.
>>> -     */
>>> -    mutex_lock(&matrix_dev->lock);
>>> -
>>> -    ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
>>> -    if (ret)
>>> -        goto done;
>>> +    memset(apm, 0, ARRAY_SIZE(apm) * sizeof(*apm));
>> What about just memset(apm, 0, sizeof(apm));
>
> apm is a pointer to an array of unsigned long, so sizeof(apm) will
> yield the number of bytes in the pointer (8), not the number of bytes in
> the array (32); or am I wrong about that?
The
  DECLARE_BITMAP(apm, AP_DEVICES);
with the macro definition in types.h:
  #define DECLARE_BITMAP(name,bits) \
    unsigned long name[BITS_TO_LONGS(bits)]
gives this expanded code:
  unsigned long apm[BITS_TO_LONGS(AP_DEVICES)];
which is an ordinary unsigned long array.
So sizeof(apm) gives the size of the array in bytes:
  sizeof(apm) = 32
I know this is weird, but it is common practice.

Funnily look at this code:
  int blubber[10];
  int *ptr = blubber;
sizeof(blubber) gives 10*sizeof(int) but
sizeof(ptr) gives the size of the pointer pointing to
the blubber array.

>
>>> +    set_bit_inv(apid, apm);
>>>   +    mutex_lock(&matrix_dev->lock);
>>> +    ret = vfio_ap_mdev_validate_masks(apm, matrix_mdev->matrix.aqm);
>>> +    if (ret) {
>>> +        mutex_unlock(&matrix_dev->lock);
>>> +        return ret;
>>> +    }
>>>       set_bit_inv(apid, matrix_mdev->matrix.apm);
>>> -
>>> -    ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
>>> -    if (ret)
>>> -        goto share_err;
>>> -
>>> -    ret = count;
>>> -    goto done;
>>> -
>>> -share_err:
>>> -    clear_bit_inv(apid, matrix_mdev->matrix.apm);
>>> -done:
>>>       mutex_unlock(&matrix_dev->lock);
>>>   -    return ret;
>>> +    return count;
>>>   }
>>>   static DEVICE_ATTR_WO(assign_adapter);
>>>   @@ -690,26 +579,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
>>>   }
>>>   static DEVICE_ATTR_WO(unassign_adapter);
>>>   -static int
>>> -vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
>>> -                         unsigned long apqi)
>>> -{
>>> -    int ret;
>>> -    unsigned long apid;
>>> -    unsigned long nbits = matrix_mdev->matrix.apm_max + 1;
>>> -
>>> -    if (find_first_bit_inv(matrix_mdev->matrix.apm, nbits) >= nbits)
>>> -        return vfio_ap_verify_queue_reserved(NULL, &apqi);
>>> -
>>> -    for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, nbits) {
>>> -        ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
>>> -        if (ret)
>>> -            return ret;
>>> -    }
>>> -
>>> -    return 0;
>>> -}
>>> -
>>>   /**
>>>    * assign_domain_store
>>>    *
>>> @@ -748,6 +617,7 @@ static ssize_t assign_domain_store(struct device *dev,
>>>   {
>>>       int ret;
>>>       unsigned long apqi;
>>> +    DECLARE_BITMAP(aqm, AP_DEVICES);
>> AP_DEVICES -> AP_DOMAINS
>
> Copy and paste error, it should be AP_DOMAINS.
>
>>>       struct mdev_device *mdev = mdev_from_dev(dev);
>>>       struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>>       unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
>>> @@ -762,27 +632,19 @@ static ssize_t assign_domain_store(struct device *dev,
>>>       if (apqi > max_apqi)
>>>           return -ENODEV;
>>>   -    mutex_lock(&matrix_dev->lock);
>>> -
>>> -    ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
>>> -    if (ret)
>>> -        goto done;
>>> +    memset(aqm, 0, ARRAY_SIZE(aqm) * sizeof(*aqm));
>> memset(aqm, 0, sizeof(aqm));
>
> See response above.
>
>>> +    set_bit_inv(apqi, aqm);
>>>   +    mutex_lock(&matrix_dev->lock);
>>> +    ret = vfio_ap_mdev_validate_masks(matrix_mdev->matrix.apm, aqm);
>>> +    if (ret) {
>>> +        mutex_unlock(&matrix_dev->lock);
>>> +        return ret;
>>> +    }
>>>       set_bit_inv(apqi, matrix_mdev->matrix.aqm);
>>> -
>>> -    ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
>>> -    if (ret)
>>> -        goto share_err;
>>> -
>>> -    ret = count;
>>> -    goto done;
>>> -
>>> -share_err:
>>> -    clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
>>> -done:
>>>       mutex_unlock(&matrix_dev->lock);
>>>   -    return ret;
>>> +    return count;
>>>   }
>>>   static DEVICE_ATTR_WO(assign_domain);
>>>   @@ -868,11 +730,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
>>>       if (id > matrix_mdev->matrix.adm_max)
>>>           return -ENODEV;
>>>   -    /* Set the bit in the ADM (bitmask) corresponding to the AP control
>>> -     * domain number (id). The bits in the mask, from most significant to
>>> -     * least significant, correspond to IDs 0 up to the one less than the
>>> -     * number of control domains that can be assigned.
>>> -     */
>>>       mutex_lock(&matrix_dev->lock);
>>>       set_bit_inv(id, matrix_mdev->matrix.adm);
>>>       mutex_unlock(&matrix_dev->lock);
>>
>

