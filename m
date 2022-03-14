Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865884D85D0
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 14:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbiCNNTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 09:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbiCNNTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 09:19:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10558EB0;
        Mon, 14 Mar 2022 06:17:52 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22ED7CEv006010;
        Mon, 14 Mar 2022 13:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=IKWPY25utZDvoApHZiSAdFdhzSlnt3SYcAU67onu3wY=;
 b=noL0Gv5baAu4F+LhzOn1j2YQ9/08hVIntu5gRWYVMGt6IsQ59aarvOAk0I1hOjO93sRa
 AgHfODBzyQJV5NNuuxVuCGVOlQi0SQwCiIZXtGahJ8JI8xPz8bP/guRg1l0/4khUMjib
 iFJl8uvl0a4iiiWVnZgAuxae8KC5zqbFobeQTNa1aDbqgrmFXtUan4BNJy9rAj4HmRAy
 ujpyHzzHHzBjFiV/mjkuE2t69CsXtVDOFrVNi7X4nmah2hRRLUqc1cfF46wyn7wNc1uq
 NpW32/fW0B42PpH02bLLpXiFlBvHLbEEMzzGlF/M5X3apiQKHxlvaMace2jYBaN7AGKr Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6a6rnh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 13:17:50 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22ED82hg016880;
        Mon, 14 Mar 2022 13:17:49 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6a6rngr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 13:17:49 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EDDICd026277;
        Mon, 14 Mar 2022 13:17:48 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3erk58s9tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 13:17:48 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EDHk1Z14614888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 13:17:46 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54D04AC059;
        Mon, 14 Mar 2022 13:17:46 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E5AAC05F;
        Mon, 14 Mar 2022 13:17:44 +0000 (GMT)
Received: from [9.160.122.233] (unknown [9.160.122.233])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 13:17:44 +0000 (GMT)
Message-ID: <fa02a725-eb03-6762-20c8-66aad68ce650@linux.ibm.com>
Date:   Mon, 14 Mar 2022 09:17:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 10/18] s390/vfio-ap: allow hot plug/unplug of AP
 devices when assigned/unassigned
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-11-akrowiak@linux.ibm.com>
 <fcce28f2-64f7-0946-3f33-3158b7909d6b@linux.ibm.com>
 <016b3ffe-8aaa-f29e-2a8e-217c6b97f3a1@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <016b3ffe-8aaa-f29e-2a8e-217c6b97f3a1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5nEOZfxq3abo_22eLJhUtvf50qwBBKvp
X-Proofpoint-ORIG-GUID: 6HGvhiQJs0_dfmfHltHPPumo_6kyVq7e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_08,2022-03-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/22 11:07, Tony Krowiak wrote:
> 
> 
> On 3/11/22 09:26, Jason J. Herne wrote:
>> On 2/14/22 19:50, Tony Krowiak wrote:
>>> Let's allow adapters, domains and control domains to be hot plugged
>>> into and hot unplugged from a KVM guest using a matrix mdev when an
>>> adapter, domain or control domain is assigned to or unassigned from
>>> the matrix mdev.
>>>
>>> Whenever an assignment or unassignment of an adapter, domain or control
>>> domain is performed, the AP configuration assigned to the matrix
>>> mediated device will be filtered and assigned to the AP control block
>>> (APCB) that supplies the AP configuration to the guest so that no
>>> adapter, domain or control domain that is not in the host's AP
>>> configuration nor any APQN that does not reference a queue device bound
>>> to the vfio_ap device driver is assigned.
>>>
>>> After updating the APCB, if the mdev is in use by a KVM guest, it is
>>> hot plugged into the guest to dynamically provide access to the adapters,
>>> domains and control domains provided via the newly refreshed APCB.
>>>
>>> Keep in mind that the matrix_dev->guests_lock must be taken outside of the
>>> matrix_mdev->kvm->lock which in turn must be taken outside of the
>>> matrix_dev->mdevs_lock in order to avoid circular lock dependencies (i.e.,
>>> a lockdep splat).Consequently, the locking order for hot plugging the
>>> guest's APCB must be:
>>>
>>> matrix_dev->guests_lock => matrix_mdev->kvm->lock => matrix_dev->mdevs_lock
>>>
>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> ---
>>>   drivers/s390/crypto/vfio_ap_ops.c | 198 +++++++++++++++++++-----------
>>>   1 file changed, 125 insertions(+), 73 deletions(-)
>>>
>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>> index 623a4b38676d..4c382cd3afc7 100644
>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>> @@ -317,10 +317,25 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>>>       matrix->adm_max = info->apxa ? info->Nd : 15;
>>>   }
>>>   -static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
>>> +static void vfio_ap_mdev_hotplug_apcb(struct ap_matrix_mdev *matrix_mdev)
>>>   {
>>> +    if (matrix_mdev->kvm)
>>> +        kvm_arch_crypto_set_masks(matrix_mdev->kvm,
>>> +                      matrix_mdev->shadow_apcb.apm,
>>> +                      matrix_mdev->shadow_apcb.aqm,
>>> +                      matrix_mdev->shadow_apcb.adm);
>>> +}
>>
>> This function updates a kvm guest's apcb. So let's rename it to
>> vfio_ap_update_apcb(). 
> 
> The idea was to indicate that the AP adapters, domains and control
> domains configured in the shadow APCB are being hot plugged into
> a running guest. Having said that, I can see your point. I'm not married to
> the function name, but I would prefer to go with
> 'vfio_ap_update_guest_apcb()' to distinguish between the shadow and
> the real apcb.
> 
>> You can also call this function in vfio_ap_mdev_set_kvm,
>> instead of duplicating the code to call kvm_arch_crypto_set_masks().
> 
> The reason I didn't do that is because we've already verified the
> matrix_mdev->kvm in kvm_arch_crypto_set_masks(). I'm not sure what
> it buys us, but I'm not adverse to making the change.
> 

