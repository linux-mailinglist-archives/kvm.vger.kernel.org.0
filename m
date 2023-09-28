Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7DD7B1C02
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 14:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjI1MSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 08:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjI1MSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 08:18:41 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB03180
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 05:18:36 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:e207:8adb:af22:7f1e])
        by albert.telenet-ops.be with bizsmtp
        id rQJa2A0083w8i7m06QJa0y; Thu, 28 Sep 2023 14:18:34 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1qlpy5-004mRe-LC;
        Thu, 28 Sep 2023 14:18:34 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1qlpyU-001ODc-3r;
        Thu, 28 Sep 2023 14:18:34 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] vhost-scsi: Spelling s/preceeding/preceding/g
Date:   Thu, 28 Sep 2023 14:18:33 +0200
Message-Id: <b57b882675809f1f9dacbf42cf6b920b2bea9cba.1695903476.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a misspelling of "preceding".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index abef0619c7901af0..2d689181bafef241 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1158,7 +1158,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			/*
 			 * Set prot_iter to data_iter and truncate it to
 			 * prot_bytes, and advance data_iter past any
-			 * preceeding prot_bytes that may be present.
+			 * preceding prot_bytes that may be present.
 			 *
 			 * Also fix up the exp_data_len to reflect only the
 			 * actual data payload length.
-- 
2.34.1

