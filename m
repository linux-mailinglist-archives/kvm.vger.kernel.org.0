Return-Path: <kvm+bounces-12827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 036F288E34F
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEFC729CB53
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 13:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D83181483;
	Wed, 27 Mar 2024 12:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTpJCld9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB818146B;
	Wed, 27 Mar 2024 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711542312; cv=none; b=dgNclMaRZmNeH6DnF0GA0JHcOdHukUluICEWU4zahy/EsWkm+jrgVcB72y8M6Fmur77Zvfp3TbJJIyKkFJn87N4PL9baTqOLWUrjBpyId00P74YocTf7Oi0qDQvybYaDo7T8Ai7dmWqj+iQF1S0JjGMhQrd/u+dlJoq1Gy40bow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711542312; c=relaxed/simple;
	bh=lVwiLUFk1Ajwy3htFqot2nLyqDukULMSp8fVXddhUz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E5VHAp/oDTDrbQtwpjjjr8vjbi6RVRkx2vacxCqA70MyFatGq8pHLoRuKTniRQ0VckV162y9Ybg2DKRgSmUf/D948g+KecQReJ8Q5mveZ4vpMElPjqbTvFXNGfDgpvpMYLxpmVKz+fyUutWOBSvanJJGWXTX+hcJVxJoS2MdctU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTpJCld9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BE7C433F1;
	Wed, 27 Mar 2024 12:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711542312;
	bh=lVwiLUFk1Ajwy3htFqot2nLyqDukULMSp8fVXddhUz8=;
	h=From:To:Cc:Subject:Date:From;
	b=LTpJCld9u8OHjBWcNTC0P4+qlXQhQJOTc0G0iQnGumGDKRAKuNj6a/aqIcP6lBWRu
	 T1bikdCCcTLeyktq9iTV4K7OT3mWEIm8dhhbjGdcM2IgYo+TvJ1wAFZ0AHKD/9vpNH
	 Vqa60wPJB9HNal5XmZhrYuGRZnPmv8gjF5GgdGlVWGHDuIfy31IYVR02pv20TTBPpi
	 d2LSB+GWw5xPsiA5L7tGO5dUR02hBKf2Rp7hRxK1a5/FqfOpFvlIScA8YXn0XBoHyE
	 U3eFQlcFpriPy/m8oQ/0Q0G7+ImxUzs0hSseAJzlm47QveLvz/hykXh++J8r9RXtRj
	 qkCsbcrIdXNxg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	alex.williamson@redhat.com
Cc: Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "vfio/pci: Disable auto-enable of exclusive INTx IRQ" failed to apply to 4.19-stable tree
Date: Wed, 27 Mar 2024 08:25:10 -0400
Message-ID: <20240327122510.2840000-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From fe9a7082684eb059b925c535682e68c34d487d43 Mon Sep 17 00:00:00 2001
From: Alex Williamson <alex.williamson@redhat.com>
Date: Fri, 8 Mar 2024 16:05:22 -0700
Subject: [PATCH] vfio/pci: Disable auto-enable of exclusive INTx IRQ

Currently for devices requiring masking at the irqchip for INTx, ie.
devices without DisINTx support, the IRQ is enabled in request_irq()
and subsequently disabled as necessary to align with the masked status
flag.  This presents a window where the interrupt could fire between
these events, resulting in the IRQ incrementing the disable depth twice.
This would be unrecoverable for a user since the masked flag prevents
nested enables through vfio.

Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive INTx
is never auto-enabled, then unmask as required.

Cc:  <stable@vger.kernel.org>
Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-2-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 237beac838097..136101179fcbd 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -296,8 +296,15 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 
 	ctx->trigger = trigger;
 
+	/*
+	 * Devices without DisINTx support require an exclusive interrupt,
+	 * IRQ masking is performed at the IRQ chip.  The masked status is
+	 * protected by vdev->irqlock. Setup the IRQ without auto-enable and
+	 * unmask as necessary below under lock.  DisINTx is unmodified by
+	 * the IRQ configuration and may therefore use auto-enable.
+	 */
 	if (!vdev->pci_2_3)
-		irqflags = 0;
+		irqflags = IRQF_NO_AUTOEN;
 
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, ctx->name, vdev);
@@ -308,13 +315,9 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 		return ret;
 	}
 
-	/*
-	 * INTx disable will stick across the new irq setup,
-	 * disable_irq won't.
-	 */
 	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && ctx->masked)
-		disable_irq_nosync(pdev->irq);
+	if (!vdev->pci_2_3 && !ctx->masked)
+		enable_irq(pdev->irq);
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 
 	return 0;
-- 
2.43.0





