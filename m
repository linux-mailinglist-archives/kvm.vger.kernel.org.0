Return-Path: <kvm+bounces-63322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C400BC62209
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0AE224E7AB3
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826EE278779;
	Mon, 17 Nov 2025 02:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTWHor37"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10422641E3;
	Mon, 17 Nov 2025 02:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347156; cv=none; b=AYTNuzWb6W8tKIztDCPJGyd4w+KDkqle6jE2MWbIiO1yeUQtSao8B9ssEZfEoVHskuX90xKP2+6jWu36hIhjc76vyWcxLeBypIbZRkskzguwIPoaudlL8ZO1pPEGx31MfT1nWTc+7UzHPfvjVJB8YJgwUNBIOlC2zlltZr/HN7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347156; c=relaxed/simple;
	bh=Esis0ebAeOXaEahTR6XxFWpYmhFmY5nU8Dg6b8/gQ4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TI00vn4yy8NdkmAxIH0Rs35iJYl0LwzzJWVphXRuUrNDYb5R3UwkEUo8zelELOn48LR2zqNX9/hr2AghEFG8ph8xCElQzqYMmwlaln1YLqh8+rkeIywDg3SyPQ5HRt+Ld88vd0tCCi3Mmf5lG+XMb/Ux+1q/uUk6IQPB/mJ0Fv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTWHor37; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347155; x=1794883155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Esis0ebAeOXaEahTR6XxFWpYmhFmY5nU8Dg6b8/gQ4A=;
  b=TTWHor373mNdqTwnW5e/ZtW/RYxjBzGl9zfSuLzDFd8f9ngercM2uyUz
   ED7prgGDeUet2BHVoJTdoitRVpshJ4aw92tLamq3KFhyGFZ7l7uxm8y9+
   j4t/feyFriG6eWZ6YC3Xuzh9UZtIJqZGmhXTGDV/Lkf7+EzocgaGJYVxs
   RX9sjnAgqiLL/0OnQw9eZxvAOXi5BhnmjXlcyQjveKSJtLND3Fm5HJG4j
   IclMtlf5AEN5hPFvEslC5oNzGGzOC3pzFEt4PGNxCxGe/Pbg71uHmfbah
   PE4dnFLnKCqYS5Ti28MbP5G1/rn8XIp5QfZ42MMjy0Ef9yjx9s8ybFHqa
   Q==;
X-CSE-ConnectionGUID: E2tb2IrOS3G5mbcGkeAUUw==
X-CSE-MsgGUID: 80x0s3fsSLODUHCO0MtECw==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729612"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729612"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:39:15 -0800
X-CSE-ConnectionGUID: DQc3ZbD7SECgg76qSUz8/g==
X-CSE-MsgGUID: 4jId08YTQeWwU6pfGvS6RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658505"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:39:10 -0800
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
Subject: [PATCH v1 22/26] coco/tdx-host: Implement SPDM session setup
Date: Mon, 17 Nov 2025 10:23:06 +0800
Message-Id: <20251117022311.2443900-23-yilun.xu@linux.intel.com>
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

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Implementation for a most straightforward SPDM session setup, using all
default session options. Retrieve device info data from TDX Module which
contains the SPDM negotiation results.

TDH.SPDM.CONNECT/DISCONNECT are TDX Module Extension introduced
SEAMCALLs which can run for longer periods and interruptible. But there
is resource constraints that limit how many SEAMCALLs of this kind can
run simultaneously. The current situation is One SEAMCALL at a time.
Otherwise TDX_OPERAND_BUSY is returned. To avoid "broken indefinite"
retry, a tdx_ext_lock is used to guard these SEAMCALLs.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Co-developed-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/shared/tdx_errno.h |   2 +
 drivers/virt/coco/tdx-host/tdx-host.c   | 301 +++++++++++++++++++++++-
 2 files changed, 299 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
index f98924fe5198..7e87496a9603 100644
--- a/arch/x86/include/asm/shared/tdx_errno.h
+++ b/arch/x86/include/asm/shared/tdx_errno.h
@@ -28,6 +28,8 @@
 #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
 #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
 #define TDX_METADATA_FIELD_NOT_READABLE		0xC0000C0200000000ULL
