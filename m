Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEAA3F9BF0
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 17:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245470AbhH0Pus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 11:50:48 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:13434 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244511AbhH0Pur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 11:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630079399; x=1661615399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GL/qxUBA8uZx50tfYHTUj1+Hmi3Ct9VjpiAt5lrDrOQ=;
  b=LURzJO82FmEKAfGZcqP4Y+X4p8IjZuC2VLRVgk+A1+15vtR0qCQZXeh3
   08sgofdluMq3QXD1CYf3k8DZnqK4W4VUMFqx15Yxb3taYbmE/6BO596Ti
   bF6KJ/n9UkLdbSctlCLyAbfOx8IMQqjXaT1YwVXpPAbWvXIr6YyEjLzDR
   o=;
X-IronPort-AV: E=Sophos;i="5.84,357,1620691200"; 
   d="scan'208";a="132769089"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 27 Aug 2021 15:49:55 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id B9D2BA2C6C;
        Fri, 27 Aug 2021 15:49:53 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 15:49:47 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Alexandru Vasile" <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v3 1/7] nitro_enclaves: Enable Arm64 support
Date:   Fri, 27 Aug 2021 18:49:24 +0300
Message-ID: <20210827154930.40608-2-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210827154930.40608-1-andraprs@amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.52]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the kernel config to enable the Nitro Enclaves kernel driver for
Arm64 support.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
---
Changelog

v1 -> v2

* No changes.

v2 -> v3

* Move changelog after the "---" line.
---
 drivers/virt/nitro_enclaves/Kconfig | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enclaves/Kconfig
index 8c9387a232df8..f53740b941c0f 100644
--- a/drivers/virt/nitro_enclaves/Kconfig
+++ b/drivers/virt/nitro_enclaves/Kconfig
@@ -1,17 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+# Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 
 # Amazon Nitro Enclaves (NE) support.
 # Nitro is a hypervisor that has been developed by Amazon.
 
-# TODO: Add dependency for ARM64 once NE is supported on Arm platforms. For now,
-# the NE kernel driver can be built for aarch64 arch.
-# depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
-
 config NITRO_ENCLAVES
 	tristate "Nitro Enclaves Support"
-	depends on X86 && HOTPLUG_CPU && PCI && SMP
+	depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
 	help
 	  This driver consists of support for enclave lifetime management
 	  for Nitro Enclaves (NE).
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

