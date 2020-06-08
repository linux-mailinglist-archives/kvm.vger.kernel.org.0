Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B680C1F193E
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgFHMxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:53:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23930 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729630AbgFHMxQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 08:53:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YC9C1bg85UqEARLoLzVVH0wVxPzUMhgdZVeMnCOVW8I=;
        b=gRUmgU326j1p6kGpqao0FSpSDCrPYIf0L1OKAiTke8et6l9xZPDqqlcMzXBORaXew9fyg0
        wBCr3U29l8UWfRtEX9I7PQZ75wDVtXpDz/b4sCrLWCWVcb8b3KXSMHELLqfRJ9SNoUdeC/
        RlLhjBXSidy/fcAv5rrNuywTC0/YrDQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-vb5_uQL1MzijG2CWAraDVg-1; Mon, 08 Jun 2020 08:53:03 -0400
X-MC-Unique: vb5_uQL1MzijG2CWAraDVg-1
Received: by mail-wm1-f69.google.com with SMTP id h6so3899325wmb.7
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 05:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YC9C1bg85UqEARLoLzVVH0wVxPzUMhgdZVeMnCOVW8I=;
        b=hOxo7ST6MjuGSgvGRu1rZU00LA2OrD38YBmz/R/CJu+JfxPO2awokFrosK0+TdCf17
         brNo5rLN5uUPJODbRSq9dDJHwZGke7YHqd7CXM00ZOp7/WLm0pmNwhNnwiw+sVv/aHPY
         IsCrN7fOrlcThAaBySLrskZSW+67g1AG5tn6xcbUWIumnCK6fwwUR8T+CH1uRhtckaI4
         749QK2w3fByABAMb/l8mosQHOQwe9bq6Vs+PpB3KegrNYw7+G0g6izsFgB/5b3Ctjs9c
         VmeiBYFpFE/pqZH4qy7rLwgYPq/Xsybw2waIGrEpmJYnTn94Nf7oZOtnJMntsfYLXqpP
         pZwA==
X-Gm-Message-State: AOAM5324IJs0pOn1ofgvPY8azqV6DBHlUGXadokfZDikQ/Urcjyl+1X4
        pK/LmK5s3d0BdyimZTFe6J7IV2JhJTgAuqfyVH3Xx1NRo+7n3214mciqBzgDEWZWHR7ITPx4ZRp
        LWNVoe36twFLc
X-Received: by 2002:a1c:59c7:: with SMTP id n190mr15634972wmb.61.1591620782175;
        Mon, 08 Jun 2020 05:53:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycvWcSZ9pgrB8OOPKZQyruJy8vStQkFo1WrrMhroFInHbRmdrcF8cq2oRf/qnvmhPPXJjLnQ==
X-Received: by 2002:a1c:59c7:: with SMTP id n190mr15634952wmb.61.1591620781966;
        Mon, 08 Jun 2020 05:53:01 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id r12sm23319300wrc.22.2020.06.08.05.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:53:01 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:53:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 04/11] vhost: reorder functions
Message-ID: <20200608125238.728563-5-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
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
 drivers/vhost/vhost.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 41d6b132c234..334529ebecab 100644
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

