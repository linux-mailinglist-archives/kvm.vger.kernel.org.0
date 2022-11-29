Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E13D63C93E
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbiK2UaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235990AbiK2U35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:57 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02hn2231.outbound.protection.outlook.com [52.100.160.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EDA64543
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8vMD7HfXECWF5kozs75c9wpYKLf12OFgUQK1aT1G/qVglFa/l8kD+IZIiHPxKiUVnW/DiVCn2YZ+kIyy4dWTUm/qTILPJ4uxH3TE7yM+LuV6VnMp4Kh/Mcu5D8LCojUkf2SCl2l+9P/VhftPiLVEXlkA590IVCw3/EVHwb+Ga37JM2buA7XRVsr5TcR4z9p5yivdPTVjDixvD0vHtIHvZSNrWVrPPDP2BFI0UVxnvWqrv8Fw0v3VcLq8WgMHp+uYCMurVVmJqUnciwtl12m2+pnXfBcn0cwW+ZST+HjbRu3GEUG/6if7xRgmi68v0q38cGxV4VSUagFPk/c4DTvgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JexhQx8gkWDxDm3ANb/ffWklp5qSBzQEAK6wwMc1ayo=;
 b=kTaTJLobQVR1R4GeiNOm9vD+F3tlqQTj6O65NSIPPU4U9xdTYkwJfrTGs/4NPCsaDjh3w61V7siY3BBC05G6mPk9SCtwEpFdSb9tywumizc0505fN3J1gobnd5BDYKwLgkATP0XjqCofY30M5qTRjHce0pc9ANvl1yaBg6h9TKWzXabIPkGu8oRCILv3QSNsu1PBYL8yioL1LuMSICqt1r/3SxF5Bgn+l7IO3OlJCo1pvTvy4eeKILIm4r1MChpWGgBsc2uAh1zjbZnZe5NxGWU7Y9jwCpFRY1af9KyhbptwpM60hKhNLkfXI3iaOm04sITtCYq+JoixupU5c0B3/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JexhQx8gkWDxDm3ANb/ffWklp5qSBzQEAK6wwMc1ayo=;
 b=Mu1eSN23aHguGsTsBRPI4o5qBpwbfItroIoLqwkrVd/A9mkkkmr3GZscjevZFXfYsKjUDKHifJ2knejwekoxOAFfcoxrFvl4AZujGrUBPCt8yzdmbGh1eXQZ3L+1+ct3983PoCuDG0xkRbx2AGHHt5Mf6qFde8wy/CbqPk15u6JXxTAKTjuPwc+ElwG48bmWJ8R2zS/Etp9cPIBP8O+xM4JzqMFq3UmRvTF+ClxJE8AIvLAkZbMBMtLVz4VSBbzGq23d9z9q5DuSkHlQ9aT7CSJkRZ1B1OfclUC63J86E2DHuqpgCVZHdj96ZC846Jo/z7zgTXh4L0e+M1qYnRj8hQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:52 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 00/19] IOMMUFD Generic interface
