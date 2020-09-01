Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB80259CFB
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 19:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgIARWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 13:22:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:55917 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbgIAPMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 11:12:05 -0400
IronPort-SDR: Yi8Sr5vMSz4huBJpKBQAa6uChiIVNIJr3Il/vQ0fqW8gbrWb1YII5D7zfvN5bvVwwQHVvJ75G2
 c7oXqV4tyYrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="221408238"
X-IronPort-AV: E=Sophos;i="5.76,379,1592895600"; 
   d="scan'208";a="221408238"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2020 08:12:05 -0700
IronPort-SDR: KY3ITyjNybES8RRoN5nLNNm1NBcyDuWPMFZT+NH7uYeYoNN4duRxHzIHvcxKnGkPNz9gw+iQT5
 ydYZmEmEYUFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,379,1592895600"; 
   d="scan'208";a="501776301"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.56.69])
  by fmsmga006.fm.intel.com with ESMTP; 01 Sep 2020 08:12:02 -0700
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
Subject: [PATCH v6 3/4] rpmsg: update documentation
Date:   Tue,  1 Sep 2020 17:11:52 +0200
Message-Id: <20200901151153.28111-4-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rpmsg_create_ept() takes struct rpmsg_channel_info chinfo as its last
argument, not a u32 value. The first two arguments are also updated.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
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
2.28.0

