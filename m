Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADEC1D604B
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgEPKLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 06:11:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:36845 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgEPKLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 06:11:19 -0400
IronPort-SDR: v81L85Yx3ys+Z0z3n6rw+j5ptI4oHvW4IpmUZyyPsF526Qm3JOjpKGpHkqU4eOtman1gDhb8P1
 TzJQlLqKoEAg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 03:11:19 -0700
IronPort-SDR: DGpy3Tqi52bkm/JmqEKrsnl8KC12m4PXkcHPNsj68zOpmluEXXtke5/Rfp/qVQ3k/W9B9KiO4T
 acqZ+yH5wCOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="281484338"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.249.40.45])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2020 03:11:17 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: [PATCH 4/6] rpmsg: update documentation
Date:   Sat, 16 May 2020 12:11:07 +0200
Message-Id: <20200516101109.2624-5-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
References: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
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

