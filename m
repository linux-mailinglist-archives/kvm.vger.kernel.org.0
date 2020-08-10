Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202B22401B7
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 07:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgHJFWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 01:22:19 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:40764 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgHJFWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 01:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1597036937; x=1628572937;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=J5YEslmwcry31TaEZAtEx5f/FDeDUdr+PDU18wr4zhg=;
  b=sFFNhOjT+3EwQEyEvJMFLytMsfwo6ZxAiVJ5x0MtL4PsCuVbOE0HUepS
   2MldFA6EiGEY3DUNiIkXvyYfUj4nemhWOOWg7bbm6QhD6mDdfy5oHvyVS
   QQFMXTt2p2ldYujs+UV5EY6EGtxEac1l90e4XJtydoMbVbG8Ml66h2spJ
   o=;
IronPort-SDR: 8pzXBZc5Y/4+h3F4T8J2K6sydDDSHq83WlIWIA2EcSSXcKOGso02rG09zgy98ICq9gu2ywi6cl
 iMxhYxyOnpYA==
X-IronPort-AV: E=Sophos;i="5.75,456,1589241600"; 
   d="scan'208";a="58522280"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 10 Aug 2020 05:22:15 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 23079A1C54;
        Mon, 10 Aug 2020 05:22:14 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 05:22:13 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.27) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 05:22:08 +0000
