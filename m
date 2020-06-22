Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03784204104
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgFVUGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:06:33 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2324 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730493AbgFVUGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856389; x=1624392389;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TsKb5HzPfmbI/WWpyOz/P0H1ryZtQH0GtYyffyttq2U=;
  b=BL85DMB5sLWkzZAwbeUuPEjssKAfLdmS9+26MNr+Q7kXDVtFmJig9iYt
   9fy7PnrhE3KdI8NUjheLUHDhZnNcaLuJppL0IaNgOz7wYJo78mc52Fvi3
   JxQeoC0CvecD7ujDSZFgR226iKn3nHgh941NeJE4Yd6/xw4g3hZOfKVl8
   k=;
IronPort-SDR: mJ8kCRifkb1MpLnDjk0m7FtgtjGBebHpH5VbDAp2cEzBjwsGsh6+Pkxuy8cIfjT7eYXMtfA3B3
 mVmcr7c5rYBQ==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="54282078"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 Jun 2020 20:06:28 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 4712BA25DD;
        Mon, 22 Jun 2020 20:06:28 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:06:27 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:06:18 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v4 16/18] nitro_enclaves: Add sample for ioctl interface usage
Date:   Mon, 22 Jun 2020 23:03:27 +0300
Message-ID: <20200622200329.52996-17-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200622200329.52996-1-andraprs@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D18UWA001.ant.amazon.com (10.43.160.11) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
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
 samples/nitro_enclaves/ne_ioctl_sample.c | 520 +++++++++++++++++++++++
 3 files changed, 538 insertions(+)
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
index 000000000000..572143d55d77
--- /dev/null
+++ b/samples/nitro_enclaves/ne_ioctl_sample.c
@@ -0,0 +1,520 @@
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
+ * https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
+ *
+ *	insmod drivers/virt/nitro_enclaves/nitro_enclaves.ko
+ *	lsmod
+ *
+ *	The CPU pool can be set at runtime, after the kernel module is loaded.
+ *
+ *	echo <cpu-list> > /sys/module/nitro_enclaves/parameters/ne_cpus
+ *
+ *	NUMA and CPU siblings information can be found using
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
+#include <sys/ioctl.h>
+#include <sys/eventfd.h>
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
+struct ne_vcpu {
+	int vcpu_fd;
+	unsigned int vcpu_id;
+};
+
+/* Thread function for polling the enclave fd. */
+void *ne_poll_enclave_fd(void *data)
+{
+	int enclave_fd = *(int *)data;
+	struct pollfd fds[1] = {};
+	int i = 0;
+	int rc = 0;
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
+	if (!ne_mem_region)
+		return -EINVAL;
+
+	if (!ne_mem_region->mem_size)
+		return -EINVAL;
+
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
+static int ne_load_enclave_image(int enclave_fd,
+	struct ne_mem_region ne_mem_regions[], char enclave_image_path[])
+{
+	struct ne_image_load_info image_load_info = {};
+	int rc = 0;
+
+	if (enclave_fd < 0)
+		return -EINVAL;
+
+	image_load_info.flags = NE_EIF_IMAGE;
+
+	rc = ioctl(enclave_fd, NE_GET_IMAGE_LOAD_INFO, &image_load_info);
+	if (rc < 0) {
+		printf("Error in get image load info [rc=%d]\n", rc);
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
+/* Wait for a hearbeat from the enclave to check it has booted. */
+static int ne_check_enclave_booted(void)
+{
+	struct sockaddr_vm client_vsock_addr = {};
+	socklen_t client_vsock_len = sizeof(client_vsock_addr);
+	struct pollfd fds[1] = {};
+	int rc = 0;
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
+		printf("Error in socket [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	rc = bind(server_vsock_fd, (struct sockaddr *)&server_vsock_addr,
+		  sizeof(server_vsock_addr));
+	if (rc < 0) {
+		printf("Error in bind [rc=%d]\n", rc);
+
+		goto out;
+	}
+
+	rc = listen(server_vsock_fd, 1);
+	if (rc < 0) {
+		printf("Error in listen [rc=%d]\n", rc);
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
+		printf("Error in accept [rc=%d]\n", rc);
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
+		printf("Error in read [rc=%d]\n", rc);
+
+		goto out;
+	}
+
+	if (rc != sizeof(recv_buf) ||
+	    recv_buf != NE_IMAGE_LOAD_HEARTBEAT_VALUE) {
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
+	int rc = 0;
+
+	if (enclave_fd < 0)
+		return -EINVAL;
+
+	mem_region.memory_size = ne_mem_region.mem_size;
+	mem_region.userspace_addr = (__u64)ne_mem_region.mem_addr;
+
+	rc = ioctl(enclave_fd, NE_SET_USER_MEMORY_REGION, &mem_region);
+	if (rc < 0) {
+		printf("Error in set user memory region [rc=%d]\n", rc);
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
+/* Create enclave vCPU. */
+static int ne_create_vcpu(int enclave_fd, struct ne_vcpu *ne_vcpu)
+{
+	if (enclave_fd < 0)
+		return -EINVAL;
+
+	if (!ne_vcpu)
+		return -EINVAL;
+
+	ne_vcpu->vcpu_fd = ioctl(enclave_fd, NE_CREATE_VCPU, &ne_vcpu->vcpu_id);
+	if (ne_vcpu->vcpu_fd < 0) {
+		printf("Error in create vcpu [rc=%d]\n", ne_vcpu->vcpu_fd);
+
+		return ne_vcpu->vcpu_fd;
+	}
+
+	return 0;
+}
+
+/* Release enclave vCPU fd(s). */
+static void ne_release_vcpus(struct ne_vcpu ne_vcpus[])
+{
+	unsigned int i = 0;
+
+	for (i = 0; i < NE_DEFAULT_NR_VCPUS; i++)
+		if (ne_vcpus[i].vcpu_fd > 0)
+			close(ne_vcpus[i].vcpu_fd);
+}
+
+int main(int argc, char *argv[])
+{
+	int enclave_fd = 0;
+	char enclave_image_path[PATH_MAX] = {};
+	struct ne_enclave_start_info enclave_start_info = {};
+	unsigned int i = 0;
+	int ne_api_version = 0;
+	int ne_dev_fd = 0;
+	struct ne_mem_region ne_mem_regions[NE_DEFAULT_NR_MEM_REGIONS] = {};
+	struct ne_vcpu ne_vcpus[NE_DEFAULT_NR_VCPUS] = {};
+	int rc = 0;
+	unsigned long slot_uid = 0;
+	pthread_t thread_id = 0;
+
+	if (argc != 2) {
+		printf("Usage: %s <path_to_enclave_image>\n", argv[0]);
+
+		exit(EXIT_FAILURE);
+	}
+
+	strncpy(enclave_image_path, argv[1], sizeof(enclave_image_path) - 1);
+
+	ne_dev_fd = open(NE_DEV_NAME, O_RDWR | O_CLOEXEC);
+	if (ne_dev_fd < 0) {
+		printf("Error in open NE device [rc=%d]\n", ne_dev_fd);
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
+		printf("Error in create enclave slot [rc=%d]\n", enclave_fd);
+
+		exit(EXIT_FAILURE);
+	}
+
+	printf("Enclave fd %d\n", enclave_fd);
+
+	rc = pthread_create(&thread_id, NULL, ne_poll_enclave_fd,
+			    (void *)&enclave_fd);
+	if (rc < 0) {
+		printf("Error in thread create [rc=%d]\n", rc);
+
+		close(enclave_fd);
+
+		exit(EXIT_FAILURE);
+	}
+
+	for (i = 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++) {
+		ne_mem_regions[i].mem_size = NE_MIN_MEM_REGION_SIZE;
+		rc = ne_alloc_mem_region(&ne_mem_regions[i]);
+		if (rc < 0) {
+			printf("Error in alloc mem region, iter %d [rc=%d]\n",
+			       i, rc);
+
+			goto release_enclave_fd;
+		}
+	}
+
+	rc = ne_load_enclave_image(enclave_fd, ne_mem_regions,
+				   enclave_image_path);
+	if (rc < 0) {
+		printf("Error in load enclave image [rc=%d]\n", rc);
+
+		goto release_enclave_fd;
+	}
+
+	for (i = 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++) {
+		rc = ne_set_mem_region(enclave_fd, ne_mem_regions[i]);
+		if (rc < 0) {
+			printf("Error in set mem region, iter %d [rc=%d]\n",
+			       i, rc);
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
+		ne_vcpus[i].vcpu_id = 0;
+		rc = ne_create_vcpu(enclave_fd, &ne_vcpus[i]);
+		if (rc < 0) {
+			printf("Error in create vcpu, iter %d [rc=%d]\n",
+			       i, rc);
+
+			goto release_enclave_vcpu_fds;
+		}
+	}
+
+	printf("Enclave vCPUs were created\n");
+
+	rc = ioctl(enclave_fd, NE_START_ENCLAVE, &enclave_start_info);
+	if (rc < 0) {
+		printf("Error in start enclave [rc=%d]\n", rc);
+
+		goto release_enclave_vcpu_fds;
+	}
+
+	printf("Enclave started, CID %llu\n", enclave_start_info.enclave_cid);
+
+	/*
+	 * TODO: Check for enclave hearbeat after it has started to see if it
+	 * has booted.
+	 */
+
+	printf("Entering sleep for %d seconds ...\n", NE_SLEEP_TIME);
+
+	sleep(NE_SLEEP_TIME);
+
+	ne_release_vcpus(ne_vcpus);
+
+	close(enclave_fd);
+
+	ne_free_mem_regions(ne_mem_regions);
+
+	exit(EXIT_SUCCESS);
+
+release_enclave_vcpu_fds:
+	ne_release_vcpus(ne_vcpus);
+release_enclave_fd:
+	close(enclave_fd);
+	ne_free_mem_regions(ne_mem_regions);
+
+	exit(EXIT_FAILURE);
+}
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

