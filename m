Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F093373A2BD
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 16:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjFVONm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 10:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjFVONi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 10:13:38 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C891BC1
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 07:13:30 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51a2c8e5a2cso9431608a12.2
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 07:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1687443209; x=1690035209;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aQFOxP/qlNJ8W5hzFaJcpbihIuSxzcIRByRUct5kWzk=;
        b=20LM5jzrEzSqUNc1jEJer0iCv9FzPlX2xvy8IgY9C+XWT2+ShvQ7I7EY02qR+8l6xA
         9UOBdpTOwPKUoN/XIF7IFHeZxWC4RWhWhGTR8uJn5h+zX394ImVqAA3ySKNoAIciad6Z
         MwUBnqVoHhnjLDMFSCq8Z2rouhjl8LpVwW4IKLQYlT8Vfh12Pl+UOag0hTtetXuuU9sS
         4kewOYNeMoV05aI/apgRu+H/GebQ/ISBJ4jXQE3NZFpR1FX7gkGKhrsMAiLkbKY/B/qP
         L85ak/gw9yTkh1lqc7oXs7gaF4R+RnKBCfu9vmJuFfnrO8J5JbG67yWa/8F/uImqRFJA
         txKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687443209; x=1690035209;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQFOxP/qlNJ8W5hzFaJcpbihIuSxzcIRByRUct5kWzk=;
        b=N2V58eHirksnX/HZCUZ1R7qySU2H+APJ0PHrIlUMITPebrueMfxACPWAthMqp2RDj/
         Ym561/Z/jE1he53h96dM+ik8wKhP9nzJrGS2iFZa3Jfvn6K7PA76rOUDlsCn02lagHyQ
         QZZXBoHoqimr5VO+ozrcyVXf+Erhx6k5xq0TfEo/7VHVAxQkg5HLEnI1CmPowxY4NUjD
         l+qONia+mwJUe1h1NcLpkdGtQeS3P7LkFSG3l9q2pIVcJZ2syVEZ1Ut+DGCW/Rc3txuz
         t7GORxb6ZKPsOYgEXLnKBwFntyTUJrZJ0qRM3zQRlwk8JORVNUIhNWlw+SDQAQa1EdEP
         OBYw==
X-Gm-Message-State: AC+VfDzk+qDT8ng2CQNsFcF9G681Bf/YzUbAp473wxRHS9cxr2oTZ/ez
        slWDgCx7hySXmbQ7+Eq/mTqHM+NsGt7hcx7UvLQEDg==
X-Google-Smtp-Source: ACHHUZ7qaE0X8VXjp7N7KADuvhsxpRq8hc8/FAQKrIA6SOk+wqkQRIBrFhuGIYRkwq5+A/Sktq0T8tk3Cq8fl8mjvbY=
X-Received: by 2002:a50:fb91:0:b0:51b:cb7c:7f97 with SMTP id
 e17-20020a50fb91000000b0051bcb7c7f97mr5567517edq.29.1687443209328; Thu, 22
 Jun 2023 07:13:29 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 22 Jun 2023 19:43:17 +0530
Message-ID: <CAAhSdy1iT=SbjSvv_7SDygSo0HhmgLjD-y+DU1_Q+6tnki7w+A@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.5
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

We have the following KVM RISC-V changes for 6.5:
1) Redirect AMO load/store misaligned traps to KVM guest
2) Trap-n-emulate AIA in-kernel irqchip for KVM guest
3) Svnapot support for KVM Guest

Please pull.

Please note that there is a minor conflict with the RISC-V
tree in the arch/riscv/include/uapi/asm/kvm.h header due to
KVM vector virtualization going through the RISC-V tree.

Regards,
Anup

The following changes since commit 9561de3a55bed6bdd44a12820ba81ec416e705a7:

  Linux 6.4-rc5 (2023-06-04 14:04:27 -0400)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.5-1

for you to fetch changes up to 07f225b5842420ae9c18cba17873fc71ed69c28e:

  RISC-V: KVM: Remove unneeded semicolon (2023-06-20 10:48:38 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.5

- Redirect AMO load/store misaligned traps to KVM guest
- Trap-n-emulate AIA in-kernel irqchip for KVM guest
- Svnapot support for KVM Guest

----------------------------------------------------------------
Andrew Jones (3):
      RISC-V: KVM: Rename dis_idx to ext_idx
      RISC-V: KVM: Convert extension_disabled[] to ext_status[]
      RISC-V: KVM: Probe for SBI extension status

Anup Patel (11):
      RISC-V: KVM: Implement guest external interrupt line management
      RISC-V: KVM: Add IMSIC related defines
      RISC-V: KVM: Add APLIC related defines
      RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
      RISC-V: KVM: Skeletal in-kernel AIA irqchip support
      RISC-V: KVM: Implement device interface for AIA irqchip
      RISC-V: KVM: Add in-kernel emulation of AIA APLIC
      RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
      RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC
      RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip
      RISC-V: KVM: Allow Svnapot extension for Guest/VM

Ben Dooks (1):
      riscv: kvm: define vcpu_sbi_ext_pmu in header

Yang Li (1):
      RISC-V: KVM: Remove unneeded semicolon

Ye Xingchen (1):
      RISC-V: KVM: use bitmap_zero() API

wchen (1):
      RISC-V: KVM: Redirect AMO load/store misaligned traps to guest

 arch/riscv/include/asm/csr.h           |    2 +
 arch/riscv/include/asm/kvm_aia.h       |  107 +++-
 arch/riscv/include/asm/kvm_aia_aplic.h |   58 ++
 arch/riscv/include/asm/kvm_aia_imsic.h |   38 ++
 arch/riscv/include/asm/kvm_host.h      |    4 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h  |   11 +-
 arch/riscv/include/uapi/asm/kvm.h      |   73 +++
 arch/riscv/kvm/Kconfig                 |    4 +
 arch/riscv/kvm/Makefile                |    3 +
 arch/riscv/kvm/aia.c                   |  274 +++++++-
 arch/riscv/kvm/aia_aplic.c             |  619 ++++++++++++++++++
 arch/riscv/kvm/aia_device.c            |  673 ++++++++++++++++++++
 arch/riscv/kvm/aia_imsic.c             | 1084 ++++++++++++++++++++++++++++++++
 arch/riscv/kvm/main.c                  |    3 +-
 arch/riscv/kvm/tlb.c                   |    2 +-
 arch/riscv/kvm/vcpu.c                  |    4 +
 arch/riscv/kvm/vcpu_exit.c             |    2 +
 arch/riscv/kvm/vcpu_sbi.c              |   80 ++-
 arch/riscv/kvm/vm.c                    |  118 ++++
 include/uapi/linux/kvm.h               |    2 +
 20 files changed, 3100 insertions(+), 61 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
 create mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
 create mode 100644 arch/riscv/kvm/aia_aplic.c
 create mode 100644 arch/riscv/kvm/aia_device.c
 create mode 100644 arch/riscv/kvm/aia_imsic.c
