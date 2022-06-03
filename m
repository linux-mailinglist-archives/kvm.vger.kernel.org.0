Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3A253C4F6
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241517AbiFCGdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241498AbiFCGdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:33:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A6C2BFB;
        Thu,  2 Jun 2022 23:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vl3AAzeMI7BX2u/O8kPSzZJJV5eD7Q+Y9ihN+xpp9yg=; b=CsHm8to1EmyLTpAfY85bRBD2Fs
        1aW45wyOFtxDv3FRvHCuMQqIwQzpkB0OMVIa6IA8gt3SWx9s6iLQvCqKijS8GSglca6BboBYVLkaR
        OHwXTpn3u2cMEhiC4KgccEWxL0nCRZbhUihE3OndKfZMDdrDsDRv87gpfuMo/ksIuoo9zfBRGNi8b
        SnxD5AgNIvRiRpeTQOCcUXVGQUrD0wQGvVLmiqVJ8iOLKBj+NxBQHY45ut8kDM3gi0gPhuANrERVb
        mQA9at7o2Y8kdKmlijG8KmGJjI7j+g7jxf520CCfjCKlyzFk5l3nBAH5MjZpiyLWgvCio/3AZOk/k
        fp6p+uAQ==;
Received: from [2001:4bb8:185:a81e:b29a:8b56:eb9a:ca3b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nx0sV-00614B-91; Fri, 03 Jun 2022 06:33:47 +0000
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
Subject: [PATCH 6/8] vfio/mdev: unexport mdev_bus_type
Date:   Fri,  3 Jun 2022 08:33:26 +0200
Message-Id: <20220603063328.3715-7-hch@lst.de>
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

mdev_bus_type is only used in mdev.ko now, so unexport it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/mdev/mdev_driver.c  | 1 -
 drivers/vfio/mdev/mdev_private.h | 1 +
 include/linux/mdev.h             | 2 --
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 9c2af59809e2e..dde6adf23b1db 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -47,7 +47,6 @@ struct bus_type mdev_bus_type = {
 	.remove		= mdev_remove,
 	.match		= mdev_match,
 };
-EXPORT_SYMBOL_GPL(mdev_bus_type);
 
 /**
  * mdev_register_driver - register a new MDEV driver
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 277819f1ebed8..3ecd6ae1dfa7c 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -13,6 +13,7 @@
 int  mdev_bus_register(void);
 void mdev_bus_unregister(void);
 
+extern struct bus_type mdev_bus_type;
 extern const struct attribute_group *mdev_device_groups[];
 
 #define to_mdev_type_attr(_attr)	\
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 5811b5a52a511..f92b4d8edf0e8 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -88,8 +88,6 @@ static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
 	return &mdev->uuid;
 }
 
-extern struct bus_type mdev_bus_type;
-
 int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
 		struct mdev_driver *mdev_driver);
 void mdev_unregister_parent(struct mdev_parent *parent);
-- 
2.30.2

