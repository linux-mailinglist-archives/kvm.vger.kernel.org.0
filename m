Return-Path: <kvm+bounces-12806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0FF88DF92
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 13:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 072D0B2212B
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5080513E8B3;
	Wed, 27 Mar 2024 12:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKFiDGH5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732D313E89A;
	Wed, 27 Mar 2024 12:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711541413; cv=none; b=ls02x0GsN0Q49PpHP22TItiFOh39z7jg0WAYHQW259c7mLOPZAJZnSH8WTDxkeRams0DADvWv1FnGBAXWsn+flFQ5Lb8HaeWZwkKUgRkyoCs11yR8ss3qRBrYN17PofGNEpMZo1h3qlVNeYA7CABqmRVRcXe3xJlZNMkGU6BNzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711541413; c=relaxed/simple;
	bh=9dIC455GMigwlHUSI1iYJ0UxBLF8LmZWAcBbGdbnmhE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jPFQfl4+tNrbgpYx8ouqjgJW2LNAWpi7Ak2BiEje5B8Q16y3jEA1wbw+V4SfvzCCeWYVnM2NIx9jl5K3CioQhApkBkwZEWPuAemVuJyAxIWRlRmNNCLKdL04D1j/vrHB42cnifuddpx+WK2widUavHtRIGOOrSorSGiID5KTcOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKFiDGH5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC21C433C7;
	Wed, 27 Mar 2024 12:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711541413;
	bh=9dIC455GMigwlHUSI1iYJ0UxBLF8LmZWAcBbGdbnmhE=;
	h=From:To:Cc:Subject:Date:From;
	b=tKFiDGH5Pjia/SN+gpr2WpHVFYM2canZPanyA6NX/3ycHyI6YXipVl2gBw8SXCAyC
	 GivTUMYk3i7IhvaIy9nkHLFcBL4yiSyhZXaog1IluKellFLZBASlKewnUYqC2bUhSk
	 VODsWMGW2hoTQN8DucgcOn2l/JngHBAPoSD5Rew9COHltv4UYxajVc4ea049M1mcMY
	 UeunDcryoJMXTy1Ky0slQj3UB/o2cQ/gGXtNqCr4PdOIOc5LZXJ9/sy/YZdggEOspI
	 lAINxKQZiYedS6xf5l7k5C4Syv/T72SRPEi3vvyIECxFoM5e7Oheu8Q5+k7Rk+guYR
	 fb24Z/hFDUs+w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	alex.williamson@redhat.com
Cc: Diana Craciun <diana.craciun@oss.nxp.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "vfio/fsl-mc: Block calling interrupt handler without trigger" failed to apply to 6.6-stable tree
Date: Wed, 27 Mar 2024 08:10:11 -0400
Message-ID: <20240327121011.2827657-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
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





