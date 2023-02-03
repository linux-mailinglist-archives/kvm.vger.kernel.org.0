Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A5A68925E
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjBCIdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 03:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjBCIdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 03:33:52 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A46B66F8A
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 00:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675413229; x=1706949229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmXRKWy5ZFKKndQf1wsA8tFOL8az3jnsBzxF82eYX7I=;
  b=Uh2GHAhCsac4oXv64JHwhaRUyNRskvvcLorgpNmDJAxxVF5D3Pklha52
   EzZe2H9X7mRp03jw4mF563mh8cmlNtiVETEsTjJ4Nozyi+0yliZMAEnvE
   wJvgBN5BqAqepUqJcWGKjKQkAgeKvSG3MoUdpSD8h6DoBd64q8FK4HjOG
   gLlBvRQCYElInq7mOWUekNNutr/3EzOxl7ou2wJb7GeCHhu3A93ql/fDF
   LzY2W+qcgt+G/FKHX3KVFLfiAfSbJi4f/B5Z7dLGsc1LmpmHCwpd8ug5D
   yY7IF/02pI2zqrinm6CuWWBmoJUh49A4UHOa0Zqhzik8DkwTbSkwbXzRn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="391089873"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="391089873"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 00:33:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="667581569"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="667581569"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 03 Feb 2023 00:33:47 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, kvm@vger.kernel.org
Subject: [PATCH v2 1/2] vfio: Update the kdoc for vfio_device_ops
Date:   Fri,  3 Feb 2023 00:33:44 -0800
Message-Id: <20230203083345.711443-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230203083345.711443-1-yi.l.liu@intel.com>
References: <20230203083345.711443-1-yi.l.liu@intel.com>
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

this is missed when adding bind_iommufd/unbind_iommufd and attach_ioas.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/vfio.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 35be78e9ae57..cc7685386b53 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -70,6 +70,10 @@ struct vfio_device {
  *
  * @init: initialize private fields in device structure
  * @release: Reclaim private fields in device structure
+ * @bind_iommufd: Called when binding the device to an iommufd
+ * @unbind_iommufd: Opposite of bind_iommufd
+ * @attach_ioas: Called when attaching device to an IOAS/HWPT managed by the
+ *		 bound iommufd. Undo in unbind_iommufd.
  * @open_device: Called when the first file descriptor is opened for this device
  * @close_device: Opposite of open_device
  * @read: Perform read(2) on device file descriptor
-- 
2.34.1

