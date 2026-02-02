Return-Path: <kvm+bounces-69793-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIwmO+wOgGmk2AIAu9opvQ
	(envelope-from <kvm+bounces-69793-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 03:41:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 502F3C7EA6
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 03:41:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 96F1B300A3BC
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 02:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1DA21D3DC;
	Mon,  2 Feb 2026 02:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="Z0c9f/IN"
X-Original-To: kvm@vger.kernel.org
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.113.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED781D7E42;
	Mon,  2 Feb 2026 02:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.182.113.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770000082; cv=none; b=bxAKFTLCfhd3lYhcFHmYSNPCAcns3gYL93ZfwJNT1NlTzVpy4HwVKaDiddNMMnEKKJapC2wTnFmeH4fiGUcph9uHG2CGzsLaeiXlqOMMD83euLHrkuriuYsT914PGIyjGTI877u3SRuuZolvkPMtP7SakGzl58xHVBDyf5GRldg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770000082; c=relaxed/simple;
	bh=Okg8nM8RIwPGp3XMtAzUD+/PFxdQrarB/WAD0TjxvLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UW2GeUlmCQTFtOYPcMFTx6Q1z7qdYHO1+WJClI3W8a9E34AS3kiVKGav53kTAgitEdiAylwbcsxVYM1/aS3hmTQYt+boDZWu16psxZtepluFcgEFO7SQVr9j8fEBnyvd1YeCJW96POrFcRyYhTms9ZI33tmd39MtU9TSNW48/Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=Z0c9f/IN; arc=none smtp.client-ip=217.182.113.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay2.mymailcheap.com (Postfix) with ESMTPS id 599A33E878;
	Mon,  2 Feb 2026 02:41:13 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id 91C62400D6;
	Mon,  2 Feb 2026 02:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1770000072; bh=Okg8nM8RIwPGp3XMtAzUD+/PFxdQrarB/WAD0TjxvLE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z0c9f/INbi3qUe6D8KSM6UFdJ4I9bb1PtE6bfnp24TuvIoxWYNKGBwI9o8yGcxGdm
	 719IqekMDL4n7LogoHyDTJ25LQSq5YKL5OekRn3MKK50W1emnNvgQEOSCS7aEdHTQ4
	 zXb0K5/dmpLRza2HNfN5MJhxi1vbB4FmlR3khX1I=
Received: from [127.0.0.1] (unknown [117.151.13.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 4F7214017F;
	Mon,  2 Feb 2026 02:41:08 +0000 (UTC)
Message-ID: <c35ba2fd-6fc2-4cbf-ba62-70dcfaac399c@aosc.io>
Date: Mon, 2 Feb 2026 10:41:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
Content-Language: en-US-large, en-US
To: Bibo Mao <maobibo@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
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
From: liushuyu <liushuyu@aosc.io>
In-Reply-To: <fe2dd7e1-4480-78e0-cfbd-4fc3574c589c@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[aosc.io:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69793-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[aosc.io];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[aosc.io:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[aosc.io:email,aosc.io:dkim,aosc.io:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 502F3C7EA6
X-Rspamd-Action: no action


>
>
> On 2026/2/1 下午3:21, Zixing Liu wrote:
>> This ioctl can be used by the userspace applications to determine which
>> (special) registers are get/set-able in a meaningful way.
>>
>> This can be very useful for cross-platform VMMs so that they do not have
>> to hardcode register indices for each supported architectures.
>>
>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>> ---
>>   Documentation/virt/kvm/api.rst |  2 +-
>>   arch/loongarch/kvm/vcpu.c      | 81 ++++++++++++++++++++++++++++++++++
>>   2 files changed, 82 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst
>> b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..f46dd8be282f 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>   ---------------------
>>     :Capability: basic
>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_reg_list (in/out)
>>   :Returns: 0 on success; -1 on error
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 656b954c1134..fb8001deadc9 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -14,6 +14,8 @@
>>   #define CREATE_TRACE_POINTS
>>   #include "trace.h"
>>   +#define NUM_LBT_REGS 6
>> +
>>   const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>       KVM_GENERIC_VCPU_STATS(),
>>       STATS_DESC_COUNTER(VCPU, int_exits),
>> @@ -1186,6 +1188,67 @@ static int kvm_loongarch_vcpu_set_attr(struct
>> kvm_vcpu *vcpu,
>>       return ret;
>>   }
>>   +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64
>> __user *uindices)
>> +{
>> +    unsigned int i, count;
>> +
>> +    for (i = 0, count = 0; i < CSR_MAX_NUMS; i++) {
>> +        if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
> My main concern is how to use KVM_GET_REG_LIST ioctl command, there
> will be compatible issue if the detail use scenery about
> KVM_GET_REG_LIST command is not clear.
>
> Can KVM_GET_REG_LIST ioctl command be used before vCPU feature
> finalized? If not, it is only used after vCPU feature finalized, guest
> CSR registers should base on vCPU features rather than host features.
> Here get_gcsr_flag() is based on host features. 
>
We can add a warning to the documentation saying using KVM_GET_REG_LIST
before vCPU feature finalization is forbidden. This is how ARM
implemented their thing (the documentation said "Other calls that depend
on a particular feature being finalized, such as KVM_RUN,
KVM_GET_REG_LIST, KVM_GET_ONE_REG and KVM_SET_ONE_REG, will fail with
-EPERM unless the feature has already been finalized by means of a
KVM_ARM_VCPU_FINALIZE call.") We can probably do the same.

What do you think? If you think this is acceptable, I can send a v4
patch that adds a similar warning to the documentation.

> Regards
> Bibo Mao 

Thanks,

Zixing

>> +            continue;
>> +        const u64 reg = KVM_IOC_CSRID(i);
>> +        if (uindices && put_user(reg, uindices++))
>> +            return -EFAULT;
>> +        count++;
>> +    }
>> +
>> +    return count;
>> +}
>> +
>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>> +{
>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>> +    unsigned long res =
>> +        kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS + 1;
>> +
>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>> +        res += NUM_LBT_REGS;
>> +
>> +    return res;
>> +}
>> +
>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>> +                      u64 __user *uindices)
>> +{
>> +    u64 reg;
>> +    unsigned int i;
>> +
>> +    i = kvm_loongarch_walk_csrs(vcpu, uindices);
>> +    if (i < 0)
>> +        return i;
>> +    uindices += i;
>> +
>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>> +        reg = KVM_IOC_CPUCFG(i);
>> +        if (put_user(reg, uindices++))
>> +            return -EFAULT;
>> +    }
>> +
>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>> +    if (put_user(reg, uindices++))
>> +        return -EFAULT;
>> +
>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>> +        return 0;
>> +
>> +    for (i = 1; i <= NUM_LBT_REGS; i++) {
>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>> +        if (put_user(reg, uindices++))
>> +            return -EFAULT;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   long kvm_arch_vcpu_ioctl(struct file *filp,
>>                unsigned int ioctl, unsigned long arg)
>>   {
>> @@ -1251,6 +1314,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>           r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>           break;
>>       }
>> +    case KVM_GET_REG_LIST: {
>> +        struct kvm_reg_list __user *user_list = argp;
>> +        struct kvm_reg_list reg_list;
>> +        unsigned n;
>> +
>> +        r = -EFAULT;
>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>> +            break;
>> +        n = reg_list.n;
>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>> +            break;
>> +        r = -E2BIG;
>> +        if (n < reg_list.n)
>> +            break;
>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>> +        break;
>> +    }
>>       default:
>>           r = -ENOIOCTLCMD;
>>           break;
>>
>

