Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78B24E8A14
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 22:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiC0Uiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 16:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiC0Uiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 16:38:46 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F80538BD1
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:37:05 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id q5so16684620ljb.11
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bl7IBJ3Zi3asRFhOwNZCQiiOdP/VdkrT7G+x0cr8tiY=;
        b=DTBh4AIEt+pSHPZJ5/JwK7C1k01NNSIzNkqbfOzwUZjA7qwm7rPbkfZHcMKuQ6wvAC
         vrvcYGlEhgxY8JIfxMJAxWppcfz9hP+d11BNyMaPvqb0kxy6bFOlMdSh2aUws8+Pihl1
         RN96kRyKO6K667JpLa+EDw8MxtiHcaeTRHXDrosamFFwSWWAHZwYx4Bo51XYjm7GxcGE
         AaTHzPCdn/zlIzebgUjKDHZT8XxEuFjsBiZ9X7Wl4qusEMXu3eE8xI0AzwkzDmYpOBBa
         EuVn24V3iEJFpAxaMsjMtvQNQP4ehG7fQp4GUM1gFvRMm8nQJMfpFJwgAIEF6Cwlt/T4
         KBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bl7IBJ3Zi3asRFhOwNZCQiiOdP/VdkrT7G+x0cr8tiY=;
        b=ve043wpKJz/v1wdGzM+TSQV3GAVPKNlmecZHBq9tWvikzAW7I8U4Gxezzh7dRXqal/
         A8WMfcOytrNLf5sT2brQpmArCKN3Xnd4pkJNzCu+dAv+Jwlsvogu/+ZQoifk1ZFi4WOF
         mjj5ZoO3220djR/CUBZ3s7PoSPn5cythkfLE6tluWzSslutgawoeYBbvnAz10KYKrcWh
         0UHv4x3vsHgck+brwvbFIH0V7wuJe81mBxRdTAP3eer8QxtAlu47S00EzxJ8DW/M35od
         QpGhsWdFxuGR6sGOcDKixPSskKhMFIKzqxwpLxiTgp7eTolQ8yOZLy9SpEkWCU147phm
         l3yQ==
X-Gm-Message-State: AOAM532961q6vyLZtcwmtrdhsZMvZ0lqZ74/0S63PYtHsE6KbLDOARWp
        HdO3umqKqNO2oFS5KT47oplgdlBCCwG/Ng==
X-Google-Smtp-Source: ABdhPJxiW3A8NQMLxqbhAlIOp01DzyZQNKElUOD7qXE4K+xYTkHeZOLIwjEpR5yRKd+iPP0iCUOs4g==
X-Received: by 2002:a2e:a790:0:b0:249:906a:c6f1 with SMTP id c16-20020a2ea790000000b00249906ac6f1mr17233577ljf.164.1648413422658;
        Sun, 27 Mar 2022 13:37:02 -0700 (PDT)
Received: from sisu-ThinkPad-E14-Gen-2 (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id i18-20020a056512225200b0044a29058506sm1444267lfu.194.2022.03.27.13.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 13:37:02 -0700 (PDT)
Date:   Sun, 27 Mar 2022 23:37:00 +0300
From:   Martin Radev <martin.b.radev@gmail.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 2/5] virtio: Sanitize config accesses
Message-ID: <YkDK7L4vU/DpGmCN@sisu-ThinkPad-E14-Gen-2>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <20220303231050.2146621-3-martin.b.radev@gmail.com>
 <YjHgCrYF20UhtwWc@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjHgCrYF20UhtwWc@monolith.localdoman>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thank you for the review.
Answers are inline.
Here are the two patches:

int to u32 patch:

From ddedd3a59b41d97e07deac59af177b360cc04b20 Mon Sep 17 00:00:00 2001
From: Martin Radev <martin.b.radev@gmail.com>
Date: Thu, 24 Mar 2022 23:24:57 +0200
Subject: [PATCH kvmtool 3/6] virtio: Use u32 instead of int in pci_data_in/out

