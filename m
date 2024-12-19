Return-Path: <kvm+bounces-34124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A5009F7700
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AB7F188166A
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957FE217667;
	Thu, 19 Dec 2024 08:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EsS0dMTW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C321FAC26
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 08:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734596085; cv=none; b=fBgAGZToYwOrN7cewH4mAPwJDPlR1Dbmt++1BzCfV2Q6u/NJ2DxF364WOLd3Mf8IR2p++yianPkHQW38XkMby/Ou9cPYqP5QRhdW/9tWhCxdrO6FKEl44Gqn9eDuP3IYom2cVZm10FExCWyrWAOTDQGgyJPaF30y9IyzH5zsYXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734596085; c=relaxed/simple;
	bh=HyQNL2QRST3bzAofC6NdSneNk+dJQgGE9UE8ka+3X3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T7F49XC3DIlniE5/S7cdFGCL0n6gm30jeJpTPSegeGYsORKa2KBzXWHkDD0voBczPZmnwiu6E/GmUzXBfXc7aZ9jvGKWZRyNGy5bVNzpAp7sksqbYFSS3dnjrQ1AFjdCV6fp+DtmW+6W5fNAryTugFI153G+mj/iD5jc3PjyyKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EsS0dMTW; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734596084; x=1766132084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HyQNL2QRST3bzAofC6NdSneNk+dJQgGE9UE8ka+3X3M=;
  b=EsS0dMTWK93HgjzXjskQKv4aUACO+m2N3o0pnNrMSctCA+CwUC2jXKfd
   vf8w1rArVtjAo8wfDHK4+YNxwh08GXcsuOC8iQebda6fAOD/3TF6b3nmU
   80uc67ySUdOfokCGtI6bYB7ftjZ8fEvAh0pq8qhq1xDore7zZJM7Min3x
   p0ErETiz/yjnBD8zh4U6NnMOx94pibVjnKZyKfr9AFakwLVkCqBffWWcc
   o/uKShYbsrB12YQd3DKe75yc8NM8HQ36iUH56n1GTSCBXTcwxInQb0J2m
   6APP5vGW5HgTdlZALqtY8bopd+zIOQ6lY/HLsnpOzQ2QFLWeeYdtgP7qN
   g==;
X-CSE-ConnectionGUID: 5jUce27PRxKkJZg3cRlBKg==
X-CSE-MsgGUID: kx2mfKYQRY+628XaEvsn7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="34378672"
X-IronPort-AV: E=Sophos;i="6.12,247,1728975600"; 
   d="scan'208";a="34378672"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 00:14:29 -0800
X-CSE-ConnectionGUID: 6Zn6Kp97QoubQDBwujTxcw==
X-CSE-MsgGUID: 3p7A14JdQe+SIqaC6tm+xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="129097570"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 19 Dec 2024 00:14:26 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 4/4] i386/cpu: add has_caches flag to check smp_cache configuration
Date: Thu, 19 Dec 2024 16:32:37 +0800
Message-Id: <20241219083237.265419-5-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241219083237.265419-1-zhao1.liu@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alireza Sanaee <alireza.sanaee@huawei.com>

Add has_caches flag to SMPCompatProps, which helps in avoiding
extra checks for every single layer of caches in x86 (and ARM in
future).

Signed-off-by: Alireza Sanaee <alireza.sanaee@huawei.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Note: Picked from Alireza's series with the changes:
 * Moved the flag to SMPCompatProps with a new name "has_caches".
   This way, it remains consistent with the function and style of
   "has_clusters" in SMPCompatProps.
 * Dropped my previous TODO with the new flag.
---
Changes since Patch v2:
 * Picked a new patch frome Alireza's ARM smp-cache series.
---
 hw/core/machine-smp.c |  2 ++
 include/hw/boards.h   |  3 +++
 target/i386/cpu.c     | 11 +++++------
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index b954eb849027..fe66961341fe 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -325,6 +325,8 @@ bool machine_parse_smp_cache(MachineState *ms,
             return false;
         }
     }
+
+    mc->smp_props.has_caches = true;
     return true;
 }
 
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 5723ee76bdea..c647e507d1a9 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -156,6 +156,8 @@ typedef struct {
  * @modules_supported - whether modules are supported by the machine
  * @cache_supported - whether cache (l1d, l1i, l2 and l3) configuration are
  *                    supported by the machine
+ * @has_caches - whether cache properties are explicitly specified in the
+ *               user provided smp-cache configuration
  */
 typedef struct {
     bool prefer_sockets;
@@ -166,6 +168,7 @@ typedef struct {
     bool drawers_supported;
     bool modules_supported;
     bool cache_supported[CACHE_LEVEL_AND_TYPE__MAX];
+    bool has_caches;
 } SMPCompatProps;
 
 /**
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index bd5620dcc086..a9700fba991f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8039,13 +8039,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
 #ifndef CONFIG_USER_ONLY
     MachineState *ms = MACHINE(qdev_get_machine());
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
 
-    /*
-     * TODO: Add a SMPCompatProps.has_caches flag to avoid useless updates
-     * if user didn't set smp_cache.
-     */
-    if (!x86_cpu_update_smp_cache_topo(ms, cpu, errp)) {
-        return;
+    if (mc->smp_props.has_caches) {
+        if (!x86_cpu_update_smp_cache_topo(ms, cpu, errp)) {
+            return;
+        }
     }
 
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
-- 
2.34.1


