Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D037C221572
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgGOTs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:48:28 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:11644 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgGOTs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842507; x=1626378507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Fc0g80u+lA5TS2UL2mjbZSqzJudFFmvt6QV3Pf1/D8=;
  b=Heyh4SyMeb0dCpe7Am0LBKpXVQHigLT+2OMF4OQSOWXMRTVdRsbPv+7l
   9xKiM4zXKVV2PNkpMRM4LrgOhLYnsHG2HlXlYh4SunZK5KAMzaRZmfFpt
   DcMheDKxpSez2QbT15qUoLELU4cZDL9/2NL5LmndBMbNjVpCJ0QhaD+Bo
   E=;
IronPort-SDR: vVPkFUb8iPGjBzQ+saQR3I1P6J0lqUyo4U48Hm1GRH9U9lWlbYlpiXOdsRGfrwmfRHzQ9xQ31v
 U5WRl5dHZjOg==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="42126687"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 15 Jul 2020 19:48:25 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id E56F1C0013;
        Wed, 15 Jul 2020 19:48:23 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:48:22 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.26) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:48:13 +0000
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
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v5 14/18] nitro_enclaves: Add Kconfig for the Nitro Enclaves driver
Date:   Wed, 15 Jul 2020 22:45:36 +0300
Message-ID: <20200715194540.45532-15-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200715194540.45532-1-andraprs@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v4 -> v5

* Add arch dependency for Arm / x86.

v3 -> v4

* Add PCI and SMP dependencies.

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.

v1 -> v2

* Update path to Kconfig to match the drivers/virt/nitro_enclaves
  directory.
* Update help in Kconfig.
---
 drivers/virt/Kconfig                |  2 ++
 drivers/virt/nitro_enclaves/Kconfig | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/Kconfig

diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
index cbc1f25c79ab..80c5f9c16ec1 100644
--- a/drivers/virt/Kconfig
+++ b/drivers/virt/Kconfig
@@ -32,4 +32,6 @@ config FSL_HV_MANAGER
 	     partition shuts down.
 
 source "drivers/virt/vboxguest/Kconfig"
+
+source "drivers/virt/nitro_enclaves/Kconfig"
 endif
diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enclaves/Kconfig
new file mode 100644
index 000000000000..78eb7293d2f7
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+
+# Amazon Nitro Enclaves (NE) support.
+# Nitro is a hypervisor that has been developed by Amazon.
+
+config NITRO_ENCLAVES
+	tristate "Nitro Enclaves Support"
+	depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
+	help
+	  This driver consists of support for enclave lifetime management
+	  for Nitro Enclaves (NE).
+
+	  To compile this driver as a module, choose M here.
+	  The module will be called nitro_enclaves.
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

