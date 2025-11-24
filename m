Return-Path: <kvm+bounces-64438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 069ECC82ABD
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 23:36:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D7AF3ACD9B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 22:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFE4345724;
	Mon, 24 Nov 2025 22:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="cRkHV11r";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L9BFqcxl"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6739C3446A9;
	Mon, 24 Nov 2025 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023791; cv=none; b=iv/vBHsyHl8gv7hHJlgkqWFAAw+3GQJWb2DdrFvY4xgYu/jE4JqNhNOH/fC+nvoKNj8B3Tq3gU95WDCWB/tueijKAnQFpgchSwI/wU7e7sYlVELtu/VmcyNcp2jHMckwFD+3DFLXZ75UXQHoUHV/Z5vXhZFV4X9LSAHcKioYDjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023791; c=relaxed/simple;
	bh=D3Kkz6qAsaR+1Ht1I6C4ZlQQCK18GoBmG4AUikwlvSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ri3620N0v7mIs3sw6heC1rZG3yqSoLJUnpFS3pJ7k0VBm3BPrII+owvh5caTtOuZ/c2zZLPF5cu8R2QKbP79ERyVnKKPJaGGBuP/OkyTX04dusSP/ZxmAcWpCb3OlnqVGK+GxNC36KKV0vVBJEXDKU/CyqkoEpqJDAYCgBVq2l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=cRkHV11r; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L9BFqcxl; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 78FBEEC01E5;
	Mon, 24 Nov 2025 17:36:26 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 24 Nov 2025 17:36:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1764023786; x=1764110186; bh=orlcnj/0SXV+jVYmUXNUa
	W7k0W1bCXC+Z7sv4OIBdt0=; b=cRkHV11rXqqkRbokZk+i29na6tAV8fNVHCcFb
	DKAur3zdczCoo0Rupl6VHzbmWJgCSIkQgwwcHpU9G3AzNCr/nGCMKbvw5fpIWu86
	lrqWQKQz69M8zkVMkjAmpRn5w8bRWmz9xucGE0ZuOlLr/PBefHgq+ZlRbMC5sqKQ
	OrkTTT5GaQHyMgqQNB/5WZqBxeXpIchfByyfZxiR+IeyYiAavmKMGiHae7TxeQCh
	q+mnEYjMT3xESiDWWa+Mv73BIInYLE/Ni3/TnpvpSqdC1gKRPUQIUPtybZGYCAgZ
	/0rbco6MMpEdwhcgc1kyu05QhKNhmWq6DxMgVSWmZu39tt+XQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1764023786; x=1764110186; bh=orlcnj/0SXV+jVYmUXNUaW7k0W1bCXC+Z7s
	v4OIBdt0=; b=L9BFqcxlnDKargnhdHRutpxhOj6H3FEEw5njJ3z1dZuOvz6kC7M
	DPq81H7+BbZsHYnhxLplxDrCnU2IQfKRKt5XhmNxo6Fjwlbu90GwYKicCMa9N1uE
	apULOjm7b3w6offIeGaIfLBdOqIfirc7mJbIs8+WdXvMLTyUVW9uapvKnrGFjrzZ
	ySAuNSaKEJ7Rv+01E8CVXVpNnShsfjj/72yGFU6Noh1peKbPAaLKZlQx+JA9n6YS
	xl/bI8QFWZh7pUEIPdMU+rzNuydYuurc2VGPl1nuFvQgPP/mCIfynxSrOL6fD8h9
	96ROE9oP4H+qIDDcr1CsybqH0x0jFW4vTPQ==
X-ME-Sender: <xms:6d0kacjCG8eperMc63SiNHNLuhm3VkliUYX9B4TBEGk5l7oXPUBy2g>
    <xme:6d0kaWjJ0j3vRqoDll912xOcuXxVKXKIRv5muNlpdwApiE-XNTPWP-5Q0aH5Rn7hh
    O19assU2MSPlf0olmcAYGoiTwD2J9kUD1TA4CwdkTUy4oCtgE4uPQ>
X-ME-Received: <xmr:6d0kaULuqMTT3wzwdBId4myWhsQZfENZxkiDjq7MXreEJSm7Xxgy2kNlX7tz8cvnTJxZ07MN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeelkedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoteeftdduqddtudculdduhedmnecujfgurhephffvve
    fufffkofgggfestdekredtredttdenucfhrhhomheptehlvgigucghihhllhhirghmshho
    nhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvddvff
    euvedtgfekvdfhffefgeetleegfeeiheetgeeuieffhffhhfetffeltedvnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgrii
    gsohhtrdhorhhgpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopegrlhgvgiesshhhrgiisghothdrohhrghdprhgtphhtthhopehkvhhmsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhr
    tghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheplh
    hinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:6d0kadEX0Wb2c9rOq9TTz69SO0dEIRsiCpvwe1YiXcc9dFz5Vv9Hpg>
    <xmx:6d0kaQQyUisULhohZO5HjQVnkS1Xf3yyOCP-A7I0BQudAfgc-nXoDQ>
    <xmx:6d0kaRclENZ8eD7-2pJbDZ_rvCIa-_znE1FlCQdN0C-n2SHAedb8Fg>
    <xmx:6d0kaXrPKRJj15FZ28X9QTDXhzOWSvGTrYTD72Rj5UveVqQ8xrL9Aw>
    <xmx:6t0kad_OrBjL3oGyr1lHwvPFvPOVXN9ShbAgEUE-nUs9YM2DVzwRa2Jo>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Nov 2025 17:36:25 -0500 (EST)
