Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A826716FCF
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 23:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjE3VgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 17:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjE3VgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 17:36:11 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7455FC7
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 14:36:09 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-33baee0235cso22905ab.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 14:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685482569; x=1688074569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ewkLPgc14ELbXHOwD+0DDe9cJ9eyhGp9sBwFGmnJByA=;
        b=OZBj5K1PJzJq7ysGaWohPD3MWFE3CYtFPYIUSyE/WsUc4uD7FgNgku0xspOed1pXA8
         bPfgeyybhTt4zAwKD6UOJaGYfhIseE0exPCyHQq2g95hYsXmkdGga6av3EMVZslCOjvm
         n8xtN4qGcX9z4OFguGscfFpNPt7ZZtuniT0qfzYFPu4f/HaIXaTx73xJ6DbnN1Fvq2Tv
         z0Tdr+GMEmSSmveJB/xI/Y6oCdtQSEo7wq/d9a3GdKOyXOR1BgMivYo/pKj3EXJKMAbk
         8TIJ5/l0zTI+LmttQ2gdXcFgkeLIpLX3o6h4w2AV0jp3RyvB0PEkkLrqusv3O/KpcwhX
         GVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685482569; x=1688074569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ewkLPgc14ELbXHOwD+0DDe9cJ9eyhGp9sBwFGmnJByA=;
        b=SY4xLfKjnuhaOjsgOkrmuVyCajbh3jHG7aSDIoQjzplox2TMe8SANjIafVx0+OaEk/
         SNP1KO+gpVn0kQJSfg75xRS0U3OEkqF9ioWddYr/vBDDA7ExIfsRoWgHH/ROhI0sydah
         kBd0+TNUG0P0P8wjdxW/4xzRVLDPzX418ZBu3un1xGP2lAR/UGe9pMaMBPw1Tf+5wMNZ
         Spocgx62OVoZ/Uxh4pGBpz1TGTSFTPMK8mSvKmZDTbZYSN4W15ATGfVE5UW/8okSYSnp
         2GUy8Yw8zHnr9GTMALZo0ZKQwgJTXaiL/PjGpyDChnNlzWuJ6buw6o0oRogAB9YvISM/
         XKXw==
X-Gm-Message-State: AC+VfDx7jdRVRu+hgTDucz7S2+7FdSrG3VTYOFxllAaeZMWxqL9fT19w
        JZPnckt18W15Y6v89dg9Xq1bXkSmwKsaHJegBYKUE4kCabEBAURzNTG9YA==
X-Google-Smtp-Source: ACHHUZ5Q8wOp3L3qRzQPnewVTnLz0MKHVYAyPyQm/rQZ68d3qLP6Wf9ulIw98RnwKFjSLug+l1YwvGCMH4ys6tKBt8s=
X-Received: by 2002:a05:6e02:1bab:b0:33b:61f8:5ae5 with SMTP id
 n11-20020a056e021bab00b0033b61f85ae5mr26739ili.15.1685482568731; Tue, 30 May
 2023 14:36:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com> <20230519005231.3027912-7-rananta@google.com>
 <87ttvvjk5q.wl-maz@kernel.org>
