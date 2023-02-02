Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6028B6876F1
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjBBIC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjBBICR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:02:17 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4B784968
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 00:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675324929; x=1706860929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rPlqgvNiQ6Hq0HUOOBwUiuhC/zkZriPfCZtt4vGs7sM=;
  b=d3aFx0KPp+xXMWvvKxRBVza+gFUWNBbMuw1fV2QN5onkKSOtpyKBWgob
   GpvCDm/w+GGQKXNAJg2ZhYlKAgg41EQRLRkoTKc50/DuzCh7LTBmm7EYM
   9qv5ePhNO69NJ55ViobAzS5PLxMdfInie7qACjr+ikKWZOfMAPu39u8JX
   G6hPFNuxYq4PjXTGatA4sAB9OAZ/LygQCL76SsZwAaqMfhJheQ/8d/T36
   60B8hwfn+FinOn05G3EbtF003r0gye2QnU0t4qbwbPbJULY5tvd6Qxzkx
   QudGi1HsPZOTPb41OnL4NC2hkDHwM0cG+b/T7u3qUXNj1TnDhCnsEFXAe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="355722227"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="355722227"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 00:02:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993990682"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="993990682"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 02 Feb 2023 00:02:03 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, kvm@vger.kernel.org
Subject: [PATCH 1/2] vfio: Update the kdoc for vfio_device_ops
Date:   Thu,  2 Feb 2023 00:02:00 -0800
Message-Id: <20230202080201.338571-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202080201.338571-1-yi.l.liu@intel.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

this is missed when adding bind_iommufd/unbind_iommufd and attach_ioas.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
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

