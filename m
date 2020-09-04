Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1674125E118
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgIDRlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 13:41:22 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:37493 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgIDRk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 13:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599241257; x=1630777257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3WH1JXdCdbpYmzmEhgenY7vg+t0Pb4yn9+A2i1nvGdc=;
  b=MV0bTC2XzubinStFWBjlVJF8LC0xaung2G1F1iv9VywCOeO2P3J1zpks
   w3y8+4/kGrByzn/Ifm44b57TTI41X2Qdnk7jRA0XC+PkEeemPeclD46r0
   TYGYAlhDZkVxwJDpQyLBZM8fiya2wdBA/fxo7d3SMQEww+yrqxrF0/nSh
   8=;
X-IronPort-AV: E=Sophos;i="5.76,390,1592870400"; 
   d="scan'208";a="72480161"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Sep 2020 17:40:56 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 37C00289B9C;
        Fri,  4 Sep 2020 17:40:52 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 17:40:42 +0000
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
Subject: [PATCH v8 18/18] MAINTAINERS: Add entry for the Nitro Enclaves driver
Date:   Fri, 4 Sep 2020 20:37:18 +0300
Message-ID: <20200904173718.64857-19-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200904173718.64857-1-andraprs@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D06UWC001.ant.amazon.com (10.43.162.91) To
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

* No changes.

v5 -> v6

* No changes.

v4 -> v5

* No changes.

v3 -> v4

* No changes.

v2 -> v3

* Update file entries to be in alphabetical order.

v1 -> v2

* No changes.
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4647c84c987..73a9b4e9b04b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12269,6 +12269,19 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2.git
 F:	arch/nios2/
 
+NITRO ENCLAVES (NE)
+M:	Andra Paraschiv <andraprs@amazon.com>
+M:	Alexandru Vasile <lexnv@amazon.com>
+M:	Alexandru Ciobotaru <alcioa@amazon.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+W:	https://aws.amazon.com/ec2/nitro/nitro-enclaves/
+F:	Documentation/nitro_enclaves/
+F:	drivers/virt/nitro_enclaves/
+F:	include/linux/nitro_enclaves.h
+F:	include/uapi/linux/nitro_enclaves.h
+F:	samples/nitro_enclaves/
+
 NOHZ, DYNTICKS SUPPORT
 M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Thomas Gleixner <tglx@linutronix.de>
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

