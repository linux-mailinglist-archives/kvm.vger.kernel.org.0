Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2D567E4C7
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjA0MM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbjA0MMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:12:10 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D9D80172;
        Fri, 27 Jan 2023 04:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaUsEIZHo1VrruVAtMnFib52+x175EA8f+O2M+UzY6Q=;
 b=eMOQ2YlQknLEZLxRqds7Q0ND10bMQdFFP5C4NK+pASHiROz80P+9tSB22XSoI0s6UiKP16VbzGQUtxDfdMSo1hF6bmONRxKez1JrOQdf5feoSa0pMDhL2c3p3ymY7WCr4lhGGfy2k5xIwoPihYqxxs/VKr8amIkCr1KJlwXk4bI=
Received: from AM5PR0701CA0015.eurprd07.prod.outlook.com
 (2603:10a6:203:51::25) by AM9PR08MB6115.eurprd08.prod.outlook.com
 (2603:10a6:20b:2df::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:59 +0000
Received: from AM7EUR03FT004.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:51:cafe::b3) by AM5PR0701CA0015.outlook.office365.com
 (2603:10a6:203:51::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.7 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT004.mail.protection.outlook.com (100.127.140.210) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:42:59 +0000
Received: ("Tessian outbound 8038f0863a52:v132"); Fri, 27 Jan 2023 11:42:59 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 3093725a19c96cd7
X-CR-MTA-TID: 64aa7808
Received: from f5c94ac5c241.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 83963576-4C02-49FC-A89F-081568359FA4.1;
        Fri, 27 Jan 2023 11:42:53 +0000
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f5c94ac5c241.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baSuFzRt2dflh8qUwCRATN0ZwVVzoYJyECGABxAwVpPLACp8sRhVEa5qcv8v5M5rF4IkTKUj1CYXmWikg/ZbzNLtYw3l/dxEvo/dOyAIZw9YZw6iovAaxVLxISucczTYswvuox886ScAiCbOLzEbq7hiKHltIIVnBGglozvZk8Cn1MEkCgjrzDGYFGV+s8umv7SlKmZzh1Or1hYUMKE+x42kp80rhU+ch9qtgJRdlzxT+wjhCK5KJsjP9y2IzBhPJmXWB2Ww4+4sViZLXAdFJl2edUfyPzOI0zafJStzb6qUYMjkmA1ixgo2fsmjIilui/NnXbFgfjC+jgF1KcCheQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaUsEIZHo1VrruVAtMnFib52+x175EA8f+O2M+UzY6Q=;
 b=bI/z3IZmrkbobWK3uB9GWtzsKbNDM3Cjeay94EyA8jUK/bArUzdO02QQJzk0ZFj4JYqZxOgKkRebUhIUGsgz6Bo3bkqoP0nSa8EGxqq6aptWk2oAqFTRasoWoDZYgY504v+LcFq8unI/VAQ8PPqjV8NM8j9GZhQuHfH1jzAWwK2Ih3SoKzqYirY2hlP1cklBRaaWhCJU/kv3cpAErH9flG3JTCr2e7M/+7/aOg/WqygS8q5d8kujxBPa6oLCxCGFBsqYKI3xFmFyRzIIvexV+T5FYzrznmjDTho0nI1/wnmgBFg9t0NTcShFyOxG6aDRSCzkmgsZlRD4vq9pz+W4kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaUsEIZHo1VrruVAtMnFib52+x175EA8f+O2M+UzY6Q=;
 b=eMOQ2YlQknLEZLxRqds7Q0ND10bMQdFFP5C4NK+pASHiROz80P+9tSB22XSoI0s6UiKP16VbzGQUtxDfdMSo1hF6bmONRxKez1JrOQdf5feoSa0pMDhL2c3p3ymY7WCr4lhGGfy2k5xIwoPihYqxxs/VKr8amIkCr1KJlwXk4bI=
Received: from AM6PR05CA0001.eurprd05.prod.outlook.com (2603:10a6:20b:2e::14)
 by DBAPR08MB5749.eurprd08.prod.outlook.com (2603:10a6:10:1af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:47 +0000
Received: from AM7EUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:2e:cafe::79) by AM6PR05CA0001.outlook.office365.com
 (2603:10a6:20b:2e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT051.mail.protection.outlook.com (100.127.140.64) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:47 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:46 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:40 +0000
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
        Djordje Kovacevic <djordje.kovacevic@arm.com>
Subject: [RFC kvm-unit-tests 16/27] arm: realm: Add tests for in realm SEA
Date:   Fri, 27 Jan 2023 11:40:57 +0000
Message-ID: <20230127114108.10025-17-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT051:EE_|DBAPR08MB5749:EE_|AM7EUR03FT004:EE_|AM9PR08MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: b03713a0-1406-49a1-894e-08db005ba3ec
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: pZjh5UYrExFlcIRmFeDeH6ef2gX42Q8PIPTLlFMudGmyfpZs07oSGQjWVXBTYeEWOaL5XwihVAAWOMZGV1tMnZA4RapQ25SdgrmuB2oruHhiiMkxzSJIeyHx6Lr3t77i+nXLWQruT/GV9qQDTIB2e3Tp411U0SP3gtiIQ3SQoY9BHZA0wi5Bm8QwUJTpnMU7uJj6i2iUUrq45ZZ/Z2UfMKrdxmwYgm1SsAjIj6ZbHWyCX7m3rHgAfn71rQwn0E6VFo7NK30wtvihHGBZUj8WJAwffz9mDbK4bU+/TtXFVn7a7e+e1+Y6g4+8QHHYkS7LJTuH447diw1qxFGppl2kNuaiqjvLiZJOhcqKheSXREfMno1TRKODitG3mv+jO5sO8Pk6lSFMrxM+WVXCoFVSxTe18BsW42/fjrGzzIvKMqWfEPx3gQOzr7JkoNxphWOeGvkxUV2KjSHv7AXd0bRTpN87EU1EBHeRBM2ZTubBkjrAJvvFFoSmyV+lJLM5Xq9k+rKJikQhfP3LCLcAtDAkkgHE0KcBtNQkDwOewfbsio/w/+KrFMtm6Q38kp0V1nCmjzWDtfTcZbzJhoDzcLBA2XZnN+06b6+Yao6SISw27gXTTkAniOZiCc49HbYHV6XYGOqDuhFZic3rVLsOQ8u/hpVCtGkka13Y5Mbc55Q163kAXp3YiQyMaeXV7pyuLVcjiArqjpANQ4FPMJnOH1SRNTen3FAY+HgqDZQ/FiY/gM8RpDoK9VC9jGL7tzqZX78A
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199018)(40470700004)(36840700001)(46966006)(83380400001)(36860700001)(336012)(40460700003)(36756003)(82310400005)(82740400003)(426003)(316002)(5660300002)(110136005)(54906003)(47076005)(7416002)(356005)(2616005)(86362001)(40480700001)(81166007)(26005)(70586007)(186003)(7696005)(478600001)(6666004)(2906002)(4326008)(8936002)(70206006)(8676002)(1076003)(44832011)(41300700001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5749
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT004.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: d8c897ae-a372-4964-dd5a-08db005b9c9e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +5gcXLpgbdv2EmuhHbuzGWdIUE6/sfCADQaRH/TGtDoA1rsMZBPt/c3598nAb8oDHeNbkp6PjztYXSIt1ArtT+//mGhLYIZ2dfBOXrPZnaS3feP3ly+SNXZQQPnftt3bLzrJBL2mOhTvL7EB/nVn4B5lwJWwFWIPc0MCHYyOTrmbhPPgCGZyUMRskNGwxxT33sorsRd+B36i3EsyP3CeSH9QH8wQu9nl2aqs8NhXxiC77ccfKmwBYkYuJ/wBXLcj8fc7RLJBn7CtStrPv9k75QkomqzcqZdcZf9Ew/w/TQ8pG7pGc0EcfMhPH/DFJVCn2u4c9riso8j1sk4wEJFO1OdapH/UXx6RgzDtEpKVWCwqzdkHr/5ruf0qnR20AvfYTieXlptLBGonjZoif8LaLUsgJKX6yMQyS4oYVP0ef7M5TDeSY9cow7+OblREBv/mGCzAme3NezsrlSWOqko0ExCNQizzPD/3Xrs4cp+V2+hH2fU1NuSLdt0cyQKlt3Ba3QFVRSBXZhEDvS5IZGBi+O9REs2PLVyqtvkkD7kVgqugkx7GCBYgzaRC9HYe9QWECjlEpWvO1DP3Q770Ftg5mhq7h6eJeo2diWIF1g8gpzXXQgD/JGN96bumRkeiw/BEAQWx+rUYkT8di9Ost/D/0fli6wTrqJYfGkQ6P7F4tgbw8Rx5IdYX7oEDWujnb34228RY80hvLiCybmXpYlX+TC9fkF7uTemwhPYfZ70igPs=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199018)(46966006)(40470700004)(36840700001)(2906002)(44832011)(426003)(36860700001)(336012)(5660300002)(41300700001)(8936002)(1076003)(4326008)(81166007)(8676002)(478600001)(26005)(450100002)(186003)(6666004)(2616005)(82740400003)(47076005)(83380400001)(40460700003)(70586007)(7696005)(40480700001)(86362001)(36756003)(316002)(110136005)(70206006)(82310400005)(54906003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:59.4175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b03713a0-1406-49a1-894e-08db005ba3ec
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT004.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6115
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Djordje Kovacevic <djordje.kovacevic@arm.com>

The RMM/Host could inject Synchronous External Aborts in to the Realm
for various reasons.

RMM injects the SEA for :
  * Instruction/Data fetch from an IPA that is in RIPAS_EMPTY state
  * Instruction fetch from an Unprotected IPA.

Trigger these conditions from within the Realm and verify that the
SEAs are received.

Signed-off-by: Djordje Kovacevic <djordje.kovacevic@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64 |   1 +
 arm/realm-sea.c    | 143 +++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |   6 ++
 3 files changed, 150 insertions(+)
 create mode 100644 arm/realm-sea.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 90ec6815..8448af36 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -35,6 +35,7 @@ tests += $(TEST_DIR)/cache.flat
 tests += $(TEST_DIR)/debug.flat
 tests += $(TEST_DIR)/realm-rsi.flat
 tests += $(TEST_DIR)/realm-fpu.flat
+tests += $(TEST_DIR)/realm-sea.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/realm-sea.c b/arm/realm-sea.c
new file mode 100644
index 00000000..5ef3e2a4
--- /dev/null
+++ b/arm/realm-sea.c
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#include <libcflat.h>
+#include <vmalloc.h>
+#include <asm/ptrace.h>
+#include <asm/thread_info.h>
+#include <asm/mmu.h>
+#include <asm/rsi.h>
+#include <linux/compiler.h>
+#include <alloc_page.h>
+#include <asm/pgtable.h>
+
+typedef void (*empty_fn)(void);
+
+static bool test_passed;
+
+/*
+ * The virtual address of the page that the test has made the access to
+ * in order to cause the I/DAbort with I/DFSC = Synchronous External Abort.
+ */
+static void* target_page_va;
+
+/*
+ * Ensure that the @va is the executable location from EL1:
+ * - SCTLR_EL1.WXN must be off.
+ * - Disable the access from EL0 (controlled by AP[1] in PTE).
+ */
+static void enable_instruction_fetch(void* va)
+{
+	unsigned long sctlr = read_sysreg(sctlr_el1);
+	if (sctlr & SCTLR_EL1_WXN) {
+		sctlr &= ~SCTLR_EL1_WXN;
+		write_sysreg(sctlr, sctlr_el1);
+		isb();
+		flush_tlb_all();
+	}
+
+	mmu_clear_user(current_thread_info()->pgtable, (u64)va);
+}
+
+static void data_abort_handler(struct pt_regs *regs, unsigned int esr)
+{
+	if ((esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT)
+		test_passed = true;
+
+	report_info("esr = %x", esr);
+	/*
+	 * Advance the PC to complete the test.
+	 */
+	regs->pc += 4;
+}
+
+static void data_access_to_empty(void)
+{
+	test_passed = false;
+	target_page_va = alloc_page();
+	phys_addr_t empty_ipa = virt_to_phys(target_page_va);
+
+	arm_set_memory_shared(empty_ipa, SZ_4K);
+
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, data_abort_handler);
+	READ_ONCE(((char*)target_page_va)[0x55]);
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
+
+	report(test_passed, " ");
+}
+
+static void instruction_abort_handler(struct pt_regs *regs, unsigned int esr)
+{
+	if (((esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT) &&
+	     (regs->pc == (u64)target_page_va))
+		test_passed = true;
+
+	report_info("esr = %x", esr);
+	/*
+	 * Simulate the RET instruction to complete the test.
+	 */
+	regs->pc = regs->regs[30];
+}
+
+static void instr_fetch_from_empty(void)
+{
+	phys_addr_t empty_ipa;
+
+	test_passed = false;
+	target_page_va = alloc_page();
+	enable_instruction_fetch(target_page_va);
+
+	empty_ipa = virt_to_phys((void*)target_page_va);
+
+	arm_set_memory_shared(empty_ipa, SZ_4K);
+
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, instruction_abort_handler);
+	/*
+	 * This should cause the IAbort with IFSC = SEA
+	 */
+	((empty_fn)target_page_va)();
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
+
+	report(test_passed, " ");
+}
+
+static void instr_fetch_from_unprotected(void)
+{
+	test_passed = false;
+	/*
+	 * The test will attempt to execute an instruction from the start of
+	 * the unprotected IPA space.
+	 */
+	target_page_va = vmap(PTE_NS_SHARED, SZ_4K);
+	enable_instruction_fetch(target_page_va);
+
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, instruction_abort_handler);
+	/*
+	 * This should cause the IAbort with IFSC = SEA
+	 */
+	((empty_fn)target_page_va)();
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
+
+	report(test_passed, " ");
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_push("in_realm_sea");
+
+	report_prefix_push("data_access_to_empty");
+	data_access_to_empty();
+	report_prefix_pop();
+
+	report_prefix_push("instr_fetch_from_empty");
+	instr_fetch_from_empty();
+	report_prefix_pop();
+
+	report_prefix_push("instr_fetch_from_unprotected");
+	instr_fetch_from_unprotected();
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index a60dc6a9..bc2354c7 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -305,3 +305,9 @@ smp = 2
 groups = nodefault realms
 accel = kvm
 arch = arm64
+
+[realm-sea]
+file = realm-sea.flat
+groups = nodefault realms
+accel = kvm
+arch = arm64
-- 
2.17.1

