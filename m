Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F1A750D9E
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjGLQLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjGLQLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:03 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1029C134
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:02 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b8b2886364so47405395ad.0
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689178261; x=1691770261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P/gyHWRhdmt3W1ZOf5pRL6UNntD92OSXMXDmAzXvrNg=;
        b=fGAuAcLoInUfc0q3fFxWXNh784K2v5lXc+3MSoA4NM4bybLlq2A877Q95K6HPCvW9i
         S9PrgoE9ClCRf5R1/0nlUvszFDWskGWmxaLRyn6U+mvK6cGOHNG3QzCcA15MOd4qS2MD
         OJtKncBfjTZp/dtZdSfB6Y79/SxulIFkSPojn75EDVKeTnitLdCwvm2lEdtuzzfq/gqP
         WgwieP0Xy0H7L55RHFo3oyH4kuqlxT+6te6xDOc3zCzYjO3yerYeY6DGF8VaQC7y7Sjo
         udyKf12J7tGNllcGbv7sN3p3I7EUKSbpIMb+L6OF6oOhCDg1p7ZtWEyjTUOrd3JjZGPW
         EHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178261; x=1691770261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P/gyHWRhdmt3W1ZOf5pRL6UNntD92OSXMXDmAzXvrNg=;
        b=lfDfDBg4k6ZAEwtn7nWx8ShJThXRmMuP/5bre7jOXhsFnepBKmGIlY8bQLTGKg7BM1
         34ZWEOS16ySjOnaj2GZl1OK4FlGhWxymv/753C1bRys28t2c2zRif7QECFJ/Hz8gyK9L
         Zyulx7bJdGBU0UJ/y7i7onR2ofDq226CbxsjsOrvsffMd/R8O0Yc/CX0aLsBnLw/478B
         vJhhmXG2ebU7nG/1DbAQolV1AmPEBh6dgcvtjRKg6/xpLa/hz8mgaW8rN4afxR5ig8Vo
         8EzuJ/gR4sUWjzCBkEFqsz30Snr02WiU9bkjBBUL6Q4WgrxK2MLgCJLz2CM13OPvPFem
         ek6g==
X-Gm-Message-State: ABy/qLb+cL0nMUmA8Zg/ON89+mpMGZsNo+QLMY+ocTlmCnA+eK+yn1ih
        rWZowLgufHhSw0x1qVY5gZd6cw==
X-Google-Smtp-Source: APBJJlFJQ/muT40Pd9YoRXcgQ+QCoBx9dXiJIoyQqgXxxQpDnA04YVdYrtkec+9jLWPYZIUFBi9Fcg==
X-Received: by 2002:a17:903:489:b0:1b8:6cae:4400 with SMTP id jj9-20020a170903048900b001b86cae4400mr15606614plb.37.1689178261471;
        Wed, 12 Jul 2023 09:11:01 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001b9f032bb3dsm3811650plb.3.2023.07.12.09.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:11:01 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Samuel Ortiz <sameo@rivosinc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/7] KVM RISC-V ONE_REG ISA extension improvements
Date:   Wed, 12 Jul 2023 21:40:40 +0530
Message-Id: <20230712161047.1764756-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series improves the ISA extension ONE_REG interface in following ways:
1) Move ONE_REG related code to dedicated source file
2) Allow multiple ISA extensions to be enabled/disabled in one ioctl
3) Add more ISA extensions to the ONE_REG interface

The series has following dependencies:
1) PATCH6 depends on
https://lore.kernel.org/linux-riscv/20230712084134.1648008-1-sameo@rivosinc.com/
2) PATCH7 depends on
https://lore.kernel.org/linux-riscv/20230711153743.1970625-1-heiko@sntech.de/

The PATCH1 to PATCH5 of this series don't depend on any patches.

These patches can also be found in the riscv_kvm_onereg_imp_v1 branch at:
https://github.com/avpatel/linux.git

Anup Patel (7):
  RISC-V: KVM: Factor-out ONE_REG related code to its own source file
  RISC-V: KVM: Extend ONE_REG to enable/disable multiple ISA extensions
  RISC-V: KVM: Allow Zba and Zbs extensions for Guest/VM
  RISC-V: KVM: Allow Zicntr, Zicsr, Zifencei, and Zihpm for Guest/VM
  RISC-V: KVM: Sort ISA extensions alphabetically in ONE_REG interface
  RISC-V: KVM: Allow Zbc, Zbk* and Zk* extensions for Guest/VM
  RISC-V: KVM: Allow Zvb* and Zvk* extensions for Guest/VM

 arch/riscv/include/asm/kvm_host.h |   6 +
 arch/riscv/include/uapi/asm/kvm.h |  35 ++
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/vcpu.c             | 529 +----------------------
 arch/riscv/kvm/vcpu_onereg.c      | 695 ++++++++++++++++++++++++++++++
 5 files changed, 738 insertions(+), 528 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_onereg.c

-- 
2.34.1

