Return-Path: <kvm+bounces-70284-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8CidMITzg2ndwAMAu9opvQ
	(envelope-from <kvm+bounces-70284-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:33:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7B2EDAB4
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 46D533016CB5
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 01:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B2F2641E3;
	Thu,  5 Feb 2026 01:33:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6607C15A85A;
	Thu,  5 Feb 2026 01:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770255220; cv=none; b=ZYZIHQe28eZlDr1Q9MspTPpJ2rdhXGfylW3c769pmUx+cgYDZXylHMar1SDgKZ5NSkAgiJGnV7blEDeoypit4PtUgplOEEzi7nvnzEk4mtV8ceOl4dXGZHzBul8fDigVBhzga44IXmgqd2Uj/B7W4GV2JwsLSMXnoBMfLDriBmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770255220; c=relaxed/simple;
	bh=Z+p99DWOZ/ImWsvXsDgiTFpQFykpq6t7nWO2QwjJkVE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FIBDqOrAXDmfP15LfNK5ZXkSMHl3zNKzhvnH6nRAsOKNlSx19qQ1fWETextGsgF0OPLiGhbSlAF4nRyVTlt24Ek3ne6kiJmbziWfOLN17tMT7sQy9YSKFteIYNGhShgloURfLbQZst4/ukyTggOAMD6yVmsJmR/p/xkYWIiCqlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxPMNq84Npw_YPAA--.51487S3;
	Thu, 05 Feb 2026 09:33:30 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxSeBd84Np3BtAAA--.54343S3;
	Thu, 05 Feb 2026 09:33:19 +0800 (CST)
Subject: Re: [PATCH v4] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: Zixing Liu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260204113601.912413-1-liushuyu@aosc.io>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <02f9aed7-d435-fd0b-4f7e-4b59dd62dcb2@loongson.cn>
Date: Thu, 5 Feb 2026 09:30:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260204113601.912413-1-liushuyu@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxSeBd84Np3BtAAA--.54343S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw1rXrW3uryrXr15GF43CFX_yoW7Jw13pF
	W3CrnxXrW5Ar1Ik34rZ3ZxuF98Xrs2grsrZa43Wa48Ar4Yyr1ftFsYkrZrXFWrJ3y8CF40
	vF1YqF1q9FZ0q3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUk529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUstxhDUUUU
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-0.990];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
	TAGGED_FROM(0.00)[bounces-70284-lists,kvm=lfdr.de];
	DMARC_NA(0.00)[loongson.cn];
	DBL_BLOCKED_OPENRESOLVER(0.00)[aosc.io:email,gitlab.com:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6E7B2EDAB4
X-Rspamd-Action: no action

Hi Zixing,

Thanks for doing this.

On 2026/2/4 下午7:36, Zixing Liu wrote:
> This ioctl can be used by the userspace applications to determine which
> (special) registers are get/set-able in a meaningful way.
> 
> This can be very useful for cross-platform VMMs so that they do not have
> to hardcode register indices for each supported architectures.
> 
> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
> ---
>   Documentation/virt/kvm/api.rst |  2 +-
>   arch/loongarch/kvm/vcpu.c      | 87 ++++++++++++++++++++++++++++++++++
>   2 files changed, 88 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 01a3abef8abb..f46dd8be282f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>   ---------------------
>   
>   :Capability: basic
> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
> +:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>   :Type: vcpu ioctl
>   :Parameters: struct kvm_reg_list (in/out)
>   :Returns: 0 on success; -1 on error
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 656b954c1134..bd855ee20ee2 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -3,6 +3,7 @@
>    * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>    */
>   
> +#include "asm/kvm_host.h"
Had better put after #include <asm/fpu.h>, and keep alphabetical order.
>   #include <linux/kvm_host.h>
>   #include <asm/fpu.h>
>   #include <asm/lbt.h>
> @@ -14,6 +15,8 @@
>   #define CREATE_TRACE_POINTS
>   #include "trace.h"
>   
> +#define NUM_LBT_REGS 6
> +
>   const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>   	KVM_GENERIC_VCPU_STATS(),
>   	STATS_DESC_COUNTER(VCPU, int_exits),
> @@ -1186,6 +1189,72 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
>   	return ret;
>   }
>   
> +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64 __user *uindices)
> +{
> +	unsigned int i, count;
> +
> +	for (i = 0, count = 0; i < CSR_MAX_NUMS; i++) {
> +		if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
> +			continue;
> +		if (i >= LOONGARCH_CSR_PERFCTRL0 && i <= LOONGARCH_CSR_PERFCNTR3) {
> +			/* Skip PMU CSRs if not supported by the guest */
> +			if (!kvm_guest_has_pmu(&vcpu->arch))
> +				continue;
> +		}
This is workable, gcsr_flag can be changed with structure, and new 
element "int required_features" added. However it does not matter, it 
can be done in later.

CSR registers relative with msgint feature can be done with this method 
also.

How about debug/watch CSR registers? can it be skipped also?  the same 
MERR CSR registers with LOONGARCH_CSR_MERR*.

The CSR register list difference can be checked with 
kvm_loongarch_get_csr() in qemu VMM, with website
https://gitlab.com/qemu-project/qemu/-/blob/master/target/loongarch/kvm/kvm.c?ref_type=heads

Regards
Bibo Mao
> +		const u64 reg = KVM_IOC_CSRID(i);
> +		if (uindices && put_user(reg, uindices++))
> +			return -EFAULT;
> +		count++;
> +	}
> +
> +	return count;
> +}
> +
> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
> +{
> +	/* +1 for the KVM_REG_LOONGARCH_COUNTER register */
> +	unsigned long res =
> +		kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS + 1;
> +
> +	if (kvm_guest_has_lbt(&vcpu->arch))
> +		res += NUM_LBT_REGS;
> +
> +	return res;
> +}
> +
> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
> +					  u64 __user *uindices)
> +{
> +	u64 reg;
> +	unsigned int i;
> +
> +	i = kvm_loongarch_walk_csrs(vcpu, uindices);
> +	if (i < 0)
> +		return i;
> +	uindices += i;
> +
> +	for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
> +		reg = KVM_IOC_CPUCFG(i);
> +		if (put_user(reg, uindices++))
> +			return -EFAULT;
> +	}
> +
> +	reg = KVM_REG_LOONGARCH_COUNTER;
> +	if (put_user(reg, uindices++))
> +		return -EFAULT;
> +
> +	if (!kvm_guest_has_lbt(&vcpu->arch))
> +		return 0;
> +
> +	for (i = 1; i <= NUM_LBT_REGS; i++) {
> +		reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
> +		if (put_user(reg, uindices++))
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg)
>   {
> @@ -1251,6 +1320,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>   		break;
>   	}
> +	case KVM_GET_REG_LIST: {
> +		struct kvm_reg_list __user *user_list = argp;
> +		struct kvm_reg_list reg_list;
> +		unsigned n;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
> +			break;
> +		n = reg_list.n;
> +		reg_list.n = kvm_loongarch_num_regs(vcpu);
> +		if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
> +			break;
> +		r = -E2BIG;
> +		if (n < reg_list.n)
> +			break;
> +		r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
> +		break;
> +	}
>   	default:
>   		r = -ENOIOCTLCMD;
>   		break;
> 


