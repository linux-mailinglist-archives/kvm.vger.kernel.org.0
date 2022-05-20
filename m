Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8497C52E3FE
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 06:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiETEpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 00:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiETEpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 00:45:53 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1955013E94
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 21:45:50 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t6so9854953wra.4
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 21:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=plxhMmUf+EvrQhTteZUdGqmGsuCJiqfW555AYN0K1E0=;
        b=rHGeIWEiwBE+lSiR4XwwNpQnDwaCBZYNHDs8N6RWS/7S5MICOMEcgkGeRFHDCI6lxL
         44V/nfAUvhDw1LX3+6DWiWH9cGED7wKMjQIfN1bn3XnTRL65I5d3M6ekdZYwdZycu8ex
         c2FxE8futNYQbMqcJv57mK7n0xOyviklalXZN44ICgvtc0rQRcYHhV1nV4u3RuPd5m6f
         bnEV4AqGSpOucEwLBVI2QVlWzelZKCzWi3rkl+YTmlumPQ3IRpvrtkaq3DeSlllxPgWh
         Fn+YDaR7KEUpEtOV0HcsxgMcEo+7aoGYt1yZe/SR8XxUT2mNhzehF2db/feGmSJ7FBW+
         IxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=plxhMmUf+EvrQhTteZUdGqmGsuCJiqfW555AYN0K1E0=;
        b=ZuFmNwe/9FF3oSCcT2CRX7yL782frotZJ4yljLm4olRnaSc3TuzwXWMFbKuzrMVmDd
         P1ru3R5a50GztqnIqLQHRcdZTJHkQ7/00EyejgE7TKrSMGR6hph7g557S3o1TQIvl8cR
         l+iLV8QTysT4G2AIADtVdbBx1R9N1BuF+jdYB4KKLUsQZMqPg0/WeJ7lCXpYtLsGrnNr
         RfS3t98wUgf/lHkYSxttz/g9WZCS9dYufcdFNvupcEjA/Wpoz41x3Ce4iGk9LdusxtHu
         Ar3N1HxgHuRIN3Tu16xpUHbP2LUHOTbYSrWek+6Ll1Fh1zRwXcNilW6Dy+BNRJdZH5oD
         H6nQ==
X-Gm-Message-State: AOAM531ySrwa/BrqLzGXrW2riXH4Jg0HvJZWWCQlIPqXFfzyFsBaxGW9
        xVRVq1CDkZMdl4kw0Fq7TMqIcykRtf6qtgfpqvzk7aTWoASGIsNd
X-Google-Smtp-Source: ABdhPJzy+GKWYDBgcDFKUOV5Waak21QZOZ8G+R+J87v2HPAdDTSuBDirrSw9Atr+eB+n9M5ag7h6sd+pwLb20DNuOm8=
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id
 r11-20020a5d6c6b000000b001ea77eadde8mr6655051wrz.690.1653021948566; Thu, 19
 May 2022 21:45:48 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 20 May 2022 10:15:36 +0530
Message-ID: <CAAhSdy0V3RziZOXe2UMfpAxmTYn1XpJJTQe5q2FdrmU_3zH+sQ@mail.gmail.com>
Subject: KVM/riscv changes for 5.19
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
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

We have following KVM RISC-V changes for 5.19:
1) Added Sv57x4 support for G-stage page table
2) Added range based local HFENCE functions
3) Added remote HFENCE functions based on VCPU requests
4) Added ISA extension registers in ONE_REG interface
5) Updated KVM RISC-V maintainers entry to cover selftests support

I don't expect any other KVM RISC-V changes for 5.19.

Please pull.

Regards,
Anup

The following changes since commit 42226c989789d8da4af1de0c31070c96726d990c:

  Linux 5.18-rc7 (2022-05-15 18:08:58 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.19-1

for you to fetch changes up to fed9b26b2501ea0ce41ae3a788bcc498440589c6:

  MAINTAINERS: Update KVM RISC-V entry to cover selftests support
(2022-05-20 09:09:23 +0530)

----------------------------------------------------------------
KVM/riscv changes for 5.19

- Added Sv57x4 support for G-stage page table
- Added range based local HFENCE functions
- Added remote HFENCE functions based on VCPU requests
- Added ISA extension registers in ONE_REG interface
- Updated KVM RISC-V maintainers entry to cover selftests support

----------------------------------------------------------------
Anup Patel (9):
      KVM: selftests: riscv: Improve unexpected guest trap handling
      RISC-V: KVM: Use G-stage name for hypervisor page table
      RISC-V: KVM: Add Sv57x4 mode support for G-stage
      RISC-V: KVM: Treat SBI HFENCE calls as NOPs
      RISC-V: KVM: Introduce range based local HFENCE functions
      RISC-V: KVM: Reduce KVM_MAX_VCPUS value
      RISC-V: KVM: Add remote HFENCE functions based on VCPU requests
      RISC-V: KVM: Cleanup stale TLB entries when host CPU changes
      MAINTAINERS: Update KVM RISC-V entry to cover selftests support

Atish Patra (1):
      RISC-V: KVM: Introduce ISA extension register

Jiapeng Chong (1):
      KVM: selftests: riscv: Remove unneeded semicolon

 MAINTAINERS                                        |   2 +
 arch/riscv/include/asm/csr.h                       |   1 +
 arch/riscv/include/asm/kvm_host.h                  | 124 +++++-
 arch/riscv/include/uapi/asm/kvm.h                  |  20 +
 arch/riscv/kvm/main.c                              |  11 +-
 arch/riscv/kvm/mmu.c                               | 264 ++++++------
 arch/riscv/kvm/tlb.S                               |  74 ----
 arch/riscv/kvm/tlb.c                               | 461 +++++++++++++++++++++
 arch/riscv/kvm/vcpu.c                              | 144 ++++++-
 arch/riscv/kvm/vcpu_exit.c                         |   6 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  40 +-
 arch/riscv/kvm/vcpu_sbi_v01.c                      |  35 +-
 arch/riscv/kvm/vm.c                                |   8 +-
 arch/riscv/kvm/vmid.c                              |  30 +-
 .../selftests/kvm/include/riscv/processor.h        |   8 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  11 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |  31 +-
 17 files changed, 965 insertions(+), 305 deletions(-)
 delete mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/tlb.c
