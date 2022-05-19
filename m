Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7194052D082
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiESK1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbiESK1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C58A7E17;
        Thu, 19 May 2022 03:27:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSV3TPEB9dAP39mHHNXXfrRdPbKnEjHGLSM4CFtDp5rsNYzPJCYoi2TWqJOnOdKSJtKlOhepAyFALS1DLfopqjuMx2G0b13TlbKlhPo8raBHtRGglkfq6LxemAzb1PgekPsGLo1ZgGF/RFYksih1rLLkmmM0kTu89KRWFtQdBKdUR3ZU/tQNr//GVK4oJGSCUU3ke8BCVnIOnSnGGn5rFzEF7Rk6JpQRH1DulL+fYHNZ8W3k4fi9cOt54q5npny4KUTx2XgolfQw8qiEcitnF5j3IwRGaPrHaRiMv+Hcj++D0C3M4vIuTXlCnKL6mwtfvlvN/2xhdIYVDf0qmV+ptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXbUDqjRmzsRStQJiczH5Ed8Uo0mFMfsNCIw/RPMjfQ=;
 b=NVhs9BBwC9w07+kiDeIXiCneq911CifZauYyZa6r8y+PXYiwaFWkuTdLSetyAKj3LcRjXwOYEzykFRfRM0qZkeujcexxQSysyiGUTvq9wQjONQsOVjinGHvpMbwVXdBis5ZmRcfuubQMukH8t+MDwC8e7XG8jMBmZKEY5D8etDQuAkWNGXuR0Rzpq96U5TLCrp8Uo/ljoUpxVdtyc1mSTmddZzljNwG0SDaaDpwP/o4DbCjZOvEFnVptX3L193yUVX60lkf1l0L8f+22Z2AQF6SOWm0+F3QhASa3CJAt+p4B+ofhtpdIcBPt/Vn4XyQjG8e68KJI5iTHvPiJlv6wGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXbUDqjRmzsRStQJiczH5Ed8Uo0mFMfsNCIw/RPMjfQ=;
 b=zTrQz9qV0saF8vOqMT4jLd/iqAiaJY1m1PCuKHjlF2t1U44WzJ9giOisu6JeLFhepCcGosrJGrmU9WgM38IQLbtB6pGhxyQTDFGORa6D2E0uYJzgEOeEXwvzf5s/fNzQ2VDIcPCZA3hp6LJuPlHozHu0zt7jNrtpS57Uc17mtfw=
Received: from DM6PR02CA0117.namprd02.prod.outlook.com (2603:10b6:5:1b4::19)
 by BN8PR12MB4770.namprd12.prod.outlook.com (2603:10b6:408:a1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 10:27:30 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::4f) by DM6PR02CA0117.outlook.office365.com
 (2603:10b6:5:1b4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Thu, 19 May 2022 10:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:29 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:28 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v6 03/17] KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
Date:   Thu, 19 May 2022 05:26:55 -0500
Message-ID: <20220519102709.24125-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc4628f4-62ee-4374-277d-08da39822d75
X-MS-TrafficTypeDiagnostic: BN8PR12MB4770:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB477005E8179BD910C8BDDED8F3D09@BN8PR12MB4770.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OfNGAAl//tOmX/kRLa/TLEU3f6eOLoL/+716D06AK7TCd0qTk3B7Y3KoNu9/2Qmz3OHnUzOVJTlRo4gixeP4BUjyyjyJ6+Eo9TLeEJH/jUVFeTKObmjfEmUUgghF0YXuygtA4Lv2nbH4Udwfga7yhkpW2g53Z8NFihxGK7M3VNE6CfI9QgrpHcYqreSah5BVcyYNLp9ul5jwnkhdW3tFljX9oIF3sQO3YnyICc+mj0oOoyoRgf2rKVrtI0rkUPBv57WCk6T3Mzc4aPZQRihIQ7P1BsEeRehcpxN7aaVj9sXWAamnuVzZ6ZAgcCAzGcXpfLDh1ZxWWG3HLYFGyHh6UGqVOWm3ewq9C2Dx9GphbD8Ipboe6RZ0hf+rTmkkLgdTFydyqd6PRe83sMCLdxSKYUdBDxBcOVzsL/FkjgS9qVMSzkKg3sUhWcpQpOrXj6GDVLIlVxKeYFzpR2F+Gm8ZhWCw1p25ZdK7E5lkt9tRH339u3Q6jBSXuk9eX4kTVdJAflNWSzojsEQMTVNmtA2JOIRFcNxkpypNysQe4/WlvcG4kfAoY+oKWGf5BybEju8+gsnE34ItwOByUcG9sZvvDchGaz/qTpgJ7k3qvC7jNvr5VxbEbp0TSptz9B1/ZpLpvFqC6uo2Iz6JUVNGnbVIESCq/NvtAYaGHZRGnOfReI7RZi5Uj2c/D2XjwLKc9eMOuAV7j6fYLU+E1kn3YZEhO+rFYbN5CDOOdrtiOW23HClPuDk3l1nj3wrovWl6P7NhRY8o+zaBZ65knB7KRp9v/Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(83380400001)(47076005)(426003)(336012)(16526019)(26005)(81166007)(7696005)(2616005)(186003)(1076003)(316002)(8676002)(4326008)(356005)(40460700003)(86362001)(70206006)(70586007)(36860700001)(82310400005)(8936002)(36756003)(6666004)(2906002)(110136005)(5660300002)(508600001)(44832011)(54906003)(71600200004)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:29.6437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4628f4-62ee-4374-277d-08da39822d75
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4770
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
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  3 +++
 arch/x86/kvm/svm/avic.c    | 45 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     | 15 ++-----------
 arch/x86/kvm/svm/svm.h     |  9 ++++++++
 4 files changed, 59 insertions(+), 13 deletions(-)

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
index a8f514212b87..7d4e73e95acd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -40,6 +40,9 @@
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+static bool force_avic;
+module_param_unsafe(force_avic, bool, 0444);
+
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -50,6 +53,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
+enum avic_modes avic_mode;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -1077,3 +1081,44 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
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
+		/*
+		 * Some older systems does not advertise AVIC support.
+		 * See Revision Guide for specific AMD processor for more detail.
+		 */
+		avic_mode = AVIC_MODE_X1;
+		pr_warn("AVIC is not supported in CPUID but force enabled");
+		pr_warn("Your system might crash and burn");
+	}
+
+	/* AVIC is a prerequisite for x2AVIC. */
+	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
+		if (avic_mode == AVIC_MODE_X1) {
+			avic_mode = AVIC_MODE_X2;
+			pr_info("x2AVIC enabled\n");
+		} else {
+			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
+			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
+		}
+	}
+
+	if (avic_mode != AVIC_MODE_NONE)
+		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+
+	return !!avic_mode;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aa7b387e0b7c..196bca5751a1 100644
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
index 32220a1b0ea2..1731c1f3884b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -36,6 +36,14 @@ extern bool npt_enabled;
 extern int vgif;
 extern bool intercept_smi;
 
+enum avic_modes {
+	AVIC_MODE_NONE = 0,
+	AVIC_MODE_X1,
+	AVIC_MODE_X2,
+};
+
+extern enum avic_modes avic_mode;
+
 /*
  * Clean bits in VMCB.
  * VMCB_ALL_CLEAN_MASK might also need to
@@ -603,6 +611,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1

