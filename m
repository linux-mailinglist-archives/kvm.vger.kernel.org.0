Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB8157EC1E
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 06:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiGWErX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Jul 2022 00:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGWErW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Jul 2022 00:47:22 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7585431200
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 21:47:20 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id b6so3802979wmq.5
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 21:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ClkRR6M+900US0KQHHRgn2sKqC8Wt2qOmc26396rdLw=;
        b=sCzL+HDv0axLrw3jxXM06IvPYPBB/FqyaN5CzcyIs518O6+S5/Hq6HW0Vtm8IrrN9a
         JlEoRO3fzJcqMiA5rECLNcZUTyfzZnduc6XmJoxXEIJ4Fa/i/mBRTN4a226oLGfZOy1T
         ZrOZBGtNb7jDv4c4cLT3HU2K5LAR+2K5qxKy6mRUcO2lMTPYGngWJngUi1s/49AZATMi
         vHTWJRjvVmdXTABGUuRMNhvtBEEH/zpdBUjLdv/kWoG/AC6eD7wkYIXXobgqA2vPgvCH
         dCy+zmkL6e/pgjUzPS+fawOaB4WCErjeADN8Gx2KtQfWmuQ65cHlJvW6YycGCCVgB0Pd
         VwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ClkRR6M+900US0KQHHRgn2sKqC8Wt2qOmc26396rdLw=;
        b=vb7riR+Za/ITu9o3/pvgWyoNQb65itE7EXQ/isIzXHXuXf4vn1QosjHDmLDfuO5MA7
         CEosjMqpgoFpmecay3OgOsyBt3wvnuVG4LWj41cBRR9ZR3VQ2+u7cnjI1juJbHuPEjom
         FdgE9Fxh/4lNtusMIPX6WU8Q2AnMzSjCOKfMVl5baX6muDptYzA+lFmipgaWMnsHUSQj
         0TYX38AFraamkcci0ru8x3sV8GjzVCagqs1ZPhneBoMuZ2wQMOs6nExJ4LMdSytD1dXj
         Pq17lOn1sDBIPGsuanrwEgxpjIOSwt4CYBLYo1TjkNhQWUIfTm2VyIAepSSL0p8Prcum
         Xrzg==
X-Gm-Message-State: AJIora/3Exchrobqoo/1FihHZH0k9hXsdg9AzGOv+PXVIkgwJ7eTImzW
        hj7xy73ApNMlHNPWW/wka/tDEQJEM7vvR0nqxic8aQ==
X-Google-Smtp-Source: AGRyM1vdTDHnXx6/iSL72TAIkM2o5HPzQQpmceFlCysZbho0p1KKEyC2jfWh5dOmd2LLx/uobVYvmK1JdDJJLKgFhWQ=
X-Received: by 2002:a05:600c:3caa:b0:394:8fb8:716 with SMTP id
 bg42-20020a05600c3caa00b003948fb80716mr14237697wmb.105.1658551638574; Fri, 22
 Jul 2022 21:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220722165047.519994-1-atishp@rivosinc.com>
In-Reply-To: <20220722165047.519994-1-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 23 Jul 2022 10:17:06 +0530
Message-ID: <CAAhSdy2UDwZYK+EaKHPXLxyKUMv-OX02EdaBDBgjNF0jdDJ7xQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] Add Sstc extension support
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Palmer,

