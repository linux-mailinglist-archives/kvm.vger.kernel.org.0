Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FAE48652C
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 14:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiAFNVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 08:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbiAFNVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 08:21:17 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68380C061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 05:21:17 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id f134-20020a1c1f8c000000b00345c05bc12dso1170141wmf.3
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 05:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FEwZHSoug1dOrMofJocJDbwU7ylidc8yair4c5/4LYw=;
        b=NLNA5+yeGoQdZTDSUOpDkZHMxhAP4Hu5s1d9oVzz5nsPOgkJbQ+qJh/bo7pITC+lxL
         YKh1kKhrNNlbR6DWRNiq21ZjW8k2g+CLc+PmQTNRWWFeGqr2ZYpHmwVR8rlT2yt+jXUB
         OdTXt7nvm6W3R3+J7g+4so5ZxGdf8nD4IeOwMgDma1cANLDwYaQ6KXluKo9zbDNhAK/f
         JWeY23zRtB6iWB2yfG0K8718jwgJb+5T+8+Uxp58OfH2bbSUjs6TeCQWUrMO9JuTzV6p
         EL8+46oN7UWo5rVvTrkYPvRmqukT8ze4fTdQEetqztKRarTm7aZtIZxoDYgAIU/CTH6d
         ljMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FEwZHSoug1dOrMofJocJDbwU7ylidc8yair4c5/4LYw=;
        b=PG2ZPG/hoRcXzuUpQ3ifTe1TqyDCzCAe5qGYsCg/AXJOdynzNE8rTeUdnDSUCkZqt6
         xJB7p0bpdkZInz/t+I/m4jL5zFfYc9VK45NXLpKZFVdX3u/tr/w1NRtJ1T63D3a9OJIp
         H1VJspxLOjrZBcji2gN/wVjVXNV3tteaDpeiHNUfGiHhZmZw3Av6cV2PyYRoj8D0t9EG
         e/THlG3OJrThj+GZXvTLfUp+63i+Vu1XKaEU2tMF5aYXL9p1jn9BFnTYll3MzGHYuhZM
         hln9DBye7NLJ1jf7sf8VOHQZ+XrVaYqfr1DFrm6Z1Ta6KxSOabr+DJr6HTMrd6jMRhIR
         cuiQ==
X-Gm-Message-State: AOAM532hp7Zmgbh/eQTA+toL+RIxatk/6Jkf603df+sm26MxoP3MYNo0
        OEXNG5m07vXzBYzjurzhvroDlBfPzNueSd4iriLy0g==
X-Google-Smtp-Source: ABdhPJyuYQg1E3xaLQAzjA28pfA0Ql48QdtnO98R1CYhsbt3qG+WFpFm5mAkWZtL9VPRSUcSleT2ahd6Nc3dJaKWr8o=
X-Received: by 2002:a05:600c:3d8e:: with SMTP id bi14mr7006042wmb.137.1641475275727;
 Thu, 06 Jan 2022 05:21:15 -0800 (PST)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 6 Jan 2022 18:51:01 +0530
Message-ID: <CAAhSdy2iRgCBt=6t2p5AE_Rq18s2QcRoM62ZAGiAcn5A6TfB4w@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 5.17, take #1
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Palao,

This is the first set of changes for 5.17. We have two new
features for KVM RISC-V:
1) SBI v0.2 support and
2) Initial kvm selftest support.

Please pull.

Regards,
Anup

The following changes since commit 5e4e84f1124aa02643833b7ea40abd5a8e964388:

  Merge tag 'kvm-s390-next-5.17-1' of
git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
(2021-12-21 12:59:53 -0500)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.17-1

for you to fetch changes up to 497685f2c743f552ec5626d60fc12e7c00faaf06:

  MAINTAINERS: Update Anup's email address (2022-01-06 15:18:22 +0530)

----------------------------------------------------------------
KVM/riscv changes for 5.17, take #1

- Use common KVM implementation of MMU memory caches
- SBI v0.2 support for Guest
- Initial KVM selftests support
- Fix to avoid spurious virtual interrupts after clearing hideleg CSR
- Update email address for Anup and Atish

----------------------------------------------------------------
Anup Patel (5):
      RISC-V: KVM: Forward SBI experimental and vendor extensions
      RISC-V: KVM: Add VM capability to allow userspace get GPA bits
      KVM: selftests: Add EXTRA_CFLAGS in top-level Makefile
      KVM: selftests: Add initial support for RISC-V 64-bit
      MAINTAINERS: Update Anup's email address

Atish Patra (6):
      RISC-V: KVM: Mark the existing SBI implementation as v0.1
      RISC-V: KVM: Reorganize SBI code by moving SBI v0.1 to its own file
      RISC-V: KVM: Add SBI v0.2 base extension
      RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2
      RISC-V: KVM: Add SBI HSM extension in KVM
      MAINTAINERS: Update Atish's email address

Jisheng Zhang (1):
      RISC-V: KVM: make kvm_riscv_vcpu_fp_clean() static

Sean Christopherson (1):
      KVM: RISC-V: Use common KVM implementation of MMU memory caches

Vincent Chen (1):
      KVM: RISC-V: Avoid spurious virtual interrupts after clearing hideleg CSR

 .mailmap                                           |   2 +
 MAINTAINERS                                        |   4 +-
 arch/riscv/include/asm/kvm_host.h                  |  11 +-
 arch/riscv/include/asm/kvm_types.h                 |   2 +-
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  33 ++
 arch/riscv/include/asm/sbi.h                       |   9 +
 arch/riscv/kvm/Makefile                            |   4 +
 arch/riscv/kvm/main.c                              |   8 +
 arch/riscv/kvm/mmu.c                               |  71 +---
 arch/riscv/kvm/vcpu.c                              |  28 +-
 arch/riscv/kvm/vcpu_fp.c                           |   2 +-
 arch/riscv/kvm/vcpu_sbi.c                          | 213 ++++++------
 arch/riscv/kvm/vcpu_sbi_base.c                     |  99 ++++++
 arch/riscv/kvm/vcpu_sbi_hsm.c                      | 105 ++++++
 arch/riscv/kvm/vcpu_sbi_replace.c                  | 135 ++++++++
 arch/riscv/kvm/vcpu_sbi_v01.c                      | 126 +++++++
 arch/riscv/kvm/vm.c                                |   3 +
 include/uapi/linux/kvm.h                           |   1 +
 tools/testing/selftests/kvm/Makefile               |  14 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |  10 +
 .../selftests/kvm/include/riscv/processor.h        | 135 ++++++++
 tools/testing/selftests/kvm/lib/guest_modes.c      |  10 +
 tools/testing/selftests/kvm/lib/riscv/processor.c  | 362 +++++++++++++++++++++
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |  87 +++++
 24 files changed, 1291 insertions(+), 183 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
 create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi_v01.c
 create mode 100644 tools/testing/selftests/kvm/include/riscv/processor.h
 create mode 100644 tools/testing/selftests/kvm/lib/riscv/processor.c
 create mode 100644 tools/testing/selftests/kvm/lib/riscv/ucall.c
