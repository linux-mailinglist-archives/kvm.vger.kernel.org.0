Return-Path: <kvm+bounces-47534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD8EAC1FEC
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E0D67AC412
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77781225788;
	Fri, 23 May 2025 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lGuDO/M6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DEC225791;
	Fri, 23 May 2025 09:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747993360; cv=none; b=M1NEjrGbs11SkcVezBFGBLu3a9We59yJIxjJcEDSDDANJ+WmubCFs0lfrVKRo7T1VRUfqDv58KfbHdIruge793DTYLUZPhdMeeGFkFtLBfHKvhKtPn+EkqV/YAlCYt7lPviVzQgaGJHfsUv6xpkZrlCpJtuWda6+p715a8IKoTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747993360; c=relaxed/simple;
	bh=HTv5n/07yQDXRcvHu7hgHboQDCuLAObub0zu/q5SUpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f9KkHMJ8hzdiQtiM0QNMrjOgr9xXHIrllrlnJatJ+jTTTHyXx1TBEnX6h6ibbfGkLKw7KW6r/pIqdlKnqa1SUT8D68lhhhxBzwmBiUOFRu28Q/3+UioROni1oif5qdUl/8lCbPqoAcD3HlLvnLSHoPdGtcMvNanl3FEH9+EXmxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lGuDO/M6; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747993358; x=1779529358;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HTv5n/07yQDXRcvHu7hgHboQDCuLAObub0zu/q5SUpQ=;
  b=lGuDO/M6dPmMtmal2h1az0bXDpHY3e2mF9Yb5/MaxZZ5AlmxksMOjjYl
   zUKbOiv54Z4hqaFTuV+QnUUNyFQP1Cz+zUl6Fy0qUNLSseGbLy662lde/
   j8K7TIGlPF4AA3MrDPxgw0mK4XvOcIsKeaTIDsAFGAU0fP3oLtYUhRSHd
   zS4SWYhcUuf2Yk9MzNuHu0VLvEk6hFi1SrP9hRtrv3aDNV5VnaEJsa3CP
   h3w+XUNRVJwLPc+r9O4Kw+wIE0LBv4/u59my3i+uMawQOBE+AcuaHLW6l
   7PulollS2+SxkwuoVXQf2nnuCqDLKNyumdEaPJEVNhJckS5TVpF0K3viL
   g==;
X-CSE-ConnectionGUID: ZLA8p51sSH+kXcQpvvC4iw==
X-CSE-MsgGUID: 5Trn/YZhSryEbUzw7k2m5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="53708209"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="53708209"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:42:33 -0700
X-CSE-ConnectionGUID: hOxvX2gASa28jbO31Jgjcg==
X-CSE-MsgGUID: TyN87VgmSxKXY9jL14NPig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="145907308"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa005.fm.intel.com with ESMTP; 23 May 2025 02:42:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id CB8491F6; Fri, 23 May 2025 12:42:27 +0300 (EEST)
Date: Fri, 23 May 2025 12:42:27 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <xjl4nloxtmp7jrfus5rnij6xz6ut6p7riixj7mwt32zlkc7k27@xvallgw2ei7r>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>

