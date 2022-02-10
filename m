Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C722D4B09C3
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 10:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbiBJJne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 04:43:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237813AbiBJJne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 04:43:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FD5198;
        Thu, 10 Feb 2022 01:43:35 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21A8e2lS017544;
        Thu, 10 Feb 2022 09:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=c+MoOO0p48rgFA4we5XmAZ1Bj7IJq9T09FokDjoZ/Xc=;
 b=VosqYpcJd8gZ+blgKJc2p2ZhLEADSmWerpbHfI/Tu+ffXwBCI4XEm7pkXYKvkinwNkC0
 4mKx2/bKG/PrTGrUxNUsjXj5zF92j27kuE0ja3HgMOsBMd/3GpdL9W4gvpcLrgLi3t/p
 97B45rxws7j2/MKp/8/wr6S0eQjblkkiXar0n8kdedeSQnEf8ZEMsSWCJcTaj57saf/Q
 /pIVsXINiNLz7ILfT8FNF1WcpVcaKxxsJTwob4Yav161n6ltVeBAZyPjxdmHud+iXrEr
 GAiu2Qo0jirlkeAeaQwXA3t0vD8V2fvN/pNF91o0mRIKaW7ueFst0K3hhK9a1AcYLhRA mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4kt2ep3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 09:43:33 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21A8imcl013862;
        Thu, 10 Feb 2022 09:43:33 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4kt2ep2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 09:43:33 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21A9bwRx029214;
        Thu, 10 Feb 2022 09:43:31 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygqkh16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 09:43:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21A9hRCo44499210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 09:43:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0F8652050;
        Thu, 10 Feb 2022 09:43:27 +0000 (GMT)
Received: from [9.171.15.77] (unknown [9.171.15.77])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B64B052052;
        Thu, 10 Feb 2022 09:43:26 +0000 (GMT)
Message-ID: <003e0e46-1dd5-7806-cab6-0d730ff923b9@linux.ibm.com>
Date:   Thu, 10 Feb 2022 10:43:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 05/10] KVM: s390: Add optional storage key checking to
 MEMOP IOCTL
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20220209170422.1910690-1-scgl@linux.ibm.com>
 <20220209170422.1910690-6-scgl@linux.ibm.com>
 <c5d8e633-c0cd-91d4-723b-abf26c01fd6d@linux.ibm.com>
 <a384835f-e8f8-7940-af3b-2a7018fa7353@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <a384835f-e8f8-7940-af3b-2a7018fa7353@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x86TmFy9WNU1K6Vynjnb-4A_Ba7OX5vD
X-Proofpoint-ORIG-GUID: XzVe-eT19huoGUkVH-3-sbJSxkmc9t5E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_03,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 10.02.22 um 10:40 schrieb Janis Schoetterl-Glausch:
> On 2/10/22 10:29, Christian Borntraeger wrote:
>> Am 09.02.22 um 18:04 schrieb Janis Schoetterl-Glausch:
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
>>
>> Claudio, Janosch, can you confirm that this is still valid?
>>
>>
>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Not @linux.ibm.com?

Yes, of course. Old habits...
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

>>
>> minor thing below
>>> ---
>>>    arch/s390/kvm/kvm-s390.c | 30 ++++++++++++++++++++----------
>>>    include/uapi/linux/kvm.h |  6 +++++-
>>>    2 files changed, 25 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index cf347e1a4f17..85763ec7bc60 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -32,6 +32,7 @@
>>>    #include <linux/sched/signal.h>
>>>    #include <linux/string.h>
>>>    #include <linux/pgtable.h>
>>> +#include <linux/bitfield.h>
>>
>> do we still need that after the changes?
> 
> No, not since we moved the key out of the flags.
>>
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
>>> @@ -4690,17 +4696,19 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>>>        void *tmpbuf = NULL;
>>>        int r = 0;
>>>        const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
>>> -                    | KVM_S390_MEMOP_F_CHECK_ONLY;
>>> +                    | KVM_S390_MEMOP_F_CHECK_ONLY
>>> +                    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
>>>          if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
>>>            return -EINVAL;
>>> -
>>>        if (mop->size > MEM_OP_MAX_SIZE)
>>>            return -E2BIG;
>>> -
>>>        if (kvm_s390_pv_cpu_is_protected(vcpu))
>>>            return -EINVAL;
>>> -
>>> +    if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
>>> +        if (access_key_invalid(mop->key))
>>> +            return -EINVAL;
>>> +    }
>>>        if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
>>>            tmpbuf = vmalloc(mop->size);
>>>            if (!tmpbuf)
>>> @@ -4710,11 +4718,12 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>>>        switch (mop->op) {
>>>        case KVM_S390_MEMOP_LOGICAL_READ:
>>>            if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>>> -            r = check_gva_range(vcpu, mop->gaddr, mop->ar,
>>> -                        mop->size, GACC_FETCH, 0);
>>> +            r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
>>> +                        GACC_FETCH, mop->key);
>>>                break;
>>>            }
>>> -        r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
>>> +        r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
>>> +                    mop->size, mop->key);
>>>            if (r == 0) {
>>>                if (copy_to_user(uaddr, tmpbuf, mop->size))
>>>                    r = -EFAULT;
>>> @@ -4722,15 +4731,16 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>>>            break;
>>>        case KVM_S390_MEMOP_LOGICAL_WRITE:
>>>            if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>>> -            r = check_gva_range(vcpu, mop->gaddr, mop->ar,
>>> -                        mop->size, GACC_STORE, 0);
>>> +            r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
>>> +                        GACC_STORE, mop->key);
>>>                break;
>>>            }
>>>            if (copy_from_user(tmpbuf, uaddr, mop->size)) {
>>>                r = -EFAULT;
>>>                break;
>>>            }
>>> -        r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
>>> +        r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
>>> +                     mop->size, mop->key);
>>>            break;
>>>        }
>>>    diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index b46bcdb0cab1..44558cf4c52e 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -562,7 +562,10 @@ struct kvm_s390_mem_op {
>>>        __u32 op;        /* type of operation */
>>>        __u64 buf;        /* buffer in userspace */
>>>        union {
>>> -        __u8 ar;    /* the access register number */
>>> +        struct {
>>> +            __u8 ar;    /* the access register number */
>>> +            __u8 key;    /* access key, ignored if flag unset */
>>> +        };
>>>            __u32 sida_offset; /* offset into the sida */
>>>            __u8 reserved[32]; /* should be set to 0 */
>>>        };
>>> @@ -575,6 +578,7 @@ struct kvm_s390_mem_op {
>>>    /* flags for kvm_s390_mem_op->flags */
>>>    #define KVM_S390_MEMOP_F_CHECK_ONLY        (1ULL << 0)
>>>    #define KVM_S390_MEMOP_F_INJECT_EXCEPTION    (1ULL << 1)
>>> +#define KVM_S390_MEMOP_F_SKEY_PROTECTION    (1ULL << 2)
>>>      /* for KVM_INTERRUPT */
>>>    struct kvm_interrupt {
> 
