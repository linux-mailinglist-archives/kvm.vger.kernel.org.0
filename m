Return-Path: <kvm+bounces-3587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C298057ED
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B4F2281D7B
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A161F67E63;
	Tue,  5 Dec 2023 14:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SZVCGNiq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1425A183;
	Tue,  5 Dec 2023 06:53:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LarG7QPpuZQRsUja7qmSahka4l2vFMzKQX9DBg483U9crfVdfJJ6+NN5z1hSORCqvrNVCP54Pp6DoA/IcI3IiJw1HsK9wt60CHYJv32JiOBt/MrLVgzN+LC3LrjkxFCksSKalZVie1jDM8IgZgGdb8Nehi4HYzWl3VZF+dLxfk4Cx73YTZBDqvanNyG7wWKg2yOAXfbt2JhAwjWcP0Cv9+2MeTxzNX/l5qZhN5enUfs06yuoPmXPoaZ4d/idchLyRbX6ikHg74SR2rlIYF6FuR9jhMysyf90+mWMUB5ZMXRxowdE0/+BKfkw1Xv0KaL/Hz4eMenZd71zIxSDyIYZhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1VFyAdrqU+gZaRf2hA7rFQoVOCm4/6MYu79H/uQKPY=;
 b=CWtHs+8ccIwAsy4GVhsp5YWIHErNJKL1HRuqfOxbBPokCGtk4fqOOQEjTBSu/5wAZXcTzq1mKAlenky2O3aGT8TG+BXsKY24nnh1njwD5K6d9o3OeG0807h9ChtMEFnm6NuBXncNsESZ/uiLm73+45hD/qRH+TKhCMotGi/Udy55dV3Ll69LolJ5Ocbt9NlnvAh2tICaOSMSpZZe4Wc2zdtdXtLMr4rS4R0KFp9uOyFEFv05UJM8k+PnWGArek8hF0esVkku5faW87vTevJ19GJU7pmrBAwCqQMhzrTKIqYA3eJJh3Vvh1AEWM8kupBVvqEGJuQoe7JkcaaiTrIWCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1VFyAdrqU+gZaRf2hA7rFQoVOCm4/6MYu79H/uQKPY=;
 b=SZVCGNiqGZPPtQ62jgt++Us8Pr5oxZMxi3XrIZPNOrWYYg6174BjoZNYLtqTHbmT597wspsiQ2x33RksECsiuWJ5h6tfRijFeSabGUM8wHR7fS+BA5GjLqfS2vlrkegPdE9pSH9Q4FjeIFSzZjDMX4YwjRB5P50LCM1RrNhWeUSGjLZ3ekAWEPw9wFl7P1L6BxoeGsBg41q216Zalp5gggayDrot/4PCZ55VxtI3fIxql9TllS1Z1G30O7y7PLv8ZgNP8FIwZpcYVGQkyNkhldqW2Bdj79E7iNATQX87i7qifR8YTuk7TSK4vkA10UDiw6yoQSiP7BGicgLrZIaDhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB9243.namprd12.prod.outlook.com (2603:10b6:a03:578::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 14:53:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 14:53:42 +0000
Date: Tue, 5 Dec 2023 10:53:41 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 16/42] iommufd: Enable device feature IOPF during
 device attachment to KVM HWPT
Message-ID: <20231205145341.GF2787277@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092311.14392-1-yan.y.zhao@intel.com>
 <20231204183603.GN1493156@nvidia.com>
 <ZW7NwSCzswweHZh6@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW7NwSCzswweHZh6@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BLAPR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:208:32a::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB9243:EE_
