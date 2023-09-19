Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127E77A6B39
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 21:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjISTN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 15:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjISTNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 15:13:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60739D
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 12:13:48 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-274abe07e94so98435a91.1
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 12:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695150828; x=1695755628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/BoKZ32KwsxUQ3UINg4R8i6IlvYW9M8AXX0zSojGAm4=;
        b=PTzwssGAakwpEsdjk+MlgFoFNyJoIiXQiQZqtRykECoBx08yMOXc0H5BevC5yh4fsU
         DPJKP1Vx1pAhAgBVnz23muLoQMHBWWdcrQiFjELsLx5omVLkBCEFvUzx5X9cgy1zLHMJ
         xhTM2niks/PxEixOcoW7JsPNdJ8viDtGBXTIfctGVsUDhVqJGmO76QHUpiSTdpM9u+xa
         VhHuhv/u/XiMbdPbGJEwaznd4J9wiN93V3l72o4hvZdBB5uQnh1OnAq7xV54woqdndZ2
         RpCttDQkJmJpckfStvXpZN9lsG6kL6ZMhShNPJbRHXcPOB2wJOn8qRfGuKolETLYSlfe
         kMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695150828; x=1695755628;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/BoKZ32KwsxUQ3UINg4R8i6IlvYW9M8AXX0zSojGAm4=;
        b=Sh10juMnDptwJcq2HLipNx9iVICnA58AXaNObbyoa0TVUiHYVz38Hba7Jcz07VUsbE
         ive5NbJ6Nxnw0/xRElthzw6XM3J4dQba8ELVrs0WNpuJyYGMazKcOmIi0EzfofpVXBdy
         hqMy3wqi2xQZ29NiSdWgrjqMZEs5B10vAaRC2c8o0xrGDVP/0YuQouTefQ8YUXANYBBa
         b6ELCDrL1jMtEr/2V1nW9qpMTBT2VpqV+H09EwxZaFPRjZ/oZCjZ3l9Rda237iTUwhAa
         KwldKjiOFvZmzinvjGaSEiULgpmPYgoLketSdSj9ysVZiy3KYq3NkF6jLnxrpt7sHqIJ
         gpPA==
X-Gm-Message-State: AOJu0Yy/rgix+oR7xjZ/K/uDHYwPfo3FqOVSs+soZdhc5M4DKifqA/YY
        mwMU3vJn26qOXq4DWklrmk89AcxNqjCee64727RoSvCMEg7PQDyWDFoARRlfPSeeX5zJ80WrsBi
        52gPDa9jNZCN2qHfDZ3tnsxp+IvSuBPEbbgPXevaMVC3STjhkzrv3pNQzgWtkRp+9cF6FCzc=
X-Google-Smtp-Source: AGHT+IHYSIEHbHJmaCdLAaNpjmkKhOqgXDOedC82RMItc2VlqXfAmzhsKN0kZMrNHaxd+LKsgRiePbdSSmg9p1vbNA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:3a86:b0:26b:43f1:e69f with
 SMTP id om6-20020a17090b3a8600b0026b43f1e69fmr86598pjb.1.1695150827508; Tue,
 19 Sep 2023 12:13:47 -0700 (PDT)
Date:   Tue, 19 Sep 2023 12:13:42 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919191343.693415-1-jingzhangos@google.com>
Subject: [PATCH v2] KVM: arm64: selftests: Test pointer authentication support
 in KVM guest
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify the KVM guest PAuth support on H/W with FEAT_PAuth. This test
will be skipped on H/W without FEAT_PAuth.
Following PAuth instructions are tested:
paciza, pacizb, pacdza, pacdzb, autiza, autizb, autdza, autdzb,
pacga, xpaclri, xpaci, xpacd
It also shows the implemented algorithm for both address authentication
and generic code authentication.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/arch/arm64/include/asm/sysreg.h         |   5 +
 tools/testing/selftests/kvm/Makefile          |   5 +
 .../selftests/kvm/aarch64/pauth_test.c        | 511 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   2 +
 4 files changed, 523 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/pauth_test.c

diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 7640fa27be94..9d903eb8388c 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -179,6 +179,7 @@
 
 #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
 #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
+#define SYS_ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
 
 #define SYS_ID_AA64MMFR0_EL1		sys_reg(3, 0, 0, 7, 0)
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
@@ -764,6 +765,10 @@
 #define ID_AA64ISAR1_GPI_NI			0x0
 #define ID_AA64ISAR1_GPI_IMP_DEF		0x1
 
