Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF7256A634
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbiGGOya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiGGOyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:54:16 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8106B5A45D
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 07:53:18 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id n12so19939055pfq.0
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 07:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2/cSQRYg50JuMF0k4CiBLOOMScUk3mXsGoE8DMLTmGQ=;
        b=er9nqWUP8eP6usOXt23apNRzaB+sp9s0z7ZvXZctGj3Om3+CrQ463jXIqaq0Olo7cA
         eLVU8m4qvUPEKhD35qoudlMRRWzhftZF2RzvL1qICwipTKw6ml05b8wHU8hudZEuGfON
         +xDaFvG1KOiNdB6l6W4oYPYwTd3zUsifB5zQzeTYpLjCnllDQv9fv4dSmKe5BQIPOInq
         juBSjYjMYn3KOEJKZGUW/wKoq0bI1MT2nuOZ3Wa43ilVxvbgUDkKdKBBAYtJq5UewcQg
         nCDZMgk0ulSCy9Ded1j4Vm1hK33lAQREgPfY7MB3Wh3rBZjOfUpWcmfX2KahyaibpiRz
         fZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2/cSQRYg50JuMF0k4CiBLOOMScUk3mXsGoE8DMLTmGQ=;
        b=7z+NO07aEs05yFHiilTmYAix2Bi/+0llbzI5rOghSh7A8k/PvMm1hOCITrnFVs7pw5
         NdesWoP+ZuLec8fcbTQ7J5Vx0MZRPRf00ZBGmpe/EGJvTifW8z6CGe+hANX6Ga9iaG7g
         7NzXG3gFCKdUYtE/RlkustNOFsHGLugmgCMt6RQ7UC6Azrs02pXP7BOsaYBKcQQU0E0I
         kYWFLoXW9C8q61uDArJGlYrOyESLRO/8UUA3q4BjlYLup3re2d4MLV3YJsBd18Kbkvga
         Bx/dooWsftFewCAQMxlpMmOIhyKYg3T3bp//scnRXT2D42on0aAkd9aL5l8E2INExtxK
         8Akw==
X-Gm-Message-State: AJIora8y3UHk+q6K6Frw6FObxcufkExpimF227+3lCUmA8XLKzDsjmcw
        Eb2lwvaVgRy0/UFFdU+f33roEg==
X-Google-Smtp-Source: AGRyM1vOJj+bmEomGF03XvBXPTdyrfwYNBaHdnZBlfX7sgIfcCWLhyRtqza8tkvG3CxVepetxWkL0Q==
X-Received: by 2002:a17:903:110c:b0:168:fa61:1440 with SMTP id n12-20020a170903110c00b00168fa611440mr52729714plh.149.1657205596753;
        Thu, 07 Jul 2022 07:53:16 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([223.226.40.162])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7951a000000b0052535e7c489sm27144231pfp.114.2022.07.07.07.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:53:16 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/5] KVM RISC-V Svpbmt support
Date:   Thu,  7 Jul 2022 20:22:43 +0530
Message-Id: <20220707145248.458771-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series extends KVM RISC-V to detect and use Svpbmt for both
G-stage (hypervisor) and VS-stage (guest) page table.

The corresponding KVMTOOL patches used for testing this series
can be found in riscv_svpbmt_sstc_v1 branch at:
https://github.com/avpatel/kvmtool.git

These patches can also be found in riscv_kvm_svpbmt_v1 branch at:
https://github.com/avpatel/linux.git

Alexandre Ghiti (1):
  riscv: Fix missing PAGE_PFN_MASK

Anup Patel (4):
  KVM: Add gfp_custom flag in struct kvm_mmu_memory_cache
  RISC-V: KVM: Add G-stage ioremap() and iounmap() functions
  RISC-V: KVM: Use PAGE_KERNEL_IO in kvm_riscv_gstage_ioremap()
  RISC-V: KVM: Add support for Svpbmt inside Guest/VM

 arch/riscv/include/asm/csr.h        | 16 ++++++++++++++++
 arch/riscv/include/asm/kvm_host.h   |  5 +++++
 arch/riscv/include/asm/pgtable-64.h | 12 ++++++------
 arch/riscv/include/asm/pgtable.h    |  6 +++---
 arch/riscv/include/uapi/asm/kvm.h   |  1 +
 arch/riscv/kvm/mmu.c                | 22 ++++++++++++++++------
 arch/riscv/kvm/vcpu.c               | 16 ++++++++++++++++
 include/linux/kvm_types.h           |  1 +
 virt/kvm/kvm_main.c                 |  4 +++-
 9 files changed, 67 insertions(+), 16 deletions(-)

-- 
2.34.1

