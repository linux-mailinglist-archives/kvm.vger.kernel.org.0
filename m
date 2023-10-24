Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7216B7D4926
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjJXH6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjJXH6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:58:30 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B073BF9
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 00:58:28 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6b1ef786b7fso3984142b3a.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 00:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1698134307; x=1698739107; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o1OkbJmnnWIN+URdErn5nNacnovVGr3BkRnPR6Q0V5U=;
        b=OMRE2IqRBbw25zNawQnNgPYMGyOHVpjZUd09goHOHuk4PhhLG8BSXjUhAyAyY+8sb5
         fEG2R9CvSrmAATDwRofIhVsSOKYAbzRiTWTK0T5fzOGWAxM0IU+9uock1GluL5cBxXHu
         b/DC3PK10utkHsQHQtHdSpROzVMceraktf9fze0f2olNUd+TXLI3NE4ruAoPDbTFg32F
         6wm0jNNN2QHfDIjVFOBKYEuWc27e/ti7oKBxymyz4z8xwNLqL9aKIJK40o2Vib7COe1v
         88u5oXmvSFhkBLA8fHp9IbTXgX/Ce8GEvazjthhAmQ9iYliNUwwCfwJaHI6RRQuBhcAZ
         GcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698134307; x=1698739107;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o1OkbJmnnWIN+URdErn5nNacnovVGr3BkRnPR6Q0V5U=;
        b=WAc8bi4sjA4oVDVBpW0viVARWj8yhq1Sqw/vMDvfQ/i9JiHduKXlDE5uqjUc2Q07at
         nET/0OvO7sZ2S+dDsmVLTO9Odd443ieqLgtX3wPcbKNjR6OkJgHcSuyUbmjieZTKHcr3
         VDn6MIlkLou2AfvtqbYEEjhHTWjOvXtd3tdMU/w5Un7bnr0YdZH8waE+lACeNgiBVlpd
         uONSA/hnwpegDkQekd0ssA49qLsAPh+zT7Yp1l6eVXda+cyaMWjNDfKnDBvAacEEXTAh
         biHD5AOs1xEI1BVf6uC3mb1mBhk/+tqPEgKM576v6EgNV6nwGuLCe4ZVXPS8EPNeeFGb
         i72A==
X-Gm-Message-State: AOJu0Yx/8UVd4uwbKmHFOhHZIw7tu0ynAD/JI1XsG1FoqIlzEMTSXNNi
        i0DEnnv0CVgQR9l5qSO9n7BGFs1jVIxi1RMvtGEg7A==
X-Google-Smtp-Source: AGHT+IHujAxpgpw9wbNA1CwPmU/3W4N3q9iKAKZQRIibVXnvzF07J1tET+EdvVoKB8bEcR5UPxiBOjyMzWn8TUledPg=
X-Received: by 2002:a05:6a20:6a1d:b0:14d:f41c:435a with SMTP id
 p29-20020a056a206a1d00b0014df41c435amr2038421pzk.39.1698134307067; Tue, 24
 Oct 2023 00:58:27 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 Oct 2023 13:28:16 +0530
Message-ID: <CAAhSdy2dg61z7=vsrOqwxHoV1GBvaAzcdUY4o6pLmTNM0WV5ig@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.7
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
