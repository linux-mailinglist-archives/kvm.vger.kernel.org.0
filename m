Return-Path: <kvm+bounces-47695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99286AC3C91
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AA8F188D86F
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5931F09AD;
	Mon, 26 May 2025 09:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Jo2bkt3k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8832CCDB
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748251339; cv=none; b=S4Q92vPAVP4050MBx5Wycdk/5YBU6zyGJAL8WY7gxABqSjR2CPlxnMjWaXd+Gv4KdUDhpmqPzBBItHysUJW7Cpc8i1zM+mpHibL+gnnBNF+2ghnrxMPvQvFF6nLNRWE7Nwx9i6vJGE4ZIbbdcnWVUC9MEwwnbhZF2QiS3GedEZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748251339; c=relaxed/simple;
	bh=v7yS7OXgu3hum6RTQqAlKfS4MyVozx6fNgU7cA4xzbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHrA5FgmG5fIYxykDrLgW9eS8YH3jnQd699Zl37u7uQxFNkx8eQ+Ky3ExrAO0Gen+R29aUA5nxIU7J46OFbWoNPrX2mdlwvEriGmyoRc4YdYA+qR5z2naaFV27pK0dO6SBBclLBR2dKwrKbgRp5CllJel1iiESUD8E0ReDpawm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Jo2bkt3k; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-442ea341570so14429055e9.1
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748251335; x=1748856135; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kVB1vMEDILwI7yDAI9DCK169GFiMbj0azQ2wkTKfU94=;
        b=Jo2bkt3kIR6RlLEsE6p03VMwZsfRdrhbXPO53gOh9ZonWeENh6saDjAXxzWITSODP+
         wL8nxlQ3az+aCYAM/wVh888QFHBrHmGHOf1bDNZvlMXHvFA2i0YhLmV8xYNnm9paRyxN
         S83BfBImElCMUpUApAcu1nLkT2Kc0CFVKEoVUFhP/2ZNoKAp1qXttm0ykYR/Aa8eNTVg
         jmG0XjloZugo7jlKP3Mdx1sdEvSHd5IChxj/4GleVNHBxuW1dCQaSI/2z+zWa4jqy40C
         W5rWkJwvHwSoCijMVwhFwN5d1n5gF2f/685S6ggUIaQqnPllVDE5huCZHSfsVI8VBP7M
         X9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748251335; x=1748856135;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kVB1vMEDILwI7yDAI9DCK169GFiMbj0azQ2wkTKfU94=;
        b=Gqm2aXpv4rGS++11ImR1nUnWqor+OmaNQqQXMItHPcGpkupPuht0Z1j0gxo0ootQOb
         25YjrHMZSDpRP4kn/h2NVlcEiQp9giWsTbvTYepqG6kiUAzykRxT06Mcd/Lf8gZusNKC
         nkZpPRKOxe5NUPOkRzedDllwbBM8p2L04k+CgZARuFn3e9YQjvT4r83payH8NJZJ2k6y
         jUwiqfYZ4gjBgIwVp5f1Ww7V86++6jrvOnEQc/TpVBPxZzC7eo2IP8xniJ07+HyvuN4Z
         FxtiSzwKjRzDulP0bCj4ZyJbitygE7DNzJRi8IcTl8Ny+eNLhJK6pRrQe9SHKkKWHVxy
         F8kw==
X-Forwarded-Encrypted: i=1; AJvYcCXWZJdJZCBRV39dOKfjhpnyJIkKCTz4FXBW0TKvUcafLMyfueT8E7YdER8YaEGoyMeAcvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoKwfWyBG0e7aZy+dkePDg6wNeHVhhMBvqMG8gBXHCiNIX20oG
	p7RL277dFnA7bpt0g3WpYAGIiWbRwC40YR2e1TwC5Z9WffpeeOdxLH1gvpfbYvf5Z94=
X-Gm-Gg: ASbGncuLoQk/DpKuEh38y23zxjXMaykpq6I8vsXxvrjeFv9O5bdlFe/ZqdfPcu6plTU
	MYviXSB/C03oV3qN7S2PWCiWQJFOCNYrbYpaD6SwrcKDJnvkVCe/i4t2LWk5HtrX7564yeFUVmk
	INnvFOK2wXC9x/vOf66DJF+Ap/PIjS/DhdYDiKEbhIAxYbOh3W16yJFZLoUfgKBTwEZRcSSW+Hk
	iXNyI2yXZPVmLco/8ZVGxE2wxFRX0/838hJbGwNqSDk8P9D8XCoiYYp90lBQARkTLmkmZe5QIQH
	xLikGTiUgqMk7eEgz+K5jTPnAwFr6j3aeBV/vlEAfTFNZ51rcWsesBXbe3PCDHvc6OrX8Sn2mL4
	CJ4Zo
X-Google-Smtp-Source: AGHT+IEGcjh7xBCh+DfeG8xrQT+wvABD+WF/Eu3axSyNQAacMD1k0+ulmhfWAKZW9jVFPAOFjD/p3g==
X-Received: by 2002:a05:6000:2407:b0:3a3:6f26:5813 with SMTP id ffacd0b85a97d-3a4cb442ea4mr5934699f8f.25.1748251335337;
        Mon, 26 May 2025 02:22:15 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4cd0cf5ccsm6703658f8f.8.2025.05.26.02.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 02:22:14 -0700 (PDT)
Date: Mon, 26 May 2025 11:22:14 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>
Subject: Re: [PATCH v4] RISC-V: KVM: add KVM_CAP_RISCV_USERSPACE_SBI
Message-ID: <20250526-e67c64d52c84a8ad7cb519c4@orel>
References: <20250523113347.2898042-3-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250523113347.2898042-3-rkrcmar@ventanamicro.com>