Date:   Tue, 29 Nov 2022 16:29:23 -0400
Message-Id: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 4915cea3-642a-4774-9f0d-08dad2487559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EiZUEaEq1qeuj2R52uGXQJjse16i6IvUi8Z5rEyAslAp/IstXeFXdGXhAtbK?=
 =?us-ascii?Q?qd7MreWrXP/P9SmplrfLHZ+QvaXq4XVf1i74lJLae99OHk2MByRUfFZ+12+n?=
 =?us-ascii?Q?SO0eRGXQLgArZS5CemuIO0ipPlNOjL8trnDHZGtHBhvfJ7HMp3ppObVn4Y6B?=
 =?us-ascii?Q?/1/DKaLB7Iz1xkAN2I+iwT2RRz8XI4j5luXyzOgAzTqpAeuHjagftwdUn6rv?=
 =?us-ascii?Q?pmk5M2tLtzRUnOPNDulbwhthQCUKX7C7YxTI+MN1w8IStDhUm79Ws0hvpHHz?=
 =?us-ascii?Q?ak1xxw0mUm70L62X93L1DFhz/5KoZS/ADd//XRZTvFks1UvAo6bUqguS19CW?=
 =?us-ascii?Q?Nr5ckj7smpq1GN6li5MeVONqtF4I6kEwTXQgt/ZZZ738Z2kEMfMDxGk3oY0m?=
 =?us-ascii?Q?KW8kfsVyuSJVJfQOj1eK3NTZaHQKYM2ZRnKPI461k/BTYofWWxT3IbB3j2ew?=
 =?us-ascii?Q?OcusQTgb7WQfEJwBkCxs6lIaEezA53q7AP6q6TClAIMj7b87QmTBmDdTZ03M?=
 =?us-ascii?Q?PnhfzTeNHx3n1+O4SYGZ1YH/Vv0YjkHb98mycV5XAO9qCkaikjS3r+SpH8lQ?=
 =?us-ascii?Q?wfHMg+VMB/0vYWFnvz7qOCrQQyKu4fEZB2gZx2b9I50wL+hbVSA5ETBqU5vy?=
 =?us-ascii?Q?uHvET5JZwBoeaeNTCacjxZxckOzXlZ5CqKfivZlQpdeaW1gJtpX0g2UNvkva?=
 =?us-ascii?Q?ej+/EkpWVotDqpgdtUeGRfT66DV7G/EmrUL52CQ1Big5yxedzjk6iF4vQkLK?=
 =?us-ascii?Q?ihNSIYd3Faejqm+d9X7XoIKAuAxgHwzt8KtPyZo98NLeCCVMBjMLElF4r8dL?=
 =?us-ascii?Q?7DpHbzC22qU/a+bBfCjyKBiLyZMjBM8vg3ixWCnpAgJDiqGbX7MVSgymIzF0?=
 =?us-ascii?Q?cQzAQu7FyMFUG35sCNcVNjAHRzTOX3Vf7c/SNWUyLG9o4nmBEu0M4nE41wx6?=
 =?us-ascii?Q?N9vGNhr3E7GNpmjzZr3LoPdIoSuoRkJyR+bciJVjWSsYDXYymscY9v9PYOJq?=
 =?us-ascii?Q?w1XOqCOs+elM5lqV8Gz83dD2gF9s+rFCNdUbGgzpVjo021U3Pc3L3IXN0qra?=
 =?us-ascii?Q?xgR8Yb/Cq0ybUCVLYCrJXISFiPVY/eI2b8Df3Nn4PwiOR1ahlez0PExpVuUC?=
 =?us-ascii?Q?7XCCl7qNaMy5QkOue6JlJiaHWTKcGTqINFWvzY2wNE/319xzImfT9jMurIIX?=
 =?us-ascii?Q?3RozbXr/WuGCT7QBNXuogsXm/oYIo4SYtw33OemxQHwFYIU4IPKpDxZ0Axv3?=
 =?us-ascii?Q?D8zi4DN1GBVeaZdl58GPBMf+WmzIbA7XDS8j6iMkhSyoHPyTk4/if2Rj8Tb7?=
 =?us-ascii?Q?vYT4kmHbXPDw6R7b1cRlq06inVKkubh2U+c3kJmIJp1hSFPZe02dcYpvNWem?=
 =?us-ascii?Q?b7NHJrW0Ugy7Jd5Kk8s8FFiSPvZr8iMKBRg9foZf94zKRJk2/I060CpoEFX4?=
 =?us-ascii?Q?uQEtiTH2tr0CDvAAxAUCaZmGqt2JHpQh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:9;SRV:;IPV:NLI;SFV:SPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(966005)(6486002)(316002)(478600001)(2906002)(30864003)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(4216001)(41533002)(266003);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0iYIz/CwE4AxLimNTn9+1DsUexiumw1+6HbM7XiS7JoLusVrkilDSYbd40df?=
 =?us-ascii?Q?+K6lr14z2+CYxPCYCcwZg2NXiwEuX4EiJZ8fwpQoDD20oZImjBjWfiiHtIpt?=
 =?us-ascii?Q?VAN2TNiI71Uk8kweBkDBcuXT5SmjMQGUy4JYnXf2CQEfM7n30Q5kgSFyC/0a?=
 =?us-ascii?Q?k/tnaEx+46espqRfDHdk//EYP9SXzyT9Td15AJKn3StI5Gs6Rd7gsgiu9e8I?=
 =?us-ascii?Q?A+T8f1a5NGeMU+u1mPTt8X1X1Nj3vsZid/tMZmBdCm6bfogwaGy5tZ5slfde?=
 =?us-ascii?Q?JjeBDvSnRXHaS7+1HTQM8O+rcEuP93GJJPXKiL3RI4f93heq6o/qhNsl8xBz?=
 =?us-ascii?Q?NNyo2bSMZnTejkzqdL10LGXwyRgSNLvx9PPsl2rsg52lZ84JmBp4AjLbFpab?=
 =?us-ascii?Q?+SZH/ic4GnuntvN2UNE2EPjrN9UQlTnArk2Ema1ix2UNXOZhbRYliKSwRF9O?=
 =?us-ascii?Q?n5v/Wh7KNBjr29zBGbrFP/xOLe2ih6sfiEM/dOP82lqPikNGG/BTVk/nztIg?=
 =?us-ascii?Q?M1Cd8sSkBQGU8HSlFMxHfMvmR32cGz33scD5LiYXoU3fJxxKdDUs0AC2dE07?=
 =?us-ascii?Q?JapEGMMO5gqCSRs8a/d/ZU0+GtSDvt022WkFs5KtSXeOE85PhzblOGvHYLmY?=
 =?us-ascii?Q?HNiZeC0HorBAaYcTQ5ubefIA1iPCrqFFdpy434rxk0yeqPiPsq6P+a6Pxio1?=
 =?us-ascii?Q?lc08pouHQdmGRCAaFxlI/+ar73iIzO1yRPgNhsk+ToeXTA0niTp+B5FJcqER?=
 =?us-ascii?Q?8lEh+Xj6eiXQpKa3WK8/e4arU6TjIvv/7km0ly5eP4ngsTYjkcfDMeBD1FBA?=
 =?us-ascii?Q?RzNFV6QtTq7cNaXVIhouSdPT2N0vUQv1Zxw5ymnv38oRfDpx2cAEj7KAlGb/?=
 =?us-ascii?Q?SVOnACpR0jdtuK9+pg6UjkFadJ4fqdd7FAdsfdEN+Sa6uhZxLZHmUnmrw6ZJ?=
 =?us-ascii?Q?wmbOVwtCoGp5xh6P6SUsnJb1A/K4j4yvDB4cJOzid4BIM6+SaQTmcGWFfCez?=
 =?us-ascii?Q?TcjCJ0vlAyWNIGsIawKKrnzD4qnZg+C/5rSSpbqqZNsLAmfvcgyVG0dEYVkq?=
 =?us-ascii?Q?21cHCt2HKJVrSiEYAn4QLqvEFvR87XO69y+wLt07W7zKGBMGrmlK9kRQkWAk?=
 =?us-ascii?Q?Kwv7tZLcDpNvN/tL7rmplH5RZ4GEXayuorr8v3meWNKL3DjKCUvctr2l4/7s?=
 =?us-ascii?Q?P20rt2F1pGfWOMm6J4RGIhUd1p3rwdrwUOfTLpZJFZ3+TuPgYss/+P7E0/9z?=
 =?us-ascii?Q?w8F8v3zODSHP0tlVEUaz+qLgOg5sCS7O48joAShiqXzC0W95ZEbEiA0QbULO?=
 =?us-ascii?Q?vGqOrsw29iXf9pKupfCRq2vpXamFmhKvcwbbaJ1M82Pae6FjVFy3Ulpijk4D?=
 =?us-ascii?Q?diG8ORCcFrNAaqbnNdkULzbeZyNsrKHLQZ6sBiblDbIug5LuwQe/xROeSNaV?=
 =?us-ascii?Q?cXdlYgCe/H+4TIOyPGqfyO+4wIO8/2Rq/MX2guYdwR/qaCibYZv6wSaeqPfW?=
 =?us-ascii?Q?ET2SdV59bf7wWhon5bMb9xi49U6NmHcfuo65H23LM4qApZwLVLjroMliRxc1?=
 =?us-ascii?Q?C29+i3ViAdLSUzpKyZWl9aqBRIQTB5Tc/Awkkdq5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4915cea3-642a-4774-9f0d-08dad2487559
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:47.9174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxk8GaN0Lxd2yZ2EjHvntLBuoYeqqAA3KKpY1ThoAE38rHOo4OjiY8UaFuwieqw8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=4.5 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[
There is very little functional change in this verion. We are at rc7 now,
so I intend to apply this version and stop changing the branch. Unless
something major happens this will be the final posting of this series.

New functional changes will have to come as followup patches from this
point.

I will continue to rebase to collect any tags and documentation/comment
changes. The branch will be sent as a PR to Linus promptly on the Monday
of the merge window.

Thank you to all
]

