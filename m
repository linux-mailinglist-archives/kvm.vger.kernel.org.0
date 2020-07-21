Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1092284BE
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgGUQEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:04:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:17661 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730190AbgGUQEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:04:23 -0400
IronPort-SDR: XQLv4MZvQY6h/6QqQrwL1HUwPAU2LD/OXVdNX+DaDn+lgzYav59W0Tba6Rup2r/wdjA+QUXJb5
 1bpmPBTBCqUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="151499224"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="151499224"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:04:17 -0700
IronPort-SDR: e1G/riTdKBZmtlGuH16tlJmv6ftO/0opkm3RNbIwWYTxk34fKp+bvBUMSL7lgxcbyvJk8AMqXw
 dh0oRj/QGmuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="319952585"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002.fm.intel.com with ESMTP; 21 Jul 2020 09:04:14 -0700
Subject: [PATCH RFC v2 18/18] dmaengine: idxd: add ABI documentation for
 mediated device support
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, jgg@mellanox.com,
        rafael@kernel.org, dave.hansen@intel.com, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Jul 2020 09:04:14 -0700
Message-ID: <159534745419.28840.5543479944375440474.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 Documentation/ABI/stable/sysfs-driver-dma-idxd |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-dma-idxd b/Documentation/ABI/stable/sysfs-driver-dma-idxd
index a336d2b2009a..edbcf8a8796c 100644
--- a/Documentation/ABI/stable/sysfs-driver-dma-idxd
+++ b/Documentation/ABI/stable/sysfs-driver-dma-idxd
@@ -1,6 +1,6 @@
 What:		/sys/bus/dsa/devices/dsa<m>/version
-Date:		Apr 15, 2020
-KernelVersion:	5.8.0
+Date:		Jul 5, 2020
+KernelVersion:	5.9.0
 Contact:	dmaengine@vger.kernel.org
 Description:	The hardware version number.
 
@@ -84,6 +84,12 @@ Contact:	dmaengine@vger.kernel.org
 Description:	To indicate if PASID (process address space identifier) is
 		enabled or not for this device.
 
+What:           /sys/bus/dsa/devices/dsa<m>/ims_size
+Date:           Jul 5, 2020
+KernelVersion:  5.9.0
+Contact:        dmaengine@vger.kernel.org
+Description:	Number of entries in the interrupt message storage table.
+
 What:           /sys/bus/dsa/devices/dsa<m>/state
 Date:           Oct 25, 2019
 KernelVersion:  5.6.0
@@ -147,8 +153,9 @@ Date:           Oct 25, 2019
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

