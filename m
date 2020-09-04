Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8B125E110
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 19:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgIDRka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 13:40:30 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:31235 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgIDRk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 13:40:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599241229; x=1630777229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lm0xp2nyoJ7iwxMrT0gLboEtI9wzxivQfh/SLbvjtB4=;
  b=EHCRkOUlyHmb+L43osaH5kjMMbCGkFvK4ISAaRhNSbia473/NC/qT8Wf
   H1o+JkZYSodz4Ld949uzoI4WSOFFM7IGD8gvPw1UCdjat6YDAkzGaH/bM
   +DGlH9x5tZbNFe7lMfVRSHS2gvQPVdVvnHxRM6LrpyGltHeuG6e4uJdkV
   A=;
X-IronPort-AV: E=Sophos;i="5.76,390,1592870400"; 
   d="scan'208";a="73692053"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 04 Sep 2020 17:40:24 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 167CFA1BD7;
        Fri,  4 Sep 2020 17:40:23 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 17:40:12 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v8 15/18] nitro_enclaves: Add Makefile for the Nitro Enclaves driver
Date:   Fri, 4 Sep 2020 20:37:15 +0300
Message-ID: <20200904173718.64857-16-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200904173718.64857-1-andraprs@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D06UWC001.ant.amazon.com (10.43.162.91) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
Changelog

v7 -> v8

* No changes.

v6 -> v7

* No changes.

v5 -> v6

* No changes.

v4 -> v5

* No changes.

v3 -> v4

* No changes.

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.

v1 -> v2

* Update path to Makefile to match the drivers/virt/nitro_enclaves
  directory.
---
 drivers/virt/Makefile                |  2 ++
 drivers/virt/nitro_enclaves/Makefile | 11 +++++++++++
 2 files changed, 13 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/Makefile

diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
index fd331247c27a..f28425ce4b39 100644
--- a/drivers/virt/Makefile
+++ b/drivers/virt/Makefile
@@ -5,3 +5,5 @@
 
 obj-$(CONFIG_FSL_HV_MANAGER)	+= fsl_hypervisor.o
 obj-y				+= vboxguest/
+
+obj-$(CONFIG_NITRO_ENCLAVES)	+= nitro_enclaves/
diff --git a/drivers/virt/nitro_enclaves/Makefile b/drivers/virt/nitro_enclaves/Makefile
new file mode 100644
index 000000000000..e9f4fcd1591e
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+
+# Enclave lifetime management support for Nitro Enclaves (NE).
+
+obj-$(CONFIG_NITRO_ENCLAVES) += nitro_enclaves.o
+
+nitro_enclaves-y := ne_pci_dev.o ne_misc_dev.o
+
+ccflags-y += -Wall
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

