Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A8F5148E1
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358924AbiD2MMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 08:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiD2MMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 08:12:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DC0C8A99
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 05:09:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eh1Ijm/rNjNVG0NAl19gEkwfsnlcZ2VlSM8Xlg7FN2Z3hNvOqb/N1W7FhwA2jN2XXYOnLZd6i/YTsUQszpENca47HuQ2ID5Qnl8QSEZtWUqyxClKRP5kO+js1dW01XwwRtZOZLg8fFy3sVK0K89A/I9GDtiiyMkUMnrzAI45KogdkQoOkmxgFq24fNeiIAfm3mUS6CccGRAWcB+fF/Ui8zuysSHcPGL5gOgUydTFqZqaxgYtipRrbaxHI+R7mFRUO8CvzWuX55egGH7gS8JH9T2BX2c9ORaVIWFpJjUyNpGsYaTDAVLpKiUSQXKuoIh5c83aEyaaz/bp9Y+v4yzVng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51wXiiRY0XpGB7RbXTnZcpgUa0Id2gIEWHtyAp32BsM=;
 b=nSb7O8Wn/RXRgnJMyaMnFpWgq5T1X0NixIjFxe8mhYSycjTbLS7yrYVLTKIV3hcuGxgCjadkz2iKW2+EzMTqWj01gEG3QL7HOjDqpAb6aDmnBU3sOtyzclEOd/A7lRkZBvK1cCjzKyqfKNRFwecYkMMGn+wxpKXiAX0faEnq7d6eR0nDJRBJC4fbK1s9qDBNVUIp/I9fJNKUTxqsWRsfdMUyWn+Uwr3zYGyXznFnQMAAoFRmWIjxFonXl9uaf/U6qnCmjsptYVqPrZ5GPDA9YFgs5Yklb23904WK48dLxXMf1brs5SNbqZw+i4gXir26Y/uSMTvyxz55msjW4KDapw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51wXiiRY0XpGB7RbXTnZcpgUa0Id2gIEWHtyAp32BsM=;
 b=DzrruXK5qMxQytuaV+9W3yP60BtSrnetQgbwG1r8yFIGzLfXb3Gygkdz0WUrd5HP8fJ9EVbaIevhgrj26mExLh+gx7gjrTLjYuZ53lqfHMTLh3OTU3m2oZJM+fGqGR953Rt/sB4nEeFAxSDwZaku6h8+IIcVJJde6tdOEagekJVrq01KXzCJxEfUFHURh6vjn43NGvi0C3d+uMiAfDKsavFxkiOoF9WSoLwQuEh2XbCEFV4w2yZWbLxsTgP5X73ZsgxqZf90dP1xjt9aTJdxQYCCzJiKGK9ZiHNMCkT4UeVx5hFmEyBpqA5aij8JGSJDzDNZHICfhwDHHT73EB/egQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1621.namprd12.prod.outlook.com (2603:10b6:910:10::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 12:09:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 12:09:34 +0000
Date:   Fri, 29 Apr 2022 09:09:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH RFC 03/19] iommufd: Dirty tracking data support
Message-ID: <20220429120933.GR8364@nvidia.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-4-joao.m.martins@oracle.com>
 <BN9PR11MB5276C829C3F744BD4F4932B78CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ef762630-c466-af13-c8a3-da3f360b334b@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef762630-c466-af13-c8a3-da3f360b334b@oracle.com>
