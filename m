Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464AE67E423
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbjA0LvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbjA0Lu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:50:27 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4017DBDD;
        Fri, 27 Jan 2023 03:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMcwtlGekEAD65YfU8NXuKfzBIuUWm2fNmvX4BABa/I=;
 b=zUAwlXkO3HsOouGuiII0TbNTcNLGTfiYODHQnOU8XcnquggamJJ/R1xEIOurpHPhsSkHe2Mn+VN5j6xBYXA7jKkFC0lEB2qjo0Wgv0bRSTydaWesh+YrnMIMmzpbZTJgLsXtz/PXZd5GsxB273oLNs/Kw/TtaqaBmmCrmVsnkfY=
Received: from DB6PR07CA0120.eurprd07.prod.outlook.com (2603:10a6:6:2c::34) by
 GV2PR08MB8368.eurprd08.prod.outlook.com (2603:10a6:150:bd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22; Fri, 27 Jan 2023 11:41:45 +0000
Received: from DBAEUR03FT049.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:2c:cafe::f4) by DB6PR07CA0120.outlook.office365.com
 (2603:10a6:6:2c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT049.mail.protection.outlook.com (100.127.142.192) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:41:44 +0000
Received: ("Tessian outbound baf1b7a96f25:v132"); Fri, 27 Jan 2023 11:41:44 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f541c80697b1d018
X-CR-MTA-TID: 64aa7808
Received: from ef6d3d9679ba.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 1235D9C1-D4EB-40A7-AF4E-4BCBA772B947.1;
        Fri, 27 Jan 2023 11:41:38 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ef6d3d9679ba.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDS80Fatr69LDCB09zJP2pGgOkcxwRdgpS502m9mfHT6YINpkO8CCn4/damB6td1IspHUsVbrW24rzWeQzaP6MVMOXaLe1PybZNV66ac7jzlx9rMXzWIUMTbLFcsknLu+fPLmuL4qL7G8B6TgrGjFKX7/5EWeWv4i5Tdd7JBDLZ3OTcoo5nDlGYohtluqUAoY0eXMN6Kej8eMzLrK2cIbGS1/ljOATou4m5dzPbhFNYrtuebLtsHD+jr+Gc9loYrYWq/gnsAMGiIMLaSpp1tmaXta0uanEXGvU9RsCIBPpEgPf2IT2pgDJ2C+7+JbFHkJJ4PlinZK7spSIKKSwdYtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMcwtlGekEAD65YfU8NXuKfzBIuUWm2fNmvX4BABa/I=;
 b=JOdnRuvCOzXu1OJNIDEk52DZrbXcXK3AWlpgtCeSzcDn8oLdZX6q8mfqqXB4By1JnwQmWFecDAtY9EhaJDFE4m5ss5beKAY4QHrbwN6p0t1l8R4KqSky4DwHarxIjZJiVeeR/wS1VwZNy7uj8pclXbSnfBQqERhdIs/l9n1WIoBExJhw3wQ5N/L6mcKZi9HFvo1/B8YxS4gWgQtSUq9Tvrikz6nPBYlBfE3wRnqvdkpC5JqbVFZwzuZ9cfenEgjp380539LZ8ssZChCg3XfLMD/B+RierTA2otOxG0pqVryd1AT+G3aTr76o3yOprWXlu5A7wVzyfqhnursxJe4L4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMcwtlGekEAD65YfU8NXuKfzBIuUWm2fNmvX4BABa/I=;
 b=zUAwlXkO3HsOouGuiII0TbNTcNLGTfiYODHQnOU8XcnquggamJJ/R1xEIOurpHPhsSkHe2Mn+VN5j6xBYXA7jKkFC0lEB2qjo0Wgv0bRSTydaWesh+YrnMIMmzpbZTJgLsXtz/PXZd5GsxB273oLNs/Kw/TtaqaBmmCrmVsnkfY=
Received: from DUZPR01CA0164.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::18) by AS8PR08MB8706.eurprd08.prod.outlook.com
 (2603:10a6:20b:564::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:41:35 +0000
Received: from DBAEUR03FT037.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:4b3:cafe::cb) by DUZPR01CA0164.outlook.office365.com
 (2603:10a6:10:4b3::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.35 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT037.mail.protection.outlook.com (100.127.142.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:41:34 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:27 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:21 +0000
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
Subject: [RFC kvm-unit-tests 02/27] arm: Expand SMCCC arguments and return values
Date:   Fri, 27 Jan 2023 11:40:43 +0000
Message-ID: <20230127114108.10025-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: DBAEUR03FT037:EE_|AS8PR08MB8706:EE_|DBAEUR03FT049:EE_|GV2PR08MB8368:EE_
X-MS-Office365-Filtering-Correlation-Id: f8cb488f-555f-4b30-542d-08db005b7779
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: oQJjb/Wo+WCK/3gYJfPP3Z6forKMnlJbI/FRPW/46kP030cHpBi22Kahjb4HzTWB0uQtsVm+X8imP/rkMU4db8+CsTHFd/ehkxorog2cpAWglvv/0Ic24SzIzB1O1DyCZkh1G6CXb4/7W2vQWK8FqJ8iM0SEYRP6YqIpdcLAsDk0bMnMLJ7nvWL1PeEzJTy37rE+GMsLmxyY+nvv803SJVyc46KyvLv0A7rQWnl+Bld/RySh9FJ/UFA4A85qcubj/eTdSc2ROvf6urPdmx4XtPUyQeDfa7+yNKkpQpvxJ/W5YpxU4Y5Y6HD8oujG0mneDfJUZsoFh9ECabmjCB+JaOPTNQFb5a7baiJWj3XYL0GOHnDoR3Uv2vimdRqXqbWZHRK5sg/M2Yz9XQx/nIWLNz+TxHd+Tiqk6rwzmXpuDbLve/jFJEAKLW/GW9umaMJ14loGlRKdAU293bqKqcyh3QOV29LhcEJGSMoiszmmjnLrv9G4GyrEvtm85K60Tbm+vVMiYqhwhR8+QfbnH7zcDd63Mf6fUzPAxYyU7hidxhceuNa7IIJJOPJZ3HnRW1SNfFJ6Capss9981jU33EK/I0LDgk48iFOcj+TWL1masK77ttOtQ8L1iOSmS9jKuzpgZ1ebgcVje8UnlvAzdGYdktiIEHMVSLEhekRfC91UC19JEpLLcWL4epU70SZ6A67rf6FikfIAHuPqkdgcvtjMXBqwC45r4Pbx74Gu6ZcXUk0rse1zHWEYSbR6yqEHYYif
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(40470700004)(36840700001)(46966006)(7696005)(336012)(478600001)(6666004)(2906002)(4326008)(26005)(186003)(44832011)(1076003)(8676002)(70206006)(70586007)(426003)(47076005)(110136005)(2616005)(54906003)(83380400001)(356005)(36860700001)(82740400003)(316002)(36756003)(5660300002)(41300700001)(40460700003)(7416002)(40480700001)(81166007)(8936002)(82310400005)(86362001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8706
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT049.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: d055afe7-ace8-46c6-33e7-08db005b7115
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVTw0WJ1BXHqVpVs9EoiF5RVHHmaaoF310o3F+qImpu4gowEgNSANAgLHlTtaJ7qFdhVQG5mgBed1vd5psuZQ0/iVjTbkZjPP1M5jeQ+x+gU5o3GQp/JFAl0Jyk1ZfjlhnPgEEHADVXyvcPYE7WpQuOaxW0NaXui3gz63J4GZD+s7blKD+mk9UsrfXiGfAtOHdehh34/4Wn7x4NNaUIaOUhZEV1gpEGgKVfBLsqfi7r04Qlol5dEtW+ovRquSXP/UosKa7Ux4pmaUBmBYsa0Gtijhx4ROToT1mTnmLWe5sxKcAgm9sRuw44y8QNnP+AQZ+zBQ7X4b0pXql/W1Oni50MOlNnrjrcnAIz9Vx/1PRGr7FEsZ/GgX3ARjXpVPUVDfCBfjm2g1g2rX20zDy3LtUpzu4/zj5R/4TzWhSJu2LGcnipcVGZN2xTDuzltvdq2Vaa9UfzISoxJRbfyMcvaTc/Jda1MzSc6AnX1TJxasT2K1xC8ozQFXi2Z/qiQISOD6mzIPcNkG+f5mqVxH4g+MaJ9GsyFdOROmVHJzCoFKhqPuphzqYLnM0DmPxUcJxpijlfTRPrq3WDnPpG5xRZfOBPWcsEO5jFV+uHsMVLCcdluJfXTh22qWRXo1XB2Sol7zyv4jNJby2h2C/v6ZVLTFbO6n53jyqanE8Em8RschBF5UW0g7bNfv8hCrp2O/KPIdSGORjDKBb8pCoVxzUVb04y9PxRPyBS9jIWzECopABk=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199018)(40470700004)(46966006)(36840700001)(2906002)(44832011)(5660300002)(8936002)(47076005)(426003)(41300700001)(36860700001)(26005)(336012)(478600001)(2616005)(6666004)(186003)(1076003)(82740400003)(83380400001)(450100002)(70206006)(40460700003)(81166007)(7696005)(86362001)(40480700001)(4326008)(70586007)(36756003)(82310400005)(8676002)(54906003)(316002)(110136005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:41:44.9521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8cb488f-555f-4b30-542d-08db005b7779
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT049.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8368
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

PSCI uses the SMC Calling Convention (SMCCC) to communicate with the higher
level software. PSCI uses at most 4 arguments and expend only one return
value. However, SMCCC has provisions for more arguments (upto 17 depending
on the SMCCC version) and upto 10 distinct return values.

We are going to be adding tests that make use of it, so add support for the
extended number of arguments and return values.

Also rename the SMCCC functions to generic, non-PSCI names, so they
can be used for Realm services.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
[ Expand the number of args to 11 /results 10]
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/cstart.S              | 49 ++++++++++++++++++++++++++++------
 arm/cstart64.S            | 55 +++++++++++++++++++++++++++++++++------
 arm/selftest.c            |  2 +-
 lib/arm/asm/arm-smccc.h   | 44 +++++++++++++++++++++++++++++++
 lib/arm/asm/psci.h        | 13 +++++----
 lib/arm/psci.c            | 19 +++++++++++---
 lib/arm64/asm/arm-smccc.h |  6 +++++
 7 files changed, 160 insertions(+), 28 deletions(-)
 create mode 100644 lib/arm/asm/arm-smccc.h
 create mode 100644 lib/arm64/asm/arm-smccc.h

diff --git a/arm/cstart.S b/arm/cstart.S
index 7036e67f..db377668 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -96,26 +96,59 @@ start:
 .text
 
 /*
- * psci_invoke_hvc / psci_invoke_smc
+ * arm_smccc_hvc / arm_smccc_smc
  *
  * Inputs:
  *   r0 -- function_id
  *   r1 -- arg0
  *   r2 -- arg1
  *   r3 -- arg2
+ *   [sp] - arg3
+ *   [sp + #4] - arg4
+ *   [sp + #8] - arg5
+ *   [sp + #12] - arg6
+ *   [sp + #16] - arg7
+ *   [sp + #20] - arg8
+ *   [sp + #24] - arg9
+ *   [sp + #28] - arg10
+ *   [sp + #32] - result (as a pointer to a struct smccc_result)
  *
  * Outputs:
  *   r0 -- return code
+ *
+ * If result pointer is not NULL:
+ *   result.r0 -- return code
+ *   result.r1 -- r1
+ *   result.r2 -- r2
+ *   result.r3 -- r3
+ *   result.r4 -- r4
+ *   result.r5 -- r5
+ *   result.r6 -- r6
+ *   result.r7 -- r7
+ *   result.r8 -- r8
+ *   result.r9 -- r9
  */
-.globl psci_invoke_hvc
-psci_invoke_hvc:
-	hvc	#0
+.macro do_smccc_call instr
+	mov	r12, sp
+	push	{r4-r11}
+	ldm	r12, {r4-r11}
+	\instr	#0
+	ldr	r10, [sp, #64]
+	cmp	r10, #0
+	beq	1f
+	stm	r10, {r0-r9}
+1:
+	pop	{r4-r11}
 	mov	pc, lr
+.endm
 
-.globl psci_invoke_smc
-psci_invoke_smc:
-	smc	#0
-	mov	pc, lr
+.globl arm_smccc_hvc
+arm_smccc_hvc:
+	do_smccc_call hvc
+
+.globl arm_smccc_smc
+arm_smccc_smc:
+	do_smccc_call smc
 
 enable_vfp:
 	/* Enable full access to CP10 and CP11: */
diff --git a/arm/cstart64.S b/arm/cstart64.S
index e4ab7d06..b689b132 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -110,26 +110,65 @@ start:
 .text
 
 /*
- * psci_invoke_hvc / psci_invoke_smc
+ * arm_smccc_hvc / arm_smccc_smc
  *
  * Inputs:
  *   w0 -- function_id
  *   x1 -- arg0
  *   x2 -- arg1
  *   x3 -- arg2
+ *   x4 -- arg3
+ *   x5 -- arg4
+ *   x6 -- arg5
+ *   x7 -- arg6
+ *   sp -- { arg7, arg8, arg9, arg10, result }
  *
  * Outputs:
  *   x0 -- return code
+ *
+ * If result pointer is not NULL:
+ *   result.r0 -- return code
+ *   result.r1 -- x1
+ *   result.r2 -- x2
+ *   result.r3 -- x3
+ *   result.r4 -- x4
+ *   result.r5 -- x5
+ *   result.r6 -- x6
+ *   result.r7 -- x7
+ *   result.r8 -- x8
+ *   result.r9 -- x9
  */
-.globl psci_invoke_hvc
-psci_invoke_hvc:
-	hvc	#0
+.macro do_smccc_call instr
+	/* Save x8-x11 on stack */
+	stp	x9, x8,	  [sp, #-16]!
+	stp	x11, x10, [sp, #-16]!
+	/* Load arg7 - arg10 from the stack */
+	ldp	x8, x9,   [sp, #32]
+	ldp	x10, x11, [sp, #48]
+	\instr	#0
+	/* Get the result address */
+	ldr	x10, [sp, #64]
+	cmp	x10, xzr
+	b.eq	1f
+	stp	x0, x1, [x10, #0]
+	stp	x2, x3, [x10, #16]
+	stp	x4, x5, [x10, #32]
+	stp	x6, x7, [x10, #48]
+	stp	x8, x9, [x10, #64]
+1:
+	/* Restore x8-x11 from stack */
+	ldp	x11, x10, [sp], #16
+	ldp	x9, x8,   [sp], #16
 	ret
+.endm
 
-.globl psci_invoke_smc
-psci_invoke_smc:
-	smc	#0
-	ret
+.globl arm_smccc_hvc
+arm_smccc_hvc:
+	do_smccc_call hvc
+
+.globl arm_smccc_smc
+arm_smccc_smc:
+	do_smccc_call smc
 
 get_mmu_off:
 	adrp	x0, auxinfo
diff --git a/arm/selftest.c b/arm/selftest.c
index 9f459ed3..6f825add 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -405,7 +405,7 @@ static void psci_print(void)
 	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
 	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
 					  PSCI_VERSION_MINOR(ver));
-	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
+	report_info("PSCI method: %s", psci_invoke_fn == arm_smccc_hvc ?
 				       "hvc" : "smc");
 }
 
diff --git a/lib/arm/asm/arm-smccc.h b/lib/arm/asm/arm-smccc.h
new file mode 100644
index 00000000..5d85b01a
--- /dev/null
+++ b/lib/arm/asm/arm-smccc.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef _ASMARM_ARM_SMCCC_H_
+#define _ASMARM_ARM_SMCCC_H_
+
+struct smccc_result {
+	unsigned long r0;
+	unsigned long r1;
+	unsigned long r2;
+	unsigned long r3;
+	unsigned long r4;
+	unsigned long r5;
+	unsigned long r6;
+	unsigned long r7;
+	unsigned long r8;
+	unsigned long r9;
+};
+
+typedef int (*smccc_invoke_fn)(unsigned int function_id, unsigned long arg0,
+			       unsigned long arg1, unsigned long arg2,
+			       unsigned long arg3, unsigned long arg4,
+			       unsigned long arg5, unsigned long arg6,
+			       unsigned long arg7, unsigned long arg8,
+			       unsigned long arg9, unsigned long arg10,
+			       struct smccc_result *result);
+extern int arm_smccc_hvc(unsigned int function_id, unsigned long arg0,
+			 unsigned long arg1, unsigned long arg2,
+			 unsigned long arg3, unsigned long arg4,
+			 unsigned long arg5, unsigned long arg6,
+			 unsigned long arg7, unsigned long arg8,
+			 unsigned long arg9, unsigned long arg10,
+			 struct smccc_result *result);
+extern int arm_smccc_smc(unsigned int function_id, unsigned long arg0,
+			 unsigned long arg1, unsigned long arg2,
+			 unsigned long arg3, unsigned long arg4,
+			 unsigned long arg5, unsigned long arg6,
+			 unsigned long arg7, unsigned long arg8,
+			 unsigned long arg9, unsigned long arg10,
+			 struct smccc_result *result);
+
+#endif /* _ASMARM_ARM_SMCCC_H_ */
diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
index cf03449b..6a399621 100644
--- a/lib/arm/asm/psci.h
+++ b/lib/arm/asm/psci.h
@@ -3,13 +3,12 @@
 #include <libcflat.h>
 #include <linux/psci.h>
 
-typedef int (*psci_invoke_fn)(unsigned int function_id, unsigned long arg0,
-			      unsigned long arg1, unsigned long arg2);
-extern psci_invoke_fn psci_invoke;
-extern int psci_invoke_hvc(unsigned int function_id, unsigned long arg0,
-			   unsigned long arg1, unsigned long arg2);
-extern int psci_invoke_smc(unsigned int function_id, unsigned long arg0,
-			   unsigned long arg1, unsigned long arg2);
+#include <asm/arm-smccc.h>
+
+extern smccc_invoke_fn psci_invoke_fn;
+
+extern int psci_invoke(unsigned int function_id, unsigned long arg0,
+		       unsigned long arg1, unsigned long arg2);
 extern void psci_set_conduit(void);
 extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
 extern void psci_system_reset(void);
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 9c031a12..0a1d0e82 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -13,13 +13,24 @@
 #include <asm/smp.h>
 
 static int psci_invoke_none(unsigned int function_id, unsigned long arg0,
-			    unsigned long arg1, unsigned long arg2)
+			    unsigned long arg1, unsigned long arg2,
+			    unsigned long arg3, unsigned long arg4,
+			    unsigned long arg5, unsigned long arg6,
+			    unsigned long arg7, unsigned long arg8,
+			    unsigned long arg9, unsigned long arg10,
+			    struct smccc_result *result)
 {
 	printf("No PSCI method configured! Can't invoke...\n");
 	return PSCI_RET_NOT_PRESENT;
 }
 
-psci_invoke_fn psci_invoke = psci_invoke_none;
+smccc_invoke_fn psci_invoke_fn = psci_invoke_none;
+
+int psci_invoke(unsigned int function_id, unsigned long arg0,
+		unsigned long arg1, unsigned long arg2)
+{
+	return psci_invoke_fn(function_id, arg0, arg1, arg2, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
+}
 
 int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
 {
@@ -69,9 +80,9 @@ void psci_set_conduit(void)
 	assert(method != NULL && len == 4);
 
 	if (strcmp(method->data, "hvc") == 0)
-		psci_invoke = psci_invoke_hvc;
+		psci_invoke_fn = arm_smccc_hvc;
 	else if (strcmp(method->data, "smc") == 0)
-		psci_invoke = psci_invoke_smc;
+		psci_invoke_fn = arm_smccc_smc;
 	else
 		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
 }
diff --git a/lib/arm64/asm/arm-smccc.h b/lib/arm64/asm/arm-smccc.h
new file mode 100644
index 00000000..ab649489
--- /dev/null
+++ b/lib/arm64/asm/arm-smccc.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#include "../../arm/asm/arm-smccc.h"
-- 
2.17.1

