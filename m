Return-Path: <kvm+bounces-3400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BC0803D22
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:34:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D92021F21250
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA8F2FC35;
	Mon,  4 Dec 2023 18:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IoNK+A2U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18165CA;
	Mon,  4 Dec 2023 10:34:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSRpzsRU2aGv4nMPsNoEr7MjyZ3Ic/b0a+vOi7hteAj3JlYopUoOykcNyeDo75XVlio9iwfFwwzmzVYbJrJA6hjwrnCg+vfQCnVPVGsEuGLUBiKupAd3J5iFDazgcjQCRefU6PbTIUlf4VpIs5EDqVlGMk/5v19UDiKw8NP5jgrnU9imk3qQWz6xSQ9r7aA3oq/D3MMXiOtg7l3r1DXkvolCZEqJahCh2FX1fI27NNnqIewS1kLF++IR80Y9Fu9eQGLgB8IsnNSoutcVt6zEkzRzwNodh1+y7+apkB6xH8LOc3MiPFyBBLuIrRQKwnvRljmA9FUaHBIlLqrSi2gyug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lg0+BtjDFeHe0us2M/RPK2MlDOQTpPFHiG8ht9T74OA=;
 b=ST4fyinW2JxfrkhROYRQpgRW+ligHMmsrC+L3DDKhjc8Q9hc/j1gj2gLm+7ZGD6AWrUDK8RPnK6OwB0av45Zxvq8TTY6gEIVgjoP9p//sTKWbAf5mg0uwKG7WzQ4CcQ2pBlYeUJE0jPBZ7j/xaNQAEpX8WzlQsBOE72FK8oQteq11Whu41ekKiM/lUv1Ela3lZdHS/V7weW5RiNENTiHAjvhxS6Q/rgzNRoTs+tvjNUaH+cCs5NrF/AwGggsbe31pbZDnDnUs0jQXe+s5EvnhzpHMX43B0oDS8MUMcg4dvy1EdJ6VNL+F9HPZpO1R7KSzAKzkB7eeckCre9FRHMjRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lg0+BtjDFeHe0us2M/RPK2MlDOQTpPFHiG8ht9T74OA=;
 b=IoNK+A2UngsgnpdV610DppyY7we7l3LuhjKikcQXGalgPiAn/jc2Dk8npSrc3Ot++uyL/XNm5ZVwmZ+T6LGefFn3FDskokCYF6IM2WE+o2TGNU1m05xNWHQOLl4nMj00NrH1X4Ulkqi2D8SH7Vlc7a5lRDU4ob5PDLJxuvMRiIGO1t5JYRvy0D/YFfv0FsJdZoW5goCOuzBusnw7V41rJD8LyO2tKxRZCSWHlgBcilkmlr+OGySvYEKrVuo20f+2sbVEgIl2fcZftY0LMQSXcvSllP/yzHszZqHLiduqK9Al+pnNh1pj8RfV7d3TMmNiGwBeVClTY56+CsO60ci2VA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB8461.namprd12.prod.outlook.com (2603:10b6:610:183::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 18:34:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 18:34:10 +0000
Date: Mon, 4 Dec 2023 14:34:10 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 14/42] iommufd: Enable KVM HW page table object to be
 proxy between KVM and IOMMU
