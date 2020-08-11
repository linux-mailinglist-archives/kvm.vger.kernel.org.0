Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB45A241FD1
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 20:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKSje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 14:39:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:62008 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgHKSjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 14:39:33 -0400
IronPort-SDR: XtScYMvmNypHlON/sX23XvTpEn98ANlqsgFVb6/vO+D/NbjaoFEOesDHjmNBGB3UZMyFHEdRYd
 Ul99Dc2BfrgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="215320560"
X-IronPort-AV: E=Sophos;i="5.76,301,1592895600"; 
   d="scan'208";a="215320560"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 11:39:25 -0700
IronPort-SDR: DSCptk9unTTsZolcqSeQUsixDuqqqM1xUH+RWpqa9c31Q5XdGVtt9F8AAkPVQQbVTfZZqZ4ygb
 01W0QCw4hDiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,301,1592895600"; 
   d="scan'208";a="324841739"
Received: from orsmsx601-2.jf.intel.com (HELO ORSMSX601.amr.corp.intel.com) ([10.22.229.81])
  by orsmga008.jf.intel.com with ESMTP; 11 Aug 2020 11:39:24 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 11 Aug 2020 11:39:24 -0700
Received: from orsmsx101.amr.corp.intel.com (10.22.225.128) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 11 Aug 2020 11:39:24 -0700
Received: from [10.212.86.9] (10.212.86.9) by ORSMSX101.amr.corp.intel.com
 (10.22.225.128) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 11 Aug
 2020 11:39:23 -0700
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <87h7tcgbs2.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <996854e7-ab11-b76b-64dc-b760b3ad2365@intel.com>
Date:   Tue, 11 Aug 2020 11:39:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87h7tcgbs2.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.212.86.9]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 8/8/2020 12:47 PM, Thomas Gleixner wrote:
> Megha,
>
> "Dey, Megha" <megha.dey@intel.com> writes:
>> On 8/7/2020 9:47 AM, Thomas Gleixner wrote:
>>> I'm all for sharing code and making the life of driver writers simple
>>> because that makes my life simple as well, but not by creating a layer
>>> at the wrong level and then hacking it into submission until it finally
>>> collapses.
>>>
>>> Designing the infrastructure following the clear layering rules of
>>> hierarchical domains so it works for IMS and also replaces the platform
>>> MSI hack is the only sane way to go forward, not the other way round.
>>   From what I've gathered, I need to:
>>
>> 1. Get rid of the mantra that "IMS" is an extension of platform-msi.
>> 2. Make this new infra devoid of any platform-msi references
> See below.
ok..
>
>> 3. Come up with a ground up approach which adheres to the layering
>> constraints of the IRQ subsystem
> Yes. It's something which can be used by all devices which have:
>
>     1) A device specific irq chip implementation including a msi write function
>     2) Device specific resource management (slots in the IMS case)
>
> The infrastructure you need is basically a wrapper around the core MSI
> domain (similar to PCI, platform-MSI etc,) which provides the specific
> functionality to handle the above.

ok, i will create a per device irq chip which will directly have the 
device specific callbacks instead of another layer of redirection.

This way i will get rid of the 'platform_msi_ops' data structure.

I am not sure what you mean by device specific resource management, are 
you referring to dev_msi_alloc/free_irqs?

>> 4. Have common code (drivers/irqchip maybe??) where we put in all the
>> generic ims-specific bits for the IRQ chip and domain
>> which can be used by all device drivers belonging to this "IMS"class.
> Yes, you can provide a common implementation for devices which share the
> same irq chip and domain (slot management functionality)
yeah i think most of the msi_domain_ops (msi_prepare, set_desc etc) are 
common and can be moved into a common file.
>
>> 5. Have the device driver do the rest:
>>       create the chip/domain (one chip/domain per device?)
>>       provide device specific callbacks for masking, unmasking, write
>>   message
> Correct, but you don't need any magic new data structures for that, the
> existing msi_domain_info/msi_domain_ops and related structures are
> either sufficient or can be extended when necessary.
>
> So for the IDXD case you need:
>
>    1) An irq chip with mask/unmask callbacks and a write msg function
>    2) A slot allocation or association function and their 'free'
>       counterpart (irq_domain_ops)

This is one part I didn't understand.

Currently my dev_msi_alloc_irqs is simply a wrapper over 
platform_msi_domain_alloc_irqs which again mostly calls 
msi_domain_alloc_irqs.

When you say add a .alloc, .free, does this mean we should add a device 
specific alloc/free and not use the default 
msi_domain_alloc/msi_domain_free?

I don't see anything device specific to be done for IDXD atleast, can 
you please let me know?

