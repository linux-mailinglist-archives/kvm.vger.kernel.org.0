Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E3B22A31
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 05:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbfETDCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 May 2019 23:02:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:6635 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfETDCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 May 2019 23:02:23 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 May 2019 20:02:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,490,1549958400"; 
   d="scan'208";a="173475588"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 19 May 2019 20:02:19 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hSYZ8-00023w-Rx; Mon, 20 May 2019 11:02:18 +0800
Date:   Mon, 20 May 2019 11:02:17 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kbuild-all@01.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
Subject: [RFC PATCH] vfio: vfio_iommu_type1: vfio_iommu_type1_caps() can be
 static
Message-ID: <20190520030217.GA48406@lkp-kbuild06>
References: <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Fixes: f10b2b74bbea ("vfio: vfio_iommu_type1: implement VFIO_IOMMU_INFO_CAPABILITIES")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 vfio_iommu_type1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9435647..46a4939 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1704,8 +1704,8 @@ static int vfio_iommu_type1_zpci_grp(struct iommu_domain *domain,
 	return ret;
 }
 
-int vfio_iommu_type1_caps(struct vfio_iommu *iommu, struct vfio_info_cap *caps,
-			  size_t size)
+static int vfio_iommu_type1_caps(struct vfio_iommu *iommu, struct vfio_info_cap *caps,
+				 size_t size)
 {
 	struct vfio_domain *d;
 	unsigned long total_size, fn_size, grp_size;
