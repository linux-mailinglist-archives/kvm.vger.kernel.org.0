Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADE31E17C7
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbgEYWRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 18:17:23 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:7486 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389376AbgEYWRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 18:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590445043; x=1621981043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZQUhc74BQTGillYV7hEL4Stk3r93yA62SoASB/NP6x8=;
  b=saZ/kSuQAveETVnULCKw3YSYx8Swdiq+b0O2fymYIuYn1zLuekzGN7KF
   6/nCH5EYv1R2sj/cj8ayVepP+ezRsKugnkt6R82Y26V0uZru+4rFNYlRm
   1ccKiXtlyrgwHO8XmIzOPiyUtKmMRx1xgLIGe6kUXRaTraNTfGdzD5rE3
   w=;
IronPort-SDR: OKcNlkJP0J1PEykixyWOMhbc/vce3A7yVFl3zCcVTXZh1QXO0f3NW2OGezw6vy4X2Ay4VuE2tC
 HqYs1GRIe0iA==
X-IronPort-AV: E=Sophos;i="5.73,435,1583193600"; 
   d="scan'208";a="37543980"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 25 May 2020 22:17:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 74A98C0B70;
        Mon, 25 May 2020 22:17:20 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:17:19 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:17:11 +0000
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
Subject: [PATCH v3 18/18] MAINTAINERS: Add entry for the Nitro Enclaves driver
Date:   Tue, 26 May 2020 01:13:34 +0300
Message-ID: <20200525221334.62966-19-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200525221334.62966-1-andraprs@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D25UWC004.ant.amazon.com (10.43.162.201) To
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

v2 -> v3

* Update file entries to be in alphabetical order.

v1 -> v2

* No changes.
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 50659d76976b..56d529256ba4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11968,6 +11968,19 @@ S:	Maintained
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

