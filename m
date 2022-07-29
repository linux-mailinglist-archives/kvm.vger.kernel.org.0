Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A413758501A
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 14:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiG2Mcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 08:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiG2Mce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 08:32:34 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7629A7FE77
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 05:32:33 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id o15so7900479yba.10
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 05:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=NgyXkRFKm1mWhtYAsy1KT6+Z/leQljWMD9vh/ZwdATE=;
        b=lVxWNeiNNhf5exql1Zx56C+uKo33x2mOny1EHptn9GK7V/cpoe63ZN1t5R56FkojAx
         Xv2HWPYCxf6WLzAcSRgKGgw7Agdmx0wKA7HzqByzcArH5r1mRKMla5wl23fWrKeuoAkE
         WFch4kUomrXvGHu24wne/FjmtUnMKWWAg9v7Pud0WHzzS/QFnh6td36U+kkgJ1PSJOUS
         KSiFfjQN6xYZpi7QP21vLEsLfH2xRNx+pCoE0Yl73v4nM3GYCnArbA74bUHrqivuurkz
         vt5Ts5LpL4gErRKgUaAMlglc8CCrnpBiz7IZTRyUjwNlNtlSvXOd9SlLgxvsxk/Xdvtv
         B/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=NgyXkRFKm1mWhtYAsy1KT6+Z/leQljWMD9vh/ZwdATE=;
        b=SKvER1gQDQWd/AbgZs/rfw5zKdTbefwwENBjh2nL/5iDqWKkd+EcWHUG1t2TC6Y974
         yWK+JuOk0oAjNQw6hVty2foFACtzkyJeQ7z47Gd0CQQQ7QP7M073aa3HYwT5oHIDTy72
         IRA8mBEJ5RSLDstMQKL2IPVh40sJdOEyLuODDtl8TgdcwLsu+JiigDPczHg0bG4alAdL
         4WO54fcu2C3BqtPDUes5E7z8JyesxMGdgxaBOvzw3bWQ9edqRW5Y99rilkRea7zOUj88
         xt2Qv7MP4tPyu8fBrJhvfxiLJxhCiFgMV4sDRWFTL1LP331AdUa9qElEv7Bd7J8z3ewR
         OO5w==
X-Gm-Message-State: ACgBeo1JLmiOk9KNl4g+CM0Qy2GCMl1HNILX7OJN1qTGajWvKJqSXi5E
        kkF1M03eu1Iy1WhSWQShNb6+ZvUn6b/ND3kTQPT/Aw==
X-Google-Smtp-Source: AA6agR5PBgzCERmTltJ0yu6/L1mipdnkKNUMB8kysnrz+Fh5bxYh/fYtfbYWKZ1au9+Nu6zm4te49cyZpxjApNx1TKg=
X-Received: by 2002:a25:640a:0:b0:671:3386:f860 with SMTP id
 y10-20020a25640a000000b006713386f860mr2272340ybb.423.1659097952476; Fri, 29
 Jul 2022 05:32:32 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 29 Jul 2022 18:01:27 +0530
Message-ID: <CAAhSdy2iH-WpitweQ_nCYm6p0S5S_fmQ3x37FdAe7tEmu_np0A@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 5.20
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
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

Hi Paolo,

We have following KVM RISC-V changes for 5.20:
1) Track ISA extensions used by Guest using bitmap
2) Added system instruction emulation framework
3) Added CSR emulation framework
4) Added gfp_custom flag in struct kvm_mmu_memory_cache
5) Added G-stage ioremap() and iounmap() functions
6) Added support for Svpbmt inside Guest

Please pull.

Regards,
Anup

The following changes since commit e0dccc3b76fb35bb257b4118367a883073d7390e:

  Linux 5.19-rc8 (2022-07-24 13:26:27 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.20-1

for you to fetch changes up to 6bb2e00ea304ffc0446f345c46fe22713ce43cbf:

  RISC-V: KVM: Add support for Svpbmt inside Guest/VM (2022-07-29
17:15:18 +0530)

----------------------------------------------------------------
KVM/riscv changes for 5.20

- Track ISA extensions used by Guest using bitmap
- Added system instruction emulation framework
- Added CSR emulation framework
- Added gfp_custom flag in struct kvm_mmu_memory_cache
- Added G-stage ioremap() and iounmap() functions
- Added support for Svpbmt inside Guest

----------------------------------------------------------------
Anup Patel (7):
      RISC-V: KVM: Factor-out instruction emulation into separate sources
      RISC-V: KVM: Add extensible system instruction emulation framework
      RISC-V: KVM: Add extensible CSR emulation framework
      KVM: Add gfp_custom flag in struct kvm_mmu_memory_cache
      RISC-V: KVM: Add G-stage ioremap() and iounmap() functions
      RISC-V: KVM: Use PAGE_KERNEL_IO in kvm_riscv_gstage_ioremap()
      RISC-V: KVM: Add support for Svpbmt inside Guest/VM

Atish Patra (1):
      RISC-V: KVM: Improve ISA extension by using a bitmap

Nikolay Borisov (2):
      RISC-V: KVM: Make kvm_riscv_guest_timer_init a void function
      RISC-V: KVM: move preempt_disable() call in kvm_arch_vcpu_ioctl_run

Zhang Jiaming (1):
      RISC-V: KVM: Fix variable spelling mistake

 arch/riscv/include/asm/csr.h            |  16 +
 arch/riscv/include/asm/kvm_host.h       |  24 +-
 arch/riscv/include/asm/kvm_vcpu_fp.h    |   8 +-
 arch/riscv/include/asm/kvm_vcpu_insn.h  |  48 ++
 arch/riscv/include/asm/kvm_vcpu_timer.h |   2 +-
 arch/riscv/include/uapi/asm/kvm.h       |   1 +
 arch/riscv/kvm/Makefile                 |   1 +
 arch/riscv/kvm/mmu.c                    |  28 +-
 arch/riscv/kvm/vcpu.c                   | 203 ++++++---
 arch/riscv/kvm/vcpu_exit.c              | 496 +--------------------
 arch/riscv/kvm/vcpu_fp.c                |  27 +-
 arch/riscv/kvm/vcpu_insn.c              | 752 ++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_timer.c             |   4 +-
 arch/riscv/kvm/vm.c                     |   4 +-
 include/linux/kvm_types.h               |   1 +
 include/uapi/linux/kvm.h                |   8 +
 virt/kvm/kvm_main.c                     |   4 +-
 17 files changed, 1028 insertions(+), 599 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_insn.h
 create mode 100644 arch/riscv/kvm/vcpu_insn.c
