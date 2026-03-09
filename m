Return-Path: <kvm+bounces-73258-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEddJLdprmkGEAIAu9opvQ
	(envelope-from <kvm+bounces-73258-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 07:33:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB2423436C
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 07:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 47058301D4FF
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 06:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C677935BDCE;
	Mon,  9 Mar 2026 06:33:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEFF1F5842;
	Mon,  9 Mar 2026 06:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773037997; cv=none; b=D+hBef+lnWkxSYgLEudicOkkAsxfKeiy5wgnKgcodyiBNMrLZEShWKMrBBZ69VAyD3ajKUA6E/J5P5Gpgnh+eVb2ijq8W1aNSpjvXYQ494evK/BTusko1rynIQdy4h/E5iuRQYhbGUejmNK2SILMv+/WC5tnXWObICBtZsUeHQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773037997; c=relaxed/simple;
	bh=E6OZ23QMvacHQO1I32Up8jILXOBz36pApBUctSDCX+c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Zs0Djsop6H5JsmhpJ4ONBSvivR8mCWJTScb0IeNbAAhBzLVaIUB4QbsaOul5pboLpO0IJn2IEbLHxiQTUNBKRk0bJ00B0WWOshp2oatd7CVHggJ6YsZ45FoHl6Stq/mz0w+kSdNjI2P0vD+i2k8kG7XHwPMdwXlNNv/04MgAAGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxccCeaa5pbdAYAA--.14591S3;
	Mon, 09 Mar 2026 14:33:03 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBx78KLaa5pRyBRAA--.23913S3;
	Mon, 09 Mar 2026 14:32:46 +0800 (CST)
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
 <f4ba7538-e413-d8c8-d4b6-7c8686c4aec6@loongson.cn>
 <f39c14fc-6fe9-4478-b595-b7480f859443@aosc.io>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <0b7652eb-ac94-b877-39a1-86e5ee576d4c@loongson.cn>
Date: Mon, 9 Mar 2026 14:30:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f39c14fc-6fe9-4478-b595-b7480f859443@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx78KLaa5pRyBRAA--.23913S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoWfGw17Zw17GryfKrWrtr4kKrX_yoW8JFy7to
	WUKw4fJr15Xr1j9r1UJ3yDJFWay3W7Grn7tryUGryxAr10y3W5A34UJ34UKay7Wr18Kr1U
	JFyUJFyDZFWUXr15l-sFpf9Il3svdjkaLaAFLSUrUUUUYb8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUO07kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUstxhDU
	UUU
X-Rspamd-Queue-Id: 0DB2423436C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	NEURAL_SPAM(0.00)[0.029];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73258-lists,kvm=lfdr.de];
	DMARC_NA(0.00)[loongson.cn];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,loongson.cn:mid]
X-Rspamd-Action: no action