X-MS-Office365-Filtering-Correlation-Id: 7be6020c-baa0-4b75-c379-08dbf5a1f934
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C+PMaAofxZ1rPtcR8n2yluO72rNkzsB5kxkj/V8r3dFHSFygTZks6LpcGHqoqOxmTtjY3l923OIJqmZgLR9GdsT/h9Ok+mHUPMBzgQ39Wmp/d8tocabaQXO2eN6CgQumYdU0sG6ianxQDgfBn4vKXnxa3TScSklby6djVvv1X84vm2GaXaA9hqHmWG8EdK6Xe4hpaTBJQ1nRQk2Eoa3qK1g0DFi/Yh9UsepNhhywezFiBlaBq/+JRZl8GPmBf7R1AjJ7Hy3dMlU5oIsewEd8AJNqQyQccCc6V4I9IQhyKT5JDaoFEIpGEX4hyX8DuUf89oqwdxejoBPfRU7Z8w498gbVz6CuiifiU3VTxJc+64P/MYMH5FfZA+aek5eqkhAZ72QWSsm30lPksYIZwXYE+Uk5BP2V0mk5vO/Yo7BMrWs44BAz2iK5ZsMk8JElvgespRHQndJCNK+BoafquAoL6HLqjDdvf6oZ3buYF6/WEpau+zUi3KXdSmQMC2BwS7t6z9Ty0gh+QT++PvTtWCpmZWTbzS28U1Ey61AnuLGxhZHpOCxqPQCS0vZ3kdmN84ts
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(136003)(39860400002)(396003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(66476007)(66946007)(316002)(6916009)(66556008)(478600001)(6486002)(7416002)(5660300002)(41300700001)(36756003)(558084003)(33656002)(2906002)(86362001)(8676002)(4326008)(8936002)(1076003)(2616005)(38100700002)(83380400001)(26005)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?52iZaJ10FN49RvDXhAsdW0nQJCSBRZNxRRN092EgZHLn0eSDE9+ARv6SBmEO?=
 =?us-ascii?Q?kqy+ZlWgoP6nTTSOkkzm9LRhCFR4pBv1zA3ZuWUxWWqm5yWtuo4vjnSQazf2?=
 =?us-ascii?Q?YUYTi5xsJgbPjX6Q2eNN+H55F0nnDgSSF0hDRlFjfoa/VfYzVuNwPT+nDUxE?=
 =?us-ascii?Q?s/ds/vD9t0nvqJAatRj3dRw3zOYh2xU44w6qXghWmgxg1xxQBIxWVBOH/5Cn?=
 =?us-ascii?Q?IaInSShPimAStfbeSgoN3ZwkGwoZJw8rKJOtfB7g40GioWhPGW4Cio4bLr/F?=
 =?us-ascii?Q?2j+aq8q2Krdg7s5A1I5Q3IXvikoWAqHRkF59IzsgiiBHczJ3vEpa5nTyP1Qm?=
 =?us-ascii?Q?AIVUURFDMS/aqtCSXtzjqcGJHQ+znPPccxtM6MsQ4kdGPJM3anZ67sJemK8r?=
 =?us-ascii?Q?Ge4pg8Lbivi6yZ+1Jue4CVBQo+r2/QPp5uq+gV8d8gVnM6TzotbAvkoRoWfd?=
 =?us-ascii?Q?b8DNx7X5g1U97gdi3JOAiicyZgEG9FQsqhTgEHGxOWkzwHI25GVrjq4GMea9?=
 =?us-ascii?Q?BM+wgcbcZbjfOo28ID37K5UfnofNBSfNK/2/8zBWOgfVd6fjwlm160YIUpkv?=
 =?us-ascii?Q?FlwRoWGuWKsAfEJQwea1z7hhGRoN8ug27WDIxhSumgW5zr/1nHJ5b9tQTPE9?=
 =?us-ascii?Q?8HsWSc2r2mbUnbXt7sF2IRUhYE9s+aVH+AlVg9uDMHShdopd2uYqKwMh14Kj?=
 =?us-ascii?Q?My4tg0eNMbeRNEf9QwOTcdI4m5J4gEXGbW9X5Gmj686Cml/oUXbZLZ6X7zPd?=
 =?us-ascii?Q?XpefxpU1x9mjnn1hd544w743+ob6F46WTv0s3qh5Y8r9wDRTw4VFdsnexwSS?=
 =?us-ascii?Q?lZg33e/cxvZvt8R1/Yz9hGFHFzOMnIyD3q3TTKU/eQy8WY/HqsETAXYo9B9R?=
 =?us-ascii?Q?RswYf5fEfJqnD+lwImZyuWymLvt5ixKN5rvl52ycsNnGJ/iGcEGuR79xO4e+?=
 =?us-ascii?Q?GxDRyy0sR3lFv2MycCAnPJAKW7dDfCkfYfMSOFYlKg1F0LQHu2JCZC89TSM7?=
 =?us-ascii?Q?3htBe3cv9E5+3gYyTYuclGoBuuSp50WHoJrY47UnwXzWjZchcG3lVYtrZrgS?=
 =?us-ascii?Q?yz5g9latytPhvco/ZKkGwZEc2lYkDMQP9K5VKmQzpuYaUIfHYu96zQWcR+6Z?=
 =?us-ascii?Q?L/B3AeDiQNAqbZbewB1S1SEPqYrANobC+qjrrdiFWf3X8Z1lslSn2SQlBs7H?=
 =?us-ascii?Q?EkK/Debf0ZaUnC2QOWQsm5LnAHzcVzUhlRDXR82YFiMyBrMU3RJ6dfrcdenx?=
 =?us-ascii?Q?1gJjDYjfZUjCe3GPcUs6qWm+DYUzoYdrwydCLuJoJADr9yyCl+/N3aYa2b31?=
 =?us-ascii?Q?O4+u9YayZ+gTJtrqW4ccrgl2RYyS4RCB+7b5CAA92CDsULJMua40y4TQTZyM?=
 =?us-ascii?Q?4raGUqeC7X3m8HWJ94YojnYk3BfxIpYgfYC+mqBEtTbQAWrM5GNrCkHNABSm?=
 =?us-ascii?Q?7C7KxNAIr/i6vi8n751VujbJIFHWOBrKQ+i5YUIA90yD9jVjD7JKy5Jt2zji?=
 =?us-ascii?Q?fCCdXeqgOvN4cEFen2IIbYwDDIFAbIcl9eB5nBI2wu5RTTIMi/xDPiyIbQrD?=
 =?us-ascii?Q?L6RXDnENrhjvhehThq0+G2IN0JxzoR4S2tTZIkNx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be6020c-baa0-4b75-c379-08dbf5a1f934
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 14:53:42.3708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /WvJE9sISbHV+tenJe+sMatNRNGWVcuVBS18nquIZBkYRZ1QSeE1ztaOZYQlO+Sx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9243

On Tue, Dec 05, 2023 at 03:14:09PM +0800, Yan Zhao wrote:

> > I would like to remove IOMMU_DEV_FEAT_IOPF completely please
> 
> So, turn on device PRI during device attachment in IOMMU vendor driver?

If a fault requesting domain is attached then PRI should just be
enabled in the driver

Jason

