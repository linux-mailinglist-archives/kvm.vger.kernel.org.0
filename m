Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101614298E5
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 23:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhJKV3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 17:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbhJKV3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 17:29:45 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC00DC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 14:27:44 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id n8so76484534lfk.6
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 14:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=efcb6Mf33zL3P5qhl+hWTZcZKW+csLXJG9StF/1J3CA=;
        b=EZXRIxOSnWhfyjcX/3hYzfQ4GUf3XrVHanHX58blofeJ3skGH8hc0YGgztJRdpXWwu
         Zn7MJvIaAB3KTLQSoqtUorraA5fuWPPwIj/ynwc28hJXsHwulwAyytrrC3LFzrM8Sfym
         zoccrdqADHsZhVE4SniCb+0et4Karq/KRtLE/iqxNMBB6N/9fhl0GMesiKjL7S2UgCa6
         p5ENn3APeR5+7ITu6JFgmKt/35nmb3vwBpd7RXPSxXzZ6OV1aysCfo1FM1OPGXdy8PHd
         boLCYLeM4yivyoPNDe+9DWkN+aj+5Un8JB/lmGnd3Mm5Xr126VP9bRVXX0ZxWe5putmK
         Ktgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=efcb6Mf33zL3P5qhl+hWTZcZKW+csLXJG9StF/1J3CA=;
        b=K/1QzYFurgITPHYGB93hE7XsQ9id9KkJgC+X2weQECVPDtlka3P0qhfcY0d77imrfx
         +epMGUIueZ3PKske3WswM0LkUr5XpBI9LBN74YDtEk+aFFOmSPYQReZwvSONHxCgacxf
         KYc1kQcBy+T6+r9Ilx4yOzHvpNCh6KnKVUq7p9A4dw2Obtua/TikdOBTifBr2rrilHtE
         mI0J553kkzxKRTLOrvnHDgsk0Y9NQFO72qRh7q5TI4C8AJLXuYUpU8IQecUpWtGEhw9P
         J+xXZ7aE/QudrhLJQKBi29wxyCOrDQSsMFVApXYTxcQSrfRb+zPVZJjCkp4J1JK9x7T5
         PwZg==
X-Gm-Message-State: AOAM53130LlM1grMVHYKxJIfvdh2alZz97agyfjG+8KWQC1D8EXWckiI
        KAtfUH3NCVLhqn7bxN6zYHIJ0mrB1hyDp/EnpnTP0Q==
X-Google-Smtp-Source: ABdhPJygDe0LVQRJEZkO0I/XjJuFloe9zsQPpslJx9erbknKnVHj8HKsPtirLdbkj/UC/jAPWrTC96YyBoJZBZFt3UU=
X-Received: by 2002:a05:651c:905:: with SMTP id e5mr24870546ljq.361.1633987662926;
 Mon, 11 Oct 2021 14:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211011204418.162846-1-dmatlack@google.com> <CANgfPd9R5kv-URf2huH8NBmggrh_1wfa+ap=1QRWN4YdJHCXEQ@mail.gmail.com>
 <CALzav=dXGFTTWtrZafc3K7ny66Kgz07DsTdVWneUen4io+k=_g@mail.gmail.com>
In-Reply-To: <CALzav=dXGFTTWtrZafc3K7ny66Kgz07DsTdVWneUen4io+k=_g@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 11 Oct 2021 14:27:16 -0700
Message-ID: <CALzav=eOU5s9aBeVjzuZEy3ipWWDLn42ZpPYwtpS1OgnS-h+Tg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 2:25 PM David Matlack <dmatlack@google.com> wrote:
>
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
>
> Agreed. The legacy MMU implementation relies on the fact that
> collapsible 2M SPTEs are never generated by dirty logging so it only
> needs to check 4K SPTEs.
>
> The TDP MMU implementation is actually more robust, since it checks
> every SPTE for collapsibility. The only reason it would be doing extra
> zaps if there is something other than dirty logging can cause an SPTE
> to be collapsible. (HugePage NX comes to mind.)

Ah but HugePage NX does not create 2M SPTEs so this wouldn't actually
result in extra zaps.

>
> >
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> >
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> >
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 18 +++++++++++++-----
> > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 24a9f4c3f5e7..f00644e79ef5 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -5382,8 +5382,8 @@ slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
> > >  }
> > >
> > >  static __always_inline bool
> > > -slot_handle_leaf(struct kvm *kvm, const struct kvm_memory_slot *memslot,
> > > -                slot_level_handler fn, bool flush_on_yield)
> > > +slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
> > > +                    slot_level_handler fn, bool flush_on_yield)
> > >  {
> > >         return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
> > >                                  PG_LEVEL_4K, flush_on_yield);
> > > @@ -5772,7 +5772,12 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> > >
> > >         if (kvm_memslots_have_rmaps(kvm)) {
> > >                 write_lock(&kvm->mmu_lock);
> > > -               flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
> > > +               /*
> > > +                * Strictly speaking only 4k SPTEs need to be zapped because
> > > +                * KVM never creates intermediate 2m mappings when performing
> > > +                * dirty logging.
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
> > > +                */
> > > +               flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
> > >                 write_unlock(&kvm->mmu_lock);
> > >         }
> > >
> > > --
> > > 2.33.0.882.g93a45727a2-goog
> > >
