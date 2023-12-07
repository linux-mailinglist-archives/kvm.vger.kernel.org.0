Return-Path: <kvm+bounces-3785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A77C5807D71
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 01:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AA092822E2
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 00:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1A4ED7;
	Thu,  7 Dec 2023 00:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m09hflPO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E7318D
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 16:56:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcEYTqL501pabG4G/rP7Q9W19rEqk8i1pzhYGUNaZoVgff6/z+CbavA5hjsO/q3a34xHWdkOTHyJ7ak8BiMlemGJBxSmRsRZNtETfxTg7sqH6mpd1zHbAzx9qViLxeeXe5RAg6RdrQJfJb3a86dI4croLQ3FatBBIcf3S1Lw1GHp+0UAP4imkoSjeeUH3pmAH1EgbKS400C8cgERpymQhMfL1j2pq5RuCCTKlbUMkdMZqOdL1OnFqJe4jxlusB+ahEVFmAh+/HP4vFGeIYHbaVIzqZt4DZevny8y/JIC43kdnmOncoi3NX6b8MhSO31tcIvU4xuPRlLzzHPql6a+BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=619xhRURHRQkvO7mMu9MIu1aZt9iexfCw+vczj/KdCg=;
 b=ic881KbLtTQdEt6HUO+JJrS+EB52eJRfNFHXbeAmwC0rRoNsrECN4IOpIHghb0eFCxiLGfY2jLlBomI/QXtlBkaUZnQDaafUk11iD4qy+wBF1qJZxSz4bK1WPVicjx7i53AlXkstrNnBvzRmwjeUC/90v6B30Xpm8LkGn2dlq/AgCfFhx0AboWVtTmD0ptt8FQu58I8ZukIppOy4htwL8UZ5tIXEvdyUkihu0JsUIXgTk/llof3O2ZqjK1786HaRns8a6Lx41L/ZZulxX5OqUTj0rCgPpjxJ0d5HGGp04WsoC4oZOvo2EUw9dXPYHM166J+rnOc6FLJIrH83zGWPpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=619xhRURHRQkvO7mMu9MIu1aZt9iexfCw+vczj/KdCg=;
 b=m09hflPOlssLXYZ0k1k3An/Hg7G9vAsZYtZu552oEGJmKRajtWnOEB6FBPQuIu6gD77WM/JbmY4+HJXbfrF99AftY5+IXerlAFjtr2JC6VrZYDkr21mjRIAJZp19F6AiZ3YTl2NPPJaGtkvBpXzGPRgczUGVurGNtqFOkAMwuqQF4VH/Y3sk7HQtruC1XHlM6B/xzkIZ54Q4b67xigbqeTwr5k086QRww1nMG8Y1UU3vMvJnog/ZmZ6sZiQmBrTsn3aw2WLJ5KslLgas19Jxk5VSjOT22dkhV6o8NC1poHWeZSGtu+vBpzDoKSM/cHNoQxEclxmI0OelBQP9wCgYZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 00:56:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 00:56:49 +0000
Date: Wed, 6 Dec 2023 20:56:48 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, mst@redhat.com, jasowang@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 vfio 8/9] vfio/pci: Expose
 vfio_pci_core_iowrite/read##size()
Message-ID: <20231207005648.GF2692119@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
 <20231206083857.241946-9-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206083857.241946-9-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:208:fc::42) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4243:EE_
