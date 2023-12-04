Return-Path: <kvm+bounces-3419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C50CE8042D3
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 00:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A36B2B20B34
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 23:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78233A267;
	Mon,  4 Dec 2023 23:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hExalkHU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617FC1735;
	Mon,  4 Dec 2023 15:49:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjDfkdeoXkC22txmPdgg4bL02OeKiuROtaSg/1PF6xb4Qml4K1YgmAsC814kLqcRJ0ji4SNc5YdXOYFn96WmwgM8sJa3eLzDyhlvqMcokhAaaL8yLXrYG1tndA3jyMmC/kjhuoG/rCLyLKLHyvE/Wvu1PV+okd9HjysUHwSVHLfMHO8qnCuAjg+TQoUx+x9QHRlB64+uVLb4TuMMywX1mA1CtUnaa/vSvw/ZHXD1ifcYUaOb5duV7EDZv6Hlb3nETcl/bPfVl/ggY/kNcX9XrslL9LKbpPvSL9gOgzD5IQB3/vCABZ1D9xtIM1PyU/Voqpq9ae7gGjYx14zNeTo+SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNRf+fJhwxBxEOKoSL6qsV47dYsFXFlBGph7NcBpngI=;
 b=Dt6se8zLeeoGFuivliFyhR0hq9negwM37JQVCGUsG2WaJ2FqLfaVRUqutQiE7yTpTqIky56Ev5KG160PBmtMluBnyCpIrYded/qC/98qPDlYYI6IzRalVDzHEtD1SqK7esqnt+zYiSRC2p73i6cJmmMQfh/Plczs96a2+GxRt8Cz3y8v9QsCneM4XAJkpQ3z/eq53hMeiP/h0RbXduka07CZu0b7yOMqNcwsXLwu2Yh3Mr/hGecck/Azsssde1IeS4mdmZrtpbmGtKq3xC+J+2oJecZ8/qXiU1oev7bJiRjydiD+qIdM9AiH6CzPBlT2C0dFWtClyg5aahEyOy9FtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNRf+fJhwxBxEOKoSL6qsV47dYsFXFlBGph7NcBpngI=;
 b=hExalkHUuWAKgGX3T8jIHnwwoZ1altrNE/8joqDn0AZADKZr2NaUh0rTpSam7xtQqFsYLbbLwwg9ty7lXdh71MTOHG9Q4116gsAqUhLjFfrP3BX/rV31tIRdKrCu/axPSYQ9b+S/Si6jhcHFReLP/j/3fTMQBQ0s0Lty5wTRsUTTNGjvCui+n5RYcCh/06GY8/b4DCkyxwoxdmmg8m3lWkpnlpa5utMfCYztuk2ngEVeTV8lMazIznqEFPT1FOULDR1ZDV5JXE8tv8P7zs8cmTkgYCuecmqQP1+7EcNEz7drkr54YYErQn1pXlFFFoAsUQZFWjGG7vEVW2HG1pMTTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5230.namprd12.prod.outlook.com (2603:10b6:5:399::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 23:49:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 23:49:37 +0000
Date: Mon, 4 Dec 2023 19:49:36 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com, pbonzini@redhat.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Message-ID: <20231204234936.GB2692119@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <ZW4Fx2U80L1PJKlh@google.com>
 <20231204173028.GJ1493156@nvidia.com>
 <ZW4nCUS9VDk0DycG@google.com>
 <20231204195055.GA2692119@nvidia.com>
 <ZW4ygoqOq2JpXml3@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW4ygoqOq2JpXml3@google.com>
X-ClientProxiedBy: MN2PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:208:fc::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: 12aecfbb-d6bd-4e8b-babe-08dbf523ac9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aoifjXeKK36hPHhycjwcE6ySXFknsPitf5IJI/Ms4X3SnsNkGDmC+3cIqqKJIlt01oyKba9t4rI2Ob2hyqZiN3uaypRyO7DdS7fTFyFHsblC/x4241wLnH83VIicOkIEhBl9FbulwElDLJgFbNBskpjRl1ijVTdLW9kx4Q3q1ykGhvl8PlZeuRsj/OdwpRJ0/3zQYXIkAM7+kLb/KRyJ+Bz7Rj2c1IVOcCB/3glaSSbIlFLDOXSfBvcQTGkS9DG3WkFrJsx0D9ypYVbcV3jhfYpl1LBk3fzOpuVa8V67+KIFvP5QvK9gcEPO/R9fiRmi38d+YWjSwwiXwLWWFgi2FMAWsju1QMN8f18IhNRneJqGWGH8RdIM/J8YN9jtP9kSh/k3x2oOpENTNzjrpFN+FRl5SpsCLzJHp2cnrwP4RladCTcBQcd5Ju0Iig+AXZ1F7Tosc9grOrRkR+a08cMmj6l19vh/+E358jqewTnYJtoJT16uFURD6min/OPGxhR4rOYfacg22qeTpvK8LOKw2gU0nl7oNnXbdi7PnRBQd2yFyTj+J0UGuWpIVKPBdH1J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(376002)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6916009)(316002)(66556008)(4326008)(86362001)(8936002)(8676002)(66946007)(66476007)(478600001)(6486002)(41300700001)(36756003)(7416002)(2906002)(5660300002)(33656002)(38100700002)(1076003)(2616005)(26005)(6506007)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BDmqVpHH1bMExtwlv5xUYWhEYRvSfCsC5WBeAUpuwTtUCwPrunW9yI1BBQFV?=
 =?us-ascii?Q?JZWouz1nivri7Ytmy/MD1j0u6iIQTWfFAY7vYBXA8DXFmapxJ8uECnNgQSc4?=
 =?us-ascii?Q?104EAgsTlxo5vuxyBZtNZ1oBwroVr2aSKdCLQq+6jCDNMD/94orpNWAyu9Zv?=
 =?us-ascii?Q?UMkCkYlF9jZlsViy6WAZxsHACHH3pohv/QmM4GeXtO7EzR3KyXKKkKp/FVg9?=
 =?us-ascii?Q?6hGwyH3RBy6GcM6cBe/8Mqr2JlKpRZoWMBuKZ6l25PLKa1VA7euI732mbZNn?=
 =?us-ascii?Q?LJkJ2D7wp18l4nmKUbVwYJwhRUmIWujHnHbHU7M3x/CqXhHT1ymwLaedzuIh?=
 =?us-ascii?Q?33WpB1L88hciZMlB90oERuCUCY/BcKp4bUDN4OtBI4pafZ0qDJ/yIO4bhRGE?=
 =?us-ascii?Q?/OKlBbbjis5kKCuJHZUwW1Y3XP8XTpjB69UxZa6TFlFwTLc9pwVTvtejaSpb?=
 =?us-ascii?Q?4o4NqnMr54fScNGzqSH/mAqDJa71fDOqnIC91eX6ZKeeB8qEX70Ler+WoaAQ?=
 =?us-ascii?Q?Ns9Hdovf4iYBztvLq0Q1jFkv7YxDMyD5d6Dph/AVgpYufmV7buuhq4eORpT8?=
 =?us-ascii?Q?vIyNGaJSNq1TE59EnHup7tQRRjzYwUpjIBRL76y09iAsx3T7agrGYDVEsc4O?=
 =?us-ascii?Q?v5yA67ktXZB6U2O/QhidUU6l31stZa4yFgc1lAjImQNskORdCwBl5tv8aBPq?=
 =?us-ascii?Q?9d/eM7ugPpnd8ug/z8lZR1SrvdJIoOvYJLdR/2D3rYXKjAN1GtESrHAo2s7v?=
 =?us-ascii?Q?T+1U4IV3zJlUItthaaDKNWBEGvf/7NgNzOk3zvnLW9vJYX8bSpprf7wViKyf?=
 =?us-ascii?Q?xjCgf0uvMlmC9Gsk1DTEg0+U8Qjb+ItazYIpZBwesFDnpeLjx+LNnYr+wItE?=
 =?us-ascii?Q?e9ATaRwrX5aLk+kzZ51fUqd7PZKOjsK6MNu6JN5NybK4QjYd7TiPZsf0E2bA?=
 =?us-ascii?Q?RgfKPo+Mr99UDN3e+T+5vpgjeJxtFq0HCtT5ZVGoV7Sok4xjMyldSrwppKqU?=
 =?us-ascii?Q?ZCqwGrbOqyCYiTqDWlQvQG4pqLtO5xvKcbDpm7Gs8pnfhcJTF3f4vRTZvBBk?=
 =?us-ascii?Q?6gXOwrr0HgzCqUoRoo3D1f0gPQn12w4kLEBZm8Vq4TINNp4zBXX6IwjvbqCl?=
 =?us-ascii?Q?fua1U+MQTX+URyhHhjuN2d8gpe0roGV+Z3O9vTLDQK7MJaJESIpvfyXH3A1I?=
 =?us-ascii?Q?138Bxjp7NdD3i3py1ay/edK0fvElFLxbmNQHCvz6Wp+CIpC2IPjzpbbJF5vK?=
 =?us-ascii?Q?FmR3H2xBgFygJmYa1GHovsUOytpsvUJ4FcyObZzybaJ6WEyaXm1+k0m1rn94?=
 =?us-ascii?Q?sJYPaJtClDL5FjizLR+r17sUswhtJrr3urnEgm8N0j3dmqIrECXSHF7rCS7J?=
 =?us-ascii?Q?DtXZcGikA46rmFFyrvl5E66RR4Jbyv1mvf4T0UpYT1dwM6rDsewfe/4Es1AO?=
 =?us-ascii?Q?SpOShkyeW+ohIgrRmuDCCkbGma1xH8F5EZtUGa7zQ25emQF8jDYpSinBXnu7?=
 =?us-ascii?Q?lvuYLQ/RG1sWyUoRz0Nuw6cOjOxlg9fy1AaMhrhoKcrZSNuQOl2VaJ5x+07V?=
 =?us-ascii?Q?u1d6eMDivsdBaDLIi3Sdru8pb7dtNsihFsHTgUsT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12aecfbb-d6bd-4e8b-babe-08dbf523ac9c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 23:49:37.2941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQRwPB7IcBnduIhMaHRjpsJra91YIa8vUU5tFEMo07am9+rINzlTefsc66XPt7vm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5230

On Mon, Dec 04, 2023 at 12:11:46PM -0800, Sean Christopherson wrote:

> > could we design the memfd stuff to not have the same challenges with
> > mirroring as normal VMAs? 
> 
> What challenges in particular are you concerned about?  And maybe also define
> "mirroring"?  E.g. ensuring that the CPU and IOMMU page tables are synchronized
> is very different than ensuring that the IOMMU page tables can only map memory
> that is mappable by the guest, i.e. that KVM can map into the CPU page tables.

IIRC, it has been awhile, it is difficult to get a new populated PTE
out of the MM side and into an hmm user and get all the invalidation
locking to work as well. Especially when the devices want to do
sleeping invalidations.

kvm doesn't solve this problem either, but pushing populated TDP PTEs
to another observer may be simpler, as perhaps would pushing populated
memfd pages or something like that?

"mirroring" here would simply mean that if the CPU side has a
popoulated page then the hmm side copying it would also have a
populated page. Instead of a fault on use model.

Jason

