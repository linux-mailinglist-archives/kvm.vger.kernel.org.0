Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A85D537AA2
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbiE3MZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 08:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbiE3MZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 08:25:52 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1680E793B8;
        Mon, 30 May 2022 05:25:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wl7yMFmXYwzZHZr53YwpHH4ky7LpM2czNQaJ3EqAgtginH7Y1JDJz5OXO64hpVOEeSmIMB5sHlCc3fy8m3Nzr0FnSeO+fwDx0LZkk6PGPiM8MiW3Pq/m24sXuTPcdKUNWMbbyFetfELoWn6OIxnuL8lDfzob6wZyHML7xOTyFgriyDYxpr+Z+G3ayJES0tL/UBi8M2brzd2afB1GeZxt7tHyHFPeqK9+OQ3oDQ3xEhRMFKgp0fLZXr3y0bSEHRDo1xX5tkeC9CauQpVuj2x16uJn8wDo8+i2VEK99Cak0xnUY7LRv/0Qi2n/rwsEpwmMLmCNDjlm0oPAzaG3XcYgeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/FTsu6I5mESxaRTipXwTbMFUvin4ulgcqpIMu/1rSk=;
 b=XUH63dnmgn57E4dmrNOzSJPNAnbR65kY3ASe87Qs8R+KsLzD1eC+HyCRMgokbjLAsXesczdmAFgfphGoNaZ2EOOECgp7O5R+YLpNh+OUaN13Ey2Vy20nC7hJuuwcwUMFmPmfsPajvbI7tPue/sT8o9yG594qrIDQEyV7RgVkJnEgF6lTtKyVXIVKBHim3ITgj9QyxvF2fzdYj+4w3Vzo68BNTpK6E/4fvq3U7XeFQu+pGV8n3k06poO9W6Ql4TPSsN+osIyGoCHS4zezVhmxnKidY4eiyN0/1mzoyNRPI+TTMSLFVpYLiFdHq8dJeoKTiTgnInlJfXzFTqbme4vq2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/FTsu6I5mESxaRTipXwTbMFUvin4ulgcqpIMu/1rSk=;
 b=T6/c5euZ34S6LipMphL4SBXdWk4sSbs/3uMnpv5KOBJ2L8PHFYASe6dr+bxlNhfA2iONPZBXbNKked+CLJwSZv8Lvr/Intrcltcw/9hF4j1x8kYN/tPApkwLdsbRuCKBTokudyOwVeVLO2gAbX2x9U+WBNHQ2QsrnSHIxDD2U5i6hqhY77rWFAcG+TrAwH2kssYwQQl9rtUQxPJJNwbWRgA8zvbXbP+Xzmn7y6tRK0dXjaKROXgbXyam3mTmqXEJMmazUTltbTU4ajYCSpaLWeaAcpQc8B1/UCqyaQtJghUDLBhBSJkxXZzQDM8hO5MzUl7oRLuejsDax8jC8asbdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5405.namprd12.prod.outlook.com (2603:10b6:a03:3af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Mon, 30 May
 2022 12:25:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%7]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 12:25:47 +0000