+/* id_aa64isar2 */
+#define ID_AA64ISAR2_APA3_SHIFT		12
+#define ID_AA64ISAR2_GPA3_SHIFT		8
+
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_CSV3_SHIFT		60
 #define ID_AA64PFR0_CSV2_SHIFT		56
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c692cc86e7da..0fe40fcb02ec 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -143,6 +143,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
+TEST_GEN_PROGS_aarch64 += aarch64/pauth_test
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
@@ -212,6 +213,10 @@ ifeq ($(ARCH),s390)
 	CFLAGS += -march=z10
 endif
 
+ifeq ($(ARCH),arm64)
+	CFLAGS += -march=armv8.3-a
+endif
+
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
         $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
 
diff --git a/tools/testing/selftests/kvm/aarch64/pauth_test.c b/tools/testing/selftests/kvm/aarch64/pauth_test.c
new file mode 100644
index 000000000000..c40c59e4139a
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/pauth_test.c
@@ -0,0 +1,511 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * pauth_test - Test for KVM guest pointer authentication.
+ * Following PAuth instructions are tested:
+ * paciza, pacizb, pacdza, pacdzb, autiza, autizb, autdza, autdzb,
+ * pacga, xpaclri, xpaci, xpacd
+ * It also shows the implemented algorithm for both address authentication
+ * and generic code authentication.
+ *
+ * Copyright (c) 2023 Google LLC.
+ *
+ */
+
+#define _GNU_SOURCE
+
+#include <sched.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define KEY1_LO		0x0123456789abcdefUL
+#define KEY1_HI		0x123456789abcdef0UL
+#define KEY2_LO		0x23456789abcdef01UL
+#define KEY2_HI		0x3456789abcdef012UL
+#define KEY3_LO		0x456789abcdef0123UL
+#define KEY3_HI		0x56789abcdef01234UL
+#define KEY4_LO		0x6789abcdef012345UL
+#define KEY4_HI		0x789abcdef0123456UL
+#define KEY5_LO		0x89abcdef01234567UL
+#define KEY5_HI		0x9abcdef012345678UL
+
+enum uc_args {
+	WAIT_MIGRATION,
+	ADDR_PAUTH_ALGO,
+	GENERIC_PAUTH_ALGO,
+	FAIL_GUEST_PAUTH,
+};
+
+enum pauth_algo {
+	QARMA5,
+	QARMA3,
+	PACIMP,
+	NOALGO,
+};
+
+static const char *const algo_string[] = {
+	"QARMA5", "QARMA3", "PACIMP", "Undefined",
+};
+
+#define DEFINE_SIGN_FUNC(INSTR)						\
+	static size_t INSTR##_sign(size_t ptr)				\
+	{								\
+		__asm__ __volatile__(					\
+			#INSTR" %[p]"					\
+			: [p] "+r" (ptr)				\
+		);							\
+		return ptr;						\
+	}
+
+DEFINE_SIGN_FUNC(paciza)
+DEFINE_SIGN_FUNC(pacizb)
+DEFINE_SIGN_FUNC(pacdza)
+DEFINE_SIGN_FUNC(pacdzb)
+
+static size_t pacga_sign(size_t ptr)
+{
+	size_t dest = 0;
+
+	__asm__ __volatile__(
+		"pacga %[d], %[p], %[m]"
+		: [d] "=r" (dest)
+		: [p] "r" (ptr), [m] "r" (0)
+	);
+
+	return dest;
+}
+
+#define DEFINE_AUTH_STRIP_FUNC(AUTH, STRIP)				\
+	static size_t AUTH##_auth_##STRIP##_strip(size_t ptr)		\
+	{								\
+		__asm__ __volatile__(					\
+			#AUTH" %[p]\n"					\
+			#STRIP" %[p]\n"					\
+			: [p] "+r" (ptr)				\
+		);							\
+		return ptr;						\
+	}
+
+DEFINE_AUTH_STRIP_FUNC(autiza, xpaci)
+DEFINE_AUTH_STRIP_FUNC(autizb, xpaci)
+DEFINE_AUTH_STRIP_FUNC(autdza, xpacd)
+DEFINE_AUTH_STRIP_FUNC(autdzb, xpacd)
+
+#define GUEST_ALGO(type, algo)	GUEST_SYNC_ARGS(type, algo, 0, 0, 0)
+
+static void check_pauth_algorithms(void)
+{
+	uint64_t isar1 = read_sysreg_s(SYS_ID_AA64ISAR1_EL1);
+	uint64_t isar2 = read_sysreg_s(SYS_ID_AA64ISAR2_EL1);
+	enum pauth_algo algo;
+
+	/* Check generic authentication algorithm */
+	if (isar1 & ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI))
+		algo = PACIMP;
+	else if (isar1 & ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA))
+		algo = QARMA5;
+	else if (isar2 & ARM64_FEATURE_MASK(ID_AA64ISAR2_GPA3))
+		algo = QARMA3;
+	else
+		algo = NOALGO;
+
+	GUEST_ALGO(GENERIC_PAUTH_ALGO, algo);
+
+	/* Check address authentication algorithm */
+	if (isar1 & ARM64_FEATURE_MASK(ID_AA64ISAR1_API))
+		algo = PACIMP;
+	else if (isar1 & ARM64_FEATURE_MASK(ID_AA64ISAR1_APA))
+		algo = QARMA5;
+	else if (isar2 & ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3))
+		algo = QARMA3;
+	else
+		algo = NOALGO;
+
+	GUEST_ALGO(ADDR_PAUTH_ALGO, algo);
+}
+
+/* Setup PAuth keys and check their retainability */
+static void check_keys_retainable(void)
+{
+	bool retainable = true;
+
+	/* Address */
+	write_sysreg_s(KEY1_LO, SYS_APIAKEYLO_EL1);
+	write_sysreg_s(KEY1_HI, SYS_APIAKEYHI_EL1);
+	write_sysreg_s(KEY2_LO, SYS_APIBKEYLO_EL1);
+	write_sysreg_s(KEY2_HI, SYS_APIBKEYHI_EL1);
+	/* Data */
+	write_sysreg_s(KEY3_LO, SYS_APDAKEYLO_EL1);
+	write_sysreg_s(KEY3_HI, SYS_APDAKEYHI_EL1);
+	write_sysreg_s(KEY4_LO, SYS_APDBKEYLO_EL1);
+	write_sysreg_s(KEY4_HI, SYS_APDBKEYHI_EL1);
+	/* Generic */
+	write_sysreg_s(KEY5_LO, SYS_APGAKEYLO_EL1);
+	write_sysreg_s(KEY5_HI, SYS_APGAKEYHI_EL1);
+	isb();
+
+	GUEST_SYNC(WAIT_MIGRATION);
+
+	/* Address */
+	retainable = retainable && (read_sysreg_s(SYS_APIAKEYLO_EL1) == KEY1_LO);
+	retainable = retainable && (read_sysreg_s(SYS_APIAKEYHI_EL1) == KEY1_HI);
+	retainable = retainable && (read_sysreg_s(SYS_APIBKEYLO_EL1) == KEY2_LO);
+	retainable = retainable && (read_sysreg_s(SYS_APIBKEYHI_EL1) == KEY2_HI);
+	/* Data */
+	retainable = retainable && (read_sysreg_s(SYS_APDAKEYLO_EL1) == KEY3_LO);
+	retainable = retainable && (read_sysreg_s(SYS_APDAKEYHI_EL1) == KEY3_HI);
+	retainable = retainable && (read_sysreg_s(SYS_APDBKEYLO_EL1) == KEY4_LO);
+	retainable = retainable && (read_sysreg_s(SYS_APDBKEYHI_EL1) == KEY4_HI);
+	/* Generic */
+	retainable = retainable && (read_sysreg_s(SYS_APGAKEYLO_EL1) == KEY5_LO);
+	retainable = retainable && (read_sysreg_s(SYS_APGAKEYHI_EL1) == KEY5_HI);
+
+	GUEST_ASSERT(retainable);
+}
+
+#define ADDR_START	0x8000
+#define ADDR_END	0x8008
+
+static void test_same_keys(void)
+{
+	/* Set the same keys */
+	write_sysreg_s(KEY1_LO, SYS_APIAKEYLO_EL1);
+	write_sysreg_s(KEY1_HI, SYS_APIAKEYHI_EL1);
+	write_sysreg_s(KEY1_LO, SYS_APIBKEYLO_EL1);
+	write_sysreg_s(KEY1_HI, SYS_APIBKEYHI_EL1);
+	write_sysreg_s(KEY1_LO, SYS_APDAKEYLO_EL1);
+	write_sysreg_s(KEY1_HI, SYS_APDAKEYHI_EL1);
+	write_sysreg_s(KEY1_LO, SYS_APDBKEYLO_EL1);
+	write_sysreg_s(KEY1_HI, SYS_APDBKEYHI_EL1);
+	isb();
+
+	/* Same algorithm, same address, same keys should have same PAC */
+	for (size_t i = ADDR_START; i < ADDR_END; i++) {
+		/* Assert if the PAuth instruction did nothing */
+		GUEST_ASSERT(paciza_sign(i) != i);
+
+		GUEST_ASSERT(paciza_sign(i) == pacizb_sign(i));
+		GUEST_ASSERT(paciza_sign(i) == pacdza_sign(i));
+		GUEST_ASSERT(paciza_sign(i) == pacdzb_sign(i));
+	}
+}
+
+static void test_different_keys(void)
+{
+	write_sysreg_s(KEY1_LO, SYS_APIAKEYLO_EL1);
+	write_sysreg_s(KEY1_HI, SYS_APIAKEYHI_EL1);
+	write_sysreg_s(KEY2_LO, SYS_APIBKEYLO_EL1);
+	write_sysreg_s(KEY2_HI, SYS_APIBKEYHI_EL1);
+	write_sysreg_s(KEY3_LO, SYS_APDAKEYLO_EL1);
+	write_sysreg_s(KEY3_HI, SYS_APDAKEYHI_EL1);
+	write_sysreg_s(KEY4_LO, SYS_APDBKEYLO_EL1);
+	write_sysreg_s(KEY4_HI, SYS_APDBKEYHI_EL1);
+	isb();
+
+	/* Same algorithm, same address, different keys should have different PAc */
+	for (size_t i = ADDR_START; i < ADDR_END; i++) {
+		/* Assert if the PAuth instruction did nothing */
+		GUEST_ASSERT(paciza_sign(i) != i);
+
+		GUEST_ASSERT(paciza_sign(i) != pacizb_sign(i));
+		GUEST_ASSERT(paciza_sign(i) != pacdza_sign(i));
+		GUEST_ASSERT(paciza_sign(i) != pacdzb_sign(i));
+	}
+}
+
+static void test_generic_sign(void)
+{
+	size_t ga_signs[ADDR_END - ADDR_START];
+	size_t i;
+
+	write_sysreg_s(KEY1_LO, SYS_APGAKEYLO_EL1);
+	write_sysreg_s(KEY1_HI, SYS_APGAKEYHI_EL1);
+	isb();
+
+	for (i = ADDR_START; i < ADDR_END; i++) {
+		ga_signs[i - ADDR_START] = pacga_sign(i);
+		/* Assert if the PAuth instruction did nothing */
+		GUEST_ASSERT(ga_signs[i - ADDR_START] != i);
+	}
+
+	write_sysreg_s(KEY5_LO, SYS_APGAKEYLO_EL1);
+	write_sysreg_s(KEY5_HI, SYS_APGAKEYHI_EL1);
+	isb();
+
+	/* Different key should have different sign */
+	for (i = ADDR_START; i < ADDR_END; i++) {
+		/* Assert if the PAuth instruction did nothing */
+		GUEST_ASSERT(pacga_sign(i) != i);
+		GUEST_ASSERT(pacga_sign(i) != ga_signs[i - ADDR_START]);
+	}
+}
+
+static void test_ia_auth_strip(void)
+{
+	size_t ptr = ADDR_START;
+
+	write_sysreg_s(KEY2_LO, SYS_APIAKEYLO_EL1);
+	write_sysreg_s(KEY2_HI, SYS_APIAKEYHI_EL1);
+	isb();
+
+	ptr = paciza_sign(ptr);
+
+	write_sysreg_s(KEY1_LO, SYS_APIAKEYLO_EL1);
+	write_sysreg_s(KEY1_HI, SYS_APIAKEYHI_EL1);
+	isb();
+
+	/*
+	 * Since key has changed, the authentication would fail and be trapped.
+	 * In the trap handler, the pauth would be disabled to avoid future trap
+	 * for auth failure.
+	 */
+	ptr = autiza_auth_xpaci_strip(ptr);
+
+	/* Assert if the strip instruction didn't work */
+	GUEST_ASSERT(ptr == ADDR_START);
+}
+
+static void test_ib_auth_strip(void)
+{
+	size_t ptr = ADDR_START;
+
+	write_sysreg_s(KEY3_LO, SYS_APIBKEYLO_EL1);
+	write_sysreg_s(KEY3_HI, SYS_APIBKEYHI_EL1);
+	isb();
+
+	ptr = pacizb_sign(ptr);
+
+	write_sysreg_s(KEY2_LO, SYS_APIBKEYLO_EL1);
+	write_sysreg_s(KEY2_HI, SYS_APIBKEYHI_EL1);
+	isb();
+
+	/*
+	 * Since key has changed, the authentication would fail and be trapped.
+	 * In the trap handler, the pauth would be disabled to avoid future trap
+	 * for auth failure.
+	 */
+	ptr = autizb_auth_xpaci_strip(ptr);
+
+	/* Assert if the strip instruction didn't work */
+	GUEST_ASSERT(ptr == ADDR_START);
+}
+
+static void test_da_auth_strip(void)
+{
+	size_t ptr = ADDR_START;
+
+	write_sysreg_s(KEY4_LO, SYS_APDAKEYLO_EL1);
+	write_sysreg_s(KEY4_HI, SYS_APDAKEYHI_EL1);
+	isb();
+
+	ptr = pacdza_sign(ptr);
+
+	write_sysreg_s(KEY3_LO, SYS_APDAKEYLO_EL1);
+	write_sysreg_s(KEY3_HI, SYS_APDAKEYHI_EL1);
+	isb();
+
+	/*
+	 * Since key has changed, the authentication would fail and be trapped.
+	 * In the trap handler, the pauth would be disabled to avoid future trap
+	 * for auth failure.
+	 */
+	ptr = autdza_auth_xpacd_strip(ptr);
+
+	/* Assert if the strip instruction didn't work */
+	GUEST_ASSERT(ptr == ADDR_START);
+}
+
+static void test_db_auth_strip(void)
+{
+	size_t ptr = ADDR_START;
+
+	write_sysreg_s(KEY5_LO, SYS_APDBKEYLO_EL1);
+	write_sysreg_s(KEY5_HI, SYS_APDBKEYHI_EL1);
+	isb();
+
+	ptr = pacdzb_sign(ptr);
+
+	write_sysreg_s(KEY4_LO, SYS_APDBKEYLO_EL1);
+	write_sysreg_s(KEY4_HI, SYS_APDBKEYHI_EL1);
+	isb();
+
+	/*
+	 * Since key has changed, the authentication would fail and be trapped.
+	 * In the trap handler, the pauth would be disabled to avoid future trap
+	 * for auth failure.
+	 */
+	ptr = autdzb_auth_xpacd_strip(ptr);
+
+	/* Assert if the strip instruction didn't work */
+	GUEST_ASSERT(ptr == ADDR_START);
+}
+
+static void test_auth_strip(void)
+{
+	test_ia_auth_strip();
+	test_ib_auth_strip();
+	test_da_auth_strip();
+	test_db_auth_strip();
+
+	/*
+	 * If all authentication instructions have failed, the PAuth enable bits
+	 * in SCTLR should have been cleared in the trap handler.
+	 * Otherwise, the auth instructions didn't work as expected.
+	 */
+	if (read_sysreg(sctlr_el1) &
+	    (SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | SCTLR_ELx_ENDA | SCTLR_ELx_ENDB))
+		GUEST_ASSERT(0);
+}
+
+static void guest_code(void)
+{
+	uint64_t sctlr = read_sysreg(sctlr_el1);
+
+	check_pauth_algorithms();
+	check_keys_retainable();
+
+	/* Enable PAuth */
+	sctlr |= SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | SCTLR_ELx_ENDA | SCTLR_ELx_ENDB;
+	write_sysreg(sctlr, sctlr_el1);
+	isb();
+
+	test_same_keys();
+	test_different_keys();
+	test_generic_sign();
+	test_auth_strip();
+
+	GUEST_DONE();
+}
+
+/* Guest will get an unknown exception (UNDEF) if guest PAuth is not enabled. */
+static void guest_unknown_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(FAIL_GUEST_PAUTH);
+	GUEST_DONE();
+}
+
+/* Guest will get a FPAC exception if KVM support guest PAuth */
+static void guest_fpac_handler(struct ex_regs *regs)
+{
+	uint64_t sctlr = read_sysreg(sctlr_el1);
+
+	if (sctlr & SCTLR_ELx_ENIA) {
+		sctlr &= ~SCTLR_ELx_ENIA;
+		write_sysreg(sctlr, sctlr_el1);
+		isb();
+	} else if (sctlr & SCTLR_ELx_ENIB) {
+		sctlr &= ~SCTLR_ELx_ENIB;
+		write_sysreg(sctlr, sctlr_el1);
+		isb();
+	} else if (sctlr & SCTLR_ELx_ENDA) {
+		sctlr &= ~SCTLR_ELx_ENDA;
+		write_sysreg(sctlr, sctlr_el1);
+		isb();
+	} else if (sctlr & SCTLR_ELx_ENDB) {
+		sctlr &= ~SCTLR_ELx_ENDB;
+		write_sysreg(sctlr, sctlr_el1);
+		isb();
+	}
+}
+
+int main(void)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	cpu_set_t cpu_mask;
+	bool guest_done = false;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PTRAUTH_ADDRESS));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PTRAUTH_GENERIC));
+
+	vm = vm_create(1);
+
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= ((1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS) |
+			     (1 << KVM_ARM_VCPU_PTRAUTH_GENERIC));
+
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_UNKNOWN, guest_unknown_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_FPAC, guest_fpac_handler);
+
+	ksft_print_header();
+	ksft_set_plan(3);
+
+	while (!guest_done) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_SYNC:
+			switch (uc.args[1]) {
+			case WAIT_MIGRATION:
+				sched_getaffinity(0, sizeof(cpu_mask), &cpu_mask);
+				CPU_CLR(sched_getcpu(), &cpu_mask);
+				sched_setaffinity(0, sizeof(cpu_mask), &cpu_mask);
+				break;
+			case FAIL_GUEST_PAUTH:
+				/*
+				 * KVM has already claimed that both itself and
+				 * HW support PAuth, but the guest still got the
+				 * UNDEF with PAuth instruction.
+				 * Usually this shouldn't happen unless KVM
+				 * screwed up the emulation somehow or the PAuth
+				 * was not enabled for the guest.
+				 */
+				TEST_FAIL("Geust PAuth was not enabled!\n");
+				break;
+			case GENERIC_PAUTH_ALGO: {
+				enum pauth_algo algo = uc.args[2];
+
+				if (algo == NOALGO) {
+					ksft_print_msg("Make sure the VCPU feature is enabled:\n");
+					ksft_print_msg("KVM_ARM_VCPU_PTRAUTH_GENERIC\n");
+					TEST_FAIL("No generic PAuth algorithm in guest!\n");
+				}
+
+				ksft_test_result_pass("Generic PAuth Algorithm: %s\n",
+						      algo_string[algo]);
+				break;
+			}
+			case ADDR_PAUTH_ALGO: {
+				enum pauth_algo algo = uc.args[2];
+
+				if (algo == NOALGO) {
+					ksft_print_msg("Make sure the VCPU feature is enabled:\n");
+					ksft_print_msg("KVM_ARM_VCPU_PTRAUTH_ADDRESS\n");
+					TEST_FAIL("No address PAuth algorithm in guest!\n");
+				}
+
+				ksft_test_result_pass("Address PAuth Algorithm: %s\n",
+						      algo_string[algo]);
+				break;
+			}
+			default:
+				ksft_print_msg("Unexpected guest sync arg: 0x%016llx\n",
+					       uc.args[1]);
+				break;
+			}
+			break;
+		case UCALL_DONE:
+			ksft_test_result_pass("Guest PAuth\n");
+			guest_done = true;
+			break;
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	}
+
+	ksft_finished();
+	kvm_vm_free(vm);
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index cb537253a6b9..f8d541af9c06 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -104,7 +104,9 @@ enum {
 #define ESR_EC_SHIFT		26
 #define ESR_EC_MASK		(ESR_EC_NUM - 1)
 
+#define ESR_EC_UNKNOWN		0x00
 #define ESR_EC_SVC64		0x15
+#define ESR_EC_FPAC		0x1c
 #define ESR_EC_IABT		0x21
 #define ESR_EC_DABT		0x25
 #define ESR_EC_HW_BP_CURRENT	0x31

base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
-- 
2.41.0.640.ga95def55d0-goog

