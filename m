Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693911E76F7
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgE2Hif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:38:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:50721 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbgE2Hib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:38:31 -0400
IronPort-SDR: lg30QldO24Egav1kCFtqq5e/z5u8G5p1AXA1TQ6ndoOcsQpxJ8D6rio/JbUigDca8v5DtLBmYm
 0kyardEDJKBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:38:07 -0700
IronPort-SDR: VhVukwj3FxbexdkWDnEa8YRPfUWFA4O+VGqjUKd6HZB/oio2bXuKxVn/OMlal9Jy8ZmZii2uVY
 BYDxjpI3S8iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890477"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:38:03 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [RFC 12/12] rpmsg: add a device ID to also bind to the ADSP device
Date:   Fri, 29 May 2020 09:37:22 +0200
Message-Id: <20200529073722.8184-13-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
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