From: Alex Williamson <alex@shazbot.org>
To: alex@shazbot.org
Cc: kvm@vger.kernel.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/pci: Use RCU for error/request triggers to avoid circular locking
Date: Mon, 24 Nov 2025 15:36:22 -0700
Message-ID: <20251124223623.2770706-1-alex@shazbot.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alex Williamson <alex.williamson@nvidia.com>

Thanks to a device generating an ACS violation during bus reset,
lockdep reported the following circular locking issue:

CPU0: SET_IRQS (MSI/X): holds igate, acquires memory_lock
CPU1: HOT_RESET: holds memory_lock, acquires pci_bus_sem
CPU2: AER: holds pci_bus_sem, acquires igate

This results in a potential 3-way deadlock.

Remove the pci_bus_sem->igate leg of the triangle by using RCU
to peek at the eventfd rather than locking it with igate.

Fixes: 3be3a074cf5b ("vfio-pci: Don't use device_lock around AER interrupt setup")
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 68 ++++++++++++++++++++++---------
 drivers/vfio/pci/vfio_pci_intrs.c | 52 ++++++++++++++---------
 drivers/vfio/pci/vfio_pci_priv.h  |  4 ++
 include/linux/vfio_pci_core.h     | 10 ++++-
 4 files changed, 93 insertions(+), 41 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 79a1a50a4ef7..2b01bfbce3ea 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -42,6 +42,40 @@ static bool nointxmask;
 static bool disable_vga;
 static bool disable_idle_d3;
 
+static void vfio_pci_eventfd_rcu_free(struct rcu_head *rcu)
+{
+	struct vfio_pci_eventfd *eventfd =
+		container_of(rcu, struct vfio_pci_eventfd, rcu);
+
+	eventfd_ctx_put(eventfd->ctx);
+	kfree(eventfd);
+}
+
+int vfio_pci_eventfd_replace_locked(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_eventfd __rcu **peventfd,
+				    struct eventfd_ctx *ctx)
+{
+	struct vfio_pci_eventfd *new = NULL;
+	struct vfio_pci_eventfd *old;
+
+	lockdep_assert_held(&vdev->igate);
+
+	if (ctx) {
+		new = kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
+		if (!new)
+			return -ENOMEM;
+
+		new->ctx = ctx;
+	}
+
+	old = rcu_replace_pointer(*peventfd, new,
+				  lockdep_is_held(&vdev->igate));
+	if (old)
+		call_rcu(&old->rcu, vfio_pci_eventfd_rcu_free);
+
+	return 0;
+}
+
 /* List of PF's that vfio_pci_core_sriov_configure() has been called on */
 static DEFINE_MUTEX(vfio_pci_sriov_pfs_mutex);
 static LIST_HEAD(vfio_pci_sriov_pfs);
@@ -697,14 +731,8 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 	vfio_pci_dma_buf_cleanup(vdev);
 
 	mutex_lock(&vdev->igate);
-	if (vdev->err_trigger) {
-		eventfd_ctx_put(vdev->err_trigger);
-		vdev->err_trigger = NULL;
-	}
-	if (vdev->req_trigger) {
-		eventfd_ctx_put(vdev->req_trigger);
-		vdev->req_trigger = NULL;
-	}
+	vfio_pci_eventfd_replace_locked(vdev, &vdev->err_trigger, NULL);
+	vfio_pci_eventfd_replace_locked(vdev, &vdev->req_trigger, NULL);
 	mutex_unlock(&vdev->igate);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
@@ -1784,21 +1812,21 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_eventfd *eventfd;
 
