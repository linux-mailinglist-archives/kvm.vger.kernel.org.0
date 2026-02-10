Return-Path: <kvm+bounces-70692-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mI2/Cz6qimmbMwAAu9opvQ
	(envelope-from <kvm+bounces-70692-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 04:47:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B504C116CAE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 04:47:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C227C3016EDE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 03:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9892DAFD5;
	Tue, 10 Feb 2026 03:46:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1385935957;
	Tue, 10 Feb 2026 03:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770695212; cv=none; b=D0k69yVlROuGzzd4iAcBEYqtI07K4iAfMiuSDKih4ygh/6TKt/xHBd2mp1v/q5JF3IOODUQzv0zA1EqYcnNKKxKz34U2w69qB9zJ2ddlvEj3iiBaROml2TjJb3fX7/Dm6oq2oOklW7Puj+NoixLSqHT/PSVEEg0qWg1u41wgC14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770695212; c=relaxed/simple;
	bh=2rvuAFwQWpWN9yUKVZ2ekarok8z+5Mzo/tb7DQ8eNn4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LTD3eHD6KCU49gYwyuDyR0o2ehzfqvreTsoOC0m8WOH5c2B+Gbq/qbqdOGJFsf/x0EMxc51dSBc3nJ1dt54zK+Zotg7Qk8cHO0iUMA1wsO34n6ZqDGfsAH4sQFzX15FEz5EOeL2+J7mENVXnSmlT/Sy7QARnZvu63OCaELGm/G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxVcEhqopp9E0RAA--.8132S3;
	Tue, 10 Feb 2026 11:46:41 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxbcIUqopp5qVDAA--.58697S3;
	Tue, 10 Feb 2026 11:46:32 +0800 (CST)
Subject: Re: [PATCH v5] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: liushuyu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260205051822.1318253-1-liushuyu@aosc.io>
 <aa35c7a6-6361-9f83-a726-89d7deff8560@loongson.cn>
 <c4be7e68-6e51-4f2b-8a51-bef658a8ac4a@aosc.io>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <f4ba7538-e413-d8c8-d4b6-7c8686c4aec6@loongson.cn>
Date: Tue, 10 Feb 2026 11:43:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <c4be7e68-6e51-4f2b-8a51-bef658a8ac4a@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxbcIUqopp5qVDAA--.58697S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxuw17Gw43uw15Kr1UtrykXrc_yoWDGw1fpr
	1kKFWUJry5Jrn3Jr1j9r1UuFyUAF1xJa1DXr18XF47JrsrAry2gr1jqr1v9F15Jr4kJr1U
	Ar1UZwnxur4fJ3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUk529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1q6r43M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVW8ZVWrXwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jTq2NUUU
	UU=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70692-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: B504C116CAE
X-Rspamd-Action: no action



On 2026/2/10 上午11:23, liushuyu wrote:
> Hi Bibo,
> 
>>
>>
>> On 2026/2/5 下午1:18, Zixing Liu wrote:
>>> This ioctl can be used by the userspace applications to determine which
>>> (special) registers are get/set-able in a meaningful way.
>>>
>>> This can be very useful for cross-platform VMMs so that they do not have
>>> to hardcode register indices for each supported architectures.
>>>
>>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>>> ---
>>>    Documentation/virt/kvm/api.rst |   2 +-
>>>    arch/loongarch/kvm/vcpu.c      | 120 +++++++++++++++++++++++++++++++++
>>>    2 files changed, 121 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst
>>> b/Documentation/virt/kvm/api.rst
>>> index 01a3abef8abb..f46dd8be282f 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>>    ---------------------
>>>      :Capability: basic
>>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>>    :Type: vcpu ioctl
>>>    :Parameters: struct kvm_reg_list (in/out)
>>>    :Returns: 0 on success; -1 on error
>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>> index 656b954c1134..de02e409ae39 100644
>>> --- a/arch/loongarch/kvm/vcpu.c
>>> +++ b/arch/loongarch/kvm/vcpu.c
>>> @@ -5,6 +5,7 @@
>>>      #include <linux/kvm_host.h>
>>>    #include <asm/fpu.h>
>>> +#include <asm/kvm_host.h>
>>>    #include <asm/lbt.h>
>>>    #include <asm/loongarch.h>
>>>    #include <asm/setup.h>
>>> @@ -14,6 +15,8 @@
>>>    #define CREATE_TRACE_POINTS
>>>    #include "trace.h"
>>>    +#define NUM_LBT_REGS 6
>>> +
>>>    const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>>        KVM_GENERIC_VCPU_STATS(),
>>>        STATS_DESC_COUNTER(VCPU, int_exits),
>>> @@ -1186,6 +1189,105 @@ static int kvm_loongarch_vcpu_set_attr(struct
>>> kvm_vcpu *vcpu,
>>>        return ret;
>>>    }
>>>    +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64
>>> __user *uindices)
>>> +{
>>> +    unsigned int i, count;
>>> +    const unsigned int csrs_to_save[] = {
>>> +        LOONGARCH_CSR_CRMD,      LOONGARCH_CSR_PRMD,
>>> +        LOONGARCH_CSR_EUEN,      LOONGARCH_CSR_MISC,
>>> +        LOONGARCH_CSR_ECFG,      LOONGARCH_CSR_ESTAT,
>>> +        LOONGARCH_CSR_ERA,      LOONGARCH_CSR_BADV,
>>> +        LOONGARCH_CSR_BADI,      LOONGARCH_CSR_EENTRY,
>>> +        LOONGARCH_CSR_TLBIDX,      LOONGARCH_CSR_TLBEHI,
>>> +        LOONGARCH_CSR_TLBELO0,      LOONGARCH_CSR_TLBELO1,
>>> +        LOONGARCH_CSR_ASID,      LOONGARCH_CSR_PGDL,
>>> +        LOONGARCH_CSR_PGDH,      LOONGARCH_CSR_PGD,
>>> +        LOONGARCH_CSR_PWCTL0,      LOONGARCH_CSR_PWCTL1,
>>> +        LOONGARCH_CSR_STLBPGSIZE, LOONGARCH_CSR_RVACFG,
>>> +        LOONGARCH_CSR_CPUID,      LOONGARCH_CSR_PRCFG1,
>>> +        LOONGARCH_CSR_PRCFG2,      LOONGARCH_CSR_PRCFG3,
>>> +        LOONGARCH_CSR_KS0,      LOONGARCH_CSR_KS1,
>>> +        LOONGARCH_CSR_KS2,      LOONGARCH_CSR_KS3,
>>> +        LOONGARCH_CSR_KS4,      LOONGARCH_CSR_KS5,
>>> +        LOONGARCH_CSR_KS6,      LOONGARCH_CSR_KS7,
>>> +        LOONGARCH_CSR_TMID,      LOONGARCH_CSR_CNTC,
>>> +        LOONGARCH_CSR_TINTCLR,      LOONGARCH_CSR_LLBCTL,
>>> +        LOONGARCH_CSR_IMPCTL1,      LOONGARCH_CSR_IMPCTL2,
>>> +        LOONGARCH_CSR_TLBRENTRY,  LOONGARCH_CSR_TLBRBADV,
>>> +        LOONGARCH_CSR_TLBRERA,      LOONGARCH_CSR_TLBRSAVE,
>>> +        LOONGARCH_CSR_TLBRELO0,      LOONGARCH_CSR_TLBRELO1,
>>> +        LOONGARCH_CSR_TLBREHI,      LOONGARCH_CSR_TLBRPRMD,
>>> +        LOONGARCH_CSR_DMWIN0,      LOONGARCH_CSR_DMWIN1,
>>> +        LOONGARCH_CSR_DMWIN2,      LOONGARCH_CSR_DMWIN3,
>>> +        LOONGARCH_CSR_TVAL,      LOONGARCH_CSR_TCFG,
>>> +    };
>> this increases much kernel stack size usage :)
>>
>> Please wait a moment, I am considering how to cleanup code about CSR
>> registers.
> Okay.
>> And KVM_GET_REG_LIST is not so urgent, else there is
>> KVM_read_from_REG_LIST/KVM_write_from_REG_LIST ioctl commands to
>> access registers in batch mode.
>>
> Adding KVM_GET_REG_LIST is not urgent. However, unlike
> KVM_read_from_REG_LIST and KVM_write_from_REG_LIST, KVM_GET_REG_LIST
> serves a different purpose.
> 
> The KVM_GET_REG_LIST ioctl lets user-space VMMs determine the number of
> get/set-able registers (via KVM_GET_ONE_REG/KVM_SET_ONE_REG) and their
> register IDs. User-space VMMs use this ioctl so they don't have to
> hardcode a register ID table for each architecture.
In theory it is so, I only know QEMU VMM now, is there other VMMs which 
does not use hardcoded register ID for different architecture? Which one 
if there is actually. There is some potential issues by my knowledge 
such as:
1. How to solve the compatible issue if KVM_GET_REG_LIST does not support?
2. How to solve dependency between registers? Dependency should be 
solved in VMM or KVM hypervisr.

