Return-Path: <kvm+bounces-30681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E019BC5B3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6620C2814C1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5823A1FE11B;
	Tue,  5 Nov 2024 06:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RavGQxO3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D14B1FDFAF
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788785; cv=none; b=Ax0doqHSfPYOlLhO29CI5EHsQYakWLbL6Q0qFKK9u+26553pLYDcGvGx6SrnCW7yIQX1KJZxb21VbLRHHsGEweTqmP3jsWcVBszBs4/jXeGbvpHiYJu5Vj9GA+uWQZGeGBx3xBSbvM3M9tKnKxCDd9uAgrhQwuYaywGx00ceV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788785; c=relaxed/simple;
	bh=xbrsyTH8bvg8xsrUxtQa3cOVPKG1OlwWAfdK7z7v1Zw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nhp4cnLY0ssB8S4XDXneGcjLWXMt2HdSdewhDzTHXsZTdbgaMsPSdA9KgFgGu7dR38P+lHXoAM2IEBYFdWp+mt34TOO9xC4k0sT3uBr9ZSEB25HquCefrlxKPjSmAPla35/leZRgebE+9KebtQ8+jkMYIPim8tKGhTQUe+L1prw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RavGQxO3; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788784; x=1762324784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xbrsyTH8bvg8xsrUxtQa3cOVPKG1OlwWAfdK7z7v1Zw=;
  b=RavGQxO3pCZaQZiEvB/S3PbCEaUX1svLfSYNKQk4yP0IwxKYDMNzFtFK
   SZCGLEejusp+ypkvp+fydKOfsbFLVH27zASR9m1OXd9Js4kvBLkJ4cDVi
   NaK3MSHd2/ADqMK52Bys0LP+hx1MeWQRGWmC1hQS53FFVe3Eka/d6+WQ7
   aFnBLowfPhZ77rq+Enil6dxcpGpRjh6fx2giCRBXsxmiHg6XxbaQiuPzw
   dzUvcrnFYinbnGUCaxom8HS1O1zMWRjF3RHHA+zCHbJuDXRzhADRWbT0n
   7mVdD1usLyuJhvr0QfONVS0iLeunA6PZVAffPuj+NkmFCA5XPdjIUbpif
   g==;
X-CSE-ConnectionGUID: ucXqjhK8RlKXxId5ULrXyQ==
X-CSE-MsgGUID: 6BNzZuKfQ5SyuKtGUs0tQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689836"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689836"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:44 -0800
X-CSE-ConnectionGUID: I1dHo+kSQGaDnrUYcs9Eow==
X-CSE-MsgGUID: xUQf/ZneTdyrNfoRVh6f7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989754"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:40 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 47/60] i386/tdx: Implement adjust_cpuid_features() for TDX
Date: Tue,  5 Nov 2024 01:23:55 -0500
Message-Id: <20241105062408.3533704-48-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1. QEMU's support for Intel PT is borken in general, thus doesn't
   support for TDX.

2. Only limited KVM PV features are supported for TD guest.

3. Drop the AMD specific bits that are reserved on Intel platform.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 9dcb77e011bd..ba723db92bfe 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -33,6 +33,8 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#include "standard-headers/asm-x86/kvm_para.h"
+
 #define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
 #define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
 
@@ -41,6 +43,14 @@
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
 #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
+#define TDX_SUPPORTED_KVM_FEATURES  ((1U << KVM_FEATURE_NOP_IO_DELAY) | \
+                                     (1U << KVM_FEATURE_PV_UNHALT) | \
+                                     (1U << KVM_FEATURE_PV_TLB_FLUSH) | \
+                                     (1U << KVM_FEATURE_PV_SEND_IPI) | \
+                                     (1U << KVM_FEATURE_POLL_CONTROL) | \
+                                     (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
+                                     (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
+
 static TdxGuest *tdx_guest;
 
 static struct kvm_tdx_capabilities *tdx_caps;
@@ -436,6 +446,39 @@ static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
     }
 }
 
+static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
+                                          uint32_t feature, uint32_t index,
+                                          int reg, uint32_t value)
+{
+    switch (feature) {
+    case 0x7:
+        if (index == 0 && reg == R_EBX) {
+            /* QEMU Intel PT support is broken */
+            value &= ~CPUID_7_0_EBX_INTEL_PT;
+        }
+        break;
+    case 0x40000001:
+        if (reg == R_EAX) {
+            value &= TDX_SUPPORTED_KVM_FEATURES;
+        }
+        break;
+    case 0x80000001:
+        if (reg == R_EDX) {
+            value &= ~CPUID_EXT2_AMD_ALIASES;
+        }
+        break;
+    case 0x80000008:
+        if (reg == R_EBX) {
+            value &= CPUID_8000_0008_EBX_WBNOINVD;
+        }
+        break;
+    default:
+        break;
+    }
+
+    return value;
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -781,4 +824,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->cpu_realizefn = tdx_cpu_realizefn;
+    x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
 }
-- 
2.34.1


