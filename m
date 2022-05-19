Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C714552E02A
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 00:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245603AbiESW6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 18:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiESW6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 18:58:50 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2042.outbound.protection.outlook.com [40.107.95.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276DB8CB2B;
        Thu, 19 May 2022 15:58:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hydXe9YB03qQ6BNyAErdceE165puc/Bf+FTl19jXJRmML1JYsOHlIPz0ayBx9DFTC6nhjhjTjmyLhYw+tZB4cQFUo/wjLp2zLZ5bh19ctClblUnqn1axMsTi8F2r1xwBiLxRZn+CfMfUUhvT2DephF8C52raoet1OZ53QoLdZthlSq3gDVsNEWGwnhJ6xvHlLjlaXJpNi3kYwW85utVDFF0ii9N1NFUjCDZy1DDe1f1t52NfdIjWZSazdtnH3t/JLl0SnOnWiLJSMz1e7ozjCh7gN9N8mMvDFpAC+yqe+ua2E4j0tzUAk5uqGJVOrzkDd4Wj4GLV5ogyVZQUoBBKyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6GLug5LJDMfSk9rl+yhehi0twhaH5O+5WCfmfaCQZQ=;
 b=GhzxmIqagTlFV5e3OXbIAIpZMX4ewaFe8oHh90NCSqbVGv/laoCe+7TvatIhh9cDTplolJWmfU3h5Zqs+nATAwRxX9s0ctkAu3G+ZJvqNuEKbEluEkLb9pOdtl1v6eXW1XJo/EpcS1JrFHCy/+P5OwS88/uk8Q5DqY6f8JyweBKRF52cweLgQYs+F/jZc/29dY5SQ8Zm+YqNgtvoJkTvkTNsXboBE83E84naPltPgKLCUy7moPz9ctArwknFq7JwLa8j0uvy7Cgtgl9UcJxPIvHPretA+lStGq5G6xSH0DuojmKee1aNDQcb47Sd4m2y8WtgNuhk6G9jjJxY5Dpa8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6GLug5LJDMfSk9rl+yhehi0twhaH5O+5WCfmfaCQZQ=;
 b=r1LO93LQH6ZMG7ns01nzrP6uqFShV/uRdPrxOxl+G1csgBjLzf+RDjNPCtKagXvj8ju11zRJ6xZLr9+XDnv8eIEfUyyAU7xfsPxA1iPd1bNmaDDtXN2TM+dKrSRIiHEGn/9wmNMfsfANixjxC55ZrmFQyM6j7pmoVRcC0Yfirgy0h5wJ+UhFQawTYijACH/fvrTbs7lprejkBHglVlQFryB28FDJ0aDb6mNkvuramBAcCWk4UhjaV57QSlteWhzsewpEaL8kpMRWBwILPdcE6PfoDUHDrm6C5UiWfPsaf8qkLrqJo06LIALGjr2s+nMP5qofcWByMUFSWPr+faJ8NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6256.namprd12.prod.outlook.com (2603:10b6:8:a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Thu, 19 May 2022 22:58:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 22:58:47 +0000
Date:   Thu, 19 May 2022 19:58:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     joro@8bytes.org, will@kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, borntraeger@linux.ibm.com,
        schnelle@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        farman@linux.ibm.com, iommu@lists.linux-foundation.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/s390: tolerate repeat attach_dev calls
Message-ID: <20220519225846.GD1343366@nvidia.com>
References: <20220519182929.581898-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519182929.581898-1-mjrosato@linux.ibm.com>
X-ClientProxiedBy: MN2PR12CA0006.namprd12.prod.outlook.com
 (2603:10b6:208:a8::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3a9a0d4-29b9-49a1-e91b-08da39eb21ed
X-MS-TrafficTypeDiagnostic: DM4PR12MB6256:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB62564475A5217D2D8B036728C2D09@DM4PR12MB6256.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/pZC68Bq5fz9r18FpSquvYGDzWfGqWOsU/Fpep2klnB6t2aPVbl7TIZ89Ge+wE8oExolhGWTFqJQE+olOmmCMMJfbazsYOmzSG5yryIhELT+p6mV84WZeRJioubypr1QNB3QptJSZtocXuwk+KdBRHdniXB21Jgw8uAhJyDbvoyV9LL3ce5pJMsvzQFUo1PzxiUSyR5u0YU6mcfTEoO/NBpR0CWlxEi9uTZbspGEdBDEKg6S4E6TDn0X4z630TgamqPyiDGK5EnKoqagtJ60Kxa37Mh/ppmc8D9d59KOfEx7BrpMhQynWMxpdfCFTHiIB/fDovuG/SJk7MoYv0LVRsQrRSyAx2DnBkMsgpMAW+r8HGX9cw8263/DRIVbPMELFjXbrjt1SpFbJazmiV6BTYhw3O5Uu8olFEAm59XkkDzygDa7py9HN4zIShXPbdU7Z12NXwIWBF6w8QxJ10i3P+d/5UAx4UeybhukJDn5PtnhPuoiVaCUFQTCXCCMdQ2vERSt62lUBODfpSq7DT7ne/IqpFTAC/uerJIONTNIP7Czq/UWetTKHwzQqhCaJ3C8SVqZ563Nqze4vFf1V1sewaLXoq4dZZfz+TKbyISi6M3dhawnsJkf9Vz2vEnrh8ajSs43ifx1bTvuDFh+eB4eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(2906002)(6512007)(8936002)(316002)(86362001)(4744005)(1076003)(7416002)(2616005)(36756003)(26005)(83380400001)(6506007)(508600001)(4326008)(66556008)(66476007)(5660300002)(6916009)(33656002)(186003)(66946007)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cdjsviSfnRnb8f+4TzeuwwON2RqbHQP65bIr3oRhGmbQwWtS7hI9W9NYquUm?=
 =?us-ascii?Q?DpGaSJCVbcPYIemBR5DvKNtExbYkHKft8JXo8I0dznJaAdeZHU8/BB99CHZ1?=
 =?us-ascii?Q?hJ2CYrq0XQS15FZ5QcpsY1eLfpJ9rnsgf3Nc5kSIvYdxWSyg6SOefcofFvcw?=
 =?us-ascii?Q?7LmG8g/lyxADdxLOMqJXzz0YwazgL5OHYyYqtUj0RlVMcZpEPV5w8fcs3lDm?=
 =?us-ascii?Q?9Lolqi7ue5tJkrC8tU3kYkgZGNDFx5ZBXR9NoKRKYtnMHIKUzDGNTFsA5uts?=
 =?us-ascii?Q?XoUMHGxnQkdAXyR0vzGvWUggvpmuFpDEvUTt+YhzOJdZAzTJ48IY73GKswvf?=
 =?us-ascii?Q?ECnEAKG+EhogElIAZjlH3yQwc3ApUKzDKEPdYXxtFvx3OfQJv26xDi/vVLNm?=
 =?us-ascii?Q?t0RK+3oRUi/kc7jWZ9PBzYgyUIZJOiz9wvVJbUQ5MY13mFx4QHCVDb8FnAes?=
 =?us-ascii?Q?mhZTXDQ3vu4U8bLreK/YbSg3Gef9bg1hWJKAeiSXQZ/Cz1D/eEU9g3h51iSa?=
 =?us-ascii?Q?t1A3vxp6b7cgK+X1q1aaP4kK87572Q5sVpO/4HfAkibGRdOljuJePx6dwMXT?=
 =?us-ascii?Q?qyWc4zWW1Jv8ZrL6wdCQWMSYyURQcFie2awJxg84oIjaoM1gz5b9SyXqvQjN?=
 =?us-ascii?Q?m1Xck17Xtt21cu/a6E/VjMl3KQGXP1KiJDs8dNlh2vixO9mHU0i0VZy+oTNr?=
 =?us-ascii?Q?HUiWahOHm6vxtNhdsAH3SnmCbq63UXRapoHVGQqKzVRqYVw0GWyQjbl3kMer?=
 =?us-ascii?Q?ZRK3TslRAFoZhkFbIE9QOESUCaLHQa0AkVFJGW3TI62QSXGHhPgyKvoJqWEY?=
 =?us-ascii?Q?x7LCZlh+L2Ra00xI902VxxfwA1yoWI2BeJOozG/Nkj+sVoYQwRpXdDO+nSw6?=
 =?us-ascii?Q?eTmneRJxUyHgtJNPRQwqB/Ob8pBE4O1GOXtW12T3WFB1xUdGov6DdH612D11?=
 =?us-ascii?Q?0Gvy5Sgo1VHcHM1ScN/pJtzuPnmc5L2E922aXBVv5ChD2oBNwv/5lTkuIWZm?=
 =?us-ascii?Q?hHolAN56WuyoUFckU8nwLIpTYwSNne/jwR29hn8VJGgyi5sjQXF93nF5Ovj/?=
 =?us-ascii?Q?mW4EcRdPjDBzFRmlJlrvyJQgokrCbbbKeZXYkSM+s4pMShJzRdVBFQI7SkSV?=
 =?us-ascii?Q?MMc73ESNytmqDqEZol0FM88nqrAYRXcKPQ0RgMlb/2xljdsdHXbJWVLVqq/m?=
 =?us-ascii?Q?tflkNFg/9Jq3mmNQntqqL8wabeAZHQyOReMXFxc5Icm8djXa21609kA0IWWf?=
 =?us-ascii?Q?896pHmtwFKkrD3QdsAbELLOHe6sqZbuVB0givW0Ojd8uBF83Mou8gENizwOV?=
 =?us-ascii?Q?28/u+qFL/M/LQEOd2tr54P602rs+Mrnq9djodWX7VxVc5vy2w0fWMYKyme0h?=
 =?us-ascii?Q?lQG0i1zf5dh4dRWbBM/bnQph3rySmBwcGqLAZtQ9A/EdFxAh0io+uC656PKL?=
 =?us-ascii?Q?4g34wOD2CjSTzTi0RDyyxzIgbY/Fju1Lfq1mX33lQ10GeVY8J6MDDVm2ryz4?=
 =?us-ascii?Q?mM2HMU/z+WrhaS6HbQAqPkQ2shZoN8drRrOc3Mc3i9ApSOS56oxoaNu+pzub?=
 =?us-ascii?Q?n8JnRIx4P8wonScbU5tCiMm4hBlqrCXRyR1PntMl6GR+lz/j9rxw8murXpFa?=
 =?us-ascii?Q?+NUUjdxeXlsxBalduzLQpZMVLTif8QGPzSAjkCJv8zhblZCdJiOxEpXKjraY?=
 =?us-ascii?Q?Nwmqy69S5loiHaHOzT8rwaHprdp7w1xPhscIsNn0AWSfTmoHz+7bmly1kJtu?=
 =?us-ascii?Q?OzrHu9cNbg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a9a0d4-29b9-49a1-e91b-08da39eb21ed
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 22:58:47.6934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZYBv5ol9bxm4y8DWVi+wbueVhFt1QF7IubX+gb7MdNHNrm1Q0qXNxaX1fUUUiSW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6256
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 02:29:29PM -0400, Matthew Rosato wrote:
> Since commit 0286300e6045 ("iommu: iommu_group_claim_dma_owner() must
> always assign a domain") s390-iommu will get called to allocate multiple
> unmanaged iommu domains for a vfio-pci device -- however the current
> s390-iommu logic tolerates only one.  Recognize that multiple domains can
> be allocated and handle switching between DMA or different iommu domain
> tables during attach_dev.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/iommu/s390-iommu.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

Makes senese, thanks

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
