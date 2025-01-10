Return-Path: <kvm+bounces-35051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D64A1A09388
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:33:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5B40188BE5F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1079211285;
	Fri, 10 Jan 2025 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nyL4YDzX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEAB21127E
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519580; cv=none; b=cB1iXcJfEhZEM/Bq52yP5Dmken+1DCnHUDbZ/lMRR1KBM2Ey3MmK9xAwxGYTOrocFeQKq+tmJ+KDQ5XZQUQqajgTaxOX37bzRJ3MnvSIhuJTyymVI+YzBQC4Y2tfhXfkZPZR4aH4Ye1h+ITw9CjP2d0ZZ8Bu8AsHhJtNcxichys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519580; c=relaxed/simple;
	bh=shkMAuvJ+JiK4YmkroyLIrAGyT0tA05DVR9Yl2i03nc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZxQvMUlznP8sz8JaqLXDFCUrTEsdAq0utAomKrt4Q5gKtGNpIUwSH8lOXnYYL6ik2NH5Ceu3RdeXH5a14Nz7bMtYDERvi3tk1sb4YDfQ/TMQw0YI5QwJ0izou2zbKGhwDftBUeyEOUYvHTGhuWzOSZYEJQQ4IUYlhdHDiOvklR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nyL4YDzX; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736519578; x=1768055578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=shkMAuvJ+JiK4YmkroyLIrAGyT0tA05DVR9Yl2i03nc=;
  b=nyL4YDzXTW58bgUeh/1oePOEy7CKuiHygMS27wkfcNz8wbegR19ynbLy
   KWhfIuilUb2BYw3B07gLwbeATl41+0p9B/zbj7AsEkUvaRfO58GPSAGNe
   70pXbeMj87s/9aMsQtMSAmLEGfWFuQ7teQ/Ht/Lc/W0VLd8JglFCbQovv
   hcoyTaw+Thti2TZMtMWcmFTYk2xf8zBHR3ln6cLF7xFvFp4Ki00lp7r4q
   +rIYmGHhqYUF+OLN0pSkEaqMqdfNCneeAfFEKTgkIngYa1VDy5UEo4faF
   mkd6xuFOJWE2EfPAajn0feCyODkV4dhFVnBwjTjv1WVa7H6ThPu8xoDGu
   A==;
X-CSE-ConnectionGUID: +9eHlFFtT+WtvLi9pusB4w==
X-CSE-MsgGUID: q2XgREvoS8y0debrlN7WvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11311"; a="62185510"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="62185510"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 06:32:58 -0800
X-CSE-ConnectionGUID: 2NcUn1NuQvmTeIli9EwbPg==
X-CSE-MsgGUID: 9odVbZt2TUO8rdPBwBuRkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108790834"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 10 Jan 2025 06:32:54 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v7 RESEND 2/5] i386/cpu: Support module level cache topology
Date: Fri, 10 Jan 2025 22:51:12 +0800
Message-Id: <20250110145115.1574345-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250110145115.1574345-1-zhao1.liu@intel.com>
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow cache to be defined at the module level. This increases
flexibility for x86 users to customize their cache topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Changes since Patch v6:
 * Dropped "thread" level cache topology support.
---
 target/i386/cpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 660ddafc28b5..4728373fdf03 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -247,6 +247,9 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     case CPU_TOPOLOGY_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
+    case CPU_TOPOLOGY_LEVEL_MODULE:
+        num_ids = 1 << apicid_module_offset(topo_info);
+        break;
     case CPU_TOPOLOGY_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
@@ -255,7 +258,7 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
         break;
     default:
         /*
-         * Currently there is no use case for THREAD and MODULE, so use
+         * Currently there is no use case for THREAD, so use
          * assert directly to facilitate debugging.
          */
         g_assert_not_reached();
-- 
2.34.1


