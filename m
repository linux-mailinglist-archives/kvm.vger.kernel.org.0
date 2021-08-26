Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087413F8D2A
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 19:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243244AbhHZRg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 13:36:26 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:2203 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243239AbhHZRgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 13:36:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1629999337; x=1661535337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yvnQ3vNE567ubQgHlaWFeJQp8opAmi9KqGdFzHyC4dQ=;
  b=tl06lcowjgCubtvewm99C1w6PlorhBc9zVJSkAtluzDiKHwmS2wrXnzr
   3haFU1mRJhSY23C/3EYNHdO/YZb7axs/ttUICRyw0JAJhxCUH9JscCtNl
   EztnofJ76fYs/zEtxfLoEje06WQroIBsPs20t4V7kr/Cptmx83PnJbwz9
   I=;
X-IronPort-AV: E=Sophos;i="5.84,354,1620691200"; 
   d="scan'208";a="135530513"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-25e59222.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 26 Aug 2021 17:35:30 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-25e59222.us-east-1.amazon.com (Postfix) with ESMTPS id 01190AE89B;
        Thu, 26 Aug 2021 17:35:26 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 26 Aug 2021 17:35:19 +0000
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
Subject: [PATCH v1 3/3] nitro_enclaves: Add fixes for checkpatch and docs reports
Date:   Thu, 26 Aug 2021 20:34:51 +0300
Message-ID: <20210826173451.93165-4-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210826173451.93165-1-andraprs@amazon.com>
References: <20210826173451.93165-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D38UWC004.ant.amazon.com (10.43.162.204) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the reported issues from checkpatch and kernel-doc scripts.

Update the copyright statements to include 2021, where changes have been
made over this year.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 17 +++++++++--------
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  2 +-
 drivers/virt/nitro_enclaves/ne_pci_dev.h  |  8 ++++++--
 include/uapi/linux/nitro_enclaves.h       | 10 +++++-----
 samples/nitro_enclaves/ne_ioctl_sample.c  |  7 +++----
 5 files changed, 24 insertions(+), 20 deletions(-)

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
 
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 143207e9b9698..40b49ec8e30b1 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
 
 /**
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 8bfbc66078185..7bbfd39280fec 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
 
 #ifndef _NE_PCI_DEV_H_
@@ -84,9 +84,13 @@
  */
 
 /**
- * NE_SEND_DATA_SIZE / NE_RECV_DATA_SIZE - 240 bytes for send / recv buffer.
+ * NE_SEND_DATA_SIZE - 240 bytes for send buffer.
  */
 #define NE_SEND_DATA_SIZE	(240)
+
+/**
+ * NE_RECV_DATA_SIZE - 240 bytes for recv buffer.
+ */
 #define NE_RECV_DATA_SIZE	(240)
 
 /**
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
index 480b763142b34..765b131c73190 100644
--- a/samples/nitro_enclaves/ne_ioctl_sample.c
+++ b/samples/nitro_enclaves/ne_ioctl_sample.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
 
 /**
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
 
@@ -638,7 +637,7 @@ static int ne_start_enclave(int enclave_fd,  struct ne_enclave_start_info *encla
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

