Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720FF1B3368
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgDUXfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:35:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:36954 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgDUXfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:35:23 -0400
IronPort-SDR: CBv6vkLWbU8jfJ6IfHCADHQIASqxLNemeyhOlbla+m9YIM1MHlCL2GHHucxV3WvJo1a/oBjjeY
 MCkvsDvGrhhg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:35:23 -0700
IronPort-SDR: TsB3fO4zi2456JXzd/fClc/FbQU2+V4BCcehrJuXYFj1PwTrfCLGA17vHSN4OBM/Wg3XKgLR2W
 YgqF215PAvbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="255449736"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003.jf.intel.com with ESMTP; 21 Apr 2020 16:35:22 -0700
Subject: [PATCH RFC 15/15] dmaengine: idxd: add ABI documentation for
 mediated device support
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:35:21 -0700
Message-ID: <158751212189.36773.8197911986164174637.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Lin <jing.lin@intel.com>

Add the sysfs attribute bits in ABI/stable for mediated deivce and guest
support.

Signed-off-by: Jing Lin <jing.lin@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ABI/stable/sysfs-driver-dma-idxd |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-dma-idxd b/Documentation/ABI/stable/sysfs-driver-dma-idxd
index c1adddde23c2..b04cbc5a1827 100644
--- a/Documentation/ABI/stable/sysfs-driver-dma-idxd
+++ b/Documentation/ABI/stable/sysfs-driver-dma-idxd
@@ -76,6 +76,12 @@ Date:		Jan 30, 2020
 KernelVersion:	5.7.0
 Contact:	dmaengine@vger.kernel.org
 Description:	To indicate if PASID (process address space identifier) is
+
+What:           sys/bus/dsa/devices/dsa<m>/ims_size
+Date:           Apr 13, 2020
+KernelVersion:  5.8.0
+Contact:        dmaengine@vger.kernel.org
+Description:	Number of entries in the interrupt message storage table.
 		enabled or not for this device.
 
 What:           sys/bus/dsa/devices/dsa<m>/state
@@ -141,8 +147,16 @@ Date:           Oct 25, 2019
 KernelVersion:  5.6.0
 Contact:        dmaengine@vger.kernel.org
 Description:    The type of this work queue, it can be "kernel" type for work
-		queue usages in the kernel space or "user" type for work queue
-		usages by applications in user space.
+		queue usages in the kernel space, "user" type for work queue
+		usages by applications in user space, or "mdev" type for
+		VFIO mediated devices.
+
+What:           sys/bus/dsa/devices/wq<m>.<n>/uuid
+Date:           Apr 13, 2020
+KernelVersion:  5.8.0
+Contact:        dmaengine@vger.kernel.org
+Description:    The uuid attached to this work queue when the mediated device is
+		created.
 
 What:           sys/bus/dsa/devices/wq<m>.<n>/cdev_minor
 Date:           Oct 25, 2019