iommufd is the user API to control the IOMMU subsystem as it relates to
managing IO page tables that point at user space memory.

It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
container) which is the VFIO specific interface for a similar idea.

We see a broad need for extended features, some being highly IOMMU device
specific:
 - Binding iommu_domain's to PASID/SSID
 - Userspace IO page tables, for ARM, x86 and S390
 - Kernel bypassed invalidation of user page tables
 - Re-use of the KVM page table in the IOMMU
 - Dirty page tracking in the IOMMU
 - Runtime Increase/Decrease of IOPTE size
 - PRI support with faults resolved in userspace

Many of these HW features exist to support VM use cases - for instance the
combination of PASID, PRI and Userspace IO Page Tables allows an
implementation of DMA Shared Virtual Addressing (vSVA) within a
guest. Dirty tracking enables VM live migration with SRIOV devices and
PASID support allow creating "scalable IOV" devices, among other things.

As these features are fundamental to a VM platform they need to be
uniformly exposed to all the driver families that do DMA into VMs, which
is currently VFIO and VDPA.

The pre-v1 series proposed re-using the VFIO type 1 data structure,
however it was suggested that if we are doing this big update then we
should also come with an improved data structure that solves the
limitations that VFIO type1 has. Notably this addresses:

 - Multiple IOAS/'containers' and multiple domains inside a single FD

 - Single-pin operation no matter how many domains and containers use
   a page

 - A fine grained locking scheme supporting user managed concurrency for
   multi-threaded map/unmap

 - A pre-registration mechanism to optimize vIOMMU use cases by
   pre-pinning pages

 - Extended ioctl API that can manage these new objects and exposes
   domains directly to user space

 - domains are sharable between subsystems, eg VFIO and VDPA

