Return-Path: <kvm+bounces-21245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7070692C7AD
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 02:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A49B31C2261C
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C42B2CA5;
	Wed, 10 Jul 2024 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XBhVcxXB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247F4A32
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720572113; cv=none; b=BZlFOnTNBrQQwojHAUU1PM6cWAjhG4KxH7vNlKsp8ib7itiGE7gFx+DYII5QY0SME+F5Jq0UBWITMK5ey/3sLV5w/Iqq+fkJKezP22K72Q/dT2ka4GzsIqKn7ImnP4A+1btdQMBWWlk3r8sp/ftCELOzBHw5Eu+Mbt+S21LJF/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720572113; c=relaxed/simple;
	bh=X5vJ6cYBVsVDUqsfpOgb+vi+Oh8FkmuKhzRarlqoKyE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=pyt09Apo7ou6rV5t4rYBgapBwHYjrkqKsyvx24ya1Z/7ZH1NSP40KC1kOjx2B/IFA6lSVISR7TzUCiAjyEK9ItcjIT+YpSqzw/HTAN3wuGa4z/8DSpGom0BhC3rVbejYNMOsswN+DnbRtZp9Y7ICHdnpYrggOJxJDBtRhPY6cEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XBhVcxXB; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720572112; x=1752108112;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X5vJ6cYBVsVDUqsfpOgb+vi+Oh8FkmuKhzRarlqoKyE=;
  b=XBhVcxXB7+LiBmqa+aRXFJRAxfrQP8jQ7RHHOdifu08Lf56IEnX099pF
   dIrHEAAAWKHAqLDnn4R2gkox9F3hanw0SOgS6q2KQ/S2roZIR3WXsVhz7
   bStZfZhoySEoYFGx9/CmLzEnXw63cT89LVs3e8wrCLdUXSJhd0Yx66nz3
   /Yiy60WAPEQmvFZOa7Swif/Dau2F56fwU5dmJ5NvBkXuS4LmQjsvovTIT
   i8EvI/VxGUqqnjMB6jkcuCPjSem3zGiVMpFF4l0cUaR4Bs7vzDU/QrHXE
   Xyw5L89RmTy/Iso/ywpnDifLJU3vCbba5d+CjWmoJKZzQn0/ck0Cy3lsU
   A==;
X-CSE-ConnectionGUID: 7CE9dUCiSIOn3XacINvoMg==
X-CSE-MsgGUID: F/9AgpxQTHiJStoFdYjv9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="17496058"
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="17496058"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 17:41:51 -0700
X-CSE-ConnectionGUID: +eL9Ml5tSTmMY36fbX7ZPw==
X-CSE-MsgGUID: B6iQKgtPR822xb20hIdAeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="48705118"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 09 Jul 2024 17:41:51 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	=?UTF-8?q?=C5=BDilvinas=20=C5=BDaltiena?= <zaltys@natrix.lt>,
	Beld Zhang <beldzhang@gmail.com>
Subject: [PATCH] vfio/pci: Init the count variable in collecting hot-reset devices
Date: Tue,  9 Jul 2024 17:41:50 -0700
Message-Id: <20240710004150.319105-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The count variable is used without initialization, it results in mistakes
in the device counting and crashes the userspace if the get hot reset info
path is triggered.

Fixes: f6944d4a0b87 ("vfio/pci: Collect hot-reset devices to local buffer")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219010
Reported-by: Žilvinas Žaltiena <zaltys@natrix.lt>
Cc: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 59af22f6f826..0a7bfdd08bc7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1260,7 +1260,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	struct vfio_pci_hot_reset_info hdr;
 	struct vfio_pci_fill_info fill = {};
 	bool slot = false;
-	int ret, count;
+	int ret, count = 0;
 
 	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
-- 
2.34.1


