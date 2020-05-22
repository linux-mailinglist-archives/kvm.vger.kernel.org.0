Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592781DDFF6
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgEVGcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:32:46 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:8476 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgEVGcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129162; x=1621665162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W2HeL6GA33boG647C+EUOE88cN/TGT0BZmVgBkDhBVQ=;
  b=j5FLe8FPjWOQbuqXV13e2BIwwIylnQIMclI0P2mqkAAT4CyTJO/Xmalb
   zBnygtamtwh94qPFnABmM6WYtLdfkVDh5TO2FT/nh/kdCHEVk/Vb7pnAs
   YHdnYQjIgkHkuNlUIky0T090lUS7v52smnk71Q4Ldf06f4c2iVmii0VrR
   U=;
IronPort-SDR: G9bQ4eJc3uLuc/03isqzi4eu6fgjVewIBp+aNGXwk6tqv9hr50vw5acgyMSS7hmBVRNj7A9aDu
 swTl9b7dN0pw==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="46675166"
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 May 2020 06:32:41 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 8A873141809;
        Fri, 22 May 2020 06:32:39 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:32:39 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:32:29 +0000
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
Subject: [PATCH v2 16/18] nitro_enclaves: Add sample for ioctl interface usage
Date:   Fri, 22 May 2020 09:29:44 +0300
Message-ID: <20200522062946.28973-17-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200522062946.28973-1-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
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
 samples/nitro_enclaves/.gitignore             |   2 +
 samples/nitro_enclaves/Makefile               |  28 +
 .../include/linux/nitro_enclaves.h            |  23 +
 .../include/uapi/linux/nitro_enclaves.h       |  77 +++
 samples/nitro_enclaves/ne_ioctl_sample.c      | 502 ++++++++++++++++++
 5 files changed, 632 insertions(+)
 create mode 100644 samples/nitro_enclaves/.gitignore
 create mode 100644 samples/nitro_enclaves/Makefile
 create mode 100644 samples/nitro_enclaves/include/linux/nitro_enclaves.h
 create mode 100644 samples/nitro_enclaves/include/uapi/linux/nitro_enclaves.h
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
index 000000000000..2acdc6e0c492
--- /dev/null
+++ b/samples/nitro_enclaves/Makefile
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, see <http://www.gnu.org/licenses/>.
+
+# Enclave lifetime management support for Nitro Enclaves (NE) - ioctl sample
+# usage.
+
+.PHONY: all clean
+
+CFLAGS += -Wall -Iinclude/
+
+all:
+	$(CC) $(CFLAGS) -o ne_ioctl_sample ne_ioctl_sample.c -lpthread
+
+clean:
+	rm -f ne_ioctl_sample
diff --git a/samples/nitro_enclaves/include/linux/nitro_enclaves.h b/samples/nitro_enclaves/include/linux/nitro_enclaves.h
new file mode 100644
index 000000000000..7e593a9fbf8c
--- /dev/null
+++ b/samples/nitro_enclaves/include/linux/nitro_enclaves.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _LINUX_NITRO_ENCLAVES_H_
+#define _LINUX_NITRO_ENCLAVES_H_
+
+#include <uapi/linux/nitro_enclaves.h>
+
+#endif /* _LINUX_NITRO_ENCLAVES_H_ */
diff --git a/samples/nitro_enclaves/include/uapi/linux/nitro_enclaves.h b/samples/nitro_enclaves/include/uapi/linux/nitro_enclaves.h
new file mode 100644
index 000000000000..98ba59f15b52
--- /dev/null
+++ b/samples/nitro_enclaves/include/uapi/linux/nitro_enclaves.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
+#define _UAPI_LINUX_NITRO_ENCLAVES_H_
+
+#include <linux/kvm.h>
+#include <linux/types.h>
+
+/* Nitro Enclaves (NE) Kernel Driver Interface */
+
+/**
+ * The command is used to get information needed for in-memory enclave image
+ * loading e.g. offset in enclave memory to start placing the enclave image.
+ *
+ * The image load metadata is an in / out data structure. It includes info
+ * provided by the caller - flags - and returns the offset in enclave memory
+ * where to start placing the enclave image.
+ */
+#define NE_GET_IMAGE_LOAD_METADATA _IOWR(0xAE, 0x20, struct image_load_metadata)
+
+/**
+ * The command is used to trigger enclave start after the enclave resources,
+ * such as memory and CPU, have been set.
+ *
+ * The enclave start metadata is an in / out data structure. It includes info
+ * provided by the caller - enclave cid and flags - and returns the slot uid
+ * and the cid (if input cid is 0).
+ */
+#define NE_START_ENCLAVE _IOWR(0xAE, 0x21, struct enclave_start_metadata)
+
+/* Metadata necessary for in-memory enclave image loading. */
+struct image_load_metadata {
+	/**
+	 * Flags to determine the enclave image type e.g. Enclave Image Format
+	 * (EIF) (in).
+	 */
+	__u64 flags;
+
+	/**
+	 * Offset in enclave memory where to start placing the enclave image
+	 * (out).
+	 */
+	__u64 memory_offset;
+};
+
+/* Setup metadata necessary for enclave start. */
+struct enclave_start_metadata {
+	/* Flags for the enclave to start with (e.g. debug mode) (in). */
+	__u64 flags;
+
+	/**
+	 * Context ID (CID) for the enclave vsock device. If 0 as input, the
+	 * CID is autogenerated by the hypervisor and returned back as output
+	 * by the driver (in/out).
+	 */
+	__u64 enclave_cid;
+
+	/* Slot unique id mapped to the enclave to start (out). */
+	__u64 slot_uid;
+};
+
+#endif /* _UAPI_LINUX_NITRO_ENCLAVES_H_ */
diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enclaves/ne_ioctl_sample.c
new file mode 100644
index 000000000000..c9a164b7193e
--- /dev/null
+++ b/samples/nitro_enclaves/ne_ioctl_sample.c
@@ -0,0 +1,502 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
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

