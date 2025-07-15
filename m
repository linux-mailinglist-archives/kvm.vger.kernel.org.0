Return-Path: <kvm+bounces-52432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E2EB0527A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:14:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08E727A5643
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A295826F445;
	Tue, 15 Jul 2025 07:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="fGVxSsnO"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684DC1C8FBA;
	Tue, 15 Jul 2025 07:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752563627; cv=none; b=gl+eXotel5ceMpmloUYRtMFRnmalfB3wTAYNE1AGMIFBZeJeLEBpXXJh2kRQs+9YX9uAL3Cp27mPmeSJmh/MNwzjAXsNJaPJiRgd+rg28zHg7tL1KbDrXXBg9mkwxk+UOu8mM/V5hCanLTP5CVnPlb9RS5Sa26hNDeJGqWDO0P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752563627; c=relaxed/simple;
	bh=3tRzF+eAG69iCFJsLHqK7qCIOSv/sCoudEUDZNrr2KA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DBH4P+mU3WzfTegDzwyMOqnX0o0cPvXuVe9NhgUa0kyt5chXjWcWMqkcIRc/azElhOYIrSl0G+Ec9FM93j1dJ4qPWXJv+hBqXJj/yEFazI5ill9B2NvJ3wpfdTIPD+MlxAKxTGOf3X3rjg/sg6YVCb3uSYSQwzABipxzsQd+9cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=fGVxSsnO; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752563604;
	bh=RFKqX/8jGLZ0gCM1lRc1v1zeuP3fiXSjkW615zWkF/8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=fGVxSsnOyLb+URLacjA1Sd3bbCsbyuEhRq1fqx/9kf9hxKAfgwJglUml0EAcf66lr
	 qP5bwH2xTPNO89oJgiIGSIe7rO7+BstjN+GEPqloQKhHWEeVxqnQCBXEKNUyVVL6S2
	 Zn3uC07ASOaEv2fW+Hoe7yFbmdxKoXTBgjiZK0Vc=
X-QQ-mid: zesmtpip3t1752563587t54e86ea1
X-QQ-Originating-IP: LAPbbLpI8/WwODO7cz/sB4Ix6FIzw86cgmvoh1lVP0U=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 15:13:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14369993403465055196
EX-QQ-RecipientCnt: 63
From: WangYuli <wangyuli@uniontech.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	marcin.s.wojtas@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	arend.vanspriel@broadcom.com,
	ilpo.jarvinen@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	jgross@suse.com,
	sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	akpm@linux-foundation.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangyuli@uniontech.com,
	ming.li@zohomail.com,
	linux-cxl@vger.kernel.org,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	kvalo@kernel.org,
	johannes.berg@intel.com,
	quic_ramess@quicinc.com,
	ragazenta@gmail.com,
	jeff.johnson@oss.qualcomm.com,
	mingo@kernel.org,
	j@jannau.net,
	linux@treblig.org,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-serial@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	shenlichuan@vivo.com,
	yujiaoliang@vivo.com,
	colin.i.king@gmail.com,
	cvam0000@gmail.com,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	guanwentao@uniontech.com
Subject: [PATCH] treewide: Fix typo "notifer"
Date: Tue, 15 Jul 2025 15:12:45 +0800
Message-ID: <B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NYOnBmlw6PSq7qfgCwz2XzMxcZWmpyFzt+hN2mg3FQguPczQComUKfYl
	M7q60PKhl/wMTk5Pm+ZTCDiwSKGwzwMxD/w72ijm5S+exZ3ncEpCpzp2Jf//EAQ/xmUvVoj
	VLbP0vvUBmRAGQbmOvmCDAeotInA+zVGcBsLXuPJVK7auy9s0tx9J9buR3544TvcV7/yS+N
	2G4KWGv/ipIcm3pj75vvZzf9tbcMXJ9xc/jG5P3WaLqO62zwWvBCnCSVsBbTXw+rRNAbOIV
	7O6yYK3hMj0IZwjWi5xNWFgb4yQX3YvFnWk9XCUHOg+uJt+viSpjX+3xc69yZ4lxjoPTxEM
	E04uhaZwMh4X6dfJqcIiCuCgGfYf7hzUSzvvpfFjEgFsevtOYn8GlHIf5XQ7fVn5FEn3vGO
	krc2zuOG/G7yJGLDyV9daWLGLjP6E1H2Ni5NP5x2Yu9c6jrMJs3f6kWWKZLp0QzKwqB5911
	IVUskZCsApQ5n7c8ROTA22tL4kCGJohhx75NQdsB/FG06QSl5+Kc5XDWSdgDMqaVE3UPRp7
	bN3EuXL50PHvt2Eyynqi7RRjin9ueCW5vaQc2E+IXnuXf8zNfes0ofjBbKk3YPzFLbjv/j/
	AhhnpgvDuHiUyXkOWLBXc1Ov1RnNGw176r2M/Rqb2VsJgpBa+giL/mwrkXOvVQYgqWVHm+m
	GMrVAAkc6zgFQlCBDoOQw6RK6bhd39P0DIojV3Z8LaNFCVllqb6A7FlWXyt7Fmor4FYflXR
	LVcHcnV3Iunc3TmGGs3ySUoND+WnQ5DJReExzQK2auKTVvjnOHu34VrtkZWNqGrVSHWqJrG
	iSKqa7mfBOloXR4ak/oiJId7tqLd/iFL0qDFPAXHMrCiFGkDjQYSHRBOGgbny4ffufHeyKq
	+rByfMK4770/JGnjKbuJcopzKzSDmiGDCMq4q7EEALyZw9zXySgeUDiAL3L6EHxh1iG/0Na
	C6dtgfKvngjxElogxtL5HYu9lD95iR1HVEyQ5k3+9zxOu5bPkJTZ6mmIcxEICbl5I53n0d8
	8UxpAgPwKjUHN1AQU8A3jWB4I3mXxYLZBr83kg7uMYUmsysjYJ
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

