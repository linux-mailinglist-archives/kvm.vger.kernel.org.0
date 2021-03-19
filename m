Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794C6341EE7
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 14:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhCSN7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 09:59:15 -0400
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:18145
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229736AbhCSN6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 09:58:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8GHRekr1rRfPhHLTiGZgvUOL+jWwMjAknFFi+J73ezQZBcXsFieRXQZIK7HwcCPazez2wZ0HugyeRSmc9oKa+e3dcnVaLDcpWi398ROUIodTSV2JvcJBUT3pPfnviuHFZk465gexOzYvHD03zLwHUM9PL79ivWDAHgp4nnQ4BAT/RK+7vJYdn3ClRCR3qnJLZJl4IMr+x634qB22vOVUfbMnHHKZLlSN802vEowDfTSotjXQP17zWgAMrhFWzWUpMPJDN4vti4ymrtMAIAVgKwZlmYkbptPNF3+US0KaTxfVSEwiID9QHTfV0WwpodoxLD6va3JaSYCswPu1SAJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBjNTeYquaVpqm9NFcVgZ0XoVek93FB5XmW5fqIKvTY=;
 b=TQ27Er8CMmMEmIlR0iL9cjhhLCQiRkovnPyU4A4fL8NSrP9E4/f2DD3UihmlQx80aLF4sx3xWgl1ux0iURPnf2OOzKy97hd37qqhB4NKlgIJyszPPo1OATVwCaWbuy64xExoDIQjSbN/ttguwFZ81v0GdXIomlXNzToiCAhAiPykbjWA0i7XOElaGX7rz0cBxF6yMnyjJcVqT+++s137RRVP+EtO4tv1qzj/VHnaVSAAERmma6HRJ+QIFwe2RFcCIRyuoXdie4QQ62S6x0aOHWIBLJ+W3QD3+TKQI73rqBhV5eTEy7/uhfRhbcHZagbvNWE4DfPlZEqRck739X6y/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBjNTeYquaVpqm9NFcVgZ0XoVek93FB5XmW5fqIKvTY=;
 b=lNS2DxlOgCsnfJP8Y2lWYYEnAR2boNbcXtoVpE4gvWH3++ILv9L/BwF/WuqsqhtCjJ6tcsOSTps//vhTLR8va4tgnAkqaNUDVmkgM8xZAtemzkN4RZHsFwr8Qu4YKmw1FYy6AZujyOgqeSBZG+m3uQfb8Yp58iBDHjL9wOHKWGwpRNTj8z4ddOAcXmSlHlwSC2oZa+GChlucl6B2a81q51p67AJ5fWWWVW5O3PdKXY192QsWNkB7+UY70dPgfMozX9d4kVag4hWJ/IK2/wqmN5seiv4Oir0ykGhmknU9J3RBWuIwtBMxx7r5831z9q6A1fa2KkBk/hCmQB/xDcsFYQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 13:58:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 13:58:44 +0000
