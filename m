Return-Path: <kvm+bounces-67338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A40D00D08
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 41E62304A901
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A0F29DB8F;
	Thu,  8 Jan 2026 03:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hmIBtBh8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A135428D8E8
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841744; cv=none; b=MgqukpxtLImB4Vjh6l5PF6bh1iBN7Sjaudg0fAZ6U2wHF2lSnTYbO+6HGZxWrKA4B1+GOK4waPY59nSrJMJOC5Og9uXVsxEbxYVml/Y2GuGQxSeEHZq76Rfwx3z7tgmCyerNpnfKxlZE0jQDofaW+IgVm5cbhKyA+ucHjkaRe34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841744; c=relaxed/simple;
	bh=2pVI74oRygJc3hf7Dc8fgLuU4+4i79m4vbxt194dNnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJkMQBCChe1uTzcD5po5/FkLJEwmyhLCd92TCNoV0tp8bz0rE/QDwILHKnbUU6J/pJrtX1k1NvxxQFfsyhH87MeCTP+XE9J/3KmTPR2E7yAGWEuaBH++BmDzdR4QOsoZYG3dAin7rF40ddSWMYXZuvZQyrxnuME0YtHc20r6jVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hmIBtBh8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841743; x=1799377743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2pVI74oRygJc3hf7Dc8fgLuU4+4i79m4vbxt194dNnw=;
  b=hmIBtBh8ynBwfCwYMHRet7e8P9WHbJ5COKE7UVCZkaozNRYS5GfEP5J1
   xB7yE+as2QtQ7iLicaV5mHw9DB2AAilRgzv05PvA8zY4KVV12/2JwwN1D
   mKmiqhYUvP4H4XKG+5IEjky5cNpkVlSYjaEQbtxJkMchIqHySF7k5AXz8
   gfZubh09eIJDBpUsX9yh0Axf6s962elRLhAt0m9uN9onRieaGI+nMHeM3
   RKyTFlqjbX52P26DOCnXU+lNX71oWhlFujh/E8BxHX/eMt4MXGn+qt45Y
   nWJpit7M+an2llbx7WhfodIiYACsOlS37kIhLunexEJLOjGuAj/1aDL38
   Q==;
X-CSE-ConnectionGUID: VelQQR7DQICoc/LnErA1xA==
X-CSE-MsgGUID: MH5iGz2lQmadiatHUgR0nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877536"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877536"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:09:03 -0800
X-CSE-ConnectionGUID: BsEG/uvbRZ2Q7VaWTX2oUw==
X-CSE-MsgGUID: kmAQcy5aSKqUioM2yAjOUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202211219"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:08:52 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 22/27] target/i386/cpu: Remove CPUX86State::full_cpuid_auto_level field
Date: Thu,  8 Jan 2026 11:30:46 +0800
Message-Id: <20260108033051.777361-23-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108033051.777361-1-zhao1.liu@intel.com>
References: <20260108033051.777361-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philippe Mathieu-Daudé <philmd@linaro.org>

The CPUX86State::full_cpuid_auto_level boolean was only
disabled for the pc-q35-2.7 and pc-i440fx-2.7 machines,
which got removed. Being now always %true, we can remove
it and simplify x86_cpu_expand_features().

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Note, although libvirt still uses this property in its test cases, it
was confirmed this property is not exposed to user directly [*].

[*]: https://lore.kernel.org/qemu-devel/aDmphSY1MSxu7L9R@orkuz.int.mamuti.net/
---
 target/i386/cpu.c | 119 ++++++++++++++++++++++------------------------
 target/i386/cpu.h |   3 --
 2 files changed, 58 insertions(+), 64 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 37803cd72490..1de70ad99db1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9518,74 +9518,72 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
 
     /* CPUID[EAX=7,ECX=0].EBX always increased level automatically: */
     x86_cpu_adjust_feat_level(cpu, FEAT_7_0_EBX);
