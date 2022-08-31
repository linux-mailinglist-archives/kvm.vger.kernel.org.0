Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F398C5A8763
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiHaUQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiHaUQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:10 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18A0DF644
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljmE6kR47Uw+pbAkxWXXArob0jnNGjrtJUDDTGiUAyNDyQru5Vb9VaKYzm1OJ0zLQORyVAjMI3jhVBanK/1GVE8WH5nb7lGnHc/Zo8r1F6Yix7pPQS83ndxgSapftM+ZxWgTzfdjvhpJ/wTn9ChUlaql8Zt/Y4slmfBu2cKvr2YzRiOsOh1EAwNh8wC0oxGd7iTIJMB/zA/DxGxSu0vfhVaPjMcwF2kSwthmS1c7JNjIa1LUOU/b4nT/Ck8W/6GYAYJPKY3iDNGA75UgGKYtU8dj+ocCNqc6RrYopBe9pYJ3XBuxx9IbT6i69kfnwVnlF+93nJFctZ8Te3qQxGSnSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sBWJTncenHIFCWjtvCy/umFZmvPIEypu2yEcYlniq8=;
 b=g2GtKPkANTbAzbrGuS9/xlCoGRio8FvTExnVpCfTarfZvKjtKYAZN6L1oJx9EwESXoGl1KKWly9jw40EH5aThtSTiG8qxbuo98UMTd+uMvIAxcLo4xjbtFWp73Gb/sjLTCxickwGEc0Qwju2+E+cTBL5WQdKldj2TsaQaLMIq031CH2pJcMy+XuUj1wfAzs8DUJOycldi01RHznF1enkBOlhgq+meTaaQeG5XXfnj86xC4nK/gK20mcFrDfjfq6dvcrFn2g66OpfdAAE4xvSkVrLLwDE9GvmFZv5xd8X/OQVq/ccVwI43KohZI9IB/GLeqv6NOzxwuz7r2yHc+GcsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sBWJTncenHIFCWjtvCy/umFZmvPIEypu2yEcYlniq8=;
 b=cpZ+ZJ5IWiK7bfs25TLZVxo5VwuRZiFaNTxrqzYY67CIxJ04f+fenP/0qhZ4av13zUdjkAv3oaJk7/mtycGynFcit/7J4wOiLUeRytQ7blWW3+gIJCPBMIqBPO4i06vkZPoV/loD9lpbQCPqJ9ia/Yye49ZfLvjfQ8LDCFvB1fKOYQW/+L0MnJqc6xRoOVqQeQEFeeSA599UVcpxeYO0DfBs8Fa8HszjqYOp/17g5X4g9qmSj2k6gHN2/HKFAHkWXWkH7KBiSbJrRFdoXnZ4pQFQli8U8Pc9MnESNFLxJ2VrnHzbTbYvu2qEWp7prpSZUNuYsVkMz0Lgag2a69a25w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:05 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 0/8] Break up ioctl dispatch functions to one function per ioctl
