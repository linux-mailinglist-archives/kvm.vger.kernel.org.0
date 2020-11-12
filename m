Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE52B06E8
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 14:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgKLNqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 08:46:17 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7461 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbgKLNqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 08:46:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad3cb00000>; Thu, 12 Nov 2020 05:46:24 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 13:46:12 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 12 Nov 2020 13:46:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZgXYA82z9Jh2bZ0cgpiVBQzB946ddM+7wxdabf3rDQj7ehjr5A7gu7JS/YYcMnlY7LBTw+XIobHMWFcEl5CO5PI2fv8ch4j1AfzjJlnJ/trMS8ffJGko9CoGaV1F3fnZ/lNxmkRQD4jnKM+onjIYYBl5weoBcVcKyaCk+syBOnm6Decr4l12jQ1XUx1dL8ucOjBXW/PbRRAFLAonuKseVSEIMwKr983OiFHgTR/mQW9nTlXKLpIDlPH7/ci7QQU56ObQHDD5iOQpS2NMNTl0AsSR0c8NdZ87MBNr4Q0Kq1wuALRR5hTlqGcwg49kAaOJ+ebP90btC11oQ0uPFgYIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9mez98IR9cHSr04ts+tzikuQTMXzNdMDRHbaqBx8mk=;
 b=miNIEKc/1lMINg6pDLGNenjdb+DphUAyVxtN3JxzMITNAkrJ0UeknnyyukoD4MpV1DKB6v0etBQWIp8Sl88mHsTD2Aa7+BHguEvgdfOtuPkh0hUZBzk+4rXRw1KcxoeTuuSOvei98sLzCv9tPUNc1HKzkAggcnx/InHpNAAd1U/ZORWcraRqhvz/XfArEcdOl5GpGZogHWBPsliFWDb2ac2Kw4A24e0bXeEZrtD3kAchjra2RmhfE6/8zx9s/2p31tB6Q5kVYwKGJ1VwPBMIc34PpI8IJC87cjr+Yc/P0wF9s60EOAXM3eNqZpGYsyQcSaAjPUXGd/G2nEFTU1WAlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Thu, 12 Nov
 2020 13:46:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Thu, 12 Nov 2020
 13:46:11 +0000
Date:   Thu, 12 Nov 2020 09:46:09 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20201112134609.GF2620339@nvidia.com>
References: <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03>
 <20201110142340.GP2620339@nvidia.com>
 <MWHPR11MB16459716A1897F79E860AB4D8CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB16459716A1897F79E860AB4D8CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:2d::36) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR03CA0023.namprd03.prod.outlook.com (2603:10b6:208:2d::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 13:46:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kdCvR-003gjy-Gd; Thu, 12 Nov 2020 09:46:09 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605188784; bh=A9mez98IR9cHSr04ts+tzikuQTMXzNdMDRHbaqBx8mk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=lb0ObooiuuWSH1TibAAww5xzchaityqWIhZjgQbrf8m67g8WS+lMVxbn9WbXnMPgG
         3eP++XYl9eg5Etej+NPRYqgrQVPIfjdc6x6V6tMhCxPh97KEJKVU0YtOHx71ne9pR+
         KQhobRiragL20oxZiySUGUCYm9tnm6AnPpEgx4I0Z2B1kCdpwaTketNYA0Xu5+hn3i
         MwiBkDGm6vhaBIj+qvvhq1tVEvb9g8fk9qiBJyitnr2nld6cUrIQEva19VqDtTUsmx
         JjkfDzTltVvQEPJCfq17VXzGuUXscp4pib0HvVod67rJHfDO2haZz/Q1Q7sAZ1BEpq
         yVqYSBgxbJaKA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 02:17:48AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, November 10, 2020 10:24 PM
> > 
> > On Tue, Nov 10, 2020 at 06:13:23AM -0800, Raj, Ashok wrote:
> > 
> > > This isn't just for idxd, as I mentioned earlier, there are vendors other
> > > than Intel already working on this. In all cases the need for guest direct
> > > manipulation of interrupt store hasn't come up. From the discussion, it
> > > seems like there are devices today or in future that will require direct
> > > manipulation of interrupt store in the guest. This needs additional work
> > > in both the device hardware providing the right plumbing and OS work to
> > > comprehend those.
> > 
> > We'd want to see SRIOV's assigned to guests to be able to use
> > IMS. This allows a SRIOV instance in a guest to spawn SIOV's which is
> > useful.
> 
> Does your VF support both MSI/IMS or IMS only? 

Of course VF's support MSI..

> If it is the former can't we adopt a phased approach or parallel
> effort between forcing guest to use MSI and adding hypercall to
> enable IMS on VF? Finding a way to disable IMS is anyway required
> per earlier discussion when hypercall is not available, and it could
> still provide a functional though suboptimal model for such VFs.

Sure, I view that as the bare minimum

Jason
