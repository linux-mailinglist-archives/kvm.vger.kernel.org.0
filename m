Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D16509062
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381793AbiDTT0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381785AbiDTT0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A798445AEA
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmWTW+PxilCxvBLsVv6PzaIqg+hd/xsNvqT0GU8ZZGc+a1icNQu7lY+n3DzvoXY/a+erceBkAO6M0RKxJGC2zL6fvM7qjzqEGH1eXPMe1B26hMN1p8EvtbPBUlkskBizbphVYzL+qfvai0Hk0R/VAA7tZ4NqliI1E7EUSMVl7iOvmZXfGbRItO71mLbjz54xnmo8C3VM04J5KdRpNFtrVGGqGOafdiv+/aVOYkusaN66QbS1Wkl1dQMS/MsW7ilOi+oZwbHFb4ExgJdb27rdycPAdrhOOv8Wneufgizqq+CtvBwGNCbPRH2m0U5CLAfzaCeetuW4sGY2+0+eT0EOqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+c16RjTyAz65LYGbdV/WMYRAD2DqdE7cCqx5nWYYPrI=;
 b=NDJ7kwgGP7eWo3BkRaJlgDj+bgNDqEQ/Ytj6XeB51A6/blWmWybqdavhIijfZ72cuK8zf3uYGVS5BufQfJkALTuydly5+eMbPl7zRlhWGnc34jkq+pd94Jo5ZMV0bQdRqhjNxl3m2Srpgxx2jWPZDmiNX+Hlw0yPSD8yGF2PkwJRQV8g/Bl5/rF8qxR3JRM5ntUGgshZKXDJngno2MJ9OF85Cm3IKuF37FFWMw56zMJk4gST+rs1hU2yaGa6Rz77aSbhvzM0swyIKweUgv1LBt+FgFYVb3Y90Gfjgygq7DJXSK9pPuMZbvFdvRPzxL3/vMSkADXGSgM2DnRZTo1tEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+c16RjTyAz65LYGbdV/WMYRAD2DqdE7cCqx5nWYYPrI=;
 b=Xl5NF1x+LM8M6tEOse5jC3bkWJiENzVK6MYz7VeL+fN9+dftGD98WMMb+f8mIxFcRVQvi2ZABP/U/cRdmn/kQGGboftD9r4ApqTs6DT7mVUOix2H6PNKjxCaTQwnFPXkAm3tJD0oMaHnnY0AHmYImVwf2Vu7Rbz9gULpLNqfwaSfaYha8Ekm3SeNBCJJrjzXG05OROUptb/3nf1RqyeyTEL1uTsL1A8wpv9clGJ+9c33q182mHEtLJ4r2+Lkcw4jAAMl3w4GpaGjgLTf+DuhRdBFXJdKBG5Wxoe0SjGLfuIZOEImM2XwI3xz33KMAIa2afz+MeC0GIGDtxSPkshvmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 20 Apr
 2022 19:23:23 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 19:23:23 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 0/8] Remove vfio_group from the struct file facing VFIO API
