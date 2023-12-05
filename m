Return-Path: <kvm+bounces-3583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCB28057E8
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 702751C21093
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C56A67E6C;
	Tue,  5 Dec 2023 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tyVdkcEE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA0ECA;
	Tue,  5 Dec 2023 06:52:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCptVK+/g66y6SfclegRzNo9P1NgaPKifAn2ZXaFNZ8JtcmwpeW+RND8bt13oGpsFQX2KzjaYAixfbujKQOA5nh3r/k3sZcei+YwvFmHa4EjtZi1GA3uvGi4kc/uhag8T6BgKVSuuMl1IlKE265PX2opyg32nh4Ysuia7a/F9H1+IkIUofSQ+24W17ESY7qVy45jcMBueraThJRMdqhIxsYkwJFUHWipXn2cxqrGsP2Vm4CiFA/8qoeDrXDAPvekec/0h13ZlQeZwck+67JJei/+uKvwaUcpgXDSKcox6EW8+Bzql0Xsd8T0bib1Dn+6AewNJX1iGrchDVFMbRNeRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSiAaaWrVHsQkZTihnn4ajcQnK/DO9o+eY4BoxLudbE=;
 b=nkFWae5ju9Fcv/N1fWG4Q0spWdZ+MS5PWmVNBESlIW5lZpau0uynUPvGRZaE6jNHM6TT6hWblB6ZZNfgoXYSDyil6nrbe09A0z4+rGrlEsPqLpxREPMo/p3IuE4Lb0e8HB2//6GqX5rJVanVniFTUYTdE8ad3t/4zEtqQhIF/TQqRn0+2EORKy3i1vLnKcYBLb0VRSvNCg1Kra+jr6blXN0f8uflI8bxOwjb9rsNwDX7c60/S69ZhKBqe1swX9jS3lDhyY04xbQt7FslWg2cXw8G3ghYxXvKTYMVkcYixxpXtbgg0EtqfEAEh4IhDJUvUYTS/UepC0fkUHtSdW93cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSiAaaWrVHsQkZTihnn4ajcQnK/DO9o+eY4BoxLudbE=;
 b=tyVdkcEEXKzy61eNbptxGDzbLz12x7ZtHpr0/FrBFnkE2cIa5KWjh6Pi0wHG3W4ajx+lPrsjr0TFh1nrfAtdR6KS0jk59z1tgZvVjuSlbaVw8EGjDIQkZ424c+O+zbxrm75Ebvbg51juHZoq/kEQKewnFi9IyEplg/9BXIjuKdlcfibJmHM7JPfW4Jj8XEy5MwXJfWJ5R0T7qNNfjDnFwNzwDF/fsr0k2CFgqnjwV/51qmr/JjZSRzBYPh91UF/SUV0L/QtjJSIxSh2tj3Y5J5hnSQpwf9DsSmZmYI7kOiB6YQKpyGUSKRjx8OP26yx2jNzRoE9rqGhiipQc7A5Wrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4169.namprd12.prod.outlook.com (2603:10b6:5:215::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 14:52:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 14:52:28 +0000
Date: Tue, 5 Dec 2023 10:52:27 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 11/42] iommu: Add new domain op cache_invalidate_kvm
Message-ID: <20231205145227.GD2787277@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092041.14084-1-yan.y.zhao@intel.com>
 <20231204150945.GF1493156@nvidia.com>
 <ZW7F3AJZe7vrqzcy@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW7F3AJZe7vrqzcy@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BLAP220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4169:EE_
