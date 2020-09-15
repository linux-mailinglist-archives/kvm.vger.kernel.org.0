Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24CF26B4BA
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 01:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgIOXab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 19:30:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:59908 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgIOX31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 19:29:27 -0400
IronPort-SDR: 6WUEQ+pPJrTJW16WmztSGy3dbfBg2+goEAFsNm+KF2PDuLZGt5kTxXhHkjSu0HJ5UjkqFmNxNd
 gPBZtE9wVY2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147120160"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="147120160"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:29:26 -0700
IronPort-SDR: EAu9yNq+VH45IieXXe+oaFmwbky6X7Vd9Y6W2Fb1GLbSz/u9fj/tlipxM08N6PvN9cFwKCRf9e
 1pKj0B6TfO1A==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="319642576"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:29:24 -0700
Subject: [PATCH v3 16/18] dmaengine: idxd: add ABI documentation for
 mediated device support
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 15 Sep 2020 16:29:24 -0700
Message-ID: <160021256431.67751.2268297306094926564.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Lin <jing.lin@intel.com>

Add the sysfs attribute bits in ABI/stable for mediated device and guest
support.

Signed-off-by: Jing Lin <jing.lin@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ABI/stable/sysfs-driver-dma-idxd |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-dma-idxd b/Documentation/ABI/stable/sysfs-driver-dma-idxd
index b44183880935..6bb925b55027 100644
--- a/Documentation/ABI/stable/sysfs-driver-dma-idxd
+++ b/Documentation/ABI/stable/sysfs-driver-dma-idxd
@@ -77,6 +77,12 @@ Contact:        dmaengine@vger.kernel.org
 Description:    The operation capability bit mask specify the operation types
 		supported by the this device.
 
+What:           /sys/bus/dsa/devices/dsa<m>/ims_size
+Date:           Sep 8, 2020
+KernelVersion:  5.10.0
+Contact:        dmaengine@vger.kernel.org
+Description:	Number of entries in the interrupt message storage table.
+
 What:           /sys/bus/dsa/devices/dsa<m>/state
 Date:           Oct 25, 2019
 KernelVersion:  5.6.0
@@ -139,8 +145,9 @@ Date:           Oct 25, 2019
 KernelVersion:  5.6.0
 Contact:        dmaengine@vger.kernel.org
 Description:    The type of this work queue, it can be "kernel" type for work
-		queue usages in the kernel space or "user" type for work queue
-		usages by applications in user space.
+		queue usages in the kernel space, "user" type for work queue
+		usages by applications in user space, or "mdev" type for
+		VFIO mediated devices.
 
 What:           /sys/bus/dsa/devices/wq<m>.<n>/cdev_minor
 Date:           Oct 25, 2019

