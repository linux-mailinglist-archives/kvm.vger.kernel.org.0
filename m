Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26368754897
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 15:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjGONE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jul 2023 09:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjGONE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jul 2023 09:04:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9D635B7;
        Sat, 15 Jul 2023 06:04:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCy3bf1Xfik0WnQALtofqrCQSjbEbHw/X5HcIrxdMQlSB7yHlLQVIuzuok24rEB/lE8c8Ii6ymHJLot82rJwTInAoSZg5zk/YnZQS7EHw2DVy7bpjNnl4H+Jfvrmt0KveTX3TRJxeR63/eIBJuVlCFCJyoVNLygz57AjcsbCXVfpqgZvOkcd5P+0N68diANanRVNWVG5nVYLbPePn+eYtLxzzbC9vtMhj24DF5vHw7Dq1EwLc+AMmDpLyndzse6B18jO/LMupLLHHuygGu9h8hAMj5oHEdu0kdWhB6J3dhmeG3eF6LjP7I5yIwHdW93KTh7qOCRnpTgksmU5WYoRUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AjjyiQIl9z5eq8vAP02WnDpkV/cVEDm74gNuAl00+4=;
 b=FPEG1RZaT1UsNyjsZoawZ4lkk5gLbEHOBhljAYmtSOBXukhIYPX/jkr15icQ2vM1hIYS0/Z7rqpcfybxU6Z+WYBkTqc81sMKy21eFr8Wo7oraSMLaCPuVfpiOR2JYmLf2XJq1RGtZhhcvOziwmNoQ/jj+tkoLPBYoEBIv0thm2/jy4eUWfSXEnPIGYUYIvoNBDLuLTBxepB+6ndHEZpDTqsi3nKED2ZwOJPjkBOPU8kXVbQcwQA84xgODnjfshnC00Y5R6UIKGB9RwQ/pyjZkLxa+/VnIzZRAmJvvccpmbvlIkkY28hKgdGBQ1qgH0zcnX8Ejcpzz/tTOT/B49ndzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AjjyiQIl9z5eq8vAP02WnDpkV/cVEDm74gNuAl00+4=;
 b=QiPKAeGKLRB5X7I55VVpwYwryxW3Lynjbs2hjZ4ueWT6+psT+883m0Jw9mFcwUyc2OjGBg5PkWHJp3McJ6qPXzTv9xRG6JlTYjN7sUkPsI2DJT8jEI8UQ6BAJgM+P7x+mdriirHEvHj8kOvV4fXaUPZnEaQpzm619yhvCZqPL8kDZA4CI2A0YQSj4lmjMAvqOxZCC4xt3QX3rbDEpo19B48zJe+PongCn0WHk+RGqqUFFjmcdLCm43s+BOuHJ9hJSRMN16VhX9oAjTr1X+oX3Sf1aUoiz8tUDCNAcndb22WybqDPuVGUwDg+TgAUYyfWoKfFctEISk0d2lENijYVzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7902.namprd12.prod.outlook.com (2603:10b6:806:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Sat, 15 Jul
 2023 13:04:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6588.028; Sat, 15 Jul 2023
 13:04:53 +0000
Date:   Sat, 15 Jul 2023 10:04:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v14 22/26] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZLKZc/wnMbrp9ZYE@nvidia.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-23-yi.l.liu@intel.com>
 <ZLFewHxO8DSelEml@nvidia.com>
 <DS0PR11MB75297BF68F3FAD4B9EEA483AC335A@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75297BF68F3FAD4B9EEA483AC335A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT1PR01CA0128.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: b33dfda5-8962-4bfe-a298-08db853414b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jAOUi8EKkF2YkZc/qN89zCIbLyTSPPCUfA0TUlsUekkGkkE7x8dvzsMS3ZVQcuCoIwzTjKcMsJrQcVF63tjabiKgjKS+ApgpMpEJrEZIm0pbyiqvSEi+N72sYtcjrmmFHmqNSLjKMhTcX5qkQQhNu5B/XxnBRG2hfxjKVGiPwk667/7I6e/nFzlcH202E5D2DoACI6zYMBhNkwtompmR9OgglsFaYhDgBR90EXdUxFlOHB/RhDhovUfl9nCjcMg1JOLgGMbuLonACqgXkHJxy+9Islgb0oJXWExMDfeRcU11+KO3EqkvEzenDETJcSonMp0+NmyZVazzJdDNihqyOru6VSn+v8Y7cmDokFdP6Ivcz4KppyJw1F/XO8epOXLg82GqyihpuM2ISxfDXoXaCNo601HPtM+HDmKt6lNmEqPTS/kggxwanzUddEc3oKwkKPH8vBe0HDOzQ3IegDVdvqL+360q5wPyCK+OVNjIpR6E19owghnPJRfMG8Tz3ov0C8PL7+Jeib4q46f101pVXo1PNtpv3N7DxNMZ6Zx8qzMeUKt4Inl/FJtevUteFXy9lJS2tQaoBZ4LYo8FRpmSoGoWtatcZhzisxbAW3b1/u0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(451199021)(38100700002)(86362001)(36756003)(316002)(26005)(8676002)(54906003)(7416002)(5660300002)(41300700001)(6506007)(186003)(8936002)(2616005)(4744005)(2906002)(6916009)(4326008)(6486002)(478600001)(6512007)(66946007)(66556008)(66476007)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ne5pXzFio6XcLsvGcnu0cxT6lLeLiscj7Isy9CrisRs0ZSmj007cpwS6/5tI?=
 =?us-ascii?Q?xkw9tfd2dmx4EK4ObfToON+K20rk0FrDsDd2cKT7L0CemOv1lEVY277CEmab?=
 =?us-ascii?Q?3GxjYa62iIt/gNiBCZb9bhjkQuKjEXVqM6pIjIoNzUyO0H2vNi0Gn6hFMjEI?=
 =?us-ascii?Q?Np1OzMi45l/z3CQZnZAoUZgPmcettxjoGBFj0di0vJzwAnErU81aJYL8QVIq?=
 =?us-ascii?Q?RgEu8aFFre26LU4le5t4Fzz+vbLyLr2zDogMvAw4Jb/D8maw5JxIOnUNSGju?=
 =?us-ascii?Q?EzIDM+O1bEvItODIgeHsITZsWCBrI2fsH4Y6Ir9VZbRvP2HmqOqcbZUady7G?=
 =?us-ascii?Q?+HRP/VlpvZ3SggZaGPyhLkLi1b7pUUfdTR7hGVTd92FGxbhqJGOQluWQh3+D?=
 =?us-ascii?Q?801Np+O4CTXbIbckzHNI6wLuOnpakS+Ivb9FybLp+rjRLq6EVd/YEthMhB88?=
 =?us-ascii?Q?qZk0c761mSP2IrsCj66U6pUj0awgMR1tZKFBkrtEKL99nNEzq0MQKOqniKvY?=
 =?us-ascii?Q?anqzPECSPGEjGto4OSFeI4FJpqApR8S/arhW/oSiXOUKRj7cEbjVRmLUwfwc?=
 =?us-ascii?Q?FfyBnLxoCY1WEO81DKFlgH+vpMCOFtnVjgOFQJ+bto6g/qv1UELdRD3oMq1v?=
 =?us-ascii?Q?1boVDdGCUNbw99ETeBRgd0njjDic2+EBJcNNMirzxhzzvDf5UIdijQxTOj4V?=
 =?us-ascii?Q?q75RywntrIhlu4Ls5URn+QhOJKaiOdOil/T70zK9na6SDGxr/D2vIHb3dDMm?=
 =?us-ascii?Q?Zvl16Rj48JQ/8d3i2/w3w6zw8edwaBSjmXk4wIYj7ds7SKk5JjNXDg4AH1IB?=
 =?us-ascii?Q?4Kt/l7Leq0n8w1hrjH4rKz0H3P0uBhcLTb7qrJ0bYCAKxkisZEIiIxWUfuov?=
 =?us-ascii?Q?CIeK1qgU9IGuy6PUvokEX3FKXYgyzoOntqpg4CLdVpg2chnKubkZCrfc6Pfy?=
 =?us-ascii?Q?Qaa2/KSwJoiiTcM9EOO736sug2VDR0hVhzLD07NnbmwW9rUukpMDzmOaglTc?=
 =?us-ascii?Q?WjyDEtrEIh2KvAdjFeb2p3k7xnXqVQxbSkymnsz3eIsvi+JPXXdrdsjEY+92?=
 =?us-ascii?Q?cJCViUhArtOfL/z7F1QAkhX2MUpuBUXQSrZXDVQtein2gU0wlYI+yxCjYIt5?=
 =?us-ascii?Q?8fQjigy2aP936wDtTS7CzDxKHVKdlE5dANy24NbNU9DNLlOHEhhWsrG6d98q?=
 =?us-ascii?Q?6pv2dcBTUs9zzIyyhE5oiZqkV9Ju+4KQOlTpPIJ7Mn2WxI7kKsrINRx/KP1V?=
 =?us-ascii?Q?ewu0MvVgl78iFruKYSjBQ4bcHTvkGc2fn6YQLkHittdGMiht/gq6pXknwa8m?=
 =?us-ascii?Q?figQbQlYLeXOxbnbjMW3qWYZ3h8wZrVnCn6Octg2aSlt6qoXzGVL1Zvt6NpB?=
 =?us-ascii?Q?/s2R1MR/SWPuNf1uhMejys4BR7MpSQHvEbmJh5x4OAQTGETiFRF99mCJVPCZ?=
 =?us-ascii?Q?da+f01sIBVqJfQszb1exC/N52I1wMwFXFfIzLLePaNrV2/J1jzrIvFOtA1nC?=
 =?us-ascii?Q?En5dbXa6+vw+wC4ZC7B9p591eyuIf4Dl92ndjYCVio46naEqlD4e+0SzA531?=
 =?us-ascii?Q?8mS5Ga60HaRgZlwS8ZFt4a8vLzIAxUXtyQobk8pf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33dfda5-8962-4bfe-a298-08db853414b1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2023 13:04:53.8128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iLES/vMSokNfH/fuXxwBg/f43rWzbJkUvTSMaTkESeP8NDPghl5qOrtFnFWLn0H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7902
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 15, 2023 at 04:16:52AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, July 14, 2023 10:42 PM
> > 
> > On Mon, Jul 10, 2023 at 07:59:24PM -0700, Yi Liu wrote:
> > 
> > > +static inline long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +					      struct vfio_device_bind_iommufd __user
> > *arg)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > 
> > This should be -ENOTTY
> 
> Okay. Since there are quite a few stub functions in the drivers/vfio/vfio.h.
> Let me check the rule. All the stub functions should return -ENOTTY in
> the !IS_ENABLED(CONFIG_XXX) case, if the function returns int., is
> it?

No, just ioctl returns ENOTTY, so really just this function.

Jason
