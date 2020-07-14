Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D4521E845
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGNGgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:36:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:33942 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgGNGgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:36:45 -0400
IronPort-SDR: 4nFB9RidGD7Uz0m6cDLSUCduwtpBoHxGYDsvrCeH0A9mbOvdAFLpvY67nMyb71JlOTZQT/2iX2
 zWN/D9g1hG1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="213632484"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="213632484"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 23:36:44 -0700
IronPort-SDR: I4HnTb5tyE8mAIwm6iR2na6s+YT52WCITvWOOvWkwf3Ls+3pP/oQYcrFJPMLlvi2DgiEpTlbw6
 XmGqWL7XUtJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="299435533"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2020 23:36:41 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 1/5] PCI: Add Intel QuickAssist device IDs
Date:   Tue, 14 Jul 2020 07:36:06 +0100
Message-Id: <20200714063610.849858-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
References: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
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

