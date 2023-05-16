Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99F67054E5
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 19:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjEPRVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 13:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjEPRVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 13:21:53 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8B1E7A
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 10:21:45 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-335a61eb904so13035ab.0
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 10:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684257705; x=1686849705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVZ+9c6lPsr2Ao0MCG6loW9XjO0wPrRtUbpRQdctJK8=;
        b=V20gW+9L8/ycr7z7MDOazESc5AWPQ6RaLNAU1aDp3gfWGjsTlqyb+MOGJspMnYhrzV
         ScNhoWkwm/CYep76EmK9b6+uQhuv4UzFHTo8iI1l6ODk5Lhb/+wCt5Yco6qwZDZh7ioT
         a7am0Lrk/vP105gUHlugDOVJSELWJ3whi/YmC+qBm3zfc5wFKO2hTUrBymF8rfsBFAue
         DDpMu2gB6x20PZhX+z0pixo0INU7xfSjzx7GnUdutGnIJOzRShVnCsz0dM/Vja2h3alB
         3jMNtlPhTQTcOYfneJRQRVXF6yQPGblwP5erwuJ63dJnwqq9eCpbNF1J/VyOBsBuNGoZ
         4hkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684257705; x=1686849705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GVZ+9c6lPsr2Ao0MCG6loW9XjO0wPrRtUbpRQdctJK8=;
        b=AO2klsFZctlgsqVVbmbJHa3UBH1tMwILnO1J5S0LjGP185HLNxlPfVstBsNRwrjFbW
         Et/lcaYbMEMsE/gfpxNZF1+nenbYOs4fmJVSVl96vNHEf6JMjtv/rURS2/HXfq9xVC+3
         gs3PBdj9CTC/IyP58TejDi7fplplqfWzdNpRXSSdoL1YpV0IX6WQv6jwpGWJRqMBrrG9
         xmmRZTuKCrU4+Hm7CQuOuf/ftq+YLInK4+mKG8wNMX8xKbHLkkl9fdECzmrPNNwProJE
         38nDD7Mh4PlowYjEh3Co9k6o/eLMXKlM1hvKBrO0rg8y5R7urPvhcgi2NbxywXhtRBP/
         3WZw==
X-Gm-Message-State: AC+VfDy4bAtSKz1PqX2fJqByMXKzcC/AvYPdtlmeNjRX7K++2+Z41/JN
        1C9Aa0YqKKnh23H7HLlMn1a121FNFO0Z7aCXJ/4Ojw==
X-Google-Smtp-Source: ACHHUZ6BL2PMIcSJjwAf2AgEJNcVVxzbOdam3StqauutqGNlV5v/nj8Tk0EG41bRNqE6I54B8OY65aevOf4qC52Evtg=
X-Received: by 2002:a05:6e02:1a0d:b0:32a:db6c:d51d with SMTP id
 s13-20020a056e021a0d00b0032adb6cd51dmr325280ild.12.1684257704853; Tue, 16 May
 2023 10:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com> <20230414172922.812640-8-rananta@google.com>
 <ZF5xLrr2tEYdLL1i@linux.dev>
In-Reply-To: <ZF5xLrr2tEYdLL1i@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 16 May 2023 10:21:33 -0700
Message-ID: <CAJHc60wUu3xB4J8oJ+FCxerDad1TzZLCMgHYGFfv0K-hzC0qmw@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] KVM: arm64: Use TLBI range-based intructions for unmap
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

On Fri, May 12, 2023 at 10:02=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Raghavendra,
>
> On Fri, Apr 14, 2023 at 05:29:22PM +0000, Raghavendra Rao Ananta wrote:
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
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 33 +++++++++++++++++++++++++++++----
> >  1 file changed, 29 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 3f136e35feb5e..bcb748e3566c7 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -987,10 +987,16 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtab=
le *pgt, u64 addr, u64 size,
> >       return ret;
> >  }
> >
> > +struct stage2_unmap_data {
> > +     struct kvm_pgtable *pgt;
> > +     bool skip_pte_tlbis;
> > +};
> > +
> >  static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx=
,
> >                              enum kvm_pgtable_walk_flags visit)
> >  {
> > -     struct kvm_pgtable *pgt =3D ctx->arg;
> > +     struct stage2_unmap_data *unmap_data =3D ctx->arg;
> > +     struct kvm_pgtable *pgt =3D unmap_data->pgt;
> >       struct kvm_s2_mmu *mmu =3D pgt->mmu;
> >       struct kvm_pgtable_mm_ops *mm_ops =3D ctx->mm_ops;
> >       kvm_pte_t *childp =3D NULL;
> > @@ -1018,7 +1024,7 @@ static int stage2_unmap_walker(const struct kvm_p=
gtable_visit_ctx *ctx,
> >        * block entry and rely on the remaining portions being faulted
> >        * back lazily.
> >        */
> > -     stage2_put_pte(ctx, mmu, mm_ops, false);
> > +     stage2_put_pte(ctx, mmu, mm_ops, unmap_data->skip_pte_tlbis);
> >
> >       if (need_flush && mm_ops->dcache_clean_inval_poc)
> >               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, m=
m_ops),
> > @@ -1032,13 +1038,32 @@ static int stage2_unmap_walker(const struct kvm=
_pgtable_visit_ctx *ctx,
> >
> >  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 si=
ze)
> >  {
> > +     int ret;
> > +     struct stage2_unmap_data unmap_data =3D {
> > +             .pgt =3D pgt,
> > +             /*
> > +              * If FEAT_TLBIRANGE is implemented, defer the individial=
 PTE
> > +              * TLB invalidations until the entire walk is finished, a=
nd
> > +              * then use the range-based TLBI instructions to do the
> > +              * invalidations. Condition this upon S2FWB in order to a=
void
> > +              * a page-table walk again to perform the CMOs after TLBI=
.
> > +              */
> > +             .skip_pte_tlbis =3D system_supports_tlb_range() &&
> > +                                     stage2_has_fwb(pgt),
>
> Why can't the underlying walker just call these two helpers directly?
> There are static keys behind these...
>
I wasn't aware of that. Although, I tried to look into the
definitions, but couldn't understand how static keys are at play here.
By any chance are you referring to the alternative_has_feature_*()
implementations when checking for cpu capabilities?

Thank you.
Raghavendra

> > +     };
> >       struct kvm_pgtable_walker walker =3D {
> >               .cb     =3D stage2_unmap_walker,
> > -             .arg    =3D pgt,
> > +             .arg    =3D &unmap_data,
> >               .flags  =3D KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABL=
E_POST,
> >       };
> >
> > -     return kvm_pgtable_walk(pgt, addr, size, &walker);
> > +     ret =3D kvm_pgtable_walk(pgt, addr, size, &walker);
> > +     if (unmap_data.skip_pte_tlbis)
> > +             /* Perform the deferred TLB invalidations */
> > +             kvm_call_hyp(__kvm_tlb_flush_vmid_range, pgt->mmu,
> > +                             addr, addr + size);
> > +
> > +     return ret;
> >  }
> >
> >  struct stage2_attr_data {
> > --
> > 2.40.0.634.g4ca3ef3211-goog
> >
>
> --
> Thanks,
> Oliver
