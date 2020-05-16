Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CE01D6042
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 12:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgEPKLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 06:11:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:36845 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgEPKLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 06:11:15 -0400
IronPort-SDR: jYpYtmQh4/+mTblRI/0nP4Bn9gHZMLxcoFRtOxnIa1wJm9XoHkc+Cq+2tvcvSsPBHVlUAz2SLy
 Pv1FtL29A1cg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 03:11:15 -0700
IronPort-SDR: HT4+gOiJayDcu3E0Dlut6ndQmru5BvKxs6/Yl2cp1LrgSIOF3tFFjynOnp88gqMqvip5/G15pQ
 MPPIdcCRufqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="281484335"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.249.40.45])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2020 03:11:13 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: [PATCH 2/6] vhost: (cosmetic) remove a superfluous variable initialisation
Date:   Sat, 16 May 2020 12:11:05 +0200
Message-Id: <20200516101109.2624-3-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
References: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even the compiler is able to figure out that in this case the
initialisation is superfluous.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 47060d8..e22d4a9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -895,7 +895,7 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
 
 #define vhost_put_user(vq, x, ptr)		\
 ({ \
-	int ret = -EFAULT; \
+	int ret; \
 	if (!vq->iotlb) { \
 		ret = __put_user(x, ptr); \
 	} else { \
-- 
1.9.3

