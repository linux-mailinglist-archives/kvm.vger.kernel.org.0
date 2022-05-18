Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB5752C012
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240155AbiERQ1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240207AbiERQ1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3961CA30B5;
        Wed, 18 May 2022 09:27:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3k2h7Jc4YwH+kEmaROSeDR6huxB/kbRvY4m6zG+uNySwtxbVJZ5TmZHBdB55ufvi0XfO6MYKSSuijjL6YqdDm9JBR3ftLyjaIl6Zqo7jvex5tqOQNIgM7xwceakyZA5jfkJ7nC3JbEE4IdsQAkdVIadS+cNFhPPmOteKnG9yy3h69BtnIWGnvfOCfb+dKEN1OVHYz2pJsXU4Tw+GRE9sOHWVhMTEHO4efgV2l5o9HbhJFzX9cl0lOgKCbmDlz3OE8JMTI+VwqokZs0qdmubViA8ydFMn7cTwiY3E8YHAotddBAfbt8+PZSFTUZtzRXTrxkl43icN0cUoobg/o1u5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZN1UbDmTA4y0AHhJlVrJtsx9BgY/0V7F+KEDD0hWG0=;
 b=fMF3m64TnJYHdAgBcs33XhWIWIArC6OxCadPN7nhQWxUAO/7B7fkMtaOu7zZ8eLdSNYA7jCTfyHk3hPqfjqbP311ZdvTieYR21smk/O5ndlidrVulZDe15RDSNcYOxwUP1et4+7JAj5xShal8TwuA2K96UcL4keH0S2rSE6eQAzhdzW309WyhadFqrsZu/eYF3aJWfGqdg+fLtx6BvKhql6gRA0Pqr3AP7VIAEajgRz209gk6+dtdO7PB8RdO4FaOilcXxu79ltwrXQ+5Fqu8fqDW6WhxXF4NKORtJAm4K8FHIhydS2sBZZJQy2F79KGU+3DvwcJWUhvqg5BY8rDMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZN1UbDmTA4y0AHhJlVrJtsx9BgY/0V7F+KEDD0hWG0=;
 b=mDJXXvhXTUknprk11Mt1GeeDQNNl9gCQOKYSEIttM+noonHthIDtumhFoWUsNyTBhS34uGaBdGRxS/mz/elTQmY5mDyT3bLThlq+YQ7Z6/wwUxBMO0VlnheOcVqdiGMZl582kK+e1dInFgExF06yCsy4PRBrK6V5d9WsmwRPRZA=
Received: from BN7PR02CA0029.namprd02.prod.outlook.com (2603:10b6:408:20::42)
 by LV2PR12MB5872.namprd12.prod.outlook.com (2603:10b6:408:173::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 16:27:17 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::cd) by BN7PR02CA0029.outlook.office365.com
 (2603:10b6:408:20::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:16 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:13 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v5 10/17] KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
Date:   Wed, 18 May 2022 11:26:45 -0500
Message-ID: <20220518162652.100493-11-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40d09535-c243-48f5-59bc-08da38eb4604
X-MS-TrafficTypeDiagnostic: LV2PR12MB5872:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB587240A36DAC91CBE7341685F3D19@LV2PR12MB5872.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZ3gphGdXbocHY3CrnYtXoZuMvcxVznbplTLFWv1ZLL9PNXC3Ik4QEQIObfDMt0JtaKh2fw3hKACqHALPdO+NDpBOQTomCbTl1ZHfpy/8kxGis4gQgsXfBJ45EUQTc3IPgOFZx/H5B6X8RVXxr3Pk/MtVgZIc2fGMtkTuhqjnxGYwqOQRp+/F6QEbNakEtolFMmGyUMK2JftzxYw6NF8Z/lIbHNHCGwckRtDTze2gzjUSey0I33m9usBZxyxf5Hry57rNIKKckGdvYEYFY06mt2UUJPn+vnQRKkfzVku+2WSceSgdgnqjxe6tAp/zzo81V2WSYzJ8YuqPPwWLGOnmhWtp2frXxA2d8fsudNBzZvf0dhtnQYYHpHztpoGkq/BLSM8HZlEj1yynT1ERrvKfoIByq666yRM921in9E85U950oIA+meGXvc5JhVyFAdYQwRSFMnQWz1y1oAoXDtR3e2m9Mq0DG45tZPD8B3u02QzZe3HdLLrLNAD6DPR78jP3EPUNlakt9iTQwMKIzv0UrrSQQpKcMAeOA++Rs6DAN7PXJRMYFidd5UokUsK1eVsOuNadG9pimqs7EOi7MfbPf+DTji9zlw29TRyHiGBXvpRAT/iccPu6xsRIFfVkuVA6SSZmIEUN3MaIsNRcF5uwTDZ0wq8XPRy6QkBYlhhSaBrgSdJWFRRRHctlVtXawCVXJ0ebdj9NyyhOsGF3xaS6g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(82310400005)(110136005)(47076005)(36756003)(26005)(54906003)(36860700001)(4326008)(186003)(336012)(1076003)(2616005)(16526019)(8676002)(81166007)(70586007)(40460700003)(426003)(86362001)(356005)(8936002)(7696005)(6666004)(5660300002)(44832011)(2906002)(316002)(70206006)(83380400001)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:16.8725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d09535-c243-48f5-59bc-08da38eb4604
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5872
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
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/avic.c    | 39 +++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c     | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 4c26b0d47d76..13d315b4eaba 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -256,6 +256,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index aa88cef3d41f..d40170082716 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -63,6 +63,36 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
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
+		svm_set_x2apic_msr_interception(svm, false);
+	} else {
+		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		/* Enabling MSR intercept for x2APIC registers */
+		svm_set_x2apic_msr_interception(svm, true);
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
+	svm_set_x2apic_msr_interception(svm, true);
+}
 
 /* Note:
  * This function is called from IOMMU driver to notify
@@ -179,13 +209,12 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
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
@@ -1076,9 +1105,9 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
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
index 31b669f3f3de..0ec2444c342d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -746,6 +746,24 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 	}
 }
 
+void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
+{
+	int i;
+
+	if (avic_mode != AVIC_MODE_X2 ||
+	    !apic_x2apic_mode(svm->vcpu.arch.apic))
+		return;
+
+	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
+		int index = direct_access_msrs[i].index;
+
+		if ((index < APIC_BASE_MSR) ||
+		    (index > APIC_BASE_MSR + 0xff))
+			continue;
+		set_msr_interception(&svm->vcpu, svm->msrpm, index,
+				     !intercept, !intercept);
+	}
+}
 
 void svm_vcpu_free_msrpm(u32 *msrpm)
 {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 16f1d117c98b..818817b11f53 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -542,6 +542,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 			  int read, int write);
+void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
 
-- 
2.25.1

