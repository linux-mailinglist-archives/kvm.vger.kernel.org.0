Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CE11F536E
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgFJLg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:36:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21952 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728642AbgFJLgU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 07:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g1mhrQ6NM5wYShJMoCPQWA/YwUtZgT5jddxZW0yxgs8=;
        b=e4exZrjI9HtnU7rNPcCffQSp6dcxNVzPTIOk9WOlEhevQmVFckVdD6wwrPz4beGBi294ot
        GjFTWLDX72WBmnpB0hJPN9LiHTo0iVrvnEclvOeUEX+xGkA7PpqXqYrhzlVXgqwx2LDFxi
        aDoHlxPegSPHT/43Gw5cVqlu6RSSu3w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-5HhCwuLwPtykJnzcYNG_Wg-1; Wed, 10 Jun 2020 07:36:17 -0400
X-MC-Unique: 5HhCwuLwPtykJnzcYNG_Wg-1
Received: by mail-wr1-f71.google.com with SMTP id i6so952028wrr.23
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g1mhrQ6NM5wYShJMoCPQWA/YwUtZgT5jddxZW0yxgs8=;
        b=WHU9ZEGGq6vd/OQ+FcaulB0GmQb2yOtUqrsfQlgHecMcVyvwX/uQJS2rqJNqagwZTn
         d8CTwai3IUfCgiwatJ0n6HzkzSBF4dQ826OFg8P/VuR/tJKAU7q2UJwH5raIPt1oP/UD
         cnvpGL4QHjDGgofT+iRjdIktq1ZqhI2Omv4I7AP5b9hwPoLbKWNOki7lGODUvqC2qmwe
         VptHSVY/+0ckRHv7SKoZK33CfDWJorlj2jpnKnBILvAOiy4NwlQ0YyhfatVuoWff6Muc
         C2Kkg79Iuvm1WTKAgwq4vS627HUgB7dyfEp67Xfga1126WG2MWr48C6su6YxYSQqkIuE
         ajvA==
X-Gm-Message-State: AOAM531eezsouDJ9rdtlVVeiPhI78GmMWUCXnUHf+J8p9Uz1f3J6aSaD
        C5p23u2I2SAU34H2uniGad2fdXh6E15Lhm2ZKmQhi2YGCiMs6iITFcj5Xf77Uul69XvJjxJ3ZHD
        lmDje7OFQl2YR
X-Received: by 2002:a1c:254:: with SMTP id 81mr2746858wmc.93.1591788976421;
        Wed, 10 Jun 2020 04:36:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFkt3Ubc8PKFjtb6gY/lDXcBZnr6E3I6m79bNAQFz95Fybj8NNv1w+aulFwppsq1zCYoyKZw==
X-Received: by 2002:a1c:254:: with SMTP id 81mr2746830wmc.93.1591788976169;
        Wed, 10 Jun 2020 04:36:16 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id z22sm6583776wmf.9.2020.06.10.04.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:15 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 07/14] fixup! vhost: format-independent API for used
 buffers
Message-ID: <20200610113515.1497099-8-mst@redhat.com>
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

---
 drivers/vhost/vhost.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e5763d81bf0f..7a587b13095c 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2421,7 +2421,7 @@ int vhost_get_avail_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf,
 err:
 	unfetch_descs(vq);
 
-	return ret ? ret : vq->num;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vhost_get_avail_buf);
 
@@ -2433,6 +2433,27 @@ void vhost_discard_avail_bufs(struct vhost_virtqueue *vq,
 }
 EXPORT_SYMBOL_GPL(vhost_discard_avail_bufs);
 
+/* This function returns the descriptor number found, or vq->num (which is
+ * never a valid descriptor number) if none was found.  A negative code is
+ * returned on error. */
+int vhost_get_vq_desc(struct vhost_virtqueue *vq,
+		      struct iovec iov[], unsigned int iov_size,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num)
+{
+	struct vhost_buf buf;
+	int ret = vhost_get_avail_buf(vq, &buf,
+				      iov, iov_size, out_num, in_num,
+				      log, log_num);
+
+	if (likely(ret > 0))
+		return buf->id;
+	if (likely(!ret))
+		return vq->num;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
+
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 {
-- 
MST

