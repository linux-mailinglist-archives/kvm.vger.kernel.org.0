Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D418576DB9C
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjHBXeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjHBXeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:34:03 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E335530C0
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:34:00 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bc0308d1e2so68625ad.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 16:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691019240; x=1691624040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vc6C3YLRbpQi2AL32H49CSJKRRKMAivDlEx5K2+EnSw=;
        b=xf/IJNr/83ysKxnLoIpURXqtW5k4S78Gh5tHb3m0g2cM656O5cPNqbgVhIX2RxNi81
         rwN3s+1UASkz3bkOQsKt/jfKJPUdzGRFa2ffYFtxNksgXsGw9O+9OKdHnIY5qvM4LBWh
         SO1LP5+sgpcVIpZxoTkUG2YUN21gRCZKcROF8+jYm9Oz49kUtlbb/rvbWBZj7GBNX8w0
         4wDDyENbZdXj4phELOLafcq19/Iy+WmF5GW/WIxs4naY1ZHw9AH8dTs/Xqsb0FZL+KGI
         5+YVJJNiMt5dFlAPlHT/6ZhE+J9D0mljI4Zs6eq8RwKcYhSzORWMDh2dDSPiSsB1zI2l
         W0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691019240; x=1691624040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vc6C3YLRbpQi2AL32H49CSJKRRKMAivDlEx5K2+EnSw=;
        b=faoWhfvy86YtCHUFfkSDTxdEkNzRsKT7jBqmYUa9UZI3glAEHerLimHVFW/W3QAUFL
         yGJ2i+6bxFhiUFPsn5j/33PPkH/vGXig+srpude2/bRCfXhI6ZeH/YgTDpu3N5Dt+ACA
         NpIfMw6RwaCzsII7xOzS9Z/AHwDg1gHsQOzsqX2ycRt9c3eCKqpZng843ccr2ZxMhsA0
         fJ9c3v3JsX8WFwbsGmLEhxHsWYW+oym8muQGgbfdYyH9duLdvnMa/WxB9I+tdYQFnPnT
         kSFIANyqWoAF8skjZFOVAVA28nXtp9rQT9V+iNdQaUoFOk0rxbFm1o8SP6y/TO46wAPf
         qqrw==
X-Gm-Message-State: AOJu0Yw6oczGpVPI3mwqGDgB7HRCQ31+4Knjmr/2EvN5vOG753K57u0G
        MZ/slA1sr9bZQWtUsv7islyeQiTjkWCjlgtUuexT3w==
X-Google-Smtp-Source: AGHT+IHW4A1mLYKXPi0AX+HzRbUtlH1BLHQ/AL7bLTbxnxnSwM+iSVI/MQBnIBN/qF4PUit3MoTRa1yu+rP1rkdZcH0=
X-Received: by 2002:a17:903:5ce:b0:1bc:3321:4105 with SMTP id
 kf14-20020a17090305ce00b001bc33214105mr289379plb.2.1691019240198; Wed, 02 Aug
 2023 16:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-13-rananta@google.com>
 <87jzulqz0v.wl-maz@kernel.org> <CAJHc60zGzAqWw2iZwNEG_bWERXkz_io7ae-K_tf_kh6xcOBxLA@mail.gmail.com>
 <86fs5158j7.wl-maz@kernel.org>
