Return-Path: <kvm+bounces-30689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C50409BC5BD
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12177B233DA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F26A1FDFA3;
	Tue,  5 Nov 2024 06:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nU4BAzbw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A5619047D
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788819; cv=none; b=FJ32HzMNpLekH9bDLr2K/Lgl2QrOi5sAh5+I9r6r1wSEHE8fEM8dY4ypdTH0rboftMg+zEKNhH4oKUZzqyOm8duKRTyNvJS25QgtCrcuxKCR20+94T57wGoDMfRBYec+L+k15QUd//8O5IMgrI6PaD7JOhHPlzal4r3WdnH3h7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788819; c=relaxed/simple;
	bh=R3qGJveZ2fmuHjYuT93ENGzexAuyNwuq1EZaJ0+cqc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RfD3H3T5YMfjvxG3WU4IecUqV7wDx5HbMNU8tYhDuzvIANxAfSZc2rddziU9wpc2JCRXePjLDA42EKQ9MvkO6z0GilNTlqaLtpWkrvTRanXRldZTPgoB2cAN2Im/7R57VS2/ThiP9w1UYrSPwwSN0SJQ6JqkPL/NERtf8Diigf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nU4BAzbw; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788818; x=1762324818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R3qGJveZ2fmuHjYuT93ENGzexAuyNwuq1EZaJ0+cqc0=;
  b=nU4BAzbwUw6Dijc2oR1g8ZxpUtnnU5RiUx/ogKM6jIldaO9Zgs0hR6gJ
   wjzQecShgsMeHhpDPqmzYDTFxvShj5VLaAmZIGA0i/EPiCEPL5Kwf775e
   HRjMFj+ZUnYkF9uKhosUVLD6768Qy2qDfGlpJDpgUJTR8jSe3t6Pmgn3Q
   b+Lr63iz99SsULfaulFkUEtLXSDnx+nFAqcIx2TSqmHbYByQFJd4947hw
   MhySCLJcSa14+F8WDOEfKrhIk5/YsHPzu3tWPqi1URjjzUz5dsV9gkVlC
   MEhe29SFr2+Wnz97RaGq5jBWSkV9nczrBZeCAf0RIRqRtsovJD/D4cd2G
   Q==;
X-CSE-ConnectionGUID: dd2wNkVEQJq6qAIviLXmCQ==
X-CSE-MsgGUID: uHlpKDPpRL2noHRwlQQc7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689919"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689919"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:40:18 -0800
X-CSE-ConnectionGUID: cCHE70fzS4uPY/tjfHAGjA==
X-CSE-MsgGUID: 4cVcz/YWTguoW1CHzdYfFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83990026"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:40:14 -0800
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
Subject: [PATCH v6 55/60] i386/tdx: Fetch and validate CPUID of TD guest
Date: Tue,  5 Nov 2024 01:24:03 -0500
Message-Id: <20241105062408.3533704-56-xiaoyao.li@intel.com>
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

Use KVM_TDX_GET_CPUID to get the CPUIDs that are managed and enfored
by TDX module for TD guest. Check QEMU's configuration against the
fetched data.

Print wanring  message when 1. a feature is not supported but requested
by QEMU or 2. QEMU doesn't want to expose a feature while it is enforced
enabled.

- If cpu->enforced_cpuid is not set, prints the warning message of both
1) and 2) and tweak QEMU's configuration.

- If cpu->enforced_cpuid is set, quit if any case of 1) or 2).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 81 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e7e0f073dfc9..9cb099e160e4 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -673,6 +673,86 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
     return value;
 }
 
+
+static void tdx_fetch_cpuid(CPUState *cpu, struct kvm_cpuid2 *fetch_cpuid)
+{
+    int r;
+
+    r = tdx_vcpu_ioctl(cpu, KVM_TDX_GET_CPUID, 0, fetch_cpuid);
+    if (r) {
+        error_report("KVM_TDX_GET_CPUID failed %s", strerror(-r));
+        exit(1);
+    }
+}
+
+static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
+{
+    uint64_t actual, requested, unavailable, forced_on;
+    g_autofree struct kvm_cpuid2 *fetch_cpuid;
+    const char *forced_on_prefix = NULL;
+    const char *unav_prefix = NULL;
+    struct kvm_cpuid_entry2 *entry;
+    X86CPU *cpu = X86_CPU(cs);
+    CPUX86State *env = &cpu->env;
+    FeatureWordInfo *wi;
+    FeatureWord w;
+    bool mismatch = false;
+
+    fetch_cpuid = g_malloc0(sizeof(*fetch_cpuid) +
+                    sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
+    tdx_fetch_cpuid(cs, fetch_cpuid);
+
+    if (cpu->check_cpuid || cpu->enforce_cpuid) {
+        unav_prefix = "TDX doesn't support requested feature";
+        forced_on_prefix = "TDX forcibly sets the feature";
+    }
+
+    for (w = 0; w < FEATURE_WORDS; w++) {
+        wi = &feature_word_info[w];
+        actual = 0;
+
+        switch (wi->type) {
+        case CPUID_FEATURE_WORD:
+            entry = cpuid_find_entry(fetch_cpuid, wi->cpuid.eax, wi->cpuid.ecx);
+            if (!entry) {
+                /*
+                 * If KVM doesn't report it means it's totally configurable
+                 * by QEMU
+                 */
+                continue;
+            }
+
+            actual = cpuid_entry_get_reg(entry, wi->cpuid.reg);
+            break;
+        case MSR_FEATURE_WORD:
+            /*
+             * TODO:
+             * validate MSR features when KVM has interface report them.
+             */
+            continue;
+        }
+
+        requested = env->features[w];
+        unavailable = requested & ~actual;
+        mark_unavailable_features(cpu, w, unavailable, unav_prefix);
+        if (unavailable) {
+            mismatch = true;
+        }
+
+        forced_on = actual & ~requested;
+        mark_forced_on_features(cpu, w, forced_on, forced_on_prefix);
+        if (forced_on) {
+            mismatch = true;
+        }
+    }
+
+    if (cpu->enforce_cpuid && mismatch) {
+        return -1;
+    }
+
+    return 0;
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -1019,4 +1099,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->cpu_realizefn = tdx_cpu_realizefn;
     x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
+    x86_klass->check_features = tdx_check_features;
 }
-- 
2.34.1


