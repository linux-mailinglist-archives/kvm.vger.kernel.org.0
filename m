Return-Path: <kvm+bounces-26080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0FDE970784
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 14:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 553921F21972
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 12:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8383215F3F3;
	Sun,  8 Sep 2024 12:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H+b9qVAw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F916CDBA
	for <kvm@vger.kernel.org>; Sun,  8 Sep 2024 12:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725799419; cv=none; b=USQvPvEDyTg1U/huSRCvQ9DRLdMhIgZbs/YHvx1AG2mr0HOEjcTKn7NOcMGkqseqKZh87W/iA1szImprANb/1CBBE7FIpYvO7jdDv9xmQd3T+KqqbW6GHHAk5NayfKkRtRIU3ZYaMCwE3YFpcmyEcZtH85zhh7i7C1Vx3JEz/EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725799419; c=relaxed/simple;
	bh=TSPfc9jnTH+S6KC1J5SxKbz8GdCtnNY8LQlYPm781xo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QdoyRCDa4vkt/uMezsmu3rO28giIs4feS4ScGiKL18XMcg1yrAODdK6ToTrVwnQTOFHkU72azxksiHuxnC82lXuge+jb1C0EO4NOEUOloax5R0EV8aU0uZHBY0rUPMp2dG3+FZOF0lOKztiKXdNxSDqGQJs+QPDx8+/UPqrli4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H+b9qVAw; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725799418; x=1757335418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TSPfc9jnTH+S6KC1J5SxKbz8GdCtnNY8LQlYPm781xo=;
  b=H+b9qVAwMn7SKk8+I79nleiKXhNDpsUMOLxLEE65rVj+1XLes/tCQzxn
   dgrS+Z6YIK/dFZTuW5aIFxDZYlvvNZCNvw68v5IvtPmj2xBbKuRvhcL33
   B6geToH5hqlmCdYKQjJ+LujP3MmT+zH78hEdIGQUpUuMMQBf0GaCEjs+w
   UaqnW990DeZuD4DBTnGyEDTdxM6C5BTUwtnWYagHs8G074LvQZNYDLYsI
   7EwmJToAjQRLob0QsFNrtHbVtU5Tsa58ViXAqPWWAOGHYf9V7aM4HLO1m
   IvWp5EHrbu66pjUcy4M4o9JlG6EyIqygDPkb8/Kb5CIrXFM1jV3KlTiM4
   Q==;
X-CSE-ConnectionGUID: zxfpjCB6SEe6aorBFnwaDw==
X-CSE-MsgGUID: K5+ELlzKTlG+0BgvHRBCbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="28238137"
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="28238137"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 05:43:38 -0700
X-CSE-ConnectionGUID: AjKzOl2aREyuLMigLk23Mg==
X-CSE-MsgGUID: AsWhvwaES2qXYgNnMwSxEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="97196521"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 08 Sep 2024 05:43:32 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 2/7] qapi/qom: Define cache enumeration and properties
Date: Sun,  8 Sep 2024 20:59:15 +0800
Message-Id: <20240908125920.1160236-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240908125920.1160236-1-zhao1.liu@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The x86 and ARM need to allow user to configure cache properties
(current only topology):
 * For x86, the default cache topology model (of max/host CPU) does not
   always match the Host's real physical cache topology. Performance can
   increase when the configured virtual topology is closer to the
   physical topology than a default topology would be.
 * For ARM, QEMU can't get the cache topology information from the CPU
   registers, then user configuration is necessary. Additionally, the
   cache information is also needed for MPAM emulation (for TCG) to
   build the right PPTT.

Define smp-cache related enumeration and properties in QAPI, so that
user could configure cache properties for SMP system through -machine in
the subsequent patch.

Cache enumeration (CacheLevelAndType) is implemented as the combination
of cache level (level 1/2/3) and cache type (data/instruction/unified).

Currently, separated L1 cache (L1 data cache and L1 instruction cache)
with unified higher-level cache (e.g., unified L2 and L3 caches), is the
most common cache architectures.

