Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892AE2153A1
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 10:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgGFIB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 04:01:57 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:62902 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbgGFIB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 04:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594022516; x=1625558516;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=RFHX09slPfR2AfRmm3yg6rE58zppAQ2AI0iBAJRp5dE=;
  b=gTwj/Kp754gBqj5eBVhowA43h2j8v9VQ0DdKnv0ytUEn8dxzhg8x+Vnj
   VtAgSEGFP9et92dkuqLvgQXaq9a8l7LLRecN50bEYQQuQM8QAvfafc2Ru
   rdzqCaQHHyjHmUkQ8WuowtCDYluDmLgaXd0KMT7GKtqgK7zV5i566m/5F
   I=;
IronPort-SDR: wnKpkrfkoD7eWZ68TvPpMStX5NOdBcU5HcHNbaJB57LcPA9epKnJDwc3c/I2sWvuoZufZiXxFJ
 t14eqtqMaDXg==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="57538671"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Jul 2020 08:01:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id D88C9A1E71;
        Mon,  6 Jul 2020 08:01:54 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 08:01:54 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.156) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 08:01:50 +0000
Subject: Re: [PATCH v4 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
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
 <391ad4b0-2011-4d63-8274-9ccb77a5351f@amazon.de>
 <7cd235d0-25a8-5476-985f-3ee7a60ce3de@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <55521a26-278c-f6c8-f87a-ab3d3ba67754@amazon.de>
Date:   Mon, 6 Jul 2020 10:01:42 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7cd235d0-25a8-5476-985f-3ee7a60ce3de@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.156]
X-ClientProxiedBy: EX13D43UWA002.ant.amazon.com (10.43.160.109) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06.07.20 09:49, Paraschiv, Andra-Irina wrote:
> =

> =

> On 06/07/2020 10:13, Alexander Graf wrote:
>>
>>
>> On 22.06.20 22:03, Andra Paraschiv wrote:
>>> The Nitro Enclaves driver provides an ioctl interface to the user space
>>> for enclave lifetime management e.g. enclave creation / termination and
>>> setting enclave resources such as memory and CPU.
>>>
>>> This ioctl interface is mapped to a Nitro Enclaves misc device.
>>>
>>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>>> ---
>>> Changelog
>>>
>>> v3 -> v4
>>>
>>> * Use dev_err instead of custom NE log pattern.
>>> * Remove the NE CPU pool init during kernel module loading, as the CPU
>>> =A0=A0 pool is now setup at runtime, via a sysfs file for the kernel
>>> =A0=A0 parameter.
>>> * Add minimum enclave memory size definition.
>>>
>>> v2 -> v3
>>>
>>> * Remove the GPL additional wording as SPDX-License-Identifier is
>>> =A0=A0 already in place.
>>> * Remove the WARN_ON calls.
>>> * Remove linux/bug and linux/kvm_host includes that are not needed.
>>> * Remove "ratelimited" from the logs that are not in the ioctl call
>>> =A0=A0 paths.
>>> * Remove file ops that do nothing for now - open and release.
>>>
>>> v1 -> v2
>>>
>>> * Add log pattern for NE.
>>> * Update goto labels to match their purpose.
>>> * Update ne_cpu_pool data structure to include the global mutex.
>>> * Update NE misc device mode to 0660.
>>> * Check if the CPU siblings are included in the NE CPU pool, as full CPU
>>> =A0=A0 cores are given for the enclave(s).
>>> ---
>>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 133 +++++++++++++++++++=
+++
>>> =A0 drivers/virt/nitro_enclaves/ne_pci_dev.c=A0 |=A0 11 ++
>>> =A0 2 files changed, 144 insertions(+)
>>> =A0 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.c
>>>
>>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>>> new file mode 100644
>>> index 000000000000..628fb10c2b36
>>> --- /dev/null
>>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>>> @@ -0,0 +1,133 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights =

>>> Reserved.
>>> + */
>>> +
>>> +/**
>>> + * Enclave lifetime management driver for Nitro Enclaves (NE).
>>> + * Nitro is a hypervisor that has been developed by Amazon.
>>> + */
>>> +
>>> +#include <linux/anon_inodes.h>
>>> +#include <linux/capability.h>
>>> +#include <linux/cpu.h>
>>> +#include <linux/device.h>
>>> +#include <linux/file.h>
>>> +#include <linux/hugetlb.h>
>>> +#include <linux/list.h>
>>> +#include <linux/miscdevice.h>
>>> +#include <linux/mm.h>
>>> +#include <linux/mman.h>
>>> +#include <linux/module.h>
>>> +#include <linux/mutex.h>
>>> +#include <linux/nitro_enclaves.h>
>>> +#include <linux/pci.h>
>>> +#include <linux/poll.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/types.h>
>>> +
>>> +#include "ne_misc_dev.h"
>>> +#include "ne_pci_dev.h"
>>> +
>>> +#define NE_EIF_LOAD_OFFSET (8 * 1024UL * 1024UL)
>>> +
>>> +#define NE_MIN_ENCLAVE_MEM_SIZE (64 * 1024UL * 1024UL)
>>> +
>>> +#define NE_MIN_MEM_REGION_SIZE (2 * 1024UL * 1024UL)
>>> +
>>> +/*
>>> + * TODO: Update logic to create new sysfs entries instead of using
>>> + * a kernel parameter e.g. if multiple sysfs files needed.
>>> + */
>>> +static const struct kernel_param_ops ne_cpu_pool_ops =3D {
>>
>> Adding an empty ops struct looks very odd. If you fill it in a later =

>> patch, please indicate so in a comment here.
> =

> True, I already updated this in v5, to have the .get function here and =

> the .set one in a later patch.
> =

>>
>>> +};
>>> +
>>> +static char ne_cpus[PAGE_SIZE];
>>
>> PAGE_SIZE is a bit excessive, no? Even if you list every single CPU of =

>> a 256 CPU system you are <1024.
> =

> It is a bit too much, I was thinking of it while declaring this. I can =

> update to 1024 in v5.

The largest NUMA node CPU count I'm aware of today is 64. Since we limit =

the pool to a single node, we can't go beyond that. Let's be a bit =

future proof and double that number: 128. Then we get to 401 characters =

if you pass in every single CPU as comma separated. I would seriously =

hope most people would just pass ranges though.

So how about we make it 512 for now?


Thanks,

Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



