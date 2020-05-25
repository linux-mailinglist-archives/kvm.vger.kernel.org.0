Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76321E10E3
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391007AbgEYOpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:45:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:34259 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391008AbgEYOpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:45:13 -0400
IronPort-SDR: DX0zY6l+pLVDf6rgR8E2EWmBJkujP8cXGW/JEcbEMKBLYqOoy2RYSRNYksnibulsRZUAd6spbR
 6SEnMx4kl68w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 07:45:12 -0700
IronPort-SDR: zkxzvcDlu7YhxUWaXww6Xjup5WrQ+OgFCWYNvXJUq7bXTFBKQFEy+varkrdlxaeqbniSPNFEwQ
 46vmiot/0mTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,433,1583222400"; 
   d="scan'208";a="266165867"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.249.41.109])
  by orsmga003.jf.intel.com with ESMTP; 25 May 2020 07:45:10 -0700
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
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v2 4/5] rpmsg: update documentation
Date:   Mon, 25 May 2020 16:44:57 +0200
Message-Id: <20200525144458.8413-5-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200525144458.8413-1-guennadi.liakhovetski@linux.intel.com>
References: <20200525144458.8413-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rpmsg_create_ept() takes struct rpmsg_channel_info chinfo as its last
argument, not a u32 value.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 Documentation/rpmsg.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
index 24b7a9e..4f9bc4f 100644
--- a/Documentation/rpmsg.txt
+++ b/Documentation/rpmsg.txt
@@ -194,7 +194,7 @@ Returns 0 on success and an appropriate error value on failure.
 
   struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
 		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
-		void *priv, u32 addr);
+		void *priv, struct rpmsg_channel_info chinfo);
 
 every rpmsg address in the system is bound to an rx callback (so when
 inbound messages arrive, they are dispatched by the rpmsg bus using the
-- 
1.9.3

