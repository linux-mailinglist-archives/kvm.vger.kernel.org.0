Return-Path: <kvm+bounces-20050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C9390FF3E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 10:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6043FB22AEC
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 08:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F008319FA72;
	Thu, 20 Jun 2024 08:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gTypdvf2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C0C19DF64;
	Thu, 20 Jun 2024 08:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718873075; cv=none; b=oBS5XdPGKQ7bOJaLi7Mq6yzaoMCMbYoy9Dbk2Hw/wTBinmDsIRFShmd8ThEIjB6W7HM3naFNwjL42O0nTUrv5T+PMs4QZ2miBa51nXIkB9jbZqU3QpsbxkvabhHQO/2km099ndQJtzkelPXOrty6/N4TeGKTX7JZwmCRXSvzWis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718873075; c=relaxed/simple;
	bh=ly4NBxLP+IfyhZ72WkmAB+qyAyjntow6va62j+tSK2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KH8GDtE5G1WftnwKjpMHU+EyyIVGS6bZ5RmpC4odQIueL+r+ycgvj7QL6T/6ii3iyVfCWnKvf9ODznvgViy7O2rPbHtFoiPt3hzStI7BVRQ+3uMzbFOIx4wYb9kHLxpNIJfCY/JS+wSNRezqNRf3+OE8Id9HuWyANc5MQrzuiTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gTypdvf2; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718873073; x=1750409073;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ly4NBxLP+IfyhZ72WkmAB+qyAyjntow6va62j+tSK2U=;
  b=gTypdvf2zXBl3rla69Jsp4CJFxItYbzeZm0AveuQXB04RotC8SKNa7j8
   ogY4e4Y5mPcnlH33ZdMCRzZ2x6e7ERtRKSHDckac5w9DZJ4438QjYLjgP
   2krAWlrBXsSNgr79qjifmvc6I1C3Hu5eRLmGPw75WMNPOZkJB5beAgI4t
   Bz1Ea3k/C7WrIz2TGev9H3taB8tAnV4hoecWrnxc/r2cdC7zPj1VXsJ3+
   ktEfp9F4+P2tkmXOFLP6gC29qhPj9a6G0BC7zoo2RMjZznbbCbduC1mdK
   5rKRsJ/UfdxRm+ZnDQlmBsxfr4UuXhj+ObwHY5mdlCrxIdcNYVteLsv2r
   Q==;
X-CSE-ConnectionGUID: 6LMvOpSpTfaUNVbl5k6aVg==
X-CSE-MsgGUID: Yfwz9aClTS2iDrH2L9WoVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15955090"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15955090"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 01:44:32 -0700
X-CSE-ConnectionGUID: 1hFuia17TUqkjulNsFs3Zg==
X-CSE-MsgGUID: QLcnBzIPRSuRIohfM/K9lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="42051034"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.224.116]) ([10.124.224.116])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 01:44:29 -0700
Message-ID: <e693adab-9fa3-47fd-b62f-c3f2589ffe7f@linux.intel.com>
Date: Thu, 20 Jun 2024 16:44:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/17] KVM: x86/tdp_mmu: Propagate tearing down mirror
 page tables
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, dmatlack@google.com, erdemaktas@google.com,
 isaku.yamahata@gmail.com, linux-kernel@vger.kernel.org, sagis@google.com,
 yan.y.zhao@intel.com, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-17-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240619223614.290657-17-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/20/2024 6:36 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Integrate hooks for mirroring page table operations for cases where TDX
