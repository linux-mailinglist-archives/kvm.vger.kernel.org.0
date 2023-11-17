Return-Path: <kvm+bounces-1975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B077EF866
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 21:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97637281069
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 20:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A97E45BE2;
	Fri, 17 Nov 2023 20:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b2gHz9tE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44651FEF;
	Fri, 17 Nov 2023 12:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700252125; x=1731788125;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/7+LjIS9p9ecKNObclU4C94lj+TYiKtZZXlq7W+6+hI=;
  b=b2gHz9tE426xGyctT2ig1NQjHnP1fFZvCzN6Cg/NoFFlCuHsuOTxcPhK
   wqSQ1Fflee65O9dCt2zoMDu74QNvRtZ2tNvzn+B9izYF+VHB1uSsYfZrD
   7jWR+0Z/w/v+7jKN5r4ihCCI3ZmQ4hgoJoybSmMtaPyTI0eVqYsY+bclM
   AH8k5VV6yijaFZCXgvievajxUT+pXgdsXaRegvtGzXpkYipdJ5sAOcqKz
   3GHs9x5sBKnDRMJRVjTllI15dj/6/e6WNpeP2HsdUboBXiKQbqet+QSCk
   C9wekRKHNyvz+LSqcvV9Hl/jde/DWQZm2iXJGi7YQFr9rpQDULxifwMLj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="12913558"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="12913558"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 12:15:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="6951003"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 12:15:23 -0800
Date: Fri, 17 Nov 2023 12:15:23 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Christopherson,, Sean" <seanjc@google.com>,
	"Shahar, Sagi" <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"gkirkpatrick@google.com" <gkirkpatrick@google.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v16 059/116] KVM: TDX: Create initial guest memory
Message-ID: <20231117201523.GD1109547@ls.amr.corp.intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
 <edccd3a8ee2ca8d96baca097546bc131f1ef3b79.1697471314.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373EC1033F88008D3B71568DCB7A@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373EC1033F88008D3B71568DCB7A@DS0PR11MB6373.namprd11.prod.outlook.com>

On Fri, Nov 17, 2023 at 12:56:32PM +0000,
"Wang, Wei W" <wei.w.wang@intel.com> wrote:

