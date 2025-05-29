Return-Path: <kvm+bounces-47944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D88AC7812
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2902502DC7
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AA125FA2B;
	Thu, 29 May 2025 05:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JCchpuBE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD112580CB;
	Thu, 29 May 2025 05:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497383; cv=none; b=S6pXXNpqXYNvI6LVXmzOtfqPmDwXnL6Za/I5pnq/j8cuUzaptXLYurRVhSxeJyvOKGcxhgpAet+HmMaJhAtMLJ6k8Ergn+/3fs4LzFBMeSxZfuh7ME0jS1pvgrxeJ2Byt2pJh+NMzw4f+MCghBiz83Lq2Xod1hbhavgCn/3EKac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497383; c=relaxed/simple;
	bh=GBS29KYqTli4hPK2EW9uHxwbeQwMH4GW8Dj2RBOdOlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lvkq2gmUJRp0y+idTV02lNKy/2xF+0/GEpYVoQzJWdSkutHdCqss8IiYUjcXmw8Om7ZCI82Hy3vIHcwtAT8C1BpgVIlz77Ci8hWMD7sytTGwMTSnw6DR2LwEG8th5xtQHPJNqM+br4gF6xWJ0UH5mvXH+e+41AuGmGWxKdlnjuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JCchpuBE; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497382; x=1780033382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GBS29KYqTli4hPK2EW9uHxwbeQwMH4GW8Dj2RBOdOlw=;
  b=JCchpuBEG5oWAmwIx4pr1om6Y2fnzh+5vKdb6uOZPEYNUWtD7Z0lu72b
   xnZ0cVv18/1kBMhhfsGc4hvwVJLRXUZKIdPPpFpdnGVGrJG6+5541/xIm
   6wY4X+1V56AVgLhRdpx5Ht0WBsQs+sfPqub7VPlxjkkAt+wA8uaC46jUj
   ESKAksLibCx3dsaLtncEq949sD0ZoOxt3UFUO3jId/TZEOAShEg86yut5
   NISoAXUgm3WOQz4Bq//bOUfDlQYCMdclaUuJcTdc5rJEehuVuOYGOjqny
   3fqei9gr9Tyn+uWeLjfSyI+RnXbb4IgHVn4I+8DnBrFbtXbkkjMSdYFKM
   g==;
X-CSE-ConnectionGUID: zPuKi/gASru/aXHyfUB/4g==
X-CSE-MsgGUID: +x8L3JYFRte7wLWK5+aJ7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963106"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963106"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:43:02 -0700
X-CSE-ConnectionGUID: /k+bvgEYSzm1XrkUJbzfUQ==
X-CSE-MsgGUID: wtMPvTBJQZCcYfzGFJRK1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443386"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:42:55 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 13/30] fixup! iommufd/selftest: Sync iommufd_device_bind() change to selftest
Date: Thu, 29 May 2025 13:34:56 +0800
Message-Id: <20250529053513.1592088-14-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sync up the additional struct kvm * parameter.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/iommu/iommufd/selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 18d9a216eb30..d070807757f2 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -992,7 +992,7 @@ static int iommufd_test_mock_domain(struct iommufd_ucmd *ucmd,
 		goto out_sobj;
 	}
 
-	idev = iommufd_device_bind(ucmd->ictx, &sobj->idev.mock_dev->dev,
+	idev = iommufd_device_bind(ucmd->ictx, &sobj->idev.mock_dev->dev, NULL,
 				   &idev_id);
 	if (IS_ERR(idev)) {
 		rc = PTR_ERR(idev);
-- 
2.25.1


