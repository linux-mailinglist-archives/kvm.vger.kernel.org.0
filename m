Return-Path: <kvm+bounces-48623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 811ACACFA86
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 02:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4B2A3B0A6E
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D8728E0F;
	Fri,  6 Jun 2025 00:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EMie37qY"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712B66F06B;
	Fri,  6 Jun 2025 00:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749171191; cv=none; b=aUoPsut/cbNrB1IPbo0QpezsbhVgOpAyQzW2xWi5XzOsF1l6vJghzWF2weXxZyH+kBSKZWAvtI4PODnelbrvLRZtAFO0TCp2TPcAoPsmiw/g4p0Z4qCnBO73+LojZYyjq+O0Eg5LwdGZdP0jR8lCj+Jw+ernXgzaf1P90Ojje4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749171191; c=relaxed/simple;
	bh=T3sY2nxuWKNXKPsm8uMDnUfpWpT+EKrbW35bH4yrACQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bN4aPKKpmn3HC3+7sCvmgLXjSSaHrFnT1tyhf5fzVZ2v9kaOPmbdxhNhAou6dKb7cbaAQppGDphHSP5/8m6u0T8/sLWpBiBhsrYJo6J1305C5NMcmAfq6fvgsa140CcA+BSTqyCZZNdZlcnpLGfELJVLLmGY9O2vwO5D+O4Zo/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EMie37qY; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <8ca50309-fad7-438a-86d6-947cd39355fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749171185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kY1Yhf2Ta16lGAfQpv9nl7Dl6/dZF2m3DEDTNJAsF5Y=;
	b=EMie37qYZzEs8Rjw9lzqRaIyG0BkrIKeZAJmJltSqgZlWHSoD3LrX5cznfshPhNPFrabI7
	OSLfNETKU251DBYbeFMpyzHpsDkkJPr/iZ7F2qHFaI2nvnKeM2nzLr2xHOncUVAXLwZSI4
	tO0xRD2vfiqsbX6LUjiLm0p4c3MDyAA=
Date: Thu, 5 Jun 2025 17:52:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 04/13] RISC-V: KVM: Drop the return value of
 kvm_riscv_vcpu_aia_init()
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250605061458.196003-1-apatel@ventanamicro.com>
 <20250605061458.196003-5-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250605061458.196003-5-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/4/25 11:14 PM, Anup Patel wrote:
> The kvm_riscv_vcpu_aia_init() does not return any failure so drop
> the return value which is always zero.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_aia.h | 2 +-
>   arch/riscv/kvm/aia_device.c      | 6 ++----
>   arch/riscv/kvm/vcpu.c            | 4 +---
>   3 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
> index 3b643b9efc07..0a0f12496f00 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -147,7 +147,7 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
>   
>   int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu);
>   void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu);
> -int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
>   void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu);
>   
>   int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm, u32 hart_index,
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 43e472ff3e1a..5b7ed2d987db 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -539,12 +539,12 @@ void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
>   	kvm_riscv_vcpu_aia_imsic_reset(vcpu);
>   }
>   
> -int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
> +void kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_vcpu_aia *vaia = &vcpu->arch.aia_context;
>   
>   	if (!kvm_riscv_aia_available())
> -		return 0;
> +		return;
>   
>   	/*
>   	 * We don't do any memory allocations over here because these
> @@ -556,8 +556,6 @@ int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
>   	/* Initialize default values in AIA vcpu context */
>   	vaia->imsic_addr = KVM_RISCV_AIA_UNDEF_ADDR;
>   	vaia->hart_index = vcpu->vcpu_idx;
> -
> -	return 0;
>   }
>   
>   void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 6a1914b21ec3..f98a1894d55b 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -160,9 +160,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	kvm_riscv_vcpu_pmu_init(vcpu);
>   
>   	/* Setup VCPU AIA */
> -	rc = kvm_riscv_vcpu_aia_init(vcpu);
> -	if (rc)
> -		return rc;
> +	kvm_riscv_vcpu_aia_init(vcpu);
>   
>   	/*
>   	 * Setup SBI extensions




