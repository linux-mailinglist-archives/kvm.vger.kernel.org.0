Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B920722B8E0
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 23:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgGWVr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 17:47:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:44370 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbgGWVr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 17:47:28 -0400
IronPort-SDR: DsfrAZaSCnT0702YBjfVULOaBKEQawkyO7hUY5NzPQyA3Dw1juj1YZOIsPY4ofuaJ6R+yvdaPO
 lcU679I4xQtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="148119979"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="148119979"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 14:47:28 -0700
IronPort-SDR: 9F0MLbkevq401E5W0qh64MuYhgXWKZRIo1g8Fe7vp4XBwBaKK0EnqRSSWoJ68qj1Zt45eR1Vtp
 cuE89jkDGqLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="311183956"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jul 2020 14:47:25 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        fiona.trahe@intel.com, qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 1/5] PCI: Add Intel QuickAssist device IDs
Date:   Thu, 23 Jul 2020 22:47:01 +0100
Message-Id: <20200723214705.5399-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723214705.5399-1-giovanni.cabiddu@intel.com>
References: <20200723214705.5399-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add device IDs for the following Intel QuickAssist devices: DH895XCC,
C3XXX and C62X.

The defines in this patch are going to be referenced in two independent
drivers, qat and vfio-pci.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 include/linux/pci_ids.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0ad57693f392..f3166b1425ca 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2659,6 +2659,8 @@
 #define PCI_DEVICE_ID_INTEL_80332_1	0x0332
 #define PCI_DEVICE_ID_INTEL_80333_0	0x0370
 #define PCI_DEVICE_ID_INTEL_80333_1	0x0372
+#define PCI_DEVICE_ID_INTEL_QAT_DH895XCC	0x0435
+#define PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF	0x0443
 #define PCI_DEVICE_ID_INTEL_82375	0x0482
 #define PCI_DEVICE_ID_INTEL_82424	0x0483
 #define PCI_DEVICE_ID_INTEL_82378	0x0484
@@ -2708,6 +2710,8 @@
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_NHI     0x1577
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_BRIDGE  0x1578
 #define PCI_DEVICE_ID_INTEL_80960_RP	0x1960
+#define PCI_DEVICE_ID_INTEL_QAT_C3XXX	0x19e2
+#define PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF	0x19e3
 #define PCI_DEVICE_ID_INTEL_82840_HB	0x1a21
 #define PCI_DEVICE_ID_INTEL_82845_HB	0x1a30
 #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
@@ -2924,6 +2928,8 @@
 #define PCI_DEVICE_ID_INTEL_IOAT_JSF7	0x3717
 #define PCI_DEVICE_ID_INTEL_IOAT_JSF8	0x3718
 #define PCI_DEVICE_ID_INTEL_IOAT_JSF9	0x3719
+#define PCI_DEVICE_ID_INTEL_QAT_C62X	0x37c8
+#define PCI_DEVICE_ID_INTEL_QAT_C62X_VF	0x37c9
 #define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
 #define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
 #define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
-- 
2.26.2

