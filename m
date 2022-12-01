Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E5663E7C6
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiLACWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiLACWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:22:03 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6897CA13F2;
        Wed, 30 Nov 2022 18:21:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmehReJQJl427qHVB6n/37Fh1zHSdbfHyiq+6LixS+OfBEU3GTYWVjODUtDcYirY4pkDOtUABxusX+bXcrPSMVod6znWovkBtYH4HwMleis2lFKpxrTgIHZR/8bSNSCxRd1yPwi0blg3RxP2uj4CRJsYRZys06sGlNzm0G9cUxJJr4SY6TOaEj7dIRuDjnAtnM3wHHZ+oK2qlRHXweuFOPGK73mKNf1/JlF+Em3ILQd8Og3LxOQcXu9+OUkdahYdoGpsnNVJ1oyva2O3JXOKjBCnFLeU86YksIDofXxHQ2EKtqbUjk32U+d9xi7zoE1vYsubW/0GcX4SgIquQATY6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvpsGEy0dTdwjyf//mnuhS0A9/wySxSByVe+FFVMqvQ=;
 b=adCmOhhT+8KDEYqt7lrXmbOHKhXx6jelWhXkfY25k+1wZSVa5SYs0/sHV8WMIzZNdF1ctaJwp+QFcOEYB4po2fzelgN0dJ/FhpC6uQy5r9Sg6YiP8hrQH7x1XSfUkVaTIT3Q8IKK2R3VNebx4443Wuy+QbwPVQcLyXK5Pns5dZSaiLsBDVsf3b26+hB661XgS3HoQvvq6T3b9pGuDLM0d3GRcQgWONxbbLr3nSRbxFmhIWq4WC2OqnhnimPTIo3ExJVXfJGcaFaOLYFKwerynpkTlGdFz/S0veDh5zW5+UAwUavQs1h4zYzF9sHHt02xfG3yaMCf9sAIZK8fPQPeNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvpsGEy0dTdwjyf//mnuhS0A9/wySxSByVe+FFVMqvQ=;
 b=UxoZqmALRXYuUsT9RIakRuH7i7iCkErdGA9leow22OqdB0R9N2gvDIrQkrkjzKfwtP4u6cGEOzslo+gLPFLUbmDnr0XrWJAf1NqHtIjs9QcRUjZ2NryUE62qoIA7vJeKKSrcwphRlLdZi8KbYbo3dzUbQszqMNqUJihZ0WKe1xA=
Received: from BN9P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::13)
 by DM6PR12MB4563.namprd12.prod.outlook.com (2603:10b6:5:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 02:21:19 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::49) by BN9P221CA0010.outlook.office365.com
 (2603:10b6:408:10a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Thu, 1 Dec 2022 02:21:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.22 via Frontend Transport; Thu, 1 Dec 2022 02:21:19 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 20:21:08 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH kernel 2/3] KVM: SEV: Enable DebugSwap
Date:   Thu, 1 Dec 2022 13:19:47 +1100
Message-ID: <20221201021948.9259-3-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221201021948.9259-1-aik@amd.com>
References: <20221201021948.9259-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT055:EE_|DM6PR12MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: 934911da-7f8b-42a5-bcc4-08dad342bb92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvMkPOgMT+iZdjrRbrdE5fdv8QKyVvWPO6G5+U9ZzS9R6PfwGmDpZpnaFRgRu7thaizuXp4n6UywoFboMphUjTEXrVlDrYEYzZq4/HOUOmmsmb+iiBu8kBHlo0xOKrv6O8d1WjuDovdmu16WAS3nmuTDxSChrdqlYzZB5qzX5E43q2CE1GevnyJSoREUB5VvCLZt714l4xTZyVjVkclUIvr1bbqTioLTz8H5E5S30xfepF1d+BXs59QNwKNk4euonesCdRJG7yqqcZzvvbEdpDPBcU4OXSGQFcPOC1vTk8YnEWWPtHq1ohGD1DMhlY0HhoAPlMkYPIAU6BuemWFUws3dEslebyUfgJo/lqGYj/Nr5QJk6CF/+R6RYJBuAct0C3jMKOt9M3rIhIb8/lsEPV2fwcFK2FkWPbIERPO4axWN3/y6+/vi4q9/G4r6xaNzR1O4W95cd8Ut3bn7M1ZrDjDIb0j5jJV91KsdauoDyQU3j+mhUm62aasOlowGTecj4V8cA64AqFZRHjUuOXhBKiqhqpz+8WtYwTsMTWIQ4gch4hSu9yWNp7WtIi4SOUgbAYRQzJfgTRRx2I6/e7jm9ksOhHrQw1yng1LwCTUcI7rN+6ufSebqZcJ8vBsgeAWDtS+3U345nBvs5HL6zkG19ahMauSNLJjrLb3dImCvyH2TrrFnHjJJLn8cxADxAYPVbtdMW3Y7Q4BPnGdZbvpqBUxOYACaGfTXHZi5yWtd9RM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199015)(40470700004)(46966006)(36840700001)(356005)(81166007)(40480700001)(7049001)(36756003)(40460700003)(6200100001)(478600001)(26005)(6666004)(7416002)(5660300002)(41300700001)(8936002)(4326008)(6862004)(54906003)(37006003)(2906002)(316002)(70586007)(70206006)(8676002)(36860700001)(82310400005)(82740400003)(336012)(16526019)(186003)(1076003)(2616005)(83380400001)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 02:21:19.4136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 934911da-7f8b-42a5-bcc4-08dad342bb92
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4563
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD Milan introduces support for the swapping, as type 'B',
of DR[0-3] and DR[0-3]_ADDR_MASK registers. It requires that
SEV_FEATURES[5] be set in the VMSA.

