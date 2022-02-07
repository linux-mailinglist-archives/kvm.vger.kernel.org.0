Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3D94AC6FA
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 18:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382778AbiBGROw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 12:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387301AbiBGRKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:10:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DC1C0401D3;
        Mon,  7 Feb 2022 09:09:59 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217GxMvj010249;
        Mon, 7 Feb 2022 17:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3FjxNMvXlNero4e/ER7437DT1UsaGVh34ObnqTGS/4E=;
 b=CBnC385t7KviCamBHRKCmYxb0jDWrH18cdDgi5c6mQF9OhdOdBw9BmxAT9syQMKtFuVU
 7eQsaPeZqjwhtUjpE0ct6R08IKbkyDjw/IckNBanAjIRh3zdhX7+tGHaL6XeH9ojVoEU
 PZC9/YGrZ63LeK0WJHo0cRjJkspMGFofak0brUXteDzwnVQBQPA+PzTXOJDjFm1WREWT
 vCWpFa54VBhKGs6N8lL/2kGTEkMR1TVv+FJDfGRrO8+VL8iuX5mtwVretl6NgTT9cTbM
 HMuc8EIRAWPqii3WyCdtIXMfZvo1Y5GrT/xFDVir7XEWToqJgOMr6e3xnvbAMzgTIXRP FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e1huxcr7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:09:58 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217GxQvA011102;
        Mon, 7 Feb 2022 17:09:58 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e1huxcr76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:09:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217H87FL000806;
        Mon, 7 Feb 2022 17:09:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gv962gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:09:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217Gxlj547907276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 16:59:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 641E5A4054;
        Mon,  7 Feb 2022 17:09:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E62EBA405B;
        Mon,  7 Feb 2022 17:09:49 +0000 (GMT)
Received: from [9.145.45.120] (unknown [9.145.45.120])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 17:09:49 +0000 (GMT)
Message-ID: <ae7c65d8-f632-a7f4-926a-50b9660673a1@linux.ibm.com>
Date:   Mon, 7 Feb 2022 18:09:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH] KVM: s390: pv: make use of ultravisor AIV support
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220204085203.3490425-1-mimu@linux.ibm.com>
 <d986a43b-5828-8145-ff91-1a507434de8b@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <d986a43b-5828-8145-ff91-1a507434de8b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FCwMbyoVIsaJf82AXXQ_xKjCbh0UIOAF
