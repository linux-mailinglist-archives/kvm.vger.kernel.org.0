Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432451F5396
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgFJLiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:38:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55191 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728486AbgFJLgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+SD3Vrt7U6HArLpzqOyIxuZrc1fS29Ei8HX5xaDKKOw=;
        b=XR1X0qwmqNbKqPwY25Jrq/T/gCXJBJtu8LeAEFSbEcKQdDbKDXoMejKUTIdLNJxYYwckwA
        5wrkiDrvlxpcgqO22fmEkRYCll1SwRXYTy8qjk3mhacVkc9FrxltBz3UZ6ZAC5c0bCiupY
        dVvHc7wuv0Uq20VoALRGrKIuX0iVr3U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-BdL4UjK7PpS--xahWFXlYg-1; Wed, 10 Jun 2020 07:36:12 -0400
X-MC-Unique: BdL4UjK7PpS--xahWFXlYg-1
Received: by mail-wr1-f69.google.com with SMTP id l18so979878wrm.0
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+SD3Vrt7U6HArLpzqOyIxuZrc1fS29Ei8HX5xaDKKOw=;
        b=eiCfBIkoWlmNQr9J3erLSB8/u6NarRw7+V/82KSeRxuueHPZ5GUlO30wjD+t/RrPRW
         xjN3qpqp2pMMQcXV8uZ3WA9x7CXQUpIKsp0lKfeRVs8s6h1QClvwXUWJ0zzSRhfScN8Y
         avad/nN7yo+vwJhiz9rjCIINkLw/i0m1bl04HjjSSWub5RrOXpkNJK+6cvrMyG6SNrm9
         6EK6nNxYbx73MFZiYdTVt8dob3LGpctX6s02ByajUuKMsbN0Zh+fY3VIoBnnPzGNxOpM
         /ReL3hIa2HYF2U5H4ScAqrQTqAjC00voSDY8to/eDPaYcY+l/wqykqKGyyEWTqoz1ZM6
         2wVg==
X-Gm-Message-State: AOAM531D6Ojab2ecWPGq6sjGIHFKzF+lQPdFES8O1nxETINWZfSYFbei
        M2w7Qd6ZYVypAxuYai0iZu4tMw5eWdiF15B5OeMuXC3U903iZuGnVMwvagrukmkz1Yp5vA7WX+r
        xI+6pcA4ABhlV
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr2755087wmi.186.1591788970805;
        Wed, 10 Jun 2020 04:36:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxemEaCHMgCrHg7/oKSQ4yFnNXg1fLjZ5OHmMHvyeRIUoWRpQOB/0A8RO0HmZnjlr0fN5RKtA==
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr2755070wmi.186.1591788970615;
        Wed, 10 Jun 2020 04:36:10 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id a1sm6866225wmd.28.2020.06.10.04.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:10 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 05/14] vhost: reorder functions
Message-ID: <20200610113515.1497099-6-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610113515.1497099-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reorder functions in the file to not rely on forward
declarations, in preparation to making them static
down the road.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 28f324fd77df..506208b63126 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2429,19 +2429,6 @@ void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 }
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
-int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
-{
-	struct vring_used_elem heads = {
-		cpu_to_vhost32(vq, head),
-		cpu_to_vhost32(vq, len)
-	};
-
-	return vhost_add_used_n(vq, &heads, 1);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used);
-
 static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 			    struct vring_used_elem *heads,
 			    unsigned count)
@@ -2511,6 +2498,19 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using eventfd. */
+int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
+{
+	struct vring_used_elem heads = {
+		cpu_to_vhost32(vq, head),
+		cpu_to_vhost32(vq, len)
+	};
+
+	return vhost_add_used_n(vq, &heads, 1);
+}
+EXPORT_SYMBOL_GPL(vhost_add_used);
+
 static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
 	__u16 old, new;
-- 
MST