In-Reply-To: <87ttvvjk5q.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 30 May 2023 14:35:57 -0700
Message-ID: <CAJHc60xiiQ8t73wTodZAcyBJomLMAwN_ycMLbjWPyiu8-j4GTA@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] KVM: arm64: Use TLBI range-based intructions for unmap
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 29, 2023 at 7:18=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 19 May 2023 01:52:31 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > The current implementation of the stage-2 unmap walker traverses
> > the given range and, as a part of break-before-make, performs
> > TLB invalidations with a DSB for every PTE. A multitude of this
> > combination could cause a performance bottleneck.
> >
> > Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
> > invalidations until the entire walk is finished, and then
> > use range-based instructions to invalidate the TLBs in one go.
> > Condition this upon S2FWB in order to avoid walking the page-table
> > again to perform the CMOs after issuing the TLBI.
>
> But that's the real bottleneck. TLBIs are cheap compared to CMOs, even
> on remarkably bad implementations. What is your plan to fix this?
>
Correct me if I'm wrong, but my understanding was that a multiple
issuance of TLBI + DSB was the bottleneck, and this patch tries to
avoid this by issuing only one TLBI + DSB at the end.
> >
> > Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
> > now serves the stage-2 unmap walker specifically, rather than
> > acting generic.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 35 ++++++++++++++++++++++++++++++-----
> >  1 file changed, 30 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index b8f0dbd12f773..5832ee3418fb0 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -771,16 +771,34 @@ static void stage2_make_pte(const struct kvm_pgta=
ble_visit_ctx *ctx, kvm_pte_t n
> >       smp_store_release(ctx->ptep, new);
> >  }
> >
> > -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, st=
ruct kvm_s2_mmu *mmu,
> > -                        struct kvm_pgtable_mm_ops *mm_ops)
> > +static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
> >  {
> > +     /*
> > +      * If FEAT_TLBIRANGE is implemented, defer the individial PTE
> > +      * TLB invalidations until the entire walk is finished, and
> > +      * then use the range-based TLBI instructions to do the
> > +      * invalidations. Condition this upon S2FWB in order to avoid
> > +      * a page-table walk again to perform the CMOs after TLBI.
> > +      */
> > +     return system_supports_tlb_range() && stage2_has_fwb(pgt);
> > +}
> > +
> > +static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *c=
tx,
> > +                             struct kvm_s2_mmu *mmu,
> > +                             struct kvm_pgtable_mm_ops *mm_ops)
> > +{
> > +     struct kvm_pgtable *pgt =3D ctx->arg;
> > +
> >       /*
> >        * Clear the existing PTE, and perform break-before-make with
> >        * TLB maintenance if it was valid.
> >        */
> >       if (kvm_pte_valid(ctx->old)) {
> >               kvm_clear_pte(ctx->ptep);
> > -             kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ct=
x->level);
> > +
> > +             if (!stage2_unmap_defer_tlb_flush(pgt))
> > +                     kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> > +                                     ctx->addr, ctx->level);
>
> This really doesn't match the comment anymore.
>
Right, I can re-write this in the next spin.

> Overall, I'm very concerned that we lose the consistency property that
> the current code has: once called, the TLBs and the page tables are
> synchronised.
>
> Yes, this patch looks correct. But it is also really fragile.
>
Yeah, we were a little skeptical about this too. Till v2, we had a
different implementation in which we had an independent fast unmap
path that disconnects the PTE hierarchy if the unmap range was exactly
KVM_PGTABLE_MIN_BLOCK_LEVEL [1].  But this had some problems, and we
pivoted to the current implementation.

> >       }
> >
> >       mm_ops->put_page(ctx->ptep);
> > @@ -1015,7 +1033,7 @@ static int stage2_unmap_walker(const struct kvm_p=
gtable_visit_ctx *ctx,
> >        * block entry and rely on the remaining portions being faulted
> >        * back lazily.
> >        */
> > -     stage2_put_pte(ctx, mmu, mm_ops);
> > +     stage2_unmap_put_pte(ctx, mmu, mm_ops);
> >
> >       if (need_flush && mm_ops->dcache_clean_inval_poc)
> >               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, m=
m_ops),
> > @@ -1029,13 +1047,20 @@ static int stage2_unmap_walker(const struct kvm=
_pgtable_visit_ctx *ctx,
> >
> >  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 si=
ze)
> >  {
> > +     int ret;
> >       struct kvm_pgtable_walker walker =3D {
> >               .cb     =3D stage2_unmap_walker,
> >               .arg    =3D pgt,
> >               .flags  =3D KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABL=
E_POST,
> >       };
> >
> > -     return kvm_pgtable_walk(pgt, addr, size, &walker);
> > +     ret =3D kvm_pgtable_walk(pgt, addr, size, &walker);
> > +     if (stage2_unmap_defer_tlb_flush(pgt))
> > +             /* Perform the deferred TLB invalidations */
> > +             kvm_call_hyp(__kvm_tlb_flush_vmid_range, pgt->mmu,
> > +                             addr, addr + size);
>
> This "kvm_call_hyp(__kvm_tlb_flush_vmid_range,...)" could do with a
> wrapper from the point where you introduce it.
>
Sorry, I didn't get this comment. Do you mind elaborating on it?

Thank you.
Raghavendra

[1]: https://lore.kernel.org/all/20230206172340.2639971-8-rananta@google.co=
m/
> > +
> > +     return ret;
> >  }
> >
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