Regards
Bibo Mao
> 
> I also had trouble finding information on the KVM_read_from_REG_LIST and
> KVM_write_from_REG_LIST ioctl commands. As of commit
> 3d29a326eba82d987a82fd59379d6d668b769965, I could not find any logic or
> identifiers for these two ioctls.
> 
> In some cases, KVM_GET_REG_LIST is a prerequisite for using
> KVM_read_from_REG_LIST or KVM_write_from_REG_LIST (assuming they exist),
> as you still need to know the register IDs to use these ioctls.
> 
>> Regards
>> Bibo Mao
>>
>>> +
>>> +    for (i = 0, count = 0;
>>> +         i < sizeof(csrs_to_save) / sizeof(csrs_to_save[0]); i++) {
>>> +        const u64 reg = KVM_IOC_CSRID(i);
>>> +        if (uindices && put_user(reg, uindices++))
>>> +            return -EFAULT;
>>> +        count++;
>>> +    }
>>> +
>>> +    /* Skip PMU CSRs if not supported by the guest */
>>> +    if (!kvm_guest_has_pmu(&vcpu->arch))
>>> +        return count;
>>> +    for (i = LOONGARCH_CSR_PERFCTRL0; i <= LOONGARCH_CSR_PERFCNTR3;
>>> i++) {
>>> +        const u64 reg = KVM_IOC_CSRID(i);
>>> +        if (uindices && put_user(reg, uindices++))
>>> +            return -EFAULT;
>>> +        count++;
>>> +    }
>>> +
>>> +    return count;
>>> +}
>>> +
>>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>>> +{
>>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>>> +    unsigned long res =
>>> +        kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS + 1;
>>> +
>>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>>> +        res += NUM_LBT_REGS;
>>> +
>>> +    return res;
>>> +}
>>> +
>>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>>> +                      u64 __user *uindices)
>>> +{
>>> +    u64 reg;
>>> +    unsigned int i;
>>> +
>>> +    i = kvm_loongarch_walk_csrs(vcpu, uindices);
>>> +    if (i < 0)
>>> +        return i;
>>> +    uindices += i;
>>> +
>>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>>> +        reg = KVM_IOC_CPUCFG(i);
>>> +        if (put_user(reg, uindices++))
>>> +            return -EFAULT;
>>> +    }
>>> +
>>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>>> +    if (put_user(reg, uindices++))
>>> +        return -EFAULT;
>>> +
>>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>>> +        return 0;
>>> +
>>> +    for (i = 1; i <= NUM_LBT_REGS; i++) {
>>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>>> +        if (put_user(reg, uindices++))
>>> +            return -EFAULT;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>    long kvm_arch_vcpu_ioctl(struct file *filp,
>>>                 unsigned int ioctl, unsigned long arg)
>>>    {
>>> @@ -1251,6 +1353,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>            r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>>            break;
>>>        }
>>> +    case KVM_GET_REG_LIST: {
>>> +        struct kvm_reg_list __user *user_list = argp;
>>> +        struct kvm_reg_list reg_list;
>>> +        unsigned n;
>>> +
>>> +        r = -EFAULT;
>>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>>> +            break;
>>> +        n = reg_list.n;
>>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>>> +            break;
>>> +        r = -E2BIG;
>>> +        if (n < reg_list.n)
>>> +            break;
>>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>>> +        break;
>>> +    }
>>>        default:
>>>            r = -ENOIOCTLCMD;
>>>            break;
>>>
>>
> Thanks,
> Zixing
> 


