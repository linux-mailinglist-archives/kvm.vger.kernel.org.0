Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDA542F79B
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbhJOQEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhJOQEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 12:04:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CF7C061570
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 09:02:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso9646357pjb.4
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J9BCW2Wzr9gAJ8XGl0UmTneu0n5hmcJzT77ktIn3cSs=;
        b=fqK2/DKQfYy3ktG5ZvfY8ST7w98hC0Vc4RhYUbDZ3dLqAG3+/RJKBcr6V6ve9LIs3b
         hF8lDhnhY50WFmELxW0x1oD9kB0SIZ4VAWtrugOPvMQvDZpXraMyy/1YfEbXAHxsBmud
         P0/O0VorEZ/1yfZtivM2V9bST0jW4V6vatUd3VDvrV4L/S5UrX8k3sYjKOqz2osFmCPi
         yqOusipoXS4xrIamFhDZ/EH3AZhumkoSu9jIeQ6rhAPYVhZeLl/m227dacX/rc4jKNf5
         n3sygY/UxmPKTBaGiDlP7opvIOJNGYKdlnNqH25jqkQp26qyRIawsyBzmRKDqmArOrmt
         dcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J9BCW2Wzr9gAJ8XGl0UmTneu0n5hmcJzT77ktIn3cSs=;
        b=tO8XJ2ELpq0czgFD++YyCMqLZ+VNgFs627kJULrixzebjbjhiIJxsO7ZKlcWOirGjf
         EwD8ZIWZSd/YF0bR3gxG34D97xygZhUXh3xh7KT5ejYup7o8GwD9csLs7WTuPdSMlwKv
         +dhKwyUikptm1ZuQpHl3kC4fzDMEaY1Feh80OZw3wOmY+DYgXk+NUHQzb+yjb+VH2Teo
         GrXsdN7vaQxfnbuGrFXzYDgJaWLTNHwDVBTNuvUylJSVhkMNWvb1wFTT1pJr9SP+6l4/
         4s63wsOejp4TGXhM6SUs0Th+BRC3yROzTVPj7R7AAnDV0Zem8HxBX44KVDx0x7Aa9eGk
         XiRA==
X-Gm-Message-State: AOAM531EpREiXUzeo46GSv2eFFk3VMyiFMXPVmpH53w0K7fmQb19goR4
        Cc2rejnlpN9W7PC3uXihPsKVYA==
X-Google-Smtp-Source: ABdhPJxpeU9mjRwOPi1qxizvmDf8mjvDpQM251bLdThkO/GmCbN48IcA0KH9vix2Ey9SfgNmpPvVFg==
X-Received: by 2002:a17:90b:88d:: with SMTP id bj13mr14438896pjb.211.1634313760326;
        Fri, 15 Oct 2021 09:02:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m22sm5289775pfo.71.2021.10.15.09.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:02:39 -0700 (PDT)
Date:   Fri, 15 Oct 2021 16:02:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Rename slot_handle_leaf to
 slot_handle_level_4k
Message-ID: <YWmmG2bBdWQ91Hnh@google.com>
References: <20211011204418.162846-1-dmatlack@google.com>
 <CANgfPd9R5kv-URf2huH8NBmggrh_1wfa+ap=1QRWN4YdJHCXEQ@mail.gmail.com>
 <CALzav=dXGFTTWtrZafc3K7ny66Kgz07DsTdVWneUen4io+k=_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dXGFTTWtrZafc3K7ny66Kgz07DsTdVWneUen4io+k=_g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021, David Matlack wrote:
> On Mon, Oct 11, 2021 at 2:07 PM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Mon, Oct 11, 2021 at 1:44 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > slot_handle_leaf is a misnomer because it only operates on 4K SPTEs
> > > whereas "leaf" is used to describe any valid terminal SPTE (4K or
> > > large page). Rename slot_handle_leaf to slot_handle_level_4k to
> > > avoid confusion.
> > >
> > > Making this change makes it more obvious there is a benign discrepency
> > > between the legacy MMU and the TDP MMU when it comes to dirty logging.
> > > The legacy MMU only operates on 4K SPTEs when zapping for collapsing
> > > and when clearing D-bits. The TDP MMU, on the other hand, operates on
> > > SPTEs on all levels. The TDP MMU behavior is technically overkill but
> > > not incorrect. So opportunistically add comments to explain the
> > > difference.
> >
> > Note that at least in the zapping case when disabling dirty logging,
> > the TDP MMU will still only zap pages if they're mapped smaller than
> > the highest granularity they could be. As a result it uses a slower
> > check, but shouldn't be doing many (if any) extra zaps.

FWIW, the legacy MMU now has the same guard against spurious zaps.

> Agreed. The legacy MMU implementation relies on the fact that
> collapsible 2M SPTEs are never generated by dirty logging so it only
> needs to check 4K SPTEs.

I think it makes sense to send a v2 to further clarify the TDP MMU with these
details, e.g. expand the last sentences to something like

  The TDP MMU behavior of zapping SPTEs at all levels is technically overkill for
  its current dirty logging implementation, which always demotes to 4k SPTES, but
  both the TDP MMU and legacy MMU zap if and only if the SPTE can be replaced by
  a larger page, i.e. will not spuriously zap 2m (or larger) SPTEs.

> > > @@ -5772,7 +5772,12 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> > >
> > >         if (kvm_memslots_have_rmaps(kvm)) {
> > >                 write_lock(&kvm->mmu_lock);
> > > -               flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
> > > +               /*
> > > +                * Strictly speaking only 4k SPTEs need to be zapped because
> > > +                * KVM never creates intermediate 2m mappings when performing
> > > +                * dirty logging.

And then also tweak this comment to clarify that the _legacy_ MMU never creates
2m SPTEs when dirty logging, so that the comment doesn't become incorrect if KVM
ever supports 2mb+ granularity in the TDP MMU but not the legacy MMU, e.g.

			/*
			 * Zap only 4k SPTEs, the legacy MMU only supports dirty
			 * logging at 4k granularity, i.e. doesn't create 2m
			 * SPTEs when dirty logging is enabled.
			 */

> > > +                */
> > > +               flush = slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
> > >                 if (flush)
> > >                         kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > >                 write_unlock(&kvm->mmu_lock);
> > > @@ -5809,8 +5814,11 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> > >
> > >         if (kvm_memslots_have_rmaps(kvm)) {
> > >                 write_lock(&kvm->mmu_lock);
> > > -               flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
> > > -                                        false);
> > > +               /*
> > > +                * Strictly speaking only 4k SPTEs need to be cleared because
> > > +                * KVM always performs dirty logging at a 4k granularity.

And "s/KVM/the legacy MMU" here as well.

> > > +                */
> > > +               flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
> > >                 write_unlock(&kvm->mmu_lock);
> > >         }
> > >
> > > --
> > > 2.33.0.882.g93a45727a2-goog
> > >