On Fri, Jul 22, 2022 at 10:20 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> This series implements Sstc extension support which was ratified recently.
> Before the Sstc extension, an SBI call is necessary to generate timer
> interrupts as only M-mode have access to the timecompare registers. Thus,
> there is significant latency to generate timer interrupts at kernel.
> For virtualized enviornments, its even worse as the KVM handles the SBI call
> and uses a software timer to emulate the timecomapre register.
>
> Sstc extension solves both these problems by defining a stimecmp/vstimecmp
> at supervisor (host/guest) level. It allows kernel to program a timer and
> recieve interrupt without supervisor execution enviornment (M-mode/HS mode)
> intervention.
>
> KVM directly updates the vstimecmp as well if the guest kernel invokes the SBI
> call instead of updating stimecmp directly. This is required because KVM will
> enable sstc extension if the hardware supports it unless the VMM explicitly
> disables it for that guest. The hardware is expected to compare the
> vstimecmp at every cycle if sstc is enabled and any stale value in vstimecmp
> will lead to spurious timer interrupts. This also helps maintaining the
> backward compatibility with older kernels.
>
> Similary, the M-mode firmware(OpenSBI) uses stimecmp for older kernel
> without sstc support as STIP bit in mip is read only for hardware with sstc.
>
> The PATCH 1 & 2 enables the basic infrastructure around Sstc extension while
> PATCH 3 lets kernel use the Sstc extension if it is available in hardware.
> PATCH 4 implements the Sstc extension in KVM.
>
> This series has been tested on Qemu(RV32 & RV64) with additional patches in
> Qemu[2]. This series can also be found at [3].
>
> Changes from v6->v7:
> 1. Fixed a compilation error reported by 0-day bot.
>
> Changes from v5->v6:
> 1. Moved SSTC extension enum below SVPBMT.
>
> Changes from v4->v5:
> 1. Added RB tag.
> 2. Changed the pr-format.
> 3. Rebased on 5.19-rc7 and kvm-queue.
> 4. Moved the henvcfg modification from hardware enable to vcpu_load.
>
> Changes from v3->v4:
> 1. Rebased on 5.18-rc6
> 2. Unified vstimemp & next_cycles.
> 3. Addressed comments in PATCH 3 & 4.
>
> Changes from v2->v3:
> 1. Dropped unrelated KVM fixes from this series.
> 2. Rebased on 5.18-rc3.
>
> Changes from v1->v2:
> 1. Separate the static key from kvm usage
> 2. Makde the sstc specific static key local to the driver/clocksource
> 3. Moved the vstimecmp update code to the vcpu_timer
> 4. Used function pointers instead of static key to invoke vstimecmp vs
>    hrtimer at the run time. This will help in future for migration of vms
>    from/to sstc enabled hardware to non-sstc enabled hardware.
> 5. Unified the vstimer & timer to 1 timer as only one of them will be used
>    at runtime.
>
> [1] https://drive.google.com/file/d/1m84Re2yK8m_vbW7TspvevCDR82MOBaSX/view
> [2] https://github.com/atishp04/qemu/tree/sstc_v6
> [3] https://github.com/atishp04/linux/tree/sstc_v7
>
> Atish Patra (4):
> RISC-V: Add SSTC extension CSR details
> RISC-V: Enable sstc extension parsing from DT
> RISC-V: Prefer sstc extension if available
> RISC-V: KVM: Support sstc extension

The PATCH4 is dependent on the KVM patches in queue for 5.20.

I suggest you take PATCH1, PATCH2 and PATCH3. I will send
PATCH4 in second batch/PR for 5.20 assuming you will send the
first three patches in your first PR for 5.20

Does this sound okay to you ?

Regards,
Anup

>
> arch/riscv/include/asm/csr.h            |   5 +
> arch/riscv/include/asm/hwcap.h          |   1 +
> arch/riscv/include/asm/kvm_vcpu_timer.h |   7 ++
> arch/riscv/include/uapi/asm/kvm.h       |   1 +
> arch/riscv/kernel/cpu.c                 |   1 +
> arch/riscv/kernel/cpufeature.c          |   1 +
> arch/riscv/kvm/vcpu.c                   |   8 +-
> arch/riscv/kvm/vcpu_timer.c             | 144 +++++++++++++++++++++++-
> drivers/clocksource/timer-riscv.c       |  25 +++-
> 9 files changed, 185 insertions(+), 8 deletions(-)
>
> --
> 2.25.1
>
