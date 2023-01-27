Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34D67E410
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbjA0LsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjA0Lrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:47:37 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe16::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8984521971;
        Fri, 27 Jan 2023 03:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAU9Jgz+nQreSzKTkls21fkkUSuTh4SKSeI2vmAyKUU=;
 b=75tQeKiwqMW67204SrfhDlHcJnZyDxaHRQypFqOHW8ppth8NoVbJ2MesTAxmAcNBWL6QwpO0KCwIepIgrFuUbN9PZNSMOv3z5gSIbxBFGXz0Y7n2UkZOnBg1xMCTEoBJmjcvQdLR96L80IhyYVrTpVDJL6/RZpLduUrpr6vOlUs=
Received: from DUZPR01CA0085.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::17) by DU0PR08MB7948.eurprd08.prod.outlook.com
 (2603:10a6:10:3e0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:43:53 +0000
Received: from DBAEUR03FT030.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:46a:cafe::4e) by DUZPR01CA0085.outlook.office365.com
 (2603:10a6:10:46a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.34 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT030.mail.protection.outlook.com (100.127.142.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:43:53 +0000
Received: ("Tessian outbound 6e565e48ed4a:v132"); Fri, 27 Jan 2023 11:43:53 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: bdea91f2db7b85cc
X-CR-MTA-TID: 64aa7808
Received: from cfce6ef35b14.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2FFD23B1-21B3-4251-BC26-5FDF25251ACC.1;
        Fri, 27 Jan 2023 11:43:46 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cfce6ef35b14.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKP7VgpkPLaMMTn3asblc203JyxWehrF7Z8DpFutJYeUtb9U+Y8USc7R0nXxQXZ1YYuJ2hk92irkAsgG9qzTwjreZIuws0l7IMsBbbSVk1WDVY5r/ulejpdaQ1OjjHN8/TRdGzmpVkXr+oYr3MjHMOCwt3FJM67Z0gO19LHwXWwittwU6ozr7IBNBj/KTNoz+kv7rom9rmU6mAppepzCE17Sz+ZCdHRauBwbgdStv06jH++9nZgmZnsADU23QRdeAlN/Aj7EXhT1uGbLu2r3J7vn8eeoz4/E/Ybh4zxykqjxHigIQiZ8Wb1PwLCFYu/Rdi56SMFkHFa9SCwYDcmMiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAU9Jgz+nQreSzKTkls21fkkUSuTh4SKSeI2vmAyKUU=;
 b=C/o3oYkYDQwpSslko86r3Vdlrd/7xwbUDdr6/QQRuocUJyoFMov8yadBnElM5VvVEUdP2u1vl8Q8Gkhag1juvD9/m5fIR4ShnUwZD6cVTnaw30sMOPnqWG/D03LZZxgoamw+1EBghffhjPe4bOP63kcB4Zw3j3IlnWETl778op2WyTzHHhC0oab4sxwMWYAhCJl9V+yQ/5zUvO+HKATDUoQ1ZnV6QQ28d1yzgPDaLs5QdMoY92HpXlySUifHxbKrHeGrcs+mmZ8XpVc8fjDIYpCqUZFCtR+PozPmYKq5HTu9ozz1AvtoPnkcQ+RXa5PVlYCdSMY7vyZ588QTkieH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAU9Jgz+nQreSzKTkls21fkkUSuTh4SKSeI2vmAyKUU=;
 b=75tQeKiwqMW67204SrfhDlHcJnZyDxaHRQypFqOHW8ppth8NoVbJ2MesTAxmAcNBWL6QwpO0KCwIepIgrFuUbN9PZNSMOv3z5gSIbxBFGXz0Y7n2UkZOnBg1xMCTEoBJmjcvQdLR96L80IhyYVrTpVDJL6/RZpLduUrpr6vOlUs=
Received: from AM6PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:20b:2e::20)
 by DU0PR08MB9934.eurprd08.prod.outlook.com (2603:10a6:10:402::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:43:43 +0000
Received: from AM7EUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:2e:cafe::49) by AM6PR05CA0007.outlook.office365.com
 (2603:10a6:20b:2e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT051.mail.protection.outlook.com (100.127.140.64) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:43:43 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:43 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:37 +0000
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
        <linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 26/27] arm: realm: Add a test for shared memory
Date:   Fri, 27 Jan 2023 11:41:07 +0000
Message-ID: <20230127114108.10025-27-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT051:EE_|DU0PR08MB9934:EE_|DBAEUR03FT030:EE_|DU0PR08MB7948:EE_
X-MS-Office365-Filtering-Correlation-Id: fa647c5b-d696-4d0b-0b10-08db005bc403
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: D45yi0Hl78fvSE8pvxxw5w6KIODVe8P3g15pwobflgGHqolMqMRHHjlBiOcvjIGo5nmtsVWqDBiTaFmUccU5rb4Z1hDyZZ/eksLuasMussDthphCqel3+rBAJmZSoum0YiuC7CQxG3COvZM2BsS3Oo6gZgz+fK0gF2EB7/rF6N8N2TjKOXx1IPnrFVVvQPMm1gn729lFvfE6O9qPGQDLCFfMPhqWBXnwFoOK+8n0QX7YVkdcbPy0JRlrNgTVschr1S+2ix9k2ip70gHKqHpwZXk4OIWrFHuZA5BM+9Pu/5cwAEP/XFdsghneoGhxmZPkNJnzhm5I5OZyYLKUtxqnuu0gtPD+zTx/M+//6TMl47RLV1oCWQxndc52IXRSbcNCh5+ECA8Ac4JT26eXU/JY3P0WffodL7QhIH/zFxoovJjslyGK/x8udxdipedGtIuzVGsTMSO/49DqVjrZEpvKj0s8JSmpZcC24uAbEKMGR+r9gr69Y3/ZLzQcmY30nYQvPP0RxVsua0NK4Sd1gIeyHpVBIM2uekVcvCHbR02uhW+FDgohFrXE1/WGD18CbiPelvCCmYugZBzl6QbQMgMOSx5Iv4b6Xl5kkY+qR4Iu6kNoKf8694RV9hhgzPFCjvWtS/aVSCKk6h3/vJByCV1PxoeT2emQVkaVbgiglXR8eixRoTxPzlxot7rivXxVc6SaQXQ4QSs783Uw1NbEo6LDsTvG5VgCfdwOov555dIw+VLZhPjT71igqhpFjWc0hr0J
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(40470700004)(36840700001)(46966006)(44832011)(82740400003)(83380400001)(82310400005)(36860700001)(356005)(7416002)(336012)(5660300002)(426003)(8936002)(2906002)(2616005)(47076005)(81166007)(86362001)(186003)(26005)(7696005)(40480700001)(1076003)(478600001)(70206006)(6666004)(54906003)(40460700003)(4326008)(8676002)(110136005)(316002)(70586007)(36756003)(41300700001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9934
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: adaa99ea-621c-4e95-7e7a-08db005bbe3f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YTUBfZC3BlTsnX2KAMqSkT5mmSzCglTF9sTe7t5/swwL+P6fPyrzG2yDhGGSruPQco6RqFmzOcDfXR4QiRTD+PB5+dSLytSdoEO9lf21/OB4aRcK1hNAi7UrfLQSTe7RxdZTeIMXpHMeHN2tlna9RH41CMhBa4MBVUWO9gi15wtc5JRjoc4fmXYky5w/C34qkK/9oJirVAZy4dPVNR/9RdQK4EXyT12x8qeT3/QI+G+YuRW+x6HnSoPS4QVFG3Y9Q0NUMkU8dy1JXahWwMy7D5B7dMPssMVqEnImSyPHUUQmEzc3JJ+jAviEor3lwHz1vCEYCf3R6oFpkq2azMCwED/fHgSnxDWbJeH+g6vb9C4avG5GdmmxmUmTxcP8W8l4vXwvIwsbb6ROt13T+eN8W61p1fsKDYs2+Hl8Q4uVjvzZEIoIWyyOeA97E4pgWCY4jTSCRJHyT0i/FwpcVjx6UwV3PXTSGbGHT/Vr1wfFOb729MLmKcJbzZId+DNnqWARTNDwIebqnhqpTXYIRt6QVj1lrAqv692zpqStGu1NXprqXKTTViromtZCagJQdC5Dh1Jzoo6krYjmG71p7rIJlaN7z3L97WGOXXJDA4uBW8BBy/ulbmQjN2APCOqBXCYUrozB5fNA37Elqiird3rJMlAIEibVhD6TWjYNLe6BG/BfDDzRSE5yWyEdK1lP42B3xLClRtTody9f1sQE7ACPdKoJfArudQ2/+zGq8v7F8hs=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(36840700001)(46966006)(40470700004)(7696005)(478600001)(6666004)(336012)(2906002)(44832011)(26005)(4326008)(450100002)(186003)(1076003)(8676002)(70586007)(110136005)(70206006)(47076005)(54906003)(83380400001)(2616005)(426003)(36756003)(41300700001)(82740400003)(40460700003)(316002)(5660300002)(8936002)(81166007)(40480700001)(36860700001)(86362001)(82310400005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:53.3458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa647c5b-d696-4d0b-0b10-08db005bc403
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7948
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Do some basic tests that trigger marking a memory region as
RIPAS_EMPTY and accessing the shared memory. Also, convert it back
to RAM and make sure the contents are scrubbed.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64    |  1 +
 arm/realm-ns-memory.c | 86 +++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg     |  8 ++++
 3 files changed, 95 insertions(+)
 create mode 100644 arm/realm-ns-memory.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 0a0c4f2c..9b41e841 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -44,6 +44,7 @@ tests += $(TEST_DIR)/realm-rsi.flat
 tests += $(TEST_DIR)/realm-attest.flat
 tests += $(TEST_DIR)/realm-fpu.flat
 tests += $(TEST_DIR)/realm-sea.flat
+tests += $(TEST_DIR)/realm-ns-memory.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/realm-ns-memory.c b/arm/realm-ns-memory.c
new file mode 100644
index 00000000..8360c371
--- /dev/null
+++ b/arm/realm-ns-memory.c
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <asm/io.h>
+#include <alloc_page.h>
+#include <bitops.h>
+
+#define GRANULE_SIZE 	0x1000
+#define BUF_SIZE	(PAGE_SIZE * 2)
+#define BUF_PAGES	(BUF_SIZE / PAGE_SIZE)
+#define BUF_GRANULES	(BUF_SIZE / GRANULE_SIZE)
+
+static char __attribute__((aligned(PAGE_SIZE))) buffer[BUF_SIZE];
+
+static void static_shared_buffer_test(void)
+{
+	int i;
+
+	set_memory_decrypted((unsigned long)buffer, sizeof(buffer));
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE)
+		buffer[i] = (char)i;
+
+	/*
+	 * Verify the content of the NS buffer
+	 */
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE) {
+		if (buffer[i] != (char)i) {
+			report(false, "Failed to set Non Secure memory");
+			return;
+		}
+	}
+
+	/* Make the buffer back to protected... */
+	set_memory_encrypted((unsigned long)buffer, sizeof(buffer));
+	/* .. and check if the contents were destroyed */
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE) {
+		if (buffer[i] != 0) {
+			report(false, "Failed to scrub protected memory");
+			return;
+		}
+	}
+
+	report(true, "Conversion of protected memory to shared and back");
+}
+
+static void dynamic_shared_buffer_test(void)
+{
+	char *ns_buffer;
+	int i;
+	int order = get_order(BUF_PAGES);
+
+	ns_buffer = alloc_pages_shared(order);
+	assert(ns_buffer);
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE)
+		ns_buffer[i] = (char)i;
+
+	/*
+	 * Verify the content of the NS buffer
+	 */
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE) {
+		if (ns_buffer[i] != (char)i) {
+			report(false, "Failed to set Non Secure memory");
+			return;
+		}
+	}
+	free_pages_shared(ns_buffer);
+	report(true, "Dynamic allocation and free of shared memory\n");
+}
+
+static void ns_test(void)
+{
+	static_shared_buffer_test();
+	dynamic_shared_buffer_test();
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_pushf("ns-memory");
+	ns_test();
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e9e1cbd..8173ccfe 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -361,3 +361,11 @@ smp = 1
 extra_params = -m 32 -append 'measurement'
 accel = kvm
 arch = arm64
+
+[realm-ns-memory]
+file=realm-ns-memory.flat
+groups = nodefault realms
+smp = 1
+extra_params = -m 32
+accel = kvm
+arch = arm64
-- 
2.17.1

