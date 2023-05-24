Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791C670FBE8
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 18:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbjEXQqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 12:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEXQqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 12:46:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E29F5
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 09:46:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8c9e9e164so2196311276.2
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 09:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684946775; x=1687538775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aiAfaynwA50QWKQNeVgzvLuZt713scWlZdQA6Janm88=;
        b=kjYcE2DxRfSvH51jvNEF5oXBTRn3b6/Z+Qox0X+/VjeCukM4HZKKDy6/6qaBp/dGQO
         v3P+98gGpvewasm8sGzmA4Kowdag5kZAvBahMXpJn+cEjxxgNndTMXWeSKE4DwPtXf0M
         Xm75VJisGMBMmpHLPdshGN6watrjYERYet7L2ZlBiYrsYZKFJoS6VBNiYyicndl6mMZr
         w6WKmRS5qvUn9sQmbtBIDeZFDVTq31yzx1C8WQviYWuqGdQrzxgUV8VXwEw4V6099dDC
         unj1DRz1+oyXIe74I2oKhj1xDo3pBCrIjxzLddf0I2ofA7qZ1xhEuPBc2n6n3CzLQB3s
         hdnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684946775; x=1687538775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aiAfaynwA50QWKQNeVgzvLuZt713scWlZdQA6Janm88=;
        b=LSPohbhxI2HhWh8Ej6tG1PiRPFCT+n7gcWePDtJ0BLfCwHknHd9CmkzWdSrOB6NRsA
         E2HGHLDqhA+W+1Al5j+IZcllsLMXdYAvXhyebmGKQLrLtHb2zOK3nGHybxY5tKFv1KKU
         qiXvVyEH1fPoSS777BrnSGXEweHEZeYDMQd/98ZigOh3/eucttST07ZVLB77tnlxzALY
         MJfrM6Kguv9hzUSmwRXOMvjgj+5KARRDpptvMnspuk7yhq2W+Dsbwxa+Ka+VRBN3N02B
         9Ws5GSp0ejjc3ohzfcgE/rBrcrqjzk+PIsnvBVpD5R365kKhDovvxoRjvdm6GprDlc1Q
         WwlQ==
X-Gm-Message-State: AC+VfDzZdef84+SFnVpfLWMQFSUHevApHeFAF2b1Dov0Y3QKblU+KeIS
        pvn3XxOT/815QZWFB6MFx7G3ozhZLrg=
X-Google-Smtp-Source: ACHHUZ4AK9p5vIZivq3Vl/EV2a/4dtczZlNo3sgWsftDLfzNDKeicgdDljqPBtujz76lVARcW+SuQ1drH5E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1615:b0:ba7:8099:c5f2 with SMTP id
 bw21-20020a056902161500b00ba78099c5f2mr151041ybb.8.1684946775431; Wed, 24 May
 2023 09:46:15 -0700 (PDT)
Date:   Wed, 24 May 2023 09:46:13 -0700
In-Reply-To: <ZG45q0xJSnA6NKQN@x1n>
Mime-Version: 1.0
References: <20230330085802.2414466-1-stevensd@google.com> <20230330085802.2414466-2-stevensd@google.com>
 <ZGvUsf7lMkrNDHuE@google.com> <ZG45q0xJSnA6NKQN@x1n>
Message-ID: <ZG4/VdHu2LqLTlct@google.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023, Peter Xu wrote:
> On Mon, May 22, 2023 at 01:46:41PM -0700, Sean Christopherson wrote:
> > As for the flags vs. bools debate (see link above), I think the best approach is
> > a mix of the two.  Specifically, reuse the FOLL_* flags as-is for inputs, and use
> > booleans for outputs.  I don't _think_ there are any input bools/flags that don't
> > map 1:1 with existing FOLL_* flags.
> > 
> > As a very, *very* rough sketch, provide APIs that look a bit like this.
> 
> Unifying ref vs nonref cases does look a bit cleaner to me too.
> 
> > 
> >   kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
> >   {
> > 	kvm_pfn_t pfn;
> > 
> > 	if (WARN_ON_ONCE(!(foll->flags & FOLL_GET) && !foll.mmu_seq))
> 
> IMHO we may not want to rely on mmu_seq==0 either for unlucky very initial
> mmu_seq being zero, or avoid overflows?

I was thinking we could initialize mmu_seq to '1' and make it a u64 to avoid
overflow.

> I'd say we can stick with FOLL_GET in this case to identify ref vs nonref
> and always assume mmu_seq a pure random number.

The intent of checking mmu_seq is to flag cases where the caller doesn't specify
FOLL_GET and isn't protected by mmu_invalidate_seq, i.e. isn't tapped into the
mmu_notifiers.  I.e. this is a sanity check, not functionally necessary.

> 
> > 		return KVM_PFN_ERR_FAULT;
> > 
> > 	pfn = ???;
> > 
> > 	if (foll->page && !(foll->flags & FOLL_GET))
> > 		put_page(foll->page);
> > 
> > 	return pfn;
> >   }
> > 
> >   kvm_pfn_t kvm_follow_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct page **page)
> >   {
> > 	struct kvm_follow_pfn foll = {
> > 		.flags = FOLL_GET | FOLL_WRITE,
> > 	};
> > 
> > 	<more stuff here?>
> > 
> > 	foll.slot = ???;
> > 	if (!foll.slot || foll.slot->flags & KVM_MEMSLOT_INVALID)
> > 		return KVM_HVA_ERR_BAD;
> > 
> > 	if (memslot_is_readonly(foll.slot))
> > 		return KVM_HVA_ERR_RO_BAD;
> > 
> > 	return __kvm_follow_pfn(&foll);
> >   }
> > 
> > and a few partially converted users
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 67e2ac799aa7..5eaf0395ed87 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -550,12 +550,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
> >  
> >         if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
> >                 flush = true;
> > -               kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> > +               if (is_refcounted_page_pte(old_spte))
> 
> One question is how to impl is_refcounted_page_pte() here to identify
> non-refcountable pages.

