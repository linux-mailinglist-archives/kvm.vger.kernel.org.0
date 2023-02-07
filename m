Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8E868D29B
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 10:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjBGJUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 04:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjBGJUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 04:20:30 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3E524C9F
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 01:20:24 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id n2so7431552pgb.2
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 01:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=616h4CPqRb9+yGgK1+zMae6bPtCXWD1O+JIiZJuuAN4=;
        b=POuFDmmZM+HsSNu3Ig6MrYzwr3GM4CyOQdDe7V11yiwyZPXSCPNLzrlt076FyPn9N3
         Ra3OCljjkArBP9GamaRLVX37vdcbOskg+wqXX/KuFLOrm5AYkm4n/TmA6Zn3pxImfTlT
         OL0CV63kV1gNyVRmGC8U56R9ST6dZfBwW6N/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=616h4CPqRb9+yGgK1+zMae6bPtCXWD1O+JIiZJuuAN4=;
        b=dD5QlgoxzseflvrtTD98rII5djvctzefEDWbx+HyxMuvOuStWPA4vJCBhCf8KfT1iD
         PjOazltGI/CXglm5DGwc+l31sv4tJezTFTX0j6EBZXG3hWn0QkGk4L9IKbOR4uIM4rwA
         ATjwT+BRzAwccKY5B7uLYp5Zo+BAHgjosNg7GAvuwR2h3RWnx+kOEe3ZjbQcOQdkvelU
         npDCz/4qKdukJRJdmuvm8ZKZ/CgOA4FXvZ8PFG7OVFSpopLibgsff+niQDFi/2EK0ob2
         gsa2kWVzcLiUnCCy+Ukav6VTLPOm2K62dblrqbw9O0FN/dZ8xvEENmF6cvK8gwAYGBKW
         EUIw==
X-Gm-Message-State: AO0yUKWE9t6DN6KMYNbgzHv5WbJ+4OAWgVfl9TA1n3MZbM7kCdcK0bPL
        hfKGt0XIDb2nEPdA6D1+3oj13hyR4FmJtgxVk26l
X-Google-Smtp-Source: AK7set8u2ObsZbLlP0iS0NBdphAYXHsP07SB/g80AsW6PNgCWskBsHThfsh9+Xa6vPihwEdNRDQUptXNmQK/81bFsSg=
X-Received: by 2002:a63:7a56:0:b0:4c7:ef33:bbe1 with SMTP id
 j22-20020a637a56000000b004c7ef33bbe1mr415970pgn.73.1675761624040; Tue, 07 Feb
 2023 01:20:24 -0800 (PST)
MIME-Version: 1.0
References: <20230201231250.3806412-1-atishp@rivosinc.com> <20230201231250.3806412-8-atishp@rivosinc.com>
 <20230202170345.uwi72dauzunlzxex@orel> <CAOnJCUJfc8y729GiUdtqhv+PZu8v9rH+kfpwPwdW=GQPEs9FNw@mail.gmail.com>
 <CAOnJCUKn_pLKqYO71S6MrZd=rnTdSShZk+XksX2uxTiVtthmTA@mail.gmail.com>
 <20230206092204.aiyo43uxlm4xdmgn@orel> <20230206113945.vcnrokltvzgifsqu@orel>
In-Reply-To: <20230206113945.vcnrokltvzgifsqu@orel>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 7 Feb 2023 01:20:12 -0800
Message-ID: <CAOnJCUK8FUFYGgTh0Zx=_nN8BwZ1rnCXccg212y=dVKkOXuwww@mail.gmail.com>
Subject: Re: [PATCH v4 07/14] RISC-V: KVM: Add skeleton support for perf
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
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

