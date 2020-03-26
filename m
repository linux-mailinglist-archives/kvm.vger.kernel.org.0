Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0781937F5
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 06:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgCZFll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 01:41:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:26877 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgCZFlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 01:41:40 -0400
IronPort-SDR: 5HZHFUDl52leJJNQvJ2lPmtA/9E4zm1X9P1OMI9snd3Ky0tdDM+8m+i5FsCEs26BVRnnYvVMDk
 +9TYy7xAVv3A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 22:41:40 -0700
IronPort-SDR: sFznkQhR+w+6OcLtC/sm6RMZ1bl5a3O1T3PyMuBYlLSeNP+h21TgDIHDcNTDkgXRsVCVqf6W2x
 1ptFnUhGLHyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393862307"
Received: from zhaji-mobl3.ccr.corp.intel.com (HELO dell-xps.ccr.corp.intel.com) ([10.249.174.174])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2020 22:41:38 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, kevin.tian@intel.com,
        intel-gvt-dev@lists.freedesktop.org,
        "Jiang, Dave" <dave.jiang@intel.com>
Subject: [PATCH v2 1/2] Documentation/driver-api/vfio-mediated-device.rst: update for aggregation support
Date:   Thu, 26 Mar 2020 13:41:35 +0800
Message-Id: <20200326054136.2543-2-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326054136.2543-1-zhenyuw@linux.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update doc for mdev aggregation support. Describe mdev generic
parameter directory under mdev device directory.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 .../driver-api/vfio-mediated-device.rst       | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834b..29c29432a847 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -269,6 +269,9 @@ Directories and Files Under the sysfs for Each mdev Device
   |--- [$MDEV_UUID]
          |--- remove
          |--- mdev_type {link to its type}
+         |--- mdev [optional]
+	     |--- aggregated_instances [optional]
+	     |--- max_aggregation [optional]
          |--- vendor-specific-attributes [optional]
 
 * remove (write only)
@@ -281,6 +284,22 @@ Example::
 
 	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
 
+* mdev directory (optional)
+
+Vendor driver could create mdev directory to specify extra generic parameters
+on mdev device by its type. Currently aggregation parameters are defined.
+Vendor driver should provide both items to support.
+
+1) aggregated_instances (read/write)
+
+Set target aggregated instances for device. Reading will show current
+count of aggregated instances. Writing value larger than max_aggregation
+would fail and return error.
+
+2) max_aggregation (read only)
+
+Show maxium instances for aggregation.
+
 Mediated device Hot plug
 ------------------------
 
-- 
2.25.1