KVM would use a software available bit in its PTEs to explicitly track which SPTEs
point at refcounted pages.  E.g. I think bit 59 is available for EPT and 64-bit
paging.  PAE paging doesn't have high available bits, which is why I called out
that this would have to be 64-bit only.

> IIUC those pages are mostly identical to a normal page (so !PG_reserved)
> but it has page_ref_count(page)==0 always, am I right?  I got that roughly
> from reading f8be156be1 only though, so I could miss a lot of things..
> 
> When thinking about that, I'm also wondering whether we can trivially allow
> kvm to support such mapping (without overhaul of the kvm pfn API) by
> something like this:
> 
> ===8<===
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 51e4882d0873..467acbac1a96 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -192,7 +192,13 @@ struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
> 
>         page = pfn_to_page(pfn);
>         if (!PageReserved(page))
> -               return page;
> +               /*
> +                * When page_ref_count(page)==0 it might be speical page
> +                * that do not support refcounting.  Treating them the same
> +                * as normal reserved (e.g. MMIO) pages by returning NULL,
> +                * so they're exempt of refcounting.
> +                */
> +               return page_ref_count(page) == 0 ? NULL : page;

Heh, because I got burned by this recently, using page_ref_count() is wrong.  This
needs to be page_count() so that tail pages of refcounted compound pages are
properly identified.

> 
>         /* The ZERO_PAGE(s) is marked PG_reserved, but is refcounted. */
>         if (is_zero_pfn(pfn))
> ===8<===
> 
> So that we treat those special pages the same as normal PFNMAP ones by
> skipping all refcountings on inc/dec.  This is based on the fact that kvm
> should always hold at least 1 ref on a normal page so a normal page should
> never hit ref==0 here, but again I could miss something somewhere..

This would "work" from a functionality perspective, and might be acceptable as an
out-of-tree patch to unblock the ChromeOS use case, but I don't want to rely on
this heuristic on the backend in KVM because it will suppress any and all
use-after-free bugs in KVM's MMU (see patch 4 of this series).  I really want to
go in the opposite direction and harden KVM against MMU bugs, e.g. I'm planning
on posting the below (which is how I learned about page_count() vs. page_ref_count()).

Today, KVM gets partial protection from check_new_page_bad(), which detects *some*
cases where KVM marks a page dirty after the page is freed.  But it's racy, and
the detection occurs well after the fact since it fires only when the page is
re-allocated.

If we hack kvm_pfn_to_refcounted_page(), then all of those protections are lost
because KVM would drop its assertions and also skip dirtying pages, i.e. would
effectively suppress the latent detection by check_new_page_bad().

Author: Sean Christopherson <seanjc@google.com>
Date:   Wed May 17 13:26:54 2023 -0700

    KVM: Assert that a page's refcount is elevated when marking accessed/dirty
    
    Assert that a page's refcount is elevated, i.e. that _something_ holds a
    reference to the page, when KVM marks a page as accessed and/or dirty.
    KVM typically doesn't hold a reference to pages that are mapped into the
    guest, e.g. to allow page migration, compaction, swap, etc., and instead
    relies on mmu_notifiers to react to changes in the primary MMU.
    
    Incorrect handling of mmu_notifier events (or similar mechanisms) can
    result in KVM keeping a mapping beyond the lifetime of the backing page,
    i.e. can (and often does) result in use-after-free.  Yelling if KVM marks
    a freed page as accessed/dirty doesn't prevent badness as KVM usually
    only does A/D updates when unmapping memory from the guest, i.e. the
    assertion fires well after an underlying bug has occured, but yelling
    does help detect, triage, and debug use-after-free bugs.
    
    Note, the assertion must use page_count(), NOT page_ref_count()!  For
    hugepages, the returned struct page may be a tailpage and thus not have
    its own refcount.
    
    Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1abb331ea68..64f18697096c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2882,6 +2882,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
 static bool kvm_is_ad_tracked_page(struct page *page)
 {
+       /*
+        * Assert that KVM isn't attempting to mark a freed page as Accessed or
+        * Dirty, i.e. that KVM's MMU doesn't have a use-after-free bug.  KVM
+        * (typically) doesn't pin pages that are mapped in KVM's MMU, and
+        * instead relies on mmu_notifiers to know when a mapping needs to be
+        * zapped/invalidated.  Unmapping from KVM's MMU must happen _before_
+        * KVM returns from its mmu_notifier, i.e. the page should have an
+        * elevated refcount at this point even though KVM doesn't hold a
+        * reference of its own.
+        */
+       if (WARN_ON_ONCE(!page_count(page)))
+               return false;
+
        /*
         * Per page-flags.h, pages tagged PG_reserved "should in general not be
         * touched (e.g. set dirty) except by its owner".

