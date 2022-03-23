Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5364E560F
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbiCWQKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 12:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiCWQKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 12:10:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C83B3D7
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 09:09:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UH0Di3AxnaWfRe14ZTsrXU4Ma6j5T+t8WWMeb/fQ4OEsyIvlZUU8nbqhHjhaYnOSSKF9/3dUEreiEcSWsQ4k5qiOin2CQH/gnMKhoZxPJFR3+e3jw9BCNHhvSPz9SRaXPxc1K1j8EIaWTCKzCufQ7Mkpj7RTRyBk2O3m1REzI8KEev0IYvtmKFZpU8/I0d8EWgLzEdTJpH1YUDB7ZpcRnAG3qjugot0hPZAGkt0Won//yolb5exM/stgIdCeEx//yo7kZ4dOK/PBpE+h15MrXgU5oyH14Ol/yajSZOTQTceZOjA9yMM/I90pzkK9WTLY4neOUXxMEqJ9G1nP12/ZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uB7D+EW4rL0CtmDwhp7l5H5E+hLKriMEpj2Yq/XLbg=;
 b=SF2ouXxZf4jN5/GG+rsoL9QIkaUCuk1XgN9BruMlIdzC0UhKRnqzyjNKwlRZ5TjNYr5MQq5azFHWfwN1gS+gsmiqhAe39Tj7LEgTz07wjGeoX8A3KhaxEVtnQVXlVlSYCJ4L1qk8QtCrSg/ZaE3xzuIYDfTd6NIvYcPKkW/Uhh5ZqwCNlgZURFpNNXJ7gT2wmqOy8AtpkK1R6TmJRjY7TDs8DD5JAesOnH2PlOAz8FMQBOQps4AX3EIA9rBQUJhymOU35dhk9TNUKcyNHskzyZlSa0unVS/Ho+y3XyqP6Jzh+SL3vSWgugD4oO3OuGP/s0g+CEVvxhAX7pZZL1WGXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uB7D+EW4rL0CtmDwhp7l5H5E+hLKriMEpj2Yq/XLbg=;
 b=HgkOfU75UbLOIL+2xxM9Y8/QJzkURRPvTGUW7mLe6uON3bhdgSdOd04LQ/wbm5ZZDbXGpYsAXpOpYk3Gb8qkUF1M9MM7hiGZ4iErtq9wls1hoCKEcsZmP6OQFtn3EunVXmMkE5s6kP91jZy3DZQWULYKMi4FTOUirpYRLlb6L6qvyCLucqqnAdOEcGyEzOslo8hCJxzC4Kwnd756yEevm5BlT4wLkhkoNDMMaF43HkBNqpaGT5ydZMVxGm6PSb5PbHD+bc2ItxARSCK+jYB6efg8lG4G3Ez5Z+BoKCQGudaEMK/vJL8Irx1up8+HS2MTLFnwln4om/0kABFLlyrE7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1564.namprd12.prod.outlook.com (2603:10b6:4:f::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.15; Wed, 23 Mar 2022 16:09:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 16:09:09 +0000
Date:   Wed, 23 Mar 2022 13:09:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 05/12] iommufd: PFN handling for iopt_pages
Message-ID: <20220323160907.GN11336@nvidia.com>
References: <5-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <910ee0690554fcfff282996f3e78b3d7b77145c3.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910ee0690554fcfff282996f3e78b3d7b77145c3.camel@linux.ibm.com>
X-ClientProxiedBy: MN2PR16CA0006.namprd16.prod.outlook.com
 (2603:10b6:208:134::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b578cc47-4f60-4822-0d8f-08da0ce7765e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB156478EEEC6420D3B4235992C2189@DM5PR12MB1564.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /EfsPiSswIPyJdJds9vGfZ6Pf202bpLu3rzoqVruMLX32OBWQo6ljGWXoBopxf9gQVsaGnuDBLOr1K4OVk1C368qLylWAxUzDZ4tWhc3WjaoKlX4LSyJ4v82dU0rH7cXg0Dqb7qcKZTp5Q7ggsViT6yTxiPHVYBrGoiChzkei7HnPX/OWP3I4yO/vERzGbrF3aF1PhNwIJbWj0BxTCa/dcPJEGi7BMfCBo03660xSAQwTh+ZDW24j6613cyU+FzCGXUYA5j5ECScyygNjLmsjppYrZxZbHNY78521ghejnqUhb21KjWq/2Gt19tg4Q3EXdtfhr3ce2WFaHs6WEpYIeln9qcDdJpeejGs5lKgsKlH9auBMhSMLJsNFSkKsTxfSBIpEXusy50PmV2U802l5LJL7eFuKcTcUBMpWSe1puMYqjPnqVdU80TBhh1if0cgCaEdG1elF9KUt4evwpT2Jkp5PfgrhHVXhba+mNH7+b3cvSHYp2y9ykADwoH6Wwo/djI0uvhRnb2FI2cfhfJ+Wu8JArwK9BSD1SlannXLjMJX1jIoIkS+auVlhqUuy0kAWcM7V7WFLQK2ix+Hlg29ROtoscz+sCx00jey5NUEt+Pg72+2P2L7bN4EI7Qt0+d2SFxM+8IjwvunknCDTOhgBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(66556008)(33656002)(54906003)(66476007)(38100700002)(186003)(5660300002)(83380400001)(26005)(508600001)(7416002)(4744005)(6916009)(1076003)(316002)(8936002)(66946007)(36756003)(6506007)(6486002)(2906002)(6512007)(8676002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e2OnNgWuQ+iab8EWZEBCrDBW4+oEP9fJ5MfOraP0SFcaJQlTxpBISENsqacI?=
 =?us-ascii?Q?vKIX60xPZeWV7VFDN10+Tf0WhnPca1sbYmAUDOlK01YEruI4b22kX5ZSYo+q?=
 =?us-ascii?Q?cC6JtHqdQ+N9wnQ8XhkQTQrS9ZvY5v47TRlTBEa8bwiQuNCCxVasDMAKzChY?=
 =?us-ascii?Q?rMO6DT/rOPAic8tn/c+vFGUv4c4RRDsxAJ1pAqRdsW9BVt40u0f0DhMYNHie?=
 =?us-ascii?Q?udd/7SDwIHOEjVEj19EqUBvdIAmF/Wosrt6DxGexlbxVA7XeDVlTeK1tjk9Y?=
 =?us-ascii?Q?B+u8is5JPRnwbIKvyo4Wg9YoxvlvAkYP0+gFLXx/PjB17KaQ95PEWgYzUANP?=
 =?us-ascii?Q?1rbJoxjlRCYAJLsu0nUHjtFaYyw/xTuBGD6F7XyzaKIIII7bgIs4QNhZ94un?=
 =?us-ascii?Q?yOkxlr2Y8zvNQMEc6I//19mU2fsyCYX9uXISk1zQbbLrh07CPb2jWq35lH8r?=
 =?us-ascii?Q?nQO20E/wTewE/NivkgnLHuNXFtZ4LJ8kikrby4KNL6qDXlNoKqQXnVA3dYQq?=
 =?us-ascii?Q?OVCrtxa04NmjgeUtnuRjj+/ENxfSwHkDgRYK835wkqR9pMZgDE1t+kYy128B?=
 =?us-ascii?Q?heX4yPDIHjweQxUV5+MCtYg04G32a6cdmVcU89OQyGjaLL5Zb87TA4Prsgz/?=
 =?us-ascii?Q?RLceVDZ7emKaQBrrMUDjwh0F9Tgm8fVHF2B9N5i7Btnls4IwyGvJh6F0gU+1?=
 =?us-ascii?Q?+tysuyfaGejOmvxICnLnnDGuPN2EOl+qRQQAOY8G0aZoJ7RxBPFC6kEVPauV?=
 =?us-ascii?Q?bd66xfq7LUAd1E0XbgAkSXwxUx0vZ/eFyPtkytNHuwdwMDSNS7uB3CD9bTzF?=
 =?us-ascii?Q?tj4GidgjmdwGZrVZ14wRGS6mgXgZtLj5bgTpt1rLlZt+HahQtyUupn2I0jce?=
 =?us-ascii?Q?wKPNIHgtbokKwXaE6gdIW0Vl/sX+e/jcKJ8Z50VuCrfNzKY/E9ClHfzBkTRa?=
 =?us-ascii?Q?j2tH9+TWLxAfJez/x4CdveeAIQtn//JRGKD3VCG2AViD5TfbFSpFPQrefqrh?=
 =?us-ascii?Q?McbixE+gMVZgAH77YWqrh/vjRgmmpfJEKllfSiijl5vu/cXT/pnxoDqPawqh?=
 =?us-ascii?Q?66JIoM+GAmTqWIudyexu0IWG6PIzywysZ1J++EjvUyXdPFE8jMril4jfN+Vf?=
 =?us-ascii?Q?CXvRSa30mmOg+tjIQHZFD9v3dESm5exifddLdk6H5IwAJJ6tE0C6f9efugUP?=
 =?us-ascii?Q?ef124jJkYu/Wwo0XaxrW8DMcTZcF/j/eLzXn+6KrwD/X6kHsLIVYeKKj0QBs?=
 =?us-ascii?Q?kUKhZiCYH6xlCLRPOMsk2844JyUz0asAJa4bqLoEpK+lTEmlMV1C8tNDMOQZ?=
 =?us-ascii?Q?0PbX70IJjv8QYwI10h1K3cqiBJqv3rUpJHLI4c6Kqp19Br88tuWeITffyB3X?=
 =?us-ascii?Q?kMP6dkAPUBaN6X8EkQaUpRkEqD/jLJJ37wp9jnWFlHID+nViAhiGer2wpEku?=
 =?us-ascii?Q?kXHZcWZpMzPb3uHUkzH2XlhL2epN8KuH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b578cc47-4f60-4822-0d8f-08da0ce7765e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 16:09:09.2168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ukDNQTM3mFhBwGKcGqjXwHuhfQrX3jiJxzZwUv/p0YZK/0deB2JYaGWnSN+O99BE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1564
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 04:37:50PM +0100, Niklas Schnelle wrote:
> > +/*
> > + * This holds a pinned page list for multiple areas of IO address space. The
> > + * pages always originate from a linear chunk of userspace VA. Multiple
> > + * io_pagetable's, through their iopt_area's, can share a single iopt_pages
> > + * which avoids multi-pinning and double accounting of page consumption.
> > + *
> > + * indexes in this structure are measured in PAGE_SIZE units, are 0 based from
> > + * the start of the uptr and extend to npages. pages are pinned dynamically
> > + * according to the intervals in the users_itree and domains_itree, npages
> > + * records the current number of pages pinned.
> 
> This sounds wrong or at least badly named. If npages records the
> current number of pages pinned then what does npinned record?

Oh, it is a typo, the 2nd npages should be npinned, thanks

Jason
