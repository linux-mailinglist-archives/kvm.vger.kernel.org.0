Return-Path: <kvm+bounces-5605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4DFB8239B9
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 01:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50BA01F2618E
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 00:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB99A107B3;
	Thu,  4 Jan 2024 00:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rMW+BxbP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694F7F4F1;
	Thu,  4 Jan 2024 00:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpWtOskT9Cga0YXtUVlQgMXnM45+AkWL2xKEFJUsZepL/BXpAzLVratnPH6s5ULbwWTzt/Hqu+84G5vY47pFqGeoZX8xLoJrb7GkWVgK5NMqXHvmu5rLO5haKG29Kbf2QIQf7PXgadGag7lvOZ0RPyhxyDiyrvmF9j/rmv8tUvXiYOVCpqfatBEqgNyOw2fIi3NdhpgszwvAi8VTBnGK07a+i9n/wrNF9mJfylCzQk5l6gCQ3RjERF4FJCN4riZaz6nCemQWTTYdUgOA98A9CQGGX6ttOqFtEgw7zM/WU3uK7G07XPe0vQemDSJL5v3oXQRFkIvwMXgrMT6Ovl0I3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfwhc0M76E1X9ccUHEh/cJonrYrBwocXmWBANSUx/UU=;
 b=jcBpx2I0sgJAy3PGhWy2mh4c9uQ7+BmXbna3JsgPkkX2rBxCTCNLybrFXHh6jD/Kvd2ke2WQ5n5mWGiTRnT7oxMdRYEGzs1TzC3iUR19FNnXAD5FO8T4i8GPytxAeD0BjxP7M/muodXymroX672504UPFXoMjj/Bf3FnQFcQQlTjolxNczgxKqSirIVjGw9DFtN8/V8rBuglIj9YS+2NWcrF4r6MH2TDLp1fxR4Lvq33vK+zQPt10xQ3OhUNZ4L65jlslXvYYytz7nA+fiswMTgFeuFrGX1AOyda5facytNwYjLSiVK8AmkiMfiip5WLP1Sc/9TEZKr7+wfS5IYF3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfwhc0M76E1X9ccUHEh/cJonrYrBwocXmWBANSUx/UU=;
 b=rMW+BxbPDVQqvmnSr0zi1wXR3/8KAuyWPizoM6JQURAoO5zBRr7SiaLZlbvZSJ2w6hhw6Cx5XiOeqX/tgaJy4RCRgh1usiMql3PAKTPhEqChNYh4deTgiNdk0QHjFPV1wZChMfGU2/rmKgH1ZHYVKF0gtqzKjrliw9VW6tkN5Za2rnAnW6ZEhQob6EyqPVewPMIR/ScpRHsIw0OSkgO9luwnsb8lujh50qFcTqGkE47c/DCUkTUO4adkqzJCnBRUCTATpmTUM9Uyta2nEpsHIGECj0MPq3U41MUCmXND/Ww/um+U94CI3STgD9opAxienWT99lfM/ijThqsypxn0xQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV3PR12MB9143.namprd12.prod.outlook.com (2603:10b6:408:19e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Thu, 4 Jan
 2024 00:40:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7135.023; Thu, 4 Jan 2024
 00:40:19 +0000
Date: Wed, 3 Jan 2024 20:40:18 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Message-ID: <20240104004018.GW50406@nvidia.com>
References: <20231217191031.19476-1-ankita@nvidia.com>
 <20231218151717.169f80aa.alex.williamson@redhat.com>
 <BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20240102091001.5fcc8736.alex.williamson@redhat.com>
 <20240103165727.GQ50406@nvidia.com>
 <20240103110016.5067b42e.alex.williamson@redhat.com>
 <20240103193356.GU50406@nvidia.com>
 <20240103172426.0a1f4ae6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103172426.0a1f4ae6.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0045.prod.exchangelabs.com (2603:10b6:208:23f::14)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV3PR12MB9143:EE_
X-MS-Office365-Filtering-Correlation-Id: c797aa48-06a4-4392-f10f-08dc0cbdba42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bVU8Tngi170jo+KgxiOvXOD2mBuEwt5iKjZ8ppBfiBSZBkgwZr/LEiQ8QgoIsAz6dY8C1RH0lDPf77qUa6YMwq34IQ3ocdfRuMySkDNjpRz5FAGgYZrn6EaijGxAkZWaIqtFBNjAbl8jHc8bmeW5XAFm99v5Nf6tXFrIn6HzxE7j5mDcLJOekAHrSwT8roE17jCR57NvsFs4VfpBXiaePvNZZGuVF3UxiuixTcxBf5JXbxdDYku7CggsS71Fkrs/OAs10ekhWzhrPSx8Pl23ISdJ+q/5f4R80+5zPlOwmjX+CEJMsTXTAJecziL2lCgD7YBRurPO7P/TC/eBSBUWNYH1PgaJavSmVl2FnVdySzulzWKEqen2nJKZYbqzeyjEX5sBbBbAJqM4OtDEzEYYsH/+6e8/Fv2Kuo2jfUAx9zVrLkx3gmyr974I74rFY+Ffw+hHYPovZIjXycpvrkFRkcUGaeE16AXGjNU5Jeh6b/X2couSWQUdZaQPJqgH8a8hkt/z7Iol32tTSh39em6w5T0plOKGRtTd99nmiZfl35PZMuG7TV8slZnoyCT5Fmw2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(376002)(346002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(2906002)(54906003)(316002)(26005)(1076003)(6512007)(2616005)(41300700001)(5660300002)(86362001)(8936002)(8676002)(36756003)(33656002)(66946007)(6486002)(6916009)(66556008)(66476007)(6506007)(83380400001)(38100700002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uJ4lBWU411qIOpFq+p4sm4ZXLiU91q7cT06tnf2gqeOLUZuaU3vGUMtiriEz?=
 =?us-ascii?Q?kHv8tPi5FS40Kwy3rtzaL1R4sxMjpkydCi38hiD0DYDZrLUQXme3Q1fs1ddj?=
 =?us-ascii?Q?ENNxUW2voxdFglC5f7o3198xWkviZ3LFu6+JiQL9/h8wiE7MsJv+uBDI04hn?=
 =?us-ascii?Q?vYeEN/d2W0POobDY6ul03t7tbCstgLMtxh6B48HWNhH7zoqrUqeIPC0QCwcA?=
 =?us-ascii?Q?d7kk6r5gg8Ea6+tSOoh0LXNN1vZ7y+YEjRjpmfutTy1aZQPtz80iNxPSY5x/?=
 =?us-ascii?Q?D+tig1BW9w2wDszwzTpDpIBFlS3LgH4hukMvpJKZqZ8FelkBJc943eynIOo8?=
 =?us-ascii?Q?UtGzYty+EqYfyX/NoNVPrzSzVh3o+ZXOXzS4Ct3du/D0UFC0O/r3UEB8c+JW?=
 =?us-ascii?Q?EkTnBQGoE9fT9+LS+7GXsKCC8uk+54dlRVD9tnqO4+fsYI3O3quTH6FQBP+8?=
 =?us-ascii?Q?YYobcObX6fq78XDFYDPFd76nsPgxYo0kQFSVe21i5IjlZENWGCKY3ebnN+Ed?=
 =?us-ascii?Q?VdE46yZ3vqRRvW+0he2fmrBeR/ZOcM7KEvmuztWx7EOT1DZolCJBVli8y9Xn?=
 =?us-ascii?Q?FnKXl/iztYzWf2kd7YkDJwiqxPVJdLrH47IQDS7tli3uKIXQC2CcZi9zJl2p?=
 =?us-ascii?Q?mdOAGbxZwVeLNX11n5AJ7bT4tPkkIRzW2pyx1CvPA4BOPdK7F8PR11pYcawO?=
 =?us-ascii?Q?L92rJviYRRJ1myN7tJ1qbsQdp6JzFZi614YGDse3IdYTLT3Wd8gSAvP01OzD?=
 =?us-ascii?Q?ZcXD7XqVYD8gQwkY8zz3GpSXXWZenfB0isjK7iFUfAJBy7jb7busLEesMs4p?=
 =?us-ascii?Q?myO+U9jPRz8n/a55ZJa4fEdiRX6X5DYsfPNgPRNz+JelrdTcXAEiqG81ZhAk?=
 =?us-ascii?Q?L8jAs/WVkSl4EZAtGNtDOU2ALQok/l4E2V6sYOazKEaS+opQZX8OVwWLJ+6I?=
 =?us-ascii?Q?JITcJGt8R1YiFMuM80e9Y7i/6nwG9ujVtEFtuwKDMYwrJ/2NmivVk/7ZW7B9?=
 =?us-ascii?Q?wVNS/xvObx/vbfbj5kaWh4JanomIxRX+KhN0OOqYOkwdGEJCINuCiEiysZXH?=
 =?us-ascii?Q?MOuJlTa+UMYnK8dOl01WM9yLoY0mymVSuXu8q5+tOHOcIXfXRGCYkDfZyZ2o?=
 =?us-ascii?Q?KpzTr/MlEXqIh6UXXQuNkWUt2jxnfYtv3Ul3+80ErMenMTSXUfG5vRHlVXFH?=
 =?us-ascii?Q?5fVupcTeeaX37urfraDzN3QjIYvk2DoT7BuazOZMefZEUIFJKqg1ntJftBOH?=
 =?us-ascii?Q?yQCxz6tq0wcH2fwXAsnHWwRrsLneVDQQ2gQsiGjVvaZBPJyeFmQhX4l/t5NI?=
 =?us-ascii?Q?IAxk7KM0E8QU20zsMleQ9+bkiFp1aotb8ksopWtzcWKSZ4Uwiaw+SKnd0cPe?=
 =?us-ascii?Q?ZFAluo7cLzxatBsGAJTU+dwUaeYObGaJA+NCTHiUcjVjD+dy4CFRcqY+ioU7?=
 =?us-ascii?Q?hfSEmRUS9f7D16N4CT4ydoE/eBD549U9aq+JKOKzJkI/Qv5OrLD8EPP9+FkC?=
 =?us-ascii?Q?cbajmP8PPesnOLcnZQTUXQslojaIC6S4vYa7zBKVBKO7kFJNF1Iaaaf1nnvV?=
 =?us-ascii?Q?XkopRtf7jc4cFcf8FGoXV0ZLzvXOgpnX3DmNN7KL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c797aa48-06a4-4392-f10f-08dc0cbdba42
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 00:40:19.4575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5mNz6h9naa+vDv731RHVpC6W21OGCh+dVQoST0HZBb7p9R2Zr5FBqz+Lfk3GWUH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9143

On Wed, Jan 03, 2024 at 05:24:26PM -0700, Alex Williamson wrote:
> > Why do it need to do anything special? If the VM read/writes from
> > memory that the master bit is disabled on it gets undefined
> > behavior. The system doesn't crash and it does something reasonable.
> 
> The behavior is actually defined (6.0.1 Table 7-4):
> 
>     Memory Space Enable - Controls a Function's response to Memory
>     Space accesses. When this bit is Clear, all received Memory Space
>     accesses are caused to be handled as Unsupported Requests. When
>     this bit is Set, the Function is enabled to decode the address and
>     further process Memory Space accesses.
> 
> From there we get into system error handling decisions where some
> platforms claim to protect data integrity by generating a fault before
> allowing drivers to consume the UR response and others are more lenient.

Sure PCIe defines more detail, but the actual behavior the SW
experiences when triggering this corner is effective undefined as
"machine crash" is something that actually happens.

> AIUI, the address space enable bits are primarily to prevent the device
> from decoding accesses during BAR sizing operations or prior to BAR
> programming.  

Yes. It is not functionally relavent to devices like this that have a
fixed aperture, or to virtual devices that can't move the physical
aperture.

I think the layers have become confused a bit here. The vfio side
should entirely care about kernel self-protection from hostile
userspace, which is why we have to zap/etc.

However the VMM still controls the "address decoder" and if the memory
(or IO) enable is off then the VMM should already prevent the VM
address space from decoding into the VFIO regions at all. Ie it should
unmap it from KVM for mmapable regions, and stop matching the address
for emulated regions.

This is effectively necessary because the VM might choose to reprogram
the BAR registers and move the region, it can't do this atomically so
we have to fully ignore the BAR value when the decoders are disabled.

IOW the corner case of the memory enable disable and the VM touching
the memory is not something the kernel VFIO should be emulating, and
indeed, I think there is probably no reason to allow the VM to
manipulate the physical control either..

> unprogrammed BARs are ignored (ie. not exposed to userspace), so perhaps
> as long as it can be guaranteed that an access with the address space
> enable bit cleared cannot generate a system level fault, we actually
> have no strong argument to strictly enforce the address space bits.

This is what I think, yes.

> > I think that has just become too pedantic, accessing the regions with
> > the enable bits turned off is broadly undefined behavior. So long as
> > the platform doesn't crash, I think it is fine to behave in a simple
> > way.
> > 
> > There is no use case for providing stronger emulation of this.
> 
> As above, I think I can be convinced this is acceptable given that the
> platform and device are essentially one in the same here with
> understood lack of a system wide error response.

Right

> Now I'm wondering if we should do something different with
> virtio-vfio-pci.  As a VF, the memory space is effectively always
> enabled, governed by the SR-IOV MSE bit on the PF which is assumed to
> be static.  It doesn't make a lot of sense to track the IO enable bit
> for the emulated IO BAR when the memory BAR is always enabled.  It's a
> fairly trivial amount of code though, so it's not harmful either.

As above, it was probably unneeded to put this into VFIO kernel side,
I don't think there is a functional harm to allow it.

Jason

