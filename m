Return-Path: <kvm+bounces-5447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F73A822016
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA52428184A
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 17:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5954B16413;
	Tue,  2 Jan 2024 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WJJEiEDU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87A616407;
	Tue,  2 Jan 2024 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGDmDpWdgFD2KzlgkcvBrwzvr1Euuc4hu+R2CbfsH+HlY6ZxkUuuXyMwXKBtlf0pdU8qBcHN1GtphwZsHG4waESzlg5JPjndg3DS1T27SdYt7i5kKBdh2F1isUODJOCkVSNC1griSvA+h6yDs375PKrEpvoI0XCSQKMhLgRlo1EENbQuC4qFzheQSNP9tanGgk8IqsawX3uBhGAUoN6EPJRKdBwvstgxJx+WwzJq4VqYMhE0f7qbMsrtGTDI7IYNceUTUyQqMbIzaMm9zXkAl/mdoda99EOEdCNXQ1laIbPI1hdVXifrtL6/1irP0YpwsJHIV2rBBNt0Ypr/CaQHgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SaeMPThzjsXQhyQhHTjT5LOmTU89XdTuetaU7ll8RpI=;
 b=BbSDSHY5tIjCrS0qFuLqeax2+lPx4hLkWFgD6C+2Bx+IaBqfwBl8OsQ0FO4YlC4/GsM39GzT9I/SlDEmF7YBuPbb1KWLvJtId+EQipbfsZMnx6CPd/clUP9iaoRq7misvfdi6Q6sOLNo3Hkfbs2AnS++CNiaCT3J/UDWft1IL9UAymhjqB6Gm8TtNzntQVSmcRnzD36Dw/7dINVaQo2P0wOLrKxRZ5rrDBHrQnqrLdobu9Nms4Jozh5qCMmdCdzhmsUwo4YUyn52k6lFGMYPOFmo631zmn/Hcai1tfU5qK4MrQdfo+Bvu6Xlzw50c3wVbJ74Ct/BJKAHVj+9FtV2vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaeMPThzjsXQhyQhHTjT5LOmTU89XdTuetaU7ll8RpI=;
 b=WJJEiEDUK9E7Jmkx516Zd9AsXpdmHgN6biKcgm4trgR9ogEnUESFpSWo5p45mod0dTbhtp0M0pi1kDBTIZy3IcQXnSrsI3u/vB5Bvj1chjTVBYEo8d7PQCNkbJy/5w8N4MFAyZa3qADjV3+aKZ5ICNL9+zTgGUPsHBNAP4bKOvR6dR1Bi+jWZOtjVGFdlfZ79TrJ3vM/fmudHubvkorJvEVKXNVQNGT+z7EYA7b0mWwMtsduZp5lq3aZsgJZ2VhiaJ8dYBHhPe7s4jPXqh018QLiMEgRNiFKSf9nkmC6qsoSslVf/6Za9/r3xdwRBamQD7ZgbPlZn82AZDSx9kI91w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Tue, 2 Jan
 2024 17:09:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7135.023; Tue, 2 Jan 2024
 17:09:09 +0000
Date: Tue, 2 Jan 2024 13:09:08 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>, ankita@nvidia.com,
	maz@kernel.org, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	gshan@redhat.com, linux-mm@kvack.org, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	james.morse@arm.com
Subject: Re: [PATCH v3 2/2] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci devices
Message-ID: <20240102170908.GG50406@nvidia.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
 <20231212181156.GO3014157@nvidia.com>
 <ZXoOieQN7rBiLL4A@linux.dev>
 <ZXsjv+svp44YjMmh@lpieralisi>
 <ZXszoQ48pZ7FnQNV@linux.dev>
 <ZYQ7VjApH1v1QwTW@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYQ7VjApH1v1QwTW@arm.com>
