Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAFF2EB3E7
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 21:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbhAEUFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 15:05:06 -0500
Received: from mga05.intel.com ([192.55.52.43]:14406 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbhAEUFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 15:05:06 -0500
IronPort-SDR: mXEdgsqJ0U4A6fzttv33ZbeEjvgxPSgTK+ZokuEPTjNhuh61GlkFkbEKfA8fcDWcWmCVFe9oLz
 ydwPsUnmAjeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="261934920"
X-IronPort-AV: E=Sophos;i="5.78,477,1599548400"; 
   d="scan'208";a="261934920"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 12:04:24 -0800
IronPort-SDR: xjsH2WvWErXywO1BWDz22++CIca0sBkRVMiBPz75aTuMupNPawTIZ0uPXmkoXyE8ZGwESOECrz
 IxTmdec2McoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,477,1599548400"; 
   d="scan'208";a="565566229"
Received: from lkp-server02.sh.intel.com (HELO 4242b19f17ef) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 05 Jan 2021 12:04:22 -0800
Received: from kbuild by 4242b19f17ef with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kwsZ3-0008N3-Te; Tue, 05 Jan 2021 20:04:21 +0000
Date:   Wed, 6 Jan 2021 04:03:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [RFC PATCH] vfio: vfio_vaddr_valid() can be static
Message-ID: <20210105200353.GA77614@f127c8abdc20>
References: <1609861013-129801-6-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609861013-129801-6-git-send-email-steven.sistare@oracle.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 vfio_iommu_type1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index cc9b61d8b57bab..697e661f8295f8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -500,7 +500,7 @@ static bool vfio_iommu_contained(struct vfio_iommu *iommu)
 }
 
 
-bool vfio_vaddr_valid(struct vfio_iommu *iommu, struct vfio_dma *dma)
+static bool vfio_vaddr_valid(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	while (dma->suspended) {
 		mutex_unlock(&iommu->lock);
