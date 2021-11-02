Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211D14424AD
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 01:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhKBAZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 20:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbhKBAZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 20:25:19 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804A3C0613B9
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 17:22:39 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o6-20020a170902778600b0013c8ce59005so6774977pll.2
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 17:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oQnGvCOz4keJ5+U570faF9qbS7l4l0LO2nLR5m1MmaE=;
        b=CWf2Hnim1EskvJDGUXc6qWNnfMAazju3skN9odfbsYVloEo8BbNmtCPxtsnlCxRWss
         s5dYxk4Qft+iucKSSpW322aHL9FeajQAFVQTMxcGW02vHYlgxEhu+vkrJe77Zb2ugRwr
         tBKjAic300xT/K/OzvTIVaHEsJmLPrCd5zDoT3wxR+5hcAK0D9bBD6zNEuFeHM8BgHGh
         c8nGGNQGhYUiCqEdgPlVSe5ij6SEKj0azoSTSYFR+y2DkaHJNQTqpBKgY4TBFfrbfMXk
         p/TK1q3ywu6w6aDJgDXW8TML0trlBUmb9FfYpmtbzeC279iB0XQbKICbqeMD9eHOyXKZ
         IvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oQnGvCOz4keJ5+U570faF9qbS7l4l0LO2nLR5m1MmaE=;
        b=5Y0sqYzeA0+40XmtFwmxR8ZVS0KMzXr0LdqCkpupBU01z/ZKQMPdnpPdwSTwWxm58T
         2ZZrHD3iC3b2HBwQnwjuHFXNJzHphT5efpNnDAI1ysqm6DRkY+3HLnMQyAP4qDqpSlO3
         CA1tXk7QuvNTp0lLYiQVAhyLe0k6BUoGazvWYKz8fPw8byxwoth8ScbrF/6qIdqc6kEU
         Lbd/JUPq+q89ye4ZvWBONl1PS64OawDJVGxq+IZ5ukiSLdOndFwhKcs2fJE6+qTwMv2G
         uvobhg3TLXnA0OTunagWcbJGpX6NQajGLOm+KZydWDKd8LK7T/lyc2YBgoS5ztlP/L9N
         kyFg==
X-Gm-Message-State: AOAM530sbJ5ZM7zQBUEPj3h2NrsGZ6Hu7JMlh5laKVZNcLIfuyOKQl8s
        W1dHeurQLr25TuJkoRexxnU/sRWDCWtm
X-Google-Smtp-Source: ABdhPJyGvWZ7+T2rFxdjjiqc/GTxfjslCDUzKVpcszo/N2fFkYf47f8xeAQO6PAqD1XvebcAG8SZFRIirgU7
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1a4c:b0:44b:1fa6:532c with SMTP
 id h12-20020a056a001a4c00b0044b1fa6532cmr32459984pfv.64.1635812559023; Mon,
 01 Nov 2021 17:22:39 -0700 (PDT)
Date:   Tue,  2 Nov 2021 00:22:02 +0000
In-Reply-To: <20211102002203.1046069-1-rananta@google.com>
Message-Id: <20211102002203.1046069-8-rananta@google.com>
Mime-Version: 1.0
References: <20211102002203.1046069-1-rananta@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH 7/8] tools: Import ARM SMCCC definitions
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
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

Import the standard SMCCC definitions from include/linux/arm-smccc.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/include/linux/arm-smccc.h | 188 ++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)
 create mode 100644 tools/include/linux/arm-smccc.h

