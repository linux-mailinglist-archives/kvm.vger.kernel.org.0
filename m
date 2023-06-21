Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B034737FDA
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 13:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjFUJlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 05:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjFUJkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 05:40:35 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884551BC3
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 02:38:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VlfaQYY_1687340316;
Received: from localhost.localdomain(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VlfaQYY_1687340316)
          by smtp.aliyun-inc.com;
          Wed, 21 Jun 2023 17:38:44 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH] vhost: Make parameter name match of vhost_get_vq_desc()
Date:   Wed, 21 Jun 2023 17:38:35 +0800
Message-Id: <20230621093835.36878-1-xianting.tian@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The parameter name in the function declaration and definition
should be the same.

drivers/vhost/vhost.h,
int vhost_get_vq_desc(..., unsigned int iov_count,...);

drivers/vhost/vhost.c,
int vhost_get_vq_desc(..., unsigned int iov_size,...)

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 drivers/vhost/vhost.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index fc900be504b3..37ce869f8a5c 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -193,7 +193,7 @@ bool vhost_log_access_ok(struct vhost_dev *);
 void vhost_clear_msg(struct vhost_dev *dev);
 
 int vhost_get_vq_desc(struct vhost_virtqueue *,
-		      struct iovec iov[], unsigned int iov_count,
+		      struct iovec iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
-- 
2.17.1

