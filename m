Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7851D67E3F1
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbjA0Lp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjA0Lpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:45:38 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497252721;
        Fri, 27 Jan 2023 03:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8JZG4jpM76HS5UgQpwVl4pSBZ5biDY9z3RHHccl+24=;
 b=eEm99mno32dYqI3hpPf2PrxE6B8TAhBUiPK2lrWFp2YfFFHG4JJWMQlumDw+ctLtbDM1kwQ+yTlpZLhjV3qpyIhSuqw+m19dVa3hL8UnzY4W6pS0d+Pic5ZdhpOojgbUpjkAfzE3o5zpmIgn6jfdq7DgLPSOhtKRWP1SKft/ug8=
Received: from AS9PR05CA0074.eurprd05.prod.outlook.com (2603:10a6:20b:499::28)
 by AM9PR08MB6097.eurprd08.prod.outlook.com (2603:10a6:20b:280::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:48 +0000
Received: from AM7EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:499:cafe::10) by AS9PR05CA0074.outlook.office365.com
 (2603:10a6:20b:499::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT011.mail.protection.outlook.com (100.127.140.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:48 +0000
Received: ("Tessian outbound baf1b7a96f25:v132"); Fri, 27 Jan 2023 11:42:48 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 80bc510a8692540b
X-CR-MTA-TID: 64aa7808
Received: from 1241152e4df0.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id D608B248-C25F-4634-B0B6-0C794EB6F09D.1;
        Fri, 27 Jan 2023 11:42:41 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1241152e4df0.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzHrXoU49HA4o+nc9qVkOVVzKPf0hiuPWeIgf0uC4dec4sWBwobCfZGf0Fa0XwgvFoA5Im4DP9GKbIj75f/gHmXSmUQ7JANAt5iZaNIWcy1yaV8xGlq9ccuk6K0jqIfeCcL1qg8fum3/TloB1rDZtlkEGG+yfK9llgvCLNuKfA+aJPHLr5R02zsl2kf5sCnX4EUYp2OaCpEfFSPRrpYI6nt+GoHMvoPosLqFOVJ5aas6WIE35tIRv2Jc9WM18cJJfhSOfMJsrYE81ulNNIB9ISWQLCVUIAXI6cQUc32UghBc/XJI2G47wYeyEr2Ovv+aKEnesSjOTZ5VbddGf5kCPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8JZG4jpM76HS5UgQpwVl4pSBZ5biDY9z3RHHccl+24=;
 b=UImYHWiroexKQOwiUHvF8LkBFze1K+PYBHF9LCBra1rYwh6Bvt/kQjux6ShQKjcF75NYX7cHvLakrO1asYF+OScVFa1nhh4Rgn8kD8nDPLCNSZjMhjGK6K1RT9qsFR409FbBUBkwyTjy2WrDuDFUHhHQC7JTYaF/1k1KHUgWIwZzw73x2gPNvyw4uYQRN0jItLng0vBBvkh//u4uSRnUEYMtHn6xON6DNCSwAr+Mly/OOzhyhJ6F19XbHP/mpMQOKN/IvI/y7rt/rElKKJ1aqBrZHPSiCslTx/ZGlT86Rwb7NGy0JnIWqMfasxuXGNgziXu1RROI2cR7JL7dg+tZ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8JZG4jpM76HS5UgQpwVl4pSBZ5biDY9z3RHHccl+24=;
 b=eEm99mno32dYqI3hpPf2PrxE6B8TAhBUiPK2lrWFp2YfFFHG4JJWMQlumDw+ctLtbDM1kwQ+yTlpZLhjV3qpyIhSuqw+m19dVa3hL8UnzY4W6pS0d+Pic5ZdhpOojgbUpjkAfzE3o5zpmIgn6jfdq7DgLPSOhtKRWP1SKft/ug8=
Received: from AS9PR06CA0513.eurprd06.prod.outlook.com (2603:10a6:20b:49d::8)
 by GV1PR08MB8692.eurprd08.prod.outlook.com (2603:10a6:150:86::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:37 +0000
Received: from AM7EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:49d:cafe::63) by AS9PR06CA0513.outlook.office365.com
 (2603:10a6:20b:49d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT013.mail.protection.outlook.com (100.127.140.191) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:36 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:35 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:29 +0000
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
        Gareth Stockwell <gareth.stockwell@arm.com>
Subject: [RFC kvm-unit-tests 14/27] arm: realm: add hvc and RSI_HOST_CALL tests
Date:   Fri, 27 Jan 2023 11:40:55 +0000
Message-ID: <20230127114108.10025-15-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT013:EE_|GV1PR08MB8692:EE_|AM7EUR03FT011:EE_|AM9PR08MB6097:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ecefbb7-fb0c-497a-6ade-08db005b9d97
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: LrrhC1LRwd7d9J67bWM/6pEwNPN1mwgg7HTt7Mo2eV8JUZkNJDd3VURcxYbCKSoikmjeJj17pAk93tFC6SG2+ujK0pEDUVGg32kNxMusiXfnV+fN11isNC6/oRiTZ+4FhqTTLzc0TsmpPMCIlJVWKrn4mbbmnhXTY2yVepWoPrWh5SqzZ95gzh9mRpBcGuXxuTvgKnw9CJLTRVyaxqiq5CdYfSm2TeDjfUPDjpNxwtOge0qe8QtxYVL/q9w8PMPCQ+ey3SKoenlgrxfNShpXmJzGeIAbjZGVgRMx44+o94XYxkcSr0E2Ob0qgHlFz0OWH6xWCp0New1nnjDqXk52dYiO+4mR+OYiHDQQILCjsV7nb0RxWmFF4pyhfzg8QYkNycXXvfsOfhV9UFbKQsM15v8oGBI+0v35xyrmy8+GRna1dqrcJiJpUnvqPedla7iaLb84XaAaJzEtAlP2sd43rCYS1yR+6zL/mKh6iia+X1v1cV/pTpsYNmUC4FXCKy7LyYRi/QUmr3ZpXTOwmEd3I2PkyQ73OhR15KPrbDYUZDGe0FsYIlapBJQpBEAwqD3MPf9QuDHsR4pl2S87yx4d8cTneNtYtSlCaCl+X9m4OUINkv4xj8qmY8vvGFTxxokM5137+UhjoxkAnklc4qJeLMri2tH5Tb563GNEihseyZ883m6lgt0FcanyynnMn/D9uWLQi94jJQcMzpYwW2btJOnU5n9+3bWCzKbGlPykQn0MOKX8hDbX0btTjhON3XSS
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(5660300002)(70206006)(7416002)(8936002)(44832011)(2906002)(41300700001)(4326008)(70586007)(8676002)(6666004)(82310400005)(316002)(54906003)(110136005)(186003)(26005)(36756003)(7696005)(1076003)(478600001)(2616005)(336012)(40460700003)(81166007)(83380400001)(47076005)(426003)(36860700001)(40480700001)(82740400003)(86362001)(356005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8692
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 55ea7516-98d0-44f5-ab2c-08db005b966c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2og2YMTpVcmkVHGEkuUdMRfH3elx3xSZLKlfU0+Ud6iXO+0+i4nYGbQ/PB2avQDt3bGKRfdERIESt/H8bErGIHqe8IUd94XF+U2JWXL+EpHQOpU5eoFbEbs2AWHb8OPSTM814PjnUvkpXWXh82iCekrmFg6TVvOj1gBh6lug6VqX2ap4dR08Y0qd1bdpCRI5XrdxAc52+O7qXR2iUGwH19niAgFQy6sqkp70gVitqaHlK/6LhiWKyvC0iVdkiuyAEFbt4JmW3T4EEueWxPJGBY9uF+1NGI/z1pZ3JG7Rill3iHaVelRnRyzlQKl+7uVlnp50x+r2XhXdnoFBlJk06QClCbOTj2Bjp6Uz3AGSIzTiCXJgX2Vql7kvZ5fBXXw3+KvFB3/tFARuaYw7j5mFRA2rSmzrPip+qDHDKS4p/DjYfX1X44FB3+XbbE8+YwA7RFt6btHIP1b2a+sqTCz8JD45Mld054o/Eq6mUPk88QX345eLXTLJqNxBGAs68enM+4Dk+L4smLQThRvbfjyQ63yKVqHzreA+MggXTiv19+jtAe5/PlZco/8vKZJLuEKCSwNZoif1lXovw2mF2IyoJrW0t04yhq8DAekDkSx++4lGp92hk/nauCSJkTpuw3CFCXpi1leN65ay2BgZBpQrhE9VKNriWQkJ2XA8dMQaAo2T1wtdvs9Ta5ZkAcmZ8hwOEn6y2sXX1PxBLzbqgupGKOx/uN+0LoAvilXw2OZHtmw=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(451199018)(46966006)(36840700001)(40470700004)(4326008)(41300700001)(70206006)(8676002)(70586007)(450100002)(83380400001)(316002)(8936002)(5660300002)(110136005)(81166007)(36756003)(40460700003)(44832011)(40480700001)(2906002)(36860700001)(54906003)(426003)(47076005)(86362001)(7696005)(478600001)(336012)(6666004)(82740400003)(1076003)(186003)(82310400005)(26005)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:48.8246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecefbb7-fb0c-497a-6ade-08db005b9d97
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6097
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Gareth Stockwell <gareth.stockwell@arm.com>

Test that a HVC instruction in a Realm is turned into an undefined exception.

Test that RSI_HOST_CALL passes through to the Hypervisor.

Signed-off-by: Gareth Stockwell <gareth.stockwell@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/realm-rsi.c   | 110 +++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg |  15 +++++++
 2 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/arm/realm-rsi.c b/arm/realm-rsi.c
index d793f305..8a7e9622 100644
--- a/arm/realm-rsi.c
+++ b/arm/realm-rsi.c
@@ -14,6 +14,96 @@
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 
+#define FID_SMCCC_VERSION	0x80000000
+#define FID_INVALID		0xc5000041
+
+#define SMCCC_VERSION_1_1	0x10001
+#define SMCCC_SUCCESS		0
+#define SMCCC_NOT_SUPPORTED	-1
+
+static bool unknown_taken;
+
+static void unknown_handler(struct pt_regs *regs, unsigned int esr)
+{
+	report_info("unknown_handler: esr=0x%x", esr);
+	unknown_taken = true;
+}
+
+static void hvc_call(unsigned int fid)
+{
+	struct smccc_result res;
+
+	unknown_taken = false;
+	arm_smccc_hvc(fid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	if (unknown_taken) {
+		report(true, "FID=0x%x caused Unknown exception", fid);
+	} else {
+		report(false, "FID=0x%x did not cause Unknown exception", fid);
+		report_info("x0:  0x%lx", res.r0);
+		report_info("x1:  0x%lx", res.r1);
+		report_info("x2:  0x%lx", res.r2);
+		report_info("x3:  0x%lx", res.r3);
+		report_info("x4:  0x%lx", res.r4);
+		report_info("x5:  0x%lx", res.r5);
+		report_info("x6:  0x%lx", res.r6);
+		report_info("x7:  0x%lx", res.r7);
+	}
+}
+
+static void rsi_test_hvc(void)
+{
+	report_prefix_push("hvc");
+
+	/* Test that HVC causes Undefined exception, regardless of FID */
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, unknown_handler);
+	hvc_call(FID_SMCCC_VERSION);
+	hvc_call(FID_INVALID);
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
+
+	report_prefix_pop();
+}
+
+static void host_call(unsigned int fid, unsigned long expected_x0)
+{
+	struct smccc_result res;
+	struct rsi_host_call __attribute__((aligned(256))) host_call_data = { 0 };
+
+	host_call_data.gprs[0] = fid;
+
+	arm_smccc_smc(SMC_RSI_HOST_CALL, virt_to_phys(&host_call_data),
+		       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	if (res.r0) {
+		report(false, "RSI_HOST_CALL returned 0x%lx", res.r0);
+	} else {
+		if (host_call_data.gprs[0] == expected_x0) {
+			report(true, "FID=0x%x x0=0x%lx",
+				fid, host_call_data.gprs[0]);
+		} else {
+			report(false, "FID=0x%x x0=0x%lx expected=0x%lx",
+				fid, host_call_data.gprs[0], expected_x0);
+			report_info("x1:  0x%lx", host_call_data.gprs[1]);
+			report_info("x2:  0x%lx", host_call_data.gprs[2]);
+			report_info("x3:  0x%lx", host_call_data.gprs[3]);
+			report_info("x4:  0x%lx", host_call_data.gprs[4]);
+			report_info("x5:  0x%lx", host_call_data.gprs[5]);
+			report_info("x6:  0x%lx", host_call_data.gprs[6]);
+		}
+	}
+}
+
+static void rsi_test_host_call(void)
+{
+	report_prefix_push("host_call");
+
+	/* Test that host calls return expected values */
+	host_call(FID_SMCCC_VERSION, SMCCC_VERSION_1_1);
+	host_call(FID_INVALID, SMCCC_NOT_SUPPORTED);
+
+	report_prefix_pop();
+}
+
 static void rsi_test_version(void)
 {
 	int version;
@@ -36,6 +126,8 @@ static void rsi_test_version(void)
 
 int main(int argc, char **argv)
 {
+	int i;
+
 	report_prefix_push("rsi");
 
 	if (!is_realm()) {
@@ -43,7 +135,23 @@ int main(int argc, char **argv)
 		goto exit;
 	}
 
-	rsi_test_version();
+	if (argc < 2) {
+		rsi_test_version();
+		rsi_test_host_call();
+		rsi_test_hvc();
+	} else {
+		for (i = 1; i < argc; i++) {
+			if (strcmp(argv[i], "version") == 0) {
+				rsi_test_version();
+			} else if (strcmp(argv[i], "hvc") == 0) {
+				rsi_test_hvc();
+			} else if (strcmp(argv[i], "host_call") == 0) {
+				rsi_test_host_call();
+			} else {
+				report_abort("Unknown subtest '%s'", argv[1]);
+			}
+		}
+	}
 exit:
 	return report_summary();
 }
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index ce1b5ad9..3cdb1a98 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -280,5 +280,20 @@ groups = debug migration
 [realm-rsi]
 file = realm-rsi.flat
 groups = nodefault realms
+extra_params = -append 'version'
+accel = kvm
+arch = arm64
+
+[realm-host-call]
+file = realm-rsi.flat
+groups = nodefault realms
+extra_params = -append 'host_call'
+accel = kvm
+arch = arm64
+
+[realm-hvc]
+file = realm-rsi.flat
+groups = nodefault realms
+extra_params = -append 'hvc'
 accel = kvm
 arch = arm64
-- 
2.17.1

