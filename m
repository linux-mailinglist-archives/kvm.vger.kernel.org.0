Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C34E6901EB
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 09:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBIIMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 03:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBIIMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 03:12:16 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B863B0D1
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 00:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675930335; x=1707466335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmXRKWy5ZFKKndQf1wsA8tFOL8az3jnsBzxF82eYX7I=;
  b=eWiB3egN1b43xtgcPURTUdudEcVJNiDqASF0Ryq5hF9h9CxU06BnrRhH
   QIDz9fAHtEYjZW2Qs+3trLXbRK0TQ+g7bimSNBYeHsYGDMLMHOQTcEA5L
   6y66yHSrWi8uKDQgeQwoDUghgQaDUIvwU1fcoXQWjSwftpnKcgYpAmJVv
   5ZHakb7yTJ75GO9pEyJgPnd0q5jV6nX+DBbYEdluLKFOFaXkkKDQ4Ncfn
   VMbSQzhwDHOqjrojgOUAsYumiUdR2RC+YgdAhIj3+MJoJYUhQUIP4/KZd
   CjtQ49AdOdGCm7KzvxIZuUihQMm/hcOMKooXeRB04BvgjpeAl5P956KJo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309694719"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="309694719"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 00:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="667553958"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="667553958"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 09 Feb 2023 00:12:12 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [PATCH v4 1/2] vfio: Update the kdoc for vfio_device_ops
Date:   Thu,  9 Feb 2023 00:12:09 -0800
Message-Id: <20230209081210.141372-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209081210.141372-1-yi.l.liu@intel.com>
References: <20230209081210.141372-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

