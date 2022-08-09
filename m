Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D9358E3DB
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 01:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiHIXvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 19:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiHIXvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 19:51:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A1C7B795;
        Tue,  9 Aug 2022 16:51:01 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c24so7961036pgg.11;
        Tue, 09 Aug 2022 16:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=A8JRpCQzq2C7QuMe4NRu7pqz793xIE1JgEiojeA+Mg4=;
        b=YlB2XvljIjzQPq3LRBihgS34XDDtuKdeTT/Kca4/74WgxEGwR1ZcekUzJKsrIoz6Fk
         wjg2KWQ3kDRA+vdXB4rIWIil3Vg2YUBrMdJCFJmsxm8hwK1ONtRV9TGuwdh2kvzXfXJB
         P3VGAVMXNeEeb6eew/BFtndWE4TXA0781JDEXRHVfVoucFLkC1kfBgyISLjcvMMylgyu
         xZ5ILlxkNGOuzTC7NdVmgs8K1LaEoIM3qLc3+5sXQpY3dJ3dO2S7EIVy7IM74pImdfMh
         yPOzF7LL0173kAGYfK1QAVbbcyg90oDR1HJQ/1BGld3KNNU//9MOa/Kuma8g6L0G6LSR
         qWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=A8JRpCQzq2C7QuMe4NRu7pqz793xIE1JgEiojeA+Mg4=;
        b=nNL49lxK9wOV+GyKNgJ0CYP/ymG6n2jGmTNoEqwpmqdMwHFOvBlSE3jyKl4SqemuEO
         iotVvldJK7LoigH2h0LJ/8kYZ2Ylw7EIoxYZzTPW2yJLtw5qqeMrEzGXANE/7Qn9oXdh
         sSs0beHnpMpAZQYnnvkJta9IMTbC9Y5XkM7HU3iCVMhJig1qQtDRmPp7jTO2b+VwthZt
         TdzGoPXbzhVJTzKgm0RP8fRy1aulB9hF8vMMjbn8JMbTiJHXoqZWr01p6Os/m1ELvL8A
         l3j+y1Bi++RN9AV74K/uyhHllxr7zkyxDd2SuByMPXBF3WbvceLQ9C2fUQXQt4SDTCUC
         l+8w==
X-Gm-Message-State: ACgBeo0AEyLLeKHnKL06g8yfb91DyzRbxCnjBqi4Ev3k1CXmba6q9tyq
        Zlj0VM9z+hsm5r1vY238yww=
X-Google-Smtp-Source: AA6agR6hbY0Uamzn6SRiOPSJMYmJM+4t3To4ftou4MRLOXsOzfr1/N+AEM9bfItpSNmlmqo+Zg29fg==
X-Received: by 2002:a63:ec04:0:b0:41c:1149:4523 with SMTP id j4-20020a63ec04000000b0041c11494523mr20526073pgh.62.1660089061164;
        Tue, 09 Aug 2022 16:51:01 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id v12-20020a17090a4ecc00b001f260b1954bsm175813pjl.13.2022.08.09.16.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 16:51:00 -0700 (PDT)
Date:   Tue, 9 Aug 2022 16:50:59 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 044/102] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Message-ID: <20220809235059.GA515657@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <392839e09c48ff4e14a598ff6ed8bd56429bf17b.1656366338.git.isaku.yamahata@intel.com>
 <YuLt72E66iuvRtl7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YuLt72E66iuvRtl7@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 01:13:35PM -0700,
David Matlack <dmatlack@google.com> wrote:

