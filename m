Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD61E17C3
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 00:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389025AbgEYWRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 18:17:10 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:34807 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388182AbgEYWRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 18:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590445026; x=1621981026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c/cTypHEYh5qpqY4wuLuDN7b5EBQS/5U9gBEF+dmWYY=;
  b=kC00QH9E8LUoCDuz719E2+dydbLBajftWbwUWAxtBuYtYZCXgHvPHXDB
   aay2ajje65cpQGalGDgN2F0HCop1ROtSBdTMPAx4Frt0AOwRdQdw/d/mb
   gjZVcKbUjEsFWDPG78YYYl7XdLF7XyiuzgO8hB+4Xmp79hkYt4Z+c0S5d
   8=;
IronPort-SDR: GioKXtH6Irn4i/1tKOeFVpT5gDDFRa/dAU8RY6mfaXPaMhS8AQ+jDuAv0iBFDDrMqHdZ+H8jAp
 cwQiKEP2lqCA==
X-IronPort-AV: E=Sophos;i="5.73,435,1583193600"; 
   d="scan'208";a="32053636"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 25 May 2020 22:17:05 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 4C39FA2858;
        Mon, 25 May 2020 22:17:04 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:17:03 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:16:18 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v3 16/18] nitro_enclaves: Add sample for ioctl interface usage
Date:   Tue, 26 May 2020 01:13:32 +0300
Message-ID: <20200525221334.62966-17-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200525221334.62966-1-andraprs@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D25UWC004.ant.amazon.com (10.43.162.201) To
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

v2 -> v3

* Remove the include directory to use the uapi from the kernel.
* Remove the GPL additional wording as SPDX-License-Identifier is already in
place.

v1 -> v2

