Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94459698297
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjBORpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjBORpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:45:39 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7A33C2A2
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:45:33 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id bt8so18036784edb.12
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4Wwsx94XKL1P3jKlCaj3qv57oY3RYmKBeXv30BtkUbE=;
        b=b7KiZOYL8vImVDmom1/QCreVvbtV2a16pMwyLdhg0hgFEkqs8ikEYrUbrhPulcckVz
         hZUBEU9XcL6NAJrKMKiVCaEhD6POGezy3kSDBOvHH7m/hQ/aIbtjW4VtO2JwNecB/o57
         N9cJbY1eqBtJVyuhn8eJBeICcgNuT/3ed3cFykKJBHxfrnWUguEs0UAaNVca7Bu3IXRE
         bKJEm8M5ma5GaE85Zkke4LKY2UD9JWo/aNL1TTSCx0m+Sn4hjXqNY3+8GdHGFVixqSuY
         mIEJZ8hUVl1ACZOTWREz4S8FK++BZHdeugSsgoGgd9v5eRb5x6Pg76i0+YtitaJOILBE
         +P6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Wwsx94XKL1P3jKlCaj3qv57oY3RYmKBeXv30BtkUbE=;
        b=TEGEMaIAlh8eCb0OzbXAgylw2WbVDaZ0+joTZ1DX+wvjS40JuFDEagiRFcQQZtVeCP
         iUGgXu/BBV5X5Py2iG9mXZUzf2b3F2Nye8QjqFH3D9WcHZbnX4NI/FnwDq+UwEm1l57/
         a+UlHD2xpgKtB/0TVis4eCPFgb0dLHWqRc2Xx751hTtCUKf9SZRUJApY2NyS2WIhAlSF
         wYjcUCcodlsBExS1b01mwxTyOup9ZfPlipLe3W6G3dP3gxhDyVJpr4EphFZzBeZxGoLQ
         pnpff1KLOx0KWEZXKXJV/1bx+7X1VqBcM6+yBTLL1E7g0dIR4SYQLXzz+RXmrHbWO5R9
         rctg==
X-Gm-Message-State: AO0yUKVqk9dowQKS1LA9R6LrXiBSjO/zflBj5A+YvoPDdrP/0wtGwnDk
        rMJ0MfgdYuVOXSCsgcpwpmEhsk8/wI45uSJfRfOSN8Hzrrc9VA==
X-Google-Smtp-Source: AK7set8yNNya/26EDizHl+6nhvR/24f5tMF/1OznOTMK+iAwJGmsk/WoOa4raLOhz4iYiVVE/ouRVMa7kun4d8pmsR4=
X-Received: by 2002:a17:906:37d1:b0:87a:2701:4b19 with SMTP id
 o17-20020a17090637d100b0087a27014b19mr1465774ejc.5.1676483131955; Wed, 15 Feb
 2023 09:45:31 -0800 (PST)
MIME-Version: 1.0
References: <CAAhSdy25NgCY23u=icRgcZpEZzNgJkyEN92KEVL8D-SvUwTBXg@mail.gmail.com>
 <CABgObfbkCP7gciYaBQ38Qqkryx_k=RcV_Egvv_UE28EO1CnOew@mail.gmail.com>
In-Reply-To: <CABgObfbkCP7gciYaBQ38Qqkryx_k=RcV_Egvv_UE28EO1CnOew@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 15 Feb 2023 23:15:19 +0530
Message-ID: <CAAhSdy3fDJaTdJkwWvGNbhoKNW1jvLZCMzXPvdBsBb68GK2-Fg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.3
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 11:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On Tue, Feb 7, 2023 at 6:36 PM Anup Patel <anup@brainfault.org> wrote:
> >
> > Hi Paolo,
> >
> > We have the following KVM RISC-V changes for 6.3:
> > 1) Fix wrong usage of PGDIR_SIZE to check page sizes
> > 2) Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
> > 3) Redirect illegal instruction traps to guest
> > 4) SBI PMU support for guest
> >
> > Please pull.
> >
> > I will send another PR for 6.3 containing AIA CSR
> > virtualization after Palmer has sent his first PR for 6.3
> > so that I can resolve conflicts with arch/riscv changes.
> > I hope you are okay with this ??
>
> Yes, it's fine to have it separate.
>
> But please send it now, solving the conflicts is either my task or Linus's.

