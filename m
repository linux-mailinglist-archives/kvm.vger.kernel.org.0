Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD06B6ED28A
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjDXQek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjDXQeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:34:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567CBEB
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:34:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMeCnPEjUEUuoab9ucLxpBdde/Ec4Q7iyyqfXJnBVv18lN0si5GS50vHd28WpzM/i941uSOYuASPQBn6Vh9/DJ08cj+5ihcWjUbJhN8LeLx9TkAHtq8QECm/HEFeKYcTiq7KcH81U8EqUs4xYARWFTh/fd2TLKv50EsWAe+SZVAU+yjhrZDfa+20tpXcm2ewylfY5eGdh5QkSgILdcweTeteZGnY/y+bBYWhk7R4HVFAt7U/VjzDJksCs0ck3dG8ahlk+30GjY5G+wem4Y9j0jty7V5dBm1UDxZRTdu7t/YKPZ21Qn7uZyNVEUMxkb8x4rXDsIjsaMA+jEJvGSB+5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAvaZEU087p2jIqr/yOJjk5Kq/4c3c/rLnmdy7WIlw8=;
 b=g/MjuZ9WNggr/79W9usxQDjmQlaxc1jKnXv85F1EwxlCLZFnRrvQA1rRphoWrvtGjECEl18RI7DoIqKZZUmuGzrKGFq9a5PUllGPeOewlEO5s53+Vhq7xVmJJRqGdYxXO8NNlaOxtS4ailTBjjxBnLdvdPQSkQhKN0Us4ADJAhwX3wGTncHK+fmK0Ppk/dgFOeCfKuNu/OocR28Ser4lhh5YKmVWyFo8cmtXGXkIP6n9UFuTPCSjSKcuFPQdUKphaUt7YXGBTvZGZPLBx9Bgi03IJa4jepfKhZVO/2wisFspYnxF6iR2mLkQQIM5xn0pT+OvUoWW+40lQxHngard1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAvaZEU087p2jIqr/yOJjk5Kq/4c3c/rLnmdy7WIlw8=;
 b=CuIYhK2Dwue2Cm/xHOgCiXvK80285b4oVHluCecBDNbObO0ou5F1/HDMBvCMJO+c883vxhe1i8YVbN4Z2Z27MK123En2cFZaMblwiHpC7eoZgXTFFQoEWcPO43b7zh9URmCzAH7g54W379S8uXenAElTwVVyn3b8ucpdKRHUEbM=
