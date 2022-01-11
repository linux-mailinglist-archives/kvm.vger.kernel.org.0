Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B7348BAA2
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 23:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346093AbiAKWTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 17:19:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237156AbiAKWTl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 17:19:41 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BLB2sb022103;
        Tue, 11 Jan 2022 22:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Smn1xAhMJZExpvsAWzB6gWaEEVvUm9IhptPr7vYwNqk=;
 b=qPqLJkwMht/es/rG6Ebzd4g1YyA3HZSO8M4bok/k+jdrPkYFvDVdA6LmhP7TWB6a1Rjk
 ypLvtNFqh7TL23udBT68sW8paB4yeebBhQZBdfMbE0P9EtUln8Yfid0vXBZoRFNqA8Jp
 KOTAoJks1wnu1pwdaglJS4O2xBFoC9R2sr2oEMR8fooSdL192nkq8ox0fLFIIatDfRud
 F4rFxBxYE/NvFKobBLoRw0JzqJEEJzvsAiO2KsPZTfra17/hE8zzTDVueHpV6kdcOtqf
 JPsPu2GI0KMRxrApn3q0k2RGxY6ZJcl8IkKROwGbHQReYQrbQDzs7LmT2V2aLR1vgzmQ tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhf6nm5f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 22:19:39 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BMJdHX020435;
        Tue, 11 Jan 2022 22:19:39 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhf6nm5et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 22:19:39 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BMIfHG000840;
        Tue, 11 Jan 2022 22:19:38 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3df28awsjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 22:19:38 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BMJbXx16187670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 22:19:37 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE2C12805C;
        Tue, 11 Jan 2022 22:19:36 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56DD928060;
        Tue, 11 Jan 2022 22:19:36 +0000 (GMT)
Received: from [9.65.85.237] (unknown [9.65.85.237])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 22:19:36 +0000 (GMT)
Message-ID: <f3696ce0-5a9f-fefb-5606-055139866d99@linux.ibm.com>
Date:   Tue, 11 Jan 2022 17:19:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 08/15] s390/vfio-ap: keep track of active guests
Content-Language: en-US
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-9-akrowiak@linux.ibm.com>
 <20211230043322.2ba19bbd.pasic@linux.ibm.com>
 <fcce7cc6-6ac7-b22a-a957-80e59a0f4e83@linux.ibm.com>
In-Reply-To: <fcce7cc6-6ac7-b22a-a957-80e59a0f4e83@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GKTSTRI1jjf2na1MzjaBxv56vuzJSE1V
X-Proofpoint-ORIG-GUID: DV_yf3FZ6WwbDTveNMZGiZwN43PWFrxv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/22 16:58, Tony Krowiak wrote:
>
>
> On 12/29/21 22:33, Halil Pasic wrote:
>> On Thu, 21 Oct 2021 11:23:25 -0400
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>> The vfio_ap device driver registers for notification when the 
>>> pointer to
>>> the KVM object for a guest is set. Let's store the KVM pointer as 
>>> well as
>>> the pointer to the mediated device when the KVM pointer is set.
>> [..]
>>
>>
>>> struct ap_matrix_dev {
>>>          ...
>>>          struct rw_semaphore guests_lock;
>>>          struct list_head guests;
>>>         ...
>>> }
>>>
>>> The 'guests_lock' field is a r/w semaphore to control access to the
>>> 'guests' field. The 'guests' field is a list of ap_guest
>>> structures containing the KVM and matrix_mdev pointers for each active
>>> guest. An ap_guest structure will be stored into the list whenever the
>>> vfio_ap device driver is notified that the KVM pointer has been set and
>>> removed when notified that the KVM pointer has been cleared.
>>>
>> Is this about the field or about the list including all the nodes? This
>> reads lie guests_lock only protects the head element, which makes no
>> sense to me. Because of how these lists work.
>
> It locks the list, I can rewrite the description.

Ignore this response and read the answers to your comments below.

>
>
>>
>> The narrowest scope that could make sense is all the list_head stuff
>> in the entire list. I.e. one would only need the lock to traverse or
>> manipulate the list, while the payload would still be subject to
>> the matrix_dev->lock mutex.
>
> The matrix_dev->guests lock is needed whenever the kvm->lock
> is needed because the struct ap_guest object is created and the
> struct kvm assigned to it when the kvm pointer is set
> (vfio_ap_mdev_set_kvm function). So, in order to access the
> ap_guest object and retrieve the kvm pointer, we have to ensure
> the ap_guest_object is still available. The fact we can get the
> kvm pointer from the ap_matrix_mdev object just makes things
> more efficient - i.e., we won't have to traverse the list.
>
> Whenever the kvm->lock and matrix_dev->lock mutexes must
> be held, the order is:
>
>     matrix_dev->guests_lock
>     matrix_dev->guests->kvm->lock
>     matrix_dev->lock
>
> There are times where all three locks are not required; for example,
> the handle_pqap and vfio_ap_mdev_probe/remove functions only
> require the matrix_dev->lock because it does not need to lock kvm.
>
>>
>> [..]
>>
>>> +struct ap_guest {
>>> +    struct kvm *kvm;
>>> +    struct list_head node;
>>> +};
>>> +
>>>   /**
>>>    * struct ap_matrix_dev - Contains the data for the matrix device.
>>>    *
>>> @@ -39,6 +44,9 @@
>>>    *        single ap_matrix_mdev device. It's quite coarse but we 
>>> don't
>>>    *        expect much contention.
>>>    * @vfio_ap_drv: the vfio_ap device driver
>>> + * @guests_lock: r/w semaphore for protecting access to @guests
>>> + * @guests:    list of guests (struct ap_guest) using AP devices 
>>> bound to the
>>> + *        vfio_ap device driver.
>> Please compare the above. Also if it is only about the access to the
>> list, then you could drop the lock right after create, and not keep it
>> till the very end of vfio_ap_mdev_set_kvm(). Right?
>
> That would be true if it only controlled access to the list, but as I
> explained above, that is not its sole purpose.
>
>>
>> In any case I'm skeptical about this whole struct ap_guest business. To
>> me, it looks like something that just makes things more obscure and
>> complicated without any real benefit.
>
> I'm open to other ideas, but you'll have to come up with a way
> to take the kvm->lock before the matrix_mdev->lock in the
> vfio_ap_mdev_probe_queue and vfio_ap_mdev_remove_queue
> functions where we don't have access to the ap_matrix_mdev
> object to which the APQN is assigned and has the pointer to the
> kvm object.
>
> In order to retrieve the matrix_mdev, we need the matrix_dev->lock.
> In order to hot plug/unplug the queue, we need the kvm->lock.
> There's your catch-22 that needs to be solved. This design is my
> attempt to solve that.
>
>>
>> Regards,
>> Halil
>>
>>>    */
>>>   struct ap_matrix_dev {
>>>       struct device device;
>>> @@ -47,6 +55,8 @@ struct ap_matrix_dev {
>>>       struct list_head mdev_list;
>>>       struct mutex lock;
>>>       struct ap_driver  *vfio_ap_drv;
>>> +    struct rw_semaphore guests_lock;
>>> +    struct list_head guests;
>>>   };
>>>     extern struct ap_matrix_dev *matrix_dev;
>

