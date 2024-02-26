Return-Path: <kvm+bounces-9838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D37A78672AB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DD3028360A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0541D52B;
	Mon, 26 Feb 2024 11:09:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [195.130.137.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBC21CF8B
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 11:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708945781; cv=none; b=sDk7rUoagSbHXIoF7zhqkoXQdpph2ySHUzcyQFrST7xxeUCjmVaa/670YAEjFclP9+hlVEZKVsJgDHo9oxlnQceVkGwzwoihLQKPRKXu8wv7dNyDFJl8U6hnliqG5JUodGj0Kwnp0DKw08HyaFb5F0fjK8NLD4VcoHI+hdinRH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708945781; c=relaxed/simple;
	bh=QfAbmpSdPxk3PLAQItfucxGrrmocc9C9SjRrIqs0/z8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uweMvfuIGe5Dvr1HX1CMbB7QRC/pDHxOc4Whlezhjf5nK8qIlOcQog2nuXkEsHWfpVJRi0wm9z79opdxXckZ0QeE5+CosGvKsqirGanaUTtivlp6abBulNcR7+BwZDvW9ZS9BXkZw73UVvgxeXCbAPKo384xyAY6nIk2mK4fmqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:7662:e968:947d:f3d0])
	by laurent.telenet-ops.be with bizsmtp
	id rn9X2B00L5Kh3Z501n9XlV; Mon, 26 Feb 2024 12:09:31 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1reYrK-001lYB-29;
	Mon, 26 Feb 2024 12:09:31 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1reYrT-004NKE-Ii;
	Mon, 26 Feb 2024 12:09:31 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Antonios Motakis <a.motakis@virtualopensystems.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] vfio: amba: Rename pl330_ids[] to vfio_amba_ids[]
Date: Mon, 26 Feb 2024 12:09:26 +0100
Message-Id: <1d1b873b59b208547439225aee1f24d6f2512a1f.1708945194.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Obviously drivers/vfio/platform/vfio_amba.c started its life as a
simplified copy of drivers/dma/pl330.c, but not all variable names were
updated.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/vfio/platform/vfio_amba.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index 6464b3939ebcfb53..485c6f9161a91be0 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -122,16 +122,16 @@ static const struct vfio_device_ops vfio_amba_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 };
 
-static const struct amba_id pl330_ids[] = {
+static const struct amba_id vfio_amba_ids[] = {
 	{ 0, 0 },
 };
 
-MODULE_DEVICE_TABLE(amba, pl330_ids);
+MODULE_DEVICE_TABLE(amba, vfio_amba_ids);
 
 static struct amba_driver vfio_amba_driver = {
 	.probe = vfio_amba_probe,
 	.remove = vfio_amba_remove,
-	.id_table = pl330_ids,
+	.id_table = vfio_amba_ids,
 	.drv = {
 		.name = "vfio-amba",
 		.owner = THIS_MODULE,
-- 
2.34.1


