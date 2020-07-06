Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C588521580A
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgGFNJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:09:49 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:57095 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729072AbgGFNJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 09:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594040988; x=1625576988;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=BlwG9nXEMUJKtGb7sDbCMSZ1W89qCavZBm8vM3wztvw=;
  b=JtynVoZWQW7NDwx/7OfFtTF4TszxiNQPEVhUrdXCtmiqSpbmren6XWXP
   LKgFK/DmozH/cji2qQQoiw7yyBg0uFaHoLuXAylUCWhUuVh91VMbh2+c0
   X+RZWHnyZTA18JeyiqqUU6wwxtIl0MEsHMUNIc9UMUdg/XNNmtdH4QMGJ
   0=;
IronPort-SDR: zux/nt/nVgKWDRuywLo9E6Q72oLw6RX9rYYGlazez0u3OIUTPdgTxa/MR1Vcs9/XKlCZv8XmTs
 +kXw1Cmuv82A==
X-IronPort-AV: E=Sophos;i="5.75,320,1589241600"; 
   d="scan'208";a="40220435"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Jul 2020 13:09:46 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 76143A24CC;
        Mon,  6 Jul 2020 13:09:45 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 13:09:44 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 13:09:37 +0000
Subject: Re: [PATCH v4 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
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
 <391ad4b0-2011-4d63-8274-9ccb77a5351f@amazon.de>
 <7cd235d0-25a8-5476-985f-3ee7a60ce3de@amazon.com>
 <55521a26-278c-f6c8-f87a-ab3d3ba67754@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <8af490be-01e3-5ba1-a3c1-4de49bf717e5@amazon.com>
Date:   Mon, 6 Jul 2020 16:09:26 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <55521a26-278c-f6c8-f87a-ab3d3ba67754@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D39UWA003.ant.amazon.com (10.43.160.235) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/07/2020 11:01, Alexander Graf wrote:
>
>
> On 06.07.20 09:49, Paraschiv, Andra-Irina wrote:
>>
>>
>> On 06/07/2020 10:13, Alexander Graf wrote:
>>>
>>>
>>> On 22.06.20 22:03, Andra Paraschiv wrote:
>>>> The Nitro Enclaves driver provides an ioctl interface to the user =

>>>> space
>>>> for enclave lifetime management e.g. enclave creation / termination =

>>>> and
>>>> setting enclave resources such as memory and CPU.
>>>>
>>>> This ioctl interface is mapped to a Nitro Enclaves misc device.
>>>>
>>>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>>>> ---
>>>> Changelog
>>>>
>>>> v3 -> v4
>>>>
>>>> * Use dev_err instead of custom NE log pattern.
>>>> * Remove the NE CPU pool init during kernel module loading, as the CPU
>>>> =A0=A0 pool is now setup at runtime, via a sysfs file for the kernel
>>>> =A0=A0 parameter.
>>>> * Add minimum enclave memory size definition.
>>>>
>>>> v2 -> v3
>>>>
>>>> * Remove the GPL additional wording as SPDX-License-Identifier is
>>>> =A0=A0 already in place.
>>>> * Remove the WARN_ON calls.
>>>> * Remove linux/bug and linux/kvm_host includes that are not needed.
>>>> * Remove "ratelimited" from the logs that are not in the ioctl call
>>>> =A0=A0 paths.
>>>> * Remove file ops that do nothing for now - open and release.
>>>>
>>>> v1 -> v2
>>>>
>>>> * Add log pattern for NE.
>>>> * Update goto labels to match their purpose.
>>>> * Update ne_cpu_pool data structure to include the global mutex.
>>>> * Update NE misc device mode to 0660.
>>>> * Check if the CPU siblings are included in the NE CPU pool, as =

>>>> full CPU
>>>> =A0=A0 cores are given for the enclave(s).
>>>> ---
>>>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 133 =

>>>> ++++++++++++++++++++++
>>>> =A0 drivers/virt/nitro_enclaves/ne_pci_dev.c=A0 |=A0 11 ++
>>>> =A0 2 files changed, 144 insertions(+)
>>>> =A0 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c
>>>>
>>>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>>>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>>>> new file mode 100644
>>>> index 000000000000..628fb10c2b36
>>>> --- /dev/null
>>>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>>>> @@ -0,0 +1,133 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/*
>>>> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights =

>>>> Reserved.
>>>> + */
>>>> +
>>>> +/**
>>>> + * Enclave lifetime management driver for Nitro Enclaves (NE).
>>>> + * Nitro is a hypervisor that has been developed by Amazon.
>>>> + */
>>>> +
>>>> +#include <linux/anon_inodes.h>
>>>> +#include <linux/capability.h>
>>>> +#include <linux/cpu.h>
>>>> +#include <linux/device.h>
>>>> +#include <linux/file.h>
>>>> +#include <linux/hugetlb.h>
>>>> +#include <linux/list.h>
>>>> +#include <linux/miscdevice.h>
>>>> +#include <linux/mm.h>
>>>> +#include <linux/mman.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/mutex.h>
>>>> +#include <linux/nitro_enclaves.h>
>>>> +#include <linux/pci.h>
>>>> +#include <linux/poll.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/types.h>
>>>> +
>>>> +#include "ne_misc_dev.h"
>>>> +#include "ne_pci_dev.h"
>>>> +
>>>> +#define NE_EIF_LOAD_OFFSET (8 * 1024UL * 1024UL)
>>>> +
>>>> +#define NE_MIN_ENCLAVE_MEM_SIZE (64 * 1024UL * 1024UL)
>>>> +
>>>> +#define NE_MIN_MEM_REGION_SIZE (2 * 1024UL * 1024UL)
>>>> +
>>>> +/*
>>>> + * TODO: Update logic to create new sysfs entries instead of using
>>>> + * a kernel parameter e.g. if multiple sysfs files needed.
>>>> + */
>>>> +static const struct kernel_param_ops ne_cpu_pool_ops =3D {
>>>
>>> Adding an empty ops struct looks very odd. If you fill it in a later =

>>> patch, please indicate so in a comment here.
>>
>> True, I already updated this in v5, to have the .get function here =

>> and the .set one in a later patch.
>>
>>>
>>>> +};
>>>> +
>>>> +static char ne_cpus[PAGE_SIZE];
>>>
>>> PAGE_SIZE is a bit excessive, no? Even if you list every single CPU =

>>> of a 256 CPU system you are <1024.
>>
>> It is a bit too much, I was thinking of it while declaring this. I =

>> can update to 1024 in v5.
>
> The largest NUMA node CPU count I'm aware of today is 64. Since we =

> limit the pool to a single node, we can't go beyond that. Let's be a =

> bit future proof and double that number: 128. Then we get to 401 =

> characters if you pass in every single CPU as comma separated. I would =

> seriously hope most people would just pass ranges though.
>
> So how about we make it 512 for now?

We can set it like this, I changed to 512 and updated the comment as well.

Thanks,
Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

