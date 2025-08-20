Return-Path: <kvm+bounces-55134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07866B2DFB8
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 289E517710E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6659D296BBC;
	Wed, 20 Aug 2025 14:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZO0pr5oK"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A79427145F
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 14:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755700856; cv=none; b=s5HzNojy7fplzVsbjOtAw61Tp3/mmAVCWhcVQ9vfpMteE2Wvcp6fXA2h5GGKMYuXRB0aBFV2QERVIFmbtJCpimPaDIzzz5hXQ9k/3fsHadv+QueKHQZ45AZtCAL1kdrGcY7tWI25lLxefJ5CiPseQKQqvk+qK8wpkSsBXmjLpfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755700856; c=relaxed/simple;
	bh=GSQ2eMx7hK1Uu/WjfaI642/Rkdo4hH8OelM2Z0TLi7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8gG9dACgasQ7x8q8kke0JojopXZEqILjrkuOjnIOLqjRLsPydF2cjZQaldU4pE9Mmn2J8PeCZXXBPe/u5JhKp6x3itKrbgncvJ7YCkR5LtSU58Dy1RP23LGy/C23qPBIPpfMWkgiVM0l/TyGbLVs8FAsUHYffX3o4kBuxiboUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZO0pr5oK; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 20 Aug 2025 22:40:29 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755700842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EcoFwzHSYrp+NY5s6PC1QvTSYtJuMsbUmRJhhxFBMK8=;
	b=ZO0pr5oKnEqT1iYmsMop0hBVSVyepMAvMrr5XQLeUU2tbWsGefS0c03EleG0w7NWqMQgOj
	tqsKnbjLTInR/2uoElcN6OvKd9AeMtj5Tz8S28UBaDegjd7FWOwujRDcTOWDDCgsupQL6l
	r+rlamPptN+vnegDZaDJj0eyerRJ5jc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Troy Mitchell <troy.mitchell@linux.dev>
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Troy Mitchell <troy.mitchell@linux.dev>
Subject: Re: [PATCH v3 2/2] RISC-V KVM: Remove unnecessary HGATP csr_read
Message-ID: <aKXeXd4pZvoQmYB9@troy-wujie14pro-arch>
References: <20250820125952.71689-1-fangyu.yu@linux.alibaba.com>
 <20250820125952.71689-3-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820125952.71689-3-fangyu.yu@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 20, 2025 at 08:59:52PM +0800, fangyu.yu@linux.alibaba.com wrote:
> From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
> 
> The HGATP has been set to zero in gstage_mode_detect(), so there
> is no need to save the old context. Unify the code convention
> with gstage_mode_detect().
> 
> Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>  arch/riscv/kvm/vmid.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 5f33625f4070..abb1c2bf2542 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -25,15 +25,12 @@ static DEFINE_SPINLOCK(vmid_lock);
>  
>  void __init kvm_riscv_gstage_vmid_detect(void)
>  {
> -	unsigned long old;
> -
>  	/* Figure-out number of VMID bits in HW */
> -	old = csr_read(CSR_HGATP);
>  	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
>  	vmid_bits = csr_read(CSR_HGATP);
>  	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>  	vmid_bits = fls_long(vmid_bits);
> -	csr_write(CSR_HGATP, old);
> +	csr_write(CSR_HGATP, 0);
Is setting HGATP to 0 in gstage_mode_detect meaningless now?
If so, it might be better to drop it and just keep the one here.

                - Troy

>  
>  	/* We polluted local TLB so flush all guest TLB */
>  	kvm_riscv_local_hfence_gvma_all();
> -- 
> 2.49.0
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

