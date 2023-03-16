Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6946D6BD00E
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCPM4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCPMzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:55:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3011DB99;
        Thu, 16 Mar 2023 05:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678971341; x=1710507341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JW3PYKWoybv02jkMZv3/3uD6SqSJnbCZLDmpFVRAyn4=;
  b=nC1SzkNP/csw5Cick0IOFSGSBVUoYNbCMdMR5Yj9AUu2bReUKQpjg6Mr
   NPD0ZcatuXOl6r6jyILWj4MitwZ3n6kDIing97mlFyH+kNzDPje3UsVRz
   zm+7F7caeJclIzpq2byC74RIjx1Bm57++Cl7iGwQUcUf8B9WC4KpoBXEz
   m+1O4gcCvDf5wmh6mFf6uHMk49kEwmYDHScsvoTM7Bfc3xW3xuliV6eFZ
   hz7paYmu3yW8xQtmgeaLfl079+wmdKRMk1dsH2coZlmTYGhBrIE5DL76p
   XtS9de2Ox3yEO3vxf7Bn+qMfTSQVDxgz0adbuDOqHeLWzSiuPUlpIy3GO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336668009"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336668009"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:55:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="790277748"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="790277748"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 05:55:40 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH v7 03/22] vfio: Remove vfio_file_is_group()
Date:   Thu, 16 Mar 2023 05:55:15 -0700
Message-Id: <20230316125534.17216-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316125534.17216-1-yi.l.liu@intel.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

since no user of vfio_file_is_group() now.

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
index 5a2e8a9d538d..a689c64432b7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -247,7 +247,6 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  * External user API
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file);
-bool vfio_file_is_group(struct file *file);
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
-- 
2.34.1

