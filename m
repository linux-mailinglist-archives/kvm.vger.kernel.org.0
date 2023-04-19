Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ABE6E7AB9
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbjDSN2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjDSN17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:59 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8917F4EEC
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:53 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r15so7559036wmo.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910872; x=1684502872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAzpvDGwBUf7AnIRiZR96oNsqPjKS9udD96ExLeWH18=;
        b=pHeQ4HSMM4WAl00aXKa1tDhTXIqToR4vfF89/rBXeGkA31U025Gm/zhHyaQM4mdCKX
         WanZqy5C3NVhfHcSzG2Xs+6mbI7uSpzxppxb/aLig8oGCGMmDVH3G5WUhtrOoeKHDfM4
         bkuozmYgzGGomu1bgeVVu5CflN8GNIeX057U7kMT3hn55RhtiT5vihIvzkSDeMBMkC6D
         yIK3xC+g6fGXWK0oqktMxUZlhdSmOeOMePpzjwgIYeghYn9PvEM8OcdbadrQNe0Lr4G6
         NOCK1+yCu/R6vWRf3xB03FvgugTO/UVRMDsUPZ3vaIivO5pwbzWsehNXWiKYEwyFodor
         Qebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910872; x=1684502872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAzpvDGwBUf7AnIRiZR96oNsqPjKS9udD96ExLeWH18=;
        b=cf+/QM9MAyr4PXe55kvJlEWThRCYSsKd553yWu7dYG44VH9+myPq/k37OdNrwqX7Db
         MtLFCb5dLd9z9lrHv1g3K4lCknBFyJHI+FwzsXZ3B5M3x2KM8wtkzehLyza0NZaJmDz9
         tU5d8lAvZz5k8sT7I+TcqwRSHYCFrcam3AKpUIuIWbtzMbycdphC4kL0juRFO5ec+INk
         xrUcudSFiRUVfmDRFyTeqSHPg0CRyfoNfZOku0eHIM8FCaX4xuhc3gnsPAhErjAgJLVo
         ZEZUsrqVcxPkSvarGHBSsOkvYnHsPBiC18VGKdI6S6ig8SKKNvGkFApStwuCWFewZl9s
         TVZg==
X-Gm-Message-State: AAQBX9cabXd9HDiiXJqOSj0zl5qe60WP29Nc6xFyBI1wZXe6IdVqoEWt
        ot6++F6XdUGD0fK0ANXvWBZtxkYS//zFuA73b/U=
X-Google-Smtp-Source: AKy350YCBqMAxrQXhEuFUr3vZSirNOurg42CE5n97uFoG+TSFke4IcXbMtOmgmgLk/PsiKVC3ciZdw==
X-Received: by 2002:a1c:740b:0:b0:3ed:276d:81a4 with SMTP id p11-20020a1c740b000000b003ed276d81a4mr17103168wmc.32.1681910871870;
        Wed, 19 Apr 2023 06:27:51 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:51 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 16/16] virtio/vhost: Clear VIRTIO_F_ACCESS_PLATFORM
Date:   Wed, 19 Apr 2023 14:21:20 +0100
Message-Id: <20230419132119.124457-17-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419132119.124457-1-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
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

Vhost interprets the VIRTIO_F_ACCESS_PLATFORM flag as if accesses need
to use vhost-iotlb, and since kvmtool does not implement vhost-iotlb,
vhost will fail to access the virtqueue.

This fix is preventive. Kvmtool does not set VIRTIO_F_ACCESS_PLATFORM at
the moment but the Arm CCA and pKVM changes will likely hit the issue
(as experienced with the CCA development tree), so we might as well fix
it now.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |  1 +
 virtio/net.c         | 14 ++++----------
 virtio/scsi.c        |  3 +--
 virtio/vhost.c       | 11 +++++++++++
 virtio/vsock.c       |  4 ++--
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 738efcd1..c6938e75 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -262,6 +262,7 @@ void virtio_vhost_set_vring_irqfd(struct kvm *kvm, u32 gsi,
 				  struct virt_queue *queue);
 void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			      struct virt_queue *queue);
+int virtio_vhost_set_features(int vhost_fd, u64 features);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index 9568b055..8be90159 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -517,23 +517,17 @@ static u64 get_host_features(struct kvm *kvm, void *dev)
 	return features;
 }
 
-static int virtio_net__vhost_set_features(struct net_dev *ndev)
+static void virtio_net_start(struct net_dev *ndev)
 {
 	/* VHOST_NET_F_VIRTIO_NET_HDR clashes with VIRTIO_F_ANY_LAYOUT! */
-	u64 features = ndev->vdev.features &
-			~(1UL << VHOST_NET_F_VIRTIO_NET_HDR);
-
-	return ioctl(ndev->vhost_fd, VHOST_SET_FEATURES, &features);
-}
+	u64 features = ndev->vdev.features & ~(1UL << VHOST_NET_F_VIRTIO_NET_HDR);
 
-static void virtio_net_start(struct net_dev *ndev)
-{
 	if (ndev->mode == NET_MODE_TAP) {
 		if (!virtio_net__tap_init(ndev))
 			die_perror("TAP device initialized failed because");
 
-		if (ndev->vhost_fd &&
-				virtio_net__vhost_set_features(ndev) != 0)
+		if (ndev->vhost_fd && virtio_vhost_set_features(ndev->vhost_fd,
+								features))
 			die_perror("VHOST_SET_FEATURES failed");
 	} else {
 		ndev->info.vnet_hdr_len = virtio_net_hdr_len(ndev);
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 60b5bc36..88e6fe5d 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -68,8 +68,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	struct virtio_scsi_config *conf = &sdev->config;
 
 	if (status & VIRTIO__STATUS_START) {
-		r = ioctl(sdev->vhost_fd, VHOST_SET_FEATURES,
-			  &sdev->vdev.features);
+		r = virtio_vhost_set_features(sdev->vhost_fd, sdev->vdev.features);
 		if (r != 0)
 			die_perror("VHOST_SET_FEATURES failed");
 
diff --git a/virtio/vhost.c b/virtio/vhost.c
index 0049003b..287e48dc 100644
--- a/virtio/vhost.c
+++ b/virtio/vhost.c
@@ -196,3 +196,14 @@ void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
 	close(queue->irqfd);
 	queue->irqfd = 0;
 }
+
+int virtio_vhost_set_features(int vhost_fd, u64 features)
+{
+	/*
+	 * vhost takes VIRTIO_F_ACCESS_PLATFORM as meaning there is an iotlb.
+	 * This is not the case for kvmtool, so mask it always.
+	 */
+	u64 masked_feat = features & ~(1ULL << VIRTIO_F_ACCESS_PLATFORM);
+
+	return ioctl(vhost_fd, VHOST_SET_FEATURES, &masked_feat);
+}
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 5d22bd24..7d4053a1 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -107,8 +107,8 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	if (status & VIRTIO__STATUS_START) {
 		start = 1;
 
-		r = ioctl(vdev->vhost_fd, VHOST_SET_FEATURES,
-			  &vdev->vdev.features);
+		r = virtio_vhost_set_features(vdev->vhost_fd,
+					      vdev->vdev.features);
 		if (r != 0)
 			die_perror("VHOST_SET_FEATURES failed");
 	} else if (status & VIRTIO__STATUS_STOP) {
-- 
2.40.0

