Return-Path: <kvm+bounces-69071-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJr+IqzNdmktWwEAu9opvQ
	(envelope-from <kvm+bounces-69071-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 03:13:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AAC0D8376C
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 03:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E3FD930015B8
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 02:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74E523EA89;
	Mon, 26 Jan 2026 02:12:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB2224113D;
	Mon, 26 Jan 2026 02:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769393569; cv=none; b=QcU9thf9xkVFEeSC3Tmoxbks3cTK73xCiXZpD5mtB9unXCteMcjrVH9MXNRke2HUi8iKCuUiK2w0bHT6qhTqbeXSY5jqJ5S8qXfdrZA6B6Ad8dB9GSsZW7g6dn6aYG0RDu5cIh2OQ8kG2qAf8GBPIPAfJyeQS1HG+ULCntX9Wcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769393569; c=relaxed/simple;
	bh=BUM8C9hkjEGzOYKfxRu8J1XeZ8xVDt4sjCeOZKvu4Ww=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CG8EMLxt3MgYA1EWJpkfZwQkKLxJneNAc0J/03SyPHlpkbAMI9qvemiAI/xZSBLfnsOujs1LJ4S/uUtmMVNcm6zSC57+iMjWrhk5ANlLcVp/FmV1vfCCKrKlC78v2FVMoFeDxpJccdEQHqiXzIX8wX3NSbvXLKOqZLRPWA2gFKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Axz8OQzXZpgJUMAA--.41370S3;
	Mon, 26 Jan 2026 10:12:32 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxfcKFzXZp7TQxAA--.30120S3;
	Mon, 26 Jan 2026 10:12:23 +0800 (CST)
Subject: Re: [PATCH 1/1] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: Zixing Liu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 rust-for-linux@vger.kernel.org
References: <20260125054322.1237687-1-liushuyu@aosc.io>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <4b504274-4241-0e3e-3ed3-7804b72b7ee8@loongson.cn>
Date: Mon, 26 Jan 2026 10:09:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260125054322.1237687-1-liushuyu@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxfcKFzXZp7TQxAA--.30120S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr4rurW3ArW7KF47ZryxJFc_yoWrGFyDpF
	W3C3ZIqrWFyr1Ik343ZwnxuF98Xrs2gw47ZFy3Ga4xAr4Yyr4FvF40krZrXFWrJ348CF40
	vF10gFyY9FWqv3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUA529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUShiSDUUUU
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[27];
	TAGGED_FROM(0.00)[bounces-69071-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[aosc.io,redhat.com,lwn.net,loongson.cn,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,gmail.com,garyguo.net,protonmail.com,google.com,umich.edu,vger.kernel.org,lists.linux.dev,lists.infradead.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.982];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,aosc.io:email,loongson.cn:mid]
X-Rspamd-Queue-Id: AAC0D8376C
X-Rspamd-Action: no action



On 2026/1/25 下午1:43, Zixing Liu wrote:
> This ioctl can be used by userspace applications to determine which
> (special) registers are get/set-able.
> 
> This can be very useful for cross-platform VMMs so that they do not have
> to hardcode register indices for each supported architectures.
> 
> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
> ---
> 
> For example, this ioctl could be used by rust-vmm/rust-kvm or maybe
> VirtualBox-kvm in the future.
> 
>   Documentation/virt/kvm/api.rst |  2 +-
>   arch/loongarch/kvm/vcpu.c      | 69 ++++++++++++++++++++++++++++++++++
>   2 files changed, 70 insertions(+), 1 deletion(-)
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
> index 656b954c1134..b884eb9c76aa 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -1186,6 +1186,57 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
>   	return ret;
>   }
>   
> +static unsigned long kvm_loongarch_num_lbt_regs(void)
> +{
> +	/* +1 for the LBT_FTOP flag (inside arch.fpu) */
> +	return sizeof(struct loongarch_lbt) / sizeof(unsigned long) + 1;
> +}
> +
> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
> +{
> +	/* +1 for the KVM_REG_LOONGARCH_COUNTER register */
> +	unsigned long res = CSR_MAX_NUMS + KVM_MAX_CPUCFG_REGS + 1;
> +
> +	if (kvm_guest_has_lbt(&vcpu->arch))
> +		res += kvm_loongarch_num_lbt_regs();
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
> +	for (i = 0; i < CSR_MAX_NUMS; i++) {
> +		reg = KVM_IOC_CSRID(i);
> +		if (put_user(reg, uindices++))
> +			return -EFAULT;
> +	}
CSR_MAX_NUMS is max number of accessible CSR registers, instead only 
part of them is used by vCPU model. By my understanding, there will be 
no much meaning if CSR_MAX_NUMS is returned. And I think it will be 
better if real CSR register id and number is returned.

Regards
Bibo Mao
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
> +	for (i = 1; i <= kvm_loongarch_num_lbt_regs(); i++) {
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
> @@ -1251,6 +1302,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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


