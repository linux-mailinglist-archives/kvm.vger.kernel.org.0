Return-Path: <kvm+bounces-20680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E5FB91C27D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 17:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7C642802AB
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 15:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1884C1CB301;
	Fri, 28 Jun 2024 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L281UsoW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDF11C2336;
	Fri, 28 Jun 2024 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719588001; cv=none; b=PTOlQjg9GB2BFMbejZMQPAqyPnfhMJDqSiJumMd/SaJdVOxxqjm3BZeQ6GxK8lNIx3oSNXIlKYsj5cbubDUeTPUO/siulm9aMNhiT/mkPlSL2vdKVjKCUBRs5pWkq8N95eKGokCFNTRESaico+fIeEWDpuSZZ0pxCdd42BafRAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719588001; c=relaxed/simple;
	bh=3I4qytfU1UkShz8BnwuREmBojQJIahzWA24/ByvF5Os=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IPLppcf4kO8romoKbCWBH1fQU/tb/XB5iNtMWMqlhLqQ3y+zWFUxqCl55XLgH+tSbny/XwoBCzddusQv43yGXpdbogBbSAjZDM+zW9YBoYf2+X935DYyfH4Xmm/rWV3hiNo0riadiwb5qXakxCXrN6E13lIJINTs9jkwzGFNsiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L281UsoW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719588000; x=1751124000;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3I4qytfU1UkShz8BnwuREmBojQJIahzWA24/ByvF5Os=;
  b=L281UsoWVssHfMl+PfA04aEGS84eiFvZd2O6v6/dy2XcFprt+wszWpz9
   DvgAB+Oqc7vDLQPMlqlvLiHgTS+RISU/hjOK61wTjh4P548SDE5VfPnyt
   zn4wzTev9imAWDOapcMLtUTZ+Pnt5rd3d/v6JSAgkeXDv0SWKf3LdK1fg
   jCiaxSDI5bvhrUNhH7dAzgcP9dOM1E0v1GK8tz2gYny/ygqz0hHqHmURZ
   XglTTzg6bQy3bz/PfSKJTD5xKpgWs9Ldhx2/YVdahopcmrmJx3XRCpunD
   rbBalrwP+Hj87kd7TE0rp5ruGPXmBOG8IYld18XLIbxZF63WFsT5j3+mY
   Q==;
X-CSE-ConnectionGUID: MGoOhvq6QNih6FoaftcOOw==
X-CSE-MsgGUID: Kdv8Vbm7QridZPxGg8PBXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="42195707"
X-IronPort-AV: E=Sophos;i="6.09,169,1716274800"; 
   d="scan'208";a="42195707"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 08:19:59 -0700
X-CSE-ConnectionGUID: w/00j5kkSKC7Ae7PujqBPQ==
X-CSE-MsgGUID: rb0JCCsZRNiSX+Z+MEO3yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,169,1716274800"; 
   d="scan'208";a="75972129"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 08:19:57 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	kevin.tian@intel.com,
	jgg@nvidia.com,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio: Get/put KVM only for the first/last vfio_df_open/close in cdev path
Date: Fri, 28 Jun 2024 23:18:45 +0800
Message-ID: <20240628151845.22166-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the device cdev path, adjust the handling of the KVM reference count to
only increment with the first vfio_df_open() and decrement after the final
vfio_df_close(). This change addresses a KVM reference leak that occurs
when a device cdev file is opened multiple times and attempts to bind to
iommufd repeatedly.

Currently, vfio_df_get_kvm_safe() is invoked prior to each vfio_df_open()
in the cdev path during iommufd binding. The corresponding
vfio_device_put_kvm() is executed either when iommufd is unbound or if an
error occurs during the binding process.

However, issues arise when a device binds to iommufd more than once. The
second vfio_df_open() will fail during iommufd binding, and
vfio_device_put_kvm() will be triggered, setting device->kvm to NULL.
Consequently, when iommufd is unbound from the first successfully bound
device, vfio_device_put_kvm() becomes ineffective, leading to a leak in the
KVM reference count.

Below is the calltrace that will be produced in this scenario when the KVM
module is unloaded afterwards, reporting "BUG kvm_vcpu (Tainted: G S):
Objects remaining in kvm_vcpu on __kmem_cache_shutdown()".

Call Trace:
 <TASK>
 dump_stack_lvl+0x80/0xc0
 slab_err+0xb0/0xf0
 ? __kmem_cache_shutdown+0xc1/0x4e0
 ? rcu_is_watching+0x11/0x50
 ? lock_acquired+0x144/0x3c0
 __kmem_cache_shutdown+0x1b7/0x4e0
 kmem_cache_destroy+0xa6/0x260
 kvm_exit+0x80/0xc0 [kvm]
 vmx_exit+0xe/0x20 [kvm_intel]
 __x64_sys_delete_module+0x143/0x250
 ? ktime_get_coarse_real_ts64+0xd3/0xe0
 ? syscall_trace_enter+0x143/0x210
 do_syscall_64+0x6f/0x140
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/device_cdev.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bb1817bd4ff3..3b85d01d1b27 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -65,6 +65,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 {
 	struct vfio_device *device = df->device;
 	struct vfio_device_bind_iommufd bind;
+	bool put_kvm = false;
 	unsigned long minsz;
 	int ret;
 
@@ -101,12 +102,15 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 	}
 
 	/*
-	 * Before the device open, get the KVM pointer currently
+	 * Before the device's first open, get the KVM pointer currently
 	 * associated with the device file (if there is) and obtain
-	 * a reference.  This reference is held until device closed.
+	 * a reference.  This reference is held until device's last closed.
 	 * Save the pointer in the device for use by drivers.
 	 */
-	vfio_df_get_kvm_safe(df);
+	if (device->open_count == 0) {
+		vfio_df_get_kvm_safe(df);
+		put_kvm = true;
+	}
 
 	ret = vfio_df_open(df);
 	if (ret)
@@ -129,7 +133,8 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 out_close_device:
 	vfio_df_close(df);
 out_put_kvm:
-	vfio_device_put_kvm(device);
+	if (put_kvm)
+		vfio_device_put_kvm(device);
 	iommufd_ctx_put(df->iommufd);
 	df->iommufd = NULL;
 out_unlock:

base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f
-- 
2.43.2


