Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E30228F4A
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 06:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGVEm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 00:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgGVEm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 00:42:26 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E5BC061794;
        Tue, 21 Jul 2020 21:42:26 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id w17so865758otl.4;
        Tue, 21 Jul 2020 21:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GtofqkQ3XIJWTX5BE6tfZb4lMA7KmqIQCzAlx3ABX0M=;
        b=VtZzRr7+vBbhCeoJXyvXwOAsKy4ygVaSH1QnWwOVYpGmgP/DCQOrHkXiKVoYGY5lrI
         9sNOgw/3D/hgGKZSuyk4RuK6rG/YRe40dmLuz4huuLscaULAkFYKJeyIxzYy2hwxm6BB
         bVkxz7KtKGw/xfXa5Ztq39jXWsJHBjF4GbZFmjbJsSSSJJfYujDKaUHi7dl8hGAnBnr5
         tCD05I743cua1VaCW/k6v38ODJupmAWPbnLL7sux60ZIdgXp5Suy0zAyr6NZJOll8Xy+
         oHE2+4addVJD8Ijrf03ErqRCJyuy/D0R1FShQ5JLqqPr6kxEZIisG/r+c+2Dgkt5hCCn
         10aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GtofqkQ3XIJWTX5BE6tfZb4lMA7KmqIQCzAlx3ABX0M=;
        b=O4hTcPb2y8P+153zjY7puL0k0qgp0WOGSOqJsyU93cbZrhvySn5ubZzuChwYCSLY7P
         Poy+kLkAHpUwOZDQnBoAkzd325bLd/PbOpGHnyIERK+9ARaBEMvk/7d54Z192EOtc5qt
         IuAv1gUJCELXHM51hbDWSnOZCbzyLgYQ6mDq5/sJAiymC6QYZjyus34PLhG1aZ9tL8K7
         3ZZvK4PTtXsExeSK0uRNQwBLDYbQgQPutzDCaG01EbhqJbfh7kAzICww0BAqo9su4JvL
         pnXYUebfEGH3uxZ2EoXlmUuk6DA1fuELaHnC+k0BHOep4sD0Fm2IIIzUXpcD58WD8iJo
         3zug==
X-Gm-Message-State: AOAM530QQK+AX3r3aSaVgmQ+xWE9GOnZKWxeP1mEAXEmlCAn4yc42hAU
        RQkp8irKRAVV5rpuTMy1JsLJXkWU0nhzBqUtxlQ=
X-Google-Smtp-Source: ABdhPJyVDBS9hB7vq2K7civKPaRsjw0GL+OvOR5dsO1HwV67oYdMaz75KRUqg6pMAFC5rOCQrnG0Yj39sxLkMsJqxyU=
X-Received: by 2002:a9d:7f06:: with SMTP id j6mr5928964otq.51.1595392945793;
 Tue, 21 Jul 2020 21:42:25 -0700 (PDT)
MIME-Version: 1.0
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com> <1594996707-3727-8-git-send-email-atrajeev@linux.vnet.ibm.com>
In-Reply-To: <1594996707-3727-8-git-send-email-atrajeev@linux.vnet.ibm.com>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Wed, 22 Jul 2020 14:41:40 +1000
Message-ID: <CACzsE9oBw1ZrJLqOAg1QqPrQgSoVbEdPh_ax7mU_kcWNyfyAcg@mail.gmail.com>
Subject: Re: [v3 07/15] powerpc/perf: Add power10_feat to dt_cpu_ftrs
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Gautham R Shenoy <ego@linux.vnet.ibm.com>, mikey@neuling.org,
        maddy@linux.vnet.ibm.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 18, 2020 at 1:13 AM Athira Rajeev
