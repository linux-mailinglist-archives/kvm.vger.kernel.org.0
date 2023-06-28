Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D554741001
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 13:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjF1LZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 07:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjF1LYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 07:24:52 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3555F2972
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:24:48 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-313e742a787so785657f8f.1
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687951486; x=1690543486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSYqyy03pZrgfAhjl+7r91H7zYXkAKbJ0x4YiAc6ngc=;
        b=P1ZvfXDXAQPcgFZ7bOY4VpEhFlXIaFSldIEVLUvxRSMPzzYcR9QQQYTdE9jM6sdx8V
         BF5QEnPzWmiChTDBBFBrvQaY6TvLoFdWwF1rnL+a55CUdtfUf77IUtnH7tdk0VCXNBCN
         K1rxFzlCyGlMIe7rAZGKTXPBdFxLkMXW2wq/SjyZu1J33kzznRJ9QtHna2KtQilhXVR5
         zdE2Jf0Wf6iAuBJ0BEGYSPVWdObdOam859vNU8iazSzB2R+LSP4lQ/uAXem2NHkfjjHZ
         RXSsAjpodGmumk64Bp5raIKvLjc1Y7PeM43W0HNjTpgOt1tgdLetALWxwBfoXFjFMQ/m
         zVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687951486; x=1690543486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSYqyy03pZrgfAhjl+7r91H7zYXkAKbJ0x4YiAc6ngc=;
        b=kLOcn9um93kkFST5+DLBGECWFoWUHD3GZOwWZZCtsqYwB7HW+f8gON3I6JWCINXv59
         s1r7D++xPjIxoKOl+HdOuCf7i8vep+B3kfdPym8fWHjZhKq2LGeXvVj7LedBvfWSWmJm
         yfqTJ4Rw87zasTvUCw0xfzaFahDDVcZxuhmiL7Mtk7ZKGdN36jDS9OncYX3Aw9E5IhJf
         64tT4J/iP/48qRVptEl5wguavK5/mXpFcbomb5IOPFbI2dE1qHQMMGphCK/GQgD5Kw4o
         w9U169/p5C7SpG+Mq1FA2OwlFqZQFzyKrJRA/GAXpv1H6liUfbXFjASmqfxJH4JrJk0+
         bzTQ==
X-Gm-Message-State: AC+VfDwQS6lFBwQcf5y6RtNhctXwgfjq0VlVqN7UPPw+JeY5JbEEjNHE
        Q8HlQKbFtuQbFSCKL7ZxB5N4N0v/xm4fPHOP2BI=
X-Google-Smtp-Source: ACHHUZ45yE6tyKc2WDTu0nnkFohj8SVftSKOuQaa3aPw65d2t+DWG2aLgQBiE9d/PXlK8bCF4xQFbw==
X-Received: by 2002:a5d:640d:0:b0:313:ef62:6370 with SMTP id z13-20020a5d640d000000b00313ef626370mr1422976wru.10.1687951486690;
        Wed, 28 Jun 2023 04:24:46 -0700 (PDT)
Received: from localhost.localdomain ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d6dc1000000b00304adbeeabbsm13065173wrz.99.2023.06.28.04.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 04:24:46 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     vivek.gautam@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 2/2] vfio/pci: Clarify the MSI states
Date:   Wed, 28 Jun 2023 12:23:32 +0100
Message-ID: <20230628112331.453904-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230628112331.453904-2-jean-philippe@linaro.org>
References: <20230628112331.453904-2-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MSI and MSI-X implementations is a bit complex, because it keeps
track of capability and vector states as seen by both the guest and the
host. Add a few comments about those states and rename them to something
more accurate.

