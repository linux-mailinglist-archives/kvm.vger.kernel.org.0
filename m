Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC7255B5DA
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 05:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiF0Dvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 23:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiF0Dvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 23:51:32 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEFE2BF8
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 20:51:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c205so7781638pfc.7
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 20:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=//V+sQsx5m0lE8DAm/hXb4DRWcTqye6cfKtA6sobtMk=;
        b=EnSVdM4TX4CzA3j5CYOf8UlLayVoHTkLp/SPX0A5i+Qb+n6O9+vzyUB0Mx3/7i4Kvv
         wYll4uh/LiPqQwTd827weKLcI8Td/rXcm6O82MhKw2JMHsWQvDnoBlEKueqQZAtztUhr
         fNkTM6O3T7oKN7F8CGA0MeWv9E+b3A7u1ohH8LQ6U/0OH5cwrbfulcXkY//rNguUPgBS
         nM/q1pvbIfLpGDT7rdOfX9NXFFql2+f87DHmmFbGNLQ4HRrhyWnECMdRQVDEUxRqn8YZ
         Vcxn9I0UIU4WzirhRj3Uwlu2CkMlsfMLUr9wTJBQ11MDdSDbwB+TILyPDNQiGLoMV/jl
         k/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=//V+sQsx5m0lE8DAm/hXb4DRWcTqye6cfKtA6sobtMk=;
        b=ixfBjSFKu7qQoFJwbGPgQSUv/w5qe0rcPx13fp5BnzZ81rYGdq5Q9TTJ82u/0b8Aly
         w4poKB8eZENGnyJ5bxpRoebD5iosN5WDeQlFZs4qqhTf+FTGOQpzIgTSrtTubMCApcih
         06njxxaYrpRSgtP6qn+t6UqsS9EHd7bYknGbnersMe4xqPsKgjxB2uFIsBwQ50BW9wcp
         cpQjVE9gGLUcrmAdqQSg2t6C2xTnu8q7rvGmxhg5zlFzrLOvgjIX9oW7Xpuc7db/H2vy
         hHmN4wcjn2B5mHZu2b6O74Emq+8hUJHMfWJWMxEK7K1/T4+eNYqt3mtIoFWLmakC1imS
         VyPw==
X-Gm-Message-State: AJIora840/TRWi8ksXVQNsp8y1AphdE44RO/FP9VdRyAPSjzZXl0z2MI
        j5doalr+Y7ss+XzOJnAuklJNCQ==
X-Google-Smtp-Source: AGRyM1sIlGJRlv0um1SEqOGDMLegisCi7XNoasjcuhvdm35jpjEZURNM70fecH4cvzhvev8WHmGadA==
X-Received: by 2002:a63:7a49:0:b0:40c:ca38:aed7 with SMTP id j9-20020a637a49000000b0040cca38aed7mr11094038pgn.11.1656301890633;
        Sun, 26 Jun 2022 20:51:30 -0700 (PDT)
Received: from MacBook-Pro.local.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090a318900b001e88c4bb3dcsm8110404pjb.25.2022.06.26.20.51.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jun 2022 20:51:30 -0700 (PDT)
From:   lizhe.67@bytedance.com
To:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca
Cc:     lizhe.67@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com
Subject: [PATCH] vfio: remove useless judgement
Date:   Mon, 27 Jun 2022 11:51:09 +0800
Message-Id: <20220627035109.73745-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li Zhe <lizhe.67@bytedance.com>

In function vfio_dma_do_unmap(), we currently prevent process to unmap
vfio dma region whose mm_struct is different from the vfio_dma->task.
In our virtual machine scenario which is using kvm and qemu, this
judgement stops us from liveupgrading our qemu, which uses fork() &&
exec() to load the new binary but the new process cannot do the
VFIO_IOMMU_UNMAP_DMA action during vm exit because of this judgement.

This judgement is added in commit 8f0d5bb95f76 ("vfio iommu type1: Add
task structure to vfio_dma") for the security reason. But it seems that
no other task who has no family relationship with old and new process
can get the same vfio_dma struct here for the reason of resource
isolation. So this patch delete it.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Jason Gunthorpe <jgg@ziepe.ca>
---
 drivers/vfio/vfio_iommu_type1.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c13b9290e357..a8ff00dad834 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1377,12 +1377,6 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 		if (!iommu->v2 && iova > dma->iova)
 			break;
-		/*
-		 * Task with same address space who mapped this iova range is
-		 * allowed to unmap the iova range.
-		 */
-		if (dma->task->mm != current->mm)
-			break;
 
 		if (invalidate_vaddr) {
 			if (dma->vaddr_invalid) {
-- 
2.20.1

