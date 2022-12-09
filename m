Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2921E647CFB
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLIEkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLIEkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:40:00 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2069.outbound.protection.outlook.com [40.107.96.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EF37A1BB;
        Thu,  8 Dec 2022 20:39:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVY/V7EBH1SHPc9GEAKlrfSwgyAirxkgBBuk3FFPs0M0Jbu0d9oIW44iQK+myqrWFA+va21d8E/EY+fdXmKvvDFOtoNUjzijvkUpFy30XVkwkzrHIE3qk2Mn9F7DkOmFyj5Ms05Q9LOnS+YoNppNdN66Gf6saf08RRArtXNv0zbFYWrgN7Zkce9Bj0mT7FMmikcUDHr3/fX+rqdiq9DqshQQXPylettdR87N46HOOf+/eJZFf0ZOpdMheR67t9Ra0ImEASxK2SpQho1o0/AqWbkbBhrIst+lueos8IqGEUXqUK9p/aZCfbpHiBODzrnT4g5omwbm3LU4IFXuaDtG2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEQ+6r6Kk8+SwbfQeky9oC/lrDkQI/M648HR3xj4u/c=;
 b=hLNtSpak1Aa5Cxldkn77Wb2Bjot8Q4yY6crV9e3JlPlxerVHFFnzwAeoM3IFSvCsYV0VI8n72xIpEkvmzqwXF6xHE6ooVIFWDKf/Mv4QiqNV1+VszffKnDuWvt6tXG/oPd8Tf/7DVcRfhYcXMzWqUC3hbUFkbAGeDTMHA7HP6dxJPRdbMrLTrohWB6W6WSs/uXERUi0YkkaUYIDdTgjfEXqN1a5KIFJSbtIA1KvybU3qNCI9FC8tna9CCVm4UEfFusmqqDzJ8G2tDmuOWCcYQsoWHRa79Lb6NvfLXf4pq7A0WEdxpeY/n0UwhW4J31apBK/D6946/Tl7wGcw/fJBNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEQ+6r6Kk8+SwbfQeky9oC/lrDkQI/M648HR3xj4u/c=;
 b=ukZDbNJ8f/T7s+oowuL+Cw+Tto1Yte/LuLHxtbVQe+hVwbkUn9ch4DwS1Y6cSCcfqZGfhdZx7NQuWNW3pAYfaEHaArFX9ZvvXJoRG+7xbWt3yY9RU06Lcml5UEDdlCQmdVIRVvEuEsQDAXt4/rZImPZAOc7Dk206dp2Uo88/w7Y=
Received: from MW2PR16CA0072.namprd16.prod.outlook.com (2603:10b6:907:1::49)
 by CY8PR12MB8241.namprd12.prod.outlook.com (2603:10b6:930:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 04:39:34 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::b) by MW2PR16CA0072.outlook.office365.com
 (2603:10b6:907:1::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 9 Dec 2022 04:39:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Fri, 9 Dec 2022 04:39:34 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Dec
 2022 22:39:22 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sean Christopherson" <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v2 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Date:   Fri, 9 Dec 2022 15:38:03 +1100
Message-ID: <20221209043804.942352-3-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209043804.942352-1-aik@amd.com>
References: <20221209043804.942352-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT056:EE_|CY8PR12MB8241:EE_
X-MS-Office365-Filtering-Correlation-Id: 1087852b-661b-40fc-208f-08dad99f5f4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1QhXYmRo6AtoJS8QnfveJM+cjZ69/7kPbmOBySpsl+4w4LVvsEhe3JrL/Vpxj190GtYZ99Apw/Xu1YywZ+Jqet/0QtAwcGInR+oK76GEtB0nfE+gToa7JhoMhltM/PYSvZuefW/plH5uImS4wwMk6tL2fdIVH00BhhAWxt1daiK6bxki6VpJyeCTcBp9mgQEjdhG8mYpI8Rd0LcIOZmgj1cU+xnxIxZzVw8/Nmt3fUtxt5eSMj6gKG/WplDGUASg0F5H9QO0INxHvoEnCWVEB0dRWI18Uvi5btb8B5Y7+z6PcmXMcBAg36m0fEAQ9FJgCvcKXW2RpLjuWlgmnn3Hgd92i4Ikpuz/KDxGTx1vEqA7HOa7UdB5RzN7nGW/G/gaBMlrwn94wN/6zlauz+sRXlvsKRHf5+QwqmY4b3b3FIW0QCj3NCICn3FD+kdg2stfoCySfNQgM7jc+X/iRk91YJ5SQx+J3sHRfrh4zUin2uP8QmmVtvnsdKTZs595jFbYYoYIWQO4z0gy7IEEqlRNu0k85qtQ8kcLV5s1Mq5NG/nGtCT4fawfnNWamY5XL56M65wpRsJbZehCO7Bliyjot5PiwQZlG5SKh+IHsrf+ke/UIOpU1dFn9XTCgs3wCuoyU5GCfQvImogWBC6QThih2+HDL5ZC7ifcgvWs2Bp0olp3uTg7Wu3rh3B2+LU1TOKHuIRkK0c70hyoKn9FRBKH4rBDNy+eL7eLUII7F4j1FkY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(36840700001)(46966006)(40470700004)(82740400003)(6666004)(36860700001)(8936002)(478600001)(8676002)(4326008)(70586007)(70206006)(40460700003)(36756003)(356005)(81166007)(41300700001)(54906003)(6916009)(40480700001)(316002)(426003)(47076005)(2616005)(336012)(1076003)(186003)(16526019)(2906002)(26005)(82310400005)(7416002)(5660300002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 04:39:34.6989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1087852b-661b-40fc-208f-08dad99f5f4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8241
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD Milan (Fam 19h) introduces support for the swapping, as type 'B',
of DR[0-3] and DR[0-3]_ADDR_MASK registers. Software enables this by
setting SEV_FEATURES[5] (called "DebugSwap") in the VMSA which makes
data breakpoints work in SEV-ES VMs.
For type 'B' swaps the hardware saves/restores the VM state on
VMEXIT/VMRUN in VMSA, and restores the host state on VMEXIT.

Enable DebugSwap in VMSA but only if CPUID Fn80000021_EAX[0]
("NoNestedDataBp", "Processor ignores nested data breakpoints") is
supported by the SOC as otherwise a malicious guest can cause
the infinite #DB loop DoS.

Save DR[0-3] / DR[0-3]_ADDR_MASK in the host save area before VMRUN
as type 'B' swap does not do this part.

Eliminate DR7 and #DB intercepts as:
- they are not needed when DebugSwap is supported;
- #VC for these intercepts is most likely not supported anyway and
kills the VM.
Keep DR7 intercepted unless DebugSwap enabled to prevent
the infinite #DB loop DoS.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v2:
* debug_swap moved from vcpu to module_param
* rewrote commit log

---

"DR7 access must remain intercepted for an SEV-ES guest" - I could not
figure out the exact reasoning why it is there in the first place,
IIUC this is to prevent loop of #DBs in the VM.

---
Tested with:
===
int x;
int main(int argc, char *argv[])
{
        x = 1;
        return 0;
}
===
gcc -g a.c
rsync a.out ruby-954vm:~/
ssh -t ruby-954vm 'gdb -ex "file a.out" -ex "watch x" -ex r'

where ruby-954vm is a VM.

With "/sys/module/kvm_amd/parameters/debug_swap = 0", gdb does not stop
on the watchpoint, with "= 1" - gdb does.
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/svm.h     | 16 ++++++++---
 arch/x86/kvm/svm/sev.c     | 29 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  3 +-
 4 files changed, 44 insertions(+), 5 deletions(-)

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
index 199a2ecef1ce..0fae611abe4a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -386,6 +386,8 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
 	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
+extern bool sev_es_is_debug_swap_enabled(void);
+
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -407,8 +409,10 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
 	}
 
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	if (!sev_es_guest(svm->vcpu.kvm) || !sev_es_is_debug_swap_enabled()) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
 
 	recalc_intercepts(svm);
 }
@@ -419,8 +423,12 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
-	/* DR7 access must remain intercepted for an SEV-ES guest */
-	if (sev_es_guest(svm->vcpu.kvm)) {
+	/*
+	 * DR7 access must remain intercepted for an SEV-ES guest unless DebugSwap
+	 * (depends on NO_NESTED_DATA_BP) is enabled as otherwise a VM writing to DR7
+	 * from the #DB handler may trigger infinite loop of #DB's.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm) && !sev_es_is_debug_swap_enabled()) {
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index efaaef2b7ae1..800ea2a778cc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -21,6 +21,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/debugreg.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -52,11 +53,21 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+
+/* enable/disable SEV-ES DebugSwap support */
+static bool sev_es_debug_swap_enabled = true;
+module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
+#define sev_es_debug_swap false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+bool sev_es_is_debug_swap_enabled(void)
+{
+	return sev_es_debug_swap_enabled;
+}
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -604,6 +615,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	if (sev_es_is_debug_swap_enabled())
+		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -2249,6 +2263,9 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	if (sev_es_debug_swap_enabled)
+		sev_es_debug_swap_enabled = sev_es_enabled &&
+			boot_cpu_has(X86_FEATURE_NO_NESTED_DATA_BP);
 #endif
 }
 
@@ -3027,6 +3044,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 
 	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
+
+	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
+	if (sev_es_is_debug_swap_enabled()) {
+		hostsa->dr0 = native_get_debugreg(0);
+		hostsa->dr1 = native_get_debugreg(1);
+		hostsa->dr2 = native_get_debugreg(2);
+		hostsa->dr3 = native_get_debugreg(3);
+		hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
+		hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
+		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
+		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
+	}
 }
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce362e88a567..697804d46545 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1189,7 +1189,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	set_exception_intercept(svm, UD_VECTOR);
 	set_exception_intercept(svm, MC_VECTOR);
 	set_exception_intercept(svm, AC_VECTOR);
-	set_exception_intercept(svm, DB_VECTOR);
+	if (!sev_es_is_debug_swap_enabled())
+		set_exception_intercept(svm, DB_VECTOR);
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
-- 
2.38.1