The PCI access size type is changed from a signed type
to an unsigned type since the size is never expected to
be negative, and the type also matches the type in the
signature of virtio_pci__io_mmio_callback.
This change simplifies size checking in the next patch.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 virtio/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 2777d1c..bcb205a 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -116,7 +116,7 @@ static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
 }
 
 static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *vdev,
-					 void *data, int size, unsigned long offset)
+					 void *data, u32 size, unsigned long offset)
 {
 	u32 config_offset;
 	struct virtio_pci *vpci = vdev->virtio;
@@ -146,7 +146,7 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
 }
 
 static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev,
-				unsigned long offset, void *data, int size)
+				unsigned long offset, void *data, u32 size)
 {
 	bool ret = true;
 	struct virtio_pci *vpci;
@@ -211,7 +211,7 @@ static void update_msix_map(struct virtio_pci *vpci,
 }
 
 static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device *vdev,
-					  void *data, int size, unsigned long offset)
+					  void *data, u32 size, unsigned long offset)
 {
 	struct virtio_pci *vpci = vdev->virtio;
 	u32 config_offset, vec;
@@ -285,7 +285,7 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 }
 
 static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vdev,
-				 unsigned long offset, void *data, int size)
+				 unsigned long offset, void *data, u32 size)
 {
 	bool ret = true;
 	struct virtio_pci *vpci;
-- 
2.25.1

Original patch but with comments addressed:

From 3a1a16895d7270be1dcb5d8c15607c25e6da670a Mon Sep 17 00:00:00 2001
From: Martin Radev <martin.b.radev@gmail.com>
Date: Sun, 16 Jan 2022 18:19:17 +0200
Subject: [PATCH kvmtool 4/6] virtio: Sanitize config accesses

The handling of VIRTIO_PCI_O_CONFIG is prone to buffer access overflows.
This patch sanitizes this operation by using the newly added virtio op
get_config_size. Any access which goes beyond the config structure's
size is prevented and a failure is returned.

Additionally, PCI accesses which span more than a single byte are prevented
and a warning is printed because the implementation does not currently
support the behavior correctly.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  1 +
 virtio/9p.c             | 25 ++++++++++++++++++++-----
 virtio/balloon.c        |  8 ++++++++
 virtio/blk.c            |  8 ++++++++
 virtio/console.c        |  8 ++++++++
 virtio/mmio.c           | 18 ++++++++++++++----
 virtio/net.c            |  8 ++++++++
 virtio/pci.c            | 29 +++++++++++++++++++++++++++++
 virtio/rng.c            |  6 ++++++
 virtio/scsi.c           |  8 ++++++++
 virtio/vsock.c          |  8 ++++++++
 12 files changed, 119 insertions(+), 9 deletions(-)

diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
index 3ea7698..77c5062 100644
--- a/include/kvm/virtio-9p.h
+++ b/include/kvm/virtio-9p.h
@@ -44,6 +44,7 @@ struct p9_dev {
 	struct virtio_device	vdev;
 	struct rb_root		fids;
 
+	size_t config_size;
 	struct virtio_9p_config	*config;
 	u32			features;
 
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 3a311f5..3880e74 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -184,6 +184,7 @@ struct virtio_device {
 
 struct virtio_ops {
 	u8 *(*get_config)(struct kvm *kvm, void *dev);
+	size_t (*get_config_size)(struct kvm *kvm, void *dev);
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
 	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
 	int (*get_vq_count)(struct kvm *kvm, void *dev);
diff --git a/virtio/9p.c b/virtio/9p.c
index b78f2b3..57cd6d0 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1375,6 +1375,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(p9dev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct p9_dev *p9dev = dev;
+
+	return p9dev->config_size;
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_9P_MOUNT_TAG;
@@ -1469,6 +1476,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 struct virtio_ops p9_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
@@ -1568,7 +1576,9 @@ virtio_dev_init(virtio_9p__init);
 int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
 {
 	struct p9_dev *p9dev;
-	int err = 0;
+	size_t tag_length;
+	size_t config_size;
+	int err;
 
 	p9dev = calloc(1, sizeof(*p9dev));
 	if (!p9dev)
@@ -1577,29 +1587,34 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
 	if (!tag_name)
 		tag_name = VIRTIO_9P_DEFAULT_TAG;
 
-	p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);
+	tag_length = strlen(tag_name);
+	/* The tag_name zero byte is intentionally excluded */
+	config_size = sizeof(*p9dev->config) + tag_length;
+
+	p9dev->config = calloc(1, config_size);
 	if (p9dev->config == NULL) {
 		err = -ENOMEM;
 		goto free_p9dev;
 	}
+	p9dev->config_size = config_size;
 
 	strncpy(p9dev->root_dir, root, sizeof(p9dev->root_dir));
 	p9dev->root_dir[sizeof(p9dev->root_dir)-1] = '\x00';
 
-	p9dev->config->tag_len = strlen(tag_name);
+	p9dev->config->tag_len = tag_length;
 	if (p9dev->config->tag_len > MAX_TAG_LEN) {
 		err = -EINVAL;
 		goto free_p9dev_config;
 	}
 
-	memcpy(&p9dev->config->tag, tag_name, strlen(tag_name));
+	memcpy(&p9dev->config->tag, tag_name, tag_length);
 
 	list_add(&p9dev->list, &devs);
 
 	if (compat_id == -1)
 		compat_id = virtio_compat_add_message("virtio-9p", "CONFIG_NET_9P_VIRTIO");
 
-	return err;
+	return 0;
 
 free_p9dev_config:
 	free(p9dev->config);
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 8e8803f..5bcd6ab 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -181,6 +181,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&bdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct bln_dev *bdev = dev;
+
+	return sizeof(bdev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_BALLOON_F_STATS_VQ;
@@ -251,6 +258,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 struct virtio_ops bln_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
diff --git a/virtio/blk.c b/virtio/blk.c
index 4d02d10..af71c0c 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -146,6 +146,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&bdev->blk_config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct blk_dev *bdev = dev;
+
+	return sizeof(bdev->blk_config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	struct blk_dev *bdev = dev;
@@ -291,6 +298,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops blk_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/console.c b/virtio/console.c
index e0b98df..dae6034 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -121,6 +121,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&cdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct con_dev *cdev = dev;
+
+	return sizeof(cdev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 0;
@@ -216,6 +223,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops con_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 5700a89..c14f08a 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -103,6 +103,8 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
 					u8 is_write, struct virtio_device *vdev)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
+	u8 *config;
+	size_t config_size;
 	u32 i;
 
 	/* Check for wrap-around. */
@@ -111,13 +113,21 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
 		return;
 	}
 
+	config = vdev->ops->get_config(vmmio->kvm, vmmio->dev);
+	config_size = vdev->ops->get_config_size(vmmio->kvm, vmmio->dev);
+
+	/* Prevent invalid accesses which go beyond the config */
+	if (config_size < addr + len) {
+		WARN_ONCE(1, "Offset (%llu) Length (%u) goes beyond config size (%zu).\n",
+			addr, len, config_size);
+		return;
+	}
+
 	for (i = 0; i < len; i++) {
 		if (is_write)
-			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
-					      *(u8 *)data + i;
+			config[addr + i] = *(u8 *)data + i;
 		else
-			data[i] = vdev->ops->get_config(vmmio->kvm,
-							vmmio->dev)[addr + i];
+			data[i] = config[addr + i];
 	}
 }
 
diff --git a/virtio/net.c b/virtio/net.c
index 1ee3c19..ec5dc1f 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -480,6 +480,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&ndev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct net_dev *ndev = dev;
+
+	return sizeof(ndev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	u32 features;
@@ -757,6 +764,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops net_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/pci.c b/virtio/pci.c
index bcb205a..13f2b76 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -136,7 +136,21 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
 		return true;
 	} else if (type == VIRTIO_PCI_O_CONFIG) {
 		u8 cfg;
+		size_t config_size;
+
+		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
+		if (config_offset + size > config_size) {
+			/* Access goes beyond the config size, so return failure. */
+			WARN_ONCE(1, "Config access offset (%u) is beyond config size (%zu)\n",
+				config_offset, config_size);
+			return false;
+		}
 
+		/* TODO: Handle access lengths beyond one byte */
+		if (size != 1) {
+			WARN_ONCE(1, "Size (%d) not supported\n", size);
+			return false;
+		}
 		cfg = vdev->ops->get_config(kvm, vpci->dev)[config_offset];
 		ioport__write8(data, cfg);
 		return true;
@@ -276,6 +290,21 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 
 		return true;
 	} else if (type == VIRTIO_PCI_O_CONFIG) {
+		size_t config_size;
+
+		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
+		if (config_offset + size > config_size) {
+			/* Access goes beyond the config size, so return failure. */
+			WARN_ONCE(1, "Config access offset (%u) is beyond config size (%zu)\n",
+				config_offset, config_size);
+			return false;
+		}
+
+		/* TODO: Handle access lengths beyond one byte */
+		if (size != 1) {
+			WARN_ONCE(1, "Size (%d) not supported\n", size);
+			return false;
+		}
 		vdev->ops->get_config(kvm, vpci->dev)[config_offset] = *(u8 *)data;
 
 		return true;
diff --git a/virtio/rng.c b/virtio/rng.c
index 78eaa64..c7835a0 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -47,6 +47,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return 0;
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	return 0;
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	/* Unused */
@@ -149,6 +154,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops rng_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 16a86cb..8f1c348 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -38,6 +38,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&sdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct scsi_dev *sdev = dev;
+
+	return sizeof(sdev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return	1UL << VIRTIO_RING_F_EVENT_IDX |
@@ -176,6 +183,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops scsi_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 5b99838..34397b6 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -41,6 +41,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&vdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct vsock_dev *vdev = dev;
+
+	return sizeof(vdev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1UL << VIRTIO_RING_F_EVENT_IDX
@@ -204,6 +211,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops vsock_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
-- 
2.25.1




On Wed, Mar 16, 2022 at 01:04:08PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Mar 04, 2022 at 01:10:47AM +0200, Martin Radev wrote:
> > The handling of VIRTIO_PCI_O_CONFIG is prone to buffer access overflows.
> > This patch sanitizes this operation by using the newly added virtio op
> > get_config_size. Any access which goes beyond the config structure's
> > size is prevented and a failure is returned.
> > 
> > Additionally, PCI accesses which span more than a single byte are prevented
> > and a warning is printed because the implementation does not currently
> > support the behavior correctly.
> > 
> > Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> > ---
> >  include/kvm/virtio-9p.h |  1 +
> >  include/kvm/virtio.h    |  1 +
> >  virtio/9p.c             | 25 ++++++++++++++++++++-----
> >  virtio/balloon.c        |  8 ++++++++
> >  virtio/blk.c            |  8 ++++++++
> >  virtio/console.c        |  8 ++++++++
> >  virtio/mmio.c           | 24 ++++++++++++++++++++----
> >  virtio/net.c            |  8 ++++++++
> >  virtio/pci.c            | 38 ++++++++++++++++++++++++++++++++++++++
> >  virtio/rng.c            |  6 ++++++
> >  virtio/scsi.c           |  8 ++++++++
> >  virtio/vsock.c          |  8 ++++++++
> >  12 files changed, 134 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
> > index 3ea7698..77c5062 100644
> > --- a/include/kvm/virtio-9p.h
> > +++ b/include/kvm/virtio-9p.h
> > @@ -44,6 +44,7 @@ struct p9_dev {
> >  	struct virtio_device	vdev;
> >  	struct rb_root		fids;
> >  
> > +	size_t config_size;
> >  	struct virtio_9p_config	*config;
> >  	u32			features;
> >  
> > diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> > index 3a311f5..3880e74 100644
> > --- a/include/kvm/virtio.h
> > +++ b/include/kvm/virtio.h
> > @@ -184,6 +184,7 @@ struct virtio_device {
> >  
> >  struct virtio_ops {
> >  	u8 *(*get_config)(struct kvm *kvm, void *dev);
> > +	size_t (*get_config_size)(struct kvm *kvm, void *dev);
> >  	u32 (*get_host_features)(struct kvm *kvm, void *dev);
> >  	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
> >  	int (*get_vq_count)(struct kvm *kvm, void *dev);
> > diff --git a/virtio/9p.c b/virtio/9p.c
> > index b78f2b3..6074f3a 100644
> > --- a/virtio/9p.c
> > +++ b/virtio/9p.c
> > @@ -1375,6 +1375,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> >  	return ((u8 *)(p9dev->config));
> >  }
> >  
> > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > +{
> > +	struct p9_dev *p9dev = dev;
> > +
> > +	return p9dev->config_size;
> > +}
> > +
> >  static u32 get_host_features(struct kvm *kvm, void *dev)
> >  {
> >  	return 1 << VIRTIO_9P_MOUNT_TAG;
> > @@ -1469,6 +1476,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> >  
> >  struct virtio_ops p9_dev_virtio_ops = {
> >  	.get_config		= get_config,
> > +	.get_config_size	= get_config_size,
> >  	.get_host_features	= get_host_features,
> >  	.set_guest_features	= set_guest_features,
> >  	.init_vq		= init_vq,
> > @@ -1568,7 +1576,9 @@ virtio_dev_init(virtio_9p__init);
> >  int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
> >  {
> >  	struct p9_dev *p9dev;
> > -	int err = 0;
> > +	size_t tag_name_length;
> 
> I think it would be better to name the variable tag_len, the same name as
> the corresponding field in struct virtio_9p_config. As a bonus, it's also
> shorter. But this is personal preference in the end, so I leave it up to
> you to decide which works better.
> 
Done.

> > +	size_t config_size;
> > +	int err;
> >  
> >  	p9dev = calloc(1, sizeof(*p9dev));
> >  	if (!p9dev)
> > @@ -1577,29 +1587,34 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
> >  	if (!tag_name)
> >  		tag_name = VIRTIO_9P_DEFAULT_TAG;
> >  
> > -	p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);
> > +	tag_name_length = strlen(tag_name);
> > +	/* The tag_name zero byte is intentionally excluded */
> 
> If this is indeed a bug (the comment from virtio_9p_config seems to suggest
> it is, but I couldn't find the 9p spec), the bug is that the config size is
> computed incorrectly, which is a different bug than a guest being able to
> write outside of the config region for the device. As such, it should be
> fixed in a separate patch.
> 
I couldn't find information about how large the configuration size is and
whether the 0 byte is included. QEMU explicitly excludes it.
See https://elixir.bootlin.com/qemu/latest/source/hw/9pfs/virtio-9p-device.c#L218
I think this is almost surely the correct way considering the tag length
is also part of the config.

> > +	config_size = sizeof(*p9dev->config) + tag_name_length;
> > +
> > +	p9dev->config = calloc(1, config_size);
> >  	if (p9dev->config == NULL) {
> >  		err = -ENOMEM;
> >  		goto free_p9dev;
> >  	}
> > +	p9dev->config_size = config_size;
> >  
> >  	strncpy(p9dev->root_dir, root, sizeof(p9dev->root_dir));
> >  	p9dev->root_dir[sizeof(p9dev->root_dir)-1] = '\x00';
> >  
> > -	p9dev->config->tag_len = strlen(tag_name);
> > +	p9dev->config->tag_len = tag_name_length;
> >  	if (p9dev->config->tag_len > MAX_TAG_LEN) {
> >  		err = -EINVAL;
> >  		goto free_p9dev_config;
> >  	}
> >  
> > -	memcpy(&p9dev->config->tag, tag_name, strlen(tag_name));
> > +	memcpy(&p9dev->config->tag, tag_name, tag_name_length);
> >  
> >  	list_add(&p9dev->list, &devs);
> >  
> >  	if (compat_id == -1)
> >  		compat_id = virtio_compat_add_message("virtio-9p", "CONFIG_NET_9P_VIRTIO");
> >  
> > -	return err;
> > +	return 0;
> >  
> >  free_p9dev_config:
> >  	free(p9dev->config);
> > diff --git a/virtio/balloon.c b/virtio/balloon.c
> > index 8e8803f..5bcd6ab 100644
> > --- a/virtio/balloon.c
> > +++ b/virtio/balloon.c
> > @@ -181,6 +181,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> >  	return ((u8 *)(&bdev->config));
> >  }
> >  
> > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > +{
> > +	struct bln_dev *bdev = dev;
> > +
> > +	return sizeof(bdev->config);
> > +}
> > +
> >  static u32 get_host_features(struct kvm *kvm, void *dev)
> >  {
> >  	return 1 << VIRTIO_BALLOON_F_STATS_VQ;
> > @@ -251,6 +258,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> >  
> >  struct virtio_ops bln_dev_virtio_ops = {
> >  	.get_config		= get_config,
> > +	.get_config_size	= get_config_size,
> >  	.get_host_features	= get_host_features,
> >  	.set_guest_features	= set_guest_features,
> >  	.init_vq		= init_vq,
> > diff --git a/virtio/blk.c b/virtio/blk.c
> > index 4d02d10..af71c0c 100644
> > --- a/virtio/blk.c
> > +++ b/virtio/blk.c
> > @@ -146,6 +146,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> >  	return ((u8 *)(&bdev->blk_config));
> >  }
> >  
> > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > +{
> > +	struct blk_dev *bdev = dev;
> > +
> > +	return sizeof(bdev->blk_config);
> > +}
> > +
> >  static u32 get_host_features(struct kvm *kvm, void *dev)
> >  {
> >  	struct blk_dev *bdev = dev;
> > @@ -291,6 +298,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> >  
> >  static struct virtio_ops blk_dev_virtio_ops = {
> >  	.get_config		= get_config,
> > +	.get_config_size	= get_config_size,
> >  	.get_host_features	= get_host_features,
> >  	.set_guest_features	= set_guest_features,
> >  	.get_vq_count		= get_vq_count,
> > diff --git a/virtio/console.c b/virtio/console.c
> > index e0b98df..dae6034 100644
> > --- a/virtio/console.c
> > +++ b/virtio/console.c
> > @@ -121,6 +121,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> >  	return ((u8 *)(&cdev->config));
> >  }
> >  
> > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > +{
> > +	struct con_dev *cdev = dev;
> > +
> > +	return sizeof(cdev->config);
> > +}
> > +
> >  static u32 get_host_features(struct kvm *kvm, void *dev)
> >  {
> >  	return 0;
> > @@ -216,6 +223,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> >  
> >  static struct virtio_ops con_dev_virtio_ops = {
> >  	.get_config		= get_config,
> > +	.get_config_size	= get_config_size,
> >  	.get_host_features	= get_host_features,
> >  	.set_guest_features	= set_guest_features,
> >  	.get_vq_count		= get_vq_count,
> > diff --git a/virtio/mmio.c b/virtio/mmio.c
> > index 875a288..0094856 100644
> > --- a/virtio/mmio.c
> > +++ b/virtio/mmio.c
> > @@ -103,15 +103,31 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
> >  					u8 is_write, struct virtio_device *vdev)
> >  {
> >  	struct virtio_mmio *vmmio = vdev->virtio;
> > +	u8 *config_aperture;
> > +	size_t config_aperture_size;
> 
> These could be shortened to config and config_size, to better match the
> callback names (get_config, respectively get_config_size) and make the code
> easier to understand.
> 
Done.

> >  	u32 i;
> >  
> > +	/* Check for wrap-around. */
> > +	if (addr + len < addr) {
> 
> No need for this, you can move patch #5 before this one, and that should
> take care of any wrap arounds.
> 
Done.

> > +		WARN_ONCE(1, "addr (%llu) + length (%u) wraps-around.\n", addr, len);
> > +		return;
> > +	}
> > +
> > +	config_aperture = vdev->ops->get_config(vmmio->kvm, vmmio->dev);
> > +	config_aperture_size = vdev->ops->get_config_size(vmmio->kvm, vmmio->dev);
> > +
> > +	/* Prevent invalid accesses which go beyond the config */
> > +	if (config_aperture_size < addr + len) {
> > +		WARN_ONCE(1, "Offset (%llu) Length (%u) goes beyond config size (%zu).\n",
> > +			addr, len, config_aperture_size);
> > +		return;
> > +	}
> > +
> >  	for (i = 0; i < len; i++) {
> >  		if (is_write)
> > -			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
> > -					      *(u8 *)data + i;
> > +			config_aperture[addr + i] = *(u8 *)data + i;
> >  		else
> > -			data[i] = vdev->ops->get_config(vmmio->kvm,
> > -							vmmio->dev)[addr + i];
> > +			data[i] = config_aperture[addr + i];
> >  	}
> >  }
> >  
> > diff --git a/virtio/net.c b/virtio/net.c
> > index 1ee3c19..ec5dc1f 100644
> > --- a/virtio/net.c
> > +++ b/virtio/net.c
> > @@ -480,6 +480,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> >  	return ((u8 *)(&ndev->config));
> >  }
> >  
> > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > +{
> > +	struct net_dev *ndev = dev;
> > +
> > +	return sizeof(ndev->config);
> > +}
> > +
> >  static u32 get_host_features(struct kvm *kvm, void *dev)
> >  {
> >  	u32 features;
> > @@ -757,6 +764,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> >  
> >  static struct virtio_ops net_dev_virtio_ops = {
> >  	.get_config		= get_config,
> > +	.get_config_size	= get_config_size,
> >  	.get_host_features	= get_host_features,
> >  	.set_guest_features	= set_guest_features,
> >  	.get_vq_count		= get_vq_count,
> > diff --git a/virtio/pci.c b/virtio/pci.c
> > index 2777d1c..0b5cccd 100644
> > --- a/virtio/pci.c
> > +++ b/virtio/pci.c
> > @@ -136,7 +136,25 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
> >  		return true;
> >  	} else if (type == VIRTIO_PCI_O_CONFIG) {
> >  		u8 cfg;
> > +		size_t config_size;
> >  
> > +		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
> > +		if (size <= 0) {
> > +			WARN_ONCE(1, "Size (%d) is non-positive\n", size);
> > +			return false;
> > +		}
> 
> This is a different bug. The kvm_run.mmio struct report length as an u32
> and the type is preserved until virtio_pci__data_{in,out} are called from
> virtio_pci__mmio_callback(). The correct fix is to change the size
> parameter from virtio_pci__data_{in,out} and
> virtio_pci__specific_data_{in,out} to an u32 in a separate patch.

I addressed this as you suggested. Patch is attached.

> 
> [1] https://elixir.bootlin.com/linux/v5.17-rc8/source/Documentation/virt/kvm/api.rst#L5726
> 
> Thanks,
> Alex
> 
> > +		if (config_offset + (u32)size > config_size) {
> > +			/* Access goes beyond the config size, so return failure. */
> > +			WARN_ONCE(1, "Config access offset (%u) is beyond config size (%zu)\n",
> > +				config_offset, config_size);
> > +			return false;
> > +		}
> > +
> > +		/* TODO: Handle access lengths beyond one byte */
> > +		if (size != 1) {
> > +			WARN_ONCE(1, "Size (%d) not supported\n", size);
> > +			return false;
> > +		}
> >  		cfg = vdev->ops->get_config(kvm, vpci->dev)[config_offset];
> >  		ioport__write8(data, cfg);
> >  		return true;
> > @@ -276,6 +294,26 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
> >  
> >  		return true;
> >  	} else if (type == VIRTIO_PCI_O_CONFIG) {
> > +		size_t config_size;
> > +
> > +		if (size <= 0) {
> > +			WARN_ONCE(1, "Size (%d) is non-positive\n", size);
> > +			return false;
> > +		}
> > +
> > +		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
> > +		if (config_offset + (u32)size > config_size) {
> > +			/* Access goes beyond the config size, so return failure. */
> > +			WARN_ONCE(1, "Config access offset (%u) is beyond config size (%zu)\n",
> > +				config_offset, config_size);
> > +			return false;
> > +		}
> > +
> > +		/* TODO: Handle access lengths beyond one byte */
> > +		if (size != 1) {
> > +			WARN_ONCE(1, "Size (%d) not supported\n", size);
> > +			return false;
> > +		}
> >  		vdev->ops->get_config(kvm, vpci->dev)[config_offset] = *(u8 *)data;
> >  
> >  		return true;
> > diff --git a/virtio/rng.c b/virtio/rng.c
> > index 78eaa64..c7835a0 100644
> > --- a/virtio/rng.c
> > +++ b/virtio/rng.c
> > @@ -47,6 +47,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> >  	return 0;
> >  }
> >  
> > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > +{
> > +	return 0;
> > +}
> > +
> >  static u32 get_host_features(struct kvm *kvm, void *dev)
> >  {
> >  	/* Unused */
> > @@ -149,6 +154,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> >  
> >  static struct virtio_ops rng_dev_virtio_ops = {
> >  	.get_config		= get_config,
> > +	.get_config_size	= get_config_size,
> >  	.get_host_features	= get_host_features,
> >  	.set_guest_features	= set_guest_features,
> >  	.init_vq		= init_vq,
> > diff --git a/virtio/scsi.c b/virtio/scsi.c
> > index 16a86cb..8f1c348 100644
> > --- a/virtio/scsi.c
> > +++ b/virtio/scsi.c
> > @@ -38,6 +38,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> >  	return ((u8 *)(&sdev->config));
> >  }
> >  
> > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > +{
> > +	struct scsi_dev *sdev = dev;
> > +
> > +	return sizeof(sdev->config);
> > +}
> > +
> >  static u32 get_host_features(struct kvm *kvm, void *dev)
> >  {
> >  	return	1UL << VIRTIO_RING_F_EVENT_IDX |
> > @@ -176,6 +183,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> >  
> >  static struct virtio_ops scsi_dev_virtio_ops = {
> >  	.get_config		= get_config,
> > +	.get_config_size	= get_config_size,
> >  	.get_host_features	= get_host_features,
> >  	.set_guest_features	= set_guest_features,
> >  	.init_vq		= init_vq,
> > diff --git a/virtio/vsock.c b/virtio/vsock.c
> > index 5b99838..34397b6 100644
> > --- a/virtio/vsock.c
> > +++ b/virtio/vsock.c
> > @@ -41,6 +41,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> >  	return ((u8 *)(&vdev->config));
> >  }
> >  
> > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > +{
> > +	struct vsock_dev *vdev = dev;
> > +
> > +	return sizeof(vdev->config);
> > +}
> > +
> >  static u32 get_host_features(struct kvm *kvm, void *dev)
> >  {
> >  	return 1UL << VIRTIO_RING_F_EVENT_IDX
> > @@ -204,6 +211,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> >  
> >  static struct virtio_ops vsock_dev_virtio_ops = {
> >  	.get_config		= get_config,
> > +	.get_config_size	= get_config_size,
> >  	.get_host_features	= get_host_features,
> >  	.set_guest_features	= set_guest_features,
> >  	.init_vq		= init_vq,
> > -- 
> > 2.25.1
> > 
