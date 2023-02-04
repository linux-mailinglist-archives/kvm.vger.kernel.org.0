Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF7F68AA9F
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 15:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjBDOmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 09:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjBDOmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 09:42:12 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585EA33468
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 06:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675521731; x=1707057731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmXRKWy5ZFKKndQf1wsA8tFOL8az3jnsBzxF82eYX7I=;
  b=lmPTTSVsZtb4M5LIK6dRxHiRZ19HyCt2B+4Dm2osFEC4ypnjD1JySI2q
   /yMHgAEgtGUAqD/lIVmo1RyBYsFLoefnjZwf6ChkW1Jq9mPQms3K2Umrg
   zi7WRrtYkGRKpkWOoh/v2cdKc6ZO3GqJk8FuI+sM2O7uWUoVpLlH7/HGr
   /lKQW6Np/Tla3WOzz+2CXqlEla/z5UWEaAduWM9DrBDEBj3RbDZMazoYL
   arUNu8/RW49UGqE5WOASURzSG1VdkLcQphpthbG8gwllvzhDtBSHriKsX
   uFVyUcQ7gFbaw6Xa1fLkod9wZ43qwstKchggod5P9aQysDFEdyS2emJd0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="415163491"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="415163491"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 06:42:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="994809708"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="994809708"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 04 Feb 2023 06:42:10 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, kvm@vger.kernel.org
Subject: [PATCH v3 1/2] vfio: Update the kdoc for vfio_device_ops
Date:   Sat,  4 Feb 2023 06:42:07 -0800
Message-Id: <20230204144208.727696-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204144208.727696-1-yi.l.liu@intel.com>
References: <20230204144208.727696-1-yi.l.liu@intel.com>
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

