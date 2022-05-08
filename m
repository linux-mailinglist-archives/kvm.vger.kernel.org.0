Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFD051EB02
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444546AbiEHCod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387816AbiEHCnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:51 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BFB11144;
        Sat,  7 May 2022 19:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZnN7XczXndfgLrBrVNauU7Hha6PE3UpQlJjjsm2Ld9CVlaH2g6erA0KvqgpbHHmodvQbRsDydVEsw0iZ2kiTFLToSxfmrUyeyPn1Fyknv4v1ca0P1iBgWZdmASWaztevyg8SRyPPdDAaWJ28hD2yHaebYhUnV7tA7siJRGxZKxay+L67dEk/cbYRWruFH0M5BBebm4WBDryCTgCjomnf9WTuYD8mPiNn4zqmSDHi4UjTd85vHt9Ogeif3rJS70Xh25q6byxN1QCo9Upzs5FjHVS5DUxvvjcb/mfqCZ6IaoWLdnIafK8Ts90vB7kJ9Kpl1pQDDRBUcUYRzPNmwNjXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2tJO/v8YJd3Pts91ftFHRQkhBbvMSAk58xRX/fZb4Y=;
 b=OE8WzU5TwOfAue5MgyfVzJ1m1PK8uatQMpv2ejYWEUod3dJRor8Q2529QYXBZDferXzwQt9rSYddoSZ1p3/s1cPL600EjhJLUDXuPui/kMdSmFBov5YGGI2OVqgstXX3UHPXCHWgIL5NFJB47xbweTyWhHkyMqPrSmeLYWDUSlKNmZjt4BDiXadkzozZ1ZfgHcLxcxGa6/iyH7TmA3MNR22GjuAOFhdn0k2aZYPnqO6g+IS1IdQb1blFza6OyzmMwY5EOWJgzUiQthwBkSDWYawYrOyMvzjrKSOgX0dl+mHY1lraBwS1HsgW6unY01xks5R7MitmXs+3igubX2cAMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2tJO/v8YJd3Pts91ftFHRQkhBbvMSAk58xRX/fZb4Y=;
 b=BNfwLdr0SlgyEHz0wN9uVRf1BmIu38oFZa8FXhuuyyQs9mSsqY8eYLngYXqNvZ9Da9A1vn3s2LGGtF3LpCzlEolDjnLu3BsXXCwOeWi13osfkewkzY0IZYFsPpW073pVyyxqfHCMBHAA7xFTt6r5eQWhlgXRz+CguSuxW56NiAM=
Received: from MW2PR2101CA0015.namprd21.prod.outlook.com (2603:10b6:302:1::28)
 by BN8PR12MB3282.namprd12.prod.outlook.com (2603:10b6:408:9e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sun, 8 May
 2022 02:39:57 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::aa) by MW2PR2101CA0015.outlook.office365.com
 (2603:10b6:302:1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.3 via Frontend
 Transport; Sun, 8 May 2022 02:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:56 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:53 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v4 10/15] KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