On 2026/3/9 上午11:52, liushuyu wrote:
> Hi Bibo,
> 
> It seems like my last email might have got bounced or landed in your
> spam filter.
> 
> So this email is a re-send of the last one.
> 
>> On 2026/2/10 上午11:23, liushuyu wrote:
>>> Hi Bibo,
>>>
>>>>
>>>> On 2026/2/5 下午1:18, Zixing Liu wrote:
>>>>> This ioctl can be used by the userspace applications to determine
>>>>> which
>>>>> (special) registers are get/set-able in a meaningful way.
>>>>>
>>>>> This can be very useful for cross-platform VMMs so that they do not
>>>>> have
>>>>> to hardcode register indices for each supported architectures.
>>>>>
>>>>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>>>>> ---
>>>>>     Documentation/virt/kvm/api.rst |   2 +-
>>>>>     arch/loongarch/kvm/vcpu.c      | 120
>>>>> +++++++++++++++++++++++++++++++++
>>>>>     2 files changed, 121 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/virt/kvm/api.rst
>>>>> b/Documentation/virt/kvm/api.rst
>>>>> index 01a3abef8abb..f46dd8be282f 100644
>>>>> --- a/Documentation/virt/kvm/api.rst
>>>>> +++ b/Documentation/virt/kvm/api.rst
>>>>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>>>>     ---------------------
>>>>>       :Capability: basic
>>>>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>>>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if
>>>>> KVM_CAP_ONE_REG)
>>>>>     :Type: vcpu ioctl
>>>>>     :Parameters: struct kvm_reg_list (in/out)
>>>>>     :Returns: 0 on success; -1 on error
>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>> index 656b954c1134..de02e409ae39 100644
>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>> @@ -5,6 +5,7 @@
>>>>>       #include <linux/kvm_host.h>
>>>>>     #include <asm/fpu.h>
>>>>> +#include <asm/kvm_host.h>
>>>>>     #include <asm/lbt.h>
>>>>>     #include <asm/loongarch.h>
>>>>>     #include <asm/setup.h>
>>>>> @@ -14,6 +15,8 @@
>>>>>     #define CREATE_TRACE_POINTS
>>>>>     #include "trace.h"
>>>>>     +#define NUM_LBT_REGS 6
>>>>> +
>>>>>     const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>>>>         KVM_GENERIC_VCPU_STATS(),
>>>>>         STATS_DESC_COUNTER(VCPU, int_exits),
>>>>> @@ -1186,6 +1189,105 @@ static int kvm_loongarch_vcpu_set_attr(struct
>>>>> kvm_vcpu *vcpu,
>>>>>         return ret;
>>>>>     }
>>>>>     +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64
>>>>> __user *uindices)
>>>>> +{
>>>>> +    unsigned int i, count;
>>>>> +    const unsigned int csrs_to_save[] = {
>>>>> +        LOONGARCH_CSR_CRMD,      LOONGARCH_CSR_PRMD,
>>>>> +        LOONGARCH_CSR_EUEN,      LOONGARCH_CSR_MISC,
>>>>> +        LOONGARCH_CSR_ECFG,      LOONGARCH_CSR_ESTAT,
>>>>> +        LOONGARCH_CSR_ERA,      LOONGARCH_CSR_BADV,
>>>>> +        LOONGARCH_CSR_BADI,      LOONGARCH_CSR_EENTRY,
>>>>> +        LOONGARCH_CSR_TLBIDX,      LOONGARCH_CSR_TLBEHI,
>>>>> +        LOONGARCH_CSR_TLBELO0,      LOONGARCH_CSR_TLBELO1,
>>>>> +        LOONGARCH_CSR_ASID,      LOONGARCH_CSR_PGDL,
>>>>> +        LOONGARCH_CSR_PGDH,      LOONGARCH_CSR_PGD,
>>>>> +        LOONGARCH_CSR_PWCTL0,      LOONGARCH_CSR_PWCTL1,
>>>>> +        LOONGARCH_CSR_STLBPGSIZE, LOONGARCH_CSR_RVACFG,
>>>>> +        LOONGARCH_CSR_CPUID,      LOONGARCH_CSR_PRCFG1,
>>>>> +        LOONGARCH_CSR_PRCFG2,      LOONGARCH_CSR_PRCFG3,
>>>>> +        LOONGARCH_CSR_KS0,      LOONGARCH_CSR_KS1,
>>>>> +        LOONGARCH_CSR_KS2,      LOONGARCH_CSR_KS3,
>>>>> +        LOONGARCH_CSR_KS4,      LOONGARCH_CSR_KS5,
>>>>> +        LOONGARCH_CSR_KS6,      LOONGARCH_CSR_KS7,
>>>>> +        LOONGARCH_CSR_TMID,      LOONGARCH_CSR_CNTC,
>>>>> +        LOONGARCH_CSR_TINTCLR,      LOONGARCH_CSR_LLBCTL,
>>>>> +        LOONGARCH_CSR_IMPCTL1,      LOONGARCH_CSR_IMPCTL2,
>>>>> +        LOONGARCH_CSR_TLBRENTRY,  LOONGARCH_CSR_TLBRBADV,
>>>>> +        LOONGARCH_CSR_TLBRERA,      LOONGARCH_CSR_TLBRSAVE,
>>>>> +        LOONGARCH_CSR_TLBRELO0,      LOONGARCH_CSR_TLBRELO1,
>>>>> +        LOONGARCH_CSR_TLBREHI,      LOONGARCH_CSR_TLBRPRMD,
>>>>> +        LOONGARCH_CSR_DMWIN0,      LOONGARCH_CSR_DMWIN1,
>>>>> +        LOONGARCH_CSR_DMWIN2,      LOONGARCH_CSR_DMWIN3,
>>>>> +        LOONGARCH_CSR_TVAL,      LOONGARCH_CSR_TCFG,
>>>>> +    };
>>>> this increases much kernel stack size usage :)
>>>>
>>>> Please wait a moment, I am considering how to cleanup code about CSR
>>>> registers.
>>> Okay.
> 
> I am also very interested in how this CSR register logic clean-up would
> work.
> 
> Can you share some details regarding this clean-up?
> 
There are some pending issues unsolved, such as _kvm_getcsr() with id == 
LOONGARCH_CSR_ESTAT case.
It is obvious improper to add vcpu_load()/vcpu_put() here with get_csr() 
register.

