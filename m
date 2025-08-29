Return-Path: <kvm+bounces-56259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6B2B3B616
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75ECD170071
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8B828BAAC;
	Fri, 29 Aug 2025 08:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RNa4l3rA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3CB261B6D;
	Fri, 29 Aug 2025 08:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756456573; cv=none; b=n+oYPd04t61KUgkeP1fMQAafU1KFZX4PZN3lfIKaHFKxb70pHzy6t0fdxQcHwm+M36dx4J9+Of5yRZv9c35xxAT7pqQpQOF9yNkcbwKg084ZTHv/z2mFtY/4W1xDuqCGWzj5zJKz4ilSli4JnA9AagfN5oLqDsOtSrLY/yY8u9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756456573; c=relaxed/simple;
	bh=5R3PiaH2SsTjygw7nEc7tUK9X0T82EoOkBxOtg0c4+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nvjwip8r1TD7Mje80MteVhg0Xi0xi/ia9G35APO0HnnCDb67fh3xi2cLoP9/RCV/Sbkueq/NWG0MISjAavfmrm14dg273VNiqHEQDs657IxpDn2ArFU+3a7+jurf4WSOcGqTCfVYM9vEFlvALj1k2X9dTZj7xo24Ykj/GYbtc1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RNa4l3rA; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756456572; x=1787992572;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5R3PiaH2SsTjygw7nEc7tUK9X0T82EoOkBxOtg0c4+w=;
  b=RNa4l3rAcxrXzI2MeTfiwxxqlFGuVk/ttfcIN8Jz05uDRVxWfIXawXIt
   TzlRTHCSF3q0Uu9QPuMizYWFlTq7zKTREbO2GOt0Z9oCNo+/C3QMw0O6l
   QNwPhIIX06jaCB5qFztrxigk0IWd4xzy4c6VAgQeKwGvBbVEoIgbuD1fz
   oQMq/Qa0OfYI5+BurlDbNX7L5s1aID7dsckWNkHyxXo6gRRPEcfuAnCxV
   5P7QNTwkIFPvk+Z92hJAzJhhCZ8dYSEI+zXnc5CtykXeixQvc6Os8pkPu
   8dzt4G73bw9Zbv5/OYvXjTQHNI1wZ5okje+mMqS/JcXI79Hm1bhjrEQar
   w==;
X-CSE-ConnectionGUID: DxwxGqAeROKLTCMhXvcENw==
X-CSE-MsgGUID: IX8uDgX8TR6da3vP985RwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="70108699"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="70108699"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 01:36:11 -0700
X-CSE-ConnectionGUID: rbYMPec8RiC/dx+NrNWYDQ==
X-CSE-MsgGUID: rH1c+3TaRpGbAPoWWGQ1DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="201271655"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 01:36:07 -0700
Message-ID: <84ccd200-d457-4b67-864d-d40d6aa732ac@linux.intel.com>
Date: Fri, 29 Aug 2025 16:36:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-6-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250829000618.351013-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/2025 8:06 AM, Sean Christopherson wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
>
> Don't explicitly pin pages when mapping pages into the S-EPT, guest_memfd
> doesn't support page migration in any capacity, i.e. there are no migrate
> callbacks because guest_memfd pages *can't* be migrated.  See the WARN in
> kvm_gmem_migrate_folio().
>
> Eliminating TDX's explicit pinning will also enable guest_memfd to support
> in-place conversion between shared and private memory[1][2].  Because KVM
> cannot distinguish between speculative/transient refcounts and the
> intentional refcount for TDX on private pages[3], failing to release
> private page refcount in TDX could cause guest_memfd to indefinitely wait
> on decreasing the refcount for the splitting.
>
> Under normal conditions, not holding an extra page refcount in TDX is safe
> because guest_memfd ensures pages are retained until its invalidation
> notification to KVM MMU is completed. However, if there're bugs in KVM/TDX
> module, not holding an extra refcount when a page is mapped in S-EPT could
> result in a page being released from guest_memfd while still mapped in the
> S-EPT.  But, doing work to make a fatal error slightly less fatal is a net
> negative when that extra work adds complexity and confusion.
>
> Several approaches were considered to address the refcount issue, including
>    - Attempting to modify the KVM unmap operation to return a failure,
>      which was deemed too complex and potentially incorrect[4].
>   - Increasing the folio reference count only upon S-EPT zapping failure[5].
>   - Use page flags or page_ext to indicate a page is still used by TDX[6],
>     which does not work for HVO (HugeTLB Vmemmap Optimization).
>    - Setting HWPOISON bit or leveraging folio_set_hugetlb_hwpoison()[7].
Nit: alignment issue with the bullets.

