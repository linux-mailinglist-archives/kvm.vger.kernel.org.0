Return-Path: <kvm+bounces-67011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F36CF23EC
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 08:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CA6E7300B68E
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 07:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9743D2DAFBB;
	Mon,  5 Jan 2026 07:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aTH9EjyG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F84B2D839F;
	Mon,  5 Jan 2026 07:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767599036; cv=none; b=hgjIP/7yRQUjVe76FBlfcTETrMfyM4IiSwKkF++Cei5KAjPt5Vw5dp0/iOulZOX3ahDDOSpx76ev8EWRvvVDJU+keZGFFZc/oyN4P9x/9Gpy9714IHTI+yDGoElG59ocDiL72yRaxSW6hcJgF0ry/76+iHMmR2+H7fGV3xvZ0pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767599036; c=relaxed/simple;
	bh=on1iStjClW+lJkJ3X9Vw4QkQuB8Ww7b1fEyqqUMdF30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xnv977FcAn+ua+yi2ft2flDcDOZCDuoGhOKRrvLmWVMjnep27Z/l2NFBeDL3KT0L5R62fzInuGB7VCqhAa/tMznz9/t1bTQK3M4rID3du2iayP0bf6m4V3vznHxDAIXSgUDcDS6PMiF2nbCuOYzjYCt+Xt+dvduLfK8oVGhyGEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aTH9EjyG; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767599035; x=1799135035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=on1iStjClW+lJkJ3X9Vw4QkQuB8Ww7b1fEyqqUMdF30=;
  b=aTH9EjyGRj2ek9Hln8I93r2e6G/mz8PVZAVAC1vW69KU72EY1lzqthCi
   5v13T0Ku5dPIjl+UP7Z6AyeRC/NfSFi2ZMp7jN6ZYdWwFKp66sJA3dgWw
   GKuphEvKXpUKWfUG6V0Wb1/8f4gMCwB3bivpaI+gZQ6M8ubuRSD07Dnv+
   Kt/nKHKRwF0jSVgtaQaR4jewamb7sz4rsuV9Hh3n4xycQkuoJWbdOpBSE
   PnMt8NEkC3i8j0In2uwrVFBZDGcsGUpU7Cp7sO83CnaevfWP/OtRFWqwL
   V3hasnzOf8Mw46nqNneudWFm3PDv1n5sw3hCuaBbgZa7M/JOtcQoZTWCg
   A==;
X-CSE-ConnectionGUID: ennwjxscTzSyJJgXgvVavA==
X-CSE-MsgGUID: 8+omKWwQQfKDHSppFFkslQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11661"; a="69012575"
X-IronPort-AV: E=Sophos;i="6.21,203,1763452800"; 
   d="scan'208";a="69012575"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2026 23:43:54 -0800
X-CSE-ConnectionGUID: wDjuU+LCTkCOvPM3R4TM4w==
X-CSE-MsgGUID: zxeipqbtQMaifeicVrt9Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,203,1763452800"; 
   d="scan'208";a="239799059"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2026 23:43:54 -0800
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: vishal.l.verma@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	vannapurve@google.com,
	Chao Gao <chao.gao@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 2/3] coco/tdx-host: Expose TDX Module version
Date: Sun,  4 Jan 2026 23:43:45 -0800
Message-ID: <20260105074350.98564-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105074350.98564-1-chao.gao@intel.com>
References: <20260105074350.98564-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently there is no way to know the TDX Module version from the
userspace. Such information is always helpful for bug reporting or
debugging.

With the tdx-host device in place, expose the TDX Module version as
a device attribute via sysfs.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v2: 
 - No need to update MAINTAINERS to include sysfs-devices-faux-tdx-host
   explicitly (Kirill)

 .../ABI/testing/sysfs-devices-faux-tdx-host   |  6 +++++
 drivers/virt/coco/tdx-host/tdx-host.c         | 26 ++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-faux-tdx-host

diff --git a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
new file mode 100644
index 000000000000..35ef21f53c2e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
@@ -0,0 +1,6 @@
+What:		/sys/devices/faux/tdx_host/version
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) Report the version of the loaded TDX Module. The TDX Module
+		version is formatted as x.y.z, where "x" is the major version,
+		"y" is the minor version and "z" is the update version. Versions
+		are used for bug reporting, TD-Preserving updates and etc.
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index ced1c980dc6f..2883c6638faf 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -9,6 +9,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/device/faux.h>
 #include <asm/cpu_device_id.h>
+#include <asm/tdx.h>
 
 static const struct x86_cpu_id tdx_host_ids[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_TDX_HOST_PLATFORM, NULL),
@@ -18,12 +19,35 @@ MODULE_DEVICE_TABLE(x86cpu, tdx_host_ids);
 
 static struct faux_device *fdev;
 
+static ssize_t version_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	const struct tdx_sys_info *tdx_sysinfo = tdx_get_sysinfo();
+	const struct tdx_sys_info_version *ver;
+
+	if (!tdx_sysinfo)
+		return -ENXIO;
+
+	ver = &tdx_sysinfo->version;
+
+	return sysfs_emit(buf, "%u.%u.%02u\n", ver->major_version,
+					       ver->minor_version,
+					       ver->update_version);
+}
+static DEVICE_ATTR_RO(version);
+
+static struct attribute *tdx_host_attrs[] = {
+	&dev_attr_version.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(tdx_host);
+
 static int __init tdx_host_init(void)
 {
 	if (!x86_match_cpu(tdx_host_ids))
 		return -ENODEV;
 
-	fdev = faux_device_create(KBUILD_MODNAME, NULL, NULL);
+	fdev = faux_device_create_with_groups(KBUILD_MODNAME, NULL, NULL, tdx_host_groups);
 	if (!fdev)
 		return -ENODEV;
 
-- 
2.47.3


