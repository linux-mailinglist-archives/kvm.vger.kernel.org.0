Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BA14D671B
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350073AbiCKREh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350593AbiCKREb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:04:31 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCC8108BF2
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:03:24 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id q14so13903502wrc.4
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Z2RgviTYIZSAoeoSoZxGUfnoAr9FmSUYXi9nHDkZWgY=;
        b=cLEKknK0f96mkMugQvjuNQuHilpDZVA8Slm6pVfk7JDYDMWePNqvPJ+e1x/2yYbw/5
         RBHUmhWhoZW/bT1gfKrDZ3haGmfU27uJU9TqXumQOmWQqijGLt/3lMSkTDQtMJg9ujXt
         +sqHBx9RJRkMfeTM5Z5OSlr6d3qTVKK23gqaofyLBeKAJtuv6ABWFoZ76zkvWWg4tUSa
         YjSPW2uF0BQSe+JT45LeGHnmsx+HFilOI7/pJLD3TpXPxre7Wz+UGJvuN5vds/tNWx4V
         ADDt1psGp3xHmVInjgHjQ+HjOAgCF9YHA7RFnzNG7i2brw6xKJ940uLI3+d6Zr0eBR1z
         1WUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Z2RgviTYIZSAoeoSoZxGUfnoAr9FmSUYXi9nHDkZWgY=;
        b=pdlohERkjkZsjDoS28XGrydRmYrY8QQby6iciXx5yKpkE3EW08wVRSLLhTKH0mnJRS
         mCiaQ7eo7c6vQxyMi2NUfqYEjpLmB8rrHY/eC3VkD/PquwLumquEfbLay8TboPEaYpaS
         jSJ+JBZLyaJki5I4g26/MxTlgwyGsCEOm1y6CBt+h1KJ2Pa4MyFD5eG9SZGuLyezAYBW
         4R259npyudyetbq576viv4nV0wHmA4PQ6iNdSslUieawGU/4mvxqwtfeE86Jdff3LHhP
         qTuDYh5j2J7Pfr7tENa7DolYw/ys6rU+Y3bnaa1MRHQQ+wd6Q9hqHctMyA+rqI5oAQ84
         453A==
X-Gm-Message-State: AOAM530xd+y5H4AWxzbknhIvHzaCT14QT39jubn2GhJHOlzzqSJX4Uoh
        REx/u/PVgj3Yq4FoMB3BiuVDF5vQQRFj+D9eDP7M1A==
X-Google-Smtp-Source: ABdhPJwtBuBh9botUSDk+ZE9VzKRYN5PSQSI4Uqz0ueKBFDKzsQYk/VB0JaBXk8o6O1rpw8RWftQkv2ggH30b8GcS50=
X-Received: by 2002:adf:b60c:0:b0:1f0:227d:bce with SMTP id
 f12-20020adfb60c000000b001f0227d0bcemr7933148wre.313.1647018202363; Fri, 11
 Mar 2022 09:03:22 -0800 (PST)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 11 Mar 2022 22:32:25 +0530
Message-ID: <CAAhSdy1cBkGqBLN7iZY-FUx2BFGoXmxd4WZJemPSRKz6my8cZQ@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 5.18
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
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

We have three KVM RISC-V changes for 5.18 which are:
1) Prevent KVM_COMPAT from being selected
2) Refine __kvm_riscv_switch_to() implementation
3) RISC-V SBI v0.3 support

I don't expect any other KVM RISC-V changes for 5.18.

Please pull.

Regards,
Anup

The following changes since commit 4a204f7895878363ca8211f50ec610408c8c70aa:

  KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255
(2022-03-08 10:59:12 -0500)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.18-1

for you to fetch changes up to 763c8bed8c05ffcce8cba882e69cd6b03df07019:

  RISC-V: KVM: Implement SBI HSM suspend call (2022-03-11 19:02:39 +0530)

----------------------------------------------------------------
KVM/riscv changes for 5.18

- Prevent KVM_COMPAT from being selected
- Refine __kvm_riscv_switch_to() implementation
- RISC-V SBI v0.3 support

----------------------------------------------------------------
Anup Patel (6):
      RISC-V: KVM: Upgrade SBI spec version to v0.3
      RISC-V: KVM: Add common kvm_riscv_vcpu_sbi_system_reset() function
      RISC-V: KVM: Implement SBI v0.3 SRST extension
      RISC-V: Add SBI HSM suspend related defines
      RISC-V: KVM: Add common kvm_riscv_vcpu_wfi() function
      RISC-V: KVM: Implement SBI HSM suspend call

Guo Ren (1):
      KVM: compat: riscv: Prevent KVM_COMPAT from being selected

Vincent Chen (1):
      RISC-V: KVM: Refine __kvm_riscv_switch_to() implementation

Yang Li (1):
      RISC-V: KVM: remove unneeded semicolon

 arch/riscv/include/asm/kvm_host.h     |  1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  5 ++-
 arch/riscv/include/asm/sbi.h          | 27 +++++++++++++---
 arch/riscv/kernel/cpu_ops_sbi.c       |  2 +-
 arch/riscv/kvm/vcpu_exit.c            | 22 +++++++++----
 arch/riscv/kvm/vcpu_sbi.c             | 19 +++++++++++
 arch/riscv/kvm/vcpu_sbi_hsm.c         | 18 +++++++++--
 arch/riscv/kvm/vcpu_sbi_replace.c     | 44 +++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_v01.c         | 20 ++----------
 arch/riscv/kvm/vcpu_switch.S          | 60 ++++++++++++++++++++---------------
 virt/kvm/Kconfig                      |  2 +-
 11 files changed, 161 insertions(+), 59 deletions(-)
