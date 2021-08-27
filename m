Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A3B3F9A38
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 15:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245243AbhH0Ndu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 09:33:50 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:23944 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245156AbhH0Ndt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 09:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630071182; x=1661607182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wh/CawUQ7CY8Snqcn644V6JnliWp+GzBGu4r/WJhUOI=;
  b=SS4xoNx3/xAI9fdeFSbRw81PUk+rE47COWNooECPyAMiGJ2ea52V8CXx
   zSl6E/dNXyCk8s/hPSalptJBKorLSrqSX6KPTR2sjLDDKV9eK3Lgm7tUb
   s2B1+JuINKUzCGBM5mnWyel0ZT0jf8ZIHZxL5xZdd/XZUQ3JbLaU+yYcJ
   U=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="137217030"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 27 Aug 2021 13:32:52 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id 0AEBCA17F3;
        Fri, 27 Aug 2021 13:32:50 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 13:32:44 +0000
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
Subject: [PATCH v2 1/7] nitro_enclaves: Enable Arm64 support
Date:   Fri, 27 Aug 2021 16:32:24 +0300
Message-ID: <20210827133230.29816-2-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210827133230.29816-1-andraprs@amazon.com>
References: <20210827133230.29816-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13d09UWA004.ant.amazon.com (10.43.160.158) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the kernel config to enable the Nitro Enclaves kernel driver for
Arm64 support.

Changelog

v1 -> v2

* No changes.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
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

