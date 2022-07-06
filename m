Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC4756803C
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 09:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiGFHmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 03:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiGFHmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 03:42:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB85D23149;
        Wed,  6 Jul 2022 00:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9eGLapvRuqvwGcfieh2L9vfSxu+838crDQ04UBysZLY=; b=3unRmj3Rt4DldFQtreNG3UraP/
        geawchtjNmhKOJyQrso03mq+ld6Xuhb/SDHkopJXB329HmHXHGtsyPHpo7gWca8nkhO05Lx/KBHy3
        tqwVebESFwUdL3euCzCIXoaOc3nrpfvM/awE6/ou5wn4KiENe4BX6dPSVj4C0/6WkF1j5PsyXhVnl
        lwo8AjsN9+CgfEeS4uPkC+rrlDHJ8GYaSEialw3pADMfpOX7ZelN+mzb0enEXDw7OsQQg6G63cst5
        Vk2aMHaNVLNO2SEWX/Rz3Ni0MrbgxRUvbFJWeXroomy25bLUV67Temlf6RKPajTSmjTACWK4R+lxi
        kFvsJgBg==;
Received: from [2001:4bb8:189:3c4a:34cd:2d1d:8766:aad] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8zgK-0079pv-Dl; Wed, 06 Jul 2022 07:42:45 +0000
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
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 07/15] vfio/mdev: unexport mdev_bus_type
Date:   Wed,  6 Jul 2022 09:42:11 +0200
Message-Id: <20220706074219.3614-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706074219.3614-1-hch@lst.de>
References: <20220706074219.3614-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mdev_bus_type is only used in mdev.ko now, so unexport it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 drivers/vfio/mdev/mdev_driver.c  | 1 -
 drivers/vfio/mdev/mdev_private.h | 1 +
 include/linux/mdev.h             | 2 --
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 1da1ecf76a0d5..5b3c94f4fb13d 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -46,7 +46,6 @@ struct bus_type mdev_bus_type = {
 	.remove		= mdev_remove,
 	.match		= mdev_match,
 };
-EXPORT_SYMBOL_GPL(mdev_bus_type);
 
 /**
  * mdev_register_driver - register a new MDEV driver
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index ba1b2dbddc0bc..af457b27f6074 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -13,6 +13,7 @@
 int  mdev_bus_register(void);
 void mdev_bus_unregister(void);
 
+extern struct bus_type mdev_bus_type;
 extern const struct attribute_group *mdev_device_groups[];
 
 #define to_mdev_type_attr(_attr)	\
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 411b655c36ab2..2ca85b6072b9e 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -92,8 +92,6 @@ static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
 	return &mdev->uuid;
 }
 
-extern struct bus_type mdev_bus_type;
-
 int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
 		struct mdev_driver *mdev_driver, struct mdev_type **types,
 		unsigned int nr_types);
-- 
2.30.2

