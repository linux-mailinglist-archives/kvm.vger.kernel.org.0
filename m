Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8DA565A75
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 17:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiGDP4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 11:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbiGDP4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 11:56:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60E6BC97;
        Mon,  4 Jul 2022 08:56:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArONBZTZN/Y9zNsCcBhV80wGA4K5d53a1YRmxPYko15bjwf8PmHPARVz/xIK5hVUePR7IsCBezcd9366MMAxoYAhrgtxEA96uxjwoXIBVp8k6KDnNxjyPykpbeVsE++HffktlTjHckFNOdurqea0B3B+h0UNLH7fJN+nh+MrNRKctJd5AZ2i2I7OAhxhhoaZV61eOxT6JF903buM8EcAURUmC1KTHIBucFW9B6bnRQAWULuz/+J5IJIKkT7lgUfRLAveqSVO8n/TO8fd2TygA05xg9omMYLztZkMXHSyVWRjG6uk5u0eJfK92F2wFroQaDHNrwmNCxXYtHeZ4dnACQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4sVyJE14kEqlyiVNf6YMsg4hz6eEdREcOwWDlkZqFY=;
 b=WqvG/WbnKmbcPYAfSuaJxiHr22kWLoOctaMkTgL4rCsr2fB6y6DMJJ00erR3zFJ6S1h27m3yIUsafGEC8ZBDKx+SBKrm/ftV5NeBA0YSDq2BAfjOG8XRebd662OFV6kitJJMktPHpYa/8YfcdSjuRLBxC7GeWfLeYWCIpJRTL9Sg9h3w08IpGUx8BMLQNRNxWGslAWYmv/lMqnXEuHqJh3gajD9Z4u4GUybaT6Lmub3fxXT9ot/cNNxUYzg9kEb+WXWCUVatS8+ZzIC3sOQ6VG3oGE115JhSDc55aXqh8gdLlWMgLZXV5KooVrW78Nt5oWjpUYw91Z/0P+EkTGIGmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4sVyJE14kEqlyiVNf6YMsg4hz6eEdREcOwWDlkZqFY=;
 b=trReaOy82cqpCC7pwSWFbrn6towZV1VSAJhHAR01ZlPfItpvXgafIUeqh/g5FcvJ8Al8zEmPqLgDmEVjjnMmHTgBJfTdoN16J58DRrl8FZUkLjYMFasWg1Te1BZGUzBFDtYBv5P1e2oUttcqgdgDlNmqMOtVmEekYyLLLaJXeceeiIuu5w8CMmmFk10tXkXhKFAnNiYx9elRm+HKdwlTszN9KYdrZFWv0usI2e9jj7oyjgS/QpUySyFVaaPQgV4GRTdj8/4g4BXCPPehevhj72vLuHhr1DPho5Fj+oqUUpGsu+J2tla3ZJf1Q7Kac30mHDO8RI56fApcLC3D+cCdfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4967.namprd12.prod.outlook.com (2603:10b6:a03:1de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 15:56:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 15:56:28 +0000
Date:   Mon, 4 Jul 2022 12:56:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 04/14] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Message-ID: <20220704155627.GS693670@nvidia.com>
References: <20220704125144.157288-1-hch@lst.de>
 <20220704125144.157288-5-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704125144.157288-5-hch@lst.de>
