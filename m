Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE50526963B
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgINUTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:19:00 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbgINUSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:18:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAEBbI9X2szN7VDxHsI6WOz8Ueu8XkXsEMSN1awe8RLoT+6KJEGPfd8xTsgKnH7SElj8jO0g1NbO/TNtoDxgjySDU9M2/gTgAomH0p2q2MiFyCnXX2AKxIbb1BxwnIZa1jp50otUkqDxf8ix9zBTDWuItiIdXHsVE+udAvMXc8aAupHHYrfhatK/rhgFa53LQHX6kimdiaDelui3V1+GqmLfuvZ5x1bQDuVY/BiwSQMbZiH2jYmyzCZXqMu9aL6Ql1rv0IlBVYwhwI2+zaKsJgbtupjNsk0W1akPBSOPnWHUxIDMqM3K0eBhoWuHRFLf9AMAZtRxA/VLAjR8etZcUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBpsnT2tJVySvuhrxxLYudkEgoLGk4WII7tECszYZhI=;
 b=C25G8Xy4LDAykGGA7ApoPp8OK8vRvXOTEy6NkwtMw26MIxFxlHv2dQiGtIyOH1OllwaF8inhyRqnkrENIuK0lm8LLWAK0YrzvPXFdj1igh20M7tR8ENoeh47CWvm4SPstBQ6iEPYh8g8q3bGiP7yeCZ5YmZlA4SdlgPtjItnbTW2V/e3zMJ3enxHSsAVjCque222/HJ+TwHpGMnLmKc7ItdacHI9xctId3IbsTtR+k6v5d2oMdygn1q2bZHGxvaQpqWVXKP7D/rGHPnMpUsz78fOEg9uS9Y+b2jZi5RenAgbLLjpXp3In0zxpG9my1+t6H7IypOYckGwPDosfiqrlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBpsnT2tJVySvuhrxxLYudkEgoLGk4WII7tECszYZhI=;
 b=OqCHuDhv1dvjY1epIlqbuh2DCfpBz5aqmWGV8rJ5AUg1JPorcKk5XNmjbeYMOJVXcNCJF+JtuX8TjlGiNfgxkZAe21BTaJz2Uh7B16W6fs3mxd077z2kTLygCFDi2srTjF0+TET+ROJaF4rN0fji6+NuSVJhPtNsKYFzrzG2tFg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:17:34 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:17:34 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 12/35] KVM: SVM: Add initial support for a VMGEXIT VMEXIT
