Return-Path: <kvm+bounces-49543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 539BEAD9879
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 01:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF77D1BC0858
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3D128FFCB;
	Fri, 13 Jun 2025 23:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="WQrD3AGd"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0902798EF;
	Fri, 13 Jun 2025 23:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749856062; cv=none; b=d9asnONznc0dyht4pP7jHLr5XiQdnAQj3EV4rgTrCxM25j/AMm/U/P8xDwSUYaYGgXC0sOVAuDafcSsgNGnIsyCvCEeZq5bT/urnIPE57gr/wNSpi6u4VaonvyZR749LxpPvk8FIuhDB2bIEdg6abPZbGAdiRAUPIs2EjKd3HXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749856062; c=relaxed/simple;
	bh=5LBmNvxGQVphTBm+dhvh3993X6dnlRF+TMf6MHhy5xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1UV5PdmhU6EJlHqRfw0uEjxj/ukV8NoErX86ghwFht0/alIJCjzJ4prbt2QLCjgnIb1EFIj9lzbLgh0WvsZhcE3V4nKd/tVGIpPt5tmT8D6J9L/+R6N8RcJckSa3TY75wwC6O0zEz2kfyKAit6r/cMI2QzThcUxoJXK/AYufd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=WQrD3AGd; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=waQo5q91jU8Ji7flII4J5+MFXZhCzcoj/TS8hqA7oVQ=; b=WQrD3AGd8Ew03Pa6
	GjvTc8x4Y+t+pUy1C2N1njppwCWMEBFmRE+zmRqQArYR4JS3JF/6i0mXBznS6Gv0C6XdR29EA1pHx
	42NwtvJpSSLgR3Fd4XP0+OSIZpZKnqgImYpSM/bcaOoYPEnNzIdzBGvQmBTQG0L5MtZwCNbUgQC2z
	DC7vmIfpMWHYxKmNIwoKTKu9GMdLjo+/Uu9goVvBVlBgJlRTMsihvXo3U7Nxq0miyx1uaDfN33XME
	L62K8QnbUtZhCzrmfPglJDFLtB9OQShfqf2gn9OGZ6ABa0TIOBB7a5oX8SYYXph1KQWKqTtjvycPT
	XhyqWqe2F2/q5d3/ZA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uQDUj-009ZoB-08;
	Fri, 13 Jun 2025 23:07:33 +0000
From: linux@treblig.org
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/2] vhost: vringh: Remove unused functions
Date: Sat, 14 Jun 2025 00:07:31 +0100
Message-ID: <20250613230731.573512-3-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613230731.573512-1-linux@treblig.org>
References: <20250613230731.573512-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

The functions:
  vringh_abandon_kern()
  vringh_abandon_user()
  vringh_iov_pull_kern() and
  vringh_iov_push_kern()
were all added in 2013 by
commit f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
but have remained unused.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/vhost/vringh.c | 61 ------------------------------------------
 include/linux/vringh.h |  7 -----
 2 files changed, 68 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 67a028d6fb5f..c99070da39a6 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -779,22 +779,6 @@ ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
 }
 EXPORT_SYMBOL(vringh_iov_push_user);
 
-/**
- * vringh_abandon_user - we've decided not to handle the descriptor(s).
- * @vrh: the vring.
- * @num: the number of descriptors to put back (ie. num
- *	 vringh_get_user() to undo).
- *
- * The next vringh_get_user() will return the old descriptor(s) again.
- */
-void vringh_abandon_user(struct vringh *vrh, unsigned int num)
-{
-	/* We only update vring_avail_event(vr) when we want to be notified,
-	 * so we haven't changed that yet. */
-	vrh->last_avail_idx -= num;
-}
-EXPORT_SYMBOL(vringh_abandon_user);
-
 /**
  * vringh_complete_user - we've finished with descriptor, publish it.
  * @vrh: the vring.
@@ -998,51 +982,6 @@ int vringh_getdesc_kern(struct vringh *vrh,
 }
 EXPORT_SYMBOL(vringh_getdesc_kern);
 
-/**
- * vringh_iov_pull_kern - copy bytes from vring_iov.
- * @riov: the riov as passed to vringh_getdesc_kern() (updated as we consume)
- * @dst: the place to copy.
- * @len: the maximum length to copy.
- *
- * Returns the bytes copied <= len or a negative errno.
- */
-ssize_t vringh_iov_pull_kern(struct vringh_kiov *riov, void *dst, size_t len)
-{
-	return vringh_iov_xfer(NULL, riov, dst, len, xfer_kern);
-}
-EXPORT_SYMBOL(vringh_iov_pull_kern);
-
-/**
- * vringh_iov_push_kern - copy bytes into vring_iov.
- * @wiov: the wiov as passed to vringh_getdesc_kern() (updated as we consume)
- * @src: the place to copy from.
- * @len: the maximum length to copy.
- *
- * Returns the bytes copied <= len or a negative errno.
- */
-ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
-			     const void *src, size_t len)
-{
-	return vringh_iov_xfer(NULL, wiov, (void *)src, len, kern_xfer);
-}
-EXPORT_SYMBOL(vringh_iov_push_kern);
-
-/**
- * vringh_abandon_kern - we've decided not to handle the descriptor(s).
- * @vrh: the vring.
- * @num: the number of descriptors to put back (ie. num
- *	 vringh_get_kern() to undo).
- *
- * The next vringh_get_kern() will return the old descriptor(s) again.
- */
-void vringh_abandon_kern(struct vringh *vrh, unsigned int num)
-{
-	/* We only update vring_avail_event(vr) when we want to be notified,
-	 * so we haven't changed that yet. */
-	vrh->last_avail_idx -= num;
-}
-EXPORT_SYMBOL(vringh_abandon_kern);
-
 /**
  * vringh_complete_kern - we've finished with descriptor, publish it.
  * @vrh: the vring.
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index af8bd2695a7b..49e7cbc9697a 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -175,9 +175,6 @@ int vringh_complete_multi_user(struct vringh *vrh,
 			       const struct vring_used_elem used[],
 			       unsigned num_used);
 
-/* Pretend we've never seen descriptor (for easy error handling). */
-void vringh_abandon_user(struct vringh *vrh, unsigned int num);
-
 /* Do we need to fire the eventfd to notify the other side? */
 int vringh_need_notify_user(struct vringh *vrh);
 
@@ -235,10 +232,6 @@ int vringh_getdesc_kern(struct vringh *vrh,
 			u16 *head,
 			gfp_t gfp);
 
-ssize_t vringh_iov_pull_kern(struct vringh_kiov *riov, void *dst, size_t len);
-ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
-			     const void *src, size_t len);
-void vringh_abandon_kern(struct vringh *vrh, unsigned int num);
 int vringh_complete_kern(struct vringh *vrh, u16 head, u32 len);
 
 bool vringh_notify_enable_kern(struct vringh *vrh);
-- 
2.49.0


