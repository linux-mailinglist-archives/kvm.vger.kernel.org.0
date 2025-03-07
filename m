Return-Path: <kvm+bounces-40304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A39A55FF2
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 06:25:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CB013B2FA8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 05:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42071990D8;
	Fri,  7 Mar 2025 05:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fvOcLGJa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDD818FC65;
	Fri,  7 Mar 2025 05:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741325113; cv=none; b=qVg2DNHIXtemziD4+IiF9Q3+Kfl3b/fGpeEHweWN3b3ZPGmieyh/msj/khGSlIl78sCtXQuRfBisl06oZ40t14iqCcgGyNCiRGBbGOuotfHQOHTvRlKO7C4+qe4rJbcueZwHEFVdiK08XhE4qtLPujzN8Hj/PQrVzQ/D+IeyQyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741325113; c=relaxed/simple;
	bh=P19fBHxU+0W0QVHozv/yGWTtaEmgDTBHwtw9lxyqAsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz/i33/6OD51tmkMy8U1UXo6Rrn5FyHe9yWXH5k85ShOytjKPwMclCtN+r4C56x5HqBbNDupb9SSuqMmOAXw/vSgRgZWmVrVhFjjq+Bl5AjCCN6y12ZzJyXLbLrLKJ73UKO7ERP+pr8vvHvq1rxcnEr71YhkWlVs4ig4zVFm3WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fvOcLGJa; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741325112; x=1772861112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P19fBHxU+0W0QVHozv/yGWTtaEmgDTBHwtw9lxyqAsM=;
  b=fvOcLGJava1mvr73OV2R/WoX+uBLhR1+RfG4gkraQNo+Ob5v4LSA31KY
   XWI2C0fvoRBdXZF1E3N/fFAlYprRuwUobWOPcSQH1vqpAj75VjY+6Q1n5
   xZlbVUpy4D2s6hwkZh9E7FoE9CxgswA2IGKupaC/2JTnapA/gv73t/WiL
   EqL+L4jOm/n3gVANeSDK88ZtCl8LrO44e5paV25PszjKL5Vy5LpX3VRM6
   P+k8xJEQRW8qJj1iodxdV1zbebApjbyLCEDfkmknqOIc7it7cZyjTNYld
   RQZRupPYD/5lBTEdpkwSXwpquSFoClpt0vNagxrAkzFoFur13ScM9N4WK
   w==;
X-CSE-ConnectionGUID: o4lZL/QrSTacOUpnvIm+eQ==
X-CSE-MsgGUID: ZfdCYmCATa+mcfp+b18JMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46293083"
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="46293083"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 21:25:09 -0800
X-CSE-ConnectionGUID: hA42JP9RRQy2qrNzAJp9BA==
X-CSE-MsgGUID: PLFcfjnuSiGDKCGMfiTgtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="119232483"
Received: from vkasired-desk2.fm.intel.com ([10.105.128.132])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 21:25:09 -0800
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
To: dri-devel@lists.freedesktop.org,
	kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 1/3] vfio: Export vfio device get and put registration helpers
Date: Thu,  6 Mar 2025 21:16:42 -0800
Message-ID: <20250307052248.405803-2-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250307052248.405803-1-vivek.kasireddy@intel.com>
References: <20250307052248.405803-1-vivek.kasireddy@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These helpers are useful for managing additional references taken
on the device from other associated VFIO modules.

Original-patch-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1fd261efc582..620a3ee5d04d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -171,11 +171,13 @@ void vfio_device_put_registration(struct vfio_device *device)
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
+EXPORT_SYMBOL_GPL(vfio_device_put_registration);
 
 bool vfio_device_try_get_registration(struct vfio_device *device)
 {
 	return refcount_inc_not_zero(&device->refcount);
 }
+EXPORT_SYMBOL_GPL(vfio_device_try_get_registration);
 
 /*
  * VFIO driver API
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 000a6cab2d31..2258b0585330 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -279,6 +279,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.48.1


