Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA723DDA0
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgHFRMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:12:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58938 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbgHFRKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:10:08 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596733806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yKVD0ICRirwJxf/czTIoL9qaNHOqC5llD5fZwtykD6w=;
        b=Uu02hQeXnceW1clbDFU34w01Na01ihe8gw5vdOZssFKm0ZWXV+ig/hiWrMPj3DyEDWsWmp
        d5q6kG0wmvOmqMIX3dWRl6kqRLWtU/fisAqjfMYs/MNmgVZG/RmheVA60Im0TeiUhxBCZi
        9hqt3C2EPyjAChYbG+bZD0bMlT5GYo2qRQV4t2yqJImq4xW2cQe2ctC176iuoCQtFZxNNG
        MI4kIWnaPSegaZ8F6XUsUtUkLhfST8e4RlThO9ng/MYX/egAzO5ulxnw6h/KaTv4bLrWqA
        /2u4RF35uMj/YCiBZQtAEM2JK91u6lf5m4pEzA64GZc0kJ2gbDtWTsZWc4f9MQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596733806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yKVD0ICRirwJxf/czTIoL9qaNHOqC5llD5fZwtykD6w=;
        b=1ench/3Yz4ELlGwrmwd8zDNRPuZX7xmwBO6TcJKMNpbwZC7PP+JR9mKgtVvQyp3pUUu5qC
        WOvTlcXJ7KEJIRBQ==
To:     "Dey\, Megha" <megha.dey@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com> <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com> <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com> <96a1eb5ccc724790b5404a642583919d@intel.com> <20200805221548.GK19097@mellanox.com> <70465fd3a7ae428a82e19f98daa779e8@intel.com> <20200805225330.GL19097@mellanox.com> <630e6a4dc17b49aba32675377f5a50e0@intel.com> <20200806001927.GM19097@mellanox.com> <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
Date:   Thu, 06 Aug 2020 19:10:05 +0200
Message-ID: <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Megha,

"Dey, Megha" <megha.dey@intel.com> writes:

>> -----Original Message-----
>> From: Jason Gunthorpe <jgg@mellanox.com>
<SNIP>
>> Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
>> irq domain

can you please fix your mail client not to copy the whole header of the
mail you are replying to into the mail body?

>> > > Well, I had suggested to pass in the parent struct device, but it
>> Oops, I was thinking of platform_msi_domain_alloc_irqs() not
>> create_device_domain()
>> 
>> ie call it in the device driver that wishes to consume the extra MSIs.
>> 
>> Is there a harm if each device driver creates a new irq_domain for its use?
>
> Well, the only harm is if we want to reuse the irq domain.

You cannot reuse the irq domain if you create a domain per driver. The
way how hierarchical domains work is:

vector --- DMAR-MSI
       |
       |-- ....
       |
       |-- IR-0 --- IO/APIC-0
       |        | 
       |        |-- IO/APIC-1
       |        |
       |        |-- PCI/MSI-0
       |        |
       |        |-- HPET/MSI-0
       |
       |-- IR-1 --- PCI/MSI-1
       |        |

The outermost domain is what the actual device driver uses. I.e. for
PCI-MSI it's the msi domain which is associated to the bus the device is
connected to. Each domain has its own interrupt chip instance and its
own data set.

Domains of the same type share the code, but neither the data nor the
interrupt chip instance.

Also there is a strict parent child relationship in terms of resources.
Let's look at PCI.

PCI/MSI-0 depends on IR-0 which depends on the vector domain. That's
reflecting both the flow of the interrupt and the steps required for
various tasks, e.g. allocation/deallocation and also interrupt chip
operations. In order to allocate a PCI/MSI interrupt in domain PCI/MSI-0
a slot in the remapping unit and a vector needs to be allocated.

If you disable interrupt remapping all the outermost domains in the
scheme above become childs of the vector domain.

So if we look at DEV/MSI as a infrastructure domain then the scheme
looks like this:

vector --- DMAR-MSI
       |
       |-- ....
       |
       |-- IR-0 --- IO/APIC-0
       |        | 
       |        |-- IO/APIC-1
       |        |
       |        |-- PCI/MSI-0
       |        |
       |        |-- HPET/MSI-0
       |        |
       |        |-- DEV/MSI-0
       |
       |-- IR-1 --- PCI/MSI-1
       |        |
       |        |-- DEV/MSI-1


But if you make it per device then you have multiple DEV/MSI domains per
IR unit.

What's the right thing to do?

If the DEV/MSI domain has it's own per IR unit resource management, then
you need one per IR unit.

If the resource management is solely per device then having a domain per
device is the right choice.

Thanks,

        tglx
