Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126731DDFF9
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgEVGc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:32:59 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20918 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgEVGc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129179; x=1621665179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sf33lwe+INgQJ3nfbsCYbHw2Wj4q8ImFKELp3Gjh7hY=;
  b=h3CAYiHHmaNscsm1GWjtMtqtk11Rn6g3l8xqNsR6IaEv8HTeo/lDkpOH
   KLDH7Z3QpB9sdPR9m7TtoMUz3X0FPoWHNnHdcLPt4jmEXiNNn+o6/47ux
   CnzfD7Z+xudGzgif+V9IvYslsDe+t2H0tsq5fflQ5YCoJ/vOjKBX4NnB3
   4=;
IronPort-SDR: jIgftmOx8xzurRLAyb1BYUHcvImfS/rto7jUmpbYgEsG9uCTRY5bWzE6bnoysFpHSp3mHouHvh
 ShEx/EZJJNwQ==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="31775604"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 May 2020 06:32:58 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 80E942831A3;
        Fri, 22 May 2020 06:32:56 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:32:56 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:32:47 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v2 18/18] MAINTAINERS: Add entry for the Nitro Enclaves driver
Date:   Fri, 22 May 2020 09:29:46 +0300
Message-ID: <20200522062946.28973-19-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200522062946.28973-1-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ecc0749810b0..69fe37999a9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11956,6 +11956,19 @@ S:	Maintained
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
+F:	drivers/virt/nitro_enclaves/
+F:	samples/nitro_enclaves/
+F:	Documentation/nitro_enclaves/
+
 NOHZ, DYNTICKS SUPPORT
 M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Thomas Gleixner <tglx@linutronix.de>
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

