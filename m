Return-Path: <kvm+bounces-63303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 843C9C6218B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 63A764E6A9D
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2547D258ECF;
	Mon, 17 Nov 2025 02:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U3t4sEqq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD5724676A;
	Mon, 17 Nov 2025 02:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347089; cv=none; b=RjKX8nHe1aceLB727d1+o6IfHFasm6o1H5cQCzeX1yT6OEB/RRAEzWXv8/pXpZbTPXJkw/CxWvhDEoZSCZWIWWFOUyCF/+wj2xdoirTYxFrwUqGv72931rOzKXH7lT02PJ7ZsxCZs3QvDgwlZqOf/dXWtiXrPbeAlhrTZ2j6niE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347089; c=relaxed/simple;
	bh=jfBYo+83L9GB6K2XXbeAbBjGF/bNuE6z9WENrU4/4hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fAPg685XMMf27ncl6AVMCRwOVv+Qcjo411gdmhOjXTdk0tg9KvzOd/GDtFFsGVKmCr3b2SxmwxzRKK1uBV6MPd+aruhJ/gVAA1yWxNav9D4DsmqyJ+pC5WX5AZ2x3WUiVpEC6WHpQFnOkiq6uvh8zrcxnAUEa6zCvYefkIoLx0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U3t4sEqq; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347087; x=1794883087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jfBYo+83L9GB6K2XXbeAbBjGF/bNuE6z9WENrU4/4hc=;
  b=U3t4sEqqQ3oB7stw9OrBgva6NxBwkSL0qD+9ivnCpknDFo/mKeLaYPba
   aSTJOfUnVN/hfUmrFRHhlOUEoPFjCtLmDF+AOFfLhQri6O6dH5x7ZTIGP
   nILb92xbcLJYwoPTgeVIX2luUPzhGsgiih24LSaPJ6cuW97KZmSWcfbXV
   wjcVYvUOgJjhC9wObx/gjxfiGpkV/XN6OqWaegiKxuAe8BUOIdXEuAULi
   lnpgld1FjU2QV96kWbB8RAsaTT0jWntLoFhdQ+h6vahheeRdIjnb0wjOj
   0PboaflHVMNMy1XiWGQxivDRxbt9w+EvI158zevLB5Lz06V5qYqvdArzP
   g==;
X-CSE-ConnectionGUID: j7Rt6tuWQrO2ycYD5QVjNA==
X-CSE-MsgGUID: 1uAkN82bTr6S6622R0qV9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729501"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729501"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:07 -0800
X-CSE-ConnectionGUID: iFICz6huRCeFU2+di82GmQ==
X-CSE-MsgGUID: Gp6URJKpT62R+ZKJBC9cnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658149"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:03 -0800
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
Subject: [PATCH v1 03/26] coco/tdx-host: Support Link TSM for TDX host
Date: Mon, 17 Nov 2025 10:22:47 +0800
Message-Id: <20251117022311.2443900-4-yilun.xu@linux.intel.com>
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

Register a Link TSM instance to support host side TSM operations for
TDISP, when the TDX Connect support bit is set by TDX Module in
tdx_feature0.

This is the main purpose of an independent tdx-host module out of TDX
core. Recall that a TEE Security Manager (TSM) is a platform agent that
speaks the TEE Device Interface Security Protocol (TDISP) to PCIe
devices and manages private memory resources for the platform. An
independent tdx-host module allows for device-security enumeration and
initialization flows to be deferred from other TDX Module initialization
requirements. Crucially, when / if TDX Module init moves earlier in x86
initialization flow this driver is still guaranteed to run after IOMMU
and PCI init (i.e. subsys_initcall() vs device_initcall()).

The ability to unload the module, or unbind the driver is also useful
for debug and coarse grained transitioning between PCI TSM operation and
PCI CMA operation (native kernel PCI device authentication).

For now this is the basic boilerplate with operation flows to be added
later.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/virt/coco/tdx-host/Kconfig    |   6 +
 arch/x86/include/asm/tdx.h            |   1 +
 drivers/virt/coco/tdx-host/tdx-host.c | 154 +++++++++++++++++++++++++-
 3 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/coco/tdx-host/Kconfig b/drivers/virt/coco/tdx-host/Kconfig
index bf6be0fc0879..026b7d5ea4fa 100644
--- a/drivers/virt/coco/tdx-host/Kconfig
+++ b/drivers/virt/coco/tdx-host/Kconfig
@@ -8,3 +8,9 @@ config TDX_HOST_SERVICES
 
 	  Say y or m if enabling support for confidential virtual machine
 	  support (CONFIG_INTEL_TDX_HOST). The module is called tdx_host.ko
