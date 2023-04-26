Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F1C6EF761
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 17:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbjDZPEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 11:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241431AbjDZPE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 11:04:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6176BC;
        Wed, 26 Apr 2023 08:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682521447; x=1714057447;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WFAskGSZ4sRwGClphsOafTN8Hu2qpEcUwsbPFoUsF98=;
  b=Lg0nBpZS5ti7VHkr0VetI6sEuy1eHpb/i3cMen4tSMOfXbANZGnvpgT6
   HEJ+gmyYVSUJG+nC4GQ7gjd9pSRp1bT6hueDd2wqkkN0PMv/5dFqB3I7k
   lWiIdqS+BOVKqqzqaSCFPBcd6+fDDfq+KbWre1m83ktR6jlgY1etkbKK/
   5OiUuyejbW7YK7J74rdeyVimtGzKjJ+aeuLfmm6ucuUpfe3v7aS2xnBVV
   gPvk/flgQqSzioa0NreEgPsqhDnxKpp5TaKNg6Cw4E3BwWflkz4sKqaDC
   x7Dl92OGLJ0HWtaxA2hkKoNPsaMOZqy35XFJgUe4v54gO0pM3zc6XG0Vo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="349944632"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="349944632"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:03:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="805544241"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="805544241"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 26 Apr 2023 08:03:54 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: [PATCH v10 16/22] vfio: Name noiommu vfio_device with "noiommu-" prefix
Date:   Wed, 26 Apr 2023 08:03:15 -0700
Message-Id: <20230426150321.454465-17-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426150321.454465-1-yi.l.liu@intel.com>
References: <20230426150321.454465-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For noiommu device, vfio core names the cdev node with prefix "noiommu-".

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 0f1139126622..c0459872d79a 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -269,10 +269,6 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	ret = dev_set_name(&device->device, "vfio%d", device->index);
-	if (ret)
-		return ret;
-
 	ret = vfio_device_set_group(device, type);
 	if (ret)
 		return ret;
@@ -281,6 +277,11 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (ret)
 		goto err_out;
 
+	ret = dev_set_name(&device->device, "%svfio%d",
+			   device->noiommu ? "noiommu-" : "", device->index);
+	if (ret)
+		goto err_out;
+
 	ret = device_add(&device->device);
 	if (ret)
 		goto err_out;
-- 
2.34.1

