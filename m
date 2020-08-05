Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC58623D40D
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 00:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgHEWxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 18:53:43 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:11705
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbgHEWxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 18:53:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kguXirI64+66ywa4zG71ihXQ3Z3TbodRFQeMKjgiEwF0E0vEYW+/6CAoGW0tU89wj5VJRUYYiZWZ/UTIBL6WDjvnEIAJyxOQqM4EQhtypN7jqFwF9cfF9DPnrHZ0D64GIJO80nbf4UySFE5t9VYz2aCkoNxj7jqI1QhEdABE9mr1c/RzOPMH5xD7G+nlm/1EI5uGmLWOdhYHjmSqJrsGHo71rXjXurW5YL8wxRYlTC0ma0n4YBGjQNJX7x+u68RV+arge2mYbq9gpVck+SKoMzcBgIDOQgBDFIxKZhBBYvY4AHg184vqLhsmjYPu7ILCArCv07PYuOMnrxNRLB1JfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mb3nMirv0j3tBeZcby2rD2tRHAkRgJBNJyywU3OdpCU=;
 b=myMGxMj1F2VBvmJJV3kjnGvU+8N5bawMHVTv9G1KQVgU0D/DeQOarOK/4UMlXsO3UYlvEuhHAYGGcMmELJrNkfXvKdPT7+3FYFHxXkHNdt3EpGFxfD+zL5AAMasdUCv2ivvIF+bXcNR+zwf3YBPQuHO+YfBABpLX6dnzQ+AEOp3/fNHslvayOjC3h6WN0ScropZhBZtTrXAummrwyn4KwOp+0dA6VluSnTVTzmlfYVcv9ix0tKkahvWL7qdR1N8dopcsWurC4OdRwVwiX80OhVVXySjPaS2fd/e9Ur/1CI/B0pA9TErfUU9bFxYD+oUxhAvj8EIVQFF6AqjMCrATgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mb3nMirv0j3tBeZcby2rD2tRHAkRgJBNJyywU3OdpCU=;
 b=l1yFs0Xtml4gZ3t+zXWjDMBAQrBxzL8VILRrP1OJhuGgm01jRaMbDb9fy0193bHSo37nimGcJ+R6ihIx9lmtmCxo5VR6V9kWAe30+mCtZuSafKIB6jKGbOjOU8CcLRw+Bb8ezYxJSrEStO88h3/GvBPIrMT1FzzJEDdiKqdETd0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB5182.eurprd05.prod.outlook.com (2603:10a6:803:ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Wed, 5 Aug
 2020 22:53:35 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a%4]) with mapi id 15.20.3261.016; Wed, 5 Aug 2020
 22:53:34 +0000
Date:   Wed, 5 Aug 2020 19:53:30 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200805225330.GL19097@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org>
 <20200722195928.GN2021248@mellanox.com>
 <96a1eb5ccc724790b5404a642583919d@intel.com>
 <20200805221548.GK19097@mellanox.com>
 <70465fd3a7ae428a82e19f98daa779e8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70465fd3a7ae428a82e19f98daa779e8@intel.com>
