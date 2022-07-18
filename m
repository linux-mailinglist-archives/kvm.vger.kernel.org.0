Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA32C577DA4
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 10:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiGRIjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 04:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiGRIjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 04:39:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3F1BF42;
        Mon, 18 Jul 2022 01:39:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7biwFhwCd+4SkL56QqbWXYDwC3pMh1XJJsey5gnjeomE+Vs8XxoJ90wEUNUcan67XKwsY4EoqXHi6HWwwaoWyx3ZF/yJkppT8arlTEWIlBq6KhpbcJ9L80I/46GrWYi3Qv3smkzu8uuxx7Bui3qGYKZsezpfwgZfKVCmkFB1D/Y5jRuE5TynPgFNDlpu3hxy01wztA8YMWR+an7iieD2kq4pknLJzoCm5kULmnrP2LZaLEmMkGpwwkDT6JMLeRtq3WeiB26aIl8Y4iPpI7p/FZzYExRAaMCob3TUMbJMH6CH1DrKplKXhWmHsRmS032qHxVYoCO8ghEQvIcsds3Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGzY2w9ALWL01PMVskLRY2Ogm/M/Uc/aXDE9xYVemRQ=;
 b=NCMWfJ8YgZI/DZJCn8y3TmrPwMM4o+jeFcS8dNV4bOf+JEk+vZFJ5fXry1brxz0sqvoE14JrXm3cKaH3BNfLxYwmey6u/dwlYEQojmbr02wvkThuesfpDnWK5UlpS2ZOoI1GYjoeTJ5hoXef/naCgjZLaq5OnAW5SMn1KH2BrL/boEgw2Y99CDLfLFRuSjnsJ31p9HTp/YrW1KaR8pan8yub3Vy3zC28rIaHSCRQefntqzsyZJaykHQBNhJrwYRZWg6Aud+JHK4TK6C5qdnomod83RpLRU0MnVh1F3xqbbsbXzn56gJy4sphNHDeN1Zebwp9JyzZaqhQX1wAo70JLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGzY2w9ALWL01PMVskLRY2Ogm/M/Uc/aXDE9xYVemRQ=;
 b=jcZ79ybcYyQ0hAzTWwZlM7H3eJPaFAWVuH11Y4p/23D8S7AWN79ymCYNVFQ+1JQETBw+fk5eEim2WpedGpIUsgWTGBPSWkK3TbMxBEuAUUXesKYTpGnLC4TlhiH37jnuzyBeaEUO/ZHpUwceXncaVSht2rVapicRK0qIZPRgSzk=
