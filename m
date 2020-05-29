Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BC31E76F6
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgE2Hie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:38:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:50721 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgE2Hia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:38:30 -0400
IronPort-SDR: JHRl0xPqE2l2/IpIqymyllCZI/IYUSyG2sUKmy2603oRFmD5fpdrnz5yP8d4DY0Q/2uLUqA0gD
 jXTxcWcsydJQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:38:03 -0700
IronPort-SDR: kVIyTg3lFV2z1o+iG4DUP5XoMcQRVi5pCnOOquBizTUL1VmJzyuc4CV7dghqQb9iKdG0JagS4R
 AOmKai9QDekA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890460"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:38:00 -0700
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
Subject: [RFC 11/12] rpmsg: increase buffer size and reduce buffer number
Date:   Fri, 29 May 2020 09:37:21 +0200
Message-Id: <20200529073722.8184-12-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is hard to imagine use-cases where 512 buffers would really be
needed, whereas 512 bytes per buffer might be too little. Change this
to use 16 16KiB buffers instead.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 include/linux/virtio_rpmsg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_rpmsg.h b/include/linux/virtio_rpmsg.h
index 679be8b..1add468 100644
--- a/include/linux/virtio_rpmsg.h
+++ b/include/linux/virtio_rpmsg.h
@@ -72,8 +72,8 @@ enum rpmsg_ns_flags {
  * can change this without changing anything in the firmware of the remote
  * processor.
  */
-#define MAX_RPMSG_NUM_BUFS	512
-#define MAX_RPMSG_BUF_SIZE	512
+#define MAX_RPMSG_NUM_BUFS	(512 / 32)
+#define MAX_RPMSG_BUF_SIZE	(512 * 32)
 
 /* Address 53 is reserved for advertising remote services */
 #define RPMSG_NS_ADDR		53
-- 
1.9.3