Date:   Mon, 14 Sep 2020 15:15:26 -0500
Message-Id: <a1b5f42b88e8246935a76a984888c480d6cdb569.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR16CA0031.namprd16.prod.outlook.com
 (2603:10b6:4:15::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR16CA0031.namprd16.prod.outlook.com (2603:10b6:4:15::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:17:33 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e821f261-34c1-4158-c9e6-08d858eb374d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11630B0BA0619D00F83C434AEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C55egjotSMJkDzKRTmFdlI5b8gBu1UDSYXdGuUIq5XBHSoLi4zZk40ZM2SHmDyi3rljiu3tUmrx2z8jJdkXpLvwQyvZOyPhxCGB6QxmJzUutIr/SSf3cCN0Q9Tw6UtHKResd1aTrniVlyF2Ufd1b70ehGHGaNTYaSnQeEnjYE+q8uUJ+tXeDj4fprptJ9V6QNsf10SibDY+NgEDJI9cAq149E99wtVULKlOOlL7czTBGaBmrL5d0Iwa0mWLjUy0R5WiHSosmbJ24WoYUoVrppKHd0oduLAAcKLGi92/cqQd94HKucKV49GBxlDXh3SSmBpVq9gjkFXZT0r62H5uZ5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zp/SrmxuZx0M4TNmVV2TjwZ877lvX5QJuutQzPX/nB7M1hIZ1D/S4SGvmyn35M57j5syNJIVMxl4JOUDeMA563cakJIDyuEQwo3KVg2gDMfWHEHvGq+W5iPu1wPStxEig2auuJ2K9dFApWem9LX0AL7huHw9I611yNwfBPWllXAVBACasQL+dR0mVlggGqTHCOcly8+VVE9h6mVfiVg1xy0L1BZ+ZFcFFZlcJsVwVQMvgtBbti9DEsdu0twQLkkUeJZHlvYp/UJVW2J5nVd58urw3JbfPzRk1NO9oTfSZ25OaX5v4HXgeB3qLngIuFLB+qZCmUYTDJviqqIspXy2BpYFdMuWOhYKYKyhvX9Z47po8srOEenBJcRWwDYQCmWPdt7oX5gYSCZSZ4kBcmHtJNeWGgGTvK2ryRhsTBX04ZT2o7xcNhyP0qORL0EwDUf5NopxU6WHQo2jHOybYlcocpO+VdygmIiAa11KSoa5tmtAYTdJ2yJohc5hLXMSlSDOAZhAlGtld0Sd1z8d6MUUjcU+PY41NsLFlNvVk97cD/0tzi8/s1gwRCFjUe2qAS7A0HU0PJ5kvuTUmUNHFNdGMfs37fcqrRe/MV+p3JGqFgbVD0HGakd+qqiHjIUfFC8o1YUrGGxqp57HNB5j3Jn24g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e821f261-34c1-4158-c9e6-08d858eb374d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:17:34.3657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0/k5VvZqwdpN2SepU+EQUx0hBUQ5jeZLydTCkbGXa8DoVSoNeGo/8NUDNi9YbT6wxQtVWhUTRVPMPe72ZBobQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SEV-ES adds a new VMEXIT reason code, VMGEXIT. Initial support for a
VMGEXIT includes reading the guest GHCB and performing the requested
action. Since many of the VMGEXIT exit reasons correspond to existing
VMEXIT reasons, the information from the GHCB is copied into the VMCB
control exit code areas and then the standard exit handlers are invoked,
similar to standard VMEXIT processing. Before restarting the vCPU, the
now updated SVM GHCB is copied back to the guest GHCB.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h      |  2 +-
 arch/x86/include/uapi/asm/svm.h |  7 ++++
 arch/x86/kvm/svm/sev.c          | 65 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  6 ++-
 arch/x86/kvm/svm/svm.h          |  7 ++++
 5 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ed03d23f56fe..07b4ac1e7179 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -82,7 +82,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 exit_int_info_err;
 	u64 nested_ctl;
 	u64 avic_vapic_bar;
-	u8 reserved_4[8];
+	u64 ghcb_gpa;
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 0f837339db66..0bc3942ffdd3 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -80,6 +80,7 @@
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
+#define SVM_EXIT_VMGEXIT       0x403
 
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
@@ -185,6 +186,12 @@
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
+	{ SVM_EXIT_VMGEXIT,		"vmgexit" }, \
+	{ SVM_VMGEXIT_MMIO_READ,	"vmgexit_mmio_read" }, \
+	{ SVM_VMGEXIT_MMIO_WRITE,	"vmgexit_mmio_write" }, \
+	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
+	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
+	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 48379e21ed43..e085d8b83a32 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1180,11 +1180,23 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+static void pre_sev_es_run(struct vcpu_svm *svm)
+{
+	if (!svm->ghcb)
+		return;
+
+	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
+	svm->ghcb = NULL;
+}
+
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	int asid = sev_get_asid(svm->vcpu.kvm);
 
+	/* Perform any SEV-ES pre-run actions */
+	pre_sev_es_run(svm);
+
 	/* Assign the asid allocated with this SEV guest */
 	svm->vmcb->control.asid = asid;
 
@@ -1202,3 +1214,56 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
+
+static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
+{
+	return -EINVAL;
+}
+
+int sev_handle_vmgexit(struct vcpu_svm *svm)
+{
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct ghcb *ghcb;
+	u64 ghcb_gpa;
+	int ret;
+
+	/* Validate the GHCB */
+	ghcb_gpa = control->ghcb_gpa;
+	if (ghcb_gpa & GHCB_MSR_INFO_MASK)
+		return sev_handle_vmgexit_msr_protocol(svm);
+
+	if (!ghcb_gpa) {
+		pr_err("vmgexit: GHCB gpa is not set\n");
+		return -EINVAL;
+	}
+
+	if (kvm_vcpu_map(&svm->vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->ghcb_map)) {
+		/* Unable to map GHCB from guest */
+		pr_err("vmgexit: error mapping GHCB from guest\n");
+		return -EINVAL;
+	}
+
+	svm->ghcb = svm->ghcb_map.hva;
+	ghcb = svm->ghcb_map.hva;
+
+	control->exit_code = lower_32_bits(ghcb_get_sw_exit_code(ghcb));
+	control->exit_code_hi = upper_32_bits(ghcb_get_sw_exit_code(ghcb));
+	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
+	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
+
+	ghcb_set_sw_exit_info_1(ghcb, 0);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+
+	ret = -EINVAL;
+	switch (ghcb_get_sw_exit_code(ghcb)) {
+	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+		pr_err("vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
+		       control->exit_info_1,
+		       control->exit_info_2);
+		break;
+	default:
+		ret = svm_invoke_exit_handler(svm, ghcb_get_sw_exit_code(ghcb));
+	}
+
+	return ret;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6a4cc535ba77..89ee9d533e9a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2929,6 +2929,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
 	[SVM_EXIT_AVIC_UNACCELERATED_ACCESS]	= avic_unaccelerated_access_interception,
+	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -2968,6 +2969,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
+	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
 	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
 	pr_err("%-20s%08x\n", "event_inj_err:", control->event_inj_err);
 	pr_err("%-20s%lld\n", "virt_ext:", control->virt_ext);
@@ -3064,7 +3066,7 @@ static bool svm_is_supported_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 	return false;
 }
 
-static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
+int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
 {
 	if (!svm_is_supported_exit(&svm->vcpu, exit_code))
 		return 0;
@@ -3080,6 +3082,8 @@ static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
 		return halt_interception(svm);
 	else if (exit_code == SVM_EXIT_NPF)
 		return npf_interception(svm);
+	else if (exit_code == SVM_EXIT_VMGEXIT)
+		return sev_handle_vmgexit(svm);
 #endif
 	return svm_exit_handlers[exit_code](svm);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9953ee7f54cd..1690e52d5265 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -17,6 +17,7 @@
 
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
+#include <linux/bits.h>
 
 #include <asm/svm.h>
 
@@ -163,6 +164,7 @@ struct vcpu_svm {
 	/* SEV-ES support */
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
+	struct kvm_host_map ghcb_map;
 };
 
 struct svm_cpu_data {
@@ -399,6 +401,7 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
+int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code);
 
 /* nested.c */
 
@@ -503,6 +506,9 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
+#define GHCB_MSR_INFO_POS		0
+#define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
@@ -519,6 +525,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+int sev_handle_vmgexit(struct vcpu_svm *svm);
 
 /* VMSA Accessor functions */
 
-- 
2.28.0

