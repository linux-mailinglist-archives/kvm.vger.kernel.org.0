Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454653F9A3E
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 15:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245285AbhH0NeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 09:34:08 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:64878 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245203AbhH0NeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 09:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630071198; x=1661607198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sBzr2CeY7ACFK2hNXkpZR3uy9YkRYqZ77qIzRjvkoEU=;
  b=YOBoYZYLCBOuzl5HJIxrfLejt7Z5tVmweVm4rXLBHRb3Ix2KxsUdRXlP
   eJho+ox6+8C25+KvPlqkR7rhUdc07XVjv5cLvK2ii0w4/D8hLLZxEnYNi
   iuAWxene0lXGjuikpPPdrlU6ok8TKGV1bfNQmCzIHj5pfrhwS9FVsLP0i
   Q=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="132732140"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 27 Aug 2021 13:33:09 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id A9958A1DE3;
        Fri, 27 Aug 2021 13:33:08 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 13:33:00 +0000
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
Subject: [PATCH v2 4/7] nitro_enclaves: Update copyright statement to include 2021
Date:   Fri, 27 Aug 2021 16:32:27 +0300
Message-ID: <20210827133230.29816-5-andraprs@amazon.com>
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

Update the copyright statement to include 2021, as a change has been
made over this year.

Check commit d874742f6a73 ("nitro_enclaves: Set Bus Master for the NE
PCI device") for the codebase update from this file (ne_pci_dev.c).

Changelog

v1 -> v2

* No codebase changes, it was split from the patch 3 in the v1 of the
patch series.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 143207e9b9698..40b49ec8e30b1 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
 
 /**
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

