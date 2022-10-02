Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2075F2176
	for <lists+kvm@lfdr.de>; Sun,  2 Oct 2022 07:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJBFql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Oct 2022 01:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBFqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Oct 2022 01:46:38 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8C63AB24
        for <kvm@vger.kernel.org>; Sat,  1 Oct 2022 22:46:37 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a26so16444042ejc.4
        for <kvm@vger.kernel.org>; Sat, 01 Oct 2022 22:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=GrhlWqAeelXfFuousvZL4+uQTtUeskpuRrDHgcNrsFk=;
        b=XjJpKVPBIKlwhYhRUPpz9eY8Ka60DUW/QLjuULsbSKCtTlOmI948XHWtlCrP8yRQHL
         SfqmahZAzqeGgQfVjj8fsuVnGg6cIV2NIj5dk/+sQgOJHycIYxjj4VN/jTqVdFE0Uuc6
         CEXhLUDLFA8SbPkuJTw/hrCrey9XCgAPdOjI35jAEluH8Tf0DJW1TmmSH+onuX+NYviP
         J6V1Dou2xcGGGQqfCO7tpLpo5u5xJHOQxs+XfeWrUCAmrSdhnKja6ukJo04ozb2JbNXB
         o+QdZClYuVoA7IrF1j6mSN+Cegh8P69f0LHforGdryusyVioIp+N5UZVkyjha+Msn0Yt
         5luQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=GrhlWqAeelXfFuousvZL4+uQTtUeskpuRrDHgcNrsFk=;
        b=zs5csSLl++PRZywIFoKWjx/FAuvafkl8U+sAOJarn8xWlawv51ddR/x4VpnMElTmmE
         wkPIvBGlTCGQnpvc08hAUXzwdBp07q3Zg5zSoCaDc5qo7IHeTkf8Aifr2B+Vt5Jn5FSy
         aGpViRJLd1eVQDkldq0s25QJy6w9FfVuDlLhZutVgy+qlVQHZvlJg/vhtbUbFYZPpj0d
         auYwoSBGmk2mo8PIh98JMM02po0S8Drl+uVf7p8WPzTDY/dXSOyk2LDI+c/huC5A/f9U
         eDCiFkb3FofVsQOpI7ct5nm9MLImIdk0Bf0seAHnIAZz8tj4y4L58dRNWH+4DiTANPoC
         qP4g==
X-Gm-Message-State: ACrzQf3sYO7bFL4fc3q7S5+23kRlmPsuz4nwtFmF6CkkI5/Stxx99A/8
        IQYyZDtYd+6jlvkoJS6botCEc6gcj8pH2Rlw06eFYQ==
X-Google-Smtp-Source: AMsMyM6D693fA/UMqz9ykh3+TeK8rgLMRoHflKIaijjN8Mr9HIz1/kbi4Ju0H1KDsquIqzXaUJzgKT8CYyFMZYNBkjA=
X-Received: by 2002:a17:906:dac8:b0:741:545b:796a with SMTP id
 xi8-20020a170906dac800b00741545b796amr11184738ejb.240.1664689595859; Sat, 01
 Oct 2022 22:46:35 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 2 Oct 2022 11:16:24 +0530
Message-ID: <CAAhSdy134Ve1mbeK+TNRx-pWpQ=nVzNLptDcUyPaDU4v18Qyaw@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.1
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

We have the following KVM RISC-V changes for 6.1:
1) Improved instruction encoding infrastructure for
    instructions not yet supported by binutils
2) Svinval support for both KVM Host and KVM Guest
3) Zihintpause support for KVM Guest
4) Zicbom support for KVM Guest
5) Record number of signal exits as a VCPU stat
6) Use generic guest entry infrastructure

Please pull.

Regards,
Anup

The following changes since commit f76349cf41451c5c42a99f18a9163377e4b364ff:

  Linux 6.0-rc7 (2022-09-25 14:01:02 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.1-1

for you to fetch changes up to b60ca69715fcc39a5f4bdd56ca2ea691b7358455:

  riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK (2022-10-02 10:19:31 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.1

- Improved instruction encoding infrastructure for
  instructions not yet supported by binutils
- Svinval support for both KVM Host and KVM Guest
- Zihintpause support for KVM Guest
- Zicbom support for KVM Guest
- Record number of signal exits as a VCPU stat
- Use generic guest entry infrastructure

----------------------------------------------------------------
Andrew Jones (7):
      riscv: Add X register names to gpr-nums
      riscv: Introduce support for defining instructions
      riscv: KVM: Apply insn-def to hfence encodings
      riscv: KVM: Apply insn-def to hlv encodings
      RISC-V: KVM: Make ISA ext mappings explicit
      RISC-V: KVM: Provide UAPI for Zicbom block size
      RISC-V: KVM: Expose Zicbom to the guest

Anup Patel (3):
      RISC-V: KVM: Change the SBI specification version to v1.0
      RISC-V: KVM: Use Svinval for local TLB maintenance when available
      RISC-V: KVM: Allow Guest use Svinval extension

Jisheng Zhang (3):
      RISC-V: KVM: Record number of signal exits as a vCPU stat
      RISC-V: KVM: Use generic guest entry infrastructure
      riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK

Mayuresh Chitale (2):
      RISC-V: Probe Svinval extension form ISA string
      RISC-V: KVM: Allow Guest use Zihintpause extension

Xiu Jianfeng (1):
      RISC-V: KVM: add __init annotation to riscv_kvm_init()

 arch/riscv/Kconfig                    |   4 +
 arch/riscv/include/asm/gpr-num.h      |   8 ++
 arch/riscv/include/asm/hwcap.h        |   4 +
 arch/riscv/include/asm/insn-def.h     | 137 ++++++++++++++++++++++++++++++
 arch/riscv/include/asm/kvm_host.h     |   1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   4 +-
 arch/riscv/include/uapi/asm/kvm.h     |   4 +
 arch/riscv/kernel/cpu.c               |   1 +
 arch/riscv/kernel/cpufeature.c        |   1 +
 arch/riscv/kvm/Kconfig                |   1 +
 arch/riscv/kvm/main.c                 |   2 +-
 arch/riscv/kvm/tlb.c                  | 155 +++++++++++-----------------------
 arch/riscv/kvm/vcpu.c                 |  60 ++++++++-----
 arch/riscv/kvm/vcpu_exit.c            |  39 ++-------
 arch/riscv/mm/dma-noncoherent.c       |   2 +
 15 files changed, 260 insertions(+), 163 deletions(-)
 create mode 100644 arch/riscv/include/asm/insn-def.h
