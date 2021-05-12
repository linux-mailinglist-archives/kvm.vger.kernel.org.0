Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F4B37EBD8
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 00:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245046AbhELTiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 15:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377960AbhELTJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 15:09:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAF4C06175F
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 12:07:42 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id j26so24684958edf.9
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 12:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SH8WV3s8un415Ugt5bhWScNzXUjXmpS/VLWqCkYtC84=;
        b=Dhgt0CAcjAsKMVv0mgkDWSTmhfoJ1JDO9EQBu8VnZeMrMvAZtfZGzR6a7jifh4Saxc
         Hq/Xmw7mGwxzB/UdOhGBvqqbYs9Ku0VF4d8poPddBeHD4saUIDkRsicjfhuLbQ/lzYG+
         OnFNHshMw1seLVEiNHoYRgsHkOlWy6d4nADCs7dMcObboHYZwS6S2cwKVwvpaNP5k32e
         PiWbWUBuZ/PrmdQTsztDQaKdaPv1fHPFzzVHRszvRXgBiEOVrPyCk6KKJrcwdBgNBNXg
         P6/AWoix5reXhIm88saw+1bSM3QP4lerCcHC3aref6LHoHzZCqKwTb4HFXZpzZV6lmmI
         qvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SH8WV3s8un415Ugt5bhWScNzXUjXmpS/VLWqCkYtC84=;
        b=UeDfJuYnORwvXCuLEVIPgYzRbDyD6OPhMOAQiLgkyNbzIfXnpoNV2PO4I2NSDnrBXU
         xqDNOTiun9o8gaFIQL328/xO9r3vU5fmliU4fkcFiWv3+zOl6IZXAQebvkAElcYoCMS6
         kFaV4t+3f2cS+fwzslFtNHtswBexzxqfDAlEBU8jlDECR8dcMb65swO97kWfO0oRXW4n
         yGZr6wGPdeW0OX9iNY/prdvTWqg301qY7Hdq3lza6MmQNb+Xk6W6CedFIu1FLJFZGGwk
         q8MB+vjF71quvTcfk2zX2m23k5Hj3S6tdiOn2wGWjcCxKoQhqJ7/QJuhgzHktRgBwElr
         U2Dw==
X-Gm-Message-State: AOAM533UIS6yZgfJCd2OVBIdtts/YPpIvMINE11n3F4VLlXx00S+q6Wa
        iN27RAuePqq6Xg9fYXzBKcp+OA7kytBPRWgCtKlKFg==
X-Google-Smtp-Source: ABdhPJzLKa0MC/AL0uqBcdjyZOKjoEtB5gcNatauceydwMC3Gu0or2hrL97FTl1aaixMEif7/6cUK+WurUukp7lpecE=
X-Received: by 2002:a05:6402:2714:: with SMTP id y20mr44871255edd.348.1620846460743;
 Wed, 12 May 2021 12:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <YEiLI8fGoa9DoCnF@kroah.com> <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
 <BYAPR11MB30950965A223EDE5414EAE08D96F9@BYAPR11MB3095.namprd11.prod.outlook.com>
 <CAPcyv4htddEBB9ePPSheH+rO+=VJULeHzx0gc384if7qXTUHHg@mail.gmail.com>
 <BYAPR11MB309515F449B8660043A559E5D96C9@BYAPR11MB3095.namprd11.prod.outlook.com>
 <YFBz1BICsjDsSJwv@kroah.com>
In-Reply-To: <YFBz1BICsjDsSJwv@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 12 May 2021 12:07:31 -0700
Message-ID: <CAPcyv4g89PjKqPuPp2ag0vB9Vq8igTqh0gdP0h+7ySTVPagQ9w@mail.gmail.com>
Subject: Re: [PATCH v10 00/20] dlb: introduce DLB device driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        KVM list <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ add kvm@vger.kernel.org for VFIO discussion ]


On Tue, Mar 16, 2021 at 2:01 AM Greg KH <gregkh@linuxfoundation.org> wrote:
[..]
> > Ioctl interface
> > Kernel driver provides ioctl interface for user applications to setup and configure dlb domains, ports, queues, scheduling types, credits,
> > sequence numbers, and links between ports and queues.  Applications also use the interface to start, stop and inquire the dlb operations.
>
> What applications use any of this?  What userspace implementation today
> interacts with this?  Where is that code located?
>
> Too many TLAs here, I have even less of an understanding of what this
> driver is supposed to be doing, and what this hardware is now than
> before.
>
> And here I thought I understood hardware devices, and if I am confused,
> I pity anyone else looking at this code...
>
> You all need to get some real documentation together to explain
> everything here in terms that anyone can understand.  Without that, this
> code is going nowhere.

