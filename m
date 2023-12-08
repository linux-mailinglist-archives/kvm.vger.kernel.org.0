Return-Path: <kvm+bounces-3962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CFCB80AD42
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11A991C20CB8
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B4C5025D;
	Fri,  8 Dec 2023 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cQrtp/y3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2080.outbound.protection.outlook.com [40.107.212.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8B81729;
	Fri,  8 Dec 2023 11:42:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DG6TYouqkF8RjCj2lHrOCXuO1YLTx+k04PjUIQsHROfiuK4w0A47uXk1sJXVSU+Ua61/sXa8TlWGCbQl6UgxmCWfP56QztBXlK4mToICbKTFJCZWTiIjG23spLKpxzv/4onM2+ExmAlrz1UlwUZpw7kbznaWESfdFlzWcKfJ8krKUPiCi9CSNwAR5v9PYjNXS7O9P5vqJ3e+JfF9l+nE8F3NqzMtUIcFqkMf+3rCziZGvg68IPGhjqexwfNwgsdo5KHrqk/KgqdqMKwunouKEUVNHvD3zWD5+8Djyd353axngkpXM0Namhv6TTeZx1oX4f7pFOBSZgR9+XfFbSDE/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45Q2NpeZKs88coQLJQCvZdgudi/rzG/+8MoK1JDRStw=;
 b=DhyzJFbv+oAGcybHfmrD2s3raXCxOs+JHMamOOVMFFbaMvXy9TyRZpfPEsgJ3iOsT3sHTe7yHLFLswWFOVjbk3kbCJjTpQEicXabtdVA++dL6H06xfGw1udSjvRQKV/XLMbXOinbp9Vq4290GwnMVnn++yMmA5hQcKel3Kv1+kiScdhrfiNUN0RrIB4ZZLuhn2+TW1tXaZMmET4MiC+vXjQq8j/F8gQ4PfaehRhj04E1cxTutBZyokhUO6KUOY7SXq7b/1er5ISYpag+fD2SuHzqTAkwGfIV46c6G9aL9uMrcIuqpsGqtGNyB6OQKm3d5Nj6hDmYdnAIYT1n5uJUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45Q2NpeZKs88coQLJQCvZdgudi/rzG/+8MoK1JDRStw=;
 b=cQrtp/y3AjBu1a7qWAk9iWtK/K+B3YpB3AZUCJyJ8rWp/53JvgQKt6/ef1FZLWtXABdmIy3vuSQBLeMD3huV8qebqC4RJkynPpDl/KQowpWr6/Y+Yo3/Mi27QhMztMKRyvxnmJLD5yL92brySWdq5zxJwdg989y6WhT0A6xvJY+rGnN5BSuEwCgbbd/XuxewtCxLyumfKJYgKNIanIwpCCB+ctciztYKXGwskzd305iYdZgLfc2fzq4hDHUPPJfTHOfo0eeP6Lg+/2SE3tl76gdfljXqM8aXFdm8nsyzWOK+wGh+52IHnsXj8dDDgxWinRHAeR0X27XhpGlVmwTxQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7909.namprd12.prod.outlook.com (2603:10b6:806:340::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 19:42:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.038; Fri, 8 Dec 2023
 19:42:00 +0000
Date: Fri, 8 Dec 2023 15:41:59 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jim Harris <jim.harris@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Message-ID: <20231208194159.GS2692119@nvidia.com>
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
 <ZXJI5+f8bUelVXqu@ubuntu>
 <20231207162148.2631fa58.alex.williamson@redhat.com>
 <20231207234810.GN2692119@nvidia.com>
 <ZXNNQkXzluoyeguu@bgt-140510-bm01.eng.stellus.in>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXNNQkXzluoyeguu@bgt-140510-bm01.eng.stellus.in>
X-ClientProxiedBy: MN2PR19CA0071.namprd19.prod.outlook.com
 (2603:10b6:208:19b::48) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a5f361a-9da5-470a-a9c8-08dbf825befd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ruoQWcRxdhEE/YDfrNDARGNblVUgxqfnFceZg2iuRU8O2JfSOz05sVPkYW5vNeNFkcn6Nm9MbVXdq1hROgjnCiP0uNDcYd82bFt5W/kCdpiFl7A96TXf/t+2lGxe553uTDj8lLk4ZsxBwVZRcAcWpBLnzvirHqtaDP9MaLUJeuMyQsbXpvQgjXO/c1UyRmJCg1j9uMFrNUgDuTAk2dUEaIIr+9J/kbuu9ocM1PNAIUGGieeBbRikeO4UulIILESeDomG9dJ/Fi0J6G3ZSeO/VU3nlvho3cKFIJzsj+/qzwnpOZT58MeTpnXB0W/5T2mBf278AyUzgbOMCOL2xuhwGkSnM3pahmIXAlpKlX0+KaUnZIfI0lcCoei41EdiVgFuKqc4NJfNlTIgrh87YkxdKbs5hfotAEnBbe80j1Qnu03nDaCuS56IqNR5UZQsaPQTF5OSlCVJLmMNqGo6UkeFagsTGUVB3SMGnAUIL5LSwLqR6eNIs4gE1t52FU7f+DOLH6fYRvoCllBIAdRLdYpPxO24gJGAo1+zuF0PQRRlreBiMTUoWM55hhD+ldub4Sql
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(8676002)(26005)(6486002)(478600001)(8936002)(4326008)(38100700002)(1076003)(86362001)(36756003)(6512007)(107886003)(2616005)(5660300002)(41300700001)(6506007)(33656002)(6636002)(316002)(66476007)(66946007)(110136005)(54906003)(66556008)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w/nvP4sfmlfJNVRMwHTzNq9t1OW+cTp5Yqi6wlJDYKcdWKsmfp4nmqqxD7+r?=
 =?us-ascii?Q?NR1v8Vpm/Jk4ycr/8xEMD008Gpoe5vjkOUtdBl7/3kd1lVqCJv5sX3BGDy6i?=
 =?us-ascii?Q?FpG/qyf1dL0VmjOidaDiBFDaKPoGg61o5izXrDZsq5U9w/8imojuUsvXP79z?=
 =?us-ascii?Q?rO6cVIBiNIIKgLlW8+i1LNVmYDZ7CPMOaBlGflIa0qVmldRIF24BGevxpDqZ?=
 =?us-ascii?Q?CyWe45JifSv7A8he4EmW1bcC3u/O2UAQLRgKn1Dv4Qc1Qsu2LGEJYrqnR1TQ?=
 =?us-ascii?Q?qYI8ToC++w5BYlMykrr8gX2SSOW0WuTZ7O5ZdsRGHIqi2S49WC5JfBxhG1QJ?=
 =?us-ascii?Q?u8KvZ89dJAR810fuqSV9mpnT2HGckmaJrEtu3V/SDc97mGyAQPyMtQRkmAvI?=
 =?us-ascii?Q?vjMAMtyGCYHAk2mhWhIO/VG7ewxUjbHpKTYe+x+p0ytYYSPGDZTQBapHsaSt?=
 =?us-ascii?Q?F+yU9pW7CZysjaHjuO8GJTnVITbzqGaaIyAeKDbLt/6xdW+wgQEn3gRgbysO?=
 =?us-ascii?Q?Wifb03XjYf7eTk0/GuXdoO42RFz63aVhNaJpq6rrtK6Wb88mZjOBl4+nh4pf?=
 =?us-ascii?Q?JmBvtOKgmR/8hQLA7cZ4lreeeSW+61xN7ZFU4/od5uC7UlyxvTbpBCe1eHbA?=
 =?us-ascii?Q?3U1dXnfJGWV44YbzN6+eMQc6yMFDV7zsEbGBxFu3/IqLc6AtCtS3A1HOGHZM?=
 =?us-ascii?Q?BC5xOdR9+pwZhKtfJRNdXfFZRgGcuNIoxe2gC740N1ffWw7yWW0taqVEtbMG?=
 =?us-ascii?Q?MDtu/bKDGUCsZ4j3SUmyR/vYkkIC/txzvLe16ttvuyojsS909RZSp6s/XQM3?=
 =?us-ascii?Q?ypVOU1qQy6ovhhPBUlMWqJ+f6BZtdfpdJ0HviE4Z1mg+jQTtiZghFIIp54eu?=
 =?us-ascii?Q?JRUOShBhhACo+ff2qHLahMS3kEdUeaSDQNnNI+yt3slkXrT3pBssEI/hAHnA?=
 =?us-ascii?Q?glphB1M0Lmod2dQ5qhGxBNFKAzG1ohLfCdPFpo1k2nMtvFbxu9QZI7MSuwoO?=
 =?us-ascii?Q?RbF7naoykFJeR9mfqb2i+QkS44BjKcLXDnmR4HHiUxuZHfVNllLdVE8tb+kz?=
 =?us-ascii?Q?8/bvJ8EZsd/G7ho5p5wA/s+nlWDJmxhMxNsDWeNMULqD73GSMeH3zXJLfuwE?=
 =?us-ascii?Q?8sgBY2q+5oIOZuLn+2hEWpxNCeuT3BVsi+PNneVUQvKQcZ7WaWtcKaljJc4O?=
 =?us-ascii?Q?d8NqKaBZdS8lsEyWn466N/wlaT1hAwqpyMSbyhW4/qdVRHJMu+/8N/+d2cdp?=
 =?us-ascii?Q?96uijn8EALF5cpYJN1wDRqzJoKBkjOwNY/NQDPgJje+OYBLkn3/2tNGmaaUm?=
 =?us-ascii?Q?OrCVNT6uAyvwm6v43hFE7w2JbnWGgZqUM9BH46yyWzhXaqu+5E156867wQTr?=
 =?us-ascii?Q?X6SRQyoh2VXBGEiNdxVFusj8iTuBEErknY/7p5Lj5pl22Xmm/fXbXfOI0BUS?=
 =?us-ascii?Q?03D/Bu6HShqYs/2F/1LtXCCgsIYdZ3I2fx9qTXUXGSkyq5tzJyar6ppYRlfl?=
 =?us-ascii?Q?PnUwRzsUxkSmTzYacggkzEsi6YD8h9HulzsE4rW/LFxTWRexLnCBl4hw8BIb?=
 =?us-ascii?Q?0gP9FqdeWk5P5erYiC1eHwGRXLrWCYUxB3Iyb4vk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5f361a-9da5-470a-a9c8-08dbf825befd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 19:42:00.6374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LD5+asjf68oUQDfUQkZAeOYNjJuMsJlx3k4KOY7b7JN/OxuXkpBWtAgEpXSmIZqz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7909

On Fri, Dec 08, 2023 at 05:07:22PM +0000, Jim Harris wrote:
> On Thu, Dec 07, 2023 at 07:48:10PM -0400, Jason Gunthorpe wrote:
> > On Thu, Dec 07, 2023 at 04:21:48PM -0700, Alex Williamson wrote:
> > > On Thu, 7 Dec 2023 22:38:23 +0000
> > > Jim Harris <jim.harris@samsung.com> wrote:
> > > 
> > > device_lock() has been a recurring problem.  We don't have a lot of
> > > leeway in how we support the driver remove callback, the device needs
> > > to be released.  We can't return -EBUSY and I don't think we can drop
> > > the mutex while we're waiting on userspace.
> > 
> > The mechanism of waiting in remove for userspace is inherently flawed,
> > it can never work fully correctly. :( I've hit this many times.
> > 
> > Upon remove VFIO should immediately remove itself and leave behind a
> > non-functional file descriptor. Userspace should catch up eventually
> > and see it is toast.
> > 
> > The kernel locking model just cannot support userspace delaying this
> > process.
> > 
> > Jason
> 
> Maybe for now we just whack this specific mole with a separate mutex
> for synchronizing access to sriov->num_VFs in the sysfs paths?
> Something like this (tested on my system):

TBH, I don't have the time right now to unpack this locking
mystery. Maybe Leon remembers?

device_lock() gets everywhere and does a lot of different stuff, so I
would be surprised if it was so easy..

Jason

