Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47B354BF24
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 03:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238832AbiFOBRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 21:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239961AbiFOBR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 21:17:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DCDB4B8;
        Tue, 14 Jun 2022 18:17:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvYFqaJdpNAFRdbGKSm9Rq0dcsVBR4MTl3WVaz8qmE7MvUhTNFoIIxyZtcmpjQCHbhbwIXXS9hiQ5Ex/ANhziImnpUQyrHL2dT/DsggpTvyW+B+dJN+a+sH+C10Tzj5DudH+gavE/rqYildDxZX0zeSBu1np0Ox1J0x6FBbPGZMUsrZZVbTjNz+Q4lLU56OZz93wpRAAq4o7m156mCqIyIX9osYZoJPk9Nnig+Kf+b7+E5B1icU97U1Wr7NQlm+UIuZ5w4g/eP0e4EqpscIojA1tcwkLtpPT6YqhQwBOMOq6dSk2jICrg57MMx0JCMMVWWuG3g862o6+XYQclJy3KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcuzILkuxG2dgCCcU/BChCFZd648xB71hXaD3JZ/jj4=;
 b=i9sBvBr4BfsU9wZngVPhO5JsjO/2MaXd0W3fBAGGV5Mm++ZfjirN7m8bBt41Pp1JmWObznXy9Q/xlZdFOT6TJQG77JjRYm97zYp9PqwlXV6uWbINlMlTr8rqBXezWx4rg1UOasWdmO9XrAQ0FYou8c5Nz5Q5DtlMmI8jpLxbWr43NsyWsxxwXtNok4M9VHClMdq1wH886PRF3VFxo7KydEsn+wXUbqUphQHRh9e3JeLYJeDeQ9Kekmz5AqRo4cd7N6AFhkCLNzhL59J7Iqrbau8urEPMZzYM2Acgxckxx5I2eUx3467EcXwX396GOsuLMm7cg8e6umxuzkE+64OB+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcuzILkuxG2dgCCcU/BChCFZd648xB71hXaD3JZ/jj4=;
 b=dPqLCFErgPdWEXn9l3tuWfnJ1RuIjy72z1mZKlUsnnG7s7ak+5NdfX6q7l/Igphg0iswv7x/pdjJBRoSb8OlCDYM+KU4Gf01ldWQT0tWGrCjcL9wkb4jjJ+hkCeSvfKzFoFWj4ia84HGL1J8vodB+tqhrAvP4xoBcCA4C2gdNK3zKEwkgNzRVXneJnq+hxpGd48bGax0RqhdVSObvtRgS4G0pR17I4gm+3CDz7Rljkpgs5OXo/PGsG9uYSxciE6dE/fquM6fEcdgpFFGPwRQkUh7OG807LZsHP1nukUXstciCjmZTodn2R5HUvFYknWgblG8/y27kRWDvhHrZbOGFA==
Received: from MW4PR03CA0041.namprd03.prod.outlook.com (2603:10b6:303:8e::16)
 by DM5PR12MB1723.namprd12.prod.outlook.com (2603:10b6:3:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Wed, 15 Jun
 2022 01:17:23 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::40) by MW4PR03CA0041.outlook.office365.com
 (2603:10b6:303:8e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Wed, 15 Jun 2022 01:17:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 01:17:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 01:17:22 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 18:17:22 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 5/7] KVM: x86: add vCPU scoped toggling for disabled exits
