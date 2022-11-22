Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71AD633286
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 02:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiKVB7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 20:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiKVB7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 20:59:32 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4FED2F7F
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 17:59:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpT6i6NTlU00BMYdIoUzT4ndeiPo8gqW/A6pfOjcQKSm4saqWcNUrR7bMDdN46YzBzY66zKICvrD2EEF/v3N6xvSIqoBfuCpmelhAHQcIFsIhVtBaJs5+kuOEZyWCvB0sxS6He/khUKhdLYfExnkQXJJRRGjUSVp5qqoa9C223omOtFnWbkLjSM1x/Ky2i92iLVU4eUCiubG9h8SyiMNK1Y0sqnN7QOrFMIBwi5fBv2avf1OHStViJKVoGMNT9hfaUNaHcUCagxpyyTw+zTtluTAnTHS0+bGPpb+H1UtOJYvUueWV99jFsuJ+/aMmzdV6giuV5AMUCjsIwoOj9cKHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pv2DRWR2LLALEDGP3gstxV0HcdF1Ow081Ex0DIiO3No=;
 b=TFAL6JGIlF9OprJGHoSKCUrauLK57qXJ7Vbe0Y+BeY5fP8tACl1bkyKHIdeSJKwml9pbuLyIUAWbaH6+VI5U8RKmdvbAIfL2+H3TcMHsExrO0QsJuwd1jDIXMo3B5O5WS6rIhvIqCY3YnaS1vsIqlPN45ek/yA5SJl4xpIl0ZeWn4CgAla3fREmamzJ7U2jhq08qvZtcUFNzp7byCMSdFouDLDMm09sljxmmEg3EYoafqARifvGnx4a/Dh5yvbCmYD7KVEYXSe30n4muDkNC3Uktg9OH46Z1yvyg4hYT5pfwRYWTYdDWm8X/0f2nWqWxMwxjAtx09pLNJ0HU7k+syg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pv2DRWR2LLALEDGP3gstxV0HcdF1Ow081Ex0DIiO3No=;
 b=iK42Xo4Tai5smxhAqggmvgx7nXZ/JP+S0LCFB14ky5sP//AagIZ+/8C4kXpiz2n5okQPH0oz8GxL0XZSGvxSHJVrDZDMJc8/V6atFa+CwkBtG7tk7Wp6zvrpCCTuKVdbCgH43mad0xNamknOYFoxT6dJTZ6PYTB+E40unTAO1yRJd/IxTofecw0Bqo6Ih4s3TBai+9RqH4ks+VoNyYi4ibgdBUiRIwqjSFJC7Px4Lo+ZlRxbY2S7ryb4EoXY0uSC1E+n9dKv+Cb20inz0bmBnGr6o+AkTIW74FrOHyEBdoPdHUbZU5gk2MuCFA0/IVYpnQ2xbMkbnKPwdLmFYqglnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6459.namprd12.prod.outlook.com (2603:10b6:208:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 22 Nov
 2022 01:59:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 01:59:29 +0000