This requires the KVM to eliminate the intercept of #DB. However,
because of the infinite #DB loop DoS that a malicious guest can do,
it can only be eliminated based if CPUID Fn80000021_EAX[0]
(NoNestedDataBp) is set in the host/HV.

This eliminates #DB intercept, DR7 intercept for SEV-ES/SEV-SNP guest.
This saves DR[0-3] / DR[0-3]_ADDR_MASK in the host save area before VMRUN.
This sets SEV_FEATURES[5] in VMSA.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/svm.h     | 18 +++++++++++-----
 arch/x86/kvm/svm/sev.c     | 22 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c     |  6 ++++--
 4 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..373a0edda588 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -273,6 +273,7 @@ enum avic_ipi_failure_cause {
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
+#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 199a2ecef1ce..4d75b14bffab 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -83,6 +83,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool debug_swap;        /* SEV-ES Debug swap enabled */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -388,6 +389,7 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
 
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	if (!sev_es_guest(svm->vcpu.kvm)) {
@@ -407,20 +409,26 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
 	}
 
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	if (!sev->debug_swap) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
 
 	recalc_intercepts(svm);
 }
 
 static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
-	/* DR7 access must remain intercepted for an SEV-ES guest */
-	if (sev_es_guest(svm->vcpu.kvm)) {
+	/*
+	 * DR7 access must remain intercepted for an SEV-ES guest unless
+	 * the DebugSwap feature is set
+	 */
+	if (sev_es_guest(svm->vcpu.kvm) && !sev->debug_swap) {
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 	}
@@ -677,7 +685,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
+void sev_es_prepare_switch_to_guest(struct kvm_vcpu *vcpu, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index efaaef2b7ae1..fac8b48e3162 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -21,6 +21,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/debugreg.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -253,6 +254,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (asid < 0)
 		goto e_no_asid;
 	sev->asid = asid;
+	sev->debug_swap = sev->es_active && kvm_cpu_cap_get(KVM_X86_FEATURE_NO_NESTED_DATA_BP);
 
 	ret = sev_platform_init(&argp->error);
 	if (ret)
@@ -564,6 +566,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 
 	/* Check some debug related fields before encrypting the VMSA */
 	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
@@ -604,6 +607,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	if (sev->debug_swap)
+		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -3010,8 +3016,10 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 					    sev_enc_bit));
 }
 
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
+void sev_es_prepare_switch_to_guest(struct kvm_vcpu *vcpu, struct sev_es_save_area *hostsa)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+
 	/*
 	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
 	 * of which one step is to perform a VMLOAD.  KVM performs the
@@ -3027,6 +3035,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 
 	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
+
+	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
+	if (sev->debug_swap) {
+		hostsa->dr0 = native_get_debugreg(0);
+		hostsa->dr1 = native_get_debugreg(1);
+		hostsa->dr2 = native_get_debugreg(2);
+		hostsa->dr3 = native_get_debugreg(3);
+		hostsa->dr0_addr_mask = get_dr_addr_mask(0);
+		hostsa->dr1_addr_mask = get_dr_addr_mask(1);
+		hostsa->dr2_addr_mask = get_dr_addr_mask(2);
+		hostsa->dr3_addr_mask = get_dr_addr_mask(3);
+	}
 }
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce362e88a567..ee0e56521d26 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1173,6 +1173,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 	struct vmcb_control_area *control = &vmcb->control;
 	struct vmcb_save_area *save = &vmcb->save;
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 
 	svm_set_intercept(svm, INTERCEPT_CR0_READ);
 	svm_set_intercept(svm, INTERCEPT_CR3_READ);
@@ -1189,7 +1190,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	set_exception_intercept(svm, UD_VECTOR);
 	set_exception_intercept(svm, MC_VECTOR);
 	set_exception_intercept(svm, AC_VECTOR);
-	set_exception_intercept(svm, DB_VECTOR);
+	if (!sev->debug_swap)
+		set_exception_intercept(svm, DB_VECTOR);
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -1461,7 +1463,7 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		struct sev_es_save_area *hostsa;
 		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
 
-		sev_es_prepare_switch_to_guest(hostsa);
+		sev_es_prepare_switch_to_guest(vcpu, hostsa);
 	}
 
 	if (tsc_scaling)
-- 
2.38.1