Message-ID: <20231204183410.GM1493156@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092216.14278-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231202092216.14278-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: BL1PR13CA0429.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB8461:EE_
X-MS-Office365-Filtering-Correlation-Id: 967ebbbd-898d-4276-0001-08dbf4f79ba3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c0n4gDFGH2NCIX5sNSNc7QH+JE7sT06xOnhfFu1iqpKcXBt98U3NkOasmMfK5YYEUapctjbkphM3VdkcRTxfDteHjrZ0f721LgToGSyXxl3tkL3ivH45YB9x88YX89RNzPRTkQIjbVTKM+1L7t+3To1WBtxTcsUcrKz0BZc5zCdvU+Q8fcNW2YvK7VRAYXnmKXjNwvk+ib8G8P0GeF2G6VLCGr8lxbZK8xv+OpNZ4jK6qh50hJSOpTuU2JM6Y26xCMG6mlG27oBvolkbBkzLTubhzvxmjl7YVCMYTUy91Zsrv/JxTJelHraGwl7dj1dxJd83o+rMqvp4zD66quL8t8YV2HjUQUCDKHMIGLNPxUphI75cYQhbbejg7Q3Guy2wMpfJOcIqJxQqvkGaFtmo0mRsA9kTzWUYUu8GFitoxpXO8CGOdnuKfXZkiTbwHlb6dX8mgxEYS7hZsPbTl+YuPxCeBclYwsz9+MNjQDUWcQGNk11U9E1w2QvumtvOL4zxk7v2YshZ7aWOd0omFlUzmRz+h7Qk/zvtPCqmecZ79hM9e+9husew9rlVCjCs6aal
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(396003)(39860400002)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(6916009)(66556008)(66476007)(66946007)(4326008)(8676002)(8936002)(316002)(6486002)(478600001)(5660300002)(7416002)(4744005)(36756003)(41300700001)(33656002)(2906002)(86362001)(83380400001)(2616005)(26005)(1076003)(38100700002)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JoXx+Sv4gtlqTMtvfAYpE23kkcoDLBR1MdFBF3IJYMRaSwxDpA/3OJ6yMB8c?=
 =?us-ascii?Q?ym3gOyBImKwXAEnTXA1UVqGADwFN2+xbY+4DLkHMG6amOBPt3a0ydKh77jdt?=
 =?us-ascii?Q?h3g4xd8gm+ZhhovbZSFfGWApSzD7tvi3er/MDyjhScwbm4aNeArgo4loB/QA?=
 =?us-ascii?Q?vCvQgQA1/Fp/5j6eelMhfnB8ZQHtS9+sKs5hBqhSyOjvOu+7ZHqlJKI6IttX?=
 =?us-ascii?Q?qFagmnqX99jssAkABd/U83Yug2V5/dwbJhUw3m4NzhXyhy3DwJS72nrkUAWK?=
 =?us-ascii?Q?AC8eAKD8lhaBUDFmtrwGnGtaUl9qQdrec4eu64T95+6eM3Bo04TK9a/g0/09?=
 =?us-ascii?Q?AJANThm/s18iu6RZazaasCqhLsVYW0d3kTXYoUbG2kKYPd/Dp7C0LaBS+EHh?=
 =?us-ascii?Q?NbNqQSYSE47DOBB1yzNfcVcvv9Yxersa6/R/yNilwHdwJ+YIEFDx2k/3IXjv?=
 =?us-ascii?Q?wS3h+kTxbHBFiE2s1UEV8uWmUtExNFDlbZ85gphNSUK0zchHpcqqdPu6q3DZ?=
 =?us-ascii?Q?Ibq7UeN720L1O5SLyFy+FPJiFZiL/4pCWLRz07pSE+8b+mXldjDGfqVigAbi?=
 =?us-ascii?Q?uc3Xu2ucFk1x1NjAFAQiopCtWupmCFlY3p1Z/wO8RhvWlk9YTZB61F/042FA?=
 =?us-ascii?Q?MRUQRXxHQ6Z4gn1tQaSzNMRhncTWTUMkDQLgEjo8X8aBrctfVe1mQoj3QTrD?=
 =?us-ascii?Q?Wv+S3eV//fFWOWlyCcyU41T6w+sA1UU1Qv6oYfyLu4rQDJdqmyri1aIP+F6O?=
 =?us-ascii?Q?VwGH/ThWIW0YWrAmI74VQrdgrSQuKntdJVUZT8L+hKuzZKYvtSGKJM8kQtOE?=
 =?us-ascii?Q?VPzCNfLplkqhc5RQvEXHWAdjMQixlfOAJUHhQlDbJju1aN2o3fOUXOPpxh/I?=
 =?us-ascii?Q?jLrf6PTjbN2TXxOieFNK9oW/c5SVts1XoNwKYnI6cEzr3eFL7czYuJHbcwF9?=
 =?us-ascii?Q?3Y8XhbEJsNWC1slB0VrANw407mRLvv61XDKuzmWkMBXNT/4v/I66Lem3nah2?=
 =?us-ascii?Q?Vdp1sS+8YJ3n3aTfF3gB+aWej/hC6ziSaG63MoHGogKpGFIlvWJU9QUxGOAt?=
 =?us-ascii?Q?UG06E2D7i0jB1228VA1BFgxs7884yAs/UYK6EjFcEqsHqDfEpEnK3EDhImyC?=
 =?us-ascii?Q?MF9blQFefUByLJ27PzSMt9y3Dry+FiA5KwYsfad1wo+eWcuiloapoqRRhpgV?=
 =?us-ascii?Q?0zXNyrcch9xwDEV/4RG9Mf90p5TmeG6QueeYnk7iFVGVCWhFP5MaL7+GuPVi?=
 =?us-ascii?Q?6Vk4WpSOCtIqQ6Pha8gk7mU0zXsRy88tcXWr35Vrv3oGeXr7BkNVvQJjeLNa?=
 =?us-ascii?Q?XDw58Y0MUdeHwhrS4giNr2z5xCZV0REp48huyme32T+vSSFtM4p0KHx/HR6r?=
 =?us-ascii?Q?pvfxWPvQKk1Ei2HCxI2wiCrPcxmKRwzrCGWUipF0MvPt9f3Hir7sLk+QPXDP?=
 =?us-ascii?Q?ysGOIXsZTxD3d8RQLHEy3sIQydpbnMmX2DE1gG5tRcoG2LddCm4LkTGI5Ijr?=
 =?us-ascii?Q?mS+zMoQtm1ZQDPIaSxiO92+g0Bw2myhWbNZngyGFm68JqZu5vQiUMOuKm5af?=
 =?us-ascii?Q?YoGDy16nQoauixEWNrNZ1Pb13pjfpcollECSkV8s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 967ebbbd-898d-4276-0001-08dbf4f79ba3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 18:34:10.9386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PBYqUnFKSnMUoUVA8/MvExULWD02tNTZIyb722mvijODi3CfNjf1+5nCfNh+JyEB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8461

On Sat, Dec 02, 2023 at 05:22:16PM +0800, Yan Zhao wrote:
> +config IOMMUFD_KVM_HWPT
> +	bool "Supports KVM managed HW page tables"
> +	default n
> +	help
> +	  Selecting this option will allow IOMMUFD to create IOMMU stage 2
> +	  page tables whose paging structure and mappings are managed by
> +	  KVM MMU. IOMMUFD serves as proxy between KVM and IOMMU driver to
> +	  allow IOMMU driver to get paging structure meta data and cache
> +	  invalidate notifications from KVM.

I'm not sure we need a user selectable kconfig for this..

Just turn it on if we have kvm turned on an iommu driver implements it

Jason