Therefore, enumerate the L1 D-cache, L1 I-cache, L2 cache and L3 cache
with smp-cache object to add the basic cache topology support. Other
kinds of caches (e.g., L1 unified or L2/L3 separated caches) can be
added directly into CacheLevelAndType if necessary.

Cache properties (SmpCacheProperties) currently only contains cache
topology information, and other cache properties can be added in it
if necessary.

Note, define cache topology based on CPU topology level with two
reasons:

 1. In practice, a cache will always be bound to the CPU container
    (either private in the CPU container or shared among multiple
    containers), and CPU container is often expressed in terms of CPU
    topology level.
 2. The x86's cache-related CPUIDs encode cache topology based on APIC
    ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
    relies on also requires CPU containers to help indicate the private
    shared hierarchy of the cache. Therefore, for SMP systems, it is
    natural to use the CPU topology hierarchy directly in QEMU to define
    the cache topology.

Suggested-by: Daniel P. Berrange <berrange@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
Suggested by credit:
 * Referred to Daniel's suggestion to introduce cache object list.
---
Changes since Patch v1:
 * Renamed SMPCacheProperty/SMPCacheProperties (QAPI structures) to
   SmpCacheProperties/SmpCachePropertiesWrapper. (Markus)
 * Renamed SMPCacheName (QAPI structure) to SmpCacheLevelAndType and
   dropped prefix. (Markus)
 * Renamed 'name' field in SmpCacheProperties to 'cache', since the
   type and level of the cache in SMP system could be able to specify
   all of these kinds of cache explicitly enough.
 * Renamed 'topo' field in SmpCacheProperties to 'topology'. (Markus)
 * Returned error information when user repeats setting cache
   properties. (Markus)
 * Renamed SmpCacheLevelAndType to CacheLevelAndType, since this
   representation is general across SMP or hybrid system.
 * Dropped handwriten smp-cache object and integrated cache pproperties
   list into MachineState (in next patch). (Markus)
 * Added the reason why x86 and ARM need to configure cache
   information. (Markus and Jonathan)

Changes since RFC v2:
 * New commit to implement cache list with JSON format instead of
   multiple sub-options in -smp.
---
 qapi/machine-common.json | 50 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/qapi/machine-common.json b/qapi/machine-common.json
index 148a2c8dccca..f6fe1a208214 100644
--- a/qapi/machine-common.json
+++ b/qapi/machine-common.json
@@ -63,3 +63,53 @@
 { 'enum': 'CpuTopologyLevel',
   'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
             'die', 'socket', 'book', 'drawer', 'default' ] }
+
+##
+# @CacheLevelAndType:
+#
+# Caches a system may have.  The enumeration value here is the
+# combination of cache level and cache type.
+#
+# @l1d: L1 data cache.
+#
+# @l1i: L1 instruction cache.
+#
+# @l2: L2 (unified) cache.
+#
+# @l3: L3 (unified) cache
+#
+# Since: 9.1
+##
+{ 'enum': 'CacheLevelAndType',
+  'data': [ 'l1d', 'l1i', 'l2', 'l3' ] }
+
+##
+# @SmpCacheProperties:
+#
+# Cache information for SMP system.
+#
+# @cache: Cache name, which is the combination of cache level
+#     and cache type.
+#
+# @topology: Cache topology level.  It accepts the CPU topology
+#     enumeration as the parameter, i.e., CPUs in the same
+#     topology container share the same cache.
+#
+# Since: 9.1
+##
+{ 'struct': 'SmpCacheProperties',
+  'data': {
+  'cache': 'CacheLevelAndType',
+  'topology': 'CpuTopologyLevel' } }
+
+##
+# @SmpCachePropertiesWrapper:
+#
+# List wrapper of SmpCacheProperties.
+#
+# @caches: the list of SmpCacheProperties.
+#
+# Since 9.1
+##
+{ 'struct': 'SmpCachePropertiesWrapper',
+  'data': { 'caches': ['SmpCacheProperties'] } }
-- 
2.34.1


