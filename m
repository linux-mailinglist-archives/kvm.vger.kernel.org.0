Return-Path: <kvm+bounces-5857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D860F827BF5
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 01:25:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5685EB22A5A
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 00:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158CA3C38;
	Tue,  9 Jan 2024 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d6w61vLx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AA433CA;
	Tue,  9 Jan 2024 00:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCXeNjKX9ZE3Zat/TSpOYeYl8yV1pseWfbEm5/v5NkeWVhtUybX6a5kc6KAVqXdzDuzFDiLJk51xteFr4/d/CZYtRPOJ4Qw0Efta7x0caEaIZ35QvcmaC8INoSwe9BAewEFQYPr0x+qjjC9AMJuIdivS3GHjQ+/eX2CRGGsk9ik6Cq+LmNnrUEHW2EpBjpRXxL+00edzky15BQypR4Pq7XsoI/IdyqFQDNZQtD8NDFSeGPjdJBVLP5jDWW0IIXUHlLtnujiHtQwh8mvcDO9JTxeY0SI5HvIvLKLewBR5URZdZf9ZDQJe7wJZ0BR+76NK/mHO3hN7Pm12X2ljD/+XTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czsj+FVe+tpuutpvbeGzNMeAwdVovb4uYOVBw2npVVU=;
 b=LH+h1olUcN8R9QZrgNWOwU6XlpdJ8FGK290s4bonVA0bThL5Ipysp/ixJeQUv3dtNi/YpJb+MxvAAmYXPScPlHQamjEb0bmW6vGV/eawZfVx+zucE+WTqL6JD6uQEGSjQrbxiTezBzRAK0aeTEFqy/idZATbNko/8Q2bX+VO+kBWzaLwlrfGrCpQuPAAZwNf+AVxf8RTuFyLUCos6SSXrIl86Y0or4TQTyXepB+I7UYlOgo8/FqPVecxxhKVB5DImKXjB8BXadlzGXZV6Vw6esDvumbKFalIbQfpt1meyqWFVNGX/XEzdas6z7PrRZmNJuuHIHbhaRzRztuRkaH1Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czsj+FVe+tpuutpvbeGzNMeAwdVovb4uYOVBw2npVVU=;
 b=d6w61vLx4fvXi4jYgILyfrQd0Vq9Qw4m8NpJRuTREg2caHNPMf1WyQZm7eobsc9IzUGetw6ZSK9RAcf4JX8NJkR8/DRsKjsNM/SKHQqLlIKFajuWu3xgpbCRM0rF75cFEuxpZqtaDraj32uApofKBBzpMlZMJJ2kJvbQ9nSApWQ1RoO3gtaujbZTFZI+3A0eeLpBF9uHQVjxCIL/0+b1uCb7mLd+JCOCsjEbrrraSdRHpJH7y7PIMHtjZSb7bvxxccMh672hBPbCA35Fvx5AIrPwzV+8zB3/rCVE71AT801C+pxKogQTV+R8mrPFYgre2bJFP2dbjkIBSficppdzeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB7991.namprd12.prod.outlook.com (2603:10b6:a03:4d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.21; Tue, 9 Jan
 2024 00:24:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7159.020; Tue, 9 Jan 2024
 00:24:38 +0000
Date: Mon, 8 Jan 2024 20:24:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Peter Xu <peterx@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Aaron Lewis <aaronlewis@google.com>
Subject: Re: [ANNOUNCE / RFC] PUCK Future Topics
Message-ID: <20240109002437.GB439767@nvidia.com>
References: <20231214001753.779022-1-seanjc@google.com>
 <ZXs3OASFnic62LL6@linux.dev>
 <ZXyzZ8GOtWVhXety@google.com>
 <ZX/bOwVVsnO5OEhI@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZX/bOwVVsnO5OEhI@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: MN2PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:208:fc::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: af758aff-8744-41f6-10d9-08dc10a95d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9CSvj9p/JG4xipMFBhCnh2oCi0PloMN7irFWQKB2H+amFgeDP0ZdPfwpjzpgb/cWMfxMxWsX2BwRSvgjHmsvZnEnzyRXuHmdbE0f5IipuzTn0nANfyYb/ZherOm2td4m5tsFzXDZDYoAGPSV1nxtilXjIBYu+mnkZl5K0HqvM5KDaaiyuZQvjtPqnUUu7kGTYGF1IiZz3ZEghD9hkdjtNHytjn2fztj99vFtk2djZR+aAWB1xWjj465CFdakICUZSrxj0bGanwAKtYiruGDdUyzpbionayY3kiJi+mf/lLZm/5S3IwflEXs4cy9lAzygJ/N34voEsXGw2Ztww+NKomLH9MOq3WO7Og+pEYrgU0FjcXg7O8r1B3ekxru6+pkSOWjd4ttJbemIcY418BzMqAg6fq7ODjiA2Ra57x4MuJKVTdCZQvA1EUWDd902O7dgmkGO0Zp8xtyOdDN0dD4AeAcRum66nO/2zioAJg+UXSa2aaLLZtbc4NvD1aQcTXDmOiHEj5sNPTc8lQNp1j0r0xgMhsgvUrogoynxOio1lfPJO0TgMWqoJ+efXSUrzXCIOKQHUezEeY606Xg+9mhE0ctUlTSgh4gAWdQ4Pt7yoFoOus2abetN0Z361z29T38KReE0AFCvqy0O71HgPNN0tcjGuPL2JQcH6cMRl1cPjPWgrFVU0o8PEyf0Rv+d104v
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(366004)(376002)(396003)(230922051799003)(230273577357003)(230173577357003)(1800799012)(186009)(451199024)(64100799003)(7416002)(2906002)(6486002)(2616005)(1076003)(26005)(66556008)(66476007)(66946007)(41300700001)(33656002)(86362001)(36756003)(5660300002)(4326008)(54906003)(6506007)(83380400001)(6512007)(478600001)(966005)(6916009)(316002)(8936002)(38100700002)(8676002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xuTPWZEAEcgUOcnfzqQbNtNoN1s2F9Eg9hMDcHfzHJ9DWJLfPO/UEk0F7gBQ?=
 =?us-ascii?Q?8cx8FdlJbrWABZcUYEkWX5nJBJgwn/sQ1S2Bza8+ps5Yc9I5khXKc0LwTVk3?=
 =?us-ascii?Q?OD6Bqb+3VvktEDGs2m6dr35r2VKNqEDMjt+nnRNbdYV2w3ort65QiQGw4x/b?=
 =?us-ascii?Q?u9M+yqtpK/RAPHslfmdgn+m8QlqMOHrNoP3q1FfLJilf+mwVk8RzBsL4nLvr?=
 =?us-ascii?Q?tfTulUH89U1eRXe6/LllZYpjGMr3mSBsfSZlQWKC6GVowW70On79O4JkxXxI?=
 =?us-ascii?Q?BTycQSUYpMBiLY6m8mPr/mdDKyFYlmUk7zbqjUzgvG7pRpKfmkiNYhA1AoIU?=
 =?us-ascii?Q?A+uQ802gJxTHeYTnF5tGry+wTzTjrRjRUm0gmcx4zYFP/JKAqcQeFHxgZLxz?=
 =?us-ascii?Q?BfFZaRoOeu7V6ndd0WVvE10HDYqFsJDMhQVzjNJBjgirhVgfT9w4MNVlb42g?=
 =?us-ascii?Q?AeKjXByTU0jQv/QXqfF54PlfsCkuK8Rpncpr9Sc+AAUHhIX52IQyKVMN+EiY?=
 =?us-ascii?Q?OqqmbYMI9nc3VyoEx2Jj9v8aJcsUCcaGXM0xfxn56dXVt72nqA10xykrFlUL?=
 =?us-ascii?Q?e6IU00M/aNZ3tvNEsm1JJi337PMzCVgExmQTIdY0nc9L2UZiqcoY0sOFUwhH?=
 =?us-ascii?Q?imsr55LCRTRq+Hwk3GQf9kjsfvCD246N6XH5C6j6tA60t5wYcNo6+6mRpkeL?=
 =?us-ascii?Q?bk5Ay6WmFbsDACgBWhA5HfzGEexMdi9VMYqvZnpea5znEacWG0r7tsRE+X3b?=
 =?us-ascii?Q?utqFD3yg9BJ9T5XXiRAaUlWAIT87pQrTNNymXETfsIs0mGJBS08qH5oWpndp?=
 =?us-ascii?Q?fzGEJuBdB7SRNI5Nh39wiG1ZGJ9U8AA1L+uE/pzgiraX9yJW99Kj7JD3QMNm?=
 =?us-ascii?Q?2Hvr2U0mNt5XFEsRn6QKjD64y4gcsXmCDXupaiVpzvTg9qBmlIGPNuIvymqi?=
 =?us-ascii?Q?6PvAnkGKzNiaaOFCVWnm/+6BXOZuPAeSIIgr6D48bNDFs3R/GFPBHa7o1K4f?=
 =?us-ascii?Q?hezXYSRJoUKuWeAVWtJgLTepckT4tjYNd6vjrWYUrGPPsEWOEhyGCi5WtNxf?=
 =?us-ascii?Q?wq60QrKZjV4/0Hthm+5tDNfnd6Bpw5kn7XsJ2yS2sbTg8kq7i7FE2Y6dMiQi?=
 =?us-ascii?Q?KrTWoJh2p4EzOacGxW2USC0YGhaJCHmy8ixhyTtY/qz1sEa+IySlUory8cnM?=
 =?us-ascii?Q?g6HA6Ndfepbb2Aft3k2ML0kxRfslg90E2+W/qZurwl0o0wuq1H7XbN7chFCL?=
 =?us-ascii?Q?PPpR7hPrRKGf4SVN4AzsS7pOQkuKUXlno9YVIA/ghmd7lvGo0MT6RWqakTpK?=
 =?us-ascii?Q?x0CtWBDsEQBDpCKSmZBiBdLHCvGTIbO4oVT7Ltb5joLE+e46ikBJsmM2Pxob?=
 =?us-ascii?Q?IJ7yBS6WtMmL2ELqWdXVmvsxu+I3tFaWkpsjw30+EQ6CLZLKQNWERYYWVmBZ?=
 =?us-ascii?Q?mmcNi7GdL4WRHsaUFqvZKkuUIPGl+ihjJWmG8FFvsnYlw9gXSjsMf5C1zjaS?=
 =?us-ascii?Q?8lw7n9mGbTvYqYbqfEDVIXKrf7JDqbFf/j3K9KxcTuLompkqKW4t0QJbiXJb?=
 =?us-ascii?Q?eIVKDd48zhxHpL/WJMqp34JzUNfntGcN0g/F4c+L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af758aff-8744-41f6-10d9-08dc10a95d4e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2024 00:24:38.1743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRXseB0Qd0al9VwF4Sc03YCWTBYk8heeFHNBX1tu1BmKh0JxtIf7RunACUP69d6a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7991

On Mon, Dec 18, 2023 at 01:40:11PM +0800, Yan Zhao wrote:
> +Jason,
> On Fri, Dec 15, 2023 at 12:13:27PM -0800, Sean Christopherson wrote:
> > On Thu, Dec 14, 2023, Oliver Upton wrote:
> > > On Wed, Dec 13, 2023 at 04:17:53PM -0800, Sean Christopherson wrote:
> > > > Hi all!  There are a handful of PUCK topics that I want to get scheduled, and
> > > > would like your help/input in confirming attendance to ensure we reach critical
> > > > mass.
> > > > 
> > > > If you are on the Cc, please confirm that you are willing and able to attend
> > > > PUCK on the proposed/tentative date for any topics tagged with your name.  Or
> > > > if you simply don't want to attend, I suppose that's a valid answer too. :-)
> > > > 
> > > > If you are not on the Cc but want to ensure that you can be present for a given
> > > > topic, please speak up asap if you have a conflict.  I will do my best to
> > > > accomodate everyone's schedules, and the more warning I get the easier that will
> > > > be.
> > > > 
> > > > Note, the proposed schedule is largely arbitrary, I am not wedded to any
> > > > particular order.  The only known conflict at this time is the guest_memfd()
> > > > post-copy discussion can't land on Jan 10th.
> > > > 
> > > > Thanks!
> > > > 
> > > > 
> > > > 2024.01.03 - Post-copy for guest_memfd()
> > > >     Needs: David M, Paolo, Peter Xu, James, Oliver, Aaron
> > > > 
> > > > 2024.01.10 - Unified uAPI for protected VMs
> > > >     Needs: Paolo, Isaku, Mike R
> > > > 
> > > > 2024.01.17 - Memtypes for non-coherent MDA
> > > >     Needs: Paolo, Yan, Oliver, Marc, more ARM folks?
> > > 
> > > Can we move this one? I'm traveling 01.08-01.16 and really don't want
> > > to miss this due to jetlag or travel delays.
> > 
> > Ya, can do.  I'll pencil it in for 01.24.
> > 
> > Yan (and others) would 01.31 work for the "TDP MMU for IOMMU" discussion?  Or if
> > you think you'll be ready earlier, 01.17 is also available (at least for now).
> Either 01.17 or 01.31 is working for me.
> But looks earlier is better :)
> 
> hi Jason,
> Would you like to join the session to discuss "TDP MMU for IOMMU", which is on
> 01.17 or 01.31?
> (6am PDT
>  Video: https://meet.google.com/vdb-aeqo-knk
>  Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656
> )

Yes, I can make the 17 it looks like

Thanks,
Jason

