Return-Path: <kvm+bounces-36498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B412EA1B6EE
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B24A8188C82E
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75EAF73176;
	Fri, 24 Jan 2025 13:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sjxskbv7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D22D42AB0
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725871; cv=none; b=BY0yuq04dLz0YYFsY4xc9dH7UoPhecFnav9fJMGyFUmvdX70UPaDO3wDG8aiG9NDkI0mxqYUgis/xbgJhyrL+2edAudl3l6cLj7DY9Vyp2E9+nSzC0XlDNW2tCTYg3TzUa7T8UgCTcf5jx825/wOwKLVTTedrBfmO0kaiAN5OJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725871; c=relaxed/simple;
	bh=qmNZXY74mhCvcHjPeZ7Zt9Eiiug9SdAA9hSZ2NO+cEA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ugqksWeaZK3FfdbNSc3A7cZS4Z+WqAAZyL6RYIoiMXhGYQpwmTLFJEcefblfu7sWlUWjhJSEy6zzCnIZP+4SLR6GRFlp91fAuUHVSI7QTFiR/exEva583bTc1jMjdbNndejIh3iacp+AfPoAkbIDfxufYAdu2fdeskD0GZBRAMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sjxskbv7; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725870; x=1769261870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qmNZXY74mhCvcHjPeZ7Zt9Eiiug9SdAA9hSZ2NO+cEA=;
  b=Sjxskbv7wVXNSzC5OJM7WiZVyArSdJQDqtYG16eajiiYiTCmd1k7YFHr
   pdpY4m547op6WuaKyeZTo5SzbbHrImUdtk0TDEaTL7VIJhOIUrtwhbShF
   VE+F+BOLhLsLoURK3kMltcqYFFjqCRoZjlkeutOh2+C048WW3I8iMREMQ
   xFhDFhs+wjzKDoYKW7wh3AtpJGR+9JhTCwLF7MAiWdrYO77oTWZNZYWEH
   E2BqJXyb8kCSDTjwlhru6Xn3J39BzG8FDBaw77wLVPHOAWsMfjv7cNMkt
   zUMH7/78xRF4U0b3qMdL2oqjjkRz0YRHoC+2evnTwi7D0Zc9R+QfeEFWM
   Q==;
X-CSE-ConnectionGUID: UGZelB2qRZGPQ9sqz3xIWw==
X-CSE-MsgGUID: OMiaV9oRQFeJSkrgIJxCZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246273"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246273"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:50 -0800
X-CSE-ConnectionGUID: p75RpVOpQQqG+e6CaUHL2Q==
X-CSE-MsgGUID: hw4H65BBSYm+zmpJJIXQkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804209"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:46 -0800
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
Subject: [PATCH v7 13/52] i386/tdx: Set APIC bus rate to match with what TDX module enforces
Date: Fri, 24 Jan 2025 08:20:09 -0500
Message-Id: <20250124132048.3229049-14-xiaoyao.li@intel.com>
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

TDX advertises core crystal clock with cpuid[0x15] as 25MHz for TD
guests and it's unchangeable from VMM. As a result, TDX guest reads
the APIC timer as the same frequency, 25MHz.

While KVM's default emulated frequency for APIC bus is 1GHz, set the
APIC bus rate to match with TDX explicitly to ensure KVM provide correct
emulated APIC timer for TD guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
 - new patch;
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 target/i386/kvm/tdx.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index ed843af1d0b6..96138c2d2b73 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -253,6 +253,19 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
+    if (!kvm_check_extension(kvm_state, KVM_CAP_X86_APIC_BUS_CYCLES_NS)) {
+        error_setg(errp, "KVM doesn't support KVM_CAP_X86_APIC_BUS_CYCLES_NS");
+        return -EOPNOTSUPP;
+    }
+
+    r = kvm_vm_enable_cap(kvm_state, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+                          0, TDX_APIC_BUS_CYCLES_NS);
+    if (r < 0) {
+        error_setg_errno(errp, -r,
+                         "Unable to set core crystal clock frequency to 25MHz");
+        return r;
+    }
+
     if (tdx_guest->mrconfigid) {
         g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
                               strlen(tdx_guest->mrconfigid), &data_len, errp);
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index e472b11fb0dd..d39e733d9fcc 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -16,6 +16,9 @@ typedef struct TdxGuestClass {
     X86ConfidentialGuestClass parent_class;
 } TdxGuestClass;
 
+/* TDX requires bus frequency 25MHz */
+#define TDX_APIC_BUS_CYCLES_NS 40
+
 typedef struct TdxGuest {
     X86ConfidentialGuest parent_obj;
 
-- 
2.34.1


