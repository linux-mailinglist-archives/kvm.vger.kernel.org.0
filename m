Return-Path: <kvm+bounces-63323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 557BAC621FD
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:41:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id BACC922957
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD4A27A93C;
	Mon, 17 Nov 2025 02:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F5/gR/i7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557B2265CC2;
	Mon, 17 Nov 2025 02:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347159; cv=none; b=lnmrPvkeZ/AtMn0W4zW7eqOTjgn1BlNILudg9pG98nIhOrG8XMIzje7EPmeqZaVK7i6IL92OBIi6wPtOaepGkBMjThdWh+y1supK9Dvm7Cw1fJHeH8ryzrdsxWH0pzEpO0kssSCtLnTqrMvIc+J8ONKgDJy7X/mnEhC+jFZIuUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347159; c=relaxed/simple;
	bh=iSTuohrg+XJ3ivn4vxqx8xkJMwzfmBlJ4y83e8nV+Sc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iS7ciDD8KF3zK5UWcs2oftXvAdAK5WYD59LYlGnJoOWLfdXAvPTsc1zYiASUlq9/4bqnkDqFBRbB6JQbj9+B2Wje3rp6ntqd4O7K9qzMfmd1sO+Fcj4eYouGD2POhFwmMaOXRe11pdGxdMCMwA06jAERWiWIJ/voeu69F+meXig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F5/gR/i7; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347159; x=1794883159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iSTuohrg+XJ3ivn4vxqx8xkJMwzfmBlJ4y83e8nV+Sc=;
  b=F5/gR/i7Ute6vqOSlE7hs9nkwm01hOWbaU5wELoadOxAZhTuX0V2eGI/
   QFcCAaDXY7CcEc1ECOLraHreukynYEV4b0M0N8UedNfp+a2BM4a42iDxa
   yAvHbBM7I2r3QYg0zKFjYHSFAOi3SI0rBTgHL3qVRpSiMr4VeM21LUVL3
   Lapg3N5U+ihPFlaFGD+JOoGnTA5S7KXYVYFkGsUjPYqDSbXqXYKQRZ4/W
   fEnyuvv9CE0oxNcfyclwY5LAFfgcolomkoVlfhQKc06KQ/fp++ALtmTQH
   DsFfKJQplyfpGTA00wQmhHqQgR+evaY8GZs3xNK9vLKrG8FeLcVQmxB9I
   Q==;
X-CSE-ConnectionGUID: lSioMxWxRtGyCpOEBPKsSw==
X-CSE-MsgGUID: dsLzvUEdTzO3fQIVappg+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729620"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729620"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:39:19 -0800
X-CSE-ConnectionGUID: EsdYWsHqSTCnCt2FfPIopQ==
X-CSE-MsgGUID: 8tFh0YMSQbCDl2RsaMsiSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658513"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:39:14 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 23/26] coco/tdx-host: Parse ACPI KEYP table to init IDE for PCI host bridges
Date: Mon, 17 Nov 2025 10:23:07 +0800
Message-Id: <20251117022311.2443900-24-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parse the KEYP Key Configuration Units (KCU), to decide the max IDE
streams supported for each host bridge.

The KEYP table points to a number of KCU structures that each associates
with a list of root ports (RP) via segment, bus, and devfn. Sanity check
the KEYP table, ensure all RPs listed for each KCU are included in one
host bridge. Then extact the max IDE streams supported to
pci_host_bridge via pci_ide_set_nr_streams().

Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/virt/coco/tdx-host/Kconfig    |   1 +
 drivers/virt/coco/tdx-host/tdx-host.c | 111 ++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)

diff --git a/drivers/virt/coco/tdx-host/Kconfig b/drivers/virt/coco/tdx-host/Kconfig
index 026b7d5ea4fa..5444798fa160 100644
--- a/drivers/virt/coco/tdx-host/Kconfig
+++ b/drivers/virt/coco/tdx-host/Kconfig
@@ -13,4 +13,5 @@ config TDX_CONNECT
 	bool
 	depends on TDX_HOST_SERVICES
 	depends on PCI_TSM
+	depends on ACPI
 	default TDX_HOST_SERVICES
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index ede47ccb5821..986a75084747 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -5,12 +5,14 @@
  * Copyright (C) 2025 Intel Corporation
  */
 
+#include <linux/acpi.h>
 #include <linux/bitfield.h>
 #include <linux/dmar.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/pci.h>
 #include <linux/pci-doe.h>
+#include <linux/pci-ide.h>
 #include <linux/pci-tsm.h>
 #include <linux/tsm.h>
 #include <linux/device/faux.h>
