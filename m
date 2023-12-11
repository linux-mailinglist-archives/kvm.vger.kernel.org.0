Return-Path: <kvm+bounces-4020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE80080C1D0
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 08:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 384901F20F9F
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 07:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66C3208C2;
	Mon, 11 Dec 2023 07:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AVWsp+A2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2D8F2;
	Sun, 10 Dec 2023 23:20:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIQ3f4czFs0cFugY7CwM21Bbv4zzMNcUdFQdQvavQWQ6xBteFngpK8XB94qVVuEc/RKCgTG4+0olS2BGWMepyOdsZe/m2hNM569LMqjAEPdenKnzBol2KOb7BhONH9ZKK3e/iIZ1waL+kszHNQXzZXMGxlf128Ob2HnOaTuQVumnLUKGNY/Vc8wVST5iVgHNLscq80OVpE8vZejO+JBsznuirciVCrpLQFu8lu1t0phKdWwwZ2AbkcpwqILnw64ZDhdV/QG/L7T5WWEgICKQrz7BsaQETe1nrsu/YsIX0Hjkn7HsRxVJ+wATUc6xpuW9R9pXmD46F6Sz7dOiRHq/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILr2PIbPVD8nXmTq6uHymv9RfSB901es2i9JuceHKNg=;
 b=ApkKSBoSPjvLgNhfLBbMyz6dIC8E/izo+WOhuGlbFr3R5kn0HNIKtuxbF7jwICVOm3Upi5F89ot7t5IPPd6BklCchCSXDJ2ERLiLH7eYtLL8Qd1jLD/xbvWg2NL4ZjzSLsn2lj4R8UK8WxZzRbP0TuFkMsRzNP1QCCnVynuKAOQQhhToOILSmC398i+W4iVJ13g+bi+jX33aCIivMKe8p0+R86PPOL+g0HJyaj8OOWzn6TdFmcPNPbSc9aTTF087pDKN7aV39yaT5AGMumZX9vhpYV3ND8Jxs39mT3m0gme5o3OPDEwfmn88i10UAeKgQ2cmMaO4FyKq/z1M6EdjMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=samsung.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILr2PIbPVD8nXmTq6uHymv9RfSB901es2i9JuceHKNg=;
 b=AVWsp+A2rrRZH4fzmXNRGY/MXq4RA4UmmICTY0Nu2o/lJUMSySmYOV4YZ820aat0m13s36tiT8xxoLqhSnjSK9wmy++rfXKLDlxBYPB57rP6/V+gxE29vlRp0pcboV6bXckU1HHOdgv6aP5Utbwk6riGo9/n7xDef2HwPmf++X+JReRSiK3cOVjuP4zPd7fe6LDGeOa+3LvYciw0RqoFnpRgVpA2gdiR2dwCwNzl+PMv+0m1pbwZ5zCSfuDB1mTIE43G3PfQpRUp/jbhTtWMntwUYc/4PsL8e2aJ54Uq2x9T00v8pxdAZiWAEn9uxGqEVNrp4ZuvhBm3x8y3VCpokw==
