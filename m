Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470EF2B0609
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 14:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgKLNKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 08:10:40 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:63551 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgKLNKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 08:10:40 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad344e0000>; Thu, 12 Nov 2020 21:10:38 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 13:10:33 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 12 Nov 2020 13:10:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVd01kg2tjyVBMaqiGnm6cOmaBJhx2N6YDH2z9U10K26yj3oJGMh2UTTxagRMyJnNaiQByG/Nb+IciZwXyV7L1Ltkf51FyTDRc8qh13srDUvH/nzwUhW+i+QrLNZaovNuky0yPMvyUvqlDqcOIYpFi+pMrZra6fDxAnzynpm4XRQ2kSC2pHVB+RSRl8t/h3KEYEbSmMFzB10P004UjwLda45gsnrVBY/ghwzW44EKBGosJ9vlPXnyoKFRFUEdTWJ6gAc3bPmZc1hgPwymPyNSMx8eV2iJl9tnaPHL6+u71GUuMYSnafdDJ8aOx0u+NU1B6QLUKaxYcheYOxxCeoLfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDzWZV5PMJTQTEmEpY/tlijlKuercM8A1+TCvshb8xI=;
 b=DC2pfd+eLATVO72X1yeyT6pvq8lX5rzI51JgqRgzr+MxedKsDOXBwLN+h9YMPr+b6zGyhdKdlgT6h6taasUGhxVSHVN/PRSdHg5L7bGIp0nPV52XZjOcHzJryGkF7B1yXlkXWOd+mGNxNH45fRt4AlGkpbNBi0pu8fAyh8dtA8Beu8Osu8JBVjCxgJ5QHTX5ljf03f8qBLs/JG/mb+VgXGYntBkIyqNOudEpuXNcbahRuP9hkSRsJBy6Q0cX54Iw5qjajjZxA785dTk9Ct7reydj7yhMoffRTjwGHl/F2iDWOt8TMw66geU3LPsPUjq0Kb8IlsyiDaY09mLtMhu1Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4636.namprd12.prod.outlook.com (2603:10b6:5:161::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 13:10:28 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Thu, 12 Nov 2020
 13:10:28 +0000
Date:   Thu, 12 Nov 2020 09:10:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
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
Message-ID: <20201112131026.GB2620339@nvidia.com>
References: <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org>
 <20201111154159.GA24059@infradead.org> <20201111160922.GA83266@otc-nc-03>
 <87k0uro7fz.fsf@nanos.tec.linutronix.de> <20201111230321.GC83266@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201111230321.GC83266@otc-nc-03>
X-ClientProxiedBy: MN2PR01CA0040.prod.exchangelabs.com (2603:10b6:208:23f::9)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR01CA0040.prod.exchangelabs.com (2603:10b6:208:23f::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 13:10:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kdCMs-003fVN-EB; Thu, 12 Nov 2020 09:10:26 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605186638; bh=JDzWZV5PMJTQTEmEpY/tlijlKuercM8A1+TCvshb8xI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=ocIcSCQRr32Jb5ucGC891UICEaV/T3IYesXRfdM0vAyHRpcHgaAxyDGHg5S1G32cM
         lgvbLs2kGS0uv6okW4tjRGXHBoWtVeIcwd+T2DAO03rH6i5LewUI8b0Z4qbtnQ/GQK
         phzWm/0JMnegWAjkGUJPMfbz9QnmmpsbDJF0rTM5BhbbsoNWjh5arl53O/oIOQ+tGq
         e3QvooR7GwlfU645b+hxIklhgVcvr3JX8nRMaXszlUSFVrSYMqYegYcxeoZxsz5h4q
         TljFci5TVPRAuZrDPa0YPuRj3wQfiac3bT9qARgXfsF7WBN4iU3SS1gJ+8W6HRlIuL
         6zDsO4rgcYW7g==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 03:03:21PM -0800, Raj, Ashok wrote:

> By default the DVSEC is not presented to guest even when the full PF is
> presented to guest. I believe VFIO only builds and presents known standard
> capabilities and specific extended capabilities. I'm a bit weak but maybe
> @AlexWilliamson can confirm if I'm off track.

This also need to work on Hyper-V and all other cases, you can't just
assume everything is vfio and kvm.

It is horrible to ask people to go back an retroactively change their
config space in a device just to work around all the design failings
Thomas eloquantly describes :(

Jason
