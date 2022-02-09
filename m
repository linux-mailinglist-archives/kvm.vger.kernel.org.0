Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592094AEFC2
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 12:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiBILKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 06:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiBILKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 06:10:21 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C628E08289D;
        Wed,  9 Feb 2022 02:05:52 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2196Rwg9037918;
        Wed, 9 Feb 2022 09:08:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=85BTCYJ8b9wszDml7GMxnTAH4jTYLNfYsR9Ox7jzAdo=;
 b=ZAaq/b+PpU6TXD/xA/7yRI5axFrpZEUUBYFqzXfoGD4vE1cySoxhieyWnLPStO3826qi
 da6cKEPnM/Yi3+RwMSEl9TYu9BxsoZz6nUAJkygadAMP85HbF6X01N9jizzWpTVmCkNC
 6HKTgFem8auLO9eLH8OIr6M3rHDvhiD9bJpdSItYBb5S/HVxCQIQwwujBIZM1+Tj2r5S
 x2fVoYG7iRkh4bOkNGissf8pYuzm70Cxd++fMr52ltqe0sxsmdbxxMm2gkLZz0cNGUNc
 C1qkBt+2CzLKPcC9OXa8/qwWdSG2RjBUp9kBCXZZvjXfWE/RUEpXsjorJc5d+WPxOTaU oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3wmk8q4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 09:08:14 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2198f80c038886;
        Wed, 9 Feb 2022 09:08:14 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3wmk8q3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 09:08:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21996UWl008785;
        Wed, 9 Feb 2022 09:08:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv9d1e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 09:08:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2198w0ts33030464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 08:58:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AF784C04E;
        Wed,  9 Feb 2022 09:08:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4F914C050;
        Wed,  9 Feb 2022 09:08:06 +0000 (GMT)
Received: from [9.171.87.52] (unknown [9.171.87.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 09:08:06 +0000 (GMT)
Message-ID: <6ea27647-fbbe-3962-03a0-8ca5340fc7fd@linux.ibm.com>
Date:   Wed, 9 Feb 2022 10:08:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 05/11] KVM: s390: Add optional storage key checking to
 MEMOP IOCTL
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
 <20220207165930.1608621-6-scgl@linux.ibm.com>
 <48d1678f-746c-dab6-5ec3-56397277f752@linux.ibm.com>
 <71f07914-d0b2-e98b-22b2-bc05f04df2da@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <71f07914-d0b2-e98b-22b2-bc05f04df2da@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Uw-uIbq5PPdoLNW5R3hzV1UaOdp6uQw_
X-Proofpoint-ORIG-GUID: kVS-vx5uYUYvBhv00PO4UAaPlK59RC8q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_04,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 09.02.22 um 09:49 schrieb Janis Schoetterl-Glausch:
> On 2/9/22 08:34, Christian Borntraeger wrote:
>> Am 07.02.22 um 17:59 schrieb Janis Schoetterl-Glausch:
>>> User space needs a mechanism to perform key checked accesses when
>>> emulating instructions.
>>>
>>> The key can be passed as an additional argument.
>>> Having an additional argument is flexible, as user space can
>>> pass the guest PSW's key, in order to make an access the same way the
>>> CPU would, or pass another key if necessary.
>>>
>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/kvm-s390.c | 49 +++++++++++++++++++++++++++++++---------
>>>    include/uapi/linux/kvm.h |  8 +++++--
>>>    2 files changed, 44 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index cf347e1a4f17..71e61fb3f0d9 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -32,6 +32,7 @@
>>>    #include <linux/sched/signal.h>
>>>    #include <linux/string.h>
>>>    #include <linux/pgtable.h>
>>> +#include <linux/bitfield.h>
>>>      #include <asm/asm-offsets.h>
>>>    #include <asm/lowcore.h>
>>> @@ -2359,6 +2360,11 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>>        return r;
>>>    }
>>>    +static bool access_key_invalid(u8 access_key)
>>> +{
>>> +    return access_key > 0xf;
>>> +}
>>> +
>>>    long kvm_arch_vm_ioctl(struct file *filp,
>>>                   unsigned int ioctl, unsigned long arg)
>>>    {
>>> @@ -4687,34 +4693,54 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>>>                      struct kvm_s390_mem_op *mop)
>>>    {
>>>        void __user *uaddr = (void __user *)mop->buf;
>>> +    u8 access_key = 0, ar = 0;
>>>        void *tmpbuf = NULL;
>>> +    bool check_reserved;
>>>        int r = 0;
>>>        const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
>>> -                    | KVM_S390_MEMOP_F_CHECK_ONLY;
>>> +                    | KVM_S390_MEMOP_F_CHECK_ONLY
>>> +                    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
>>>    -    if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
>>> +    if (mop->flags & ~supported_flags || !mop->size)
>>>            return -EINVAL;
>>> -
>>>        if (mop->size > MEM_OP_MAX_SIZE)
>>>            return -E2BIG;
>>> -
>>>        if (kvm_s390_pv_cpu_is_protected(vcpu))
>>>            return -EINVAL;
>>> -
>>>        if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
>>>            tmpbuf = vmalloc(mop->size);
>>>            if (!tmpbuf)
>>>                return -ENOMEM;
>>>        }
>>> +    ar = mop->ar;
>>> +    mop->ar = 0;
>>
>> Why this assignment to 0?
> 
> It's so the check of reserved below works like that, they're all part of the anonymous union.

Ah, I see. This is ugly :-)

>>
>>> +    if (ar >= NUM_ACRS)
>>> +        return -EINVAL;
>>> +    if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
>>> +        access_key = mop->key;
>>> +        mop->key = 0;
>>
>> and this? I think we can leave mop unchanged.
>>
>> In fact, why do we add the ar and access_key variable?
>> This breaks the check from above (if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size))  into two checks
>> and it will create a memleak for tmpbuf.
> 
> I can move the allocation down, goto out or get rid of the reserved check and keep everything as before.
> First is simpler, but second makes handling that case more explicit and might help in the future.

Maybe add a reserved_02 field in the anon struct and check this for being zero and get rid of the local variables?

> Patch 6 has the same issue in the vm ioctl handler.
>>
>> Simply use mop->key and mop->ar below and get rid of the local variables.
>> The structure has no concurrency and gcc will handle that just as the local variable.
>>
>> Other than that this looks good.
> 
> [...]
> 