diff --git a/tools/include/linux/arm-smccc.h b/tools/include/linux/arm-smccc.h
new file mode 100644
index 000000000000..e3a24ae6863a
--- /dev/null
+++ b/tools/include/linux/arm-smccc.h
@@ -0,0 +1,188 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2015, Linaro Limited
+ */
+#ifndef __LINUX_ARM_SMCCC_H
+#define __LINUX_ARM_SMCCC_H
+
+#include <linux/const.h>
+
+/*
+ * This file provides common defines for ARM SMC Calling Convention as
+ * specified in
+ * https://developer.arm.com/docs/den0028/latest
+ *
+ * This code is up-to-date with version DEN 0028 C
+ */
+
+#define ARM_SMCCC_STD_CALL	        _AC(0,U)
+#define ARM_SMCCC_FAST_CALL	        _AC(1,U)
+#define ARM_SMCCC_TYPE_SHIFT		31
+
+#define ARM_SMCCC_SMC_32		0
+#define ARM_SMCCC_SMC_64		1
+#define ARM_SMCCC_CALL_CONV_SHIFT	30
+
+#define ARM_SMCCC_OWNER_MASK		0x3F
+#define ARM_SMCCC_OWNER_SHIFT		24
+
+#define ARM_SMCCC_FUNC_MASK		0xFFFF
+
+#define ARM_SMCCC_IS_FAST_CALL(smc_val)	\
+	((smc_val) & (ARM_SMCCC_FAST_CALL << ARM_SMCCC_TYPE_SHIFT))
+#define ARM_SMCCC_IS_64(smc_val) \
+	((smc_val) & (ARM_SMCCC_SMC_64 << ARM_SMCCC_CALL_CONV_SHIFT))
+#define ARM_SMCCC_FUNC_NUM(smc_val)	((smc_val) & ARM_SMCCC_FUNC_MASK)
+#define ARM_SMCCC_OWNER_NUM(smc_val) \
+	(((smc_val) >> ARM_SMCCC_OWNER_SHIFT) & ARM_SMCCC_OWNER_MASK)
+
+#define ARM_SMCCC_CALL_VAL(type, calling_convention, owner, func_num) \
+	(((type) << ARM_SMCCC_TYPE_SHIFT) | \
+	((calling_convention) << ARM_SMCCC_CALL_CONV_SHIFT) | \
+	(((owner) & ARM_SMCCC_OWNER_MASK) << ARM_SMCCC_OWNER_SHIFT) | \
+	((func_num) & ARM_SMCCC_FUNC_MASK))
+
+#define ARM_SMCCC_OWNER_ARCH		0
+#define ARM_SMCCC_OWNER_CPU		1
+#define ARM_SMCCC_OWNER_SIP		2
+#define ARM_SMCCC_OWNER_OEM		3
+#define ARM_SMCCC_OWNER_STANDARD	4
+#define ARM_SMCCC_OWNER_STANDARD_HYP	5
+#define ARM_SMCCC_OWNER_VENDOR_HYP	6
+#define ARM_SMCCC_OWNER_TRUSTED_APP	48
+#define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
+#define ARM_SMCCC_OWNER_TRUSTED_OS	50
+#define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
+
+#define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
+
+#define ARM_SMCCC_QUIRK_NONE		0
+#define ARM_SMCCC_QUIRK_QCOM_A6		1 /* Save/restore register a6 */
+
+#define ARM_SMCCC_VERSION_1_0		0x10000
+#define ARM_SMCCC_VERSION_1_1		0x10001
+#define ARM_SMCCC_VERSION_1_2		0x10002
+#define ARM_SMCCC_VERSION_1_3		0x10003
+
+#define ARM_SMCCC_1_3_SVE_HINT		0x10000
+
+#define ARM_SMCCC_VERSION_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0)
+
+#define ARM_SMCCC_ARCH_FEATURES_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 1)
+
+#define ARM_SMCCC_ARCH_SOC_ID						\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 2)
+
+#define ARM_SMCCC_ARCH_WORKAROUND_1					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x8000)
+
+#define ARM_SMCCC_ARCH_WORKAROUND_2					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x7fff)
+
+#define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_FUNC_QUERY_CALL_UID)
+
+/* KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74 */
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
+
+/* KVM "vendor specific" services */
+#define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
+#define ARM_SMCCC_KVM_NUM_FUNCS			128
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_FEATURES)
+
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+
+/*
+ * ptp_kvm is a feature used for time sync between vm and host.
+ * ptp_kvm module in guest kernel will get service from host using
+ * this hypercall ID.
+ */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_PTP)
+
+/* ptp_kvm counter type ID */
+#define KVM_PTP_VIRT_COUNTER			0
+#define KVM_PTP_PHYS_COUNTER			1
+
+/* Paravirtualised time calls (defined by ARM DEN0057A) */
+#define ARM_SMCCC_HV_PV_TIME_FEATURES				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x20)
+
+#define ARM_SMCCC_HV_PV_TIME_ST					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x21)
+
+/* TRNG entropy source calls (defined by ARM DEN0098) */
+#define ARM_SMCCC_TRNG_VERSION					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x50)
+
+#define ARM_SMCCC_TRNG_FEATURES					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x51)
+
+#define ARM_SMCCC_TRNG_GET_UUID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x52)
+
+#define ARM_SMCCC_TRNG_RND32					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x53)
+
+#define ARM_SMCCC_TRNG_RND64					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x53)
+
+/*
+ * Return codes defined in ARM DEN 0070A
+ * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
+ */
+#define SMCCC_RET_SUCCESS			0
+#define SMCCC_RET_NOT_SUPPORTED			-1
+#define SMCCC_RET_NOT_REQUIRED			-2
+#define SMCCC_RET_INVALID_PARAMETER		-3
+
+#endif /*__LINUX_ARM_SMCCC_H*/
\ No newline at end of file
-- 
2.33.1.1089.g2158813163f-goog

