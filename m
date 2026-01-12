Return-Path: <kvm+bounces-67866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8343BD15F5E
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 76A7E300D818
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBEE226D02;
	Tue, 13 Jan 2026 00:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OhGtDk0e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD7B248F66;
	Tue, 13 Jan 2026 00:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263524; cv=none; b=Z8k4CED0+dkbnnIzkp/9vedeTqS3jxYPdwHzwLTwrYAlSugpSGbu2kvYS1QIudCmW8zHtzDRm1kvLl2ruHlJ9W7xTwIz3LViuMsRTOLS9L1R+yQI+i+P12+Gr3iSvnTE2oVYgBq2UOmhU3m9PFr/qjSGM5vPFZP9Xk7YIrLJc/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263524; c=relaxed/simple;
	bh=mCDXrYMSyGGejxXWe4/gKpSgUYhATo0cxRE8f7Kzqb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq+JVJ7JADYR0cOg8LmmV6CoIWYtYBuxeXbmvvD86HgEfzVINrfWRcLEzLZDqANL9c4McgiGRUn7rZer9X/f8uwHd8feC6sGAhZemnwNtY8us95lPkvQXPS67Uz7H0dl1jpLNtHsv9ap6KVQT30bdsGqS0cFVmoK/1R6jIto0mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OhGtDk0e; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263523; x=1799799523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mCDXrYMSyGGejxXWe4/gKpSgUYhATo0cxRE8f7Kzqb8=;
  b=OhGtDk0e5oTi5SlIHdPZaPxMiPRxRzLiHaJV+mWDQf/atNiFBY9D8iSe
   CZ8R481aAQF6bgXg3eiGaxqQ31Aun50UZ/GfYZkF+jfOjBItuJ1o5oH3n
   QWiMxFnz3N+HzSfQvqqDJ3MML5/FkY5H+nN4fnlbhNT0OY5p+6Wnvo32f
   fn0QbnzkbpQTxQwzLe5sXuGO4Inx4wgNAiBtUqEbKf6ga7HaxNYLrp9Yc
   iI8rwYURoayaVcw8ZqGV7oqJBBNx2MHkeOEsZvX9lO5ij5cXTz5ZYfTFY
   S+eaeijbEYnb1BVJsS8PRBlcv+05DgqLJQPf0OfZOm1vUjObo0zRa9hY0
   g==;
X-CSE-ConnectionGUID: oNdwrRIiR8WyNQ+p9lt/7Q==
X-CSE-MsgGUID: xw4eZUa+Q1i/hNg+hmEuyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264273"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264273"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:43 -0800
X-CSE-ConnectionGUID: cCF4ZobiRl+rIL9UhFZuUw==
X-CSE-MsgGUID: 1S8/fYGNSJSNExksB6OlQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042300"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:44 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 13/16] KVM: x86: Guard valid XCR0.APX settings
Date: Mon, 12 Jan 2026 23:54:05 +0000
Message-ID: <20260112235408.168200-14-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prevent invalid XCR0.APX configurations in two cases: conflict with MPX
and lack of SVM support.

In the non-compacted XSAVE format, APX and MPX conflict on the same
offset. Although MPX is being deprecated in practice, KVM should
explicitly reject such configurations that set both bits.

At this point, only VMX supports EGPRs. SVM will require corresponding
extensions to handle EGPR indices.

The addition to the supported XCR0 mask should accompany guest CPUID
exposure, which will be done separately.

Link: https://lore.kernel.org/ab3f4937-38f5-4354-8850-bf773c159bbe@redhat.com
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++++-
 arch/x86/kvm/x86.c     | 4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 209faa742e98..a06e5a24b808 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5301,8 +5301,13 @@ static __init int svm_hardware_setup(void)
 	}
 	kvm_enable_efer_bits(EFER_NX);
 
+	/*
+	 * APX introduces EGPRs, which require additional VMCB support.
+	 * Disable APX until the necessary extensions are handled.
+	 */
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
-				     XFEATURE_MASK_BNDCSR);
+				     XFEATURE_MASK_BNDCSR  |
+				     XFEATURE_MASK_APX);
 
 	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
 		kvm_enable_efer_bits(EFER_FFXSR);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7f858488f2c..189a03483d03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1391,6 +1391,10 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	    (!(xcr0 & XFEATURE_MASK_BNDCSR)))
 		return 1;
 
+	/* MPX and APX conflict in the non-compacted XSAVE format */
+	if (xcr0 & XFEATURE_MASK_BNDREGS && xcr0 & XFEATURE_MASK_APX)
+		return 1;
+
 	if (xcr0 & XFEATURE_MASK_AVX512) {
 		if (!(xcr0 & XFEATURE_MASK_YMM))
 			return 1;
-- 
2.51.0