On Mon, May 05, 2025 at 12:44:26PM +0000, Huang, Kai wrote:
> On Fri, 2025-05-02 at 16:08 +0300, Kirill A. Shutemov wrote:
> > Introduce a pair of helpers to allocate and free memory for a given 2M
> > range. The range is represented by struct page for any memory in the
> > range and the PAMT memory by a list of pages.
> > 
> > Use per-2M refcounts to detect when PAMT memory has to be allocated and
> > when it can be freed.
> > 
> > pamt_lock spinlock serializes against races between multiple
> > tdx_pamt_add() as well as tdx_pamt_add() vs tdx_pamt_put().
> 
> Maybe elaborate a little bit on _why_ using spinlock?
> 
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/include/asm/tdx.h   |   2 +
> >  arch/x86/kvm/vmx/tdx.c       | 123 +++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/tdx_errno.h |   1 +
> >  3 files changed, 126 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index 8091bf5b43cc..42449c054938 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -135,6 +135,8 @@ static inline int tdx_nr_pamt_pages(const struct tdx_sys_info *sysinfo)
> >  	return sysinfo->tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
> >  }
> >  
> > +atomic_t *tdx_get_pamt_refcount(unsigned long hpa);
> > +
> 
> This at least needs to be in the same patch which exports it.  But as replied to
> patch 2, I think we should just move the code in this patch to TDX core code.
> 
> >  int tdx_guest_keyid_alloc(void);
> >  u32 tdx_get_nr_guest_keyids(void);
> >  void tdx_guest_keyid_free(unsigned int keyid);
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index b952bc673271..ea7e2d93fb44 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -207,6 +207,10 @@ static bool tdx_operand_busy(u64 err)
> >  	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY;
> >  }
> >  
> > +static bool tdx_hpa_range_not_free(u64 err)
> > +{
> > +	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_HPA_RANGE_NOT_FREE;
> > +}
> >  
> >  /*
> >   * A per-CPU list of TD vCPUs associated with a given CPU.
> > @@ -276,6 +280,125 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> >  	vcpu->cpu = -1;
> >  }
> >  
> > +static DEFINE_SPINLOCK(pamt_lock);
> > +
> > +static void tdx_free_pamt_pages(struct list_head *pamt_pages)
> > +{
> > +	struct page *page;
> > +
> > +	while ((page = list_first_entry_or_null(pamt_pages, struct page, lru))) {
> > +		list_del(&page->lru);
> > +		__free_page(page);
> > +	}
> > +}
> > +
> > +static int tdx_alloc_pamt_pages(struct list_head *pamt_pages)
> > +{
> > +	for (int i = 0; i < tdx_nr_pamt_pages(tdx_sysinfo); i++) {
> > +		struct page *page = alloc_page(GFP_KERNEL);
> > +		if (!page)
> > +			goto fail;
> > +		list_add(&page->lru, pamt_pages);
> > +	}
> > +	return 0;
> > +fail:
> > +	tdx_free_pamt_pages(pamt_pages);
> > +	return -ENOMEM;
> > +}
> > +
> > +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> > +			struct list_head *pamt_pages)
> > +{
> > +	u64 err;
> > +
> > +	hpa = ALIGN_DOWN(hpa, SZ_2M);
> > +
> > +	spin_lock(&pamt_lock);
> 
> Just curious, Can the lock be per-2M-range?
> 
> > +
> > +	/* Lost race to other tdx_pamt_add() */
> > +	if (atomic_read(pamt_refcount) != 0) {
> > +		atomic_inc(pamt_refcount);
> > +		spin_unlock(&pamt_lock);
> > +		tdx_free_pamt_pages(pamt_pages);
> 
> It's unfortunate multiple caller of tdx_pamt_add() needs to firstly allocate
> PAMT pages by the caller out of the spinlock and then free them here.
> 
> I am thinking if we make tdx_pamt_add() return:
> 
> 	* > 0: PAMT pages already added (another tdx_pamt_add() won)
> 	* = 0: PAMT pages added successfully
> 	* < 0: error code
> 
> .. then we at least could move tdx_free_pamt_pages() to the caller too.
> 
> > +		return 0;
> > +	}
> > +
> > +	err = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pages);
> > +
> > +	if (err)
> > +		tdx_free_pamt_pages(pamt_pages);
> 
> Seems we are calling tdx_free_pamt_pages() within spinlock, which is not
> consistent with above when another tdx_pamt_add() has won the race.
> 
> > +
> > +	/*
> > +	 * tdx_hpa_range_not_free() is true if current task won race
> > +	 * against tdx_pamt_put().
> > +	 */
> > +	if (err && !tdx_hpa_range_not_free(err)) {
> > +		spin_unlock(&pamt_lock);
> > +		pr_tdx_error(TDH_PHYMEM_PAMT_ADD, err);
> > +		return -EIO;
> > +	}
> 
> I had hard time to figure out why we need to handle tdx_hpa_range_not_free()
> explicitly.  IIUC, it is because atomic_dec_and_test() is used in
> tdx_pamt_put(), in which case the atomic_t can reach to 0 outside of the
> spinlock thus tdh_phymem_pamt_add() can be called when there's still PAMT pages
> populated.
> 
> But ...
> 
> > +
> > +	atomic_set(pamt_refcount, 1);
> > +	spin_unlock(&pamt_lock);
> > +	return 0;
> > +}
> > +
> > +static int tdx_pamt_get(struct page *page)
> > +{
> > +	unsigned long hpa = page_to_phys(page);
> > +	atomic_t *pamt_refcount;
> > +	LIST_HEAD(pamt_pages);
> > +
> > +	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
> > +		return 0;
> > +
> > +	pamt_refcount = tdx_get_pamt_refcount(hpa);
> > +	WARN_ON_ONCE(atomic_read(pamt_refcount) < 0);
> > +
> > +	if (atomic_inc_not_zero(pamt_refcount))
> > +		return 0;
> 
> ... if we set the initial value of pamt_refcount to -1, and use
> atomic_inc_unless_negetive() here:
> 
> 	if (atomic_inc_unless_negative(pamt_refcount))
> 		return 0;
> 
> 	if (tdx_alloc_pamt_pages(&pamt_pages))
> 		return -ENOMEM;
> 
> 	spin_lock(&pamt_lock);
> 	ret = tdx_pamt_add(hpa, &pamt_pages);
> 	if (ret >= 0)
> 		atomic_inc(pamt_refcount, 0);
> 	spin_unlock(&pamt_lock);
> 	
> 	/*
> 	 * If another tdx_pamt_get() won the race, or in case of
> 	 * error, PAMT pages are not used and can be freed.
> 	 */
> 	if (ret)
> 		tdx_free_pamt_pages(&pamt_pages);
> 
> 	return ret >= 0 ? 0 : ret;
> 
> and ...
> 
> > +
> > +	if (tdx_alloc_pamt_pages(&pamt_pages))
> > +		return -ENOMEM;
> > +
> > +	return tdx_pamt_add(pamt_refcount, hpa, &pamt_pages);
> > +}
> > +
> > +static void tdx_pamt_put(struct page *page)
> > +{
> > +	unsigned long hpa = page_to_phys(page);
> > +	atomic_t *pamt_refcount;
> > +	LIST_HEAD(pamt_pages);
> > +	u64 err;
> > +
> > +	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
> > +		return;
> > +
> > +	hpa = ALIGN_DOWN(hpa, SZ_2M);
> > +
> > +	pamt_refcount = tdx_get_pamt_refcount(hpa);
> > +	if (!atomic_dec_and_test(pamt_refcount))
> > +		return;
> 
> ... use atomic_dec_if_possible() here, we should be able to avoid the special
> handling of tdx_hpa_range_not_free() in tdx_pamt_get().  Someething like:
> 
> 	if (atomic_dec_if_positive(pamt_refcount) >= 0)
> 		return;
> 
> 	spin_lock(&pamt_lock);
> 	
> 	/* tdx_pamt_get() called more than once */
> 	if (atomic_read(pamt_refcount) > 0) {

This check would do nothing to protect you against parallel increase of
the counter as we get here with pamt_refcount == 0 the parallel
atomic_inc_unless_negative() is free to bump the counter in the fast path
without taking the lock just after this condition.

So, the code below will free PAMT memory when there is still user.

> 		spin_unlock(&pamt_lock);
> 		return;
> 	}
> 
> 	err = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, &pamt_pages);
> 	atomic_set(pamt_refcount, -1);
> 	spin_unlock(&pamt_lock);
> 
> 	tdx_free_pamt_pages(&pamt_pages);
> 
> Hmm.. am I missing anything?
> 			
> > +
> > +	spin_lock(&pamt_lock);
> > +
> > +	/* Lost race against tdx_pamt_add()? */
> > +	if (atomic_read(pamt_refcount) != 0) {
> > +		spin_unlock(&pamt_lock);
> > +		return;
> > +	}
> > +
> > +	err = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, &pamt_pages);
> > +	spin_unlock(&pamt_lock);
> > +
> > +	if (err) {
> > +		pr_tdx_error(TDH_PHYMEM_PAMT_REMOVE, err);
> > +		return;
> > +	}
> > +
> > +	tdx_free_pamt_pages(&pamt_pages);
> > +}
> > +
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

