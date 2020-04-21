Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126C81B2F6A
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgDUSoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:44:06 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:58103 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbgDUSoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494644; x=1619030644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D9HcJgxc4qqZhJGXAx5AE73mSnX8REqGb4FqR6zgOqg=;
  b=iA7hzwtuhPX+wtdKgKX2stjaZlpH74+uKnHzk+LVkEoUh7pvNmf1338+
   5Slvw5qoCVSdbspyN3aEjipGvYklSNZdtiGQZjmMdQQDNxlYX0vVBJS8r
   xT3wK0fY1+c9CJahdW1fUupz5pABLk0RJ4BuHCx0Ci17zamYFsMU8G5tD
   Y=;
IronPort-SDR: E1OEtWh/TXxgF7Tm+5R6eNZav9pOKyWH2vFSqo7w69B4aYS+xleB6sm+8TgyeMqx5xKTYIUPES
 43PM+H/wt78A==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="26614658"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Apr 2020 18:44:03 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id BDDE7A1D33;
        Tue, 21 Apr 2020 18:44:01 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:44:01 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.217) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:52 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v1 13/15] nitro_enclaves: Add Kconfig for the Nitro Enclaves driver
Date:   Tue, 21 Apr 2020 21:41:48 +0300
Message-ID: <20200421184150.68011-14-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200421184150.68011-1-andraprs@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D17UWC002.ant.amazon.com (10.43.162.61) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/Kconfig        |  2 ++
 drivers/virt/amazon/Kconfig | 28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 drivers/virt/amazon/Kconfig

diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
index 363af2eaf2ba..06bb5cfa191d 100644
--- a/drivers/virt/Kconfig
+++ b/drivers/virt/Kconfig
@@ -32,4 +32,6 @@ config FSL_HV_MANAGER
 	     partition shuts down.
 
 source "drivers/virt/vboxguest/Kconfig"
+
+source "drivers/virt/amazon/Kconfig"
 endif
diff --git a/drivers/virt/amazon/Kconfig b/drivers/virt/amazon/Kconfig
new file mode 100644
index 000000000000..57fd0aa58803
--- /dev/null
+++ b/drivers/virt/amazon/Kconfig
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, see <http://www.gnu.org/licenses/>.
+
+# Amazon Nitro Enclaves (NE) support.
+# Nitro is a hypervisor that has been developed by Amazon.
+
+config NITRO_ENCLAVES
+	tristate "Nitro Enclaves Support"
+	depends on HOTPLUG_CPU
+	---help---
+	  This driver consists of support for enclave lifetime management
+	  for Nitro Enclaves (NE).
+
+	  To compile this driver as a module, choose M here.
+	  The module will be called nitro_enclaves.
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

