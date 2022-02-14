Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18714B551C
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 16:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356026AbiBNPqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 10:46:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356016AbiBNPqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 10:46:40 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28E826D;
        Mon, 14 Feb 2022 07:46:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBUx11nm1limaV6Gigylear8n+1NcR7CQZpQJCri+a93uycig8RHM18RlKYDs7wbCurr6JomAUXjyJhiBUEp/7QBh5EJaY1rDlBXanMD3ujg902O8EJXOidRnQt2Hoszs6YSRFNSXkLVVDjPzZsHJLGLF1pL9ysHIiXV3zMLL+Muv35DuhM9vNw04o4PoXx3rHW0LmrMnPr9IVDxSzfJ/bBWXQ7PBOOA2c+Ny3k65LdQjYAnpbG8bkNbtmwuT1LzW3SSi9B2+NLWvaECSdxPa/pVlA2AO9H1khxYFBijTaDeGRsitL8x/1AEiYLG7oPGZj6vtdYmR9NtM8iGww2YvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2wsG1hr8343sJCB58vClGdnUh/toyAKtwzcI63W5/LM=;
 b=nN2PSia7T+EqLQw0x7QXNgcxTe7APktp/K25gxUrn2GPMirmDbPmOq7zLdwKpYMncQYlAqmlLqJ3q+IE3RY5v4SlmlcqF9RuIbox42o0NjSJymH6RFdbQNRC2yi31+rRwNuUu7gEc/BNlcHwjpjE2Tw4LRdU76e1zB0El7XFfpts3M+wfwY2WlUvrBYOEpa5lyVSgBJ/5hum6fJ8ik0g0vWEAlppypvG5NF+6oypIrWnDzV34Dn4aJgCEJNTXFQqxJ9zFkf2hlxL2646XKIaLmnfVu9ssqzXp9En9DEr13Wwo67g/RBvinY8vKkIfdEHjLUSH/Ab3CIDwXIg+ZCjCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wsG1hr8343sJCB58vClGdnUh/toyAKtwzcI63W5/LM=;
 b=LCB5/rG1HRF82NkcPPsmdTlsEtgAVKbBEZCUNbjsdrkEGD0i/JbZ0XpE7wil02qTg30lzqiFFtIRUR2SOnPEqXZA731jrt6vkQ97fkCsD5JDBli0FozSmv57RcMgYta42fxJpeTnVC5Yq1f8WcsFDlJGlgLoq52KRJ1MUsZCr1Ii4gYUMH9u+p9FY//STG0OenjbNx21m7xTmiDNjFmI8OOE1+XDFxf80Er5owFuCiIY3ipiqJT9ee/ITtlnVN+oGgl1vlE6zuF3gXIFy9mXTXggT4lQaDjt6DQYXjFWO1fHRYddlibQtt55nvXPEMiYwGHdxHijqCC0Q3VXvL7Dwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3770.namprd12.prod.outlook.com (2603:10b6:5:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Mon, 14 Feb
 2022 15:46:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 15:46:27 +0000
Date:   Mon, 14 Feb 2022 11:46:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Stuart Yoder <stuyoder@gmail.com>,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Message-ID: <20220214154626.GF4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <Ygo/eCRFnraY01WA@8bytes.org>
 <20220214130313.GV4160@nvidia.com>
 <Ygppub+Wjq6mQEAX@8bytes.org>
 <08e90a61-8491-acf1-ab0f-f93f97366d24@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08e90a61-8491-acf1-ab0f-f93f97366d24@arm.com>
