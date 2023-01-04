Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0504865CB26
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 02:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbjADBAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 20:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjADBAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 20:00:42 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CEF17066
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 17:00:41 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-466c5fb1c39so446722877b3.10
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 17:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CjDUy4DyLWqialDx+oLtHpMfqyOR8g2BaJhUO6gTmfk=;
        b=eR5jD+Kzi4enxS2mo0zQ8w7UbSuNkQNe0DLqJqyFknrRav4Y85zJTCrtONPeXEl8Pf
         9Fmv5Cgw3apZ887oi4QlOhfTSK6lSBziIiebarh9uQpX7Hy3qx4NOdYJ2tIydgJDKk15
         bI81jiaOmY1C2CdF3vDXX/xaqE7HHUabKzHHlG2ndn14gVi+DadXFibMjziKCuiddHDD
         rNvgBRHgpVtV45mlf0h9/CUp4BKoMV/cbjXAtR51SnxwNuNfdrxLtMOlCWJt0tLMFL+f
         BVuzmhvpxKeQoIvDC9guGycKyRvQzdMuQwGc+XMt+ebcRscUaXfD3ZdLNWNKHWyqByAM
         EzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CjDUy4DyLWqialDx+oLtHpMfqyOR8g2BaJhUO6gTmfk=;
        b=yEyIzZiWVHrr3tD30r6JxEfdRnt7ghcwL9FLDYVdmSTYgwAIcMVfHd7FX661s94+Zl
         nRYDfHfXYmSvKNe0J+okugJNt06wIjCYMHRMzHgyGVbNi0iCJkyvtzfgqiRdrrGNlUpE
         4SKqTcO/S7KN2DvV07iQEGtRKJ2YOXvcFSvMWzK+d/lUJ+h7YF0UMRomE/+rZgFFc18e
         l83ugbkeMNkwuLdg3TI4aUvq4QZyiS/mBvEh9SxzXBTnl8R3c4uyHgiR5M6YTIkrfxme
         CH2hGhsEnHDSagGztX9FrIR60OBPHRHq1XxHVjDpJ9JPTWwjSQkm5RKO884jOEX4IjyG
         IsJQ==
X-Gm-Message-State: AFqh2krDfXMAxoh9W3clhJXhGcghMrUGIiVotWdM7YmVeWODzPzLOHEQ
        Q6+Scf0ivziE+m+VFJ2gi4VrUCA6huy3T9HwgBamgg==
X-Google-Smtp-Source: AMrXdXtiQi+hq88sxDOXcORmCgkHqXukWNpnyG/jVyI0iyqKDex2KRtHsGUn0omuHWxUotVBU5iAOsu5wA9jDefUICw=
X-Received: by 2002:a0d:d882:0:b0:36f:f251:213b with SMTP id
 a124-20020a0dd882000000b0036ff251213bmr3410913ywe.228.1672794040800; Tue, 03
 Jan 2023 17:00:40 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-2-vipinsh@google.com>
 <CAL715WKT_WbaUHT++tvnKr9fhGObiJpyKdD-zMmmcZnt4Bc=Gg@mail.gmail.com>
In-Reply-To: <CAL715WKT_WbaUHT++tvnKr9fhGObiJpyKdD-zMmmcZnt4Bc=Gg@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 3 Jan 2023 17:00:04 -0800
Message-ID: <CAHVum0f9kxHBBR8mBQrA3FrNHvPvqkGE8qXxKJhrnKoE6XkySg@mail.gmail.com>
Subject: Re: [Patch v3 1/9] KVM: x86/mmu: Repurpose KVM MMU shrinker to purge
 shadow page caches
To:     Mingwei Zhang <mizhang@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jan 3, 2023 at 11:32 AM Mingwei Zhang <mizhang@google.com> wrote:
>
> On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > +static void mmu_free_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
> > +                                    spinlock_t *cache_lock)
> > +{
> > +       int orig_nobjs;
> > +
> > +       spin_lock(cache_lock);
> > +       orig_nobjs = cache->nobjs;
> > +       kvm_mmu_free_memory_cache(cache);
> > +       if (orig_nobjs)
> > +               percpu_counter_sub(&kvm_total_unused_mmu_pages, orig_nobjs);
> > +
> > +       spin_unlock(cache_lock);
> > +}
>
> I think the mmu_cache allocation and deallocation may cause the usage
> of GFP_ATOMIC (as observed by other reviewers as well). Adding a new
> lock would definitely sound like a plan, but I think it might affect
> the performance. Alternatively, I am wondering if we could use a
> mmu_cache_sequence similar to mmu_notifier_seq to help avoid the
> concurrency?
>

Can you explain more about the performance impact? Each vcpu will have
its own mutex. So, only contention will be with the mmu_shrinker. This
shrinker will use mutex_try_lock() which will not block to wait for
the lock, it will just pass on to the next vcpu. While shrinker is
holding the lock, vcpu will be blocked in the page fault path but I
think it should not have a huge impact considering it will execute
rarely and for a small time.

> Similar to mmu_notifier_seq, mmu_cache_sequence should be protected by
> mmu write lock. In the page fault path, each vcpu has to collect a
> snapshot of  mmu_cache_sequence before calling into
> mmu_topup_memory_caches() and check the value again when holding the
> mmu lock. If the value is different, that means the mmu_shrinker has
> removed the cache objects and because of that, the vcpu should retry.
>

Yeah, this can be one approach. I think it will come down to the
performance impact of using mutex which I don't think should be a
concern.
