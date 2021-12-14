Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2711473B8C
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 04:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhLNDdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 22:33:17 -0500
Received: from mail-co1nam11on2074.outbound.protection.outlook.com ([40.107.220.74]:49633
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229485AbhLNDdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 22:33:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiiBQ3HxR80Mol2tNBAenwOgV3wRJNfkkIH9iuaObtNm+An23iPay6uVM1rHgjf7M9Z5+Z6v4P4k9iXa2c0WjX5EyYa1s1msy78ZgkukhIrH57VmQ+J/patjUdu8V5XWQUKe8fABkWb4qUGg6JnHCMZjmZhrq//8NAj3TPSfUzRVkiGKrxvEpzLDfwoKi92w2OLReMxltzwqfRuN0pn3mPTAOfymTBy2GtMtKf1yr/lOk2mqfsk/yQ98qHi0WV8uH8M0vVbtKXPNTClwDktrGf6gxo/SuNqAA9LqmiomVdTjrF5wfUCgglQErkvvJUXEBLTu/tUwiNPgcUBk//sOVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCHqrQUVJ3tloACRL/VTee6oFdSvagIsueU1G3q88j4=;
 b=AA+0wsEmG65PbcJoxWWBlL/yQ7yoDWiprhmG/zIraimWEVq6J4SAzRmY3s+OPi0h5yzX525H88EvBLogV+QfzKqv7GiQ9PAU3UCppWGy2JKE4iR3Yigb4qgN8iLEr53i1nn/gVDGxT+y/MX+xhnIuyGU6n8nmka1b78q+0DXgzLHw/UgMNqm3DJhUf3aOIE0IE1u4A1bPTddB7CeMMKIMq9XC/4jiAjnuMNDuNWCRibCpZUq+9SSfFADstqSf1PZcpkAhEzHBqVEODj8FiWUTCMIrHxU6N07ZCxmrkvbFM4xBhYluLFnqUqsy4saVFHRsChOIc5sZobW3Vu7fPezCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCHqrQUVJ3tloACRL/VTee6oFdSvagIsueU1G3q88j4=;
 b=t2CcHdOGmx9piZz4pBtqoMUlntwAfl8v6D2etEj6u+QCplecEdS+2SkxeUchLyzzyEorgW9yQSZQSYKcwehWJQ5jQuZfKXkh1iP5sy6yCs4BRQ7D5LAPMFZMzS6KelP1wotbOX67B28TPkhn3A/Y2caXVNlznHxYwtw1tyIsGtMIccxUm7FaD0dxkeH/j/vTp3YKN/qrtVUfQJ32iQWRymSM2V1y7hhZ5dX8NSHDDnUkG5M9IVA9kEk7IUzeL6kFp/+u7JzWotWF+0xRJHMw1LA3wotnZMZ2UdQXGGUOYh00ymkagpbzxdnqbDW++vD+DwiAlCOVNha/dn6epruQlg==
Received: from MW4PR03CA0207.namprd03.prod.outlook.com (2603:10b6:303:b8::32)
 by CH2PR12MB4214.namprd12.prod.outlook.com (2603:10b6:610:aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Tue, 14 Dec
 2021 03:33:14 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::b4) by MW4PR03CA0207.outlook.office365.com
 (2603:10b6:303:b8::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Tue, 14 Dec 2021 03:33:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Tue, 14 Dec 2021 03:33:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 03:33:11 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (172.20.187.6) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.9; Mon, 13 Dec 2021 19:33:09 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <wanpengli@tencent.com>, <rkrcmar@redhat.com>,
        <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] KVM: x86: add kvm per-vCPU exits disable capability
Date:   Mon, 13 Dec 2021 19:32:27 -0800
Message-ID: <20211214033227.264714-1-kechenl@nvidia.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24ecdc42-148c-4c16-37c1-08d9beb275dd
X-MS-TrafficTypeDiagnostic: CH2PR12MB4214:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB42142869AF3E59480F92D150CA759@CH2PR12MB4214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4B8WOfbQHSM90/Se/0jiUxFOVqvenRFM4ONvm8u7hHO4xLfVPQ9B94+yU9ujGUmClk2Lp56EwTCfnSHSWArP9FXHEjm+TGkJo2W2BvvVRhpn2rF+hoN/7RFuSn5wpzd52r5RKBJFWD2oBvU6Z7hqHMOOWeN5mQ5NCdEst4VEHOmENFJIlKfsWvCc4EHqA91dwIlVY7r20mZujyV47ONtW/rwXh3JcjD7Gs9fs3WMcef2w1M7ZLRdGcMa/5iHoR6lkT4oIqbhlEcfIXqFkhZrzPqN0UhAXfviZoJSQ5yJ7ypfItc4bJDYxvCnv8V4+xDSEpNQgoDSXMhvzjhHDf0woIwYJZHFoDGoevceV7U7p/ph23dfYb+Iyiot3uKfeo+JMH+j08qmwyFeVkS6hCf3Qs3XfCZBZ1uqx25qlL66OwCnqF6m2DeN8aB3pfgC0swqrTUM8PjNsTxFhTzdS8F8mqsqNAmQx1EkuDH7j9dA40qQuq+HJPVufF9WC4tz6UYqN7MGIjVLdUI3ai//WdO90Dq8ZLIAcd2nWglXs2lNMv6tGWznW7+tFMBKw4XbYt+l+pN9/VHDci6LpPqTALAOSFgKWV5Q6mqdADBGMh9Bm8GLjsdU4THO32bb9/mGLzuroqa/wFysdYIYidFDvxJL1ATixfZsYxgEAO2ZnaV0K9QlHwAgm8HckRAXjboxLnjF7jrA3r4HWj3M3fAA1/Hx2FMnbAiL5K91BbsDAy/CTiUz3giSx7KFkEV0TY6iD3tG2h36qECjfc3/II6t5ROHkPTmImjswy9hBpPHwy1Tt4=
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(186003)(82310400004)(54906003)(1076003)(336012)(110136005)(34070700002)(316002)(16526019)(47076005)(86362001)(508600001)(8936002)(2616005)(26005)(356005)(4326008)(8676002)(5660300002)(83380400001)(7696005)(6666004)(36860700001)(70586007)(40460700001)(2906002)(426003)(70206006)(36756003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 03:33:13.6930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ecdc42-148c-4c16-37c1-08d9beb275dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4214
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new bit KVM_X86_DISABLE_EXITS_PER_VCPU and second arg of
KVM_CAP_X86_DISABLE_EXITS cap as vCPU mask for disabling exits to
enable finer-grained VM exits disabling on per vCPU scales instead
of whole guest. This exits_disable_vcpu_mask default is 0, i.e.
disable exits on all vCPUs, if it is 0x5, i.e. enable exits on vCPU0
and vCPU2, disable exits on all other vCPUs. This patch only enabled
this per-vCPU disable on HLT VM-exits.

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

Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 Documentation/virt/kvm/api.rst  | 8 +++++++-
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 2 +-
 arch/x86/kvm/svm/svm.c          | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 arch/x86/kvm/x86.c              | 5 ++++-
 arch/x86/kvm/x86.h              | 5 +++--
 include/uapi/linux/kvm.h        | 4 +++-
 8 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..9a44896dc950 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6580,6 +6580,9 @@ branch to guests' 0x200 interrupt vector.
 
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
+             args[1] defines vCPU bitmask based on vCPU ID, 1 on
+                     corresponding vCPU ID bit would enable exists
+                     on that vCPU
 :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
 
 Valid bits in args[0] are::
@@ -6588,13 +6591,16 @@ Valid bits in args[0] are::
   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
+  #define KVM_X86_DISABLE_EXITS_PER_VCPU         (1UL << 63)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
 workloads, and is suggested when vCPUs are associated to dedicated
 physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
-all such vmexits.
+all such vmexits. Set KVM_X86_DISABLE_EXITS_PER_VCPU enables per-vCPU
+exits disabling based on the vCPUs bitmask for args[1], currently only
+set for HLT exits.
 
 Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2164b9f4c7b0..1c65dc500c55 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1085,6 +1085,7 @@ struct kvm_arch {
 	bool hlt_in_guest;
 	bool pause_in_guest;
 	bool cstate_in_guest;
+	u64 exits_disable_vcpu_mask;
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 07e9215e911d..6291e15710ba 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -177,7 +177,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	best = kvm_find_kvm_cpuid_features(vcpu);
-	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
+	if (kvm_hlt_in_guest(vcpu) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d0f68d11ec70..d24f67b33ae5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1276,7 +1276,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm_set_intercept(svm, INTERCEPT_MWAIT);
 	}
 
-	if (!kvm_hlt_in_guest(vcpu->kvm))
+	if (!kvm_hlt_in_guest(vcpu))
 		svm_set_intercept(svm, INTERCEPT_HLT);
 
 	control->iopm_base_pa = __sme_set(iopm_base);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5aadad3e7367..8694279bb655 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1585,7 +1585,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 	 * then the instruction is already executing and RIP has already been
 	 * advanced.
 	 */
-	if (kvm_hlt_in_guest(vcpu->kvm) &&
+	if (kvm_hlt_in_guest(vcpu) &&
 			vmcs_read32(GUEST_ACTIVITY_STATE) == GUEST_ACTIVITY_HLT)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
@@ -4123,7 +4123,7 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 	if (kvm_mwait_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~(CPU_BASED_MWAIT_EXITING |
 				CPU_BASED_MONITOR_EXITING);
-	if (kvm_hlt_in_guest(vmx->vcpu.kvm))
+	if (kvm_hlt_in_guest(&vmx->vcpu))
 		exec_control &= ~CPU_BASED_HLT_EXITING;
 	return exec_control;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0cf1082455df..9432d7c04a98 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5773,6 +5773,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.pause_in_guest = true;
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
 			kvm->arch.cstate_in_guest = true;
+		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_PER_VCPU) &&
+			cap->args[1])
+			kvm->arch.exits_disable_vcpu_mask = cap->args[1];
 		r = 0;
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
@@ -12080,7 +12083,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 		     vcpu->arch.exception.pending))
 		return false;
 
-	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
+	if (kvm_hlt_in_guest(vcpu) && !kvm_can_deliver_async_pf(vcpu))
 		return false;
 
 	/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4abcd8d9836d..449476e13206 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -377,9 +377,10 @@ static inline bool kvm_mwait_in_guest(struct kvm *kvm)
 	return kvm->arch.mwait_in_guest;
 }
 
-static inline bool kvm_hlt_in_guest(struct kvm *kvm)
+static inline bool kvm_hlt_in_guest(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.hlt_in_guest;
+	return vcpu->kvm->arch.hlt_in_guest && (rol64(1UL, vcpu->vcpu_id) &
+			~vcpu->kvm->arch.exits_disable_vcpu_mask);
 }
 
 static inline bool kvm_pause_in_guest(struct kvm *kvm)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..976eb16f7fc0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -798,10 +798,12 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_PER_VCPU       (1UL << 63)
 #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
                                               KVM_X86_DISABLE_EXITS_HLT | \
                                               KVM_X86_DISABLE_EXITS_PAUSE | \
-                                              KVM_X86_DISABLE_EXITS_CSTATE)
+					      KVM_X86_DISABLE_EXITS_CSTATE| \
+					      KVM_X86_DISABLE_EXITS_PER_VCPU)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
-- 
2.30.2

