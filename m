Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C0268DF0C
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 18:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjBGRgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 12:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbjBGRgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 12:36:07 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09663A846
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 09:36:00 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hx15so44455990ejc.11
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 09:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BZ6y0HfdU+5U+iTOtrcJ4GxWnnDEHocKk/DZG1/+ooM=;
        b=TwzAwA2xXYZ/V6lNMp/SIYufRe4LwLnRoZESGvbDUn5HMDW4rguxJJMztGKAYjIk3o
         fG5Q87YAZYLElVMN9eEVvVnE/NCPzsjekAmPFPkOvVm3geVi4p6X8qk1yD27v2n4nGNI
         IXwR1ODRM1T5hiuZAeygXR//XQCc+d+f5D3iR7RCnG+W+Xs2nT6UOrVabyBUqW7eebOI
         kSPnLtV/qflRK/KW73RECl5KPD1uRhbhO9lltyFxaz64DrphZkSRpyy2566HwJ82sJRt
         bx0bM8qKCigg1JYhFI/YlU9kgCJuEUnPqfCgQqWC4AvqkNQR3R99nsSSd5XYyxhsuH2u
         57ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZ6y0HfdU+5U+iTOtrcJ4GxWnnDEHocKk/DZG1/+ooM=;
        b=3XCEXz8KK8SZk4BJZi7qhpQL4t2fJqni75jDsNC9w3xvaNk6t7DOAAW2hsxpUX0Omq
         o6zDYod2dhaDnxbHi9U5Hp4sZVeewMnVwz8AIzSfeyG+FVRzzVDqhC0oVKuM9IVGwWNb
         RvHJZotiKWchgUCZtOsJUSTd5YqzCKeqG+sAskAxaRRAhgpgyb2InqxTAmWAyJ5OhTqc
         4YW9bdbUJAXC/KgXjMegxjvmUJQxepSnoCOmBNPnvKufa2QOlfrrC0QoMb1b8u3a9Mig
         Pe8s4v4Z3gzseZrwlv+0/bqy/Nigg2cXJJRyno+aFMz5JZNudMfW8Z/KE7Ohf2KsP72k
         snVw==
X-Gm-Message-State: AO0yUKXSjFJIH+96huOmmB800ByXWl5g7zgSvONtMkq4h2z2QenXVV2f
        Y4vg/3xp102sRuQ0KJo8/Zg8k9SpVMKT/Ft7p1J4JQ==
X-Google-Smtp-Source: AK7set+1X+nDNSzXfWLcK/qx4Ts9Ui6/V+Vi26x3FAphUtadBkrkCKKfEKwMyQipsGnI8EZHnBdV0FsGtRhAhGiGk4Y=
X-Received: by 2002:a17:906:3ad1:b0:884:8380:20db with SMTP id
 z17-20020a1709063ad100b00884838020dbmr891330ejd.301.1675791359418; Tue, 07
 Feb 2023 09:35:59 -0800 (PST)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 7 Feb 2023 23:05:48 +0530
Message-ID: <CAAhSdy25NgCY23u=icRgcZpEZzNgJkyEN92KEVL8D-SvUwTBXg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.3
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

Hi Paolo,

We have the following KVM RISC-V changes for 6.3:
1) Fix wrong usage of PGDIR_SIZE to check page sizes
2) Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
3) Redirect illegal instruction traps to guest
4) SBI PMU support for guest

Please pull.

I will send another PR for 6.3 containing AIA CSR
virtualization after Palmer has sent his first PR for 6.3
so that I can resolve conflicts with arch/riscv changes.
I hope you are okay with this ??

Regards,
Anup

The following changes since commit 4ec5183ec48656cec489c49f989c508b68b518e3:

  Linux 6.2-rc7 (2023-02-05 13:13:28 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.3-1

for you to fetch changes up to c39cea6f38eefe356d64d0bc1e1f2267e282cdd3:

  RISC-V: KVM: Increment firmware pmu events (2023-02-07 20:36:08 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.3

- Fix wrong usage of PGDIR_SIZE to check page sizes
- Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
- Redirect illegal instruction traps to guest
- SBI PMU support for guest

----------------------------------------------------------------
Alexandre Ghiti (1):
      KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page sizes

Andy Chiu (1):
      RISC-V: KVM: Redirect illegal instruction traps to guest

Anup Patel (1):
      RISC-V: KVM: Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()

Atish Patra (14):
      perf: RISC-V: Define helper functions expose hpm counter width and count
      perf: RISC-V: Improve privilege mode filtering for perf
      RISC-V: Improve SBI PMU extension related definitions
      RISC-V: KVM: Define a probe function for SBI extension data structures
      RISC-V: KVM: Return correct code for hsm stop function
      RISC-V: KVM: Modify SBI extension handler to return SBI error code
      RISC-V: KVM: Add skeleton support for perf
      RISC-V: KVM: Add SBI PMU extension support
      RISC-V: KVM: Make PMU functionality depend on Sscofpmf
      RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
      RISC-V: KVM: Implement trap & emulate for hpmcounters
      RISC-V: KVM: Implement perf support without sampling
      RISC-V: KVM: Support firmware events
      RISC-V: KVM: Increment firmware pmu events

 arch/riscv/include/asm/kvm_host.h     |   4 +
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 107 ++++++
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  13 +-
 arch/riscv/include/asm/sbi.h          |   7 +-
 arch/riscv/kvm/Makefile               |   1 +
 arch/riscv/kvm/main.c                 |   3 +-
 arch/riscv/kvm/mmu.c                  |   8 +-
 arch/riscv/kvm/tlb.c                  |   4 +
 arch/riscv/kvm/vcpu.c                 |   7 +
 arch/riscv/kvm/vcpu_exit.c            |   9 +
 arch/riscv/kvm/vcpu_insn.c            |   4 +-
 arch/riscv/kvm/vcpu_pmu.c             | 633 ++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c             |  72 ++--
 arch/riscv/kvm/vcpu_sbi_base.c        |  27 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c         |  28 +-
 arch/riscv/kvm/vcpu_sbi_pmu.c         |  86 +++++
 arch/riscv/kvm/vcpu_sbi_replace.c     |  50 +--
 arch/riscv/kvm/vcpu_sbi_v01.c         |  17 +-
 drivers/perf/riscv_pmu_sbi.c          |  64 +++-
 include/linux/perf/riscv_pmu.h        |   5 +
 20 files changed, 1035 insertions(+), 114 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
 create mode 100644 arch/riscv/kvm/vcpu_pmu.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
