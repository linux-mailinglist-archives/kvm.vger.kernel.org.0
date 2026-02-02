Return-Path: <kvm+bounces-69792-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6O6+AKkNgGl82AIAu9opvQ
	(envelope-from <kvm+bounces-69792-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 03:36:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6EDFC7E50
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 03:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 12D873006535
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 02:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E67521D3CD;
	Mon,  2 Feb 2026 02:36:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F92F1DD525;
	Mon,  2 Feb 2026 02:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769999779; cv=none; b=RA5QljlEOc0bV060nUpAp7dDyuHhAoq73f5nEOiQbAo94YoZNfSwTrMjvXNCZMKnuCVJJK/YQ2gzo9DEyHtCHwsHj/BwSioIbgiwWQRLpPqRqYOxeu0yrLfWU1JIy1Qw6qa2Boklx2pTpRmRwstRoyg9agaFK+1U2gZs1LCLK2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769999779; c=relaxed/simple;
	bh=X1BnZYCTNs7icPjklhQGcBhKKA8n6YOs0sexGAGn53o=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OmNcYN+FlJ1W2H4RHUENvxiJ+F3prnU4YWJrMrNTf5jOvmAowFbnluMtxezoXBR19Wj+ypDO18y1Hos+HVjHU9O2O4bNSTDJRBImaV9UbWGS2+s73oDoF4OzTthHFnDIkoDRJJ1S8/hq3OC72it8wDUM/d3SgOSop6eiLEmy2bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxcfCbDYBp_NUOAA--.48798S3;
	Mon, 02 Feb 2026 10:36:11 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxjcKRDYBp78M9AA--.46557S3;
	Mon, 02 Feb 2026 10:36:03 +0800 (CST)
Subject: Re: [PATCH v3] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: Zixing Liu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260201072124.566587-1-liushuyu@aosc.io>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <fe2dd7e1-4480-78e0-cfbd-4fc3574c589c@loongson.cn>
Date: Mon, 2 Feb 2026 10:33:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260201072124.566587-1-liushuyu@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxjcKRDYBp78M9AA--.46557S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAF4ruF4DXrWrKr4xJry7Arc_yoWrCF1kpr
	W3CrnIqrW5Ar1Ik34fZ3Z8WFy5Xrn2grsrZasxG348Ar4Yyr1Fya1FkrZrZFWrJ348CF40
	vF1YgF1Y9FZ0q3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUk529EdanIXcx71UUUUU7KY7ZEXa
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
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUstxhDUUUU
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
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
	TAGGED_FROM(0.00)[bounces-69792-lists,kvm=lfdr.de];
	DMARC_NA(0.00)[loongson.cn];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,aosc.io:email,loongson.cn:mid]
X-Rspamd-Queue-Id: B6EDFC7E50
X-Rspamd-Action: no action



On 2026/2/1 下午3:21, Zixing Liu wrote:
> This ioctl can be used by the userspace applications to determine which
> (special) registers are get/set-able in a meaningful way.
> 
> This can be very useful for cross-platform VMMs so that they do not have
> to hardcode register indices for each supported architectures.
> 
> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
> ---
>   Documentation/virt/kvm/api.rst |  2 +-
>   arch/loongarch/kvm/vcpu.c      | 81 ++++++++++++++++++++++++++++++++++
>   2 files changed, 82 insertions(+), 1 deletion(-)
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
> index 656b954c1134..fb8001deadc9 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -14,6 +14,8 @@
>   #define CREATE_TRACE_POINTS
>   #include "trace.h"
>   
> +#define NUM_LBT_REGS 6
> +
>   const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>   	KVM_GENERIC_VCPU_STATS(),
>   	STATS_DESC_COUNTER(VCPU, int_exits),
> @@ -1186,6 +1188,67 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
>   	return ret;
>   }
>   
> +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64 __user *uindices)
> +{
> +	unsigned int i, count;
> +
> +	for (i = 0, count = 0; i < CSR_MAX_NUMS; i++) {
> +		if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
My main concern is how to use KVM_GET_REG_LIST ioctl command, there will 
be compatible issue if the detail use scenery about KVM_GET_REG_LIST 
command is not clear.

Can KVM_GET_REG_LIST ioctl command be used before vCPU feature 
finalized? If not, it is only used after vCPU feature finalized, guest 
CSR registers should base on vCPU features rather than host features. 
Here get_gcsr_flag() is based on host features.

Regards
Bibo Mao
> +			continue;
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
> @@ -1251,6 +1314,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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


