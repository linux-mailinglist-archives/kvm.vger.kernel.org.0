Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A315F67E45E
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjA0L7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjA0L6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:58:22 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::60e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C242781B14;
        Fri, 27 Jan 2023 03:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfmG/SscmSCGgdmMDRai/tE1Awu1KRQPqX/oIQCKwoM=;
 b=+JqUBo/jsRhua9s3PCNyd9sDD1dh2ja9Z4UAwuyOhQT2SIck9DFVGzkhC/3MNT5RZyGEgFD/n2xveKp/HfsxLVXFM6+uJgPh5LEtrZPpHJt/X5tN5uYi01rt1V/DX4TsJn809sSe2cSPC3VQkEkqQc9APcVMF1Gowb45DSlNjWA=
Received: from DB8PR06CA0043.eurprd06.prod.outlook.com (2603:10a6:10:120::17)
 by GV1PR08MB7849.eurprd08.prod.outlook.com (2603:10a6:150:5c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:41:45 +0000
Received: from DBAEUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:120:cafe::e7) by DB8PR06CA0043.outlook.office365.com
 (2603:10a6:10:120::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT041.mail.protection.outlook.com (100.127.142.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:41:44 +0000
Received: ("Tessian outbound 0d7b2ab0f13d:v132"); Fri, 27 Jan 2023 11:41:44 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 01b30c8a8973a124
X-CR-MTA-TID: 64aa7808
Received: from 414c00eca92b.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2C600D57-46FD-4933-9EA1-500F83CBE8BA.1;
        Fri, 27 Jan 2023 11:41:38 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 414c00eca92b.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzosGICsOKX23lXJIKzEiVxLH5VYcjXf+BDei8VgB9tLNgdfs7T4M62DnARQ3lTnaSuJwTQn13ohiJ5V50ipTcbIF4J8BepBHx8yd1/hBTL110uHt+6lZoZRFuZUO687xHPMOCuoI+hu9NLkO57f6gegPpmaVsepjLhzZvKu/ehtTcE5CsVF/j1CsJYwO4E2Usg2X+5Ck9ZFLX3x38JhvsWPsbLYxZO4O51etbNYcQZ+bh/ns00av++eZkIPrMLCC20baIti4zyNaZqqSyiHKv5K0W0uCYo9O/DGi5KiqJnPn0pyyd7vO90k8l7DUQsJBOzf+ajIlxXwiKg6bbwFCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfmG/SscmSCGgdmMDRai/tE1Awu1KRQPqX/oIQCKwoM=;
 b=Q6xI2j/TbAR+DvXnakWyFxmv6cBI+KQ5UBYpK6/64AfUPDbvyiVKn/yrX08zRX/ptSiOgFb/qJP0RZOrjqfAAL1laLL0DGYj/FuHRKKPMQN1c+qxLI5qQRlYa3Mcjg7FF3qiPBaVe0euLhnNg8+9IS3qLo/EQlLwY4P8jEh0gXOGhZw9rzNKE70MwsO//GE9l5/En4DZxyAHrkFTBzmJzw8aIxUsoeQWsDrOHW00foE9hzBMNDgkKW57yEyIck6DZbvN0/dOjw8ZiDW3h6eDR4TmwM+VKiT4gbrlBhyj4QzvUZdfwR9QRQmeIbZixPhg4+70juGfRDOquVMmKPmbzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfmG/SscmSCGgdmMDRai/tE1Awu1KRQPqX/oIQCKwoM=;
 b=+JqUBo/jsRhua9s3PCNyd9sDD1dh2ja9Z4UAwuyOhQT2SIck9DFVGzkhC/3MNT5RZyGEgFD/n2xveKp/HfsxLVXFM6+uJgPh5LEtrZPpHJt/X5tN5uYi01rt1V/DX4TsJn809sSe2cSPC3VQkEkqQc9APcVMF1Gowb45DSlNjWA=
Received: from AM5PR0101CA0004.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::17) by DU0PR08MB7637.eurprd08.prod.outlook.com
 (2603:10a6:10:31c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Fri, 27 Jan
 2023 11:41:34 +0000
Received: from AM7EUR03FT061.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:16:cafe::55) by AM5PR0101CA0004.outlook.office365.com
 (2603:10a6:206:16::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.34 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT061.mail.protection.outlook.com (100.127.140.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:41:33 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:32 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:27 +0000
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
Subject: [RFC kvm-unit-tests 03/27] arm: realm: Add RSI interface header
Date:   Fri, 27 Jan 2023 11:40:44 +0000
Message-ID: <20230127114108.10025-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT061:EE_|DU0PR08MB7637:EE_|DBAEUR03FT041:EE_|GV1PR08MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fd0b465-095c-4c3e-95c6-08db005b7769
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: BVjsYobxHabxc5fQduZYXdoGRTBp3BtDg2neAkTMmuIleelJgyk/pxf4dD6HOmq13+BqmX1UHjDVNDSgeSjM0YdUSmpsAOGyOkx1V/VdgUXh5rZe5S7QkdDaBTBKz4SFwHfjK44Yu3D09nd7bIJ7BRryJfJgWypWaUrGpM+jgvr0Sc4Q9FLIRSA/xoxRIEiR0HO/J8dUUAaZY1zx0Cv8trl8hQIMBEUbDwA9IJaD6WRXnqk2ufFmoki493X7/s4t0cIus6V8cdYCxPjkPByTzDXFE1+zSSIGzT4DfgEpH6bwFjtECAMUo2shhVVamNnQJ0xfNRNyxccbkdnxhsMOhobCJtwXDMMzUf4yAertjJeym07VT+MdPz69jAI3PimRANNor6j1qQzlZPnz0cQck7Jlnvj12K/n8+PE1yhaFyqP36LD3E2dB8zbv0A8qe1buOrvmrCY5w6Tjwdy/u6/63qR/maNlLDlDAuQtjoghM3RjzCpCYH/yfNdJpXZi7fppbxBXZykVc6PmqJhOK4vdMLTz16+w7F3R0uJdasdbs0ADjE0tmoG0/3MCg/T7mT2g+q8KSJKm4QaXf6k7bQyy70tHjODHMm+Bh89eLbmRZJ22/6BnE6Fdwrkp/ztfVpTmPbBm51dLhw7IE8SATvHMSwZ7Fu8ouVoR0J0ddXgoKXVulwh7cMHeS9EXxjn6femrS5CNkw0VQPhQQOF+SJTFIUYTRb7IKUzbSLxcqdVR1HRKa5eF5RxNwpVm3b7fdG/
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199018)(46966006)(36840700001)(40470700004)(36756003)(336012)(70206006)(41300700001)(478600001)(70586007)(82310400005)(4326008)(26005)(2616005)(316002)(1076003)(7696005)(81166007)(426003)(7416002)(54906003)(83380400001)(356005)(6666004)(5660300002)(40460700003)(110136005)(8676002)(40480700001)(82740400003)(44832011)(36860700001)(86362001)(186003)(47076005)(8936002)(2906002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7637
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 51920a98-4f0b-4763-9801-08db005b70de
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ethpEyhj0mtGaMjjx7GWA3Ov2RNpGIx5h8Qkxvt8OuDvvk6sc3I5miHuZcjrgIffTSefWEBmL8Ro91jlgqf2idxD+MKwKY7FbCbiPz1O2+UtkvNks6Mr8uhoYkNO8/De50KFNKViGZdVOViTK3ffl6JLZxD4T4/dVfYGvlYCAtWnc3Wm2B1SmVt48fMhqNdHl9G85+T0z4DZ0zDFO/1XH7zn5QRl4zUIkz8Es63cw1fqgeCr5ktpVHoHpsq1ijxIXzZXeH5JE3FNVL/m7mGOPIGi9FUUVW7GNqkiBAv/Q6GCbtzs8BcanL0JtiKZNFO0+O4h8fHZVC2WJInlQ4T/MZolgA6l819Ko/TJY8IL6WKoxRYdO0PkrSb+shjiFHVZCnVecjMtOLf5Wp7Zx1EjNUxzyy/APAkv9epeBdNzLil/9ozBEbaavyyhRdqy8YpfskZOjn2kT5Cas+X1tFvSNbRtLA56pW4/2xpS3NE0HKlj/3eol7PWX7gldAdF0h8ObM44M4qlUAU1jcPu9rkuVwYjPJDFmaUWRQGxcDWcTy6rnjrOy/wu3ioYiZOPcVHqsGdPta/Wt9VE9JIccENQNNiagQiicrCXlxo2YvkswqZ3GTLgRhHqz7mEejBQrpb+ZpDle+BD83OO8d9PxFpOj9Kvow6Mtey+q+6ZAzW1uZE8aZpDbB7gqCWgNqMsM/cq61uvhPUQSuLm5LAUJUkz7DFZMm44dJhTjnjw9Z4VImA=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199018)(40470700004)(46966006)(36840700001)(40480700001)(2906002)(8936002)(82310400005)(336012)(36860700001)(81166007)(6666004)(82740400003)(54906003)(70586007)(8676002)(41300700001)(70206006)(40460700003)(110136005)(36756003)(4326008)(478600001)(47076005)(450100002)(5660300002)(316002)(1076003)(186003)(2616005)(83380400001)(7696005)(426003)(26005)(44832011)(86362001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:41:44.8176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd0b465-095c-4c3e-95c6-08db005b7769
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7849
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the defintions for the Realm Service Interface (RSI). RSI calls are a way
for the Realm to communicate with the RMM and request information/services.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm64/asm/smc-rsi.h | 139 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)
 create mode 100644 lib/arm64/asm/smc-rsi.h

diff --git a/lib/arm64/asm/smc-rsi.h b/lib/arm64/asm/smc-rsi.h
new file mode 100644
index 00000000..cd05e9c6
--- /dev/null
+++ b/lib/arm64/asm/smc-rsi.h
@@ -0,0 +1,139 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef __SMC_RSI_H_
+#define __SMC_RSI_H_
+
+/*
+ * This file describes the Realm Services Interface (RSI) Application Binary
+ * Interface (ABI) for SMC calls made from within the Realm to the RMM and
+ * serviced by the RMM.
+ */
+
+#define SMC_RSI_CALL_BASE		0xC4000000
+
+/*
+ * The major version number of the RSI implementation.  Increase this whenever
+ * the binary format or semantics of the SMC calls change.
+ */
+#define RSI_ABI_VERSION_MAJOR		12
+
+/*
+ * The minor version number of the RSI implementation.  Increase this when
+ * a bug is fixed, or a feature is added without breaking binary compatibility.
+ */
+#define RSI_ABI_VERSION_MINOR		0
+
+#define RSI_ABI_VERSION			((RSI_ABI_VERSION_MAJOR << 16) | \
+					 RSI_ABI_VERSION_MINOR)
+
+#define RSI_ABI_VERSION_GET_MAJOR(_version) ((_version) >> 16)
+#define RSI_ABI_VERSION_GET_MINOR(_version) ((_version) & 0xFFFF)
+
+#define RSI_SUCCESS			0
+#define RSI_ERROR_INPUT			1
+#define RSI_ERROR_STATE			2
+#define RSI_INCOMPLETE			3
+#define RSI_ERROR_MEMORY		4
+
+#define SMC_RSI_FID(_x)			(SMC_RSI_CALL_BASE + (_x))
+
+#define SMC_RSI_ABI_VERSION			SMC_RSI_FID(0x190)
+
+/*
+ * arg1 == The IPA of token buffer
+ * arg2 == Challenge value, bytes:  0 -  7
+ * arg3 == Challenge value, bytes:  7 - 15
+ * arg4 == Challenge value, bytes: 16 - 23
+ * arg5 == Challenge value, bytes: 24 - 31
+ * arg6 == Challenge value, bytes: 32 - 39
+ * arg7 == Challenge value, bytes: 40 - 47
+ * arg8 == Challenge value, bytes: 48 - 55
+ * arg9 == Challenge value, bytes: 56 - 63
+ * ret0 == Status / error
+ */
+#define SMC_RSI_ATTEST_TOKEN_INIT	SMC_RSI_FID(0x194)
+
+/*
+ * arg1 == The IPA of token buffer
+ * ret0 == Status / error
+ * ret1 == Size of completed token in bytes
+ */
+#define SMC_RSI_ATTEST_TOKEN_CONTINUE	SMC_RSI_FID(0x195)
+
+/*
+ * arg1  == Index (1..4), which measurement (REM) to extend
+ * arg2  == Size of realm measurement in bytes, max 64 bytes
+ * arg3  == Measurement value, bytes:  0 -  7
+ * arg4  == Measurement value, bytes:  7 - 15
+ * arg5  == Measurement value, bytes: 16 - 23
+ * arg6  == Measurement value, bytes: 24 - 31
+ * arg7  == Measurement value, bytes: 32 - 39
+ * arg8  == Measurement value, bytes: 40 - 47
+ * arg9  == Measurement value, bytes: 48 - 55
+ * arg10 == Measurement value, bytes: 56 - 63
+ * ret0  == Status / error
+ */
+#define SMC_RSI_MEASUREMENT_EXTEND	SMC_RSI_FID(0x193)
+
+/*
+ * arg1 == Index (0..4), which measurement (RIM or REM) to read
+ * ret0 == Status / error
+ * ret1 == Measurement value, bytes:  0 -  7
+ * ret2 == Measurement value, bytes:  7 - 15
+ * ret3 == Measurement value, bytes: 16 - 23
+ * ret4 == Measurement value, bytes: 24 - 31
+ * ret5 == Measurement value, bytes: 32 - 39
+ * ret6 == Measurement value, bytes: 40 - 47
+ * ret7 == Measurement value, bytes: 48 - 55
+ * ret8 == Measurement value, bytes: 56 - 63
+ */
+#define SMC_RSI_MEASUREMENT_READ	SMC_RSI_FID(0x192)
+
+#ifndef __ASSEMBLY__
+
+struct rsi_realm_config {
+	union {
+		struct {
+			unsigned long ipa_width; /* Width of IPA in bits */
+		};
+		unsigned char __reserved0[0x1000];
+	};
+	/* Offset 0x1000 */
+};
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * arg0 == struct rsi_realm_config addr
+ */
+#define SMC_RSI_REALM_CONFIG		SMC_RSI_FID(0x196)
+
+/*
+ * arg0 == IPA address of target region
+ * arg1 == size of target region in bytes
+ * arg2 == RIPAS value
+ * ret0 == Status / error
+ * ret1 == Top of modified IPA range
+ */
+#define SMC_RSI_IPA_STATE_SET		SMC_RSI_FID(0x197)
+
+#define RSI_HOST_CALL_NR_GPRS		31
+
+#ifndef __ASSEMBLY__
+
+struct rsi_host_call {
+	unsigned int imm;
+	unsigned long gprs[RSI_HOST_CALL_NR_GPRS];
+};
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * arg0 == struct rsi_host_call addr
+ */
+#define SMC_RSI_HOST_CALL		SMC_RSI_FID(0x199)
+
+#endif /* __SMC_RSI_H_ */
-- 
2.17.1

