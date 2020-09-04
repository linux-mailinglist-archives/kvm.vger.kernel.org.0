Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF89525E11D
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgIDRmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 13:42:07 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:3558 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgIDRkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 13:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599241210; x=1630777210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uCCUSEPsgK7LpKM7i1LnBPb3b+0b1zudShw68xsNyIE=;
  b=MwcQkMZ8qIqpRGO5pn7jnTm2WBXX3CbA6U0OJ1N4wd5x1ZDoKmW1T7ns
   B/NrIG1b1bbGE154vuXvqcrYF21tdC26XOeaaNk39bL0/YywbXqc3c3ND
   qmiOU6h9Bn/pyWiUgIzCpiwvaKGiTaiFu5u2C1+yag7LJRi3ECbzBwt4a
   g=;
X-IronPort-AV: E=Sophos;i="5.76,390,1592870400"; 
   d="scan'208";a="51939252"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Sep 2020 17:40:10 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id EC7BCA269E;
        Fri,  4 Sep 2020 17:40:07 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 17:39:57 +0000
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
Subject: [PATCH v8 14/18] nitro_enclaves: Add Kconfig for the Nitro Enclaves driver
Date:   Fri, 4 Sep 2020 20:37:14 +0300
Message-ID: <20200904173718.64857-15-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200904173718.64857-1-andraprs@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D08UWC002.ant.amazon.com (10.43.162.168) To
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

* Remove, for now, the dependency on ARM64 arch. x86 is currently
  supported, with Arm to come afterwards. The NE kernel driver can be
  built for aarch64 arch.

v5 -> v6

* No changes.

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
 drivers/virt/nitro_enclaves/Kconfig | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)
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
index 000000000000..8c9387a232df
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+
+# Amazon Nitro Enclaves (NE) support.
+# Nitro is a hypervisor that has been developed by Amazon.
+
+# TODO: Add dependency for ARM64 once NE is supported on Arm platforms. For now,
+# the NE kernel driver can be built for aarch64 arch.
+# depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
+
+config NITRO_ENCLAVES
+	tristate "Nitro Enclaves Support"
+	depends on X86 && HOTPLUG_CPU && PCI && SMP
+	help
+	  This driver consists of support for enclave lifetime management
+	  for Nitro Enclaves (NE).
+
+	  To compile this driver as a module, choose M here.
+	  The module will be called nitro_enclaves.
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

