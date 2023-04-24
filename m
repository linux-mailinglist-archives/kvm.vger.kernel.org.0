Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B6A6ED28E
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjDXQeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjDXQec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:34:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB031D8
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:34:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yz4ZIJcGpPwdT9nJMDPZaZtF9h5B1tEncoQwA6Ero1mFOrhaL1ltAvD9g2gyEKkEILGi5V30TpKaI5eaa25XOkqVMWYeGKTS+6+hpI75FsyUPjhDKH1v2CTQE8RQRWWo9+oEY6CiYodIhpZTTPKQltySSviYNWAFSYHOrIgER+6/8ypa261azvRPJkdIwxxbv6O1By/kkYA3vf6dYV3iOxXqIF+ZgbVcK45QTS1hARtnLr9qR5HTW6Pof9xdqKhxjV4ObAAjbRhh2/pHVRzVDsLBy9UUOIh0ebBEJvGrtj14YMEy9jSPRbSG7YAmce6GUhlTo96Af29ByWjr/C5dJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5Epj38ZKzbUzQkCpLvxqBkF21nGDkFZD5EP0hJq634=;
 b=ihITkfQeWJqKu3CiHkiCUPuYYxnR0Bgp3Sa4bQ7jlHGE/tJrarqFyG/xNznqtitzx4+RoGMe2G/5ZvCBqUs0c0e31RGT324+FJyJpfzRIy5IxqwCdGYDdeT+335ibHa6dbtxMv7R+YEsg+Q+v3Oc9RMrB+lsuSToMetT2Fs8n9Zdgx/w73YDmaRX4D4SLD+dfU8VW0aYKorVG18Lu1EwGUwN+lwoLp1OZWtjdNksug4a34qRqC2MiZdnOECLFNiZmA/NknirBEB7klcDLfU8KBxFvNB7GMRe0c6DQkZ4uc5t8hLfAJiuE3bx/3oETJxeBq+Zojs4KFjvNk317yRpPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5Epj38ZKzbUzQkCpLvxqBkF21nGDkFZD5EP0hJq634=;
 b=vEoUMf58XJUKsEWBI+HG/Ov/9aa0lfgzl+C2Svl2wQrEObkktzzms0CfBXxmFOogmTI7/R0weEiXnBueMzDa2IGk3x4/qVQNiCURkdTJfiAbiBzbGtYUX5OPoz+W77inepQzApI5qBZFA9nmOtZA8pcG5OrpmafzHPfcdIMQAjM=