What's called phys_state at the moment represents the software state
maintained by VFIO and kvmtool, rather than the physical MSI capability,
so host_state is more correct. To be consistent, rename virt_state to
guest_state as well.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/vfio.h |  8 ++---
 vfio/pci.c         | 86 ++++++++++++++++++++++++++++------------------
 2 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 764ab9b9..ac7b6226 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -36,8 +36,8 @@ struct vfio_pci_msi_entry {
 	struct msix_table		config;
 	int				gsi;
 	int				eventfd;
-	u8				phys_state;
-	u8				virt_state;
+	u8				guest_state;
+	u8				host_state;
 };
 
 struct vfio_pci_msix_table {
@@ -57,8 +57,8 @@ struct vfio_pci_msix_pba {
 /* Common data for MSI and MSI-X */
 struct vfio_pci_msi_common {
 	off_t				pos;
-	u8				virt_state;
-	u8				phys_state;
+	u8				guest_state;
+	u8				host_state;
 	struct mutex			mutex;
 	struct vfio_irq_info		info;
 	struct vfio_irq_set		*irq_set;
diff --git a/vfio/pci.c b/vfio/pci.c
index a10b5528..0bcd60e6 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -28,8 +28,31 @@ static void set_vfio_irq_eventd_payload(union vfio_irq_eventfd *evfd, int fd)
 	memcpy(&evfd->irq.data, &fd, sizeof(fd));
 }
 
+/*
+ * To support MSI and MSI-X with common code, track the host and guest states of
+ * the MSI/MSI-X capability, and of individual vectors.
+ *
+ * Both MSI and MSI-X capabilities are enabled and disabled through registers.
+ * Vectors cannot be individually disabled.
+ */
 #define msi_is_enabled(state)		((state) & VFIO_PCI_MSI_STATE_ENABLED)
+
+/*
+ * MSI-X: the control register allows to mask all vectors, and the table allows
+ * to mask each vector individually.
+ *
+ * MSI: if the capability supports Per-Vector Masking then the Mask Bit register
+ * allows to mask each vector individually. Otherwise there is no masking for
+ * MSI.
+ */
 #define msi_is_masked(state)		((state) & VFIO_PCI_MSI_STATE_MASKED)
+
+/*
+ * A capability is empty when no vector has been registered with SET_IRQS
+ * yet. It's an optimization specific to kvmtool to avoid issuing lots of
+ * SET_IRQS ioctls when the guest configures the MSI-X table while the
+ * capability is masked.
+ */
 #define msi_is_empty(state)		((state) & VFIO_PCI_MSI_STATE_EMPTY)
 
 #define msi_update_state(state, val, bit)				\
@@ -62,7 +85,7 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 		},
 	};
 
-	if (!msi_is_enabled(msis->virt_state))
+	if (!msi_is_enabled(msis->guest_state))
 		return 0;
 
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
@@ -78,9 +101,9 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 
 	/*
 	 * Initial registration of the full range. This enables the physical
-	 * MSI/MSI-X capability, which might have desired side effects. For
-	 * instance when assigning virtio legacy devices, enabling the MSI
-	 * capability modifies the config space layout!
+	 * MSI/MSI-X capability, which might have side effects. For instance
+	 * when assigning virtio legacy devices, enabling the MSI capability
+	 * modifies the config space layout!
 	 *
 	 * As an optimization, only update MSIs when guest unmasks the
 	 * capability. This greatly reduces the initialization time for Linux
@@ -88,13 +111,10 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 	 * masked, then fills individual vectors, then unmasks the whole
 	 * function. So we only do one VFIO ioctl when enabling for the first
 	 * time, and then one when unmasking.
-	 *
-	 * phys_state is empty when it is enabled but no vector has been
-	 * registered via SET_IRQS yet.
 	 */
-	if (!msi_is_enabled(msis->phys_state) ||
-	    (!msi_is_masked(msis->virt_state) &&
-	     msi_is_empty(msis->phys_state))) {
+	if (!msi_is_enabled(msis->host_state) ||
+	    (!msi_is_masked(msis->guest_state) &&
+	     msi_is_empty(msis->host_state))) {
 		bool empty = true;
 
 		for (i = 0; i < msis->nr_entries; i++) {
@@ -111,14 +131,14 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 			return ret;
 		}
 
-		msi_set_enabled(msis->phys_state, true);
-		msi_set_empty(msis->phys_state, empty);
+		msi_set_enabled(msis->host_state, true);
+		msi_set_empty(msis->host_state, empty);
 
 		return 0;
 	}
 
-	if (msi_is_masked(msis->virt_state)) {
-		/* TODO: if phys_state is not empty nor masked, mask all vectors */
+	if (msi_is_masked(msis->guest_state)) {
+		/* TODO: if host_state is not empty nor masked, mask all vectors */
 		return 0;
 	}
 
@@ -141,8 +161,8 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 
 		eventfds[i] = fd;
 
-		if (msi_is_empty(msis->phys_state) && fd >= 0)
-			msi_set_empty(msis->phys_state, false);
+		if (msi_is_empty(msis->host_state) && fd >= 0)
+			msi_set_empty(msis->host_state, false);
 	}
 
 	return ret;
@@ -162,7 +182,7 @@ static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
 		.count	= 0,
 	};
 
-	if (!msi_is_enabled(msis->phys_state))
+	if (!msi_is_enabled(msis->host_state))
 		return 0;
 
 	ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
@@ -171,8 +191,8 @@ static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
 		return ret;
 	}
 
