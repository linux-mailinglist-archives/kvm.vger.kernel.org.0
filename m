Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC5A3E5986
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 13:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbhHJL5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 07:57:51 -0400
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:20128
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233167AbhHJL5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 07:57:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bK31D1x83kuGJRUOaRmRRDzidp5Clw7D51As4m6ewEqM9wKzCpIPWdh6qNN3azsC0vLRjtA95XtPTiCJ+SxvsxCcRgfBeU0LDKRmI93GmTqqiZTZ1Qo/Ko0hNlVV4Bh7PraHvqgBBFMoE0lkyAwAhkcZGwl2FYWssh3sSF9Yni9h8kc8USLOLDprUQLLIDrwW+kQXKdbfJBqFHxUjJXITjnJ/ZszzQ/VGBtZvj5pJid8Yg25fbdUwuYTG6gxplcPwbDZQLZuZqL5Vp3lMMIm2qBWLITQp4sCLE8ucpIsJLNcxbZokAMNHBsg/Aeb50c+kv2Ft+/fmqlRBjONrnlueA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIBr8sNNPuc6x4VSR4n6mQlt+aDZjPE2Vg3qYoxbc+o=;
 b=oUlaHmXeyzxGkTSx5w2Sla4Gn1+K5bwzdW5t6Wip6nQu6/M0d08tCiQWWUEtOFXkR29lP9v0/JV8sUvPXh5A9C8Iujzrp3mxgQA0jnOkhJ0SCVl03MvO8lvIT9U4/O9dENyTLA5Clv1c4qMZeu2exjThTX+A1IcsjdsgDgEWl1cop5nrrjxxNSHQjnKCwrT8f8ah5z997vIdQkKyO/0raK+dxXrfWcDJlA0dMsBg3G0VmAtX37FdgV3G0AIpnPzUfc9PLHEhKBXcBZ0AP3XihTa6zpSCfSUSY+HQw+B3L/OkczN5qoH7J9y/IMPmYzbA5mJvSD4OZxwBWXt8IlP+1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIBr8sNNPuc6x4VSR4n6mQlt+aDZjPE2Vg3qYoxbc+o=;
 b=XjdeV+Ev+Ylk8iTFdEMM7JwcUD3HzDxlLs5J7JJceX4skc7wwXobURR2QkElAK3SKjo052jIiY4c3XM43n2yipMt11wIpa53CD2ZWpXdX3uV2EGGfwy1Bot8d2tbpmGjwVqZkyVmadNcoMxXfjZg/P3FDK5uaGe05yjllzLXxR/bw67lO2zRtxiYFAeXl/IGiZeJFzH7oPIT+K9Ic5m95ts7QqcGe87yJp+Evflnpwl/lyYzqcWni6lU7ado7+0uxOr6BPGweUQmT/Da+Y7x/yz1+bndUpoS0R7IDXAPno1DgCsc8XfB3UaKZijZ61KZ7XueqBKSo+7a4+Xi0q8K5w==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Tue, 10 Aug
 2021 11:57:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:57:25 +0000
Date:   Tue, 10 Aug 2021 08:57:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <20210810115722.GA5158@nvidia.com>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
 <20210806010418.GF1672295@nvidia.com>
 <20210806141745.1d8c3e0a.alex.williamson@redhat.com>
 <YRI9+7CCSq++pYfM@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRI9+7CCSq++pYfM@infradead.org>
