Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ADB2AA1AB
	for <lists+kvm@lfdr.de>; Sat,  7 Nov 2020 01:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgKGAMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 19:12:18 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:37416 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgKGAMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 19:12:18 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa5e65f0000>; Sat, 07 Nov 2020 08:12:15 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 7 Nov
 2020 00:12:12 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 7 Nov 2020 00:12:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcFvPgZ7c+J5sj1gZPe0Lau9hjnP8bLtpScFOfKcY7IMYn4kQ7/TI1lJzdCiyT252+B6VC/qUMm/ndtudcKJ3RLUDsXFseoS4PMypC2XufTDTSDDZSI67fi4kQ+DlD9TYN+HGb7u612o8ZKVW9APeyxl1HmZ/NovgenDSCzlYyIjHy2HrWK7WjZz1SOZ6UHPdRunoQV0yoFYULZLs6HdAe0Rbaz+2v2OjvUkKUgBQEFURrx5Ver/qwNyZaH8D4xSbufk0mkaGML3YF0BiG1KCJYy9GuWCfBN7Kmz+H6W0Uvlc/c+OSNgRzsfkQVWMMo9Ewy86E84gmFBwyHiNMsnSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXQ+SpzZb5V9OPfmuK/bv7yxrxOa8qNbfruPqSYHmg0=;
 b=G1veKVlMNLYcAxNZf8tddinStGZPD2r3014wnIOemsUPB7XyNTm1tJDT1x8qc21PUKSXYulQ+U6dgtFlKYzmU0Pnw7FQOrcdNmdwwC24MjlD5SqbY5TWnmRQjb4AtweFofe+AQVQ5CUSEtZldk0eKHy4xzX+hhAV+jQ6eEEk83WGlZQLvdNAuFHCjW7CLTTjvmjrgn7cUb7NbjnpBUOm4YDQHdRULl33cj5e1czcQiPOdx5ZP9rTMt62Ysf0NyepZCZilug+sJPZ+8ZekAuQOYn8NcfDph/GXb7vjNnckEW2vrc7XMXnEfu8tBFDQWSwt2LSE6O3H+YVrrSH1/sz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3113.namprd12.prod.outlook.com (2603:10b6:5:11b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Sat, 7 Nov
 2020 00:12:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Sat, 7 Nov 2020
 00:12:09 +0000
Date:   Fri, 6 Nov 2020 20:12:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
Message-ID: <20201107001207.GA2620339@nvidia.com>
References: <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
X-ClientProxiedBy: BL0PR0102CA0047.prod.exchangelabs.com
 (2603:10b6:208:25::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0047.prod.exchangelabs.com (2603:10b6:208:25::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sat, 7 Nov 2020 00:12:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kbBpv-0015PA-Er; Fri, 06 Nov 2020 20:12:07 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604707935; bh=XXQ+SpzZb5V9OPfmuK/bv7yxrxOa8qNbfruPqSYHmg0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=CpqhAGJA2g38X5aPDdi/KS8mlUkN26wUrolTmHrgKpGhmP6fydDojmM9CMJ2SQDhw
         +/VFSqvFzBbkzgceR8EyoWVhsDxjHqROGxXTWbK/tgxzfQmIbr17IrxqRSTZf4z+Es
         jdXoVboyITmxvpSsnQ6j3kezIOuiFSxPTt5Y6+TfKFIaiaIRpBEtqvd7Am6nkQzz8B
         4Fd4I6NShOrL4mghpp7YcR2S3xWTxnyo0XmMfVHzaTfNZbKV++FkZV/R5PMUFvft94
         8lHOP8qmuv+XfWBbAz2NFwzU9LPjJWVqwd0QHjiS7QwLVHYHXhzmdAWPNiwmVpCRoX
         gggIXWqtU1zPA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 03:47:00PM -0800, Dan Williams wrote:

> Also feel free to straighten me out (Jason or Ashok) if I've botched
> the understanding of this.

It is pretty simple when you get down to it.

We have a new kernel API that Thomas added:

  pci_subdevice_msi_create_irq_domain()

This creates an IRQ domain that hands out addr/data pairs that
trigger interrupts.

On bare metal the addr/data pairs from the IRQ domain are programmed
into the HW in some HW specific way by the device driver that calls
the above function.

On (kvm) virtualization the addr/data pair the IRQ domain hands out
doesn't work. It is some fake thing.

To make this work on normal MSI/MSI-X the VMM implements emulation of
the standard MSI/MSI-X programming and swaps the fake addr/data pair
for a real one obtained from the hypervisor IRQ domain.

To "deal" with this issue the SIOV spec suggests to add a per-device
PCI Capability that says "IMS works". Which means either:
 - This is bare metal, so of course it works
 - The VMM is trapping and emulating whatever the device specific IMS
   programming is.

The idea being that a VMM can never advertise the IMS cap flag to the
guest unles the VMM provides a device specific driver that does device
specific emulation to capture the addr/data pair. Remeber IMS doesn't
say how to program the addr/data pair! Every device is unique!

On something like IDXD this emulation is not so hard, on something
like mlx5 this is completely unworkable. Further we never do
emulation on our devices, they always pass native hardware through,
even for SIOV-like cases.

In the end pci_subdevice_msi_create_irq_domain() is a platform
function. Either it should work completely on every device with no
device-specific emulation required in the VMM, or it should not work
at all and return -EOPNOTSUPP.

The only sane way to implement this generically is for the VMM to
provide a hypercall to obtain a real *working* addr/data pair(s) and
then have the platform hand those out from
pci_subdevice_msi_create_irq_domain(). 

All IMS device drivers will work correctly. No VMM device emulation is
ever needed to translate addr/data pairs.

Earlier in this thread Kevin said hyper-v is already working this way,
even for MSI/MSI-X. To me this says it is fundamentally a KVM platform
problem and it should not be solved by PCI capability flags.

Jason