-	mutex_lock(&vdev->igate);
-
-	if (vdev->req_trigger) {
+	rcu_read_lock();
+	eventfd = rcu_dereference(vdev->req_trigger);
+	if (eventfd) {
 		if (!(count % 10))
 			pci_notice_ratelimited(pdev,
 				"Relaying device request to user (#%u)\n",
 				count);
-		eventfd_signal(vdev->req_trigger);
+		eventfd_signal(eventfd->ctx);
 	} else if (count == 0) {
 		pci_warn(pdev,
 			"No device request channel registered, blocked until released by user\n");
 	}
-
-	mutex_unlock(&vdev->igate);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
@@ -2216,13 +2244,13 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state)
 {
 	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct vfio_pci_eventfd *eventfd;
 
-	mutex_lock(&vdev->igate);
-
-	if (vdev->err_trigger)
-		eventfd_signal(vdev->err_trigger);
-
-	mutex_unlock(&vdev->igate);
+	rcu_read_lock();
+	eventfd = rcu_dereference(vdev->err_trigger);
+	if (eventfd)
+		eventfd_signal(eventfd->ctx);
+	rcu_read_unlock();
 
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 30d3e921cb0d..c76e753b3cec 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -731,21 +731,27 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
+static int vfio_pci_set_ctx_trigger_single(struct vfio_pci_core_device *vdev,
+					   struct vfio_pci_eventfd __rcu **peventfd,
 					   unsigned int count, uint32_t flags,
 					   void *data)
 {
 	/* DATA_NONE/DATA_BOOL enables loopback testing */
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		if (*ctx) {
-			if (count) {
-				eventfd_signal(*ctx);
-			} else {
-				eventfd_ctx_put(*ctx);
-				*ctx = NULL;
-			}
+		struct vfio_pci_eventfd *eventfd;
+
+		eventfd = rcu_dereference_protected(*peventfd,
+						lockdep_is_held(&vdev->igate));
+
+		if (!eventfd)
+			return -EINVAL;
+
+		if (count) {
+			eventfd_signal(eventfd->ctx);
 			return 0;
 		}
+
+		return vfio_pci_eventfd_replace_locked(vdev, peventfd, NULL);
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t trigger;
 
@@ -753,8 +759,15 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 			return -EINVAL;
 
 		trigger = *(uint8_t *)data;
-		if (trigger && *ctx)
-			eventfd_signal(*ctx);
+
+		if (trigger) {
+			struct vfio_pci_eventfd *eventfd =
+					rcu_dereference_protected(*peventfd,
+					lockdep_is_held(&vdev->igate));
+
+			if (eventfd)
+				eventfd_signal(eventfd->ctx);
+		}
 
 		return 0;
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
@@ -765,22 +778,23 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 
 		fd = *(int32_t *)data;
 		if (fd == -1) {
-			if (*ctx)
-				eventfd_ctx_put(*ctx);
-			*ctx = NULL;
+			return vfio_pci_eventfd_replace_locked(vdev,
+							       peventfd, NULL);
 		} else if (fd >= 0) {
 			struct eventfd_ctx *efdctx;
+			int ret;
 
 			efdctx = eventfd_ctx_fdget(fd);
 			if (IS_ERR(efdctx))
 				return PTR_ERR(efdctx);
 
-			if (*ctx)
-				eventfd_ctx_put(*ctx);
+			ret = vfio_pci_eventfd_replace_locked(vdev,
+							      peventfd, efdctx);
+			if (ret)
+				eventfd_ctx_put(efdctx);
 
-			*ctx = efdctx;
+			return ret;
 		}
-		return 0;
 	}
 
 	return -EINVAL;
@@ -793,7 +807,7 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->err_trigger,
+	return vfio_pci_set_ctx_trigger_single(vdev, &vdev->err_trigger,
 					       count, flags, data);
 }
 
@@ -804,7 +818,7 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->req_trigger,
+	return vfio_pci_set_ctx_trigger_single(vdev, &vdev->req_trigger,
 					       count, flags, data);
 }
 
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 28a405f8b97c..6681389518a7 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -26,6 +26,10 @@ struct vfio_pci_ioeventfd {
 bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
+int vfio_pci_eventfd_replace_locked(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_eventfd __rcu **peventfd,
+				    struct eventfd_ctx *ctx);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 88fd2fd895d0..a1eddd55dab8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/vfio.h>
 #include <linux/irqbypass.h>
+#include <linux/rcupdate.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
 #include <linux/notifier.h>
@@ -29,6 +30,11 @@ struct vfio_pci_region;
 struct p2pdma_provider;
 struct dma_buf_phys_vec;
 
+struct vfio_pci_eventfd {
+	struct eventfd_ctx	*ctx;
+	struct rcu_head		rcu;
+};
+
 struct vfio_pci_regops {
 	ssize_t (*rw)(struct vfio_pci_core_device *vdev, char __user *buf,
 		      size_t count, loff_t *ppos, bool iswrite);
@@ -124,8 +130,8 @@ struct vfio_pci_core_device {
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-	struct eventfd_ctx	*err_trigger;
-	struct eventfd_ctx	*req_trigger;
+	struct vfio_pci_eventfd __rcu *err_trigger;
+	struct vfio_pci_eventfd __rcu *req_trigger;
 	struct eventfd_ctx	*pm_wake_eventfd_ctx;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
-- 
2.51.1


