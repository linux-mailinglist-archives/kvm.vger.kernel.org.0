Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7363C95D
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiK2UcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiK2UcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:32:02 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213836317C
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:32:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mM70jh4CAGAw9pU4Xyku0S+q8yvkJvZd3k/Lxwyb5Ft09KD2GLdchmEURscxiWlG0fX4smwtvEHu5z2MTLySCgTaXSY4hB6jPQXS2SS8p9XcTHTOqhat6zFsLsCB9Gsjozy+rChv6X88KCB0HXSoxNnppqFC85cekJp/M4Af1GltD7kzKawWWQizmfNXGGKqTvNFrhAT1S6px+wHrkGqeY6k4lzoUmiDsdEfvU8GJwUNmW66MT3jB9XW7dxMGnf3BK/tZi3joBY5pMY9f1X1C2kHArAmsT73SHXv4GvYdED8mFvcX1UjlRQ8BEpKjEOzqbjvLpaXytFSlpgA9pe0sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fW+Ri/hJJOv+LZgTBKXkBk/GhQpJ8SMUPSn5sZE7KCY=;
 b=akiD9eRGAlOq0dqXykDoo9O8S2IKFhjzkGxrFGYdcLGdAN4yKgxjGpSRJZhjsiIUGJUsPipX7zlZ8aBKTNuVli2Xg3iAq0RQTWgTiODlg0V1o5K9CUVKZzzR9NmgSLeUUBAMFICIVh/AHEtdhMTXMM0rZHOCo8tex7ov4CVks+2DRiqVvR9Qh75maMcm2mLApbNcReewputYDKDLHGCnDJxNi2Yul7JfWcdVijDcL4uPDyKb3kFUAzld9pOAPCNiFHQjLNxs82hICbF3sJ+V1AD9Aw2oBRXoB7clBSDwmCy7Wtzdirn3BgNaQgvak6cHCDCyliWpP19vuGOHycSqaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fW+Ri/hJJOv+LZgTBKXkBk/GhQpJ8SMUPSn5sZE7KCY=;
 b=TyAI6MAl/00KiSWgtuf7z8xfvsdug40ECfZOcsJNgKo4GoE4SRmK9b6E6UQ8vKv7XwNRQWSHrlErjkkTGRJNo0nCPusT2PiGAmHAzgG2SegLF5fFbtboZOa6PUY+QMIwmlJlDSjpLH92bUCKvChc7JHUU4zmyPWZIAXE1GhK7GTlJFU+ZgtUNpoFG96XGAV2OavMl9piB1Q7mQmcF7hQFiqJVzS9LTWv7UYowVhKTfVA1zVN8e7okqOenyUtuqqueuwXkCjXNaYG0/qa09co1gjBrv9XEplqvuG1vnBt/tWuQPL2iKxwfAaVKaQdevpuFiTxX9Osb5/IEm1mMdo1lA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 20:31:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:31:58 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v4 00/10] Connect VFIO to IOMMUFD