-	msi_set_enabled(msis->phys_state, false);
-	msi_set_empty(msis->phys_state, true);
+	msi_set_enabled(msis->host_state, false);
+	msi_set_empty(msis->host_state, true);
 
 	/*
 	 * When MSI or MSIX is disabled, this might be called when
@@ -223,12 +243,12 @@ static int vfio_pci_update_msi_entry(struct kvm *kvm, struct vfio_device *vdev,
 	 *   the eventfd in a local handler, in order to serve Pending Bit reads
 	 *   to the guest.
 	 *
-	 * So entry->phys_state is masked when there is no active irqfd route.
+	 * So entry->host_state is masked when there is no active irqfd route.
 	 */
-	if (msi_is_masked(entry->virt_state) == msi_is_masked(entry->phys_state))
+	if (msi_is_masked(entry->guest_state) == msi_is_masked(entry->host_state))
 		return 0;
 
-	if (msi_is_masked(entry->phys_state)) {
+	if (msi_is_masked(entry->host_state)) {
 		ret = irq__add_irqfd(kvm, entry->gsi, entry->eventfd, -1);
 		if (ret < 0) {
 			vfio_dev_err(vdev, "cannot setup irqfd");
@@ -238,7 +258,7 @@ static int vfio_pci_update_msi_entry(struct kvm *kvm, struct vfio_device *vdev,
 		irq__del_irqfd(kvm, entry->gsi, entry->eventfd);
 	}
 
-	msi_set_masked(entry->phys_state, msi_is_masked(entry->virt_state));
+	msi_set_masked(entry->host_state, msi_is_masked(entry->guest_state));
 
 	return 0;
 }
@@ -311,7 +331,7 @@ static void vfio_pci_msix_table_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	if (field + len <= PCI_MSIX_ENTRY_VECTOR_CTRL)
 		goto out_unlock;
 
-	msi_set_masked(entry->virt_state, entry->config.ctrl &
+	msi_set_masked(entry->guest_state, entry->config.ctrl &
 		       PCI_MSIX_ENTRY_CTRL_MASKBIT);
 
 	if (vfio_pci_update_msi_entry(kvm, vdev, entry) < 0)
@@ -346,9 +366,9 @@ static void vfio_pci_msix_cap_write(struct kvm *kvm,
 
 	mutex_lock(&pdev->msix.mutex);
 
-	msi_set_masked(pdev->msix.virt_state, flags & PCI_MSIX_FLAGS_MASKALL);
+	msi_set_masked(pdev->msix.guest_state, flags & PCI_MSIX_FLAGS_MASKALL);
 	enable = flags & PCI_MSIX_FLAGS_ENABLE;
-	msi_set_enabled(pdev->msix.virt_state, enable);
+	msi_set_enabled(pdev->msix.guest_state, enable);
 
 	if (enable && vfio_pci_enable_msis(kvm, vdev, true))
 		vfio_dev_err(vdev, "cannot enable MSIX");
@@ -382,7 +402,7 @@ static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
 	/* Set mask to current state */
 	for (i = 0; i < pdev->msi.nr_entries; i++) {
 		entry = &pdev->msi.entries[i];
-		mask |= !!msi_is_masked(entry->virt_state) << i;
+		mask |= !!msi_is_masked(entry->guest_state) << i;
 	}
 
 	/* Update mask following the intersection of access and register */
@@ -397,8 +417,8 @@ static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
 		bool masked = mask & (1 << i);
 
 		entry = &pdev->msi.entries[i];
-		if (masked != msi_is_masked(entry->virt_state)) {
-			msi_set_masked(entry->virt_state, masked);
+		if (masked != msi_is_masked(entry->guest_state)) {
+			msi_set_masked(entry->guest_state, masked);
 			vfio_pci_update_msi_entry(kvm, vdev, entry);
 		}
 	}
@@ -430,9 +450,9 @@ static void vfio_pci_msi_cap_write(struct kvm *kvm, struct vfio_device *vdev,
 
 	ctrl = *(u8 *)(data + PCI_MSI_FLAGS - off);
 
-	msi_set_enabled(pdev->msi.virt_state, ctrl & PCI_MSI_FLAGS_ENABLE);
+	msi_set_enabled(pdev->msi.guest_state, ctrl & PCI_MSI_FLAGS_ENABLE);
 
-	if (!msi_is_enabled(pdev->msi.virt_state)) {
+	if (!msi_is_enabled(pdev->msi.guest_state)) {
 		vfio_pci_disable_msis(kvm, vdev, false);
 		goto out_unlock;
 	}
@@ -1182,8 +1202,8 @@ static int vfio_pci_init_msis(struct kvm *kvm, struct vfio_device *vdev,
 		entry = &msis->entries[i];
 		entry->gsi = -1;
 		entry->eventfd = -1;
-		msi_set_masked(entry->virt_state, false);
-		msi_set_masked(entry->phys_state, true);
+		msi_set_masked(entry->guest_state, false);
+		msi_set_masked(entry->host_state, true);
 		eventfds[i] = -1;
 	}
 
-- 
2.41.0

