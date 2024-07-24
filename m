Return-Path: <kvm+bounces-22155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EAD093ADC6
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 10:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D5581F214DD
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 08:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A881411C8;
	Wed, 24 Jul 2024 08:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Th3QGLml"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768CF13E020
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 08:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721808544; cv=none; b=sGmZu60EGLFQR9yo2nKVd8AZfQC8uAyE0RqQERDb+hec3SMIRh5EO64A8HcXoE7ccg8ZQ5CzWKgxHxGZtl4iMj3pmUHYZP2WNCOp1/DJlBng4mlxZeuMTB0ewVsMc3b/kIIxmYJEmtV1nVMLdvp1mOpP3HS4WrWAPvgRlP8vM64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721808544; c=relaxed/simple;
	bh=ZCHPqRkAPaaK7jIc8I0RwDlUEvdpc1r9dJXDCMFtXtw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TcHyC7fgPgPhZF7h3bU6BgjSENKZK7pw/0ajwnrEINs5JzZ4UjPNRFXYFl0iiTA/nI2dTm/2jtEszZszlx9mgbv41tX6VZHCGJF1Et8Oi7KuiR0m5NeTT2qRzMJyRMPectRBL9jedYnaTsNxSMHCsCGrPuzpr97P7Om//TpFLS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Th3QGLml; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721808543; x=1753344543;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZCHPqRkAPaaK7jIc8I0RwDlUEvdpc1r9dJXDCMFtXtw=;
  b=Th3QGLmlWIczqMbYfL7xoq3L9oDPBcxkdS4hKkINYEnnY5mgF9V3e5Th
   2fZSw2UDjwRzlTWDFlhygINFKQcPRlvzuQF0nxUwleL2TLuHHvlX/5M6h
   QF3dn3t6W8gbYUEnuoWEYAUt2RO7qy9cA60/7sDCAu8ZcTAuj4SOsUaxF
   3UV7/ZXHXTmG+PfVTKK/bXyZmt+oeGMmL49QWhIixpvcBFDT6D7fgqyg7
   +d6NYuPgWIhT9ASjn5WtUPw4JWHYWCRasuKa0FVeC4g2SgLgXQV0v2F34
   d6YPx2RaCs3GseujIMe8rPyWGsyrfd0/hkQx4qiQm0fwpLCLWb8RCpuVp
   g==;
X-CSE-ConnectionGUID: jIfVueAwR3qdN/DkEAGVBQ==
X-CSE-MsgGUID: 2mtHQuE9TTWbktgNf1WkPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11142"; a="19347441"
X-IronPort-AV: E=Sophos;i="6.09,232,1716274800"; 
   d="scan'208";a="19347441"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 01:09:02 -0700
X-CSE-ConnectionGUID: ziHbI3rIS9OplWmFzi0xlA==
X-CSE-MsgGUID: E/DptciSQNKaSrRSSdnHFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,232,1716274800"; 
   d="scan'208";a="56820196"
Received: from sqa-gate.sh.intel.com (HELO emr-bkc.tsp.org) ([10.239.48.212])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 01:09:00 -0700
From: Lei Wang <lei4.wang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Xin Li <xin3.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Lei Wang <lei4.wang@intel.com>
Subject: [PATCH] target/i386: Raise the highest index value used for any VMCS encoding
Date: Wed, 24 Jul 2024 04:08:58 -0400
Message-Id: <20240724080858.46609-1-lei4.wang@intel.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Because the index value of the VMCS field encoding of Secondary VM-exit
controls, 0x44, is larger than any existing index value, raise the highest
index value used for any VMCS encoding to 0x44.

Because the index value of the VMCS field encoding of FRED injected-event
data (one of the newly added VMCS fields for FRED transitions), 0x52, is
larger than any existing index value, raise the highest index value used
for any VMCS encoding to 0x52.

Co-developed-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Lei Wang <lei4.wang@intel.com>
---
 target/i386/cpu.h     | 1 +
 target/i386/kvm/kvm.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c6cc035df3..5604cc2994 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1192,6 +1192,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define VMX_VM_EXIT_PT_CONCEAL_PIP                  0x01000000
 #define VMX_VM_EXIT_CLEAR_IA32_RTIT_CTL             0x02000000
 #define VMX_VM_EXIT_LOAD_IA32_PKRS                  0x20000000
+#define VMX_VM_EXIT_ACTIVATE_SECONDARY_CONTROLS     0x80000000
 
 #define VMX_VM_ENTRY_LOAD_DEBUG_CONTROLS            0x00000004
 #define VMX_VM_ENTRY_IA32E_MODE                     0x00000200
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b4aab9a410..7c8cb16675 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3694,7 +3694,14 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
     kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR4_FIXED0,
                       CR4_VMXE_MASK);
 
-    if (f[FEAT_VMX_SECONDARY_CTLS] & VMX_SECONDARY_EXEC_TSC_SCALING) {
+    if (f[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
+        /* FRED injected-event data (0x2052).  */
+        kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x52);
+    } else if (f[FEAT_VMX_EXIT_CTLS] &
+               VMX_VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
+        /* Secondary VM-exit controls (0x2044).  */
+        kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x44);
+    } else if (f[FEAT_VMX_SECONDARY_CTLS] & VMX_SECONDARY_EXEC_TSC_SCALING) {
         /* TSC multiplier (0x2032).  */
         kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x32);
     } else {
-- 
2.39.3


