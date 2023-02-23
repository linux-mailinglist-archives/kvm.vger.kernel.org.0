Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A926A104B
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjBWTMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjBWTMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:12:19 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB5E5C17A
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:11:48 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-538116920c3so90619187b3.15
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lgz23S0KW/3Vuh8fPybY+EaMWzwQFtPo75lQKh/z++I=;
        b=illZ3Rsxhz/9jljbLI+FUdfsGaNHQ+3fywMFYtiPdi4y1cf10XY7ukC5ghyLXOpRiX
         ECKpfvO4XF3GMAEqQtGTGUg1jqO+AbRdSqGFpyrvz1Y54kJ0qEPuz3ERkD1mNPRjChGr
         FIk8fspffno+cxbJIVBWXLSAjcURDSQfT0pVMLjA9MwRSCOas0U4UaV//I6oaWp4/jP8
         Nedf5FJP2yTEdqt4rNWa/GGGRcnTa9xaHgSx+sUBPJmKn+5OuioGUbjEJBaVHxmxHjpR
         JfrWlzWMnyD8o2vHK884xzIW6y4U6nk3QsjYBj1PHqc/oR+/TNHECEU3hASerxLBXfzT
         1/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Lgz23S0KW/3Vuh8fPybY+EaMWzwQFtPo75lQKh/z++I=;
        b=aOcCqjbGbtHM1QlYdQhqFcYBPxaO+BjglHvsoJCFkdrjv6DT/AKhON2vFzOpCfEA+S
         nwNNXXnuII4svYuyQvHrgDOBRfZtgO0iWspf7qJWbRcD3D1gu0hE8XgH1M03im2KSBQ+
         GCZdraYpq/xOXrWj4fYWaQcOfbqJviEhq7SLFVtSbi1HMFx0MFR1N1FxELQp3CnrgXvS
         bLr1zUzNhbpS2fKuBoJ+qPmRu3LG7YvR9YH+aW/gKwPRWWZj44URwmfoVjExpiPwBXgi
         iXANs+edNxR6l4t4GwiDx9DXWsydWTOmBpHVGq5cuyiNLb5e//H+sTt1GR9KAbJ2eyp1
         RGTw==
X-Gm-Message-State: AO0yUKXZHEb/CgYcC4PK/inc7OfwrMiJrsPY7tfnBec7izxpFWcATtLz
        4vY4a5bLVcratzzl/TQUnOh48CnqKZw=
X-Google-Smtp-Source: AK7set9CAvBzEvzau8o9w7k/cYlwu85gWQxy7MQm2EeJKeyL2LgEayAQYJRKvwtnPY5l/Yt7cVb6SpmQxus=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:50b:0:b0:a36:3875:564a with SMTP id
 o11-20020a5b050b000000b00a363875564amr1021123ybp.2.1677179496807; Thu, 23 Feb
 2023 11:11:36 -0800 (PST)
Date:   Thu, 23 Feb 2023 11:11:35 -0800
In-Reply-To: <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
 <Y/elw7CTvVWt0Js6@google.com> <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
Message-ID: <Y/e6Z+KIl6sYJoRg@google.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 10:43=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Feb 16, 2023, Yu Zhao wrote:
> > >   kswapd (MGLRU before)
> > >     100.00%  balance_pgdat
> > >       100.00%  shrink_node
> > >         100.00%  shrink_one
> > >           99.97%  try_to_shrink_lruvec
> > >             99.06%  evict_folios
> > >               97.41%  shrink_folio_list
> > >                 31.33%  folio_referenced
> > >                   31.06%  rmap_walk_file
> > >                     30.89%  folio_referenced_one
> > >                       20.83%  __mmu_notifier_clear_flush_young
> > >                         20.54%  kvm_mmu_notifier_clear_flush_young
> > >   =3D>                      19.34%  _raw_write_lock
> > >
> > >   kswapd (MGLRU after)
> > >     100.00%  balance_pgdat
> > >       100.00%  shrink_node
> > >         100.00%  shrink_one
> > >           99.97%  try_to_shrink_lruvec
> > >             99.51%  evict_folios
> > >               71.70%  shrink_folio_list
> > >                 7.08%  folio_referenced
> > >                   6.78%  rmap_walk_file
> > >                     6.72%  folio_referenced_one
> > >                       5.60%  lru_gen_look_around
> > >   =3D>                    1.53%  __mmu_notifier_test_clear_young
> >
> > Do you happen to know how much of the improvement is due to batching, a=
nd how
> > much is due to using a walkless walk?
>=20
> No. I have three benchmarks running at the moment:
> 1. Windows SQL server guest on x86 host,
> 2. Apache Spark guest on arm64 host, and
> 3. Memcached guest on ppc64 host.
>=20
> If you are really interested in that, I can reprioritize -- I need to
> stop 1) and use that machine to get the number for you.

After looking at the "MGLRU before" stack again, it's definitely worth gett=
ing
those numbers.  The "before" isn't just taking mmu_lock, it's taking mmu_lo=
ck for
write _and_ flushing remote TLBs on _every_ PTE.  I suspect the batching is=
 a
tiny percentage of the overall win (might be larger with RETPOLINE and frie=
nds),
and that the bulk of the improvement comes from avoiding the insanity of
kvm_mmu_notifier_clear_flush_young().

Speaking of which, what would it take to drop mmu_notifier_clear_flush_youn=
g()
entirely?  I.e. why can MGLRU tolerate stale information but !MGLRU cannot?=
  If
we simply deleted mmu_notifier_clear_flush_young() and used mmu_notifier_cl=
ear_young()
instead, would anyone notice, let alone care?

> > > @@ -5699,6 +5797,9 @@ static ssize_t show_enabled(struct kobject *kob=
j, struct kobj_attribute *attr, c
> > >       if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_=
YOUNG))
> > >               caps |=3D BIT(LRU_GEN_NONLEAF_YOUNG);
> > >
> > > +     if (kvm_arch_has_test_clear_young() && get_cap(LRU_GEN_SPTE_WAL=
K))
> > > +             caps |=3D BIT(LRU_GEN_SPTE_WALK);
> >
> > As alluded to in patch 1, unless batching the walks even if KVM does _n=
ot_ support
> > a lockless walk is somehow _worse_ than using the existing mmu_notifier=
_clear_flush_young(),
> > I think batching the calls should be conditional only on LRU_GEN_SPTE_W=
ALK.  Or
> > if we want to avoid batching when there are no mmu_notifier listeners, =
probe
> > mmu_notifiers.  But don't call into KVM directly.
>=20
> I'm not sure I fully understand. Let's present the problem on the MM
> side: assuming KVM supports lockless walks, batching can still be
> worse (very unlikely), because GFNs can exhibit no memory locality at
> all. So this option allows userspace to disable batching.

I'm asking the opposite.  Is there a scenario where batching+lock is worse =
than
!batching+lock?  If not, then don't make batching depend on lockless walks.

> I fully understand why you don't want MM to call into KVM directly. No
> acceptable ways to set up a clear interface between MM and KVM other
> than the MMU notifier?

There are several options I can think of, but before we go spend time desig=
ning
the best API, I'd rather figure out if we care in the first place.
