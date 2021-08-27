Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C2F3F9A3A
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 15:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245266AbhH0Ndw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 09:33:52 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:37455 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245247AbhH0Ndv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 09:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630071182; x=1661607182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DLGQ8FV4uLF3688qqMzcwYQpXuVX6E8NOg0dFy56eJI=;
  b=Isjmq/a/typfrikmGCtML6S4CsrOGKwpktTYzoLACMuUZg0PD/tMnDOa
   peRebMarvM1DtRy0K4vhv3DtWDhjG9EmPECeDvVuV/Tkt5ZghiTjj4uTV
   ZC8pai1BuLgjQjPSTwyTwVzWULgCN6o/m+rD3zmtDliIRTO4B1sfyK0OC
   k=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="953537455"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 27 Aug 2021 13:33:01 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 6314AA1785;
        Fri, 27 Aug 2021 13:33:01 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 13:32:54 +0000
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
Subject: [PATCH v2 3/7] nitro_enclaves: Add fix for the kernel-doc report
Date:   Fri, 27 Aug 2021 16:32:26 +0300
Message-ID: <20210827133230.29816-4-andraprs@amazon.com>
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

Fix the reported issue from the kernel-doc script, to have a comment per
identifier.

Changelog

v1 -> v2

* Update comments for send / receive buffer sizes for the NE PCI device.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 8bfbc66078185..6e9f28971a4e0 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
 
 #ifndef _NE_PCI_DEV_H_
@@ -84,9 +84,13 @@
  */
 
 /**
- * NE_SEND_DATA_SIZE / NE_RECV_DATA_SIZE - 240 bytes for send / recv buffer.
+ * NE_SEND_DATA_SIZE - Size of the send buffer, in bytes.
  */
 #define NE_SEND_DATA_SIZE	(240)
+
+/**
+ * NE_RECV_DATA_SIZE - Size of the receive buffer, in bytes.
+ */
 #define NE_RECV_DATA_SIZE	(240)
 
 /**
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