On Mon, Feb 6, 2023 at 3:39 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Mon, Feb 06, 2023 at 10:22:04AM +0100, Andrew Jones wrote:
> > On Sat, Feb 04, 2023 at 11:37:47PM -0800, Atish Patra wrote:
> > > On Fri, Feb 3, 2023 at 12:47 AM Atish Patra <atishp@atishpatra.org> wrote:
> > > >
> > > > On Thu, Feb 2, 2023 at 9:03 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> > > > >
> > > > > On Wed, Feb 01, 2023 at 03:12:43PM -0800, Atish Patra wrote:
> > > > > > This patch only adds barebone structure of perf implementation. Most of
> > > > > > the function returns zero at this point and will be implemented
> > > > > > fully in the future.
> > > > > >
> > > > > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > > > > ---
> > > > > >  arch/riscv/include/asm/kvm_host.h     |   4 +
> > > > > >  arch/riscv/include/asm/kvm_vcpu_pmu.h |  78 +++++++++++++++
> > > > > >  arch/riscv/kvm/Makefile               |   1 +
> > > > > >  arch/riscv/kvm/vcpu.c                 |   7 ++
> > > > > >  arch/riscv/kvm/vcpu_pmu.c             | 136 ++++++++++++++++++++++++++
> > > > > >  5 files changed, 226 insertions(+)
> > > > > >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > > >  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> > > > > >
> > > > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > > > > > index 93f43a3..b90be9a 100644
> > > > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > > > @@ -18,6 +18,7 @@
> > > > > >  #include <asm/kvm_vcpu_insn.h>
> > > > > >  #include <asm/kvm_vcpu_sbi.h>
> > > > > >  #include <asm/kvm_vcpu_timer.h>
> > > > > > +#include <asm/kvm_vcpu_pmu.h>
> > > > > >
> > > > > >  #define KVM_MAX_VCPUS                        1024
> > > > > >
> > > > > > @@ -228,6 +229,9 @@ struct kvm_vcpu_arch {
> > > > > >
> > > > > >       /* Don't run the VCPU (blocked) */
> > > > > >       bool pause;
> > > > > > +
> > > > > > +     /* Performance monitoring context */
> > > > > > +     struct kvm_pmu pmu_context;
> > > > > >  };
> > > > > >
> > > > > >  static inline void kvm_arch_hardware_unsetup(void) {}
> > > > > > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > > > new file mode 100644
> > > > > > index 0000000..e2b4038
> > > > > > --- /dev/null
> > > > > > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > > > @@ -0,0 +1,78 @@
> > > > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > > > +/*
> > > > > > + * Copyright (c) 2023 Rivos Inc
> > > > > > + *
> > > > > > + * Authors:
> > > > > > + *     Atish Patra <atishp@rivosinc.com>
> > > > > > + */
> > > > > > +
> > > > > > +#ifndef __KVM_VCPU_RISCV_PMU_H
> > > > > > +#define __KVM_VCPU_RISCV_PMU_H
> > > > > > +
> > > > > > +#include <linux/perf/riscv_pmu.h>
> > > > > > +#include <asm/kvm_vcpu_sbi.h>
> > > > > > +#include <asm/sbi.h>
> > > > > > +
> > > > > > +#ifdef CONFIG_RISCV_PMU_SBI
> > > > > > +#define RISCV_KVM_MAX_FW_CTRS        32
> > > > > > +
> > > > > > +#if RISCV_KVM_MAX_FW_CTRS > 32
> > > > > > +#error "Maximum firmware counter can't exceed 32 without increasing the RISCV_MAX_COUNTERS"
> > > > >
> > > > > "The number of firmware counters cannot exceed 32 without increasing RISCV_MAX_COUNTERS"
> > > > >
> > > > > > +#endif
> > > > > > +
> > > > > > +#define RISCV_MAX_COUNTERS      64
> > > > >
> > > > > But instead of that message, what I think we need is something like
> > > > >
> > > > >  #define RISCV_KVM_MAX_HW_CTRS  32
> > > > >  #define RISCV_KVM_MAX_FW_CTRS  32
> > > > >  #define RISCV_MAX_COUNTERS     (RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
> > > > >
> > > > >  static_assert(RISCV_MAX_COUNTERS <= 64)
> > > > >
> > > > > And then in pmu_sbi_device_probe() should ensure
> > > > >
> > > > >   num_counters <= RISCV_MAX_COUNTERS
> > > > >
> > > > > and pmu_sbi_get_ctrinfo() should ensure
> > > > >
> > > > >   num_hw_ctr <= RISCV_KVM_MAX_HW_CTRS
> > > > >   num_fw_ctr <= RISCV_KVM_MAX_FW_CTRS
> > > > >
> > > > > which has to be done at runtime.
> > > > >
> > > >
> > > > Sure. I will add the additional sanity checks.
> > > >
> > >
> > > As explained above, I feel we shouldn't mix the firmware number of
> > > counters that the host gets and it exposes to a guest.
> > > So I have not included this suggestion in the v5.
> > > I have changed the num_fw_ctrs to PMU_FW_MAX though to accurately
> > > reflect the firmware counters KVM is actually using.
> >
> > Sounds good
>
> I just looked at v5. IMO, much of what I proposed above still makes
> sense, since what I'm proposing is that the relationship between
> RISCV_KVM_MAX_HW_CTRS, RISCV_KVM_MAX_FW_CTRS, RISCV_MAX_COUNTERS, and 64
> (our current max bitmap size) be explicitly checked. So, even if we want
> RISCV_KVM_MAX_FW_CTRS to be SBI_PMU_FW_MAX, it'd be good to have
>
> #define RISCV_KVM_MAX_HW_CTRS  32
>
> (And a runtime check confirming num_hw_ctrs + 1 <= RISCV_KVM_MAX_HW_CTRS,
>  and then either silently capping or issuing a warning and capping)
>
> And, to be sure the sum of RISCV_KVM_MAX_FW_CTRS and RISCV_KVM_MAX_HW_CTRS
> doesn't exceed the size of the bitmap
>
> #define RISCV_KVM_MAX_FW_CTRS   SBI_PMU_FW_MAX
> #define RISCV_MAX_COUNTERS      (RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
> static_assert(RISCV_MAX_COUNTERS <= 64)
>

ok. I have added those changes but I have modified RISCV_MAX_COUNTERS
to RISCV_KVM_MAX_COUNTERS,
to avoid overlapping with the RISCV_MAX_COUNTERS defined in the host.
Logically, the host and the guest can have separate counters anyways.

> Thanks,
> drew
>
> >
> > > I don't know if there is any benefit of static_assert over #error.
> > > Please let me know if you feel strongly about that.
> >
> > One "normal" line vs. three #-lines?
> >

Fair enough. Fixed.

> > Thanks,
> > drew



-- 
Regards,
Atish
