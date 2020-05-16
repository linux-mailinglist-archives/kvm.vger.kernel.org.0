Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F701D6052
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 12:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgEPKLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 06:11:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:36854 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgEPKLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 06:11:23 -0400
IronPort-SDR: j24N9k/zXf59IPwOv2k3gdDfMQDrtrBamy3lkMwEgALJR8W7psFbBTq4leUWQ+YE1k8D4e3uDN
 kbwk6mU7Wobw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 03:11:23 -0700
IronPort-SDR: TNk+UMuSMDVjjh2YitQdFTVG7AgpGoifVcsx496qPMiJmSgfztrHYq0d/ZSgY6Q33aAfFWfSas
 QZbPuban1IGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="281484351"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.249.40.45])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2020 03:11:21 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: [PATCH 6/6] rpmsg: add a device ID to also bind to the ADSP device
Date:   Sat, 16 May 2020 12:11:09 +0200
Message-Id: <20200516101109.2624-7-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
References: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ADSP device uses the RPMsg API to connect vhost and VirtIO SOF
Audio DSP drivers on KVM host and guest.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index f3bd050..ebe3f19 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -949,6 +949,7 @@ static void rpmsg_remove(struct virtio_device *vdev)
 
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_RPMSG, VIRTIO_DEV_ANY_ID },
+	{ VIRTIO_ID_ADSP, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
 
-- 
1.9.3

