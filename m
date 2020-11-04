Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273782A648F
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 13:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgKDMk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 07:40:27 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17461 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgKDMk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 07:40:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa2a13d0002>; Wed, 04 Nov 2020 04:40:29 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Nov
 2020 12:40:22 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Nov 2020 12:40:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmYAVJO2QrUxvwSNB19uV80Hi88BnFcjbTNHj0sLwe5IpaUJIg207TunnEz00GO/Lv9id6/cu08pPZH7WTE5vFnNGvRDoeMEw1J5ZgMRKOIkz9F8BAggDCDzXArq5b2kNvLW9Ihi00jrUdwrJsobhfoWPCHcRFH5DCmptZbzBUNineEp3pLpKnL0s0RN05+HHBPit4KbruW6G/11iIQZboNcl9s6HqtbEr9c1o+6V9aClv8fKZpYOwBkgOg5He0aT661WhWhrjRwRZdR4D8Bc393NTG90aIQrmP+1QH6HZaXflLwWEVMr72wMc5tMXMqR2VWT0cmkqwdaW9xhZZesA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly2oeyLHt+9xgCf6InlNFupONQhHnN+seyBdY1snqFM=;
 b=odlSa3ap+GvgJ5VD0+NueY8IyQVMLmhW8cDIN+TvMnn6YiyxUEXw0uVwDyv0/6LC6kirk9yfbExq3n8kmIYsWfX4qf16/CQAh4cJmnGq/ohh+jfjlEhsemAOHlE1K16HPXyPQLnNMEuFNuEKPnVDqT+m0x+cWp8FILeNIC4sFngfoFKsNY5gkGUuOPes2GEDc5sLnfc6wy6o6Ljz5xjPGbSo/+yrU6LQ/SQ0wLfzH7ZRDUiQ76xbzd/nc6GdurQHy9cwBnMWRfn3BrS1G090nZIntiuLScaO6UdKW3W+2eT0Yj+pmQXsj6SeZDnbhtmIE9e/wZbVdQnIBLdM5Cu7gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2439.namprd12.prod.outlook.com (2603:10b6:4:b4::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 4 Nov
 2020 12:40:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 12:40:19 +0000
Date:   Wed, 4 Nov 2020 08:40:17 -0400
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
Message-ID: <20201104124017.GW2620339@nvidia.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR22CA0003.namprd22.prod.outlook.com
 (2603:10b6:208:238::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR22CA0003.namprd22.prod.outlook.com (2603:10b6:208:238::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 4 Nov 2020 12:40:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kaI5J-00GU44-LN; Wed, 04 Nov 2020 08:40:17 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604493629; bh=ly2oeyLHt+9xgCf6InlNFupONQhHnN+seyBdY1snqFM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=Fodb48BRizFtyLLl2nCM6FAknIzBy0v3MMHEJlFDmeQJ7Rtru0ycAtDwJX/1RS688
         H3EQrsy4oQQtO9OPvoO230V97TPEYgWwHlr2PMnDcXCD6Z8XvsALcnuMh6hWKm1YgO
         Wa/lad7AY3njLf81mp1fVFjaJ6BjucLUhowWxGAaxyZLJzVDj1QjlQTN65ZTQeYILP
         JCZmC92zcdbMXDxpeZB6I6k/5SRBBSNtVX10O6lPLizqit+kMBx+NUtZYFzCwCkkXO
         VFxuEOHN/l3lSa8SWiVsyzV9kO6V4X0blymDK65UmdUoPGKfTw5DelnufLrUfeV0na
         CHmR8JyLD9/RA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 03:41:33AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, November 3, 2020 8:44 PM
> > 
> > On Tue, Nov 03, 2020 at 02:49:27AM +0000, Tian, Kevin wrote:
> > 
> > > > There is a missing hypercall to allow the guest to do this on its own,
> > > > presumably it will someday be fixed so IMS can work in guests.
> > >
> > > Hypercall is VMM specific, while IMS cap provides a VMM-agnostic
> > > interface so any guest driver (if following the spec) can seamlessly
> > > work on all hypervisors.
> > 
> > It is a *VMM* issue, not PCI. Adding a PCI cap to describe a VMM issue
> > is architecturally wrong.
> > 
> > IMS *can not work* in any hypervsior without some special
> > hypercall. Just block it in the platform code and forget about the PCI
> > cap.
> > 
> 
> It's per-device thing instead of platform thing. If the VMM understands
> the IMS format of a specific device and virtualize it to the guest,

Please no! Adding device specific emulation is just going down deeper
into this bad architecture.

Interrupts is a platform issue. Using emulation of MSI to dynamically
insert vectors to a VM was a reasonable, but hacky thing. Now it needs
proper platform support.

Jason
