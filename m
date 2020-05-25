Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F70B1E17C0
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 00:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389322AbgEYWQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 18:16:23 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:56075 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389318AbgEYWQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 18:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590444982; x=1621980982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YJ2slGj03Pw5ollWzd2NosTIBtv7p8phHu4CCCaYS80=;
  b=HuHsUEU6H5enY0cKFonqNMF58DP8Wl0pwzEulQT9Zp+fhQEPbO+cg/yo
   Robhs3dge9EZzQf7XboyX73cfAg5SE11+NRp6+I4tEcwW4QI+UdVAQd5Y
   44vhlOioEYiIo691xfRYMC6cbbse97B3KWAGblOv1cYb7T7nLFdOaxm/k
   A=;
IronPort-SDR: YRkpqOEjcnIFEEcVDxOdSzzQvCjRSKI85EAiWWKn2NTXPTUJgHa1UcVVObqcXMdt1NMWH0hJbN
 O4+lhOqwUAPQ==
X-IronPort-AV: E=Sophos;i="5.73,435,1583193600"; 
   d="scan'208";a="45841837"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 May 2020 22:16:21 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 6FB4CA1E07;
        Mon, 25 May 2020 22:16:19 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:16:18 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:16:10 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v3 15/18] nitro_enclaves: Add Makefile for the Nitro Enclaves driver
Date:   Tue, 26 May 2020 01:13:31 +0300
Message-ID: <20200525221334.62966-16-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200525221334.62966-1-andraprs@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D25UWC004.ant.amazon.com (10.43.162.201) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is already in
place.

v1 -> v2

* Update path to Makefile to match the drivers/virt/nitro_enclaves directory.
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

