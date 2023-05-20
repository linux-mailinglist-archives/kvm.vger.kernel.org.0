Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888AB70A8A4
	for <lists+kvm@lfdr.de>; Sat, 20 May 2023 17:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjETPBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 May 2023 11:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjETPBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 May 2023 11:01:22 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803F9118
        for <kvm@vger.kernel.org>; Sat, 20 May 2023 08:01:21 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64d577071a6so205230b3a.1
        for <kvm@vger.kernel.org>; Sat, 20 May 2023 08:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684594881; x=1687186881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JngrVDzUb7onTZW8kbY61V0gOKYCqFmRyyUS95xUVKQ=;
        b=OFj5rEl+qVxZn2gEAREcEKPNqxdvf88EZUo7G+ne53NX+LW/JtyWB733CSy9AHNZmH
         dhMCfpbCHjOHp6QQd5oDYFL+v+iWeY/3tMeDUjepOUz+jbpdL2Db7dKdtpWLjKVeRvG6
         98QHLmg7w+5qSxyC6jYAUha2bVXfz0KNof4+vHpn7e3EC9IrGyPFHT1d9zEvK/FV/a0L
         xMVyY01ospb8E4kmm1IrlJ1EU4T5zlO1TY8jDuAM0o7zW+6bMYEh8tkfo0fNOXFNvDE1
         yefPPuperLrwpIMP5wzwtTdwzcky5e6w31/TCGRMZjN30IGjZv/JAbpP6Ub1FocTRNrL
         KQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684594881; x=1687186881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JngrVDzUb7onTZW8kbY61V0gOKYCqFmRyyUS95xUVKQ=;
        b=kGYJMH+VXOnePmFPodgw10F5CydqcdCPiSfOXzOZVqhO/TSZ8+j3WH9JSvM0l3pPGn
         0fKOrOk/+QBGe7eAoF6IWGI3dVaTKYbkZZ/ReclnMEmSp7ROavBVqRkuc8J28xVhxWKh
         I5CRvYtUBhZ6YDVByyHzfpn4mDpxo9rqhhHxwzeEUDc+VH0dW1ZwkssYgcJhgdxkkv2U
         /r9MdsN60/m1opOHrH9qMuBdo0rRWckp3VIXvIB47VrxXR6R+EqgP5xfY2KjYUod3E2w
         zBbVbvEMFn7f6hQVNGqqBLtlwKfiXmjklyZ+uOiMpwfAHwef/chosue++ng+53ZIAR/m
         OMCw==
X-Gm-Message-State: AC+VfDybp/OCd954SYYdwhIwBOqLINjJIYEun4Wh1s+hW5fBfNEG8LgV
        QtHUrPxp9wakAhqX/mcPHLg=
X-Google-Smtp-Source: ACHHUZ6CCAoiklTOJARIxoSJqUydx1h76n10uIK/FXaLDlt/SmrCT0Ili+NK9Fui7i35MaBf3nuMpQ==
X-Received: by 2002:a05:6a00:804:b0:645:b13e:e674 with SMTP id m4-20020a056a00080400b00645b13ee674mr7529666pfk.26.1684594880737;
        Sat, 20 May 2023 08:01:20 -0700 (PDT)
Received: from localhost.localdomain (36-230-227-109.dynamic-ip.hinet.net. [36.230.227.109])
        by smtp.gmail.com with ESMTPSA id j17-20020a62e911000000b0064d413caea6sm1387355pfh.179.2023.05.20.08.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 May 2023 08:01:20 -0700 (PDT)
From:   wchen <waylingii@gmail.com>
X-Google-Original-From: wchen <waylingII@gmail.com>
To:     anup@brainfault.org
Cc:     atishp@atishpatra.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        ajones@ventanamicro.com, wchen <waylingII@gmail.com>
Subject: [PATCH] RISC-V: KVM: Redirect AMO load/store misaligned traps to guest
Date:   Sat, 20 May 2023 23:01:16 +0800
Message-Id: <20230520150116.7451-1-waylingII@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The M-mode redirects an unhandled misaligned trap back
to S-mode when not delegating it to VS-mode(hedeleg).
However, KVM running in HS-mode terminates the VS-mode
software when back from M-mode.
The KVM should redirect the trap back to VS-mode, and
let VS-mode trap handler decide the next step.
Here is a way to handle misaligned traps in KVM,
not only directing them to VS-mode or terminate it.

Signed-off-by: wchen <waylingII@gmail.com>
---
 arch/riscv/include/asm/csr.h | 2 ++
 arch/riscv/kvm/vcpu_exit.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index b6acb7ed1..917814a0f 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -82,7 +82,9 @@
 #define EXC_INST_ACCESS		1
 #define EXC_INST_ILLEGAL	2
 #define EXC_BREAKPOINT		3
+#define EXC_LOAD_MISALIGNED	4
 #define EXC_LOAD_ACCESS		5
+#define EXC_STORE_MISALIGNED	6
 #define EXC_STORE_ACCESS	7
 #define EXC_SYSCALL		8
 #define EXC_HYPERVISOR_SYSCALL	9
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 4ea101a73..2415722c0 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -183,6 +183,8 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (trap->scause) {
 	case EXC_INST_ILLEGAL:
+	case EXC_LOAD_MISALIGNED:
+	case EXC_STORE_MISALIGNED:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
 			kvm_riscv_vcpu_trap_redirect(vcpu, trap);
 			ret = 1;
-- 
2.34.1

