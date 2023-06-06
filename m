Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BFF7243A4
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbjFFNFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237905AbjFFNFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:21 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18806EA
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:20 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f3ba703b67so7497554e87.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056718; x=1688648718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMCSj9ykrTkYqs21+BkUjr47dMUoWMQ/hEySo2FJU04=;
        b=CX58Ts/sgWwSznUPLCLmtUXiJqOoIvlMuYj0jb8QOzcuKyQuv+x0LpihgNlp8TDfEf
         hOdw5B5ad8W9iSQ9LoSSXDl8frVwOwDONyqYctwMagBu/E0FbHozV2siT9uqdL3Zft/S
         XceqLenu7XIdmSBAWebFCHdzSA0gFWVkVAPkeDbrCyqmsZJo3ox9xOnOralAdm3J+cSx
         aYgPdLLP3bFE1ZmeuURR3NSU4FlUxEeKtlYn5y6DxQ0n18j255aq2tpW+UpgMrj+ZZXd
         N6MoBPPAcs4GrbIojFr4xoK2z6zFTw83L/KVp2ve5h1BeT0MmsAWEgCtbuXZFVfq3M9h
         ppHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056718; x=1688648718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMCSj9ykrTkYqs21+BkUjr47dMUoWMQ/hEySo2FJU04=;
        b=Q4l7Oo8MV44fHXd5YMs4hFZvfVEetPS/n1qY0gxTzML3Ixn73tAwu/H7G+D+hhMUDP
         lN4gMG6+p7FVXfIKucnmt0klRYVQ6HHk1n0yfsRo1hM1nNBPlYcNTD7PjwbFDTQK6FDw
         lvd7IgxwCJj4+bvbkgJSHDbwvvUTS06tdA9PZJWxKzSYfh9FiI3BIMf6RuoPz5obe0jn
         9ZftjNxH3VDmY9e2/3UiWK800qit9C9zgJPLp1Khv7AHJ/O1EiPteDMaZUPT/10s3pj2
         /xoJyOJgGTLHCvLzgmvyIsPJrcgb3IQtfOSzaVayiQXZvP90f86g0B0YvE09qY4Gw4T7
         1Fzg==
X-Gm-Message-State: AC+VfDxT7FcOPim1vTL6J7T+jIKMUBAQw+Nev/ODA7bW2Est1HgYPxHy
        vKgPmElM1SdoI88pB0vB0Dwf6fNALV318ggd2maQ9Q==
X-Google-Smtp-Source: ACHHUZ5NkIFQuJZG1ezT1j+aT1JZHIyO3ZJNXh+xuayBkIMwWj/5NIIAll3hrQPElMaDDR2KTZMGWg==
X-Received: by 2002:ac2:554f:0:b0:4ea:f8f0:545f with SMTP id l15-20020ac2554f000000b004eaf8f0545fmr879200lfk.52.1686056718345;
        Tue, 06 Jun 2023 06:05:18 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:18 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 10/17] virtio/vsock: Fix feature selection
Date:   Tue,  6 Jun 2023 14:04:19 +0100
Message-Id: <20230606130426.978945-11-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606130426.978945-1-jean-philippe@linaro.org>
References: <20230606130426.978945-1-jean-philippe@linaro.org>
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

We should advertise to the guest only the features supported by vhost
and kvmtool. Then we should set in vhost only the features acked by the
guest. Move vhost feature query to get_host_features(), and vhost
feature setting to device start (after the guest has acked features).

This fixes vsock because we used to enable all vhost features including
VIRTIO_F_ACCESS_PLATFORM, which forces vhost to use vhost-iotlb and
isn't supported by kvmtool.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/vsock.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/virtio/vsock.c b/virtio/vsock.c
index 559fbaba..64512713 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -51,8 +51,17 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 
 static u64 get_host_features(struct kvm *kvm, void *dev)
 {
-	return 1UL << VIRTIO_RING_F_EVENT_IDX
-		| 1UL << VIRTIO_RING_F_INDIRECT_DESC;
+	int r;
+	u64 features;
+	struct vsock_dev *vdev = dev;
+
+	r = ioctl(vdev->vhost_fd, VHOST_GET_FEATURES, &features);
+	if (r != 0)
+		die_perror("VHOST_GET_FEATURES failed");
+
+	return features &
+		(1ULL << VIRTIO_RING_F_EVENT_IDX |
+		 1ULL << VIRTIO_RING_F_INDIRECT_DESC);
 }
 
 static bool is_event_vq(u32 vq)
@@ -95,12 +104,18 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	if (status & VIRTIO__STATUS_CONFIG)
 		vdev->config.guest_cid = cpu_to_le64(vdev->guest_cid);
 
-	if (status & VIRTIO__STATUS_START)
+	if (status & VIRTIO__STATUS_START) {
 		start = 1;
-	else if (status & VIRTIO__STATUS_STOP)
+
+		r = ioctl(vdev->vhost_fd, VHOST_SET_FEATURES,
+			  &vdev->vdev.features);
+		if (r != 0)
+			die_perror("VHOST_SET_FEATURES failed");
+	} else if (status & VIRTIO__STATUS_STOP) {
 		start = 0;
-	else
+	} else {
 		return;
+	}
 
 	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_RUNNING, &start);
 	if (r != 0)
@@ -162,7 +177,6 @@ static struct virtio_ops vsock_dev_virtio_ops = {
 
 static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
 {
-	u64 features;
 	int r;
 
 	vdev->vhost_fd = open("/dev/vhost-vsock", O_RDWR);
@@ -171,14 +185,6 @@ static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
 
 	virtio_vhost_init(kvm, vdev->vhost_fd);
 
-	r = ioctl(vdev->vhost_fd, VHOST_GET_FEATURES, &features);
-	if (r != 0)
-		die_perror("VHOST_GET_FEATURES failed");
-
-	r = ioctl(vdev->vhost_fd, VHOST_SET_FEATURES, &features);
-	if (r != 0)
-		die_perror("VHOST_SET_FEATURES failed");
-
 	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_GUEST_CID, &vdev->guest_cid);
 	if (r != 0)
 		die_perror("VHOST_VSOCK_SET_GUEST_CID failed");
-- 
2.40.1