Date:   Fri, 19 Mar 2021 10:58:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
Message-ID: <20210319135843.GU2356281@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB1886F207C3A002CA2FBBB21E8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210316230744.GB3799225@nvidia.com>
 <MWHPR11MB1886F45D619CE701979D2A638C6A9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886F45D619CE701979D2A638C6A9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR01CA0023.prod.exchangelabs.com (2603:10b6:208:10c::36)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0023.prod.exchangelabs.com (2603:10b6:208:10c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 13:58:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lNFeF-00HDCa-2m; Fri, 19 Mar 2021 10:58:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c99b0949-6525-43df-72cf-08d8eadf1c09
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4235BFB859F39C71BDCBAE9AC2689@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HM1Pi9GfqKiQKSC+qQZjNc7Fb0ykWxD53phgxfNoWm+0iS88/RlXZhDmD2JLaY9cdkRqtRU/2IzMP6jEiya7x7zKvKojONojxA8CglnwOukrIYdlfoBDvCxns1h4yulvfo/QprPCbkuzk90GAWqXdhiBLJcZ+EoDfea0MjIt7HhUzDVwaBO8/9bZuJY5T80gHVgDJ+UlyrOnsGYwnTUUSL1r/j1vDE0zJJzTT0jyrrI+Ps5ax9ZLaAg7Bb9ktTNfFpHxipcg9ZRmbtfZ2Zt7b6FvYy47LojXTQR5DTBMwl03CXr5L546/poQFdvJBwaEkkpMQDvT4CcJylmt5WOj+evxsnjsvBY4o7k9h7QYg9qGEKrhedjtozoJ+tx5gO0Z4trJNc/GeA80twqeGRiJ7KGu/LHlq/wzywJXTIpSUD5jDvwnUsBDmnpLpykz7HY7dQ+AZrsfxLNhYSoIPsMrYx6q3yDosSUA04ye2HFPTYTEAoNS24xSa7oM9F9mu9DKupMwhjVNZT5bqwssqd1sVSra4BpYNTZ/jl8RYxsksdeF2QGoCgTUmUTMzsT2lb1onIM0prRjDDKVUe900/2Tu9Z37OrN/FEfU8VwMfmXk8RX3qZlHOOR8i1+NuM3nnVlJhrjzFmew4wYFgk30rhdWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(8676002)(1076003)(4326008)(36756003)(66946007)(66476007)(66556008)(33656002)(4744005)(2616005)(316002)(8936002)(426003)(9746002)(478600001)(9786002)(83380400001)(6916009)(86362001)(107886003)(5660300002)(2906002)(186003)(54906003)(38100700001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?L2m1+aXplx8kG9YMMG0CvHV72cYHP49nGIcaw4snfhQjV/FkK/n8Hx4P4I9F?=
 =?us-ascii?Q?3t5W0jIbkn/axFe/tNZuXFRqEnTcydhhVrg4mCsZu5fcroxzYi/owYT1wsQS?=
 =?us-ascii?Q?QAp/OLCmCoGj2oN2lWsL5P8J+nJXI40V4hhiZiYNpXBwxQJRLCj2j8cQFTYP?=
 =?us-ascii?Q?D+TnsxY700TvHzSCebsKgp7VsFFhRt697Isym/v+Cd1pt3hjaUrGAkJzI/q6?=
 =?us-ascii?Q?UOFiwKST1fAt2Q6yhNq5cPUojzdWLu6G8xtF6mYTT4beQ7/3vmlND25vCO7D?=
 =?us-ascii?Q?GJWhp8gS3kh1YZRL5WKq5I7sULQm/vciHU8IrVGA4nTDZcAe1DqcZ8z5n0+i?=
 =?us-ascii?Q?KQKwI7vJsAX8/p/0SC1fnBZjoOTiL+QNrdiLz6q52or0r8IROaQBSh2Vc3ES?=
 =?us-ascii?Q?VgcVsGUQ/odvojAyXd/MNjCOQbLi4uUURnxeDvO1m0DoM58+oG0BCLL2rFIv?=
 =?us-ascii?Q?fvZC57i3thb186bCjZr+3QFc/bHIRHawLffUkfAf3HLZfavhYF7sMUg5qnMc?=
 =?us-ascii?Q?BzifydMBnXwfX8bTQvjP+tm/KWbtjZYrnADrl+kIbzQUcegZGqOAlLCEPtCp?=
 =?us-ascii?Q?lY2p57rQLmfEAE2N+bWcbfCOJOyrYHjWKFgNSVePIBXn3Ax4Tc77HUiJecQb?=
 =?us-ascii?Q?3SmuA1M37qV+ZMylrJlrkuWjbNt0w/W6UG0ivVwUf8DmJns+I/EW5qdXfPvI?=
 =?us-ascii?Q?PdDXXvL5HWSwfhCWKCmK5Sq0Aei9pz5k6VfIUZUYdD28NvbY0/teZZJ/Rz88?=
 =?us-ascii?Q?y2kZqpwNKJ/KHC0gI958NmYeJl4wYb0k28fbInT/VwWcnn2Qe9mRlPaW5S+u?=
 =?us-ascii?Q?B8ln6P26CfouFBr3BzkK6xyT2obDhXHDMGsjZWDI3g23F8K8zO5wmbdefOWO?=
 =?us-ascii?Q?KcoSmEVhWf5YDXgKOIdGUk+P3t9hkh0+qnFBM74omkjtp67JkLURWlISLpoi?=
 =?us-ascii?Q?NT7CjUusw1s/te5U5c27M30KtxoQELcpKXnXc24H+Kc9rjPtuYJ3Q+ozSXxH?=
 =?us-ascii?Q?X60BAEmnOd51VoLiPgv57PEe1ShoqhIlsyfQTad4O9QT8yj4iK7nWql9s3Us?=
 =?us-ascii?Q?myTnRbKP3I23BBTm9OHh8Ts0vUGwvbTICw7bgf7oZL1o8YBye7mxT45aT4Gu?=
 =?us-ascii?Q?UWAUDDxgI1aY27UwVkue103Sx7Iv28KqRLsPq1rd8PMKZc5gpGFjj9vQxYTE?=
 =?us-ascii?Q?Hb7xKTDwe78gsu/44owdePga5ySgvQFgVD60rrcuYATQnmt4wS5cnI+FmKUf?=
 =?us-ascii?Q?GLEjJw1jyb62fKifkwUBACg18G+g8HOC8oqKPNdwyHhswuSYUJcsygdGprfW?=
 =?us-ascii?Q?KZKfsbSx+uA6b06hVrhmo/bH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99b0949-6525-43df-72cf-08d8eadf1c09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 13:58:44.4261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUhnbvUwT5CDbp1wglHSAeBpNJOpavqgUNxZgJuxP3hC0w7f94hlgqITox05fru6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021 at 12:47:16AM +0000, Tian, Kevin wrote:

> > /* Our reference on group is moved to the device */
> > 
> > The get is a move in this case
> > 
> > Later delete the function and this becomes perfectly clear
> 
> Looks above comment is not updated after vfio_group_create_device 
> is removed in patch03.

Oops, that hunk got lost during some rebase I think, I fixed it

Thanks,
Jason