Received: from DS7PR05CA0017.namprd05.prod.outlook.com (2603:10b6:5:3b9::22)
 by IA0PR12MB8279.namprd12.prod.outlook.com (2603:10b6:208:40c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:34:22 +0000
Received: from DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::48) by DS7PR05CA0017.outlook.office365.com
 (2603:10b6:5:3b9::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.19 via Frontend
 Transport; Mon, 24 Apr 2023 16:34:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT079.mail.protection.outlook.com (10.13.173.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 16:34:21 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 24 Apr
 2023 11:34:19 -0500
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC:     <weijiang.yang@intel.com>, <philmd@linaro.org>,
        <dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
        <qemu-devel@nongnu.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>,
        <berrange@redhat.com>, <babu.moger@amd.com>
Subject: [PATCH v3 3/7] target/i386: Add a couple of feature bits in  8000_0008_EBX
Date:   Mon, 24 Apr 2023 11:33:57 -0500
Message-ID: <20230424163401.23018-4-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230424163401.23018-1-babu.moger@amd.com>
References: <20230424163401.23018-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT079:EE_|IA0PR12MB8279:EE_
X-MS-Office365-Filtering-Correlation-Id: a72d0617-b81e-41bb-7b94-08db44e1c22d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B86UmuKuhPTA7p7eCLftXN4a0Rw9iO/vTyjgNGcEfgwhc0cn4FqxM8WG8UDK1ukiD/YXvxGkrXt/zvI0BwVPzkdbd8FDlJFiRkyrjvzTlnx1LoBBbqaTSLVJVSvuJAFSfxk3sBr653pzhu1ZQpzQrv1vcdJs35pjf+6gHwoBLZvcSiL5ijOI5HiKV1vvTkovOzJrYSs5OsLANAn+6Z6JOzk3qUWcgODkuT0S4gKFvjTBYlBi6kDPhgaJUjKLib1WCmR9Aef0weitsGuqpAEoyQXughQHo3Mfx/qV7CqsS1i7kIIi1cLbPZBFMfRjzFgWZ3tOreUCMVsaJczChp1RgsO4QbkGL6VF0xQKX52x2zR+kfH3yVzePjA6MMqVo0QLkJlBe0j5bH2xMTjy4D0CJ5HGLnjdWKMRZ6Ykg/Ldg0viEVrHXUI4pxA2s7dzVdz1WvtjKy+cprYvD8b5JptRkVoNqKw1unBtoL6ZP537ZDr9ATmSEpit4R3PX5OGnve5v/7mvvruFZ0strRxS7ps8PEOnbHCOAA6hin87JZ8pRly5E9jp8DlBJrXIKzuEZJZp5VB5sFtfbT1L+f89pEMAn9W/nWMOaIo9lkZhNa14bZCXw1yfKDQxzvkXIgpL7obHsqy1eNy0DujBqKhTvLfsxHs3d1Fhr3k7It112sj/bV2X7tGh+r0UwDBuH0FeNMs6Q6Zty/KBi/3wuXnzd7mkfOukcq5m24jjJmAu4UlOacrzcsV9Mzoo3keWsojFoniIZVoWIwb2z3xP06aob/bZQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199021)(36840700001)(46966006)(40470700004)(478600001)(40460700003)(16526019)(110136005)(54906003)(86362001)(966005)(36756003)(186003)(7696005)(26005)(82310400005)(1076003)(40480700001)(6666004)(4326008)(316002)(82740400003)(44832011)(83380400001)(70206006)(70586007)(36860700001)(2906002)(336012)(356005)(426003)(41300700001)(81166007)(8676002)(8936002)(5660300002)(47076005)(7416002)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:34:21.8366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a72d0617-b81e-41bb-7b94-08db44e1c22d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8279
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following feature bits.

amd-psfd : Predictive Store Forwarding Disable:
           PSF is a hardware-based micro-architectural optimization
           designed to improve the performance of code execution by
           predicting address dependencies between loads and stores.
           While SSBD (Speculative Store Bypass Disable) disables both
           PSF and speculative store bypass, PSFD only disables PSF.
           PSFD may be desirable for the software which is concerned
           with the speculative behavior of PSF but desires a smaller
           performance impact than setting SSBD.
	   Depends on the following kernel commit:
           b73a54321ad8 ("KVM: x86: Expose Predictive Store Forwarding Disable")

stibp-always-on :
           Single Thread Indirect Branch Prediction mode has enhanced
           performance and may be left always on.

The documentation for the features are available in the links below.
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,
   Revision B1 Processors
b. SECURITY ANALYSIS OF AMD PREDICTIVE STORE FORWARDING

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://www.amd.com/system/files/documents/security-analysis-predictive-store-forwarding.pdf
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c1bc47661d..64a1fdd6ca 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -911,10 +911,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, NULL, NULL, NULL,
             NULL, "wbnoinvd", NULL, NULL,
             "ibpb", NULL, "ibrs", "amd-stibp",
-            NULL, NULL, NULL, NULL,
+            NULL, "stibp-always-on", NULL, NULL,
             NULL, NULL, NULL, NULL,
             "amd-ssbd", "virt-ssbd", "amd-no-ssb", NULL,
-            NULL, NULL, NULL, NULL,
+            "amd-psfd", NULL, NULL, NULL,
         },
         .cpuid = { .eax = 0x80000008, .reg = R_EBX, },
         .tcg_features = 0,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d243e290d3..14645e3cb8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -932,8 +932,12 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_8000_0008_EBX_IBRS        (1U << 14)
 /* Single Thread Indirect Branch Predictors */
 #define CPUID_8000_0008_EBX_STIBP       (1U << 15)
+/* STIBP mode has enhanced performance and may be left always on */
+#define CPUID_8000_0008_EBX_STIBP_ALWAYS_ON    (1U << 17)
 /* Speculative Store Bypass Disable */
 #define CPUID_8000_0008_EBX_AMD_SSBD    (1U << 24)
+/* Predictive Store Forwarding Disable */
+#define CPUID_8000_0008_EBX_AMD_PSFD    (1U << 28)
 
 #define CPUID_XSAVE_XSAVEOPT   (1U << 0)
 #define CPUID_XSAVE_XSAVEC     (1U << 1)
-- 
2.34.1

