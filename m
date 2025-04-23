Return-Path: <kvm+bounces-43920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A05A9887F
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 514C74440A8
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7248126FA7E;
	Wed, 23 Apr 2025 11:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dsTdrOYL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C3026FA5D
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407576; cv=none; b=eZ2mKpcvJGRV11/x8Wak6zBbPdsibhSXXBxRNjPxkCZLG2Yu29wJscIavhZRNY/97+xDcR00a+SSXrVUcvqrCEux6Q98d6Lnklw3TBg5lX6G4Aghn/gyPSOLl1dt4cvDGvQZsA5oIp16xKlzOSJ4BPBeOstforFF0VlzQ75rKxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407576; c=relaxed/simple;
	bh=hFmCDh1g6jFUGO8m7NQhmZ+M7gV0kLnTguTu4AQJhYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=amg4grR2/fVApJ/8AG6tZTXYJhOGqJjgYiVsB+Fd4qre5BqKPXv9hmWFC6w/JUOLrxfxdJ7h46dzi5vhQvaxUXfu2dJW36F0FF5yZckJQHlCKa2UzKCOdpoMM2D9c9AwJ5VBytX6a6oDSBKlKmb0RXYhPEvHdUtmalHcE55Ok/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dsTdrOYL; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745407575; x=1776943575;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hFmCDh1g6jFUGO8m7NQhmZ+M7gV0kLnTguTu4AQJhYA=;
  b=dsTdrOYL6ubJRuyor9fCfirxF2ybd+WskJp6lC9gbU2OQ3o8yIkjSuqi
   6VaZ9FPHJQr4FcpjcXDzlxSMdWP4l7aw9ECjhAOp53JeK4Crp1rgyjELu
   B9b+By1G/YUSIqDHIUXXC708ZFcB7OAv4/SFaYKHIHu3qCbmZgV+ACrVR
   Bxb2FecA5hpoEXT7doy6QvHeEoKWsrceG1FeXns7KMQeABbR/94wCW/wa
   LexUMLganHjo2xPbI3v6wDXcnY00Abwtahd65DxKY1FYLsiOUQlI9ILO8
   s1YmZ3h4MCQEFT+YgzwWdQCj5Dy/eYlYpbzjGoWVibM1oY7vfCzQ3nCvk
   g==;
X-CSE-ConnectionGUID: oFwGaZ/ERaK8vOvNhhP9fw==
X-CSE-MsgGUID: dzmWY5x5Si+891iKLWlMTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50825253"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50825253"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 04:26:14 -0700
X-CSE-ConnectionGUID: tsvDa8cqR0qLIgIGbl3vlA==
X-CSE-MsgGUID: FVISKOKWSki5mLfx20fGug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137150725"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 23 Apr 2025 04:26:11 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for Intel
Date: Wed, 23 Apr 2025 19:46:53 +0800
Message-Id: <20250423114702.1529340-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250423114702.1529340-1-zhao1.liu@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Per SDM, 0x80000005 leaf is reserved for Intel CPU, and its current
"assert" check blocks adding new cache model for non-AMD CPUs.

Therefore, check the vendor and encode this leaf as all-0 for Intel
CPU. And since Zhaoxin mostly follows Intel behavior, apply the vendor
check for Zhaoxin as well.

Note, for !vendor_cpuid_only case, non-AMD CPU would get the wrong
information, i.e., get AMD's cache model for Intel or Zhaoxin CPUs.
For this case, there is no need to tweak for non-AMD CPUs, because
vendor_cpuid_only has been turned on by default since PC machine v6.1.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1b64ceaaba46..8fdafa8aedaf 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7248,11 +7248,23 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
         break;
     case 0x80000005:
-        /* cache info (L1 cache) */
-        if (cpu->cache_info_passthrough) {
+        /*
+         * cache info (L1 cache)
+         *
+         * For !vendor_cpuid_only case, non-AMD CPU would get the wrong
+         * information, i.e., get AMD's cache model. It doesn't matter,
+         * vendor_cpuid_only has been turned on by default since
+         * PC machine v6.1.
+         */
+        if (cpu->vendor_cpuid_only &&
+            (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
+            *eax = *ebx = *ecx = *edx = 0;
+            break;
+        } else if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
         }
+
         *eax = (L1_DTLB_2M_ASSOC << 24) | (L1_DTLB_2M_ENTRIES << 16) |
                (L1_ITLB_2M_ASSOC <<  8) | (L1_ITLB_2M_ENTRIES);
         *ebx = (L1_DTLB_4K_ASSOC << 24) | (L1_DTLB_4K_ENTRIES << 16) |
-- 
2.34.1


