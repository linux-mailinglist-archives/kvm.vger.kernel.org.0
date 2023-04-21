Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915CD6EB09A
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbjDUReQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 13:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjDUReP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 13:34:15 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CFA5251
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:34:13 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a640c23a62f3a-953343581a4so270737666b.3
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1682098452; x=1684690452;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gmbHaAEPuU4oEmlAG224eV0NF90p/lDU8WXg7UgBfxs=;
        b=0Yf4QFtDYxApW8e+Npa8eclnh1VPHECPdGgPfNTV+QtqQajhKU+b5z/94b/0kjjMLO
         9jNHHye49I5lSjPgdZmti3vLwUqQcMJnmyh/k7xXfuVJE10F2oGKWSHY2vIV+kwa8+t7
         fAML1NpJB08gTXg/dasdPltO/cgah/Ls7Z5pUVlUFcVxGQkjmTyIr1nNUgLZZc3okHyY
         QXECeu32BbNB0dcFw81iIE0FZynz/mP4m1+JRBODA+gM7xc7GOzGrO4ONwx0ZbG/DmM4
         8DhlSRRP5Wfd0gAb2llDQJ61n6Bcb6dtzWtEzY/ZU5YWucTfG3tX0eGFlVl7S5AImlQn
         aY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682098452; x=1684690452;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gmbHaAEPuU4oEmlAG224eV0NF90p/lDU8WXg7UgBfxs=;
        b=FOjFYITFnyQVfRLaE7TBys57jCNa+4CKclV145PDytfrobg5gvit5Jh6i3s7Yr0e3C
         EwzhMofa4zGxz3Qa2Nz2lrhfJUHMDVHOOk+SzqczcHnBSWxdv169zyecE9+jTNk+WV6K
         PTiYViVwZatrnb7NKNN04loMgHPDt8KPvmMq2UWDDockLUOuF9bTwndyYTNklxikSTLe
         MEe8b0KhhcL2qCpUlPFVNgvz9nGSHzBdWQ3pimap/1aiqeg1/o3km91HIvOnzpXS6IeS
         76HzBgdLzISXKnpnzWw6wKkSNXFhhu62g87fQTJSCj1sR4vmCuo6yAlNjK6yCDQbVCYX
         Lf6w==
X-Gm-Message-State: AAQBX9cnlplja5ZVqbdOrej7ownWkBeHBMP4tj1fVTc3ihZVyZTiMCOe
        D3C6JxMO8jqiJU4Pi/ZI8K8onmq26oeLQwHHa9VRMw==
X-Google-Smtp-Source: AKy350ZyHJzBdNd9Rl58RWyYWoyAjvKclDuYlwqb0MZh+iKf0jW1tajFN5kR9NWZ4LTB8iD0kOx3hQ7QlL/dJY8wNHM=
X-Received: by 2002:a17:906:58c:b0:953:429e:fff6 with SMTP id
 12-20020a170906058c00b00953429efff6mr3148032ejn.51.1682098451946; Fri, 21 Apr
 2023 10:34:11 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 21 Apr 2023 23:04:00 +0530
Message-ID: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.4
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

We have the following KVM RISC-V changes for 6.4:
1) ONE_REG interface to enable/disable SBI extensions
2) Zbb extension for Guest/VM
3) AIA CSR virtualization
4) Few minor cleanups and fixes

Please pull.

Please note that the Zicboz series has been taken by
Palmer through the RISC-V tree which results in few
minor conflicts in the following files:
arch/riscv/include/asm/hwcap.h
arch/riscv/include/uapi/asm/kvm.h
arch/riscv/kernel/cpu.c
arch/riscv/kernel/cpufeature.c
arch/riscv/kvm/vcpu.c

I am not sure if a shared tag can make things easy
for you or Palmer.

Regards,
Anup

The following changes since commit 6a8f57ae2eb07ab39a6f0ccad60c760743051026:

  Linux 6.3-rc7 (2023-04-16 15:23:53 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.4-1

for you to fetch changes up to 2f4d58f7635aec014428e73ef6120c4d0377c430:

  RISC-V: KVM: Virtualize per-HART AIA CSRs (2023-04-21 18:10:27 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.4

- ONE_REG interface to enable/disable SBI extensions
- Zbb extension for Guest/VM
- AIA CSR virtualization

----------------------------------------------------------------
Andrew Jones (1):
      RISC-V: KVM: Alphabetize selects

Anup Patel (10):
      RISC-V: KVM: Add ONE_REG interface to enable/disable SBI extensions
      RISC-V: KVM: Allow Zbb extension for Guest/VM
      RISC-V: Add AIA related CSR defines
      RISC-V: Detect AIA CSRs from ISA string
      RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
      RISC-V: KVM: Initial skeletal support for AIA
      RISC-V: KVM: Implement subtype for CSR ONE_REG interface
      RISC-V: KVM: Add ONE_REG interface for AIA CSRs
      RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
      RISC-V: KVM: Virtualize per-HART AIA CSRs

David Matlack (1):
      KVM: RISC-V: Retry fault if vma_lookup() results become invalid

 arch/riscv/include/asm/csr.h          | 107 +++++++++-
 arch/riscv/include/asm/hwcap.h        |   8 +
 arch/riscv/include/asm/kvm_aia.h      | 127 +++++++++++
 arch/riscv/include/asm/kvm_host.h     |  14 +-
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
 arch/riscv/include/uapi/asm/kvm.h     |  51 ++++-
 arch/riscv/kernel/cpu.c               |   2 +
 arch/riscv/kernel/cpufeature.c        |   2 +
 arch/riscv/kvm/Kconfig                |  10 +-
 arch/riscv/kvm/Makefile               |   1 +
 arch/riscv/kvm/aia.c                  | 388 ++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/main.c                 |  22 +-
 arch/riscv/kvm/mmu.c                  |  28 ++-
 arch/riscv/kvm/vcpu.c                 | 194 +++++++++++++----
 arch/riscv/kvm/vcpu_insn.c            |   1 +
 arch/riscv/kvm/vcpu_sbi.c             | 247 ++++++++++++++++++++--
 arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
 arch/riscv/kvm/vm.c                   |   4 +
 arch/riscv/kvm/vmid.c                 |   4 +-
 19 files changed, 1129 insertions(+), 91 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia.h
 create mode 100644 arch/riscv/kvm/aia.c
