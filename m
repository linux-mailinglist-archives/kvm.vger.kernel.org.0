Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44A5421FD5
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 09:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhJEH5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 03:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbhJEH5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 03:57:10 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100BAC061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 00:55:20 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v17so35677776wrv.9
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 00:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TpulCX7npQF5e07hvQ3boQz+xIFvtGE3nVeFjtPk+QE=;
        b=jmkiurrRXdEWLLP7+WsGhKmU/GTo7CTUddVbaghaNPrSIkyQ3vaRN4k7wJdjSNUKou
         vHEdb4RvW0DfKalHKG++IRYlHyC3yMqHKa89Lds97UokeB6XGDUu7GctlGXObVrYoZz8
         OW8fnrtPtpfj8LjcdkaPlsYGuLZASe5kejFGTknsCjuPWM3dcog2AGEpEZdOUjmwHwYb
         IJfx/5H0xmQpT4k1uMvOFOmENfV+i8aIcMYY36JP7WX4LUruKlUAxrZ7fGkorUkzjU/S
         eoFKFTBCPYJ/JNl9ssuBMqBztFThk2ubiVeCh5Do3z4SuuulNAgfCK+N6ybDLajnFCVX
         I/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TpulCX7npQF5e07hvQ3boQz+xIFvtGE3nVeFjtPk+QE=;
        b=SOB8sqOox6Od5RedBVf4ln9Li0lz89BWm1UyrV60HeMe9OiJPCS/LTHZAzIpd2EPc1
         w6pq3v7Wu9xCSKnfLwmoYY0TIkgkOZKP3C6yY0fT0/wH34EFLs7iddRepXY4m7Qe1ZO9
         MxruFyEjKGsBkk6dKdV5GrB+Bh8Bmv9An/sVrXLF16r0MFplq30q56lnStJ7yLUQrGlF
         jVTSBA2rP/cssJNoI11Aur7dg4FaHx/smXNUp7+pf8jue8Tugzptz95m49K1kh8aJTSP
         upF+nK6SRSBSSk53bEoTIEffnm5okPDiqbPrmIw/y16+IqHz/0D3ZgtMjF624txX78/C
         aQEA==
X-Gm-Message-State: AOAM531gL6d9EV2739F4rUQAGN4VjMZmNs7Iq7qZUNZV3UlLNyV1ekV3
        /F+XXh5aIA8cAbAwszmKfJOJ4BHneEWkT/8cVxoEvw==
X-Google-Smtp-Source: ABdhPJzPD4cRXG+lZnI0BaIc2LF4yFyt+eCJr1+tsz1zoYr2KiWPdAsWfvwkjehVIrbIRCQP9EYJu6+TJcuatzfUNnU=
X-Received: by 2002:adf:e805:: with SMTP id o5mr19360415wrm.249.1633420518388;
 Tue, 05 Oct 2021 00:55:18 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 5 Oct 2021 13:25:07 +0530
Message-ID: <CAAhSdy37xNOs3udMe4GuLJ3=huKD1bsHEO_RfUPvuMiVw56GCQ@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv for 5.16
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

As discussed on the KVM RISC-V v20 series thread, here's the first
KVM/riscv pull request for 5.16. This pull request has all patches of
the KVM RISC-V v20 series except PATCH1 which is available in the
shared tag "for-riscv" of the KVM tree.

Please pull.

Best Regards,
Anup

The following changes since commit 3f2401f47d29d669e2cb137709d10dd4c156a02f:

  RISC-V: Add hypervisor extension related CSR defines (2021-10-04
04:54:55 -0400)

are available in the Git repository at:

  git://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.16-1

for you to fetch changes up to 24b699d12c34cfc907de9fe3989a122b7b13391c:

  RISC-V: KVM: Add MAINTAINERS entry (2021-10-04 16:14:10 +0530)

----------------------------------------------------------------
Initial KVM RISC-V support

