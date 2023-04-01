Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CCF6D3207
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjDAPSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjDAPSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:39 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2AB20D88;
        Sat,  1 Apr 2023 08:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362318; x=1711898318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GLz5NXI+1KYeMmg5ytUfNGqA8vEqwpVcpTZviemQX7A=;
  b=JgoyUmFQKcln+u79l2MRh9GGhDxkRwxu+aVfPYaWNUH0sQGtjyaof87c
   pRthtC+wiE/QpAbhET9DUKflxaUDADov2g8A558MPQwO8jR+Odo9LJxlC
   nQp9ONU1GPTQAluu2tYJVxEpruYStVhllzuP44WX9OESRqaxlGiawbKc2
   uEyYnakim37V+a7eVfbHazOO45ABs5zU3YZQuEq2QDScHnrGnI+R0NleE
   XpwkR8/XldqYcrd189qFscZqdX0kkSR1hKIkiRLZxw1u2kzwjsD2Lovoi
   vBjnsudNpD0D7iv0kfnCD0B7EotpTviN1KDJCwvaS62byIB6Ho4Ot3oMz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411192"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411192"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937156"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937156"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:37 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v9 03/25] vfio: Remove vfio_file_is_group()
Date:   Sat,  1 Apr 2023 08:18:11 -0700
Message-Id: <20230401151833.124749-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401151833.124749-1-yi.l.liu@intel.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

since no user of vfio_file_is_group() now.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c | 10 ----------
 include/linux/vfio.h |  1 -
 2 files changed, 11 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index ede4723c5f72..4f937ebaf6f7 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -792,16 +792,6 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
-/**
- * vfio_file_is_group - True if the file is a vfio group file
- * @file: VFIO group file
- */
-bool vfio_file_is_group(struct file *file)
-{
-	return vfio_group_from_file(file);
-}
-EXPORT_SYMBOL_GPL(vfio_file_is_group);
-
 bool vfio_group_enforced_coherent(struct vfio_group *group)
 {
 	struct vfio_device *device;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index d9a0770e5fc1..7519ae89fcd6 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -264,7 +264,6 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  * External user API
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file);
-bool vfio_file_is_group(struct file *file);
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
-- 
2.34.1

