Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC292A96C6
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 14:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgKFNOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 08:14:22 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9967 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbgKFNOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 08:14:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa54c2b0000>; Fri, 06 Nov 2020 05:14:19 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Nov
 2020 13:14:18 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 6 Nov 2020 13:14:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwUztPW7pqhIdD09v5kGJFlHA0hULgxn4XRfWab4OSo9yZ3pRIktbxDugCOVUzSNBV2DekHPJYzJv5SxiN/RjszZyLCS+rXZcbAqOSzSiRzrMaj78Ew0G9MY6xeC12wj/N7uUbT7uY9qfUMBh9apR38kkCwH4pyZKqml6IB7nrGr07nRinoszYbuz0/pdhWAAFavME0SlUZEtWQMWQgGdaOucNwcszBWXluNyg++qH0sJT6d2wRpxHigLGN0p8Klv7LeM8bmEwf8N+fiJcoO57NeKjP4k5suGN1Em3K6l8PeeAE+jbAjOb+8sC9RuokDB38hZA2YNTDWnGV5ZnZj3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yU3SYmiJaE5H4ciitO/MVwxvXeRoZLRHePyN2XxzayM=;
 b=JwMckCmehmFazFPhc10ZzYOiW7BNmflYLtuR7iWzqeacRJgz10BT+nziaKmMbo91pBoShyPNta90hvYfID7qZ3K4FzdlvvGOR2y+6Ia8AB9MoIXZkEj8CZHoSJY8KAbBgkD/e+CehHcMkDlicZkhPkO2kiQQm6/5kcjndnf1H94HRErzmcgvF3zncgXtTu5LNhrd/C0vMYMlHUpvFq6Nn+k48AulgFS3N4AhDJ5yx+K3dnpY6uVPyZzMBNdcq/Nk16DcJQfdRz5VTj0uVQMqwaooy7NQfoDO/EuE2huCh3z6cZEBONVvPiJ3nmZrYnjXyiBM2gRnRbKPtgI/7IO3uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4041.namprd12.prod.outlook.com (2603:10b6:5:210::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 6 Nov
 2020 13:14:16 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 13:14:16 +0000
Date:   Fri, 6 Nov 2020 09:14:15 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Message-ID: <20201106131415.GT2620339@nvidia.com>
References: <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:208:120::43) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR10CA0030.namprd10.prod.outlook.com (2603:10b6:208:120::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 13:14:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kb1ZH-000m0q-6P; Fri, 06 Nov 2020 09:14:15 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604668459; bh=yU3SYmiJaE5H4ciitO/MVwxvXeRoZLRHePyN2XxzayM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=WcXCdQgvHtFRxCAkbzgmDijav3mHjHMD+MMRDEDM1eI09+T/7TgU46yK5DAgrDK34
         AvTzeYe4416ttDHdL5++xWzgLzXm70Zfp2Wz0g0GOwtdRNVx6LE8AijqGjhYknYrgi
         OZAVusrp1aSY2k5R9g3erv3gZSPW4i8/J6+yhNu4c0LpkFhHj3B0hOQT/JBI0SPTN+
         qbQ6fbOIvDfEUizV6cvpPPEK5XPvhPs7NIr7oMgAX7vt0p97vzFkDypvdugz9tmz3J
         uYkxZ6WZyiw2LmCl4NU1pte7dvRprQisih1Xi9XgmhSRlrNGX5SYbQixJQxcwUI0aD
         Ycfqrzo11UaAw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 09:48:34AM +0000, Tian, Kevin wrote:
> > The interrupt controller is responsible to create an addr/data pair
> > for an interrupt message. It sets the message format and ensures it
> > routes to the proper CPU interrupt handler. Everything about the
> > addr/data pair is owned by the platform interrupt controller.
> > 
> > Devices do not create interrupts. They only trigger the addr/data pair
> > the platform gives them.
> 
> I guess that we may just view it from different angles. On x86 platform,
> a MSI/IMS capable device directly composes interrupt messages, with 
> addr/data pair filled by OS.

Yes, all platforms work like that. The addr/data pair is *opaque* to
the device. Only the platform interrupt controller component
understands how to form those values.

> If there is no IOMMU remapping enabled in the middle, the message
> just hits the CPU. Your description possibly is from software side,
> e.g. describing the hierarchical IRQ domain concept?

I suppose you could say that. Technically the APIC doesn't form any
addr/data pairs, but the configuration of the APIC, IOMMU and other
platform components define what addr/data pairs are acceptable.

The IRQ domain stuff broadly puts responsibilty to form these values
in the IRQ layer which abstracts all the platform detatils. In Linux
we expect the platform to provide the IRQ Domain tha can specify
working addr/data pairs.

> I agree with this point, just as how pci-hyperv.c works. In concept Linux
> guest driver should be able to use IMS when running on Hyper-v. There
> is no such thing for KVM, but possibly one day we will need similar stuff.
> Before that happens the guest could choose to simply disallow devmsi
> by default in the platform code (inventing a hypercall just for 'disable' 
> doesn't make sense) and ignore the IMS cap. One small open is whether
> this can be done in one central-place. The detection of running as guest
> is done in arch-specific code. Do we need disabling devmsi for every arch?
>
> But when talking about virtualization it's not good to assume the guest
> behavior. It's perfectly sane to run a guest OS which doesn't implement 
> any PV stuff (thus don't know running in a VM) but do support IMS. In 
> such scenario the IMS cap allows the hypervisor to educate the guest 
> driver to use MSI instead of IMS, as long as the driver follows the device 
> spec. In this regard I don't think that the IMS cap will be a short-term 
> thing, although Linux may choose to not use it.

The IMS flag belongs in the platform not in the devices.

For instance you could put a "disable IMS" flag in the ACPI tables, in
the config space of the emuulated root port, or any other areas that
clearly belong to the platform.

The OS logic would be
 - If no IMS information found then use IMS (Bare metal)
 - If the IMS disable flag is found then
   - If (future) hypercall available and the OS knows how to use it
     then use IMS
   - If no hypercall found, or no OS knowledge, fail IMS

Our devices can use IMS even in a pure no-emulation
configurations. Saying that we need to insert complicated security
sensitive emulation just to get IMS in the guest is absolutely crazy.

> Do you mind providing the link? There were lots of discussions between
> you and Thomas. I failed to locate the exact mail when searching above
> keywords. 

Read through these two threads:

https://lore.kernel.org/linux-hyperv/20200821002949.049867339@linutronix.de/
https://lore.kernel.org/dmaengine/159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com/

Jason
