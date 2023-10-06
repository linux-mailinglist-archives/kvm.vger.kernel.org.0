Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F517BBCF3
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjJFQlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjJFQl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FC6AD;
        Fri,  6 Oct 2023 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610485; x=1728146485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mm/55LXHi28066oVFk7+DbJoQjq6buhXunb9T8tkOO0=;
  b=VqxV2wKZWAabdgkBbwxtQkYMnkqieUik/GQuzoMZNQKHvz6MnZGq1ext
   BTMwBnGXGU6w5HJPK17GouMkhdG9WYiC7tsJjZSIG7SojDxiU9RBLFAU1
   EcnA5o2rYKdCvdNmG+D/6qj/oZv4/l6xe/Egj5BCRHxmRpYJjjVCigx9r
   DayjMY/xTN9BTLIfS9c3f2LqBbZp886xDydJWxYJLJoD3YSrwk6idc7w4
   wy4iShiimYV8Bi9s8eoscBuqOFm2EH+OB3X+m62dodsy3MHebBrt1lChb
   0bFWoOf/y0oqby2ocJvo5YLBJQCKBsCW/e/yu3dt8pDS1re8YJkBPGzc3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063161"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063161"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892845"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892845"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:23 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 03/18] vfio/pci: Use unsigned int instead of unsigned
Date:   Fri,  6 Oct 2023 09:40:58 -0700
Message-Id: <e69a5968e7a6d0344be9df2d0a650ea241426c4c.1696609476.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1696609476.git.reinette.chatre@intel.com>
References: <cover.1696609476.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

checkpatch.pl warns about usage of bare unsigned.

Change unsigned to unsigned int as a preparatory change
to avoid checkpatch.pl producing several warnings as
the work adding support for backends to VFIO interrupt
management progress.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 37 ++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b5b1c09bef25..c49588c8f4a3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -553,8 +553,9 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
  * IOCTL support
  */
 static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -584,8 +585,8 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
-				  unsigned index, unsigned start,
-				  unsigned count, uint32_t flags, void *data)
+				  unsigned int index, unsigned int start,
+				  unsigned int count, uint32_t flags, void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -604,8 +605,9 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
-				     unsigned index, unsigned start,
-				     unsigned count, uint32_t flags, void *data)
+				     unsigned int index, unsigned int start,
+				     unsigned int count, uint32_t flags,
+				     void *data)
 {
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
@@ -647,8 +649,9 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
@@ -755,8 +758,9 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 }
 
 static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (!pci_is_pcie(vdev->pdev))
 		return -ENOTTY;
@@ -769,8 +773,9 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
@@ -780,11 +785,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 }
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
-			    unsigned index, unsigned start, unsigned count,
-			    void *data)
+			    unsigned int index, unsigned int start,
+			    unsigned int count, void *data)
 {
-	int (*func)(struct vfio_pci_core_device *vdev, unsigned index,
-		    unsigned start, unsigned count, uint32_t flags,
+	int (*func)(struct vfio_pci_core_device *vdev, unsigned int index,
+		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
 
 	switch (index) {
-- 
2.34.1

