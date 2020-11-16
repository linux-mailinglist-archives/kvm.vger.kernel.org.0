Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920152B4ECC
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388202AbgKPSCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:02:55 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:35096 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731246AbgKPSCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:02:54 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb2becc0000>; Tue, 17 Nov 2020 02:02:52 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Nov
 2020 18:02:48 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 16 Nov 2020 18:02:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BG2AL4HpLrMD0VGigJwuNI/rTVeB1LeNHXGT62ezyeHvHaP9OXt85YpuPYFF5NSZomsa/TvlOGd3CEbAxuvSu+PbLrnac8fC7uBtZg5Y0Q5+sXvshd6yAXk8zVzFldo8+BeD/hWKGRaDbcKVPbF4ZTBO8KHubm4kyT41bOWX/twG7wcZnGuPOde54Y77ej4LEXzxECI28FoOscIR1EmkMrBH9zT4RHkcTJnmJRvwwzIWM4FxcUVCQ0bHGcZs3HPYDph2mYKl8ZsSAibBapPv/Kfs27MczOpbfWtCwydO5eIQQw/lksPPuQVarKxaMJgKiMZg9AuuXi4dX1Mo0roQyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gctU42yzXtZmjACsW2kwDKYFXJUjOeLjhgXDkGb+56M=;
 b=NBc8RsQPE+TB/nnB1l4GX5q8HIY3cVZ/DfpDCOViUxPVH89DDwSpVHSxb8wUbXhjzdFxtwFY8K9IioEPSOX+AprS46cTmgYOIJ4jV1DT+ZCMGvXZBg1UB+Ts793NvTwguVb5ltuG5vGc1epw1lQwafFKYOL3L30jkAA/0+GoI8ti0suEje4xJt69jxfsvqZ+TFH5Kv2n20wO466k3dSAxmVfBZCcFvYaFEzD0+NXvrILVB4YBHCR8htWKfdOijB/ig1TLWtvD2HCey9wu2wRWYzp0tdL0U+a6w2vbo2ZSUUgYEhz2MIAi3DSxQGnKwHTK5FrZCFCf0GDPzd0cy+qxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Mon, 16 Nov
 2020 18:02:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 18:02:43 +0000
Date:   Mon, 16 Nov 2020 14:02:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Message-ID: <20201116180241.GP917484@nvidia.com>
References: <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <20201114103430.GA9810@infradead.org>
 <20201114211837.GB12197@araj-mobl1.jf.intel.com>
 <877dqmamjl.fsf@nanos.tec.linutronix.de>
 <20201115193156.GB14750@araj-mobl1.jf.intel.com>
 <875z665kz4.fsf@nanos.tec.linutronix.de>
 <20201116002232.GA2440@araj-mobl1.jf.intel.com>
 <MWHPR11MB164539B8FDE63D5CBDA300E18CE30@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201116154635.GK917484@nvidia.com> <87y2j1xk1a.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87y2j1xk1a.fsf@nanos.tec.linutronix.de>
X-ClientProxiedBy: BL0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:2d::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR03CA0020.namprd03.prod.outlook.com (2603:10b6:208:2d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 18:02:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1keipt-006LE4-Rv; Mon, 16 Nov 2020 14:02:41 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605549772; bh=gctU42yzXtZmjACsW2kwDKYFXJUjOeLjhgXDkGb+56M=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=ZQgW9Ek1MAQdv1H5vhuPRp9uzLSPLBlRmllGTf5kT6x0gDlbk2wDQ4IPcotg/aHg5
         pK5djhjl0/yDPHCVoKWsLLrHl7HL/5I9BR08B1Ii6FvMeUNyERaqt92/MgrvQ9XaIt
         XIQQfOjVg82/s5FtqNsR6pn2JobWhCf0jUlkqRa2uj4EqXYZBWP/f7TjewemKVXSOt
         keVbZrd1sqjEa41qapwrsjKUioqYzT1HlPInLXigFGcDze56UOnwCxMO9bnLXe37xh
         RupXtuhwHr7FIPvXQolrxt80Byvdaa5L0wldZ00arhCwiqQZVPsOuWHTCDd0fnEbVi
         qdNouGZAffTEQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 06:56:33PM +0100, Thomas Gleixner wrote:
> On Mon, Nov 16 2020 at 11:46, Jason Gunthorpe wrote:
> 
> > On Mon, Nov 16, 2020 at 07:31:49AM +0000, Tian, Kevin wrote:
> >
> >> > The subdevices require PASID & IOMMU in native, but inside the guest there
> >> > is no
> >> > need for IOMMU unless you want to build SVM on top. subdevices work
> >> > without
> >> > any vIOMMU or hypercall in the guest. Only because they look like normal
> >> > PCI devices we could map interrupts to legacy MSIx.
> >> 
> >> Guest managed subdevices on PF/VF requires vIOMMU. 
> >
> > Why? I've never heard we need vIOMMU for our existing SRIOV flows in
> > VMs??
> 
> Handing PF/VF into the guest does not require it.
> 
> But if the PF/VF driver in the guest wants to create and manage the
> magic mdev subdevices which require PASID support then you surely need
> it.

'magic mdevs' are only one reason to use IMS in a guest. On mlx5 we
might want to use IMS for VPDA devices. mlx5 can spawn a VDPA device
in a guest, against a 'ADI', without ever requiring an IOMMU to do it.

We don't even need IOMMU in the hypervisor to create the ADI, mlx5 has
an internal secure IOMMU that can be used instead of the platform
IOMMU.

Not saying this is a major use case, or a reason not to link things to
IOMMU detection, but lets be clear that a hard need for IOMMU is a
another IDXD thing, not general.

Jason