>>>> And KVM_GET_REG_LIST is not so urgent, else there is
>>>> KVM_read_from_REG_LIST/KVM_write_from_REG_LIST ioctl commands to
>>>> access registers in batch mode.
>>>>
>>> Adding KVM_GET_REG_LIST is not urgent. However, unlike
>>> KVM_read_from_REG_LIST and KVM_write_from_REG_LIST, KVM_GET_REG_LIST
>>> serves a different purpose.
>>>
>>> The KVM_GET_REG_LIST ioctl lets user-space VMMs determine the number of
>>> get/set-able registers (via KVM_GET_ONE_REG/KVM_SET_ONE_REG) and their
>>> register IDs. User-space VMMs use this ioctl so they don't have to
>>> hardcode a register ID table for each architecture.
>> In theory it is so, I only know QEMU VMM now, is there other VMMs
>> which does not use hardcoded register ID for different architecture?
>> Which one if there is actually.
> There is https://github.com/firecracker-microvm/firecracker (from
> Amazon), which uses https://github.com/rust-vmm/kvm as the VMM library
> (which uses the KVM_GET_REG_LIST ioctl to determine how many registers
> to save).
>> There is some potential issues by my knowledge such as:
>> 1. How to solve the compatible issue if KVM_GET_REG_LIST does not
>> support?
> I agree this could be an issue for LoongArch as we are trying to add
> this ioctl very late. I am guessing we either tell the user that you
> will need to use Linux 7.1 or something for this to work; or, for older
> kernel versions, we have to resort to embedding a table in the
> user-space VMM (and maybe remove it after a few years). For other
> architectures, they implemented it somewhat early and did not have this
> issue.
I agree with this, the compatible issue only can be solved with time 
pass away until old kernel is not supported.
>> 2. How to solve dependency between registers? Dependency should be
>> solved in VMM or KVM hypervisr.
> If the dependency issue can be solved by simply re-ordering the register
> IDs in the list returned to the user space, we can help the user space
> VMM by sorting the list to the correct order when the kernel-side is
> walking the CSR list (for instance, put the registers that require other
> registers to be saved last). If that is not the case, we will need to
> add a paragraph to the KVM documentation explaining how to properly
> interpret the list returned by this ioctl.
There may be different dependency issues regarding read access and write 
access, do you agree that? How to solve it.

The important thing is that I think this requirement is not urgent and 
old method can work. The new API is not so matured  and also it will 
bring unexpected compatible issue. So I suggest that it need more time.

Maybe you think that it is important. I have such experience also, every 
time when I submit one patch, I think it is important. Indeed without 
the patch or the patch is submit after months, the world still works well :)

Regards
Bibo Mao