X-ClientProxiedBy: MN2PR16CA0020.namprd16.prod.outlook.com
 (2603:10b6:208:134::33) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR16CA0020.namprd16.prod.outlook.com (2603:10b6:208:134::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Wed, 5 Aug 2020 22:53:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1k3SHq-003yhY-TT; Wed, 05 Aug 2020 19:53:30 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 038788c9-c871-4643-77ce-08d83992620b
X-MS-TrafficTypeDiagnostic: VI1PR05MB5182:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5182F1EABDF0C3902228AB9BCF4B0@VI1PR05MB5182.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g1k2tm8U4uFHG4iLsST/mxf0EWKp3IVeZkyQrCIuvOZcENDHzzADbeiUWFGO4V9TQlXaQmLHUUUmtTFV0zggnl4jeq71bzNhyqlph72QIGBxgYnEGkwTnqc6f6rhMKLXKACKulLRPgrIF2ye4oPcmvG+tdEH8Cf64PY9muMZZKsrjhjx+tXApgPbPq9sV0dGyLsAtuOQ9re7fC9k45P62nwCVEWWz8VoEDjW7QM4fCd63nL6x9SStw+iG4/4JajCe5m3ne+3OviqLcqJ/bmr8AI7rt1KMCyXVDoGEqxtdgMZNKxEzG63i4tmgEdAxXZtrEDNKCzIK0ULrUFpCH8ciQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(478600001)(26005)(2906002)(316002)(8676002)(4326008)(8936002)(186003)(83380400001)(33656002)(54906003)(426003)(7416002)(6916009)(7406005)(86362001)(53546011)(66476007)(66946007)(66556008)(36756003)(9746002)(9786002)(2616005)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: s4xRQ/SgZOLTTLiA1M/1UWzsDoRMMGswXzch9oXJKKCEKhQuyWGRHyUYYuhpkC3tZpJ8FKhGnoNTcavT4QvG3S7280htCiyalb6Ez+q9dMZF5vNlz1rC1QwWAIh9yGAWYjuEANXPx2HyNSNeylnbqKrUEyU64ut9tzEbUmGvTvp/vYmjC1k3zJu+vmv2/m5kbjNsSM1yD8PCyyQN7eE8JkxcmiSKDc2AFEtWn4J5V+mzYWcomL4C0+cNag4D9pbZw5vsIEQ7b07pxpj3UJDykWx/d3Mi1j0aMzZO4rj7zbDIVr/3F9ypqeEaEn5xAx7mDaaAbauRxru5MQkxwM9lco17lYhXtNkn0x4hdDx2ZFC9pg7MSoymBGu5hjPOzgAsw9MurlcvI9Xm2LPSngH/dR+4lOxz2TpWO35MlKl90+dho3Zb3zkP4nnpaa2UVdDT/7hl6IUXC0VnsDCGYFh8VNncuDyR1nH1He6C+ywo6Z75soyp/A0O9KtgsyyYpzlWcwQoC936mBMxHcabvQAga1vGT1ubUQAYnNnBQB7pIZ+mUigvMYJ1FrEnU0bThzb48qx/Du+fgMOsboBb3lPn0iFaG6mdhKTgaKABlpClgfsL5HVZRssacBEwtku0kbB7UtrIdv6fVgtXMSLVwjwZgg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038788c9-c871-4643-77ce-08d83992620b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 22:53:34.8121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4UhnXpLhaBk2FKnMHHq8JP+beAMSBTetIWlcEnUhg1blNHd6KbgRIF4/TA/y6eNpxbANHqQ4vEC5Y1lgr3KGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5182
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 10:36:23PM +0000, Dey, Megha wrote:
> Hi Jason,
> 
> > From: Jason Gunthorpe <jgg@mellanox.com>
> > Sent: Wednesday, August 5, 2020 3:16 PM
> > To: Dey, Megha <megha.dey@intel.com>
> > Cc: Marc Zyngier <maz@kernel.org>; Jiang, Dave <dave.jiang@intel.com>;
> > vkoul@kernel.org; bhelgaas@google.com; rafael@kernel.org;
> > gregkh@linuxfoundation.org; tglx@linutronix.de; hpa@zytor.com;
> > alex.williamson@redhat.com; Pan, Jacob jun <jacob.jun.pan@intel.com>; Raj,
> > Ashok <ashok.raj@intel.com>; Liu, Yi L <yi.l.liu@intel.com>; Lu, Baolu
> > <baolu.lu@intel.com>; Tian, Kevin <kevin.tian@intel.com>; Kumar, Sanjay K
> > <sanjay.k.kumar@intel.com>; Luck, Tony <tony.luck@intel.com>; Lin, Jing
> > <jing.lin@intel.com>; Williams, Dan J <dan.j.williams@intel.com>;
> > kwankhede@nvidia.com; eric.auger@redhat.com; parav@mellanox.com;
> > Hansen, Dave <dave.hansen@intel.com>; netanelg@mellanox.com;
> > shahafs@mellanox.com; yan.y.zhao@linux.intel.com; pbonzini@redhat.com;
> > Ortiz, Samuel <samuel.ortiz@intel.com>; Hossain, Mona
> > <mona.hossain@intel.com>; dmaengine@vger.kernel.org; linux-
> > kernel@vger.kernel.org; x86@kernel.org; linux-pci@vger.kernel.org;
> > kvm@vger.kernel.org
> > Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
> > irq domain
> > 
> > On Wed, Aug 05, 2020 at 07:18:39PM +0000, Dey, Megha wrote:
> > 
> > > Hence we will only have one create_dev_msi_domain which can be called
> > > by any device driver that wants to use the dev-msi IRQ domain to
> > > alloc/free IRQs. It would be the responsibility of the device driver
> > > to provide the correct device and update the dev->msi_domain.
> > 
> > I'm not sure that sounds like a good idea, why should a device driver touch dev-
> > >msi_domain?
> > 
> > There was a certain appeal to the api I suggested by having everything related to
> > setting up the new IRQs being in the core code.
> 
> The basic API to create the dev_msi domain would be :
> 
> struct irq_domain *create_dev_msi_irq_domain(struct irq_domain *parent)
> 
> This can be called by devices according to their use case.
> 
> For e.g. in dsa case, it is called from the irq remapping driver:
> iommu->ir_dev_msi_domain = create_dev_msi_domain(iommu->ir_domain)
> 
> and from the dsa mdev driver:
> p_dev = get_parent_pci_dev(dev);
> iommu = device_to_iommu(p_dev);
> 
> dev->msi_domain = iommu->ir_dev_msi_domain;
> 
> So we are creating the domain in the IRQ  remapping domain which can be used by other devices which want to have the same IRQ parent domain and use dev-msi APIs. We are only updating that device's msi_domain to the already created dev-msi domain in the driver. 
> 
> Other devices (your rdma driver etc) can create their own dev-msi domain by passing the appropriate parent IRq domain.
> 
> We cannot have this in the core code since the parent domain cannot
> be the same?

Well, I had suggested to pass in the parent struct device, but it
could certainly use an irq_domain instead:

  platform_msi_assign_domain(dev, device_to_iommu(p_dev)->ir_domain);

Or

  platform_msi_assign_domain(dev, pdev->msi_domain)

?

Any maybe the natural expression is to add a version of
platform_msi_create_device_domain() that accepts a parent irq_domain()
and if the device doesn't already have a msi_domain then it creates
one. Might be too tricky to manage lifetime of the new irq_domain
though..

It feels cleaner to me if everything related to this is contained in
the platform_msi and the driver using it. Not sure it makes sense to
involve the iommu?

Jason
