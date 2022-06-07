Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6309954043E
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345337AbiFGRDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiFGRDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:16 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F9D5FF589
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F20D51516;
        Tue,  7 Jun 2022 10:03:15 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 861053F66F;
        Tue,  7 Jun 2022 10:03:14 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 02/24] virtio: Remove redundant test
Date:   Tue,  7 Jun 2022 18:02:17 +0100
Message-Id: <20220607170239.120084-3-jean-philippe.brucker@arm.com>
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

Don't test for VIRTIO__STATUS_STOP right after setting it.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virtio/core.c b/virtio/core.c
index 90a661d1..40532664 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -247,8 +247,7 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 		 * Reset virtqueues and stop all traffic now, so that the device
 		 * can safely reset the backend in notify_status().
 		 */
-		if (ext_status & VIRTIO__STATUS_STOP)
-			vdev->ops->reset(kvm, vdev);
+		vdev->ops->reset(kvm, vdev);
 	}
 
 	if (vdev->ops->notify_status)
-- 
2.36.1

