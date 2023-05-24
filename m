Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F9170FDE5
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 20:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbjEXS35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 14:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbjEXS3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 14:29:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA71E7
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 11:29:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba83a9779f3so2593404276.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 11:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684952987; x=1687544987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zhCLzNiRBNlROtfKp+ujTOcVOVXlrI8zrVzKw44qRAY=;
        b=gk9VY1Fi8rAEgoEQhDDDcAlyZtuvVYH+tDqstE9RgYMCMx44Q39XjyhilHUndn79Jf
         DsYr1NeHSyJUP6Xnpups0LK8LE/e6MaJSo5KgXEbph/nbdV6f20iBAAvJDcDAb8yWxqa
         PwXxf/osa258qdIt5lOohF/nQXbGcInom6MWSqv5xu2G/FDMvyF17aGJfKTyj0ZxdkU+
         1YwX6JquS35m12/IprqBATiSQnRhymKxch+P3H7efEhJZWSGzCXGn81+zzZVAaeP//kP
         +akCm4mHwxaHiE3+Y6UMz/ktFwEkssQ3cCRXbiLWobVua0yuYn9XCHMU6TN87sPyU0Lr
         hBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684952987; x=1687544987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zhCLzNiRBNlROtfKp+ujTOcVOVXlrI8zrVzKw44qRAY=;
        b=CegfNP/iro1mf3BUCwvkstCukKLrtl59IrPT8HPLCjFqTVqaa3X/VYxWpoliYVJxDR
         kHgEBiOoyMViQ4R8xmYkfW9XvXXcjYI1bE9vfxUe+LO+DoCOUKXFIXSWNDl+pJ09qr8T
         X9YbhlmWFZw2KpvQGF4jwZo7TTe9f7NBiTdI+pIYouNgxh36J/sRvgrRf+EGp9pGVJq9
         hBIq2Lr9/trRPzsvAdK1EubQ8DlRqhEVy8EasZ8Of3Qs7VEpADPwYvAjb/Wk6yDnsH7b
         6AEElfmiVawbqP1iZnu0qo5NBsm1zSuRrlpqb7DRJxemOZWzylTA0HJ5cSZivcaI/U6O
         n2yA==
X-Gm-Message-State: AC+VfDw6ZbWBa1G3mT1ugfCT/tcVI38tUUpSW+z6737xiLB7aX0psrb5
        UNsAOfqiDoxkzLcPEBepbk/SY/cbhEo=
X-Google-Smtp-Source: ACHHUZ6aIrpFTNF+ZZtuCtnMHlGQa2V7WRfUVWrDI43ohWGbs/qTvtv8jZTbxA9m9umssjztL0lGmACZlFw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1024:b0:ba8:6422:7fc with SMTP id
 x4-20020a056902102400b00ba8642207fcmr398046ybt.7.1684952987216; Wed, 24 May
 2023 11:29:47 -0700 (PDT)
Date:   Wed, 24 May 2023 11:29:45 -0700
In-Reply-To: <ZG5F3igFgdIAwrn4@x1n>
Mime-Version: 1.0
References: <20230330085802.2414466-1-stevensd@google.com> <20230330085802.2414466-2-stevensd@google.com>
 <ZGvUsf7lMkrNDHuE@google.com> <ZG45q0xJSnA6NKQN@x1n> <ZG4/VdHu2LqLTlct@google.com>
 <ZG5F3igFgdIAwrn4@x1n>
Message-ID: <ZG5XmdYy3VtcyPAL@google.com>
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
> On Wed, May 24, 2023 at 09:46:13AM -0700, Sean Christopherson wrote:
> > If we hack kvm_pfn_to_refcounted_page(), then all of those protections are lost
> > because KVM would drop its assertions and also skip dirtying pages, i.e. would
> > effectively suppress the latent detection by check_new_page_bad().
> 
> So it's probably that I totally have no idea what are the attributes for
> those special pages so I don't understand enough on why we need to handle
> those pages differently from e.g. PFNMAP pages, and also the benefits.
> 
> I think what I can tell is that they're pages that doesn't have
> PageCompound bits set on either head or tails, however it's still a
> multi-2-order large page.  Is there an example on how these pages are used
> and allocated?  Why would we need those pages, and whether these pages need
> to be set dirty/accessed after all?

The use case David is interested in is where an AMD GPU driver kmallocs() a
chunk of memory, let's it be mmap()'d by userspace, and userspace then maps it
into the guest for a virtual (passthrough?) GPU.  For all intents and purposes,
it's normal memory, just not refcounted.

> >  static bool kvm_is_ad_tracked_page(struct page *page)
> >  {
> > +       /*
> > +        * Assert that KVM isn't attempting to mark a freed page as Accessed or
> > +        * Dirty, i.e. that KVM's MMU doesn't have a use-after-free bug.  KVM
> > +        * (typically) doesn't pin pages that are mapped in KVM's MMU, and
> > +        * instead relies on mmu_notifiers to know when a mapping needs to be
> > +        * zapped/invalidated.  Unmapping from KVM's MMU must happen _before_
> > +        * KVM returns from its mmu_notifier, i.e. the page should have an
> > +        * elevated refcount at this point even though KVM doesn't hold a
> > +        * reference of its own.
> > +        */
> > +       if (WARN_ON_ONCE(!page_count(page)))
> > +               return false;
> > +
> >         /*
> >          * Per page-flags.h, pages tagged PG_reserved "should in general not be
> >          * touched (e.g. set dirty) except by its owner".
> > 
> 
> This looks like a good thing to have, indeed.  But again it doesn't seem
> like anything special to the pages we're discussing here, say, !Compound &&
> refcount==0 ones.

The problem is that if KVM ignores refcount==0 pages, then KVM can't distinguish
between the legitimate[*] refcount==0 AMD GPU case and a buggy refcount==0
use-after-free scenario.  I don't want to make that sacrifice as the legimiate
!refcounted use case is a very specific use case, whereas consuming refcounted
memory is ubiquituous (outside of maybe AWS).

[*] Consuming !refcounted pages is safe only for flows that are tied into the
    mmu_notifiers.  The current proposal/plan is to add an off-by-default module
    param that let's userspace opt-in to kmap() use of !refcounted memory, e.g.
    this case and PFNMAP memory.