Subject: Re: [PATCH v6 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Andra Paraschiv <andraprs@amazon.com>,
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
From:   Alexander Graf <graf@amazon.de>
Message-ID: <a27b4997-12a5-46e7-de81-41ec2b550fc2@amazon.de>
Date:   Mon, 10 Aug 2020 07:22:06 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805091017.86203-8-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D31UWA001.ant.amazon.com (10.43.160.57) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.08.20 11:10, Andra Paraschiv wrote:
> The Nitro Enclaves driver provides an ioctl interface to the user space
> for enclave lifetime management e.g. enclave creation / termination and
> setting enclave resources such as memory and CPU.
> =

> This ioctl interface is mapped to a Nitro Enclaves misc device.
> =

> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v5 -> v6
> =

> * Remove the ioctl to query API version.
> * Update documentation to kernel-doc format.
> =

> v4 -> v5
> =

> * Update the size of the NE CPU pool string from 4096 to 512 chars.
> =

> v3 -> v4
> =

> * Use dev_err instead of custom NE log pattern.
> * Remove the NE CPU pool init during kernel module loading, as the CPU
>    pool is now setup at runtime, via a sysfs file for the kernel
>    parameter.
> * Add minimum enclave memory size definition.
> =

> v2 -> v3
> =

> * Remove the GPL additional wording as SPDX-License-Identifier is
>    already in place.
> * Remove the WARN_ON calls.
> * Remove linux/bug and linux/kvm_host includes that are not needed.
> * Remove "ratelimited" from the logs that are not in the ioctl call
>    paths.
> * Remove file ops that do nothing for now - open and release.
> =

> v1 -> v2
> =

> * Add log pattern for NE.
> * Update goto labels to match their purpose.
> * Update ne_cpu_pool data structure to include the global mutex.
> * Update NE misc device mode to 0660.
> * Check if the CPU siblings are included in the NE CPU pool, as full CPU
>    cores are given for the enclave(s).
> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 121 ++++++++++++++++++++++
>   drivers/virt/nitro_enclaves/ne_pci_dev.c  |  11 ++
>   2 files changed, 132 insertions(+)
>   create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> new file mode 100644
> index 000000000000..472850250220
> --- /dev/null
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -0,0 +1,121 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserve=
d.
> + */
> +
> +/**
> + * DOC: Enclave lifetime management driver for Nitro Enclaves (NE).
> + * Nitro is a hypervisor that has been developed by Amazon.
> + */
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/capability.h>
> +#include <linux/cpu.h>
> +#include <linux/device.h>
> +#include <linux/file.h>
> +#include <linux/hugetlb.h>
> +#include <linux/list.h>
> +#include <linux/miscdevice.h>
> +#include <linux/mm.h>
> +#include <linux/mman.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/nitro_enclaves.h>
> +#include <linux/pci.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +
> +#include "ne_misc_dev.h"
> +#include "ne_pci_dev.h"
> +
> +/**
> + * NE_CPUS_SIZE - Size for max 128 CPUs, for now, in a cpu-list string, =
comma
> + *		  separated. The NE CPU pool includes CPUs from a single NUMA
> + *		  node.
> + */
> +#define NE_CPUS_SIZE		(512)
> +
> +/**
> + * NE_EIF_LOAD_OFFSET - The offset where to copy the Enclave Image Forma=
t (EIF)
> + *			image in enclave memory.
> + */
> +#define NE_EIF_LOAD_OFFSET	(8 * 1024UL * 1024UL)
> +
> +/**
> + * NE_MIN_ENCLAVE_MEM_SIZE - The minimum memory size an enclave can be l=
aunched
> + *			     with.
> + */
> +#define NE_MIN_ENCLAVE_MEM_SIZE	(64 * 1024UL * 1024UL)
> +
> +/**
> + * NE_MIN_MEM_REGION_SIZE - The minimum size of an enclave memory region.
> + */
> +#define NE_MIN_MEM_REGION_SIZE	(2 * 1024UL * 1024UL)
> +
> +/*
> + * TODO: Update logic to create new sysfs entries instead of using
> + * a kernel parameter e.g. if multiple sysfs files needed.
> + */
> +static const struct kernel_param_ops ne_cpu_pool_ops =3D {
> +	.get	=3D param_get_string,
> +};
> +
> +static char ne_cpus[NE_CPUS_SIZE];
> +static struct kparam_string ne_cpus_arg =3D {
> +	.maxlen	=3D sizeof(ne_cpus),
> +	.string	=3D ne_cpus,
> +};
> +
> +module_param_cb(ne_cpus, &ne_cpu_pool_ops, &ne_cpus_arg, 0644);
> +/* https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.=
html#cpu-lists */
> +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves=
");
> +
> +/**
> + * struct ne_cpu_pool - CPU pool used for Nitro Enclaves.
> + * @avail_cores:	Available CPU cores in the pool.
> + * @avail_cores_size:	The size of the available cores array.
> + * @mutex:		Mutex for the access to the NE CPU pool.
> + * @numa_node:		NUMA node of the CPUs in the pool.
> + */
> +struct ne_cpu_pool {
> +	cpumask_var_t	*avail_cores;
> +	unsigned int	avail_cores_size;
> +	struct mutex	mutex;
> +	int		numa_node;
> +};
> +
> +static struct ne_cpu_pool ne_cpu_pool;
> +
> +static const struct file_operations ne_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.llseek		=3D noop_llseek,
> +};
> +
> +struct miscdevice ne_misc_dev =3D {
> +	.minor	=3D MISC_DYNAMIC_MINOR,
> +	.name	=3D "nitro_enclaves",
> +	.fops	=3D &ne_fops,
> +	.mode	=3D 0660,
> +};
> +
> +static int __init ne_init(void)
> +{
> +	mutex_init(&ne_cpu_pool.mutex);
> +
> +	return pci_register_driver(&ne_pci_driver);
> +}
> +
> +static void __exit ne_exit(void)
> +{
> +	pci_unregister_driver(&ne_pci_driver);
> +}
> +
> +/* TODO: Handle actions such as reboot, kexec. */
> +
> +module_init(ne_init);
> +module_exit(ne_exit);
> +
> +MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
> +MODULE_DESCRIPTION("Nitro Enclaves Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitr=
o_enclaves/ne_pci_dev.c
> index a898fae066d9..1e434bf44c9d 100644
> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> @@ -527,6 +527,13 @@ static int ne_pci_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
>   		goto teardown_msix;
>   	}
>   =

> +	rc =3D misc_register(&ne_misc_dev);

If you set ne_misc_dev.parent to &pdev->dev, you can establish a full =

device path connection between the device node and the underlying NE PCI =

device. That means that in the ioctl path, you can also just access the =

device rather than search for it.

Alex

> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "Error in misc dev register [rc=3D%d]\n", rc);
> +
> +		goto disable_ne_pci_dev;
> +	}
> +
>   	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
>   	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
>   	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
> @@ -536,6 +543,8 @@ static int ne_pci_probe(struct pci_dev *pdev, const s=
truct pci_device_id *id)
>   =

>   	return 0;
>   =

> +disable_ne_pci_dev:
> +	ne_pci_dev_disable(pdev);
>   teardown_msix:
>   	ne_teardown_msix(pdev);
>   iounmap_pci_bar:
> @@ -561,6 +570,8 @@ static void ne_pci_remove(struct pci_dev *pdev)
>   {
>   	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>   =

> +	misc_deregister(&ne_misc_dev);
> +
>   	ne_pci_dev_disable(pdev);
>   =

>   	ne_teardown_msix(pdev);
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



