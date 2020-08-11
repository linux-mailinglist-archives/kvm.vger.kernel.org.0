Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685D72417B8
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 09:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgHKH6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 03:58:39 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:3189 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgHKH6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 03:58:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597132717; x=1628668717;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nEZ2S9+iU8Xr5SMAvSEh7jW5n1wfR1rpnvqwKzudaBc=;
  b=fyaBW2sGvYxjYh3gge66GpS3Hu8XSXG0S2NkdbDJRpxuoC8ppY4UQGrx
   FlZr+86dHe4hZvOQkR3UPRFFwytaX4bVyDCR3u+Dd3y0c2sR2ifP/7Zva
   8XtLypdN3y3aj55MAKku/pHnTuuKr8uVkkQwqGCSP6kFjGqJKpeSTU2LP
   I=;
IronPort-SDR: 8BWAS7aEuJodA0twMOrnazGJTwkcygNt0ulgDY4RPpSn+DBRYKpN08Oft+A/uX3AyHjKTUwfo8
 XerRW+9M0jpQ==
X-IronPort-AV: E=Sophos;i="5.75,460,1589241600"; 
   d="scan'208";a="47249969"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 11 Aug 2020 07:58:34 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 638DDA1C3A;
        Tue, 11 Aug 2020 07:58:32 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 Aug 2020 07:58:31 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 Aug 2020 07:58:21 +0000
