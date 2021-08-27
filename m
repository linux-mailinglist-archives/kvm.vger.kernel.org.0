Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DD93F9A40
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245303AbhH0NeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 09:34:14 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:24439 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245304AbhH0NeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 09:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630071203; x=1661607203;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EEu3FYMRr+q81t6fu5GQ4KYQRiWxMXDTwSHjx1OG3e4=;
  b=V/ZPigkqf289X5wRGMDNJPgr9W3rKOS08g/3y/qT+WtpSKk40g2nOLLR
   px2xQVOUqeymaL6OXn9FdgE677htmeL6C/Z+21SxlNurZYLRXX3Iga3Rf
   KYiZa3pGCbXh+SxaOa+Q2+l7Ah8qN+k1HuCq01uCo+o91oH/5rTmvI7gL
   A=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="137217143"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 27 Aug 2021 13:33:22 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id 6BF85A0AE8;
        Fri, 27 Aug 2021 13:33:20 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 13:33:13 +0000
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
Subject: [PATCH v2 5/7] nitro_enclaves: Add fixes for checkpatch match open parenthesis reports
Date:   Fri, 27 Aug 2021 16:32:28 +0300
Message-ID: <20210827133230.29816-6-andraprs@amazon.com>
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

Update the codebase formatting to fix the reports from the checkpatch
script, to match the open parenthesis.

Changelog

v1 -> v2

* No codebase changes, it was split from the patch 3 in the v1 of the
patch series.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index e21e1e86ad15f..8939612ee0e08 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
 
 /**
@@ -284,8 +284,8 @@ static int ne_setup_cpu_pool(const char *ne_cpu_list)
 	ne_cpu_pool.nr_parent_vm_cores = nr_cpu_ids / ne_cpu_pool.nr_threads_per_core;
 
 	ne_cpu_pool.avail_threads_per_core = kcalloc(ne_cpu_pool.nr_parent_vm_cores,
-					     sizeof(*ne_cpu_pool.avail_threads_per_core),
-					     GFP_KERNEL);
+						     sizeof(*ne_cpu_pool.avail_threads_per_core),
+						     GFP_KERNEL);
 	if (!ne_cpu_pool.avail_threads_per_core) {
 		rc = -ENOMEM;
 
@@ -735,7 +735,7 @@ static int ne_add_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
  * * Negative return value on failure.
  */
 static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
-	struct ne_user_memory_region mem_region)
+					   struct ne_user_memory_region mem_region)
 {
 	struct ne_mem_region *ne_mem_region = NULL;
 
@@ -771,7 +771,7 @@ static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
 		u64 userspace_addr = ne_mem_region->userspace_addr;
 
 		if ((userspace_addr <= mem_region.userspace_addr &&
-		    mem_region.userspace_addr < (userspace_addr + memory_size)) ||
+		     mem_region.userspace_addr < (userspace_addr + memory_size)) ||
 		    (mem_region.userspace_addr <= userspace_addr &&
 		    (mem_region.userspace_addr + mem_region.memory_size) > userspace_addr)) {
 			dev_err_ratelimited(ne_misc_dev.this_device,
@@ -836,7 +836,7 @@ static int ne_sanity_check_user_mem_region_page(struct ne_enclave *ne_enclave,
  * * Negative return value on failure.
  */
 static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
-	struct ne_user_memory_region mem_region)
+					   struct ne_user_memory_region mem_region)
 {
 	long gup_rc = 0;
 	unsigned long i = 0;
@@ -1014,7 +1014,7 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
  * * Negative return value on failure.
  */
 static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
-	struct ne_enclave_start_info *enclave_start_info)
+				  struct ne_enclave_start_info *enclave_start_info)
 {
 	struct ne_pci_dev_cmd_reply cmd_reply = {};
 	unsigned int cpu = 0;
@@ -1574,7 +1574,8 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
 	mutex_unlock(&ne_cpu_pool.mutex);
 
 	ne_enclave->threads_per_core = kcalloc(ne_enclave->nr_parent_vm_cores,
-		sizeof(*ne_enclave->threads_per_core), GFP_KERNEL);
+					       sizeof(*ne_enclave->threads_per_core),
+					       GFP_KERNEL);
 	if (!ne_enclave->threads_per_core) {
 		rc = -ENOMEM;
 
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

