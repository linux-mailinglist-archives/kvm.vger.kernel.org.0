Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F83221562
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgGOTrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:47:19 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:5531 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgGOTrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842434; x=1626378434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/HkBTh4tqdBH3hbQFM7eTO8K3wEzhwcaTUh8umyvZi0=;
  b=PUsFmgL5Sln7K4LlwkgP2CYW3CDMGA4FPFMmwSz526QHu/WFFJ99uYhP
   y8dtaLsMLohDusSQfQB12q1+QTHCon2CxLX+XRGg/ivsj2y+PgkBycMlX
   9vu4hIb57fdsUgyXzq+m3a72nBG81AAQfdfooTR93jbXF0LOrO7WfZSlr
   s=;
IronPort-SDR: l5ItmYRMAA01XNCo3tPcWYdBugCc9x3wtLAe4h0m9fDqIBWjLDJDZUvPod30oqRz64GQmjXfWu
 ehCwlNKr0CNg==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="43560402"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 15 Jul 2020 19:47:13 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id 2A05EA261D;
        Wed, 15 Jul 2020 19:47:12 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:47:11 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.214) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:47:01 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
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
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v5 07/18] nitro_enclaves: Init misc device providing the ioctl interface
Date:   Wed, 15 Jul 2020 22:45:29 +0300
Message-ID: <20200715194540.45532-8-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200715194540.45532-1-andraprs@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D46UWB001.ant.amazon.com (10.43.161.16) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Nitro Enclaves driver provides an ioctl interface to the user space
for enclave lifetime management e.g. enclave creation / termination and
setting enclave resources such as memory and CPU.

This ioctl interface is mapped to a Nitro Enclaves misc device.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v4 -> v5

* Update the size of the NE CPU pool string from 4096 to 512 chars.

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Remove the NE CPU pool init during kernel module loading, as the CPU
  pool is now setup at runtime, via a sysfs file for the kernel
  parameter.
* Add minimum enclave memory size definition.

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.
* Remove the WARN_ON calls.
* Remove linux/bug and linux/kvm_host includes that are not needed.
* Remove "ratelimited" from the logs that are not in the ioctl call
  paths.
* Remove file ops that do nothing for now - open and release.

v1 -> v2

* Add log pattern for NE.
* Update goto labels to match their purpose.
* Update ne_cpu_pool data structure to include the global mutex.
* Update NE misc device mode to 0660.
* Check if the CPU siblings are included in the NE CPU pool, as full CPU
  cores are given for the enclave(s).
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 123 ++++++++++++++++++++++
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  11 ++
 2 files changed, 134 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
new file mode 100644
index 000000000000..62c9a70c5cf3
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+/**
+ * Enclave lifetime management driver for Nitro Enclaves (NE).
+ * Nitro is a hypervisor that has been developed by Amazon.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/capability.h>
+#include <linux/cpu.h>
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/hugetlb.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/nitro_enclaves.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include "ne_misc_dev.h"
+#include "ne_pci_dev.h"
+
+/**
+ * Size for max 128 CPUs, for now, in a cpu-list string, comma separated.
+ * The NE CPU pool includes CPUs from a single NUMA node.
+ */
+#define NE_CPUS_SIZE (512)
+
+#define NE_EIF_LOAD_OFFSET (8 * 1024UL * 1024UL)
+
+#define NE_MIN_ENCLAVE_MEM_SIZE (64 * 1024UL * 1024UL)
+
+#define NE_MIN_MEM_REGION_SIZE (2 * 1024UL * 1024UL)
+
+/*
+ * TODO: Update logic to create new sysfs entries instead of using
+ * a kernel parameter e.g. if multiple sysfs files needed.
+ */
+static const struct kernel_param_ops ne_cpu_pool_ops = {
+	.get = param_get_string,
+};
+
+static char ne_cpus[NE_CPUS_SIZE];
+static struct kparam_string ne_cpus_arg = {
+	.maxlen = sizeof(ne_cpus),
+	.string = ne_cpus,
+};
+
+module_param_cb(ne_cpus, &ne_cpu_pool_ops, &ne_cpus_arg, 0644);
+/* https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html#cpu-lists */
+MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
+
+/* CPU pool used for Nitro Enclaves. */
+struct ne_cpu_pool {
+	/* Available CPU cores in the pool. */
+	cpumask_var_t *avail_cores;
+
+	/* The size of the available cores array. */
+	unsigned int avail_cores_size;
+
+	struct mutex mutex;
+
+	/* NUMA node of the CPUs in the pool. */
+	int numa_node;
+};
+
+static struct ne_cpu_pool ne_cpu_pool;
+
+static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case NE_GET_API_VERSION:
+		return NE_API_VERSION;
+
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static const struct file_operations ne_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl	= ne_ioctl,
+};
+
+struct miscdevice ne_misc_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "nitro_enclaves",
+	.fops	= &ne_fops,
+	.mode	= 0660,
+};
+
+static int __init ne_init(void)
+{
+	mutex_init(&ne_cpu_pool.mutex);
+
+	return pci_register_driver(&ne_pci_driver);
+}
+
+static void __exit ne_exit(void)
+{
+	pci_unregister_driver(&ne_pci_driver);
+}
+
+/* TODO: Handle actions such as reboot, kexec. */
+
+module_init(ne_init);
+module_exit(ne_exit);
+
+MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
+MODULE_DESCRIPTION("Nitro Enclaves Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index e12a8f8bf0be..1208f303272e 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -499,6 +499,13 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto teardown_msix;
 	}
 
+	rc = misc_register(&ne_misc_dev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in misc dev register [rc=%d]\n", rc);
+
+		goto disable_ne_pci_dev;
+	}
+
 	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
 	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
 	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
@@ -508,6 +515,8 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+disable_ne_pci_dev:
+	ne_pci_dev_disable(pdev);
 teardown_msix:
 	ne_teardown_msix(pdev);
 iounmap_pci_bar:
@@ -527,6 +536,8 @@ static void ne_pci_remove(struct pci_dev *pdev)
 {
 	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
 
+	misc_deregister(&ne_misc_dev);
+
 	ne_pci_dev_disable(pdev);
 
 	ne_teardown_msix(pdev);
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

