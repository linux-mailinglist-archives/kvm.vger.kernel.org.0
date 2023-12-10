Return-Path: <kvm+bounces-4004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDDA980BCA1
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 20:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E862E1C2048F
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 19:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B8A1BDE8;
	Sun, 10 Dec 2023 19:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LQNqp0KU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E634F0;
	Sun, 10 Dec 2023 11:05:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUFVYFI1qhUn0VTnlIcglhjUJ57VnFEdGVFG8UYp938q74AiP+tTUX9b6waJIVew5EBSUnonKpLl/3RJ4DztmxZTehA2QFQs3btZGbK9zhWYK2A4PaguNjLE5DFfRDO6326TOS6B/rZj4JB8j6a+GSbtO/k0doN7gtzOA42ay/d6mptIaKL0kd/R2zHyz/Ao0DO/hVRES3YMZ04txhnegXMJdhbbkD1SLAw8+YkUvz2ncNuz/YHdQ560DSgoVkHAfJXVBGsLEwc8rb2aj3Jv0vplVP4qv58TFN2YV6u/tUNTRtS5Iq4MAdYZv8yCGZxr0cbxOfulbc308NfRN4AS3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZBQrpkZoBhIxj/w/mK1NfwQr2EDcC4fHBxdZiol+xM=;
 b=K9BLoyIWVGevFiOpHMQB+gsSj0dCZrnxG7Stbknd+AQFd22rT21WJTnz1CPsiuNq5e123ETOaBaz+lTSoIp2Q8UlRGENTXkc9MqnDBNaV6s9vRkO+10jlkJsuUR+CD5dBiPGcR1n8osK0QJwtPPeOViPTt4zeR12g1/Mxq2RwrvgST7BmKbZO9VaaLZi7ocNfl1tglUq32JnuqeU15eJWwtFYWCIi+ahY9BuYk/e3cnBPnk5vU2kfwvTbXMHtyeCEXmo5iFuvB1nOZMD+MQNVfBf7WoZSSnCQdS8u6MmhHBsvS2OuATxZSsN56w/BAFkp5WPb2Mbjqja3drU6U8SQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZBQrpkZoBhIxj/w/mK1NfwQr2EDcC4fHBxdZiol+xM=;
 b=LQNqp0KUv2mr2ox0ct7By9HKX6fOY1Y5EZlMh2Gq9grCp71T14wW6nRHRyvwUukI+RDlBD46XVlLRYyvt2+JzlTlrO7w26TaFQkIB6MCtF/pxXTStScx1y7+85cvIGpIjXVDroKFE77ipb9zgVXusCafFsIkBFjDeL983WIz3F8IOePGz9ivwbomwfxpg+0Vpp/TAHfyEbDMVtxJnFyrR+Vc8X8ukgE/uoBcfvnPqJYHJ3N7UBnKh4N2+ipPXtt/3V4FhpD+0xOb+S0A4wvH+wwMmypTk/Ns/5I0aU2irqAWra1MFLqKl+q+B3G7volEmovUGVc9fTVpojhWiPZstQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB7893.namprd12.prod.outlook.com (2603:10b6:a03:4cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Sun, 10 Dec
 2023 19:05:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7068.031; Sun, 10 Dec 2023
 19:05:50 +0000
Date: Sun, 10 Dec 2023 15:05:49 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jim Harris <jim.harris@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>,
	"pierre.cregut@orange.com" <pierre.cregut@orange.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Message-ID: <20231210190549.GA2944114@nvidia.com>
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
 <ZXJI5+f8bUelVXqu@ubuntu>
 <20231207162148.2631fa58.alex.williamson@redhat.com>
 <20231207234810.GN2692119@nvidia.com>
 <ZXNNQkXzluoyeguu@bgt-140510-bm01.eng.stellus.in>
 <20231208194159.GS2692119@nvidia.com>
 <ZXN3+dHzM1N5b7r+@ubuntu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXN3+dHzM1N5b7r+@ubuntu>
X-ClientProxiedBy: BL0PR02CA0079.namprd02.prod.outlook.com
 (2603:10b6:208:51::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB7893:EE_
X-MS-Office365-Filtering-Correlation-Id: c72e17e1-98a4-4257-dde6-08dbf9b3068b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TNM39ovKcUGk9i8g/rJGNffgeBKL6ZGbEuNnrAadmxNHpxHY5uk85txIG8WZL/AEi05UoYLMn/0oJhrmeZbgC7ccUeI96sJSCncNJoYpC/MVsYTgiq47lWXrL8wQumAkVWZrpCSxJ25kn2qyGcgeANhqHdDyywtETLET5JfZRYGqmfbyfzlas/zcaNd8GU0+GofqoFwBEOTMOT2c2RLUHvms3f4flh+Z0HTrvGsjgHbhQR3Q+mcD3gWMRdnd2nZBluHTpdE2QJ+JjmXN6IbbN6tzhKt/PoNeWX0SzIpK0Tqfr6Ufm0RUNRjhNHAL6NVOw+LmXzYIhv2GkGoZDMyNj28brRTyB9/j6yE9GH2dn3RnP815Y3Hj2TTnQs8HTKqeqqrZOiNEv/eQW8mcRH1Z4JQKXG6Q/2Lp0NLoT55OSr58cMdhoxegprmoeyk5Ja/XBQlRld7XkSqoxW1cgyB9mFVFoPW16qSNvcRNGI6DpTl2QXZFCkfD3KGIhXn0WHHSYZ3kUQyMkeJHvlMhuaTbLwR9rKFTSdRarAyQo56G2e0AKFQAsUrBRPhtw3ZYOy/4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(39860400002)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(36756003)(6506007)(478600001)(2906002)(1076003)(83380400001)(26005)(6512007)(2616005)(6486002)(4326008)(8936002)(8676002)(5660300002)(54906003)(66946007)(6916009)(66556008)(66476007)(316002)(33656002)(38100700002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/h/BTh4Gz51U6tRQmawsFMJRc22b6an6dL3ly/ZEfRZ2rwyZ6Ax6/mPjQUtx?=
 =?us-ascii?Q?eHfxAjhd1Wrp2xkPrSoFIwSl7AuHtZrpOQHUsEuZGpsOkzXi4qHPZ6qoQCBA?=
 =?us-ascii?Q?gXTMKpTlx06lUkB8O+5MekRsZQYtoyfBCX6Nzjv5GxxnJDt4/gn/WcWHKOPR?=
 =?us-ascii?Q?3iBqBGtkJ1BwSrq/SgiV0QsjbkhqKqk/hDlHdELv0v1w6AX6rifRawWMSqoe?=
 =?us-ascii?Q?kCAxrKDX2SlZJLEPq2Zz5jnGYnADU+yFTdwcqxO8M5eY12vbMTgZvNpiIoa1?=
 =?us-ascii?Q?/6UhLO5tzj6TzE3GLs7fsiGnoqHL+c6d8uuIkUGlNwkcoYI/WPSbWOoRtW5b?=
 =?us-ascii?Q?zoc1QhOsw6Bgre6qtna0+YfIRIdMhgZ4ZlE587GqkCBnklMrUZqeaAam9Yn7?=
 =?us-ascii?Q?SsabiscuHD8eI3uSJZDsz3az4Lpm5kYmKy1MLI/Yvc9j6ZXaqbuVqB7m2hHy?=
 =?us-ascii?Q?6w8seIPVc1Eu5dJwXhjE3yv1s6ZGP9HmaLsemFx7Fj1EpOjnevv0dHo3RF6g?=
 =?us-ascii?Q?sfPus2zqmRvoOjYC5RPyiQiV0EdhsD9PXBY5R5LwlF4jvmL0FkTs5oe+fLwb?=
 =?us-ascii?Q?RjzPrYfqKv0g7BLd4zwxBPV8al7Yiz7MQif2+ioLD45e8C72VNo1eWZFaTYG?=
 =?us-ascii?Q?PVaA2JfmS4yVDExqwzMenXhmkQmM+cgVT5ASWot/YT9gurxDueX9p5tyWji9?=
 =?us-ascii?Q?KqvqEcolod9Bs60GjTp0zSyLOpl17jgMgu7Uk5vsCoRYy32QJJqghmjAheYK?=
 =?us-ascii?Q?4mXQBWo2T60zPuOWMzG6RYrhBGaqNmbzCCBDdESFSliG4hyRmoEr+nTnKr89?=
 =?us-ascii?Q?I85+jQTeO1VZXtUCOy+x17khHS51WibLKoWOcYFLZPwuZ0PFM7mQUf9wKIcj?=
 =?us-ascii?Q?3M9AtAV7HOQlV31JpDrcJ2846pqcshTcIrE9Dv927H+/Wv3p4yLy6udxQE/j?=
 =?us-ascii?Q?IU4CK5GOgqchItANGV9bksD9MI3EzBIkvV4q9mYf5TTRzaGcJ/KQ2goY1LAs?=
 =?us-ascii?Q?ZoR+hIoTnX8N485qACOgZ65sGrJqGcR2EnnPVA0ocJJXLBA7r46OoW4Apjp6?=
 =?us-ascii?Q?n4NmNZSImUh0HA0J2uANFlCoDXBzz1dOLLEwcVop3B3DYCWkMKktwnU8Rl8Q?=
 =?us-ascii?Q?JtLwO2vnJu3ptXiov2EuIkzlIuGFuu68n9cWqa8J6tgHQ7zYjPQ/gZZvsxPP?=
 =?us-ascii?Q?BM58B0rzoywYkGgWY31bp47Cv7ZKW6FfBjo1BOxUYYlWjwK/runzYiM0/+QG?=
 =?us-ascii?Q?6naMj5G/AUNuDj/fvPBrWOAwDNna/kbQwO9VYcZnsnAp+8K3erYOPO6kKvyM?=
 =?us-ascii?Q?fQVqsGnb3dfV2atCJvehjjXWNyu3yC4vrL+/G0V0ucVCJgtr41spCCELjsy5?=
 =?us-ascii?Q?MULufBwncCtrSR6qKLPfFIhhjazdhRSh5ZiQin7vYzqBraW4S0RzT+FH2/q5?=
 =?us-ascii?Q?V0bmFlexBjfYInBzgNo2BJjhbFHwiO8KHskzhZfYewtQGCrq2Dl/3nVa8HdU?=
 =?us-ascii?Q?BRYaV991acJJhArCTGsjAW+o8eiqPS3CboYWNR5E+6rmfWtdDFE1dj1/VgJp?=
 =?us-ascii?Q?oKRBrpVj92oC/grsjnGMIbL5o2UGcCAEnYmO2FXe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72e17e1-98a4-4257-dde6-08dbf9b3068b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2023 19:05:50.8931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyP2Dyza2x3QA5MCifgc1JgZst6a801iHJsuGI13TWPjJcvU4VQ7IERB0/AOZw/W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7893

On Fri, Dec 08, 2023 at 08:09:34PM +0000, Jim Harris wrote:
> On Fri, Dec 08, 2023 at 03:41:59PM -0400, Jason Gunthorpe wrote:
> > On Fri, Dec 08, 2023 at 05:07:22PM +0000, Jim Harris wrote:
> > > 
> > > Maybe for now we just whack this specific mole with a separate mutex
> > > for synchronizing access to sriov->num_VFs in the sysfs paths?
> > > Something like this (tested on my system):
> > 
> > TBH, I don't have the time right now to unpack this locking
> > mystery. Maybe Leon remembers?
> > 
> > device_lock() gets everywhere and does a lot of different stuff, so I
> > would be surprised if it was so easy..
> 
> The store() side still keeps the device_lock(), it just also acquires this
> new sriov lock. So store() side should observe zero differences. The only
> difference is now the show() side can acquire just the more-granular lock,
> since it is only trying to synchronize on sriov->num_VFs with the store()
> side. But maybe I'm missing something subtle here...

Oh if that is the only goal then probably a READ_ONCE is fine

Jason

