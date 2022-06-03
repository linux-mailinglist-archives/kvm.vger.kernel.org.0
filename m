Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8191D53C4F8
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241497AbiFCGdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241484AbiFCGdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:33:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394012BFB;
        Thu,  2 Jun 2022 23:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZkozTzAKPEHeRhQeRr7+xxJPoFvm4mWSXSylHIvm9tc=; b=RkBbkQptfuCODrqIbUTe0CVdvi
        Q2F/ReiVrC8APZ9oHIWgeqoNL7p0Jr8k8/gLm+KqsihXxScNrD0qHaEjqZr5mgZ8GPX4VVXfJJ+4f
        qIYuLHRSh3jHgxX5Ipb8Vkcqjy/Wo0p9ALdtmFUraAcJFB/lguJGDgWUoDBmsirVmzvcruSjmgvto
        lHbYKbIiz+aeDKrmcsdhrEm0T6NzxQfJaI+wELLy7TdJ6BS2j/AaMPX3VlignQNX5XAfXxbeEgrVL
        /wKktbQUWEBCNf/+SZKLkCMk2s//F3xHOImDI9ralSV61lvWnepXVxcGmGjDA3c7bGpy6S+9gUOeg
        9yhf7axw==;
Received: from [2001:4bb8:185:a81e:b29a:8b56:eb9a:ca3b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nx0sH-00610e-1b; Fri, 03 Jun 2022 06:33:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: [PATCH 1/8] vfio/mdev: make mdev.h standalone includable
Date:   Fri,  3 Jun 2022 08:33:21 +0200
Message-Id: <20220603063328.3715-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220603063328.3715-1-hch@lst.de>
References: <20220603063328.3715-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include <linux/device.h> and <linux/uuid.h> so that users of this headers
don't need to do that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mdev.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index bb539794f54a8..555c1d015b5f0 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -10,6 +10,9 @@
 #ifndef MDEV_H
 #define MDEV_H
 
+#include <linux/device.h>
+#include <linux/uuid.h>
+
 struct mdev_type;
 
 struct mdev_device {
-- 
2.30.2

