Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7F170FEF5
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 22:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjEXUFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 16:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjEXUFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 16:05:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DACFC
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:05:29 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-518d6f87a47so395997a12.3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684958729; x=1687550729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Wo8IPofr5IpEW+ax3IvqEWITKhSS7r+DVQFWDx/Q3w=;
        b=cM5I2g/sGcDLMJ7cDZJKkrmDCu/I/ejP2YujUQ6/H3ebhoV92Cl+FRrOuefqsp1VqC
         DCwq4EUofvb6CpFAeuqfuD9sXbUhTXBTxQIAVgLvrTGDHXViI8Jn6GCgN0nNM8034rOW
         BH7C1jT/9b/68gPTEnBL+E2jBfIppwbdr5bieJ8E0CVDdU2kS88aNFIg26rQBXm9we2E
         JO46b9KinV65dWntKHZLpbNAFr9Cc3psRjAD6alpHeTYkh5mKSmdDHrngtFUei9SEeD+
         guxxPGSKjZsOCFB4T1RHbYBeWwd/4xuT8x+xIi3TgcNg/nKNKyWuJzSfG6/d8H7XdJX6
         SMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684958729; x=1687550729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Wo8IPofr5IpEW+ax3IvqEWITKhSS7r+DVQFWDx/Q3w=;
        b=TRO06KpCBTiu4MeuWazDXSV1z77XA55qLREgCVUIiGeHwyZ/jghpbLu7TXelc4gPnI
         CWEC1YlIPc0RtukCFM6AgGwdjvBoNdrpAP31AXMS7SYNYK/hC7Dj4opvLCHmjQ8ohz6r
         EFbIuoFyI5wy7miVS8uLDbWD/szf2w2VINnlGB7xnU5Pyjaz3qeOit+epbFKw82EnmfA
         h0YcyoasmiO2vwJIGRv8mBys/tYcrWG9J8z1eKABOOf7VGJy2tWm/m7AOg+wWq7qFEbN
         dM6EGbJK8zZjyjcwUb/PZgtjx9j110OsNuBW4wkxWRs1QUaJOxVvEy+B1ONCMuWwd3Zs
         AhOw==
X-Gm-Message-State: AC+VfDypr12PQtMF7E2js6G/C7zRVlj8lw3N/frVFqFySJsuA3nN8Md6
        VQXAfU9iLbEeinUpEd3ioYof+4EkQ3g=
X-Google-Smtp-Source: ACHHUZ7aAaZ4DZIh4roCKOcv/0fpbVmvXqI6dKiQGMExO4BifCTRpFrnwqav5XkCzh5HN23hnvYqD6vHIRs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:943:0:b0:53f:2577:74fb with SMTP id
 64-20020a630943000000b0053f257774fbmr13432pgj.8.1684958729265; Wed, 24 May
 2023 13:05:29 -0700 (PDT)
Date:   Wed, 24 May 2023 13:05:27 -0700
In-Reply-To: <ZG5g7bhAlsli+Pao@x1n>
Mime-Version: 1.0
References: <20230330085802.2414466-1-stevensd@google.com> <20230330085802.2414466-2-stevensd@google.com>
 <ZGvUsf7lMkrNDHuE@google.com> <ZG45q0xJSnA6NKQN@x1n> <ZG4/VdHu2LqLTlct@google.com>
 <ZG5F3igFgdIAwrn4@x1n> <ZG5XmdYy3VtcyPAL@google.com> <ZG5g7bhAlsli+Pao@x1n>
Message-ID: <ZG5uB4SiaS92YEWr@google.com>
Subject: Re: [PATCH v6 1/4] KVM: mmu: introduce new gfn_to_pfn_noref functions
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023, Peter Xu wrote:
> On Wed, May 24, 2023 at 11:29:45AM -0700, Sean Christopherson wrote:
> > On Wed, May 24, 2023, Peter Xu wrote:
> > > On Wed, May 24, 2023 at 09:46:13AM -0700, Sean Christopherson wrote:
> > > > If we hack kvm_pfn_to_refcounted_page(), then all of those protections are lost
> > > > because KVM would drop its assertions and also skip dirtying pages, i.e. would
> > > > effectively suppress the latent detection by check_new_page_bad().
> > > 
> > > So it's probably that I totally have no idea what are the attributes for
> > > those special pages so I don't understand enough on why we need to handle
> > > those pages differently from e.g. PFNMAP pages, and also the benefits.
> > > 
> > > I think what I can tell is that they're pages that doesn't have
> > > PageCompound bits set on either head or tails, however it's still a
> > > multi-2-order large page.  Is there an example on how these pages are used
> > > and allocated?  Why would we need those pages, and whether these pages need
> > > to be set dirty/accessed after all?
> > 
> > The use case David is interested in is where an AMD GPU driver kmallocs() a
> > chunk of memory, let's it be mmap()'d by userspace, and userspace then maps it
> > into the guest for a virtual (passthrough?) GPU.  For all intents and purposes,
> > it's normal memory, just not refcounted.
> 
> I'm not familiar enough with kmalloc, but what I think is kmalloc for large
> chunks will be the same as alloc_pages, and I thought it should also be a
> compound page already.  If that needs to be mmap()ed to userapp then I
> assume it mostly should be kmalloc_large().

