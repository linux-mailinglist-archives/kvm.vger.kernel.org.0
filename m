Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A34229B05
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 17:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgGVPJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 11:09:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:33994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731539AbgGVPJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 11:09:40 -0400
IronPort-SDR: aJi00ENdKLnq+cBtScPAAjrTqZHEZpzLiJOGy3pM4cooXn8OE/0FGymLcb+BwgiYhDJky4MqGD
 kZ+WUTSDOl9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="149513625"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="149513625"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 08:09:40 -0700
IronPort-SDR: eXlLnoRtPhfDmJIKns5h5jOZ7CfeHJJl9KxxD/i2f2k3+hv58yJ6//v2kjWy0aCE3T4rLFgOzB
 gwngnw6t6Ggw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="432407326"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.58.190])
  by orsmga004.jf.intel.com with ESMTP; 22 Jul 2020 08:09:37 -0700
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
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH v4 3/4] rpmsg: update documentation
Date:   Wed, 22 Jul 2020 17:09:26 +0200
Message-Id: <20200722150927.15587-4-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rpmsg_create_ept() takes struct rpmsg_channel_info chinfo as its last
argument, not a u32 value. The first two arguments are also updated.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 Documentation/rpmsg.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
index 24b7a9e1a5f9..1ce353cb232a 100644
--- a/Documentation/rpmsg.txt
+++ b/Documentation/rpmsg.txt
@@ -192,9 +192,9 @@ Returns 0 on success and an appropriate error value on failure.
 
 ::
 
-  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
-		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
-		void *priv, u32 addr);
+  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_device *rpdev,
+					  rpmsg_rx_cb_t cb, void *priv,
+					  struct rpmsg_channel_info chinfo);
 
 every rpmsg address in the system is bound to an rx callback (so when
 inbound messages arrive, they are dispatched by the rpmsg bus using the
-- 
2.27.0