<atrajeev@linux.vnet.ibm.com> wrote:
>
> From: Madhavan Srinivasan <maddy@linux.ibm.com>
>
> Add power10 feature function to dt_cpu_ftrs.c along
> with a power10 specific init() to initialize pmu sprs,
> sets the oprofile_cpu_type and cpu_features. This will
> enable performance monitoring unit(PMU) for Power10
> in CPU features with "performance-monitor-power10".
>
> For PowerISA v3.1, BHRB disable is controlled via Monitor Mode
> Control Register A (MMCRA) bit, namely "BHRB Recording Disable
> (BHRBRD)". This patch initializes MMCRA BHRBRD to disable BHRB
> feature at boot for power10.
>
> Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/reg.h        |  3 +++
>  arch/powerpc/kernel/cpu_setup_power.S |  8 ++++++++
>  arch/powerpc/kernel/dt_cpu_ftrs.c     | 26 ++++++++++++++++++++++++++
>  3 files changed, 37 insertions(+)
>
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
> index 21a1b2d..900ada1 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -1068,6 +1068,9 @@
>  #define MMCR0_PMC2_LOADMISSTIME        0x5
>  #endif
>
> +/* BHRB disable bit for PowerISA v3.10 */
> +#define MMCRA_BHRB_DISABLE     0x0000002000000000
Shouldn't this go under SPRN_MMCRA with the other MMCRA_*.
> +
>  /*
>   * SPRG usage:
>   *
> diff --git a/arch/powerpc/kernel/cpu_setup_power.S b/arch/powerpc/kernel/cpu_setup_power.S
> index efdcfa7..b8e0d1e 100644
> --- a/arch/powerpc/kernel/cpu_setup_power.S
> +++ b/arch/powerpc/kernel/cpu_setup_power.S
> @@ -94,6 +94,7 @@ _GLOBAL(__restore_cpu_power8)
>  _GLOBAL(__setup_cpu_power10)
>         mflr    r11
>         bl      __init_FSCR_power10
> +       bl      __init_PMU_ISA31
So we set MMCRA here but then aren't we still going to call __init_PMU
which will overwrite that?
Would this setting MMCRA also need to be handled in __restore_cpu_power10?
>         b       1f
>
>  _GLOBAL(__setup_cpu_power9)
> @@ -233,3 +234,10 @@ __init_PMU_ISA207:
>         li      r5,0
>         mtspr   SPRN_MMCRS,r5
>         blr
> +
> +__init_PMU_ISA31:
> +       li      r5,0
> +       mtspr   SPRN_MMCR3,r5
> +       LOAD_REG_IMMEDIATE(r5, MMCRA_BHRB_DISABLE)
> +       mtspr   SPRN_MMCRA,r5
> +       blr
> diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
> index 3a40951..f482286 100644
> --- a/arch/powerpc/kernel/dt_cpu_ftrs.c
> +++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
> @@ -450,6 +450,31 @@ static int __init feat_enable_pmu_power9(struct dt_cpu_feature *f)
>         return 1;
>  }
>
> +static void init_pmu_power10(void)
> +{
> +       init_pmu_power9();
> +
> +       mtspr(SPRN_MMCR3, 0);
> +       mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
> +}
> +
> +static int __init feat_enable_pmu_power10(struct dt_cpu_feature *f)
> +{
> +       hfscr_pmu_enable();
> +
> +       init_pmu_power10();
> +       init_pmu_registers = init_pmu_power10;
> +
> +       cur_cpu_spec->cpu_features |= CPU_FTR_MMCRA;
> +       cur_cpu_spec->cpu_user_features |= PPC_FEATURE_PSERIES_PERFMON_COMPAT;
> +
> +       cur_cpu_spec->num_pmcs          = 6;
> +       cur_cpu_spec->pmc_type          = PPC_PMC_IBM;
> +       cur_cpu_spec->oprofile_cpu_type = "ppc64/power10";
> +
> +       return 1;
> +}
> +
>  static int __init feat_enable_tm(struct dt_cpu_feature *f)
>  {
>  #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> @@ -639,6 +664,7 @@ struct dt_cpu_feature_match {
>         {"pc-relative-addressing", feat_enable, 0},
>         {"machine-check-power9", feat_enable_mce_power9, 0},
>         {"performance-monitor-power9", feat_enable_pmu_power9, 0},
> +       {"performance-monitor-power10", feat_enable_pmu_power10, 0},
>         {"event-based-branch-v3", feat_enable, 0},
>         {"random-number-generator", feat_enable, 0},
>         {"system-call-vectored", feat_disable, 0},
> --
> 1.8.3.1
>
