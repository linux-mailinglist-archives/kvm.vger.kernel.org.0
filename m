Return-Path: <kvm+bounces-68985-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eMEZKpGOc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68985-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:06:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF5477786
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 386AC300F98D
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CA8323416;
	Fri, 23 Jan 2026 15:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JddqBQZW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1EF2DECC6;
	Fri, 23 Jan 2026 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180427; cv=none; b=GsWcKuTy7k46yHnupB6rCriHmbNDEoD5ig8OzqWmUvWWUzzv/fPxowPuvky9M2dfBnuQfOgvPVEuPGccfJtWHsLH9bIC73vd7Z3it/PEvi23saSNnAV2xJnNRccJ2JdVqjO5mLIoGrt0VuMod3+ppqlT9qDk6BmqkYS4tFKT67E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180427; c=relaxed/simple;
	bh=iyuCaDaAcegyeDCHE8c/aayAPOHbknHM/l0oTLZdxpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alSWO39GZ7ZY9pMPE/Cw0vFkSjA0A4p3b2SUkIO+mvqSA4NPhSv3GbGIvynxPOrRSKb1tXV687PXK26x5X24i7y/wbzon0q7wXy8JWF26yMqKjg+xlH1Crht74c2BPiqo0Do71AnCXAH9c3uHOTL2pzOUaQzoPmTfmI7+dk6Jo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JddqBQZW; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180423; x=1800716423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iyuCaDaAcegyeDCHE8c/aayAPOHbknHM/l0oTLZdxpw=;
  b=JddqBQZWXuL5IrwJFe4k2ZvRvlLDu+xYVJmJQ/bYpIYqSwZ6xjnAPEVe
   FW/2dWmJCWB+9qhCzgJetGXIja6T8rCUMs93NCRkou2pSa1IFpP5GfM+9
   0IyzZqf/ei0Jqd1S7OiPpHh2DHtldDa0cOQh9zANj2hzgjTvQBn5fPpTU
   OeGV3fipXMWgtk8fxwDBosnPnjHPMxXSvORsa+zdwmPR7SyjCaihhXSIZ
   pca4DKMhyKa3zgAnBq6l9fFfFhhUIG+F+SQ5choP0OyZOKfWEx1nMnIRZ
   H1HhAtbdja29ybtbr8G518KKqFqZx+T7FGLo+/6FS3l2Zl84ZHsd09ulb
   Q==;
X-CSE-ConnectionGUID: HbYl/7ElRSieitwF0zCyAQ==
X-CSE-MsgGUID: 50PEh2y/TnufUdMQGexMVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334404"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334404"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:14 -0800
X-CSE-ConnectionGUID: skrujS8RSZS5kEeAKUr8ZA==
X-CSE-MsgGUID: FCTFCq3ASbSHi/plHAwR+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697122"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:14 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 10/26] coco/tdx-host: Implement FW_UPLOAD sysfs ABI for TDX Module updates
Date: Fri, 23 Jan 2026 06:55:18 -0800
Message-ID: <20260123145645.90444-11-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68985-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: DFF5477786
X-Rspamd-Action: no action

The firmware upload framework provides a standard mechanism for firmware
updates by allowing device drivers to expose sysfs interfaces for
user-initiated updates.

Register with this framework to expose sysfs interfaces for TDX Module
updates and implement operations to process data blobs supplied by
userspace.

Note that:
1. P-SEAMLDR processes the entire update at once rather than
   chunk-by-chunk, so .write() is called only once per update; so the
   offset should be always 0.
2. TDX Module Updates complete synchronously within .write(), meaning
   .poll_complete() is only called after successful updates and therefore
   always returns success

Why fw_upload instead of request_firmware()?
============================================
The explicit file selection capabilities of fw_upload is preferred over
the implicit file selection of request_firmware() for the following
reasons:

a. Intel distributes all versions of the TDX Module, allowing admins to
load any version rather than always defaulting to the latest. This
flexibility is necessary because future extensions may require reverting to
a previous version to clear fatal errors.

b. Some module version series are platform-specific. For example, the 1.5.x
series is for certain platform generations, while the 2.0.x series is
intended for others.

c. The update policy for TDX Module updates is non-linear at times. The
latest TDX Module may not be compatible. For example, TDX Module 1.5.x
may be updated to 1.5.y but not to 1.5.y+1. This policy is documented
separately in a file released along with each TDX Module release.