Date:   Tue, 14 Jun 2022 18:16:20 -0700
Message-ID: <20220615011622.136646-6-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615011622.136646-1-kechenl@nvidia.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5797d27e-e061-4516-5b2a-08da4e6ccd58
X-MS-TrafficTypeDiagnostic: DM5PR12MB1723:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1723056F6150F4224FF04DA9CAAD9@DM5PR12MB1723.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s8dmfOLMGw0e9qpPRgE3DMGgatwtg2sEDD0q/RdnrWs53VemmxKzslaA0gGANF+QVOSPUJJdvp4an/QpayaUbxzCycRvxtrtEykYVT7gB7wkaKACdv90rpgngVblyVdAEMkvF4pWCmU4D390Y9qAp55ydvPJb15Awvu8AFN/mvSIOxtR/X6S/p5YZH9OZTMRzWc+zHGsOtsEdd+HJeO0VQ3sXbkxgPOIZloHcr8YWgN9v/wz1uhbX2yzA18X3nOorSIdIm2QpmUOiraric6GKE7PaZ/VhIlF0dxEkBpTJXgKFzonGCSzQns2oWtsWE5qXLuTqJCbhsDSNW3Eue56Hz3HXWHPuAVkESecbemGD/mEgoF+z6ju7CSJiuDcDSBEf0ITjNSUtq+JhKGpeKG3GQ3maJ2iq1CJ4hG7TdGhTdrSY1ur3ARLqYgCtilSRJzmE7HPvf+fSE7LZz7rWWbN7vviZyae+1QuOdZzRT8s6jskhwjm/bqjy4WKrzkfSOj6kuyq+u0IZX16VyFIrgDp7BaC8kKHWWutxA2qjJM5n5KAPnLZ7hGXv+fFCHbPEyYWQ4boSeMejWQXtJZ9PrPzky9m1XEcEXuhncCidRgC1NS5ku0G2jK6vx8plHwi3+aEkDTFFupkHz0mLm8G2xgR/7xBsm0eByOJjaZtako7pQ1zw7UcmKC43upQ4TedDaikkx31sVMKi6rMjyF5Q7ruJw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(5660300002)(81166007)(2906002)(26005)(508600001)(356005)(8936002)(7696005)(36860700001)(336012)(47076005)(1076003)(426003)(16526019)(186003)(40460700003)(36756003)(82310400005)(86362001)(4326008)(316002)(110136005)(54906003)(8676002)(2616005)(70206006)(83380400001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 01:17:23.3650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5797d27e-e061-4516-5b2a-08da4e6ccd58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1723
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support of vCPU-scoped ioctl with KVM_CAP_X86_DISABLE_EXITS
cap for disabling exits to enable finer-grained VM exits disabling
on per vCPU scales instead of whole guest. This patch enabled
the vCPU-scoped exits control toggling, also align the VM-scoped
exits control behaviors.

In use cases like Windows guest running heavy CPU-bound
workloads, disabling HLT VM-exits could mitigate host sched ctx switch
overhead. Simply HLT disabling on all vCPUs could bring
performance benefits, but if no pCPUs reserved for host threads, could
happened to the forced preemption as host does not know the time to do
the schedule for other host threads want to run. With this patch, we
could only disable part of vCPUs HLT exits for one guest, this still
keeps performance benefits, and also shows resiliency to host stressing
workload running at the same time.

In the host stressing workload experiment with Windows guest heavy
CPU-bound workloads, it shows good resiliency and having the ~3%
performance improvement. E.g. Passmark running in a Windows guest
with this patch disabling HLT exits on only half of vCPUs still
showing 2.4% higher main score v/s baseline.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 Documentation/virt/kvm/api.rst     |  2 +-
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/svm/svm.c             | 30 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c             | 37 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 | 20 ++++++++++++----
 6 files changed, 87 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 89e13b6783b5..7f614b7d5ad8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6948,7 +6948,7 @@ longer intercept some instructions for improved latency in some
 workloads, and is suggested when vCPUs are associated to dedicated
 physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
-all such vmexits.
+all such vmexits. VM scoped and vCPU scoped capability are both supported.
 
 By default, this capability only disables exits.  To re-enable an exit, or to
 override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index da47f60a4650..c17d417cb3cf 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -128,6 +128,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP(update_disabled_exits)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 573a39bf7a84..1c9e6067c34f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1584,6 +1584,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	void (*update_disabled_exits)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b32987f54ace..7b3d64b3b901 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4589,6 +4589,33 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
+static void svm_update_disabled_exits(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	if (kvm_hlt_in_guest(vcpu))
+		svm_clr_intercept(svm, INTERCEPT_HLT);
+	else
+		svm_set_intercept(svm, INTERCEPT_HLT);
+
+	if (kvm_mwait_in_guest(vcpu)) {
+		svm_clr_intercept(svm, INTERCEPT_MONITOR);
+		svm_clr_intercept(svm, INTERCEPT_MWAIT);
+	} else {
+		svm_set_intercept(svm, INTERCEPT_MONITOR);
+		svm_set_intercept(svm, INTERCEPT_MWAIT);
+	}
+
+	if (kvm_pause_in_guest(vcpu)) {
+		svm_clr_intercept(svm, INTERCEPT_PAUSE);
+	} else {
+		control->pause_filter_count = pause_filter_count;
+		if (pause_filter_thresh)
+			control->pause_filter_thresh = pause_filter_thresh;
+	}
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4732,7 +4759,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+
+	.update_disabled_exits = svm_update_disabled_exits,
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f24c9a357f70..2d000638cc9b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7716,6 +7716,41 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 	return supported & BIT(reason);
 }
 
+static void vmx_update_disabled_exits(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (kvm_hlt_in_guest(vcpu))
+		exec_controls_clearbit(vmx, CPU_BASED_HLT_EXITING);
+	else
+		exec_controls_setbit(vmx, CPU_BASED_HLT_EXITING);
+
+	if (kvm_mwait_in_guest(vcpu))
+		exec_controls_clearbit(vmx, CPU_BASED_MWAIT_EXITING |
+			CPU_BASED_MONITOR_EXITING);
+	else
+		exec_controls_setbit(vmx, CPU_BASED_MWAIT_EXITING |
+			CPU_BASED_MONITOR_EXITING);
+
+	if (!kvm_pause_in_guest(vcpu)) {
+		vmcs_write32(PLE_GAP, ple_gap);
+		vmx->ple_window = ple_window;
+		vmx->ple_window_dirty = true;
+	}
+
+	if (kvm_cstate_in_guest(vcpu)) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+	} else {
+		vmx_enable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_enable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_enable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_enable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+	}
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -7849,6 +7884,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.update_disabled_exits = vmx_update_disabled_exits,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7cc8ac550bc7..8123309d097f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5331,6 +5331,13 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		if (vcpu->arch.pv_cpuid.enforce)
 			kvm_update_pv_runtime(vcpu);
 
+		return 0;
+	case KVM_CAP_X86_DISABLE_EXITS:
+		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
+			return -EINVAL;
+
+		kvm_ioctl_disable_exits(vcpu->arch, cap->args[0]);
+		static_call(kvm_x86_update_disabled_exits)(vcpu);
 		return 0;
 	default:
 		return -EINVAL;
@@ -5980,6 +5987,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 	int r;
 
 	if (cap->flags)
@@ -6036,14 +6045,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			break;
 
 		mutex_lock(&kvm->lock);
-		if (kvm->created_vcpus)
-			goto disable_exits_unlock;
+		if (kvm->created_vcpus) {
+			kvm_for_each_vcpu(i, vcpu, kvm) {
+				kvm_ioctl_disable_exits(vcpu->arch, cap->args[0]);
+				static_call(kvm_x86_update_disabled_exits)(vcpu);
+			}
+		}
+		mutex_unlock(&kvm->lock);
 
 		kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
 
 		r = 0;
-disable_exits_unlock:
-		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
-- 
2.32.0

