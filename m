Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78154B50F0
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353797AbiBNNDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:03:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349874AbiBNNDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:03:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9454D609;
        Mon, 14 Feb 2022 05:03:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwNbZIWdbdN3vtZuI1zJEWIJM/UtuJSmdhElUHw38/INdTpQhzO+GNR/gnFSzzW9iJ7lMomowvfTlU84Yz4wy+798CBANLp5+zxBs9rWrOwk0XXCMVAMOtwOf8vvE/rLzKdVcQEU8MuKkzIV+p1rSHcq75q5fkiFD1T62ilCkAOr7Yazekw77SGu77WTpmjh0eywVpo0kCiTHd42oyrfSxBB6f867huhPKe8U+IXT7ra3zzOjiRrF7BI8Z7KMdzZvm/preKSiAR5sTJjEBt3W/QDUIRrWeFkYZNi1TAf5H99Wfi/Mzx0rXT883w6OX8+3JFFi0DKVztYorCmqHJKdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s10pw3Q0IJYajsmJnBuOXdvlhULZIGQsbnb9tziWXNw=;
 b=GGQJB8KtUQ8f0RCxT6dDawlGd2fI27jWkFNluUTaHwmOLiUeTdlFwvjwQP1YlCyw+sAgfczQC6xR0S3tt40ymTyZ4aZR/evLB9lgX5VBGsoPOdcUT416A63lqG0PlIunR4tIBM8MPc23z+Rjc8feSyoykfVHvNXvjXvkJfYlgusNQpfVuKqVzE1BAIM1naBeB+Z2KGNsRpMB6WBcFBDQwJkeeeD+ewbWHPRMv2iLGcQpwtDsaXcDB1A9/wMDWeve9D+5VB9/OIj2b48+v944MOaD6+dplEczISo04ydLyJi/ZnLYWwV7DgeoiTFZFiakfVCYI0dyj8hrSUe2UNtv1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s10pw3Q0IJYajsmJnBuOXdvlhULZIGQsbnb9tziWXNw=;
 b=IBtJGLqgbKlmjEq9LIC9W0nrcZwjd9rm7KcFP77lx06ja9qvPZM73iNIQH3uQFZIlSFk8gax/46fZcFop2R1jtABxBIWc8TXu7zjrrCdI05hNpuwx8vawBxr8sKHQgrPV0aVtgXm9/YSXX+vWL2W0Z/oLIkenCTc/OTooMRodyYeW37GopirogJE2nj8IWoHccwVE5dipkctje2VLQGRtQVHKFGFfyDoW7owPX9RYkKfm2MVyYIOLAHPhbPR06bmANOUP7kHilBqGLSfr+XuGfqHSi9cfJqlsTAbTK0LbHJ2Yaehyzzx10jJrgX4bax7RYfaw4i5EwMPA0OKpkVbyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR1201MB0176.namprd12.prod.outlook.com (2603:10b6:301:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Mon, 14 Feb
 2022 13:03:14 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 13:03:14 +0000
Date:   Mon, 14 Feb 2022 09:03:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Message-ID: <20220214130313.GV4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <Ygo/eCRFnraY01WA@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygo/eCRFnraY01WA@8bytes.org>
X-ClientProxiedBy: BL0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:91::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b50d104-5963-4828-7220-08d9efba5c8d
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0176:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0176D2AF00154CA6A7C0A641C2339@MWHPR1201MB0176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhvP8dPL/Pk0UHHeP79p6Cca0eWEBi8ajZ+CjLpiacw0zar3eNlmJRVEkzlSiepr0/nmZ4oQyuVutpt6OqGLRuN1Z0pbSm371hUECxUaq8RWuFRt/4/RR90yVxOlsVv2Lvo/bqd/u1I5/SiCMWT4q1Bjj2lQ3IBj1KxpPOaJTPEmvL4vygR41S2kIArUO21eAwFkO3ptPFdfNx3M7jlg76oFaYbY+taqSl8hlXFsBFJ32c/4ZanwYkhWCrwLE2GJsN8+D0DfAh7RAU005XJjjJS4C1SMMEcq69wJkWsxfmNl5zLotywi8B2MlfTV8SC24FnEIe8cTlEgJRnWo7E42gpdMyz0DQKmDAGLuhbHHranpRAy0+GAc+oP63TEkChTgQFzNpFwHQ9mKeXgLury0/SQqaqXp+CGkhE8BdoLrdc+mMpkjN1DSIvevsbHQubKFy0girT0xjL1ZNTmYeMAjuMvM6TrnhyM/B81Kjq8GYG1CjoyWVxG/NznUh1nZjY7W8CH7hMrRbSgrD3X3yCA0cuenyUyvu1uDVGP30If0Ou1D+p94EhcVPAZjnOvxRdj6p30gAmkpFJU94JfcWwNIYG3QZHy/0RHQZ36u1rsdR8bGCNoiQngqyv/96n+845ZEheTpBCazLtuq/5cfqByFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(66946007)(316002)(38100700002)(2616005)(6486002)(66556008)(66476007)(4326008)(6916009)(33656002)(186003)(1076003)(26005)(7416002)(86362001)(6512007)(2906002)(54906003)(508600001)(83380400001)(5660300002)(8936002)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gjn2Fuanha/kowFyaDapXzkvWlR2Oh74FKgb4jdsVqrkiQ1/EqMalkZKArKX?=
 =?us-ascii?Q?1Ikxwc4cAPHq2O4tbbtG+66ih21pUobwOYf2i6p0VdK5uPPHlLVcH1D6T5Yb?=
 =?us-ascii?Q?XgnNwKKybnu5Ki6Y5NReY1H/z+6gOzsAAUeeYGzo9pA/kYw+hq6e7iUxQ/yo?=
 =?us-ascii?Q?TxlwZsx9UdtIC7p37ImWJigAU8SQnM8ca58Wcf/S2axHQxVyrEykcz6y2sWD?=
 =?us-ascii?Q?VvsFu5uTbJ0LjFS+auiiQZqlHdVj/apaMJBSTLaDRpACf/vohfawW/cYIihc?=
 =?us-ascii?Q?X75F7s/+v0WTE8b++e2GU9VcaNxHN4IAOfXzCbonTl7G8B4ckHCHaa3e755e?=
 =?us-ascii?Q?g78gec4UxvyWRrttnSpoFTdHcfgBY/+ZIUTEXjRcC6ZAym1UqocIbtQdWoU9?=
 =?us-ascii?Q?nqQy+rRdLIepSoMNq4gV5eophcfTQnw3m92o/91A2y5YwRsmR1difIkvtf3b?=
 =?us-ascii?Q?PGYWaF6YSyOcoUeBHMmsPooEoN98KVt6pAuR32pNbQHxyAjRZL3tc6X+LilF?=
 =?us-ascii?Q?A5kFIe76684SLuIxPjTan/lrsMfOJ6I/0z3EGcLGTrvj87NEr0r70/GlBaFd?=
 =?us-ascii?Q?ZZyu/dZQj9rZ2hqvpIPp56ep38iAXC/nzq8aKiYhxyRQWRR9ZvnQn0jKpuK3?=
 =?us-ascii?Q?izx1axuuxvECUPIbDy2mvqLTl1qnBC2M5VTGs5dCkAlqxuXpp2GA6CJ/OkDH?=
 =?us-ascii?Q?tVXealtWZs3B51c7cCbiwMVoFcVcXSE1TvJFPT6MkrYkdYg9Z1CB2NlqQ7VG?=
 =?us-ascii?Q?2weBVWfa9iIXy5Iy7lDZtxdoxL+qjSmQrNVNn+wBLaoE1eFZ0wsCykNNWTPD?=
 =?us-ascii?Q?a2LaGD0yYzEf1hGCoZoxsyVcdGyHbJSnMWZoZyrkw3N36MXfHG5O/iMjwvDh?=
 =?us-ascii?Q?Lqd8jRGWG4Y4KQMRw3gQZY/9RA0k/00d7OzV6P5GB0Ik+53pYzRP/4juPDJW?=
 =?us-ascii?Q?Q1k55aUGyhVmWyfcOB/UgzUBjNNgmeW9HLsAc+OwcHKisVnJPSzCxfmBpcop?=
 =?us-ascii?Q?IH9LQYii9GDte7CHSpQoKRzPCLShQPvA7Fo4HnaH5velh7Iw0sLTai3yfpSP?=
 =?us-ascii?Q?+O1Cv0oA7eSh4+3JFAKnMPDRx3CGWoiQqvx910H+r2ra8KTYpOdsBqQ5qfnb?=
 =?us-ascii?Q?mA9Ql/M/W5E43Ed/8Npm+sM8/jeSC9Sy/3nIu40mIrI0egbjw5EPc36+bFOI?=
 =?us-ascii?Q?FueMt936fVFrwzHdh0F1oD4zntzy0c6mvjjv2htD1QSfobyCTCc8cmgVqAMP?=
 =?us-ascii?Q?Mr6kDxezhcdBiSSL5A33F5LAgbskWSH2KYdzmev8LVi1qJgpFXFDph0sO76p?=
 =?us-ascii?Q?tQNfg16MHqCuFqU+SAjHQ53kmRkQXW8NbrR/GVGhN8lVfhex+cwPQMeBGGiY?=
 =?us-ascii?Q?ngkejyvnslESjbdw9XO/txph844MNK3Hx3xxCAGMzkwNtG/F45/skMCGgMyo?=
 =?us-ascii?Q?l9izFV5kTJqLVpUwWxukQECsuAvCr5tJWMyQe390tKJbZdKHBAVLGVN9Lwa/?=
 =?us-ascii?Q?iUB87ZmeG+l15bRi1ONK5b3IwRjWnn3RwmSLZx3n+8txaAm4kWqLZb/g4cqP?=
 =?us-ascii?Q?WMqPFD1AavpjL9i7ye0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b50d104-5963-4828-7220-08d9efba5c8d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 13:03:14.7708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76+iU8LkpLRhe6gkXH0Kx1LeSMLIgEuiXmbuyE3KOh58YGIPRtBU34YkFf1RX2rm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0176
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 12:39:36PM +0100, Joerg Roedel wrote:

> This extends iommu_attach_device() to behave as iommu_attach_group(),
> changing the domain for the whole group. 

Of course, the only action to take is to change the domain of a
group..

> Wouldn't it be better to scrap the iommu_attach_device() interface
> instead and only rely on iommu_attach_group()? This way it is clear
> that a call changes the whole group.

From an API design perspective drivers should never touch groups -
they have struct devices, they should have a clean struct device based
API.

Groups should disappear into an internal implementation detail, not be
so prominent in the API.

> IIUC this work is heading towards allowing multiple domains in one group
> as long as the group is owned by one entity.

No, it isn't. This work is only about properly arbitrating which
single domain is attached to an entire group.

> 	1) Introduce a concept of a sub-group (or whatever we want to
> 	   call it), which groups devices together which must be in the
> 	   same domain because they use the same request ID and thus
> 	   look all the same to the IOMMU.
>
> 	2) Keep todays IOMMU groups to group devices together which can
> 	   bypass the IOMMU when talking to each other, like
> 	   multi-function devices and devices behind a no-ACS bridge.

We've talked about all these details before and nobody has thought
they are important enough to implement. This distinction is not the
goal of this series.

I think if someone did want to do this there is room in the API to
allow the distinction between 1 (must share) and 2 (sharing is
insecure). eg by checking owner and blocking mixing user/kernel. 

This is another reason to stick with the device centric API as if we
did someday want multi-domain groups then the device input is still
the correct input and the iommu code can figure out what sub-groups or
whatever transparently.

Jason
