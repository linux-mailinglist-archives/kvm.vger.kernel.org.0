Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2E5215681
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 13:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgGFLjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 07:39:55 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:33553 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFLjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 07:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594035592; x=1625571592;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=W1GdcoTTV3EKwP0sATtzz4Ll6ZE31RVDtaLew4/uQVg=;
  b=E5asy6vAYcPuvissTHN53ozz0DsCGYP4c298GGfVm6xro3eD3np4BGX2
   yJ0cgnj87wEQ+xq220XIwXnjuAs3AUNYB2QjVYxF9uEzFygiE94LleueN
   1el5xUmW9M9YysJ4Pwz+W9gHWEpGOIQgjlHH7mrt+JMOuypT18T85jC0W
   4=;
IronPort-SDR: regmt3oP5o2Q8Ibb6AW3uMq/P9kZkRlxGKGGzowD/k3dP0M+ouJkMt6aicnVX3i6FwmNifkq+Y
 FoTDXeuH/1LA==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="40198860"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Jul 2020 11:39:50 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id AFBAEC05E3;
        Mon,  6 Jul 2020 11:39:48 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 11:39:45 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.156) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 11:39:37 +0000
Subject: Re: [PATCH v4 16/18] nitro_enclaves: Add sample for ioctl interface
 usage
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-17-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <e1278340-e5bb-062f-9353-b27329efdbf2@amazon.de>
Date:   Mon, 6 Jul 2020 13:39:34 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-17-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.156]
X-ClientProxiedBy: EX13D01UWB002.ant.amazon.com (10.43.161.136) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v3 -> v4
> =

> * Update usage details to match the updates in v4.
> * Update NE ioctl interface usage.
> =

> v2 -> v3
> =

> * Remove the include directory to use the uapi from the kernel.
> * Remove the GPL additional wording as SPDX-License-Identifier is
>    already in place.
> =

> v1 -> v2
> =

> * New in v2.
> ---
>   samples/nitro_enclaves/.gitignore        |   2 +
>   samples/nitro_enclaves/Makefile          |  16 +
>   samples/nitro_enclaves/ne_ioctl_sample.c | 520 +++++++++++++++++++++++
>   3 files changed, 538 insertions(+)
>   create mode 100644 samples/nitro_enclaves/.gitignore
>   create mode 100644 samples/nitro_enclaves/Makefile
>   create mode 100644 samples/nitro_enclaves/ne_ioctl_sample.c
> =

