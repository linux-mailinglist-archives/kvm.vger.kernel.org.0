Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00C828DC59
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 11:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgJNJFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 05:05:35 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:65507 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgJNJFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 05:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602666335; x=1634202335;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y4uF4ZEBK32Jc4xw6gI6FEIourHHlYCRqz8nki0gYyI=;
  b=qOkMFX5sufrRtwI98Q7oKihHHXk37ODwvS3A6bG83oyN/IH2ycib0lcC
   Q2oxQIV+Cy0C5pQbEnXqWfgUwEYH0txiSN45eecLiplhhORP/4moc1i+u
   /CRwTHoO9JFt68ueghICBuh2Ugl5sx94+Wr3LvJHmflQd9DIDH7LUsGgj
   I=;
X-IronPort-AV: E=Sophos;i="5.77,374,1596499200"; 
   d="scan'208";a="83212214"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 14 Oct 2020 09:05:21 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 10167A2236;
        Wed, 14 Oct 2020 09:05:16 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.71) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 14 Oct 2020 09:05:06 +0000
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v1] nitro_enclaves: Fixup type of the poll result assigned value
Date:   Wed, 14 Oct 2020 12:05:00 +0300
Message-ID: <20201014090500.75678-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D43UWC001.ant.amazon.com (10.43.162.69) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the assigned value of the poll result to be EPOLLHUP instead of
POLLHUP to match the __poll_t type.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index f06622b48d69..9148566455e8 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1508,7 +1508,7 @@ static __poll_t ne_enclave_poll(struct file *file, poll_table *wait)
 	if (!ne_enclave->has_event)
 		return mask;
 
-	mask = POLLHUP;
+	mask = EPOLLHUP;
 
 	return mask;
 }
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

