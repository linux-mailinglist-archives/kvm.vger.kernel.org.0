Return-Path: <kvm+bounces-49645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A056FADBE06
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 02:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 422503B7487
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5769B1AC88B;
	Tue, 17 Jun 2025 00:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="WlwaeUTp"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1101547C0;
	Tue, 17 Jun 2025 00:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750119544; cv=none; b=VHM1cYgsU5c4wjGP1zSsXX3hyNa6c8IP0PDNZ8SxEgqaLSJu6a3N5GrE4VDJ2Vtv+F/8fQJkorouDpy38prIjTFvHh/OH5aCzbIDRKsXKppHWOxuk1eexyxpErlEhUanyc8o+Xt5XCOyOi91dNNhBTEjUH/4H+S5/neDkptN/4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750119544; c=relaxed/simple;
	bh=LOoJjdxUB4Ub7LbtajDLb1UlDqZtd2NrF0DqNmtC0PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uubxagjvEIqaw3zENQ3HJN/1+DxBKiiQ5xdwUihIqKrN1WRH59NQpjbeJA1etH5kidoMpfHR0i+Pgt3nk+84ZXj3agImR2u28V+byZMBZL1erej84k+u04WvOzyMTiSLBbKPGUJ1X3aRtXPFcak4EJjFYkiejcyDeEdlYd/G3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=WlwaeUTp; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=nTlx+GYsiiaRpQjioGAK5Ofohl0JMzdQaTv4jSqczjA=; b=WlwaeUTpAoX3HvWa
	rIcboywP00Cdu/Nqmu8C3qOiOxAmMYlmmE/fCnh3cUztHEoPdNR/f92ZnKHACZxgs2kKIteTrbm7m
	Cnrue6rXcvkgQ3YSlFRXxSsDyKM7v9Bx7hu5ETv8HVyEelE3As7EmQbZuhHJC59RhdF+WjllB8ua2
	hQiLcQ8j46b2EMYFLcRmuy4zUdB9BmNi7qr8n4imh0J6f6dPTaZIRo1Wfp8L0fZnkB+NwGZdyRAg2
	5Qd762bsXVNKC1KHaIy+7HTz3CbYVdLFitefWhOW3dNOa1BtEzwHBYHhGPNmvkVzARlBg/s8DN8sB
	MrZVo6LRLGsEiJC4/Q==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uRK2L-009znJ-2E;
	Tue, 17 Jun 2025 00:18:49 +0000
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
Subject: [PATCH v2 1/2] vhost: vringh: Remove unused iotlb functions
Date: Tue, 17 Jun 2025 01:18:36 +0100
Message-ID: <20250617001838.114457-2-linux@treblig.org>
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
  vringh_abandon_iotlb()
  vringh_notify_disable_iotlb() and
  vringh_notify_enable_iotlb()

were added in 2020 by
commit 9ad9c49cfe97 ("vringh: IOTLB support")
but have remained unused.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: Simon Horman <horms@kernel.org>
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