> On Tuesday, October 17, 2023 12:14 AM, isaku.yamahata@intel.com wrote:
> > Because the guest memory is protected in TDX, the creation of the initial guest
> > memory requires a dedicated TDX module API, tdh_mem_page_add, instead of
> > directly copying the memory contents into the guest memory in the case of
> > the default VM type.  KVM MMU page fault handler callback, private_page_add,
> > handles it.
> > 
> > Define new subcommand, KVM_TDX_INIT_MEM_REGION, of VM-scoped
> > KVM_MEMORY_ENCRYPT_OP.  It assigns the guest page, copies the initial
> > memory contents into the guest memory, encrypts the guest memory.  At the
> > same time, optionally it extends memory measurement of the TDX guest.  It
> > calls the KVM MMU page fault(EPT-violation) handler to trigger the callbacks
> > for it.
> > 
> > Reported-by: gkirkpatrick@google.com
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > v15 -> v16:
> > - add check if nr_pages isn't large with
> >   (nr_page << PAGE_SHIFT) >> PAGE_SHIFT
> > 
> > v14 -> v15:
> > - add a check if TD is finalized or not to tdx_init_mem_region()
> > - return -EAGAIN when partial population
> > ---
> >  arch/x86/include/uapi/asm/kvm.h       |   9 ++
> >  arch/x86/kvm/mmu/mmu.c                |   1 +
> >  arch/x86/kvm/vmx/tdx.c                | 167 +++++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/tdx.h                |   2 +
> >  tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
> >  5 files changed, 185 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h
> > b/arch/x86/include/uapi/asm/kvm.h index 311a7894b712..a1815fcbb0be
> > 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -572,6 +572,7 @@ enum kvm_tdx_cmd_id {
> >  	KVM_TDX_CAPABILITIES = 0,
> >  	KVM_TDX_INIT_VM,
> >  	KVM_TDX_INIT_VCPU,
> > +	KVM_TDX_INIT_MEM_REGION,
> > 
> >  	KVM_TDX_CMD_NR_MAX,
> >  };
> > @@ -645,4 +646,12 @@ struct kvm_tdx_init_vm {
> >  	struct kvm_cpuid2 cpuid;
> >  };
> > 
> > +#define KVM_TDX_MEASURE_MEMORY_REGION	(1UL << 0)
> > +
> > +struct kvm_tdx_init_mem_region {
> > +	__u64 source_addr;
> > +	__u64 gpa;
> > +	__u64 nr_pages;
> > +};
> > +
> >  #endif /* _ASM_X86_KVM_H */
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c index
> > 107cf27505fe..63a4efd1e40a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5652,6 +5652,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
> >  out:
> >  	return r;
> >  }
> > +EXPORT_SYMBOL(kvm_mmu_load);
> > 
> >  void kvm_mmu_unload(struct kvm_vcpu *vcpu)  { diff --git
> > a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c index
> > a5f1b3e75764..dc17c212cb38 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -470,6 +470,21 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu,
> > hpa_t root_hpa, int pgd_level)
> >  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa &
> > PAGE_MASK);  }
> > 
> > +static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa) {
> > +	struct tdx_module_args out;
> > +	u64 err;
> > +	int i;
> > +
> > +	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> > +		err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
> > +		if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
> > +			pr_tdx_error(TDH_MR_EXTEND, err, &out);
> > +			break;
> > +		}
> > +	}
> > +}
> > +
> >  static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)  {
> >  	struct page *page = pfn_to_page(pfn);
> > @@ -533,6 +548,61 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t
> > gfn,
> >  	return 0;
> >  }
> > 
> > +static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
> > +			     enum pg_level level, kvm_pfn_t pfn) {
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	hpa_t hpa = pfn_to_hpa(pfn);
> > +	gpa_t gpa = gfn_to_gpa(gfn);
> > +	struct tdx_module_args out;
> > +	hpa_t source_pa;
> > +	bool measure;
> > +	u64 err;
> > +
> > +	/*
> > +	 * KVM_INIT_MEM_REGION, tdx_init_mem_region(), supports only 4K
> > page
> > +	 * because tdh_mem_page_add() supports only 4K page.
> > +	 */
> > +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * In case of TDP MMU, fault handler can run concurrently.  Note
> > +	 * 'source_pa' is a TD scope variable, meaning if there are multiple
> > +	 * threads reaching here with all needing to access 'source_pa', it
> > +	 * will break.  However fortunately this won't happen, because below
> > +	 * TDH_MEM_PAGE_ADD code path is only used when VM is being
> > created
> > +	 * before it is running, using KVM_TDX_INIT_MEM_REGION ioctl
> > (which
> > +	 * always uses vcpu 0's page table and protected by vcpu->mutex).
> > +	 */
> > +	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
> > +		tdx_unpin(kvm, pfn);
> > +		return -EINVAL;
> > +	}
> > +
> > +	source_pa = kvm_tdx->source_pa &
> > ~KVM_TDX_MEASURE_MEMORY_REGION;
> > +	measure = kvm_tdx->source_pa &
> > KVM_TDX_MEASURE_MEMORY_REGION;
> > +	kvm_tdx->source_pa = INVALID_PAGE;
> > +
> > +	do {
> > +		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa,
> > source_pa,
> > +				       &out);
> > +		/*
> > +		 * This path is executed during populating initial guest memory
> > +		 * image. i.e. before running any vcpu.  Race is rare.
> > +		 */
> > +	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
> > +	if (KVM_BUG_ON(err, kvm)) {
> > +		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
> > +		tdx_unpin(kvm, pfn);
> > +		return -EIO;
> > +	} else if (measure)
> > +		tdx_measure_page(kvm_tdx, gpa);
> > +
> > +	return 0;
> > +
> > +}
> > +
> >  static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  				     enum pg_level level, kvm_pfn_t pfn)  { @@
> > -555,9 +625,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t
> > gfn,
> >  	if (likely(is_td_finalized(kvm_tdx)))
> >  		return tdx_sept_page_aug(kvm, gfn, level, pfn);
> > 
> > -	/* TODO: tdh_mem_page_add() comes here for the initial memory. */
> > -
> > -	return 0;
> > +	return tdx_sept_page_add(kvm, gfn, level, pfn);
> >  }
> > 
> >  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, @@ -1265,6
> > +1333,96 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
> >  	tdx_track(vcpu->kvm);
> >  }
> > 
> > +#define TDX_SEPT_PFERR	(PFERR_WRITE_MASK |
> > PFERR_GUEST_ENC_MASK)
> > +
> > +static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd
> > +*cmd) {
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	struct kvm_tdx_init_mem_region region;
> > +	struct kvm_vcpu *vcpu;
> > +	struct page *page;
> > +	int idx, ret = 0;
> > +	bool added = false;
> > +
> > +	/* Once TD is finalized, the initial guest memory is fixed. */
> > +	if (is_td_finalized(kvm_tdx))
> > +		return -EINVAL;
> > +
> > +	/* The BSP vCPU must be created before initializing memory regions.
> > */
> > +	if (!atomic_read(&kvm->online_vcpus))
> > +		return -EINVAL;
> > +
> > +	if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(&region, (void __user *)cmd->data, sizeof(region)))
> > +		return -EFAULT;
> > +
> > +	/* Sanity check */
> > +	if (!IS_ALIGNED(region.source_addr, PAGE_SIZE) ||
> > +	    !IS_ALIGNED(region.gpa, PAGE_SIZE) ||
> > +	    !region.nr_pages ||
> > +	    region.nr_pages & GENMASK_ULL(63, 63 - PAGE_SHIFT) ||
> > +	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
> > +	    !kvm_is_private_gpa(kvm, region.gpa) ||
> > +	    !kvm_is_private_gpa(kvm, region.gpa + (region.nr_pages <<
> > PAGE_SHIFT)))
> > +		return -EINVAL;
> > +
> > +	vcpu = kvm_get_vcpu(kvm, 0);
> > +	if (mutex_lock_killable(&vcpu->mutex))
> > +		return -EINTR;
> > +
> > +	vcpu_load(vcpu);
> > +	idx = srcu_read_lock(&kvm->srcu);
> > +
> > +	kvm_mmu_reload(vcpu);
> > +
> > +	while (region.nr_pages) {
> > +		if (signal_pending(current)) {
> > +			ret = -ERESTARTSYS;
> > +			break;
> > +		}
> > +
> > +		if (need_resched())
> > +			cond_resched();
> > +
> > +		/* Pin the source page. */
> > +		ret = get_user_pages_fast(region.source_addr, 1, 0, &page);
> > +		if (ret < 0)
> > +			break;
> > +		if (ret != 1) {
> > +			ret = -ENOMEM;
> > +			break;
> > +		}
> > +
> > +		kvm_tdx->source_pa = pfn_to_hpa(page_to_pfn(page)) |
> > +				     (cmd->flags &
> > KVM_TDX_MEASURE_MEMORY_REGION);
> > +
> 
> Is it fundamentally correct to take a userspace mapped page to add as a TD private page?
> Maybe take the corresponding page from gmem and do a copy to it?
> For example:
> ret = get_user_pages_fast(region.source_addr, 1, 0, &user_page);
> ...
> kvm_gmem_get_pfn(kvm, gfn_to_memslot(kvm, gfn), gfn, &gmem_pfn, NULL);
> memcpy(__va(gmem_pfn << PAGE_SHIFT), page_to_virt(user_page), PAGE_SIZE);
> kvm_tdx->source_pa = pfn_to_hpa(gmem_pfn) |
>                                      (cmd->flags & KVM_TDX_MEASURE_MEMORY_REGION);

Please refer to
static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
                                     enum pg_level level, kvm_pfn_t pfn)

The guest memfd provides the page of gfn which is different from
kvm_tdx->source_pa. The function calls tdh_mem_page_add().

tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa, source_pa, &out);
gpa: corresponds to the page from guest memfd
source_pa: corresopnds to the page tdx_init_mem_region() pinned down.

tdh_mem_page_add() copies the page contents from source_pa to gpa and
gives gpa to the TD guest. not source_pa.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

