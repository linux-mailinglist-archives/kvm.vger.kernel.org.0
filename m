Return-Path: <kvm+bounces-38933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DDEDA404D5
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DC5470074D
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F242045BA;
	Sat, 22 Feb 2025 01:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XNynLVyM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CB92040AB;
	Sat, 22 Feb 2025 01:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188480; cv=none; b=HvPBU/M0FWvo7+duB5bQAjNupodKQCzr6E0rg9I2qGGITk8It8Gbqqm5bsoF1EpDz0LUgdYRV5B5UPcVtA+R5RJ3Nlh14dmE10Wxpe0MW0iyElQK2FtCa1rt0FX6IE4y+oj4OIJG53uCdpmmO7oLzXnzBj0s4QXfAR2NriTkJTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188480; c=relaxed/simple;
	bh=YWhNX5t2bn0dywpZOM7YmQtLt1z/ih4TjdvqvxCs8Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiVTtb/JsnrLi8wVoi/0d6LFCHrzrsWbTpRTrhj/iyNwYD2GBXJWXzaX4sJfNkX4qGwFI6CHB7Do9PUCsYURk5FhVQtkPnCYud2hpTE8d/KBQ9zlDM/JkXsTLs2UUete6ykYJmudw4P2Uyd60XBAjLhUasuYlHLN6mSAl2q5MqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XNynLVyM; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188478; x=1771724478;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YWhNX5t2bn0dywpZOM7YmQtLt1z/ih4TjdvqvxCs8Cg=;
  b=XNynLVyMgFgmagqdiI16B5d/ymYyfQQNEldkez7L8pkOQVwFjdx3+DOO
   tyWGsDu/0Fv4pznCq/R/ZeFom6ZdGYgJXUWTI+VsvGPchQeFE1qlEp1Tp
   zVVNtZaQXT8nv3+wAf/h9vKH6EYS3lijqBrFTOO7QXyXta5Hn6hECBnRi
   bQ9tNOF7PXPzY9cAcp2AIRhp8bSSw0Ch0eGF1TOhx8uiq0k4NdYGS42VR
   YI3mvruZeAvKfJo+/Tm09xjjgTHnK86cBcRRC3YKD/jMU4ZPGRIXxQqhL
   r+5imvxAUwhPkuFFp10RoXc3a4s3buOU4vxOjC1Qf+9zdjD6iFMQOwmgn
   w==;
X-CSE-ConnectionGUID: Q9PyuTGHTkaVaW2ebrLOYQ==
X-CSE-MsgGUID: LXfvwHTXRRyLxNE0zuQUqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893304"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893304"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:17 -0800
X-CSE-ConnectionGUID: i/5xb73fSjO5cfKb+R148Q==
X-CSE-MsgGUID: x1r+jbNbQvSLOsZBAGsOEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370269"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:14 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 7/9] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
Date: Sat, 22 Feb 2025 09:42:23 +0800
Message-ID: <20250222014225.897298-8-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014225.897298-1-binbin.wu@linux.intel.com>
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert TDG.VP.VMCALL<ReportFatalError> to KVM_EXIT_SYSTEM_EVENT with
a new type KVM_SYSTEM_EVENT_TDX_FATAL and forward it to userspace for
handling.

TD guest can use TDG.VP.VMCALL<ReportFatalError> to report the fatal
error it has experienced.  This hypercall is special because TD guest
is requesting a termination with the error information, KVM needs to
forward the hypercall to userspace anyway, KVM doesn't do parsing or
conversion, it just dumps the 16 general-purpose registers to userspace
and let userspace decide what to do.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace v3:
- Dump all 16 general-purpose registers to userspace. (Sean)

Hypercalls exit to userspace v2:
- Use vp_enter_args instead of x86 registers.
- vcpu->run->system_event.ndata is not hardcoded to 10. (Xiaoyao)
- Undefine COPY_REG after use. (Yilun)
- Updated the document about KVM_SYSTEM_EVENT_TDX_FATAL. (Chao)

Hypercalls exit to userspace v1:
- New added.
  Implement one of the hypercalls need to exit to userspace for handling after
  reverting "KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL", which tries to resolve
  Sean's comment.
  https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 Documentation/virt/kvm/api.rst |  9 ++++++---
 arch/x86/kvm/vmx/tdx.c         | 28 ++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b52eb77e29c..2d75edc9db4f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6823,6 +6823,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_WAKEUP         4
   #define KVM_SYSTEM_EVENT_SUSPEND        5
   #define KVM_SYSTEM_EVENT_SEV_TERM       6
+  #define KVM_SYSTEM_EVENT_TDX_FATAL      7
 			__u32 type;
                         __u32 ndata;
                         __u64 data[16];
@@ -6849,9 +6850,11 @@ Valid values for 'type' are:
    reset/shutdown of the VM.
  - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
    The guest physical address of the guest's GHCB is stored in `data[0]`.
- - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
-   KVM has recognized a wakeup event. Userspace may honor this event by
-   marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
+ - KVM_SYSTEM_EVENT_TDX_FATAL -- a TDX guest reported a fatal error state.
+   KVM doesn't do any parsing or conversion, it just dumps 16 general-purpose
+   registers to userspace, in ascending order of the 4-bit indices for x86-64
+   general-purpose registers in instruction encoding, as defined in the Intel
+   SDM.
  - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested a suspension of
    the VM.
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7b2f4c32f01b..7c8356299a25 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1093,11 +1093,39 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u64 *regs = vcpu->run->system_event.data;
+	u64 *module_regs = &tdx->vp_enter_args.r8;
+	int index = VCPU_REGS_RAX;
+
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
+	vcpu->run->system_event.ndata = 16;
+
+	/* Dump 16 general-purpose registers to userspace in ascending order. */
+	regs[index++] = tdx->vp_enter_ret;
+	regs[index++] = tdx->vp_enter_args.rcx;
+	regs[index++] = tdx->vp_enter_args.rdx;
+	regs[index++] = tdx->vp_enter_args.rbx;
+	regs[index++] = 0;
+	regs[index++] = 0;
+	regs[index++] = tdx->vp_enter_args.rsi;
+	regs[index] = tdx->vp_enter_args.rdi;
+	for (index = 0; index < 8; index++)
+		regs[VCPU_REGS_R8 + index] = module_regs[index];
+
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
 	case TDVMCALL_MAP_GPA:
 		return tdx_map_gpa(vcpu);
+	case TDVMCALL_REPORT_FATAL_ERROR:
+		return tdx_report_fatal_error(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b9..937400350317 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -375,6 +375,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_WAKEUP         4
 #define KVM_SYSTEM_EVENT_SUSPEND        5
 #define KVM_SYSTEM_EVENT_SEV_TERM       6
+#define KVM_SYSTEM_EVENT_TDX_FATAL      7
 			__u32 type;
 			__u32 ndata;
 			union {
-- 
2.46.0


