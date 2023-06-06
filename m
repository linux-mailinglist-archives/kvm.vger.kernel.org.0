Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF437246AA
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbjFFOqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237503AbjFFOqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:46:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB8019B6;
        Tue,  6 Jun 2023 07:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NaVtNwdof6DipT+RX7p7dUAGSxjXtyGqAKV7WkrC9TC42faDerTjVq0a88IaY6WgYe0yV+hLaK/0TtBsh1RWz06ebj4LqkN4j2kqiJjRZVyNMkk6VK/3D+13/M9w61E6vr0dS/hoLHsJTeWGJTf06oPnhrNxOitWF0l3abYHluaR73KRDTnPSX+vevsYY0FbHMnkDUYc853wD9Zqdd98gmnaJVblDJqx3dIyPmV/C6dkl7ODvlcBgFZA9vQwUcMeve7bEjlJMK+Ib3mXnehzXxTd6B29KNU/nfPIBUfa4Um9vDXzBQpqoGHMyh9HiQWa5s9feYXm/529nUVD2jnqBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mjg4Pbtc3DKaiCjkga39HTgLjVT2sdaT7QEmCiJklgg=;
 b=oUOIpCTmAoINaNu6DQwLXINOWaO9HRd0foX8WdvyP9lcrSwN7w6UaMUQ/T7T5fA31748Vdk+QW0z8oUuKj76o3h6NEM8Z6WWSH4xeExemsEUNHhCv5dbuqoqN6gi/5BW+y9gP4/w0M+INj5nKM5xFmUC2GkGm72pfVCuPije5WVl2vl0l5BZ0W3dgIn2hneXw8+mxODNbQeDIojJIbd5TYS1eUuLx0yFgV3vgN5l6gzuqyYNqhi1e9Y1OTjIm937dUAJcgq4TGTFLRtBv5QIj8NvNRfBR+Ggl9VpoS93RKIxFDuUyAgCTeRo4EUuLzM8ZnbcpwLfaHcDLmzV80MYqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mjg4Pbtc3DKaiCjkga39HTgLjVT2sdaT7QEmCiJklgg=;
 b=g6aHQ2Jkd5mTD2ehqu4f10gSz6jUfFoX7gsU0+q2IyM1bC7i0TvMykF5RO4Aet3Ux9tnGeNtK/bxBp3RkKchtssCQ/S4EBxrsOOxfXBBt9J+/f5YW/yRdWdOqBNB+1X7pipghzFbKMliRBcAOettzNDMV7ww16G++NpBd17wu4lqKlHDnV1z1Ee4KQze/W17UEMjzuD9uUbj8Kj7Bd3ehrzAs+sEUp+0asdSLOwZVz3JLqy4NpxqbIbmQsmlgvrxlVpAkpp8Vfw2W/Mge8oo2S9r46z7NcW4kSk3AmYWLYL6QDy/axS9u7FliiNyN2FUn3Wrmy9UhzD9PqdN2UqDLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8538.namprd12.prod.outlook.com (2603:10b6:208:455::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 14:43:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 14:43:01 +0000
Date:   Tue, 6 Jun 2023 11:42:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <ZH9F8zFtD7pPeUE8@nvidia.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
 <20230513132827.39066-21-yi.l.liu@intel.com>
 <20230522161534.32f3bf8e.alex.williamson@redhat.com>
 <DS0PR11MB7529096D1BE1D337BA50884BC3409@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230523095025.1898297c.alex.williamson@redhat.com>
 <DS0PR11MB75292161F081F27C0650EFB3C3419@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230524093142.3cac798e.alex.williamson@redhat.com>
 <DS0PR11MB7529407F01EE55AE4A0A9F1FC3469@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529407F01EE55AE4A0A9F1FC3469@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8538:EE_
X-MS-Office365-Filtering-Correlation-Id: c118a827-12b7-481a-47f5-08db669c53dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fAJLNoLB8w+OZiaeBDrV4pPFpBDDwS9TVbr8agEwWcMdY/6f+qar3Hm4zecuSklfJyaibrF9xuGLR1XtXOI7SsRzM8gJfbyHXe4TMO1bRyG3Fi8/fXrJqLTu2azHdVg5WohZ0IyViKRoaQpEqQ6yanI6zCM5g8IauIZLw32OnLJnBLzUb1RMgbIo7mFHxka40HZCusbPvzIZO1IhTOt92l8R9miOVYZ82hLlIgCKgJs5F8qFKGfN7MaRKd8Ce1MaDgnKTCfb4ZRz5Udhi5swYOhAa7BAq7ENhUJCVIrYn9pZmtXVEUJqzf5aTASTfedk1TqvFtg01nVqeJhzsBpTFGwwNj0/CK7bSNjFBwzkz7oHqTxmUA9YNY7vpsl34pqAI9P3y/nk6U9Kvx9gkt6jIRkD5KV98KXnSpopUStVekgeWOmyVtu2rwh2hfth/UdED+h1ATG2jknIuAzbz/h94VJLOkmkv1sh66UEOPYBlPGlF9cTaL6+nbWA8Ht+q55x5KsF3zmBQ31JR37TJ3R+GkYZmSEYPDuEuN4jlR6NQ1tyhdW9ongwlFNPT5pqVkvmmaPY6JSgevudJUIj6giI9IQVJLSRQBD9+Wc2cbF6QqY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(6486002)(26005)(6512007)(6506007)(186003)(2616005)(36756003)(38100700002)(86362001)(66476007)(54906003)(316002)(4326008)(8936002)(66556008)(6916009)(8676002)(66946007)(5660300002)(7416002)(4744005)(2906002)(41300700001)(478600001)(83133001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HC8bPS7F1uZ+sncUgZDq26UDeUtvjr8x7MdP8jBxU9bTtDKHFsdxmzn6RIn2?=
 =?us-ascii?Q?jN/5/GC15n1YpQdVTfM5YrA+HHvXTcLRdFse+4iWx2O8ymoc97cEDK/hsxvL?=
 =?us-ascii?Q?pTAfgiS7jwBdbuQ8KwL61bSRlLSn0pPeKB0zRj3MHFpWv2dUGlnW0vndOgA4?=
 =?us-ascii?Q?f/qYnrD+YDjEVGDdo3Dp0Oca8MJwwVNCe5TWSEgqtO71KCObIaQ5rXawG32J?=
 =?us-ascii?Q?K0RA/3rJANwT6mBGovNH02OEl28DRzUtmHzyUBUCJozK2shdUVm8tj2b36od?=
 =?us-ascii?Q?3sjxQafK8aCS227AklqYSUDUCp+WSPF91N5dfuBEEoNT3il6T+ihTomZvjhr?=
 =?us-ascii?Q?QypTs1qOcs8GcsNdfx7sXqRQBLVJoOtNcbcUI+HrFw+SX+4H+Ehs1oslSPTy?=
 =?us-ascii?Q?2kBL2ofYz3/sZB9+XEFP4ge1YYRpJKxjdLkvJI5mdsi1vpvCwWPd+pcP1hDo?=
 =?us-ascii?Q?LjeKqVdVPdbevjx9tlTmIXGEJJtR4EueSVW8vrPvj5K8bZCv1qgKlBs9t26J?=
 =?us-ascii?Q?RnrHQq8dQtsR62qhE7jlGi9nDXn8m939NttvSjyFnrzL39zjOhPhtBwCb2Ge?=
 =?us-ascii?Q?ysMs5q94jL8nXAdC+7dVL772ptd9dsKaxU8YC11m0ZrT3wgSdjvM5je9VDxR?=
 =?us-ascii?Q?qPvDdqEJc7sET3/cHt6s14w0rkV6UWGUU9xoUzx0p0XsCLLlaimURL5ckkP5?=
 =?us-ascii?Q?+YZ7oNM8nknVw+2wNzC78+KQU0F+o7h4pJJXTEOlVYsut3/MAdu4/p2kLxvq?=
 =?us-ascii?Q?Rp59oHpAfV3FRgqjGjIeB7fZ7QQuWuUAs0GGnKg8pI5dDScf+rF6EPKeN0VH?=
 =?us-ascii?Q?crUOr08i0oLweKmsH5bm2b74Mw3rrM4si8Ko4CBrOYmrBIG9LEXG958ZCHZz?=
 =?us-ascii?Q?aiCALSkKrDq0UFI12HbOzPi3TROtX6QEvbWze+dEfpY34v0BNTTHkb9apR2U?=
 =?us-ascii?Q?0LUkihciiTOM7Iw1l+2JfiNx6dk8x+5VT4uiCtXW/h0ksUI/df9cCCgXk9QP?=
 =?us-ascii?Q?ZLpkJnrkSJs0RgH1uP4yqNB+ka44YrtVIeQRdrG5SoKG2HEFinKOtNd421YQ?=
 =?us-ascii?Q?xTqZPKz16pPfUZeBc/rFwjvpM+dlIXT+jxgEg4AZly8bGr41Iu13E2ykhOIG?=
 =?us-ascii?Q?9SGNpz0RwbpI7DVylom7ev+jmXj3PbfCQDEcXOJFjFuL7HyP1pd0IF057+vk?=
 =?us-ascii?Q?0Oes0l/iRHzbwdB3v+5WpOZikVyFSvxpa+c1hRXUilDA7NLSBiVf5JaSZkRT?=
 =?us-ascii?Q?1INrRb1Gh712C1qAWrwhnx6KjbGm4HLtcutubNJCqT4oR69b2A55cvrSR50+?=
 =?us-ascii?Q?8f0M+Zy/HN3Jdzrdqgm5lj0laZvibmvmaXw0zqTIPPpldZ8vXzYrb1HStz/k?=
 =?us-ascii?Q?9Z0paFrCvmRZtdnj0b3OTLcyNywYiT2o3Fv7cVwpbuzyZzIBTZNFRmFEhK+t?=
 =?us-ascii?Q?ZjVG0+gsP+v1cUSpNB5/LD66RYhz6E3rl+LSPImzrhIv9vUUNtW5L/vdfPyh?=
 =?us-ascii?Q?MQ94Ty9FhlwlcSwXUY+ncx5CEtG2RgLWa2Y10LN3L3sQfYTyw9ByOdBmFOKd?=
 =?us-ascii?Q?Dv91rjBnk38X/O5RcfDMqHHgLoJvCk8Z9hiBIveK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c118a827-12b7-481a-47f5-08db669c53dd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 14:43:01.2648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQOFlUkyCkWAkN3eCOuoC+PWvO5NXmiDYiag7vE7GUEvfjVrH3jNVln7O9iVBW1I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8538
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023 at 03:03:54AM +0000, Liu, Yi L wrote:

> vIOMMU may introduce some performance deduction if there
> are frequent map/unmap. 

DPDK doesn't do that.

And once you turn on the HW IOMMU you negate alot of the micro
performance wins of bypassing. Maybe there is still some argument
about giant/huge pages or something.

> without vIOMMU is supposed to be more robust. But I'm not
> sure if the noiommu userspace will adapt to cdev noiommu.
> Perhaps yes if group may be deprecated in future.

I think that is more a distro question, and we don't have to answer it
fully now.
 
Jason
