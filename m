Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78689221577
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgGOTs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:48:57 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:10559 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgGOTs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842531; x=1626378531;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QFxl8D96GW+k/d2txqMlUy7sqJuj8jA31KZN5rz8qR0=;
  b=RxwLMjUt3d9J7bTEnpMHuL5ybuKktjxpo2GO1mVmeZnMxwLWax2vWkJM
   dflVFIDYkkEhuCHaUrt7GJorKkPR93ok8INM8IWVWkZts88h7+ka15ey8
   gNKyi7hh7jtYiOAZ5NXFFN4WujkOIX50mq2d7OqyfNbQ6Wh96diE7Z/40
   k=;
IronPort-SDR: IwYvyAvdmFbYhD++uK+i1liIID+DVsXSNs2Wlk5FPXodb8sn6ksl8N99WC4aUtXNexsViv+Gt8
 drb3wxfObg1A==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="42238115"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 15 Jul 2020 19:48:50 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 7D5D8A205E;
        Wed, 15 Jul 2020 19:48:48 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:48:47 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:48:37 +0000
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
Subject: [PATCH v5 16/18] nitro_enclaves: Add sample for ioctl interface usage
Date:   Wed, 15 Jul 2020 22:45:38 +0300
Message-ID: <20200715194540.45532-17-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200715194540.45532-1-andraprs@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D34UWA002.ant.amazon.com (10.43.160.245) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v4 -> v5

* Print enclave vCPU ids when they are created.
* Update logic to map the modified vCPU ioctl call.
* Add check for the path to the enclave image to be less than PATH_MAX.
* Update the ioctl calls error checking logic to match the NE specific
  error codes.

v3 -> v4

* Update usage details to match the updates in v4.
* Update NE ioctl interface usage.

v2 -> v3

* Remove the include directory to use the uapi from the kernel.
* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.

v1 -> v2

* New in v2.
---
 samples/nitro_enclaves/.gitignore        |   2 +
 samples/nitro_enclaves/Makefile          |  16 +
 samples/nitro_enclaves/ne_ioctl_sample.c | 628 +++++++++++++++++++++++
 3 files changed, 646 insertions(+)
 create mode 100644 samples/nitro_enclaves/.gitignore
 create mode 100644 samples/nitro_enclaves/Makefile
 create mode 100644 samples/nitro_enclaves/ne_ioctl_sample.c

