Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BD7557920
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 13:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiFWL4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 07:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiFWL4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 07:56:18 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5504D266
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 04:56:17 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id u37so18884867pfg.3
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 04:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ia9mS6RsT06aC9HBHOhsumcbFMbuVRbfJziDZXxgacI=;
        b=DKdYjYsHZTEOjCXcx1YfCeYZpbHVoUfdfdEJpQrkQBFuWtAnhkAYj5tFspl+QXukNn
         wRzkYrpmoHW7GJRxgEq1cYf23mgKrLxH/zfYpICDyoGk7RRGTIob5qwXGNQULab3xeWQ
         IuHIX4pV9zaYctVoB5QPGI4+iuvPH0GQgRKm8lkwLu7I8DRFAWvzitQHz0r5O1AWHA/y
         ljBq3wV5+R3LLCL4diXsBhm4YDNRjEFY7qp1hB+6eW5X0UBnfiNeLnSnIPkcBy40qIO2
         GlCt3T6/yUhEhxaLRWfr8psfkCG71qz9OLM5zp8jmhTyW/bWtdT+LYzp5dgF57/YDkSA
         A0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ia9mS6RsT06aC9HBHOhsumcbFMbuVRbfJziDZXxgacI=;
        b=CBtwOB2zL4lXlHUztpuquRpT38X0ySv+XGtri8jZdlc6xydsZknRlo2zpmgNeyh/nX
         50a1AdoIQX8MW2MG+GivTWtrbFnrtboLRLWpWMqDaqJ4qim3maaIaspk7vBnSj0Wk1jt
         3gSKhcb5g7POSNcaP9C/svn/m9mer5dYQ+AM/qzsvmCXB0giLIS43dF0plCD1ouI1KeO
         4isz3gVfsTsM/FUIjKs/V4sua9D1SwPYiD9IsCwQnFPmafBQVbushxx+5HUxPKsp05nC
         KFFGf2XPxV6GVUvuzVF0VtRBy5xuuYj+g9RAtnxjGTphVD38Wk1Z8VMP82dBhNgrIKqA
         j/BA==
X-Gm-Message-State: AJIora+2DoJXZmolKroa3ovr51S9v20VOWUgI6BIRBAUGBc4JdDnMBW6
        ZdgbhSMfc+Kx57wQYFivKZD//g==
X-Google-Smtp-Source: AGRyM1v0FKk4Ak+tf0g0uB8p8EHLIsJouVzjkc9/WAlwwtkCaxang1Yds7HBuMO2pIZ/YZyRimMAzg==
X-Received: by 2002:a05:6a00:e12:b0:525:21db:1ad with SMTP id bq18-20020a056a000e1200b0052521db01admr21803406pfb.68.1655985376595;
        Thu, 23 Jun 2022 04:56:16 -0700 (PDT)
Received: from MacBook-Pro.local.net ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id z27-20020aa79e5b000000b0052553215444sm1812735pfq.101.2022.06.23.04.56.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jun 2022 04:56:16 -0700 (PDT)
From:   lizhe.67@bytedance.com
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com, lizhe.67@bytedance.com
Subject: [RFC] vfio: remove useless judgement
Date:   Thu, 23 Jun 2022 19:56:03 +0800
Message-Id: <20220623115603.22288-1-lizhe.67@bytedance.com>
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

