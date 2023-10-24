Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D247D49B7
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbjJXIPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjJXHzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:55:24 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07BF122
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 00:55:22 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5ad5178d1bfso3052346a12.2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 00:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1698134122; x=1698738922; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o1OkbJmnnWIN+URdErn5nNacnovVGr3BkRnPR6Q0V5U=;
        b=O8K+DdLkZHdR7Fc5qp2H2pz+uipK/2SrQYSG8p3n2FOto+31ZGAzIEbPhU20yGvz13
         oqfPzV/Qc7OIWK5lTNYtnV5wmqd+al9Di7OGdwBdyDGF17dgnc0cE9nyPlH+cZBeS8Pb
         +i145TLJR/a9PDisZ7vXiMNGb7LHTIbPtfJG/XREwGP4/4LBEyx2GgdmS1TsJk46STHT
         iyBhXf0TjyDK+GecALRE9G6Vwah2Qr/hWqVrwXC/3f2mG9nQ1y54F28EkPAVwyorPQB1
         5daQUaB2ITax4EPhwZjkkXTMrmyvBGTkR6zdDvijNbyrYUzUPLRuOaSS7otdFule4K71
         hWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698134122; x=1698738922;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o1OkbJmnnWIN+URdErn5nNacnovVGr3BkRnPR6Q0V5U=;
        b=Zns0QKr3D4SR33a8hVok3MmvyV1IUKOeUt0AZd0SvvO6HxuVhVM+k+Domk8QquX4Tj
         iO+zFge40ctruBpbnPszD7YjKdW8eI0XvWHyjtQwMBZy1ffFUplDFIc8MirMyeEQqokg
         Pf/Z26tQyRndHAY2MOt2xfrbyJbYuhferTv0mcJ4CiyVHq0++XvLOsSh5Iei/dIP0TVt
         Hbwb/4/sqFqA0hMtmYhMNDUOrEfo7tL+QRjUPdA98g3XzH73q/IV9xyop+26wtCaH2aJ
         og1t3z6YqcdYby5LmH/qO6BhJfpzLeTEPIP0X+Gaay6VeJORbTuGkW1sl8A1cPk8z90P
         cY7w==
X-Gm-Message-State: AOJu0Yy0f8rkniNRT/Oc9B/v3/ip5W/M2iZjx+ePJ/ApLkwVXw23BRWN
        LYVBLWgOZ2advgeQPnPUCBTT76QHyb+ckUQWHI5iGEjGtfOX+KF5LAA=
X-Google-Smtp-Source: AGHT+IESe7yLkYn4jHtaeEJUILf4yttqOK3b1t5e2moa34SyCMsGt2bc8wSXfYGQfzjaQgUOGClTATr8/JZzduHM9YQ=
X-Received: by 2002:a05:6a20:729e:b0:15e:bb88:b76e with SMTP id
 o30-20020a056a20729e00b0015ebb88b76emr2006406pzk.14.1698134122184; Tue, 24
 Oct 2023 00:55:22 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 Oct 2023 13:25:10 +0530
Message-ID: <CAAhSdy2p0h8i=GPBx+=ZJVr_PSwOHhTqanJQmOc0O0bw1ffrmw@mail.gmail.com>
Subject: KVM/riscv changes for 6.7
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
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

We have the following KVM RISC-V changes for 6.7:
1) Smstateen and Zicond support for Guest/VM
2) Virtualized senvcfg CSR for Guest/VM
3) Added Smstateen registers to the get-reg-list selftests
4) Added Zicond to the get-reg-list selftests
5) Virtualized SBI debug console (DBCN) for Guest/VM
6) Added SBI debug console (DBCN) to the get-reg-list selftests

Please pull.

Please note that the following four patches are part of the
shared tag kvm-riscv-shared-tag-6.7 provided to Palmer:
 - dt-bindings: riscv: Add Zicond extension entry
 - RISC-V: Detect Zicond from ISA string
 - dt-bindings: riscv: Add smstateen entry
 - RISC-V: Detect Smstateen extension

Regards,
Anup

The following changes since commit 94f6f0550c625fab1f373bb86a6669b45e9748b3:

  Linux 6.6-rc5 (2023-10-08 13:49:43 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.7-1

for you to fetch changes up to d9c00f44e5de542340cce1d09e2c990e16c0ed3a:

  KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test
(2023-10-20 16:50:39 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.7

- Smstateen and Zicond support for Guest/VM
- Virtualized senvcfg CSR for Guest/VM
- Added Smstateen registers to the get-reg-list selftests
- Added Zicond to the get-reg-list selftests
- Virtualized SBI debug console (DBCN) for Guest/VM
- Added SBI debug console (DBCN) to the get-reg-list selftests

----------------------------------------------------------------
Andrew Jones (3):
      MAINTAINERS: RISC-V: KVM: Add another kselftests path
      KVM: selftests: Add array order helpers to riscv get-reg-list
      KVM: riscv: selftests: get-reg-list print_reg should never fail

Anup Patel (11):
      RISC-V: Detect Zicond from ISA string
      dt-bindings: riscv: Add Zicond extension entry
      RISC-V: KVM: Allow Zicond extension for Guest/VM
      KVM: riscv: selftests: Add senvcfg register to get-reg-list test
      KVM: riscv: selftests: Add smstateen registers to get-reg-list test
      KVM: riscv: selftests: Add condops extensions to get-reg-list test
      RISC-V: Add defines for SBI debug console extension
      RISC-V: KVM: Change the SBI specification version to v2.0
      RISC-V: KVM: Allow some SBI extensions to be disabled by default
      RISC-V: KVM: Forward SBI DBCN extension to user-space
      KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test

Mayuresh Chitale (7):
      RISC-V: Detect Smstateen extension
      dt-bindings: riscv: Add smstateen entry
      RISC-V: KVM: Add kvm_vcpu_config
      RISC-V: KVM: Enable Smstateen accesses
      RISCV: KVM: Add senvcfg context save/restore
      RISCV: KVM: Add sstateen0 context save/restore
      RISCV: KVM: Add sstateen0 to ONE_REG

 .../devicetree/bindings/riscv/extensions.yaml      |  12 ++
 MAINTAINERS                                        |   1 +
 arch/riscv/include/asm/csr.h                       |  18 ++
 arch/riscv/include/asm/hwcap.h                     |   2 +
 arch/riscv/include/asm/kvm_host.h                  |  18 ++
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   7 +-
 arch/riscv/include/asm/sbi.h                       |   7 +
 arch/riscv/include/uapi/asm/kvm.h                  |  12 ++
 arch/riscv/kernel/cpufeature.c                     |   2 +
 arch/riscv/kvm/vcpu.c                              |  76 +++++--
 arch/riscv/kvm/vcpu_onereg.c                       |  72 ++++++-
 arch/riscv/kvm/vcpu_sbi.c                          |  61 +++---
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  32 +++
 tools/testing/selftests/kvm/riscv/get-reg-list.c   | 233 +++++++++++++--------
 14 files changed, 418 insertions(+), 135 deletions(-)