* New in v2.
---
 samples/nitro_enclaves/.gitignore        |   2 +
 samples/nitro_enclaves/Makefile          |  16 +
 samples/nitro_enclaves/ne_ioctl_sample.c | 490 +++++++++++++++++++++++
 3 files changed, 508 insertions(+)
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
index 000000000000..ad5595acc012
--- /dev/null
+++ b/samples/nitro_enclaves/ne_ioctl_sample.c
@@ -0,0 +1,490 @@
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
+ * Load the nitro_enclaves module, setting also the enclave CPU pool.
+ *
+ * See the cpu list section from the kernel documentation.
+ * https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
+ *
+ *	insmod drivers/virt/nitro_enclaves/nitro_enclaves.ko ne_cpus=<cpu-list>
+ *	lsmod
+ *
+ * Check dmesg for any warnings / errors through the NE driver lifetime / usage.
+ * The NE logs contain the "nitro_enclaves" pattern.
+ *
+ *	dmesg
+ *
+ * Check the online / offline CPU list. The CPUs from the pool should be
+ * offlined.
+ *
+ *	lscpu
+ *
+ * Setup hugetlbfs huge pages.
+ *
+ *	echo <nr_hugepages> > /proc/sys/vm/nr_hugepages
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
+
+/* Timeout in seconds / milliseconds for each poll event. */
+#define POLL_WAIT_TIME (60)
+#define POLL_WAIT_TIME_MS (POLL_WAIT_TIME * 1000)
+
+/* Amount of time in seconds for the process to keep the enclave alive. */
+#define SLEEP_TIME (300)
+
+/* Enclave vCPUs metadata. */
+#define DEFAULT_NR_VCPUS (2)
+
+/* Enclave memory metadata */
+/* Min memory size - 2 MiB */
+#define MIN_MEM_REGION_SIZE (2 * 1024 * 1024)
+/* 256 memory regions of 2 MiB */
+#define DEFAULT_NR_MEM_REGIONS (256)
+
+/* Vsock addressing for enclave image loading heartbeat. */
+#define VSOCK_CID (3)
+#define VSOCK_PORT (9000)
+#define HEARTBEAT_VALUE (0xb7)
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
+		rc = poll(fds, 1, POLL_WAIT_TIME_MS);
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
+			       i * POLL_WAIT_TIME);
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
+int ne_alloc_mem_region(struct ne_mem_region *ne_mem_region)
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
+int ne_load_enclave_image(int enclave_fd, struct ne_mem_region ne_mem_regions[],
+			  char enclave_image_path[])
+{
+	struct image_load_metadata image_load_metadata = {};
+	int rc = 0;
+
+	if (enclave_fd < 0)
+		return -EINVAL;
+
+	/* TODO: Set flags based on enclave image type. */
+	image_load_metadata.flags = 0;
+
+	rc = ioctl(enclave_fd, NE_GET_IMAGE_LOAD_METADATA,
+		   &image_load_metadata);
+	if (rc < 0) {
+		printf("Error in get image load metadata [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	printf("Enclave image offset in enclave memory is %lld\n",
+	       image_load_metadata.memory_offset);
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
+int ne_check_enclave_booted(void)
+{
+	struct sockaddr_vm client_vsock_addr = {};
+	socklen_t client_vsock_len = sizeof(client_vsock_addr);
+	struct pollfd fds[1] = {};
+	int rc = 0;
+	unsigned char recv_buf = 0;
+	struct sockaddr_vm server_vsock_addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = VSOCK_CID,
+		.svm_port = VSOCK_PORT,
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
+	rc = poll(fds, 1, POLL_WAIT_TIME_MS);
+	if (rc < 0) {
+		printf("Error in poll [%m]\n");
+
+		goto out;
+	}
+
+	if (!rc) {
+		printf("Poll timeout, %d seconds elapsed\n", POLL_WAIT_TIME);
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
+	if (rc != sizeof(recv_buf) || recv_buf != HEARTBEAT_VALUE) {
+		printf("Read %d instead of %d\n", recv_buf, HEARTBEAT_VALUE);
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
+int ne_set_mem_region(int enclave_fd, struct ne_mem_region ne_mem_region)
+{
+	struct kvm_userspace_memory_region mem_region = {};
+	int rc = 0;
+
+	if (enclave_fd < 0)
+		return -EINVAL;
+
+	mem_region.slot = 0;
+	mem_region.memory_size = ne_mem_region.mem_size;
+	mem_region.userspace_addr = (__u64)ne_mem_region.mem_addr;
+	mem_region.guest_phys_addr = 0;
+
+	rc = ioctl(enclave_fd, KVM_SET_USER_MEMORY_REGION, &mem_region);
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
+void ne_free_mem_regions(struct ne_mem_region ne_mem_regions[])
+{
+	unsigned int i = 0;
+
+	for (i = 0; i < DEFAULT_NR_MEM_REGIONS; i++)
+		munmap(ne_mem_regions[i].mem_addr, ne_mem_regions[i].mem_size);
+}
+
+/* Create enclave vCPU. */
+int ne_create_vcpu(int enclave_fd, struct ne_vcpu *ne_vcpu)
+{
+	if (enclave_fd < 0)
+		return -EINVAL;
+
+	if (!ne_vcpu)
+		return -EINVAL;
+
+	ne_vcpu->vcpu_fd = ioctl(enclave_fd, KVM_CREATE_VCPU,
+				 &ne_vcpu->vcpu_id);
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
+void ne_release_vcpus(struct ne_vcpu ne_vcpus[])
+{
+	unsigned int i = 0;
+
+	for (i = 0; i < DEFAULT_NR_VCPUS; i++)
+		if (ne_vcpus[i].vcpu_fd > 0)
+			close(ne_vcpus[i].vcpu_fd);
+}
+
+int main(int argc, char *argv[])
+{
+	int enclave_fd = 0;
+	char enclave_image_path[PATH_MAX] = {};
+	unsigned int i = 0;
+	int ne_dev_fd = 0;
+	struct ne_mem_region ne_mem_regions[DEFAULT_NR_MEM_REGIONS] = {};
+	struct enclave_start_metadata ne_start_metadata = {};
+	struct ne_vcpu ne_vcpus[DEFAULT_NR_VCPUS] = {};
+	int rc = 0;
+	pthread_t thread_id = 0;
+	unsigned long type = 0;
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
+	printf("Creating enclave slot ...\n");
+
+	enclave_fd = ioctl(ne_dev_fd, KVM_CREATE_VM, &type);
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
+	for (i = 0; i < DEFAULT_NR_MEM_REGIONS; i++) {
+		ne_mem_regions[i].mem_size = MIN_MEM_REGION_SIZE;
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
+	for (i = 0; i < DEFAULT_NR_MEM_REGIONS; i++) {
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
+	for (i = 0; i < DEFAULT_NR_VCPUS; i++) {
+		/*
+		 * The vCPU is chosen from the enclave vCPU pool, this value is
+		 * not used for now.
+		 */
+		ne_vcpus[i].vcpu_id = i;
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
+	rc = ioctl(enclave_fd, NE_START_ENCLAVE, &ne_start_metadata);
+	if (rc < 0) {
+		printf("Error in start enclave [rc=%d]\n", rc);
+
+		goto release_enclave_vcpu_fds;
+	}
+
+	printf("Enclave started, CID %llu\n", ne_start_metadata.enclave_cid);
+
+	/*
+	 * TODO: Check for enclave hearbeat after it has started to see if it
+	 * has booted.
+	 */
+
+	printf("Entering sleep for %d seconds ...\n", SLEEP_TIME);
+
+	sleep(SLEEP_TIME);
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