The bulk of this code is a new data structure design to track how the
IOVAs are mapped to PFNs.

iommufd intends to be general and consumable by any driver that wants to
DMA to userspace. From a driver perspective it can largely be dropped in
in-place of iommu_attach_device() and provides a uniform full feature set
to all consumers.

As this is a larger project this series is the first step. This series
provides the iommfd "generic interface" which is designed to be suitable
for applications like DPDK and VMM flows that are not optimized to
specific HW scenarios. It is close to being a drop in replacement for the
existing VFIO type 1 and supports existing qemu based VM flows.

Several follow-on series are being prepared:

- Patches integrating with qemu in native mode:
  https://github.com/yiliu1765/qemu/commits/qemu-iommufd-6.0-rc2

- A completed integration with VFIO now exists that covers "emulated" mdev
  use cases now, and can pass testing with qemu/etc in compatability mode:
  https://github.com/jgunthorpe/linux/commits/vfio_iommufd

- A draft providing system iommu dirty tracking on top of iommufd,
  including iommu driver implementations:
  https://github.com/jpemartins/linux/commits/x86-iommufd

  This pairs with patches for providing a similar API to support VFIO-device
  tracking to give a complete vfio solution:
  https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com/

- Userspace page tables aka 'nested translation' for ARM and Intel iommu
  drivers:
  https://github.com/nicolinc/iommufd/commits/iommufd_nesting

- "device centric" vfio series to expose the vfio_device FD directly as a
  normal cdev, and provide an extended API allowing dynamically changing
  the IOAS binding:
  https://github.com/yiliu1765/iommufd/commits/iommufd-v6.0-rc2-nesting-0901

- Drafts for PASID and PRI interfaces are included above as well

Overall enough work is done now to show the merit of the new API design
and at least draft solutions to many of the main problems.

Several people have contributed directly to this work: Eric Auger, Joao
Martins, Kevin Tian, Lu Baolu, Nicolin Chen, Yi L Liu. Many more have
participated in the discussions that lead here, and provided ideas. Thanks
to all!