@@ -477,6 +479,111 @@ static void unregister_link_tsm(void *link)
 	tsm_unregister(link);
 }
 
+#define KCU_STR_CAP_NUM_STREAMS		GENMASK(8, 0)
+
+/* The bus_end is inclusive */
+struct keyp_hb_info {
+	/* input */
+	u16 segment;
+	u8 bus_start;
+	u8 bus_end;
+	/* output */
+	u8 nr_ide_streams;
+};
+
+static bool keyp_info_match(struct acpi_keyp_rp_info *rp,
+			    struct keyp_hb_info *hb)
+{
+	return rp->segment == hb->segment && rp->bus >= hb->bus_start &&
+	       rp->bus <= hb->bus_end;
+}
+
+static int keyp_config_unit_handler(union acpi_subtable_headers *header,
+				    void *arg, const unsigned long end)
+{
+	struct acpi_keyp_config_unit *acpi_cu =
+		(struct acpi_keyp_config_unit *)&header->keyp;
+	struct keyp_hb_info *hb_info = arg;
+	int rp_size, rp_count, i;
+	void __iomem *addr;
+	bool match = false;
+	u32 cap;
+
+	rp_size = acpi_cu->header.length - sizeof(*acpi_cu);
+	if (rp_size % sizeof(struct acpi_keyp_rp_info))
+		return -EINVAL;
+
+	rp_count = rp_size / sizeof(struct acpi_keyp_rp_info);
+	if (!rp_count || rp_count != acpi_cu->root_port_count)
+		return -EINVAL;
+
+	for (i = 0; i < rp_count; i++) {
+		struct acpi_keyp_rp_info *rp_info = &acpi_cu->rp_info[i];
+
+		if (i == 0) {
+			match = keyp_info_match(rp_info, hb_info);
+			/* The host bridge already matches another KCU */
+			if (match && hb_info->nr_ide_streams)
+				return -EINVAL;
+
+			continue;
+		}
+
+		if (match ^ keyp_info_match(rp_info, hb_info))
+			return -EINVAL;
+	}
+
+	if (!match)
+		return 0;
+
+	addr = ioremap(acpi_cu->register_base_address, sizeof(cap));
+	if (!addr)
+		return -ENOMEM;
+	cap = ioread32(addr);
+	iounmap(addr);
+
+	hb_info->nr_ide_streams = FIELD_GET(KCU_STR_CAP_NUM_STREAMS, cap) + 1;
+
+	return 0;
+}
+
+static u8 keyp_find_nr_ide_stream(u16 segment, u8 bus_start, u8 bus_end)
+{
+	struct keyp_hb_info hb_info = {
+		.segment = segment,
+		.bus_start = bus_start,
+		.bus_end = bus_end,
+	};
+	int rc;
+
+	rc = acpi_table_parse_keyp(ACPI_KEYP_TYPE_CONFIG_UNIT,
+				   keyp_config_unit_handler, &hb_info);
+	if (rc < 0)
+		return 0;
+
+	return hb_info.nr_ide_streams;
+}
+
+static void keyp_setup_nr_ide_stream(struct pci_bus *bus)
+{
+	struct pci_host_bridge *hb = pci_find_host_bridge(bus);
+	u8 nr_ide_streams;
+
+	nr_ide_streams = keyp_find_nr_ide_stream(pci_domain_nr(bus),
+						 bus->busn_res.start,
+						 bus->busn_res.end);
+
+	pci_ide_set_nr_streams(hb, nr_ide_streams);
+}
+
+static void tdx_setup_nr_ide_stream(void)
+{
+	struct pci_bus *bus = NULL;
+
+	while ((bus = pci_find_next_bus(bus)))
+		keyp_setup_nr_ide_stream(bus);
+}
+
 static DEFINE_XARRAY(tlink_iommu_xa);
 
 static void tdx_iommu_clear(u64 iommu_id, struct tdx_page_array *iommu_mt)
@@ -590,6 +697,8 @@ static int __maybe_unused tdx_connect_init(struct device *dev)
 	if (ret)
 		return ret;
 
+	tdx_setup_nr_ide_stream();
+
 	link = tsm_register(dev, &tdx_link_ops);
 	if (IS_ERR(link))
 		return dev_err_probe(dev, PTR_ERR(link),
@@ -633,5 +742,7 @@ static void __exit tdx_host_exit(void)
 }
 module_exit(tdx_host_exit);
 
+MODULE_IMPORT_NS("ACPI");
+MODULE_IMPORT_NS("PCI_IDE");
 MODULE_DESCRIPTION("TDX Host Services");
 MODULE_LICENSE("GPL");
-- 
2.25.1