Date:   Tue, 29 Nov 2022 16:31:45 -0400
Message-Id: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0064.namprd08.prod.outlook.com
 (2603:10b6:a03:117::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: c4131414-3d8b-41e5-f5f2-08dad248c330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fbkhxmx/84pmTVY+88wtiB5/YFO6nPbbutcAG0iMYWys1+SVF+yT+jGThsm4khphz28h47EHg5/7hbaxJPWXvkI+PhPCLxAxTzlT7z4iN1Kbk2V8PeaRNFBO1kKsEGFzgdMo+IUfZeDu68WPHtQyTIx+fTccP9RV9NO/bWfKgRqLWWhyvm3iyYPvIt11OxfaH7Sl6w22uw2tUVPlytwiWz1tEUq3wG1Oa1shb9jOvEsWXC/1cM2QSP5OHYrvvs3KBv/MRL3bPjOfTsHzAqVhNZIcIHVM4+xjPCRXbRo8KhPMER3TMluzHiG4hObN+wofXteNGYPz0Hs/zxX69aExreV6c30HmhF8unhgBhTVOH+rl4YlKhcWZm2H7niuniuzXP2ojbGi5Yl/qGed2icbL+T5jviwk1r8FVNFuaUsyFF6zdIhySgSyt6uBmgPeznU6megcAIwfF93YCFYg18ExRhFdDnXHRPWUvd5NAfivyd4IYVrZDGjThXddo/+wDva1bunvFWSXQ2DRdqfQEBL8RYE70Tf2bbonLOMCRYGP3ORbbvnOoME1GTj2LGgNLlapBCK+NcehyLFmzJt0kp9Qy1VUeg2oWM04XarCurMsaEbGQtxXO8fY2jc7HJy7PfeZCgsiArQUrYmqKXwvwa8Ut2yj4w+QxkYl4qyah92llm8g5VNmEm+XKA1pA28gzSoQ6ksIL8R4LA2CG6bPfKM1q8AxJQ5fIXceL0dBcawXs5XVWYTOLX3KIdGpRuk5L96m2lMeLiVXXCMMe0qYz8CxclG+UyG4aXGFYNfcKCSgt7rkMRtTOXapnPYl1oVyY1n9g6wwzzDkjjuc4Vi9uxJlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(109986013)(451199015)(26005)(86362001)(2616005)(6512007)(186003)(54906003)(6506007)(6486002)(966005)(6666004)(478600001)(38100700002)(83380400001)(36756003)(2906002)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(8936002)(7416002)(5660300002)(41300700001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iBE8jHlmBXSs/hajBeAP+BHNo4HoCY22Pb39g18OwL5b0QuyPz1ReRFgpgwb?=
 =?us-ascii?Q?xycCyN8PceZua9/dE6AcwLLtNg4TT4UGpoQhM+amsge3QpVKEEP2IZveF52X?=
 =?us-ascii?Q?4RZst7EZQCVOry+VSARaYvYJmb5ZFLza1MTGAwwQzdyx15GaRgEp0MtHEIL4?=
 =?us-ascii?Q?T7Q2n9ZCoPJCcLlrOCrfiJeQzQlxt6NI+WUegU0GIIrASs3fRWjqviKB303a?=
 =?us-ascii?Q?LFUZQ5/asaAIystY0duQgJqBUMuo21iWnsto6DjjYsdCmEcsfkyrhSwBefNX?=
 =?us-ascii?Q?i1LRIsJN6qmHaI5hh2kYUt6kU0+zHD9+avvVpSdeeFK288IjMn1hpIFHMiJB?=
 =?us-ascii?Q?us6c3tuxJ+vG0BosgHejkmjPcmKxcdhVTgzbpQgY17S6nd49HdsVdy/KZHTz?=
 =?us-ascii?Q?Y167JnEkLSYyKI4usq23fzQVM8vgb9F5jD3ESWca5lSS+gFnrmcw1kIToLBE?=
 =?us-ascii?Q?XtHwwGAG2S1niWvzHHXrb5+QdvJp2PMRQxkXUQLP08JYMiHSxZ96IyYgLo21?=
 =?us-ascii?Q?7BpAbXzmd5gZDEP48N63uXySLtAr0l9o8jhZyB/mgi/7hRg6+bQ/gY76FsqE?=
 =?us-ascii?Q?ZvkS9HwzaRBHfSV9BhbZ16mSGi+/BZihV4Nh0UFdlh5GJ+uoKd/BQ+kC52NT?=
 =?us-ascii?Q?tyPdyQvzHcwFyvGU/IFs4PpOrMPknFvLUtgiOPIwGaJSIgAEFN6Apch82eVB?=
 =?us-ascii?Q?Rp0Q465ayuP0HV0YlFAqzfAAsT5PIRIGWC7RZiXMxd1zHRuf1p5EknXjGELM?=
 =?us-ascii?Q?H1pJVSL9IJ8gM7nYiJJ9NCVCvz1oJ+bmWc0MTyQfjOa0g+1F6gjuyVWK7sc8?=
 =?us-ascii?Q?/8Ys6e1i4aX7l3rR252UC/7V7Ltw/26nW9N27wH4V/0I2cCu1evPvfRvC12L?=
 =?us-ascii?Q?vbK7xPM5UTfv00C6wGEg7LTlyXZ5jwuWcFvOfpF8n5hoLkGGXetd8YkJE48U?=
 =?us-ascii?Q?xfTDVlE7Hgce/O/82hyGQZ1PSPXrkEsE79zgvG7EgRk6lPRL3KcOZgIvnUak?=
 =?us-ascii?Q?qL/vHb8nghp53osV3NRTOhJOwU2t0/LA8d23CdjV3ddsHetnig9rxJYDZs70?=
 =?us-ascii?Q?4kmdEm7nkzK9hxV2JqDtELc3SA/QuLEzPfy4S7sP+UMcYsi9my74n6GoTmYf?=
 =?us-ascii?Q?WRj/YBozXFkqeBdxgsLfQRLd+TQ2FHuRmK1i62Rl1MpnWbFTloWEEPaUT+q3?=
 =?us-ascii?Q?g4c8moQYfKSzVYBZO6g8m34jFT8exGf/qLsBWO0d97WCaQtYSPwdRRwTJhD4?=
 =?us-ascii?Q?LI2yBzvZNvRmYlKkRBqFk+uP0xM3ktwsl2mQe+FRb9BOQ9fsoVZjQBsDhroF?=
 =?us-ascii?Q?1loVDHYn1OxRLV6IDMfEXghmVf9+LEBjxezJVHhYio+R4je6qZ40finMLcFI?=
 =?us-ascii?Q?2A7qUjWb83drcdJwDJdJNiqFFva/ApMF9Eg/TKUlN8ta1gIV/r1U9ImuIMXl?=
 =?us-ascii?Q?YK25VHFJqfokWZcMgtVpfVL4/hIN+x8SdkrlQGUrWqvLJ4AJNldWzQACmLRX?=
 =?us-ascii?Q?gew2JUgZSxPiFDs2aqfQ4kxKVwivYbWWP0GTUM0JWb92u62T+KlxaFT22bnP?=
 =?us-ascii?Q?QPfoDsf7INdggQDrh4R8jcbMvTvwtlkhU7unsTf5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4131414-3d8b-41e5-f5f2-08dad248c330
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:31:58.1996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7lkoCexCHrGtxI2bQE727GCL/ByKDI3pqZAk2sV4XrUhc3WsbAb42z0AQRA2Us3Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6439
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ As with the iommufd series, this will be the last posting unless
something major happens, futher fixes will be in new commits ]

This series provides an alternative container layer for VFIO implemented
using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
not be compiled in.

At this point iommufd can be injected by passing in a iommfd FD to
VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
to obtain the compat IOAS and then connect up all the VFIO drivers as
appropriate.

This is temporary stopping point, a following series will provide a way to
directly open a VFIO device FD and directly connect it to IOMMUFD using
native ioctls that can expose the IOMMUFD features like hwpt, future
vPASID and dynamic attachment.

This series, in compat mode, has passed all the qemu tests we have
available, including the test suites for the Intel GVT mdev. Aside from
the temporary limitation with P2P memory this is belived to be fully
compatible with VFIO.

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd

It requires the iommufd series:

https://lore.kernel.org/r/0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com

v4:
 - Change the assertion in vfio_group_has_iommu to be clearer
 - Use vfio_group_has_iommu()
 - Remove allow_unsafe_interrupts stuff
 - Update IOMMUFD_VFIO_CONTAINER kconfig description
 - Use DEBUG_KERNEL insted of RUNTIME_TESTING_MENU for IOMMUFD_TEST kconfig
v3: https://lore.kernel.org/r/0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com
 - Fix iommufd_attached to be only used in the vfio_iommufd_physical_*
   funcs
 - Always check for iommufd before invoking a iommufd function
 - Fix mismatch between vfio_pin_pages and iommufd_access when the IOVA
   is not aligned. Resolves problems on S390
v2: https://lore.kernel.org/r/0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com
 - Rebase to v6.1-rc3, v4 iommufd series
 - Fixup comments and commit messages from list remarks
 - Fix leaking of the iommufd for mdevs
 - New patch to fix vfio modaliases when vfio container is disabled
 - Add a dmesg once when the iommufd provided /dev/vfio/vfio is opened
   to signal that iommufd is providing this
v1: https://lore.kernel.org/r/0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (10):
  vfio: Move vfio_device driver open/close code to a function
  vfio: Move vfio_device_assign_container() into
    vfio_device_first_open()
  vfio: Rename vfio_device_assign/unassign_container()
  vfio: Use IOMMU_CAP_ENFORCE_CACHE_COHERENCY for
    vfio_file_enforced_coherent()
  vfio-iommufd: Allow iommufd to be used in place of a container fd
  vfio-iommufd: Support iommufd for physical VFIO devices
  vfio-iommufd: Support iommufd for emulated VFIO devices
  vfio: Move container related MODULE_ALIAS statements into container.c
  vfio: Make vfio_container optionally compiled
  iommufd: Allow iommufd to supply /dev/vfio/vfio

 drivers/gpu/drm/i915/gvt/kvmgt.c              |   3 +
 drivers/iommu/iommufd/Kconfig                 |  20 +
 drivers/iommu/iommufd/main.c                  |  36 ++
 drivers/s390/cio/vfio_ccw_ops.c               |   3 +
 drivers/s390/crypto/vfio_ap_ops.c             |   3 +
 drivers/vfio/Kconfig                          |  36 +-
 drivers/vfio/Makefile                         |   5 +-
 drivers/vfio/container.c                      | 141 ++-----
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   3 +
 drivers/vfio/iommufd.c                        | 158 ++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   6 +
 drivers/vfio/pci/mlx5/main.c                  |   3 +
 drivers/vfio/pci/vfio_pci.c                   |   3 +
 drivers/vfio/platform/vfio_amba.c             |   3 +
 drivers/vfio/platform/vfio_platform.c         |   3 +
 drivers/vfio/vfio.h                           |  98 ++++-
 drivers/vfio/vfio_main.c                      | 347 ++++++++++++++----
 include/linux/vfio.h                          |  39 ++
 18 files changed, 714 insertions(+), 196 deletions(-)
 create mode 100644 drivers/vfio/iommufd.c


base-commit: d0bc1f9dffb03f939c4fc988e35b9f4bd995683f
-- 
2.38.1

