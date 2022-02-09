Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C3D4AF17F
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 13:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiBIM1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 07:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbiBIM1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 07:27:00 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A6CC05CB86;
        Wed,  9 Feb 2022 04:27:03 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219BSRmr014162;
        Wed, 9 Feb 2022 12:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dWa9FmD2DoH+uE6blgv/qXhYH8j5lKGw7yJl+iTqvk4=;
 b=qC6FgNSYTRhFG/ybXz7IIFXl8wFf7gRwHpGDsL7gFr8CXTKhzeSPXudN1ZQxLzvPFn8R
 cP1+44FDEkbMLH70tzBfSAMHu3mx7QL3upiCAzUx3oPFXJ3buHyRgVYpKeZ9BZnmeQ/1
 SLuFRiaw9KOuebsEfi9jtec4xyihUDoKW6zlk8jkC4JJhxa4w+PeBFfzRa2X9gRkka2+
 t7ExS1Es/7+iJXuJOhKp7oD8FoBlTYW5sOqOjK/3jfdo6k7agSUDVkw7SYoirmciKQlM
 m+nrH6D1a4BPpW9dOhyZzBs/BOQ6w1Tat8YNfYcuQgd/Mp00mm/IMfCnIj/Xus58vOuM yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4crxs1e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 12:27:02 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219CIglA028256;
        Wed, 9 Feb 2022 12:27:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4crxs1de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 12:27:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219CLNB3017123;
        Wed, 9 Feb 2022 12:27:00 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gvad8uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 12:27:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219CGnUD34078994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 12:16:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCDD8A405F;
        Wed,  9 Feb 2022 12:26:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 531A2A405C;
        Wed,  9 Feb 2022 12:26:56 +0000 (GMT)
Received: from [9.145.45.120] (unknown [9.145.45.120])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 12:26:56 +0000 (GMT)
Message-ID: <9d21f70f-969a-5752-1027-acd6fbfcce12@linux.ibm.com>
Date:   Wed, 9 Feb 2022 13:26:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v2 1/1] KVM: s390: pv: make use of ultravisor AIV support
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220208165310.3905815-1-mimu@linux.ibm.com>
 <20220208165310.3905815-2-mimu@linux.ibm.com>
 <79a49a19-e42d-d53c-27a2-2e96a20156d4@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <79a49a19-e42d-d53c-27a2-2e96a20156d4@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TlNyrT60GnaX3GnUD9Uf7JXmUCWWx8-F
