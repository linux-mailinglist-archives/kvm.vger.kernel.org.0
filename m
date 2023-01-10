Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA4D663C69
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 10:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjAJJLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 04:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbjAJJKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 04:10:32 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3D964C9;
        Tue, 10 Jan 2023 01:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Lj42chFASi82/LX1TdBGvCiiDRzVl2Xg5BDLAFDy/9M=; b=i5D0hDTwYnj79ZamDZuwSI51vc
        BlSm+Y1842x4Uf+7uEtpeFfSLNPRUcCP+3HAISnEzQ78ruik928I7s8VD1nGoIbfKXR5jRr2NIfTs
        gDzzAI5lNhPLyWW1EJLqF+uQSfjEiOSW/cX4gqlJyBx4LXz4roijEI+FtJA+tEu0tvJprVXe/O0rG
        xPw50vDWgvIEMMi4zHbsP9QpTg0HUXtNqUtHAlqSozq2vTOOKXTS+qAYgrVdNvHBqki5kgmpMZ56C
        Nm9WTXhLXPjxknpjC+EnwC9pRvw3I2pGMfMBUJ9vZD3uYM/6ih1NSfqYbVpAElwrr2RtcRwUeg9lt
        V9mQJnhA==;
Received: from [2001:4bb8:181:656b:cb3a:c552:3fcc:12a6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFAe6-0060aT-Uh; Tue, 10 Jan 2023 09:10:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: [PATCH 1/4] vfio-mdev: allow building the samples into the kernel
Date:   Tue, 10 Jan 2023 10:10:06 +0100
Message-Id: <20230110091009.474427-2-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230110091009.474427-1-hch@lst.de>
References: <20230110091009.474427-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is nothing in the vfio-mdev sample drivers that requires building
them as modules, so remove that restriction.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 samples/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 0d81c00289ee36..f1b8d4ff123036 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -184,23 +184,23 @@ config SAMPLE_UHID
 	  Build UHID sample program.
 
 config SAMPLE_VFIO_MDEV_MTTY
-	tristate "Build VFIO mtty example mediated device sample code -- loadable modules only"
-	depends on VFIO_MDEV && m
+	tristate "Build VFIO mtty example mediated device sample code"
+	depends on VFIO_MDEV
 	help
 	  Build a virtual tty sample driver for use as a VFIO
 	  mediated device
 
 config SAMPLE_VFIO_MDEV_MDPY
-	tristate "Build VFIO mdpy example mediated device sample code -- loadable modules only"
-	depends on VFIO_MDEV && m
+	tristate "Build VFIO mdpy example mediated device sample code"
+	depends on VFIO_MDEV
 	help
 	  Build a virtual display sample driver for use as a VFIO
 	  mediated device.  It is a simple framebuffer and supports
 	  the region display interface (VFIO_GFX_PLANE_TYPE_REGION).
 
 config SAMPLE_VFIO_MDEV_MDPY_FB
-	tristate "Build VFIO mdpy example guest fbdev driver -- loadable module only"
-	depends on FB && m
+	tristate "Build VFIO mdpy example guest fbdev driver"
+	depends on FB
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -208,8 +208,8 @@ config SAMPLE_VFIO_MDEV_MDPY_FB
 	  Guest fbdev driver for the virtual display sample driver.
 
 config SAMPLE_VFIO_MDEV_MBOCHS
-	tristate "Build VFIO mdpy example mediated device sample code -- loadable modules only"
-	depends on VFIO_MDEV && m
+	tristate "Build VFIO mdpy example mediated device sample code"
+	depends on VFIO_MDEV
 	select DMA_SHARED_BUFFER
 	help
 	  Build a virtual display sample driver for use as a VFIO
-- 
2.35.1