> will zap PTEs or free page tables.
>
> Like other Coco technologies, TDX has the concept of private and shared
> memory. For TDX the private and shared mappings are managed on separate
> EPT roots. The private half is managed indirectly though calls into a
> protected runtime environment called the TDX module, where the shared half
> is managed within KVM in normal page tables.
>
> Since calls into the TDX module are relatively slow, walking private page
> tables by making calls into the TDX module would not be efficient. Because
> of this, previous changes have taught the TDP MMU to keep a mirror root,
> which is separate, unmapped TDP root that private operations can be
> directed to. Currently this root is disconnected from the guest. Now add
> plumbing to propagate changes to the "external" page tables being
> mirrored. Just create the x86_ops for now, leave plumbing the operations
> into the TDX module for future patches.
>
> Add two operations for tearing down page tables, one for freeing page
> tables (free_external_spt) and one for zapping PTEs (remove_external_spte).
> Define them such that remove_external_spte will perform a TLB flush as
> well. (in TDX terms "ensure there are no active translations").
>
> TDX MMU support will exclude certain MMU operations, so only plug in the
> mirroring x86 ops where they will be needed. For zapping/freeing, only
> hook tdp_mmu_iter_set_spte() which is use used for mapping and linking
                                         ^
                                         extra "use"

Also, this sentence is a bit confusing about "used for mapping and linking".

> PTs. Don't bother hooking tdp_mmu_set_spte_atomic() as it is only used for
> zapping PTEs in operations unsupported by TDX: zapping collapsible PTEs and
> kvm_mmu_zap_all_fast().
>
> In previous changes to address races around concurrent populating using
> tdp_mmu_set_spte_atomic(), a solution was introduced to temporarily set
> REMOVED_SPTE in the mirrored page tables while performing the external
   ^
  FROZEN_SPTE

> operations. Such a solution is not needed for the tear down paths in TDX
> as these will always be performed with the mmu_lock held for write.
> Sprinkle some KVM_BUG_ON()s to reflect this.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU Prep v3:
>   - Rename mirrored->external (Paolo)
>   - Drop new_spte arg from reflect_removed_spte() (Paolo)
>   - ...and drop was_present and is_present bools (Paolo)
>   - Use base_gfn instead of sp->gfn (Paolo)
>   - Better comment on logic that bugs if doing tdp_mmu_set_spte() on
>     present PTE. (Paolo)
>   - Move comment around KVM_BUG_ON() in __tdp_mmu_set_spte_atomic() to this
>     patch, and add better comment. (Paolo)
>   - In remove_external_spte(), remove was_leaf bool, skip duplicates
>     present check and add comment.
>   - Rename REMOVED_SPTE to FROZEN_SPTE (Paolo)
>
> TDX MMU Prep v2:
>   - Split from "KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU"
>   - Rename x86_ops from "private" to "reflect"
>   - In response to "sp->mirrored_spt" rename helpers to "mirrored"
>   - Remove unused present mirroring support in tdp_mmu_set_spte()
>   - Merge reflect_zap_spte() into reflect_remove_spte()
>   - Move mirror zapping logic out of handle_changed_spte()
>   - Add some KVM_BUG_ONs
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>   arch/x86/include/asm/kvm_host.h    |  8 +++++
>   arch/x86/kvm/mmu/tdp_mmu.c         | 51 +++++++++++++++++++++++++++++-
>   3 files changed, 60 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 3ef19fcb5e42..18a83b211c90 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -97,6 +97,8 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
>   KVM_X86_OP_OPTIONAL(link_external_spt)
>   KVM_X86_OP_OPTIONAL(set_external_spte)
> +KVM_X86_OP_OPTIONAL(free_external_spt)
> +KVM_X86_OP_OPTIONAL(remove_external_spte)
>   KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
>   KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 12ff04135a0e..dca623ffa903 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1745,6 +1745,14 @@ struct kvm_x86_ops {
>   	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>   				 kvm_pfn_t pfn_for_gfn);
>   
> +	/* Update external page tables for page table about to be freed */
Nit: Add "." at the end of the sentence.

> +	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				 void *external_spt);
> +
> +	/* Update external page table from spte getting removed, and flush TLB */
Ditto

> +	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				    kvm_pfn_t pfn_for_gfn);
> +
>   	bool (*has_wbinvd_exit)(void);
>   
>   	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
[...]