X-Proofpoint-ORIG-GUID: dilYz7dkq3InBiQy52b7G1KVvvieueZv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_06,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202090072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09.02.22 10:12, Janosch Frank wrote:
> On 2/8/22 17:53, Michael Mueller wrote:
>> This patch enables the ultravisor adapter interruption vitualization
>> support indicated by UV feature BIT_UV_FEAT_AIV. This allows ISC
>> interruption injection directly into the GISA IPM for PV kvm guests.
>>
>> Hardware that does not support this feature will continue to use the
>> UV interruption interception method to deliver ISC interruptions to
>> PV kvm guests. For this purpose, the ECA_AIV bit for all guest cpus
>> will be cleared and the GISA will be disabled during PV CPU setup.
>>
>> In addition a check in __inject_io() has been removed. That reduces the
>> required instructions for interruption handling for PV and traditional
>> kvm guests.
>>
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/uv.h |  1 +
>>   arch/s390/kvm/interrupt.c  | 53 +++++++++++++++++++++++++++++++++-----
>>   arch/s390/kvm/kvm-s390.c   | 12 ++++++---
>>   arch/s390/kvm/kvm-s390.h   | 11 ++++++++
>>   4 files changed, 68 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 86218382d29c..a2d376b8bce3 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -80,6 +80,7 @@ enum uv_cmds_inst {
>>   enum uv_feat_ind {
>>       BIT_UV_FEAT_MISC = 0,
>> +    BIT_UV_FEAT_AIV = 1,
>>   };
>>   struct uv_cb_header {
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index db933c252dbc..d45e26e31d3d 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -1901,13 +1901,12 @@ static int __inject_io(struct kvm *kvm, struct 
>> kvm_s390_interrupt_info *inti)
>>       isc = int_word_to_isc(inti->io.io_int_word);
>>       /*
>> -     * Do not make use of gisa in protected mode. We do not use the lock
>> -     * checking variant as this is just a performance optimization 
>> and we
>> -     * do not hold the lock here. This is ok as the code will pick
>> -     * interrupts from both "lists" for delivery.
>> +     * We do not use the lock checking variant as this is just a
>> +     * performance optimization and we do not hold the lock here.
>> +     * This is ok as the code will pick interrupts from both "lists"
>> +     * for delivery.
>>        */
>> -    if (!kvm_s390_pv_get_handle(kvm) &&
>> -        gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
>> +    if (gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
>>           VM_EVENT(kvm, 4, "%s isc %1u", "inject: I/O (AI/gisa)", isc);
>>           gisa_set_ipm_gisc(gi->origin, isc);
>>           kfree(inti);
>> @@ -3171,9 +3170,32 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>>       VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
>>   }
>> +void kvm_s390_gisa_enable(struct kvm *kvm)
>> +{
>> +    struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>> +    struct kvm_vcpu *vcpu;
>> +    unsigned long i;
>> +
>> +    if (gi->origin)
>> +        return;
>> +    kvm_s390_gisa_init(kvm);
>> +    kvm_for_each_vcpu(i, vcpu, kvm) {
>> +        mutex_lock(&vcpu->mutex);
>> +        vcpu->arch.sie_block->gd = kvm_s390_get_gisa_desc(kvm);
> 
> The gisa is a per VM structure so this value could be cached outside the 
> loop. Also I'd expect that we would need to do the != 0 check only once, 
> no?

Will do in front of the vcpu loop-

> 
>> +        if (vcpu->arch.sie_block->gd) {
>> +            vcpu->arch.sie_block->eca |= ECA_AIV;
>> +            VCPU_EVENT(vcpu, 3, "AIV gisa format-%u enabled for cpu 
>> %03u",
>> +                   vcpu->arch.sie_block->gd & 0x3, vcpu->vcpu_id);
>> +        }
>> +        mutex_unlock(&vcpu->mutex);
>> +    }
>> +}
>> +
>> +
> 
> One \n too much

yep

> 
>>   void kvm_s390_gisa_destroy(struct kvm *kvm)
>>   {
>>       struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>> +    struct kvm_s390_gisa *gisa = gi->origin;
>>       if (!gi->origin)
>>           return;
>> @@ -3184,6 +3206,25 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
>>           cpu_relax();
>>       hrtimer_cancel(&gi->timer);
>>       gi->origin = NULL;
>> +    VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
>> +}
>> +
>> +void kvm_s390_gisa_disable(struct kvm *kvm)
>> +{
>> +    struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>> +    struct kvm_vcpu *vcpu;
>> +    unsigned long i;
>> +
>> +    if (!gi->origin)
>> +        return;
>> +    kvm_for_each_vcpu(i, vcpu, kvm) {
>> +        mutex_lock(&vcpu->mutex);
>> +        vcpu->arch.sie_block->eca &= ~ECA_AIV;
>> +        vcpu->arch.sie_block->gd = 0U;
>> +        mutex_unlock(&vcpu->mutex);
>> +        VCPU_EVENT(vcpu, 3, "AIV disabled for cpu %03u", vcpu->vcpu_id);
>> +    }
>> +    kvm_s390_gisa_destroy(kvm);
>>   }
>>   /**
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 577f1ead6a51..72a3c9a7c9dd 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2194,6 +2194,9 @@ static int kvm_s390_cpus_from_pv(struct kvm 
>> *kvm, u16 *rcp, u16 *rrcp)
>>           }
>>           mutex_unlock(&vcpu->mutex);
>>       }
>> +    /* Finally enable the GISA if required for traditional KVM guests */
> 
> Ensure that we re-enable gisa if the non-PV guest used it but the PV 
> guest did not.

I will change the comment if that makes it more clear.

> 
>> +    if (use_gisa)
>> +        kvm_s390_gisa_enable(kvm);
>>       return ret;
>>   }
>> @@ -2205,6 +2208,10 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, 
>> u16 *rc, u16 *rrc)
>>       struct kvm_vcpu *vcpu;
>> +    /* First disable the GISA if the ultravisor does not support AIV. */
> 
> I think we should drop the "First" here.

ok

> 
>> +    if (!test_bit_inv(BIT_UV_FEAT_AIV, &uv_info.uv_feature_indications))
>> +        kvm_s390_gisa_disable(kvm);
>> +
>>       kvm_for_each_vcpu(i, vcpu, kvm) {
>>           mutex_lock(&vcpu->mutex);
>>           r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
>> @@ -2268,6 +2275,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, 
>> struct kvm_pv_cmd *cmd)
>>            */
>>           if (r)
>>               break;
>> +
> 
> Stray whitespace change

ups

> 
>>           r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
>>           /* no need to block service interrupts any more */
>> @@ -3263,9 +3271,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>       vcpu->arch.sie_block->icpua = vcpu->vcpu_id;
>>       spin_lock_init(&vcpu->arch.local_int.lock);
>> -    vcpu->arch.sie_block->gd = 
>> (u32)(u64)vcpu->kvm->arch.gisa_int.origin;
>> -    if (vcpu->arch.sie_block->gd && sclp.has_gisaf)
>> -        vcpu->arch.sie_block->gd |= GISA_FORMAT1;
>> +    vcpu->arch.sie_block->gd = kvm_s390_get_gisa_desc(vcpu->kvm);
> 
> I like that way of handling the gisa setup of VCPUs

Thanks a lot Janosch, for providing review feedback on this item.

Michael

> 
>>       seqcount_init(&vcpu->arch.cputm_seqcount);
>>       vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index 098831e815e6..4ba8fc30d87a 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -231,6 +231,15 @@ static inline unsigned long 
>> kvm_s390_get_gfn_end(struct kvm_memslots *slots)
>>       return ms->base_gfn + ms->npages;
>>   }
>> +static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
>> +{
>> +    u32 gd = (u32)(u64)kvm->arch.gisa_int.origin;
>> +
>> +    if (gd && sclp.has_gisaf)
>> +        gd |= GISA_FORMAT1;
>> +    return gd;
>> +}
>> +
>>   /* implemented in pv.c */
>>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
>>   int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
>> @@ -450,6 +459,8 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu,
>>   void kvm_s390_gisa_init(struct kvm *kvm);
>>   void kvm_s390_gisa_clear(struct kvm *kvm);
>>   void kvm_s390_gisa_destroy(struct kvm *kvm);
>> +void kvm_s390_gisa_disable(struct kvm *kvm);
>> +void kvm_s390_gisa_enable(struct kvm *kvm);
>>   int kvm_s390_gib_init(u8 nisc);
>>   void kvm_s390_gib_destroy(void);
> 