X-ClientProxiedBy: MN2PR19CA0053.namprd19.prod.outlook.com
 (2603:10b6:208:19b::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c59587fc-8a83-4ba5-3d29-08da5dd5c164
X-MS-TrafficTypeDiagnostic: BY5PR12MB4967:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qQx+RXGuamJ0fzw7EgvZo8YC09A+Q3nJ+LYH9cray3fJSPwhTVZOSTnpobfoBiFponCJlVVg2pFVkqsEEcdhomuU+d9159GQW9jxvHqJxYpMVZv44dhxyyaIPzCM9AwBN0eRNYGnWUeenLD2o1wBKbg8dYzE/VTvYM25ISkpig19SFAViJ+vG7n4Mt5FfC00hj/MZJZlkzfxMnclD5U2k6FzWxc7FOKLER2xanzGm7JPOk5Cn6qww4qDv3i1N/UnDplHHhARH++QPgb1+5v6dIs2sa5HP0/tzjbZR6BTCsriSOHhdQ+qmbBhj98vvRIC75ml1G7lw29twdQlh1IFj2Q32/eG5r2o1bUh3uqdyYlUcvx9hV48HOBCG086v1y56DVuCD1729Ci797WRvrpIt8UDJlr7j72bKIxdFyJ/FJfENRTsnr6YkyXvLkNmFEg3JkH+x1IWiviezSQ7cUaycf8wAbQ1FIA9y61OpRXVNuV1v/WZvtVMZbSqegkNyuyYCxcRMSF4D9PBBDLaTpPJcE+FjwXGV9+nNw6mds9mgHIv/NgsBruDuTmO7h2L7TWncWW+7K+BQyoeLFz946en/pw0+AKvigwrEUWnGAceKrEEZApDFjy5HxkSTNR5tbgZOZjBz8L2+oHjxxbScwYRCLP+1lV+0ubojwlVyG0VFXiivgqeRcqTCZ4+14AvO3Xklr0JcSA8d9Ru/MdeHtf8rqSWiEBSGpPZaaH3YWstP+7Ro4lcsGHgy4xExn2I3eJWUJjXtlZLGSOeHidxFXjQUMlLERHNABAnx7sCuKm0kM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(86362001)(7416002)(478600001)(6486002)(8936002)(6512007)(26005)(2906002)(33656002)(6506007)(41300700001)(5660300002)(38100700002)(2616005)(186003)(1076003)(83380400001)(36756003)(54906003)(316002)(66556008)(66946007)(4326008)(66476007)(8676002)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JXCWyUtOdg7Iod6ZQYDdE0a2Srs2hSsN2JWH0T4Kkiv+MZShZ/wK8oi4eQcx?=
 =?us-ascii?Q?lnAtz5GdElUkA6IVW9sVSWcnnwGS/GvCGme3mntyOF+/SMa+Xo/wXIlcguuE?=
 =?us-ascii?Q?e4tBsd5v0bvQyngqELsjHQEEsYIYtxtVfX9H1Ug712jFH6qwSF0WzZ2NNG9M?=
 =?us-ascii?Q?dCFAQHV8gavHIVZHkHrUY3zdLf1cUDk6xmjOfZncXJL0cUs2E+GKPx44qU0g?=
 =?us-ascii?Q?cNh4IwEwsFDXoFPOkgojoWYk44YpmSdf/78CS9518QL8Jgs28vAqvWm3cmCv?=
 =?us-ascii?Q?MACActnq7EnL20iw10Q/xL/lIg6XZITbFCWn1iKmY9x2uLo/H4NaZ7dX3jwu?=
 =?us-ascii?Q?6kYXLmL01LoaIvVRSjqChjLS9jpTqbWa6MbiD+Le2Zw45giZ9VlPqoJGKdap?=
 =?us-ascii?Q?yEpWqsb4nlzpcX4Dn51MmU0qwYnmN+rdny3V7oceFkEMJyhDfnAUzjNUmF8t?=
 =?us-ascii?Q?7eerQy3dNVtiiluiqAxknN1dZ5yL7fK7xJwbd2nTrcgc+eBKsQc2N1gsaGur?=
 =?us-ascii?Q?qWBOPIPTWG3wec7WBycUUAFUCTP9unkEjvHOX9brfjWHmh6PuWbOkRBtrHFR?=
 =?us-ascii?Q?cpOc4XKS0wi9LBbTXFRw1zoyDhPUVse6iBjfPO+5cBOhIBe0NiTHX32/e1ku?=
 =?us-ascii?Q?5gWSY0xIJlDkB+rej+aXTQkQhP9bWmlOR7c+3PzgjguBBvE/PvOKE6x+iOGm?=
 =?us-ascii?Q?3YCuZaToGhyL3aH9QcLQ/m8jxmmO9RHQirCRophDk04y3q2v2zdaDf2HuIX0?=
 =?us-ascii?Q?hvCY/Ppd3abRmwstU2ShoklQlFdCzUu4ozu9JVrkyeXZL6v85rqFrMzFnUaJ?=
 =?us-ascii?Q?r0V3BVB6iKrEnPZh4N0BWgbCEt08Ah3ZJtyX8ABtET6uwx8/gTMU+qWi8AZz?=
 =?us-ascii?Q?vdRRGb+s2OQZ7uyWnQSTtj8HHqvgiXcp777q7rA9Yul1zpnRK3+/Oaty5rRh?=
 =?us-ascii?Q?rGp3Nm8uch4z0k6NoTDVC8rwYxGPGpcktzgeTZeSL4MEyuak8ueZljH5gBg0?=
 =?us-ascii?Q?j4T3YurMniP/zDYhKAGB8FQwKNDIO3AeOnSHz4qDDvXEIwTBhCYukMVSMV5P?=
 =?us-ascii?Q?W/sCIvN8zBSGgqkvKrPvxGM5MkwKG/f3LMzxx0ucoU+DhU4ovtoOeWqzE6mT?=
 =?us-ascii?Q?jXG/AOy9uoBVcQ7k09PJBgauMP3FWu7fKKEeOFIxuPaRy830Z/A3rkILTTYi?=
 =?us-ascii?Q?VoBvbSEGwbsuxlyR3DHU8tSp94CrF1g5rR2hwfJi5567nAD4EBahksETA3Ik?=
 =?us-ascii?Q?6UDZzd8z7hKKvy6neyX+g2HNxRa/HM32K+14l8W4Sn037wtQp+UUY634HGxd?=
 =?us-ascii?Q?RFYwjPhOoWZVmSKlbMsSV3wygt2anQSv8HA0z+ffoigl1A49+B/Jlx6b49T4?=
 =?us-ascii?Q?FiqU4Vlix6tsLlx/K5ZULGylCF84Tx3fXV/wSVIzNsR+OpOB4BEMak5AX7qe?=
 =?us-ascii?Q?86Oup0aL6uDjTT1WXuDP15W/FIVYczXo8b6Q9OSqrc4BfkEGvmoTlgLtHxmW?=
 =?us-ascii?Q?4Ji9Sw9aYty3aipQegp8dQcrAT400ig4yt44BCIrh0UZg6pDkNGcv73918Ff?=
 =?us-ascii?Q?Z4vfMUCXN8CM3PrhSU9F38dujX/6Nx1EtuZOFmJZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59587fc-8a83-4ba5-3d29-08da5dd5c164
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 15:56:28.1116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hT2fCyodrJ2/0G18uqhU64y346YXSLh4gR2G5GbX7/hqxyD5Mdv4BBW5JugGco46
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4967
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 02:51:34PM +0200, Christoph Hellwig wrote:
> Simplify mdev_{un}register_device by requiring the caller to pass in
> a structure allocate as part of the parent device structure.  This
> removes the need for a list of parents and the separate mdev_parent
> refcount as we can simplify rely on the reference to the parent device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       |  12 +-
>  Documentation/s390/vfio-ap.rst                |   2 +-
>  Documentation/s390/vfio-ccw.rst               |   2 +-
>  drivers/gpu/drm/i915/gvt/gvt.h                |   2 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |   5 +-
>  drivers/s390/cio/cio.h                        |   2 +
>  drivers/s390/cio/vfio_ccw_ops.c               |   6 +-
>  drivers/s390/crypto/vfio_ap_ops.c             |   5 +-
>  drivers/s390/crypto/vfio_ap_private.h         |   1 +
>  drivers/vfio/mdev/mdev_core.c                 | 120 ++++--------------
>  drivers/vfio/mdev/mdev_private.h              |  23 ----
>  drivers/vfio/mdev/mdev_sysfs.c                |   4 +-
>  include/linux/mdev.h                          |  15 ++-
>  samples/vfio-mdev/mbochs.c                    |   5 +-
>  samples/vfio-mdev/mdpy.c                      |   5 +-
>  samples/vfio-mdev/mtty.c                      |   6 +-
>  16 files changed, 69 insertions(+), 146 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
