Return-Path: <kvm+bounces-12819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5FD88E1EC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0D1C1C2A3E1
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 13:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5077415F3F4;
	Wed, 27 Mar 2024 12:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHavZUA2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738F915F3E0;
	Wed, 27 Mar 2024 12:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711541963; cv=none; b=cDpCL/zCbavUThvToLx05MXUCBOP4IBlcgl+BlLPav6a7pTmjMojTdK0QmulEP7GF4QrJgldHjViuQzin+ZizHxE9sua9tRB7zd3AYXoz3WvIjTlySUJne08+3rDh/PYTrrMaH6nYTshZNBEO/KqIUojnN4bKZST2/hoCoGBsr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711541963; c=relaxed/simple;
	bh=6y8QCnpHEVSwUIL96dKvPc4U0vMl4U0y6S/JyANItlM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dr7c5K2lDf1YzEARBrfMRS62DoTV1PcsrQ7qErjFKnXbOiWirDKQK1LAKM3ehk4zl1yJ+g/RuMWk4M+N7I3U5uxOxeegA8KR9yMT7eDyk0/tOTD5IMV6R7QIpOmsEgpsouyND91B4g2OGn6cMg0UnbyFqMpRDAwbv1z0D9UMmL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHavZUA2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8567FC433F1;
	Wed, 27 Mar 2024 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711541963;
	bh=6y8QCnpHEVSwUIL96dKvPc4U0vMl4U0y6S/JyANItlM=;
	h=From:To:Cc:Subject:Date:From;
	b=CHavZUA2Xsw6bEF8H9bJ8AH8f/0kasaxE1+eSlPk3SnSEwxyk2CZrH3BEpaRvpen9
	 p4jPjRX7sMPHEKNOHt8Lh7ScF7su1GOiOnX5blIA8eEtMlww7x4ISa7VlRGdtwl6Gf
	 zpWdS1ZUYJqxdmlgq75aIcAx3Afkx8Qjgmt41W7aA73wxxUHoO/G198lb7MU6lFNbm
	 Xvf+ey+ftuBvH4DPBm1deBRY+HMqOpXxkKOikP21n3/zRvk3QHjD22l/3Ef0vAkvz2
	 vK6d5nzdWp3Sf+m5UVAv8weCQMWDI5EYgpuUageaT0ncvd52wmMDI5WrbupSNsnlUC
	 4qypbbHdzsEDw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	alex.williamson@redhat.com
Cc: Diana Craciun <diana.craciun@oss.nxp.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "vfio/fsl-mc: Block calling interrupt handler without trigger" failed to apply to 5.10-stable tree
Date: Wed, 27 Mar 2024 08:19:21 -0400
Message-ID: <20240327121921.2835117-1-sashal@kernel.org>
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

The patch below does not apply to the 5.10-stable tree.
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





