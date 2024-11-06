Return-Path: <kvm+bounces-30840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B479BDD38
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A4261C22DF0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F9D018A92C;
	Wed,  6 Nov 2024 02:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XAP6aoc0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB9118B47E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861418; cv=none; b=L/HzZhN2W6OftPfjOdh2P6WSyw/wl95RZXFf4eTRMLuv19uOGlVtI2oCNB3azoxSWrbIWOoo/90q9PND3+zNXFuxZIucOZ+pANx6lwwEeGFnffEhqhZ/DLAuBfOYeWzY15Jkn9t8tUJEkDhQehHw1ZF5z4bbtlsrDPGf3Gnh0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861418; c=relaxed/simple;
	bh=W73DxTAKGKDwOxIP+UEa3mm04Ri1kkHN13Gfy8Im22A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IsFMdZfiJuNXNYOZFRHampJ8V2JMCTG6Yb5aknZduBAl9EUf7bODPL597IJkw0Jp4KAxoEjGKZqoz67Np6V6BzmwInCSnSntUu7XyeVKnYgkJ5JK+Zesi7nL3KcBWpwhWl6XI+aBQR5HdGuHleXyi3+/N8wOfE4TObX5qj0pBuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XAP6aoc0; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861417; x=1762397417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W73DxTAKGKDwOxIP+UEa3mm04Ri1kkHN13Gfy8Im22A=;
  b=XAP6aoc0H0Bnvw+hYVVvg+8kCcJ4Ca3+ncZlhEi8HkisVrNdsX53yKtK
   EVBVjLWACks8jUifb5tWEhV98VsZV0wOaFPQGzLb1Ue7ok8r4Nh1Q8n3f
   twHSnGHsmH605x75n/Gc9bB2IWe+cjKAF6EHqBMwmPWTK+JOuh5lNDL3Q
   DX0hVtupRwZJ4+WJECDwvMgXwInV7u1PjGyWIGt9KvMHOOp867A14gdei
   fRUkk2Mi8rmlQbrzQd70dqbAV2QpOG/cqr9CQWz3oH0yFXUAsKEYdCLBW
   td45hu3NPLXsmDAJHUkQESR7sO+WprQoK2AfbxZPZzpikjLsk/mOnWYXZ
   Q==;
X-CSE-ConnectionGUID: NyKbVK0YTRyS927sBfKHFg==
X-CSE-MsgGUID: 6kT8DyQ+TM+Fi2d7ieDhBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492310"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492310"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:50:17 -0800
X-CSE-ConnectionGUID: u6UjNTUoTaahh0D0ORPZLQ==
X-CSE-MsgGUID: u1ZDVdxyTCW2KTSVmr2mUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115078027"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:50:14 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 09/11] target/i386/kvm: Return -1 when kvm_msr_energy_thread_init() fails
Date: Wed,  6 Nov 2024 11:07:26 +0800
Message-Id: <20241106030728.553238-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is common practice to return a negative value (like -1) to indicate
an error, and other functions in kvm_arch_init() follow this style.

To avoid confusion (sometimes returned -1 indicates failure, and
sometimes -1, in a same function), return -1 when
kvm_msr_energy_thread_init() fails.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
v5: new commit.
---
 target/i386/kvm/kvm.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9993382fb40e..69825b53b6da 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2921,7 +2921,6 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
     struct KVMMsrEnergy *r = &s->msr_energy;
-    int ret = 0;
 
     /*
      * Sanity check
@@ -2931,13 +2930,11 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
     if (!is_host_cpu_intel()) {
         error_report("The RAPL feature can only be enabled on hosts "
                      "with Intel CPU models");
-        ret = 1;
-        goto out;
+        return -1;
     }
 
     if (!is_rapl_enabled()) {
-        ret = 1;
-        goto out;
+        return -1;
     }
 
     /* Retrieve the virtual topology */
@@ -2959,16 +2956,14 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
     r->host_topo.maxcpus = vmsr_get_maxcpus();
     if (r->host_topo.maxcpus == 0) {
         error_report("host max cpus = 0");
-        ret = 1;
-        goto out;
+        return -1;
     }
 
     /* Max number of packages on the host */
     r->host_topo.maxpkgs = vmsr_get_max_physical_package(r->host_topo.maxcpus);
     if (r->host_topo.maxpkgs == 0) {
         error_report("host max pkgs = 0");
-        ret = 1;
-        goto out;
+        return -1;
     }
 
     /* Allocate memory for each package on the host */
@@ -2980,8 +2975,7 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
     for (int i = 0; i < r->host_topo.maxpkgs; i++) {
         if (r->host_topo.pkg_cpu_count[i] == 0) {
             error_report("cpu per packages = 0 on package_%d", i);
-            ret = 1;
-            goto out;
+            return -1;
         }
     }
 
@@ -2998,8 +2992,7 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
 
     if (s->msr_energy.sioc == NULL) {
         error_report("vmsr socket opening failed");
-        ret = 1;
-        goto out;
+        return -1;
     }
 
     /* Those MSR values should not change */
@@ -3011,15 +3004,13 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
                                     s->msr_energy.sioc);
     if (r->msr_unit == 0 || r->msr_limit == 0 || r->msr_info == 0) {
         error_report("can't read any virtual msr");
-        ret = 1;
-        goto out;
+        return -1;
     }
 
     qemu_thread_create(&r->msr_thr, "kvm-msr",
                        kvm_msr_energy_thread,
                        s, QEMU_THREAD_JOINABLE);
-out:
-    return ret;
+    return 0;
 }
 
 int kvm_arch_get_default_type(MachineState *ms)
@@ -3327,7 +3318,9 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
         if (s->msr_energy.enable == true) {
             kvm_vm_enable_energy_msrs(s);
-            if (kvm_msr_energy_thread_init(s, ms)) {
+
+            ret = kvm_msr_energy_thread_init(s, ms);
+            if (ret < 0) {
                 error_report("kvm : error RAPL feature requirement not met");
                 exit(1);
             }
-- 
2.34.1


