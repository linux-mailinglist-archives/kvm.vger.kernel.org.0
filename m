Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2A32AD887
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgKJOTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:19:13 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:3819 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbgKJOTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 09:19:12 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5faaa15e0000>; Tue, 10 Nov 2020 22:19:10 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Nov
 2020 14:19:09 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.57) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 10 Nov 2020 14:19:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWcsI0YFJtTgaz6My2DD1yOWPMb2UV4HRe5f8yWyK/KJZOCDLY9e9Y/u8ZBRzXXcxIsf7gpEnwS/+barDXiG8HHM9RUXEwYpYh6z7eLGXs3ygu3KuJWg5fUrh6ud1+PHHrPjNWrNcf4zfGK6ScZe0ck98YMKPJUWLcvEWfDO4WS03jmQmQmUtrsvY3i/gDwuMh6BxnN7mg+az1lU8rOPSGh8LaMekh9DefaLJvys8NooggoTsg44j0wDMNuITCpdZNx3ynyXypsrpPqTcIQGECRoIZvfpe+9GAzW229JgajRV4vIjzv54WlxiK1nnErjUmBuu0likgd1NRamMsImAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EuC9e2e4SYCsCPrdGYOup6bsNVeR1tqITIEOBMGl+KU=;
 b=MKb0JFcsFdpkJ7kJtE4BUSfwDXVW2KY+SETLJw27/EJyYcl5cTD3gAgwV+yx5YqiFaAhCcrmpNnvucagU/571ftyT/tn2fZBp0FOBjE5M9SHs74mSYuCQ//y1mPzLfyGlraPn2pyhgmqFoClaPri7VO98HYd+ItTP9J6xz0/68kWmnG9RteQjsq+82/O5cZGJniPiYgoIomZpxXVYN4bFIQAVHuJL4CQDn5T4juKIAyvuy0sEIaHa+oTC/uHcUTfsUOSmfaOKGJrl0jX5BOPNNjULCGWNaaQuUsAmwB7M5+BsgFyFnaugfT2o3qhbHeTyWYB31LqjyZx023VF6NqJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 14:19:02 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Tue, 10 Nov 2020
 14:19:02 +0000
Date:   Tue, 10 Nov 2020 10:19:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201110141900.GO2620339@nvidia.com>
References: <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201110051412.GA20147@otc-nc-03>
X-ClientProxiedBy: BL0PR02CA0098.namprd02.prod.outlook.com
 (2603:10b6:208:51::39) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0098.namprd02.prod.outlook.com (2603:10b6:208:51::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 14:19:02 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kcUU8-002Qnu-Td; Tue, 10 Nov 2020 10:19:00 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605017950; bh=EuC9e2e4SYCsCPrdGYOup6bsNVeR1tqITIEOBMGl+KU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=SxDagDE0Unw/qz1cnDO1zMo0f4i3z1qe7entKgzoKNYBQlMwhFwo49w0SrnP7LUfJ
         xu3hXlSX8Qu1KX46W9aBRp1gQmO8wBLWsOuCd4bSnbEPGgjU+t8pIeUGUMs8OIyVpt
         xhvwwwwPHTmsDGkyI8GwmKtEyJHL/9z8IzA89vRLDdzzqVjjwGqHBAyUzmVjPiTyYO
         ApkN17Q3dODZqClS8vwd8pqZ9HPFU7tHpd/mAzs4TWNLeJcFsguo/gIG0tLsrKIRVf
         0cz+GZF04PVY2dd1lJLav/xB/yT0pxCXn3bbDlgT1fJtnQDC8iWN4ZQs8xq+VUT+dE
         gv5AHHWwXhRJg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 09:14:12PM -0800, Raj, Ashok wrote:

> There are multiple tools (such as logic analyzers) and OEM test validation 
> harnesses that depend on such DWORD sized DMA writes with no PASID as interrupt
> messages. One of the feedback we had received in the development of the
> specification was to avoid impacting such tools irrespective of
> MSI-X or IMS

This is a really bad reason to make a poor decision for system
security. Relying on trapping/emulation increases the attack surface
and complexity of the VMM and the device which now have to create this
artificial split, which does not exist in SRIOV.

Hopefully we won't see devices get this wrong, but any path that
allows the guest to cause the device to create TLPs outside its IOMMU
containment is security worrysome.

> was used for interrupt message storage (on the wire they follow the
> same format), and also to ensure interoperability of devices
> supporting IMS across CPU vendors (who may not support PASID TLP
> prefix).  This is one reason that led to interrupts from IMS to not
> use PASID (and match the wire format of MSI/MSI-X generated
> interrupts).  The other problem was disambiguation between DMA to
> SVM v/s interrupts.

This is a defect in the IOMMU, not something fundamental.

The IOMMU needs to know if the interrupt range is active or not for
each PASID. Process based SVA will, of course, not enable interrupts
on the PASID, VM Guest based PASID will.

> Intel had published the specification almost 2 years back and have
> comprehended all the feedback received from the ecosystem 
> (both open-source and others), along with offering the specification 
> to be implemented by any vendors (both device and CPU vendors). 
> There are few device vendors who are implementing to the spec already and 
> are being explored for support by other CPU vendors

Which is why it is such a shame that including PASID in the MSI was
deliberately skipped in the document, the ecosystem could have been
much aligned to this solution by now :(

Jason