-    if (cpu->full_cpuid_auto_level) {
-        x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
-        x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
-
-        /* Intel Processor Trace requires CPUID[0x14] */
-        if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
-            if (cpu->intel_pt_auto_level) {
-                x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x14);
-            } else if (cpu->env.cpuid_min_level < 0x14) {
-                mark_unavailable_features(cpu, FEAT_7_0_EBX,
-                    CPUID_7_0_EBX_INTEL_PT,
-                    "Intel PT need CPUID leaf 0x14, please set by \"-cpu ...,intel-pt=on,min-level=0x14\"");
-            }
+    x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
+    x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
+
+    /* Intel Processor Trace requires CPUID[0x14] */
+    if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
+        if (cpu->intel_pt_auto_level) {
+            x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x14);
+        } else if (cpu->env.cpuid_min_level < 0x14) {
+            mark_unavailable_features(cpu, FEAT_7_0_EBX,
+                CPUID_7_0_EBX_INTEL_PT,
+                "Intel PT need CPUID leaf 0x14, please set by \"-cpu ...,intel-pt=on,min-level=0x14\"");
         }
+    }
 
-        /*
-         * Intel CPU topology with multi-dies support requires CPUID[0x1F].
-         * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should detect
-         * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, unless
-         * cpu->vendor_cpuid_only has been unset for compatibility with older
-         * machine types.
-         */
-        if (x86_has_cpuid_0x1f(cpu) &&
-            (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
-        }
+    /*
+     * Intel CPU topology with multi-dies support requires CPUID[0x1F].
+     * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should detect
+     * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, unless
+     * cpu->vendor_cpuid_only has been unset for compatibility with older
+     * machine types.
+     */
+    if (x86_has_cpuid_0x1f(cpu) &&
+        (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
+    }
 
-        /* Advanced Vector Extensions 10 (AVX10) requires CPUID[0x24] */
-        if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
-        }
+    /* Advanced Vector Extensions 10 (AVX10) requires CPUID[0x24] */
+    if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
+    }
 
-        /* Advanced Performance Extensions (APX) requires CPUID[0x29] */
-        if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APXF) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x29);
-        }
+    /* Advanced Performance Extensions (APX) requires CPUID[0x29] */
+    if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APXF) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x29);
+    }
 
-        /* SVM requires CPUID[0x8000000A] */
-        if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A);
-        }
+    /* SVM requires CPUID[0x8000000A] */
+    if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A);
+    }
 
-        /* SEV requires CPUID[0x8000001F] */
-        if (sev_enabled()) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F);
-        }
+    /* SEV requires CPUID[0x8000001F] */
+    if (sev_enabled()) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F);
+    }
 
-        if (env->features[FEAT_8000_0021_EAX]) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021);
-        }
+    if (env->features[FEAT_8000_0021_EAX]) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021);
+    }
 
-        /* SGX requires CPUID[0x12] for EPC enumeration */
-        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
-        }
+    /* SGX requires CPUID[0x12] for EPC enumeration */
+    if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
     }
 
     /* Set cpuid_*level* based on cpuid_min_*level, if not explicitly set */
@@ -10530,7 +10528,6 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_UINT32("min-xlevel", X86CPU, env.cpuid_min_xlevel, 0),
     DEFINE_PROP_UINT32("min-xlevel2", X86CPU, env.cpuid_min_xlevel2, 0),
     DEFINE_PROP_UINT64("ucode-rev", X86CPU, ucode_rev, 0),
-    DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto_level, true),
     DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
     DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
     DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 2bbc977d9088..6503a36d26b1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2425,9 +2425,6 @@ struct ArchCPU {
     /* Force to enable cpuid 0x1f */
     bool force_cpuid_0x1f;
 
-    /* Enable auto level-increase for all CPUID leaves */
-    bool full_cpuid_auto_level;
-
     /*
      * Compatibility bits for old machine types (PC machine v6.0 and older).
      * Only advertise CPUID leaves defined by the vendor.
-- 
2.34.1