>> Regards
>> Bibo Mao
>>> I also had trouble finding information on the KVM_read_from_REG_LIST and
>>> KVM_write_from_REG_LIST ioctl commands. As of commit
>>> 3d29a326eba82d987a82fd59379d6d668b769965, I could not find any logic or
>>> identifiers for these two ioctls.
>>>
>>> In some cases, KVM_GET_REG_LIST is a prerequisite for using
>>> KVM_read_from_REG_LIST or KVM_write_from_REG_LIST (assuming they exist),
>>> as you still need to know the register IDs to use these ioctls.
>>>
>>>> Regards
>>>> Bibo Mao
>>>>
>>>>> +
>>>>> +    for (i = 0, count = 0;
>>>>> +         i < sizeof(csrs_to_save) / sizeof(csrs_to_save[0]); i++) {
>>>>> +        const u64 reg = KVM_IOC_CSRID(i);
>>>>> +        if (uindices && put_user(reg, uindices++))
>>>>> +            return -EFAULT;
>>>>> +        count++;
>>>>> +    }
>>>>> +
>>>>> +    /* Skip PMU CSRs if not supported by the guest */
>>>>> +    if (!kvm_guest_has_pmu(&vcpu->arch))
>>>>> +        return count;
>>>>> +    for (i = LOONGARCH_CSR_PERFCTRL0; i <= LOONGARCH_CSR_PERFCNTR3;
>>>>> i++) {
>>>>> +        const u64 reg = KVM_IOC_CSRID(i);
>>>>> +        if (uindices && put_user(reg, uindices++))
>>>>> +            return -EFAULT;
>>>>> +        count++;
>>>>> +    }
>>>>> +
>>>>> +    return count;
>>>>> +}
>>>>> +
>>>>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>>>>> +    unsigned long res =
>>>>> +        kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS
>>>>> + 1;
>>>>> +
>>>>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>>>>> +        res += NUM_LBT_REGS;
>>>>> +
>>>>> +    return res;
>>>>> +}
>>>>> +
>>>>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>>>>> +                      u64 __user *uindices)
>>>>> +{
>>>>> +    u64 reg;
>>>>> +    unsigned int i;
>>>>> +
>>>>> +    i = kvm_loongarch_walk_csrs(vcpu, uindices);
>>>>> +    if (i < 0)
>>>>> +        return i;
>>>>> +    uindices += i;
>>>>> +
>>>>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>>>>> +        reg = KVM_IOC_CPUCFG(i);
>>>>> +        if (put_user(reg, uindices++))
>>>>> +            return -EFAULT;
>>>>> +    }
>>>>> +
>>>>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>>>>> +    if (put_user(reg, uindices++))
>>>>> +        return -EFAULT;
>>>>> +
>>>>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>>>>> +        return 0;
>>>>> +
>>>>> +    for (i = 1; i <= NUM_LBT_REGS; i++) {
>>>>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>>>>> +        if (put_user(reg, uindices++))
>>>>> +            return -EFAULT;
>>>>> +    }
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>>     long kvm_arch_vcpu_ioctl(struct file *filp,
>>>>>                  unsigned int ioctl, unsigned long arg)
>>>>>     {
>>>>> @@ -1251,6 +1353,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>>>             r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>>>>             break;
>>>>>         }
>>>>> +    case KVM_GET_REG_LIST: {
>>>>> +        struct kvm_reg_list __user *user_list = argp;
>>>>> +        struct kvm_reg_list reg_list;
>>>>> +        unsigned n;
>>>>> +
>>>>> +        r = -EFAULT;
>>>>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>>>>> +            break;
>>>>> +        n = reg_list.n;
>>>>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>>>>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>>>>> +            break;
>>>>> +        r = -E2BIG;
>>>>> +        if (n < reg_list.n)
>>>>> +            break;
>>>>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>>>>> +        break;
>>>>> +    }
>>>>>         default:
>>>>>             r = -ENOIOCTLCMD;
>>>>>             break;
>>>>>
>>>>
>>> Thanks,
>>> Zixing
>>>
>>
> Thanks,
> Zixing
> 