Date:   Wed, 31 Aug 2022 17:15:55 -0300
Message-Id: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:5:100::43) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0d8546d-c8ca-4d52-1bd0-08da8b8da1f1
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+UEk0D79n5vGUyPAx/mUvE4qZZyffCpL3cg6ZR+1j1ggM9DHqmrRC9UUz8ZeNJSfYzY4OSKe92iya3sdlGvs9geyvaMCHM1VYgY93v0PhlTn18Q1GDbP96WwlbsFrmM8c/MS2pjW/L7riq71lTmzirx4EKcRg1PSSNHRXc8Xc0zS/el3dDfWpZ4sw9CDFxiD1+tOblRo0F8lSoe8ClZOkekqUYPdkwDXd1ULsZLAnPK93eaLyUFcZdtoa9XSHxC38syLjW7C/6INrTnKxcKqFKBmNLdUnwhwxpsXRolxDrQdVu7QvNX0knaOn9Qik0wuhECYH0bjdvPoAzU+073+l8rkq66fJSiMEvDlFD7ZaJ7oPy7skIIwNVXFOf9nk4R3x438mgxAGQME9Yc8+ACckolLzscfiO/Pj06i3i89sL2UivnOebAPx2COBSZ0zYQd7mAIb5dQ54VhdvVpz80BCHgDvyfRzaz5uyEgRdNVAth3p+qgqGdv1VL8Glxv70bg32kUw5B8Vo71zIo9cxlJK6cYNtPAg8awBEXFV8omDxeaaQEA6I/xdtcCPr1L800BortsJkkcmaKsFdvO0eNj4urVAiNFmUrmnk7m61o/8OK19RUjGiXM6ZRoE2Ee6AaT5lV12XLmnvvQDIkWsIh49gKe9zyZkMBGY0ltm683g54kY4z2pRR8BGc97XdNoRuCivGri7+X6D7HQiMN0nProQg1gdoo9Pl2Bs6wbrAypUhIdBJDO5T8JZmffGCNyEX9iX3dSUVJs2fqG9w5X9xIlGg0eMRzuPqyFwfFRbkEzyZdiSeawBvpP25F/SuRIx5E/zn+c3W1sODRmlF4OT7ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(966005)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nXCZIqrMMg3FgJLcdeAwoH1PXzgTND2QZhS7aEJ/jPDX3+IlGjVkSC12MtrD?=
 =?us-ascii?Q?YRbqXry+9Lfue+5nUSQwR+lbQMrD9ecZVvwVtCJ5ogspAL7pv5Wb1TLTnuHC?=
 =?us-ascii?Q?7YXpCnq2wMucqdL04RInxZle3MpMbsB2ZgoxxxO5hR8WE7rA7uB01OgVkNk6?=
 =?us-ascii?Q?f8FFKw2Sb6RM8tbgd56oP2EF/BWG2JW60bVBI6BQNnUhDQVbm9eCKNLWU9SM?=
 =?us-ascii?Q?e6P+ZTYh9cSeEJWdF++yQrUQ6/BI7wiq9jdNATpnFVkazLLYW2ryHk1MQgUs?=
 =?us-ascii?Q?WVSRN5UCdWv+1GShCxBlWGvLs0Z5idbe2EWwF5OaiB5ij3/5RaRFWaR50fCQ?=
 =?us-ascii?Q?8jx3Qoc4Gg2glwOI6C4x3w099e4ZRWMB2GnnZ1/2PiLXStWVATeg8/yx+8lX?=
 =?us-ascii?Q?bnRb/KKAEBZs0G0ONG1nf3CDL4D4MMZrAfdqNH+ryTsa3rDuZS6xQJtxLjS4?=
 =?us-ascii?Q?a5nR6kY2V8A+EP8/taoSWcuXCBrU/BBXmv/Qb7CveEWrXMqFWNgkfcD2h802?=
 =?us-ascii?Q?uaQmO14qXTpVA5BSByTlaHEkgyqw4RddWIP+5xhKyYcG2G3Gpms/mbxS1fPZ?=
 =?us-ascii?Q?isriP/wQG1S9pOkbk8VOfwp2pHiiBfcqcj39xV2YT34U6XDN2tF4sz4ydzLG?=
 =?us-ascii?Q?4Q6JMrQj2uCpOS6pHP9FKfZP/uRetRlluqNjYTx8P+NZQui1DfskIxZTyHhk?=
 =?us-ascii?Q?PBHPxfObmw05ENsa1+/+oxr9GhieoYJ3rh2AOvZ5JZ541LGEMl31sM8hHhS/?=
 =?us-ascii?Q?IgpXNxTvcaqn9b/lUyVa5T+fNwf7ykwZWzKkaRbP8rtS6xgLGFZ5MjlT5qru?=
 =?us-ascii?Q?TiLD8Ztyz2KTAKOHhxVCA68TNHqiE/GGu1RLzsXyn8dphP5EyG4xmlKF76kZ?=
 =?us-ascii?Q?RDsFo1aTTXQ3ehwuKEl85bT3R+SNmz3eWn/5SjRlwxXqTDxrxwfkd6HY/RfP?=
 =?us-ascii?Q?/1kkOU1uBwz7IzRLUye3UL6lYip7IZY/BBlOH4X0g0XFx0i0a3zaHN18Yfes?=
 =?us-ascii?Q?I1ySisVqJjl/mgf/856/bx/get1aDP9zON75PnqQFV53LJdkA6pF4YOiqWax?=
 =?us-ascii?Q?QPBRBb0CJqgGf26cbCG7a2fDKygVAjMvSY9TU0CSmI567vsoUNZ2cPUeoN4m?=
 =?us-ascii?Q?BsweVdHNe5t7VPwnIoD9az6egnbdfn/fEcT8IKglOjth02IawLYvgpR5Bz1C?=
 =?us-ascii?Q?+ODTnjcZv7qOtnvwCW4BUCPvLGcGmlbpZ7TRSdQX6BepLu6UBQZ3hQdM9kq6?=
 =?us-ascii?Q?L1dS9WaVP6JnD1/OYf0eMd/GlLt9rarhLpmfWwmQTiuqaYUEpPvWBW0l1J4a?=
 =?us-ascii?Q?POIH0QJCTBrX/bQBvMXYqfGDqM58DQEfSNkve187A/8jX/siPZvXnweUP9SF?=
 =?us-ascii?Q?g8p0olb6PcxHLAtvX8kR4wvskA+nJgKY/NUx2AYW6fBuJxaoMWRJLP80sMvX?=
 =?us-ascii?Q?zyb3GuL4S0kIsP4z+lC0n2b3nrLdNHMtKqHqfjsDxVFj3v7Wo3W74xXD9sBR?=
 =?us-ascii?Q?5b7sFGt/DbGuwzyiBip9vQNGYGWo8eGKni2Cfz4m1weCpjDBShJgAs9gXS0r?=
 =?us-ascii?Q?Eu6Z5e7bKH7D79ZNAXxb6ynzE2opE+AUupzsQ/hb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d8546d-c8ca-4d52-1bd0-08da8b8da1f1
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:05.1022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3+3og0sbQ6KBm/4EsohlKdzSkP0Wrx6WiYcdWHh+aTNtQGM1c/g6nWqn3RHObUE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move ioctl dispatch functions for the group FD and PCI to follow a common
pattern:

 - One function per ioctl
 - Function name has 'ioctl' in it
 - Function takes in a __user pointer of the correct type

