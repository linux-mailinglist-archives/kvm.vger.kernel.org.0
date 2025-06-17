Return-Path: <kvm+bounces-49644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4711ADBE02
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 02:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED9771744FC
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F99E16DEB3;
	Tue, 17 Jun 2025 00:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="J1vuX/AG"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938D21C683;
	Tue, 17 Jun 2025 00:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750119542; cv=none; b=klFqAX0kp/grkrX9JUe4kHNhAh90ZLs5bGRXjmnQFZtmS8sq1H9h2jG9cTJ2DaUjUMxKX4YGFHuDBUAOFV+DjpaT65WhJhxe8S68xG+5aPEWNyu0YDJLn7u/It0O1hl2npnwtuE9THW6P7SJJn8GBgLV4zvD1BPNktgz1+YWyds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750119542; c=relaxed/simple;
	bh=y3q/CK06lk9lk76b5nH9YzG1AhihlSPk87sJ8wCMgV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPHGFj0/5eLliqmIZBUG6eQvQHrDkg+cgub6qQC1JY8PyRN/AyBefg6tGkpkOfMM9/SWXY4h2Hxih6nm+StIY6ZYX9Mm9Ryjge157/2xDPzMXkP/YIfqKwawrnteWdddaBD8PKPZKTFazZpCglEJ6nT/U/VQC5VpfEssbDZ8PtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=J1vuX/AG; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=l+NrzISvaKK3MwfDhAbTRjiy+gg6Cgp/SV3R9ADgnOE=; b=J1vuX/AGQ5rhOACo
	REraBkeNzm/4qYaEuWKpfcr4GCD7ubsMBWowg8taeNv0h8GzHrzJ1JAqgwEzIX+UQxH8P+DShHEHb
	eC9lHAVfpODTcWV2pZThLfcCKzJK6mguv52Hl7u/3CVoha1ml2/ushJ5C8NUR7GTbIqszgYdr6ueq
	Z8y+NYNEGjG6E175jp/5FGRBQ7SHRBJ8Xe4USGseo7w2ycLiT8P8zoZtmUovuZkSqT9AvirDMlpI1
	/bE9uXdE0SWbiBjOCFIDM6Ao3uFIZoDtR4dgFvTvhNdc6q/B7OGBS/97ct99A4kBHQ5+pgFoVGB9D
	CM5aOPnmFP6a3Zweog==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uRK2M-009znJ-1O;
	Tue, 17 Jun 2025 00:18:50 +0000
From: linux@treblig.org
To: mst@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH v2 2/2] vhost: vringh: Remove unused functions
Date: Tue, 17 Jun 2025 01:18:37 +0100
Message-ID: <20250617001838.114457-3-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617001838.114457-1-linux@treblig.org>
References: <20250617001838.114457-1-linux@treblig.org>
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

Remove them and the two helper functions they used.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/vhost/vringh.c | 75 ------------------------------------------
 include/linux/vringh.h |  7 ----
 2 files changed, 82 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 67a028d6fb5f..9f27c3f6091b 100644
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
@@ -900,20 +884,6 @@ static inline int putused_kern(const struct vringh *vrh,
 	return 0;
 }
 
-static inline int xfer_kern(const struct vringh *vrh, void *src,
-			    void *dst, size_t len)
-{
-	memcpy(dst, src, len);
-	return 0;
-}
-
-static inline int kern_xfer(const struct vringh *vrh, void *dst,
-			    void *src, size_t len)
-{
-	memcpy(dst, src, len);
-	return 0;
-}
-
 /**
  * vringh_init_kern - initialize a vringh for a kernelspace vring.
  * @vrh: the vringh to initialize.
@@ -998,51 +968,6 @@ int vringh_getdesc_kern(struct vringh *vrh,
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