X-ClientProxiedBy: YTOPR0101CA0028.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::41) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (24.114.97.43) by YTOPR0101CA0028.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20 via Frontend Transport; Tue, 10 Aug 2021 11:57:25 +0000
Received: from jgg by jggl with local (Exim 4.94)       (envelope-from <jgg@nvidia.com>)        id 1mDQNm-0001bF-1r; Tue, 10 Aug 2021 08:57:22 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cc799a5-cf6f-45c0-2126-08d95bf60513
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:
X-Microsoft-Antispam-PRVS: <BL1PR12MB522321EE4D04D96BE8549BBBC2F79@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/MKz1voxHwV9SKUa8fif9jSlCnnjuVkFm+Vv2td+pw8LbSQEFcVEphUzBwFyClYKUswt6DBHhUDGoUWXJmjkxNdMwhCXKWGBNjDWPNXCfflvERKipt8b0Q3CQ49bSCJbL9GpXXXmPahU2NYDVsr/mmXaC+c+ySeRMdNz46cn9e+dKlUF/X1IV/QH3SeAaSc8SR/ugEIKruhVJIH3QST0Nt5nX/KP93TmCY6m1cLWaw2AMyZ+ILZyRmlizAnDwzm8PMuZ7TRCYWAPYXQrEHOE53XsgGc2KZUCoOX8CxyiRqkwUZgkxKBCBC8fY+1q2yYwTNyRLyc9fOLH3I8SkYSh/Jb6sORxD/tlfJq8LvH01+JH8C/KJltBEHUZDP//DmP1sqLP1jnFMiewGfuMT5pODCUBCB2i6nOYbWRjFK9dcrH09OU9eM2pStpspWcbQs5LhDqO6Z0zE0blQmnojZ+XxVAVWkkHbpzC5ImvMuzK2f+++o6EaUHLHrMP2nZG1OQ0iukY3sMYr3wSx+bOlXrgdsbEOgq4vQ0Kz62AWb5JxG9knBJWY1PO4wtTE6JCVSzN+3S9+BkV5ZNSYFk/qyGCntFByoE9GZmAv8WJa264fXPg15R6Y2jgZQUp2ubZ22ctVQc8kCZ7upZegY5p3bUKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(33656002)(66946007)(2906002)(66556008)(426003)(83380400001)(86362001)(26005)(1076003)(36756003)(508600001)(5660300002)(6916009)(186003)(8936002)(316002)(8676002)(9786002)(9746002)(38100700002)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EyaoG7vl7Z4/DLSYcMc80VsaJKQb/ylyQhv5aQuHnoDl2jQJh7tCy0y3cZ9V?=
 =?us-ascii?Q?Y52WEyy8u7D+I0DugmyiE3XBreDQFN+yDfeQLjzQjJtzbiJwMjkRjyMMufSK?=
 =?us-ascii?Q?+2LqVcDFjvhhyFfHtALml91wYxprs4gP2YXHUvfeb8IruJbZjUMKSKnvQ0vO?=
 =?us-ascii?Q?gI4InRy/45lyxhrRExQJpBc9vUR5ZGHOLpV/iMY1BZniLvhcJzW+TYOrDcym?=
 =?us-ascii?Q?B6nkE2LcdpdzhCd5mtDfBsRhY7bnATGP07ChZiqV0swBNCELWJORbm7MIQgZ?=
 =?us-ascii?Q?pE3mCFylB+4Pf6Om86guz/a7Qe9/m+jHN8ACx3ZVda3UkuXH/7RpjVhB5OP+?=
 =?us-ascii?Q?3BMlNu8vGXxpsuDn7Caxbjd2bFBS5bjXajRWf0EXrCimIWpL6otYnwdFr7EH?=
 =?us-ascii?Q?8C5IcozyYAfBJA3s0L/F0z70yk3dvvT+2QJJ2RFJJXIPEQO0XzGgkmPG2Eq6?=
 =?us-ascii?Q?KQHSk3AwNkYjYOxc1ZhIxYXyGJA6jhDbHldLVbeiSW9caZKZyEX9M8j/wlbS?=
 =?us-ascii?Q?4A+IeiMBLql76p+A/mUQK3/PHpB1MsdMHHPVhen5AypaSeF2fcM3Zrmk0S6F?=
 =?us-ascii?Q?P+LkZ9RBTcIeOXl9uUCYq2UjDHloME1FQeAlQ278NxQByQXwU/E+qfUqWvbR?=
 =?us-ascii?Q?Q3fPuRYBL7OZFjEZDx9IXhDSaJySWCVJJA/cVgkzptN3lEenFpQ4JBZJty5Q?=
 =?us-ascii?Q?G+n53K84yO58YN1dBdVR+fzhCwn+Fi5XX/eibSScbWnkqXk56Pz2JEFijw2f?=
 =?us-ascii?Q?tq/kgh8y9L17g+WDO+aB3KsTHQOtEF5KVDwtnD9TXWEJPv3BfMnOtI2Nt/VR?=
 =?us-ascii?Q?QdFc9+6qom/XWReuqkm5rkz6bKoni7ElFPnRiIoIAJIUbdgxteoQITNrN5Pn?=
 =?us-ascii?Q?UHI5ZSfu4JF1NVCmHsJgu9uuhph40WktM3slPUKGrI4G3mVUIc43w64W3XHY?=
 =?us-ascii?Q?ZfetLaUS/NhXq66tcX1X+dCCGPOSRMowNsXswoAXGzRxCflVwtlpSIvhZNGk?=
 =?us-ascii?Q?nhwe4OBJOp0s3xVnkl+lpo+30f9kEuU1qN11n60xXbaq4bIs52gGScZ7ufT6?=
 =?us-ascii?Q?dHOHT2XekMNrPwzrbOwLo73rbg3OmhjBRMff5UOI8vomu/q1lgaKKuEig5Nq?=
 =?us-ascii?Q?3vjE8G9L2cw2Wo896B4NzfLxuKSBB11Ms27afUFMdwD7gKQx97G4ItIX0Txb?=
 =?us-ascii?Q?egdc8WKCs4J7s+SOzfGHji3tSIfam3rClYjQOYQrosnQlrzSJTUGeyX0Fnlr?=
 =?us-ascii?Q?x2PJIcbOZf583MFbZ7GVI0BkQZnSktaaPVkxAyvzFLq36sWVoA792SObgxY0?=
 =?us-ascii?Q?DuMo8NN0qsjWVkXzMLKRMBz0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc799a5-cf6f-45c0-2126-08d95bf60513
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:57:25.7755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BfQZkDj4tURDGdo0CmeuWiQcGTpaQe0QLQhQ34aYlvcDj7WuCS/ehQdRKu3eeIA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 09:51:07AM +0100, Christoph Hellwig wrote:
> On Fri, Aug 06, 2021 at 02:17:45PM -0600, Alex Williamson wrote:
> > > Now that this is simplified so much, I wonder if we can drop the
> > > memory_lock and just use the dev_set->lock?
> > > 
> > > That avoids the whole down_write_trylock thing and makes it much more
> > > understandable?
> > 
> > Hmm, that would make this case a lot easier, but using a mutex,
> > potentially shared across multiple devices, taken on every non-mmap
> > read/write doesn't really feel like a good trade-off when we're
> > currently using a per device rwsem to retain concurrency here.  Thanks,
> 
> Using a per-set percpu_rw_semaphore might be a good plan here.  Probably
> makes sense to do that incrementally after this change, though.

I'm not sure there is a real performance win to chase here? Doesn't
this only protect mmap against reset? The mmap isn't performance
sensitive, right?

If this really needs extra optimization adding a rwsem to the devset
and using that across the whole set would surely be sufficient.

Jason
