Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638D523C8ED
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgHEJOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:14:42 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:58952 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728658AbgHEJNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 05:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596618823; x=1628154823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PjFXOtCuwEnfKyB7ZS+LsNc46T9Vj62xWcGURLnWUrE=;
  b=WP+yGyj8LfnY6QYhGqUcOeX2sl7q2EIxqDXlT50pI08VHcmBM7wPIOqU
   bQ2Q5YsnfPTLVZhRRBivP4RarjSndEd7zTm4QVHDGMLuIaHdMgtE4bPw2
   q42A8ePNwISqjSG8plpEyUI3p4T3OJoH71oN+TvXSv2TnwMLvgnBgcTeT
   E=;
IronPort-SDR: rzIkGJeoP5W6DZzjxGgYhooXNR5msuoi/CAiBItm/MyrkgudraV93c9qjcyZSEONnhzjFJkRl8
 PmZV/5mpb12g==
X-IronPort-AV: E=Sophos;i="5.75,436,1589241600"; 
   d="scan'208";a="46143825"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 05 Aug 2020 09:13:42 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 5DAC8A24DD;
        Wed,  5 Aug 2020 09:13:39 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:13:39 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.192) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:13:30 +0000
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
Subject: [PATCH v6 18/18] MAINTAINERS: Add entry for the Nitro Enclaves driver
Date:   Wed, 5 Aug 2020 12:10:17 +0300
Message-ID: <20200805091017.86203-19-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200805091017.86203-1-andraprs@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.192]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
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
index 4e2698cc7e23..0d83aaad3cd4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12127,6 +12127,19 @@ S:	Maintained
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