+#define TDX_SPDM_SESSION_KEY_REQUIRE_REFRESH	0xC0000F4500000000ULL
+#define TDX_SPDM_REQUEST			0xC0000F5700000000ULL
 
 /*
  * SW-defined error codes.
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index f0151561e00e..ede47ccb5821 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -14,6 +14,7 @@
 #include <linux/pci-tsm.h>
 #include <linux/tsm.h>
 #include <linux/device/faux.h>
+#include <linux/vmalloc.h>
 #include <asm/cpu_device_id.h>
 #include <asm/tdx.h>
 #include <asm/tdx_global_metadata.h>
@@ -34,8 +35,34 @@ MODULE_DEVICE_TABLE(x86cpu, tdx_host_ids);
  */
 static const struct tdx_sys_info *tdx_sysinfo;
 
+#define TDISP_FUNC_ID		GENMASK(15, 0)
+#define TDISP_FUNC_ID_SEGMENT		GENMASK(23, 16)
+#define TDISP_FUNC_ID_SEG_VALID		BIT(24)
+
+static inline u32 tdisp_func_id(struct pci_dev *pdev)
+{
+	u32 func_id;
+
+	func_id = FIELD_PREP(TDISP_FUNC_ID_SEGMENT, pci_domain_nr(pdev->bus));
+	if (func_id)
+		func_id |= TDISP_FUNC_ID_SEG_VALID;
+	func_id |= FIELD_PREP(TDISP_FUNC_ID,
+			      PCI_DEVID(pdev->bus->number, pdev->devfn));
+
+	return func_id;
+}
+
 struct tdx_link {
 	struct pci_tsm_pf0 pci;
+	u32 func_id;
+	struct page *in_msg;
+	struct page *out_msg;
+
+	u64 spdm_id;
+	struct page *spdm_conf;
+	struct tdx_page_array *spdm_mt;
+	unsigned int dev_info_size;
+	void *dev_info_data;
 };
 
 static struct tdx_link *to_tdx_link(struct pci_tsm *tsm)
@@ -50,9 +77,9 @@ static struct tdx_link *to_tdx_link(struct pci_tsm *tsm)
 
 #define PCI_DOE_PROTOCOL_SECURE_SPDM		2
 