On Fri, May 23, 2025 at 01:33:49PM +0200, Radim Krčmář wrote:
> The new capability allows userspace to implement SBI extensions that KVM
> does not handle.  This allows userspace to implement any SBI ecall as
> userspace already has the ability to disable acceleration of selected
> SBI extensions.
> The base extension is made controllable as well, but only with the new
> capability, because it was previously handled specially for some reason.
> *** The related compatibility TODO in the code needs addressing. ***
> 
> This is a VM capability, because userspace will most likely want to have
> the same behavior for all VCPUs.  We can easily make it both a VCPU and
> a VM capability if there is demand in the future.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> ---
> v4:
> * forward base extension as well
> * change the id to 242, because 241 is already taken in linux-next
> * QEMU example: https://github.com/radimkrcmar/qemu/tree/mp_state_reset
> v3: new
> ---
>  Documentation/virt/kvm/api.rst    | 11 +++++++++++
>  arch/riscv/include/asm/kvm_host.h |  3 +++
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/vcpu_sbi.c         | 17 ++++++++++++++---
>  arch/riscv/kvm/vm.c               |  5 +++++
>  include/uapi/linux/kvm.h          |  1 +
>  6 files changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e107694fb41f..c9d627d13a5e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8507,6 +8507,17 @@ given VM.
>  When this capability is enabled, KVM resets the VCPU when setting
>  MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
>  
> +7.44 KVM_CAP_RISCV_USERSPACE_SBI
> +--------------------------------
> +
> +:Architectures: riscv
> +:Type: VM
> +:Parameters: None
> +:Returns: 0 on success, -EINVAL if arg[0] is not zero
> +
> +When this capability is enabled, KVM forwards ecalls from disabled or unknown
> +SBI extensions to userspace.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 85cfebc32e4c..6f17cd923889 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -122,6 +122,9 @@ struct kvm_arch {
>  
>  	/* KVM_CAP_RISCV_MP_STATE_RESET */
>  	bool mp_state_reset;
> +
> +	/* KVM_CAP_RISCV_USERSPACE_SBI */
> +	bool userspace_sbi;
>  };
>  
>  struct kvm_cpu_trap {
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 5f59fd226cc5..dd3a5dc53d34 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -204,6 +204,7 @@ enum KVM_RISCV_SBI_EXT_ID {
>  	KVM_RISCV_SBI_EXT_DBCN,
>  	KVM_RISCV_SBI_EXT_STA,
>  	KVM_RISCV_SBI_EXT_SUSP,
> +	KVM_RISCV_SBI_EXT_BASE,
>  	KVM_RISCV_SBI_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 31fd3cc98d66..497d5b023153 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -39,7 +39,7 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
>  		.ext_ptr = &vcpu_sbi_ext_v01,
>  	},
>  	{
> -		.ext_idx = KVM_RISCV_SBI_EXT_MAX, /* Can't be disabled */
> +		.ext_idx = KVM_RISCV_SBI_EXT_BASE,
>  		.ext_ptr = &vcpu_sbi_ext_base,
>  	},
>  	{
> @@ -217,6 +217,11 @@ static int riscv_vcpu_set_sbi_ext_single(struct kvm_vcpu *vcpu,
>  	if (!sext || scontext->ext_status[sext->ext_idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE)
>  		return -ENOENT;
>  
> +	// TODO: probably remove, the extension originally couldn't be
> +	// disabled, but it doesn't seem necessary
> +	if (!vcpu->kvm->arch.userspace_sbi && sext->ext_id == KVM_RISCV_SBI_EXT_BASE)
> +		return -ENOENT;
> +

I agree that we don't need to babysit userspace and it's even conceivable
to have guests that don't need SBI. KVM should only need checks in its
UAPI to protect itself from userspace and to enforce proper use of the
API. It's not KVM's place to ensure userspace doesn't violate the SBI spec
or create broken guests (userspace is the boss, even if it's a boss that
doesn't make sense)

So, I vote we drop the check.

>  	scontext->ext_status[sext->ext_idx] = (reg_val) ?
>  			KVM_RISCV_SBI_EXT_STATUS_ENABLED :
>  			KVM_RISCV_SBI_EXT_STATUS_DISABLED;
> @@ -471,8 +476,14 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  #endif
>  		ret = sbi_ext->handler(vcpu, run, &sbi_ret);
>  	} else {
> -		/* Return error for unsupported SBI calls */
> -		cp->a0 = SBI_ERR_NOT_SUPPORTED;
> +		if (vcpu->kvm->arch.userspace_sbi) {
> +			next_sepc = false;
> +			ret = 0;
> +			kvm_riscv_vcpu_sbi_forward(vcpu, run);
> +		} else {
> +			/* Return error for unsupported SBI calls */
> +			cp->a0 = SBI_ERR_NOT_SUPPORTED;
> +		}
>  		goto ecall_done;
>  	}
>  
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index b27ec8f96697..0b6378b83955 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -217,6 +217,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  			return -EINVAL;
>  		kvm->arch.mp_state_reset = true;
>  		return 0;
> +	case KVM_CAP_RISCV_USERSPACE_SBI:
> +		if (cap->flags)
> +			return -EINVAL;
> +		kvm->arch.userspace_sbi = true;
> +		return 0;
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 454b7d4a0448..bf23deb6679e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -931,6 +931,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_X86_GUEST_MODE 238
>  #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
>  #define KVM_CAP_RISCV_MP_STATE_RESET 240
> +#define KVM_CAP_RISCV_USERSPACE_SBI 242
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> -- 
> 2.49.0
>

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