diff --git a/samples/nitro_enclaves/.gitignore b/samples/nitro_enclaves/.gitignore
new file mode 100644
index 000000000000..827934129c90
--- /dev/null
+++ b/samples/nitro_enclaves/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+ne_ioctl_sample
diff --git a/samples/nitro_enclaves/Makefile b/samples/nitro_enclaves/Makefile
new file mode 100644
index 000000000000..a3ec78fefb52
--- /dev/null
+++ b/samples/nitro_enclaves/Makefile
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+
+# Enclave lifetime management support for Nitro Enclaves (NE) - ioctl sample
+# usage.
+
+.PHONY: all clean
+
+CFLAGS += -Wall
+
+all:
+	$(CC) $(CFLAGS) -o ne_ioctl_sample ne_ioctl_sample.c -lpthread
+
+clean:
+	rm -f ne_ioctl_sample
diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enclaves/ne_ioctl_sample.c
new file mode 100644
index 000000000000..d8f64e3df535
--- /dev/null
+++ b/samples/nitro_enclaves/ne_ioctl_sample.c
@@ -0,0 +1,628 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+/**
+ * Sample flow of using the ioctl interface provided by the Nitro Enclaves (NE)
+ * kernel driver.
+ *
+ * Usage
+ * -----
+ *
+ * Load the nitro_enclaves module, setting also the enclave CPU pool. The
+ * enclave CPUs need to be full cores from the same NUMA node. CPU 0 and its
+ * siblings have to remain available for the primary / parent VM, so they
+ * cannot be included in the enclave CPU pool.
+ *
+ * See the cpu list section from the kernel documentation.
+ * https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html#cpu-lists
+ *
+ *	insmod drivers/virt/nitro_enclaves/nitro_enclaves.ko
+ *	lsmod
+ *
+ *	The CPU pool can be set at runtime, after the kernel module is loaded.
+ *
+ *	echo <cpu-list> > /sys/module/nitro_enclaves/parameters/ne_cpus
+ *
+ *	NUMA and CPU siblings information can be found using:
+ *
+ *	lscpu
+ *	/proc/cpuinfo
+ *
+ * Check the online / offline CPU list. The CPUs from the pool should be
+ * offlined.
+ *
+ *	lscpu
+ *
+ * Check dmesg for any warnings / errors through the NE driver lifetime / usage.
+ * The NE logs contain the "nitro_enclaves" or "pci 0000:00:02.0" pattern.
+ *
+ *	dmesg
+ *
+ * Setup hugetlbfs huge pages. The memory needs to be from the same NUMA node as
+ * the enclave CPUs.
+ * https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt
+ * TODO: Update the usage steps for NUMA aware hugetlb configuration. By
+ * default, the allocation of hugetlb pages are distributed on all possible NUMA
+ * nodes.
+ *
+ *	echo <nr_hugepages> > /proc/sys/vm/nr_hugepages
+ *
+ *	or set the number of 2 MiB / 1 GiB hugepages using
+ *
+ *	/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+ *	/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
+ *
+ *	In this example 256 hugepages of 2 MiB are used.
+ *
+ * Build and run the NE sample.
+ *
+ *	make -C samples/nitro_enclaves clean
+ *	make -C samples/nitro_enclaves
+ *	./samples/nitro_enclaves/ne_ioctl_sample <path_to_enclave_image>
+ *
+ * Unload the nitro_enclaves module.
+ *
+ *	rmmod nitro_enclaves
+ *	lsmod
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <poll.h>
+#include <pthread.h>
+#include <string.h>
+#include <sys/eventfd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include <linux/nitro_enclaves.h>
+#include <linux/vm_sockets.h>
+
+/* Nitro Enclaves (NE) misc device that provides the ioctl interface. */
+#define NE_DEV_NAME "/dev/nitro_enclaves"
+#define NE_EXPECTED_API_VERSION (1)
+
+/* Timeout in seconds / milliseconds for each poll event. */
+#define NE_POLL_WAIT_TIME (60)
+#define NE_POLL_WAIT_TIME_MS (NE_POLL_WAIT_TIME * 1000)
+
+/* Amount of time in seconds for the process to keep the enclave alive. */
+#define NE_SLEEP_TIME (300)
+
+/* Enclave vCPUs metadata. */
+#define NE_DEFAULT_NR_VCPUS (2)
+
+/* Enclave memory metadata */
+
+/* Min memory size - 2 MiB */
+#define NE_MIN_MEM_REGION_SIZE (2 * 1024 * 1024)
+
+/* 256 memory regions of 2 MiB */
+#define NE_DEFAULT_NR_MEM_REGIONS (256)
+
+/* Vsock addressing for enclave image loading heartbeat. */
+#define NE_IMAGE_LOAD_VSOCK_CID (3)
+#define NE_IMAGE_LOAD_VSOCK_PORT (9000)
+#define NE_IMAGE_LOAD_HEARTBEAT_VALUE (0xb7)
+
+struct ne_mem_region {
+	void *mem_addr;
+	size_t mem_size;
+};
+
+/* Thread function for polling the enclave fd. */
+void *ne_poll_enclave_fd(void *data)
+{
+	int enclave_fd = *(int *)data;
+	struct pollfd fds[1] = {};
+	int i = 0;
+	int rc = -EINVAL;
+
+	printf("Running from poll thread, enclave fd %d\n", enclave_fd);
+
+	fds[0].fd = enclave_fd;
+	fds[0].events = POLLIN | POLLERR | POLLHUP;
+
+	/* Keep on polling until the current process is terminated. */
+	while (1) {
+		printf("[iter %d] Polling ...\n", i);
+
+		rc = poll(fds, 1, NE_POLL_WAIT_TIME_MS);
+		if (rc < 0) {
+			printf("Error in poll [%m]\n");
+
+			return NULL;
+		}
+
+		i++;
+
+		if (!rc) {
+			printf("Poll: %d seconds elapsed\n",
+			       i * NE_POLL_WAIT_TIME);
+
+			continue;
+		}
+
+		printf("Poll received value %d\n", fds[0].revents);
+	}
+
+	return NULL;
+}
+
+/* Allocate memory region that will be used for the enclave. */
+static int ne_alloc_mem_region(struct ne_mem_region *ne_mem_region)
+{
+	ne_mem_region->mem_addr = mmap(NULL, ne_mem_region->mem_size,
+				       PROT_READ | PROT_WRITE,
+				       MAP_PRIVATE | MAP_ANONYMOUS |
+				       MAP_HUGETLB, -1, 0);
+	if (ne_mem_region->mem_addr == MAP_FAILED) {
+		printf("Error in mmap memory [%m]\n");
+
+		return -1;
+	}
+
+	return 0;
+}
+
+/* Place enclave image in enclave memory. */
+static int ne_load_enclave_image(int enclave_fd, struct ne_mem_region ne_mem_regions[],
+				 char *enclave_image_path)
+{
+	struct ne_image_load_info image_load_info = {};
+	int rc = -EINVAL;
+
+	image_load_info.flags = NE_EIF_IMAGE;
+
+	rc = ioctl(enclave_fd, NE_GET_IMAGE_LOAD_INFO, &image_load_info);
+	if (rc < 0) {
+		switch (errno) {
+		case NE_ERR_NOT_IN_INIT_STATE: {
+			printf("Error in get image load info, enclave not in init state\n");
+
+			break;
+		}
+
+		default:
+			printf("Error in get image load info [rc=%m]\n");
+		}
+
+		return rc;
+	}
+
+	printf("Enclave image offset in enclave memory is %lld\n",
+	       image_load_info.memory_offset);
+
+	/*
+	 * TODO: Copy enclave image in enclave memory starting from the given
+	 * offset.
+	 */
+
+	return 0;
+}
+
+/* TODO: Update the heartbeat logic based on the latest updates of EIF init. */
+/* Wait for a hearbeat from the enclave to check it has booted. */
+static int ne_check_enclave_booted(void)
+{
+	struct sockaddr_vm client_vsock_addr = {};
+	socklen_t client_vsock_len = sizeof(client_vsock_addr);
+	struct pollfd fds[1] = {};
+	int rc = -EINVAL;
+	unsigned char recv_buf = 0;
+	struct sockaddr_vm server_vsock_addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = NE_IMAGE_LOAD_VSOCK_CID,
+		.svm_port = NE_IMAGE_LOAD_VSOCK_PORT,
+	};
+	int server_vsock_fd = 0;
+
+	server_vsock_fd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (server_vsock_fd < 0) {
+		rc = server_vsock_fd;
+
+		printf("Error in socket [rc=%m]\n");
+
+		return rc;
+	}
+
+	rc = bind(server_vsock_fd, (struct sockaddr *)&server_vsock_addr,
+		  sizeof(server_vsock_addr));
+	if (rc < 0) {
+		printf("Error in bind [rc=%m]\n");
+
+		goto out;
+	}
+
+	rc = listen(server_vsock_fd, 1);
+	if (rc < 0) {
+		printf("Error in listen [rc=%m]\n");
+
+		goto out;
+	}
+
+	fds[0].fd = server_vsock_fd;
+	fds[0].events = POLLIN;
+
+	rc = poll(fds, 1, NE_POLL_WAIT_TIME_MS);
+	if (rc < 0) {
+		printf("Error in poll [%m]\n");
+
+		goto out;
+	}
+
+	if (!rc) {
+		printf("Poll timeout, %d seconds elapsed\n", NE_POLL_WAIT_TIME);
+
+		rc = -ETIMEDOUT;
+
+		goto out;
+	}
+
+	if ((fds[0].revents & POLLIN) == 0) {
+		printf("Poll received value %d\n", fds[0].revents);
+
+		rc = -EINVAL;
+
+		goto out;
+	}
+
+	rc = accept(server_vsock_fd, (struct sockaddr *)&client_vsock_addr,
+		    &client_vsock_len);
+	if (rc < 0) {
+		printf("Error in accept [rc=%m]\n");
+
+		goto out;
+	}
+
+	/*
+	 * Read the heartbeat value that the init process in the enclave sends
+	 * after vsock connect.
+	 */
+	rc = read(server_vsock_fd, &recv_buf, sizeof(recv_buf));
+	if (rc < 0) {
+		printf("Error in read [rc=%m]\n");
+
+		goto out;
+	}
+
+	if (rc != sizeof(recv_buf) || recv_buf != NE_IMAGE_LOAD_HEARTBEAT_VALUE) {
+		printf("Read %d instead of %d\n", recv_buf,
+		       NE_IMAGE_LOAD_HEARTBEAT_VALUE);
+
+		goto out;
+	}
+
+	close(server_vsock_fd);
+
+	return 0;
+
+out:
+	close(server_vsock_fd);
+
+	return rc;
+}
+
+/* Set memory region for the given enclave. */
+static int ne_set_mem_region(int enclave_fd, struct ne_mem_region ne_mem_region)
+{
+	struct ne_user_memory_region mem_region = {};
+	int rc = -EINVAL;
+
+	mem_region.memory_size = ne_mem_region.mem_size;
+	mem_region.userspace_addr = (__u64)ne_mem_region.mem_addr;
+
+	rc = ioctl(enclave_fd, NE_SET_USER_MEMORY_REGION, &mem_region);
+	if (rc < 0) {
+		switch (errno) {
+		case NE_ERR_NOT_IN_INIT_STATE: {
+			printf("Error in set user memory region, enclave not in init state\n");
+
+			break;
+		}
+
+		case NE_ERR_INVALID_MEM_REGION_SIZE: {
+			printf("Error in set user memory region, mem size not multiple of 2 MiB\n");
+
+			break;
+		}
+
+		case NE_ERR_INVALID_MEM_REGION_ADDR: {
+			printf("Error in set user memory region, invalid user space address\n");
+
+			break;
+		}
+
+		case NE_ERR_UNALIGNED_MEM_REGION_ADDR: {
+			printf("Error in set user memory region, unaligned user space address\n");
+
+			break;
+		}
+
+		case NE_ERR_MEM_NOT_HUGE_PAGE: {
+			printf("Error in set user memory region, not backed by huge pages\n");
+
+			break;
+		}
+
+		case NE_ERR_MEM_DIFF_NUMA_NODE: {
+			printf("Error in set user memory region, different NUMA node than CPUs\n");
+
+			break;
+		}
+
+		case NE_ERR_MEM_MAX_REGIONS: {
+			printf("Error in set user memory region, max memory regions reached\n");
+
+			break;
+		}
+
+		default:
+			printf("Error in set user memory region [rc=%m]\n");
+		}
+
+		return rc;
+	}
+
+	return 0;
+}
+
+/* Unmap all the memory regions that were set aside for the  enclave. */
+static void ne_free_mem_regions(struct ne_mem_region ne_mem_regions[])
+{
+	unsigned int i = 0;
+
+	for (i = 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++)
+		munmap(ne_mem_regions[i].mem_addr, ne_mem_regions[i].mem_size);
+}
+
+/* Add enclave vCPU. */
+static int ne_add_vcpu(int enclave_fd, unsigned int *vcpu_id)
+{
+	int rc = -EINVAL;
+
+	rc = ioctl(enclave_fd, NE_ADD_VCPU, vcpu_id);
+	if (rc < 0) {
+		switch (errno) {
+		case NE_ERR_NO_CPUS_AVAIL_IN_POOL: {
+			printf("Error in add vcpu, no CPUs available in the NE CPU pool\n");
+
+			break;
+		}
+
+		case NE_ERR_VCPU_ALREADY_USED: {
+			printf("Error in add vcpu, the provided vCPU is already used\n");
+
+			break;
+		}
+
+		case NE_ERR_VCPU_NOT_IN_POOL: {
+			printf("Error in add vcpu, the provided vCPU is not in the NE CPU pool\n");
+
+			break;
+		}
+
+		case NE_ERR_INVALID_CPU_CORE: {
+			printf("Error in add vcpu, the core id of the provided vCPU is invalid\n");
+
+			break;
+		}
+
+		case NE_ERR_NOT_IN_INIT_STATE: {
+			printf("Error in add vcpu, enclave not in init state\n");
+
+			break;
+		}
+
+		case NE_ERR_INVALID_VCPU: {
+			printf("Error in add vcpu, the provided vCPU is out of avail CPUs range\n");
+
+			break;
+		}
+
+		default:
+			printf("Error in add vcpu [rc=%m]\n");
+
+		}
+		return rc;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int enclave_fd = 0;
+	struct ne_enclave_start_info enclave_start_info = {};
+	unsigned int i = 0;
+	int ne_api_version = 0;
+	int ne_dev_fd = 0;
+	struct ne_mem_region ne_mem_regions[NE_DEFAULT_NR_MEM_REGIONS] = {};
+	unsigned int ne_vcpus[NE_DEFAULT_NR_VCPUS] = {};
+	int rc = -EINVAL;
+	unsigned long slot_uid = 0;
+	pthread_t thread_id = 0;
+
+	if (argc != 2) {
+		printf("Usage: %s <path_to_enclave_image>\n", argv[0]);
+
+		exit(EXIT_FAILURE);
+	}
+
+	if (strlen(argv[1]) >= PATH_MAX) {
+		printf("The size of the path to enclave image is higher than max path\n");
+
+		exit(EXIT_FAILURE);
+	}
+
+	ne_dev_fd = open(NE_DEV_NAME, O_RDWR | O_CLOEXEC);
+	if (ne_dev_fd < 0) {
+		rc = ne_dev_fd;
+
+		printf("Error in open NE device [rc=%m]\n");
+
+		exit(EXIT_FAILURE);
+	}
+
+	ne_api_version = ioctl(ne_dev_fd, NE_GET_API_VERSION);
+	if (ne_api_version != NE_EXPECTED_API_VERSION) {
+		printf("Expected API version %d, provided API version %d\n",
+		       NE_EXPECTED_API_VERSION, ne_api_version);
+
+		close(ne_dev_fd);
+
+		exit(EXIT_FAILURE);
+	}
+
+	printf("Creating enclave slot ...\n");
+
+	enclave_fd = ioctl(ne_dev_fd, NE_CREATE_VM, &slot_uid);
+
+	close(ne_dev_fd);
+
+	if (enclave_fd < 0) {
+		rc = enclave_fd;
+		switch (errno) {
+		case NE_ERR_NO_CPUS_AVAIL_IN_POOL: {
+			printf("Error in create vm, no CPUs available in the NE CPU pool\n");
+
+			break;
+		}
+
+		default:
+			printf("Error in create vm [rc=%m]\n");
+		}
+
+		exit(EXIT_FAILURE);
+	}
+
+	printf("Enclave fd %d\n", enclave_fd);
+
+	rc = pthread_create(&thread_id, NULL, ne_poll_enclave_fd, (void *)&enclave_fd);
+	if (rc < 0) {
+		printf("Error in thread create [rc=%m]\n");
+
+		close(enclave_fd);
+
+		exit(EXIT_FAILURE);
+	}
+
+	for (i = 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++) {
+		ne_mem_regions[i].mem_size = NE_MIN_MEM_REGION_SIZE;
+
+		rc = ne_alloc_mem_region(&ne_mem_regions[i]);
+		if (rc < 0) {
+			printf("Error in alloc mem region, iter %d\n", i);
+
+			goto release_enclave_fd;
+		}
+	}
+
+	rc = ne_load_enclave_image(enclave_fd, ne_mem_regions, argv[1]);
+	if (rc < 0) {
+		printf("Error in load enclave image\n");
+
+		goto release_enclave_fd;
+	}
+
+	for (i = 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++) {
+		rc = ne_set_mem_region(enclave_fd, ne_mem_regions[i]);
+		if (rc < 0) {
+			printf("Error in set mem region, iter %d\n", i);
+
+			goto release_enclave_fd;
+		}
+	}
+
+	printf("Enclave memory regions were added\n");
+
+	for (i = 0; i < NE_DEFAULT_NR_VCPUS; i++) {
+		/*
+		 * The vCPU is chosen from the enclave vCPU pool, if the value
+		 * of the vcpu_id is 0.
+		 */
+		ne_vcpus[i] = 0;
+		rc = ne_add_vcpu(enclave_fd, &ne_vcpus[i]);
+		if (rc < 0) {
+			printf("Error in add vcpu, iter %d\n", i);
+
+			goto release_enclave_fd;
+		}
+
+		printf("Added vCPU %d to the enclave\n", ne_vcpus[i]);
+	}
+
+	printf("Enclave vCPUs were added\n");
+
+	rc = ioctl(enclave_fd, NE_START_ENCLAVE, &enclave_start_info);
+	if (rc < 0) {
+		switch (errno) {
+		case NE_ERR_NOT_IN_INIT_STATE: {
+			printf("Error in start enclave, enclave not in init state\n");
+
+			break;
+		}
+
+		case NE_ERR_NO_MEM_REGIONS_ADDED: {
+			printf("Error in start enclave, no memory regions have been added\n");
+
+			break;
+		}
+
+		case NE_ERR_NO_VCPUS_ADDED: {
+			printf("Error in start enclave, no vCPUs have been added\n");
+
+			break;
+		}
+
+		case NE_ERR_FULL_CORES_NOT_USED: {
+			printf("Error in start enclave, enclave has no full cores set\n");
+
+			break;
+		}
+
+		case NE_ERR_ENCLAVE_MEM_MIN_SIZE: {
+			printf("Error in start enclave, enclave memory is less than min size\n");
+
+			break;
+		}
+
+		default:
+			printf("Error in start enclave [rc=%s]\n", strerror(rc));
+		}
+
+		goto release_enclave_fd;
+	}
+
+	printf("Enclave started, CID %llu\n", enclave_start_info.enclave_cid);
+
+	/*
+	 * TODO: Check for enclave hearbeat after it has started to see if it
+	 * has booted. Update the heartbeat logic based on the latest updates
+	 * of the init process of an EIF.
+	 */
+
+	printf("Entering sleep for %d seconds ...\n", NE_SLEEP_TIME);
+
+	sleep(NE_SLEEP_TIME);
+
+	close(enclave_fd);
+
+	ne_free_mem_regions(ne_mem_regions);
+
+	exit(EXIT_SUCCESS);
+
+release_enclave_fd:
+	close(enclave_fd);
+	ne_free_mem_regions(ne_mem_regions);
+
+	exit(EXIT_FAILURE);
+}
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

