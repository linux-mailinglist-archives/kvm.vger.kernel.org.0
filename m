Return-Path: <kvm+bounces-19008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A90CD8FE54F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 13:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CC021F25640
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 11:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A03195803;
	Thu,  6 Jun 2024 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="XO4TPrtj"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E66160865;
	Thu,  6 Jun 2024 11:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717673185; cv=none; b=CKa7xefSiIUznTxKlAIPYtqIotpv1oNmDXFlRBjw1CfZmoHc6FqH0FWnvaj9W1HHa9xOO5VK/gNF5ccCMfsxRl++pd+85BvG42AA//XTnpIW114D6YWbQT/D8wBhqYQAsG59Ojf1i41f8ZtGXBCLJHTq3Mx8/R8SU1bVkhkcaUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717673185; c=relaxed/simple;
	bh=I8eXEpEHYSS55mlqLSfygn5zlOeg8Bj8Bwky7Y1Nbrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d0V5FvuOAmEKyR9Ium2l00YDd+j+3B48rmxJlnUtPvp8LlDBGHbtFPtUvWxcjFjtwBlhB3d6rI55T48/FMZ7UzyjuPbZDmp8MdFBd7Ivm4KYAIr7KeqNh40XUPSdoVTzek3ee+uNZPq40q5RvfchWCEZGpFrsUkE/P+/NrFR8Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=XO4TPrtj; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1717672811; bh=I8eXEpEHYSS55mlqLSfygn5zlOeg8Bj8Bwky7Y1Nbrw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XO4TPrtjuDeNDFtuGW0qyMyddDdy90rW98a4gM2MLl5ynzT8L3JcC/7jc8MSHN207
	 Eh5ylgeMaWqmoFtrAkwvCQYZ9wMktoNGJlOP0VfdQnhpqnkil3Sxs2SEmIs25DjT8S
	 Pzt6lsOi+C0S9CD9aj/joRq06QdadcJqsDlfTPlE=
Received: from [IPV6:240e:46c:8500:3a6c:c01f:bf1e:942:ff23] (unknown [IPv6:240e:46c:8500:3a6c:c01f:bf1e:942:ff23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id A1ABF60096;
	Thu,  6 Jun 2024 19:20:10 +0800 (CST)
Message-ID: <9bb552c8-fe86-43dc-9c4e-0b95c99fb25c@xen0n.name>
Date: Thu, 6 Jun 2024 19:20:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] LoongArch: KVM: Add feature passing from user space
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240606074850.2651896-1-maobibo@loongson.cn>
Content-Language: en-US
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20240606074850.2651896-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 6/6/24 15:48, Bibo Mao wrote:
> Currently features defined in cpucfg CPUCFG_KVM_FEATURE comes from
> kvm kernel mode only. Some features are defined in user space VMM,

"come from kernel side only. But currently KVM is not aware of 
user-space VMM features which makes it hard to employ optimizations that 
are both (1) specific to the VM use case and (2) requiring cooperation 
from user space."

> however KVM module does not know. Here interface is added to update
> register CPUCFG_KVM_FEATURE from user space, only bit 24 - 31 is valid.
> 
> Feature KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI is added from user mdoe.
> FEAT_VIRT_EXTIOI is virt EXTIOI extension which can route interrupt
> to 256 VCPUs rather than 4 CPUs like real hw.

"A new feature bit ... is added which can be set from user space. 
FEAT_... indicates that the VM EXTIOI can route interrupts to 256 vCPUs, 
rather than 4 like with real HW."

(Am I right in paraphrasing the "EXTIOI" part?)

> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_host.h  |  4 +++
>   arch/loongarch/include/asm/loongarch.h |  5 ++++
>   arch/loongarch/include/uapi/asm/kvm.h  |  2 ++
>   arch/loongarch/kvm/exit.c              |  1 +
>   arch/loongarch/kvm/vcpu.c              | 36 +++++++++++++++++++++++---
>   5 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 88023ab59486..8fa50d757247 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -135,6 +135,9 @@ enum emulation_result {
>   #define KVM_LARCH_HWCSR_USABLE	(0x1 << 4)
>   #define KVM_LARCH_LBT		(0x1 << 5)
>   
> +#define KVM_LOONGARCH_USR_FEAT_MASK			\
> +	BIT(KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI)
> +
>   struct kvm_vcpu_arch {
>   	/*
>   	 * Switch pointer-to-function type to unsigned long
> @@ -210,6 +213,7 @@ struct kvm_vcpu_arch {
>   		u64 last_steal;
>   		struct gfn_to_hva_cache cache;
>   	} st;
> +	unsigned int usr_features;
>   };
>   
>   static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
> index 7a4633ef284b..4d9837512c19 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -167,9 +167,14 @@
>   
>   #define CPUCFG_KVM_SIG			(CPUCFG_KVM_BASE + 0)
>   #define  KVM_SIGNATURE			"KVM\0"
> +/*
> + * BIT 24 - 31 is features configurable by user space vmm
> + */
>   #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
>   #define  KVM_FEATURE_IPI		BIT(1)
>   #define  KVM_FEATURE_STEAL_TIME		BIT(2)
> +/* With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs */
> +#define  KVM_FEATURE_VIRT_EXTIOI	BIT(24)
>   
>   #ifndef __ASSEMBLY__
>   

What about assigning a new CPUCFG leaf ID for separating the two kinds 
of feature flags very cleanly?

> @@ -896,7 +907,24 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
>   static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
>   					 struct kvm_device_attr *attr)
>   {
> -	return -ENXIO;
> +	u64 __user *user = (u64 __user *)attr->addr;
> +	u64 val, valid_flags;
> +
> +	switch (attr->attr) {
> +	case CPUCFG_KVM_FEATURE:
> +		if (get_user(val, user))
> +			return -EFAULT;
> +
> +		valid_flags = KVM_LOONGARCH_USR_FEAT_MASK;
> +		if (val & ~valid_flags)
> +			return -EINVAL;
> +
> +		vcpu->arch.usr_features |= val;

Isn't this usage of "|=" instead of "=" implying that the feature bits 
could not get disabled after being enabled earlier, for whatever reason?

> +		return 0;
> +
> +	default:
> +		return -ENXIO;
> +	}
>   }
>   
>   static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
> 
> base-commit: 2df0193e62cf887f373995fb8a91068562784adc

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


