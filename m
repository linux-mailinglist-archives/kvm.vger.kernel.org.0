Return-Path: <kvm+bounces-27113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CA997C28E
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7A9D286930
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FEE1BC44;
	Thu, 19 Sep 2024 01:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QEvkQmzC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FE512E75
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710059; cv=none; b=D/bPhXOhYTr7qjzlDcQuKzKHmR5fqU4RlDT/BJtON5bFSKo/GBHSLhsAio99Lhq15XWS2nYaMkcmdsnWZtPZw6SIB6ZH6RS2s1P9iERADQPH8tubEPhq94VdbzU1VZtCZx8is/HQe41mc0mu0WrpHMTCsdQGsViEsxkdm8O+vYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710059; c=relaxed/simple;
	bh=yof4pkElgDw/rHKl12O9snBHTn5fw7x3AIk3IaZiwVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DT4Ac54507VCjtUiyZPBQ/gvIDK/FPJhMuviyRI7cyZcB68nJ9lv4OfASa00cEnyU+M/AqZ5AOq5bqZWqCDHtUpN5Dj7zTTaxCseBAUp1TOMViIbcXb7EYowGfgGKVYDQbpKMlPIkpyC7PIykkalsEv2rVhXb+eyQf16B39QoVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QEvkQmzC; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710058; x=1758246058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yof4pkElgDw/rHKl12O9snBHTn5fw7x3AIk3IaZiwVQ=;
  b=QEvkQmzCSXQLIzMCI3SpJUWWEDgqMufrLdjMfLmMaU7bcjwX3hzLg9sr
   vPHLSx6UJs2p+qFkjECCuv2R4umaiq9mcHRerye8njJ+Rm+rzSSbOgdA1
   NsgF7uzfxXvhJAA7CtUl2JMvtY1amApI9IxzuOiGEE3rJRyK7mbsVVyvZ
   iScRFqSw8/sY5J3NoWCdMdTTvFwdvHJoS+1NtElevKKlDayXCt4aUG+Bz
   93e99Es5/dvl71W8xlDK/av8IjIe1kM2X24Xn1kw+QcVRfnbnz6ayohG0
   qGvQ8YLQpc2fMkcW2wywv6pLM5Nulem66F4QRC10mYWFYs7EPKsRls6S2
   Q==;
X-CSE-ConnectionGUID: VcCBLL2pR+KXHZc0U5c5Xw==
X-CSE-MsgGUID: O4npQ0yqQmS4aME34IK0WA==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25798039"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25798039"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:40:58 -0700
X-CSE-ConnectionGUID: nl6/vbvKRUyF+/RLJLKJoA==
X-CSE-MsgGUID: zZt2sOthQ+SFZ3bJiPNv0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058946"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:40:52 -0700
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
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 11/15] hw/core: Support topology tree in none machine for compatibility
Date: Thu, 19 Sep 2024 09:55:29 +0800
Message-Id: <20240919015533.766754-12-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919015533.766754-1-zhao1.liu@intel.com>
References: <20240919015533.766754-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

None machine accepts any CPU types, even some CPUs may have the
bus_type.

To address this, set topo_tree_supported as true for none machine, then
none machine will have a CPU slot with CPU bus to collect any topology
device with bus_type specified.

And since arch_id_topo_level is not set, the topology devices will be
directly inserted under the CPU slot without being organized into a tree
structure.

For the CPUs without bus_type, topo_tree_supported will not affect them.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/null-machine.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/core/null-machine.c b/hw/core/null-machine.c
index f586a4bef543..101649f3e8c1 100644
--- a/hw/core/null-machine.c
+++ b/hw/core/null-machine.c
@@ -54,6 +54,11 @@ static void machine_none_machine_init(MachineClass *mc)
     mc->no_floppy = 1;
     mc->no_cdrom = 1;
     mc->no_sdcard = 1;
+    /*
+     * For compatibility with arches and CPUs that already
+     * support topology tree.
+     */
+    mc->smp_props.topo_tree_supported = true;
 }
 
 DEFINE_MACHINE("none", machine_none_machine_init)
-- 
2.34.1


