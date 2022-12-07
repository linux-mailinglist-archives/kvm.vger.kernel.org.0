Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488CD6457EA
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 11:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLGKdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 05:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLGKdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 05:33:42 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F112654C
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 02:33:41 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id n21so12861341ejb.9
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 02:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I0jpWPIBVAp+rHu6Z64EYwjXGIWWou0XXGrJUb14aao=;
        b=scpoUvPhowy1XW5Y96Ae003nM1Gvl3fcmNIdR4qRMYq/SipCy3E/62EhkBRXw9D2Gi
         2xAVK6xRXmyqGTivUoovzUQ8uvymc3LwokrvWO870n1WP8bJdApEgvdamY//1yakUNKV
         juQSDzs8tODfjN9xhRsg7xmY1+Z3A4PxUgZM/OcZN07mb+iovagj0fbar4fkBe4GGXIl
         SPaANxskB67v78rbgpYwDnwcs/uJ4SfZE5zWwTC00kJwQhO7H4H23wJo0GdwJCYsyYzt
         xMb8pShJvuLE01FgHKOO90eBDT40cYL+2UrsqIRuLZ3HwGhrr/IcoQTMsciFSohQTOl9
         xASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I0jpWPIBVAp+rHu6Z64EYwjXGIWWou0XXGrJUb14aao=;
        b=Fm+jPV/Gr4mYFeA/HTzgKkUkCXLdURYzXqoaiQeaQMeECqx9ZPRryDVgJ9eIYNhvEm
         ZKHVZpVFIERHH5QyTu+aoV41sPUeh47u1e8hq8SdSwWsaj+Hiy1pwBX5BX7XGWpjdu8Q
         KP82wG1jMcCuZ1NYhYhvTKPuWOmXmfOdmtWpSBfH/SbOiPGnCjRsNQi+MmAJ1jSOQnIc
         hqizg3M3e/ZwQYqRkPSgg0l6dqeER5LTwLWaDW7AZWn8xVK82T1RhQVrAP0zB/P7hOfh
         9h+BeyTXzz5EEil2xN0hUbY7d0FX+7n4YvpsEMAnjakjAoQv7I4vcA0dT79+9L+w354T
         DHOw==
X-Gm-Message-State: ANoB5pmNvBtbkTm7GurlCC0EaVcrBLrrx2IIAeSS/p58/YXCMJb95MRs
        vdecs4Ml9gBBukWcMQBIxUE0UKUf8RLPXFBdASEfVw==
X-Google-Smtp-Source: AA0mqf7gvLaEime8aYps0wOthxWyDMPcGn8Z+/r199yLrTRc6psuJEF6pBbA/xA9BzcaPKlCe8Jz/AIQWBoKY/+ZyXQ=
X-Received: by 2002:a17:906:114a:b0:7c0:c836:e586 with SMTP id
 i10-20020a170906114a00b007c0c836e586mr18222229eja.750.1670409220219; Wed, 07
 Dec 2022 02:33:40 -0800 (PST)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 7 Dec 2022 16:03:28 +0530
Message-ID: <CAAhSdy0qihfFCXTV-QUjP-5XiQQqBC4_sP-swx77k6PC3uTmmw@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.2
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

We have the following KVM RISC-V changes for 6.2:
1) Allow unloading KVM module
2) Allow KVM user-space to set mvendorid, marchid, and mimpid
3) Several fixes and cleanups

Please pull.

Regards,
Anup

The following changes since commit 76dcd734eca23168cb008912c0f69ff408905235:

  Linux 6.1-rc8 (2022-12-04 14:48:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.2-1

for you to fetch changes up to 6ebbdecff6ae00557a52539287b681641f4f0d33:

  RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and
mimpid (2022-12-07 09:17:49 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.2

- Allow unloading KVM module
- Allow KVM user-space to set mvendorid, marchid, and mimpid
- Several fixes and cleanups

----------------------------------------------------------------
Anup Patel (9):
      RISC-V: KVM: Exit run-loop immediately if xfer_to_guest fails
      RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
      RISC-V: KVM: Remove redundant includes of asm/kvm_vcpu_timer.h
      RISC-V: KVM: Remove redundant includes of asm/csr.h
      RISC-V: KVM: Use switch-case in kvm_riscv_vcpu_set/get_reg()
      RISC-V: KVM: Move sbi related struct and functions to kvm_vcpu_sbi.h
      RISC-V: Export sbi_get_mvendorid() and friends
      RISC-V: KVM: Save mvendorid, marchid, and mimpid when creating VCPU
      RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and mimpid

Bo Liu (1):
      RISC-V: KVM: use vma_lookup() instead of find_vma_intersection()

Christophe JAILLET (1):
      RISC-V: KVM: Simplify kvm_arch_prepare_memory_region()

XiakaiPan (1):
      RISC-V: KVM: Add exit logic to main.c

 arch/riscv/include/asm/kvm_host.h     | 16 +++----
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  6 +++
 arch/riscv/include/uapi/asm/kvm.h     |  3 ++
 arch/riscv/kernel/sbi.c               |  3 ++
 arch/riscv/kvm/main.c                 |  6 +++
 arch/riscv/kvm/mmu.c                  |  6 +--
 arch/riscv/kvm/vcpu.c                 | 85 ++++++++++++++++++++++++++---------
 arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++---
 arch/riscv/kvm/vcpu_sbi_hsm.c         |  1 -
 arch/riscv/kvm/vcpu_sbi_replace.c     |  1 -
 arch/riscv/kvm/vcpu_sbi_v01.c         |  1 -
 11 files changed, 97 insertions(+), 44 deletions(-)
