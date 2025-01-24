Return-Path: <kvm+bounces-36499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77154A1B6EF
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3655F16D8BF
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D814C62E;
	Fri, 24 Jan 2025 13:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d3l6XiXX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA58C42AB0
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725875; cv=none; b=Pthhi0xXuOMf0z1vVZMJ8/g00lYGoFLySqaiIeOdgrb+Mzxn+BoDCDznpo5ILSxtYqAaMHdEKWm3gY1p6PvZlAvRT4sQuaEMWywdx7CQSGT3VZzY9NEQbfFHNKR7PavuR4QmV5EMm4XqxeYmdPp49GG8eQtKAAVfjGMgsBK1FsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725875; c=relaxed/simple;
	bh=QQ+mVECDFZb0mkAaU9OtvuN3aHLirivkATTtr/jbCBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CiCAlFLVf310TokL4I6u+DN+8kAb5YVF1/PTGkpT0Gq46XLeGvF80GcUipx9eOAkj9PsXsjx9uqyIurOyvn39StBJmOF9fKRpC80/lcVCnLsRfGSDX4TVNHAHab63zi2U7xi4FAB7xgu7VUqi44JMPnt3Pa3t5zzJP+oc1e3mw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d3l6XiXX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725874; x=1769261874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QQ+mVECDFZb0mkAaU9OtvuN3aHLirivkATTtr/jbCBI=;
  b=d3l6XiXXYdC8wu5sqDGtQP/iAbCCSbpIq4NF8+hoT3QnDBvsv7ObxJMv
   bR9FudjmY9MoMb70EjDvUIr703pczyHev3MuyWXovWBChsu3JrCh5u9MM
   gytHWZAyq98nlcVLdZEDI+U6jGCbj3A3ngupjMEdGbD6lZ+TClM3gFRkN
   zHraSO3utBWW7ga8jTgCUr6J5ESju6bgRfQ50gHbSWtqBMIlFZ9K7R9bQ
   txD06CJUtJbn9q/lX9zy6wNoiEL6b/W4VCp5hav9lybz++dQ9ViuaUq0Z
   r4NsLqqlfwfEunAlCMDfPHlGwAob9FXQ7jOfCep6Di+1EoaQamQkI0uX5
   Q==;
X-CSE-ConnectionGUID: ErPkLZc2QiC+dEYAYQZV9w==
X-CSE-MsgGUID: i+0cCuk1QKmZ7Qa1uxuQvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246286"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246286"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:54 -0800
X-CSE-ConnectionGUID: O6LbGE7HQISg2e//eEKBdQ==
X-CSE-MsgGUID: appmcy6vRWqbm5xN1V/jfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804218"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:50 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 14/52] i386/tdx: Implement user specified tsc frequency
Date: Fri, 24 Jan 2025 08:20:10 -0500
Message-Id: <20250124132048.3229049-15-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reuse "-cpu,tsc-frequency=" to get user wanted tsc frequency and call VM
scope VM_SET_TSC_KHZ to set the tsc frequency of TD before KVM_TDX_INIT_VM.

Besides, sanity check the tsc frequency to be in the legal range and
legal granularity (required by TDX module).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v3:
- use @errp to report error info; (Daniel)

Changes in v1:
- Use VM scope VM_SET_TSC_KHZ to set the TSC frequency of TD since KVM
  side drop the @tsc_khz field in struct kvm_tdx_init_vm
---
 target/i386/kvm/kvm.c |  9 +++++++++
 target/i386/kvm/tdx.c | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a537699bb7df..7de5014051eb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -869,6 +869,15 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
     int r, cur_freq;
     bool set_ioctl = false;
 
+    /*
+     * TSC of TD vcpu is immutable, it cannot be set/changed via vcpu scope
+     * VM_SET_TSC_KHZ, but only be initialized via VM scope VM_SET_TSC_KHZ
+     * before ioctl KVM_TDX_INIT_VM in tdx_pre_create_vcpu()
+     */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     if (!env->tsc_khz) {
         return 0;
     }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 96138c2d2b73..2124284e1653 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -20,6 +20,9 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
+
 #define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
@@ -266,6 +269,28 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
         return r;
     }
 
+    if (env->tsc_khz && (env->tsc_khz < TDX_MIN_TSC_FREQUENCY_KHZ ||
+                         env->tsc_khz > TDX_MAX_TSC_FREQUENCY_KHZ)) {
+        error_setg(errp, "Invalid TSC %ld KHz, must specify cpu_frequency "
+                         "between [%d, %d] kHz", env->tsc_khz,
+                         TDX_MIN_TSC_FREQUENCY_KHZ, TDX_MAX_TSC_FREQUENCY_KHZ);
+       return -EINVAL;
+    }
+
+    if (env->tsc_khz % (25 * 1000)) {
+        error_setg(errp, "Invalid TSC %ld KHz, it must be multiple of 25MHz",
+                   env->tsc_khz);
+        return -EINVAL;
+    }
+
+    /* it's safe even env->tsc_khz is 0. KVM uses host's tsc_khz in this case */
+    r = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, env->tsc_khz);
+    if (r < 0) {
+        error_setg_errno(errp, -r, "Unable to set TSC frequency to %ld kHz",
+                         env->tsc_khz);
+        return r;
+    }
+
     if (tdx_guest->mrconfigid) {
         g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
                               strlen(tdx_guest->mrconfigid), &data_len, errp);
-- 
2.34.1


