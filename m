Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED321E76EF
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgE2Hi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:38:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:50721 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgE2Hi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:38:26 -0400
IronPort-SDR: Y6miWXOpxNbLZi5itsAkagFk110wHUEjuJh+1mg8QwU7NwyMe+ONBpKUcxQdfS9Q0DEqHgQ8xg
 YyrJlkXkk6DA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:37:47 -0700
IronPort-SDR: rTKJqOPMqQRVF+KQ32cbe/ifTXICDLVtQ3m+aFwEahmUdOZJowqsOjT43n9LppcjwF9qJavRSw
 rQUKHIhek6qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890408"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:37:45 -0700
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
Subject: [RFC 07/12] ASoC: SOF: use a macro instead of a hard-coded value
Date:   Fri, 29 May 2020 09:37:17 +0200
Message-Id: <20200529073722.8184-8-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

target_stats in sof_suspend should contain one of SOF_DSP_PM_* power
state macros, not a hard-coded value 0.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 sound/soc/sof/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 5e804a7..c7aa2cf 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -174,7 +174,7 @@ static int sof_resume(struct device *dev, bool runtime_resume)
 static int sof_suspend(struct device *dev, bool runtime_suspend)
 {
 	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
-	u32 target_state = 0;
+	u32 target_state = SOF_DSP_PM_D0;
 	int ret;
 
 	/* do nothing if dsp suspend callback is not set */
-- 
1.9.3

