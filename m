Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0897351984C
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345501AbiEDHfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345271AbiEDHfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:31 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2054.outbound.protection.outlook.com [40.107.100.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2383E167DC;
        Wed,  4 May 2022 00:31:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOB2r2O5CnqCsrtnBd/GYVFKiit0rkCq/atTQYEeng6x0oEZV1o5iZU5NwtSj/ve7zlaQA8uRWOjtN9q6AkK+jQZLaaSAxX7dr+KFc2YzoFPhsyYKPACLHexu1qqhJBJR8RzVqc6fVr+pEtL1MajQBCOdje+JyKMECeyV0pOlmmDrsfI5EPUOK4v9I5ILAkMysIdif/HjiP0bK48rZKMOj3ajiNsRTKZ4qkxrpLmdoSxaO7D4mAk+3RFw+Xz2D1xFbDkgBGMh9H6RQdkokDmztkESHsGTbZ4HViHM6UOasXJHon4q10RLk4sI1A70imB6W+eKZ66qP7Hw+ajYjHgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VV3Z5LtFVKWONo8RBpJqojzZpm2/QHjyX/ZscgGf0tc=;
 b=KFNunjSNWSuwQblvpzQm6fTX3TVW4eAy9naVbKeMurJFSaBWb6iJp6MogC8Zp/cdQzqRnnyTb/15RfnVDjEDkNV6MaImCGEve2t4azl+5A/NrNeXSZ2hSpT/oPrUaISt89FwGDEfFitQok8ENRsGyT4s1A5QG9UW0P0wGloPnmwDtrDMYWya4veGrt2LhWA4IxCJJghqii5mcvRTqDH01Apftwevju4J4wQy9UaDGRZfqR9xM4gC2g+wXBQjlHM0yqf3iWIT1Gj60GrCFevM13FnwV1Qeezv9l1BJutj8x9qEOggbdZk2M7eXKVn5ZJqA4eVXdDP5NruwsFtrmbVqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV3Z5LtFVKWONo8RBpJqojzZpm2/QHjyX/ZscgGf0tc=;
 b=Ke4TR5TrQ3/xOaz1doc2mOv3SZutgMfCeoSOL9UVNAv54xAMt3XcFPNAWRFf7RAM5xQe0u1itHgRF6Cu7Y0SkgsZLLD7us1OIQ40IVLcjMpDw06UQz8MRe4YqjfuXH8GjwPWjDUnzeseUXQ8cyDxuwayDgFS128HybBOxDoPpAM=
Received: from BN0PR07CA0004.namprd07.prod.outlook.com (2603:10b6:408:141::22)
 by SN6PR12MB4767.namprd12.prod.outlook.com (2603:10b6:805:e5::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:31:53 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::30) by BN0PR07CA0004.outlook.office365.com
 (2603:10b6:408:141::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Wed, 4 May 2022 07:31:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:31:52 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:50 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 03/14] KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
Date:   Wed, 4 May 2022 02:31:17 -0500
Message-ID: <20220504073128.12031-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54bd0db4-07ab-4a5a-f1b0-08da2da028a9
X-MS-TrafficTypeDiagnostic: SN6PR12MB4767:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB4767B5D59930813E49E82CC9F3C39@SN6PR12MB4767.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wEYneZGOPRztG8gQ32L08UWSumOZbYSDxPSM3Kbk5DMtJ7AKAUs8GscjV9ujkJtNG/LGpjHATcsP51jGiNe/L9I51ar756NQfo2iyrPP7/mV0CKLCgJG1/cHoxtvbn0q0VtJaeS+ZwVFMRMZhOf+p3mxfj7M/oh/PcGf4euklSQuAgoZsYDT9a9bqBj+xMEGMsRbOGuKDmxRop5Pf6P1pEoaQQqTZAYATqYo7PWik7J9y+Y8418GJYcHsYqcNH4Sy/5Sg9/5sVohKQ3lBRleNaXndTruMpgI2iBbpJ/9HnRdWTZCgBjCAQR8ACyGMMYySPXx5/2VEjGxVNM7POAllWxghGjU8di7ZG8NTuM2APRRSLLi9/o0TJ3JIGAl2all6FuHUyq1OpcgLJBZjutXaw1uB6xfieu9z2rjPN7e/6NV9FkLcaEAJp12jsJc347FmG+5vPDS/BAk4Es9R7mlVYm7L/QQSa5FNWoe42GQKSmNtOqbEJ7gFJSDB0qKHI+/AXpwBBljIR5t/ejxf1kpjQv0n7qCPcCOjSTazGts4/XgyGMW2GBDm1vu20UaXN+JJOIyacDSH9ZrH8KUqts0tccYiR5Z+vxH1a4BRSPIEsucqpJG/o6PCkDn6dKcYHXFKLtMntqt4ife6y6jCyO8R8txWAfUQ9EPEACG65y6bQtRmNtExOTpeoz0lrqrLngHOCagekS0+XHzE2coVB0jOG/R8ihNsTIliFByAQe2bx/HOtV0DxSrlrpEWlHlm8Cw
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70206006)(47076005)(336012)(4326008)(426003)(40460700003)(81166007)(70586007)(83380400001)(8676002)(36860700001)(110136005)(54906003)(2616005)(16526019)(1076003)(186003)(316002)(82310400005)(86362001)(2906002)(26005)(36756003)(6666004)(356005)(44832011)(5660300002)(7696005)(8936002)(508600001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:31:52.5808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54bd0db4-07ab-4a5a-f1b0-08da2da028a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4767
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CPUID check for the x2APIC virtualization (x2AVIC) feature.
If available, the SVM driver can support both AVIC and x2AVIC modes
when load the kvm_amd driver with avic=1. The operating mode will be
determined at runtime depending on the guest APIC mode.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  3 +++
 arch/x86/kvm/svm/avic.c    | 40 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     | 15 ++------------
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f70a5108d464..2c2a104b777e 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -195,6 +195,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
+#define X2APIC_MODE_SHIFT 30
+#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
+
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a8f514212b87..fc3ba6071482 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -40,6 +40,15 @@
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+enum avic_modes {
+	AVIC_MODE_NONE = 0,
+	AVIC_MODE_X1,
+	AVIC_MODE_X2,
+};
+
+static bool force_avic;
+module_param_unsafe(force_avic, bool, 0444);
+
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -50,6 +59,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
+static enum avic_modes avic_mode;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -1077,3 +1087,33 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 	avic_vcpu_load(vcpu);
 }