We have decided to defer AIA CSR virtualization to Linux-6.4
so I won't be sending a second PR for this merge window.

Thanks,
Anup

>
> Paolo
>
>
> > Regards,
> > Anup
> >
> > The following changes since commit 4ec5183ec48656cec489c49f989c508b68b518e3:
> >
> >   Linux 6.2-rc7 (2023-02-05 13:13:28 -0800)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.3-1
> >
> > for you to fetch changes up to c39cea6f38eefe356d64d0bc1e1f2267e282cdd3:
> >
> >   RISC-V: KVM: Increment firmware pmu events (2023-02-07 20:36:08 +0530)
> >
> > ----------------------------------------------------------------
> > KVM/riscv changes for 6.3
> >
> > - Fix wrong usage of PGDIR_SIZE to check page sizes
> > - Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
> > - Redirect illegal instruction traps to guest
> > - SBI PMU support for guest
> >
> > ----------------------------------------------------------------
> > Alexandre Ghiti (1):
> >       KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page sizes
> >
> > Andy Chiu (1):
> >       RISC-V: KVM: Redirect illegal instruction traps to guest
> >
> > Anup Patel (1):
> >       RISC-V: KVM: Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
> >
> > Atish Patra (14):
> >       perf: RISC-V: Define helper functions expose hpm counter width and count
> >       perf: RISC-V: Improve privilege mode filtering for perf
> >       RISC-V: Improve SBI PMU extension related definitions
> >       RISC-V: KVM: Define a probe function for SBI extension data structures
> >       RISC-V: KVM: Return correct code for hsm stop function
> >       RISC-V: KVM: Modify SBI extension handler to return SBI error code
> >       RISC-V: KVM: Add skeleton support for perf
> >       RISC-V: KVM: Add SBI PMU extension support
> >       RISC-V: KVM: Make PMU functionality depend on Sscofpmf
> >       RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
> >       RISC-V: KVM: Implement trap & emulate for hpmcounters
> >       RISC-V: KVM: Implement perf support without sampling
> >       RISC-V: KVM: Support firmware events
> >       RISC-V: KVM: Increment firmware pmu events
> >
> >  arch/riscv/include/asm/kvm_host.h     |   4 +
> >  arch/riscv/include/asm/kvm_vcpu_pmu.h | 107 ++++++
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |  13 +-
> >  arch/riscv/include/asm/sbi.h          |   7 +-
> >  arch/riscv/kvm/Makefile               |   1 +
> >  arch/riscv/kvm/main.c                 |   3 +-
> >  arch/riscv/kvm/mmu.c                  |   8 +-
> >  arch/riscv/kvm/tlb.c                  |   4 +
> >  arch/riscv/kvm/vcpu.c                 |   7 +
> >  arch/riscv/kvm/vcpu_exit.c            |   9 +
> >  arch/riscv/kvm/vcpu_insn.c            |   4 +-
> >  arch/riscv/kvm/vcpu_pmu.c             | 633 ++++++++++++++++++++++++++++++++++
> >  arch/riscv/kvm/vcpu_sbi.c             |  72 ++--
> >  arch/riscv/kvm/vcpu_sbi_base.c        |  27 +-
> >  arch/riscv/kvm/vcpu_sbi_hsm.c         |  28 +-
> >  arch/riscv/kvm/vcpu_sbi_pmu.c         |  86 +++++
> >  arch/riscv/kvm/vcpu_sbi_replace.c     |  50 +--
> >  arch/riscv/kvm/vcpu_sbi_v01.c         |  17 +-
> >  drivers/perf/riscv_pmu_sbi.c          |  64 +++-
> >  include/linux/perf/riscv_pmu.h        |   5 +
> >  20 files changed, 1035 insertions(+), 114 deletions(-)
> >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
> >  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> >  create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
> >
>
