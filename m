Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2736B3288
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 01:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjCJAHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 19:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCJAH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 19:07:28 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7556CF8285
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 16:07:27 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id x1so2406565uav.9
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 16:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678406846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R96Vy3bzWe3iRlAJWoP7dbbEtRj3288SsN12+zliR+o=;
        b=U7ED+uGZhrJWU0A5W675pD4df+3lGt5XlElIpc1w6sqypbxbG8DkybmFGFX2aJ1OwB
         pdX/uLjX66DSi2BqIVNJs6xQlYNPNtd+NjvFoZIyWR4HYRKJfL6hROhLcnShRXHN7eEg
         bhrR8ZoA6kWY/xFFCF4qlO3ySRBuPmddDSeUs7YZp+1P3PvoB+1wn/KCLA0AsJeHbD7j
         dTf/i0eQz6ZmRFDEzUoJEMs6UcnUYVHjHvyi0mgQfnSeVXVJX3Fk776MWYb5v8rRYnzw
         G+Ig5YPAYTdId3nwycjZ0TRSpzvY9Jtdmva5N9+4iKlDmafouJWnEM2uRWpd/PO5csb6
         tztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678406846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R96Vy3bzWe3iRlAJWoP7dbbEtRj3288SsN12+zliR+o=;
        b=Q28d0COciOQ8qfM4UAIbTyFEF2pc3kN1IisNR4PLmF8sHpiwNLjrboK6qYUn4KYyDc
         F1GNEKUivJci8RNnLnvFHhzuvdZTh7cRzvROgQ51JehaRisehXuhiThNVr8Y5kw7hooU
         r1B2q1yvTvGpz2R765O5J0ixSSfYmYPgIEMV1gSQCFfgeDcXNwa6J2F93hmBekkfynQ1
         UW6WuIprqCVGTLdW6fzouTp0lMo5NDtcyDgMunWEN9dAxwolj9E8jXQ90xdUEJU5Lci5
         +IwWH2E55rOot5/VZsV5eogceMrSLpDldfA7cZ3Hxfc73oLLuWj3P09HKkAn1abAcrxI
         Lmjg==
X-Gm-Message-State: AO0yUKWVuZEtHsu7wGM88C7PAAy1LGk9xCRZXqEsD966DMWYEU7zqT3C
        TrwRs+K9Dd8mX6T+9QBuLb7YOsMb2upJsk4hlrMakA==
X-Google-Smtp-Source: AK7set+4oVnjR4bN52kPfzdD9tmb+OgdDWIojEP8m5f9m3kD8C6EfeW1j6EnKxCzuFysYGxS9YKqfIcQq/F5fZMdtTg=
X-Received: by 2002:ab0:5619:0:b0:68b:716e:ed8a with SMTP id
 y25-20020ab05619000000b0068b716eed8amr369831uaa.0.1678406846398; Thu, 09 Mar
 2023 16:07:26 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-6-vipinsh@google.com>
 <20230309175849.0000565e@gmail.com> <CAHVum0fhU2PAQEerG5t92R1ropoh1-ML4Yv1CzwGThRtbbvWHg@mail.gmail.com>
 <ZAp0W9eH6XbWhiap@google.com>
In-Reply-To: <ZAp0W9eH6XbWhiap@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 9 Mar 2023 16:06:59 -0800
Message-ID: <CALzav=cYb1a1fNWUHvR9AoN_+KTthoJE4Gfg_gn4tz-vrAORNQ@mail.gmail.com>
Subject: Re: [Patch v4 05/18] KVM: x86/mmu: Add split_shadow_page_cache pages
 to global count of MMU cache pages
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, seanjc@google.com,
        pbonzini@redhat.com, bgardon@google.com, jmattson@google.com,
        mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Mar 9, 2023 at 4:05=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On Thu, Mar 09, 2023 at 11:59:00AM -0800, Vipin Sharma wrote:
> > On Thu, Mar 9, 2023 at 7:58=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.c=
om> wrote:
> > >
> > > On Mon,  6 Mar 2023 14:41:14 -0800
> > > Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > > Add pages in split_shadow_page_cache to the global counter
> > > > kvm_total_unused_cached_pages. These pages will be freed by MMU shr=
inker
> > > > in future commit.
> > > >
> > > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index df8dcb7e5de7..0ebb8a2eaf47 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -6149,7 +6149,9 @@ static void mmu_free_vm_memory_caches(struct =
kvm *kvm)
> > > >  {
> > > >       kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
> > > >       kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache)=
;
> > > > -     kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache)=
;
> > > > +     mutex_lock(&kvm->slots_lock);
> > > > +     mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache);
> > > > +     mutex_unlock(&kvm->slots_lock);
> > >
> > > Taking the lock of the calling path in the layer of cache topping/fre=
e layer
> > > seems off.
> > >
> > > My vote goes to have a lock for each cache and take the lock of the c=
ache when
> > > topping/free the cache. It is more self-contained and architecturally=
 nice.
> > >
> >
> > Yeah, this can be one way. However, in future patches when I am adding
> > per NUMA node cache, it will add up a lot of locks for the same code
> > path before a topup. In split huge page case we know what NUMA node we
> > need to allocate from so we can fine tune which lock to take but  in
> > fault path code we don't know what NUMA node the page will be coming
> > from so we need to topup all of the NUMA caches. Having a single lock
> > simplifies code a little bit.
> >
> > I agree with you on being more self-contained. I will wait for others
> > to also chime in on this and go from there.
>
> As a general rule, please only added locking when it's needed. Adding
> the lock in this commit is just confusing.
>
> But that aside, I don't think acquiring the slots lock is even needed in
> this commit.

Correction: even needed in the *next* commit

> mmu_free_vm_memory_caches() is never called while the the
> VM is on vm_list. i.e. This can never race with the shrinker.
>
> If you want to be paranoid you can add a WARN to ensure that stays true
> going forward:
>
>   /* ... comment ... */
>   WARN_ON_ONCE(!list_empty(&kvm->vm_list));
