Return-Path: <kvm+bounces-45914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 044E8AAFE72
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1495F166C00
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206C8280A38;
	Thu,  8 May 2025 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kvhMSa8P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC03C280A21
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716729; cv=none; b=HTyhGYh/oqebPjlyJKFR67J0wvtJTzl/m4eUqzBcU5JwZMtlqXTL9f9v1HGpJRqbk7szvkOlBPZqAt3NZ0Y6p3U/6Q+e7lJEebzxxnwZPqo6JAwgRihnImn5iKzxBShjWr65aq2IcZBiTx13zQqsIi0rBp7qJs7A5dzhwZKOhqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716729; c=relaxed/simple;
	bh=vnMToofY2qJOL3v3hWuDrcIkydTbCN84hUfygyo1j2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJRinQMWArd/f1fzgFR2dbk+EW0wfUmsXLA3Mt4ez/UQyuQUfs9JUCtmMi0vJ9eLNkB1nGp33YG/0rABwrjGglk7KjducWEdlosPovFHv0stpxRb91HZeTr5QDP8ionVQURT/MywqfZFG8Wmh7WuqgIIoH34EdSIc5kfgDVxMfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kvhMSa8P; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716728; x=1778252728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vnMToofY2qJOL3v3hWuDrcIkydTbCN84hUfygyo1j2E=;
  b=kvhMSa8PeBhLCSzj1+lZjqQA93O5fdVOY3WqpSoep4K6YfkkrEuIeqXH
   yb1QXbB2/Xy4djUzAztjkt6h/B48b7RWniukrf8Psx2KGB5kYedFHeZh8
   0JND/v3aNs56CkuDAfvgczFgC1rdqpMs+7Ee59T1KGrfDZnK7xuwMddGs
   VLajObNXcqwh9MS1RWE5+BOS6gID2YY/CaxhaoTsKcRKQ5zKfMLP819YQ
   c1m6cgYIiqjSDY/zcjJuUNTw4cirK26kDyyvM22uxfghpJaTCVq+ItslL
   PRcOJAliawH5B4Pq2DXBPme48EnDNaBdC3BTEnxaWQcQe5/lMhrHerVw2
   g==;
X-CSE-ConnectionGUID: IXcviAZAQ/mGHizeEB/W8g==
X-CSE-MsgGUID: QyDJBQuqT1KKcNu7q1KFHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888074"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888074"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:27 -0700
X-CSE-ConnectionGUID: RVsEO63ITf6lE+52aWju/Q==
X-CSE-MsgGUID: Vx4uLwc0Slevt1UJzBmdig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439867"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:25 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 11/55] i386/tdx: Wire CPU features up with attributes of TD guest
Date: Thu,  8 May 2025 10:59:17 -0400
Message-ID: <20250508150002.689633-12-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For QEMU VMs,
  - PKS is configured via CPUID_7_0_ECX_PKS, e.g., -cpu xxx,+pks  and
  - PMU is configured by x86cpu->enable_pmu, e.g., -cpu xxx,pmu=on

While the bit 30 (PKS) and bit 63 (PERFMON) of TD's attributes are also
used to configure the PKS and PERFMON/PMU of TD, reuse the existing
configuration interfaces of 'cpu' for TD's attributes.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 2ed40b76141a..1ab063f790d9 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,8 @@
 #include "tdx.h"
 
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+#define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
+#define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
 static TdxGuest *tdx_guest;
 
@@ -151,6 +153,15 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
 }
 
+static void setup_td_guest_attributes(X86CPU *x86cpu)
+{
+    CPUX86State *env = &x86cpu->env;
+
+    tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
+                             TDX_TD_ATTRIBUTES_PKS : 0;
+    tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
+}
+
 static int setup_td_xfam(X86CPU *x86cpu, Error **errp)
 {
     CPUX86State *env = &x86cpu->env;
@@ -214,6 +225,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
+    setup_td_guest_attributes(x86cpu);
+
     r = setup_td_xfam(x86cpu, errp);
     if (r) {
         return r;
-- 
2.43.0


