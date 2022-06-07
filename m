Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4EE540444
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345373AbiFGRDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345357AbiFGRD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C8C5FF594
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3645814BF;
        Tue,  7 Jun 2022 10:03:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BCE8B3F66F;
        Tue,  7 Jun 2022 10:03:24 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 08/24] virtio/console: Remove unused callback
Date:   Tue,  7 Jun 2022 18:02:23 +0100
Message-Id: <20220607170239.120084-9-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unused set_status() callback

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/balloon.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/virtio/balloon.c b/virtio/balloon.c
index 753171d1..f06955d2 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -214,10 +214,6 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	bdev->features = features;
 }
 
-static void notify_status(struct kvm *kvm, void *dev, u32 status)
-{
-}
-
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct bln_dev *bdev = dev;
@@ -272,7 +268,6 @@ struct virtio_ops bln_dev_virtio_ops = {
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
-	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
-- 
2.36.1

