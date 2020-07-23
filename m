Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983E922A48E
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 03:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbgGWB1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 21:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWB1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 21:27:45 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747F1C0619DC;
        Wed, 22 Jul 2020 18:27:45 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id e4so3619519oib.1;
        Wed, 22 Jul 2020 18:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bJRM6LHxT+4yC6REoomd3KFOX0i3jFe3XKP9/cvKJRo=;
        b=bIrg7ZzLW8UCZSmsuMqSfbrfaQ9KgCB6lrQ/r/Xc9kkck5wcqPOolPl3Yi8JW5gYaO
         3Vkv5SXyUMxCkkGRxA6qEthqOH5f1k2SrY6guKsOxMW/nGNftTwoYfofjMoTHEe0OwLD
         50BB4gYEYEvv+VC9br7Eox2FNW33q4aiycrq7fbGdFhDPhD1u9WyPjzFD77DUiS6aqf+
         83s0REwY64/1R+8nzB4ZB/Hi6g8dDrXHInGM0cXYDsgwwr97Dr3p8U9x4xGWcrjdr7zh
         fBiuvpFE/IbDCmKpcdBhfKQG4I1l6ySos0L1ZsnzpBNg6Y1Zvscxq+SlYsEiATNEyB6A
         ycVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bJRM6LHxT+4yC6REoomd3KFOX0i3jFe3XKP9/cvKJRo=;
        b=gZION9jhkx/O+jB5XMLCTRA0knazndSl13SX/cw3Hgw+8YYo0oZZZack+wgAZKiHK/
         UcGEXajNWp3lJXEvkOqLPA+0IrLFKy0gaYE4ctjWHD28YI1cTzW3EiK+utnJC5UdHQ8/
         qD9V9PGx7sJHdMNs/yMeSIYgvGSF6o6JwIbOEkQBVmJqmHjjaNzTfJ4ann4EW+6spCYw
         UY8KlXUPPQWRG+De413LKA8e2u1r6ZSoAamT/8TFKVqwaCdUrpK6fQj6UDvCre/+TMQe
         yJuKmuQ6IjCkVlzHZgqvItvJt74Xxw/6nZrTgtwlvdovvmJLn68uFQn/Vao/XIHjP7mD
         kwew==
X-Gm-Message-State: AOAM530uyMkN/JeFSt+6tZYdonX5Wz+eEUQyCToV32/HGuV5Y8c5uHFn
        fcPsQ2vIDJwewIJh+ddc+h8mwXuX2S1/1jn+kbo=
X-Google-Smtp-Source: ABdhPJy/EF46qiLohUlhXLo4BTs9HiA/V8GjJrHrkSQlnAXYXuvo8Jg0t76Qc5uSAt6Pv+DlHrtxL3arw+FS/VvZ/i8=
X-Received: by 2002:aca:c690:: with SMTP id w138mr2022882oif.12.1595467664619;
 Wed, 22 Jul 2020 18:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com> <1594996707-3727-12-git-send-email-atrajeev@linux.vnet.ibm.com>
In-Reply-To: <1594996707-3727-12-git-send-email-atrajeev@linux.vnet.ibm.com>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Thu, 23 Jul 2020 11:26:19 +1000
Message-ID: <CACzsE9q-oOhABFWUWH5Jc3BuePpUSmtyrzaJt0x7iJSVpeXH0g@mail.gmail.com>
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

