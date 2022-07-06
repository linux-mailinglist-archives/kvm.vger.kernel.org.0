Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49396569182
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 20:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiGFSPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 14:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiGFSPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 14:15:39 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2078.outbound.protection.outlook.com [40.107.96.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDFF5FF0;
        Wed,  6 Jul 2022 11:15:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6tdbrQZwy1EALh+WeIRcr2ZRX+gTVnamo3wd+s+Hlq2IZrReX555uNbf+DhjL5K6UrzqOLy1/BGeu4/ZdXgK+7pBC3DvLWgQ+ozdo6SxE/eHH4Uu3YM4RjZ0bAPqG5VzVfS4OK8jWnS+QhgnTFxe4G8uQyCojLtBGkWNhZbbDw+Ue3K6RQhp8rWI4OA+EMAPrfbjMrDbkgZKbq7sZiH6nSkUICJXEexuHDzud/azuDWq6Bxht6lD4qDnATSHlrUiTlgi1dJx/4psbzNfrKyE3w3bS5+9VBzvBxbn0H+VEv/fUmAluGtgHc35GmaRLOmQVeuUKR30Imal+ST4hZYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHTWi9wBbPiA86pL11ydanPCadwNaja7MH7iXDeYKm4=;
 b=Uk9rodDVggrxKRQo33sAFmJjQcLKePJvQY8RAo507Yo5YHAEGK2m/6pPFQpl6XZANKH7gJK2P6MaGtk1x7NhVQ+OJHBo3xM4xzouaExt/4YWgTPtOIO1EVBmntVCG/1Hz8Cph2RLukoyLmbY2W8VHvgt5ZGdiM9qrUQRxPJPL/c/Gnb60d87rF1NP0+kBlnG5Dn1rD8mVRKL0Si3b55HdoeNoUJDulx9rZLpqIE+i9/XmCp5tRcsdPpINxqv20l6Z2RFi/6ozDB9f2M9wgI1GUiNoSY9j/Hg421bO30cLpzPjT9JAtOn8wvWeF3RqBHprS9xoNxneAseZd6yC0+5xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHTWi9wBbPiA86pL11ydanPCadwNaja7MH7iXDeYKm4=;
 b=VSqzNlpAnX8iTXTNJ6ggCqu250+rC/9Nx0As3TMD1TNXO0NlLQk6c80zuFJbPpBEagtY+D+FKYlQAfRDSQauW7BoZVhA4FxF1P7i7H6NIlp2YTX7cZ2XDuLOfkmmgthsBMiICq8JvvtuaYs0sKwaJzlCguJsrlm2NNY1RKgVi/25mDsIgpInJFLaGLgr/yVtfJLoFkhs9bWaUHmm88PFdFjm1aGmr4d9Hgc/T4B2YndI0Xo6uVw7ffIw48ljf4XCj1VfukPznh8/ifizE+AAN2O2+LHAs3I+mWv6hx2tz+a5GV5GJXPvf14iOq9+IjtMnTOlbz4U7C7I3Z5UxXEI1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB6149.namprd12.prod.outlook.com (2603:10b6:208:3c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 18:15:36 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 18:15:36 +0000
Date:   Wed, 6 Jul 2022 15:15:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     kwankhede@nvidia.com, corbet@lwn.net, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, hch@infradead.org, jchrist@linux.ibm.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v2 7/9] vfio: Rename user_iova of vfio_dma_rw()
Message-ID: <20220706181534.GO693670@nvidia.com>
References: <20220706062759.24946-1-nicolinc@nvidia.com>
 <20220706062759.24946-8-nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706062759.24946-8-nicolinc@nvidia.com>
X-ClientProxiedBy: BL0PR0102CA0015.prod.exchangelabs.com
 (2603:10b6:207:18::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d80e043f-c1bc-4bf6-a6b2-08da5f7b85fe
X-MS-TrafficTypeDiagnostic: MN0PR12MB6149:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YEhnC7iPzTel/SYXLWvTFdV6991RlSMlUquMcgWKiqGvU3v92aF3V1y1IvfidtJ3kXPDpxs0pauNC+PCTTrJPtP73kKs27ZVS7zGgySN1w1LjosMXKFgk8LGIpaYJJl8Dzud1Ja325Aw/YCEYRw9qtgn8nUjGN9mEqab6rqCpAnteUhOC9MHeKTYm7Exk/z17XGDM17EzUZOwtLAEP3qZdU60Uvr+Yc1GSTLfaJO24NM83Dw4oYVq9Hb6rPGQ1OOQJrbhKZNg7fLSxqVLdjnrNUiohBZEdH9Boa5AFmIOMcMuBrEc2wzFvXcaa5JPy7H8oFWqj4q+IkjB8cOSnhblt32S58D3a1l48s8OlYrvwdj30GVUDfEYeCFTag80EpzTIZ4bVTCMBULN/vl0BJMx4IfmKoB0zhJUz+jaKawxDMscgOpVmwxFU/KWfDZCHr+0UZNpaRcZk8qN5//1YLlOlpBBetJjSySgeetv7eNkCH1tO8LcxVHEa3I15w1XXRZMMoR+P2hCCLvCL8M/WmbjnG1erwOVyaDgEVymuIyRdP6z4xXyO0b8a1nib/DeeKiaIriOTINREY1jWQKXHyz4xrR6E+AxzJ6sRXGRDnUmAQY+Rj2ZuBQUGqGQlhpXoH8STxH14tidl0ysc1TaQk/F8eai5tJBtI8DIfkGoZf6FfKKeSUTqZsOoZm+pN6lhKwKS2HSLtJRRM0GA5J7I0NbYcsDIyxrwH3nyYLkQatLNsmZTgMjxejkmsrrE1d5e+Vh9GJ682FH7QNJdVQSiOkvc4rTokxtqJaxJdGS31rdX7aCiqj5aIghnbzMw073qTA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(6862004)(8936002)(7416002)(5660300002)(86362001)(66476007)(66556008)(7406005)(8676002)(41300700001)(6636002)(4326008)(37006003)(66946007)(316002)(4744005)(2616005)(186003)(478600001)(26005)(36756003)(6486002)(6512007)(6506007)(2906002)(33656002)(38100700002)(83380400001)(1076003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PRrBM3gxJnOqmOxhQKM62yXSALPgy5G04+kajMt2N+tOoqaiAZkdkDO/y05w?=
 =?us-ascii?Q?Le5uATqGTAOekbmwKnIi30ydCfreEzqNMAR7JZ2nna+ZFj0v2FW1NUk6U0gF?=
 =?us-ascii?Q?d3SNWG9kpDTC4SSTdFdU3dhtwx893lAxVDxPImohzHrjoGq3MY3yIuhpKO6Q?=
 =?us-ascii?Q?FGGF6nvz/e+EqMx6VDb/Vlk9ugdnVn6z24FQ50c2gy51v+9FDQXfpz8Sni9U?=
 =?us-ascii?Q?+b64IUgfJ9/EEq/VZmBjZ5EvPpSifpa5kt2kuz//Pf83r7ZDHzB9Mx2NuEBb?=
 =?us-ascii?Q?ElJSkoAS3ufi130KqC3yWjAYot8DQlflEN77Qi59/FxPEzwrz+1332F7FfP3?=
 =?us-ascii?Q?8wli8Ww4Z4GSKx78rDVjYjSyb0M9q/36b+GWTyRfu8x4IxCAv1B+LhkPbXtI?=
 =?us-ascii?Q?TkfNuWk/vsVgoqw0XvF71KsbgzY7OpTWVUOM5CfHKI5wdOrL9tHONz+1/m37?=
 =?us-ascii?Q?XBkq/Zo+TYSCGjwMuO7eo+T0sV16qggMC/AScx0tj4f/k/s1onsdhwyw+UB5?=
 =?us-ascii?Q?GEbKlXf7ZuvOORBlBMaLxi3JQxLv6Enb6BI6UyjzImnnpWfJG0WiCv6834VS?=
 =?us-ascii?Q?miqh3w5r8hd+nXMVa3kTE20opBAGmCE18iDnRcf7nWN6IthN7h/R2Wa/DJim?=
 =?us-ascii?Q?fe2KRffiGxjjZYriiojNoI8EpG5/6AuZ/fsfamPccS5fQVj/MwlC9yS87EJt?=
 =?us-ascii?Q?6sQS+j1IdiTBhIOpa7ZLf6nmSBPgdpx+ymbuaiYCit4TthISaV1M5tlxtO5R?=
 =?us-ascii?Q?AT7qIofFCJmhJEmBVlfPayJkQof0eL5ooA+kciNO1fGehGoyKc1GCxXJ6mEi?=
 =?us-ascii?Q?ANdjf60sqaXrUFIZTG+g6aaZwZzgr7o1+JWQq5JgUdaaLBFAQGE7CYhHOv+7?=
 =?us-ascii?Q?dUCXWVRMPUln/DTOS7y8RDPJNfLuLyb8rwrmaI7zB+iooIfPe0zV2oBmN+GQ?=
 =?us-ascii?Q?NjnDUDM5cvVQ8KPFrqJ4dKw7vafYR8qh2DMIYUa0/Yx5Ckeu8pM4AfOH6EMZ?=
 =?us-ascii?Q?D0VME86zmfKWrAHmspZbHIAvUx//na8womP9j76PYgnTIs4ZQ6pU0leIc3fc?=
 =?us-ascii?Q?qe42DxD+ppxxn9b7w26BXnQTbc74D53gsWfQDrvsvcemRTZw1dmiZKXCT4yp?=
 =?us-ascii?Q?jhL6+BEOIyiWA9iAWORG1IC6iP7QFFC71f4DZaXKY4qVZjTBrMPUGDC+0GNW?=
 =?us-ascii?Q?7+GoDpIpPjRO9jEGdKJRrovRZR51bMU6ZluNkMMz8gB2znInH0CwF3fLDVxe?=
 =?us-ascii?Q?0EXjt3FiF3FnHyxkfowaYmrlXPj8PudoSJ7beQm24HEJ/6MBhYP8Ix2y6o6k?=
 =?us-ascii?Q?JgTTIWSR99+Py3lsojjtXUnsALl/wzhVhCVUwERz0Bt7619btUsPOK32NXY9?=
 =?us-ascii?Q?FKyTdo7B/KfODMn1MvEpDDV1yeAuq33TjRbCKHGQ7L+nJgiId+rgrN/DYNq6?=
 =?us-ascii?Q?aDZhfFljNnjPEJOECx3hyTC/cWuLw9dXEZUQxGpun/drqnFN5HoeL8OJFxc6?=
 =?us-ascii?Q?BJ6SEdeCFnFKxUC99UEdQM9jCBUyPsZIaR4TnVMF78McfbmXCnNqUrthOq5N?=
 =?us-ascii?Q?zcyu8D3mveCy7fZGXzXjt3Cow2wM96f9fnE6AEew?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d80e043f-c1bc-4bf6-a6b2-08da5f7b85fe
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 18:15:36.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSELiQIX9taY+KDbw7BZMDQmZbSmbmZiCn6CuLbG733ytacBe66TEcDkU1RP4kpa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6149
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 05, 2022 at 11:27:57PM -0700, Nicolin Chen wrote:
> Following the updated vfio_pin/unpin_pages(), use the simpler "iova".
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/vfio/vfio.c  | 6 +++---
>  include/linux/vfio.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
