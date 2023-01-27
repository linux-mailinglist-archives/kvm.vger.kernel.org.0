Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495D067E442
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbjA0Lzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbjA0LzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:55:00 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on20613.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1a::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659F377DF6;
        Fri, 27 Jan 2023 03:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBnCN7QdJ8CYRLAqVvlj5JNGftuZbnrdU6WdPVMigKs=;
 b=knpPzsPz7n9YQw1GOhwwpl0pfhjsJo8wcsjObJRt+swLP6QkNS4mOqTfz1Ef6zrybR00mzl1Vbludz+aa2MlQGAw5zTqh3Pqwt2gojEHWHH54aCAmobhw9Yhk8otUWkVn//lT57+12p1duRNI7VodJdImvIfyKFy52RxZR/1nkY=
Received: from DUZPR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::11) by PAVPR08MB9040.eurprd08.prod.outlook.com
 (2603:10a6:102:32d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:34 +0000
Received: from DBAEUR03FT030.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:46a:cafe::ec) by DUZPR01CA0084.outlook.office365.com
 (2603:10a6:10:46a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.34 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:34 +0000
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
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:42:34 +0000
Received: ("Tessian outbound 8038f0863a52:v132"); Fri, 27 Jan 2023 11:42:34 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 989407ff5cb2e6bc
X-CR-MTA-TID: 64aa7808
Received: from 665dd25750ca.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4420A9C3-87BC-4116-98FE-BA2B14E1F1AF.1;
        Fri, 27 Jan 2023 11:42:27 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 665dd25750ca.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv7LIYB2Q253DlqNaBPN04dNmrXUuAlmJAEQEScytcbXm3FAnRzBUm8rJbugP3AUGXky5VFdjdg310U+rY+gLsPhwX7yIb5BLM+2bAlnByWzPUfy+mj0G/WOIx78wHxPTcLh/GWNcc5AYsvMAjftzSD2uNHgycYAFLUlB6oEjnCOBTW9zSIg2oQ58o7J64+KBGqmrTHMwrccZu5eOvItkzceUKu8SJptz+nveoWFmHoBV9svTkuA69XBgBkyTJehmmFutfM1dlFAiF3d/9D9QK1sp0fSoMPYB95KRAE7ljTpkGMiJb146FGbcHVUP/ZVm8XTFzm6d7rIGPapLGXcXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBnCN7QdJ8CYRLAqVvlj5JNGftuZbnrdU6WdPVMigKs=;
 b=Yl+XtsYF3lv8GyMHbSBb+UmW3TCDVO8lzdV3cx1kRmbpYewnN/W+mQ2nN26eoAye+LzEio6I9Xz0yTUe5SWvq65cHvuh95O8HXi/+EHlKvW6JUdLuGeIMp7fn6fK8qdSs1ar60W/CmT6jZgwylHmTKbGKy6yvMePc3Yr+/wZLUlCpp4qKr0emJ+L7O+Zg7qxJXNie/QbGWdvFGM4O6Lp+QbZlHDHgpiC9/msMi8qlBlvSRNjLUwv0P7PQeyIDhLraJoXzMQx+NzHrYE5BPFAwyIyjmNJU3p6EG46BlhtqA9VG5eFPdmrIBvLlZbrd0bJHO20g1brz6864mpIFT+rgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBnCN7QdJ8CYRLAqVvlj5JNGftuZbnrdU6WdPVMigKs=;
 b=knpPzsPz7n9YQw1GOhwwpl0pfhjsJo8wcsjObJRt+swLP6QkNS4mOqTfz1Ef6zrybR00mzl1Vbludz+aa2MlQGAw5zTqh3Pqwt2gojEHWHH54aCAmobhw9Yhk8otUWkVn//lT57+12p1duRNI7VodJdImvIfyKFy52RxZR/1nkY=
Received: from AS9PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:20b:497::31)
 by DU0PR08MB8186.eurprd08.prod.outlook.com (2603:10a6:10:3ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:25 +0000
Received: from AM7EUR03FT035.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:497:cafe::d5) by AS9PR05CA0139.outlook.office365.com
 (2603:10a6:20b:497::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT035.mail.protection.outlook.com (100.127.141.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:42:25 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:23 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:18 +0000
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
Subject: [RFC kvm-unit-tests 12/27] arm: realm: Add RSI version test
Date:   Fri, 27 Jan 2023 11:40:53 +0000
Message-ID: <20230127114108.10025-13-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT035:EE_|DU0PR08MB8186:EE_|DBAEUR03FT030:EE_|PAVPR08MB9040:EE_
X-MS-Office365-Filtering-Correlation-Id: e0dc1f79-745b-4219-29d9-08db005b94df
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: i3s6LwEfWeEBxbNWkoNA4XkHRLRr9m+ioxOaYmnSXfL8p1gjmiPg8dXZ6zipI9g7McSOHvpzd/GoiTX8abKjjrLcsWK9kguA/gHQ43JsWRrBdTm3pXRUNeAC2r1pxYKCVmXyu5U7GpG3RaVG9y/XVKn3gSYsWTEnoz4mK2WXRECtoq9qyaoDldgwuFydMQD5z2BumxRA2qrDJ6u4WdInffULbejT0NjpZ1dkvsc9YAodIRCDOJCVNCn8uKowMykDFrEd5cOirpiW1mZRxRQipi6KxXPRJuuvTIf9LqHWRi7YCJPgaaQsxrwpmR9lqV/3P17E+eLysJwQS5KFFEB5jHRnqh0ArXSUu53qjpo24YU2ZYHnvntmxdRnd6uhoF/L8Osjq1liIPuZqbNtXI46SYVMl1yoEO2HVMJx7iktTcoTqxCuFWDFB157HHjRz5EGLAu0uD6P2h29bdLpRwiXW8M4J1mr2HVPKOBs7qnzqXMWttXgTVsKNkw3cQP7T/1vaF8CxqkRLehBcFjYeapGQEJ2Wuqaj30AdGyTMUDiC3zRtQs1ft/iEiusrEi2qRaxAfd0a7JAAlX/KdjEziPy5MIAgrRSKerOJMp5wxnWxEuSOwyQHz/VHFIlDFdgieS/g4pDDrk67Km51Y1T/D2numYI6onQzU8Lok69OCPcuP07EQgYbKXgug346uGtoFo2sisyBrHMRh0tT29zyzR4+i5bqH0P8X1SlKnn6gBkrlOOzAx2fDvsxbcdCrndhqPA
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199018)(40470700004)(46966006)(36840700001)(2906002)(44832011)(7416002)(5660300002)(8936002)(47076005)(426003)(41300700001)(36860700001)(26005)(336012)(478600001)(2616005)(6666004)(186003)(1076003)(82740400003)(83380400001)(70206006)(40460700003)(81166007)(7696005)(86362001)(40480700001)(356005)(4326008)(70586007)(36756003)(82310400005)(8676002)(54906003)(316002)(110136005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8186
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 77adec84-efc2-4db8-853e-08db005b8f81
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /037Uc/XBIY9FcOd/cEUN4lInARi47/pgl3AGr1YcfC2zpfZDzyGtKcSgnJK9DEsRmW+yjL+kjO9RqoR/bEBqH0pXGijP6TuvkDB0oNFq1Nniv0Zt1cX+74yky+uhsPv4+ox7Dh/LELbCw993iK6mzc2I4y8lryrogWN6qDwqhf/5Q4scSQ8PzseQ+XyhXzC4x1Z9clf5qOlIQDyw1x9zvb1zyYBnAEnLUgtU2KR9wIM7/Q6Zx9SGayIwyX99cJD0mbAf2i6lHMeq5LaQoUgHm/zkszrdIEuMNPfe141K8KsHg1WDbIZwU1bPEJ/XcOZN6dM8mJ71i+geDtXs4dTffSm8A9FQwNY/xK7pb0N366Wpt3wSkFSXaP4v5O8Eav4R4Nj9RkkTfNj7jprF0hx5iA1mTYuaqTa6604hvWRYEWQYcqY90lauG+ImUd8gLfuFUYJ2dMa2AStaDu8FszeCAsozx3e/T0TAWIxytMtkhdcOnpb4kzd25Sg4OodBJVnU/BzYUxgRhLNB/YvGzbbYL70H44j6b2PlJhSyXvLPZcMY30LB0lTYcl12Ah2FnwFDtR24VYJG3b1xvTdlIBy4+ghe2SIcthKP3NZ3yQbUJLFNASV+O/bPobFaDaUgnaHIglI6X9R1FPG20uauV179Yn/qehGSLGBKJ+l2bn45kMZuE+9ZgnOhhrw5toPzjHmiWSuAx9YLgbTeW3KGSvR4CN2bpEVxDLGBZzNbD96dOk=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(8936002)(82310400005)(4326008)(1076003)(2616005)(82740400003)(81166007)(44832011)(36756003)(5660300002)(186003)(2906002)(7696005)(26005)(478600001)(86362001)(316002)(54906003)(110136005)(40460700003)(40480700001)(6666004)(70586007)(41300700001)(70206006)(83380400001)(8676002)(450100002)(336012)(426003)(47076005)(36860700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:34.2578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0dc1f79-745b-4219-29d9-08db005b94df
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9040
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add basic test for checking the RSI version command.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64 |  1 +
 arm/realm-rsi.c    | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |  7 +++++++
 3 files changed, 57 insertions(+)
 create mode 100644 arm/realm-rsi.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index ab557f84..eed77d3a 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -33,6 +33,7 @@ tests = $(TEST_DIR)/timer.flat
 tests += $(TEST_DIR)/micro-bench.flat
 tests += $(TEST_DIR)/cache.flat
 tests += $(TEST_DIR)/debug.flat
+tests += $(TEST_DIR)/realm-rsi.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/realm-rsi.c b/arm/realm-rsi.c
new file mode 100644
index 00000000..d793f305
--- /dev/null
+++ b/arm/realm-rsi.c
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <libcflat.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/psci.h>
+#include <alloc_page.h>
+#include <asm/rsi.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+
+static void rsi_test_version(void)
+{
+	int version;
+
+	report_prefix_push("version");
+
+	version = rsi_get_version();
+	if (version < 0) {
+		report(false, "SMC_RSI_ABI_VERSION failed (%d)", version);
+		return;
+	}
+
+	report(version == RSI_ABI_VERSION, "RSI ABI version %u.%u (expected: %u.%u)",
+	       RSI_ABI_VERSION_GET_MAJOR(version),
+	       RSI_ABI_VERSION_GET_MINOR(version),
+	       RSI_ABI_VERSION_GET_MAJOR(RSI_ABI_VERSION),
+	       RSI_ABI_VERSION_GET_MINOR(RSI_ABI_VERSION));
+	report_prefix_pop();
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_push("rsi");
+
+	if (!is_realm()) {
+		report_skip("Not a realm, skipping tests");
+		goto exit;
+	}
+
+	rsi_test_version();
+exit:
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e67b558..ce1b5ad9 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -275,3 +275,10 @@ file = debug.flat
 arch = arm64
 extra_params = -append 'ss-migration'
 groups = debug migration
+
+# Realm RSI ABI test
+[realm-rsi]
+file = realm-rsi.flat
+groups = nodefault realms
+accel = kvm
+arch = arm64
-- 
2.17.1