The v1/v2 iommufd series has been used to guide a large amount of preparatory
work that has now been merged. The general theme is to organize things in
a way that makes injecting iommufd natural:

 - VFIO live migration support with mlx5 and hisi_acc drivers.
   These series need a dirty tracking solution to be really usable.
   https://lore.kernel.org/kvm/20220224142024.147653-1-yishaih@nvidia.com/
   https://lore.kernel.org/kvm/20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com/

 - Significantly rework the VFIO gvt mdev and remove struct
   mdev_parent_ops
   https://lore.kernel.org/lkml/20220411141403.86980-1-hch@lst.de/

 - Rework how PCIe no-snoop blocking works
   https://lore.kernel.org/kvm/0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com/

 - Consolidate dma ownership into the iommu core code
   https://lore.kernel.org/linux-iommu/20220418005000.897664-1-baolu.lu@linux.intel.com/

 - Make all vfio driver interfaces use struct vfio_device consistently
   https://lore.kernel.org/kvm/0-v4-8045e76bf00b+13d-vfio_mdev_no_group_jgg@nvidia.com/

 - Remove the vfio_group from the kvm/vfio interface
   https://lore.kernel.org/kvm/0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com/

 - Simplify locking in vfio
   https://lore.kernel.org/kvm/0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com/

 - Remove the vfio notifiter scheme that faces drivers
   https://lore.kernel.org/kvm/0-v4-681e038e30fd+78-vfio_unmap_notif_jgg@nvidia.com/

 - Improve the driver facing API for vfio pin/unpin pages to make the
   presence of struct page clear
   https://lore.kernel.org/kvm/20220723020256.30081-1-nicolinc@nvidia.com/

 - Clean up in the Intel IOMMU driver
   https://lore.kernel.org/linux-iommu/20220301020159.633356-1-baolu.lu@linux.intel.com/
   https://lore.kernel.org/linux-iommu/20220510023407.2759143-1-baolu.lu@linux.intel.com/
   https://lore.kernel.org/linux-iommu/20220514014322.2927339-1-baolu.lu@linux.intel.com/
   https://lore.kernel.org/linux-iommu/20220706025524.2904370-1-baolu.lu@linux.intel.com/
   https://lore.kernel.org/linux-iommu/20220702015610.2849494-1-baolu.lu@linux.intel.com/

 - Rework s390 vfio drivers
   https://lore.kernel.org/kvm/20220707135737.720765-1-farman@linux.ibm.com/

 - Normalize vfio ioctl handling
   https://lore.kernel.org/kvm/0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com/

 - VFIO API for dirty tracking (aka dma logging) managed inside a PCI
   device, with mlx5 implementation
   https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com

 - Introduce a struct device sysfs presence for struct vfio_device
   https://lore.kernel.org/kvm/20220901143747.32858-1-kevin.tian@intel.com/

 - Complete restructuring the vfio mdev model
   https://lore.kernel.org/kvm/20220822062208.152745-1-hch@lst.de/

 - Isolate VFIO container code in preperation for iommufd to provide an
   alternative implementation of it all
   https://lore.kernel.org/kvm/0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com

 - Simplify and consolidate iommu_domain/device compatability checking
   https://lore.kernel.org/linux-iommu/cover.1666042872.git.nicolinc@nvidia.com/

 - Align iommu SVA support with the domain-centric model
   https://lore.kernel.org/all/20221031005917.45690-1-baolu.lu@linux.intel.com/

This is about 233 patches applied since March, thank you to everyone
involved in all this work!

Currently there are a number of supporting series still in progress:

 - DMABUF exporter support for VFIO to allow PCI P2P with VFIO
   https://lore.kernel.org/r/0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com

 - Start to provide iommu_domain ops for POWER
   https://lore.kernel.org/all/20220714081822.3717693-1-aik@ozlabs.ru/

However, these are not necessary for this series to advance.

Syzkaller coverage has been merged and is now running in the syzbot
environment on linux-next:

https://github.com/google/syzkaller/pull/3515
https://github.com/google/syzkaller/pull/3521

This is on github: https://github.com/jgunthorpe/linux/commits/iommufd

v6:
 - Comment clarity and grammar updates
 - Enforce 0 on the reserved and object_id IOMMU_OPTION values
 - Add allow_unsafe_interrupts as an iommufd module option and remove
   the forwarding of the vfio option
 - Add a test that the GUP FOLL_FORCE path is working right, since
   that is all being revised on the mm side.
