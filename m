Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBC0705522
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 19:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjEPRjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 13:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEPRjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 13:39:19 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B765F6EB1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 10:39:18 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-33164ec77ccso14165ab.0
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 10:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684258758; x=1686850758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rwakRNEZg00nJzKAJVvqSW5mx9DF58xDsBOKOjXcGQA=;
        b=Ek49bn3anPQPSUmms5vWVmfuR7XlCCgjUhzxojlwroQ8vkZYmSTR9nij0U7tkcbx7M
         kdSuSp99b7kuefNb3ThsnUu+n6jLA2KjLjWtJTN1ckWqFdM7dXCqsv5HYmbOQJyFw28S
         vI30S/hDXN3LvOEgWthOWiaiK/7h5p8Av9AQM+ft28NJwU0yWvTPSaUUagyBFVzvG/Iq
         eVnyDDGUOULhf2SFffzXUXIOeabZs9SAvrJeuhdOQI2jOGfJJ0XnB6p8LTJChtpvpwKa
         m+T/MqTeGMac0ZoKEC2dlV9r1ttRUZ8bAFRYw6HJftHYGP5wuA0YPN8nE4iszhwA9jbC
         CXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684258758; x=1686850758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rwakRNEZg00nJzKAJVvqSW5mx9DF58xDsBOKOjXcGQA=;
        b=YQkbr7QaKHd6k4QpSVopRaAwNVr0UyDpb7jmpVWh9wbZ6eWJACeH2YNkWjTYTkHKOZ
         2IBr4bRjla9pmD4MJlyI5+Ytl9O2CdDPeGfz1LaQrQJY8VdxSNWuWT405SqaE8yDMalw
         LRlisS+jyztrsW3SgBOoErSjkLD0iksWaaFHl5J5IS1T5hSc0skZ1rhMLaZaH8BH0oXI
         3mru0qtkKgqfoCc8sJM/burSHOZ7duGyP1KUcK0nMHC32nFhGwZv04VHm0TJEgGJGAPP
         y/iNAK3Se6TcNkXtvwHeKAoClfkqae9EuV3dwHabEhTM/9JH4wPg2vVecK8ibrnTwqEs
         rFGw==
X-Gm-Message-State: AC+VfDw/r5H4lF6UvbWa6Azgl/Qg7SRk+mlDgOG+3j0XRoiVbFQIgkxT
        EpSFv450QT9/cisNrkT+tbtyyn1qtBEpGGayQG5H/iqA2Tfd5wecsgixqA==
X-Google-Smtp-Source: ACHHUZ6wWlpTv3IpwTR512FEiD5s98A5U3Lt0r6lTl9BzMmumqhm2ei8LXBGXvZYcIrzuW22YQrsdzk3pHp0zdiWakE=
X-Received: by 2002:a17:903:187:b0:1a6:6a2d:18f0 with SMTP id
 z7-20020a170903018700b001a66a2d18f0mr213668plg.9.1684258352254; Tue, 16 May
 2023 10:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com> <20230414172922.812640-7-rananta@google.com>
 <ZF51f5tYPjK1aCpd@linux.dev>
In-Reply-To: <ZF51f5tYPjK1aCpd@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 16 May 2023 10:32:20 -0700
Message-ID: <CAJHc60wJob+VpRN-Z3VDTH1sVHSYUxPSCpyKCrC4rFBRuCcsQA@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] KVM: arm64: Add 'skip_flush' arg to stage2_put_pte()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Fri, May 12, 2023 at 10:21=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Raghavendra,
>
> On Fri, Apr 14, 2023 at 05:29:21PM +0000, Raghavendra Rao Ananta wrote:
> > Add a 'skip_flush' argument in stage2_put_pte() to
> > control the TLB invalidations. This will be leveraged
> > by the upcoming patch to defer the individual PTE
> > invalidations until the entire walk is finished.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index b8f0dbd12f773..3f136e35feb5e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -772,7 +772,7 @@ static void stage2_make_pte(const struct kvm_pgtabl=
e_visit_ctx *ctx, kvm_pte_t n
> >  }
> >
> >  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, st=
ruct kvm_s2_mmu *mmu,
> > -                        struct kvm_pgtable_mm_ops *mm_ops)
> > +                        struct kvm_pgtable_mm_ops *mm_ops, bool skip_f=
lush)
>
> Assuming you are going to pull the cpufeature checks into this helper,
> it might me helpful to narrow the scope of it. 'stage2_put_pte()' sounds
> very generic, but it is about to have a very precise meaning in relation
> to kvm_pgtable_stage2_unmap().
>
> So maybe stage2_unmap_put_pte()? While at it, you'd want to have a
> shared helper for the deferral check:
>
Yeah, stage2_unmap_put_pte() sounds better. I'll change that.

> static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
> {
>         /* your blurb for why FWB is required too */
>         return system_supports_tlb_range() && stage2_has_fwb(pgt);
> }
>
Good idea; I can introduce the helper, now that we'll get rid of
stage2_unmap_data.skip_pte_tlbis (patch 7/7) as per your comments.
Also, since we are now making stage2_put_pte() specific to unmap, I
can also get rid of the 'skip_flush' arg and call
stage2_unmap_defer_tlb_flush() directly, or do you have a preference
for the additional arg?

Thank you.
Raghavendra
> The 'flush' part is annoying, because the exact term is an invalidation,
> but we already have that pattern in all of our TLB invalidation helpers.
>
> >  {
> >       /*
> >        * Clear the existing PTE, and perform break-before-make with
> > @@ -780,7 +780,10 @@ static void stage2_put_pte(const struct kvm_pgtabl=
e_visit_ctx *ctx, struct kvm_s
> >        */
> >       if (kvm_pte_valid(ctx->old)) {
> >               kvm_clear_pte(ctx->ptep);
> > -             kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ct=
x->level);
> > +
> > +             if (!skip_flush)
> > +                     kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> > +                                     ctx->addr, ctx->level);
> >       }
> >
> >       mm_ops->put_page(ctx->ptep);
> > @@ -1015,7 +1018,7 @@ static int stage2_unmap_walker(const struct kvm_p=
gtable_visit_ctx *ctx,
> >        * block entry and rely on the remaining portions being faulted
> >        * back lazily.
> >        */
> > -     stage2_put_pte(ctx, mmu, mm_ops);
> > +     stage2_put_pte(ctx, mmu, mm_ops, false);
> >
> >       if (need_flush && mm_ops->dcache_clean_inval_poc)
> >               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, m=
m_ops),
> > --
> > 2.40.0.634.g4ca3ef3211-goog
> >
>
> --
> Thanks,
> Oliver
