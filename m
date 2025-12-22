Return-Path: <kvm+bounces-66526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 336B8CD764D
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 23:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7645D303EF66
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 22:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9856233EAF2;
	Mon, 22 Dec 2025 22:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jkDIdYfn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A099230FF3A;
	Mon, 22 Dec 2025 22:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766444241; cv=none; b=cpVQWVcqgWcdAKwi3X0c44hBeBRghEoE/S10mMNT3hxCPk53Rffw0hM8jn4T9WWc2PNm4dOI+UA624pslpNknUWBFxttjoMsK9lzhlxCvUbhfMGYgl/CkH3ns3xHFmffLis98C2bzTG082GIRPDkmYjOvKRMX5EbiIrhyVK8yP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766444241; c=relaxed/simple;
	bh=FUn0OR5YuUpOyGicuQ/+P8CxhpRvnEK0ByM4pk9sBBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0cOm7vjlAxd3NZq0L+JvyCdQ6MsguNMJ23MiUEJa10k2s95axjnNJX0gOyNm1jtpBBP3NZmhtOagBqSvYfJcT59Lg9rCFQbmEtoZyXYIO+5ZFG6yCUi+eORi0pu0fgUJRaLvA0ziOAyK5BgIa4dxS/SnOpr4KbxDtqkzboyhyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jkDIdYfn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB36C19422;
	Mon, 22 Dec 2025 22:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766444241;
	bh=FUn0OR5YuUpOyGicuQ/+P8CxhpRvnEK0ByM4pk9sBBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkDIdYfnBqcXbdVlEcYHR8rr8eyFgbFLksExGZOipWUuaszxxf8NXXERC4E3BOd1d
	 csaPAD/ejsi3V1RA96mDKBsERN+6mMRSNintABqnX79yeUt7uag4SPoBFioRtLEyyL
	 HJ+TebQlu/5ZdCXFp5SuTN2IZRRXfjFlrgJeFB5+2wNVfORL5NiJQUgJDXUKbloQIU
	 a6HXfvKzlLYbWQrXvsk/Lne8dMl4klJ8gmsAjw4Xxt3zSaHVF9eY7AdZJTeMf6kjpa
	 XiDv/qrNjeCIkPAjjCy6c6xgWPmqqYRmDa55H+oTGdOqcBfGptmm9dZLcuFtqp7Uje
	 3El3eqVE7twsw==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 02/11] tools headers: Sync UAPI KVM headers with kernel sources
Date: Mon, 22 Dec 2025 14:57:07 -0800
Message-ID: <20251222225716.3565649-2-namhyung@kernel.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20251222225716.3565649-1-namhyung@kernel.org>
References: <20251222225716.3565649-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To pick up changes from:

  ad9c62bd8946621e ("KVM: arm64: VM exit to userspace to handle SEA")
  8e8678e740ecde2a ("KVM: s390: Add capability that forwards operation exceptions")
  e0c26d47def7382d ("Merge tag 'kvm-s390-next-6.19-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD")
  7a61d61396b97fd6 ("KVM: SEV: Publish supported SEV-SNP policy bits")

This should be used to beautify DRM syscall arguments and it addresses
these tools/perf build warnings:

  Warning: Kernel ABI header differences:
    diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h
    diff -u tools/arch/x86/include/uapi/asm/kvm.h arch/x86/include/uapi/asm/kvm.h

Please see tools/include/README.kernel-copies.

Cc: kvm@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/arch/x86/include/uapi/asm/kvm.h |  1 +
 tools/include/uapi/linux/kvm.h        | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d48c98..7ceff65836525c74 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -502,6 +502,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SNP_POLICY_BITS	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 52f6000ab020840e..dddb781b0507dcfe 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
+#define KVM_EXIT_ARM_SEA          41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -473,6 +474,14 @@ struct kvm_run {
 				} setup_event_notify;
 			};
 		} tdx;
+		/* KVM_EXIT_ARM_SEA */
+		struct {
+#define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID	(1ULL << 0)
+			__u64 flags;
+			__u64 esr;
+			__u64 gva;
+			__u64 gpa;
+		} arm_sea;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -963,6 +972,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_ARM_SEA_TO_USER 245
+#define KVM_CAP_S390_USER_OPEREXEC 246
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.52.0.351.gbe84eed79e-goog