Received: from MW4PR03CA0228.namprd03.prod.outlook.com (2603:10b6:303:b9::23)
 by BYAPR12MB3638.namprd12.prod.outlook.com (2603:10b6:a03:dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Mon, 18 Jul
 2022 08:38:57 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::e7) by MW4PR03CA0228.outlook.office365.com
 (2603:10b6:303:b9::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17 via Frontend
 Transport; Mon, 18 Jul 2022 08:38:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 08:38:57 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 03:38:52 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Fix x2APIC MSRs interception
Date:   Mon, 18 Jul 2022 03:38:33 -0500
Message-ID: <20220718083833.222117-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a0a1cc3-f3f0-4c9a-e18c-08da6898f480
X-MS-TrafficTypeDiagnostic: BYAPR12MB3638:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xvdFuoJkw2iXW2CFEEW5YEC086BHQxNqBQ6dSzXAogaT6kGJU1z+P8V3Be14tnFLOt3lOHWvhhDHjNPrLj502FaFWmhCZpfz9pgqLVSpJfxAoqGvUxD17p5RqshN0ZATeWuNSU/MxbVw2lVIFMUPOVHlPMIuWAZLCg6bl3Mb8ekOgFcPfzwMrDaplOYHS1cRoGqAssdsaBc/1UMCpL9xDaiUKG2DftmVOp2dM7vUUD0oMtldWuCky4+Tm9GmwbOuiDNjoX5cu0JjIXWEW7tfxdGYS/9lCPG6hK1oTtnnhmPnEIJlETysCI6vPw8HByedHP5XWlXKof9SaJvMizrf+XHNr+nqpbsLSEyCFXZJFDpWdTYa6cMKCEU4AfcCHk4K2uDV7PPMBwwZJN4E9+fhXnOTtWh7yc88VhIYu8BKdW7VdMfa+RtcXjzYnxaPygT+xDy2927hEW8Z4Wf83O6NZouM7ZB1W1/zEwqf/FvoE9KZPuQDJe86D2eJJ5cbZdM/4973TiwdemKIcsPSVNlgbQTOMhsX5nd7ENPN4zXSoAG7+bTddZb4HH0Vjm8VqcVe5dEHPv6EVujqd3SOCSuSfvoocBhmetcu0l3V29DuU8ftEmKI18ZwWXVQKvOqlFq5XbpM9xpuNp1GBJGW75wLSPdrIVVmPvsiVfWpCTbJu+FyF4HKXOR4oNdG3j3u5vaaQhIMYWnLOkcj5jIyQeR9ugFqjaj8vq/tJyrvqPohVWqpLNW82cDGZC5q+tW7gcfZYStzSCdWBQFbJoRCa3TcP9a2EZKBpOBTXJfGhoDM7GiYEUQFrccCdxKyCxlu+pE8wqIl9PrJZEVk31vyuBjfyD0XZz4RzXiENkbg2XmyrV8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966006)(36840700001)(40470700004)(82740400003)(81166007)(83380400001)(478600001)(36756003)(356005)(6666004)(7696005)(41300700001)(2616005)(336012)(316002)(186003)(47076005)(1076003)(426003)(16526019)(110136005)(8676002)(82310400005)(40460700003)(44832011)(4326008)(70586007)(8936002)(70206006)(5660300002)(36860700001)(2906002)(86362001)(54906003)(26005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 08:38:57.0876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0a1cc3-f3f0-4c9a-e18c-08da6898f480
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3638
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The index for svm_direct_access_msrs was incorrectly initialized with
the APIC MMIO register macros. Fix by introducing a macro for calculating
x2APIC MSRs.

Fixes: 5c127c85472c ("KVM: SVM: Adding support for configuring x2APIC MSRs interception")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 52 ++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ba81a7e58f75..aef63aae922d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -74,6 +74,8 @@ static uint64_t osvw_len = 4, osvw_status;
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
+#define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
+
 static const struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is initially cleared */
@@ -100,31 +102,31 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
 	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
 	{ .index = MSR_TSC_AUX,				.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_ID),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_LVR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_TASKPRI),	.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_ARBPRI),	.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_PROCPRI),	.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_EOI),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_RRR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_LDR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_DFR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_SPIV),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_ISR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_TMR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_IRR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_ESR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_ICR),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_ICR2),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_LVTT),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_LVTTHMR),	.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_LVTPC),	.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_LVT0),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_LVT1),		.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_LVTERR),	.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_TMICT),	.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_TMCCT),	.always = false },
-	{ .index = (APIC_BASE_MSR + APIC_TDCR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_ID),			.always = false },
+	{ .index = X2APIC_MSR(APIC_LVR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_TASKPRI),		.always = false },
+	{ .index = X2APIC_MSR(APIC_ARBPRI),		.always = false },
+	{ .index = X2APIC_MSR(APIC_PROCPRI),		.always = false },
+	{ .index = X2APIC_MSR(APIC_EOI),		.always = false },
+	{ .index = X2APIC_MSR(APIC_RRR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_LDR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_DFR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_SPIV),		.always = false },
+	{ .index = X2APIC_MSR(APIC_ISR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_TMR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_IRR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_ESR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_ICR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_ICR2),		.always = false },
+	{ .index = X2APIC_MSR(APIC_LVTT),		.always = false },
+	{ .index = X2APIC_MSR(APIC_LVTTHMR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_LVTPC),		.always = false },
+	{ .index = X2APIC_MSR(APIC_LVT0),		.always = false },
+	{ .index = X2APIC_MSR(APIC_LVT1),		.always = false },
+	{ .index = X2APIC_MSR(APIC_LVTERR),		.always = false },
+	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
+	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
+	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
-- 
2.34.1

