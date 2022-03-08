Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1207D4D1D75
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348453AbiCHQks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348435AbiCHQko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:44 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2809D4BFDD;
        Tue,  8 Mar 2022 08:39:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrWYb4LaWW/iM7iGV96nYTePj6Vh5u02N0XcIe3QUdrALxACq7+4lQvdLRMKE3x8Y8KKRvEH0qoWcFVhPv/15gySACcK5faAp3RPPoJAQyBTiuQN6/7f9pMfEJ1LFzAKNff60HLZ69m4z9/RFe3yUGFDAOPuVdrUpXXjckPZTX8mzH4hj+dV73EBfuhTL1MKinVZQGMnQZ9nkNBwEiYwKcjPDV/GjpN5NQNInh7zlM+tOYvXsEi10e1cb75ZKU8+ID14H72ijWF5H80tp7WsFXm10VB0UGk8O2wO/nK0q66Iqjrw5qCm+OMXVK3z44dufBCK9kbuhXLR9aPJV8Rv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vmu42+8Bz+fLtHQ6E0t8A6luRIMdpYlYPVaJj9vEAr0=;
 b=FlayAwEzs9q+11th6JR7TfvLmJ5aATwyvcGn/wOXTRWX4Qz//mc/BryDbFX+OV90SoStkqgnBVCvFO5fgrDEWtdOijMHEUNTDs3BEdLLfoU6kFWPYmi7k2mJI15ETLY8OPN2nxO1uIi/XJaWczq7mKFbCzbUhlibOTfFC5mxhWMoL8WfD67f4ALRrDLR4PNABkd2DeKPuoRn1IG3drxLefBhYFVVK6MU8xCj1N7XlTD254zKHtTyvSMZ2NAT67EYWrQpBhX3Y5OKKNA1vvovrC+b35YfLhAQu0DW72ThPZPdFA5r+f9nc4ExL03mWwcIsOnbZCeDKh8wFobqXLwi8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vmu42+8Bz+fLtHQ6E0t8A6luRIMdpYlYPVaJj9vEAr0=;
 b=Y0jjvaCxL5+02DC6o0nrCCTaegqb+0p0j4DpFi7skPxnPkyU9ZsHb51PjOKC61o2xq4eQ0D92NTcTBhtDvok14ZvyVmd2vxZ8zKZD+jDrxhJPiEY/H9eoId3duLcKldXHyhBZpi2nKQXCCMmZSVE2krW0rwnZdmpCBkAmCrewIM=
Received: from BN9PR03CA0318.namprd03.prod.outlook.com (2603:10b6:408:112::23)
 by CY4PR12MB1160.namprd12.prod.outlook.com (2603:10b6:903:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 16:39:45 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::47) by BN9PR03CA0318.outlook.office365.com
 (2603:10b6:408:112::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:45 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:42 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 03/12] KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
Date:   Tue, 8 Mar 2022 10:39:17 -0600
Message-ID: <20220308163926.563994-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65184c10-6af8-4940-c186-08da012240db
X-MS-TrafficTypeDiagnostic: CY4PR12MB1160:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1160FA97B4D812FEF026C741F3099@CY4PR12MB1160.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hsdzlS2sPg82drJGMnpL6H+G/+6CxqvVexSVk72uWUUQDY6coON8e8JVzLJKZxb8Ofd5ZPd9kkHaI+sIKB1VdLcy6WvJENI+dhT6T5bFxcyVJt8wHxCNHfUdYc1clgRWbeB2itaJc6BeyoiVKFWvA/7OdC0QEYvKSdu4ueBP1xhZ5mgaaUuTYzR9Rqg7wEZ/z6V+rRnJCt8SqxIFRWGEgbjSlncs0ABSVj+CRkB7GmqE7Lntvcyl8QEeoPBEwKgn01TIutrUciJg8rfKQq4PZqcMEceQ4NEayWmy6YrRIPjJiPOhSI2SUxSIfxZ8yCFZNpyK4tiqmVIfS5zp4rQ+9PoFC/Q/3Hc727xdMfZ6+shJhUKLU01PxQs9hhNorWhErNnhyYvvuBWoNA5jY17NSz6Z9IdsraVaGKCrHN9nwmHgi0K3eVE/UJvtOaBAdLQZ2sfiW7zBfCJ4rK/7Ril6VkTpB5UcQh8HNfUL4JvFfWoPIFaKV+z0MjGnbtPQb6kqnAkGlhK0Cbu1l21YjULAe1ZMoFRXuzQk1hd+Z3wqR8akjkDBXaPrYDzk1NDjSZhdll0E3hfpkHaTmefrYE8KXF9FH53GCMIubKRe2lXzOMKVaeEzeXYiPzQCFXVthezE463ftnfUICqAh8rYLAaPb0i572peJbIfruEMC27/ZcN6TbZ8idvqVCszszAA2KbwP6vmO0tf1d/JY7ZRgS3d102NVmD9k2gpQamCEQTcEkO8mrjVdAYNiN865q1tyjrK
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(86362001)(2906002)(508600001)(40460700003)(2616005)(1076003)(16526019)(426003)(6666004)(7696005)(47076005)(83380400001)(336012)(26005)(4326008)(5660300002)(186003)(44832011)(81166007)(70586007)(8676002)(70206006)(54906003)(110136005)(36860700001)(356005)(316002)(8936002)(82310400004)(36756003)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:45.4381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65184c10-6af8-4940-c186-08da012240db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1160
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

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  3 +++
 arch/x86/kvm/svm/avic.c    | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  8 ++------
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 7eb2df5417fb..7a7a2297165b 100644
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
index 60cd346acd1c..49b185f0d42e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -40,6 +40,12 @@
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+enum avic_modes {
+	AVIC_MODE_NONE = 0,
+	AVIC_MODE_X1,
+	AVIC_MODE_X2,
+};
+
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -50,6 +56,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
+static enum avic_modes avic_mode;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -1014,3 +1021,30 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 	put_cpu();
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
index 821edf664e7a..3048f4b758d6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4817,13 +4817,9 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
+	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
 
-	if (enable_apicv) {
-		pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	} else {
+	if (!enable_apicv) {
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fa98d6844728..b53c83a44ec2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -558,6 +558,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1

