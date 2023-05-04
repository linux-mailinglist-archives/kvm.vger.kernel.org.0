Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886BD6F7787
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjEDUzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjEDUyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:54:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE35B1
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:54:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLDyMtfSC09kGEieg1uRm9VYIOphjR923sXkpLRGPUuM0Lw0ZYhCaVixeNMARjTaeyKY8Yzwvtd/xDsHywk3lvSwEcjU5ZM7n2W5jLwV3JnZBaZLBJhQS4B8k9hvUBjZQSJLhNdTY6aqcjwmqC3sAEEPU44D+pm3fA4q4azIsOaw4wwyG4OHb4DP4LyWOZhFEpEi99z2N0TsY9zo4apDbr1xRovNfKrUTD9yPsy9Psh8sGQ4rqZ8C5BRsdbmpC0DWdVYA/9NDc2KCk62U7aakhjWnIpogSPHk0rXjhhcDceEX7Bikf4RMX8G5Z7Pckh7YBe3wH8slEpVZx6B4qiVfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlHpPkuppVHlDMATPAqeYcJ2Kr09C0OxfBnDZdoE/ew=;
 b=f6soLSczfvcFRZpIg8gSdoJkYOadMs2M5OhytuXEcuwtvavhz9pjILzMRy0h5EYM287AD6N9fJ1ikJkm94u8X97CwaW2Ho5lIWzRNUAFXQv7eZIlzw8OOHlrisMMpRI3oEqTR/LCC+6wcoOWfhneYe/XaC2BrSUkOmf1hOxuV0dRs8TeSdnuhoA9U5o7L8hP6ULGS3znbVxCZ2vGSwhTtZ4W+k2o4PiUnGTO+bHt+Lu/V3jNOWaqzfbiTiSZ/tQsPLjZeAHtC024MaVIQc8JkjtHaIvP7t6D33kez11OD5K1moQL/d3TADwm/FgbBtmoxpGunD/bssvzlQ0oWxEnHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlHpPkuppVHlDMATPAqeYcJ2Kr09C0OxfBnDZdoE/ew=;
 b=SwWC9RE65gPxuXsxMxx5Kwtd8tyqYkTQpKjbdyyokPLeLEUrkJaCbNYI8Ak5fU1F9vCbYf3vumSMFxAFVFobVI0Y9+bwkcslLr7G7UdGRiqKLCzuLxbWw3rkJIEwN9FmJOtnhAujDRJef64cJVFsS+WRyTyedUW8vfIpUp5WWVA=
Received: from MW4PR04CA0198.namprd04.prod.outlook.com (2603:10b6:303:86::23)
 by MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 20:53:32 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::7a) by MW4PR04CA0198.outlook.office365.com
 (2603:10b6:303:86::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 20:53:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.27 via Frontend Transport; Thu, 4 May 2023 20:53:31 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:53:30 -0500
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
Subject: [PATCH v4 7/7] target/i386: Add EPYC-Genoa model to support Zen 4 processor series
Date:   Thu, 4 May 2023 15:53:12 -0500
Message-ID: <20230504205313.225073-8-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230504205313.225073-1-babu.moger@amd.com>
References: <20230504205313.225073-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT046:EE_|MN2PR12MB4423:EE_
X-MS-Office365-Filtering-Correlation-Id: 24e24c36-ed0c-4fbd-c9b9-08db4ce19ed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GJ/4yIdlH21nkrVVDVEF/+gh/krLJzajldqimztiLDagtamb5A9dgboh4vM4Oqbtt2fH6J55j+v7qNkiDoI1MUVXcJt3n/Pj4oq+cHcfRcWUUL3ROJ+/lsuIS/GmtYdhMGxqwcVkfMkJXfcOOYDeWMgTRT7aQcg6oi6bHYLOl89qvVNnBGV2S8njh5G9XClju67QEB06caE8RgWdhGhn6VpIRlWTgQ3I3RJhYPwleHhM1CbgC9y9MUS1BLcPPuqAjEPZNqAzzSeO9NRNbUvj84Ex0jH0rXXKwrX/so9yJFWo4eFuKSOTxOImoBDB/6DySgk7xR7lpcgxAPQeTuht1tw6KnqQlHVTsosV/PIOE7QM1Dhinl+zxx1/WDC60rdevD8e55Ord6Za4r4P8a9BiqJpHF4xmufsyLIXmGU3y56uVkMbLlyyedDEFmz7vlQgVcFZ6sEdVT1WRKWZQ/RnpKJNiEFydahR9pve1+bNMwlwa6QttUHPvJU8dYQbsYY1IoOeJI5CLmMazeq5xs4pL2oXDe6JS8UBMJc9cdnO11z18dLuJSk5khT+37IJ47sexVodN+IL08URK0TfKBAKJ9JdKuJ89Hj0IRkXkHu5DaxmDW5k0pZyburHde8EvkyZq9xIW0vThExjJrdAMBOMUFJy374zKIxm9vO5kZqoTsmMqJ9zsA6jvHWfV6pRAb+SJxHuJWew4bgpivTCujfSXrkrenInjepNAJfJxayxysg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(40470700004)(46966006)(36840700001)(36756003)(47076005)(86362001)(70586007)(54906003)(7696005)(70206006)(6666004)(110136005)(4326008)(478600001)(316002)(82310400005)(40480700001)(5660300002)(2906002)(44832011)(8936002)(7416002)(16526019)(82740400003)(8676002)(356005)(81166007)(186003)(2616005)(1076003)(26005)(41300700001)(36860700001)(426003)(336012)(83380400001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:53:31.7436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e24c36-ed0c-4fbd-c9b9-08db4ce19ed4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
index d50ace84bf..71fe1e02ee 100644
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