X-MS-Office365-Filtering-Correlation-Id: aa60f102-1b1c-40eb-a680-08dbf5a1cd0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rr0r+M70A7a8H2Qeg+BA/AGSPkgCkTSuttek4JncSLiLlDfKXWsoO8ru2nWzeV0wW/B9ZOeGnJOEkVFe/V6asO8p094WHr+HBwxZERs4Jkb9d8GzaANfotkopkmil8MZ36VK3zJY0F7uVjFG1HsOY17lH2yLLzol9ym4SijQi49Atlqa0zJaITDOgkE/h65Tkj/IgPg6TYl7GSrhaY/FYhtSvYviw4+y8qr3JmfohNyDb1ze0vAugQdAxdAlIVCUxzBQubxDXk5UQ1HGqq4gnYu8VPr2S9GnzDESFaS7tKWnlOeazyG15zCtzDxM0TKrdNw+Bd0O17YgQa25kAU/psjFI5lsOGrbZhyfa4VPlZ27MFJBB44EFw6USePzXJ3le05qa0tnQu0JsTdnAJn94PCaS/VS7bEMRMM1e0dBVJ/edVOGmyBCwDsenO/XeQLI4eLuVuHxSiB8q7XiQwoAVwuRyjSi2QXQWRdusig5SwJYEkyOUAzCMxtQNQEEC0xUM4ogcid+bPjmwjQXZSs74bf470wfejwUX4LOm4XQbC30uVcxdXSI0x5z7sSk5nFs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(376002)(366004)(396003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(36756003)(2906002)(83380400001)(38100700002)(41300700001)(2616005)(26005)(33656002)(7416002)(5660300002)(1076003)(6506007)(6512007)(86362001)(6486002)(478600001)(8936002)(4326008)(8676002)(6916009)(66556008)(66476007)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uMeeGNQN0kN2uDcY+Uy3Zeuk0gl1h0ne++C4YYN5LVwFTrjtRTwWccnJ+CLa?=
 =?us-ascii?Q?NmbqWc5JwjMr1V8lLzriiUfqNCb1MLLRaGJUGGv9rHVaaO74xVzB7/whirdr?=
 =?us-ascii?Q?2cDaBqalE5M3wU8dQUT3VLVwMIuzbcoP5CUfuz06EWbKfMjzYFmHfMx5zZG0?=
 =?us-ascii?Q?4jI3zlHvdB/N2RWEY0ih66szolRtLhiNLFWZTO90aatEcMIWkypvWqVuKQrR?=
 =?us-ascii?Q?AuYw77h32a2zKSf1tykmIPGM/W3OSKEBjej3kpp5f4vju1d6/wyc2LfO9oA9?=
 =?us-ascii?Q?l7Lsm8tAuq7enFmYm4IybnzAKqhzVudom7xJJ8CigFxeQw0MCtgWvKitls0Z?=
 =?us-ascii?Q?oohG/nN0izrMeMidAA+E5asfj/1UVkq+JarZdbuGJpiDzxJVUfG2WYacyqqv?=
 =?us-ascii?Q?X5ExbmeFd035uC3IZ6w4Y8kvjrXx5gLqaiLVeHTS4l9V8yx5I2977TokwApe?=
 =?us-ascii?Q?VGNGmE/Ygpz/ZZOyiyK6ZvWhXnmZD1Erp2e0Wl35jHaiLuy6bni5Ycyn8Hs4?=
 =?us-ascii?Q?Vnlhxa36cqMYcJUDx6+h73BQzXvDxtw/C7Av4GHl3t0wmUs/H49yu04FgWPC?=
 =?us-ascii?Q?/d9Gqm8efJtJ7Fb6ofAc6kATqf4sFSp20TrBcSpLCsHx9hkDj1gY3gfXaoXe?=
 =?us-ascii?Q?RZaHDeHEhGuQJ2DkpWzTmTpG9ocpr1/bopOmKGA2Kcq71X6xmN5ouTHbOnHO?=
 =?us-ascii?Q?+TcFzVJyWLUQvWJbyEb1/RJpwt9pHOqiT3U1EWyc6wUEepDnAF8rp9sC2TBQ?=
 =?us-ascii?Q?yRNh/YhUxMLzviH3hl+USCFgp6LwuZoogfEu6XnjxPcTkzzq0loHxAg0/dwF?=
 =?us-ascii?Q?/DroEvIu8s+dcoN8u+D+4v6pcZHTpv5c7+K71M9yNehG0W3V4qreN/HNBs73?=
 =?us-ascii?Q?+BTbjzs+LFvvr6OEZVEZiwSreLAZWkgTxzgnborBy0eYoZ+QtiN9UCJEqg02?=
 =?us-ascii?Q?dEvmzdX7uHI4dr6ixT4xqdtd7KQEmhKXQ/xkoQRWDATKJyU55hgenRbIFfxM?=
 =?us-ascii?Q?E02wr2fRzqveX2xDQ7ETYUgarKHV60sAPY+lQ5buehtNHm0in5AhkiYvW1w9?=
 =?us-ascii?Q?GPgIWEfhecbRo9Q3ey7phZxzzoGyDKPZFOFjFniPWRewY6mi2dQ51nRQLejM?=
 =?us-ascii?Q?Leqt1w7QispYclSPHHj0ZcPjoTe4+Il47wo0vA4iv6Xsvn7t/jFrbbaHOmWZ?=
 =?us-ascii?Q?KlHAQkiXhzfCP5GGXYRZ9dM+inf4Y98YaTRnB05jvzytnv4KecgtKflYQtp4?=
 =?us-ascii?Q?/fDAhD2rlDD5jSig/WmPGWLEQjuw4NF5HqSZzRmcNa0ie3OhLu8/rvO1vrv8?=
 =?us-ascii?Q?lb3opEUmDBe45W/GAnVQAVfl/P+K0uja7dnLVfl8FVlJT1yAVwV7xcBeya9u?=
 =?us-ascii?Q?yM+TrPhpA7BUNEZu7xAQLnq3eGSX4p5xnbkQ1jEbtNrwZahcAxoiiPwVAksz?=
 =?us-ascii?Q?ZWkzJIaCJWmX13F/1M2wnVv4YscFbw3oSTW6Y2voeBiDnFAuYkoBw7mqwb+s?=
 =?us-ascii?Q?gnKWH3BnNtFyD4Hf00CoizS8bmBUQ/uQSbcXjNCROyC0tJUJ4HYLlYPSqdHb?=
 =?us-ascii?Q?zmkkM96e7Ck6DJFrB5D+FO0KJ9pjLit6gnW0sP1d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa60f102-1b1c-40eb-a680-08dbf5a1cd0f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 14:52:28.3456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sn/nwmoAHaoVN8KhXSZZqDhGM7IXEzOyKixmxZp6lc7bNOTSyq2qLf4mYPGP+558
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4169

On Tue, Dec 05, 2023 at 02:40:28PM +0800, Yan Zhao wrote:
> On Mon, Dec 04, 2023 at 11:09:45AM -0400, Jason Gunthorpe wrote:
> > On Sat, Dec 02, 2023 at 05:20:41PM +0800, Yan Zhao wrote:
> > > On KVM invalidates mappings that are shared to IOMMU stage 2 paging
> > > structures, IOMMU driver needs to invalidate hardware TLBs accordingly.
> > > 
> > > The new op cache_invalidate_kvm is called from IOMMUFD to invalidate
> > > hardware TLBs upon receiving invalidation notifications from KVM.
> > 
> > Why?
> > 
> > SVA hooks the invalidation directly to the mm, shouldn't KVM also hook
> > the invalidation directly from the kvm? Why do we need to call a chain
> > of function pointers? iommufd isn't adding any value in the chain
> > here.
> Do you prefer IOMMU vendor driver to register as importer to KVM directly?
> Then IOMMUFD just passes "struct kvm_tdp_fd" to IOMMU vendor driver for domain
> creation.

Yes, this is what we did for SVA

Function pointers are slow these days, so it is preferred to go
directly.

Jason

