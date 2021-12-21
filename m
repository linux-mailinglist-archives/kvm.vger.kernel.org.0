Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE66147BC75
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbhLUJGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:06:13 -0500
Received: from mail-sn1anam02on2088.outbound.protection.outlook.com ([40.107.96.88]:63537
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234458AbhLUJGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 04:06:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvnMeRL5rI61GKFIEGLHEY51byWVHlngVrR7mlQ8Bq72vLniyXuSwGkGHnhqze4YCisgLqSCyPsJKr97KWPN8Ceer8DC62m2ccKmByKQPmdSy8gVdS0qSPiXx0bl+q+rg97mhTavLLSF441q0ZsG0c79PU2dcMqAvD57EU96WRp8MXebFDBRyIEtFi20nQgsrvjcsVUobNWZgcmrMoUAWZkFOALh5BEo2z/GRwEk4yRcEBWCdWYcWjlgqqtFt3ze4DoFpIxWTEeJmQ6/RohkFqXkz5D6wFYAqYBm/+o/mCob8bi3bz/r5mzpYBW5kBnO/r977//2FseTAjJANpSrWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=423C2vMgljaXwW8RC2gskLtkzw5Xg8H4m0gx676AlqE=;
 b=lRTcmSvy9E7boZ2v6D7cfDyi9GyVd9ZebWnL5aCA7sle01tHGDIb007ycWepMMlNb6zUmrHdg0Hevg5Z8h4EfGesN4v2IjZwQue3YgngEpK0VF3rTtsaqvgRttWlmFRCCkYRzl5ejiHa+PATEXK679ezYge41s2PJJA30oFULIWApKGkS9i8yvQB+cP4EjJwEj52Y/OTpX4NEjTkcEJgXUHaBeaTVG6jD0DNV+eEn6ET2rwjUWvGNI6tX3QDWlqivSsU0kKHQgfbR2ZahaPsh1PEYzU1dfvrv7Swwf+PJCHwFo3fXkGH7zfckGD52KAkMZEBk5YkfXG1h2cZ7kkyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=423C2vMgljaXwW8RC2gskLtkzw5Xg8H4m0gx676AlqE=;
 b=U6rD9ExTrv/56yyoR9skX7uH7K9fYSTv3v98sP0Ovf+Hz0t4UsRYxZ6WtyruCQjadHXdxZts8Bit96Du06j4Yj/8qbqkg6MHyxgQuaRb0vIVP756+o6aIWgk/JDVDu4+t/bMk6+JiFVlnM+VZ52irqWaEtPvLkkC4TOiHyL36xgdhmDwWjnbMswADCZZsB4g36GqIlOMtnnKaxQIVBTxJ+ZA6qLXVpQwufbASb7xKo5cYOa9qWGiSMK6PCEiAGyO3sEPBtUZKzlj/HoyFJL//iT3McjYShsgwjtbC11bIkBtL74tbLG+Z9T26TqotIbEcIADMrq5KtT9ce0/lQ1t8A==
Received: from BN6PR11CA0062.namprd11.prod.outlook.com (2603:10b6:404:f7::24)
 by PH0PR12MB5402.namprd12.prod.outlook.com (2603:10b6:510:ef::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.16; Tue, 21 Dec
 2021 09:06:07 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::32) by BN6PR11CA0062.outlook.office365.com
 (2603:10b6:404:f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17 via Frontend
 Transport; Tue, 21 Dec 2021 09:06:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 09:06:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 09:06:02 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.9; Tue, 21 Dec 2021 01:06:01 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <wanpengli@tencent.com>, <vkuznets@redhat.com>, <mst@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits disable capability
Date:   Tue, 21 Dec 2021 01:04:49 -0800
Message-ID: <20211221090449.15337-4-kechenl@nvidia.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211221090449.15337-1-kechenl@nvidia.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd4743b7-f806-4d5c-1588-08d9c4611fc9
X-MS-TrafficTypeDiagnostic: PH0PR12MB5402:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB540293CA564D705940A737F6CA7C9@PH0PR12MB5402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oa3cNNBVZqxhbN3LbLj87BQhmmspGiNnEaeYgNEGYLVRgrv6RONjoPvMGCMUNTs/HXM2yBnXp8hOfaVhlv0Xd1C+rRFII82PJ1B/nlO4RQZX8cWB/wTQPKHvcaIjC3w38fnr/0YDGrzEZMxC4gA+CAIi6fqPZkYzuKQEfexA2Co7wn/NNn24CngU0keS3sg02qMG0/hN3tgKGHxxC8m9Li9CXQXs+gzPKwIUBDAWrJ5ycYGRJ6a+SEj5jVCuByk4/QAzVPU9Z8Ynyc4hw7d1RXOpn7370IibM5yi17jgEzkhn+SlUT8ZIn9S2NLQ8CMQI+C7Tznd9KK2OrQSLzvWckBQXTO27rsjkgk2rmt/ztW0ghimyQp0YGaT/WkTbkGvQg9y7/zwFQ1eSI0+2NEBCGMdfrVfdGFEHRGQVl/XJs6xS3kTh6oVXLUpRBdwU8MGwf3WNeaCTGsYhZwq1/FAD/lErBjcHPKhMi6O3z6jHc0C8ZeFHOSEJFHD76/cepPLHMd8USLW97CRh5yWUO88L52dRiUwnaSeWXGm8M8FqpcKffsPq/wTRV4qzcllZsBxYzsgs+VOXbK2JW8iNTFVeRb4XZPgJ9M5b3HxP/tRPXOeDZXudgL7EnsknKcaUnA4Fn6vlVXMe7iFcT+fDyCVRNbhjcSFrP5BMhu1r24ctiajFd2kNtJRjAIaYWfLk/Hp0Zmdn5SeWTbimsHz5fdAcM9fIiwNCCYsFCbBCLD/uKH62+8N+oj/f76vLmRfk4ih3F3bestzmDcfHhQiJYyEFcuo/6Z02TqBLi/++TOS7pY5coRgMXye5N2U7QOAl57VAJ9a9oH2ZTWWPRWHwJxilA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(2616005)(1076003)(70586007)(4326008)(70206006)(426003)(36860700001)(86362001)(356005)(508600001)(47076005)(5660300002)(82310400004)(81166007)(40460700001)(8676002)(36756003)(8936002)(54906003)(316002)(26005)(16526019)(7696005)(186003)(2906002)(6666004)(83380400001)(110136005)(34020700004)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 09:06:07.1904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4743b7-f806-4d5c-1588-08d9c4611fc9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5402
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support of vCPU-scoped ioctl with KVM_CAP_X86_DISABLE_EXITS
cap for disabling exits to enable finer-grained VM exits disabling
on per vCPU scales instead of whole guest. This patch enabled
the vCPU-scoped exits control on HLT VM-exits.

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
performance improvement.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 Documentation/virt/kvm/api.rst     |  5 +++--
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/svm/svm.c             | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.c             | 10 ++++++++++
 arch/x86/kvm/x86.c                 | 12 ++++++++++++
 6 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d1c50b95bbc1..b340e36a34f3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6581,7 +6581,7 @@ branch to guests' 0x200 interrupt vector.
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
 :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
-          or if any vCPU has already been created
+          or if any vCPU has already been created for vm ioctl
 
 Valid bits in args[0] are::
 
@@ -6595,7 +6595,8 @@ longer intercept some instructions for improved latency in some
 workloads, and is suggested when vCPUs are associated to dedicated
 physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
-all such vmexits.
+all such vmexits. vCPUs scoped capability support is also added for
+HLT exits.
 
 Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..3e54400535f2 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -121,6 +121,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
 KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP(update_disabled_exits)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index edc5fca4d8c8..20a1f34c772c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1498,6 +1498,8 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+
+	void (*update_disabled_exits)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 70e393c6dfb5..6cad069a540a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4556,6 +4556,14 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
+static void svm_update_disabled_exits(struct kvm_vcpu *vcpu)
+{
+	if (kvm_hlt_in_guest(vcpu))
+		svm_clr_intercept(to_svm(vcpu), INTERCEPT_HLT);
+	else
+		svm_set_intercept(to_svm(vcpu), INTERCEPT_HLT);
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4705,6 +4713,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.update_disabled_exits = svm_update_disabled_exits,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b5133619dea1..149eb621b124 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7536,6 +7536,14 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static void vmx_update_disabled_exits(struct kvm_vcpu *vcpu)
+{
+	if (kvm_hlt_in_guest(vcpu))
+		exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_HLT_EXITING);
+	else
+		exec_controls_setbit(to_vmx(vcpu), CPU_BASED_HLT_EXITING);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -7672,6 +7680,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.update_disabled_exits = vmx_update_disabled_exits,
 };
 
 static __init void vmx_setup_user_return_msrs(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d5d0d99b584e..d7b4a3e360bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5072,6 +5072,18 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 			kvm_update_pv_runtime(vcpu);
 
 		return 0;
+
+	case KVM_CAP_X86_DISABLE_EXITS:
+		if (cap->args[0] && (cap->args[0] &
+				~KVM_X86_DISABLE_VALID_EXITS))
+			return -EINVAL;
+
+		vcpu->arch.hlt_in_guest = (cap->args[0] &
+			KVM_X86_DISABLE_EXITS_HLT) ? true : false;
+
+		static_call(kvm_x86_update_disabled_exits)(vcpu);
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
-- 
2.30.2