It avoids code duplication which makes the driver smaller, and slightly
easier to read. It also reduces rework effort if/when mask handling ever
changes.

>>
>>
>>
>>
>>> +static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
>>> +{
>>> +    DECLARE_BITMAP(shadow_adm, AP_DOMAINS);
>>> +
>>> +    bitmap_copy(shadow_adm, matrix_mdev->shadow_apcb.adm, AP_DOMAINS);
>>>       bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
>>>              (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
>>> +
>>> +    return !bitmap_equal(shadow_adm, matrix_mdev->shadow_apcb.adm,
>>> +                 AP_DOMAINS);
>>>   }
>>
>> your variable, shadow_adm, should be named original_adm. Since it represents
>> the original value before filtering. This makes the intent much more clear.
>> Same goes for the vars in vfio_ap_mdev_filter_matrix().
> 
> Makes sense, but I think I'll go with prev_shadow_apm, prev_shadow_aqm and
> prev_shadow_adm. That seems more accurate since these are not the original
> copies of the bitmaps, but copies of the previous versions prior to filtering.

That works for me :) Thanks! In general, I like to avoid generic variable names
like "mask" or "thing" whenever possible. Especially if I'm dealing with multiple
instances of the same type of data within the same scope. Giving each variable a
specific name can really help de-obfuscate the code.

>>
>> ...
>>> +/**
>>> + * vfio_ap_mdev_get_locks - acquire the locks required to assign/unassign AP
>>> + *                adapters, domains and control domains for an mdev in
>>> + *                the proper locking order.
>>> + *
>>> + * @matrix_mdev: the matrix mediated device object
>>> + */
>>> +static void vfio_ap_mdev_get_locks(struct ap_matrix_mdev *matrix_mdev)
>>> +{
>>> +    /* Lock the mutex required to access the KVM guest's state */
>>> +    mutex_lock(&matrix_dev->guests_lock);
>>> +
>>> +    /* If a KVM guest is running, lock the mutex required to plug/unplug the
>>> +     * AP devices passed through to the guest
>>> +     */
>>> +    if (matrix_mdev->kvm)
>>> +        mutex_lock(&matrix_mdev->kvm->lock);
>>> +
>>> +    /* The lock required to access the mdev's state */
>>> +    mutex_lock(&matrix_dev->mdevs_lock);
>>> +}
>>
>> Simplifying the cdoe, and removing duplication by moving the locking code to a
>> function is probably a good thing. But I don't feel like this belongs to this
>> particular patch. In general, a patch should only do one thing, and ideally that
>> one thing should be as small as reasonably possible. This makes the patch easier
>> to read and to review.
>>
>> I feel like, as much as possible, you should refactor the locking in a series
>> of patches that are all kept together. Ideally, they would be a patch series
>> completely separate from dynamic ap. After all, this series is already at 18
>> patches. :)
> 
> I'm going to have to disagree, this locking scheme makes no sense outside of
> this series. It is only necessary because we now update a guest's APCB
> whenever an adapter, domain or control domain is assigned or unassigned,
> when a queue device is probed or removed and when the vfio_ap driver is
> notified that the host's AP configuration has changed.
>
> Prior to this series, a guest's APCB was updated only when the vfio_ap
> driver was notified that the KVM pointer was set or cleared, so it was
> only necessary to ensure the kvm->lock is taken before the matrix_dev->lock
> in the functions that handle the VFIO_GROUP_NOTIFY_SET_KVM group
> notification event. Prior to this, a patch series to introduce the matrix_dev->guests lock
> would make no sense because it is not needed to enforce the locking order in those
> functions listed in the previous paragraph because we didn't update the guest's
> APCB in those functions.
> 

