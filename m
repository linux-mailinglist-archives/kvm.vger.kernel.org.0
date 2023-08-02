Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B596F76DBBA
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjHBXnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjHBXnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:43:20 -0400
Received: from out-77.mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2141BF1
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:43:19 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691019797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ev3SDPunXCWTJ1ggdNe8DIBa+5NRmW648ATtklgt00s=;
        b=Ltqa8JWbMUVOjaT8qW3VzXAOkI2/kjx1ZSnOT33u5pU/ahtkHKayj3UndqwmYJ4LiyaPMl
        llSjjE6oYf4kDPCOxv1+2HVdCDnaOhCS9BiUS2FmaTfaP/piK+jydhUJZe+nS1trsUoXVw
        uZgaCgt3XPjKeIaqpK13rS4ouvx1hwM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v3 03/17] Update psci.h to Linux 6.5-rc1
Date:   Wed,  2 Aug 2023 23:42:41 +0000
Message-ID: <20230802234255.466782-4-oliver.upton@linux.dev>
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to do PSCI emulation in kvmtool, we're going to need to pull in
a few more definitions.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 include/linux/psci.h | 47 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/include/linux/psci.h b/include/linux/psci.h
index 310d83e0a91b..42a40ad3fb62 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * ARM Power State and Coordination Interface (PSCI) header
  *
@@ -46,6 +47,28 @@
 #define PSCI_0_2_FN64_MIGRATE			PSCI_0_2_FN64(5)
 #define PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU	PSCI_0_2_FN64(7)
 
+#define PSCI_1_0_FN_PSCI_FEATURES		PSCI_0_2_FN(10)
+#define PSCI_1_0_FN_CPU_FREEZE			PSCI_0_2_FN(11)
+#define PSCI_1_0_FN_CPU_DEFAULT_SUSPEND		PSCI_0_2_FN(12)
+#define PSCI_1_0_FN_NODE_HW_STATE		PSCI_0_2_FN(13)
+#define PSCI_1_0_FN_SYSTEM_SUSPEND		PSCI_0_2_FN(14)
+#define PSCI_1_0_FN_SET_SUSPEND_MODE		PSCI_0_2_FN(15)
+#define PSCI_1_0_FN_STAT_RESIDENCY		PSCI_0_2_FN(16)
+#define PSCI_1_0_FN_STAT_COUNT			PSCI_0_2_FN(17)
+
+#define PSCI_1_1_FN_SYSTEM_RESET2		PSCI_0_2_FN(18)
+#define PSCI_1_1_FN_MEM_PROTECT			PSCI_0_2_FN(19)
+#define PSCI_1_1_FN_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN(20)
+
+#define PSCI_1_0_FN64_CPU_DEFAULT_SUSPEND	PSCI_0_2_FN64(12)
+#define PSCI_1_0_FN64_NODE_HW_STATE		PSCI_0_2_FN64(13)
+#define PSCI_1_0_FN64_SYSTEM_SUSPEND		PSCI_0_2_FN64(14)
+#define PSCI_1_0_FN64_STAT_RESIDENCY		PSCI_0_2_FN64(16)
+#define PSCI_1_0_FN64_STAT_COUNT		PSCI_0_2_FN64(17)
+
+#define PSCI_1_1_FN64_SYSTEM_RESET2		PSCI_0_2_FN64(18)
+#define PSCI_1_1_FN64_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN64(20)
+
 /* PSCI v0.2 power state encoding for CPU_SUSPEND function */
 #define PSCI_0_2_POWER_STATE_ID_MASK		0xffff
 #define PSCI_0_2_POWER_STATE_ID_SHIFT		0
@@ -56,6 +79,13 @@
 #define PSCI_0_2_POWER_STATE_AFFL_MASK		\
 				(0x3 << PSCI_0_2_POWER_STATE_AFFL_SHIFT)
 
+/* PSCI extended power state encoding for CPU_SUSPEND function */
+#define PSCI_1_0_EXT_POWER_STATE_ID_MASK	0xfffffff
+#define PSCI_1_0_EXT_POWER_STATE_ID_SHIFT	0
+#define PSCI_1_0_EXT_POWER_STATE_TYPE_SHIFT	30
+#define PSCI_1_0_EXT_POWER_STATE_TYPE_MASK	\
+				(0x1 << PSCI_1_0_EXT_POWER_STATE_TYPE_SHIFT)
+
 /* PSCI v0.2 affinity level state returned by AFFINITY_INFO */
 #define PSCI_0_2_AFFINITY_LEVEL_ON		0
 #define PSCI_0_2_AFFINITY_LEVEL_OFF		1
@@ -66,6 +96,10 @@
 #define PSCI_0_2_TOS_UP_NO_MIGRATE		1
 #define PSCI_0_2_TOS_MP				2
 
+/* PSCI v1.1 reset type encoding for SYSTEM_RESET2 */
+#define PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET	0
+#define PSCI_1_1_RESET_TYPE_VENDOR_START	0x80000000U
+
 /* PSCI version decoding (independent of PSCI version) */
 #define PSCI_VERSION_MAJOR_SHIFT		16
 #define PSCI_VERSION_MINOR_MASK			\
@@ -75,6 +109,18 @@
 		(((ver) & PSCI_VERSION_MAJOR_MASK) >> PSCI_VERSION_MAJOR_SHIFT)
 #define PSCI_VERSION_MINOR(ver)			\
 		((ver) & PSCI_VERSION_MINOR_MASK)
+#define PSCI_VERSION(maj, min)						\
+	((((maj) << PSCI_VERSION_MAJOR_SHIFT) & PSCI_VERSION_MAJOR_MASK) | \
+	 ((min) & PSCI_VERSION_MINOR_MASK))
+
+/* PSCI features decoding (>=1.0) */
+#define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT	1
+#define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_MASK	\
+			(0x1 << PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT)
+
+#define PSCI_1_0_OS_INITIATED			BIT(0)
+#define PSCI_1_0_SUSPEND_MODE_PC		0
+#define PSCI_1_0_SUSPEND_MODE_OSI		1
 
 /* PSCI return values (inclusive of all PSCI versions) */
 #define PSCI_RET_SUCCESS			0
@@ -86,5 +132,6 @@
 #define PSCI_RET_INTERNAL_FAILURE		-6
 #define PSCI_RET_NOT_PRESENT			-7
 #define PSCI_RET_DISABLED			-8
+#define PSCI_RET_INVALID_ADDRESS		-9
 
 #endif /* _UAPI_LINUX_PSCI_H */
-- 
2.41.0.585.gd2178a4bd4-goog