There are some spelling mistakes of 'notifer' in comments which
should be 'notifier'.

Fix them and add it to scripts/spelling.txt.

Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 arch/x86/kvm/i8254.c                                        | 4 ++--
 drivers/cxl/core/mce.h                                      | 2 +-
 drivers/gpu/drm/xe/xe_vm_types.h                            | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                       | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 drivers/tty/serial/8250/8250_dw.c                           | 2 +-
 include/xen/xenbus.h                                        | 2 +-
 scripts/spelling.txt                                        | 1 +
 8 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 739aa6c0d0c3..9ff55112900a 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -641,7 +641,7 @@ static void kvm_pit_reset(struct kvm_pit *pit)
 	kvm_pit_reset_reinject(pit);
 }
 
-static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
+static void pit_mask_notifier(struct kvm_irq_mask_notifier *kimn, bool mask)
 {
 	struct kvm_pit *pit = container_of(kimn, struct kvm_pit, mask_notifier);
 
@@ -694,7 +694,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 
 	pit_state->irq_ack_notifier.gsi = 0;
 	pit_state->irq_ack_notifier.irq_acked = kvm_pit_ack_irq;
-	pit->mask_notifier.func = pit_mask_notifer;
+	pit->mask_notifier.func = pit_mask_notifier;
 
 	kvm_pit_reset(pit);
 
diff --git a/drivers/cxl/core/mce.h b/drivers/cxl/core/mce.h
index ace73424eeb6..ca272e8db6c7 100644
--- a/drivers/cxl/core/mce.h
+++ b/drivers/cxl/core/mce.h
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_CXL_MCE
 int devm_cxl_register_mce_notifier(struct device *dev,
-				   struct notifier_block *mce_notifer);
+				   struct notifier_block *mce_notifier);
 #else
 static inline int
 devm_cxl_register_mce_notifier(struct device *dev,
diff --git a/drivers/gpu/drm/xe/xe_vm_types.h b/drivers/gpu/drm/xe/xe_vm_types.h
index 1979e9bdbdf3..0ca27579fd1f 100644
--- a/drivers/gpu/drm/xe/xe_vm_types.h
+++ b/drivers/gpu/drm/xe/xe_vm_types.h
@@ -259,7 +259,7 @@ struct xe_vm {
 		 * up for revalidation. Protected from access with the
 		 * @invalidated_lock. Removing items from the list
 		 * additionally requires @lock in write mode, and adding
-		 * items to the list requires either the @userptr.notifer_lock in
+		 * items to the list requires either the @userptr.notifier_lock in
 		 * write mode, OR @lock in write mode.
 		 */
 		struct list_head invalidated;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 147571fdada3..ee4696600146 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4610,7 +4610,7 @@ static int mvneta_stop(struct net_device *dev)
 		/* Inform that we are stopping so we don't want to setup the
 		 * driver for new CPUs in the notifiers. The code of the
 		 * notifier for CPU online is protected by the same spinlock,
-		 * so when we get the lock, the notifer work is done.
+		 * so when we get the lock, the notifier work is done.
 		 */
 		spin_lock(&pp->lock);
 		pp->is_stopped = true;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b94c3619526c..bcd56c7c4e42 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -8313,7 +8313,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	cfg->d11inf.io_type = (u8)io_type;
 	brcmu_d11_attach(&cfg->d11inf);
 
-	/* regulatory notifer below needs access to cfg so
+	/* regulatory notifier below needs access to cfg so
 	 * assign it now.
 	 */
 	drvr->config = cfg;
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 1902f29444a1..6d9af6417620 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -392,7 +392,7 @@ static void dw8250_set_termios(struct uart_port *p, struct ktermios *termios,
 	rate = clk_round_rate(d->clk, newrate);
 	if (rate > 0) {
 		/*
-		 * Note that any clock-notifer worker will block in
+		 * Note that any clock-notifier worker will block in
 		 * serial8250_update_uartclk() until we are done.
 		 */
 		ret = clk_set_rate(d->clk, newrate);
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 3f90bdd387b6..00b84f2e402b 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -180,7 +180,7 @@ int xenbus_printf(struct xenbus_transaction t,
  * sprintf-style type string, and pointer. Returns 0 or errno.*/
 int xenbus_gather(struct xenbus_transaction t, const char *dir, ...);
 
-/* notifer routines for when the xenstore comes up */
+/* notifier routines for when the xenstore comes up */
 extern int xenstored_ready;
 int register_xenstore_notifier(struct notifier_block *nb);
 void unregister_xenstore_notifier(struct notifier_block *nb);
diff --git a/scripts/spelling.txt b/scripts/spelling.txt
index c9a6df5be281..d824c4b17390 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -1099,6 +1099,7 @@ notication||notification
 notications||notifications
 notifcations||notifications
 notifed||notified
+notifer||notifier
 notity||notify
 notfify||notify
 nubmer||number
-- 
2.50.0