Following features are supported by the initial KVM RISC-V support:
1. No RISC-V specific KVM IOCTL
2. Loadable KVM RISC-V module
3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
4. Works on both RV64 and RV32 host
5. Full Guest/VM switch via vcpu_get/vcpu_put infrastructure
6. KVM ONE_REG interface for VCPU register access from KVM user-space
7. Interrupt controller emulation in KVM user-space
8. Timer and IPI emuation in kernel
9. Both Sv39x4 and Sv48x4 supported for RV64 host
10. MMU notifiers supported
11. Generic dirty log supported
12. FP lazy save/restore supported
13. SBI v0.1 emulation for Guest/VM
14. Forward unhandled SBI calls to KVM user-space
15. Hugepage support for Guest/VM
16. IOEVENTFD support for Vhost

----------------------------------------------------------------
Anup Patel (12):
      RISC-V: Add initial skeletal KVM support
      RISC-V: KVM: Implement VCPU create, init and destroy functions
      RISC-V: KVM: Implement VCPU interrupts and requests handling
      RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
      RISC-V: KVM: Implement VCPU world-switch
      RISC-V: KVM: Handle MMIO exits for VCPU
      RISC-V: KVM: Handle WFI exits for VCPU
      RISC-V: KVM: Implement VMID allocator
      RISC-V: KVM: Implement stage2 page table programming
      RISC-V: KVM: Implement MMU notifiers
      RISC-V: KVM: Document RISC-V specific parts of KVM API
      RISC-V: KVM: Add MAINTAINERS entry

Atish Patra (4):
      RISC-V: KVM: Add timer functionality
      RISC-V: KVM: FP lazy save/restore
      RISC-V: KVM: Implement ONE REG interface for FP registers
      RISC-V: KVM: Add SBI v0.1 support

 Documentation/virt/kvm/api.rst          | 193 ++++++++++++++++++++++++++--
 MAINTAINERS                             |  12 ++
 arch/riscv/Kconfig                      |   1 +
 arch/riscv/Makefile                     |   1 +
 arch/riscv/include/asm/kvm_host.h       | 266
++++++++++++++++++++++++++++++++++++++
 arch/riscv/include/asm/kvm_types.h      |   7 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |  44 +++++++
 arch/riscv/include/uapi/asm/kvm.h       | 128 ++++++++++++++++++
 arch/riscv/kernel/asm-offsets.c         | 156 ++++++++++++++++++++++
 arch/riscv/kvm/Kconfig                  |  36 ++++++
 arch/riscv/kvm/Makefile                 |  25 ++++
 arch/riscv/kvm/main.c                   | 118 +++++++++++++++++
 arch/riscv/kvm/mmu.c                    | 802
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/tlb.S                    |  74 +++++++++++
 arch/riscv/kvm/vcpu.c                   | 997
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c              | 701
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c               | 185 ++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_switch.S            | 400
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_timer.c             | 225 ++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vm.c                     |  97 ++++++++++++++
 arch/riscv/kvm/vmid.c                   | 120 +++++++++++++++++
 drivers/clocksource/timer-riscv.c       |   9 ++
 include/clocksource/timer-riscv.h       |  16 +++
 include/uapi/linux/kvm.h                |   8 ++
 24 files changed, 4612 insertions(+), 9 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_host.h
 create mode 100644 arch/riscv/include/asm/kvm_types.h
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/include/uapi/asm/kvm.h
 create mode 100644 arch/riscv/kvm/Kconfig
 create mode 100644 arch/riscv/kvm/Makefile
 create mode 100644 arch/riscv/kvm/main.c
 create mode 100644 arch/riscv/kvm/mmu.c
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vcpu.c
 create mode 100644 arch/riscv/kvm/vcpu_exit.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c
 create mode 100644 arch/riscv/kvm/vcpu_switch.S
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 arch/riscv/kvm/vm.c
 create mode 100644 arch/riscv/kvm/vmid.c
 create mode 100644 include/clocksource/timer-riscv.h
