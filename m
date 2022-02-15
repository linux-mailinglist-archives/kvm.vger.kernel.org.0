Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55C94B6DFA
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 14:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbiBONr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 08:47:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238408AbiBONr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 08:47:57 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0987DF2F;
        Tue, 15 Feb 2022 05:47:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHkNrCrT7hM+A4rMxWxjyjgCtWFFSnMIn1kX6MM1rVk5x6PAF+Fufpam1Ujii377/6ZW9KptP0vG+jCnBK7HOuqDeuA0C3AtmcsoSYUFKim/u8QADYh/eh45icmjYjGzgt/tczPWOu4fEfSGnMcyBw2pp4SIMFhoQp7jhE6c1BLtaZ5YIqLuxsatQcwgrkZ5nCR8xgSNXJYGrhI+sX0pwKm78g1SzG/XjsNMfA8nMJG2OXKL1SNO+JX06z2rGLRzltPiODTDHWAoav0PgefxsxDk8MIbzrO89WZgxI4EM1f/pevk3eQeZeEvZC6pF9ES5cggOYoVM0diwiOSkSA2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0i2YyEsaZexMhSHlFSOMsKg54H1gW8mUVTSgPXHuW0=;
 b=mn/WtPtnH3mCT/lqK0ML/pqHHlzPe+aUvILzmQDormNFZS+rcm5FhIO/STsmuzKPkq00t15yGCrToXrLRIUn3W95h5h9GqEGLIii7TLSJhHfLZ6EAIAo8NZUEQsVnpe9q088iEeJEM17oY7MsuCa7s36HL/UBlpwGXx6tgOojh42SFRqcWg/P+6j5ilZyZhLSsmoNG1Sp5BxyrE2YITBFf92dUgVldBZdLKHKaBNPZYy0u3/vHlvSmn3miJkNNmcOFgOgC2UPhttjv5xidMwe9D67OnFQ7Hjnkj/S+67hYyAGmhYV5BQzM+h7o8bvrAWwPiKq5CFZHRPaRmqHv7n5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0i2YyEsaZexMhSHlFSOMsKg54H1gW8mUVTSgPXHuW0=;
 b=JF6gWnA+VS1sImXwd6il5E/7hrttgMMhWqD1wQxHYxVhTc0LJ8qg09lA3xcvFHQnKFTtCpItfmrKJsA2wpE1jd8/BOfZrKjvUAiR8iLVpDz177UEsLk4NvyjPRpHT8o4yZBZ8VKI0SA2JAgltnA+4rXwBaq23LxzkgnFSrRxfKBVb+h0oPts/WXaxEBbwj9kIkfL7QA+o/r1ZCrOv/DYUriCFAEErebvIPfliJMR08oLaqI0UwLnmfdrZlHNe7fk1n9YwTlTZxRugFXM+257UXUL2+qcCkO7T6UJlbfPagViwldnXw0hQ6OVu+wMTR85AAKwwOayY5e4GrWi4EsVvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BN8PR12MB3075.namprd12.prod.outlook.com (2603:10b6:408:67::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 13:47:46 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 13:47:45 +0000
Date:   Tue, 15 Feb 2022 09:47:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Stuart Yoder <stuyoder@gmail.com>, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
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
Message-ID: <20220215134744.GO4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <Ygo/eCRFnraY01WA@8bytes.org>
 <20220214130313.GV4160@nvidia.com>
 <Ygppub+Wjq6mQEAX@8bytes.org>
 <08e90a61-8491-acf1-ab0f-f93f97366d24@arm.com>
 <20220214154626.GF4160@nvidia.com>
 <YgtrJVI9wGMFdPWk@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgtrJVI9wGMFdPWk@8bytes.org>
X-ClientProxiedBy: BL1PR13CA0231.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::26) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45576e2c-84fd-441b-4903-08d9f089bf0f
X-MS-TrafficTypeDiagnostic: BN8PR12MB3075:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB30753A160B147531D43DEF10C2349@BN8PR12MB3075.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 88+o1ITyl5PajuDBs1xV4gOfWT7cnaf1D5g+rl2CknpqUuWroAREoJyCu/nTmHdIri61OqFxj2CRCLP9DxKNi/FdFwofnBP8D9JSy3DxU0UoJ1S7/HvZJlDhTy8gA1H33Ul/3YU307yV+2zy4Pro6ZTExcmtML3u7NJbfEDR5+EDcmWdjhMkUHmC5JpaLzpYctyJgM2SKRFinTnMipy7Qlkqd8L2tEPRzGf+drcABF5t5nh7vnaA9FkQxMGw5pAsd0GTCqjREtHvgU/uk20+OC8Nm4eICAu7c3PlvURwYcGHXgr8t+TwOj4f8w8Z3s7glSTlJbiRHlPH7LEG7dpqR9goG+/xeZqnBu0iWR+Oa3RcYxPnjXa+qOG9xjblP2pdSn+DqFXcqx+7fLE612YwJ0smx7CRyc/kI9G2/Hsz42lf2hETr9oq2EoQC3zrUDHhU67Pb01HzSnnA/IA28D/uq/e5FHkfEy80X1mg0Vwbcpx2XYfYfT/5mynsTAbCd8cKMpmUkM1a500Tbl55Tg5HSY9+/NGN3bth8z7ODfnBYkMD9C64wt12VxJCVYnLnwF8oWYzlM8DMMqrPWoUS81yHnvj/QYqdsC1Uy7lZujL6okOtcUnflCM5JYvVYBe+6JgsctCCsK8Y9jFOccmXHtag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(1076003)(186003)(2616005)(508600001)(26005)(66946007)(5660300002)(54906003)(38100700002)(33656002)(6916009)(6486002)(7416002)(66476007)(8936002)(36756003)(316002)(83380400001)(86362001)(4326008)(8676002)(2906002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?buzFBb8FjC2tWGSoMlyOBJ27qvuRGWMavDZF8U5YvRUV+huYFPTvfmgOWie3?=
 =?us-ascii?Q?P0S3nLS0rgUic7nplMzs1eWmxqAC3wo2qc6pAgMk+RaSNZpfSe9KZv+h/si4?=
 =?us-ascii?Q?sNBGtRr7PzevPpg2hqg2mVoZyOe8neX623oBDNOVhNDjUSXbBujs9MzgatqW?=
 =?us-ascii?Q?Gfgqt8cJAdRr089k3uCtNCDqY/LWLCDpx8OwHMAYJ/RGsgUd27IzbaIyXZIF?=
 =?us-ascii?Q?MFcvNagJb8HAnl/B3cVftw6VXN/rNJWk8AUzrUaLKyl8nQhgBg1WuAqtoN9Y?=
 =?us-ascii?Q?yNkkprrZPf8BEi1HxQVRqCeYqqZea7tjhpN5dN5NsdYkEoMqlI3tN7w4Cy1L?=
 =?us-ascii?Q?POH7Ux44Seefa89FKrr1h+tf3NqTNWrrylK+MMHopILDtHDNd0a74UE5DWfK?=
 =?us-ascii?Q?KJSELpkjhKLgE3kWmwzqQnBC4JyaJpnALFm6/vc34hVJsh6+mtNrDlsYmNUu?=
 =?us-ascii?Q?2+KV94YIlfOYeMdo/LNZtP+3taZEYNgFhZOSudluiKY00yANu1GDZhMijCfj?=
 =?us-ascii?Q?tL/wfabheboVsaw1v/0DSZPiemryNNmKi/eD1Le1XA+uWMo6SVE/x+7j88N1?=
 =?us-ascii?Q?osQnFoz5xeMQ9fx53gmVzWmoi4FEqMPfGB7Dsdj7hu5n559z6UaTur+AjkbD?=
 =?us-ascii?Q?YVQhZwuhUc7TiaoylsMp4GwGecHY5NV63dIXvV9uaSGTIJST/V0Oy3DyBzVL?=
 =?us-ascii?Q?YDgj5p+CHYBdJXqIjP8IFPRmxJtHxzbktUwAW/RVnPoe5IxAalNh9NKYxTtf?=
 =?us-ascii?Q?vWZPC9xt1H6LAdADZowG/BkGzpm+PjS9E3j6m3aUfUESh4EvyzsmS6lIomOJ?=
 =?us-ascii?Q?179Qvo3Jx7oB6i2lxYS2i3/NHvILUe5m4Rr4yS4wT74t17d4a8hnY2YZXPoR?=
 =?us-ascii?Q?JP9jlAVWb2DU3RPEYeLdjaXD3XVa8dcD9V+eu3wMjLrIccSjQdcWRM8lZupn?=
 =?us-ascii?Q?vzJKqDvTNj+KsYJxI/93HObpZeVozSYyJZaPoKR9WRs83OvbQx7zp2JCKYhd?=
 =?us-ascii?Q?PpESLHNjYdT/AQQ/NUvKc9FGRhp9gMZBfAiyCQMx2lG3Z4kGtG3GIOx6D8z2?=
 =?us-ascii?Q?VlKAP559wKTbYniFP0OgZwPyHQ1F2xf7ZrDIrHvSZJDdF07M71dxNCtthIQ5?=
 =?us-ascii?Q?BEuj28Yjvr4uVtMXLmfyBBTB9m9iDyZ4wnm5k4IGMS/1lXRdOsICm5WTqQbz?=
 =?us-ascii?Q?MLn5CcXMXmhLVzUH040qxD7afIC10ZaMAp1UW60g7VD0sRUtvaUUZHNsjV+Q?=
 =?us-ascii?Q?uM2uoFRGBW+HK0VR90eYFXG8nbrZ0YfKmHvirW7cXRPSo2YCRQvMSLSDRx7v?=
 =?us-ascii?Q?UsiNbT+76HTnWoywnk6w5u8WQSlmCab3ZJNz7+Frhp5uuJU9efRFMcigxZAI?=
 =?us-ascii?Q?zOyq/VvYukCaOHgrk04di8s0oBl5foejL8PMvlk/6IaPWf5ACrYwDdEKZ8ak?=
 =?us-ascii?Q?gIgCpuY/YVFFEYCOgaUvg3Q0o/pomo61aH2A8rxeqLWhgHSackDwtAL6yOtN?=
 =?us-ascii?Q?+dbWzqDSnwzAF4oxsP5/bn5qtd6w2SvohT6Q59jrT/L8cW2b7D5NiCVjmRO1?=
 =?us-ascii?Q?7pYGC77UmyDTNKiWJbs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45576e2c-84fd-441b-4903-08d9f089bf0f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 13:47:45.8458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srIr/UHAkXtnAdozCxcpPB1v9pUwsjSfL6kw8VQIZ6gtpKxwh4ByINPnRUgvG9sx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3075
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022 at 09:58:13AM +0100, Joerg Roedel wrote:
> On Mon, Feb 14, 2022 at 11:46:26AM -0400, Jason Gunthorpe wrote:
> > On Mon, Feb 14, 2022 at 03:18:31PM +0000, Robin Murphy wrote:
> > 
> > > Arguably, iommu_attach_device() could be renamed something like
> > > iommu_attach_group_for_dev(), since that's effectively the semantic that all
> > > the existing API users want anyway (even VFIO at the high level - the group
> > > is the means for the user to assign their GPU/NIC/whatever device to their
> > > process, not the end in itself). That's just a lot more churn.
> > 
> > Right
> 
> Okay, good point. I can live with an iommu_attach_group_for_dev()
> interface, it is still better than making iommu_attach_device() silently
> operate on whole groups.

I think this is what Lu's series currently does, it just doesn't do
the rename churn as Robin noted. Lu, why not add a note like Robin
explained to the kdoc so it is clear this api impacts the whole group?

There is no argument that the internal operation of the iommu layer
should always be using groups - we are just presenting a simplified
API toward drivers.

Jason