v5: https://lore.kernel.org/r/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com
 - Move WARN_ON in __iommu_group_alloc_blocking_domain()
 - Fix rebase error of pfn_batch::npfns
 - iopt_pages_add/remove_access() is now iopt_area_add/remove_access()
 - Change iopt_pages_access::refcount into an unsigned int
 - Lower mutex/etc into iopt_area_add_access()
 - Match VFIO error codes for some map failure modes
 - Block area split if accesses are present
 - Match VFIO behavior for pin/unpin when the IOVA is unaligned. Round
   down the IOVA to PAGE_SIZE and assume the caller will take an offset
   into the first page based on IOVA % PAGE_SIZE
 - Increase VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL to U32_MAX for s390
 - Enforce that access->ops->unmap is set if pin_pages is used
 - Split the test code into several patches to stay below the 100k mailing
   list message size limit
 - A few code naming changes for clarity
 - Use double span for IOVA allocation
 - Lots of comment and doc updates
v4: https://lore.kernel.org/r/0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com
 - Rebase to v6.1-rc3, include the iommu branch with the needed EINVAL
   patch series and also the SVA rework
 - All bug fixes and comments with no API or behavioral changes
 - gvt tests are passing again
 - Syzkaller is no longer finding issues and achieved high coverage of
   69%(75%)
 - Coverity has been run by two people
 - new "nth failure" test that systematically sweeps all error unwind paths
   looking for splats
 - All fixes noted in the mailing list
   If you sent an email and I didn't reply please ping it, I have lost it.
 - The selftest patch has been broken into three to make the additional
   modification to the main code clearer
 - The interdiff is 1.8k lines for the main code, with another 3k of
   test suite changes
v3: https://lore.kernel.org/r/0-v3-402a7d6459de+24b-iommufd_jgg@nvidia.com
 - Rebase to v6.1-rc1
 - Improve documentation
 - Use EXPORT_SYMBOL_NS
 - Fix W1, checkpatch stuff
 - Revise pages.c to resolve the FIXMEs. Create a
   interval_tree_double_span_iter which allows a simple expression of the
   previously problematic algorithms
 - Consistently use the word 'access' instead of user to refer to an
   access from an in-kernel user (eg vfio mdev)
 - Support two forms of rlimit accounting and make the vfio compatible one
   the default in compatability mode (following series)
 - Support old VFIO type1 by disabling huge pages and implementing a
   simple algorithm to split a struct iopt_area
 - Full implementation of access support, test coverage and optimizations
 - Complete COPY to be able to copy across contiguous areas. Improve
   all the algorithms around contiguous areas with a dedicated iterator
 - Functional ENFORCED_COHERENT support
 - Support multi-device groups
 - Lots of smaller changes (the interdiff is 5k lines)
v2: https://lore.kernel.org/r/0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com
 - Rebase to v6.0-rc3
 - Improve comments
 - Change to an iterative destruction approach to avoid cycles
 - Near rewrite of the vfio facing implementation, supported by a complete
   implementation on the vfio side
 - New IOMMU_IOAS_ALLOW_IOVAS API as discussed. Allows userspace to
   assert that ranges of IOVA must always be mappable. To be used by a VMM
   that has promised a guest a certain availability of IOVA. May help
   guide PPC's multi-window implementation.
 - Rework how unmap_iova works, user can unmap the whole ioas now
 - The no-snoop / wbinvd support is implemented
 - Bug fixes
 - Test suite improvements
 - Lots of smaller changes (the interdiff is 3k lines)
v1: https://lore.kernel.org/r/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (17):
  iommu: Add IOMMU_CAP_ENFORCE_CACHE_COHERENCY
  interval-tree: Add a utility to iterate over spans in an interval tree
  scripts/kernel-doc: support EXPORT_SYMBOL_NS_GPL() with -export
  iommufd: File descriptor, context, kconfig and makefiles
  kernel/user: Allow user::locked_vm to be usable for iommufd
  iommufd: PFN handling for iopt_pages
  iommufd: Algorithms for PFN storage
  iommufd: Data structure to provide IOVA to PFN mapping
  iommufd: IOCTLs for the io_pagetable
  iommufd: Add a HW pagetable object
  iommufd: Add kAPI toward external drivers for physical devices
  iommufd: Add kAPI toward external drivers for kernel access
  iommufd: vfio container FD ioctl compatibility
  iommufd: Add kernel support for testing iommufd
  iommufd: Add some fault injection points
  iommufd: Add additional invariant assertions
  iommufd: Add a selftest

