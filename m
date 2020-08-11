Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D177C2421EC
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 23:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHKVZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 17:25:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47830 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgHKVZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 17:25:25 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597181121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m7u9iZM4bgu8PK3FkxHuv+64l2WKnfoRB2cXVRaJnw4=;
        b=hHMPyBCCFhlvypwiG0tlGoOocC/6/w0Nr1YrzlsbqBj4aPtPO/SivNrJhDJEsTmJyGBIdn
        wK0wPPSyrn7SNhuGozY7SxeMQGtH3iWuZKg1GkBrbc8IlgZ2Gx3o6VXa3NqbhOwIfzBaRX
        DDw0wFU1fbPEzxG7beKNyXGeTrMpfuk2yUHezKaaKjlqKA7w5mpEXFXBx76TWqQTGw4fVl
        ChhvpDvDISgZQd4H5KwPka7VdwhciDFvo1qFJDfsKn/qZvzrO8XXhGQCqQFRBZ2c1Gi7gs
        3EM4eZN6+l+aw+/4T6WNsCaZ0eoOLyv/0QwkRGu2PU270twsSL5THasIK9zWdw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597181121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m7u9iZM4bgu8PK3FkxHuv+64l2WKnfoRB2cXVRaJnw4=;
        b=ELIHt1uF/dwRXMv9lB5SfQSoe8rLSoQwm3SbukE5hxSYXAPouA1PkOj1GSCxGPJ4+5QGfT
        SzYNpK6OM0WGwOBw==
To:     "Dey\, Megha" <megha.dey@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Lin\, Jing" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "Hansen\, Dave" <dave.hansen@intel.com>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <8a8a853c-cbe6-b19c-f6ba-c8cdeda84a36@intel.com>
References: <87h7tcgbs2.fsf@nanos.tec.linutronix.de> <87ft8uxjga.fsf@nanos> <87d03x5x0k.fsf@nanos.tec.linutronix.de> <8a8a853c-cbe6-b19c-f6ba-c8cdeda84a36@intel.com>
Date:   Tue, 11 Aug 2020 23:25:20 +0200
Message-ID: <87bljg7u4f.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Dey, Megha" <megha.dey@intel.com> writes:
> On 8/11/2020 2:53 AM, Thomas Gleixner wrote:
>>> And the annoying fact that you need XEN support which opens another can
>>> of worms...
>
> hmm I am not sure why we need Xen support... are you referring to idxd 
> using xen?

What about using IDXD when you are running on XEN? I might be missing
something and IDXD/IMS is hypervisor only, but that still does not solve
this problem on bare metal:

>> x86 still does not associate the irq domain to devices at device
>> discovery time, i.e. the device::msi_domain pointer is never
>> populated.

We can't do that right now due to the way how X86 PCI/MSI allocation
works and being able to do so would make things consistent and way
simpler even for your stuff.

>> The right thing to do is to convert XEN MSI support over to proper irq
>> domains. This allows to populate device::msi_domain which makes a lot of
>> things simpler and also more consistent.
>
> do you think this cleanup is to be a precursor to my patches? I could 
> look into it but I am not familiar with the background of Xen
>
> and this stuff. Can you please provide further guidance on where to
> look

As I said:

>> So to support this new fangled device MSI stuff we'd need yet more
>> x86/xen specific arch_*msi_irqs() indirection and hackery, which is not
>> going to happen.

  git grep arch_.*msi_irq arch/x86

This indirection prevents storing the irq_domain pointer in the device
at probe/detection time. Native code already uses irq domains for
PCI/MSI but we can't exploit the full potential because then
pci_msi_setup_msi_irqs() would never end up in arch_setup_msi_irqs()
which breaks XEN.

I was reminded of that nastiness when I was looking at sensible ways to
integrate this device MSI maze proper.

From a conceptual POV this stuff, which is not restricted to IDXD at all,
looks like this:

           ]-------------------------------------------|
PCI BUS -- | PCI device                                |
           ]-------------------|                       |
           | Physical function |                       |
           ]-------------------|                       |
           ]-------------------|----------|            |
           | Control block for subdevices |            |
           ]------------------------------|            |
           |            | <- "Subdevice BUS"           |
           |            |                              |
           |            |-- Subddevice 0               | 
           |            |-- Subddevice 1               | 
           |            |-- ...                        | 
           |            |-- Subddevice N               | 
           ]-------------------------------------------|

It does not matter whether this is IDXD with it's magic devices or a
network card with a gazillion of queues. Conceptually we need to look at
them as individual subdevices.

And obviously the above picture gives you the topology. The physical
function device belongs to PCI in all aspects including the MSI
interrupt control. The control block is part of the PCI device as well
and it even can have regular PCI/MSI interrupts for its own
purposes. There might be devices where the Physical function device does
not exist at all and the only true PCI functionality is the control
block to manage subdevices. That does not matter and does not change the
concept.

Now the subdevices belong topology wise NOT to the PCI part. PCI is just
the transport they utilize. And their irq domain is distinct from the
PCI/MSI domain for reasons I explained before.

So looking at it from a Linux perspective:

  pci-bus -> PCI device (managed by PCI/MSI domain)
               - PF device
               - CB device (hosts DEVMSI domain)
                    | "Subdevice bus"
                    | - subdevice
                    | - subdevice
                    | - subdevice

Now you would assume that figuring out the irq domain which the DEVMSI
domain serving the subdevices on the subdevice bus should take as parent
is pretty trivial when looking at the topology, right?

CB device's parent is PCI device and we know that PCI device MSI is
handled by the PCI/MSI domain which is either system wide or per IR
unit.

So getting the relevant PCI/MSI irq domain is as simple as doing:

   pcimsi_domain = pcidevice->device->msi_domain;

and then because we know that this is a hierarchy the parent domain of
pcimsi_domain is the one which is the parent of our DEVMSI domain, i.e.:

   parent = pcmsi_domain->parent;

Obvious, right?

What's not so obvious is that pcidevice->device->msi_domain is not
populated on x86 and trying to get the parent from there is a NULL
pointer dereference which does not work well.

So you surely can hack up some workaround for this, but that's just
proliferating crap. We want this to be consistent and there is
absolutely no reason why that network card with the MSI storage in the
queue data should not work on any other architecture.

We do the correct association already for IOMMU and whatever topological
stuff is attached to (PCI) devices on probe/detection time so making it
consistent for irq domains is just a logical consequence and matter of
consistency.

Back in the days when x86 was converted to hierarchical irq domains in
order to support I/O APIC hotplug this workaround was accepted to make
progress and it was meant as a transitional step. Of course after the
goal was achieved nobody @Intel cared anymore and so far this did not
cause big problems. But now it does and we really want to make this
consistent first.

And no we are not making an exception for IDXD either just because
that's Intel only. Intel is not special and not exempt from cleaning
stuff up before adding new features especially not when the stuff to
cleanup is a leftover from Intel itself. IOW, we are not adding more
crap on top of crap which should not exists anymore.

It's not rocket science to fix this. All it needs is to let XEN create
irq domains and populate them during init.

On device detection/probe the proper domain needs to be determined which
is trivial and then stored in device->msi_domain. That makes
arch_.*_msi_irq() go away and a lot of code just simpler.

Thanks,

        tglx
