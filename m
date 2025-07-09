Return-Path: <kvm+bounces-51952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D44E5AFEC02
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29CEF18808E3
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7F42E5413;
	Wed,  9 Jul 2025 14:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CftVFqir"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F392E6110;
	Wed,  9 Jul 2025 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752071413; cv=none; b=Hrs+oHyDRbWhtp3qSUEduLTu6+oFH6ryY8kAz65Ro/qgGa1leK/VAbw+kUKbqlvi0387iEKQZcsOpm3iHXLp2FZNcFv0Zd3MqGa6ogY4+QwLRP8sAuie9vQx6hqTgcg9+0N/4tfn3oKu8eZTQo3qhMDRjNUsK6Io9aGGLcQ5TX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752071413; c=relaxed/simple;
	bh=/BtTSH93VrIIZBv/TtRzPdF9xB2kfbOMw8pxnsx3XcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9z2cJcLhIsVKlKXI/4/RwUWyyOdCOx6x/UNMf/0mKdwWPENdZbZAq3ch6o7Rot5XRrCK07ar6RWqdkKASzaurVVIZUbnwksuLmDwM0Jxmt3tZnfHz+nSaFazwjfIFoYvG+tZlcXs9C3pbR1aQz7JK47aDH9no3NhglXusf674Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CftVFqir; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752071412; x=1783607412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/BtTSH93VrIIZBv/TtRzPdF9xB2kfbOMw8pxnsx3XcU=;
  b=CftVFqir3pPfZH0bgl0Am7vE7mTHtX0y/ZhNyjpnDfDh/rCLYuJwSODk
   bMB1cjax9lluMytEsTn1FKVZcXDv8ih1atNpnp26cDIHuD681KuDzGoZz
   m4QotltiPmAmn+ysyrjl0w1/dNAC8ZI9L2NwehC0nBgWhzgFkI5GGvoxu
   urmhYQ3/t6qJ+X9pRPbJAvpFNkGU0Dw3cdDWEDg8PXj5irFeJUBf2cPwB
   3NwGr3Ezqkx4vu2RgwTEGVjf9o0lug4HBr8KfwE2fop+O3reqr+ufPm2H
   nBREUywb0KNWjTE6KETeVvS3t0GXxa6iFlK8sDpKQPELHL18Q91TWdRbd
   A==;
X-CSE-ConnectionGUID: HWVdBX9cSMe4cXI5geqqzQ==
X-CSE-MsgGUID: u1okw+R3QmuZp4ln73VkHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54214375"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54214375"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 07:30:11 -0700
X-CSE-ConnectionGUID: SP5P3WgvSMeaEBInRkzzuQ==
X-CSE-MsgGUID: EECYl+1LRXONC+ta8D+JfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="160328742"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa004.jf.intel.com with ESMTP; 09 Jul 2025 07:29:51 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 2A91D1B7; Wed, 09 Jul 2025 17:29:49 +0300 (EEST)
Date: Wed, 9 Jul 2025 17:29:49 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Message-ID: <nlnio65utrbd4t3vgkcibmwwmtkfhso6gz7lkqqnwhn5ialu7h@azdndahrdr3f>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
 <aba17e84f56f2a51e7d3cf0e286a898adf66dc46.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aba17e84f56f2a51e7d3cf0e286a898adf66dc46.camel@intel.com>

On Wed, Jun 25, 2025 at 10:38:42PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2025-06-09 at 22:13 +0300, Kirill A. Shutemov wrote:
> > There are two distinct cases when the kernel needs to allocate PAMT
> > memory in the fault path: for SEPT page tables in tdx_sept_link_private_spt()
> > and for leaf pages in tdx_sept_set_private_spte().
> > 
> > These code paths run in atomic context. Use a pre-allocated per-VCPU
> > pool for memory allocations.
> 
> This log is way to thin. It should explain the design, justify the function
> pointer, excuse the export, etc.

Ack.

> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/include/asm/tdx.h  |  4 ++++
> >  arch/x86/kvm/vmx/tdx.c      | 40 ++++++++++++++++++++++++++++++++-----
> >  arch/x86/virt/vmx/tdx/tdx.c | 21 +++++++++++++------
> >  virt/kvm/kvm_main.c         |  1 +
> >  4 files changed, 55 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index 47092eb13eb3..39f8dd7e0f06 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -116,6 +116,10 @@ u32 tdx_get_nr_guest_keyids(void);
> >  void tdx_guest_keyid_free(unsigned int keyid);
> >  
> >  int tdx_nr_pamt_pages(void);
> > +int tdx_pamt_get(struct page *page, enum pg_level level,
> > +		 struct page *(alloc)(void *data), void *data);
> > +void tdx_pamt_put(struct page *page, enum pg_level level);
> > +
> >  struct page *tdx_alloc_page(void);
> >  void tdx_free_page(struct page *page);
> >  
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 36c3c9f8a62c..bc9bc393f866 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1537,11 +1537,26 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
> >  	return 0;
> >  }
> >  
> > +static struct page *tdx_alloc_pamt_page_atomic(void *data)
> > +{
> > +	struct kvm_vcpu *vcpu = data;
> > +	void *p;
> > +
> > +	p = kvm_mmu_memory_cache_alloc(&vcpu->arch.pamt_page_cache);
> > +	return virt_to_page(p);
> > +}
> > +
> >  int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  			      enum pg_level level, kvm_pfn_t pfn)
> >  {
> > +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  	struct page *page = pfn_to_page(pfn);
> > +	int ret;
> > +
> > +	ret = tdx_pamt_get(page, level, tdx_alloc_pamt_page_atomic, vcpu);
> > +	if (ret)
> > +		return ret;
> >  
> >  	/* TODO: handle large pages. */
> >  	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> 
> level is known to be PG_LEVEL_4K if you swap the order of these. I'm guessing
> left over from order swap.

We would need to pass actual level when huge pages are supported. It is
better to keep it this way to avoid patching in the future.

> 
> > @@ -1562,10 +1577,16 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	 * barrier in tdx_td_finalize().
> >  	 */
> >  	smp_rmb();
> > -	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> > -		return tdx_mem_page_aug(kvm, gfn, level, page);
> >  
> > -	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> > +	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> > +		ret = tdx_mem_page_aug(kvm, gfn, level, page);
> > +	else
> > +		ret = tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> 
> tdx_mem_page_record_premap_cnt() doesn't need tdx_pamt_get(). I think it could
> be skipped if the order is re-arranged.

We need to deposit PAMT memory for PAGE.ADD at some point. I think having
it consolidated here for both PAGE.ADD and PAGE.AUG is better.

> > +
> > +	if (ret)
> > +		tdx_pamt_put(page, level);
> > +
> > +	return ret;
> >  }
> >  
> >  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > @@ -1622,17 +1643,26 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> >  			      enum pg_level level, void *private_spt)
> >  {
> >  	int tdx_level = pg_level_to_tdx_sept_level(level);
> > -	gpa_t gpa = gfn_to_gpa(gfn);
> > +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> >  	struct page *page = virt_to_page(private_spt);
> > +	gpa_t gpa = gfn_to_gpa(gfn);
> >  	u64 err, entry, level_state;
> > +	int ret;
> > +
> > +	ret = tdx_pamt_get(page, PG_LEVEL_4K, tdx_alloc_pamt_page_atomic, vcpu);
> > +	if (ret)
> > +		return ret;
> >  
> >  	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, page, &entry,
> >  			       &level_state);
> > -	if (unlikely(tdx_operand_busy(err)))
> > +	if (unlikely(tdx_operand_busy(err))) {
> > +		tdx_pamt_put(page, PG_LEVEL_4K);
> >  		return -EBUSY;
> > +	}
> >  
> >  	if (KVM_BUG_ON(err, kvm)) {
> >  		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
> > +		tdx_pamt_put(page, PG_LEVEL_4K);
> >  		return -EIO;
> >  	}
> >  
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 4f9eaba4af4a..d4b50b6428fa 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -2067,10 +2067,16 @@ static void tdx_free_pamt_pages(struct list_head *pamt_pages)
> >  	}
> >  }
> >  
> > -static int tdx_alloc_pamt_pages(struct list_head *pamt_pages)
> > +static int tdx_alloc_pamt_pages(struct list_head *pamt_pages,
> > +				 struct page *(alloc)(void *data), void *data)
> >  {
> >  	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
> > -		struct page *page = alloc_page(GFP_KERNEL);
> > +		struct page *page;
> > +
> > +		if (alloc)
> > +			page = alloc(data);
> > +		else
> > +			page = alloc_page(GFP_KERNEL);
> 
> It's not great I think. A branch between a function pointer and alloc_page,
> where there is only ever one value for the function pointer. There has to be a
> better way?

I guess we can do something like this (but I am not sure it is better):

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index baa791ea5fd7..58a3066be6fc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2141,11 +2141,7 @@ static int tdx_alloc_pamt_pages(struct list_head *pamt_pages,
 	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
 		struct page *page;
 
-		if (alloc)
-			page = alloc(data);
-		else
-			page = alloc_page(GFP_KERNEL);
-
+		page = alloc(data);
 		if (!page) {
 			tdx_free_pamt_pages(pamt_pages);
 			return -ENOMEM;
@@ -2208,6 +2204,11 @@ static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
 	return 0;
 }
 
+static struct page *alloc_kernel_page(void *dummy)
+{
+	return alloc_page(GFP_KERNEL);
+}
+
 /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
 int tdx_pamt_get(struct page *page, enum pg_level level,
 		 struct page *(alloc)(void *data), void *data)
@@ -2233,6 +2234,9 @@ int tdx_pamt_get(struct page *page, enum pg_level level,
 	if (atomic_inc_not_zero(pamt_refcount))
 		return 0;
 
+	if (!alloc)
+		alloc = alloc_kernel_page;
+
 	if (tdx_alloc_pamt_pages(&pamt_pages, alloc, data))
 		return -ENOMEM;
 
> 
> >  		if (!page)
> >  			goto fail;
> >  		list_add(&page->lru, pamt_pages);
> > @@ -2115,7 +2121,8 @@ static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> >  	return 0;
> >  }
> >  
> > -static int tdx_pamt_get(struct page *page, enum pg_level level)
> > +int tdx_pamt_get(struct page *page, enum pg_level level,
> > +		 struct page *(alloc)(void *data), void *data)
> >  {
> >  	unsigned long hpa = page_to_phys(page);
> >  	atomic_t *pamt_refcount;
> > @@ -2134,7 +2141,7 @@ static int tdx_pamt_get(struct page *page, enum pg_level level)
> >  	if (atomic_inc_not_zero(pamt_refcount))
> >  		return 0;
> >  
> > -	if (tdx_alloc_pamt_pages(&pamt_pages))
> > +	if (tdx_alloc_pamt_pages(&pamt_pages, alloc, data))
> >  		return -ENOMEM;
> >  
> >  	ret = tdx_pamt_add(pamt_refcount, hpa, &pamt_pages);
> > @@ -2143,8 +2150,9 @@ static int tdx_pamt_get(struct page *page, enum pg_level level)
> >  
> >  	return ret >= 0 ? 0 : ret;
> >  }
> > +EXPORT_SYMBOL_GPL(tdx_pamt_get);
> >  
> > -static void tdx_pamt_put(struct page *page, enum pg_level level)
> > +void tdx_pamt_put(struct page *page, enum pg_level level)
> >  {
> >  	unsigned long hpa = page_to_phys(page);
> >  	atomic_t *pamt_refcount;
> > @@ -2179,6 +2187,7 @@ static void tdx_pamt_put(struct page *page, enum pg_level level)
> >  
> >  	tdx_free_pamt_pages(&pamt_pages);
> >  }
> > +EXPORT_SYMBOL_GPL(tdx_pamt_put);
> >  
> >  struct page *tdx_alloc_page(void)
> >  {
> > @@ -2188,7 +2197,7 @@ struct page *tdx_alloc_page(void)
> >  	if (!page)
> >  		return NULL;
> >  
> > -	if (tdx_pamt_get(page, PG_LEVEL_4K)) {
> > +	if (tdx_pamt_get(page, PG_LEVEL_4K, NULL, NULL)) {
> >  		__free_page(page);
> >  		return NULL;
> >  	}
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index eec82775c5bf..6add012532a0 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -436,6 +436,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> >  	BUG_ON(!p);
> >  	return p;
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
> 
> Did you consider pre-allocating a page and returning it to the cache if it's not
> needed.

I am not sure how returning object back to pool helps anything.

Or do you mean to invent a new memory pool mechanism just for PAMT. Seems
excessive.


> Or moving kvm_mmu_memory_cache_alloc() to a static inline in a header
> that core x86 can use.

mmu_memory_cache_alloc_obj() need to be pulled into header too. At this
point we might as well pull all KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE stuff
there. 

It seems too extreme to avoid export.

> They all seem bad in different ways.
> 
> >  #endif
> >  
> >  static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

