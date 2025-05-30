Return-Path: <kvm+bounces-48096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7E2AC8C1E
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 12:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7775173D25
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 10:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4502236F3;
	Fri, 30 May 2025 10:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MB2EYJ5h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD622222BB;
	Fri, 30 May 2025 10:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748600926; cv=none; b=rrahNwGIVI6LlWOZDgeV/Lpz6e6cbVRwRCaVQxbSBN4xB3Xw5HDQX4HRG2NCQ+c9NXBfa7nEflwL9UDdSlciEBoY5ldPDaDr0UgO7kxcMsEptVMmrwAjfvtCx4RxIaRo8rp505sxdbdPTUje7RBd5PXOpSj0UZG3QJZ1pl7QGes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748600926; c=relaxed/simple;
	bh=aWZEgxSVS4Ru0ExtQ69W5ibS4LzCBJTNvFmwCjQNAxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttgwNFQ156IpUh/G/1Z3uRTqLMtIwWoozhwTOLLIK3wX4TDPcdSQpbdqCDrLI4ZAYIEDpb9dBDMznZdGE7quKFXyWHySJPcrjWDq6Lj9Ne9eNKfQYVwMplD+Vis0h0r0aiD7kPtDJDr59c1kXNAphEn/RKCDgQU2QbWawdpzzLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MB2EYJ5h; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748600925; x=1780136925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aWZEgxSVS4Ru0ExtQ69W5ibS4LzCBJTNvFmwCjQNAxU=;
  b=MB2EYJ5hramnsP7B151L3FvWNvS2W7+Jh8KcM0LwlmyVMTSu6mHLzFBW
   2xhTDIa0kk53AW/8aeDFqPlKMvmh2BrI/aR63oSY887v67NEiU+PeU/Ls
   6wf+bKXPLG9GsDLUprc70aiGGMYV/YZj5bcy03Khgf3W5Db4ksHRyrgQa
   Nz+9dA5LGZuRDtlTow3aYmkbQz5TxLSsQNxNXS1VlgxRohuC2ClQvt/rA
   6F9SpPQj6uD+nn8p6vmNsAkctX/fSqYmucInJF7Rpu9BZD52IOi0rsOS/
   paJpA7FBygbXtaKEEGUX45plZ1MrZTlgEEqLDJyuffCDSZK6QJzqJpyHQ
   A==;
X-CSE-ConnectionGUID: WD7tVe8PTo+AUTjzZwONbA==
X-CSE-MsgGUID: JFl4Olc4SyCNyq/oXBIf5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="49931257"
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="49931257"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2025 03:28:44 -0700
X-CSE-ConnectionGUID: 72d97e1oRRuHDdHUHh2R7w==
X-CSE-MsgGUID: 62XjU1h0SY2jnZyOT+HBlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="181054375"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa001.jf.intel.com with ESMTP; 30 May 2025 03:28:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 3526214B; Fri, 30 May 2025 13:28:39 +0300 (EEST)
Date: Fri, 30 May 2025 13:28:39 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, yan.y.zhao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 09/12] KVM: TDX: Preallocate PAMT pages to be used
 in page fault path
Message-ID: <dtptwhf2si2n2ksz746p67v5oib7h7l7bz57hvxd6rmxne7nht@fvodz653v5nf>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-10-kirill.shutemov@linux.intel.com>
 <aCQ4imYKThyxOWuT@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCQ4imYKThyxOWuT@intel.com>

On Wed, May 14, 2025 at 02:30:34PM +0800, Chao Gao wrote:
> On Fri, May 02, 2025 at 04:08:25PM +0300, Kirill A. Shutemov wrote:
> >Preallocate a page to be used in the link_external_spt() and
> >set_external_spte() paths.
> >
> >In the worst-case scenario, handling a page fault might require a
> >tdx_nr_pamt_pages() pages for each page table level.
> >
> >Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> >---
> > arch/x86/include/asm/kvm_host.h |  2 ++
> > arch/x86/kvm/mmu/mmu.c          | 10 ++++++++++
> > 2 files changed, 12 insertions(+)
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >index 91958c55f918..a5661499a176 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -849,6 +849,8 @@ struct kvm_vcpu_arch {
> > 	 */
> > 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
> > 
> >+	struct kvm_mmu_memory_cache pamt_page_cache;
> >+
> > 	/*
> > 	 * QEMU userspace and the guest each have their own FPU state.
> > 	 * In vcpu_run, we switch between the user and guest FPU contexts.
> >diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >index a284dce227a0..7bfa0dc50440 100644
> >--- a/arch/x86/kvm/mmu/mmu.c
> >+++ b/arch/x86/kvm/mmu/mmu.c
> >@@ -616,6 +616,15 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> > 		if (r)
> > 			return r;
> > 	}
> >+
> >+	if (vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM) {
> 
> The check for vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM is identical to
> kvm_has_mirrored_tdp() a few lines above.

Well, yes. But I think it is conceptually different. There can be
different virtualization mode that has mirrored TDP which is not TDX.

> 
> >+		int nr = tdx_nr_pamt_pages(tdx_get_sysinfo());
> 
> Since you're already accessing tdx_sysinfo, you can check if dynamic PAMT is
> enabled and allocate the pamt page cache accordingly.

I will hide it in tdx_nr_pamt_pages() which would return 0 if Dynamic PAMT
is disabled.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

