Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E85C6F7788
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjEDUzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjEDUyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:54:53 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B799EEE
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:54:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j74N8s2BARecRM4Z/EGTkbImoJvGa654hAPxT8hvz1BS2S6dKtcgAyDnRAYq4oCVv4JQJ3lAxqIS0r06ihp9F+PvmxXRgAHwpK2iAc5DUFE0RYMTBx5TKcX1JUCAOuTT7uZrJt7AzWOqtplDBRuYyn9C2FJubR7DIYszpdspvNOLpReMgEtdaaqke9YOACXYJTU18dkezL0JI+xutrU5zC/H31zUB/nOly/tTbtVMs6OflR9NkW/vGTWIEWR/TS9L7VBMC3WpLBirvDMA0MpYMCXi+PzS18Flcx0sDIVxevNydKugjb6rcWA+n1qvCfUerdgZ19ItG2bDxBG7ZgrLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hp2/tJWr7a7IUBgGdrJraven/9x9JRPhj+y1L5oiqI=;
 b=Y6FEKHhekwrB606kNXId3fUU+GTtvJzbGcpIXd/MpjDSJ+AA8DfflyrXnvgjfUsc0jpDimIeKbIGDF/MiDoXpE5CILm/mxiwj9xkO10UOK8iQfkyAm7m/QMy3Gtw6J1e9V/fc/u4hMpVB90IXKkxCiGvI+R3tnx8XGPxQ+dgdBZU7Pqdg//okksMVeL76DiEmAl8CJMKqyja1kU/bER7xH6w+FPWU2ZUGd/RGM1DHgg8HKV8i3GPYIM5NJy9bIdDPb2cND9VVSyz91/1e3wiy9NK+fH6iOnqlJX7J2TbnUAsiJStVewyqYFZui2qB1yrE3M6ZtRtEYOHvbF44c5W9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hp2/tJWr7a7IUBgGdrJraven/9x9JRPhj+y1L5oiqI=;
 b=374MoYwbRXh/9Yk0EgfBt7OhAJ6gPxaSTD8ZVMye5GoPNTTLOkFp43qjxj0RhWwiBYEATfh1OXUWyf0A3f9bFGn1kRXLATkgcPaCrL8qRC1Qg5+OLg5D/mnebiDBaNQSiSMK1mvbSyoyvQmotZSumB1MyWlSiKNYuhMkPpwyXAk=