X-ClientProxiedBy: MN2PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:208:234::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4512:EE_
X-MS-Office365-Filtering-Correlation-Id: 6de4bb8a-1139-4cd6-a05a-08dc0bb588d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	efzWhFQtMa+oMUpN0ruK2+54sA2yUI2AkVzpw1qDLAcfjLP7RyozdBm3xn4myDN2JtiGX0Iw6Oik9Zs02rbCPRuKHVDDKBj8fQcJ6VkTz+dgMraf6kPB8NkRMvNuJOYEPESd6oA7yqbSKGCUW583j3w2Rzyd7sKhfwlsG3pre5QUskLXjM0wKeMU6A83b3CiajVtEKkyDgp3Bb0IpPNdQ3bhdCc5tiwKGvhePsN4A1ejpzA7L0O00uhSnPrZkmf4LpNJF6aBnBlGs4yAnt6B5cAFQ7s5qx+PQeQJdPfaExytR0bFUO7eTyLKNgO3ZgIScSYxASC7YHbXiqZa+8PHBZMENaXoIAY99f9FUzjNK+wf4h3kztZ3Jphw2XLNJw3m1gZiL3m+lOLNDsZB4+my2EVwA6AXQ41gaJq3KqqEq/QH6L82Bk4P4rAhXihnJM3ijSF5j6Xh7ahRQuCZ51mh8FybNIM1sgdEEyiaHbrUgb54y8ZPcj4GrUdMd/4WB6VuxcX7j5akiboHzjiLpfvoIKbgXJk0S4Lr2RvpjjzzND+OrDjwGwgOjzOnO3APP85P
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(39860400002)(376002)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(2616005)(83380400001)(1076003)(26005)(38100700002)(41300700001)(8936002)(8676002)(316002)(54906003)(5660300002)(2906002)(7416002)(4326008)(478600001)(66476007)(66556008)(66946007)(6506007)(6512007)(6916009)(6486002)(86362001)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TtBvKvohDDZNz0Vwtl3KxYxOSkw+Q7ZOm8HRc/PzlAqkgVkFMwjQE/VJ7tGz?=
 =?us-ascii?Q?QswMtmjNq1ai1rCMsTqQV03MkXqAcwMUMVRNijruYEDOYEm0pfD4YJLXUqxk?=
 =?us-ascii?Q?5KH/59vwRfvdDzM3gMU7BEG/vsAfDgX/RxhfFXa/wshGO1jqwmQnWoTVm3nl?=
 =?us-ascii?Q?QV0XAv4R9UMYdAtaaeCmKJXR9HC31bjEDKMttvezIoojYkqbqd4uQytbXJL0?=
 =?us-ascii?Q?sUVhkT+Lq4OLwsIRcrcsCc5Whjwk/RiFZ9doEXVj4jwdicAP8wEcEc6/Mfli?=
 =?us-ascii?Q?DH9qcinereDOiBuuN3FUJQ2izCO1PQQkFRvN4JmY6zFUvE61oKHdDpxfyPGx?=
 =?us-ascii?Q?4Rl76lKdcPfbsq9a9Pf0D3FrqW2gj9v81CJx608bEcRvxde70Sv5Y6s6Uaod?=
 =?us-ascii?Q?9JbjRTczBuppdYpbiCuROTsp7Bdwco5HLRFKdTReFsxzCnNGsJaSFx5SyMYy?=
 =?us-ascii?Q?bRSnW4+Uw5xWEnmB2cEn+DOiO0VyRWAzJ9EFpZLVFwPumGaABeh3ISVMnlUO?=
 =?us-ascii?Q?aIfFkIdYQcKwuss354ehL9ASulYX1EQXbWjE3VN15vw1nXXY30ApGDbWzk54?=
 =?us-ascii?Q?LuAH0GQVjtWiKhFm+ydBSwfI7g+L65TCUUYCCxWDfISJUnsrbn+tFTKamUvA?=
 =?us-ascii?Q?rJry/juZ1bwrGAIAsFWkNYEinPB/eXsRZxp2iYlFMu4c/vlA9kARSiRKt9jC?=
 =?us-ascii?Q?OAtGnUhGDlnhlFtEZ1k8oY4ltnaaHmaGVMMBQAoDec1S5MFK9JbdEp07jbLI?=
 =?us-ascii?Q?TqY8D/TslL+/16yKYFiwevK4hhR7my4uU7f7+L51Bx1gWdMTvTsakCseKIdG?=
 =?us-ascii?Q?8RJuIPnrI1GKp+NPN4aUsyLtISRtZKOLe84tMpPUFdsgrKXUdVkoRpfUZT7P?=
 =?us-ascii?Q?LNBwxFVX6dukyoUI1PPlJXo7rBK+YS9GftE8m5FS2SviC4BMVRkM6qFMyT7T?=
 =?us-ascii?Q?kO6f+d5vVJKgqcNsgosRHB/KK6ln/VdcH2epqAmurFiTMWBri32JieNhO9rB?=
 =?us-ascii?Q?JU2E+upnRt6lhfcQLeu1FvS91GzE+LAIXaTWbSHQHreaSpj8MEHq6gDiK4Ow?=
 =?us-ascii?Q?3Zn4u4uHuE6tyrSS/0D7ymOG1aaxxqv2BF7kHLq4I7nfdKuM//9JB0cjBNnV?=
 =?us-ascii?Q?5Z58BUdijP3freysxvrg0vgGRimwuXEEu6PPyNqFX2DFDzYLLut3bM9IIxgZ?=
 =?us-ascii?Q?iHnMCEGnG0J19gnrMDfEwyINAOlaNmrwgqoVLIyA0Tzjdrz9VO0WFWshwbcT?=
 =?us-ascii?Q?wTgk8xMzolSCmJNCHRZZYR8g4Dbah1xnouHYDPXet9Npcu+qnGcHpm68DTid?=
 =?us-ascii?Q?p3n44A9IZBCdjEtTOrrZErK3Bww0+5GsltXAPlIJSYXTb0ZABCiNiOT2ukJQ?=
 =?us-ascii?Q?zolN07osXhZoG2Ux6k+7z9BudPK/eicTEVHuDSOqxgS3oI1Zh1I7wnGLKpK7?=
 =?us-ascii?Q?DXEZ8sSY7Cj24m2+HpRm09/6qlzJccQ6gATd3yRMF81nnh/akbefrjN9j8Gv?=
 =?us-ascii?Q?XHe2UGh7JJ+jMr9omcs+tI0EOWMwQGjKIjm6TvgP0LAgYE2GYt+2HcHuTKmg?=
 =?us-ascii?Q?VPJihSB3WihC3MmR9zU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de4bb8a-1139-4cd6-a05a-08dc0bb588d3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2024 17:09:09.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jORWB1Olaraj4ndpLWDuiT3ZQC+XSvFD92Wa/Ta9VO5aFzBs4zR4GIk+9i7oTwzq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512

On Thu, Dec 21, 2023 at 01:19:18PM +0000, Catalin Marinas wrote:

> If we really want to avoid any aliases (though I think we are spending
> too many cycles on something that's not a real issue), the only way is
> to have fd-based mappings in KVM so that there's no VMM alias. After
> that we need to choose between (2) and (3) since the VMM may no longer
> be able to probe the device and figure out which ranges need what
> attributes.

If we use a FD then KVM will be invoking some API on the FD to get the
physical memory addreses and we can have that API also return
information on the allowed memory types.

> > Kinda stinks to make the VMM aware of the device, but IMO it is a
> > fundamental limitation of the way we back memslots right now.
> 
> As I mentioned above, the limitation may be more complex if the
> intra-BAR attributes are not something readily available in the device
> documentation. Maybe Jason or Ankit can shed some light here: are those
> intra-BAR ranges configurable by the (guest) driver or they are already
> pre-configured by firmware and the driver only needs to probe them?

Configured by the guest on the fly, on a page by page basis.

There is no way for the VMM to pre-predict what memory type the VM
will need. The VM must be in control of this.

Jason