Received: from DM6PR11CA0041.namprd11.prod.outlook.com (2603:10b6:5:14c::18)
 by CYYPR12MB9016.namprd12.prod.outlook.com (2603:10b6:930:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:34:28 +0000
Received: from DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::ea) by DM6PR11CA0041.outlook.office365.com
 (2603:10b6:5:14c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 16:34:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT080.mail.protection.outlook.com (10.13.173.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 16:34:28 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 24 Apr
 2023 11:34:26 -0500
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
Subject: [PATCH v3 7/7] target/i386: Add EPYC-Genoa model to support Zen 4 processor series
Date:   Mon, 24 Apr 2023 11:34:01 -0500
Message-ID: <20230424163401.23018-8-babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT080:EE_|CYYPR12MB9016:EE_
X-MS-Office365-Filtering-Correlation-Id: c43449e9-212d-4f2f-fefc-08db44e1c60f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +S4VQikh3mZGesRdqn8hr8UHgsTlcAHoCbALOWUo1XfoBpUf/AKmt/IfHbW3TD6S57OE4XPk1t4ko+JjxGdPjr1TCNr3r1jK88d2H6eQQpzx5FCOvBCqbccmjK4r4q1iDIr+IQtuRtNWf84HZWkO9Bf0/ABswJHcY0nR24qlrjnN6lrUiCdCPt38i/f5c6FBsvWS8nSknLGS9FlY0FIBKKWihONKmkknYdJR1eeNySPNENEfzEGt3wHr7iBDb+klYY6EeyhYlBsE1S9A9/Io+50HHo7UkcVkICCpuowAkjKB7RHIxQrrNyeq9kG26Kxk8eyW6bW/ok997Ws11NbTONg5uV/ks1CEH5ppW6ecmC++vt0FMC44lN3Gplk5C9u7rJkHad7k2N9YmJ7AzoEOqLgy0J8BQJ0eecUE5h2Li8bMRy3R7Fn3gspdx0O8JPao2VuN4xyvz7jhmjKc4LeBXmyXwGdhoZchef3Ukj1pGX3mcZDlVrTfr1WJUKIV7OJA2HiEecg1KHi1t+pmfG3aEpklVLsom5RGQ+TioAWx6+a+0KKvtofuzyUonPU1m5dQCeJdZASPwvTKdEoYX7tmj0hdbFd0QSj9SLEqksdNUt+NzOdPHgMKMNjeu1daS2OoImfAb3uPaCzxpGS2gYO3YcRJ0m/9BysmtnUkUEoP3GEUGItvXWu7wjF9KnGryX4pKQ4NhRnYTpLdECrMW0paXnlkZY9lQpf1ZnbOHUYJpH8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(7696005)(2616005)(6666004)(16526019)(1076003)(26005)(186003)(40480700001)(70586007)(70206006)(8676002)(8936002)(316002)(41300700001)(4326008)(478600001)(44832011)(5660300002)(7416002)(54906003)(110136005)(82740400003)(356005)(81166007)(82310400005)(36756003)(86362001)(40460700003)(36860700001)(47076005)(426003)(336012)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:34:28.3699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c43449e9-212d-4f2f-fefc-08db44e1c60f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9016
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds the support for AMD EPYC Genoa generation processors. The model
display for the new processor will be EPYC-Genoa.

Adds the following new feature bits on top of the feature bits from
the previous generation EPYC models.

avx512f         : AVX-512 Foundation instruction
avx512dq        : AVX-512 Doubleword & Quadword Instruction
avx512ifma      : AVX-512 Integer Fused Multiply Add instruction
avx512cd        : AVX-512 Conflict Detection instruction
avx512bw        : AVX-512 Byte and Word Instructions
avx512vl        : AVX-512 Vector Length Extension Instructions
avx512vbmi      : AVX-512 Vector Byte Manipulation Instruction
avx512_vbmi2    : AVX-512 Additional Vector Byte Manipulation Instruction
gfni            : AVX-512 Galois Field New Instructions
avx512_vnni     : AVX-512 Vector Neural Network Instructions
avx512_bitalg   : AVX-512 Bit Algorithms, add bit algorithms Instructions
avx512_vpopcntdq: AVX-512 AVX-512 Vector Population Count Doubleword and
                  Quadword Instructions
avx512_bf16	: AVX-512 BFLOAT16 instructions
la57            : 57-bit virtual address support (5-level Page Tables)
vnmi            : Virtual NMI (VNMI) allows the hypervisor to inject the NMI
                  into the guest without using Event Injection mechanism
                  meaning not required to track the guest NMI and intercepting
                  the IRET.
auto-ibrs       : The AMD Zen4 core supports a new feature called Automatic IBRS.
                  It is a "set-and-forget" feature that means that, unlike e.g.,
                  s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS mitigation
                  resources automatically across CPL transitions.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ce26e955d8..0b0ff4a0c0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1973,6 +1973,56 @@ static const CPUCaches epyc_milan_v2_cache_info = {
     },
 };
 
+static const CPUCaches epyc_genoa_cache_info = {
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
+        .size = 1 * MiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 2048,
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
@@ -4472,6 +4522,78 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             { /* end of list */ }
         }
     },
