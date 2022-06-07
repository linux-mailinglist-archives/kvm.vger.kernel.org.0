Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B054044B
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345393AbiFGRDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345379AbiFGRDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 996ABFF590
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:35 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4706143D;
        Tue,  7 Jun 2022 10:03:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 75C423F66F;
        Tue,  7 Jun 2022 10:03:34 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 14/24] virtio/console: Add VIRTIO_F_ANY_LAYOUT feature
Date:   Tue,  7 Jun 2022 18:02:29 +0100
Message-Id: <20220607170239.120084-15-jean-philippe.brucker@arm.com>
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

Our virtio-console implementation already supports ANY_LAYOUT, because
buffers are accessed with scatter-gather operations. Advertise the
VIRTIO_F_ANY_LAYOUT feature.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/console.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/console.c b/virtio/console.c
index 610995de..c42c8b9f 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -122,7 +122,7 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
-	return 0;
+	return 1 << VIRTIO_F_ANY_LAYOUT;
 }
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
-- 
2.36.1

