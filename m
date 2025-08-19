Return-Path: <kvm+bounces-54990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8CBB2C70B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 615855A02F2
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFC6263C7F;
	Tue, 19 Aug 2025 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T9GqhK34"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C454C2110;
	Tue, 19 Aug 2025 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613634; cv=none; b=GxxdQSfDXCjKUIOc4IeUVG5mNexbPRYJLJNnbzynkTz7ox0CiAp0RDXEvTTk9P8WktpBUKWHBYzfksf80OooYLjT2tZ+RWV76iBE7NhXnGsFR0FwjE7QewgNCnuR5jo2KCAyD1uK7ECGleQLegQ3AqcPC6sZoy1Sc0A0qPwKnp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613634; c=relaxed/simple;
	bh=yDs+kKBrbP3yEi8uWei0eMe0N9vYgihZ6nzRT6EJui0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdEHCf//m+/GMH10/vKVf3172v5EF1JmkdaFE+8hvY5Gz9ylwTQZHBzKQBG7FOxQBdSInkK287yqV+zw3sSYteG1ZuT3qG8ij37Gwsp6yBAPt50w7nLIdq5pmSG/x3EHm7KpcLRXBSypmkduSmtQQThfpwSb/umzbBz7rWUFPKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T9GqhK34; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 19 Aug 2025 22:27:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755613629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TWvZTXUXEJL7nh5uPtT4Ud1hkvku6IV5nyuOFNoTAv0=;
	b=T9GqhK34sK0ikauzeNSBxRN+EiQBDKH+FGTdM+8EKZAk6f96SaUGXFbx8fWXcyBXWpZl4X
	0EPRsXPggdH7pQiRg1jQTC5wQrkfVwCYUqzXVPSD80QBctEB5jeuwnpeavr0ymy91sfeaR
	xOyZHtsELbRedj3ZwbDihZ9DiD0AjH8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Troy Mitchell <troy.mitchell@linux.dev>
To: guoren@kernel.org, paul.walmsley@sifive.com, anup@brainfault.org,
	atish.patra@linux.dev, fangyu.yu@linux.alibaba.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Troy Mitchell <troy.mitchell@linux.dev>
Subject: Re: [PATCH] RISC-V: KVM: Prevent HGATP_MODE_BARE passed
Message-ID: <aKSJtqea0x0r44Tq@troy-wujie14pro-arch>
References: <20250819004643.1884149-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819004643.1884149-1-guoren@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 18, 2025 at 08:46:43PM -0400, guoren@kernel.org wrote:
> From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
> 
> urrent kvm_riscv_gstage_mode_detect() assumes H-extension must
> have HGATP_MODE_SV39X4/SV32X4 at least, but the spec allows
> H-extension with HGATP_MODE_BARE alone. The KVM depends on
> !HGATP_MODE_BARE at least, so enhance the gstage-mode-detect
> to block HGATP_MODE_BARE.
> 
> Move gstage-mode-check closer to gstage-mode-detect to prevent
> unnecessary init.
> 
> Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
> ---
>  arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
>  arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
>  2 files changed, 41 insertions(+), 21 deletions(-)
Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>

> 
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index 24c270d6d0e2..b67d60d722c2 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -321,7 +321,7 @@ void __init kvm_riscv_gstage_mode_detect(void)
>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
>  		kvm_riscv_gstage_mode = HGATP_MODE_SV57X4;
>  		kvm_riscv_gstage_pgd_levels = 5;
> -		goto skip_sv48x4_test;
> +		goto done;
>  	}
>  
>  	/* Try Sv48x4 G-stage mode */
> @@ -329,10 +329,31 @@ void __init kvm_riscv_gstage_mode_detect(void)
>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
>  		kvm_riscv_gstage_mode = HGATP_MODE_SV48X4;
>  		kvm_riscv_gstage_pgd_levels = 4;
> +		goto done;
>  	}
> -skip_sv48x4_test:
>  
> +	/* Try Sv39x4 G-stage mode */
> +	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
> +	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
> +		kvm_riscv_gstage_mode = HGATP_MODE_SV39X4;
> +		kvm_riscv_gstage_pgd_levels = 3;
> +		goto done;
> +	}
> +#else /* CONFIG_32BIT */
> +	/* Try Sv32x4 G-stage mode */
> +	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
> +	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV32X4) {
> +		kvm_riscv_gstage_mode = HGATP_MODE_SV32X4;
> +		kvm_riscv_gstage_pgd_levels = 2;
> +		goto done;
> +	}
> +#endif
> +
> +	/* KVM depends on !HGATP_MODE_OFF */
> +	kvm_riscv_gstage_mode = HGATP_MODE_OFF;
> +	kvm_riscv_gstage_pgd_levels = 0;
> +
> +done:
>  	csr_write(CSR_HGATP, 0);
>  	kvm_riscv_local_hfence_gvma_all();
> -#endif
>  }
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 67c876de74ef..8ee7aaa74ddc 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -93,6 +93,23 @@ static int __init riscv_kvm_init(void)
>  		return rc;
>  
>  	kvm_riscv_gstage_mode_detect();
> +	switch (kvm_riscv_gstage_mode) {
> +	case HGATP_MODE_SV32X4:
> +		str = "Sv32x4";
> +		break;
> +	case HGATP_MODE_SV39X4:
> +		str = "Sv39x4";
> +		break;
> +	case HGATP_MODE_SV48X4:
> +		str = "Sv48x4";
> +		break;
> +	case HGATP_MODE_SV57X4:
> +		str = "Sv57x4";
> +		break;
> +	default:
> +		return -ENODEV;
> +	}
> +	kvm_info("using %s G-stage page table format\n", str);
>  
>  	kvm_riscv_gstage_vmid_detect();
>  
> @@ -135,24 +152,6 @@ static int __init riscv_kvm_init(void)
>  			 (rc) ? slist : "no features");
>  	}
>  
> -	switch (kvm_riscv_gstage_mode) {
> -	case HGATP_MODE_SV32X4:
> -		str = "Sv32x4";
> -		break;
> -	case HGATP_MODE_SV39X4:
> -		str = "Sv39x4";
> -		break;
> -	case HGATP_MODE_SV48X4:
> -		str = "Sv48x4";
> -		break;
> -	case HGATP_MODE_SV57X4:
> -		str = "Sv57x4";
> -		break;
> -	default:
> -		return -ENODEV;
> -	}
> -	kvm_info("using %s G-stage page table format\n", str);
> -
>  	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
>  
>  	if (kvm_riscv_aia_available())
> -- 
> 2.40.1
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

