Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5206F778C
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjEDUzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjEDUyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:54:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1778138
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:54:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTEqDiaLUP6L93wX/udf/mLgozjTl/xZ4otcVjWbiPZhr90KA9n6AyDgq93Ii122SwDP2w+9Wpa6dXUwygmokIL+J+9ieehiBBQgcMK34nxTFR/5g7sOVc2Yq6nvnFN45m+p9jfp1CgHWwHvatDy+5Qq2kibfGL/oqcro4MZC9s3vtSuMdDgsB+G3tTYBtHafVbipz68OqV1Wsk9g7kIuUHvn3oEL71LzMVmNgJt2Roa1m0vUQFZHVQeeHlbyFfVBPxpTnN2G7ZNd/J40DqejFkKISyirHxDrIjvRG6xlKn0BY18OrVN43qUbvzi4tBXoW0NDiMMK4n/+0oflvaq2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbWhGaDsfZ7f4Rtw53TegEa8G45rHiyejRm38z1ZK3E=;
 b=JgFsGOiNLMCLokoCqqkDdPwmoyXrWGAQPl2/WXFUPrqxDQ0WY5wGWF4Y3ysuViYXOnNtPpj0GmXVaP/ZLsFGcUKV7JsQk5rGJ6HrJu30zUKK9Qqbf2m5WhuXxGuBGPUlzgEAzbh0RoGKPuHLSuEAOAqcJNsXqyQM7YALMw9cNaQBELd+EvBzLNvrNXsRBaaPs4diSgqYGDGxSfkptKMtJ7CbP9t3AAOP/iTtA7f5NimWvqCUrRp88MQObtqJ7arm/3+EQZv5ydT8JTWz4ZT3t7pZgvwG4G0ya64zxiNOuGwwC1PJUkihwUCXema4ul+CRfeS+91RFIVbdXxW5P5wkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbWhGaDsfZ7f4Rtw53TegEa8G45rHiyejRm38z1ZK3E=;
 b=pK0ZFFc5qn3z7wW4pLkfUWro4JsvRpC4V+8u0D0aR2/1ZB50t6g1bfDexCV/COO64GINlBo/E0atCrmxvhXGPsVjFNVVQa640uWZemSl25TbDj+Pu8M5e81nlRRiGKBj4YQD+hlId/7Jw7YUlO3B+vgRnX5Bwuaw8yt7UQHuV7U=
