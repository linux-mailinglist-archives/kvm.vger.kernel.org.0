Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D84367E402
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjA0Lrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbjA0LrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:47:18 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2065.outbound.protection.outlook.com [40.107.21.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE0F1EBEF;
        Fri, 27 Jan 2023 03:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3H/KofU7Yu6fUxSmEWe39E/Gu3RJjuYRpnxRF7mLwfI=;
 b=tV+JGkMrQftoQRTL2cVT7OiePpomSaEz3/ExHzrx31m4QRJof1jJMrFuIw9hJXH7dZx6z3QoryV79uJ+b5CmQJYrCPuT96h/HjUS1SSPX1Y+M3beNuw4HmVi0cnrUiTVQKLl2VDseKdlDaxPtiFVRro/mSy1CfxO/V5Crpjd8zQ=
Received: from AM5PR0701CA0015.eurprd07.prod.outlook.com
 (2603:10a6:203:51::25) by GV1PR08MB8215.eurprd08.prod.outlook.com
 (2603:10a6:150:5e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Fri, 27 Jan
 2023 11:42:51 +0000
Received: from AM7EUR03FT034.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:51:cafe::cf) by AM5PR0701CA0015.outlook.office365.com
 (2603:10a6:203:51::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.7 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT034.mail.protection.outlook.com (100.127.140.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:51 +0000
Received: ("Tessian outbound 8038f0863a52:v132"); Fri, 27 Jan 2023 11:42:50 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 94b28eb650647488
X-CR-MTA-TID: 64aa7808
Received: from 3fa6661c85f2.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 300BB85B-DF74-4B62-800A-70313A127B26.1;
        Fri, 27 Jan 2023 11:42:44 +0000
Received: from EUR02-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 3fa6661c85f2.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+Ae76UG64Rb+TLIKIHAW8AOZxboFRQK5wYukOtAUL5ttcTJezG/USJshtCFmjWMgIasIVwtU3ld2UtDsbGk0I6UwM8eUNfIBObSZT9mTSRQRtPUB4haEbdiGpW8ug2HLyIpjIkmUP8d7qntEFLjM7qzSTdq2BKe1jTLCb+ozHC/l+U0jnG1P68eOrQw2SZP0Y6EBwlM4io7Hd2CAtv6aF1bIojthDXhGo0i6MHPsGJv4GtG/ypc2tUmmoBmnA1VrtJz9JUtgL+VF8dca2YXSsKWAiAOjTDmBzRwdkeCtLMfmlAcwQRGfAi/8FeTM22bwqh8CKOJMGmOOi8XJMh0Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3H/KofU7Yu6fUxSmEWe39E/Gu3RJjuYRpnxRF7mLwfI=;
 b=eqkOLz+/+qVM94gD0N2ExU7ILB2C7TxD8Qlkotbj7DgpTuhRtNUD7OntQr110Cy7/EnpO0yGfJoye8EE6xWgeozwhaGFYGcJ5+zTIBVo+oz8mLLfbmi0qbWmy1nEol9ad8FoZcKl+MRRN3WPaJuMCT7NqevS1QVA9Up6/C9OFaiRKRt417j2JCMNYQBs81JSZuX44e7w8l2wg0Dtx75rLbzfTfF0YqAhFmZcNPlk877SwsTU1MGIswM4XKsvOrxI7EOt+llPaUWY0ppy1qlrFzLOttM+/QhlpQ1ooGlTD9Bc9jvsdBnCyJQiGnLgedJDjZxfc/ygqq9WAeB+aUhg7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3H/KofU7Yu6fUxSmEWe39E/Gu3RJjuYRpnxRF7mLwfI=;
 b=tV+JGkMrQftoQRTL2cVT7OiePpomSaEz3/ExHzrx31m4QRJof1jJMrFuIw9hJXH7dZx6z3QoryV79uJ+b5CmQJYrCPuT96h/HjUS1SSPX1Y+M3beNuw4HmVi0cnrUiTVQKLl2VDseKdlDaxPtiFVRro/mSy1CfxO/V5Crpjd8zQ=
Received: from AS9PR06CA0596.eurprd06.prod.outlook.com (2603:10a6:20b:486::31)
 by DB8PR08MB5452.eurprd08.prod.outlook.com (2603:10a6:10:111::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:41 +0000
Received: from AM7EUR03FT016.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:486:cafe::e3) by AS9PR06CA0596.outlook.office365.com
 (2603:10a6:20b:486::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT016.mail.protection.outlook.com (100.127.140.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:41 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:40 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:35 +0000
From:   Joey Gouly <joey.gouly@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Thomas Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        <linux-coco@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Subhasish Ghosh <subhasish.ghosh@arm.com>
Subject: [RFC kvm-unit-tests 15/27] arm: realm: Add test for FPU/SIMD context save/restore
Date:   Fri, 27 Jan 2023 11:40:56 +0000
Message-ID: <20230127114108.10025-16-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT016:EE_|DB8PR08MB5452:EE_|AM7EUR03FT034:EE_|GV1PR08MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 5038839f-aa68-4763-dd89-08db005b9ef2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 1sQTB5DLx+5RQCLMv9LvT5cZ+emGhI22P/936SHgbTE/PDSVRyAqb39bcPbb7BD56LM5DfCUk4n1YW17GFNRIFcu9nroeN4LxAj0rgugPV0a2MCd4Q0ZSdqEi7TpDsMAWEUbC2J+bo4gkqkZzcQJP5cXOnIilrK95NAXKWRIKSuLpBjgMTpf2/IHz8qaXllAsej8z2X/O99dVIva+41TDF5ey/IyTfepZn+lbS3JYH1avlPxBDGoORiETScXTjsIthnX8BZlsbD1ROftU+wiD1ygFhDtJPCRkoyt1oh518jKPHX2dlW6LsKNjzzsr194OHpuUQb9SKdjtjRbQ0PSfFPtXH2OpDnkbjw5CbTVYkojtNr9Erw7dlPjrcVFYHB8vnb7hGg8bUUVkhhdP0wkPpS4ogfjvD/yDB4ZWzHhB8G1ObqDgyaakygqBRjRlyZPRGt8zagzZPYUHhoLAOTq5taXJ+UDqinIObutW4HmtW2vUcLs1qNzhz1iuTuwkyBymbXZ949oUv6bUfupO4OEgTCKl0uraDylsQHF+84/zU01LsVslKq0G3krPBqy/XvvXFybejONOsyRLWLsAkShuKPAQyB3+EBy6IFQIOGwVIBiZK0+VyDOikPiPmotM1gFUgVgja4FjJmK8p/uIMBmMXlds+3+sGRhgc4RR35lHG9BdHdMK5AQga9obYViEAJ4LGm7AzXosAVW9fd3jy0yTBuNV7Z/gx/eO0/SeAUnhRwttrmf5SnOrV6Gj3l8O1we
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(36840700001)(40470700004)(46966006)(70586007)(4326008)(316002)(82310400005)(70206006)(8936002)(54906003)(36756003)(7416002)(5660300002)(8676002)(82740400003)(36860700001)(86362001)(356005)(81166007)(41300700001)(186003)(1076003)(26005)(6666004)(110136005)(336012)(426003)(47076005)(44832011)(40460700003)(40480700001)(2906002)(2616005)(478600001)(7696005)(83380400001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5452
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5cb29121-41b8-48ea-add8-08db005b994e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XDVM1yDjl0Fhfr1W9BmCZlVbLIfIsVH0+79XLVtWyD6Va22Nt8kgmsApvOtO/UxrTGT4g5pfPaf8ZQFRbgJjaO7Fu8lSkCoR3Yl8Wz1F+gqRUy6FIOOTSOjv4fLhjOwzB2XxaH3MRr9hQjgiBcpHUGhgb9XPcMiXwFqV5ma8aowG8M4bC0TCv+EGRpP8S4RXK6EPYst0+nFgRHHGOvQlNWN5qrdjDJRzsikTc2aa8MkiRV1UhIjYoMRM8Hc278JK6+cD1mDpmzmo9f+uXcD0GKre+cH+aPmSsdGcjy22SdcAQmDdbO3op90/51MERStIyuOOtB5y7pG9V0AYW0CehzKJjQVoMyvntOAKe6W+Szvq4yIwxSNP/D3GsjgwpJ/EPtIJXu9+qQiCHW0oh+qxFUj2Wc7h6E6aw84IGnjZ6eeM7Smt7UR2pt4seWIwc25CjHRbnJ2/tMJdH4p8BurNNKiaOjbdzXhVS9g0h2EPKgXIQ0RgPsUwX7mwXsl9XQyOcKhZx5IyqIcmHh7NrE37FyWa6rGHf6kGqe8FfcvOPs8nI+JfwP9UlJe+Hmv9UBlupevORWyPj5ijA2B2fR7OWelcedbhiwSi7KLAilNl9hhQEL0Dv2UckCeRDr3StyA9D4uZoYbe01ridKz7jyMvhgVtWIeQqJ07FBEjR6ASV08SKOalvJlVUS0TRjUCQrRSfR5M4+KDbCBRD2ji74s8JIKVTAr8iQg65Grv1jNrvus=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(81166007)(86362001)(336012)(82310400005)(40480700001)(36756003)(47076005)(186003)(2906002)(83380400001)(4326008)(41300700001)(36860700001)(316002)(44832011)(8676002)(5660300002)(426003)(450100002)(70206006)(478600001)(110136005)(54906003)(26005)(70586007)(6666004)(2616005)(82740400003)(1076003)(8936002)(7696005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:51.0860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5038839f-aa68-4763-dd89-08db005b9ef2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8215
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Subhasish Ghosh <subhasish.ghosh@arm.com>

Test that the FPU/SIMD registers are saved and restored correctly when
context switching VCPUs.

In order to test fpu/simd functionality, we need to make sure that
kvm-unit-tests doesn't generate code that uses the fpu registers, as that
might interfere with the test results. Thus make sure we compile the tests
with -mgeneral-regs-only.

Signed-off-by: Subhasish Ghosh <subhasish.ghosh@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64  |   1 +
 arm/Makefile.common |   1 +
 arm/realm-fpu.c     | 242 ++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   8 ++
 4 files changed, 252 insertions(+)
 create mode 100644 arm/realm-fpu.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index eed77d3a..90ec6815 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/micro-bench.flat
 tests += $(TEST_DIR)/cache.flat
 tests += $(TEST_DIR)/debug.flat
 tests += $(TEST_DIR)/realm-rsi.flat
+tests += $(TEST_DIR)/realm-fpu.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 1bbec64f..b339b62d 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -25,6 +25,7 @@ CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
+CFLAGS += -mgeneral-regs-only
 
 # We want to keep intermediate files
 .PRECIOUS: %.elf %.o
diff --git a/arm/realm-fpu.c b/arm/realm-fpu.c
new file mode 100644
index 00000000..35cfdf09
--- /dev/null
+++ b/arm/realm-fpu.c
@@ -0,0 +1,242 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <stdlib.h>
+
+#include <asm/rsi.h>
+
+#define CPU0_ID			0
+#define CPU1_ID			(CPU0_ID + 1)
+#define CPUS_MAX		(CPU1_ID + 1)
+#define RMM_FPU_QREG_MAX	32
+#define RMM_FPU_RESULT_PASS	(-1U)
+
+#define fpu_reg_read(val)				\
+({							\
+	uint64_t *__val = (val);			\
+	asm volatile("stp q0, q1, [%0], #32\n\t"	\
+		     "stp q2, q3, [%0], #32\n\t"	\
+		     "stp q4, q5, [%0], #32\n\t"	\
+		     "stp q6, q7, [%0], #32\n\t"	\
+		     "stp q8, q9, [%0], #32\n\t"	\
+		     "stp q10, q11, [%0], #32\n\t"	\
+		     "stp q12, q13, [%0], #32\n\t"	\
+		     "stp q14, q15, [%0], #32\n\t"	\
+		     "stp q16, q17, [%0], #32\n\t"	\
+		     "stp q18, q19, [%0], #32\n\t"	\
+		     "stp q20, q21, [%0], #32\n\t"	\
+		     "stp q22, q23, [%0], #32\n\t"	\
+		     "stp q24, q25, [%0], #32\n\t"	\
+		     "stp q26, q27, [%0], #32\n\t"	\
+		     "stp q28, q29, [%0], #32\n\t"	\
+		     "stp q30, q31, [%0], #32\n\t"	\
+		     : "=r" (__val)			\
+		     :					\
+		     : "q0", "q1", "q2", "q3",		\
+			"q4", "q5", "q6", "q7",		\
+			"q8", "q9", "q10", "q11",	\
+			"q12", "q13", "q14",		\
+			"q15", "q16", "q17",		\
+			"q18", "q19", "q20",		\
+			"q21", "q22", "q23",		\
+			"q24", "q25", "q26",		\
+			"q27", "q28", "q29",		\
+			"q30", "q31", "memory");	\
+})
+
+#define fpu_reg_write(val)			\
+do {						\
+	uint64_t *__val = (val);		\
+	asm volatile("ldp q0, q1, [%0]\n\t"	\
+		     "ldp q2, q3, [%0]\n\t"	\
+		     "ldp q4, q5, [%0]\n\t"	\
+		     "ldp q6, q7, [%0]\n\t"	\
+		     "ldp q8, q9, [%0]\n\t"	\
+		     "ldp q10, q11, [%0]\n\t"	\
+		     "ldp q12, q13, [%0]\n\t"	\
+		     "ldp q14, q15, [%0]\n\t"	\
+		     "ldp q16, q17, [%0]\n\t"	\
+		     "ldp q18, q19, [%0]\n\t"	\
+		     "ldp q20, q21, [%0]\n\t"	\
+		     "ldp q22, q23, [%0]\n\t"	\
+		     "ldp q24, q25, [%0]\n\t"	\
+		     "ldp q26, q27, [%0]\n\t"	\
+		     "ldp q28, q29, [%0]\n\t"	\
+		     "ldp q30, q31, [%0]\n\t"	\
+		     :				\
+		     : "r" (__val)		\
+		     : "q0", "q1", "q2", "q3",  \
+			"q4", "q5", "q6", "q7", \
+			"q8", "q9", "q10", "q11",\
+			"q12", "q13", "q14",	\
+			"q15", "q16", "q17",	\
+			"q18", "q19", "q20",	\
+			"q21", "q22", "q23",	\
+			"q24", "q25", "q26",	\
+			"q27", "q28", "q29",	\
+			"q30", "q31", "memory");\
+} while (0)
+
+static void nr_cpu_check(int nr)
+{
+	if (nr_cpus < nr)
+		report_abort("At least %d cpus required", nr);
+}
+/**
+ * @brief check if the FPU/SIMD register contents are the same as
+ * the input data provided.
+ */
+static uint32_t __realm_fpuregs_testall(uint64_t *indata)
+{
+	/* 128b aligned array to read data into */
+	uint64_t outdata[RMM_FPU_QREG_MAX * 2]
+			 __attribute__((aligned(sizeof(__uint128_t)))) = {
+			[0 ... ((RMM_FPU_QREG_MAX * 2) - 1)] = 0 };
+	uint8_t regcnt	= 0;
+	uint32_t result	= 0;
+
+	if (indata == NULL)
+		report_abort("invalid data pointer received");
+
+	/* read data from FPU registers */
+	fpu_reg_read(outdata);
+
+	/* check is the data is the same */
+	for (regcnt = 0; regcnt < (RMM_FPU_QREG_MAX * 2); regcnt += 2) {
+		if ((outdata[regcnt] != indata[regcnt % 4]) ||
+			(outdata[regcnt+1] != indata[(regcnt+1) % 4])) {
+			report_info(
+			"fpu/simd save/restore failed for reg: q%d expected: %lx_%lx received: %lx_%lx\n",
+			regcnt / 2, indata[(regcnt+1) % 4],
+			indata[regcnt % 4], outdata[regcnt+1],
+			outdata[regcnt]);
+		} else {
+			/* populate a bitmask indicating which
+			 * registers passed/failed
+			 */
+			result |= (1 << (regcnt / 2));
+		}
+	}
+
+	return result;
+}
+
+/**
+ * @brief writes randomly sampled data into the FPU/SIMD registers.
+ */
+static void __realm_fpuregs_writeall_random(uint64_t **indata)
+{
+
+	/* allocate 128b aligned memory */
+	*indata = memalign(sizeof(__uint128_t), sizeof(uint64_t) * 4);
+
+	/* populate the memory with sampled data from a counter */
+	(*indata)[0] = get_cntvct();
+	(*indata)[1] = get_cntvct();
+	(*indata)[2] = get_cntvct();
+	(*indata)[3] = get_cntvct();
+
+	/* write data into FPU registers */
+	fpu_reg_write(*indata);
+}
+
+static void realm_fpuregs_writeall_run(void *data)
+{
+
+	uint64_t **indata	= (uint64_t **)data;
+
+	__realm_fpuregs_writeall_random(indata);
+}
+
+static void realm_fpuregs_testall_run(void *data)
+{
+
+	uint64_t *indata	= (uint64_t *)data;
+	uint32_t result		= 0;
+
+	result = __realm_fpuregs_testall(indata);
+	report((result == RMM_FPU_RESULT_PASS),
+	       "fpu/simd register save/restore mask: 0x%x", result);
+}
+
+/**
+ * @brief This test uses two VCPU to test FPU/SIMD save/restore
+ * @details REC1 (vcpu1) writes random data into FPU/SIMD
+ * registers, REC0 (vcpu0) corrupts/overwrites the data and finally
+ * REC1 checks if the data remains unchanged in its context.
+ */
+static void realm_fpuregs_context_switch_cpu1(void)
+{
+	int target		= CPU1_ID;
+	uint64_t *indata_remote	= NULL;
+	uint64_t *indata_local	= NULL;
+
+	/* write data from REC1/VCPU1 */
+	on_cpu(target, realm_fpuregs_writeall_run, &indata_remote);
+
+	/* Overwrite from REC0/VCPU0 */
+	__realm_fpuregs_writeall_random(&indata_local);
+
+	/* check data consistency */
+	on_cpu(target, realm_fpuregs_testall_run, indata_remote);
+
+	free(indata_remote);
+	free(indata_local);
+}
+
+/**
+ * @brief This test uses two VCPU to test FPU/SIMD save/restore
+ * @details REC0 (vcpu0) writes random data into FPU/SIMD
+ * registers, REC1 (vcpu1) corrupts/overwrites the data and finally
+ * REC0 checks if the data remains unchanged in its context.
+ */
+static void realm_fpuregs_context_switch_cpu0(void)
+{
+
+	int target		= CPU1_ID;
+	uint64_t *indata_local	= NULL;
+	uint64_t *indata_remote	= NULL;
+	uint32_t result		= 0;
+
+	/* write data from REC0/VCPU0 */
+	__realm_fpuregs_writeall_random(&indata_local);
+
+	/* Overwrite from REC1/VCPU1 */
+	on_cpu(target, realm_fpuregs_writeall_run, &indata_remote);
+
+	/* check data consistency */
+	result = __realm_fpuregs_testall(indata_local);
+	report((result == RMM_FPU_RESULT_PASS),
+	       "fpu/simd register save/restore mask: 0x%x", result);
+
+	free(indata_remote);
+	free(indata_local);
+}
+/**
+ * checks if during realm context switch, FPU/SIMD registers
+ * are saved/restored.
+ */
+static void realm_fpuregs_context_switch(void)
+{
+
+	realm_fpuregs_context_switch_cpu0();
+	realm_fpuregs_context_switch_cpu1();
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_pushf("realm-fpu");
+
+	if (!is_realm())
+		report_skip("Not running in Realm world, skipping");
+
+	nr_cpu_check(CPUS_MAX);
+	realm_fpuregs_context_switch();
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 3cdb1a98..a60dc6a9 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -297,3 +297,11 @@ groups = nodefault realms
 extra_params = -append 'hvc'
 accel = kvm
 arch = arm64
+
+# Realm FPU/SIMD test
+[realm-fpu-context]
+file = realm-fpu.flat
+smp = 2
+groups = nodefault realms
+accel = kvm
+arch = arm64
-- 
2.17.1

