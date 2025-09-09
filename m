Return-Path: <kvm+bounces-57064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 04087B4A850
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BC9F74E1812
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A491A2D1913;
	Tue,  9 Sep 2025 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RePqteug"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35672C21D5;
	Tue,  9 Sep 2025 09:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410797; cv=none; b=dfQgFIfIlZwMrDwSXRwfHntZsCk8ZTsmRaJ35+mP8Of8QmHoKMorksFyhTM2YQnB5Nu70jAUahACfidvyxtzOdLupxfydUgi0mqVbUf4kYH8W8LPTwDjm8a8cSlHKPKO3ZaBi6iaw4XL2Voo3AwPr8blCYyDTG8P9l6iCRjpEqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410797; c=relaxed/simple;
	bh=awSO2SajylR+9FfF5723lqDYN0HFNJlp3YMao7mQqgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrPff4nZvOaUtS3Qnf6wpQd/LbdobKZCc9rnfX7iaj0C9l408RXMmayFXH2WW8l+S4iaHNhx13KqSxf0WeLy+tufv75w8JPGfYF+EgZSQ/sljfI6kKKaTzwHbTeZNt/vZ6w+yE8WLIizauSxdLOrnmcOhcgYeZ4O16ufqZUFB6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RePqteug; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410796; x=1788946796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=awSO2SajylR+9FfF5723lqDYN0HFNJlp3YMao7mQqgA=;
  b=RePqteugm3TFCjlgXAxJRc/FQcSwSLFyALlRtIBFRKkAwpvGOCLrDQI+
   W4NNMO53ZWXXzJrZQwzb0GwPCPXDAt/tBpdNDp40kcNLmjBt6OFUxKgyl
   It5sw03vhC3/WgFaERQPyy728RLDdYBv0nHLbG0MDXpOp6lLQ1ULjoERL
   orSyN+pyGonJSFpEPHhGAopbACj3OKZG6CdeN0gGb7PaKyZGXF6yQV98l
   q7fvzgVOGfhnJ66BM2Nk7CIESAR0ZLwExRRk3F8IHiT++kVk5V/n1Pjma
   CroQLejqFabB8IOEC/PWzo9UHH2qM5gboegdeP+WPrYWoaV++1mVH5RZl
   A==;
X-CSE-ConnectionGUID: PD41bYJpSSmJ55zXy4kryA==
X-CSE-MsgGUID: 7ZLmsCBqTnOQvrrvBKG6ZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307178"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307178"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:54 -0700
X-CSE-ConnectionGUID: Zl1dDcnHTu2Eday039ucNQ==
X-CSE-MsgGUID: g6ubcS0DQSGExMHxzchO2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207388"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:54 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 01/22] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
Date: Tue,  9 Sep 2025 02:39:32 -0700
Message-ID: <20250909093953.202028-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access MSRs and
other non-MSR registers through them.

This is in preparation for allowing userspace to read/write the guest SSP
register, which is needed for the upcoming CET virtualization support.

Currently, two types of registers are supported: KVM_X86_REG_TYPE_MSR and
KVM_X86_REG_TYPE_KVM. All MSRs are in the former type; the latter type is
added for registers that lack existing KVM uAPIs to access them. The "KVM"
in the name is intended to be vague to give KVM flexibility to include
other potential registers. We considered some specific names, like
"SYNTHETIC" and "SYNTHETIC_MSR" before, but both are confusing and may put
KVM itself into a corner.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com/ [1]
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v14:
- Rename the group type of guest SSP register to KVM_X86_REG_KVM
- Add docs for id patterns for x86 in api.rst
- Update commit message
---
 Documentation/virt/kvm/api.rst  |  2 +
 arch/x86/include/uapi/asm/kvm.h | 26 +++++++++++
 arch/x86/kvm/x86.c              | 78 +++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..28fc12b46eeb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2908,6 +2908,8 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
 
   0x9030 0000 0002 <reg:16>
 
+x86 MSR registers have the following id bit patterns::
+  0x2030 0002 <msr number:32>
 
 4.69 KVM_GET_ONE_REG
 --------------------
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..508b713ca52e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -411,6 +411,32 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
+#define KVM_X86_REG_TYPE_MSR		2
+#define KVM_X86_REG_TYPE_KVM		3
+
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg == KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
+({										\
+	__u64 type_size = (__u64)type << 32;					\
+										\
+	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
+		     type == KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
+		     0;								\
+	type_size;								\
+})
+
+#define KVM_X86_REG_ENCODE(type, index)				\
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
+
+#define KVM_X86_REG_MSR(index)					\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
+#define KVM_X86_REG_KVM(index)					\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_KVM, index)
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ba2cdfdac44..f32d3edfc7b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2254,6 +2254,31 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
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
@@ -4737,6 +4762,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
 	case KVM_CAP_X86_GUEST_MODE:
+	case KVM_CAP_ONE_REG:
 		r = 1;
 		break;
 	case KVM_CAP_PRE_FAULT_MEMORY:
@@ -5915,6 +5941,20 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+struct kvm_x86_reg_id {
+	__u32 index;
+	__u8  type;
+	__u8  rsvd1;
+	__u8  rsvd2:4;
+	__u8  size:4;
+	__u8  x86;
+};
+
+static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
+{
+	return -EINVAL;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -6031,6 +6071,44 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
+		if ((reg.id & KVM_REG_ARCH_MASK) != KVM_REG_X86)
+			break;
+
+		id = (struct kvm_x86_reg_id *)&reg.id;
+		if (id->rsvd1 || id->rsvd2)
+			break;
+
+		if (id->type == KVM_X86_REG_TYPE_KVM) {
+			r = kvm_translate_kvm_reg(id);
+			if (r)
+				break;
+		}
+
+		r = -EINVAL;
+		if (id->type != KVM_X86_REG_TYPE_MSR)
+			break;
+
+		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
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
2.47.3