In-Reply-To: <86fs5158j7.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 2 Aug 2023 16:33:48 -0700
Message-ID: <CAJHc60ww4X89SU+ttddjZUjOFS+D_s9Z+2xE1WaVCR-w7hEF9g@mail.gmail.com>
Subject: Re: [PATCH v7 12/12] KVM: arm64: Use TLBI range-based intructions for unmap
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 2, 2023 at 4:28=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 31 Jul 2023 19:26:09 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > On Thu, Jul 27, 2023 at 6:12=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Sat, 22 Jul 2023 03:22:51 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > The current implementation of the stage-2 unmap walker traverses
> > > > the given range and, as a part of break-before-make, performs
> > > > TLB invalidations with a DSB for every PTE. A multitude of this
> > > > combination could cause a performance bottleneck on some systems.
> > > >
> > > > Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
> > > > invalidations until the entire walk is finished, and then
> > > > use range-based instructions to invalidate the TLBs in one go.
> > > > Condition deferred TLB invalidation on the system supporting FWB,
> > > > as the optimization is entirely pointless when the unmap walker
> > > > needs to perform CMOs.
> > > >
> > > > Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
> > > > now serves the stage-2 unmap walker specifically, rather than
> > > > acting generic.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/pgtable.c | 67 +++++++++++++++++++++++++++++++-=
----
> > > >  1 file changed, 58 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgta=
ble.c
> > > > index 5ef098af1736..cf88933a2ea0 100644
> > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > @@ -831,16 +831,54 @@ static void stage2_make_pte(const struct kvm_=
pgtable_visit_ctx *ctx, kvm_pte_t n
> > > >       smp_store_release(ctx->ptep, new);
> > > >  }
> > > >
> > > > -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx=
, struct kvm_s2_mmu *mmu,
> > > > -                        struct kvm_pgtable_mm_ops *mm_ops)
> > > > +struct stage2_unmap_data {
> > > > +     struct kvm_pgtable *pgt;
> > > > +     bool defer_tlb_flush_init;
> > > > +};
> > > > +
> > > > +static bool __stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt=
)
> > > > +{
> > > > +     /*
> > > > +      * If FEAT_TLBIRANGE is implemented, defer the individual
> > > > +      * TLB invalidations until the entire walk is finished, and
> > > > +      * then use the range-based TLBI instructions to do the
> > > > +      * invalidations. Condition deferred TLB invalidation on the
> > > > +      * system supporting FWB, as the optimization is entirely
> > > > +      * pointless when the unmap walker needs to perform CMOs.
> > > > +      */
> > > > +     return system_supports_tlb_range() && stage2_has_fwb(pgt);
> > > > +}
> > > > +
> > > > +static bool stage2_unmap_defer_tlb_flush(struct stage2_unmap_data =
*unmap_data)
> > > > +{
> > > > +     bool defer_tlb_flush =3D __stage2_unmap_defer_tlb_flush(unmap=
_data->pgt);
> > > > +
> > > > +     /*
> > > > +      * Since __stage2_unmap_defer_tlb_flush() is based on alterna=
tive
> > > > +      * patching and the TLBIs' operations behavior depend on this=
,
> > > > +      * track if there's any change in the state during the unmap =
sequence.
> > > > +      */
> > > > +     WARN_ON(unmap_data->defer_tlb_flush_init !=3D defer_tlb_flush=
);
> > > > +     return defer_tlb_flush;
> > >
> > > I really don't understand what you're testing here. The ability to
> > > defer TLB invalidation is a function of the system capabilities
> > > (range+FWB) and a single flag that is only set on the host for pKVM.
> > >
> > > How could that change in the middle of the life of the system? if
> > > further begs the question about the need for the unmap_data data
> > > structure.
> > >
> > > It looks to me that we could simply pass the pgt pointer around and b=
e
> > > done with it. Am I missing something obvious?
> > >
> > From one of the previous comments [1] (used in a different context),
> > I'm given to understand that since these feature checks are governed
> > by alternative patching, they can potentially change (at runtime?). Is
> > that not the case and I have misunderstood the idea in comment [1]
> > entirely? Is it solely used for optimization purposes and set only
> > once?
>
> Alternative patching, just like the static branches used to implement
> the capability stuff, is a one way street. At the point where KVM is
> initialised, these configurations are set in stone, and there is no
> going back.
>
Understood.
> > If that's the case, I can get rid of the WARN_ON() and unmap_data.
>
> yes, please.
>
Sure, I'll get rid of the WARN_ON and 'struct stage2_unmap_data' in v8.

Thanks,
Raghavendra
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