Received: from MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::16)
 by PH0PR12MB7470.namprd12.prod.outlook.com (2603:10b6:510:1e9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 20:53:31 +0000
Received: from CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::6c) by MW4P222CA0011.outlook.office365.com
 (2603:10b6:303:114::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 20:53:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT098.mail.protection.outlook.com (10.13.174.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.26 via Frontend Transport; Thu, 4 May 2023 20:53:30 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:53:28 -0500
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC:     <weijiang.yang@intel.com>, <philmd@linaro.org>,
        <dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
        <qemu-devel@nongnu.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>,
        <berrange@redhat.com>, <babu.moger@amd.com>, <bdas@redhat.com>
Subject: [PATCH v4 5/7] target/i386: Add missing feature bits in EPYC-Milan model
Date:   Thu, 4 May 2023 15:53:10 -0500
Message-ID: <20230504205313.225073-6-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230504205313.225073-1-babu.moger@amd.com>
References: <20230504205313.225073-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT098:EE_|PH0PR12MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c58fd64-e597-497c-a17b-08db4ce19e63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mM3B3IS/dYHTkEQwWQ40sFer8tudBGO1mo7IlLKgIwcAGVp2VeeA1oEvgR2RQTZbjVbrtM+SZCCwJOmNMWtpxOOxjTk9e5I8xZBAPV5QYT0nhPFfB6zAJM93RKMHpIawYojUhDgTr9XnD81wo4Jrf8B7ezVMwaOwyHK2zZLb9PawF1osmAtasHyI3lmJaKeTAlR7J5oF2XjmvvWAB8CQzUSPwn27WMfShEuvXOCLu4ttJGWW3D9xohaKCN9M71GCAHPPJiWzsCPbhZC/Er+XGZ7Cn04alTiPgHnzifLBkwIPM4rFOpEhvm8O21heRtVNfdtkNvY+PA3vDqju/qMGuWsi0uWyf+6N+GOoEXwgnRc/VeXj1juWBBjLLr4KxKGxV6hiypKeIQu6jPU8HP+I3jZlET4V9NuUJhnS1Pv+1GequwekL7ycMoc8+CZqrpocY8BKwbGmSTKkCuJ16Ap274pFSU7SKu1c7Y7J6/RXq6KMFSoLRQJUxgXe0pyhMre/epDzviHG+BQNspHlWlv0C+1dEt8vgjQ4Fq7axhxsYi89EW5VW0FpQ3SSmQ/nECjd1CSMBpgZN9wzSIKmLS0ajOkowRJ+z5uUTvvPkmSzwvxbRuzfPSX9fc5r/h+7HhMffHat6hERAYEaTZ3BVXXpTTdyHKANFpeYrqjcyrhcajrXFOxCz4ersH5ggZ/B8v2aj6Ut437EnNuoSmml+1Zz27jqCE6Pj7qM3VwA6v2CfigxnRGwvw+u4fbbJN4U2RllFDhToCIyG9ZB1xyvwSFMaA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(478600001)(4326008)(70206006)(7696005)(70586007)(6666004)(966005)(54906003)(316002)(110136005)(86362001)(36756003)(426003)(47076005)(336012)(26005)(36860700001)(1076003)(8676002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(2906002)(82310400005)(40480700001)(356005)(81166007)(16526019)(186003)(83380400001)(2616005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:53:30.9864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c58fd64-e597-497c-a17b-08db4ce19e63
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7470
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following feature bits for EPYC-Milan model and bump the version.
vaes            : Vector VAES(ENC|DEC), VAES(ENC|DEC)LAST instruction support
vpclmulqdq	: Vector VPCLMULQDQ instruction support
stibp-always-on : Single Thread Indirect Branch Prediction Mode has enhanced
                  performance and may be left Always on
amd-psfd	: Predictive Store Forward Disable
no-nested-data-bp         : Processor ignores nested data breakpoints
lfence-always-serializing : LFENCE instruction is always serializing
null-sel-clr-base         : Null Selector Clears Base. When this bit is
                            set, a null segment load clears the segment base

These new features will be added in EPYC-Milan-v2. The "-cpu help" output
after the change will be.

    x86 EPYC-Milan             (alias configured by machine type)
    x86 EPYC-Milan-v1          AMD EPYC-Milan Processor
    x86 EPYC-Milan-v2          AMD EPYC-Milan Processor

The documentation for the features are available in the links below.
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,
   Revision B1 Processors
b. SECURITY ANALYSIS OF AMD PREDICTIVE STORE FORWARDING
c. AMD64 Architecture Programmer’s Manual Volumes 1–5 Publication No. Revision
    40332 4.05 Date October 2022

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Link: https://www.amd.com/system/files/documents/security-analysis-predictive-store-forwarding.pdf
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
---
 target/i386/cpu.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5c93c230e6..0a6fb2fc82 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1923,6 +1923,56 @@ static const CPUCaches epyc_milan_cache_info = {
     },
 };
 
+static const CPUCaches epyc_milan_v2_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 512 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 1024,
+        .lines_per_tag = 1,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 32 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 32768,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = false,
+    },
+};
+
 /* The following VMX features are not supported by KVM and are left out in the
  * CPU definitions:
  *
@@ -4401,6 +4451,26 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .xlevel = 0x8000001E,
         .model_id = "AMD EPYC-Milan Processor",
         .cache_info = &epyc_milan_cache_info,
+        .versions = (X86CPUVersionDefinition[]) {
+            { .version = 1 },
+            {
+                .version = 2,
+                .props = (PropValue[]) {
+                    { "model-id",
+                      "AMD EPYC-Milan-v2 Processor" },
+                    { "vaes", "on" },
+                    { "vpclmulqdq", "on" },
+                    { "stibp-always-on", "on" },
+                    { "amd-psfd", "on" },
+                    { "no-nested-data-bp", "on" },
+                    { "lfence-always-serializing", "on" },
+                    { "null-sel-clr-base", "on" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_milan_v2_cache_info
+            },
+            { /* end of list */ }
+        }
     },
 };
 
-- 
2.34.1