Date:   Mon, 30 May 2022 09:25:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220530122546.GZ1343366@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
X-ClientProxiedBy: BL0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:91::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1106305f-ae42-48fd-3f5a-08da423786ab
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5405:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB54059C9D74A02E825F93ACF3C2DD9@SJ0PR12MB5405.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4L5Y4MgaClIa8OLxHKmM/EQp9+iwAOKEq2QYe13BSaQYnb5WGk8fPj74llgCDL1dl+aOAeOjdST6MiUdCHAqEOC93Odp2f15ciGGyG1MFSw48nkEyxfeA5+4QXwWhrbtDrX+KDuJfKAtUJBx4441lV1igS/0C8o4W66TOil3vYAQRICa0aW82/Yz4FkBOmYAzddjEAbV+XoDmuUb4Ge74iuH8OY4gYUQ63NjvhGZ+yNvKo1sX/U6aChjzuHZq2+4Qp7JLlMWc12GrtX0x6aOujQWXuKgwlFFgtXNlYtVCN2uRCUH0bXQmgnHr8dk/1q9xRhumBuORkoPiCQmFDI9z531XZjLR2wWCWif0rf5mxPUOuliWt6YCCP2VXkqmmiD8TU2my3MmxdRke7CWg6atcrv7xrzXPEetYnWGYIVzZSqLBDoi0FlFnNdrLUhnsZ5Ufz7tYejJ42MaXtsJWsWjQYMyN7vtQ8vFE3N6wvV1LmM/bs/KQuCcu7dsrIDWIgalKpg+as3yBdKKmyhndWPYHzNK6EaTXeMJmErhYIYCPoWx/XFuykRZvc2TP18bN9zKZOvM5YB8sl27n5SyrFT9ZI9VmysZk6tVz+cn1L1kIenfrkqlPftP/zYnUgqlROeQwg2OK2Eq6x0Wjlisq9V3mfOa2fi1TzYUF6/1GNM7bMWlwZbr7BnUauOohpZBI6171THVCi05T7905Cfm3LvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(38100700002)(186003)(2616005)(8676002)(316002)(4326008)(54906003)(6636002)(37006003)(36756003)(6862004)(66476007)(83380400001)(8936002)(6486002)(7416002)(6506007)(86362001)(508600001)(4744005)(33656002)(5660300002)(26005)(6512007)(2906002)(66556008)(66946007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?937IzUEY9ZjEkeAJUoey6dulkGmPiDf9NUhRY9HZTI3TsedHDNo8PgSXNf3a?=
 =?us-ascii?Q?xHgA/cKX06aNg1tYZNWSOjiH3TFWVUh1lhJZmTXa837ZcsrVHKsZccT5nbXT?=
 =?us-ascii?Q?osDj0EycLihTyMHGGHP14oipNA+6zMM4tmpR9GXvNNiDrZf0nZ7HYQ99apaC?=
 =?us-ascii?Q?B/eNGEA8iGk0BvLU58YZmA7Vo8DdAJltZtgPSpZaYsP10MaBpEPRJTgPUlZl?=
 =?us-ascii?Q?lfhdY/Q544tp2EDoNOhnh12SReaAL3NlKVGT2380Oqwc3fHd/Rg3c66Rp3KG?=
 =?us-ascii?Q?jAwq25WVlyvzrLVFuRTAcFRHHfQ6Xfu/dOgkQlamdToyOtn+C88SW1JHaO5/?=
 =?us-ascii?Q?ObMtwYD0AQOyHnK3kovL/f7LzPOT1zH8r4oNO1SPUNIM9lVCX7D8QAzwkE9/?=
 =?us-ascii?Q?qQiphEQq5XU9TvScWUuqZHXsBzm+nqMPe3Jw4zTwssTwOo9CeQiIyiy/2Re+?=
 =?us-ascii?Q?QzJT0aShuE+K1XF6OIPMjXG6BAB1JrNAqTFQ9xDPuWUzJNv2Py0Ks2nlZoO9?=
 =?us-ascii?Q?luQjiI/MEeQmejWkNjY9SxcdMMM7cCZAu0P1GSVryaiGhmR3PolzxfNJ84d6?=
 =?us-ascii?Q?r6uyajqqXxsXIffYzr5RJPv5tYeSmnSk/Qqt6tQJyTNmV9v0TzIbhbdx1yDP?=
 =?us-ascii?Q?l7T7A/Nx81xtevlcp72zhcg3w4CC1k506o1/fVWR2m1y8Gqg1L2fJ/kk1CuT?=
 =?us-ascii?Q?mAMRiUeLxsVUrbKq43iFrqjOV+sSnwXYry22W7GMMXQg+zpt96mRyRy3Pn2V?=
 =?us-ascii?Q?csVWaN/CEO9bHuoqxgxiyhevPp2p9ieHNkCaNOgeOXWDH/68tCgSZqDjoqxI?=
 =?us-ascii?Q?ZL09FtZNOgPKHe1au0qEiO4ka4ylivEqFv/J2pH4e0BnRj+S9aMrK+Dt93fg?=
 =?us-ascii?Q?7syv2T5i72BuGurhwxRweLf2USKSTMz2I+dKa0jqYI3JZJC6UTzHeFaOegdm?=
 =?us-ascii?Q?lpRzaYIPV2cYwm0XiYPGfogY18aEQdnH7xgvwjunopfYSrKh/UpPPuqBUxzk?=
 =?us-ascii?Q?As/vLt/B1IMNzA44dKoqDv/jFCBSB08ZbLxHy8DiYjoYLTdpQxBIZsPEMv6w?=
 =?us-ascii?Q?r4PZr/zm1Sy3JuYhSI0YKYS2VD5qRxmkWYYZN/lvPkMihzycJOmk+XBZvq2j?=
 =?us-ascii?Q?lBLD+6Em+EjSgqrX9GMBvBw+9ZqiD0S1tjC3jULpBzGjAN5ShSIntic+5n2z?=
 =?us-ascii?Q?S9UCllwTP/QBMiMNMlWWjV2mUNQjMUD0DSWcj6uB6AWo6PpSIFBLU0ZESkW9?=
 =?us-ascii?Q?17Up4+PHbzjI8yHgmNkT1Fd0gdwAtTNieaF7UExE4hZlVebZxlqj5c/9zQS7?=
 =?us-ascii?Q?nYLgKvLdNVrtohjurpJ79Lzw2PTXld+hRdWWM0v6117FHyC3VRLkGRTb8SpI?=
 =?us-ascii?Q?D59/CmV30jWT3WPH+NpI/+B8zpAU8tQb+stI94wdpPZ3BLTU+k6tl7AmZ3Ic?=
 =?us-ascii?Q?i7/7qzGL3K+YvXhA0Hg6+VHkmhOVW6f2P5eT+dHNU/dzmo+qnV2i015tVuC+?=
 =?us-ascii?Q?dkt455wzGYJvajhaVxry25sP7jpf/EZBL7VQi6PBFkbolJh4cbW+s4zoO09D?=
 =?us-ascii?Q?m+8BUhlMylp8u4fSM15V4FMCegnAp8++BK7kpDYl5gdpDcRGAzTbyove2NFF?=
 =?us-ascii?Q?/oeudqmrwF4SG4CLZiM7I6AkgJ5ehqol2KwAbdZdp63sYoIjDQ+9rrqQrIhj?=
 =?us-ascii?Q?3HnBdDo7k2O6T83+cWMm6qdAEobsEno9ddJzt3w6RVL8NF643CwlRpe0pjH0?=
 =?us-ascii?Q?cgs2TW7Gbg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1106305f-ae42-48fd-3f5a-08da423786ab
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 12:25:47.7756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sh1l+cBpcZa/3sIHJ/vdmom1CNe46ksXlz91Jl8ataZeZiIPQmoBKWkeHS3xuibE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5405
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:

>  1. In real use case, config or any other ioctl should not come along
>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
>  
>  2. Maintain some 'access_count' which will be incremented when we
>     do any config space access or ioctl.

Please don't open code locks - if you need a lock then write a proper
lock. You can use the 'try' variants to bail out in cases where that
is appropriate.

Jason
