Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D722152F0
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 09:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgGFHNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 03:13:47 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:4793 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbgGFHNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 03:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594019625; x=1625555625;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=VB95bLc+g+UmqWSFzbL0u4bPsb7J3t0bL/7bnKUwHs4=;
  b=HAbD/y9DB6Eo/9r0ahSS+no4unCwo/+DQapfJX19WUZ3odWCw4bF7mQd
   ntdAnRsVkQjULw9gmSTO9I3bnylatP/H9Wy+m3xAxZ40TdNIlLsZeKcEz
   mf77upqiTBgbOjZVKPEccAn2JvvOPB923WAbxc405RK0mQ5t6g03miPvR
   Q=;
IronPort-SDR: kiJ824QJQ+IdadidvsuVJT+aOsVUniEOlOdVMKHebjWDlsaXcHzny5EzUwawmx4lNzmlAPPZzm
 7WG2uX4IxGmQ==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="56253262"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 Jul 2020 07:13:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 46F6BA2038;
        Mon,  6 Jul 2020 07:13:42 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 07:13:41 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.65) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 07:13:34 +0000
Subject: Re: [PATCH v4 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-8-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <391ad4b0-2011-4d63-8274-9ccb77a5351f@amazon.de>
Date:   Mon, 6 Jul 2020 09:13:29 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-8-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D11UWB002.ant.amazon.com (10.43.161.20) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
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
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 133 ++++++++++++++++++++++
>   drivers/virt/nitro_enclaves/ne_pci_dev.c  |  11 ++
>   2 files changed, 144 insertions(+)
>   create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> new file mode 100644
> index 000000000000..628fb10c2b36
> --- /dev/null
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -0,0 +1,133 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserve=
d.
> + */
> +
> +/**
> + * Enclave lifetime management driver for Nitro Enclaves (NE).
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
> +#define NE_EIF_LOAD_OFFSET (8 * 1024UL * 1024UL)
> +
> +#define NE_MIN_ENCLAVE_MEM_SIZE (64 * 1024UL * 1024UL)
> +
> +#define NE_MIN_MEM_REGION_SIZE (2 * 1024UL * 1024UL)
> +
> +/*
> + * TODO: Update logic to create new sysfs entries instead of using
> + * a kernel parameter e.g. if multiple sysfs files needed.
> + */
> +static const struct kernel_param_ops ne_cpu_pool_ops =3D {

Adding an empty ops struct looks very odd. If you fill it in a later =

patch, please indicate so in a comment here.

> +};
> +
> +static char ne_cpus[PAGE_SIZE];

PAGE_SIZE is a bit excessive, no? Even if you list every single CPU of a =

256 CPU system you are <1024.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