X-MS-Office365-Filtering-Correlation-Id: 32b1f7f5-23ce-4fe9-a2a5-08dbf6bf64ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6pCbJeY0tKhWQIdkUL3u2Ctr1cDlQ56r8Ovs8TlGvhDZc36OjgTK6kj3VG28H08+wjnfw2DfBAxza/OkHyXX6hq02X3VskSo9/pyedtlrTKqzzZrXwgyOCXfk2pyFIeVHmKqiSfwORHsV4I9j3b6AwSuu9szMwfQDNJPYirlSpkDRo/svAF8WI8/pQqAbJ5ZHhynE2tzbHVRsF7FrZ71RuUqW6V59ZXlC4kKGW41pW2511UOwBk5rVN7JsAyZaRoySeQI5YR0tEgmpeR8jtiLuow23yFJEmHddzCSlj7wkQ8oZtwH7hZA+n3k0yN7lAcHIt/XblPH0Bm0yIj7jyealKXAaBhF/9K/mr9hEuYSw4G5oG+Rk+3qohcQ1I27wYwVSPPBkGacKp+Nv66y3wSGDbynp54zNk2qY6MMr7rKcSL9OHXBJB/FGkHf9qFBV+zUT6P9IVmquV+9nuqsrUW7P44Oqn/iHFMNiOLxMZHIEJyLoyKu0+tKvwGQGxWmt/WErjeeLkuGyU5eeJSuRpUrPmJqfZNsULa3JcfohwAiu0BvDrdvSnyNwgEOjc2FY0a
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(39860400002)(396003)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(33656002)(4326008)(41300700001)(36756003)(316002)(37006003)(66556008)(86362001)(8676002)(8936002)(6862004)(6486002)(6636002)(66476007)(478600001)(66946007)(4744005)(2906002)(5660300002)(38100700002)(2616005)(26005)(1076003)(6506007)(107886003)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ApGWF/cjZJySc+9eK+N2qm5CoxKeAo6+UPGia5TJYwmJbrPKIsNSvU6nLsPv?=
 =?us-ascii?Q?OouT/Y9EQ6iEzTRtgmLGnj2SG13VYzUv0HXQ7TI3+2Kw72wLEZVJEt+0+VC5?=
 =?us-ascii?Q?i9k0+sjpo9ofu2ZF7bdnPMGZS7NOhLS9w2A8SgbLYDbCRLoobs8WHvW53Zsn?=
 =?us-ascii?Q?KV+qdPz33pGxqZxtPi3R8okrq5mxlBJ6TajvG0FiN/EXQDGuKxk5ryawQKua?=
 =?us-ascii?Q?LHXMKxPAfVu+a6BRBzi9DI1eyZgQzL58Oe0EKluhdVVD5+4w79pQ7TQVdktq?=
 =?us-ascii?Q?rQAyNm7aZ95PzdC8G0EKhi3yBBr18caLya6ea5VyCI1fNaIW95MBtvp3qqdH?=
 =?us-ascii?Q?yFMsebGG+h8h0hjOJG24nhGjTxdnIX8fFxUKQ0mjy1LUZDjpOyypvslZ9WV0?=
 =?us-ascii?Q?W5jeNQyyo2f/+HREGhLoktiG7NM3cp4cJDObsieVwrb8onw03Gm2+FfhrjkA?=
 =?us-ascii?Q?+BqWOOJGEnhlaHT8RInVNyj33lTFGrJ4hRCdoyuuYkIUV7ttIrqhb/M38K3H?=
 =?us-ascii?Q?8JEfB/IBAtiDi31JlE2RyyOiAWXdFuXUCgMir/nz6Haq5sYGoV9RdH+MncB+?=
 =?us-ascii?Q?mvslD0HlGbSj4oeggVfzFcZoCf48WSyUedXGwJQWitjLUM/lVQbIs5RDATph?=
 =?us-ascii?Q?CuKrbh3dyJp0x9B5PAs9N0khMYWVvtc/H6BeDp2zxgv3W+S4ltyM4nhQIhrm?=
 =?us-ascii?Q?J1AITlRwMk38INky7KThGBBjZTQglQiDH7qa7qcpe5LJWSXSCT2Z4U2X71JT?=
 =?us-ascii?Q?VE+MNIYiupGjmKMqnKCGS8SdGfTKZYHlljqCJiNzBhMvnP4y1PGaEidSTDat?=
 =?us-ascii?Q?3MgBNxJDY22iH/wtPuDyN8f7qct3s/m9o9W66YPZpNejj115tVvdb+Gwoen6?=
 =?us-ascii?Q?m82no9yFkczb7Y0TjqTpaNx8LBwj3qBT9DCgWktqpM8FRFCk0l3pKYJe78qa?=
 =?us-ascii?Q?enwD+GTXEuHasX49OwxkunpixIzSgYmLjC7F0Qgycg+ZNGnUttDBHl1k4umJ?=
 =?us-ascii?Q?TQxZmRqiiaq4E0ZiFYEtvTBqSLDT0u5Htumx1zD/8P6iKvkWswxPZsrcZ5su?=
 =?us-ascii?Q?MJPR8PACqa5mPlfTPx2hxXRsFjWCaAov+eDndzGw6+9mer5BM4CajwABkYx0?=
 =?us-ascii?Q?mq7DwRvfZ+8RLZyuSIyiGS4pd/L4zs0WHJt9Rsk3WEfts93ehhWiq/pwZvcD?=
 =?us-ascii?Q?eBZGjVYci3K5+Knr8cGxv8hBKwhoM1sIDBHhmHx76g/ovoenqW/JSwtqOXLq?=
 =?us-ascii?Q?cH5CpG240rLouEyQk+x5K/7qMySxOt+Kc6UN91rNgbXeQwxcT6g8PMgqciw/?=
 =?us-ascii?Q?IRLA531z4z8o5JaWfI6bxr/3pOzB9+vklwtDzY18XcYBjbzgUkhWPaAK8yVT?=
 =?us-ascii?Q?DJVRHHGAOgane7O4j8Hywxk4KoMixvLUFiiumMJs9mvbvgHz2Tclga2j1Rji?=
 =?us-ascii?Q?6WzsdEEM8wJF9gkMiSSTJSNqGR8HEhA1AX5kNfv7pnW9PvKobo09owatPN/l?=
 =?us-ascii?Q?8J+knnfnX9otOVJNLUYV5E2/+EOA6sy2mVOvqAASz5V7+oMmvWY81cwNjvii?=
 =?us-ascii?Q?HfZzjqeQHOtZd8zl2/8yVfnvzIS0ALFCW3LbnzOA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b1f7f5-23ce-4fe9-a2a5-08dbf6bf64ab
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 00:56:49.2303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4AW0VRf44wqnjK3K6IkKIkF2hISdqkZ2AJGvnGKlPpF48M7QsHycNkHIBk/TbYA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243

On Wed, Dec 06, 2023 at 10:38:56AM +0200, Yishai Hadas wrote:
> Expose vfio_pci_core_iowrite/read##size() to let it be used by drivers.
> 
> This functionality is needed to enable direct access to some physical
> BAR of the device with the proper locks/checks in place.
> 
> The next patches from this series will use this functionality on a data
> path flow when a direct access to the BAR is needed.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 50 +++++++++++++++++---------------
>  include/linux/vfio_pci_core.h    | 19 ++++++++++++
>  2 files changed, 45 insertions(+), 24 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