X-Proofpoint-GUID: I9dXu9PIaTXoERG4JAYcDJYo8GwBM3JP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.02.22 12:12, Janosch Frank wrote:
> On 2/4/22 09:52, Michael Mueller wrote:
>> This patch enables the ultravisor adapter interruption vitualization
>> support indicated by UV feature BIT_UV_FEAT_AIV. This allows ISC
>> interruption injection directly into the GISA IPM for PV kvm guests.
>>
>> Hardware that does not support this feature will continue to use the
>> UV interruption interception method to deliver ISC interruptions to
>> PV kvm guests. For this purpose, the ECA_AIV bit for all guest cpus
>> will be cleared and the GISA will be disabled during PV guest setup.
>>
>> In addition a check in __inject_io() has been removed. That reduces the
>> required intructions for interruption handling for PV and traditional
>> kvm guests.
>>
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/uv.h |  1 +
>>   arch/s390/kvm/interrupt.c  | 53 +++++++++++++++++++++++++++++++++-----
>>   arch/s390/kvm/kvm-s390.c   | 10 ++++---
>>   arch/s390/kvm/kvm-s390.h   | 11 ++++++++
>>   4 files changed, 66 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 72d3e49c2860..0cb2bbb50ad7 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -80,6 +80,7 @@ enum uv_cmds_inst {
>>   enum uv_feat_ind {
>>       BIT_UV_FEAT_MISC = 0,
>> +    BIT_UV_FEAT_AIV = 1,
>>   };
>>   struct uv_cb_header {
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index c3bd993fdd0c..6ff80069b1fe 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -1900,13 +1900,12 @@ static int __inject_io(struct kvm *kvm, struct 
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
> 
> This was previously fenced by the UV by ignoring the gd altogether, right?

Right, the z15 UV is ignoring gd altogether. That's the reason
we made the exception for PV guests here. That is now released
and included in the gd value (i.e. gi->origin)

> 
>>           VM_EVENT(kvm, 4, "%s isc %1u", "inject: I/O (AI/gisa)", isc);
>>           gisa_set_ipm_gisc(gi->origin, isc);
>>           kfree(inti);
>> @@ -3163,9 +3162,32 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>>       VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
>>   }
>> +void kvm_s390_gisa_enable(struct kvm *kvm)
>> +{
>> +    struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>> +    struct kvm_vcpu *vcpu;
>> +    int i;
>> +
>> +    if (gi->origin)
>> +        return;
>> +    kvm_s390_gisa_init(kvm);
>> +    kvm_for_each_vcpu(i, vcpu, kvm) {
>> +        mutex_lock(&vcpu->mutex);
>> +        vcpu->arch.sie_block->gd = kvm_s390_get_gisa_desc(kvm);
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
>>   void kvm_s390_gisa_destroy(struct kvm *kvm)
>>   {
>>       struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>> +    struct kvm_s390_gisa *gisa = gi->origin;
>>       if (!gi->origin)
>>           return;
>> @@ -3176,6 +3198,25 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
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
>> +    int i;
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
>> index 14a18ba5ff2c..8839a58e03c7 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2273,6 +2273,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, 
>> struct kvm_pv_cmd *cmd)
>>           if (r)
>>               break;
>> +        if (!test_bit_inv(BIT_UV_FEAT_AIV, 
>> &uv_info.uv_feature_indications))
>> +            kvm_s390_gisa_disable(kvm);
>> +
> 
> If the kvm_s390_cpus_to_pv() fails we'd miss a gisa_enable(), no? >
> And we might have a problem in kvm_s390_vcpu_setup() as we don't fence 
> it for new cpus.

I guess we then need it for both failing cases pv_init_vm()
and cpus_to_pv(). But I have to verify with UVC_CMD_CREATE_SEC_CONF.
It might be possible to disable the gisa after that UVC call.

> 
> 
>>           r = kvm_s390_pv_init_vm(kvm, &cmd->rc, &cmd->rrc);
>>           if (r)
>>               break;
>> @@ -2300,6 +2303,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, 
>> struct kvm_pv_cmd *cmd)
>>               break;
>>           r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
>> +        if (use_gisa)
>> +            kvm_s390_gisa_enable(kvm);
>> +
>>           /* no need to block service interrupts any more */
>>           clear_bit(IRQ_PEND_EXT_SERVICE, 
>> &kvm->arch.float_int.masked_irqs);
>>           break;
>> @@ -3309,9 +3315,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>       vcpu->arch.sie_block->icpua = vcpu->vcpu_id;
>>       spin_lock_init(&vcpu->arch.local_int.lock);
>> -    vcpu->arch.sie_block->gd = 
>> (u32)(u64)vcpu->kvm->arch.gisa_int.origin;
>> -    if (vcpu->arch.sie_block->gd && sclp.has_gisaf)
>> -        vcpu->arch.sie_block->gd |= GISA_FORMAT1;
>> +    vcpu->arch.sie_block->gd = kvm_s390_get_gisa_desc(vcpu->kvm);
>>       seqcount_init(&vcpu->arch.cputm_seqcount);
>>       vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index c07a050d757d..08a622a44f6f 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -217,6 +217,15 @@ static inline void 
>> kvm_s390_set_user_cpu_state_ctrl(struct kvm *kvm)
>>       kvm->arch.user_cpu_state_ctrl = 1;
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
>> @@ -435,6 +444,8 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu,
>>   void kvm_s390_gisa_init(struct kvm *kvm);
>>   void kvm_s390_gisa_clear(struct kvm *kvm);
>>   void kvm_s390_gisa_destroy(struct kvm *kvm);
>> +void kvm_s390_gisa_disable(struct kvm *kvm);
>> +void kvm_s390_gisa_enable(struct kvm *kvm);
>>   int kvm_s390_gib_init(u8 nisc);
>>   void kvm_s390_gib_destroy(void);
>>
> 