At least PCI has grown its single ioctl function to over 500 lines and
needs splitting. Group is split up in the same style to make some coming
patches more understandable.

This is based on the "Remove private items from linux/vfio_pci_core.h"
series as it has a minor conflict with it.

v2:
 - Rebase onto the v2 "Remove private items" series with
   vfio_pci_core_register_dev_region()
 - Pull the locking into vfio_group_ioctl_unset_container()
 - Add missing blank line before vfio_group_ioctl_get_status()
 - Remove stray whitespace in 'return vfio_group_ioctl_set_container'
 - Remove the 'ret' variable in vfio_group_fops_unl_ioctl() since
   everything just returns directly
v1: https://lore.kernel.org/r/0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com

Jason Gunthorpe (8):
  vfio-pci: Fix vfio_pci_ioeventfd() to return int
  vfio-pci: Break up vfio_pci_core_ioctl() into one function per ioctl
  vfio-pci: Re-indent what was vfio_pci_core_ioctl()
  vfio-pci: Replace 'void __user *' with proper types in the ioctl
    functions
  vfio: Fold VFIO_GROUP_GET_DEVICE_FD into vfio_group_get_device_fd()
  vfio: Fold VFIO_GROUP_SET_CONTAINER into vfio_group_set_container()
  vfio: Follow the naming pattern for vfio_group_ioctl_unset_container()
  vfio: Split VFIO_GROUP_GET_STATUS into a function

 drivers/vfio/pci/vfio_pci_core.c | 800 ++++++++++++++++---------------
 drivers/vfio/pci/vfio_pci_priv.h |   4 +-
 drivers/vfio/pci/vfio_pci_rdwr.c |   4 +-
 drivers/vfio/vfio_main.c         | 161 ++++---
 4 files changed, 496 insertions(+), 473 deletions(-)


base-commit: c444ddba00ccce817f6e1ca6b71b041dd1007a17
-- 
2.37.2