On Sat, Jul 18, 2020 at 1:26 AM Athira Rajeev
<atrajeev@linux.vnet.ibm.com> wrote:
>
> PowerISA v3.1 has few updates for the Branch History Rolling Buffer(BHRB).
>
> BHRB disable is controlled via Monitor Mode Control Register A (MMCRA)
> bit, namely "BHRB Recording Disable (BHRBRD)". This field controls
> whether BHRB entries are written when BHRB recording is enabled by other
> bits. This patch implements support for this BHRB disable bit.
>
> By setting 0b1 to this bit will disable the BHRB and by setting 0b0
> to this bit will have BHRB enabled. This addresses backward
> compatibility (for older OS), since this bit will be cleared and
> hardware will be writing to BHRB by default.
>
> This patch addresses changes to set MMCRA (BHRBRD) at boot for power10
> ( there by the core will run faster) and enable this feature only on
> runtime ie, on explicit need from user. Also save/restore MMCRA in the
> restore path of state-loss idle state to make sure we keep BHRB disabled
> if it was not enabled on request at runtime.
>
> Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
> ---
>  arch/powerpc/perf/core-book3s.c       | 20 ++++++++++++++++----
>  arch/powerpc/perf/isa207-common.c     | 12 ++++++++++++
>  arch/powerpc/platforms/powernv/idle.c | 22 ++++++++++++++++++++--
>  3 files changed, 48 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> index bd125fe..31c0535 100644
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -1218,7 +1218,7 @@ static void write_mmcr0(struct cpu_hw_events *cpuhw, unsigned long mmcr0)
>  static void power_pmu_disable(struct pmu *pmu)
>  {
>         struct cpu_hw_events *cpuhw;
> -       unsigned long flags, mmcr0, val;
> +       unsigned long flags, mmcr0, val, mmcra;
>
>         if (!ppmu)
>                 return;
> @@ -1251,12 +1251,24 @@ static void power_pmu_disable(struct pmu *pmu)
>                 mb();
>                 isync();
>
> +               val = mmcra = cpuhw->mmcr.mmcra;
> +
>                 /*
>                  * Disable instruction sampling if it was enabled
>                  */
> -               if (cpuhw->mmcr.mmcra & MMCRA_SAMPLE_ENABLE) {
> -                       mtspr(SPRN_MMCRA,
> -                             cpuhw->mmcr.mmcra & ~MMCRA_SAMPLE_ENABLE);
> +               if (cpuhw->mmcr.mmcra & MMCRA_SAMPLE_ENABLE)
> +                       val &= ~MMCRA_SAMPLE_ENABLE;
> +
> +               /* Disable BHRB via mmcra (BHRBRD) for p10 */
> +               if (ppmu->flags & PPMU_ARCH_310S)
> +                       val |= MMCRA_BHRB_DISABLE;
> +
> +               /*
> +                * Write SPRN_MMCRA if mmcra has either disabled
> +                * instruction sampling or BHRB.
> +                */
> +               if (val != mmcra) {
> +                       mtspr(SPRN_MMCRA, mmcra);
>                         mb();
>                         isync();
>                 }
> diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
> index 77643f3..964437a 100644
> --- a/arch/powerpc/perf/isa207-common.c
> +++ b/arch/powerpc/perf/isa207-common.c
> @@ -404,6 +404,13 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
>
>         mmcra = mmcr1 = mmcr2 = mmcr3 = 0;
>
> +       /*
> +        * Disable bhrb unless explicitly requested
> +        * by setting MMCRA (BHRBRD) bit.
> +        */
> +       if (cpu_has_feature(CPU_FTR_ARCH_31))
> +               mmcra |= MMCRA_BHRB_DISABLE;
> +
>         /* Second pass: assign PMCs, set all MMCR1 fields */
>         for (i = 0; i < n_ev; ++i) {
>                 pmc     = (event[i] >> EVENT_PMC_SHIFT) & EVENT_PMC_MASK;
> @@ -479,6 +486,11 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
>                         mmcra |= val << MMCRA_IFM_SHIFT;
>                 }
>
> +               /* set MMCRA (BHRBRD) to 0 if there is user request for BHRB */
> +               if (cpu_has_feature(CPU_FTR_ARCH_31) &&
> +                               (has_branch_stack(pevents[i]) || (event[i] & EVENT_WANTS_BHRB)))
> +                       mmcra &= ~MMCRA_BHRB_DISABLE;
> +
>                 if (pevents[i]->attr.exclude_user)
>                         mmcr2 |= MMCR2_FCP(pmc);
>
> diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
> index 2dd4673..1c9d0a9 100644
> --- a/arch/powerpc/platforms/powernv/idle.c
> +++ b/arch/powerpc/platforms/powernv/idle.c
> @@ -611,6 +611,7 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
>         unsigned long srr1;
>         unsigned long pls;
>         unsigned long mmcr0 = 0;
> +       unsigned long mmcra = 0;
>         struct p9_sprs sprs = {}; /* avoid false used-uninitialised */
>         bool sprs_saved = false;
>
> @@ -657,6 +658,21 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
>                   */
>                 mmcr0           = mfspr(SPRN_MMCR0);
>         }
> +
> +       if (cpu_has_feature(CPU_FTR_ARCH_31)) {
> +               /*
> +                * POWER10 uses MMCRA (BHRBRD) as BHRB disable bit.
> +                * If the user hasn't asked for the BHRB to be
> +                * written, the value of MMCRA[BHRBRD] is 1.
> +                * On wakeup from stop, MMCRA[BHRBD] will be 0,
> +                * since it is previleged resource and will be lost.
> +                * Thus, if we do not save and restore the MMCRA[BHRBD],
> +                * hardware will be needlessly writing to the BHRB
> +                * in problem mode.
> +                */
> +               mmcra           = mfspr(SPRN_MMCRA);
If the only thing that needs to happen is set MMCRA[BHRBRD], why save the MMCRA?
> +       }
> +
>         if ((psscr & PSSCR_RL_MASK) >= pnv_first_spr_loss_level) {
>                 sprs.lpcr       = mfspr(SPRN_LPCR);
>                 sprs.hfscr      = mfspr(SPRN_HFSCR);
> @@ -700,8 +716,6 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
>         WARN_ON_ONCE(mfmsr() & (MSR_IR|MSR_DR));
>
>         if ((srr1 & SRR1_WAKESTATE) != SRR1_WS_NOLOSS) {
> -               unsigned long mmcra;
> -
>                 /*
>                  * We don't need an isync after the mtsprs here because the
>                  * upcoming mtmsrd is execution synchronizing.
> @@ -721,6 +735,10 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
>                         mtspr(SPRN_MMCR0, mmcr0);
>                 }
>
> +               /* Reload MMCRA to restore BHRB disable bit for POWER10 */
> +               if (cpu_has_feature(CPU_FTR_ARCH_31))
> +                       mtspr(SPRN_MMCRA, mmcra);
> +
>                 /*
>                  * DD2.2 and earlier need to set then clear bit 60 in MMCRA
>                  * to ensure the PMU starts running.
Just below here we have:
        mmcra = mfspr(SPRN_MMCRA);
        mmcra |= PPC_BIT(60);
        mtspr(SPRN_MMCRA, mmcra);
        mmcra &= ~PPC_BIT(60);
        mtspr(SPRN_MMCRA, mmcra);
It seems MMCRA[BHRBRD] could just be OR'd in someway similar to this
for ISA v3.1?
> --
> 1.8.3.1
>