X-ClientProxiedBy: BL1PR13CA0334.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::9) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f0d76a9-4126-4570-ebd9-08da29d91fdb
X-MS-TrafficTypeDiagnostic: CY4PR12MB1621:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1621DC5FAB72A6F9C9727B2AC2FC9@CY4PR12MB1621.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D73CmM8Me3KX0bERonMlOF+DeeIkOuR5pBMk10y7O/ixrdVahd71YDEyQFrmv0Ddrncyr2Dvrw5mFn8sornzMW9Kll4ijI40X+re+T/3n0vyRQuCF9+V4xcvODnh+HU6Y4O8WdvhUNU2d2vhrieBPHJLutkgC5Sdd75KeD+sn7GB1VokKKr9heebCvc/9/ElSZx9Uh6EpLQUFjwDcWuDqNGtaI7wixWz2iHYWMBxFmnsG8W2xEYv2EbwHVPnFEWxPLN2pbZz1fiC5mZWJxhawOIesIpckI4kogqMLbFORYimEAr4RuTi21qb2tr3Sm8zb4XnIgTIpiHV1tCKQdmbqxa6xsTqWaFx1jbRmTV7JiSJF2WPSlOg3RBZOWiKPPyRNw/UulZVdJ9g1fysXdnI4EYL5s+S8iNAWt6XrbTexN2OYBeiDO29KroQjMOYS6N8CVzrA3UDuObXR5I+O1wTIwWgRaXsqCH3lZwqyTs8dsQndAdeoudYV53M9lU6aT0yHR9FNuds0iKAunqEMHSpTp+40Vl4Ky35k5MH7kYyVukbLaSMNdk/+Tl+G4M4+rIW2YDYtMr9uvDjoBuvbHTsF+Yr2RdPcONfyb9bTyXFwZyDhOBBY93wcBeY8KK2eb9S1EJavUFMTE75RWN2vVlQgSuXgXwu4/qrvOfCYxgt6CpxRUKWQ5PkGI9Y3fmtpR/JAhou9Jg4fXXqY1wR3/ypxTwZ5mvv7R/xH59WMUoyM+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(1076003)(2616005)(2906002)(186003)(6512007)(26005)(6506007)(86362001)(508600001)(33656002)(6486002)(6916009)(316002)(54906003)(36756003)(38100700002)(66946007)(66556008)(8936002)(66476007)(7416002)(4326008)(8676002)(5660300002)(21314003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JhShsBMivgnRoBrEKFNsyAFwc+Ur5tfKG9ZklfgR2vvmkoaXwSwz9x4VAEVw?=
 =?us-ascii?Q?y95mrjS396yo1RKYIg51nSQKHtXjdPImkXohmxKrLxt3feaHxWSSSPumhxjx?=
 =?us-ascii?Q?F4mkcG4zbqYz1luvjs+rM2yWQESk33Su6R6jEz8GmeC4nxykQQ22YgK2fc8Z?=
 =?us-ascii?Q?A3gBqFDKLTgOLX7lpB4I7PU0k+6B9B1ioiPvDr1Vk4tcczXMLXXelujIWjmA?=
 =?us-ascii?Q?8l5llSOjiQlt2Hk1dd2zzK/KOEsDF/iar6j9WLFAzt5YVTISk/9CZ/yDPCBE?=
 =?us-ascii?Q?TL5GJifAMnTgdAK2O4UNmpEkhsYtJVcOrh+uBG3Uq7HQ/jOToQJprffYVIxs?=
 =?us-ascii?Q?lKdeTPETObrW4h/Y9UhkI9VWNQ45oG9GkPv+eU8fPiGyKd6OKKt0BH5NZgfR?=
 =?us-ascii?Q?XB5sDliKT5sMXQZRQMgqxFxskma8t3llpa9/sSrT5ZC9qXLyZsZT7B0b7kWj?=
 =?us-ascii?Q?w3EqWX5TtZdXI3aqHZHvQtgjzqb5rZfvwnGcc8RmIulRo8JK4vOJFOvmVtci?=
 =?us-ascii?Q?sCUQZ0uhn8Lhm4mGtTpxDS+TwpEFIv8jHFHp0tPXBqkTcLz+sruAB445qkte?=
 =?us-ascii?Q?NQUy2aZwXEnAWAMvIK6gRVXTgWitjUIs2L2HCNJEg2UeY4nJlyE17zYCaOx4?=
 =?us-ascii?Q?nfHJT6zGanvJzzYBVs+b8e1CIi6xKTApKlNAIKcOZ+qIjiEgWgbbUie8qvIG?=
 =?us-ascii?Q?5VhSBT+oQR3FuuwYONdiu3ErA/yj0aBGN8Ms916kiLw9LVoD5iIAVhxWxK64?=
 =?us-ascii?Q?PFDB5dO814xWBInabyueer/LnOyaN8li66hA/5Hnxi3wexClPjAKBnqNCl0y?=
 =?us-ascii?Q?/m7XTcYKbjy/hLtTDz4FrkfLMiHDhxhV5RFxb8UmgDrZCwSoatfLskszS3dp?=
 =?us-ascii?Q?njDvqWSI90y8A1x7rC73XZl6NtBqcY4Wk44eTe5R2Ebb36R+2BCnX5SUv4kH?=
 =?us-ascii?Q?Yru0sgb39ST1k+EmMCVjCSoz4qe22htjDc6X+6Xrrq9GCpMcjVoxBadLnGYX?=
 =?us-ascii?Q?bq3S3a0NcqnxEnYfuAaBrExnV4+qo1RtgRQd9AD9AAsNDktPWX4iYVyzhVVW?=
 =?us-ascii?Q?T6SXk6aeMky940n+fCe86s85tcn8ssTqZESWgPT/zGyY/XkitPMnk2lOuf19?=
 =?us-ascii?Q?ydwQyFwFtKTYHp25JlULgHMvazYsBfgeoahjc5ft8YMSzrRfE3QtoIFqSgyX?=
 =?us-ascii?Q?FW7QmevL/ABW+oPgeTuwXvfCaRVRnRLWZEij0yEbxmLcKdQdZZpomT+/TKXH?=
 =?us-ascii?Q?RmR8sskO675hlDH1wiO4ROy8fFvQOa/lT76jX94iawZizlQIAVdU0Trtrctn?=
 =?us-ascii?Q?wbJWQjQGVmC49jLJkFhUVlNroSKQSUfxhunBIlzFxaIHxLYgq2efZ4DOccWT?=
 =?us-ascii?Q?YLR+FD9sNN4q127KGenT2Wnma9SwvC/+cww+MwbrfSfvjoSRmj4z93aN7SpC?=
 =?us-ascii?Q?SzlWgH7xqT7pLLHyVVloDrMSEkGtNgJxv1+Dj09Q2Z9B9c74vQN/m6G7an9r?=
 =?us-ascii?Q?t8QkdyaDXF34c4h1YJ2L795MsoYYiDMwDJrWJaRHEJdcaTylq6FlkaVSWYOa?=
 =?us-ascii?Q?BuYGA27q7kMK8QLvNHqTPR8wcFuGpM79EcBcZmb5Louikg57hCx3ybMnQpdz?=
 =?us-ascii?Q?z4/Yn33yuLHF1gGzKmG3XF0ikXck/BcIGKplHu3T5VqpauITKseh2s6ushko?=
 =?us-ascii?Q?w96Ghy3cmD8kAuGqn8z2FQxUlFTxnNQ60nr9M7DP/+sm2s9D44ybarPbKU5O?=
 =?us-ascii?Q?nC8ndpwY0Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f0d76a9-4126-4570-ebd9-08da29d91fdb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 12:09:34.6900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtbGPNyhFDkhb6MsL+rshSHAJcptkJW3GzT2TXC/Sb2x9KfEbV8dZ0YBUOe8Gfvo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1621
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 11:54:16AM +0100, Joao Martins wrote:
> On 4/29/22 09:12, Tian, Kevin wrote:
> >> From: Joao Martins <joao.m.martins@oracle.com>
> >> Sent: Friday, April 29, 2022 5:09 AM
> > [...]
> >> +
> >> +static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
> >> +				      struct iommufd_dirty_data *bitmap)
> > 
> > In a glance this function and all previous helpers doesn't rely on any
> > iommufd objects except that the new structures are named as
> > iommufd_xxx. 
> > 
> > I wonder whether moving all of them to the iommu layer would make
> > more sense here.
> > 
> I suppose, instinctively, I was trying to make this tie to iommufd only,
> to avoid getting it called in cases we don't except when made as a generic
> exported kernel facility.
> 
> (note: iommufd can be built as a module).

Yeah, I think that is a reasonable reason to put iommufd only stuff in
iommufd.ko rather than bloat the static kernel.

You could put it in a new .c file though so there is some logical
modularity?

Jason
