Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D1E2A9B38
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 18:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgKFRvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 12:51:40 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3612 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgKFRvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 12:51:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa58d2f0000>; Fri, 06 Nov 2020 09:51:43 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Nov
 2020 17:51:37 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 6 Nov 2020 17:51:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDIrYVgm+MI5AhY6JoZ/CjXaSW5z1rp6bx1ieH0iRvO52D0b8E0LsmuvN4RX6Ia0rbTaNxsnfJudfsYieErKHuLsTAmf/g0FGAs/1tAIHoo0DsthdLkaP7ARb/glC3T3OXqMLQXqEdIj2/RzZyPz4WuaCJCJujphWcY9suScOPtLdF3qEoTpgA8M/qn2I1/XQEBWrx/Jn0qdc+GV08uMdOSePtqNr4ntDExsBf8mkDCp3yXcq/HYXdQRFilwHFdFlos+hxIGOWp2XU6K5bm9cCcHSjzOFFs8V95M0viy/fGntQwyDF4KDIhQ2TGRpSChEfiSLzagixV/Fkfiv2JFbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DSePUoQ6vl4qfuoUwGYHLoD0BveDxxjeobSHmvrAAY=;
 b=Zeb53IRgPsYILnrkU5QkyEeAJ08R80xcc4idFDTBgv1P32YVlsApD9qzFHHWHFAdBEZIVJHQ+1e7UlTm5el9AHxKCIVDje+FgJOSprM8wgMe6VccpqL+yVaUorEEmU5m8ZZpHrwcnUAIV37I8XVTS7JLCLFEYwt9Wal4N/cDNfsnzqtWJW5NbNqZqpffzfDC2hCbPS164TQ4iSYbAWbJzgq+TeF4oj2ruyWVru7ghkZBHtviTMPjdErArbOSkTCAoo5kxnC4imkOo7SDzWKre4tIzVOV9YZO+yyM0QrHzL7oLou9ZYbSyNvKYV2s9W2ZUBT1AxtoJiNyU+qnkHlHQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1145.namprd12.prod.outlook.com (2603:10b6:3:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 6 Nov
 2020 17:51:33 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 17:51:33 +0000
Date:   Fri, 6 Nov 2020 13:51:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20201106175131.GW2620339@nvidia.com>
References: <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201106164850.GA85879@otc-nc-03>
X-ClientProxiedBy: BL0PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:91::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR05CA0021.namprd05.prod.outlook.com (2603:10b6:208:91::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend Transport; Fri, 6 Nov 2020 17:51:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kb5tb-000zdx-Vk; Fri, 06 Nov 2020 13:51:32 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604685103; bh=8DSePUoQ6vl4qfuoUwGYHLoD0BveDxxjeobSHmvrAAY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=qjaWebqqfQ87Xcu9Gsl7Z8tT1Mk/2+WDlzwkefsGy0vRjJh5BsXW5elfSz6TMyVC+
         TN0Vg+YB3W6avTOX+ONRFKqMJQtw6hhrNsH4ietTaGR9ph3j7UeY1erMrLgRpWZusw
         P5SHq+5n2z/GONY3KgZZQgqyLOv8O7QNrCVIhAQF6SDacC0BtSrVccbI/2Q/P+EPf4
         yJ3bBFlGAgoUgwCTeQZwywB4fgvWTFyIdIdr6T67zmvV403n0brsv7AcJt4iwezHsv
         xTuXMsmMfiSOTBn8LdNTbzSZiCF07ieuPDig7v6YbgX9ynFGMC7kI5y/yo00C8gOxv
         4PfjKf0RxG40Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 08:48:50AM -0800, Raj, Ashok wrote:
> > The IMS flag belongs in the platform not in the devices.
> 
> This support is mostly a SW thing right? we don't need to muck with
> platform/ACPI for that matter. 

Something needs to tell the guest OS platform what to do, so you need
a place to put it.

Putting it in a per-device PCI cap is horrible and hacky from an
architectural perspective.

> I missed why ACPI tables should carry such information. If kernel doesn't
> want to support those devices its within kernel control. Which means kernel
> will only use the available MSIx interfaces. This is legacy support.

The platform flag tells the guest that it can (or can't) support IMS
*at all*

Primarily a guest would be blocked because the VMM provides no way for
the guest to create addr/data pairs.

Has nothing to do with individual devices.

 
> > The OS logic would be
> >  - If no IMS information found then use IMS (Bare metal)
> >  - If the IMS disable flag is found then
> >    - If (future) hypercall available and the OS knows how to use it
> >      then use IMS
> >    - If no hypercall found, or no OS knowledge, fail IMS
> > 
> > Our devices can use IMS even in a pure no-emulation
> 
> This is true for IMS as well. But probably not implemented in the kernel as
> such. From a HW point of view (take idxd for instance) the facility is
> available to native OS as well. The early RFC supported this for native.

I can't follow what you are trying to say here.

Dave said the IMS cap was to indicate that the VMM supported emulation
of IMS so that the VMM can do the MSI addr/data translation as part of
the emulation.

I'm saying emulation will be too horrible for our devices that don't
require *any* emulation.

It is a bad architecture. The platform needs to handle this globally
for all devices, not special hacky emulations things custom made for
every device out there.

> Native devices can have both MSIx and IMS capability. But as I
> understand this isn't how we have partitioned things in SW today. We
> left IMS only for mdev's. And I agree this would be very useful.

That split is just some decision idxd did, we are thinking about doing
other things in our devices.

Jason
