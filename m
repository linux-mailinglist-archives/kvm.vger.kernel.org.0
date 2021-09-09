Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976684042E1
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349465AbhIIBjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349386AbhIIBjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:39:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38D1C0613D9
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so405421yba.9
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AmUNmW1zNN82NWDCZCOv1ajU/78+UJITtNZym/5TLfk=;
        b=nVLRqzD6wmqrvZ7NzKkwjTUiJua5Ei6ADvZu1xGt4iE5FUDbOxGNmsNlVUqk+djoq1
         oU6mj2WrVuYDdr9KTXNHa+nyASgxa29IHf2VIQ6Fnl3TgQmZiBiozmJVSwDqw4sIiTB7
         luu/462mdgVrDsXpZO71HDSayore8Y16aeYYJZ+2TERLRPHJgAiSbWINpP22ZdSRYXHH
         IgFkvfSQnyZtI99PM3ia16/uLcBfn3nJ7qBqF2uiyIMAq+PBrMDUq/E1h/GQ9pTDacYn
         2UeMfEjtC9bugHyi6PXpoyqVTIxDroIpEu/6Zlz/FSvPPE1bMRkAODU8HzUr6ZAUAJiE
         +mPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AmUNmW1zNN82NWDCZCOv1ajU/78+UJITtNZym/5TLfk=;
        b=wGk7Tf1T4s3BbUuLEmAapvF1kxcDaelC/ni9bhasbdsOqXclJsHBTVK1vBHIEdMLln
         PFCntPZHWXk9vBgIQI0TlPnaUh5ewcmrE3IjWMetWIODpEr1Agm9l7WhiTyMx8ke6vjh
         IYzwgdwYYRighOkdjvgMbmdBvb6ZhMdHTJ2eRYAesNZd8RLsNQKkLocaHvnXPiSDIHHp
         EIm11C4ZMn4xsndXemnsqPJcNhsuszPsttC/k10H8PyBHs3dcoGwR/ZXg4na56ixwc0M
         jfShJkNVU+DsKjm5FORXQbS7GGQ5WUFWY79Sfw2iozSJYMeET6tJz2+5ZeHI2TsXHPPU
         bifA==
X-Gm-Message-State: AOAM531gaQtLxE3W5gVzbFX7w2SSu0KfXjhQuFFPPLQOGWeP1jSwahfU
        fD6MB8wqeQrBvAdt5QPGsj2KsbD/JDft
X-Google-Smtp-Source: ABdhPJyBAxT0YEGXKFY4c0vPYLsbHcErA9CrWCZOdmxwg4Yk6E8km+9UKdjBl253uqZRUYIktzqR1LSF8MqU
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:804:: with SMTP id 4mr522844ybi.346.1631151511813;
 Wed, 08 Sep 2021 18:38:31 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:03 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-4-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 03/18] KVM: arm64: selftests: Use read/write definitions
 from sysreg.h
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make use of the register read/write definitions from
sysreg.h, instead of the existing definitions. A syntax
correction is needed for the files that use write_sysreg()
to make it compliant with the new (kernel's) syntax.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
 .../selftests/kvm/include/aarch64/processor.h | 13 +--------
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index e5e6c92b60da..11fd23e21cb4 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -34,16 +34,16 @@ static void reset_debug_state(void)
 {
 	asm volatile("msr daifset, #8");
 
-	write_sysreg(osdlr_el1, 0);
-	write_sysreg(oslar_el1, 0);
+	write_sysreg(0, osdlr_el1);
+	write_sysreg(0, oslar_el1);
 	isb();
 
-	write_sysreg(mdscr_el1, 0);
+	write_sysreg(0, mdscr_el1);
 	/* This test only uses the first bp and wp slot. */
-	write_sysreg(dbgbvr0_el1, 0);
-	write_sysreg(dbgbcr0_el1, 0);
-	write_sysreg(dbgwcr0_el1, 0);
-	write_sysreg(dbgwvr0_el1, 0);
+	write_sysreg(0, dbgbvr0_el1);
+	write_sysreg(0, dbgbcr0_el1);
+	write_sysreg(0, dbgwcr0_el1);
+	write_sysreg(0, dbgwvr0_el1);
 	isb();
 }
 
@@ -53,14 +53,14 @@ static void install_wp(uint64_t addr)
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_sysreg(dbgwcr0_el1, wcr);
-	write_sysreg(dbgwvr0_el1, addr);
+	write_sysreg(wcr, dbgwcr0_el1);
+	write_sysreg(addr, dbgwvr0_el1);
 	isb();
 
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
@@ -70,14 +70,14 @@ static void install_hw_bp(uint64_t addr)
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_sysreg(dbgbcr0_el1, bcr);
-	write_sysreg(dbgbvr0_el1, addr);
+	write_sysreg(bcr, dbgbcr0_el1);
+	write_sysreg(addr, dbgbvr0_el1);
 	isb();
 
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
@@ -88,7 +88,7 @@ static void install_ss(void)
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_SS;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 96578bd46a85..bed4ffa70905 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -8,6 +8,7 @@
 #define SELFTEST_KVM_PROCESSOR_H
 
 #include "kvm_util.h"
+#include "sysreg.h"
 #include <linux/stringify.h>
 #include <linux/types.h>
 
@@ -119,18 +120,6 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
-#define write_sysreg(reg, val)						  \
-({									  \
-	u64 __val = (u64)(val);						  \
-	asm volatile("msr " __stringify(reg) ", %x0" : : "rZ" (__val));	  \
-})
-
-#define read_sysreg(reg)						  \
-({	u64 val;							  \
-	asm volatile("mrs %0, "__stringify(reg) : "=r"(val) : : "memory");\
-	val;								  \
-})
-
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.153.gba50c8fa24-goog

