Return-Path: <kvm+bounces-66517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E9AD8CD6E0B
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 19:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 207C23014DC9
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DEC332EAD;
	Mon, 22 Dec 2025 18:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fFWvoW/7"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1620332EA3
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 18:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766427091; cv=none; b=QSy15mhX6JZ4Yvnfjl1BdayQytAF2hVJtQPcCCxChe6IYQpNZ3d/sIET40oPNXjrQw/01eNiW5PXm6FgnDYZ8FbdaGUTwuMTqh9Kr1SidKTo5TUUKapkpTRfANDurAtmvBlHkMhui/cCUHqYG5OLI/z0hOJHdQ4MZzB7w3JpJag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766427091; c=relaxed/simple;
	bh=VOEhbTVHGJEW5F4jwUMTelawd4Q5UO+9aKLUv7kG2Ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QswdTcybSh85mbavU5mHG9d6FOTeDrIQAZCr7kOuF0N5E361vpWvogxTUOhteou2OurWjN/jBIKvk/6ak1G8DbMG/D2mtVkwvdkt4goEQMmcS5/wSABAG5PHmzwWkrDviRac09yw/KQ0c2Etz4N1zFSSAXaYGMWpx5Ya0UsJkpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fFWvoW/7; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 22 Dec 2025 12:11:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766427082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/toT1W7OTQvTEtD4gZRzA7tSobi23a6qTYqR+de5foM=;
	b=fFWvoW/7kSGLJp45pHDVtgX9vgb+7so0qkJceS3LAGTyR1KaxF3L+F72RF4P9zBGHGrYUm
	aVaaQEkrE3EKHvupvEsBRhRlekKnoRyTkn4kjqm+11ROVQfl6TfmMiQ0RG7VjXg0tycJia
	qLd1QfPUM+9xCRLaIPN+tDyVVMt3i0Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org
Subject: Re: [PATCH v2 4/5] KVM: selftests: Move page_align() to shared header
Message-ID: <20251222-ed460d0e29ab66fb4987e365@orel>
References: <20251215165155.3451819-1-tabba@google.com>
 <20251215165155.3451819-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215165155.3451819-5-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 04:51:54PM +0000, Fuad Tabba wrote:
> To avoid code duplication, move page_align() to the shared `kvm_util.h`
> header file.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
>  tools/testing/selftests/kvm/lib/arm64/processor.c | 5 -----
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 5 -----
>  3 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 81f4355ff28a..dabbe4c3b93f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
>  	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
>  }
>  
> +static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> +{
> +	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> +}
> +
>  /*
>   * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
>   * to allow for arch-specific setup that is common to all tests, e.g. computing
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> index 607a4e462984..143632917766 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -21,11 +21,6 @@
>  
>  static vm_vaddr_t exception_handlers;
>  
> -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> -{
> -	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> -}
> -
>  static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
>  {
>  	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index d5e8747b5e69..f8ff4bf938d9 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -26,11 +26,6 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
>  	return !ret && !!value;
>  }
>  
> -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> -{
> -	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> -}
> -
>  static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
>  {
>  	return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 
>

kvm_util.h is collecting a bit too much random stuff and it'd be nice to
split stuff out rather than add more, but, for now, this is an overall
improvement since we kill some duplication.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

