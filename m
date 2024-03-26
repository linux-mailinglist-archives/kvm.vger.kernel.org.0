Return-Path: <kvm+bounces-12710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1B188CB05
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 18:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C7E71C65CB2
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6894B208A7;
	Tue, 26 Mar 2024 17:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vds0Pkbf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C941CD3F;
	Tue, 26 Mar 2024 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711474461; cv=none; b=Cw5E19fgtlfu8jRekLiV81vvJH5oP7QyOwmLcJprrmIPhLVsXpkudSTAluLucSEi7tNudNz71tA76/v5Dl7DQGUiUbqnPSNRhGmEBDWNNAOUJBR1mi6nEhNgk7CSlNMTHUfn7FtK2xWs0aybDygYY/sYSt/rUGFEQ8JLCfqXEv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711474461; c=relaxed/simple;
	bh=PP2+ULTolFHZ6Yk2NHBFIy4YY1fXuiQgaFH7sDpUkzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQzyKMHyIm13AUX8V5Mee7eQxqk9q872+dDKcF14k+ELSqgtqmewByi1NCNkyXkt6Hrmkhr2DP35rolwTk4QB3ZsHWA/ZLOgUnsWHljhzvQ3dsn9eM6HiPHmL9M7nA18IZozv6QDtBvJxaJZFb2x452xsr+oXqZZzhw6kQ9B6Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vds0Pkbf; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711474459; x=1743010459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PP2+ULTolFHZ6Yk2NHBFIy4YY1fXuiQgaFH7sDpUkzY=;
  b=Vds0PkbfEO3VkHWO/9dODTzy7j5+RvjPDSIxRoC4KkDQjmlQfUvL9tpN
   Ngh+5dPhG3drcHLlU1/0GEGDe68CNZIUBChCpaw3yyxvS25RPp12e4pP1
   QjkBQviektM4PP/F8m4aHRKUrEUocvnsRBZSAfs4LBEn5lJDB3QhrjIft
   3onDqCq9/+nrCU8x5Tk4hIDGVCZ0+YXoyV0vuXiUMvs6JG87NDGkr3Jxk
   F/Mhq9GZLdRT63enVnzrThEruzTZXM7gUOad35zo9q4B/YG/F+cIkyLsB
   iYWZoxIiYW0Eh7qusbpMy39xck/dpZWRe9z7BuFeyLfpvKAWYvhZoQWHl
   A==;
X-CSE-ConnectionGUID: sbjI3EQWQu+oLngKAChAUg==
X-CSE-MsgGUID: INtoZqSVTPGD4JqUIPVsuQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="29020005"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="29020005"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 10:34:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="15942645"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 10:34:16 -0700
Date: Tue, 26 Mar 2024 10:34:14 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 048/130] KVM: Allow page-sized MMU caches to be
 initialized with custom 64-bit values
Message-ID: <20240326173414.GA2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c392612eac4f3c489ad12dd4a4d505cf10d36dc.1708933498.git.isaku.yamahata@intel.com>
 <d2ea2f8e-80b1-4dda-bf47-2145859e7463@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d2ea2f8e-80b1-4dda-bf47-2145859e7463@linux.intel.com>

On Tue, Mar 26, 2024 at 11:53:02PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Add support to MMU caches for initializing a page with a custom 64-bit
> > value, e.g. to pre-fill an entire page table with non-zero PTE values.
> > The functionality will be used by x86 to support Intel's TDX, which needs
> > to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
> > faults from getting reflected into the guest (Intel's EPT Violation #VE
> > architecture made the less than brilliant decision of having the per-PTE
> > behavior be opt-out instead of opt-in).
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   include/linux/kvm_types.h |  1 +
> >   virt/kvm/kvm_main.c       | 16 ++++++++++++++--
> >   2 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index 9d1f7835d8c1..60c8d5c9eab9 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -94,6 +94,7 @@ struct gfn_to_pfn_cache {
> >   struct kvm_mmu_memory_cache {
> >   	gfp_t gfp_zero;
> >   	gfp_t gfp_custom;
> > +	u64 init_value;
> >   	struct kmem_cache *kmem_cache;
> >   	int capacity;
> >   	int nobjs;
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index de38f308738e..d399009ef1d7 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -401,12 +401,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
> >   static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> >   					       gfp_t gfp_flags)
> >   {
> > +	void *page;
> > +
> >   	gfp_flags |= mc->gfp_zero;
> >   	if (mc->kmem_cache)
> >   		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> > -	else
> > -		return (void *)__get_free_page(gfp_flags);
> > +
> > +	page = (void *)__get_free_page(gfp_flags);
> > +	if (page && mc->init_value)
> > +		memset64(page, mc->init_value, PAGE_SIZE / sizeof(mc->init_value));
> 
> Do we need a static_assert() to make sure mc->init_value is 64bit?

I don't see much value.  Is your concern sizeof() part?
If so, we can replace it with 8.

        memset64(page, mc->init_value, PAGE_SIZE / 8);
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

