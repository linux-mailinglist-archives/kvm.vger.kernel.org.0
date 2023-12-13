Return-Path: <kvm+bounces-4296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3544810AAE
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39580B20BB5
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 06:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420E912B81;
	Wed, 13 Dec 2023 06:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e77jSiSx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2412299;
	Tue, 12 Dec 2023 22:56:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJot94u3q3a1bNg40gGNAVispZV+op9ZJtLcjUypT42aBrNaBqN03U+acsAZXCcDXfKYFLsu+mcZvtAALEYtkt5Eg8P+5owlsSaiIk5RZzCiHMyQJuAnGoUkU0gt+a2YSM0ToF5WvXdZm6jkFyxVl+rYotwOsFtp4himL4JHaAWFwo1WbkarU5lpi3+TqSL27JTEcmBT4QTblVcmV6csRM0BaC+O2FI8AaqQkHk7aFHO06R61oLvSirqjRjV4/fhkxExjlxbNyvZyCZZgxsQ1MNXfsu4R8kljEj+cN/8KiNJMSqckWSRA1sCwJwcoQ177WHeealIE8qZNasrurpWJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDDKl8zuosQB7FgDrC62d7CGO234rWGg4UdAvtDwgh0=;
 b=PJXtAfv3y7wtSo43CgocSGjWviqD39HFEKDxBZ5Imnt7YQzOHlLnG5Q/BSX8XriySGZ7N+ylk1cddLbwcdsNr4rYypR3o3QGEjy7Q/MGFOb56sGm7LNAwuYRB5av4RQzOOz2FrGFs5iJBqwqia/JTO6CqavfqWhqq4vhbpu9qzCybtGyRfRcCdzQyQw8PY+/+rSKzpziHZt751yR+//wvAxbjbApLkRj08FlqPETxYSH0EGhIhnuBmdmg0JEYvO7jl95Ag/jcjCiqKZEV+hJAJPqkxO1Q1WA3obAB6Xb7ioGEFW7eFXaVlVc0IPagEWPYFgxe2fGPUFbljPL25a0pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=samsung.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDDKl8zuosQB7FgDrC62d7CGO234rWGg4UdAvtDwgh0=;
 b=e77jSiSxxROKREIf+jBEv2nlliFfsSw1aPTE6rOh6HkEcRMaNMwB+JsgBqCkFs0DsSTeOhgy5prIXlZGuk6ecOqz/qR82hw53Arpq4EzMvgaK5CtIaA9XYbKs5dWTU1gFGkPnuybU+5Pq5uFR40x/yUebOjOXohg8aRfLmOtI+Yu1PErB2SNtTWcXNmF+CcHHC3Mu+S6KHv0yIh1oU+YXYcyHR8EORein4G3DJx8ApZRVvSwJdajpZe5EpUKO4AjkZqbUz+g3O8rcfvog8xc8hS06lxYAEGtFZ8rS6CjOPr1hPi3o9Bk6lnzbnA4jPrX/C2+g0abHCr9hYoW+FFzog==