+
+/*
+ * Note:
+ * - The module param avic enable both xAPIC and x2APIC mode.
+ * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
+ * - The mode can be switched at run-time.
+ */
+bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	if (!npt_enabled)
+		return false;
+
+	if (boot_cpu_has(X86_FEATURE_AVIC)) {
+		avic_mode = AVIC_MODE_X1;
+		pr_info("AVIC enabled\n");
+	} else if (force_avic) {
+		pr_warn("AVIC is not supported in CPUID but force enabled");
+		pr_warn("Your system might crash and burn");
+	}
+
+	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
+		avic_mode = AVIC_MODE_X2;
+		pr_info("x2AVIC enabled\n");
+	}
+
+	if (avic_mode != AVIC_MODE_NONE)
+		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+
+	return !!avic_mode;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3b49337998ec..74e6f86f5dc3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -188,9 +188,6 @@ module_param(tsc_scaling, int, 0444);
 static bool avic;
 module_param(avic, bool, 0444);
 
-static bool force_avic;
-module_param_unsafe(force_avic, bool, 0444);
-
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -4913,17 +4910,9 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
+	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
 
-	if (enable_apicv) {
-		if (!boot_cpu_has(X86_FEATURE_AVIC)) {
-			pr_warn("AVIC is not supported in CPUID but force enabled");
-			pr_warn("Your system might crash and burn");
-		} else
-			pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	} else {
+	if (!enable_apicv) {
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 32220a1b0ea2..678fc7757fe4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -603,6 +603,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1

