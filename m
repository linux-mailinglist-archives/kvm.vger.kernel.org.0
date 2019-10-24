Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEA7E29C7
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437471AbfJXFIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:08:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:7748 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437475AbfJXFIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:08:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 22:08:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,223,1569308400"; 
   d="scan'208";a="197627658"
Received: from debian-nuc.sh.intel.com ([10.239.160.133])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 22:08:39 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: [PATCH 5/6] Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfio/mdev aggregation support
Date:   Thu, 24 Oct 2019 13:08:28 +0800
Message-Id: <20191024050829.4517-6-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20191024050829.4517-1-zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update vfio/mdev ABI description for new aggregation attributes.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-vfio-mdev b/Documentation/ABI/testing/sysfs-bus-vfio-mdev
index 452dbe39270e..6645ff9a6a6a 100644
--- a/Documentation/ABI/testing/sysfs-bus-vfio-mdev
+++ b/Documentation/ABI/testing/sysfs-bus-vfio-mdev
@@ -85,6 +85,23 @@ Users:
 		a particular <type-id> that can help in understanding the
 		features provided by that type of mediated device.
 
+What:           /sys/.../mdev_supported_types/<type-id>/aggregation
+Date:           October 2019
+Contact:        Zhenyu Wang <zhenyuw@linux.intel.com>
+Description:
+		Reading this attribute will show number of mdev instances
+		that can be aggregated to assign for one mdev device.
+		This is an optional attribute. If this attribute exists,
+		the driver supports to aggregate target mdev type's
+		resources assigned for one mdev device.
+Users:
+		Userspace application should check the number of aggregation
+		instances that could be created before creating mediated device.
+		Create mdev instance with aggregation by applying this,
+		e.g
+		# echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1001,aggregate=XX" > \
+		       /sys/devices/foo/mdev_supported_types/foo-1/create
+
 What:           /sys/.../<device>/<UUID>/
 Date:           October 2016
 Contact:        Kirti Wankhede <kwankhede@nvidia.com>
@@ -109,3 +126,10 @@ Description:
 		is active and the vendor driver doesn't support hot unplug.
 		Example:
 		# echo 1 > /sys/bus/mdev/devices/<UUID>/remove
+
+What:           /sys/.../<device>/<UUID>/aggregated_instances
+Date:           October 2019
+Contact:        Zhenyu Wang <zhenyuw@linux.intel.com>
+Description:
+		This attributes shows number of aggregated instances if this
+		mediated device was created with "aggregate" parameter.
\ No newline at end of file
-- 
2.24.0.rc0

