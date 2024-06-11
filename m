Return-Path: <kvm+bounces-19297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D688B9031E5
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 07:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B531F1C23F19
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 05:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2EF17107F;
	Tue, 11 Jun 2024 05:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cyEhHRmu"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EBB8488
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 05:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085491; cv=none; b=nSyji67VomtxUXvH8lpscqQnM1XqtxTEJMFXKrMFC0knRvovUCl7SKZ+6GDj8drqR6ZXFVXVuVAu6LfZ8mzmLespW2lTc03qcUrFZOgkxEIaCNucC9UMp0NB8UTTHYy5OwTR2sHIM2GtdpFBhkLpNI2NgQoVZfNnpSeCo2xCUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085491; c=relaxed/simple;
	bh=GBB/Uk8+cudk122GvBiogfdSb49xEZ/DJt19Rw07vxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bKlVgLYXd6cuuVBYaHs0024CFxVtEQQs2PfMYeA6mUjdufFCCzSRhMnYWBT96vdzF91tJ75H6gWjtCiCFLv5XiCVNqzdk+M3VW9A+4I96U5rvoR/9IMlBUwGosi0e21sZts61F5uqyS/SRMOZ5vVfrbhiA1CGu9v3wdcFhjXokM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cyEhHRmu; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jthoughton@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718085486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqiWe39MZdeODszfKFW0wTFxaRO6NFFUSNnRgYQUTLg=;
	b=cyEhHRmuHeeS06ZjBXNkPufgh3B8leCOaQ+2mkGJsxw/fHVbVvUbyAUlYdvNZ9xfM9HCHm
	m4wplQ7pMuC8Dp8TGrb57W3hgjukde4F/i3k4080Q2Pj9PRiHNda6b2hjDUS8A2WB9ueZh
	mwDKUBEjSMLvLDQO1P+3kvVaJ2uaU30=
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: ankita@nvidia.com
X-Envelope-To: axelrasmussen@google.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: dmatlack@google.com
X-Envelope-To: rientjes@google.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: corbet@lwn.net
X-Envelope-To: maz@kernel.org
X-Envelope-To: rananta@google.com
X-Envelope-To: ryan.roberts@arm.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: weixugc@google.com
X-Envelope-To: will@kernel.org
X-Envelope-To: yuzhao@google.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-doc@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-mm@kvack.org
Date: Mon, 10 Jun 2024 22:57:54 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 3/9] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
Message-ID: <ZmfnYnm3K_rHX_VB@linux.dev>
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611002145.2078921-4-jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 11, 2024 at 12:21:39AM +0000, James Houghton wrote:
> Replace the MMU write locks (taken in the memslot iteration loop) for
> read locks.
> 
> Grabbing the read lock instead of the write lock is safe because the
> only requirement we have is that the stage-2 page tables do not get
> deallocated while we are walking them. The stage2_age_walker() callback
> is safe to race with itself; update the comment to reflect the
> synchronization change.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/arm64/kvm/Kconfig       |  1 +
>  arch/arm64/kvm/hyp/pgtable.c | 15 +++++++++------
>  arch/arm64/kvm/mmu.c         | 26 ++++++++++++++++++++------
>  3 files changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 58f09370d17e..7a1af8141c0e 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -22,6 +22,7 @@ menuconfig KVM
>  	select KVM_COMMON
>  	select KVM_GENERIC_HARDWARE_ENABLING
>  	select KVM_GENERIC_MMU_NOTIFIER
> +	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>  	select KVM_MMIO
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 9e2bbee77491..b1b0f7148cff 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1319,10 +1319,10 @@ static int stage2_age_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	data->young = true;
>  
>  	/*
> -	 * stage2_age_walker() is always called while holding the MMU lock for
> -	 * write, so this will always succeed. Nonetheless, this deliberately
> -	 * follows the race detection pattern of the other stage-2 walkers in
> -	 * case the locking mechanics of the MMU notifiers is ever changed.
> +	 * This walk may not be exclusive; the PTE is permitted to change

s/may not/is not/

> +	 * from under us. If there is a race to update this PTE, then the
> +	 * GFN is most likely young, so failing to clear the AF is likely
> +	 * to be inconsequential.
>  	 */
>  	if (data->mkold && !stage2_try_set_pte(ctx, new))
>  		return -EAGAIN;
> @@ -1345,10 +1345,13 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
>  	struct kvm_pgtable_walker walker = {
>  		.cb		= stage2_age_walker,
>  		.arg		= &data,
> -		.flags		= KVM_PGTABLE_WALK_LEAF,
> +		.flags		= KVM_PGTABLE_WALK_LEAF |
> +				  KVM_PGTABLE_WALK_SHARED,
>  	};
> +	int r;
>  
> -	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
> +	r = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	WARN_ON(r && r != -EAGAIN);

I could've been more explicit last time around, could you please tone
this down to WARN_ON_ONCE() as well?

>  	return data.young;
>  }
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8bcab0cc3fe9..a62c27a347ed 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1773,25 +1773,39 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	u64 size = (range->end - range->start) << PAGE_SHIFT;
> +	bool young = false;
> +
> +	read_lock(&kvm->mmu_lock);
>  
>  	if (!kvm->arch.mmu.pgt)
>  		return false;

I'm guessing you meant to have 'goto out' here, since this early return
fails to drop the mmu_lock.

-- 
Thanks,
Oliver

