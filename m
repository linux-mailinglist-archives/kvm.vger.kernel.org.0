Return-Path: <kvm+bounces-12809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A78CB88E076
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 13:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D90661C28940
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A6F149C4D;
	Wed, 27 Mar 2024 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAczGo8f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9E11494D3;
	Wed, 27 Mar 2024 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711541574; cv=none; b=OxKbLyboXhnlklakYHgvDgXrdMBbaJPWes5Yoo+tfaRjLIBx7JgaWyuxXe4MoHju8dIBKggJ3L4j7OuKWeRRJySd7ua4y8OPw2xV7s453n15WUwHLPO+iIRtBdeZHz6+uu5MKcxYI87/vyRBIGqEZEvCSSYltMvRE/h5CVRGGLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711541574; c=relaxed/simple;
	bh=5RV/UDyTKc5U6zXvHzqIJGRIHgJyA4wBy0rSI8lYSvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oa/fUwAJ/XeYCrcBYlmOhUYUWMukmFIW7Gy6928m14XDoyCyWm2SzSzIkHm0AK7I4nXkdv5xYMc7w+zqIqffvUezvZIHAOnSydFwyjXp5pIh0hrl+npM/oomkJ7G+dG7Xnq1vZUKsNNPZ6nM2EKAdSo68XRsXifglO/iKuvt7qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAczGo8f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0237C433A6;
	Wed, 27 Mar 2024 12:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711541573;
	bh=5RV/UDyTKc5U6zXvHzqIJGRIHgJyA4wBy0rSI8lYSvM=;
	h=From:To:Cc:Subject:Date:From;
	b=eAczGo8fMecX2BOwouZmYnFfGYfzR7XOLAX/6nd47cL9GDz8+6Tqa6+MuZs9jvJ4i
	 J/SxSX9cp9+2WipfPyZGeQjiYEVGsCn0+A/FoziRqKbaLeOx96Tjk5/zFJV9WLYLuG
	 4KG/2Ro4TPTVBXIN6E3bh/bdPacusypq9uL0Cx63P3IuS2tLOUdTlj0/eCRQu9tbqn
	 fYH8pHjdk5W9k3doPMQCd6N1A9biwjZPu4PFSKUsCxMu0VkuMjsYE38R+KpSfj2Nat
	 s4dL9WMp/SNLxnj8kQ1sI94UF+a5sO3QEgq8YAKveFAN7Xpf7JGxIlPynLk9VK9yif
	 SXpTajehN8mzw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	alex.williamson@redhat.com
Cc: Diana Craciun <diana.craciun@oss.nxp.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "vfio/fsl-mc: Block calling interrupt handler without trigger" failed to apply to 6.1-stable tree
Date: Wed, 27 Mar 2024 08:12:51 -0400
Message-ID: <20240327121252.2829855-1-sashal@kernel.org>
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

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 7447d911af699a15f8d050dfcb7c680a86f87012 Mon Sep 17 00:00:00 2001
From: Alex Williamson <alex.williamson@redhat.com>
Date: Fri, 8 Mar 2024 16:05:28 -0700
Subject: [PATCH] vfio/fsl-mc: Block calling interrupt handler without trigger

The eventfd_ctx trigger pointer of the vfio_fsl_mc_irq object is
initially NULL and may become NULL if the user sets the trigger
eventfd to -1.  The interrupt handler itself is guaranteed that
trigger is always valid between request_irq() and free_irq(), but
the loopback testing mechanisms to invoke the handler function
need to test the trigger.  The triggering and setting ioctl paths
both make use of igate and are therefore mutually exclusive.

The vfio-fsl-mc driver does not make use of irqfds, nor does it
support any sort of masking operations, therefore unlike vfio-pci
and vfio-platform, the flow can remain essentially unchanged.

Cc: Diana Craciun <diana.craciun@oss.nxp.com>
Cc:  <stable@vger.kernel.org>
Fixes: cc0ee20bd969 ("vfio/fsl-mc: trigger an interrupt via eventfd")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-8-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index d62fbfff20b82..82b2afa9b7e31 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -141,13 +141,14 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
 	irq = &vdev->mc_irqs[index];
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_fsl_mc_irq_handler(hwirq, irq);
+		if (irq->trigger)
+			eventfd_signal(irq->trigger);
 
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		u8 trigger = *(u8 *)data;
 
-		if (trigger)
-			vfio_fsl_mc_irq_handler(hwirq, irq);
+		if (trigger && irq->trigger)
+			eventfd_signal(irq->trigger);
 	}
 
 	return 0;
-- 
2.43.0





