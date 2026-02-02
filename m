Return-Path: <kvm+bounces-69794-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YMWjE7ETgGm+2QIAu9opvQ
	(envelope-from <kvm+bounces-69794-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 04:02:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A18B1C7F50
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 04:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C537300A3B2
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 03:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B779721773F;
	Mon,  2 Feb 2026 03:01:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A781D5CEA;
	Mon,  2 Feb 2026 03:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770001312; cv=none; b=TJhldfElFH5xfD2TuhaqFFD8Cj5nR5vYFeaQhEEGpGnfWzcKAYKbhWbnDbVzI7V0YysYkOXlJ55Q15wZMObjzzDkPxd3CxlCOFVSzLBSlCWl9F8jN3plPR6Fxra+HbXZrEIf8MqC4Y3oNFbqkzySsGalqAa6F5ymDWBLg6k1mZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770001312; c=relaxed/simple;
	bh=WiXhFRtyB6TH2mQxUV6GDUuCbq5D2Mx+Ihocy5CMMhg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XjnHbM4SJZVNiR2leke9Qocyz5dRwFhiQJ/dNzPmfwqs9IqRCO+cLRW5g+GMHrMaA13oNqPE5iFcOnbNuhkexRIdc3f+l4eepjOu0UxDMUhVzU/LDntEKE+BLYa75iyHzhLskEg85wX0poMekg594ydgIHQccludN92Ko+XB57s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxXcOYE4BpGdcOAA--.48515S3;
	Mon, 02 Feb 2026 11:01:44 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBx78KRE4BpM8k9AA--.49717S3;
	Mon, 02 Feb 2026 11:01:40 +0800 (CST)
Subject: Re: [PATCH v3] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: liushuyu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260201072124.566587-1-liushuyu@aosc.io>
 <fe2dd7e1-4480-78e0-cfbd-4fc3574c589c@loongson.cn>
 <c35ba2fd-6fc2-4cbf-ba62-70dcfaac399c@aosc.io>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <5dfa6dd3-eefe-cdbc-6d6e-dd9e2385a8ec@loongson.cn>
Date: Mon, 2 Feb 2026 10:59:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <c35ba2fd-6fc2-4cbf-ba62-70dcfaac399c@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx78KRE4BpM8k9AA--.49717S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3AF4xCw1xZF18Jw48GFyUJwc_yoWxZFyxpr
	1kAFW5Xry5Grn3Cw1UWF1UXFyUAr18Ja1DXrn3X3W8Ar42yr12gr1jgryqgF1UJw48AF4j
	vr15XrnrursxJrgCm3ZEXasCq-sJn29KB7ZKAUJUUUUk529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	TAGGED_FROM(0.00)[bounces-69794-lists,kvm=lfdr.de];
	DMARC_NA(0.00)[loongson.cn];
	DBL_BLOCKED_OPENRESOLVER(0.00)[aosc.io:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A18B1C7F50
X-Rspamd-Action: no action



On 2026/2/2 上午10:41, liushuyu wrote:
> 
>>
>>
>> On 2026/2/1 下午3:21, Zixing Liu wrote:
>>> This ioctl can be used by the userspace applications to determine which
>>> (special) registers are get/set-able in a meaningful way.
>>>
>>> This can be very useful for cross-platform VMMs so that they do not have
>>> to hardcode register indices for each supported architectures.
>>>
>>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>>> ---
>>>    Documentation/virt/kvm/api.rst |  2 +-
>>>    arch/loongarch/kvm/vcpu.c      | 81 ++++++++++++++++++++++++++++++++++
>>>    2 files changed, 82 insertions(+), 1 deletion(-)
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
>>> index 656b954c1134..fb8001deadc9 100644
>>> --- a/arch/loongarch/kvm/vcpu.c
>>> +++ b/arch/loongarch/kvm/vcpu.c
>>> @@ -14,6 +14,8 @@
>>>    #define CREATE_TRACE_POINTS
>>>    #include "trace.h"
>>>    +#define NUM_LBT_REGS 6
>>> +
>>>    const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>>        KVM_GENERIC_VCPU_STATS(),
>>>        STATS_DESC_COUNTER(VCPU, int_exits),
>>> @@ -1186,6 +1188,67 @@ static int kvm_loongarch_vcpu_set_attr(struct
>>> kvm_vcpu *vcpu,
>>>        return ret;
>>>    }
>>>    +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64
>>> __user *uindices)
>>> +{
>>> +    unsigned int i, count;
>>> +
>>> +    for (i = 0, count = 0; i < CSR_MAX_NUMS; i++) {
>>> +        if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
>> My main concern is how to use KVM_GET_REG_LIST ioctl command, there
>> will be compatible issue if the detail use scenery about
>> KVM_GET_REG_LIST command is not clear.
>>
>> Can KVM_GET_REG_LIST ioctl command be used before vCPU feature
>> finalized? If not, it is only used after vCPU feature finalized, guest
>> CSR registers should base on vCPU features rather than host features.
>> Here get_gcsr_flag() is based on host features.
>>
> We can add a warning to the documentation saying using KVM_GET_REG_LIST
> before vCPU feature finalization is forbidden. This is how ARM
> implemented their thing (the documentation said "Other calls that depend
> on a particular feature being finalized, such as KVM_RUN,
> KVM_GET_REG_LIST, KVM_GET_ONE_REG and KVM_SET_ONE_REG, will fail with
> -EPERM unless the feature has already been finalized by means of a
> KVM_ARM_VCPU_FINALIZE call.") We can probably do the same.
> 
> What do you think? If you think this is acceptable, I can send a v4
> patch that adds a similar warning to the documentation.
No special document is need.

If KVM_GET_REG_LIST command is used after vCPU feature finalization, 
vCPU feature can be checked when KVM_GET_REG_LIST command is called.

Here funciton kvm_loongarch_walk_csrs() should be modified. 
get_gcsr_flag() is based on host HW feature rather than vCPU feature. 
For example VM can disable PMU/MSGINT features, so CSR registers 
relative with PMU/MSGINT should be listed based on vCPU features.

Regards
Bibo Mao
> 
>> Regards
>> Bibo Mao
> 
> Thanks,
> 
> Zixing
> 
>>> +            continue;
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
>>> @@ -1251,6 +1314,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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


