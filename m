Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E9F52E3FF
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 06:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbiETEsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 00:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiETEso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 00:48:44 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E7C13C0A8
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 21:48:42 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id v191-20020a1cacc8000000b00397001398c0so6134789wme.5
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 21:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=plxhMmUf+EvrQhTteZUdGqmGsuCJiqfW555AYN0K1E0=;
        b=unSzjMkf5QFwC8NcjB+EBDJVjpaXKKYE3Od5nIKx5fhHptk9QdmyI0NuFU0+ZSoPWp
         RWuOSGhmhKcQeMvvi78ODu1fTPrmQIBbRDJzOeE/2QnHP1XlL+sio0HQSIUBnuO5cUPP
         tNRO4kMrMtJEXWAQph71C2elgA+8YB+b9G9gBJgMdVDLWo64+bWFdZVWLUsceX25e+Uy
         0fxMBbAfxY6Dan7iMEecB45fedgB0f1DR66Lt1cDMaVJjTzjrrKMp6FgpCthh+2OREvA
         5dh1ZN4heEMR06j/hdVdtkcq+hJ2G0nMMLu1OfyaK1TewMptRT+AZNX/ntgbWyqmhD3j
         6rnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=plxhMmUf+EvrQhTteZUdGqmGsuCJiqfW555AYN0K1E0=;
        b=l8rcNnLY5S2EpwMxyAe3/lWpRKDsznjA/f9LGkm6CNx7sbHSvCKLVm5IrsJiL5HRrt
         053EWutDwi1ufkSm6tgd7gNLm1cinfxswpC3tSKWa6t2Wr+XppEnaQBC37QGWjF3Vcds
         ZNpuWKtrW37QDIUXR3a5vISb0tpELx7spV/A5PwWDfa6VUiJEmK1gUiTdD9EmvjNCW2p
         Z0Rg6YSTP7VKqw7mce3hiKytNVrgenBFovyytMFZl+Hxahq2CmJOP0Z9cLFIsoL+YtnP
         AKfR1ju7kO+f5xZBbLZe0oVuyiGK5bCrRwZ08ScnZxpFrwKZBNysTP2d1OIxbrkPy/OK
         +1gw==
X-Gm-Message-State: AOAM530g81yyEZ+cypbPtA45h7l9U8iIczqAG8tpIHFJMlLUsIS7uPPr
        TDL9omKp3/z5BLGAK9efQ1hO98U1a8uT1NCDlAxSOA==
X-Google-Smtp-Source: ABdhPJykE5sa+XllxwxbmsoQly/lZ3QV+g8Z2JdvJ5RxXL4OGzl2J0gatnl2iyCrwOqF/qmQRR67GWUuYMhnl+uhZ1U=
X-Received: by 2002:a05:600c:4fd5:b0:394:55ae:32c7 with SMTP id
 o21-20020a05600c4fd500b0039455ae32c7mr7105025wmq.73.1653022121217; Thu, 19
 May 2022 21:48:41 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 20 May 2022 10:18:29 +0530
Message-ID: <CAAhSdy1DUJa=5YxbV_u0B=NLaTJrW03PbLxegJ2oCWDeWqy=zw@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 5.19
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