So, the default policy of "request_firmware()" of "always load latest", is
not suitable for TDX. Userspace needs to deploy a more sophisticated policy
check (e.g., latest may not be compatible), and there is potential
operator choice to consider.

Just have userspace pick rather than add kernel mechanism to change the
default policy of request_firmware().

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
v3:
 - clear "cancel_request" in the "prepare" phase [Binbin]
 - Don't fail the whole tdx-host device if seamldr_init() met an error
 [Yilun]
 - Add kdoc for seamldr_install_module() and verify that the input
   buffer is vmalloc'd. [Yilun]
---
 arch/x86/include/asm/seamldr.h        |   2 +
 arch/x86/include/asm/tdx.h            |   5 ++
 arch/x86/virt/vmx/tdx/seamldr.c       |  19 ++++
 drivers/virt/coco/tdx-host/Kconfig    |   2 +
 drivers/virt/coco/tdx-host/tdx-host.c | 124 +++++++++++++++++++++++++-
 5 files changed, 151 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/seamldr.h b/arch/x86/include/asm/seamldr.h
index d1e9f6e16e8d..692bde5e9bb4 100644
--- a/arch/x86/include/asm/seamldr.h
+++ b/arch/x86/include/asm/seamldr.h
@@ -20,8 +20,10 @@ struct seamldr_info {
 
 #ifdef CONFIG_INTEL_TDX_MODULE_UPDATE
 const struct seamldr_info *seamldr_get_info(void);
+int seamldr_install_module(const u8 *data, u32 size);
 #else
 static inline const struct seamldr_info *seamldr_get_info(void) { return NULL; }
+static inline int seamldr_install_module(const u8 *data, u32 size) { return -EOPNOTSUPP; }
 #endif
 
 #endif
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index cb2219302dfc..ffadbf64d0c1 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -103,6 +103,11 @@ int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
+static inline bool tdx_supports_runtime_update(const struct tdx_sys_info *sysinfo)
+{
+	return false; /* To be enabled when kernel is ready */
+}
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 6a83ae405fac..af7a6621e5e0 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -7,6 +7,7 @@
 #define pr_fmt(fmt)	"seamldr: " fmt
 
 #include <linux/irqflags.h>
+#include <linux/mm.h>
 #include <linux/types.h>
 
 #include <asm/seamldr.h>
@@ -69,3 +70,21 @@ const struct seamldr_info *seamldr_get_info(void)
 	return seamldr_call(P_SEAMLDR_INFO, &args) ? NULL : &seamldr_info;
 }
 EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");
+
+/**
+ * seamldr_install_module - Install a new TDX module
+ * @data: Pointer to the TDX module binary data. It should be vmalloc'd
+ *        memory.
+ * @size: Size of the TDX module binary data
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int seamldr_install_module(const u8 *data, u32 size)
+{
+	if (!is_vmalloc_addr(data))
+		return -EINVAL;
+
+	/* TODO: Update TDX Module here */
+	return 0;
+}
+EXPORT_SYMBOL_FOR_MODULES(seamldr_install_module, "tdx-host");
diff --git a/drivers/virt/coco/tdx-host/Kconfig b/drivers/virt/coco/tdx-host/Kconfig
index 6a9199e6c2c6..59aaca2252b0 100644
--- a/drivers/virt/coco/tdx-host/Kconfig
+++ b/drivers/virt/coco/tdx-host/Kconfig
@@ -12,6 +12,8 @@ config TDX_HOST_SERVICES
 config INTEL_TDX_MODULE_UPDATE
 	bool "Intel TDX module runtime update"
 	depends on TDX_HOST_SERVICES
+	select FW_LOADER
+	select FW_UPLOAD
 	help
 	  This enables the kernel to support TDX module runtime update. This
 	  allows the admin to update the TDX module to another compatible
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index f4ce89522806..06487de2ebfe 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/device/faux.h>
+#include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/sysfs.h>
@@ -20,6 +21,13 @@ static const struct x86_cpu_id tdx_host_ids[] = {
 };
 MODULE_DEVICE_TABLE(x86cpu, tdx_host_ids);
 
+struct tdx_fw_upload_status {
+	bool cancel_request;
+};
+
+struct fw_upload *tdx_fwl;
+static struct tdx_fw_upload_status tdx_fw_upload_status;
+
 static ssize_t version_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
@@ -100,6 +108,120 @@ static const struct attribute_group *tdx_host_groups[] = {
 	NULL,
 };
 
