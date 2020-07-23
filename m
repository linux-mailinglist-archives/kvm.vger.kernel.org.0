Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1379622A49A
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 03:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387492AbgGWBaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 21:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733075AbgGWBaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 21:30:13 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5930C0619DC;
        Wed, 22 Jul 2020 18:30:13 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j11so3575305oiw.12;
        Wed, 22 Jul 2020 18:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YhLOcjKpCgLt9oimmCJP4UVsxMUg1CDYf6yyYw8HbJ0=;
        b=BoO4p+rFFbuFiuHh5Pqlltm6349FRazyKgxJhgbyowZV+wRbNyCkRmw+0idYJkch4j
         z1xnBYXriUkVfpcQyAfJvHS3zqO+2Nb1qdA3W+Tobh/qpKos+RN25ibIKvo2K6GYexgV
         qLl7v2jh0jiahIHPPSbf4kdLzA6iawc5p8W7SDPvGX8Lcl7iS1colNmrjjIDr33J1rjP
         1G9MtEFrMX50cYcU4KaAE6JI2ungLdDGfy/WfHBpmRvDlIJ06KDEixpyeNS6A1w2MgY4
         l+GUHqtJ7H+q0Lz+ucwx2EzI8GBWp7GdAgPxFHUwbBbr7wb8VgCzXoPySA1zLm4ZypiO
         BKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YhLOcjKpCgLt9oimmCJP4UVsxMUg1CDYf6yyYw8HbJ0=;
        b=Rk3Hm3udrpyeI9aNdwSzwhD0MJrVQ9ZUpdxd8u9TsI92+i9l9oVKqEbbRJ4NHTi5Xg
         VjTpBydmQ4LngE1eJTqIaUB1s6umG1PlDwnAC1H/VX66cJA42WXo9y4HBbSjNz0LAAXX
         R3Gj6TGWBkaUIIHDIHqI6lSk1ikxKnGE5ODNGJX9PAZ2xQAT94kCNUFKKV5ZJSd62zeH
         YU5sTEhrYfnv4Zp8Pu8ZdcaJK2tLYlGtJJ+isYx2UwHbEeSh8LoBStPzT3sZWiyoWjxi
         Rt/fWrY4GYRnuh0VetHhZrSpe2Vxlaxl+61QO9lZXKkQ94jPYxEGj5535FE8Qm3Wc9BM
         WDSw==
X-Gm-Message-State: AOAM532J0ueUrNImwgZjpShMEHITCqhyqlZM3uNmC1KLE0WSFAo6T+Bq
        Sc0drNaNXlBZFsQAvHOv78MKs/wQe4DflfQu72I=
X-Google-Smtp-Source: ABdhPJyQcxAMRL3JGmj7nO+Tmk2DdxuUkrpSYbyfcTaP3o/PkZYxVRZb84LYpTu8w+cfiAdVLskOmzZaD+midLe430o=
X-Received: by 2002:a54:4418:: with SMTP id k24mr1987878oiw.126.1595467813141;
 Wed, 22 Jul 2020 18:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-12-git-send-email-atrajeev@linux.vnet.ibm.com> <CACzsE9q-oOhABFWUWH5Jc3BuePpUSmtyrzaJt0x7iJSVpeXH0g@mail.gmail.com>
In-Reply-To: <CACzsE9q-oOhABFWUWH5Jc3BuePpUSmtyrzaJt0x7iJSVpeXH0g@mail.gmail.com>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Thu, 23 Jul 2020 11:28:46 +1000
Message-ID: <CACzsE9qyLvSQs2KFirQoTDRZZeVkirDXQumhXycYQ8Kojc8BLQ@mail.gmail.com>
Subject: Re: [v3 11/15] powerpc/perf: BHRB control to disable BHRB logic when
 not used
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Gautham R Shenoy <ego@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>, maddy@linux.vnet.ibm.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com,
        acme@kernel.org, jolsa@kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 23, 2020 at 11:26 AM Jordan Niethe <jniethe5@gmail.com> wrote:
>
> On Sat, Jul 18, 2020 at 1:26 AM Athira Rajeev
> <atrajeev@linux.vnet.ibm.com> wrote:
> >
> > PowerISA v3.1 has few updates for the Branch History Rolling Buffer(BHRB).
> >
> > BHRB disable is controlled via Monitor Mode Control Register A (MMCRA)
> > bit, namely "BHRB Recording Disable (BHRBRD)". This field controls
> > whether BHRB entries are written when BHRB recording is enabled by other
> > bits. This patch implements support for this BHRB disable bit.
> >
> > By setting 0b1 to this bit will disable the BHRB and by setting 0b0
> > to this bit will have BHRB enabled. This addresses backward
> > compatibility (for older OS), since this bit will be cleared and
> > hardware will be writing to BHRB by default.
> >
> > This patch addresses changes to set MMCRA (BHRBRD) at boot for power10
> > ( there by the core will run faster) and enable this feature only on
> > runtime ie, on explicit need from user. Also save/restore MMCRA in the
> > restore path of state-loss idle state to make sure we keep BHRB disabled
> > if it was not enabled on request at runtime.
> >
> > Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
> > ---
> >  arch/powerpc/perf/core-book3s.c       | 20 ++++++++++++++++----
> >  arch/powerpc/perf/isa207-common.c     | 12 ++++++++++++
> >  arch/powerpc/platforms/powernv/idle.c | 22 ++++++++++++++++++++--
> >  3 files changed, 48 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> > index bd125fe..31c0535 100644
> > --- a/arch/powerpc/perf/core-book3s.c
> > +++ b/arch/powerpc/perf/core-book3s.c
> > @@ -1218,7 +1218,7 @@ static void write_mmcr0(struct cpu_hw_events *cpuhw, unsigned long mmcr0)
> >  static void power_pmu_disable(struct pmu *pmu)
> >  {
> >         struct cpu_hw_events *cpuhw;
> > -       unsigned long flags, mmcr0, val;
> > +       unsigned long flags, mmcr0, val, mmcra;
> >
> >         if (!ppmu)
> >                 return;
> > @@ -1251,12 +1251,24 @@ static void power_pmu_disable(struct pmu *pmu)
> >                 mb();
> >                 isync();
> >
> > +               val = mmcra = cpuhw->mmcr.mmcra;
> > +
> >                 /*
> >                  * Disable instruction sampling if it was enabled
> >                  */
> > -               if (cpuhw->mmcr.mmcra & MMCRA_SAMPLE_ENABLE) {
> > -                       mtspr(SPRN_MMCRA,
> > -                             cpuhw->mmcr.mmcra & ~MMCRA_SAMPLE_ENABLE);
> > +               if (cpuhw->mmcr.mmcra & MMCRA_SAMPLE_ENABLE)
> > +                       val &= ~MMCRA_SAMPLE_ENABLE;
> > +
> > +               /* Disable BHRB via mmcra (BHRBRD) for p10 */
> > +               if (ppmu->flags & PPMU_ARCH_310S)
> > +                       val |= MMCRA_BHRB_DISABLE;
> > +
> > +               /*
> > +                * Write SPRN_MMCRA if mmcra has either disabled
> > +                * instruction sampling or BHRB.
> > +                */
> > +               if (val != mmcra) {
> > +                       mtspr(SPRN_MMCRA, mmcra);
> >                         mb();
> >                         isync();
> >                 }
> > diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
> > index 77643f3..964437a 100644
> > --- a/arch/powerpc/perf/isa207-common.c
> > +++ b/arch/powerpc/perf/isa207-common.c
> > @@ -404,6 +404,13 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
> >
> >         mmcra = mmcr1 = mmcr2 = mmcr3 = 0;
> >
> > +       /*
> > +        * Disable bhrb unless explicitly requested
> > +        * by setting MMCRA (BHRBRD) bit.
> > +        */
> > +       if (cpu_has_feature(CPU_FTR_ARCH_31))
> > +               mmcra |= MMCRA_BHRB_DISABLE;
> > +
> >         /* Second pass: assign PMCs, set all MMCR1 fields */
> >         for (i = 0; i < n_ev; ++i) {
> >                 pmc     = (event[i] >> EVENT_PMC_SHIFT) & EVENT_PMC_MASK;
> > @@ -479,6 +486,11 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
> >                         mmcra |= val << MMCRA_IFM_SHIFT;
> >                 }
> >
> > +               /* set MMCRA (BHRBRD) to 0 if there is user request for BHRB */
> > +               if (cpu_has_feature(CPU_FTR_ARCH_31) &&
> > +                               (has_branch_stack(pevents[i]) || (event[i] & EVENT_WANTS_BHRB)))
> > +                       mmcra &= ~MMCRA_BHRB_DISABLE;
> > +
> >                 if (pevents[i]->attr.exclude_user)
> >                         mmcr2 |= MMCR2_FCP(pmc);
> >
> > diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
> > index 2dd4673..1c9d0a9 100644
> > --- a/arch/powerpc/platforms/powernv/idle.c
> > +++ b/arch/powerpc/platforms/powernv/idle.c
> > @@ -611,6 +611,7 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
> >         unsigned long srr1;
> >         unsigned long pls;
> >         unsigned long mmcr0 = 0;
> > +       unsigned long mmcra = 0;
> >         struct p9_sprs sprs = {}; /* avoid false used-uninitialised */
> >         bool sprs_saved = false;
> >
> > @@ -657,6 +658,21 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
> >                   */
> >                 mmcr0           = mfspr(SPRN_MMCR0);
> >         }
> > +
> > +       if (cpu_has_feature(CPU_FTR_ARCH_31)) {
> > +               /*
> > +                * POWER10 uses MMCRA (BHRBRD) as BHRB disable bit.
> > +                * If the user hasn't asked for the BHRB to be
> > +                * written, the value of MMCRA[BHRBRD] is 1.
> > +                * On wakeup from stop, MMCRA[BHRBD] will be 0,
> > +                * since it is previleged resource and will be lost.
> > +                * Thus, if we do not save and restore the MMCRA[BHRBD],
> > +                * hardware will be needlessly writing to the BHRB
> > +                * in problem mode.
> > +                */
> > +               mmcra           = mfspr(SPRN_MMCRA);
> If the only thing that needs to happen is set MMCRA[BHRBRD], why save the MMCRA?
> > +       }
> > +
> >         if ((psscr & PSSCR_RL_MASK) >= pnv_first_spr_loss_level) {
> >                 sprs.lpcr       = mfspr(SPRN_LPCR);
> >                 sprs.hfscr      = mfspr(SPRN_HFSCR);
> > @@ -700,8 +716,6 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
> >         WARN_ON_ONCE(mfmsr() & (MSR_IR|MSR_DR));
> >
> >         if ((srr1 & SRR1_WAKESTATE) != SRR1_WS_NOLOSS) {
> > -               unsigned long mmcra;
> > -
> >                 /*
> >                  * We don't need an isync after the mtsprs here because the
> >                  * upcoming mtmsrd is execution synchronizing.
> > @@ -721,6 +735,10 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
> >                         mtspr(SPRN_MMCR0, mmcr0);
> >                 }
> >
> > +               /* Reload MMCRA to restore BHRB disable bit for POWER10 */
> > +               if (cpu_has_feature(CPU_FTR_ARCH_31))
> > +                       mtspr(SPRN_MMCRA, mmcra);
> > +
> >                 /*
> >                  * DD2.2 and earlier need to set then clear bit 60 in MMCRA
> >                  * to ensure the PMU starts running.
> Just below here we have:
>         mmcra = mfspr(SPRN_MMCRA);
>         mmcra |= PPC_BIT(60);
>         mtspr(SPRN_MMCRA, mmcra);
>         mmcra &= ~PPC_BIT(60);
>         mtspr(SPRN_MMCRA, mmcra);
> It seems MMCRA[BHRBRD] could just be OR'd in someway similar to this
> for ISA v3.1?
Oh wait the user could have cleared it, just ignore me.
> > --
> > 1.8.3.1
> >
