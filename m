Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509D5545B6A
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 07:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbiFJFGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 01:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiFJFGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 01:06:22 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87727253FD1
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 22:06:18 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g186so14886743pgc.1
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 22:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rbnBF3SupX16h4V+L32e9kicSqU8X+l6y02dEeIHSV8=;
        b=hMpBl7S+khoWtaiMQH2q/PpiPaJ82+mNbitAXXVEZKEpAzp6w/P9i+Tz8SqjP2NbU1
         3QokBo0J9Zh/4cstHvaL4422P/JKlZ8yaQWxBbUHNjvJ8pS8SK4kYrvZPRQZ1O/pW6Zg
         RlK/kF3qmfQn2UGk92ZceMqqO63r6UNW2u9bVapSbt3p7BDq4/p0KPWX2ciaTSJ9dUB7
         Vcu34fK49AuVuvm6+khJnKJHI475tXU7Uvp3PfJOsVWCem36l+Gz82/9wZXa0g/yAWaF
         0kQFS9wXXddKPLpEzXcVP8Qe5GjhjUpipMwNmSxFVoglQ/MpM726Rg8NHFXKVaN2CY8J
         8xIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rbnBF3SupX16h4V+L32e9kicSqU8X+l6y02dEeIHSV8=;
        b=AjC5lAmVop9BMDV+r7Do7TlwbWvdsinkLIOQYjS8LQWV0hewvgKtHpMltKxU0DulD/
         dQWEoqHyPscVRWDah/Z5vesRaA0Ft5hXHqhzNA5/adERs8CcnEBPl4aotvdeqFIMb1CD
         3sFq8Fz+NiaZAzep2Rpymu6hCUxlIWrJ9V746x2e99TAqgDYv2Riqe+mqnNekacs/0uU
         gecCprRY3JsoHCezpRms3YBgD11c89uve5rXykBL6oebChX+/CBcxirDlPgxA+ZDZiHU
         tXqyl4h07gjrFfQRhh9c997GfEKe7m9wLWtd6obwGuwzi09Z3Wbr1J2AO3S/+w1ifOnl
         Q6OA==
X-Gm-Message-State: AOAM530J3caHTsae+1GkUA2yN6HOdxuAfgVsrQIz4NE1HxToauHJ1wWN
        XeSzV39QHE7fwZDehOrqyEzlcWVRPK3t9Q==
X-Google-Smtp-Source: ABdhPJzM/qCodL1LGXRkBY0EbWv8AZW9XZ61+8sHljtJEtEXgCIs3+vGyLmEtFdvzOOCqXXtf8NK+w==
X-Received: by 2002:a63:3c3:0:b0:3fc:5864:7412 with SMTP id 186-20020a6303c3000000b003fc58647412mr37096930pgd.138.1654837577990;
        Thu, 09 Jun 2022 22:06:17 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([106.200.250.139])
        by smtp.gmail.com with ESMTPSA id u7-20020a056a00158700b00519cfca8e30sm12429424pfk.209.2022.06.09.22.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 22:06:17 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/3] Improve instruction and CSR emulation in KVM RISC-V
Date:   Fri, 10 Jun 2022 10:35:52 +0530
Message-Id: <20220610050555.288251-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the instruction emulation for MMIO traps and Virtual instruction
traps co-exist with general VCPU exit handling. The instruction and CSR
emulation will grow with upcoming SBI PMU, AIA, and Nested virtualization
in KVM RISC-V. In addition, we also need a mechanism to allow user-space
emulate certain CSRs under certain situation (example, host has AIA support
but user-space does not wants to use in-kernel AIA IMSIC and APLIC support).

This series improves instruction and CSR emulation in KVM RISC-V to make
it extensible based on above.

These patches can also be found in riscv_kvm_csr_v1 branch at:
https://github.com/avpatel/linux.git

Anup Patel (3):
  RISC-V: KVM: Factor-out instruction emulation into separate sources
  RISC-V: KVM: Add extensible system instruction emulation framework
  RISC-V: KVM: Add extensible CSR emulation framework

 arch/riscv/include/asm/kvm_host.h           |  16 +-
 arch/riscv/include/asm/kvm_vcpu_insn.h      |  48 ++
 arch/riscv/kvm/Makefile                     |   1 +
 arch/riscv/kvm/vcpu.c                       |  11 +
 arch/riscv/kvm/vcpu_exit.c                  | 490 +----------------
 arch/riscv/kvm/{vcpu_exit.c => vcpu_insn.c} | 560 +++++++++++---------
 include/uapi/linux/kvm.h                    |   8 +
 7 files changed, 382 insertions(+), 752 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_insn.h
 copy arch/riscv/kvm/{vcpu_exit.c => vcpu_insn.c} (64%)

-- 
2.34.1

