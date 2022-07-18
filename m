Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CCD5787C8
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbiGRQu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 12:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiGRQuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 12:50:23 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B16E08E
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:50:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 5so9539246plk.9
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xbz9zNJ4kudtBf4HleF/yHu6MPshPQFfqoJeR3sCNGk=;
        b=pIJd3Rwn4OsqgMkQsd/bkmHGfMyZspMyiAOd14uUTppNPZ2se0sG5bX1psOR5cPqnk
         bxbdl+zj9dDCNCReWjeZ5dReNQ08Gzy4tZwcqezsQOB1ABYcgOo2Xig5BHxO10/xpT/g
         ovXE+65resESh+wZlHPMAumZ5sCDQia67KIHmp7zX25uRJkk3huy1Wd9Z21YWmG+i2j9
         lfKAafpGO4z76Djs1J2bsLbFSTihsR11QLFcwdhM1HK8x3ZgcqnZsY1yoT7mpLn6NscT
         RZyI5K4yjdcnRMzQ3UXh0xSd9t4CT7uvWRGVaf70IoaWdW/zFXhPdWUoUww5unOGVF2a
         e+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xbz9zNJ4kudtBf4HleF/yHu6MPshPQFfqoJeR3sCNGk=;
        b=XoWXRExxhna//8iO8EOslPYxRyi/C6dFhTyZO/W9cWJVyjYRZOeWMo9PaZIaFFB1xj
         /wGZM4etmpMzD4gx9od4C+IoQkmLR27GS77MEW1gFpj2mC+QHFB2f0kc3HjZKCf0JjId
         P2XQnlU6vG+ZeI52lHVNqI3GwPydoBEQz2m5oepmGGaaGR0e3Wg3T/jryorE+X2COAJ9
         utbX98Bexvl638540U8XKyL0mGvlIO1wnhU2PvZd4zlxmzDr6z6KD2T1IPV6vwfmHnBB
         Nw/Gg2fQsTJDrJn+PWBtVENMX4gne4/KKXnqKFB6WKIHWIfMSiEfpkBMdbMAPCyNPJWx
         c7mw==
X-Gm-Message-State: AJIora/DYwuvKmQzSG9nu55a58nxmOFoTCuDhQ/YnV6kBZa8yxo7Nx5X
        4O37Qlj0mV2QJqI2KGnYZG+DQA==
X-Google-Smtp-Source: AGRyM1vl7YFDCbAwvvfalJOgfG+z5WlR/ZoOFjk4UTf7LkgcuSQbI2ibhatxCL/NtG24+yabrzs8Kg==
X-Received: by 2002:a17:902:e746:b0:16c:3ffd:61fb with SMTP id p6-20020a170902e74600b0016c3ffd61fbmr29139404plf.123.1658163020887;
        Mon, 18 Jul 2022 09:50:20 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id k6-20020aa79986000000b00528c22038f5sm9895204pfh.14.2022.07.18.09.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:50:20 -0700 (PDT)
Date:   Mon, 18 Jul 2022 16:50:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Document the "rules" for using
 host_pfn_mapping_level()
Message-ID: <YtWPSILmAp/0m5eC@google.com>
References: <20220715232107.3775620-1-seanjc@google.com>
 <20220715232107.3775620-3-seanjc@google.com>
 <YtMIvgfsgIPWMgGM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtMIvgfsgIPWMgGM@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 16, 2022, Mingwei Zhang wrote:
> On Fri, Jul 15, 2022, Sean Christopherson wrote:
> > Add a comment to document how host_pfn_mapping_level() can be used safely,
> > as the line between safe and dangerous is quite thin.  E.g. if KVM were
> > to ever support in-place promotion to create huge pages, consuming the
> > level is safe if the caller holds mmu_lock and checks that there's an
> > existing _leaf_ SPTE, but unsafe if the caller only checks that there's a
> > non-leaf SPTE.
> > 
> > Opportunistically tweak the existing comments to explicitly document why
> > KVM needs to use READ_ONCE().
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 42 +++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 35 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index bebff1d5acd4..d5b644f3e003 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2919,6 +2919,31 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
> >  	__direct_pte_prefetch(vcpu, sp, sptep);
> >  }
> >  
> > +/*
> > + * Lookup the mapping level for @gfn in the current mm.
> > + *
> > + * WARNING!  Use of host_pfn_mapping_level() requires the caller and the end
> > + * consumer to be tied into KVM's handlers for MMU notifier events!
> Since calling this function won't cause kernel crash now, I guess we can
> remove the warning sign here, but keep the remaining statement since it
> is necessary.

Calling this function won't _directly_ crash the kernel, but improper usage can
most definitely crash the host kernel, or even worse, silently corrupt host and
or guest data.  E.g. if KVM were to race with an mmu_notifier event and incorrectly
map a stale huge page into the guest.

So yes, the function itself is robust, but usage is still very subtle and delicate.

> > + *
> > + * There are several ways to safely use this helper:
> > + *
> > + * - Check mmu_notifier_retry_hva() after grabbing the mapping level, before
> > + *   consuming it.  In this case, mmu_lock doesn't need to be held during the
> > + *   lookup, but it does need to be held while checking the MMU notifier.
> 
> but it does need to be held while checking the MMU notifier and
> consuming the result.

I didn't want to include "consuming the result" because arguably the result is
being consumed while running the guest, and obviously KVM doesn't hold mmu_lock
while running the guest (though I fully acknowledge the above effectively uses
"consume" in the sense of shoving the result into SPTEs).  

> > + *
> > + * - Hold mmu_lock AND ensure there is no in-progress MMU notifier invalidation
> > + *   event for the hva.  This can be done by explicit checking the MMU notifier

s/explicit/explicitly

> > + *   or by ensuring that KVM already has a valid mapping that covers the hva.
> 
> Yes, more specifically, "mmu notifier sequence counter".

Heh, depends on what the reader interprets as "sequence counter".  If the reader
interprets that as the literal sequence counter, mmu_notifier_seq, then this phrasing
is incorrect as mmu_notifier_seq isn't bumped until the invalidation completes,
i.e. it guards against _past_ invalidations, not in-progress validations.

My preference is to intentionally not be precise in describing how to check for an
in-progress invalidation, e.g. so that this comment doesn't need to be updated if
the details change, and to also to try and force developers to do more than copy
and paste if they want to use this helper.