Sorry, by "kmalloc()" I was handwaving at all of the variations of kernel allocated
memory.  From a separate thread[*], looks like the actual usage is a direct call to
alloc_pages() that deliberately doesn't set __GFP_COMP.  Note, I'm pretty sure the
comment about "mapping pages directly into userspace" being illegal really means
something like "don't allow these pages to be gup()'d or mapped via standard mmap()".
IIUC, ttm_pool_alloc() fills tt->pages and then ttm_bo_vm_fault_reserved() does
vmf_insert_pfn_prot() to shove the pfn into userspace.

  static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
					unsigned int order)
  {
	unsigned long attr = DMA_ATTR_FORCE_CONTIGUOUS;
	struct ttm_pool_dma *dma;
	struct page *p;
	void *vaddr;

	/* Don't set the __GFP_COMP flag for higher order allocations.
	 * Mapping pages directly into an userspace process and calling
	 * put_page() on a TTM allocated page is illegal.
	 */
	if (order)
		gfp_flags |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN |
			__GFP_KSWAPD_RECLAIM;

	if (!pool->use_dma_alloc) {
		p = alloc_pages(gfp_flags, order);
		if (p)
			p->private = order;
		return p;

	}

[*] https://lore.kernel.org/all/20220815095423.11131-1-dmitry.osipenko@collabora.com

> kmalloc -> kmalloc_large -> __kmalloc_large_node:
> 
> 	flags |= __GFP_COMP;
> 
> Then when the new page allocated and being prepared (prep_new_page):
> 
> 	if (order && (gfp_flags & __GFP_COMP))
> 		prep_compound_page(page, order);
> 
> I assume prep_compound_page() will make PageCompound return true for those
> pages returned.  So I know I still miss something, but not sure
> where.. because IIRC we're at least talking about !PageCompound pages.

Yeah, they're !PageCompound().

> > > >  static bool kvm_is_ad_tracked_page(struct page *page)
> > > >  {
> > > > +       /*
> > > > +        * Assert that KVM isn't attempting to mark a freed page as Accessed or
> > > > +        * Dirty, i.e. that KVM's MMU doesn't have a use-after-free bug.  KVM
> > > > +        * (typically) doesn't pin pages that are mapped in KVM's MMU, and
> > > > +        * instead relies on mmu_notifiers to know when a mapping needs to be
> > > > +        * zapped/invalidated.  Unmapping from KVM's MMU must happen _before_
> > > > +        * KVM returns from its mmu_notifier, i.e. the page should have an
> > > > +        * elevated refcount at this point even though KVM doesn't hold a
> > > > +        * reference of its own.
> > > > +        */
> > > > +       if (WARN_ON_ONCE(!page_count(page)))
> > > > +               return false;
> > > > +
> > > >         /*
> > > >          * Per page-flags.h, pages tagged PG_reserved "should in general not be
> > > >          * touched (e.g. set dirty) except by its owner".
> > > > 
> > > 
> > > This looks like a good thing to have, indeed.  But again it doesn't seem
> > > like anything special to the pages we're discussing here, say, !Compound &&
> > > refcount==0 ones.
> > 
> > The problem is that if KVM ignores refcount==0 pages, then KVM can't distinguish
> > between the legitimate[*] refcount==0 AMD GPU case and a buggy refcount==0
> > use-after-free scenario.  I don't want to make that sacrifice as the legimiate
> > !refcounted use case is a very specific use case, whereas consuming refcounted
> > memory is ubiquituous (outside of maybe AWS).
> > 
> > [*] Consuming !refcounted pages is safe only for flows that are tied into the
> >     mmu_notifiers.  The current proposal/plan is to add an off-by-default module
> >     param that let's userspace opt-in to kmap() use of !refcounted memory, e.g.
> >     this case and PFNMAP memory.
> 
> I see.
> 
> I think you mentioned that we can use one special bit in the shadow pte to
> mark such special pages.  Does it mean that your above patch will still
> cover what you wanted to protect even if we use the trick?  Because then
> kvm_is_ad_tracked_page() should only be called when we're sure the special
> bit is not set.  IOW, we can still rule out these pages already and
> page_count()==0 check here can still be helpful to track kvm bugs?

Yep, exactly.  FWIW, I was thinking that the SPTE bit would flag refcounted pages,
not these "special" pages, but either way would work.  All that matters is that
KVM tracks whether or not the page was refcounted when KVM installed the SPTE.