> diff --git a/samples/nitro_enclaves/.gitignore b/samples/nitro_enclaves/.=
gitignore
> new file mode 100644
> index 000000000000..827934129c90
> --- /dev/null
> +++ b/samples/nitro_enclaves/.gitignore
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0
> +ne_ioctl_sample
> diff --git a/samples/nitro_enclaves/Makefile b/samples/nitro_enclaves/Mak=
efile
> new file mode 100644
> index 000000000000..a3ec78fefb52
> --- /dev/null
> +++ b/samples/nitro_enclaves/Makefile
> @@ -0,0 +1,16 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> +
> +# Enclave lifetime management support for Nitro Enclaves (NE) - ioctl sa=
mple
> +# usage.
> +
> +.PHONY: all clean
> +
> +CFLAGS +=3D -Wall
> +
> +all:
> +	$(CC) $(CFLAGS) -o ne_ioctl_sample ne_ioctl_sample.c -lpthread
> +
> +clean:
> +	rm -f ne_ioctl_sample
> diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c b/samples/nitro_enc=
laves/ne_ioctl_sample.c
> new file mode 100644
> index 000000000000..572143d55d77
> --- /dev/null
> +++ b/samples/nitro_enclaves/ne_ioctl_sample.c
> @@ -0,0 +1,520 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserve=
d.
> + */
> +
> +/**
> + * Sample flow of using the ioctl interface provided by the Nitro Enclav=
es (NE)
> + * kernel driver.
> + *
> + * Usage
> + * -----
> + *
> + * Load the nitro_enclaves module, setting also the enclave CPU pool. The
> + * enclave CPUs need to be full cores from the same NUMA node. CPU 0 and=
 its
> + * siblings have to remain available for the primary / parent VM, so they
> + * cannot be included in the enclave CPU pool.
> + *
> + * See the cpu list section from the kernel documentation.
> + * https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.=
html
> + *
> + *	insmod drivers/virt/nitro_enclaves/nitro_enclaves.ko
> + *	lsmod
> + *
> + *	The CPU pool can be set at runtime, after the kernel module is loaded.
> + *
> + *	echo <cpu-list> > /sys/module/nitro_enclaves/parameters/ne_cpus
> + *
> + *	NUMA and CPU siblings information can be found using
> + *
> + *	lscpu
> + *	/proc/cpuinfo
> + *
> + * Check the online / offline CPU list. The CPUs from the pool should be
> + * offlined.
> + *
> + *	lscpu
> + *
> + * Check dmesg for any warnings / errors through the NE driver lifetime =
/ usage.
> + * The NE logs contain the "nitro_enclaves" or "pci 0000:00:02.0" patter=
n.
> + *
> + *	dmesg
> + *
> + * Setup hugetlbfs huge pages. The memory needs to be from the same NUMA=
 node as
> + * the enclave CPUs.
> + * https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt
> + *
> + *	echo <nr_hugepages> > /proc/sys/vm/nr_hugepages
> + *
> + *	or set the number of 2 MiB / 1 GiB hugepages using
> + *
> + *	/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> + *	/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> + *
> + *	In this example 256 hugepages of 2 MiB are used.
> + *
> + * Build and run the NE sample.
> + *
> + *	make -C samples/nitro_enclaves clean
> + *	make -C samples/nitro_enclaves
> + *	./samples/nitro_enclaves/ne_ioctl_sample <path_to_enclave_image>
> + *
> + * Unload the nitro_enclaves module.
> + *
> + *	rmmod nitro_enclaves
> + *	lsmod
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <poll.h>
> +#include <pthread.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <sys/eventfd.h>
> +#include <sys/mman.h>
> +#include <sys/socket.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +
> +#include <linux/nitro_enclaves.h>
> +#include <linux/vm_sockets.h>
> +
> +/* Nitro Enclaves (NE) misc device that provides the ioctl interface. */
> +#define NE_DEV_NAME "/dev/nitro_enclaves"
> +#define NE_EXPECTED_API_VERSION (1)
> +
> +/* Timeout in seconds / milliseconds for each poll event. */
> +#define NE_POLL_WAIT_TIME (60)
> +#define NE_POLL_WAIT_TIME_MS (NE_POLL_WAIT_TIME * 1000)
> +
> +/* Amount of time in seconds for the process to keep the enclave alive. =
*/
> +#define NE_SLEEP_TIME (300)
> +
> +/* Enclave vCPUs metadata. */
> +#define NE_DEFAULT_NR_VCPUS (2)
> +
> +/* Enclave memory metadata */
> +
> +/* Min memory size - 2 MiB */
> +#define NE_MIN_MEM_REGION_SIZE (2 * 1024 * 1024)
> +
> +/* 256 memory regions of 2 MiB */
> +#define NE_DEFAULT_NR_MEM_REGIONS (256)
> +
> +/* Vsock addressing for enclave image loading heartbeat. */
> +#define NE_IMAGE_LOAD_VSOCK_CID (3)
> +#define NE_IMAGE_LOAD_VSOCK_PORT (9000)
> +#define NE_IMAGE_LOAD_HEARTBEAT_VALUE (0xb7)
> +
> +struct ne_mem_region {
> +	void *mem_addr;
> +	size_t mem_size;
> +};
> +
> +struct ne_vcpu {
> +	int vcpu_fd;
> +	unsigned int vcpu_id;
> +};
> +
> +/* Thread function for polling the enclave fd. */
> +void *ne_poll_enclave_fd(void *data)
> +{
> +	int enclave_fd =3D *(int *)data;
> +	struct pollfd fds[1] =3D {};
> +	int i =3D 0;
> +	int rc =3D 0;
> +
> +	printf("Running from poll thread, enclave fd %d\n", enclave_fd);
> +
> +	fds[0].fd =3D enclave_fd;
> +	fds[0].events =3D POLLIN | POLLERR | POLLHUP;
> +
> +	/* Keep on polling until the current process is terminated. */
> +	while (1) {
> +		printf("[iter %d] Polling ...\n", i);
> +
> +		rc =3D poll(fds, 1, NE_POLL_WAIT_TIME_MS);
> +		if (rc < 0) {
> +			printf("Error in poll [%m]\n");
> +
> +			return NULL;
> +		}
> +
> +		i++;
> +
> +		if (!rc) {
> +			printf("Poll: %d seconds elapsed\n",
> +			       i * NE_POLL_WAIT_TIME);
> +
> +			continue;
> +		}
> +
> +		printf("Poll received value %d\n", fds[0].revents);
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Allocate memory region that will be used for the enclave. */
> +static int ne_alloc_mem_region(struct ne_mem_region *ne_mem_region)
> +{
> +	if (!ne_mem_region)
> +		return -EINVAL;
> +
> +	if (!ne_mem_region->mem_size)
> +		return -EINVAL;
> +
> +	ne_mem_region->mem_addr =3D mmap(NULL, ne_mem_region->mem_size,
> +				       PROT_READ | PROT_WRITE,
> +				       MAP_PRIVATE | MAP_ANONYMOUS |
> +				       MAP_HUGETLB, -1, 0);
> +	if (ne_mem_region->mem_addr =3D=3D MAP_FAILED) {
> +		printf("Error in mmap memory [%m]\n");
> +
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Place enclave image in enclave memory. */
> +static int ne_load_enclave_image(int enclave_fd,
> +	struct ne_mem_region ne_mem_regions[], char enclave_image_path[])
> +{
> +	struct ne_image_load_info image_load_info =3D {};
> +	int rc =3D 0;
> +
> +	if (enclave_fd < 0)
> +		return -EINVAL;
> +
> +	image_load_info.flags =3D NE_EIF_IMAGE;
> +
> +	rc =3D ioctl(enclave_fd, NE_GET_IMAGE_LOAD_INFO, &image_load_info);
> +	if (rc < 0) {
> +		printf("Error in get image load info [rc=3D%d]\n", rc);
> +
> +		return rc;
> +	}
> +
> +	printf("Enclave image offset in enclave memory is %lld\n",
> +	       image_load_info.memory_offset);
> +
> +	/*
> +	 * TODO: Copy enclave image in enclave memory starting from the given
> +	 * offset.
> +	 */

Just open and read into the buffer at the given offset? :)

> +
> +	return 0;
> +}
> +
> +/* Wait for a hearbeat from the enclave to check it has booted. */
> +static int ne_check_enclave_booted(void)
> +{
> +	struct sockaddr_vm client_vsock_addr =3D {};
> +	socklen_t client_vsock_len =3D sizeof(client_vsock_addr);
> +	struct pollfd fds[1] =3D {};
> +	int rc =3D 0;
> +	unsigned char recv_buf =3D 0;
> +	struct sockaddr_vm server_vsock_addr =3D {
> +		.svm_family =3D AF_VSOCK,
> +		.svm_cid =3D NE_IMAGE_LOAD_VSOCK_CID,
> +		.svm_port =3D NE_IMAGE_LOAD_VSOCK_PORT,
> +	};
> +	int server_vsock_fd =3D 0;
> +
> +	server_vsock_fd =3D socket(AF_VSOCK, SOCK_STREAM, 0);
> +	if (server_vsock_fd < 0) {
> +		rc =3D server_vsock_fd;
> +
> +		printf("Error in socket [rc=3D%d]\n", rc);
> +
> +		return rc;
> +	}
> +
> +	rc =3D bind(server_vsock_fd, (struct sockaddr *)&server_vsock_addr,
> +		  sizeof(server_vsock_addr));
> +	if (rc < 0) {
> +		printf("Error in bind [rc=3D%d]\n", rc);
> +
> +		goto out;
> +	}
> +
> +	rc =3D listen(server_vsock_fd, 1);
> +	if (rc < 0) {
> +		printf("Error in listen [rc=3D%d]\n", rc);
> +
> +		goto out;
> +	}
> +
> +	fds[0].fd =3D server_vsock_fd;
> +	fds[0].events =3D POLLIN;
> +
> +	rc =3D poll(fds, 1, NE_POLL_WAIT_TIME_MS);
> +	if (rc < 0) {
> +		printf("Error in poll [%m]\n");
> +
> +		goto out;
> +	}
> +
> +	if (!rc) {
> +		printf("Poll timeout, %d seconds elapsed\n", NE_POLL_WAIT_TIME);
> +
> +		rc =3D -ETIMEDOUT;
> +
> +		goto out;
> +	}
> +
> +	if ((fds[0].revents & POLLIN) =3D=3D 0) {
> +		printf("Poll received value %d\n", fds[0].revents);
> +
> +		rc =3D -EINVAL;
> +
> +		goto out;
> +	}
> +
> +	rc =3D accept(server_vsock_fd, (struct sockaddr *)&client_vsock_addr,
> +		    &client_vsock_len);
> +	if (rc < 0) {
> +		printf("Error in accept [rc=3D%d]\n", rc);
> +
> +		goto out;
> +	}
> +
> +	/*
> +	 * Read the heartbeat value that the init process in the enclave sends
> +	 * after vsock connect.
> +	 */
> +	rc =3D read(server_vsock_fd, &recv_buf, sizeof(recv_buf));
> +	if (rc < 0) {
> +		printf("Error in read [rc=3D%d]\n", rc);
> +
> +		goto out;
> +	}
> +
> +	if (rc !=3D sizeof(recv_buf) ||
> +	    recv_buf !=3D NE_IMAGE_LOAD_HEARTBEAT_VALUE) {
> +		printf("Read %d instead of %d\n", recv_buf,
> +		       NE_IMAGE_LOAD_HEARTBEAT_VALUE);
> +
> +		goto out;
> +	}
> +
> +	close(server_vsock_fd);
> +
> +	return 0;
> +
> +out:
> +	close(server_vsock_fd);
> +
> +	return rc;
> +}
> +
> +/* Set memory region for the given enclave. */
> +static int ne_set_mem_region(int enclave_fd, struct ne_mem_region ne_mem=
_region)
> +{
> +	struct ne_user_memory_region mem_region =3D {};
> +	int rc =3D 0;
> +
> +	if (enclave_fd < 0)
> +		return -EINVAL;
> +
> +	mem_region.memory_size =3D ne_mem_region.mem_size;
> +	mem_region.userspace_addr =3D (__u64)ne_mem_region.mem_addr;
> +
> +	rc =3D ioctl(enclave_fd, NE_SET_USER_MEMORY_REGION, &mem_region);
> +	if (rc < 0) {
> +		printf("Error in set user memory region [rc=3D%d]\n", rc);
> +
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Unmap all the memory regions that were set aside for the  enclave. */
> +static void ne_free_mem_regions(struct ne_mem_region ne_mem_regions[])
> +{
> +	unsigned int i =3D 0;
> +
> +	for (i =3D 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++)
> +		munmap(ne_mem_regions[i].mem_addr, ne_mem_regions[i].mem_size);
> +}
> +
> +/* Create enclave vCPU. */
> +static int ne_create_vcpu(int enclave_fd, struct ne_vcpu *ne_vcpu)
> +{
> +	if (enclave_fd < 0)
> +		return -EINVAL;
> +
> +	if (!ne_vcpu)
> +		return -EINVAL;
> +
> +	ne_vcpu->vcpu_fd =3D ioctl(enclave_fd, NE_CREATE_VCPU, &ne_vcpu->vcpu_i=
d);
> +	if (ne_vcpu->vcpu_fd < 0) {
> +		printf("Error in create vcpu [rc=3D%d]\n", ne_vcpu->vcpu_fd);
> +
> +		return ne_vcpu->vcpu_fd;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Release enclave vCPU fd(s). */
> +static void ne_release_vcpus(struct ne_vcpu ne_vcpus[])
> +{
> +	unsigned int i =3D 0;
> +
> +	for (i =3D 0; i < NE_DEFAULT_NR_VCPUS; i++)
> +		if (ne_vcpus[i].vcpu_fd > 0)
> +			close(ne_vcpus[i].vcpu_fd);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int enclave_fd =3D 0;
> +	char enclave_image_path[PATH_MAX] =3D {};
> +	struct ne_enclave_start_info enclave_start_info =3D {};
> +	unsigned int i =3D 0;
> +	int ne_api_version =3D 0;
> +	int ne_dev_fd =3D 0;
> +	struct ne_mem_region ne_mem_regions[NE_DEFAULT_NR_MEM_REGIONS] =3D {};
> +	struct ne_vcpu ne_vcpus[NE_DEFAULT_NR_VCPUS] =3D {};
> +	int rc =3D 0;
> +	unsigned long slot_uid =3D 0;
> +	pthread_t thread_id =3D 0;
> +
> +	if (argc !=3D 2) {
> +		printf("Usage: %s <path_to_enclave_image>\n", argv[0]);
> +
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	strncpy(enclave_image_path, argv[1], sizeof(enclave_image_path) - 1);

Why can you not just pass argv[1] as path?

> +
> +	ne_dev_fd =3D open(NE_DEV_NAME, O_RDWR | O_CLOEXEC);
> +	if (ne_dev_fd < 0) {
> +		printf("Error in open NE device [rc=3D%d]\n", ne_dev_fd);
> +
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	ne_api_version =3D ioctl(ne_dev_fd, NE_GET_API_VERSION);
> +	if (ne_api_version !=3D NE_EXPECTED_API_VERSION) {
> +		printf("Expected API version %d, provided API version %d\n",
> +		       NE_EXPECTED_API_VERSION, ne_api_version);
> +
> +		close(ne_dev_fd);
> +
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	printf("Creating enclave slot ...\n");
> +
> +	enclave_fd =3D ioctl(ne_dev_fd, NE_CREATE_VM, &slot_uid);
> +
> +	close(ne_dev_fd);
> +
> +	if (enclave_fd < 0) {
> +		printf("Error in create enclave slot [rc=3D%d]\n", enclave_fd);
> +
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	printf("Enclave fd %d\n", enclave_fd);
> +
> +	rc =3D pthread_create(&thread_id, NULL, ne_poll_enclave_fd,
> +			    (void *)&enclave_fd);
> +	if (rc < 0) {
> +		printf("Error in thread create [rc=3D%d]\n", rc);
> +
> +		close(enclave_fd);
> +
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	for (i =3D 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++) {
> +		ne_mem_regions[i].mem_size =3D NE_MIN_MEM_REGION_SIZE;
> +		rc =3D ne_alloc_mem_region(&ne_mem_regions[i]);
> +		if (rc < 0) {
> +			printf("Error in alloc mem region, iter %d [rc=3D%d]\n",
> +			       i, rc);
> +
> +			goto release_enclave_fd;
> +		}
> +	}
> +
> +	rc =3D ne_load_enclave_image(enclave_fd, ne_mem_regions,
> +				   enclave_image_path);
> +	if (rc < 0) {
> +		printf("Error in load enclave image [rc=3D%d]\n", rc);
> +
> +		goto release_enclave_fd;
> +	}
> +
> +	for (i =3D 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++) {
> +		rc =3D ne_set_mem_region(enclave_fd, ne_mem_regions[i]);
> +		if (rc < 0) {
> +			printf("Error in set mem region, iter %d [rc=3D%d]\n",
> +			       i, rc);
> +
> +			goto release_enclave_fd;
> +		}
> +	}
> +
> +	printf("Enclave memory regions were added\n");
> +
> +	for (i =3D 0; i < NE_DEFAULT_NR_VCPUS; i++) {
> +		/*
> +		 * The vCPU is chosen from the enclave vCPU pool, if the value
> +		 * of the vcpu_id is 0.
> +		 */
> +		ne_vcpus[i].vcpu_id =3D 0;
> +		rc =3D ne_create_vcpu(enclave_fd, &ne_vcpus[i]);
> +		if (rc < 0) {
> +			printf("Error in create vcpu, iter %d [rc=3D%d]\n",
> +			       i, rc);
> +
> +			goto release_enclave_vcpu_fds;
> +		}
> +	}
> +
> +	printf("Enclave vCPUs were created\n");
> +
> +	rc =3D ioctl(enclave_fd, NE_START_ENCLAVE, &enclave_start_info);
> +	if (rc < 0) {
> +		printf("Error in start enclave [rc=3D%d]\n", rc);
> +
> +		goto release_enclave_vcpu_fds;
> +	}
> +
> +	printf("Enclave started, CID %llu\n", enclave_start_info.enclave_cid);
> +
> +	/*
> +	 * TODO: Check for enclave hearbeat after it has started to see if it
> +	 * has booted.
> +	 */

So you wrote the function to check for the heartbeat, but don't call it? =

Why?


Alex

> +
> +	printf("Entering sleep for %d seconds ...\n", NE_SLEEP_TIME);
> +
> +	sleep(NE_SLEEP_TIME);
> +
> +	ne_release_vcpus(ne_vcpus);
> +
> +	close(enclave_fd);
> +
> +	ne_free_mem_regions(ne_mem_regions);
> +
> +	exit(EXIT_SUCCESS);
> +
> +release_enclave_vcpu_fds:
> +	ne_release_vcpus(ne_vcpus);
> +release_enclave_fd:
> +	close(enclave_fd);
> +	ne_free_mem_regions(ne_mem_regions);
> +
> +	exit(EXIT_FAILURE);
> +}
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