Date:   Wed, 20 Apr 2022 16:23:09 -0300
Message-Id: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0104.namprd03.prod.outlook.com
 (2603:10b6:208:32a::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e868036-3839-4672-0ba4-08da23033a28
X-MS-TrafficTypeDiagnostic: BY5PR12MB4131:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB41319844C6D5824231614964C2F59@BY5PR12MB4131.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfCVHk0uI8+cOzcCiE40A94cjIeXs8XncIB20wmUR5doUfKk3VlyEK6xnbt45hwSOAJkbSBsFg0ND6vGnOueaZkTAXcn+a8tpK9jHnxdGKBUcDUj/5rQew2oQOh7lcm0fd5x4GliImlZGYpT4y1CMKWwdq4BumgRF4s4Z9MZskka4BZhdUqR+ogE2WAfiXGNxgXNH+U9aU6QxSI0+j9K61j5dOSBmSCk3BbVhGFSrOKwuHpBVRV6uzQzl3Axs61Hg6qrLd4Uha6Ev0WpdnmnwPfkQp9B/g4XYPpxWgWJPDIg598YTvlGckgLJ95HDUGueXwQkA6IO+NhwoFOC8UxqX+daJaV4XHLQW+pYQR6Yc4t/lpXAKiHaOHfXfn4y+UxJgDbkhj3RShCAEIpnoNJIXzAAVhTWP3DCXGxkomvdRbjn+PJ71QTvx6hOYkM0t57KTFR90DbVbZnB6GqIYpCkW5uA7FMErzsoB+Otc8ehJwlqzlJTE/xgS2P6C0DNT/a9Et+Q6vK0NnX34WLcWDMx71cehS4wdEifgItUSqwHixoc0iWfY/ls2/5BXywThFuCM5hkj6pwh4sA7Nj2nm2yW5WIGS7Mx5rBGakSSYnndFwDhzTQrY2l2+7BSbZ/CACX6nPs+HdQaAMYpdnvSlnku6ATLX9aJArLLsfjSSRFnzw5pmMsDQMhzQF1lmYaSnN4RQty6ujuClFymTXSsa7OLbcmgPO+PTUYZuuUFmtYi5GJPxJYowKi5yvLQUJOnHo6Au3+k15wE1fjJwZZdiv+vLODmsjoWNxhs3CIpAEnbv966Vq6+MufDKf1dAcgLRA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(38100700002)(6512007)(36756003)(6506007)(66946007)(2616005)(186003)(6666004)(66476007)(8676002)(66556008)(8936002)(316002)(4326008)(5660300002)(86362001)(83380400001)(110136005)(54906003)(508600001)(6486002)(966005)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X2c/tw7wACcjYoDMb6M6PamtIs0wappRswHtIUkNV62BPMKxofgM3uTv1J7J?=
 =?us-ascii?Q?JedUnu6mOCwPaTWylrNx37PXc+j3Z62SEESngjiT2QTwIMI10ypBw3lJuVR0?=
 =?us-ascii?Q?5sSQo70yRHN485eU5plAqgEYDFL6zAaclfohrlxuhC9CtRF1Sy3x5j9E14JK?=
 =?us-ascii?Q?DjNqh5zrCo8knzD51sUXhtuSgkX9UoR9/NTBih6nDlFrbPRerAToHPRNWHbs?=
 =?us-ascii?Q?m5Q+gul/uALNJiGubQfWC+jlST6+OZgEIlR7zJBVDYOMwIQAWq1qle6Pfyu4?=
 =?us-ascii?Q?2hRoddSUSZGN2GvEzswg7rF+qKRpH9ybSVsEAD/PE/XZibTynNjoTA2rCeJR?=
 =?us-ascii?Q?gbZcsWrlgc9f5gpUxHmaEWUXigzfsmdHFyMBYrQWZstbGXRXx13V/0zAMYnd?=
 =?us-ascii?Q?Xq656JvEuXHSgr8EUQ4SH0ElLSO8PzkMHFgH9dMWPXptc8CB2YSIDgk5hfDi?=
 =?us-ascii?Q?1eRDZ4R8UuK64mcSBpMlfP3dA6w8DSgPsjMr8Z8psIewqRRR6yY4r3j1N49N?=
 =?us-ascii?Q?Q83G+VqCp6+dOBGF2PzDDPtFcVS62mKOe0CBClLuSMaaPEuVKf56iYuOdH9x?=
 =?us-ascii?Q?Cn3AYZ4NHu4igAq38uMOPONMgvHjLzt1yW5pXrcaMll6OF6VKEnL5pOTtqjQ?=
 =?us-ascii?Q?4LvS7+4M90C2h78PULtxnhZk2nbhHVRLCbVwU/XEo9rb5GUziubfw/04lpag?=
 =?us-ascii?Q?4oK3kn5u3ZKRjnfmvJboHIni8zAIna7O4kpz1Ym7p18abXZYDiw/8BtnhmTP?=
 =?us-ascii?Q?+lyE8E0fAswvxYvkEx+rjlGQnrys4RWg2hEac31BliBqlsFWvVGEYke1eZqw?=
 =?us-ascii?Q?I2quOsAIbcntbDtyNUay7ptMGOwGxOnz6Mhn0POtYo6AHCuFrMcAbk5+QjJ5?=
 =?us-ascii?Q?XapfiE/5d5AXIEqNMVkoSZ5OK0NwSLq6ash7oXxYpDdXKifdE5/oLAQVZXhZ?=
 =?us-ascii?Q?jMSzUbri7rhjI3yunFrtWkXDxr/vWEEhuKjgFYFKn2kPknghTNiYu3RvQnWa?=
 =?us-ascii?Q?YTEWxJJEP+nvX44WYC2zJOMvrAwuedHPihJx8ODvVv3XSqE0d/PpOvZ2pOhd?=
 =?us-ascii?Q?i5nR01TAMJYlohgXMGjqvsaGGLKGkIUs+KzuZSc0KPO4VFkUMs2on7n3vgf8?=
 =?us-ascii?Q?FD9UaaJN12HlZZy3wp3X/6BXm18rz3qg5IuWbSjD20HLLXaHBncuRddciNbP?=
 =?us-ascii?Q?YtoWUKZDIMKprhOrftg56nWPdsp8en6niUf4vCMDTpSQ5WM1bQ+iAda9UPAb?=
 =?us-ascii?Q?kulfq8VHdzAX0jhmPvXOLAo6lUV+S6NXSfCq4IH4rqFD+sClVoFqHjyOgLMc?=
 =?us-ascii?Q?75ymrwjiObfR9x3GMmE/EXcB9kwNsyqRcSzNFrgHGLSiKwZhWrnYcG+IYld8?=
 =?us-ascii?Q?3MYNsa4+rKtIx00YkPD73gY0pFGg0fs4bWJgECWUFw4LKYf/AlRM5OkT7DJq?=
 =?us-ascii?Q?7OCXRerQWGZHiYtM42UHkoNhvfS3dYPMlwz0FLzj5I5mbnPtC1qOs9+Fnpc4?=
 =?us-ascii?Q?4oRxz4F9QEps7iF073XucAn0R883VPGhOUZ21hDmy0iLWSMgXNG1wjl+YJr4?=
 =?us-ascii?Q?hBi90Pg5H1Wk9DHmoiqUUnYwjnxc3ino7B+ck4mVdkSBaSBl6AnGK5qeYG05?=
 =?us-ascii?Q?abJMxg+1fdO5gbsjACeyhON0UTEo4lMKw9YdiyT6RwAvJDKei09IamzWoF6g?=
 =?us-ascii?Q?pX9OOKwv4pksuGO4sWBSRcgIB5MCyYi8UgDZi9djxFi/NQ07tM7SAc4lidrY?=
 =?us-ascii?Q?8+6bX8RD4g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e868036-3839-4672-0ba4-08da23033a28
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:19.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2/Yx8kO6FvvgpN/8Gj3GVEenwbKNujTCMCwHx8An30mTGSMoz3OLoraFhzOXGlc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4131
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the other half of removing the vfio_group from the externally
facing VFIO API.

VFIO provides an API to manipulate its struct file *'s for use by KVM and
VFIO PCI. Instead of converting the struct file into a ref counted struct
vfio_group simply use the struct file as the handle throughout the API.

Along the way some of the APIs are simplified to be more direct about what
they are trying to do with an eye to making future iommufd implementations
for all of them.

This also simplifies the container_users ref counting by not holding a
users refcount while KVM holds the group file.

Removing vfio_group from the external facing API is part of the iommufd
work to modualize and compartmentalize the VFIO container and group object
to be entirely internal to VFIO itself.

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_kvm_no_group

v2:
- s/filp/file/ s/filep/file/
- Drop patch to allow ppc to be compile tested
- Keep symbol_get's Christoph has an alternative approach
v1: https://lore.kernel.org/r/0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com

Jason Gunthorpe (8):
  kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
  kvm/vfio: Store the struct file in the kvm_vfio_group
  vfio: Change vfio_external_user_iommu_id() to vfio_file_iommu_group()
  vfio: Remove vfio_external_group_match_file()
  vfio: Change vfio_external_check_extension() to
    vfio_file_enforced_coherent()
  vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()
  kvm/vfio: Remove vfio_group from kvm
  vfio/pci: Use the struct file as the handle not the vfio_group

 drivers/vfio/pci/vfio_pci_core.c |  42 ++--
 drivers/vfio/vfio.c              | 146 ++++++------
 include/linux/vfio.h             |  14 +-
 virt/kvm/vfio.c                  | 377 ++++++++++++++-----------------
 4 files changed, 270 insertions(+), 309 deletions(-)


base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
-- 
2.36.0

