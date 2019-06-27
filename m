Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00A957A2D
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 05:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfF0DoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 23:44:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:21244 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbfF0DoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 23:44:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 20:44:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,422,1557212400"; 
   d="scan'208";a="360560977"
Received: from gvt.bj.intel.com ([10.238.158.187])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jun 2019 20:44:04 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v3 2/4] vfio: Introduce vGPU display irq type
Date:   Thu, 27 Jun 2019 11:38:00 +0800
Message-Id: <20190627033802.1663-3-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627033802.1663-1-tina.zhang@intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 include/uapi/linux/vfio.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 600784acc4ac..c3e9c821a5cb 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -465,6 +465,9 @@ struct vfio_irq_info_cap_type {
 	__u32 subtype;  /* type specific */
 };
 
+#define VFIO_IRQ_TYPE_GFX				(1)
+#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)
+
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
-- 
2.17.1

