Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D0E1EBC96
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 15:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgFBNGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 09:06:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45149 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728188AbgFBNGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 09:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Doki9eOY+Vt0bEelnsffrGLeK+qhziALFfS1p6mljA=;
        b=FOQAzT8mQe4AXVguQhjZNMWDzXVxAzBY7YV5PmjRHwbVnVIDxg/kg5Z1Zkpyt4AiYnHX7W
        9N9v2WvHrvbzuK/qFRyxGVmWoZg2frMmX06nVfUeW/BG61ShbUOlpmUJal0vz3PhBGiAnk
        rHrjqf1uPL5hzpnn+cF2HVEDYFiutXU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-rNsK_MGuPK2OejaAhz1rmw-1; Tue, 02 Jun 2020 09:06:11 -0400
X-MC-Unique: rNsK_MGuPK2OejaAhz1rmw-1
Received: by mail-wm1-f72.google.com with SMTP id s15so913710wmc.8
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 06:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Doki9eOY+Vt0bEelnsffrGLeK+qhziALFfS1p6mljA=;
        b=umdM47xRRxHl+pnt23qIKeC5zW5ImPLtf9EaNd7pqr9VPDb+z8jeG9liy8BSbqsIQA
         pVT2j+Q0bu8d7oe9OsllPFG3k4Cbj+8cngbHANt7LZeU3hROu6zopJ1pxlNH5NBToBEr
         fRqeBAJADPp4eCTDMLkzqlHQALNdFLp7pnGzw7JipM6dSZulTjA8Jn/q3Xhi0ywNie8i
         4jXq/IVWgzd9UDO71nv46bCyQ8Z2TkUrfpHa16t7c/a+F5DTkzNA4EscnZ7zZf4jtIxK
         NJgfHoIkk1ZZtrxha0T7c2iLqC829+hSHpS4QohVVAdpFzJTmLMlpB5sMVVuA0JPoHHD
         i+Qw==
X-Gm-Message-State: AOAM532guiOxKESffxNw/NS3f5otvdOQ5oFkw1jnxaEhVkeSUHGSaE+M
        uxF8VsqjB5iajmbLYQ4QLnRaiHrdDcDgjt+usoL+qDpeG6U4fI6tIAzL08PeA85wYe2dESN9J85
        rMeNkJs59NQHG
X-Received: by 2002:adf:d852:: with SMTP id k18mr11135185wrl.177.1591103170685;
        Tue, 02 Jun 2020 06:06:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJze7fjrtd3HAxuSDspGJm8TtOVdc3+cTfx7SISy8qbvd/4VQ9hQeFCUsVzEXG1sYbQZL/2f6g==
X-Received: by 2002:adf:d852:: with SMTP id k18mr11135174wrl.177.1591103170498;
        Tue, 02 Jun 2020 06:06:10 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id k14sm3631200wrq.97.2020.06.02.06.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:10 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 06/13] vhost: reorder functions
Message-ID: <20200602130543.578420-7-mst@redhat.com>
References: <20200602130543.578420-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602130543.578420-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
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
 drivers/vhost/vhost.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index bd52b44b0d23..b4a6e44d56a8 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2256,6 +2256,13 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	return 1;
 }
 
+/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
+void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
+{
+	vq->last_avail_idx -= n;
+}
+EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
+
 /* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
  * A negative code is returned on error. */
 static int fetch_descs(struct vhost_virtqueue *vq)
@@ -2370,26 +2377,6 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
-/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
-void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
-{
-	vq->last_avail_idx -= n;
-}
-EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
-
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
@@ -2459,6 +2446,19 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
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

