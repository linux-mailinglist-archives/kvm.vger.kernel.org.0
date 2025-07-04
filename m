Return-Path: <kvm+bounces-51574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05394AF8CD0
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B027176E91
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D58D2ED159;
	Fri,  4 Jul 2025 08:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZd1OY6v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0900A28B406;
	Fri,  4 Jul 2025 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619044; cv=none; b=qLo9E+Tf2njxHrtlVGH/NxK0wvhlw5wxLEZ2lgU5WEQjgzgmhmvupMsy1ikDGI0GC9Sdf/TZjjQLktdWfwMPv83TH+At8SGM/BAwMYbsY0dz6QVQvjMaer6bJkgRhkWOYaPdz6b1BfPJrYb+vzue7IO2/KHI80KoEO9pzCw9/o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619044; c=relaxed/simple;
	bh=zlvrn41Vs+GgCqYRRra63A7wMsg/fEs8hXj4l3Idpy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJkQk9BJuRAS8YLYpgdY0ccnL82zGgrtsv/PNukPAIuj8yNFPvbIOtLb0x5aofEFV1scltdPrxzS7WEfZZ7Ajl3OVRcbf3eTElIxFLJQJzEchnllSQjUJFEyMTHkIHM594rcXj/zun989YC/J3k//SqfrDBQMdS8XZMsgJyQV+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZd1OY6v; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619041; x=1783155041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zlvrn41Vs+GgCqYRRra63A7wMsg/fEs8hXj4l3Idpy0=;
  b=gZd1OY6vcDlVLK1YFPZW51Qrh7/HZVRmUu2AKVlT49N6/JsrzHZghP6a
   gsBPVxqsyPZWDKFvgBUVb7NDx64X/hC+u23JoE/32enz+l0iSCzwm842g
   x9IB7b4Bp4+GD5d5hehUxF7B0lnd9IGgXdbY+/EG4uycGrfITMHdFOzlL
   hbBbsr7g2QrhDLigPWWpc/davHiDL+BCCnHpZKlE79wlAXzJihKiyBbPd
   XHI+XXQS6HmYx97ONL+t1NF6ju50KO2lNDej0rZgLQZXEkDhPjn1+6XDY
   Y4Cup4uemIpgb0KLuA04WqVFWoswOZfjnGa/soJ6mYUtse4AWZJyLBvI/
   w==;
X-CSE-ConnectionGUID: tDX35CyeTaaY43J1J4HrZA==
X-CSE-MsgGUID: q+tM8LSgSVOVz2UV6xEK6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391607"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391607"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:37 -0700
X-CSE-ConnectionGUID: W+PQqjjaROaKyNL8Bq8Q0A==
X-CSE-MsgGUID: FbecwjjZRqeJBvDTy6ePwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721959"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:37 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 05/23] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
Date: Fri,  4 Jul 2025 01:49:36 -0700
Message-ID: <20250704085027.182163-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access HW MSR or
KVM synthetic MSR through it.

In CET KVM series [1], KVM "steals" an MSR from PV MSR space and access
it via KVM_{G,S}ET_MSRs uAPIs, but the approach pollutes PV MSR space
and hides the difference of synthetic MSRs and normal HW defined MSRs.

Now carve out a separate room in KVM-customized MSR address space for
synthetic MSRs. The synthetic MSRs are not exposed to userspace via
KVM_GET_MSR_INDEX_LIST, instead userspace complies with KVM's setup and
composes the uAPI params. KVM synthetic MSR indices start from 0 and
increase linearly. Userspace caller should tag MSR type correctly in
order to access intended HW or synthetic MSR.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com/ [1]
---
 arch/x86/include/uapi/asm/kvm.h | 10 +++++
 arch/x86/kvm/x86.c              | 66 +++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..e72d9e6c1739 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -411,6 +411,16 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
+#define KVM_X86_REG_MSR			(1 << 2)
+#define KVM_X86_REG_SYNTHETIC		(1 << 3)
+
+struct kvm_x86_reg_id {
+	__u32 index;
+	__u8 type;
+	__u8 rsvd;
+	__u16 rsvd16;
+};
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9d1c84f0794..e5c2bf4a90e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2237,6 +2237,31 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
 }
 
+static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
+{
+	u64 val;
+	int r;
+
+	r = do_get_msr(vcpu, msr, &val);
+	if (r)
+		return r;
+
+	if (put_user(val, value))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
+{
+	u64 val;
+
+	if (get_user(val, value))
+		return -EFAULT;
+
+	return do_set_msr(vcpu, msr, &val);
+}
+
 #ifdef CONFIG_X86_64
 struct pvclock_clock {
 	int vclock_mode;
@@ -5896,6 +5921,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
+{
+	return -EINVAL;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -6012,6 +6042,42 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
+	case KVM_GET_ONE_REG:
+	case KVM_SET_ONE_REG: {
+		struct kvm_x86_reg_id *id;
+		struct kvm_one_reg reg;
+		u64 __user *value;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+
+		r = -EINVAL;
+		id = (struct kvm_x86_reg_id *)&reg.id;
+		if (id->rsvd || id->rsvd16)
+			break;
+
+		if (id->type != KVM_X86_REG_MSR &&
+		    id->type != KVM_X86_REG_SYNTHETIC)
+			break;
+
+		if (id->type == KVM_X86_REG_SYNTHETIC) {
+			r = kvm_translate_synthetic_msr(id);
+			if (r)
+				break;
+		}
+
+		r = -EINVAL;
+		if (id->type != KVM_X86_REG_MSR)
+			break;
+
+		value = u64_to_user_ptr(reg.addr);
+		if (ioctl == KVM_GET_ONE_REG)
+			r = kvm_get_one_msr(vcpu, id->index, value);
+		else
+			r = kvm_set_one_msr(vcpu, id->index, value);
+		break;
+	}
 	case KVM_TPR_ACCESS_REPORTING: {
 		struct kvm_tpr_access_ctl tac;
 
-- 
2.47.1


