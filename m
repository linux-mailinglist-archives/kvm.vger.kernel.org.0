Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC21667E4B0
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjA0MKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjA0MJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:09:48 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3338325E37;
        Fri, 27 Jan 2023 04:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3PXBb4SSqTJtAHYbgMwbsFsilPhoJvLJat1+V5pGRk=;
 b=teCllaDYprHB57RNGMDs+MbVsedMgn2+Yw86C637bEdiObkB8PsfAWv+Y+XxPOLH4msvA/gJwPUq702toOWO1xcIZHPnX9Ep2ySWBmFkoYHHikDbtkO0/YgX+9ofJQmHikee+DPXXkc5JdrxMfzk4bxDsYUMbuR6KPzBJaU1dms=
Received: from DB6PR0301CA0015.eurprd03.prod.outlook.com (2603:10a6:4:3e::25)
 by AS8PR08MB5878.eurprd08.prod.outlook.com (2603:10a6:20b:29b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:13 +0000
Received: from DBAEUR03FT003.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:3e:cafe::e2) by DB6PR0301CA0015.outlook.office365.com
 (2603:10a6:4:3e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT003.mail.protection.outlook.com (100.127.142.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:42:13 +0000
Received: ("Tessian outbound 0d7b2ab0f13d:v132"); Fri, 27 Jan 2023 11:42:13 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f10d6ff2762418f7
X-CR-MTA-TID: 64aa7808
Received: from 4942fa1c6f02.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 92B6480C-80AA-44BC-AC6F-3CA257DF5AB0.1;
        Fri, 27 Jan 2023 11:42:05 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 4942fa1c6f02.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwOjveYkIk9iEBPUHRkXVu+3flM8sABzyumrJwn/UEhm2fy4ZgCY73hZMdbaGXA3vukJc112WnmJE/xb6iauiOgAdfDlE0J02SVSEc8jhJZtm+trwsBVIL6FWSXAojCnxaBbqoom2ZyeBc3TI3Ww1rd2ipknyBVRt2QifTNDKGAf1f1RU0A1y7jB87swNw1aiSpwKbYbciGXOKLErKahBGUkgVnt/kVmegW0zY3hJ+hwLfpJdbbHNnXQIXaeCIhi/vPEqS0vLoL/JafN920WoG6Qwl+XVWaDWiBmRWHUpNU3NxGAf9KfgNycr0w+9gQKvAND32W5g4rbsoPiE8rSfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3PXBb4SSqTJtAHYbgMwbsFsilPhoJvLJat1+V5pGRk=;
 b=WoTXprq/EWjq4tC+imzQgrFrp01cxfjYqESgLllb8yeOE3Tr1Tc1Qc2k/l/dUtvWeBS9A/x/ZreI88uGJKQ3z2Upml/voSOmjgGQdLByUFQ8WGjewqUOq5h8YvW7cKU6x216JqE1USezmvnUjsyV07red16I60MAZi+nyJ2ZjHdoJUvAu1hCAmZ//M0ts9lFuXsOIlfSmLpiwZxtqDQ94HeiJCdAjQLYfppxZQIuWH0pudLwU5zg//nTKBXC8l3j4xkBRnen1HjtOvVX8JCJWbzTKsG5SOKOYvqh6zcCu9u1DsN6zmWOtuvPlplb5MmOL3hMMYvBjNsuG2WkXsoqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3PXBb4SSqTJtAHYbgMwbsFsilPhoJvLJat1+V5pGRk=;
 b=teCllaDYprHB57RNGMDs+MbVsedMgn2+Yw86C637bEdiObkB8PsfAWv+Y+XxPOLH4msvA/gJwPUq702toOWO1xcIZHPnX9Ep2ySWBmFkoYHHikDbtkO0/YgX+9ofJQmHikee+DPXXkc5JdrxMfzk4bxDsYUMbuR6KPzBJaU1dms=
Received: from AM5PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:206:1::23)
 by VE1PR08MB5583.eurprd08.prod.outlook.com (2603:10a6:800:1ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:42:03 +0000
Received: from AM7EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:1:cafe::45) by AM5PR04CA0010.outlook.office365.com
 (2603:10a6:206:1::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT005.mail.protection.outlook.com (100.127.140.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.25 via Frontend Transport; Fri, 27 Jan 2023 11:42:02 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:01 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:55 +0000
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
Subject: [RFC kvm-unit-tests 08/27] arm: realm: Realm initialisation
Date:   Fri, 27 Jan 2023 11:40:49 +0000
Message-ID: <20230127114108.10025-9-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT005:EE_|VE1PR08MB5583:EE_|DBAEUR03FT003:EE_|AS8PR08MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: a11d7623-678e-403a-8ef8-08db005b8855
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: l1n7+XZjSyqfW/XOP8i0HXiuC0odLH+5j+ZTSyT9gGkaRekbTisuAFI2rf+E9S3uoxHXu39O2eDwNo/s9tyKbU3QlifTtTLRkOOUmGdDFG/SU/I/4sbm97AbqXWavs1s8WqOWEvo8FNEEM0FeYk7f5QjYjgjprHnS+WPIIhwfRaFx08Sxw16xGBSk3fowbrAF559a6tqdnsLVHkpXY9ylLFzm/XUc/7l5Xe1+gw8HFwK3t0hXpFnPokRwRKYZ6zaOkYH+Ip/BulhaizmSR6qDVJ+l4RVT08QsjR2DRS62T1eQ3KokqmYtQZ5hYOlDnXQIQ0/p02Zh4L5yrR+t0UtyUGvjHgWiGKyeKgOR+E95dmlxWLGeHIJvBIkIdGEVhGoGVW3L2koi/Cgb3FNgFLU8nGRVV6gFU5SE6n7M7zGxyytYYDEUvAdMzas/yezCLpXRaXoFLtj5HAl/ag1qKGr2oBg8zFSZuS470yPT320w1dyFZ71T9uGErO4dn2xHlkvZh6GzL1jTnPgSpriQ4wNRPrflbuFj/nWbJ8PFVWpZtF3suCj70j7OIcKKUlQhhNslcXd+07oBNQh7LvdbzAX+2f8wqWiG/ZODejxg9hz4UPHIVj1RaW6mafvBe206lnAAR8RPPmfv47gnCvtMn2XIzUgVcabcaV3v5jDPRXbVVw3rUcvXkxSLeR2iN6DcFUpUsdpI82wUYCCj+298bv5OyQ0wyWbmeNmCe93ySfTXkR7fVOMQ0ahsG1b2lO2eRWG
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(81166007)(8676002)(36756003)(86362001)(82740400003)(40480700001)(44832011)(2906002)(426003)(4326008)(1076003)(6666004)(7416002)(40460700003)(83380400001)(186003)(41300700001)(26005)(8936002)(5660300002)(478600001)(336012)(70586007)(54906003)(316002)(82310400005)(70206006)(356005)(47076005)(36860700001)(2616005)(110136005)(7696005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5583
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 246d5100-1af4-47aa-93e9-08db005b8239
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4iv4DSJtmsF+hdrol573rbCJX1lSxH+6UQ4LrB6+WLYocORc0OmY13AbM3oEHFZL+jPtGEv2Xkp5yuTEshprKOSxIclRqr4xURIFlLW1jZO1TtACQC5H3lhvuaKW5ymY7siJHuXZ+yt5HkxmI7rrj/C4VxpD/AmlmCrA25AaIfVJ6IoY9qk83fo4KaKmCYIUpA4nEH6Q4nBUQBV5oGNSnNZ7RZlQ8nsmnkkHFnTztrVkYqP31QPypm86VaAYeBEIA84KJblh58AULE0+AR1okuDV+zSHfQb05Z6r4qJD2Wx2oM5KWzT8xht3Iz4K2SfkEbOj1G965yRB8XMIclZlpxy9A1zKVpOGCztJP1aw8NoNl5PCmSjXOwk1XSQSJ7kf9VL+NwaEvEHGoZZoQ36lZk2lTDxjJ8tf0iZ+/UwMf7U16NMmjKLZMXGufOGbaLKNOIbpt43Hpin1X5BNvlNo7NKihokGW5ayqQMZXoEjT98Hag0NCfApPpM45OfWZ4igBBW78Mo9iht7X0qjpEpS2ZGCEOCwWr+YAImudOaRPJNVhXZTAPN1NWJ4L+8EmC8FSFbvL3F3bqqUFvoIe1VK+qpkMKfOYtqpheTUObao1TLLN6XVpcLU+XrCEjOmlXJjmvCkhoWiZtSvMwqZhPaUPfXB0XMxyxYy9Qelj2jvFBwLjyMuZ+fCG01veSI7PhQpatBzXhkWEpx6j8bZmEsrAVCNCyOiyRsmgsLkdhAAR54=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(82310400005)(36860700001)(1076003)(2616005)(8936002)(81166007)(40460700003)(2906002)(44832011)(110136005)(54906003)(82740400003)(316002)(7696005)(41300700001)(478600001)(426003)(86362001)(40480700001)(83380400001)(186003)(26005)(6666004)(70586007)(70206006)(47076005)(8676002)(450100002)(36756003)(5660300002)(336012)(4326008)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:13.2233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a11d7623-678e-403a-8ef8-08db005b8855
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5878
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During the boot, run a check for the presence of RMM. If we are Realm,
detect the Realm configuration using RSI and initialise the key parameters.

Also expose a helper to indicate if this is running inside a Realm

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64        |  1 +
 lib/arm/asm/rsi.h         | 16 ++++++++++
 lib/arm/setup.c           |  3 ++
 lib/arm64/asm/processor.h |  8 +++++
 lib/arm64/asm/rsi.h       | 36 +++++++++++++++++++++
 lib/arm64/rsi.c           | 67 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 131 insertions(+)
 create mode 100644 lib/arm/asm/rsi.h
 create mode 100644 lib/arm64/asm/rsi.h
 create mode 100644 lib/arm64/rsi.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 42e18e77..ab557f84 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -24,6 +24,7 @@ cstart.o = $(TEST_DIR)/cstart64.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
+cflatobjs += lib/arm64/rsi.o
 
 OBJDIRS += lib/arm64
 
diff --git a/lib/arm/asm/rsi.h b/lib/arm/asm/rsi.h
new file mode 100644
index 00000000..d1f72c25
--- /dev/null
+++ b/lib/arm/asm/rsi.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef __ASMARM_RSI_H_
+#define __ASMARM_RSI_H_
+
+#include <stdbool.h>
+
+static inline bool is_realm(void)
+{
+	return false;
+}
+
+#endif /* __ASMARM_RSI_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 65d98e97..36d4d826 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -24,6 +24,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
+#include <asm/rsi.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
 #include <asm/psci.h>
@@ -244,6 +245,8 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	u32 fdt_size;
 	int ret;
 
+	arm_rsi_init();
+
 	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
 	freemem = (void *)(unsigned long)freemem_start;
 
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1c73ba32..320ebaef 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -114,6 +114,14 @@ static inline unsigned long get_id_aa64mmfr0_el1(void)
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
 
+static inline unsigned long get_id_aa64pfr0_el1(void)
+{
+	return read_sysreg(id_aa64pfr0_el1);
+}
+
+#define ID_AA64PFR0_EL1_EL3	(0xf << 12)
+#define ID_AA64PFR0_EL1_EL3_NI	(0x0 << 12)
+
 static inline bool system_supports_granule(size_t granule)
 {
 	u32 shift;
diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
new file mode 100644
index 00000000..8b9b91b2
--- /dev/null
+++ b/lib/arm64/asm/rsi.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef __ASMARM64_RSI_H_
+#define __ASMARM64_RSI_H_
+
+#include <stdbool.h>
+
+#include <asm/arm-smccc.h>
+#include <asm/io.h>
+#include <asm/smc-rsi.h>
+
+#define RSI_GRANULE_SIZE	SZ_4K
+
+extern bool rsi_present;
+
+void arm_rsi_init(void);
+
+int rsi_invoke(unsigned int function_id, unsigned long arg0,
+	       unsigned long arg1, unsigned long arg2,
+	       unsigned long arg3, unsigned long arg4,
+	       unsigned long arg5, unsigned long arg6,
+	       unsigned long arg7, unsigned long arg8,
+	       unsigned long arg9, unsigned long arg10,
+	       struct smccc_result *result);
+
+int rsi_get_version(void);
+
+static inline bool is_realm(void)
+{
+	return rsi_present;
+}
+
+#endif /* __ASMARM64_RSI_H_ */
diff --git a/lib/arm64/rsi.c b/lib/arm64/rsi.c
new file mode 100644
index 00000000..23a4e963
--- /dev/null
+++ b/lib/arm64/rsi.c
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#include <libcflat.h>
+
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/rsi.h>
+
+bool rsi_present;
+
+int rsi_invoke(unsigned int function_id, unsigned long arg0,
+	       unsigned long arg1, unsigned long arg2,
+	       unsigned long arg3, unsigned long arg4,
+	       unsigned long arg5, unsigned long arg6,
+	       unsigned long arg7, unsigned long arg8,
+	       unsigned long arg9, unsigned long arg10,
+	       struct smccc_result *result)
+{
+	return arm_smccc_smc(function_id, arg0, arg1, arg2, arg3, arg4, arg5,
+			     arg6, arg7, arg8, arg9, arg10, result);
+}
+
+struct rsi_realm_config __attribute__((aligned(RSI_GRANULE_SIZE))) config;
+
+static unsigned long rsi_get_realm_config(struct rsi_realm_config *cfg)
+{
+	struct smccc_result res;
+
+	rsi_invoke(SMC_RSI_REALM_CONFIG, __virt_to_phys((unsigned long)cfg),
+		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	return res.r0;
+}
+
+int rsi_get_version(void)
+{
+	struct smccc_result res = {};
+	int ret;
+
+	if ((get_id_aa64pfr0_el1() & ID_AA64PFR0_EL1_EL3) == ID_AA64PFR0_EL1_EL3_NI)
+		return -1;
+
+	ret = rsi_invoke(SMC_RSI_ABI_VERSION, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		         &res);
+	if (ret)
+		return ret;
+
+	return res.r0;
+}
+
+void arm_rsi_init(void)
+{
+	if (rsi_get_version() != RSI_ABI_VERSION)
+		return;
+
+	if (rsi_get_realm_config(&config))
+		return;
+
+	rsi_present = true;
+
+	phys_mask_shift = (config.ipa_width - 1);
+	/* Set the upper bit of the IPA as the NS_SHARED pte attribute */
+	prot_ns_shared = (1UL << phys_mask_shift);
+}
-- 
2.17.1