Date:   Mon, 21 Nov 2022 21:59:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Message-ID: <Y3wtAPTqKJLxBRBg@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
 <Y3embh+09Fqu26wJ@nvidia.com>
 <20221118133646.7c6421e7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118133646.7c6421e7.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAP220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f6b3f4-4602-40f6-03a2-08dacc2d30cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+MJ1mlQ3FaJHxSdDLV1Wmr/+EVsP9R8Myx9C9kD7Jxgb4fNaqZvPjs34v445zQRN7aUXxC6uR23C4Y/A39uVIyZ+85eUpFaRq/Aq6uerG0UDQREyA/mlldnCPJZ39ePk/+AbMLmkAMAQb8gExRtI1RjX4Y3yGs6yLZ1lmqmpO2pck6O69dqR3s3UqvDoob0aDNojjB9tBSnutTQT3BcPiCnQHGsovNIHgXFajn6GhrNIxr1ZmtxCRdx+Dc36cX2yUYGbmo3wKrwtoOgapIVgyU1dl6ptoV4oIQtARUHCfxnjwp3mWr08mBiAJ6LUwYxnI/az/AwSNKQc7j2YXK6C1hQZkN+YOChYkvaadgzBxdvfz6V+kLVDuxIFBCFZb2ga1UQiiW7WymvuRD8L8tI3RyZKRFs5hoeZQbYFIY0FR6UPCMvUrSARCYci3C7kld8bL6oCF2CikAszWi5NHmQFoTywP3S33F3EgX4E7mN+7PtBdI5+69OuiLl1nJT6BSH/92r2aEJZxK4oQrClm+vef57blwajeEiilThzMpX9RzzqVEpWQ8MVMiWkRZfnQJ6Js1qwh5x+dTamvehD+tOgYdbi1XblRLfNJMolWOwDIYiJPUNc5/hRslH9FqMZ624HEwmQiM8wTHsNyM2QOBLdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199015)(38100700002)(83380400001)(86362001)(66476007)(5660300002)(7416002)(8676002)(6486002)(478600001)(8936002)(41300700001)(66946007)(316002)(6916009)(66556008)(4326008)(2616005)(2906002)(6512007)(54906003)(186003)(26005)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OzI3r+PEvB0DbU7nz1B8TU0iFZqMM3Nr+m+h9siouvpLd0u3Asr+mqzmQwkz?=
 =?us-ascii?Q?vsouUZP+IpbgFgW7RKhPT9uXopvDG7o0O5emIoJkj7IvelnALuwXFEAndNct?=
 =?us-ascii?Q?Kqcw3JNykG3qFmHPN4uKGkqIqq2ZmmjCM6XEVhicuQC2IdbUpG+5hStj0p/b?=
 =?us-ascii?Q?U3mWgCHOnVb4YJcfOZ1I3zu5GZJLsE8RVH+sFcQAEhGBgv9zgIkzXyXB4BAU?=
 =?us-ascii?Q?ccfQzyan6IKtQpnPbZI+UvcfSIIEzOIaztR/CA4EGmyUn1fu7QYgevvugH5G?=
 =?us-ascii?Q?Ex+A6gW85/iU5nkuVQiJJxRqAUlFmCQo/hdGiXPZ3HnrbL86ICNZ1SvGzhbw?=
 =?us-ascii?Q?quwL2x3/PmuBVkMly2mKgEtRuFIKk9HDw7Y6fg/yjtjBj45WteymnJ6mvR63?=
 =?us-ascii?Q?FIWPSzRbkixvsKDVpLWDWEKLnARb06Ns0kA2+n27yy7h+npShp4ssNiHSTjN?=
 =?us-ascii?Q?g4y6RSGkxrPStWyN/Lp+ZnC5WxjWpDzxnjt5BqEvrYdOSlIOqjq5z380Z332?=
 =?us-ascii?Q?pTYn8S+sZOWfv8lsfxWBhzYuKrDbwEAbekOHvnKN+CmxGy2EFt1UYwqXP4Xi?=
 =?us-ascii?Q?sno7wr6UMG/Pm54Pp6LWdBscWuGv4CMZslO97liWCQtGvy0onhHySdxtimr8?=
 =?us-ascii?Q?WXlKUUhcruw++S4t1e1m4J6Xe1bxJcLa6Wx1nr3znn4kL7o2dU+DucptafVW?=
 =?us-ascii?Q?TyUMdBpBy/ZbSt3k1BF+I360kFkvkXtcgbfjcb9qt+F4Gue2JPiinsRfAoK0?=
 =?us-ascii?Q?sEpKcJEF7LZUIXHMh/Akfp64EnT9MUJRcgfoIGtGZYo+CE7/HMdl7MQnwOvL?=
 =?us-ascii?Q?7FeV0atCQEgCvFrs9aVq3ZupDD6tvWtxLs6mYzY5YGt4PdlgvVYoHARduvnO?=
 =?us-ascii?Q?ihpDEkZuwQ8fEE336Kic8TV3tArZeFRrv8YdAuDjj9JWPaBym1Q13jxIA3jO?=
 =?us-ascii?Q?YFaXe0su14yx5tLvXYmzWolKTcEplOvUEqBcwJLs/JO/Jub+Nlz5VNTZVttS?=
 =?us-ascii?Q?cHmTuE628QiR0lkIYQDP0Nl9sIyxQOH0eC9WYvNUwPTkHcFtBAAUXlAR2wl5?=
 =?us-ascii?Q?yYRSbdJdi+DMJsIyA8uMhx56oX+7htnoF8SvG+h3VhJZPzEHE6Q0jUSm89iw?=
 =?us-ascii?Q?CmTNNhTDZOSn7PxxYLYYuJlh2PKYaTuJ9NRkdDGxbC8X5s/NA+WDqvJp1ArC?=
 =?us-ascii?Q?DSdnI42xo6xBO9qXVHYKaduahOGEs/JfXMyPULDsIrkre9spFO7Ye7lkl28D?=
 =?us-ascii?Q?6StqDInHlAuIDjj+tdIPbJJX18pL/uamYFQbwGbB/j/bHY3AQF5dEmlHW2Fk?=
 =?us-ascii?Q?vPp/DmsnPzcGxUiAlFgHDU0E3klp3Zrb5KJDQCOHybhZ3hAeIzUU6VSlfvui?=
 =?us-ascii?Q?+1e2O3MAkwp6sr+K5rQwq1Taq4/EKte8f3s7y3gNBgXTDY+jmO5XBmV90NO4?=
 =?us-ascii?Q?JprpcyNw76WOvFHNCpyi//C1lfU95GnCIwzHsG0b1ikb4vYgamXK1yjqS++t?=
 =?us-ascii?Q?Rug+wuo2EQXyc6duFOEs+1k2l3hyQ++tYZmsslU2SfZ82HEb7aJyC3reQNfN?=
 =?us-ascii?Q?+OcWxOMirHktWKZ4fkM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f6b3f4-4602-40f6-03a2-08dacc2d30cb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 01:59:29.2095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNJOV2hF277IM/x1/rup7oJPGYTP/h/uyGkF9r7ewCvcEJN66AGEfYdmqnREgVqm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6459
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 18, 2022 at 01:36:46PM -0700, Alex Williamson wrote:
> On Fri, 18 Nov 2022 11:36:14 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Nov 17, 2022 at 01:14:51PM -0700, Alex Williamson wrote:
> > > On Wed, 16 Nov 2022 17:05:29 -0400
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > This legacy module knob has become uAPI, when set on the vfio_iommu_type1
> > > > it disables some security protections in the iommu drivers. Move the
> > > > storage for this knob to vfio_main.c so that iommufd can access it too.
> > > > 
> > > > The may need enhancing as we learn more about how necessary
> > > > allow_unsafe_interrupts is in the current state of the world. If vfio
> > > > container is disabled then this option will not be available to the user.
> > > > 
> > > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > Tested-by: Yi Liu <yi.l.liu@intel.com>
> > > > Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> > > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > Tested-by: Yu He <yu.he@intel.com>
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > ---
> > > >  drivers/vfio/vfio.h             | 2 ++
> > > >  drivers/vfio/vfio_iommu_type1.c | 5 ++---
> > > >  drivers/vfio/vfio_main.c        | 3 +++
> > > >  3 files changed, 7 insertions(+), 3 deletions(-)  
> > > 
> > > It's really quite trivial to convert to a vfio_iommu.ko module to host
> > > a separate option for this.  Half of the patch below is undoing what's
> > > done here.  Is your only concern with this approach that we use a few
> > > KB more memory for the separate module?  
> > 
> > My main dislike is that it just seems arbitary to shunt iommufd
> > support to a module when it is always required by vfio.ko. In general
> > if you have a module that is only ever used by 1 other module, you
> > should probably just combine them. It saves memory and simplifies
> > operation (eg you don't have to unload a zoo of modules during
> > development testing)
> 
> These are all great reasons for why iommufd should host this option, as
> it's fundamentally part of the DMA isolation of the device, which vfio
> relies on iommufd to provide in this case. 

Fine, lets do that.

> > Except this, I think we still should have iommufd compat with the
> > current module ABI, so this should still get moved into vfio.ko and
> > both vfio_iommu_type1.ko and vfio_iommufd.ko should jointly manipulate
> > the same memory with their module options.
> 
> Modules implicitly interacting in this way is exactly what I find so
> terrible in the original proposal.  The idea of a stub type1 module to
> preserve that uAPI was only proposed as a known terrible solution to the
> problem.

And I take it you prefer we remove this compat code as well and just
leave the module option on vfio_type1 non-working?

> think it's fair to require a re-opt-in by the user.  In the latter
> case, userspace is intentionally choosing to use a highly compatible
> uAPI, but nonetheless, it's still a different uAPI.

Well, the later case is likely going to be a choice made by the
distribution, eg I would expect that libvirt will start automatically
favoring iommufd if it is available.

So, instructions someone might find saying to tweak the module option
and then use libvirt are going to stop working at some point.

Thanks,
Jason
