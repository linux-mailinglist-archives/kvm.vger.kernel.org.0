Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976683F9A42
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 15:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245340AbhH0NeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 09:34:18 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:24564 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245299AbhH0NeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 09:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630071209; x=1661607209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kHebWcaTe5iAVHkkg40aCcznXhYBts4+VmWf/Kg1ipM=;
  b=dk0yVjoJlekPDpZegk2HNBxofSOYcwbWwoxZ4zgLKK8RA/rG2EIPMfGP
   tZGc5cfhh7B3lV4mEVQcHJ0APX9COe4N5Kj8WSgE9vhXyE7Qbiy1Ne7ql
   RftZ0/nzZ2VS6scI0gdFDLKcBTbWr6fM4uUoF1Ypqsk/mXJDw4uLXnqGN
   0=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="137217159"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 27 Aug 2021 13:33:28 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id C1539A2288;
        Fri, 27 Aug 2021 13:33:26 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 13:33:19 +0000
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
Subject: [PATCH v2 6/7] nitro_enclaves: Add fixes for checkpatch spell check reports
Date:   Fri, 27 Aug 2021 16:32:29 +0300
Message-ID: <20210827133230.29816-7-andraprs@amazon.com>
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

Fix the typos in the words spelling as per the checkpatch script
reports.

Changelog

v1 -> v2

* No codebase changes, it was split from the patch 3 in the v1 of the
patch series.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 include/uapi/linux/nitro_enclaves.h      | 10 +++++-----
 samples/nitro_enclaves/ne_ioctl_sample.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index b945073fe544d..e808f5ba124d4 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
- * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
 
 #ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
@@ -60,7 +60,7 @@
  *
  * Context: Process context.
  * Return:
- * * 0					- Logic succesfully completed.
+ * * 0					- Logic successfully completed.
  * *  -1				- There was a failure in the ioctl logic.
  * On failure, errno is set to:
  * * EFAULT				- copy_from_user() / copy_to_user() failure.
@@ -95,7 +95,7 @@
  *
  * Context: Process context.
  * Return:
- * * 0				- Logic succesfully completed.
+ * * 0				- Logic successfully completed.
  * *  -1			- There was a failure in the ioctl logic.
  * On failure, errno is set to:
  * * EFAULT			- copy_from_user() / copy_to_user() failure.
@@ -118,7 +118,7 @@
  *
  * Context: Process context.
  * Return:
- * * 0					- Logic succesfully completed.
+ * * 0					- Logic successfully completed.
  * *  -1				- There was a failure in the ioctl logic.
  * On failure, errno is set to:
  * * EFAULT				- copy_from_user() failure.
@@ -161,7 +161,7 @@
  *
  * Context: Process context.
  * Return:
- * * 0					- Logic succesfully completed.
+ * * 0					- Logic successfully completed.
  * *  -1				- There was a failure in the ioctl logic.
  * On failure, errno is set to:
  * * EFAULT				- copy_from_user() / copy_to_user() failure.
diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enclaves/ne_ioctl_sample.c
index 480b763142b34..6a60990b2e202 100644
--- a/samples/nitro_enclaves/ne_ioctl_sample.c
+++ b/samples/nitro_enclaves/ne_ioctl_sample.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
 
 /**
@@ -638,7 +638,7 @@ static int ne_start_enclave(int enclave_fd,  struct ne_enclave_start_info *encla
 }
 
 /**
- * ne_start_enclave_check_booted() - Start the enclave and wait for a hearbeat
+ * ne_start_enclave_check_booted() - Start the enclave and wait for a heartbeat
  *				     from it, on a newly created vsock channel,
  *				     to check it has booted.
  * @enclave_fd :	The file descriptor associated with the enclave.
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

