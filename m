Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1F0217777
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 21:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgGGTDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 15:03:34 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:45843 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgGGTDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 15:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594148609; x=1625684609;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ju8Si6506FnDHJJi5+lbPtI586/+A90q2u1gmdR2jBE=;
  b=lJO09W3LM27taeotXlXDLn0RJ1IpsvRcLfPRy76OduVx4ekDVK+hRJnV
   uhBny+FEVe1cIfMtubd98jcdJU0zPrIJ1XrkG2P0XQsfagg7Vuc7RYlP6
   U+iy48LT0YtUPVRqoibtqYWqCRVv5mSW83ZSkqmc6v9AE9J62SWle37/K
   w=;
IronPort-SDR: APUr2FvP1z/oSknJGq0yi9s7ct7aE+XmyxNIhyyybhW5ANPOqQtNmvcdwYZJFuG+GbMay/eAD2
 TGO92/b9RvXA==
X-IronPort-AV: E=Sophos;i="5.75,324,1589241600"; 
   d="scan'208";a="49834421"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 07 Jul 2020 19:03:17 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 14165A1E9E;
        Tue,  7 Jul 2020 19:03:17 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 7 Jul 2020 19:03:16 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.203) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 7 Jul 2020 19:03:07 +0000
Subject: Re: [PATCH v4 16/18] nitro_enclaves: Add sample for ioctl interface
 usage
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
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
 <e1278340-e5bb-062f-9353-b27329efdbf2@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <6c4d6a08-6c16-b71a-12a5-0f02567f083d@amazon.com>
Date:   Tue, 7 Jul 2020 22:03:01 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e1278340-e5bb-062f-9353-b27329efdbf2@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D45UWB003.ant.amazon.com (10.43.161.67) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/07/2020 14:39, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v3 -> v4
>>
>> * Update usage details to match the updates in v4.
>> * Update NE ioctl interface usage.
>>
>> v2 -> v3
>>
>> * Remove the include directory to use the uapi from the kernel.
>> * Remove the GPL additional wording as SPDX-License-Identifier is
>> =A0=A0 already in place.
>>
>> v1 -> v2
>>
>> * New in v2.
>> ---
>> =A0 samples/nitro_enclaves/.gitignore=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +
>> =A0 samples/nitro_enclaves/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 16 +
>> =A0 samples/nitro_enclaves/ne_ioctl_sample.c | 520 +++++++++++++++++++++=
++
>> =A0 3 files changed, 538 insertions(+)
>> =A0 create mode 100644 samples/nitro_enclaves/.gitignore
>> =A0 create mode 100644 samples/nitro_enclaves/Makefile
>> =A0 create mode 100644 samples/nitro_enclaves/ne_ioctl_sample.c
>>
>> diff --git a/samples/nitro_enclaves/.gitignore =

>> b/samples/nitro_enclaves/.gitignore
>> new file mode 100644
>> index 000000000000..827934129c90
>> --- /dev/null
>> +++ b/samples/nitro_enclaves/.gitignore
>> @@ -0,0 +1,2 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +ne_ioctl_sample
>> diff --git a/samples/nitro_enclaves/Makefile =

>> b/samples/nitro_enclaves/Makefile
>> new file mode 100644
>> index 000000000000..a3ec78fefb52
>> --- /dev/null
>> +++ b/samples/nitro_enclaves/Makefile
>> @@ -0,0 +1,16 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights =

>> Reserved.
>> +
>> +# Enclave lifetime management support for Nitro Enclaves (NE) - =

>> ioctl sample
>> +# usage.
>> +
>> +.PHONY: all clean
>> +
>> +CFLAGS +=3D -Wall
>> +
>> +all:
>> +=A0=A0=A0 $(CC) $(CFLAGS) -o ne_ioctl_sample ne_ioctl_sample.c -lpthread
>> +
>> +clean:
>> +=A0=A0=A0 rm -f ne_ioctl_sample
>> diff --git a/samples/nitro_enclaves/ne_ioctl_sample.c =

>> b/samples/nitro_enclaves/ne_ioctl_sample.c
>> new file mode 100644
>> index 000000000000..572143d55d77
>> --- /dev/null
>> +++ b/samples/nitro_enclaves/ne_ioctl_sample.c
>> @@ -0,0 +1,520 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights =

>> Reserved.
>> + */
>> +
>> +/**
>> + * Sample flow of using the ioctl interface provided by the Nitro =

>> Enclaves (NE)
>> + * kernel driver.
>> + *
>> + * Usage
>> + * -----
>> + *
>> + * Load the nitro_enclaves module, setting also the enclave CPU =

>> pool. The
>> + * enclave CPUs need to be full cores from the same NUMA node. CPU 0 =

>> and its
>> + * siblings have to remain available for the primary / parent VM, so =

>> they
>> + * cannot be included in the enclave CPU pool.
>> + *
>> + * See the cpu list section from the kernel documentation.
>> + * =

>> https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
>> + *
>> + *=A0=A0=A0 insmod drivers/virt/nitro_enclaves/nitro_enclaves.ko
>> + *=A0=A0=A0 lsmod
>> + *
>> + *=A0=A0=A0 The CPU pool can be set at runtime, after the kernel module=
 is =

>> loaded.
>> + *
>> + *=A0=A0=A0 echo <cpu-list> > /sys/module/nitro_enclaves/parameters/ne_=
cpus
>> + *
>> + *=A0=A0=A0 NUMA and CPU siblings information can be found using
>> + *
>> + *=A0=A0=A0 lscpu
>> + *=A0=A0=A0 /proc/cpuinfo
>> + *
>> + * Check the online / offline CPU list. The CPUs from the pool =

>> should be
>> + * offlined.
>> + *
>> + *=A0=A0=A0 lscpu
>> + *
>> + * Check dmesg for any warnings / errors through the NE driver =

>> lifetime / usage.
>> + * The NE logs contain the "nitro_enclaves" or "pci 0000:00:02.0" =

>> pattern.
>> + *
>> + *=A0=A0=A0 dmesg
>> + *
>> + * Setup hugetlbfs huge pages. The memory needs to be from the same =

>> NUMA node as
>> + * the enclave CPUs.
>> + * https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt
>> + *
>> + *=A0=A0=A0 echo <nr_hugepages> > /proc/sys/vm/nr_hugepages
>> + *
>> + *=A0=A0=A0 or set the number of 2 MiB / 1 GiB hugepages using
>> + *
>> + *=A0=A0=A0 /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>> + *=A0=A0=A0 /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>> + *
>> + *=A0=A0=A0 In this example 256 hugepages of 2 MiB are used.
>> + *
>> + * Build and run the NE sample.
>> + *
>> + *=A0=A0=A0 make -C samples/nitro_enclaves clean
>> + *=A0=A0=A0 make -C samples/nitro_enclaves
>> + *=A0=A0=A0 ./samples/nitro_enclaves/ne_ioctl_sample <path_to_enclave_i=
mage>
>> + *
>> + * Unload the nitro_enclaves module.
>> + *
>> + *=A0=A0=A0 rmmod nitro_enclaves
>> + *=A0=A0=A0 lsmod
>> + */
>> +
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <limits.h>
>> +#include <poll.h>
>> +#include <pthread.h>
>> +#include <string.h>
>> +#include <sys/ioctl.h>
>> +#include <sys/eventfd.h>
>> +#include <sys/mman.h>
>> +#include <sys/socket.h>
>> +#include <sys/types.h>
>> +#include <unistd.h>
>> +
>> +#include <linux/nitro_enclaves.h>
>> +#include <linux/vm_sockets.h>
>> +
>> +/* Nitro Enclaves (NE) misc device that provides the ioctl =

>> interface. */
>> +#define NE_DEV_NAME "/dev/nitro_enclaves"
>> +#define NE_EXPECTED_API_VERSION (1)
>> +
>> +/* Timeout in seconds / milliseconds for each poll event. */
>> +#define NE_POLL_WAIT_TIME (60)
>> +#define NE_POLL_WAIT_TIME_MS (NE_POLL_WAIT_TIME * 1000)
>> +
>> +/* Amount of time in seconds for the process to keep the enclave =

>> alive. */
>> +#define NE_SLEEP_TIME (300)
>> +
>> +/* Enclave vCPUs metadata. */
>> +#define NE_DEFAULT_NR_VCPUS (2)
>> +
>> +/* Enclave memory metadata */
>> +
>> +/* Min memory size - 2 MiB */
>> +#define NE_MIN_MEM_REGION_SIZE (2 * 1024 * 1024)
>> +
>> +/* 256 memory regions of 2 MiB */
>> +#define NE_DEFAULT_NR_MEM_REGIONS (256)
>> +
>> +/* Vsock addressing for enclave image loading heartbeat. */
>> +#define NE_IMAGE_LOAD_VSOCK_CID (3)
>> +#define NE_IMAGE_LOAD_VSOCK_PORT (9000)
>> +#define NE_IMAGE_LOAD_HEARTBEAT_VALUE (0xb7)
>> +
>> +struct ne_mem_region {
>> +=A0=A0=A0 void *mem_addr;
>> +=A0=A0=A0 size_t mem_size;
>> +};
>> +
>> +struct ne_vcpu {
>> +=A0=A0=A0 int vcpu_fd;
>> +=A0=A0=A0 unsigned int vcpu_id;
>> +};
>> +
>> +/* Thread function for polling the enclave fd. */
>> +void *ne_poll_enclave_fd(void *data)
>> +{
>> +=A0=A0=A0 int enclave_fd =3D *(int *)data;
>> +=A0=A0=A0 struct pollfd fds[1] =3D {};
>> +=A0=A0=A0 int i =3D 0;
>> +=A0=A0=A0 int rc =3D 0;
>> +
>> +=A0=A0=A0 printf("Running from poll thread, enclave fd %d\n", enclave_f=
d);
>> +
>> +=A0=A0=A0 fds[0].fd =3D enclave_fd;
>> +=A0=A0=A0 fds[0].events =3D POLLIN | POLLERR | POLLHUP;
>> +
>> +=A0=A0=A0 /* Keep on polling until the current process is terminated. */
>> +=A0=A0=A0 while (1) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("[iter %d] Polling ...\n", i);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D poll(fds, 1, NE_POLL_WAIT_TIME_MS);
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("Error in poll [%m]\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 i++;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (!rc) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("Poll: %d seconds elapsed\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i * NE_POLL_WAIT=
_TIME);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Poll received value %d\n", fds[0].revents=
);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return NULL;
>> +}
>> +
>> +/* Allocate memory region that will be used for the enclave. */
>> +static int ne_alloc_mem_region(struct ne_mem_region *ne_mem_region)
>> +{
>> +=A0=A0=A0 if (!ne_mem_region)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +
>> +=A0=A0=A0 if (!ne_mem_region->mem_size)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +
>> +=A0=A0=A0 ne_mem_region->mem_addr =3D mmap(NULL, ne_mem_region->mem_siz=
e,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PROT=
_READ | PROT_WRITE,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MAP_=
PRIVATE | MAP_ANONYMOUS |
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MAP_=
HUGETLB, -1, 0);
>> +=A0=A0=A0 if (ne_mem_region->mem_addr =3D=3D MAP_FAILED) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in mmap memory [%m]\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -1;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/* Place enclave image in enclave memory. */
>> +static int ne_load_enclave_image(int enclave_fd,
>> +=A0=A0=A0 struct ne_mem_region ne_mem_regions[], char enclave_image_pat=
h[])
>> +{
>> +=A0=A0=A0 struct ne_image_load_info image_load_info =3D {};
>> +=A0=A0=A0 int rc =3D 0;
>> +
>> +=A0=A0=A0 if (enclave_fd < 0)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +
>> +=A0=A0=A0 image_load_info.flags =3D NE_EIF_IMAGE;
>> +
>> +=A0=A0=A0 rc =3D ioctl(enclave_fd, NE_GET_IMAGE_LOAD_INFO, &image_load_=
info);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in get image load info [rc=3D%d]\n"=
, rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 printf("Enclave image offset in enclave memory is %lld\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 image_load_info.memory_offset);
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * TODO: Copy enclave image in enclave memory starting from=
 the =

>> given
>> +=A0=A0=A0=A0 * offset.
>> +=A0=A0=A0=A0 */
>
> Just open and read into the buffer at the given offset? :)

Aham, there is no big complexity in this. :) I just wanted to have it =

together with the updated functionality on the heartbeat logic below.

>
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/* Wait for a hearbeat from the enclave to check it has booted. */
>> +static int ne_check_enclave_booted(void)
>> +{
>> +=A0=A0=A0 struct sockaddr_vm client_vsock_addr =3D {};
>> +=A0=A0=A0 socklen_t client_vsock_len =3D sizeof(client_vsock_addr);
>> +=A0=A0=A0 struct pollfd fds[1] =3D {};
>> +=A0=A0=A0 int rc =3D 0;
>> +=A0=A0=A0 unsigned char recv_buf =3D 0;
>> +=A0=A0=A0 struct sockaddr_vm server_vsock_addr =3D {
>> +=A0=A0=A0=A0=A0=A0=A0 .svm_family =3D AF_VSOCK,
>> +=A0=A0=A0=A0=A0=A0=A0 .svm_cid =3D NE_IMAGE_LOAD_VSOCK_CID,
>> +=A0=A0=A0=A0=A0=A0=A0 .svm_port =3D NE_IMAGE_LOAD_VSOCK_PORT,
>> +=A0=A0=A0 };
>> +=A0=A0=A0 int server_vsock_fd =3D 0;
>> +
>> +=A0=A0=A0 server_vsock_fd =3D socket(AF_VSOCK, SOCK_STREAM, 0);
>> +=A0=A0=A0 if (server_vsock_fd < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D server_vsock_fd;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in socket [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 rc =3D bind(server_vsock_fd, (struct sockaddr *)&server_vsock=
_addr,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(server_vsock_addr));
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in bind [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto out;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 rc =3D listen(server_vsock_fd, 1);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in listen [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto out;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 fds[0].fd =3D server_vsock_fd;
>> +=A0=A0=A0 fds[0].events =3D POLLIN;
>> +
>> +=A0=A0=A0 rc =3D poll(fds, 1, NE_POLL_WAIT_TIME_MS);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in poll [%m]\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto out;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if (!rc) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Poll timeout, %d seconds elapsed\n", =

>> NE_POLL_WAIT_TIME);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D -ETIMEDOUT;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto out;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if ((fds[0].revents & POLLIN) =3D=3D 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Poll received value %d\n", fds[0].revents=
);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto out;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 rc =3D accept(server_vsock_fd, (struct sockaddr *)&client_vso=
ck_addr,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &client_vsock_len);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in accept [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto out;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * Read the heartbeat value that the init process in the en=
clave =

>> sends
>> +=A0=A0=A0=A0 * after vsock connect.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 rc =3D read(server_vsock_fd, &recv_buf, sizeof(recv_buf));
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in read [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto out;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if (rc !=3D sizeof(recv_buf) ||
>> +=A0=A0=A0=A0=A0=A0=A0 recv_buf !=3D NE_IMAGE_LOAD_HEARTBEAT_VALUE) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Read %d instead of %d\n", recv_buf,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 NE_IMAGE_LOAD_HEARTBEAT_VALU=
E);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto out;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 close(server_vsock_fd);
>> +
>> +=A0=A0=A0 return 0;
>> +
>> +out:
>> +=A0=A0=A0 close(server_vsock_fd);
>> +
>> +=A0=A0=A0 return rc;
>> +}
>> +
>> +/* Set memory region for the given enclave. */
>> +static int ne_set_mem_region(int enclave_fd, struct ne_mem_region =

>> ne_mem_region)
>> +{
>> +=A0=A0=A0 struct ne_user_memory_region mem_region =3D {};
>> +=A0=A0=A0 int rc =3D 0;
>> +
>> +=A0=A0=A0 if (enclave_fd < 0)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +
>> +=A0=A0=A0 mem_region.memory_size =3D ne_mem_region.mem_size;
>> +=A0=A0=A0 mem_region.userspace_addr =3D (__u64)ne_mem_region.mem_addr;
>> +
>> +=A0=A0=A0 rc =3D ioctl(enclave_fd, NE_SET_USER_MEMORY_REGION, &mem_regi=
on);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in set user memory region [rc=3D%d]=
\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/* Unmap all the memory regions that were set aside for the enclave. */
>> +static void ne_free_mem_regions(struct ne_mem_region ne_mem_regions[])
>> +{
>> +=A0=A0=A0 unsigned int i =3D 0;
>> +
>> +=A0=A0=A0 for (i =3D 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++)
>> +=A0=A0=A0=A0=A0=A0=A0 munmap(ne_mem_regions[i].mem_addr, ne_mem_regions=
[i].mem_size);
>> +}
>> +
>> +/* Create enclave vCPU. */
>> +static int ne_create_vcpu(int enclave_fd, struct ne_vcpu *ne_vcpu)
>> +{
>> +=A0=A0=A0 if (enclave_fd < 0)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +
>> +=A0=A0=A0 if (!ne_vcpu)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +
>> +=A0=A0=A0 ne_vcpu->vcpu_fd =3D ioctl(enclave_fd, NE_CREATE_VCPU, =

>> &ne_vcpu->vcpu_id);
>> +=A0=A0=A0 if (ne_vcpu->vcpu_fd < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in create vcpu [rc=3D%d]\n", ne_vcp=
u->vcpu_fd);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return ne_vcpu->vcpu_fd;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/* Release enclave vCPU fd(s). */
>> +static void ne_release_vcpus(struct ne_vcpu ne_vcpus[])
>> +{
>> +=A0=A0=A0 unsigned int i =3D 0;
>> +
>> +=A0=A0=A0 for (i =3D 0; i < NE_DEFAULT_NR_VCPUS; i++)
>> +=A0=A0=A0=A0=A0=A0=A0 if (ne_vcpus[i].vcpu_fd > 0)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(ne_vcpus[i].vcpu_fd);
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +=A0=A0=A0 int enclave_fd =3D 0;
>> +=A0=A0=A0 char enclave_image_path[PATH_MAX] =3D {};
>> +=A0=A0=A0 struct ne_enclave_start_info enclave_start_info =3D {};
>> +=A0=A0=A0 unsigned int i =3D 0;
>> +=A0=A0=A0 int ne_api_version =3D 0;
>> +=A0=A0=A0 int ne_dev_fd =3D 0;
>> +=A0=A0=A0 struct ne_mem_region ne_mem_regions[NE_DEFAULT_NR_MEM_REGIONS=
] =3D =

>> {};
>> +=A0=A0=A0 struct ne_vcpu ne_vcpus[NE_DEFAULT_NR_VCPUS] =3D {};
>> +=A0=A0=A0 int rc =3D 0;
>> +=A0=A0=A0 unsigned long slot_uid =3D 0;
>> +=A0=A0=A0 pthread_t thread_id =3D 0;
>> +
>> +=A0=A0=A0 if (argc !=3D 2) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Usage: %s <path_to_enclave_image>\n", arg=
v[0]);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 exit(EXIT_FAILURE);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 strncpy(enclave_image_path, argv[1], sizeof(enclave_image_pat=
h) =

>> - 1);
>
> Why can you not just pass argv[1] as path?

I just wanted to limit to PATH_MAX size, but I can have this check on =

argv[1] and then pass it as path.

>
>> +
>> +=A0=A0=A0 ne_dev_fd =3D open(NE_DEV_NAME, O_RDWR | O_CLOEXEC);
>> +=A0=A0=A0 if (ne_dev_fd < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in open NE device [rc=3D%d]\n", ne_=
dev_fd);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 exit(EXIT_FAILURE);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 ne_api_version =3D ioctl(ne_dev_fd, NE_GET_API_VERSION);
>> +=A0=A0=A0 if (ne_api_version !=3D NE_EXPECTED_API_VERSION) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Expected API version %d, provided API ver=
sion %d\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 NE_EXPECTED_API_VERSION, ne_=
api_version);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 close(ne_dev_fd);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 exit(EXIT_FAILURE);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 printf("Creating enclave slot ...\n");
>> +
>> +=A0=A0=A0 enclave_fd =3D ioctl(ne_dev_fd, NE_CREATE_VM, &slot_uid);
>> +
>> +=A0=A0=A0 close(ne_dev_fd);
>> +
>> +=A0=A0=A0 if (enclave_fd < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in create enclave slot [rc=3D%d]\n"=
, enclave_fd);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 exit(EXIT_FAILURE);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 printf("Enclave fd %d\n", enclave_fd);
>> +
>> +=A0=A0=A0 rc =3D pthread_create(&thread_id, NULL, ne_poll_enclave_fd,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (void *)&enclave_fd);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in thread create [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 close(enclave_fd);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 exit(EXIT_FAILURE);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 for (i =3D 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++) {
>> +=A0=A0=A0=A0=A0=A0=A0 ne_mem_regions[i].mem_size =3D NE_MIN_MEM_REGION_=
SIZE;
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D ne_alloc_mem_region(&ne_mem_regions[i]);
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("Error in alloc mem region, it=
er %d [rc=3D%d]\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i, rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto release_enclave_fd;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 rc =3D ne_load_enclave_image(enclave_fd, ne_mem_regions,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enclave_image_pa=
th);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in load enclave image [rc=3D%d]\n",=
 rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto release_enclave_fd;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 for (i =3D 0; i < NE_DEFAULT_NR_MEM_REGIONS; i++) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D ne_set_mem_region(enclave_fd, ne_mem_regio=
ns[i]);
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("Error in set mem region, iter=
 %d [rc=3D%d]\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i, rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto release_enclave_fd;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 printf("Enclave memory regions were added\n");
>> +
>> +=A0=A0=A0 for (i =3D 0; i < NE_DEFAULT_NR_VCPUS; i++) {
>> +=A0=A0=A0=A0=A0=A0=A0 /*
>> +=A0=A0=A0=A0=A0=A0=A0=A0 * The vCPU is chosen from the enclave vCPU poo=
l, if the value
>> +=A0=A0=A0=A0=A0=A0=A0=A0 * of the vcpu_id is 0.
>> +=A0=A0=A0=A0=A0=A0=A0=A0 */
>> +=A0=A0=A0=A0=A0=A0=A0 ne_vcpus[i].vcpu_id =3D 0;
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D ne_create_vcpu(enclave_fd, &ne_vcpus[i]);
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("Error in create vcpu, iter %d=
 [rc=3D%d]\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i, rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto release_enclave_vcpu_fds;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 printf("Enclave vCPUs were created\n");
>> +
>> +=A0=A0=A0 rc =3D ioctl(enclave_fd, NE_START_ENCLAVE, &enclave_start_inf=
o);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 printf("Error in start enclave [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto release_enclave_vcpu_fds;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 printf("Enclave started, CID %llu\n", =

>> enclave_start_info.enclave_cid);
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * TODO: Check for enclave hearbeat after it has started to=
 see =

>> if it
>> +=A0=A0=A0=A0 * has booted.
>> +=A0=A0=A0=A0 */
>
> So you wrote the function to check for the heartbeat, but don't call =

> it? Why?
>

The logic flow (in the NE user space tooling, not from this sample) was =

in review at the time I added it here and recently has been updated. Now =

that we have completed the reviews, I will update this logic in the =

sample, together with including the enclave image loading in memory code =

bits mentioned above.

Thanks,
Andra

>
>> +
>> +=A0=A0=A0 printf("Entering sleep for %d seconds ...\n", NE_SLEEP_TIME);
>> +
>> +=A0=A0=A0 sleep(NE_SLEEP_TIME);
>> +
>> +=A0=A0=A0 ne_release_vcpus(ne_vcpus);
>> +
>> +=A0=A0=A0 close(enclave_fd);
>> +
>> +=A0=A0=A0 ne_free_mem_regions(ne_mem_regions);
>> +
>> +=A0=A0=A0 exit(EXIT_SUCCESS);
>> +
>> +release_enclave_vcpu_fds:
>> +=A0=A0=A0 ne_release_vcpus(ne_vcpus);
>> +release_enclave_fd:
>> +=A0=A0=A0 close(enclave_fd);
>> +=A0=A0=A0 ne_free_mem_regions(ne_mem_regions);
>> +
>> +=A0=A0=A0 exit(EXIT_FAILURE);
>> +}
>>




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

