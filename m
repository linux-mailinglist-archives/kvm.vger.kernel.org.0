Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88988575E34
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 11:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbiGOJDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 05:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiGOJDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 05:03:48 -0400
Received: from m12-17.163.com (m12-17.163.com [220.181.12.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD9EC12D3A;
        Fri, 15 Jul 2022 02:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=m4hKf
        BL4nqs53oqPJrYtedixI9QUO8tbMKID97bcLtQ=; b=nGSiZat0lo8s5aZbxB5l2
        2E4bJMot39JFljAszn5zg+aCCy5zWkGSpkB4F/F7BtrTAhBozqaAPpwzxl3hFh1y
        0yusMN6VMvNj2OQCs4W0v+JspmvjLnIJ3gLsEMmCxzZS5NbsOKfVRjwrZVd5ijPt
        CCzzON/hPoJgyY7VnqUhJs=
Received: from localhost.localdomain (unknown [111.48.58.12])
        by smtp13 (Coremail) with SMTP id EcCowAB3kp+fKdFiiizJNg--.6037S2;
        Fri, 15 Jul 2022 16:47:30 +0800 (CST)
From:   Jiangshan Yi <13667453960@163.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiangshan Yi <yijiangshan@kylinos.cn>,
        k2ci <kernel-bot@kylinos.cn>
Subject: [PATCH] KVM: Fix spelling typo in comment
Date:   Fri, 15 Jul 2022 16:47:12 +0800
Message-Id: <20220715084712.998150-1-13667453960@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowAB3kp+fKdFiiizJNg--.6037S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrury7Jr47ZFy5Jw4rGw47XFb_yoWDZrb_Z3
        Z3Gw4xWrWrGFs3Zr1vkFsIyF1Igw4UGFWjvF95Aryaqa98Aws8Gw4kZr1ava4UGrWI9Fs3
        Zas5W34rGw12gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0U5r7UUUUU==
X-Originating-IP: [111.48.58.12]
X-CM-SenderInfo: bprtllyxuvjmiwq6il2tof0z/1tbizQI-+1c7NglsvwAAsL
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_DIGITS,FROM_LOCAL_HEX,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jiangshan Yi <yijiangshan@kylinos.cn>

Fix spelling typo in comment.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 83cf7fd842e0..3fd6c198d222 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1311,7 +1311,7 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  *                 -EFAULT for an untranslatable guest physical address.
  *
  * This will attempt to refresh a gfn_to_pfn_cache. Note that a successful
- * returm from this function does not mean the page can be immediately
+ * return from this function does not mean the page can be immediately
  * accessed because it may have raced with an invalidation. Callers must
  * still lock and check the cache status, as this function does not return
  * with the lock still held to permit access.
-- 
2.25.1