> On Mon, Jun 27, 2022 at 02:53:36PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > For private GPA, CPU refers a private page table whose contents are
> > encrypted.  The dedicated APIs to operate on it (e.g. updating/reading its
> > PTE entry) are used and their cost is expensive.
> > 
> > When KVM resolves KVM page fault, it walks the page tables.  To reuse the
> > existing KVM MMU code and mitigate the heavy cost to directly walk
> > encrypted private page table, allocate a more page to mirror the existing
> > KVM page table.  Resolve KVM page fault with the existing code, and do
> > additional operations necessary for the mirrored private page table.  To
> > distinguish such cases, the existing KVM page table is called a shared page
> > table (i.e. no mirrored private page table), and the KVM page table with
> > mirrored private page table is called a private page table.  The
> > relationship is depicted below.
> > 
> > Add private pointer to struct kvm_mmu_page for mirrored private page table
> > and add helper functions to allocate/initialize/free a mirrored private
> > page table page.  Also, add helper functions to check if a given
> > kvm_mmu_page is private.  The later patch introduces hooks to operate on
> > the mirrored private page table.
> > 
> >               KVM page fault                     |
> >                      |                           |
> >                      V                           |
> >         -------------+----------                 |
> >         |                      |                 |
> >         V                      V                 |
> >      shared GPA           private GPA            |
> >         |                      |                 |
> >         V                      V                 |
> >  CPU/KVM shared PT root  KVM private PT root     |  CPU private PT root
> >         |                      |                 |           |
> >         V                      V                 |           V
> >      shared PT            private PT <----mirror----> mirrored private PT
> >         |                      |                 |           |
> >         |                      \-----------------+------\    |
> >         |                                        |      |    |
> >         V                                        |      V    V
> >   shared guest page                              |    private guest page
> >                                                  |
> >                            non-encrypted memory  |    encrypted memory
> >                                                  |
> > PT: page table
> > 
> > Both CPU and KVM refer to CPU/KVM shared page table.  Private page table
> > is used only by KVM.  CPU refers to mirrored private page table.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/mmu/mmu.c          |  9 ++++
> >  arch/x86/kvm/mmu/mmu_internal.h | 84 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++
> >  4 files changed, 97 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f4d4ed41641b..bfc934dc9a33 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -716,6 +716,7 @@ struct kvm_vcpu_arch {
> >  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> >  	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
> >  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> > +	struct kvm_mmu_memory_cache mmu_private_sp_cache;
> >  
> >  	/*
> >  	 * QEMU userspace and the guest each have their own FPU state.
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index c517c7bca105..a5bf3e40e209 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -691,6 +691,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> >  	int start, end, i, r;
> >  	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
> >  
> > +	if (kvm_gfn_shared_mask(vcpu->kvm)) {
> > +		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
> > +					       PT64_ROOT_MAX_LEVEL);
> > +		if (r)
> > +			return r;
> > +	}
> > +
> >  	if (is_tdp_mmu && shadow_nonpresent_value)
> >  		start = kvm_mmu_memory_cache_nr_free_objects(mc);
> >  
> > @@ -732,6 +739,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> >  {
> >  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> >  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> > +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
> >  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
> >  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
> >  }
> > @@ -1736,6 +1744,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
> >  	if (!direct)
> >  		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> >  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > +	kvm_mmu_init_private_sp(sp, NULL);
> >  
> >  	/*
> >  	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 44a04fad4bed..9f3a6bea60a3 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -55,6 +55,10 @@ struct kvm_mmu_page {
> >  	u64 *spt;
> >  	/* hold the gfn of each spte inside spt */
> >  	gfn_t *gfns;
> > +#ifdef CONFIG_KVM_MMU_PRIVATE
> > +	/* associated private shadow page, e.g. SEPT page. */
> > +	void *private_sp;
> > +#endif
> 
> write_flooding_count and unsync_children are only used in shadow MMU SPs
> and private_sp is only used in TDP MMU SPs. So it seems like we could
> put these together in a union and drop CONFIG_KVM_MMU_PRIVATE without
> increasing the size of kvm_mmu_page. i.e.

I introduced KVM_MMU_PRIVATE as a alias to INTEL_TDX_HOST because I don't want
to use it in kvm/mmu and I'd like KVM_MMU_PRIVATE (a sort of) independent from
INTEL_TDX_HOST.  Anyway once the patch series is merged, we can drop
KVM_MMU_PRIVATE.


> 	union {
> 		struct {
> 			unsigned int unsync_children;
> 			/* Number of writes since the last time traversal visited this page.  */
> 			atomic_t write_flooding_count;
> 		};
> 		/*
> 		 * The associated private shadow page table, e.g. for Secure EPT.
> 		 * Only valid if tdp_mmu_page is true.
> 		 */
> 		void *private_spt;
> 	};
> 
> Then change is_private_sp() to:
> 
> static inline bool is_private_sp(struct kvm_mmu_page *sp)
> {
> 	return sp->tdp_mmu_page && sp->private_sp;
> }
> 
> This will allow us to drop CONFIG_KVM_MMU_PRIVATE, the only benefit of
> which I see is to avoid increasing the size of kvm_mmu_page. However
> to actually realize that benefit Cloud vendors (for example) would have
> to create separate kernel builds for TDX and non-TDX hosts, which seems
> like a huge hassel.

Good idea. I'll use union.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