+    {
+        .name = "EPYC-Genoa",
+        .level = 0xd,
+        .vendor = CPUID_VENDOR_AMD,
+        .family = 25,
+        .model = 17,
+        .stepping = 0,
+        .features[FEAT_1_EDX] =
+            CPUID_SSE2 | CPUID_SSE | CPUID_FXSR | CPUID_MMX | CPUID_CLFLUSH |
+            CPUID_PSE36 | CPUID_PAT | CPUID_CMOV | CPUID_MCA | CPUID_PGE |
+            CPUID_MTRR | CPUID_SEP | CPUID_APIC | CPUID_CX8 | CPUID_MCE |
+            CPUID_PAE | CPUID_MSR | CPUID_TSC | CPUID_PSE | CPUID_DE |
+            CPUID_VME | CPUID_FP87,
+        .features[FEAT_1_ECX] =
+            CPUID_EXT_RDRAND | CPUID_EXT_F16C | CPUID_EXT_AVX |
+            CPUID_EXT_XSAVE | CPUID_EXT_AES |  CPUID_EXT_POPCNT |
+            CPUID_EXT_MOVBE | CPUID_EXT_SSE42 | CPUID_EXT_SSE41 |
+            CPUID_EXT_PCID | CPUID_EXT_CX16 | CPUID_EXT_FMA |
+            CPUID_EXT_SSSE3 | CPUID_EXT_MONITOR | CPUID_EXT_PCLMULQDQ |
+            CPUID_EXT_SSE3,
+        .features[FEAT_8000_0001_EDX] =
+            CPUID_EXT2_LM | CPUID_EXT2_RDTSCP | CPUID_EXT2_PDPE1GB |
+            CPUID_EXT2_FFXSR | CPUID_EXT2_MMXEXT | CPUID_EXT2_NX |
+            CPUID_EXT2_SYSCALL,
+        .features[FEAT_8000_0001_ECX] =
+            CPUID_EXT3_OSVW | CPUID_EXT3_3DNOWPREFETCH |
+            CPUID_EXT3_MISALIGNSSE | CPUID_EXT3_SSE4A | CPUID_EXT3_ABM |
+            CPUID_EXT3_CR8LEG | CPUID_EXT3_SVM | CPUID_EXT3_LAHF_LM |
+            CPUID_EXT3_TOPOEXT | CPUID_EXT3_PERFCORE,
+        .features[FEAT_8000_0008_EBX] =
+            CPUID_8000_0008_EBX_CLZERO | CPUID_8000_0008_EBX_XSAVEERPTR |
+            CPUID_8000_0008_EBX_WBNOINVD | CPUID_8000_0008_EBX_IBPB |
+            CPUID_8000_0008_EBX_IBRS | CPUID_8000_0008_EBX_STIBP |
+            CPUID_8000_0008_EBX_STIBP_ALWAYS_ON |
+            CPUID_8000_0008_EBX_AMD_SSBD | CPUID_8000_0008_EBX_AMD_PSFD,
+        .features[FEAT_8000_0021_EAX] =
+            CPUID_8000_0021_EAX_No_NESTED_DATA_BP |
+            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
+            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
+            CPUID_8000_0021_EAX_AUTO_IBRS,
+        .features[FEAT_7_0_EBX] =
+            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_BMI1 | CPUID_7_0_EBX_AVX2 |
+            CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_BMI2 | CPUID_7_0_EBX_ERMS |
+            CPUID_7_0_EBX_INVPCID | CPUID_7_0_EBX_AVX512F |
+            CPUID_7_0_EBX_AVX512DQ | CPUID_7_0_EBX_RDSEED | CPUID_7_0_EBX_ADX |
+            CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_AVX512IFMA |
+            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
+            CPUID_7_0_EBX_AVX512CD | CPUID_7_0_EBX_SHA_NI |
+            CPUID_7_0_EBX_AVX512BW | CPUID_7_0_EBX_AVX512VL,
+        .features[FEAT_7_0_ECX] =
+            CPUID_7_0_ECX_AVX512_VBMI | CPUID_7_0_ECX_UMIP | CPUID_7_0_ECX_PKU |
+            CPUID_7_0_ECX_AVX512_VBMI2 | CPUID_7_0_ECX_GFNI |
+            CPUID_7_0_ECX_VAES | CPUID_7_0_ECX_VPCLMULQDQ |
+            CPUID_7_0_ECX_AVX512VNNI | CPUID_7_0_ECX_AVX512BITALG |
+            CPUID_7_0_ECX_AVX512_VPOPCNTDQ | CPUID_7_0_ECX_LA57 |
+            CPUID_7_0_ECX_RDPID,
+        .features[FEAT_7_0_EDX] =
+            CPUID_7_0_EDX_FSRM,
+        .features[FEAT_7_1_EAX] =
+            CPUID_7_1_EAX_AVX512_BF16,
+        .features[FEAT_XSAVE] =
+            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
+            CPUID_XSAVE_XGETBV1 | CPUID_XSAVE_XSAVES,
+        .features[FEAT_6_EAX] =
+            CPUID_6_EAX_ARAT,
+        .features[FEAT_SVM] =
+            CPUID_SVM_NPT | CPUID_SVM_NRIPSAVE | CPUID_SVM_VNMI |
+            CPUID_SVM_SVME_ADDR_CHK,
+        .xlevel = 0x80000022,
+        .model_id = "AMD EPYC-Genoa Processor",
+        .cache_info = &epyc_genoa_cache_info,
+    },
 };
 
 /*
-- 
2.34.1