+static enum fw_upload_err tdx_fw_prepare(struct fw_upload *fwl,
+					 const u8 *data, u32 size)
+{
+	struct tdx_fw_upload_status *status = fwl->dd_handle;
+
+	status->cancel_request = false;
+
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static enum fw_upload_err tdx_fw_write(struct fw_upload *fwl, const u8 *data,
+				       u32 offset, u32 size, u32 *written)
+{
+	struct tdx_fw_upload_status *status = fwl->dd_handle;
+	int ret;
+
+	if (status->cancel_request) {
+		status->cancel_request = false;
+		return FW_UPLOAD_ERR_CANCELED;
+	}
+
+	/*
+	 * tdx_fw_write() always processes all data on the first call with
+	 * offset == 0. Since it never returns partial success (it either
+	 * succeeds completely or fails), there is no subsequent call with
+	 * non-zero offsets.
+	 */
+	WARN_ON_ONCE(offset);
+	ret = seamldr_install_module(data, size);
+	switch (ret) {
+	case 0:
+		*written = size;
+		return FW_UPLOAD_ERR_NONE;
+	case -EBUSY:
+		return FW_UPLOAD_ERR_BUSY;
+	case -EIO:
+		return FW_UPLOAD_ERR_HW_ERROR;
+	case -ENOSPC:
+		return FW_UPLOAD_ERR_WEAROUT;
+	case -ENOMEM:
+		return FW_UPLOAD_ERR_RW_ERROR;
+	default:
+		return FW_UPLOAD_ERR_FW_INVALID;
+	}
+}
+
+static enum fw_upload_err tdx_fw_poll_complete(struct fw_upload *fwl)
+{
+	/*
+	 * TDX Module updates are completed in the previous phase
+	 * (tdx_fw_write()). If any error occurred, the previous phase
+	 * would return an error code to abort the update process. In
+	 * other words, reaching this point means the update succeeded.
+	 */
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static void tdx_fw_cancel(struct fw_upload *fwl)
+{
+	struct tdx_fw_upload_status *status = fwl->dd_handle;
+
+	status->cancel_request = true;
+}
+
+static const struct fw_upload_ops tdx_fw_ops = {
+	.prepare = tdx_fw_prepare,
+	.write = tdx_fw_write,
+	.poll_complete = tdx_fw_poll_complete,
+	.cancel = tdx_fw_cancel,
+};
+
+static void seamldr_init(struct device *dev)
+{
+	const struct tdx_sys_info *tdx_sysinfo = tdx_get_sysinfo();
+	int ret;
+
+	if (WARN_ON_ONCE(!tdx_sysinfo))
+		return;
+
+	if (!IS_ENABLED(CONFIG_INTEL_TDX_MODULE_UPDATE))
+		return;
+
+	if (!tdx_supports_runtime_update(tdx_sysinfo))
+		pr_info("Current TDX Module cannot be updated. Consider BIOS updates\n");
+
+	tdx_fwl = firmware_upload_register(THIS_MODULE, dev, "seamldr_upload",
+					   &tdx_fw_ops, &tdx_fw_upload_status);
+	ret = PTR_ERR_OR_ZERO(tdx_fwl);
+	if (ret)
+		pr_err("failed to register module uploader %d\n", ret);
+}
+
+static void seamldr_deinit(void)
+{
+	if (tdx_fwl)
+		firmware_upload_unregister(tdx_fwl);
+}
+
+static int tdx_host_probe(struct faux_device *fdev)
+{
+	seamldr_init(&fdev->dev);
+	return 0;
+}
+
+static void tdx_host_remove(struct faux_device *fdev)
+{
+	seamldr_deinit();
+}
+
+static struct faux_device_ops tdx_host_ops = {
+	.probe		= tdx_host_probe,
+	.remove		= tdx_host_remove,
+};
+
 static struct faux_device *fdev;
 
 static int __init tdx_host_init(void)
@@ -107,7 +229,7 @@ static int __init tdx_host_init(void)
 	if (!x86_match_cpu(tdx_host_ids) || !tdx_get_sysinfo())
 		return -ENODEV;
 
-	fdev = faux_device_create_with_groups(KBUILD_MODNAME, NULL, NULL, tdx_host_groups);
+	fdev = faux_device_create_with_groups(KBUILD_MODNAME, NULL, &tdx_host_ops, tdx_host_groups);
 	if (!fdev)
 		return -ENODEV;
 
-- 
2.47.3


