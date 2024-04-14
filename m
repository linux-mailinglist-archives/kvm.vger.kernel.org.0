Return-Path: <kvm+bounces-14605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5618A41C5
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 12:14:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B99A61C20E62
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 10:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482D62D61B;
	Sun, 14 Apr 2024 10:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="oibIlkcH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCF22374C;
	Sun, 14 Apr 2024 10:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713089641; cv=none; b=PVnCQo6kbzvN5bbFhTc7eK3hRHHvMj4ObOMOSUwQSHJn0YKJhv625deOrlPzAKe0lF4EDLb7uUKYxoVtF8LS31b5fpz3FdeMi8hXAEPxjACrScFMROpH2a+BG/riHYoZ6fGosCUsAjy040xgh6XhbCwww1+zXhqp/12DcSs8Oto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713089641; c=relaxed/simple;
	bh=wTUGgeFPL6oQbMhkQ07Xn7K8s7vcqSJwRTRQoc9gkOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TJYFPkhVCnRU5KBjZC5EmQLiEEnnYIyVdOTEaZZpXM9Mg98foIa+NerzOl5wSliT8zid5c2JUrerx9NBDe/6L8mU6wLfGBacNBJ2gLvMQOgKSoWYhpiPamWuYw8RkmmoYEuJ/86glPyI/ijzJpoy0ZVeyJYq98P8kM+jbAJnvpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=oibIlkcH; arc=none smtp.client-ip=80.12.242.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from fedora.home ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id vwiyrPARNVYR4vwiyrSi3R; Sun, 14 Apr 2024 12:04:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1713089078;
	bh=Wu3eqlNZ33DIowcdMPCmbQIFZiK8nMriLzGayBQf0uE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=oibIlkcH8xzA74tG14bNIc95dw9UMTiPq2/ZH1PEN04vNkXvakJMWi8NEYvyr8qMJ
	 2sAG+CYsU3K8c5IDPPYvYUt2i1Sj1DFPLWueSs/HtN0ajbWqVCXQehJX3XheMAxS0y
	 7D3HJ1rczDBOK4m8TBWsU/9CtIkehZJlaGCqgE6y+5hSGCiq35aDNXdfKiq+686Tj9
	 b94OJw9qrzDAyNoHyy0tvWP+CwNpmEzyVp97ahEN5p5GT657VtTlSzIOfzbf6sTlHW
	 M4O5dd0p4DHttexu8yM5AVwFdshbugyuzlJq6zzc8cUwg7pzFr6nhuhWIvGV4Ij1CF
	 CWgLb9T6EHI1A==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 14 Apr 2024 12:04:38 +0200
X-ME-IP: 86.243.17.157
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <horms@kernel.org>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH v2] vhost-vdpa: Remove usage of the deprecated ida_simple_xx() API
Date: Sun, 14 Apr 2024 12:04:26 +0200
Message-ID: <67c2edf49788c27d5f7a49fc701520b9fcf739b5.1713088999.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_max() is inclusive. So a -1 has been added when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
---
Changes in V2:
   - fix a typo in the commit message
   - Add a R-b tag

V1: https://lore.kernel.org/all/bd27d4066f7749997a75cf4111fbf51e11d5898d.1705350942.git.christophe.jaillet@wanadoo.fr/
---
 drivers/vhost/vdpa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ba52d128aeb7..63a53680a85c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1548,7 +1548,7 @@ static void vhost_vdpa_release_dev(struct device *device)
 	struct vhost_vdpa *v =
 	       container_of(device, struct vhost_vdpa, dev);
 
-	ida_simple_remove(&vhost_vdpa_ida, v->minor);
+	ida_free(&vhost_vdpa_ida, v->minor);
 	kfree(v->vqs);
 	kfree(v);
 }
@@ -1571,8 +1571,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	if (!v)
 		return -ENOMEM;
 
-	minor = ida_simple_get(&vhost_vdpa_ida, 0,
-			       VHOST_VDPA_DEV_MAX, GFP_KERNEL);
+	minor = ida_alloc_max(&vhost_vdpa_ida, VHOST_VDPA_DEV_MAX - 1,
+			      GFP_KERNEL);
 	if (minor < 0) {
 		kfree(v);
 		return minor;
-- 
2.44.0


