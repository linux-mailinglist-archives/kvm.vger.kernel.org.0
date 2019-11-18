Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F734100281
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfKRKgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:36:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47030 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRKgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 05:36:01 -0500
Received: by mail-wr1-f68.google.com with SMTP id b3so18783667wrs.13
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 02:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O6snPj4zRF7PnmdnvOs9XQoZqp3Knhprhwo6jIsI7pk=;
        b=EDk8Fod4KYVy3Ku3JKZWOBfrr3rK7aA/YCCASUklWuJkEwjDeojA2EuQOaogcy1Ce4
         91VzGpCS11mVTlMh97BzYznrWt0ZB0pWImcJc1CMhWmZWbJJK7kBQS/ukmqK7LhSRM+k
         FuxXis9+tN4+RJ/2LWZVcQL+JLlu725EEPJ/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O6snPj4zRF7PnmdnvOs9XQoZqp3Knhprhwo6jIsI7pk=;
        b=mDswTYucywRuOlZ7PiexvQp8FZzF1oRpeIh7EMmhpRG7HxnI10foX487uRTrFD+rxy
         GpTCqmk1OxLOx5mBYrRaZZbb4d9W3TSWvtcO/SO5D2yfTTLvLkF0mnm+Z1Id07GaXhx6
         KFj1/571QVWKEdc9Gg8RImn39uwOeC61zCfdla1BOUHyWKsA1R3qYeRZ213D5pYyoPHy
         zFLJ6OLN3cxVwBBh3gfNUmxjAEraoch1ao8+BOTlV7y4aFfO6+ytgxNL35GZmouoLw7l
         kdnXIog6Aut6rex5giR751scvTB/nk4AxP69d2CaqQ8HnWDTc+yiEOD24+zb9zxkJD04
         Jd9Q==
X-Gm-Message-State: APjAAAU7ZvaBy1lHLCEeXP9EuDDx8LJlHu95pVd6GBBD29e19shuZkgQ
        N5O35Cr6LGkRFUImIil3lHBYtg==
X-Google-Smtp-Source: APXvYqxwliWhIEUAO9jqkKlsD9SR6F/Gar8dxbJUUc2j0kGt2YK8h8lt3xuihOzMEA3CN5LZFOMWFw==
X-Received: by 2002:adf:ec42:: with SMTP id w2mr15988758wrn.32.1574073359659;
        Mon, 18 Nov 2019 02:35:59 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id j2sm22749200wrt.61.2019.11.18.02.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 02:35:58 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: [PATCH 14/15] sample/vfio-mdev/mbocs: Remove dma_buf_k(un)map support
Date:   Mon, 18 Nov 2019 11:35:35 +0100
Message-Id: <20191118103536.17675-15-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191118103536.17675-1-daniel.vetter@ffwll.ch>
References: <20191118103536.17675-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No in-tree users left.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: kvm@vger.kernel.org
--
Ack for merging this through drm trees very much appreciated.
-Daniel
---
 samples/vfio-mdev/mbochs.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index ac5c8c17b1ff..3cc5e5921682 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -891,26 +891,10 @@ static void mbochs_release_dmabuf(struct dma_buf *buf)
 	mutex_unlock(&mdev_state->ops_lock);
 }
 
-static void *mbochs_kmap_dmabuf(struct dma_buf *buf, unsigned long page_num)
-{
-	struct mbochs_dmabuf *dmabuf = buf->priv;
-	struct page *page = dmabuf->pages[page_num];
-
-	return kmap(page);
-}
-
-static void mbochs_kunmap_dmabuf(struct dma_buf *buf, unsigned long page_num,
-				 void *vaddr)
-{
-	kunmap(vaddr);
-}
-
 static struct dma_buf_ops mbochs_dmabuf_ops = {
 	.map_dma_buf	  = mbochs_map_dmabuf,
 	.unmap_dma_buf	  = mbochs_unmap_dmabuf,
 	.release	  = mbochs_release_dmabuf,
-	.map		  = mbochs_kmap_dmabuf,
-	.unmap		  = mbochs_kunmap_dmabuf,
 	.mmap		  = mbochs_mmap_dmabuf,
 };
 
-- 
2.24.0