>
> The function and struct pointers go into the appropriate
> msi_info/msi_ops structures along with the correct flags to set up the
> whole thing and then the infrastructure creates your domain, fills in
> the shared functions and sets the whole thing up.
>
> That's all what a device driver needs to provide, i.e. stick the device
> specific functionality into right data structures and let the common
> infrastructure deal with it. The rest just works and the device specific
> functions are invoked from the right places when required.
yeah. makes sense..
>
>> So from the hierarchical domain standpoint, we will have:
>> - For DSA device: vector->intel-IR->IDXD
>> - For Jason's device: root domain-> domain A-> Jason's device's IRQ domain
>> - For any other intel IMS device in the future which
>>       does not require interrupt remapping: vector->new device IRQ domain
>>       requires interrupt remapping: vector->intel-IR->new device IRQ
>> domain (i.e. create a new domain even though IDXD is already present?)
> What's special about IDXD? It's just one specific implementation of IMS
> and any other device implementing IMS is completely independent and as
> documented in the specification the IMS slot management and therefore
> the mask/unmask functionality can and will be completely different. IDXD
> has a storage array with slots, Jason's hardware puts the IMS slot into
> the queue storage.
>
> It does not matter whether a device comes from Intel or any other vendor,
> it does neither matter whether the device works with direct vector
> delivery or interrupt remapping.
>
> IDXD is not any different from any other IMS capable device when you
> look at it from the interrupt hierarchy. It's either:
>
>       vector -> IR -> device
> or
>       vector -> device
>
> The only point where this is differentiated is when the irq domain is
> created. Anything else just falls into place.
yeah, so I will create the IRQ domain in the IDXD driver with INTEL-IR 
as the parent, instead of creating a common per IR unit domain
>
> To answer Jason's question: No, the parent is never the PCI/MSI irq
> domain because that sits at the same level as that device
> domain. Remember the scheme:
>
>     vector --- DMAR-MSI
> 	  |
> 	  |-- ....
> 	  |
> 	  |-- IR-0 --- IO/APIC-0
> 	  |        |
> 	  |        |-- IO/APIC-1
> 	  |        |
> 	  |        |-- PCI/MSI-0
> 	  |        |
> 	  |        |-- HPET/MSI-0
> 	  |        |
> 	  |        |-- DEV-A/MSI-0
> 	  |        |-- DEV-A/MSI-1
> 	  |        |-- DEV-B/MSI-2
> 	  |
> 	  |-- IR-1 --- PCI/MSI-1
> 	  |        |
> 	  |        |-- DEV-C/MSI-3
>
> The PCI/MSI domain(s) are dealing solely with PCI standard compliant
> MSI/MSI-X. IMS or similar (platform-MSI being one variant) sit at the
> same level as the PCI/MSI domains.
>
> Why? It's how the hardware operates.
>
> The PCI/MSI "irq chip" is configured by the PCI/MSI domain level and it
> sends its message to the interrupt parent in the hierarchy, i.e. either
> to the Interrupt Remap unit or to the configured vector of the target
> CPU.
>
> IMS does not send it to some magic PCI layer first at least not at the
> conceptual level. The fact that the message is transported by PCIe does
> not change that at all. PCIe in that case is solely the transport, but
> the "irq chip" at the PCI/MSI level of the device is not involved at
> all. If it were that would be a different story.
>
> So now you might ask why we have a single PCI/MSI domain per IR unit and
> why I want seperate IMS domains.
>
> The answer is in the hardware again. PCI/MSI is uniform accross devices
> so the irq chip and all of the domain functionality can be shared. But
> then we have two PCI/MSI domains in the above example because again the
> hardware has one connected to IR unit 0 and the other to IR unit 1.
> IR 0 and IR 1 manage different resources (remap tables) so PCI/MSI-0
> depends on IR-0 and PCI/MSI-1 on IR-1 which is reflected in the
> parent/child relation ship of the domains.
>
> There is another reason why we can spawn a single PCI/MSI domain per
> root complex / IR unit. The PCI/MSI domains are not doing any resource
> management at all. The resulting message is created from the allocated
> vector (direct CPU delivery) or from the allocated Interrupt remapping
> slot information. The domain just deals with the logic required to
> handle PCI/MSI(X) and the necessary resources are provided by the parent
> interrupt layers.
>
> IMS is different. It needs device specific resource management to
> allocate an IMS slot which is clearly part of the "irq chip" management
> layer, aka. irq domain. If the IMS slot management would happen in a
> global or per IR unit table and as a consequence the management, layout,
> mask/unmask operations would be uniform then an IMS domain per system or
> IR unit would be the right choice, but that's not how the hardware is
> specified and implemented.
>
> Now coming back to platform MSI. The way it looks is:
>
>   CPU --- (IR) ---- PLATFORM-MSI  --- PLATFORM-DEVICE-MSI-0
>                                   |-- PLATFORM-DEVICE-MSI-1
>                                   |...
>
> PLATFORM-MSI is a common resource management which also provides a
> shared interrupt chip which operates at the PLATFORM-MSI level with one
> exception:
>
>    The irq_msi_write_msg() callback has an indirection so the actual
>    devices can provide their device specific msi_write_msg() function.
>
> That's a borderline abuse of the hierarchy, but it makes sense to some
> extent as the actual PLATFORM-MSI domain is a truly shared resource and
> the only device specific functionality required is the message
> write. But that message write is not something which has it's own
> resource management, it's just a non uniform storage accessor. IOW, the
> underlying PLATFORM-MSI domain does all resource management including
> message creation and the quirk allows to write the message in the device
> specific way. Not that I love it, but ...
>
> That is the main difference between platform MSI and IMS. IMS is
> completely non uniform and the devices do not share any common resource
> or chip functionality. Each device has its own message store management,
> slot allocation/assignment and a device specifc interrupt chip
> functionality which goes way beyond the nasty write msg quirk.
Thanks for giving such a detailed explanation! really helps :)
>
>> What I still don't understand fully is what if all the IMS devices
>> need the same domain ops and chip callbacks, we will be creating
>> various instances of the same IRQ chip and domain right? Is that ok?
> Why would it be not ok? Are you really worried about a few hundred bytes
> of memory required for this?
>
> Sharing an instance only makes sense if the instance handles a shared or
> uniform resource space, which is clearly not the case with IMS.
>
> We create several PCI/MSI domains and several IO/APIC domains on larger
> systems. They all share the code, but they are dealing with seperate
> resources so they have seperate storage.
ok, got it ..
>
>> Currently the creation of the IRQ domain happens at the IR level so that
>> we can reuse the same domain but if it advisable to have a per device
>> interrupt domain, I will shift this to the device driver.
> Again. Look at the layering. What you created now is a pseudo shared
> domain which needs
>
>     1) An indirection layer for providing device specific functions
>
>     2) An extra allocation layer in the device specific driver to assign
>        IMS slots completely outside of the domain allocation mechanism.
hmmm, again I am not sure of which extra allocation layer you are 
referring to..
>
>     In other words you try to make things which are neither uniform nor
>     share a resource space look the same way. That's the "all I have is a
>     hammer so everything is a nail" approach. That never worked out well.
>
> With a per device domain/chip approach you get one consistent domain
> per device which provides
>
>     1) The device specific resource management (i.e. slot allocation
>        becomes part of the irq domain operations)
>
>     2) The device specific irq chip functions at the correct point in the
>        layering without the horrid indirections
>
>     3) Consolidated data storage at the device level where the actual
>        data is managed.
>
>     This is of course sharing as much code as possible with the MSI core
>     implementation.
>
>     As a side effect any extension of this be it on the domain or the irq
>     chip side is just a matter of adding the functionality to that
>     particular incarnation and not by having yet another indirection
>     logic at the wrong place.
>
> The price you pay is a bit of memory but you get a clean layering and
> seperation of functionality as a reward. The amount of code in the
> actual IMS device driver is not going to be much more than with the
> approach you have now.
>
> The infrastructure itself is not more than a thin wrapper around the
> existing msi domain infrastructure and might even share code with
> platform-msi.

 From your explanation:


In the device driver:


static const struct irq_domain_ops idxd_irq_domain_ops = {

.alloc= idxd_domain_alloc, //not sure what this should do

.free= idxd_domain_free,

};

struct irq_chip idxd_irq_chip = {

.name= "idxd"

.irq_mask= idxd_irq_mask,

.irq_unmask= idxd_irq_unmask,

.irq_write_msg = idxd_irq_write_msg,

.irq_ack= irq_chip_ack_parent,

.irq_retrigger= irq_chip_retrigger_hierarchy,

.flags= IRQCHIP_SKIP_SET_WAKE,

}

struct msi_domain_info idxd_domain_info = {

.flags        =MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS,

.ops          =&dev_msi_domain_ops,//can be common

.chip         =&idxd_irq_chip //per device

.handler= handle_edge_irq,

.handler_name = "edge",

}

dev->msi_domain = dev_msi_create_irq_domain(iommu->ir_domain, 
idxd_domain_info, idxd_irq_domain_ops)

msi_domain_alloc_irqs(dev->msi_domain, dev, nvec);

Common code:


struct irq_domain *dev_msi_create_irq_domain(struct irq_domain *parent,

struct msi_domain_info *dev_msi_domain_info,

struct irq_domain_ops dev_msi_irq_domain_ops)

{

struct irq_domain *domain;

         .......

domain = irq_domain_create_hierarchy(parent, IRQ_DOMAIN_FLAG_MSI, 0,
NULL, &dev_msi_irq_domain_ops, info);

         .......

return domain;

}

static struct msi_domain_ops dev_msi_domain_ops = {

.set_desc= dev_msi_set_desc,

.msi_prepare= dev_msi_prepare,

.get_hwirq= dev_msi_get_hwirq,

}; // can re-use platform-msi data structures


except the alloc/free irq_domain_ops, does this look fine to you?


-Megha

>
> Thanks,
>
>          tglx
