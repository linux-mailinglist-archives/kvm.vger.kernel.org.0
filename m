Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65EF51EAF2
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441978AbiEHCn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347221AbiEHCnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269B211145;
        Sat,  7 May 2022 19:39:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1tXejslU7ewOGmcL6YIZCoC4Sxarq7f8bAd9CXIe2naknnWfKh1J8xFrKiNruWppdMuHOBPBHxJCKFhPNe6wfA3ty/Dl1nKuPLTQMOEfyOYRQByOHL/qtf1A2lL12gGzC/Xj4QFLQcOrmQ6hvk5bfiuygOYDxm2VI+x/FQ7TxCrEUWWCRY16F3tyYw5zZo8/ZUp54luFeEeb2b64SU1b7HkXuQuAEgOzMO1Fb6km3ZGCNjwytX4V+R0jPipeVQE9bJNlNiwWcJORLOCBDhG0aMnkDEKZJ/wWp+DmOp3pqC5gCaI2Shp5PY3NiTADQIpN77cXAUOsWIBzuTp8g60lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nslZO8zuxUXS4JfZIHYRpugwo9xm0JXE/2yPFs/6Y1I=;
 b=QfvHupHu/24jX3+LW0mH4NLJ9nPT9/v4igvvaM7KqGplToXlqbMKBj5uK1kfoLyOrjraGAkthBBiJRV+Pd/5mr7A13NhwmzhJILN0eI0WePhiZ3zmSUQyRBFXroPGHTPw9M2P979MRm3uMoJc6FtiXJZghJ51IKQe5Ckst9FmPFHNl3BqWbQz50XvXxmTfRJhK6Jv974mrTIjLLfw5sT1NSyFRDgZH0y3L5q6dE30H8IHwpXF+wMJ9dKgUeW11Lw0DSjEy57lzu2dWxNbZCVD+1f677SGV3uQZePZovcGO5glYkChkiwiYr30ZbJqqipgRrEzWXv9cPRDHAiJFvntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nslZO8zuxUXS4JfZIHYRpugwo9xm0JXE/2yPFs/6Y1I=;
 b=4qEok5P4Bb55wTlAx7UZj+NkS9DbFcFBrgbmMreFfHssVuGC4a1cPln8IoFePy01thsHkaR1+48rbcekOcHAGqW2StDZ72dVyFuOtMEho6EGfKD3zF8ymHrvjUNiTzOQt6eGDHaqSYR8xBWeJuan3ghOif5AKC+vN8on4GQdcXQ=
Received: from MW4PR04CA0056.namprd04.prod.outlook.com (2603:10b6:303:6a::31)
 by CY4PR12MB1670.namprd12.prod.outlook.com (2603:10b6:910:4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sun, 8 May
 2022 02:39:51 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::6b) by MW4PR04CA0056.outlook.office365.com
 (2603:10b6:303:6a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Sun, 8 May 2022 02:39:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:51 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:48 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 03/15] KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
Date:   Sat, 7 May 2022 21:39:18 -0500
Message-ID: <20220508023930.12881-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82db76ba-c8c1-4995-1013-08da309c06ff
X-MS-TrafficTypeDiagnostic: CY4PR12MB1670:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1670E46576CCF50E45337CE3F3C79@CY4PR12MB1670.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aGcHyY3qtfnsroJOKAwMkNldRzsgbEIUCHoqMfHxq3Noogq5r+rEg/IUOPph6REvo8Y6g72qE0TZj4799BAuQFiU00FY2ev4Lc87uXCwqy68B+CUOq1B8VslZNMaam0gDXqOGiAyny2P6sKxGHqeRxxVhn7RGBIasLi6zOaoEwb5mE5n+PR0zyFH7nAySmfLbh2VfaLduBCX8J91xqT4wuItXjfOQ5ljAt0/M9TrmKfAWowvwpKKP/5q2+cHot3AbcBq06dawWYE/6ER9JG8x0GCrc2OUwByh5A16iocaz3+RRs8uAnVn6yqkLRdll1vN1aABgEo5FYGxGn7k99bgut/RCsnmnXM3wV2VdRGDJ1VGkKCFs7inIsBNRYdhPBTnxux8SsvtYcYA1lxmAxcrMUX1eRpHu6F3HdS20/mv0RFFAx1JGDl2K4QWj3sM7MbMZ1NjaZ+F14bQRmbtiXFyAA9BAFMrYL9vxQKYVr3PGZCk9FsNvTQIrhZIr8FFe2ZUgvup5jXUxXFPH6+Drh4q3PqB0SnNATgdzHxo0biCDjRxumLHs9JPzMpCbk34jcjpgWMqpplAD4UMChRqemCWf9uRN74Y8IypFTt04ba2WaEl3/aJUaTy7Pz+pRd8WAjwKJo2fiFWP5dPVgkioUG4B55ewOIsY8RIYyJcWQv1oZLKZUG0Iggp2scBVt8j90qpi1sETfhjtLypPhiB3UPoL9PeLZS0VwzZPSGXM2Ycx+4WyON4hAOVq80wrkPhhkThH1U2IHdIx+nZ+l0k6XT2w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(54906003)(1076003)(110136005)(26005)(47076005)(186003)(2616005)(44832011)(86362001)(4326008)(8676002)(83380400001)(70586007)(70206006)(40460700003)(16526019)(5660300002)(316002)(336012)(426003)(36860700001)(36756003)(8936002)(508600001)(81166007)(82310400005)(7696005)(2906002)(6666004)(356005)(71600200004)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:51.4882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82db76ba-c8c1-4995-1013-08da309c06ff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1670
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
 arch/x86/kvm/svm/avic.c    | 51 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     | 15 ++---------
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 57 insertions(+), 13 deletions(-)

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
index a8f514212b87..95006bbdf970 100644
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
@@ -1077,3 +1087,44 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
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