Kevin Tian (1):
  iommufd: Document overview of iommufd

Lu Baolu (1):
  iommu: Add device-centric DMA ownership interfaces

 .clang-format                                 |    3 +
 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    1 +
 Documentation/userspace-api/iommufd.rst       |  223 ++
 MAINTAINERS                                   |   12 +
 drivers/iommu/Kconfig                         |    1 +
 drivers/iommu/Makefile                        |    2 +-
 drivers/iommu/amd/iommu.c                     |    2 +
 drivers/iommu/intel/iommu.c                   |   16 +-
 drivers/iommu/iommu.c                         |  121 +-
 drivers/iommu/iommufd/Kconfig                 |   24 +
 drivers/iommu/iommufd/Makefile                |   13 +
 drivers/iommu/iommufd/device.c                |  778 +++++++
 drivers/iommu/iommufd/double_span.h           |   53 +
 drivers/iommu/iommufd/hw_pagetable.c          |   57 +
 drivers/iommu/iommufd/io_pagetable.c          | 1212 ++++++++++
 drivers/iommu/iommufd/io_pagetable.h          |  241 ++
 drivers/iommu/iommufd/ioas.c                  |  398 ++++
 drivers/iommu/iommufd/iommufd_private.h       |  307 +++
 drivers/iommu/iommufd/iommufd_test.h          |   93 +
 drivers/iommu/iommufd/main.c                  |  424 ++++
 drivers/iommu/iommufd/pages.c                 | 1981 +++++++++++++++++
 drivers/iommu/iommufd/selftest.c              |  853 +++++++
 drivers/iommu/iommufd/vfio_compat.c           |  472 ++++
 include/linux/interval_tree.h                 |   58 +
 include/linux/iommu.h                         |   17 +
 include/linux/iommufd.h                       |   98 +
 include/linux/sched/user.h                    |    2 +-
 include/uapi/linux/iommufd.h                  |  345 +++
 kernel/user.c                                 |    1 +
 lib/Kconfig                                   |    4 +
 lib/interval_tree.c                           |  132 ++
 scripts/kernel-doc                            |   12 +-
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/iommu/.gitignore      |    3 +
 tools/testing/selftests/iommu/Makefile        |   12 +
 tools/testing/selftests/iommu/config          |    2 +
 tools/testing/selftests/iommu/iommufd.c       | 1654 ++++++++++++++
 .../selftests/iommu/iommufd_fail_nth.c        |  580 +++++
 tools/testing/selftests/iommu/iommufd_utils.h |  278 +++
 40 files changed, 10450 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/userspace-api/iommufd.rst
 create mode 100644 drivers/iommu/iommufd/Kconfig
 create mode 100644 drivers/iommu/iommufd/Makefile
 create mode 100644 drivers/iommu/iommufd/device.c
 create mode 100644 drivers/iommu/iommufd/double_span.h
 create mode 100644 drivers/iommu/iommufd/hw_pagetable.c
 create mode 100644 drivers/iommu/iommufd/io_pagetable.c
 create mode 100644 drivers/iommu/iommufd/io_pagetable.h
 create mode 100644 drivers/iommu/iommufd/ioas.c
 create mode 100644 drivers/iommu/iommufd/iommufd_private.h
 create mode 100644 drivers/iommu/iommufd/iommufd_test.h
 create mode 100644 drivers/iommu/iommufd/main.c
 create mode 100644 drivers/iommu/iommufd/pages.c
 create mode 100644 drivers/iommu/iommufd/selftest.c
 create mode 100644 drivers/iommu/iommufd/vfio_compat.c
 create mode 100644 include/linux/iommufd.h
 create mode 100644 include/uapi/linux/iommufd.h
 create mode 100644 tools/testing/selftests/iommu/.gitignore
 create mode 100644 tools/testing/selftests/iommu/Makefile
 create mode 100644 tools/testing/selftests/iommu/config
 create mode 100644 tools/testing/selftests/iommu/iommufd.c
 create mode 100644 tools/testing/selftests/iommu/iommufd_fail_nth.c
 create mode 100644 tools/testing/selftests/iommu/iommufd_utils.h


base-commit: 69e61edebea030f177de7a23b8d5d9b8c4a90bda
-- 
2.38.1