Received: from DS7PR03CA0048.namprd03.prod.outlook.com (2603:10b6:5:3b5::23)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Mon, 11 Dec
 2023 07:20:21 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:5:3b5:cafe::ba) by DS7PR03CA0048.outlook.office365.com
 (2603:10b6:5:3b5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32 via Frontend
 Transport; Mon, 11 Dec 2023 07:20:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.18 via Frontend Transport; Mon, 11 Dec 2023 07:20:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 10 Dec
 2023 23:20:10 -0800
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 10 Dec
 2023 23:20:09 -0800
Date: Mon, 11 Dec 2023 09:20:06 +0200
From: Leon Romanovsky <leonro@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Jim Harris <jim.harris@samsung.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>, "pierre.cregut@orange.com"
	<pierre.cregut@orange.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Message-ID: <20231211072006.GA4870@unreal>
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
 <ZXJI5+f8bUelVXqu@ubuntu>
 <20231207162148.2631fa58.alex.williamson@redhat.com>
 <20231207234810.GN2692119@nvidia.com>
 <ZXNNQkXzluoyeguu@bgt-140510-bm01.eng.stellus.in>
 <20231208194159.GS2692119@nvidia.com>
 <ZXN3+dHzM1N5b7r+@ubuntu>
 <20231210190549.GA2944114@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231210190549.GA2944114@nvidia.com>
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: 815f3972-c440-49c6-7a79-08dbfa19a244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	au3kKBIayMmEnbmNYDusrgU/wabNTLCErDgfk96eweyp3cU6aYqISJoV1M8yK4QGwO+CwPmPCt8itfQTThk6PYjByYj84EwBFn1tH6aSvx0TjYJGGHxGLgdHxd84YB2thpnpQoLqvw+Dqm7I0oG3q3x8TXAvyhFgPeT2lKApTBUDP6271jB3nm2I0KGOqs2UZQv/Cj28bL2sylY3Gp15CW1eUji0QD0MitGcZCK7qwNExt3JR0/NDDS3747hnDH4MV1AZgkmFz4h3olLAFE+y4ddsVQWN+BWqoc7YFo0WizcRaxS1WSe7RK7TXrTl2UTA2NLkQPjqaclxP7YOucaOFqeYa6ZFRjyDHS9KkCxnIIKfF6/UORnD/bPz5+t7FfOgWOjeTAqj5o4GtgXJT34mBTsdQKv7YeNV/5UoN9/rQ0CIenML8py3EPYphrxrzXT6iINuvup2uKOVByKgnyNY3AEJuu9ov+OVAMLLHkfsCWAo3UUY6xkysQ54pwn+wjRBZCgUyOGAkMJCZVnSJawSANaZaV7h12ByeNCzS+GCzImmKderFpyQ/dZYPfOdJCNlMjcEbZDYG1TiMcHLPjosA0fdkxE2hvHcwkrT7AjOfLtmBaGEk+vxFfapg0EkZowCYN7ueSOWaJGtj1XLYo+S8cMJJGL8yoRognmppD144Ahd6L1394H42KQPfjkDzO7Af1DUx1VU5PW8GzimTQuePVJeDn8fcIMGEpLK4auesYahTZJIJpI8dZqHRBMUk2NFj0b7q3FCKm97torlu7oGaCVJ2p9wzzTvcekbpb6/oA=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(7916004)(4636009)(136003)(346002)(396003)(376002)(39860400002)(230922051799003)(64100799003)(451199024)(82310400011)(1800799012)(186009)(36840700001)(46966006)(40470700004)(40480700001)(33716001)(41300700001)(40460700003)(2906002)(5660300002)(316002)(4326008)(8676002)(8936002)(70586007)(54906003)(70206006)(7636003)(356005)(82740400003)(9686003)(33656002)(86362001)(110136005)(36860700001)(47076005)(966005)(83380400001)(26005)(478600001)(6666004)(1076003)(16526019)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2023 07:20:20.5017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 815f3972-c440-49c6-7a79-08dbfa19a244
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7614

On Sun, Dec 10, 2023 at 03:05:49PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 08, 2023 at 08:09:34PM +0000, Jim Harris wrote:
> > On Fri, Dec 08, 2023 at 03:41:59PM -0400, Jason Gunthorpe wrote:
> > > On Fri, Dec 08, 2023 at 05:07:22PM +0000, Jim Harris wrote:
> > > > 
> > > > Maybe for now we just whack this specific mole with a separate mutex
> > > > for synchronizing access to sriov->num_VFs in the sysfs paths?
> > > > Something like this (tested on my system):
> > > 
> > > TBH, I don't have the time right now to unpack this locking
> > > mystery. Maybe Leon remembers?
> > > 
> > > device_lock() gets everywhere and does a lot of different stuff, so I
> > > would be surprised if it was so easy..
> > 
> > The store() side still keeps the device_lock(), it just also acquires this
> > new sriov lock. So store() side should observe zero differences. The only
> > difference is now the show() side can acquire just the more-granular lock,
> > since it is only trying to synchronize on sriov->num_VFs with the store()
> > side. But maybe I'm missing something subtle here...
> 
> Oh if that is the only goal then probably a READ_ONCE is fine

I would say that worth to revert the patch
35ff867b7657 ("PCI/IOV: Serialize sysfs sriov_numvfs reads vs writes")
as there is no such promise that netdev devices (as presented in script
https://bugzilla.kernel.org/show_bug.cgi?id=202991), which have different
lifetime model will be only after sysfs changes in PF.

netlink event means netdev FOO is ready and if someone needs to follow
after sriov_numvfs, he/she should listen to sysfs events.

In addition, I would do this change:

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 25dbe85c4217..3b768e20c7ab 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -683,8 +683,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
        if (rc)
                goto err_pcibios;

-       kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
        iov->num_VFs = nr_virtfn;
+       kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);

        return 0;



Thanks

> 
> Jason
> 