X-ClientProxiedBy: BL1PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22f3bb6a-1def-45e7-df32-08d9efd1295d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3770:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB37703E4CF699666A0E67EF3FC2339@DM6PR12MB3770.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pmTuuhCUeoxmFxNboGN2OxS0CEgCS3WLxp3djChTEtAQ14l0+Hhvx1IztLF4J/OgwZ9q2P06WAJARUjpyugyNw0rcdmwCe7bjgvL0k0OLpmEq4O8J8XaLAAU16FHs/iKhoC8YWyyn7L1t4g3625lXwJ+iWWYmy19Poe7jYi+n7sIbPsqz2FFuKa01qQOaj/RVOZWjFk27LsPCv2dgtOEbrqYZNFLNJ8bfp7v/eLd/W3FEHn5c01R+Yw1+M+4yDLsvIW4iLyLTB40wgOeTEv+61rxENgL32eZnqChsXwOnvSJ8SLZb1S5osn6miorRAinxv26mbllBhP29FSRZsWpIGk+T+fwrx6BhIIgODqOF+7LG0ofLDkByDkqj6pPnJI16842RSY9TkZ3nn8r4zfvKbjBsSmLvrEw9rTRFcV+KVaD/ruotJogPQvZSO0o0YHrEfI6c5J4sPSEJt8hkva2AeOjNdEztLIYn97sQzucUXXYOo9vXR62q6mBRB4O1OmM9t4NKdUvWTPrybsB87BIg1Lb5tNZ5VfixeEDWxuFNwEb57/cbVUFw58oTjLDJMstx7SkrG9IRwDOBhrfHNcrob1ce1QZDAu2ZEcqzD0Q75+ABbWd9Ll140QuVD4L60rI8654Kk7TLon8N0kriXA2Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(54906003)(6506007)(316002)(508600001)(6486002)(86362001)(6512007)(1076003)(5660300002)(26005)(186003)(2906002)(33656002)(2616005)(36756003)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rm3A8/+CCwywTETbcpetS1LxfwHQG9kU7qGb1ZgSuuTD74K8pFUjNa+JrHTi?=
 =?us-ascii?Q?PHWnR0h3AI4D2/8HgIigcEA8YMQFqDW6uQ0yYoPzBQPhvXXy++R7MuPS6dYb?=
 =?us-ascii?Q?5jCV2UohLGmFhgakv9NbWYN/XVMZRZq3W4F71moCrYSPX2JOOebkr1mRfLrd?=
 =?us-ascii?Q?hCex6ySGDOOBkAqgaiASbZkCchsonRiRbCoXQu9R6VMDHYuEXyA6U0YHXoiB?=
 =?us-ascii?Q?8heg1xHiyFN44A8uuONby5YSqOlQKcyCfUkkdvCx8NKELdcICrEE35UdoBgw?=
 =?us-ascii?Q?IYCUHAu+nkPGRHwQoAXj+pmc/5lhSyoae5e6Q2amcOiEP6PTdFV9AB05CpqY?=
 =?us-ascii?Q?66/LwKNyasYIS45E4+R9IywSGwk0IocN/4YqCNcyi8JNTnuXwNE5BOtz6M7x?=
 =?us-ascii?Q?PMFm4gnKjc/o9F3ZEt+AF4/bNWuJntxT6t+0vbDhIa0/I8gRZndaqGvSjkHa?=
 =?us-ascii?Q?KV0sBPl99bYFxVQwEsQaRCH2bBFmWIqp8DpNhbIXtLU9qUNlsJuAu3QgJFGK?=
 =?us-ascii?Q?H0Tc0MC0ZmHzTk1S0Yq1sc2EHJ0e2brh8tEkLQcprqy4qh9AV3jYDsqHO8po?=
 =?us-ascii?Q?9WAjNBP+FvQcOeN/ySfwet57sNUiB8ppNhJ9n+Tm6xb13dWp7yOjtMMx2x41?=
 =?us-ascii?Q?s+1zXLYVaKSQy+8xiGLH5QyF2SvOHRH0jObtZfyF3nxMTL7KfqWrO0ftSBP6?=
 =?us-ascii?Q?5XCNngDHWsos1aKJuzvDEWKqORG2f50tMBEuVvExK8SyvTEnBPZ+to2oGnit?=
 =?us-ascii?Q?A2eST6XNQTljlD01mRZENJHVI8Qv7zxco4QtAFmHdQRZvOK9KEelzte2kmik?=
 =?us-ascii?Q?6HhPeX2e9912L5YOPTfceCpLr/94GkIDa9B6/Xi7Dt6Nb5SeNDlvNFizYZ2L?=
 =?us-ascii?Q?/8EtrG6q9AMk0DN+49DQyuNlWJjGpJNaWvDuhsL3lqTD52mBXUQxkly+d1fY?=
 =?us-ascii?Q?/Af8dYUqA/eLFz5GelxwblWfpjbK3fUuuGH1e2zj2JjsIo05Zlx7n0nFkE2B?=
 =?us-ascii?Q?M2M2x5mHDr0vb1FN6/hUwioeGfPV/cVlXo1MyZJ+Om6lwNcsImoE997PJj38?=
 =?us-ascii?Q?ukcQhg5L6L4RdQKHUQnv7lzqfNgGy2hkoFLIYfDBhsRJzgEYdp9q/nbEdiSz?=
 =?us-ascii?Q?/8j6xEGL1lnqGGYrIwR/Y5C1RxBp7fJNqiVbEdhyooUzT/DJP7LSO0ED0ZFG?=
 =?us-ascii?Q?UwEZ2/EogS953P5B7OBK/Em+EypZbiEYBok2eegPoxfo8KOfTBg8+wWrkynI?=
 =?us-ascii?Q?SEhbkKioM9NIeMf0eeVAjkqveePOP++kGlcF60nrzRjfJj/TLpnsvyKmvNU7?=
 =?us-ascii?Q?LYJ2FR4YhLLaE5oBjuAvoyIco1iJq2agV1UpZz+ZSYHrj6E3G6RlZT4B9wzV?=
 =?us-ascii?Q?H8ON8NlljGibM2SpEOGq2GoO/NVhQkVPRd8Ws9+ra++HTEFePpGuvvG597Rw?=
 =?us-ascii?Q?r4GO3xtWC0hUzTZ00b94fsWrIvS3RK32synSBI33PX2XRjyVZWjej8Xf04Yv?=
 =?us-ascii?Q?e7p8KirtDlRlMNKq5ruZDI/0UwCkUH2UvUa/I3iadg8com7j7Cg8Je5M4CVx?=
 =?us-ascii?Q?5S3MgbZ/4eJ9sRmBkZE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f3bb6a-1def-45e7-df32-08d9efd1295d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 15:46:27.2419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2KIFVwNSONGNkzGqLzumqpOVl9sbJ9gs8IpLjf1TI9By3zan4o7rRMiv+QErA/ND
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3770
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 03:18:31PM +0000, Robin Murphy wrote:

> Arguably, iommu_attach_device() could be renamed something like
> iommu_attach_group_for_dev(), since that's effectively the semantic that all
> the existing API users want anyway (even VFIO at the high level - the group
> is the means for the user to assign their GPU/NIC/whatever device to their
> process, not the end in itself). That's just a lot more churn.

Right
 
> It's not that callers should be blind to the entire concept of groups
> altogether - they remain a significant reason why iommu_attach_device()
> might fail, for one thing - however what callers really shouldn't need to be
> bothered with is the exact *implementation* of groups. I do actually quite
> like the idea of refining the group abstraction into isolation groups as a
> superset of alias groups, but if anything that's a further argument for not
> having the guts of the current abstraction exposed in places that don't need
> to care - otherwise that would be liable to be a microcosm of this series in
> itself: widespread churn vs. "same name, new meaning" compromises.

Exactly, groups should not leak out through the abstraction more than
necessary. If the caller can't do anything with the group information
then it shouldn't touch it.

VFIO needs them because its uAPI is tied, but even so we keep talking
about ways to narrow the amount of group API it consumes.

We should not set the recommended/good kAPI based on VFIOs uAPI
design.

Jason
