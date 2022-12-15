Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1991164E49E
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 00:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiLOXVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 18:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLOXVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 18:21:22 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9919C1D;
        Thu, 15 Dec 2022 15:21:21 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id x2so544804plb.13;
        Thu, 15 Dec 2022 15:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WPz8Pq9lnBJ/CBecVsQ2s8viQ8BlcttzN3Tp92z+Dqo=;
        b=SCA5S+vLSOHRC1RVsavYxKulSAJH00iysjd/SdZ7H8pecdFtSupXWXn2bt9lDDgqjN
         txmYU0Qe905WgKOThjZP5dERuJIBrT14W9LXllFrV8FVnrmrnproMrTylCv8JLr5T4WO
         Wl7c8a4SksrN90m4iwMTZJHBje0wPsbpEZt5mVQ+/Ka5NqFHknJagDrn/cV9tvAbjtg0
         8yzH1Huzg0SL7zT2/f4/WwImnQk5BYFASChbuLK1AR8uluQ0PBZhn5GTA4cjvq5jkkLl
         e8GHg96cuCwufXVLKk7BAoVu4GCaegZHt6FJp7lTTLVf96QrEzGomf6WbpQYBgIctxJ7
         XWXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPz8Pq9lnBJ/CBecVsQ2s8viQ8BlcttzN3Tp92z+Dqo=;
        b=QoZ5dqYbp1rko5cFWZ8QZQrVvY7VxikdBvB5M9Cp5mkd6tAK78GTemK6bIsyha6m61
         49nTzTrlJ234NdyDnfD9fd0og1tfjF7y7DaYAVXfd+BlSnyBSqfMORHZRNxiTeJAvt6g
         SaEC3shYmNfzTVukQJSB4sav2IWKRceMyclngb5/tpynQKLVs4EPcnGLnG1UCPGjvTNr
         Xg4fqB0AoD4nlTLiFwLfg6Iq+2ahpJ2IuSygghDRG9P4qZtnfe/F0Kxcj8QBpXRLqDYq
         vYiVw0Y4xi/hfvIX4qSfUTw2NKHmzImzgtVhqrL4vxP/X0usiLHOCQC6CN+Vd+cEi6P3
         ga5A==
X-Gm-Message-State: ANoB5plJQ88nTQdWWOs5eOVyRnSpOD4N8oJGedeU51lvTYEJvYXmCwnC
        FOboNHt3m2QWhvJDYB+qkAg=
X-Google-Smtp-Source: AA0mqf6EpKeb0XnTiVJspMlfp71aNtx3W7fSRFq4tj8EPxHQEFr7NZ6LGCNTAtMbEDxyZvVuC5f8BA==
X-Received: by 2002:a17:90a:f3c1:b0:21e:dec6:fc3d with SMTP id ha1-20020a17090af3c100b0021edec6fc3dmr26504573pjb.8.1671146481103;
        Thu, 15 Dec 2022 15:21:21 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id gz14-20020a17090b0ece00b00219463262desm158802pjb.39.2022.12.15.15.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 15:21:20 -0800 (PST)
Date:   Thu, 15 Dec 2022 15:21:19 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 052/108] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Message-ID: <20221215232119.GJ3632095@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <32e2f5f567e1af3858e2896d705b66f90a908ff0.1667110240.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373E6562F6F0CCC92CF8A22DC189@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373E6562F6F0CCC92CF8A22DC189@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 02:23:35PM +0000,
"Wang, Wei W" <wei.w.wang@intel.com> wrote:

