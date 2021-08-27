Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823C83F9A4D
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245365AbhH0Ne2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 09:34:28 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:29653 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245360AbhH0NeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 09:34:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630071212; x=1661607212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XlrFOPsHVkGwuf5CGE9FaO4wRJO0d1CiINHk8dBhF/8=;
  b=MVXYpuFyKKJru/YR9nKSRMv3VvkVfblLVrVJkoJXcA0amto9q9359C7o
   u8Av7ywZukDMMNDVtIIBgOQ9KZsuTlh6vkJipRwq09WcAocBMdyskxYJT
   mXY6p+qS58E1FaSvNxOXpJGIHBsA06h6LIX5CqNQt2gj8loif65e3IRmW
   g=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="155617338"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 27 Aug 2021 13:33:32 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 988FEA04DB;
        Fri, 27 Aug 2021 13:33:31 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 13:33:25 +0000
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
Subject: [PATCH v2 7/7] nitro_enclaves: Add fixes for checkpatch blank line reports
Date:   Fri, 27 Aug 2021 16:32:30 +0300
Message-ID: <20210827133230.29816-8-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210827133230.29816-1-andraprs@amazon.com>
References: <20210827133230.29816-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.52]
X-ClientProxiedBy: EX13D43UWA002.ant.amazon.com (10.43.160.109) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove blank lines that are not necessary, fixing the checkpatch script
reports. While at it, add a blank line after the switch default block,
similar to the other parts of the codebase.

Changelog

v1 -> v2

* No codebase changes, it was split from the patch 3 in the v1 of the
patch series.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 samples/nitro_enclaves/ne_ioctl_sample.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enclaves/ne_ioctl_sample.c
index 6a60990b2e202..765b131c73190 100644
--- a/samples/nitro_enclaves/ne_ioctl_sample.c
+++ b/samples/nitro_enclaves/ne_ioctl_sample.c
@@ -185,7 +185,6 @@ static int ne_create_vm(int ne_dev_fd, unsigned long *slot_uid, int *enclave_fd)
 	return 0;
 }
 
-
 /**
  * ne_poll_enclave_fd() - Thread function for polling the enclave fd.
  * @data:	Argument provided for the polling function.
@@ -560,8 +559,8 @@ static int ne_add_vcpu(int enclave_fd, unsigned int *vcpu_id)
 
 		default:
 			printf("Error in add vcpu [%m]\n");
-
 		}
+
 		return rc;
 	}
 
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