+
+config TDX_CONNECT
+	bool
+	depends on TDX_HOST_SERVICES
+	depends on PCI_TSM
+	default TDX_HOST_SERVICES
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b6961e137450..ff77900f067b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -148,6 +148,7 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 const char *tdx_dump_mce_info(struct mce *m);
 
 /* Bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_TDXCONNECT	BIT_ULL(6)
 #define TDX_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
 
 const struct tdx_sys_info *tdx_get_sysinfo(void);
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index ced1c980dc6f..6f21bb2dbeb9 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -7,8 +7,13 @@
 
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
+#include <linux/pci.h>
+#include <linux/pci-tsm.h>
+#include <linux/tsm.h>
 #include <linux/device/faux.h>
 #include <asm/cpu_device_id.h>
+#include <asm/tdx.h>
+#include <asm/tdx_global_metadata.h>
 
 static const struct x86_cpu_id tdx_host_ids[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_TDX_HOST_PLATFORM, NULL),
@@ -16,6 +21,153 @@ static const struct x86_cpu_id tdx_host_ids[] = {
 };
 MODULE_DEVICE_TABLE(x86cpu, tdx_host_ids);
 
+/*
+ * The scope of this pointer is for TDX Connect.
+ * Every feature should evaluate how to get tdx_sysinfo. TDX Connect expects no
+ * tdx_sysinfo change after TDX Module update so could cache it. TDX version
+ * sysfs expects change so should call tdx_get_sysinfo() every time.
+ *
+ * Maybe move TDX Connect to a separate file makes thing clearer.
+ */
+static const struct tdx_sys_info *tdx_sysinfo;
+
+struct tdx_link {
+	struct pci_tsm_pf0 pci;
+};
+
+static struct tdx_link *to_tdx_link(struct pci_tsm *tsm)
+{
+	return container_of(tsm, struct tdx_link, pci.base_tsm);
+}
+
+static int tdx_link_connect(struct pci_dev *pdev)
+{
+	return -ENXIO;
+}
+
+static void tdx_link_disconnect(struct pci_dev *pdev)
+{
+}
+
+static struct pci_tsm *tdx_link_pf0_probe(struct tsm_dev *tsm_dev,
+					  struct pci_dev *pdev)
+{
+	int rc;
+
+	struct tdx_link *tlink __free(kfree) =
+		kzalloc(sizeof(*tlink), GFP_KERNEL);
+	if (!tlink)
+		return NULL;
+
+	rc = pci_tsm_pf0_constructor(pdev, &tlink->pci, tsm_dev);
+	if (rc)
+		return NULL;
+
+	return &no_free_ptr(tlink)->pci.base_tsm;
+}
+
+static void tdx_link_pf0_remove(struct pci_tsm *tsm)
+{
+	struct tdx_link *tlink = to_tdx_link(tsm);
+
+	pci_tsm_pf0_destructor(&tlink->pci);
+	kfree(tlink);
+}
+
+static struct pci_tsm *tdx_link_fn_probe(struct tsm_dev *tsm_dev,
+					 struct pci_dev *pdev)
+{
+	int rc;
+
+	struct pci_tsm *pci_tsm __free(kfree) =
+		kzalloc(sizeof(*pci_tsm), GFP_KERNEL);
+	if (!pci_tsm)
+		return NULL;
+
+	rc = pci_tsm_link_constructor(pdev, pci_tsm, tsm_dev);
+	if (rc)
+		return NULL;
+
+	return no_free_ptr(pci_tsm);
+}
+
+static struct pci_tsm *tdx_link_probe(struct tsm_dev *tsm_dev, struct pci_dev *pdev)
+{
+	if (is_pci_tsm_pf0(pdev))
+		return tdx_link_pf0_probe(tsm_dev, pdev);
+
+	return tdx_link_fn_probe(tsm_dev, pdev);
+}
+
+static void tdx_link_remove(struct pci_tsm *tsm)
+{
+	if (is_pci_tsm_pf0(tsm->pdev)) {
+		tdx_link_pf0_remove(tsm);
+		return;
+	}
+
+	/* for sub-functions */
+	kfree(tsm);
+}
+
+static struct pci_tsm_ops tdx_link_ops = {
+	.probe = tdx_link_probe,
+	.remove = tdx_link_remove,
+	.connect = tdx_link_connect,
+	.disconnect = tdx_link_disconnect,
+};
+
+static void unregister_link_tsm(void *link)
+{
+	tsm_unregister(link);
+}
+
+static int __maybe_unused tdx_connect_init(struct device *dev)
+{
+	struct tsm_dev *link;
+
+	if (!IS_ENABLED(CONFIG_TDX_CONNECT))
+		return 0;
+
+	/*
+	 * With this errata, TDX should use movdir64b to clear private pages
+	 * when reclaiming them. See tdx_clear_page().
+	 *
+	 * Don't expect this errata on any TDX Connect supported platform. TDX
+	 * Connect will never call tdx_clear_page().
+	 */
+	if (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
+		return -ENXIO;
+
+	tdx_sysinfo = tdx_get_sysinfo();
+	if (!tdx_sysinfo)
+		return -ENXIO;
+
+	if (!(tdx_sysinfo->features.tdx_features0 & TDX_FEATURES0_TDXCONNECT))
+		return 0;
+
+	link = tsm_register(dev, &tdx_link_ops);
+	if (IS_ERR(link))
+		return dev_err_probe(dev, PTR_ERR(link),
+				     "failed to register TSM\n");
+
+	return devm_add_action_or_reset(dev, unregister_link_tsm, link);
+}
+
+static int tdx_host_probe(struct faux_device *fdev)
+{
+	/*
+	 * Only support TDX Connect now. More TDX features could be added here.
+	 *
+	 * TODO: do tdx_connect_init() when it is fully implemented.
+	 */
+	return 0;
+}
+
+static struct faux_device_ops tdx_host_ops = {
+	.probe = tdx_host_probe,
+};
+
 static struct faux_device *fdev;
 
 static int __init tdx_host_init(void)
@@ -23,7 +175,7 @@ static int __init tdx_host_init(void)
 	if (!x86_match_cpu(tdx_host_ids))
 		return -ENODEV;
 
-	fdev = faux_device_create(KBUILD_MODNAME, NULL, NULL);
+	fdev = faux_device_create(KBUILD_MODNAME, NULL, &tdx_host_ops);
 	if (!fdev)
 		return -ENODEV;
 
-- 
2.25.1