-static int __maybe_unused tdx_spdm_msg_exchange(struct tdx_link *tlink,
-						void *request, size_t request_sz,
-						void *response, size_t response_sz)
+static int tdx_spdm_msg_exchange(struct tdx_link *tlink,
+				 void *request, size_t request_sz,
+				 void *response, size_t response_sz)
 {
 	struct pci_dev *pdev = tlink->pci.base_tsm.pdev;
 	void *req_pl_addr, *resp_pl_addr;
@@ -102,18 +129,258 @@ static int __maybe_unused tdx_spdm_msg_exchange(struct tdx_link *tlink,
 	return ret;
 }
 
+static int tdx_spdm_session_keyupdate(struct tdx_link *tlink);
+
+static int tdx_link_event_handler(struct tdx_link *tlink,
+				  u64 tdx_ret, u64 out_msg_sz)
+{
+	int ret;
+
+	if (tdx_ret == TDX_SUCCESS)
+		return 0;
+
+	if (tdx_ret == TDX_SPDM_REQUEST) {
+		ret = tdx_spdm_msg_exchange(tlink,
+					    page_address(tlink->out_msg),
+					    out_msg_sz,
+					    page_address(tlink->in_msg),
+					    PAGE_SIZE);
+		if (ret < 0)
+			return ret;
+
+		return -EAGAIN;
+	}
+
+	if (tdx_ret == TDX_SPDM_SESSION_KEY_REQUIRE_REFRESH) {
+		/* keyupdate won't trigger this error again, no recursion risk */
+		ret = tdx_spdm_session_keyupdate(tlink);
+		if (ret)
+			return ret;
+
+		return -EAGAIN;
+	}
+
+	return -EFAULT;
+}
+
+/*
+ * TDX Module extension introduced SEAMCALLs work like a request queue.
+ * The caller is responsible for grabbing a queue slot before SEAMCALL,
+ * otherwise will fail with TDX_OPERAND_BUSY. Currently the queue depth is 1.
+ * So a mutex could work for simplicity.
+ */
+static DEFINE_MUTEX(tdx_ext_lock);
+
+enum tdx_spdm_mng_op {
+	TDX_SPDM_MNG_HEARTBEAT = 0,
+	TDX_SPDM_MNG_KEY_UPDATE = 1,
+	TDX_SPDM_MNG_RECOLLECT = 2,
+};
+
+static int tdx_spdm_session_mng(struct tdx_link *tlink,
+				enum tdx_spdm_mng_op op)
+{
+	u64 r, out_msg_sz;
+	int ret;
+
+	guard(mutex)(&tdx_ext_lock);
+	do {
+		r = tdh_exec_spdm_mng(tlink->spdm_id, op, NULL, tlink->in_msg,
+				      tlink->out_msg, NULL, &out_msg_sz);
+		ret = tdx_link_event_handler(tlink, r, out_msg_sz);
+	} while (ret == -EAGAIN);
+
+	return ret;
+}
+
+static int tdx_spdm_session_keyupdate(struct tdx_link *tlink)
+{
+	return tdx_spdm_session_mng(tlink, TDX_SPDM_MNG_KEY_UPDATE);
+}
+
+static void *tdx_dup_array_data(struct tdx_page_array *array,
+				unsigned int data_size)
+{
+	unsigned int npages = (data_size + PAGE_SIZE - 1) / PAGE_SIZE;
+	void *data, *dup_data;
+
+	if (npages > array->nr_pages)
+		return NULL;
+
+	data = vm_map_ram(array->pages, npages, -1);
+	if (!data)
+		return NULL;
+
+	dup_data = kmemdup(data, data_size, GFP_KERNEL);
+	vm_unmap_ram(data, npages);
+
+	return dup_data;
+}
+
+static struct tdx_link *tdx_spdm_session_connect(struct tdx_link *tlink,
+						 struct tdx_page_array *dev_info)
+{
+	u64 r, out_msg_sz;
+	int ret;
+
+	guard(mutex)(&tdx_ext_lock);
+	do {
+		r = tdh_exec_spdm_connect(tlink->spdm_id, tlink->spdm_conf,
+					  tlink->in_msg, tlink->out_msg,
+					  dev_info, &out_msg_sz);
+		ret = tdx_link_event_handler(tlink, r, out_msg_sz);
+	} while (ret == -EAGAIN);
+
+	if (ret)
+		return ERR_PTR(ret);
+
+	tlink->dev_info_size = out_msg_sz;
+	return tlink;
+}
+
+static void tdx_spdm_session_disconnect(struct tdx_link *tlink)
+{
+	u64 r, out_msg_sz;
+	int ret;
+
+	guard(mutex)(&tdx_ext_lock);
+	do {
+		r = tdh_exec_spdm_disconnect(tlink->spdm_id, tlink->in_msg,
+					     tlink->out_msg, &out_msg_sz);
+		ret = tdx_link_event_handler(tlink, r, out_msg_sz);
+	} while (ret == -EAGAIN);
+
+	WARN_ON(ret);
+}
+
+DEFINE_FREE(tdx_spdm_session_disconnect, struct tdx_link *,
+	    if (!IS_ERR_OR_NULL(_T)) tdx_spdm_session_disconnect(_T))
+
+static struct tdx_link *tdx_spdm_create(struct tdx_link *tlink)
+{
+	unsigned int nr_pages = tdx_sysinfo->connect.spdm_mt_page_count;
+	u64 spdm_id, r;
+
+	struct tdx_page_array *spdm_mt __free(tdx_page_array_free) =
+		tdx_page_array_create(nr_pages);
+	if (!spdm_mt)
+		return ERR_PTR(-ENOMEM);
+
+	r = tdh_spdm_create(tlink->func_id, spdm_mt, &spdm_id);
+	if (r)
+		return ERR_PTR(-EFAULT);
+
+	tlink->spdm_id = spdm_id;
+	tlink->spdm_mt = no_free_ptr(spdm_mt);
+	return tlink;
+}
+
+static void tdx_spdm_delete(struct tdx_link *tlink)
+{
+	struct pci_dev *pdev = tlink->pci.base_tsm.pdev;
+	unsigned int nr_released;
+	u64 released_hpa, r;
+
+	r = tdh_spdm_delete(tlink->spdm_id, tlink->spdm_mt, &nr_released, &released_hpa);
+	if (r) {
+		pci_err(pdev, "fail to delete spdm\n");
+		goto leak;
+	}
+
+	if (tdx_page_array_ctrl_release(tlink->spdm_mt, nr_released, released_hpa)) {
+		pci_err(pdev, "fail to release metadata pages\n");
+		goto leak;
+	}
+
+	return;
+
+leak:
+	tdx_page_array_ctrl_leak(tlink->spdm_mt);
+}
+
+DEFINE_FREE(tdx_spdm_delete, struct tdx_link *, if (!IS_ERR_OR_NULL(_T)) tdx_spdm_delete(_T))
+
+static struct tdx_link *tdx_spdm_session_setup(struct tdx_link *tlink)
+{
+	unsigned int nr_pages = tdx_sysinfo->connect.spdm_max_dev_info_pages;
+
+	struct tdx_link *tlink_create __free(tdx_spdm_delete) =
+		tdx_spdm_create(tlink);
+	if (IS_ERR(tlink_create))
+		return tlink_create;
+
+	struct tdx_page_array *dev_info __free(tdx_page_array_free) =
+		tdx_page_array_create(nr_pages);
+	if (!dev_info)
+		return ERR_PTR(-ENOMEM);
+
+	struct tdx_link *tlink_connect __free(tdx_spdm_session_disconnect) =
+		tdx_spdm_session_connect(tlink, dev_info);
+	if (IS_ERR(tlink_connect))
+		return tlink_connect;
+
+	tlink->dev_info_data = tdx_dup_array_data(dev_info,
+						  tlink->dev_info_size);
+	if (!tlink->dev_info_data)
+		return ERR_PTR(-ENOMEM);
+
+	retain_and_null_ptr(tlink_create);
+	retain_and_null_ptr(tlink_connect);
+
+	return tlink;
+}
+
+static void tdx_spdm_session_teardown(struct tdx_link *tlink)
+{
+	kfree(tlink->dev_info_data);
+
+	tdx_spdm_session_disconnect(tlink);
+	tdx_spdm_delete(tlink);
+}
+
+DEFINE_FREE(tdx_spdm_session_teardown, struct tdx_link *,
+	    if (!IS_ERR_OR_NULL(_T)) tdx_spdm_session_teardown(_T))
+
 static int tdx_link_connect(struct pci_dev *pdev)
 {
-	return -ENXIO;
+	struct tdx_link *tlink = to_tdx_link(pdev->tsm);
+
+	struct tdx_link *tlink_spdm __free(tdx_spdm_session_teardown) =
+		tdx_spdm_session_setup(tlink);
+	if (IS_ERR(tlink_spdm)) {
+		pci_err(pdev, "fail to setup spdm session\n");
+		return PTR_ERR(tlink_spdm);
+	}
+
+	retain_and_null_ptr(tlink_spdm);
+
+	return 0;
 }
 
 static void tdx_link_disconnect(struct pci_dev *pdev)
 {
+	struct tdx_link *tlink = to_tdx_link(pdev->tsm);
+
+	tdx_spdm_session_teardown(tlink);
 }
 
+struct spdm_config_info_t {
+	u32 vmm_spdm_cap;
+#define SPDM_CAP_HBEAT          BIT(13)
+#define SPDM_CAP_KEY_UPD        BIT(14)
+	u8 spdm_session_policy;
+	u8 certificate_slot_mask;
+	u8 raw_bitstream_requested;
+} __packed;
+
 static struct pci_tsm *tdx_link_pf0_probe(struct tsm_dev *tsm_dev,
 					  struct pci_dev *pdev)
 {
+	const struct spdm_config_info_t spdm_config_info = {
+		/* use a default configuration, may require user input later */
+		.vmm_spdm_cap = SPDM_CAP_KEY_UPD,
+		.certificate_slot_mask = 0xff,
+	};
 	int rc;
 
 	struct tdx_link *tlink __free(kfree) =
@@ -125,6 +392,29 @@ static struct pci_tsm *tdx_link_pf0_probe(struct tsm_dev *tsm_dev,
 	if (rc)
 		return NULL;
 
+	tlink->func_id = tdisp_func_id(pdev);
+
+	struct page *in_msg_page __free(__free_page) =
+		alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!in_msg_page)
+		return NULL;
+
+	struct page *out_msg_page __free(__free_page) =
+		alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!out_msg_page)
+		return NULL;
+
+	struct page *spdm_conf __free(__free_page) =
+		alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!spdm_conf)
+		return NULL;
+
+	memcpy(page_address(spdm_conf), &spdm_config_info, sizeof(spdm_config_info));
+
+	tlink->in_msg = no_free_ptr(in_msg_page);
+	tlink->out_msg = no_free_ptr(out_msg_page);
+	tlink->spdm_conf = no_free_ptr(spdm_conf);
+
 	return &no_free_ptr(tlink)->pci.base_tsm;
 }
 
@@ -132,6 +422,9 @@ static void tdx_link_pf0_remove(struct pci_tsm *tsm)
 {
 	struct tdx_link *tlink = to_tdx_link(tsm);
 
+	__free_page(tlink->spdm_conf);
+	__free_page(tlink->out_msg);
+	__free_page(tlink->in_msg);
 	pci_tsm_pf0_destructor(&tlink->pci);
 	kfree(tlink);
 }
-- 
2.25.1


