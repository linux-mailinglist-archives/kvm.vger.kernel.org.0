Return-Path: <kvm+bounces-20930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD394926DC1
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68654281E29
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DED11B7F7;
	Thu,  4 Jul 2024 03:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YbAaVeb8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025951B7E4
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062060; cv=none; b=DpxKIn2L61oAIRVdCJ5QOugZxmoNxT9ygt6SFq6b6WQ/Bn/l3tFKENCkyd9BXhftjZ26UmMMdGFFsRe2a1BCJPiZQGYUUoHBa8n8IrCg1vTx1m/wXPqNurzMzOocgryAs4O8OU+mHais8oX/HvhTHXWA31rWwocRE3FSAOfnsJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062060; c=relaxed/simple;
	bh=WvA5kdecwjQmICQjAc3CQ0RARFRwW0D39pFCdSGsMJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BFlyljBrCYQe7LwHMEPHarh6V3jF6rxHQ+4UB8mmbZuOItmvQRrP6PFda/kRfEyTkRLHZINKYnPy8H5xKGV0tFnV4ZPxC7XeHbKYTrrlBYUPMZcYzME5cdpBAiLrM04iJCXsesWFqY3FLNGONe5uf7dJ7mcjSSgP/Y5bkKrrj1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YbAaVeb8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720062059; x=1751598059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WvA5kdecwjQmICQjAc3CQ0RARFRwW0D39pFCdSGsMJs=;
  b=YbAaVeb8JTvukClQ3YQxtjlV/f8CZcPZejVEd5GHGSQnb2FEy3lMQlQE
   Dw3ysBCsrXkddGKPfB8bFlL7f6RJpD86lm6cCS8RjnFG+ul0FcTObUpEn
   uRd1IjUuksdvZBHmo+dtlJafexaiWNAo+D7VdTH8sxOMj5sMkTSh8HNr8
   3byyEplsI8E7EWIjdsn1a6DwH4UR4x2yxcav7+TMNH5DdVrZ+qa34xzdw
   9VWk6vLln4JJK1olrGGy99ej1VMxOvI7yRx0vO0Zg9RXaWyUDy0P27pMy
   orczIOJPhMPbkdITtwxcR9uYMRv51vLr/wO1ilFacS4v8HzoMIUmq7HVC
   A==;
X-CSE-ConnectionGUID: o/O3ql/uTA2li+aJRcC3SQ==
X-CSE-MsgGUID: tYrboT8cR5ivrenxfxhDJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39838132"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="39838132"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 20:00:58 -0700
X-CSE-ConnectionGUID: QYzkN/9dTKaDrPxBswrhTQ==
X-CSE-MsgGUID: iWwTKPgkQhy4cReKgVsBCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51052354"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2024 20:00:53 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 5/8] i386/cpu: Support thread and module level cache topology
Date: Thu,  4 Jul 2024 11:16:00 +0800
Message-Id: <20240704031603.1744546-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240704031603.1744546-1-zhao1.liu@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allows cache to be defined at the thread and module level. This
increases flexibility for x86 users to customize their cache topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4ae3bbf30682..0ddbfa577caf 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -241,9 +241,15 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     uint32_t num_ids = 0;
 
     switch (share_level) {
+    case CPU_TOPO_LEVEL_THREAD:
+        num_ids = 1;
+        break;
     case CPU_TOPO_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
+    case CPU_TOPO_LEVEL_MODULE:
+        num_ids = 1 << apicid_module_offset(topo_info);
+        break;
     case CPU_TOPO_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
@@ -251,10 +257,6 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
         num_ids = 1 << apicid_pkg_offset(topo_info);
         break;
     default:
-        /*
-         * Currently there is no use case for THREAD and MODULE, so use
-         * assert directly to facilitate debugging.
-         */
         g_assert_not_reached();
     }
 
-- 
2.34.1


