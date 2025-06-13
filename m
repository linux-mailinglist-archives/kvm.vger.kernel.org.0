Return-Path: <kvm+bounces-49544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B3BAD987A
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 01:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C71C1BC15F1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F25628FFF3;
	Fri, 13 Jun 2025 23:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="HBh3tjv/"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC5279DD6;
	Fri, 13 Jun 2025 23:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749856062; cv=none; b=Ti0ey0Y4wVis7WnQVjHJWkO0Ke1F0LA10U1LgVExrky43s3/XGP1Q2470gUr88p2XV0FktjL2wFtblxZRHYdfNs3qz5Hmj8MVEdFiyKmxW4jgWBY/vGDYhZVfr/j+ESX/g77Ch1aqz2HWhVhIFBbJM2PH2n4+uoioELuzS99TJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749856062; c=relaxed/simple;
	bh=ECoZ5+TP9aQskq5NYHIIj6ItZgwamalNqUH6JikShnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzIct//shas8qGzU3Sg6CNtJm574ejP99q50NCXiehoqJaYntUc4HgIf8fXRX5wu1MXfNMzn5EdHKui0aJ6faj6TFWKuIO287fKQb2jX8HrqilWFxyrfzMRHPse74mhj+cV3vSQaAVOay3KvWLI7XZ1OmEibwuA5ttf7Avrbf6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=HBh3tjv/; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=yXxGDOj4zoKlS3Ljt5GLp0sLLRwyFJizlLysOBFNGd8=; b=HBh3tjv/aw40mvzC
	gE5dV06eLTHjjfWCaov5D1ZeFi08W+vMH4xNa3WSJ6frppYS5AWO6S4ajwgAtB9hqFq8OY8+OSjQ9
	8b/0epiPxv3ZMhvTtAJMaEQNzWYYdLuWtRcfz6wCDqKKQSjhe1RLlGn3+cX/Y4ymBxDvcWK3oAxHi
	QV+N8fgSDtT08IVhebVmetpXXTSOAMpHnk+OGpicYZ9aBqM2rILh9RWhK38YwgcjHGuSofy1qEnfX
	4QvJonQETaNgIgzFZ7PcYFsRcMI2Bs3VmqL0DLnwQJ1qdgGdHrKgrx38yJ6NXCpv8pMmrCDsNkZe9
	jx450mnrZYZt1bdcFw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uQDUi-009ZoB-1P;
	Fri, 13 Jun 2025 23:07:32 +0000
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
Subject: [PATCH 1/2] vhost: vringh: Remove unused iotlb functions
Date: Sat, 14 Jun 2025 00:07:30 +0100
Message-ID: <20250613230731.573512-2-linux@treblig.org>
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
  vringh_abandon_iotlb()
  vringh_notify_disable_iotlb() and
  vringh_notify_enable_iotlb()

were added in 2020 by
commit 9ad9c49cfe97 ("vringh: IOTLB support")
but have remained unused.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/vhost/vringh.c | 43 ------------------------------------------
 include/linux/vringh.h |  5 -----
 2 files changed, 48 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index bbce65452701..67a028d6fb5f 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1534,23 +1534,6 @@ ssize_t vringh_iov_push_iotlb(struct vringh *vrh,
 }
 EXPORT_SYMBOL(vringh_iov_push_iotlb);
 
-/**
- * vringh_abandon_iotlb - we've decided not to handle the descriptor(s).
- * @vrh: the vring.
- * @num: the number of descriptors to put back (ie. num
- *	 vringh_get_iotlb() to undo).
- *
- * The next vringh_get_iotlb() will return the old descriptor(s) again.
- */
-void vringh_abandon_iotlb(struct vringh *vrh, unsigned int num)
-{
-	/* We only update vring_avail_event(vr) when we want to be notified,
-	 * so we haven't changed that yet.
-	 */
-	vrh->last_avail_idx -= num;
-}
-EXPORT_SYMBOL(vringh_abandon_iotlb);
-
 /**
  * vringh_complete_iotlb - we've finished with descriptor, publish it.
  * @vrh: the vring.
@@ -1571,32 +1554,6 @@ int vringh_complete_iotlb(struct vringh *vrh, u16 head, u32 len)
 }
 EXPORT_SYMBOL(vringh_complete_iotlb);
 
-/**
- * vringh_notify_enable_iotlb - we want to know if something changes.
- * @vrh: the vring.
- *
- * This always enables notifications, but returns false if there are
- * now more buffers available in the vring.
- */
-bool vringh_notify_enable_iotlb(struct vringh *vrh)
-{
-	return __vringh_notify_enable(vrh, getu16_iotlb, putu16_iotlb);
-}
-EXPORT_SYMBOL(vringh_notify_enable_iotlb);
-
-/**
- * vringh_notify_disable_iotlb - don't tell us if something changes.
- * @vrh: the vring.
- *
- * This is our normal running state: we disable and then only enable when
- * we're going to sleep.
- */
-void vringh_notify_disable_iotlb(struct vringh *vrh)
-{
-	__vringh_notify_disable(vrh, putu16_iotlb);
-}
-EXPORT_SYMBOL(vringh_notify_disable_iotlb);
-
 /**
  * vringh_need_notify_iotlb - must we tell the other side about used buffers?
  * @vrh: the vring we've called vringh_complete_iotlb() on.
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index c3a8117dabe8..af8bd2695a7b 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -319,13 +319,8 @@ ssize_t vringh_iov_push_iotlb(struct vringh *vrh,
 			      struct vringh_kiov *wiov,
 			      const void *src, size_t len);
 
-void vringh_abandon_iotlb(struct vringh *vrh, unsigned int num);
-
 int vringh_complete_iotlb(struct vringh *vrh, u16 head, u32 len);
 
-bool vringh_notify_enable_iotlb(struct vringh *vrh);
-void vringh_notify_disable_iotlb(struct vringh *vrh);
-
 int vringh_need_notify_iotlb(struct vringh *vrh);
 
 #endif /* CONFIG_VHOST_IOTLB */
-- 
2.49.0


