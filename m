Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB5221576
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgGOTsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:48:43 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:55554 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgGOTsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842522; x=1626378522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GUMPdj9z2XkMxCnmJXfT10kzSIIt0TepI75x0lQGJac=;
  b=YNbr03oFS3iI6y1UG9fSLG3i360bxS/YO4SmkL1vgSW20JBDBpjzhngd
   MO14AQUTYxWES7EyCMM1QDCXN4hMCx3MuE+lTAt3Yho8XzAbVCoD/GO6s
   wk0aVJkZhGDmx/69HRAlj9ojfeEHt+gXGrAnQftIzx4x+UV2n8oXUJgdK
   A=;
IronPort-SDR: 1Z09EYRH5zPocaO8Fl7ng/AD0NhagGdUcU9br/ysmHjE7vsKA1KlLTy8SnkmGL7PfOFb5zHXQ7
 C+n8q9qJlS1Q==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="58897608"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 15 Jul 2020 19:48:39 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 71629A268A;
        Wed, 15 Jul 2020 19:48:38 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:48:37 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:48:27 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
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
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Graf <graf@amazon.com>
Subject: [PATCH v5 15/18] nitro_enclaves: Add Makefile for the Nitro Enclaves driver
Date:   Wed, 15 Jul 2020 22:45:37 +0300
Message-ID: <20200715194540.45532-16-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200715194540.45532-1-andraprs@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D34UWA002.ant.amazon.com (10.43.160.245) To
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

