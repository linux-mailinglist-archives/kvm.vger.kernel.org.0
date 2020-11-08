Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3E62AAE3B
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 00:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgKHXXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 18:23:54 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8640 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgKHXXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 18:23:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa87e0d0000>; Sun, 08 Nov 2020 15:23:57 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 8 Nov
 2020 23:23:48 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 8 Nov 2020 23:23:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYh6ZvDtFjVnz0L4SwcZ46X+mzezO3wICgPQLPGndgPUFanlPlY8w/liq0a6rAr7xLMvd64DkeLFTmZc5vZ0wd2Uj1kKS5AkFMcQifwjE/7375IxaW7QOyBMf5mJ7EnQaSB71TMxqCsnRHh5rpZO9MyjvUVM5nM3SxLvv5pcjJaLqShcIuWnB068A5rR3sKFIkM4twrThqSlSbiNt+g6Ds3QhZMvQi2kJki9QhxqArTP11bK6fHaZlzCVpNEs2TIjAzWBAum8TkiqInAPnoFNbidzvX9RnuBnaJd2sJDAFz76syjc2dfAB+7pTzhpyymd2/d8THi52VOnH1SIG01TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5D9x5U4jc7S6hHcssnXaIRs0s7OxWdDoNrXUtdukNis=;
 b=UYGM+30+sIZOIakOd0DKMfDyQFFQq2JQr/n+pEAZf5UaUjheNakCxrDb5YPbzei8atavP6DhW7/opDUEzrjRw++yh7k2N29w2F44tlSsOkKKLehqOnj+5cjAV12DLX1epK32NLQ1k5/uLXbKZ8S/JrdrsGy3F0x+sfonPwxm/LnBOhJ4b+lrXvnxIHFBxVHDmKgWWpyZFuV7I5dbodLnP5Lxhday09+p4QefQJ4zajUjguCXAy3dpQOZ0NMsnZceeA3B9Eq8LMC/hIxw+WUFdn47EAEAKAX/7xc9ujhjxsKm++UlUW1ggL1STurRYp9JqSV89TM0vpDo6dij6/njGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2601.namprd12.prod.outlook.com (2603:10b6:5:45::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Sun, 8 Nov
 2020 23:23:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Sun, 8 Nov 2020
 23:23:43 +0000
Date:   Sun, 8 Nov 2020 19:23:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Dan Williams <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
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
        "jing.lin@intel.com" <jing.lin@intel.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201108232341.GB2620339@nvidia.com>
References: <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
X-ClientProxiedBy: BL0PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:208:51::41) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0100.namprd02.prod.outlook.com (2603:10b6:208:51::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sun, 8 Nov 2020 23:23:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kbu29-001jW1-7w; Sun, 08 Nov 2020 19:23:41 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604877837; bh=5D9x5U4jc7S6hHcssnXaIRs0s7OxWdDoNrXUtdukNis=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=HJ4Xu8NCcoTW7+GSABmikZnwYmowvkwjpoA++M723JDZjBAYpE8hhT4Bgk5g4lVtz
         7tnj6vtY1wHgE3RR5Zvhr/V2VzSge4XbaIyft37IWcO+MT1W2MDATKlMO2KixMFt78
         uw/EC/fhtXE71cIpVY5QU6+63OSZ5IhpVwo2QASi7NqezG1OQFRqn4EnCdYUwwSJGA
         cDNAC/gjQQldvc9WL/fWsCAVc/jbVrRpsZqKl4bRUPq2dxybPy2UWdG58VmrgXBaOr
         sm5ZBB2nLKHVLxssxTCheKVHXrI/AK3GFPLGxxEBipBTgB6IhLM5Pp/xTiPNhFxtGk
         +V/45RHIk3Lsw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 08, 2020 at 07:47:24PM +0100, Thomas Gleixner wrote:
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

Yes, this will describes what I have been thinking

> Now the question which I can't answer is whether this can work correctly
> in terms of isolation. If the IMS storage is in guest memory (queue
> storage) then the guest driver can obviously write random crap into it
> which the device will happily send. (For MSI and IDXD style IMS it
> still can trap the store).

There are four cases of interest here:

 1) Bare metal, PF and VF devices just deliver whatever addr/data pairs
    to the APIC. IMS works perfectly with pci_subdevice_msi_create_irq_domain()

 2) SRIOV VF assigned to the guest.

    The guest can cause any MemWr TLP to any addr/data pair
    and the iommu/platform/vmm is supposed to use the
    Bus/device/function to isolate & secure the interrupt address
    range.

    IMS can work in the guest if the guest knows the details of the
    address range and can make hypercalls to setup routing. So
    pci_subdevice_msi_create_irq_domain() works if the hypercalls
    exist and fails if they don't.

 3) SIOV sub device assigned to the guest.

    The difference between SIOV and SRIOV is the device must attach a
    PASID to every TLP triggered by the guest. Logically we'd expect
    when IMS is used in this situation the interrupt MemWr is tagged
    with bus/device/function/PASID to uniquly ID the guest and the same
    security protection scheme from #2 applies.

 4) SIOV sub device assigned to the guest, but with emulation.

    This SIOV device cannot tag interrupts with PASID so cannot do #2
    (or the platform cannot recieve a PASID tagged interrupt message).

    Since the interrupts are being delivered with TLPs pointing at the
    hypervisor the only solution is for the hypervisor to exclusively
    control the interrupt table. MSI table like emulation for IMS is
    needed and the hypervisor will use pci_subdevice_msi_create_irq_domain()
    to get the real interrupts.

    pci_subdevice_msi_create_irq_domain() needs to return the 'fake'
    addr/data pairs which are actually an ABI between the guest and
    hypervisor carried in the hidden hypercall of the emulation.
    (ie it works like MSI works today)

IDXD is worring about case #4, I think, but I didn't follow in that
whole discussion about the IMS table layout if they PASID tag the IMS
MemWr or not?? Ashok can you clarify?

> Is the IOMMU/Interrupt remapping unit able to catch such messages which
> go outside the space to which the guest is allowed to signal to? If yes,
> problem solved. If no, then IMS storage in guest memory can't ever work.

Right. Only PASID on the interrupt messages can resolve this securely.

> So in case that the HCALL domain is missing, the Vector domain needs
> return an error code on domain creation. If the HCALL domain is there
> then the domain creation works and in case of actual interrupt
> allocation the hypercall either returns a valid composed message or an
> appropriate error code.

Yes
 
> But there's a catch:
> 
> This only works when the guest OS actually knows that it runs in a
> VM. If the guest can't figure that out, i.e. via CPUID, this cannot be
> solved because from the guest OS view that's the same as running on bare
> metal. Obviously on bare metal the Vector domain can and must handle
> this.

Yes

The flip side is today, the way pci_subdevice_msi_create_irq_domain()
works a VF using it on baremetal will succeed and if that same VF is
assigned to a guest then pci_subdevice_msi_create_irq_domain()
succeeds but the interrupt never comes - so the driver is broken.

Yes, if we add some ACPI/etc flag that is not going to magically fix
old kvm's, but at least *something* exists that works right and
generically.

If we follow Intel's path then we need special KVM level support for
*every* device, PCI cap mangling and so on. Forever. Sounds horrible
to me..

This feels like one of these things where no matter what we do
something is broken. Picking the least breakage is the challenge here.

> So this needs some thought.

I think your HAOLL diagram is the only sane architecture.

If go that way then case #4 will still work, in this case the HCALL
will return addr/data pairs that conform to what the emulation
expects. Or fail if the VMM can't do emulation for the device.

Jason