> On Sunday, October 30, 2022 2:23 PM, Yamahata, Isaku wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Some KVM MMU operations (dirty page logging, page migration, aging page)
> > aren't supported for private GFNs (yet) with the first generation of TDX.
> > Silently return on unsupported TDX KVM MMU operations.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     |  3 ++
> >  arch/x86/kvm/mmu/tdp_mmu.c | 73
> > +++++++++++++++++++++++++++++++++++---
> >  arch/x86/kvm/x86.c         |  3 ++
> >  3 files changed, 74 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c index
> > 02e7b5cf3231..efc3b3f2dd12 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6588,6 +6588,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct
> > kvm *kvm,
> >  	for_each_rmap_spte(rmap_head, &iter, sptep) {
> >  		sp = sptep_to_sp(sptep);
> > 
> > +		/* Private page dirty logging is not supported yet. */
> > +		KVM_BUG_ON(is_private_sptep(sptep), kvm);
> > +
> >  		/*
> >  		 * We cannot do huge page mapping for indirect shadow pages,
> >  		 * which are found on the last rmap (level = 1) when not using diff --git
> > a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c index
> > 0e053b96444a..4b207ce83ffe 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1469,7 +1469,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm,
> > struct tdp_iter *iter,
> > 
> >  static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
> >  						   struct kvm_gfn_range *range,
> > -						   tdp_handler_t handler)
> > +						   tdp_handler_t handler,
> > +						   bool only_shared)
> >  {
> >  	struct kvm_mmu_page *root;
> >  	struct tdp_iter iter;
> > @@ -1480,9 +1481,23 @@ static __always_inline bool
> > kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
> >  	 * into this helper allow blocking; it'd be dead, wasteful code.
> >  	 */
> >  	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> > +		gfn_t start;
> > +		gfn_t end;
> > +
> > +		if (only_shared && is_private_sp(root))
> > +			continue;
> > +
> >  		rcu_read_lock();
> > 
> > -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> > +		/*
> > +		 * For TDX shared mapping, set GFN shared bit to the range,
> > +		 * so the handler() doesn't need to set it, to avoid duplicated
> > +		 * code in multiple handler()s.
> > +		 */
> > +		start = kvm_gfn_for_root(kvm, root, range->start);
> > +		end = kvm_gfn_for_root(kvm, root, range->end);
> > +
> > +		tdp_root_for_each_leaf_pte(iter, root, start, end)
> >  			ret |= handler(kvm, &iter, range);
> > 
> >  		rcu_read_unlock();
> > @@ -1526,7 +1541,12 @@ static bool age_gfn_range(struct kvm *kvm, struct
> > tdp_iter *iter,
> > 
> >  bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range
> > *range)  {
> > -	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
> > +	/*
> > +	 * First TDX generation doesn't support clearing A bit for private
> > +	 * mapping, since there's no secure EPT API to support it.  However
> > +	 * it's a legitimate request for TDX guest.
> > +	 */
> > +	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range, true);
> >  }
> > 
> >  static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter, @@ -1537,7
> > +1557,8 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
> > 
> >  bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range
> > *range)  {
> > -	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
> > +	/* The first TDX generation doesn't support A bit. */
> > +	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn, true);
> >  }
> > 
> >  static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter, @@ -1582,8
> > +1603,11 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct
> > kvm_gfn_range *range)
> >  	 * No need to handle the remote TLB flush under RCU protection, the
> >  	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
> >  	 * shadow page.  See the WARN on pfn_changed in
> > __handle_changed_spte().
> > +	 *
> > +	 * .change_pte() callback should not happen for private page, because
> > +	 * for now TDX private pages are pinned during VM's life time.
> >  	 */
> > -	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
> > +	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn, true);
> >  }
> > 
> >  /*
> > @@ -1637,6 +1661,14 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
> > 
> >  	lockdep_assert_held_read(&kvm->mmu_lock);
> > 
> > +	/*
> > +	 * Because first TDX generation doesn't support write protecting private
> > +	 * mappings and kvm_arch_dirty_log_supported(kvm) = false, it's a bug
> > +	 * to reach here for guest TD.
> > +	 */
> > +	if (WARN_ON_ONCE(!kvm_arch_dirty_log_supported(kvm)))
> > +		return false;
> > +
> >  	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
> >  		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
> >  			     slot->base_gfn + slot->npages, min_level); @@ -1902,6
> > +1934,14 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
> > 
> >  	lockdep_assert_held_read(&kvm->mmu_lock);
> > 
> > +	/*
> > +	 * First TDX generation doesn't support clearing dirty bit,
> > +	 * since there's no secure EPT API to support it.  It is a
> > +	 * bug to reach here for TDX guest.
> > +	 */
> > +	if (WARN_ON_ONCE(!kvm_arch_dirty_log_supported(kvm)))
> > +		return false;
> > +
> 
> It might not be a good choice to intercept everywhere in kvm_mmu just as tdx
> doesn't support it. I'm thinking maybe we could do the check in tdx.c, which is
> much simpler. For example:
> 
> @@ -2592,6 +2605,12 @@ static void tdx_handle_changed_private_spte(struct kvm *kvm,
>         lockdep_assert_held(&kvm->mmu_lock);
> 
>         if (change->new.is_present) {
> +               /* Only flags change. This isn't supported currently. */
> +               KVM_BUG_ON(change->old.is_present, kvm);
> 
> Then we can have kvm_arch_dirty_log_supported completely removed.

Do you mean WARN_ON_ONCE()? If so, they can be removed from this patches because
the code should be blocked by "if (!kvm_arch_dirty_log_supported(kvm))" at the
caller.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
