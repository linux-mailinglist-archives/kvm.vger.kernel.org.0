Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214336330F8
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 00:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiKUXuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 18:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiKUXuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 18:50:50 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F47ED59
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 15:50:49 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id cn2-20020a056830658200b0066c74617e3dso8329602otb.2
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 15:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9qJGSmI/PVM4rhm2z0vPY9+1OW24z6YeaOBoyxuNZ2Y=;
        b=pZeRXuaDR4YUAfk9pdiqFA9TNENllOMQJLmkdrsc2MdWnAAdd30cd7c7ROFGKUDQf6
         +ZNNNZ6KQrQS7mXrU5dtHljL+yC4zTULQH3K6B1tf9UZpkaXG5sbD0ytAKxL8yhOTF1I
         veCJvHxCJEFLT1214Au5yOvydOw7ieR3Csaxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9qJGSmI/PVM4rhm2z0vPY9+1OW24z6YeaOBoyxuNZ2Y=;
        b=nxNmiUw60Q457i42vnskpsHjRWz3/hiK9+VSSW3hqCXd6Vt5LRisM/K2OEriLvPSxQ
         dPj273kE1fd86kItb44IvRNmxnwrUAhmJvsZ63+eK6zABNHueq6DT6JKf2Itt/mJvMiT
         xecyce5922qi/59XFjieWe1xTDxi1DEFCM3CyW9JufPM54aclWjHJAq+0etaJ/sfYsVP
         Hzznh2bK2pe4vd5atE+zFhTu1avM7+MxoK95Yy/vBBnANy9r0qrcE6bEaczL+uRmGytU
         ltVlHGsd1AjUHFxbOgd7ZNCHrbVv3jf5J8AunNDIM62lDAZBMZNvNFBXLvjsF9M9HHe5
         C0Hg==
X-Gm-Message-State: ANoB5pnkdu9sb0a55Y+/Gvxp7OOwPInXo1HSbTFUmkQAwGM537xq3rQk
        6qCo+zaCk4NFQUgMS2gSLbN4u86mcbkd2Qbp5eqL
X-Google-Smtp-Source: AA0mqf7kgYx54Yys6ETxvNQky+UEeKJ5p7LWh6nQdHq65TGyGvoY5M23v26YV+tFfDLtE9o9NFgqlU+8tlQQZEuniNM=
X-Received: by 2002:a05:6830:22f2:b0:669:3797:c1b4 with SMTP id
 t18-20020a05683022f200b006693797c1b4mr10436192otc.293.1669074648514; Mon, 21
 Nov 2022 15:50:48 -0800 (PST)
MIME-Version: 1.0
References: <20220718170205.2972215-1-atishp@rivosinc.com> <20220718170205.2972215-2-atishp@rivosinc.com>
 <20221101123008.e3bwen6f2yxi3whi@kamzik>
In-Reply-To: <20221101123008.e3bwen6f2yxi3whi@kamzik>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 21 Nov 2022 15:50:37 -0800
Message-ID: <CAOnJCU+wf=CR12GONjBougZGs+ZQV1MoDAK-w+ALQatEECoFBQ@mail.gmail.com>
Subject: Re: [RFC 1/9] RISC-V: Define a helper function to probe number of
 hardware counters
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 1, 2022 at 5:30 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Mon, Jul 18, 2022 at 10:01:57AM -0700, Atish Patra wrote:
> > KVM module needs to know how many hardware counters the platform supports.
> > Otherwise, it will not be able to show optimal value of virtual
>                                         ^ the
> > counters to the guest.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  drivers/perf/riscv_pmu_sbi.c   | 23 +++++++++++++++++------
> >  include/linux/perf/riscv_pmu.h |  4 ++++
> >  2 files changed, 21 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> > index 24124546844c..1723af68ffa1 100644
> > --- a/drivers/perf/riscv_pmu_sbi.c
> > +++ b/drivers/perf/riscv_pmu_sbi.c
> > @@ -27,6 +27,7 @@
> >   */
> >  static union sbi_pmu_ctr_info *pmu_ctr_list;
> >  static unsigned int riscv_pmu_irq;
> > +static struct riscv_pmu *rvpmu;
>
> Do we really need rvpmu? From a quick scan of the series it's only used
> for num_hw_counters, which has to be added to struct riscv_pmu, and
> num_counters. How about instead creating a static global for num_counters

Yes. I added rvpmu just for future usage if any.

> and then getting num_hw_counters by iterating pmu_ctr_list. If we want

iteration is fine as we are doing that for hpm_width anyways.

> riscv_pmu_sbi_get_num_hw_ctrs() to be faster, then we can cache the value
> in a static variable in the function.
>

We have cmask now which can be cached in a static variable. We need to
retrieve the
counter width and the hardware counters for kvm. I have combined PATCH
1 & PATCH 2
to return both the values in one function.

> Thanks,
> drew



-- 
Regards,
Atish