Date:   Sat, 7 May 2022 21:39:25 -0500
Message-ID: <20220508023930.12881-11-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 15eac29f-0a97-4c06-af56-08da309c0a26
X-MS-TrafficTypeDiagnostic: BN8PR12MB3282:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3282767EAD8DF19A4693B402F3C79@BN8PR12MB3282.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39BNuT+02WsR7wUex+Y25UQBjkTKRnBotj2Bt0yu85dz9lW3TR+d4FCJN4HsL4/ZlZSxjJHNiUH9PN+Xy/3ovRegdEdlst/tDg81iNgvEfRXVOoAfj5KDsUXU6LcxGRzjjoovKNpoXbsXs9ZnJXpMVCa2Q3cWkY/6v7+C5V2x1/7C77MIoMBPK705sDAC12fsGOXSMAPaKUe2PII6/g8LZJVkRkZR6vPQTod50ynxePInTcjP4haOzyTOcRIi6GSpFIqpxxUrpxRaGIkUoeS52PtsX//lBnUJyI01a1LX0IF8uOqzzIt5l/IwLOioIrTOSVki97pPjOSfM60hrqO9OEVnG7TAjWplzGL8Rnly4XBpI+lmCafRpgSEddMB33owaZYuCaUOHk8Ys8i+eZiXjWqwDanW1fXTDrW4ADtfkuhCScUva9TSDTScw9vYWzl22F1qdIRWxARc5SYGh5nourWQpWwTz7UF8QCCiuMe20c8ixDZfxS9k+Vnlojm+D25v0T8M7PUmtu93ZS1iWViDj3Hmh68cUIkqFK4oJYFqg2aRBG7yFckCi6mlKW0iYlQgpsHBbrXdCWmMRFu+v72EF4xLgFWu4QC2I4tAcC0pcms6UHEeNhj4BceOkzno6XLiOc1nApmEZYIiEfvBjjnmFSnOsahXjxZUWyPn9z6qLjOC8Pm/Th6HzLUIKbggzxp1bh4uFcy4DWdx19j+xNuQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(5660300002)(82310400005)(44832011)(356005)(81166007)(2906002)(26005)(110136005)(54906003)(316002)(2616005)(1076003)(508600001)(6666004)(7696005)(70586007)(70206006)(36860700001)(8676002)(4326008)(47076005)(186003)(336012)(426003)(16526019)(40460700003)(83380400001)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:56.7654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15eac29f-0a97-4c06-af56-08da309c0a26
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3282
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the current logic for (de)activate AVIC into helper functions,
and also add logic for (de)activate x2AVIC. The helper function are used
when initializing AVIC and switching from AVIC to x2AVIC mode
(handled by svm_refresh_spicv_exec_ctrl()).

When an AVIC-enabled guest switches from APIC to x2APIC mode during
runtime, the SVM driver needs to perform the following steps:

1. Set the x2APIC mode bit for AVIC in VMCB along with the maximum
APIC ID support for each mode accodingly.

2. Disable x2APIC MSRs interception in order to allow the hardware
to virtualize x2APIC MSRs accesses.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  6 +++++
 arch/x86/kvm/svm/avic.c    | 54 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c     |  6 ++---
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 4c26b0d47d76..f5525c0e03f7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -256,6 +256,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID
@@ -500,4 +501,9 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
 
+struct svm_direct_access_msrs {
+	u32 index;   /* Index of the MSR */
+	bool always; /* True if intercept is initially cleared */
+};
+
 #endif
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a82981722018..ad2ef6c00559 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -69,6 +69,51 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
+{
+	int i;
+
+	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
+		int index = direct_access_msrs[i].index;
+
+		if ((index < APIC_BASE_MSR) ||
+		    (index > APIC_BASE_MSR + 0xff))
+			continue;
+		set_msr_interception(&svm->vcpu, svm->msrpm, index,
+				     !disable, !disable);
+	}
+}
+
+static void avic_activate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+
+	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
+		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
+		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		/* Disabling MSR intercept for x2APIC registers */
+		avic_set_x2apic_msr_interception(svm, false);
+	} else {
+		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		/* Enabling MSR intercept for x2APIC registers */
+		avic_set_x2apic_msr_interception(svm, true);
+	}
+}
+
+static void avic_deactivate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+
+	/* Enabling MSR intercept for x2APIC registers */
+	avic_set_x2apic_msr_interception(svm, true);
+}
 
 /* Note:
  * This function is called from IOMMU driver to notify
@@ -185,13 +230,12 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+		avic_activate_vmcb(svm);
 	else
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+		avic_deactivate_vmcb(svm);
 }
 
 static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
@@ -1082,9 +1126,9 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		 * accordingly before re-activating.
 		 */
 		avic_apicv_post_state_restore(vcpu);
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+		avic_activate_vmcb(svm);
 	} else {
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+		avic_deactivate_vmcb(svm);
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9066568fd19d..96a1fc1a1d1b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -74,10 +74,8 @@ static uint64_t osvw_len = 4, osvw_status;
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
-static const struct svm_direct_access_msrs {
-	u32 index;   /* Index of the MSR */
-	bool always; /* True if intercept is initially cleared */
-} direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
+const struct svm_direct_access_msrs
+direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
 	{ .index = MSR_STAR,				.always = true  },
 	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
 	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5ed958863b81..bb5bf70de3b2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -600,6 +600,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
+extern const struct svm_direct_access_msrs direct_access_msrs[];
 
 /* avic.c */
 
-- 
2.25.1

