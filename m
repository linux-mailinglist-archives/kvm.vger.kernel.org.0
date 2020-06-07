Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32201F0BC6
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 16:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgFGOMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jun 2020 10:12:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42210 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727009AbgFGOL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jun 2020 10:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BdT/NVEYKIP5krUx3MbnbeOT2Gkkz8v5cdPwDSMfuzw=;
        b=EQDwV0mobcDsgEqgAWZITbPyPU1dwr3Hm6EmRdsUqh/DydzMCOq8jh0SGl5zHdOD33YAM1
        IXjmQ8FZGEL0XtwXuMUkBOMYiUhZ6PLc9z/fWh1n6V37cRa725gH00Ubm8vz5x5RWETlt0
        t6cdfCTDcGnccd5zYCCGp1fNMYzKJdo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-Jvo1AxGQNhuCiWsG20P-Lg-1; Sun, 07 Jun 2020 10:11:55 -0400
X-MC-Unique: Jvo1AxGQNhuCiWsG20P-Lg-1
Received: by mail-wr1-f69.google.com with SMTP id w4so6066981wrl.13
        for <kvm@vger.kernel.org>; Sun, 07 Jun 2020 07:11:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BdT/NVEYKIP5krUx3MbnbeOT2Gkkz8v5cdPwDSMfuzw=;
        b=jXTDIuS9n1zSiNpzLurHDskF+sG8NWoVyKBS3UBxUnNWtbfwykvBhhcWXKb0ma2Egc
         krpaXGn6HmJBVH69jYnsx4GO/wtmFJ4JDK6jvNHOK4opC8YCbugmfFfOCnlWoiOe1qzd
         Ld3Xpy6Rh0q5KC2C1dOmv5typQfbrch8q4CdJ2mHoiPYD0PSTJuCU1rhi+v4bRRrfM/Y
         HLvnRWYWlXQbzgE+j6qM4OKraj2Xk1hv/tckZ8jyFpwcqNBauSizeeeFCRP5d0tXu7pp
         yAXkyYuwUieM4LbdepTxtd32VMYFVh12fuX/may8HVhsiaeLTmNXEWOJ1bG/FfUNBqOQ
         c9rQ==
X-Gm-Message-State: AOAM530h6MvD7mgM5JQyEPiv6fv6IAw3UoEvZIgu4/qxU0AMZM5HS2VA
        10yJUZn6iypNOs683GQgycNb4WdW6/YIT51GidaRKKgI4sq9A2kcCq2phDW5oUQxm07Y8PuhuK1
        4yqKicRu8laP2
X-Received: by 2002:adf:aa42:: with SMTP id q2mr20101726wrd.360.1591539113491;
        Sun, 07 Jun 2020 07:11:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEuiY3dY5m3J+lc+g7iAjevWjCfgDBijLQ0kLevfltCIsWHMIGkkxV9D36m8hDgKdaJ2qeiA==
X-Received: by 2002:adf:aa42:: with SMTP id q2mr20101707wrd.360.1591539113282;
        Sun, 07 Jun 2020 07:11:53 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id c70sm8895722wme.32.2020.06.07.07.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:52 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 13/13] vhost: drop head based APIs
Message-ID: <20200607141057.704085-14-mst@redhat.com>
References: <20200607141057.704085-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607141057.704085-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Everyone's using buf APIs, no need for head based ones anymore.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 36 ++++++++----------------------------
 drivers/vhost/vhost.h | 12 ------------
 2 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 72ee55c810c4..e6931b760b61 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2299,12 +2299,12 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	return 1;
 }
 
-/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
+/* Revert the effect of fetch_buf. Useful for error handling. */
+static
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 {
 	vq->last_avail_idx -= n;
 }
-EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
 /* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
  * A negative code is returned on error. */
@@ -2464,8 +2464,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
+static
 int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 		     unsigned count)
 {
@@ -2499,10 +2498,8 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	return r;
 }
-EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
+static
 int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 {
 	struct vring_used_elem heads = {
@@ -2512,14 +2509,17 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 
 	return vhost_add_used_n(vq, &heads, 1);
 }
-EXPORT_SYMBOL_GPL(vhost_add_used);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using vhost_signal. */
 int vhost_put_used_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf)
 {
 	return vhost_add_used(vq, buf->id, buf->in_len);
 }
 EXPORT_SYMBOL_GPL(vhost_put_used_buf);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using vhost_signal. */
 int vhost_put_used_n_bufs(struct vhost_virtqueue *vq,
 			  struct vhost_buf *bufs, unsigned count)
 {
@@ -2580,26 +2580,6 @@ void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(vhost_signal);
 
-/* And here's the combo meal deal.  Supersize me! */
-void vhost_add_used_and_signal(struct vhost_dev *dev,
-			       struct vhost_virtqueue *vq,
-			       unsigned int head, int len)
-{
-	vhost_add_used(vq, head, len);
-	vhost_signal(dev, vq);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
-
-/* multi-buffer version of vhost_add_used_and_signal */
-void vhost_add_used_and_signal_n(struct vhost_dev *dev,
-				 struct vhost_virtqueue *vq,
-				 struct vring_used_elem *heads, unsigned count)
-{
-	vhost_add_used_n(vq, heads, count);
-	vhost_signal(dev, vq);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
-
 /* return true if we're sure that avaiable ring is empty */
 bool vhost_vq_avail_empty(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 28eea0155efb..264a2a2fae97 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -197,11 +197,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
 
-int vhost_get_vq_desc(struct vhost_virtqueue *,
-		      struct iovec iov[], unsigned int iov_count,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num);
-void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
 			struct iovec iov[], unsigned int iov_count,
 			unsigned int *out_num, unsigned int *in_num,
@@ -209,13 +204,6 @@ int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
 void vhost_discard_avail_bufs(struct vhost_virtqueue *,
 			      struct vhost_buf *, unsigned count);
 int vhost_vq_init_access(struct vhost_virtqueue *);
-int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
-int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-		     unsigned count);
-void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
-			       unsigned int id, int len);
-void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
-			       struct vring_used_elem *heads, unsigned count);
 int vhost_put_used_buf(struct vhost_virtqueue *, struct vhost_buf *buf);
 int vhost_put_used_n_bufs(struct vhost_virtqueue *,
 			  struct vhost_buf *bufs, unsigned count);
-- 
MST