Received: from MW4P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::19)
 by PH7PR12MB7306.namprd12.prod.outlook.com (2603:10b6:510:20a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Thu, 4 May
 2023 20:53:31 +0000
Received: from CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::da) by MW4P222CA0014.outlook.office365.com
 (2603:10b6:303:114::19) with Microsoft SMTP Server (version=TLS1_2,
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
 15.20.6363.26 via Frontend Transport; Thu, 4 May 2023 20:53:31 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:53:29 -0500
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
Subject: [PATCH v4 6/7] target/i386: Add VNMI and automatic IBRS feature bits
Date:   Thu, 4 May 2023 15:53:11 -0500
Message-ID: <20230504205313.225073-7-babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT098:EE_|PH7PR12MB7306:EE_
X-MS-Office365-Filtering-Correlation-Id: c27fdc1b-c059-48e2-9b88-08db4ce19ec0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpLsU8Pj741D7pfdOPAASpLZ21iU94ttyjGdczuNgIygA/l/iUzacjjca8JvSJ9m7LAiAPz6gKlTAik4o749bOu3QGSMzfGfSf2e4ZE1rMZu/DL7KSAx0OOxeKAkxpcSDCLLaEfUDeANXTUfbrLa7lBCABARjJPOTD+45Xjww5tgl3lCjGpQvXzLVBVl8RUKD/Q1/teEcr4BjVcboslcgHzkjtLOpQGOFKxXfwZdZylh3Sj1eA6EBy+wDG/Gw3TFDnKCoRovAoot9HLUhrGXgr4dD3kwAGOHpYg8XH76tGF/27ejQIZtJI2WUjnVJAtPb6R9b7+tnC3FVN3pGR+uLE9zU/ZzOrbo5NkQElgo1jAPQqtdpz5AR8txCRgdzYHQntc/sHhFrAj+qFu8nwMLvopHXMi1m2ymSkQ0eAj1lFh6Nl9p2F45WV1TEkip1NQ5pFfQYz7NKx+NIOrE4jAc3DZoh6IsZGZ5sU1upM4bLI0PRGDcMp9cTKlRJVYC8vgUtn1MNH80+W5HMX7BjNxsZ92VLf2B5TNeUPXt25a0lt4V37WdjEUu0nPFC5DhaJYkvUwrhCrUqKtuRkVxsv/p4QzTAfUlY6euN7Zr7S0eelQ/vLqn6t9SRidYWKPJpI/6ZwPiK3DirYu1vLFGMZRFY/6LCbZvJUb4TTG5ML5m9Ij002MHrldscL0PB7olTX2jcUPgQXysnF7lVGfYYiKF5BHUrZuf+YmLfnxuo0sQiQ4xmXCKBCAkv1Fk3tA1960gXJsMc/OB5zPKAW5CRWX05A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(478600001)(186003)(36756003)(16526019)(54906003)(2616005)(82310400005)(7696005)(966005)(4326008)(36860700001)(47076005)(6666004)(316002)(110136005)(1076003)(26005)(336012)(70586007)(83380400001)(426003)(70206006)(8936002)(41300700001)(2906002)(5660300002)(8676002)(356005)(82740400003)(7416002)(44832011)(40460700003)(40480700001)(86362001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:53:31.6113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c27fdc1b-c059-48e2-9b88-08db4ce19ec0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7306
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following featute bits.

vnmi: Virtual NMI (VNMI) allows the hypervisor to inject the NMI into the
      guest without using Event Injection mechanism meaning not required to
      track the guest NMI and intercepting the IRET.
      The presence of this feature is indicated via the CPUID function
      0x8000000A_EDX[25].


automatic-ibrs :
      The AMD Zen4 core supports a new feature called Automatic IBRS.
      It is a "set-and-forget" feature that means that, unlike e.g.,
      s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS mitigation
      resources automatically across CPL transitions.
      The presence of this feature is indicated via the CPUID function
      0x80000021_EAX[8].

The documention for the features are available in the links below.
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,
   Revision B1 Processors
b. AMD64 Architecture Programmer’s Manual Volumes 1–5 Publication No. Revision
   40332 4.05 Date October 2022

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0a6fb2fc82..d50ace84bf 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -806,7 +806,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "pfthreshold", "avic", NULL, "v-vmsave-vmload",
             "vgif", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
+            NULL, "vnmi", NULL, NULL,
             "svme-addr-chk", NULL, NULL, NULL,
         },
         .cpuid = { .eax = 0x8000000A, .reg = R_EDX, },
@@ -925,7 +925,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .feat_names = {
             "no-nested-data-bp", NULL, "lfence-always-serializing", NULL,
             NULL, NULL, "null-sel-clr-base", NULL,
-            NULL, NULL, NULL, NULL,
+            "auto-ibrs", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7cf811d8fe..f6575f1f01 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -773,6 +773,7 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_SVM_AVIC            (1U << 13)
 #define CPUID_SVM_V_VMSAVE_VMLOAD (1U << 15)
 #define CPUID_SVM_VGIF            (1U << 16)
+#define CPUID_SVM_VNMI            (1U << 25)
 #define CPUID_SVM_SVME_ADDR_CHK   (1U << 28)
 
 /* Support RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE */
@@ -946,6 +947,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
 /* Null Selector Clears Base */
 #define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE    (1U << 6)
+/* Automatic IBRS */
+#define CPUID_8000_0021_EAX_AUTO_IBRS   (1U << 8)
 
 #define CPUID_XSAVE_XSAVEOPT   (1U << 0)
 #define CPUID_XSAVE_XSAVEC     (1U << 1)
-- 
2.34.1