Received: from BYAPR11CA0053.namprd11.prod.outlook.com (2603:10b6:a03:80::30)
 by DS0PR12MB7899.namprd12.prod.outlook.com (2603:10b6:8:149::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 06:56:02 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:80:cafe::ff) by BYAPR11CA0053.outlook.office365.com
 (2603:10b6:a03:80::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Wed, 13 Dec 2023 06:56:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Wed, 13 Dec 2023 06:56:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 12 Dec
 2023 22:55:45 -0800
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 12 Dec
 2023 22:55:44 -0800
Date: Wed, 13 Dec 2023 08:55:40 +0200
From: Leon Romanovsky <leonro@nvidia.com>
To: Jim Harris <jim.harris@samsung.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ben@nvidia.com"
	<ben@nvidia.com>, "pierre.cregut@orange.com" <pierre.cregut@orange.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Message-ID: <20231213065540.GL4870@unreal>
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
 <ZXJI5+f8bUelVXqu@ubuntu>
 <20231207162148.2631fa58.alex.williamson@redhat.com>
 <20231207234810.GN2692119@nvidia.com>
 <ZXNNQkXzluoyeguu@bgt-140510-bm01.eng.stellus.in>
 <20231208194159.GS2692119@nvidia.com>
 <ZXN3+dHzM1N5b7r+@ubuntu>
 <20231210190549.GA2944114@nvidia.com>
 <20231211072006.GA4870@unreal>
 <ZXjRvfu9urCcyEmN@ubuntu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZXjRvfu9urCcyEmN@ubuntu>
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|DS0PR12MB7899:EE_
X-MS-Office365-Filtering-Correlation-Id: 2108f1d4-0e44-401c-45b2-08dbfba891ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Dya5AoO0u+tosExlIBgjcUPwfXA96075mvbSKK1EpfbmiSz0DJ7z1XkNKH5VvReeThNB50e8MfRt0dyviy0onLA4RXX2xgScYUzUwsuHeLPQB42iWAapA/yuIGQdT2vpvE2irPKHejhvSAJ7kCo2AiLNcooODhLNVyaXscjwXn9oK3bNT/TKcIvCINDkuYbmPmIFxSuPEWxd315jh2jVJw1XCv5qVX2D0WcbxQ0D0StlZoZQ959EKqajpYiVR664RfZp2Sws7tRcFQ0Tw2pW/+8O3iGgSpN9uDwOdG+iekOjf41Qsj6DPM5KvCz3R7PSwm6e/TgjpHDSYrz17UWVLuebMoi5uGhytDFaX4++korNiuDz/9QPYRxRrrDSSIh1hqHMTWWC+YF93b8qEN+sxaczsBu/Qxv1gN1Cy0WypsAqD72RF6W/NISed5j7hhVcWuXFDDT1U9VkYdmWWOEkMrQNaCP7+2Bk2/uAVozv7wlstkt6QSnHqKr/ikE5U1u+NePcU9KhMqSSwMm0EjB3YjXDZhCopBa/4Lq+7WSCDoCU/qfukU93JnnapH0W8mc/wUY5fj3xXrvSbuFGQoEzeuk85r9TGXEx0/rZnY6kvnSDhA/aE6i/BX9T9eGLlW/GKHOZ9gzMRjvLrH61B8lJUei9kJZAanVTAAcN9pTA+pknwgs0A7VOuJRUJuVqvSwSquY5S0ngbpcGXLyVeNNTW6GIU3WWw/Ap5jphCMYsCAdHTuqb7Gtm24n/h3OP7r97lAV4w6j1FwNR4ClARpDDjIitAnu5od06QakI2C+9spg=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(7916004)(4636009)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(82310400011)(64100799003)(1800799012)(451199024)(186009)(40470700004)(46966006)(36840700001)(4326008)(8676002)(8936002)(2906002)(5660300002)(41300700001)(33716001)(40480700001)(478600001)(316002)(6916009)(40460700003)(47076005)(36860700001)(54906003)(356005)(7636003)(70206006)(70586007)(83380400001)(33656002)(82740400003)(336012)(426003)(26005)(1076003)(16526019)(86362001)(966005)(6666004)(9686003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2023 06:56:02.3246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2108f1d4-0e44-401c-45b2-08dbfba891ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7899

On Tue, Dec 12, 2023 at 09:34:43PM +0000, Jim Harris wrote:
> On Mon, Dec 11, 2023 at 09:20:06AM +0200, Leon Romanovsky wrote:
> > On Sun, Dec 10, 2023 at 03:05:49PM -0400, Jason Gunthorpe wrote:
> > > On Fri, Dec 08, 2023 at 08:09:34PM +0000, Jim Harris wrote:
> > > > 
> > > > The store() side still keeps the device_lock(), it just also acquires this
> > > > new sriov lock. So store() side should observe zero differences. The only
> > > > difference is now the show() side can acquire just the more-granular lock,
> > > > since it is only trying to synchronize on sriov->num_VFs with the store()
> > > > side. But maybe I'm missing something subtle here...
> > > 
> > > Oh if that is the only goal then probably a READ_ONCE is fine
> 
> IIUC, the synchronization was to block readers of sriov_numvfs if a writer was
> in process of the driver->sriov_configure(). Presumably sriov_configure()
> can take a long time, and it was better to block the sysfs read rather than
> return a stale value.

Nothing prevents from user to write to sriov_numvfs in one thread and
read from another thread. User will get stale value anyway.

> 
> > I would say that worth to revert the patch
> > 35ff867b7657 ("PCI/IOV: Serialize sysfs sriov_numvfs reads vs writes")
> > as there is no such promise that netdev devices (as presented in script
> > https://bugzilla.kernel.org/show_bug.cgi?id=202991), which have different
> > lifetime model will be only after sysfs changes in PF.
> 
> But I guess you're saying using the sysfs change as any kind of indicator
> is wrong to begin with.

Yes

> 
> > netlink event means netdev FOO is ready and if someone needs to follow
> > after sriov_numvfs, he/she should listen to sysfs events.
> > 
> > In addition, I would do this change:
> > 
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > index 25dbe85c4217..3b768e20c7ab 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -683,8 +683,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
> >         if (rc)
> >                 goto err_pcibios;
> > 
> > -       kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
> >         iov->num_VFs = nr_virtfn;
> > +       kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
> 
> Ack. I'll post patches for both of these suggestions.

Thanks

