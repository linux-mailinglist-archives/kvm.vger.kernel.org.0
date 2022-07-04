Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4E75655F3
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiGDMwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbiGDMwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:52:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0056510FD1;
        Mon,  4 Jul 2022 05:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9eGLapvRuqvwGcfieh2L9vfSxu+838crDQ04UBysZLY=; b=UXB/yMavqCPD9a5dh0Svxrdcmw
        ZAYAvQu0XzvK89xsH8mLjgId21hsCQNxyaZ0p1bmUqCaztNsRlav2XJT9aoY2iOWloQ0dH/SoUh0f
        bl45URQyx7ssXhy2uIsP+MoH7YkuViV3yBhVg8Ev7ygphEjTCzO1cHbakmYoULf9J3YcohMjSciNw
        UWFgaeV2s8sh5lY5MkLU4VlhrT9cKR2zhZTfBYY3nqztZMoKYluB1rIhuC5ep6qV3k4yvFbGbEGX9
        /FtHb2mB5V0RMPoultEMaR5o+VsocOaTP4LMztEhTPLZ82hf3RbNXk4Qmw4iK7N9Hrksc28CRud2M
        d0MP3cnw==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LYd-008wTy-BS; Mon, 04 Jul 2022 12:52:07 +0000
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
Subject: [PATCH 07/14] vfio/mdev: unexport mdev_bus_type
Date:   Mon,  4 Jul 2022 14:51:37 +0200
Message-Id: <20220704125144.157288-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704125144.157288-1-hch@lst.de>
References: <20220704125144.157288-1-hch@lst.de>
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

