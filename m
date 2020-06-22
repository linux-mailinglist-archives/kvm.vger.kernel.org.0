Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFD82040FD
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgFVUGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:06:07 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63994 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgFVUGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856366; x=1624392366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mgtR0h3KW4s0auosIP1yMlre8AxMHdQ4uZuVmmjS7gI=;
  b=FA44C17EgFgUV2/vt5wFp07WDxmwdeT2UX32RMfOn3sRLfIJuIikT853
   MvDgjmWQ3Kn9TNngwD0BBt2vEEPejfzhPoAq1Iw2Ca3axXtwTaBhwyl+e
   FHFPBUJ4mHe/ZsGyihW7knzfFXTgSNPAC0j9QVc7QtkDxcyvcbnGtcy94
   w=;
IronPort-SDR: Bbr2lKW3je/x7GQODWiYM51cFlRGMXsHGoR2HrzN+wwECJattwKJMIdgsZZ1aaK/h8n0aznrOQ
 7alTxJ+28a4Q==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="46041541"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Jun 2020 20:06:05 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id 82EE4A1C78;
        Mon, 22 Jun 2020 20:06:04 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:06:04 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:05:55 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v4 14/18] nitro_enclaves: Add Kconfig for the Nitro Enclaves driver
Date:   Mon, 22 Jun 2020 23:03:25 +0300
Message-ID: <20200622200329.52996-15-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200622200329.52996-1-andraprs@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D45UWB004.ant.amazon.com (10.43.161.54) To
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
index 000000000000..69e41aa2222d
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
+	depends on HOTPLUG_CPU && PCI && SMP
+	help
+	  This driver consists of support for enclave lifetime management
+	  for Nitro Enclaves (NE).
+
+	  To compile this driver as a module, choose M here.
+	  The module will be called nitro_enclaves.
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

