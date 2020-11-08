Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC992AAE67
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 00:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgKHX6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 18:58:55 -0500
Received: from mga17.intel.com ([192.55.52.151]:33865 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgKHX6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 18:58:55 -0500
IronPort-SDR: sO39jINB+B2//5zjoozlbToqgmSbZxsA/LEVafu1tu41xZs+wBmdmnEDzuCKhBG39sK7Wm+HI2
 bAorLbQN7nsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="149583150"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="149583150"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 15:58:55 -0800
IronPort-SDR: 6fpEqJJpr1gACFKnqPJ12azV28+SksypvRr7UlbSLW9nBQf+GqEiK7TBKS2/r2PJ30S3gzljrx
 8ZwqDSBFP9Kw==
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="472749304"
Received: from araj-mobl1.jf.intel.com ([10.255.228.179])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 15:58:53 -0800
Date:   Sun, 8 Nov 2020 15:58:52 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201108235852.GC32074@araj-mobl1.jf.intel.com>
References: <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

[-] Jing, She isn't working at Intel anymore.

Now this is getting compiled as a book :-).. Thanks a ton!

One question on the hypercall case that isn't immediately
clear to me.

On Sun, Nov 08, 2020 at 07:47:24PM +0100, Thomas Gleixner wrote:
> 
> 
> Now if we look at the virtualization scenario and device hand through
> then the structure in the guest view is not any different from the basic
> case. This works with PCI-MSI[X] and the IDXD IMS variant because the
> hypervisor can trap the access to the storage and translate the message:
> 
>                    |
>                    |
>   [CPU]    -- [Bri | dge] -- Bus -- [Device]
>                    |
>   Alloc +
>   Compose                   Store     Use
>                              |
>                              | Trap
>                              v
>                              Hypervisor translates and stores
> 

The above case, VMM is responsible for writing to the message
store. In both cases if its IMS or Legacy MSI/MSIx. VMM handles
the writes to the device interrupt region and to the IRTE tables.

> But obviously with an IMS storage location which is software controlled
> by the guest side driver (the case Jason is interested in) the above
> cannot work for obvious reasons.
> 
> That means the guest needs a way to ask the hypervisor for a proper
> translation, i.e. a hypercall. Now where to do that? Looking at the
> above remapping case it's pretty obvious:
> 
> 
>                      |
>                      |
>   [CPU]       -- [VI | RT]  -- [Bridge] --    Bus    -- [Device]
>                      |
>   Alloc          "Compose"                   Store         Use
> 
>   Vectordomain   HCALLdomain                Busdomain
>                  |        ^
>                  |        |
>                  v        | 
>             Hypervisor    
>                Alloc + Compose
> 
> Why? Because it reflects the boundaries and leaves the busdomain part
> agnostic as it should be. And it works for _all_ variants of Busdomains.
> 
> Now the question which I can't answer is whether this can work correctly
> in terms of isolation. If the IMS storage is in guest memory (queue
> storage) then the guest driver can obviously write random crap into it
> which the device will happily send. (For MSI and IDXD style IMS it
> still can trap the store).

The isolation problem is not just the guest memory being used as interrrupt
store right? If the Store to device region is not trapped and controlled by 
VMM, there is no gaurantee the guest OS has done the right thing?


Thinking about it, guest memory might be more problematic since its not
trappable and VMM can't enforce what is written. This is something that
needs more attension. But for now the devices supporting memory on device
the trap and store by VMM seems to satisfy the security properties you
highlight here.

> 
> Is the IOMMU/Interrupt remapping unit able to catch such messages which
> go outside the space to which the guest is allowed to signal to? If yes,
> problem solved. If no, then IMS storage in guest memory can't ever work.

This can probably work for SRIOV devices where guest owns the entire device.
interrupt remap does have RID checks if interrupt arrives at an Interrupt handle
not allocated for that BDF.

But for SIOV devices there is no PASID filtering at the remap level since
interrupt messages don't carry PASID in the TLP.

> 
> Coming back to this:
> 
> > In the end pci_subdevice_msi_create_irq_domain() is a platform
> > function. Either it should work completely on every device with no
> > device-specific emulation required in the VMM, or it should not work
> > at all and return -EOPNOTSUPP.
> 
> The subdevice domain is a 'Busdomain' according to the structure
> above. It does not and should never have any clue about the underlying
> system. It's in the agnostic part and always works. It simply does not
> care what's underneath. So it won't return -EOPNOTSUPP.
> 
> What it has to do is to transport the IMS in queue memory requirement to
> the underlying parent domain.
> 
> So in case that the HCALL domain is missing, the Vector domain needs
> return an error code on domain creation. If the HCALL domain is there
> then the domain creation works and in case of actual interrupt
> allocation the hypercall either returns a valid composed message or an
> appropriate error code.
> 
> But there's a catch:
> 
> This only works when the guest OS actually knows that it runs in a
> VM. If the guest can't figure that out, i.e. via CPUID, this cannot be

Precicely!. It might work if the OS is new, but for legacy the trap-emulate
seems both safe and works for legacy as well?


Cheers,
Ashok