Otherwise,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> Due to the complexity or inappropriateness of these approaches, and the
> fact that S-EPT zapping failure is currently only possible when there are
> bugs in the KVM or TDX module, which is very rare in a production kernel,
> a straightforward approach of simply not holding the page reference count
> in TDX was chosen[8].
>
> When S-EPT zapping errors occur, KVM_BUG_ON() is invoked to kick off all
> vCPUs and mark the VM as dead. Although there is a potential window that a
> private page mapped in the S-EPT could be reallocated and used outside the
> VM, the loud warning from KVM_BUG_ON() should provide sufficient debug
> information. To be robust against bugs, the user can enable panic_on_warn
> as normal.
>
> Link: https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com [1]
> Link: https://youtu.be/UnBKahkAon4 [2]
> Link: https://lore.kernel.org/all/CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com [3]
> Link: https://lore.kernel.org/all/aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com [4]
> Link: https://lore.kernel.org/all/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh.intel.com [5]
> Link: https://lore.kernel.org/all/aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com [6]
> Link: https://lore.kernel.org/all/diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com [7]
> Link: https://lore.kernel.org/all/53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com [8]
> Suggested-by: Vishal Annapurve <vannapurve@google.com>
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> [sean: extract out of hugepage series, massage changelog accordingly]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 28 ++++------------------------
>   1 file changed, 4 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c83e1ff02827..f24f8635b433 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1586,29 +1586,22 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>   	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
>   }
>   
> -static void tdx_unpin(struct kvm *kvm, struct page *page)
> -{
> -	put_page(page);
> -}
> -
>   static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> -			    enum pg_level level, struct page *page)
> +			    enum pg_level level, kvm_pfn_t pfn)
>   {
>   	int tdx_level = pg_level_to_tdx_sept_level(level);
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct page *page = pfn_to_page(pfn);
>   	gpa_t gpa = gfn_to_gpa(gfn);
>   	u64 entry, level_state;
>   	u64 err;
>   
>   	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
> -	if (unlikely(tdx_operand_busy(err))) {
> -		tdx_unpin(kvm, page);
> +	if (unlikely(tdx_operand_busy(err)))
>   		return -EBUSY;
> -	}
>   
>   	if (KVM_BUG_ON(err, kvm)) {
>   		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
> -		tdx_unpin(kvm, page);
>   		return -EIO;
>   	}
>   
> @@ -1642,29 +1635,18 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   				     enum pg_level level, kvm_pfn_t pfn)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -	struct page *page = pfn_to_page(pfn);
>   
>   	/* TODO: handle large pages. */
>   	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
>   		return -EINVAL;
>   
> -	/*
> -	 * Because guest_memfd doesn't support page migration with
> -	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
> -	 * migration.  Until guest_memfd supports page migration, prevent page
> -	 * migration.
> -	 * TODO: Once guest_memfd introduces callback on page migration,
> -	 * implement it and remove get_page/put_page().
> -	 */
> -	get_page(page);
> -
>   	/*
>   	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
>   	 * barrier in tdx_td_finalize().
>   	 */
>   	smp_rmb();
>   	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> -		return tdx_mem_page_aug(kvm, gfn, level, page);
> +		return tdx_mem_page_aug(kvm, gfn, level, pfn);
>   
>   	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
>   }
> @@ -1715,7 +1697,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		return -EIO;
>   	}
>   	tdx_clear_page(page);
> -	tdx_unpin(kvm, page);
>   	return 0;
>   }
>   
> @@ -1795,7 +1776,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>   	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
>   	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
>   		atomic64_dec(&kvm_tdx->nr_premapped);
> -		tdx_unpin(kvm, page);
>   		return 0;
>   	}
>   


