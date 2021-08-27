Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247583F9BFD
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 17:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245512AbhH0Pv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 11:51:28 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:46050 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245509AbhH0Pv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 11:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630079438; x=1661615438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i0j/X6GVx88IEMduyTxlPnzYI3HNiRgbOvXelXh/NoM=;
  b=S4B5YNbXuMwkOsmU254+UiKjrdE49emrT47idKYJIvLHgPDUkboPTv3I
   TgYYIpV4B3E/Yi1VQczYPiWbFZbRWD4MWNcXKj8BmfhRXvxMKKW2GceiC
   JhxEDkIKA0N9uKI7zJAWpI537TSw0LGdALBEsfgSXtokjWOFae8Oyn24R
   M=;
X-IronPort-AV: E=Sophos;i="5.84,357,1620691200"; 
   d="scan'208";a="155652121"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 27 Aug 2021 15:50:32 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 5161A2202AF;
        Fri, 27 Aug 2021 15:50:31 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 15:50:24 +0000
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
Subject: [PATCH v3 7/7] nitro_enclaves: Add fixes for checkpatch blank line reports
Date:   Fri, 27 Aug 2021 18:49:30 +0300
Message-ID: <20210827154930.40608-8-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210827154930.40608-1-andraprs@amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.52]
X-ClientProxiedBy: EX13D04UWB004.ant.amazon.com (10.43.161.103) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove blank lines that are not necessary, fixing the checkpatch script
reports. While at it, add a blank line after the switch default block,
similar to the other parts of the codebase.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v1 -> v2

* No codebase changes, it was split from the patch 3 in the v1 of the
patch series.

v2 -> v3

* Move changelog after the "---" line.
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

