Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2C267E44D
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbjA0L5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjA0L4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:56:48 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00757D999;
        Fri, 27 Jan 2023 03:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LPirvCS090ii8x00q60vC8CmR1XvwhXOu0GKUUIIY0=;
 b=MNceCef5xhcEzMv0CP9yefRYmetyvnhJdaUwaBbgQ4DH/2wahnVWzrkyzpQDsCw1RXqYA9uMRSL6QqHX7wzl5GWE7cnfbrZiEmzpnVOUTv0mvBi9qO0IkZsMxmTy1LSexHAOf1Jh4JqhI3M7AKaa+YTsVp9V3KetY4YX5onLnGw=
Received: from DB6PR0402CA0014.eurprd04.prod.outlook.com (2603:10a6:4:91::24)
 by AS8PR08MB7919.eurprd08.prod.outlook.com (2603:10a6:20b:53a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Fri, 27 Jan
 2023 11:42:20 +0000
Received: from DBAEUR03FT025.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:91:cafe::41) by DB6PR0402CA0014.outlook.office365.com
 (2603:10a6:4:91::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT025.mail.protection.outlook.com (100.127.142.226) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:42:20 +0000
Received: ("Tessian outbound 43b0faad5a68:v132"); Fri, 27 Jan 2023 11:42:20 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 9bd9ecc9dc87ca10
X-CR-MTA-TID: 64aa7808
Received: from 3b00719e383c.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3F85915E-32AB-4BCC-946B-18C3739F12DB.1;
        Fri, 27 Jan 2023 11:42:13 +0000
Received: from EUR03-AM7-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 3b00719e383c.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrAvJ0Bo6Nd6TvUrqElZBwAhjYSS09Ch+IatBKizTGWo3iMmLJche31ZuUg8LR3nTIIJJLj/igPVkU6NRI2alqITDgX6ECpcTM9GYfmxd5RQYOwDzTVQqWs7U8o0WRTrpz4jcYM55Bsf3mGei4fC1nWX2oHTQ/J8YLvnhy4gFviupnwU+uzQVeCuMqVG+zzx40Oj0QolGcOu6+BMAvOgNsmxYSzbsbdcNP1usWPbjb/K+g/heiLrznBggCCP43W2Cq0i2c37nFzQ/G0aiNOaHyZ3VWE6RI/nvgfVwPQM4TH5aOzZUCIf5qxaaisTm6yw7CzLEFXD2R7afsmfUM8+Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LPirvCS090ii8x00q60vC8CmR1XvwhXOu0GKUUIIY0=;
 b=TCGoGqauAJNz1KM73ynZRh22GYMnAanTSEylvR4S6I9vMzaPMll8p1rTQGShmTByYIfpHXRmmZNeEcO7GyAYJU2a6wnMHSKrouzJ9x7Iliz+BRLH2DcITgHBqtjyDa9ImrhIZQODKfSWAKM1KlKPRvOVG5rKcVvSFv/+6r7pOQRwraPR1dkuVQFcm8+cOfOJnHuSvYqB86YbCBzIanYtToFRD1V99AtWL7+Al8UjZD2/wRezlWVFn9uTXvHUvSbjfMEl5xK2nRNXw6tc1eGDqJ9L4ooiA3tfVV3B/1Kx8Zxbv6XbGI5aiovTjXxR1+j1Iq4f8kB+5wsWPQ7wADgufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LPirvCS090ii8x00q60vC8CmR1XvwhXOu0GKUUIIY0=;
 b=MNceCef5xhcEzMv0CP9yefRYmetyvnhJdaUwaBbgQ4DH/2wahnVWzrkyzpQDsCw1RXqYA9uMRSL6QqHX7wzl5GWE7cnfbrZiEmzpnVOUTv0mvBi9qO0IkZsMxmTy1LSexHAOf1Jh4JqhI3M7AKaa+YTsVp9V3KetY4YX5onLnGw=
Received: from AS9PR06CA0718.eurprd06.prod.outlook.com (2603:10a6:20b:49f::33)
 by DU0PR08MB9079.eurprd08.prod.outlook.com (2603:10a6:10:470::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:08 +0000
Received: from AM7EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:49f:cafe::f8) by AS9PR06CA0718.outlook.office365.com
 (2603:10a6:20b:49f::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT048.mail.protection.outlook.com (100.127.140.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:42:08 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:07 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:06 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:01 +0000
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
Subject: [RFC kvm-unit-tests 09/27] arm: realm: Add support for changing the state of memory
Date:   Fri, 27 Jan 2023 11:40:50 +0000
Message-ID: <20230127114108.10025-10-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT048:EE_|DU0PR08MB9079:EE_|DBAEUR03FT025:EE_|AS8PR08MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: e7782b56-79fd-4bf4-7487-08db005b8ca4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: rheXZgf8s9vM0JR+2yCi7Tl5zJkej8a2aTYURTHqrXgT5cudKFEHmXNQuv0Jyd5KyOP8qfcb45HSVfrDz0RZVytOq+XFlmAI+Ynipl1YS9UcvUvZ40bDBmDlEEEfuyYbcaNXmvlwDNkCqsZXifivrT+AMgvkVn031kRF8N5vcUXUVxTI4Ak1CwRvWp86vjRlQw51CCkGjsrZAir0c0EQrRa8xcA4toNqwbwxsnYUnhCOwsoUUog5ae/Yfud70Hx6eickmijPR9yB/FFIYi8zC8cASeQy5qIAVWJepNRvhtJRSb8EuFoWLrrqM8bHZF2Mhsyyo0fvDs4m7/XWv+ltQCuwBWsK8G5PI/qPj/Rk9KwSdacUdgix0nhjje61kwnOb0612iEUi2gbYCSGRfuQVHrMVTtZ2lWgZjyGVV1y8yrX1a7AUuripHEPJ5+SzY6ZNEPoactivURJd6Nrl9po4uZ/Zpy2fvzvMvWuKZ8rSUnTGCSKPgxr2Ra7UAy12VsnKLcCHXKATTJZ48nITcIEof5p1H0tWzgW7u0ai1GhdXw2leGB0XLWmxhW09Apiw43SpoBJCvBd0RAu/vEbmeteD4MaSrNiSxx7Zt0J9UwHwHiXMixoT0but71Kph2euez2Wa9dzIFfa7Yro6DMetmczZ9GwkYY0RMhH+x/HK5Z6eWSznaXJDCnch94tEFUHUg2EN1nCpGVg8gLhvWolfBwXcSefl7p5K78RoSNDaWipgAqaHVTa3hIwmrSEl1/IqT
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(2906002)(26005)(1076003)(41300700001)(186003)(110136005)(426003)(54906003)(47076005)(4326008)(83380400001)(70206006)(8676002)(70586007)(36860700001)(356005)(6666004)(316002)(86362001)(44832011)(82310400005)(40480700001)(40460700003)(82740400003)(81166007)(478600001)(7416002)(2616005)(336012)(8936002)(5660300002)(7696005)(36756003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9079
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT025.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: db2a54ca-f8cc-4e96-1ae6-08db005b85a3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: goG6d/kKr1K8uxBtkm+OdvdIUA3twLPRj5lBRmjcgW76lWKUNAygxubFTsmGnqfMH56qAzANoKDOa9xOMCkewCfXxdriX64q+lQZdwD+d0RqLhGV3ODv4wlQuFoWUdpxXHPePdOc33Q9ls8Vc0k1Y5baJqTKHIWwIaMpENAzpNVkUtVZ7wwB9aBp6SJTdYKUHT3XGHnVWrxUfWuAx8SqBXPg4we4XXIq2P9M5dRb9itog08sZZvAejE5vrO/wjzysqVLHtLZOwq7spTGIbVtB6yBaxSJkUxsVlgWsC8yn70ypoUh6nUFoOarTzes4/BI6hgEiGZkDpkzhKA53VFXvIXkTVzYpRwjEfZsUVeRgqgFSlOgGYTR9PoNdgBlr+/bOU0KxdDKkSe34OfeZscLoJFXn7pWm9b52YI9abX8N/cTOuBQPkX54m5vO9TrdpJLeuuTyFNs1/czz1iyK0pXHN4cES1SHJq3ZWjP4FYT9wtXHo7KFW5bq/sC6HW3MMJGyGq3DIvvjIqDqdua8ov8lcw76bv6ASsVBuPHqLzDUxtA18ho5/eLzL7R9ivtvvYyjAlwrYHs0l6V1m4b10XkrfG6RsjifIcL/Gempeqtw+po9Dhf0GhoDaT6ErfDLVd13mw5+L/NDbP2OcUbrVcEvJKKd8ieM+3gDzhHVyYzOQl1tebmbFjCAkcOFDiXdi6GDftdTVPpJB9/hoE75bBrQMPxunz5S1kKQ65xbUAxK30=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(36756003)(40480700001)(82310400005)(8676002)(426003)(47076005)(316002)(54906003)(110136005)(336012)(6666004)(1076003)(26005)(40460700003)(44832011)(2906002)(41300700001)(5660300002)(36860700001)(7696005)(86362001)(81166007)(478600001)(186003)(2616005)(450100002)(83380400001)(8936002)(70586007)(4326008)(70206006)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:20.4512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7782b56-79fd-4bf4-7487-08db005b8ca4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT025.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7919
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For a Realm, the guest physical address (in reality the IPA/GPA of the VM)
has an associated state (Realm IPA State, RIPAS) which is either of :
   RIPAS_RAM
   RIPAS_EMPTY

The state of the physical address decides certain behaviors. e.g., any access
to a RIPAS_EMPTY PA will generate a Synchronous External Abort back to the Realm,
from the RMM.

All "PA" that represents RAM for the Realm, must be set to RIPAS_RAM before
an access is made. When the initial image (e.g., test, DTB) of a Realm is
loaded, the hypervisor/VMM can transition the state of the loaded "area" to
RIPAS_RAM. The rest of the "RAM" must be transitioned by the test payload
before any access is made.

Similarly, a Realm could set an "IPA" to RIPAS_EMPTY, when it is about to use
the "unprotected" alias of the IPA. This is a hint for the host to reclaim the
page from the protected "IPA.

This patchs adds supporting helpers for setting the IPA state from Realm. These
will be used later for the Realm.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/mmu.c       |  1 +
 lib/arm64/asm/rsi.h |  8 ++++++++
 lib/arm64/rsi.c     | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 6f1f42f5..2b5a7141 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -12,6 +12,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/io.h>
+#include <asm/rsi.h>
 
 #include "alloc_page.h"
 #include "vmalloc.h"
diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
index 8b9b91b2..c8179341 100644
--- a/lib/arm64/asm/rsi.h
+++ b/lib/arm64/asm/rsi.h
@@ -33,4 +33,12 @@ static inline bool is_realm(void)
 	return rsi_present;
 }
 
+enum ripas_t {
+	RIPAS_EMPTY,
+	RIPAS_RAM,
+};
+
+void arm_set_memory_protected(unsigned long va, size_t size);
+void arm_set_memory_shared(unsigned long va, size_t size);
+
 #endif /* __ASMARM64_RSI_H_ */
diff --git a/lib/arm64/rsi.c b/lib/arm64/rsi.c
index 23a4e963..08c77889 100644
--- a/lib/arm64/rsi.c
+++ b/lib/arm64/rsi.c
@@ -65,3 +65,47 @@ void arm_rsi_init(void)
 	/* Set the upper bit of the IPA as the NS_SHARED pte attribute */
 	prot_ns_shared = (1UL << phys_mask_shift);
 }
+
+static unsigned rsi_set_addr_range_state(unsigned long start, unsigned long size,
+					 enum ripas_t state, unsigned long *top)
+{
+	struct smccc_result res;
+
+	rsi_invoke(SMC_RSI_IPA_STATE_SET, start, size, state, 0, 0, 0, 0, 0, 0, 0, 0, &res);
+	*top = res.r1;
+	return res.r0;
+}
+
+static void arm_set_memory_state(unsigned long start,
+				 unsigned long size,
+				 unsigned int ripas)
+{
+	int ret;
+	unsigned long end, top;
+	unsigned long old_start = start;
+
+	if (!is_realm())
+		return;
+
+	start = ALIGN_DOWN(start, RSI_GRANULE_SIZE);
+	if (start != old_start)
+		size += old_start - start;
+	end = ALIGN(start + size, RSI_GRANULE_SIZE);
+	while (start != end) {
+		ret = rsi_set_addr_range_state(start, (end - start),
+					       ripas, &top);
+		assert(!ret);
+		assert(top <= end);
+		start = top;
+	}
+}
+
+void arm_set_memory_protected(unsigned long start, unsigned long size)
+{
+	arm_set_memory_state(start, size, RIPAS_RAM);
+}
+
+void arm_set_memory_shared(unsigned long start, unsigned long size)
+{
+	arm_set_memory_state(start, size, RIPAS_EMPTY);
+}
-- 
2.17.1