Subject: Re: [PATCH v6 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Alexander Graf <graf@amazon.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
 <20200805091017.86203-8-andraprs@amazon.com>
 <a27b4997-12a5-46e7-de81-41ec2b550fc2@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <08fe3dc4-5849-e5b5-260e-31c0c70790d6@amazon.com>
Date:   Tue, 11 Aug 2020 10:58:11 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <a27b4997-12a5-46e7-de81-41ec2b550fc2@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D32UWB003.ant.amazon.com (10.43.161.220) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/08/2020 08:22, Alexander Graf wrote:
>
>
> On 05.08.20 11:10, Andra Paraschiv wrote:
>> The Nitro Enclaves driver provides an ioctl interface to the user space
>> for enclave lifetime management e.g. enclave creation / termination and
>> setting enclave resources such as memory and CPU.
>>
>> This ioctl interface is mapped to a Nitro Enclaves misc device.
>>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v5 -> v6
>>
>> * Remove the ioctl to query API version.
>> * Update documentation to kernel-doc format.
>>
>> v4 -> v5
>>
>> * Update the size of the NE CPU pool string from 4096 to 512 chars.
>>
>> v3 -> v4
>>
>> * Use dev_err instead of custom NE log pattern.
>> * Remove the NE CPU pool init during kernel module loading, as the CPU
>> =A0=A0 pool is now setup at runtime, via a sysfs file for the kernel
>> =A0=A0 parameter.
>> * Add minimum enclave memory size definition.
>>
>> v2 -> v3
>>
>> * Remove the GPL additional wording as SPDX-License-Identifier is
>> =A0=A0 already in place.
>> * Remove the WARN_ON calls.
>> * Remove linux/bug and linux/kvm_host includes that are not needed.
>> * Remove "ratelimited" from the logs that are not in the ioctl call
>> =A0=A0 paths.
>> * Remove file ops that do nothing for now - open and release.
>>
>> v1 -> v2
>>
>> * Add log pattern for NE.
>> * Update goto labels to match their purpose.
>> * Update ne_cpu_pool data structure to include the global mutex.
>> * Update NE misc device mode to 0660.
>> * Check if the CPU siblings are included in the NE CPU pool, as full CPU
>> =A0=A0 cores are given for the enclave(s).
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 121 ++++++++++++++++++++=
++
>> =A0 drivers/virt/nitro_enclaves/ne_pci_dev.c=A0 |=A0 11 ++
>> =A0 2 files changed, 132 insertions(+)
>> =A0 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> new file mode 100644
>> index 000000000000..472850250220
>> --- /dev/null
>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> @@ -0,0 +1,121 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights =

>> Reserved.
>> + */
>> +
>> +/**
>> + * DOC: Enclave lifetime management driver for Nitro Enclaves (NE).
>> + * Nitro is a hypervisor that has been developed by Amazon.
>> + */
>> +
>> +#include <linux/anon_inodes.h>
>> +#include <linux/capability.h>
>> +#include <linux/cpu.h>
>> +#include <linux/device.h>
>> +#include <linux/file.h>
>> +#include <linux/hugetlb.h>
>> +#include <linux/list.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/mm.h>
>> +#include <linux/mman.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/nitro_enclaves.h>
>> +#include <linux/pci.h>
>> +#include <linux/poll.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +
>> +#include "ne_misc_dev.h"
>> +#include "ne_pci_dev.h"
>> +
>> +/**
>> + * NE_CPUS_SIZE - Size for max 128 CPUs, for now, in a cpu-list =

>> string, comma
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0 separated. The NE CPU pool includes CPUs =
from a single NUMA
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0 node.
>> + */
>> +#define NE_CPUS_SIZE=A0=A0=A0=A0=A0=A0=A0 (512)
>> +
>> +/**
>> + * NE_EIF_LOAD_OFFSET - The offset where to copy the Enclave Image =

>> Format (EIF)
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 image in enclave memory.
>> + */
>> +#define NE_EIF_LOAD_OFFSET=A0=A0=A0 (8 * 1024UL * 1024UL)
>> +
>> +/**
>> + * NE_MIN_ENCLAVE_MEM_SIZE - The minimum memory size an enclave can =

>> be launched
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 with.
>> + */
>> +#define NE_MIN_ENCLAVE_MEM_SIZE=A0=A0=A0 (64 * 1024UL * 1024UL)
>> +
>> +/**
>> + * NE_MIN_MEM_REGION_SIZE - The minimum size of an enclave memory =

>> region.
>> + */
>> +#define NE_MIN_MEM_REGION_SIZE=A0=A0=A0 (2 * 1024UL * 1024UL)
>> +
>> +/*
>> + * TODO: Update logic to create new sysfs entries instead of using
>> + * a kernel parameter e.g. if multiple sysfs files needed.
>> + */
>> +static const struct kernel_param_ops ne_cpu_pool_ops =3D {
>> +=A0=A0=A0 .get=A0=A0=A0 =3D param_get_string,
>> +};
>> +
>> +static char ne_cpus[NE_CPUS_SIZE];
>> +static struct kparam_string ne_cpus_arg =3D {
>> +=A0=A0=A0 .maxlen=A0=A0=A0 =3D sizeof(ne_cpus),
>> +=A0=A0=A0 .string=A0=A0=A0 =3D ne_cpus,
>> +};
>> +
>> +module_param_cb(ne_cpus, &ne_cpu_pool_ops, &ne_cpus_arg, 0644);
>> +/* =

>> https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.htm=
l#cpu-lists =

>> */
>> +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro =

>> Enclaves");
>> +
>> +/**
>> + * struct ne_cpu_pool - CPU pool used for Nitro Enclaves.
>> + * @avail_cores:=A0=A0=A0 Available CPU cores in the pool.
>> + * @avail_cores_size:=A0=A0=A0 The size of the available cores array.
>> + * @mutex:=A0=A0=A0=A0=A0=A0=A0 Mutex for the access to the NE CPU pool.
>> + * @numa_node:=A0=A0=A0=A0=A0=A0=A0 NUMA node of the CPUs in the pool.
>> + */
>> +struct ne_cpu_pool {
>> +=A0=A0=A0 cpumask_var_t=A0=A0=A0 *avail_cores;
>> +=A0=A0=A0 unsigned int=A0=A0=A0 avail_cores_size;
>> +=A0=A0=A0 struct mutex=A0=A0=A0 mutex;
>> +=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0 numa_node;
>> +};
>> +
>> +static struct ne_cpu_pool ne_cpu_pool;
>> +
>> +static const struct file_operations ne_fops =3D {
>> +=A0=A0=A0 .owner=A0=A0=A0=A0=A0=A0=A0 =3D THIS_MODULE,
>> +=A0=A0=A0 .llseek=A0=A0=A0=A0=A0=A0=A0 =3D noop_llseek,
>> +};
>> +
>> +struct miscdevice ne_misc_dev =3D {
>> +=A0=A0=A0 .minor=A0=A0=A0 =3D MISC_DYNAMIC_MINOR,
>> +=A0=A0=A0 .name=A0=A0=A0 =3D "nitro_enclaves",
>> +=A0=A0=A0 .fops=A0=A0=A0 =3D &ne_fops,
>> +=A0=A0=A0 .mode=A0=A0=A0 =3D 0660,
>> +};
>> +
>> +static int __init ne_init(void)
>> +{
>> +=A0=A0=A0 mutex_init(&ne_cpu_pool.mutex);
>> +
>> +=A0=A0=A0 return pci_register_driver(&ne_pci_driver);
>> +}
>> +
>> +static void __exit ne_exit(void)
>> +{
>> +=A0=A0=A0 pci_unregister_driver(&ne_pci_driver);
>> +}
>> +
>> +/* TODO: Handle actions such as reboot, kexec. */
>> +
>> +module_init(ne_init);
>> +module_exit(ne_exit);
>> +
>> +MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
>> +MODULE_DESCRIPTION("Nitro Enclaves Driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> index a898fae066d9..1e434bf44c9d 100644
>> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> @@ -527,6 +527,13 @@ static int ne_pci_probe(struct pci_dev *pdev, =

>> const struct pci_device_id *id)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 goto teardown_msix;
>> =A0=A0=A0=A0=A0 }
>> =A0 +=A0=A0=A0 rc =3D misc_register(&ne_misc_dev);
>
> If you set ne_misc_dev.parent to &pdev->dev, you can establish a full =

> device path connection between the device node and the underlying NE =

> PCI device. That means that in the ioctl path, you can also just =

> access the device rather than search for it.
>
>

Thanks, that's a good option. I'll include this in v7.

Andra

>
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Error in misc dev register [=
rc=3D%d]\n", =

>> rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto disable_ne_pci_dev;
>> +=A0=A0=A0 }
>> +
>> =A0=A0=A0=A0=A0 atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
>> =A0=A0=A0=A0=A0 init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
>> =A0=A0=A0=A0=A0 INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
>> @@ -536,6 +543,8 @@ static int ne_pci_probe(struct pci_dev *pdev, =

>> const struct pci_device_id *id)
>> =A0 =A0=A0=A0=A0=A0 return 0;
>> =A0 +disable_ne_pci_dev:
>> +=A0=A0=A0 ne_pci_dev_disable(pdev);
>> =A0 teardown_msix:
>> =A0=A0=A0=A0=A0 ne_teardown_msix(pdev);
>> =A0 iounmap_pci_bar:
>> @@ -561,6 +570,8 @@ static void ne_pci_remove(struct pci_dev *pdev)
>> =A0 {
>> =A0=A0=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> =A0 +=A0=A0=A0 misc_deregister(&ne_misc_dev);
>> +
>> =A0=A0=A0=A0=A0 ne_pci_dev_disable(pdev);
>> =A0 =A0=A0=A0=A0=A0 ne_teardown_msix(pdev);
>>




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

