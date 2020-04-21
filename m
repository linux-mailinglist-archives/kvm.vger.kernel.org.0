Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF781B2F71
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgDUSoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:44:24 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:62594 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729704AbgDUSoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494663; x=1619030663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x7e23kFiXkvUBqIe8e1beT+ixqa5FhXJH3ogwFK7OSU=;
  b=vn/TA35TOdoOp+o/iwsowk/an8xoEc6JG1no/UuRS3QPLdcbHO63sW6t
   sECpUucUJTm2x8rfcrz03MHfgjEYc++7mZa4kRkizUHQFWn4Z2Tt9Y8J9
   Ww7LK0W14kzwrOhUZ/UfpoQYmFdPH+My0Fbxb9eJ+FNuadkPpYA+zls6/
   Y=;
IronPort-SDR: 6GB3xe8ItpdTWMUTW+vMRC6TZZZLRue50FgLVl+Eux87Zm7497NnDu+ILeFy356WlBd/pnb4dv
 tSyjFZ/rAolw==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="39978688"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2020 18:44:23 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 456D0A277D;
        Tue, 21 Apr 2020 18:44:22 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:44:21 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.148) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:44:13 +0000
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
Subject: [PATCH v1 15/15] MAINTAINERS: Add entry for the Nitro Enclaves driver
Date:   Tue, 21 Apr 2020 21:41:50 +0300
Message-ID: <20200421184150.68011-16-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200421184150.68011-1-andraprs@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.148]
X-ClientProxiedBy: EX13D08UWB002.ant.amazon.com (10.43.161.168) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b816a453b10e..9625fadbd400 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11956,6 +11956,17 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2.git
 F:	arch/nios2/
 
+NITRO ENCLAVES (NE)
+M:	Andra Paraschiv <andraprs@amazon.com>
+M:	Alexandru Vasile <lexnv@amazon.com>
+M:	Alexandru Ciobotaru <alcioa@amazon.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+W:	https://aws.amazon.com/ec2/nitro/nitro-enclaves/
+F:	include/linux/nitro_enclaves.h
+F:	include/uapi/linux/nitro_enclaves.h
+F:	drivers/virt/amazon/nitro_enclaves/
+
 NOHZ, DYNTICKS SUPPORT
 M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Thomas Gleixner <tglx@linutronix.de>
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