I don't understand the lock code enough to argue a whole lot here :) But I do still
think, at the very least, that your refactoring of the locking into get_locks/put_locks
functions really does belong in a separate patch. Refactoring is not directly related to
the hotplug/unplug. Also, this is not a minor refactor. This refactoring touches the code
all over the place and really just adds noise to this patch. That noise makes it harder
to review.

>> ...
>>>   /**
>>>    * assign_adapter_store - parses the APID from @buf and sets the
>>>    * corresponding bit in the mediated matrix device's APM
>>> @@ -649,17 +723,9 @@ static ssize_t assign_adapter_store(struct device *dev,
>>>       int ret;
>>>       unsigned long apid;
>>>       DECLARE_BITMAP(apm, AP_DEVICES);
>>> -
>>>       struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>>>   -    mutex_lock(&matrix_dev->guests_lock);
>>> -    mutex_lock(&matrix_dev->mdevs_lock);
>>> -
>>> -    /* If the KVM guest is running, disallow assignment of adapter */
>>> -    if (matrix_mdev->kvm) {
>>> -        ret = -EBUSY;
>>> -        goto done;
>>> -    }
>>> +    vfio_ap_mdev_get_locks(matrix_mdev);
>>>         ret = kstrtoul(buf, 0, &apid);
>>>       if (ret)
>>> @@ -671,8 +737,6 @@ static ssize_t assign_adapter_store(struct device *dev,
>>>       }
>>>         set_bit_inv(apid, matrix_mdev->matrix.apm);
>>> -    memset(apm, 0, sizeof(apm));
>>> -    set_bit_inv(apid, apm);
>>>         ret = vfio_ap_mdev_validate_masks(matrix_mdev);
>>
>> It looks like you moved the memset() and set_bit_inv() to be closer to where
>> "apm" is used, namely, the call to vfio_ap_mdev_filter_matrix(). Any reason you
>> cannot move it down under the call to vfio_ap_mdev_link_adapter()? That would
>> get it even closer to where it is used.
> 
> I didn't move it to be closer to where it is used, I moved it because it was not
> necessary to do the memset/set_bit_inv when not necessary to do so. Having
> said that, it can definitely be moved after the vfio_ap_mdev_link_adapter().
> 
>>
>> Also, I think renaming apm to apm_delta or apm_diff makes sense here. After all,
>> it is the difference between the original apm, and the new apm. The new apm
>> has an extra bit for the newly added adapter. Do I have that right? If so, I
>> think renaming the variable will make the code clearer.
> 
> The purpose of this bitmap is to limit the filtering to the new APID being assigned
> because there is no need to do filtering of adapters already assigned; so, it is not
> really a new apm per se. It might be more accurate to call it new_apid or new_apids,
> although there will only be one bit set in the bitmap.

My main concern here was generic variables names. The "new_apm" will have exactly one
new bit set. That bit is the delta (or the difference) between the previously existing 
apm, and the new apm, which will be the result of adding in whatever the "apid" bit is. 
Therefore, it really is a delta, right? This was the basis for my suggestion of the
name. Its really not the "new" apm... its the difference between the old and new.


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
