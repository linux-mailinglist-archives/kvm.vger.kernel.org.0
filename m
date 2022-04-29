Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030D0513FC3
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 02:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353566AbiD2Atg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 20:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353572AbiD2At3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 20:49:29 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662ABBB914
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 17:46:12 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u9so5172800plf.6
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 17:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EagzqCWHhn+9dJ9MscFTqU/lwiWeVVOzta6evzEb65E=;
        b=O2Tw5b/hhSM7sUPjKZfilkafwE0fUd90Qg+9mXCE0z95XVG7P9ldKCaRrJuE48TNa6
         uiYD2bucdUQ9ixgkz3GWzV+OOptKqGg1oxo4ez3bDMzBJw879qwDr5IevJ9fmgsSkMnR
         X1O85tFU8VXMcEvzUwLWI6XC/HRHSP8K73rwHxfkLHGffb+HFPfXZe20smWbdgI3e4s9
         3oUT5JvXNpO8e4IMGrhzYq+DycpRNqos3zrBxQvA6i8hL9Y9fyukUCJ1TzaynpFD51/7
         4tgJUwxrKOY9HfsFSraMuECV8rUNDmie4DCd5gLwZqkNUHVNRrQ5WZW/6HsTnp2J95L8
         cQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EagzqCWHhn+9dJ9MscFTqU/lwiWeVVOzta6evzEb65E=;
        b=7Ia7E7S2GEpQPLJEmbgC7jEG7CVNuOaAUkAYGPMuYHUOkSfZAi2dnXv6WwAANIyBg0
         Gp//XRadS5BvdwZSxxD1qAzbLGxxPMEI8CIOlbvQu5MJjPA+XP8UWtwIfFvLT1EkiVVx
         RB9FJ7dMP3cJ+cmFB3YQ/Dkuq1tIzpggX5ZR3gB1eu/rpowm9H7tvnUyLHAYyZaQ4IYF
         8oHhoUHTq58iMNk93JMyQMMuBIVZc7tJbpbXqZXiMEhKK/u3RiQBO4doV3OyDR7KXU1a
         RxNYkiQdvg6coePWRv2gB4XIf6N0/R31FjWCG5/FGrqa+zOyJzutgmTkQ9/pN4Km0ddZ
         /NFw==
X-Gm-Message-State: AOAM531tJ3KRdizQHrOdl+KN/57ENxbIS69Z79hi9iSn/EmNnrDqAVtb
        UjX/N6TuUWinEFJlBh/6g7jhSw==
X-Google-Smtp-Source: ABdhPJyWe5FGjQ9v+/trRLwUkRBNkzA5jk+4leC8OEvgYgH3lqH/mqVluuuAs5ELoXD898wWwvv9qw==
X-Received: by 2002:a17:902:e808:b0:15c:ed0d:f11c with SMTP id u8-20020a170902e80800b0015ced0df11cmr29016694plg.1.1651193172304;
        Thu, 28 Apr 2022 17:46:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 35-20020a631063000000b003c14af50602sm3974267pgq.26.2022.04.28.17.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 17:46:11 -0700 (PDT)
Date:   Fri, 29 Apr 2022 00:46:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 048/104] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <Yms1UPapk9jVGHrf@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <7a5246c54427952728bd702bd7f2c6963eefa712.1646422845.git.isaku.yamahata@intel.com>
 <CAAhR5DE4-Z6JYLHbWyEyraqqWCx5bD+gZADAnisDmSJ4bkgV8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhR5DE4-Z6JYLHbWyEyraqqWCx5bD+gZADAnisDmSJ4bkgV8g@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022, Sagi Shahar wrote:
> > @@ -468,23 +503,49 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >
> >         if (was_leaf && is_dirty_spte(old_spte) &&
> >             (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
> > -               kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> > +               kvm_set_pfn_dirty(old_pfn);
> > +
> > +       /*
> > +        * Special handling for the private mapping.  We are either
> > +        * setting up new mapping at middle level page table, or leaf,
> > +        * or tearing down existing mapping.
> > +        */
> > +       if (private_spte) {
> > +               void *sept_page = NULL;
> > +
> > +               if (is_present && !is_leaf) {
> > +                       struct kvm_mmu_page *sp = to_shadow_page(pfn_to_hpa(new_pfn));
> > +
> > +                       sept_page = kvm_mmu_private_sp(sp);
> > +                       WARN_ON(!sept_page);
> > +                       WARN_ON(sp->role.level + 1 != level);
> > +                       WARN_ON(sp->gfn != gfn);
> > +               }
> > +
> > +               static_call(kvm_x86_handle_changed_private_spte)(
> > +                       kvm, gfn, level,
> > +                       old_pfn, was_present, was_leaf,
> > +                       new_pfn, is_present, is_leaf, sept_page);
> > +       }
> >
> >         /*
> >          * Recursively handle child PTs if the change removed a subtree from
> >          * the paging structure.
> >          */
> > -       if (was_present && !was_leaf && (pfn_changed || !is_present))
> > +       if (was_present && !was_leaf && (pfn_changed || !is_present)) {
> > +               WARN_ON(private_spte !=
> > +                       is_private_spte(spte_to_child_pt(old_spte, level)));

This sanity check is pointless.  The private flag comes from the parent shadow
page role, and that's not changing.

> > @@ -1015,6 +1137,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                     is_large_pte(iter.old_spte)) {
> >                         if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> >                                 break;
> > +                       /*
> > +                        * TODO: large page support.
> > +                        * Doesn't support large page for TDX now
> > +                        */
> > +                       WARN_ON(is_private_spte(&iter.old_spte));
> 
> The above line is causing a null ptr dereferencing when running the
> KVM unit tests.
> It should be is_private_spte(iter.sptep) instead of
> is_private_spte(&iter.old_spte)
> While old_spte holds a snapshot of the value pointed to by sptep,
> &old_spte is not equivalent to sptep.

Bug aside, the name is really, really bad.  All of the existing helpers with an
"is_blah_spte()" name take an SPTE value, not a pointer to an SPTE.

is_private_sptep() is the obvious choice.  That makes me a bit nervous too, and
I don't love having to go back to the parent to query private vs shared.

That said, I think it's worth waiting to see the next version of this series before
going behind the bikeshed, I suspect many/most of the calls will go away, i.e. we
might find a better option presents itself.