Hi Greg,

So, for the last few weeks Mike and company have patiently waded
through my questions and now I think we are at a point to work through
the upstream driver architecture options and tradeoffs. You were not
alone in struggling to understand what this device does because it is
unlike any other accelerator Linux has ever considered. It shards /
load balances a data stream for processing by CPU threads. This is
typically a network appliance function / protocol, but could also be
any other generic thread pool like the kernel's padata. It saves the
CPU cycles spent load balancing work items and marshaling them through
a thread pool pipeline. For example, in DPDK applications, DLB2 frees
up entire cores that would otherwise be consumed with scheduling and
work distribution. A separate proof-of-concept, using DLB2 to
accelerate the kernel's "padata" thread pool for a crypto workload,
demonstrated ~150% higher throughput with hardware employed to manage
work distribution and result ordering. Yes, you need a sufficiently
high touch / high throughput protocol before the software load
balancing overhead coordinating CPU threads starts to dominate the
performance, but there are some specific workloads willing to switch
to this regime.

The primary consumer to date has been as a backend for the event
handling in the userspace networking stack, DPDK. DLB2 has an existing
polled-mode-userspace driver for that use case. So I said, "great,
just add more features to that userspace driver and you're done". In
fact there was DLB1 hardware that also had a polled-mode-userspace
driver. So, the next question is "what's changed in DLB2 where a
userspace driver is no longer suitable?". The new use case for DLB2 is
new hardware support for a host driver to carve up device resources
into smaller sets (vfio-mdevs) that can be assigned to guests (Intel
calls this new hardware capability SIOV: Scalable IO Virtualization).

Hardware resource management is difficult to handle in userspace
especially when bare-metal hardware events need to coordinate with
guest-VM device instances. This includes a mailbox interface for the
guest VM to negotiate resources with the host driver. Another more
practical roadblock for a "DLB2 in userspace" proposal is the fact
that it implements what are in-effect software-defined-interrupts to
go beyond the scalability limits of PCI MSI-x (Intel calls this
Interrupt Message Store: IMS). So even if hardware resource management
was awkwardly plumbed into a userspace daemon there would still need
to be kernel enabling for device-specific extensions to
drivers/vfio/pci/vfio_pci_intrs.c for it to understand the IMS
interrupts of DLB2 in addition to PCI MSI-x.

While that still might be solvable in userspace if you squint at it, I
don't think Linux end users are served by pushing all of hardware
resource management to userspace. VFIO is mostly built to pass entire
PCI devices to guests, or in coordination with a kernel driver to
describe a subset of the hardware to a virtual-device (vfio-mdev)
interface. The rub here is that to date kernel drivers using VFIO to
provision mdevs have some existing responsibilities to the core kernel
like a network driver or DMA offload driver. The DLB2 driver offers no
such service to the kernel for its primary role of accelerating a
userspace data-plane. I am assuming here that  the padata
proof-of-concept is interesting, but not a compelling reason to ship a
driver compared to giving end users competent kernel-driven
hardware-resource assignment for deploying DLB2 virtual instances into
guest VMs.

My "just continue in userspace" suggestion has no answer for the IMS
interrupt and reliable hardware resource management support
requirements. If you're with me so far we can go deeper into the
details, but in answer to your previous questions most of the TLAs
were from the land of "SIOV" where the VFIO community should be
brought in to review. The driver is mostly a configuration plane where
the fast path data-plane is entirely in userspace. That configuration
plane needs to manage hardware events and resourcing on behalf of
guest VMs running on a partitioned subset of the device. There are
worthwhile questions about whether some of the uapi can be refactored
to common modules like uacce, but I think we need to get to a first
order understanding on what DLB2 is and why the kernel has a role
before diving into the uapi discussion.

Any clearer?

So, in summary drivers/misc/ appears to be the first stop in the
review since a host driver needs to be established to start the VFIO
enabling campaign. With my community hat on, I think requiring
standalone host drivers is healthier for Linux than broaching the
subject of VFIO-only drivers. Even if, as in this case, the initial
host driver is mostly implementing a capability that could be achieved
with a userspace driver.
