Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3AD4E4FAA
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 10:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243318AbiCWJrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 05:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243312AbiCWJrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 05:47:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2569911C1E;
        Wed, 23 Mar 2022 02:45:53 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N9QBx9018452;
        Wed, 23 Mar 2022 09:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7LKmfYkYIAAQwIlj3rg0LsAEbnQObOItHI07v0dw0V4=;
 b=VL5MWpEXkIMAVk8EEV1rWblT12YxmIkoUrOI7XKS4qDh6fq/YmCWVEEljQQmczilQFDC
 Ro8Q8kSg/INEmPuC2KF0ajLK6ZY6OHqbnCq4usMrO/8OHgF9RaH2avVfbsL2JivpMVto
 jGglXOtQXhKZTHqKO2U17sWwwZHrgWPn7s7og7A9mzUNXaviWpndM7juP6mSNyScR9FA
 g6ivjJgZEpTnqgcoch/K4qUQvmC7cKj5cpQtuBERiZDdO5eoJRWZDOC7nuSaAiIxSl8w
 Yj4lDrkzIlX0PbWLJ8QxvJyAPJk/fLox6EnCO+M0kYN0/E7r7UJd+3Q7aCPfubD9U21s lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f00wr8bff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 09:45:53 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22N9SO7s022985;
        Wed, 23 Mar 2022 09:45:52 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f00wr8beq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 09:45:52 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22N9axDL024844;
        Wed, 23 Mar 2022 09:45:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej08gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 09:45:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22N9jlj216908550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 09:45:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 392F152050;
        Wed, 23 Mar 2022 09:45:47 +0000 (GMT)
Received: from [9.171.50.35] (unknown [9.171.50.35])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A6B615204F;
        Wed, 23 Mar 2022 09:45:46 +0000 (GMT)
Message-ID: <ce84fb30-30b4-2ff6-e5dc-4b7da5f47c85@linux.ibm.com>
Date:   Wed, 23 Mar 2022 10:45:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] KVM: s390: Fix lockdep issue in vm memop
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220322153204.2637400-1-scgl@linux.ibm.com>
 <44618f05-9aee-5aa5-b036-dd838285b26f@linux.ibm.com>
 <95c28949-8732-8812-c255-79467dafb5c8@linux.ibm.com>
 <7bcd8720-1c92-4e14-0c93-51d604f017a4@linux.ibm.com>
 <968319ed-ae4b-02fe-41c4-06799e940d94@linux.ibm.com>
 <8dc4c812-5c92-fcb8-9322-efc41fc73e1e@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <8dc4c812-5c92-fcb8-9322-efc41fc73e1e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N1fkA2LGWxYrCraW2S9-sUeT7aYt2gSA
X-Proofpoint-ORIG-GUID: f-zumIiEju4Yu7_UvVZvjBca1r-eFfjS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_05,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 bulkscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 23.03.22 um 10:39 schrieb Janis Schoetterl-Glausch:
> On 3/23/22 10:30, Christian Borntraeger wrote:
>>
>>
>> Am 23.03.22 um 09:57 schrieb Janosch Frank:
>>> On 3/23/22 09:52, Janis Schoetterl-Glausch wrote:
>>>> On 3/23/22 08:58, Janosch Frank wrote:
>>>>> On 3/22/22 16:32, Janis Schoetterl-Glausch wrote:
>>>>>> Issuing a memop on a protected vm does not make sense,
>>>>>
>>>>> Issuing a vm memop on a protected vm...
>>>>>
>>>>> The cpu memop still makes sense, no?
>>>>
>>>> The vcpu memop does hold the vcpu->lock, so no lockdep issue.
>>>> If you issue a vcpu memop while enabling protected virtualization,
>>>> the memop might find that the vcpu is not protected, while other vcpus
>>>> might already be, but I don't think there's a way to create secure memory
>>>> concurrent with the memop.
>>>
>>> I just wanted you to make this a bit more specific since we now have vm and vcpu memops. vm memops don't make sense for pv guests but vcpu ones are needed to access the sida.
>>
>> Right, I think changing the commit messages
>> - Issuing a memop on a protected vm does not make sense
>> + Issuing a vm memop on a protected vm does not make sense
>>
>> does make sense.
> 
> Ok, want me to send a v2?

I can fixup when applying. Done and queued for kvm.
>>
>>>
>>>>>
>>>>>> neither is the memory readable/writable, nor does it make sense to check
>>>>>> storage keys. This is why the ioctl will return -EINVAL when it detects
>>>>>> the vm to be protected. However, in order to ensure that the vm cannot
>>>>>> become protected during the memop, the kvm->lock would need to be taken
>>>>>> for the duration of the ioctl. This is also required because
>>>>>> kvm_s390_pv_is_protected asserts that the lock must be held.
>>>>>> Instead, don't try to prevent this. If user space enables secure
>>>>>> execution concurrently with a memop it must accecpt the possibility of
>>>>>> the memop failing.
>>>>>> Still check if the vm is currently protected, but without locking and
>>>>>> consider it a heuristic.
>>>>>>
>>>>>> Fixes: ef11c9463ae0 ("KVM: s390: Add vm IOCTL for key checked guest absolute memory access")
>>>>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>>>>
>>>>> Makes sense to me.
>>>>>
>>>>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>>>>>
>>>>>> ---
>>>>>>     arch/s390/kvm/kvm-s390.c | 11 ++++++++++-
>>>>>>     1 file changed, 10 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>> index ca96f84db2cc..53adbe86a68f 100644
>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>> @@ -2385,7 +2385,16 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
>>>>>>             return -EINVAL;
>>>>>>         if (mop->size > MEM_OP_MAX_SIZE)
>>>>>>             return -E2BIG;
>>>>>> -    if (kvm_s390_pv_is_protected(kvm))
>>>>>> +    /*
>>>>>> +     * This is technically a heuristic only, if the kvm->lock is not
>>>>>> +     * taken, it is not guaranteed that the vm is/remains non-protected.
>>>>>> +     * This is ok from a kernel perspective, wrongdoing is detected
>>>>>> +     * on the access, -EFAULT is returned and the vm may crash the
>>>>>> +     * next time it accesses the memory in question.
>>>>>> +     * There is no sane usecase to do switching and a memop on two
>>>>>> +     * different CPUs at the same time.
>>>>>> +     */
>>>>>> +    if (kvm_s390_pv_get_handle(kvm))
>>>>>>             return -EINVAL;
>>>>>>         if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
>>>>>>             if (access_key_invalid(mop->key))
>>>>>>
>>>>>> base-commit: c9b8fecddb5bb4b67e351bbaeaa648a6f7456912
>>>>>
>>>>
>>>
> 
