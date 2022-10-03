Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD24F5F32BF
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJCPj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 11:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJCPjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 11:39:46 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2291BC3F
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 08:39:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a82VZtWXkl+cghb5O1+lnz1wi2NtBcm0Ka2+H4JmySmkCrTbqmodxo4bNlbEL38BfGSje302Ty4uDQkroyCavx4wHhoICUU0GOH1QtqZ/U2+B1XN25Y0EdVeKNcRgEb3GxXAJNSEgooN6eToX7qstM0spy+ONPWbAbmKxOFgQR8nT7Cqhp+FAheSnpuBb1Tv9nGzMNi+IKxDdS/6ElPVYDGPQBYXlfQFUOvhk3KOBW8cdOwaMy8VJJE9w23PLgwAQD+NoDjwUkxPY+aaTq5pXzojXldh/tA+Qgl8ABnW8qELwI37XdEQYXPP5XIMguA6aXL0l4NhoJKjnZureok4Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rM4j61N9ULdIlI6xZfeO1VfCdz1K/HdCoZN4Hs7AIt0=;
 b=SP3I9OX76ytGUDdVKcvthHoxGQSCrWFcv+Jn9bxvG7/X0WcaryXu1SB4TpUD6x75dECpRLYGIaNMmIRfXLI2rMWKxvqKXqpT0gAPbgmSYKoL8/9nti2XRAnc0iurt9nnX8eSeaBkwGMkokFtYAcPP2xzu0XRVxST1daBKroB0GuT7pxCHYKrySbXk7nVw7sv6EpJO8qDAvDpB92dR2+oa2W6GQe3g6jy+Fteu0v65kGzeXPhEfCIlZhYYETOc9N2QgoPDm4RYC52K2aY+3mDjd+W3MVWIN1olX1xGhXDKGjaU1zV9G6xTTra7oUNXLoh7UYYoPE9inUjDosgIeMsng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rM4j61N9ULdIlI6xZfeO1VfCdz1K/HdCoZN4Hs7AIt0=;
 b=XRtwkZQOxIZBvxcYcOKzR9SF1hSfi7bkYbsagoE+Xi03s1i6nuzejqrE6DZuXpc7hnWCe+ihsbgbxq+ORyXnJMne8Psz2j5UstNI/F4dKy9ecjbILQYU5gJdCrb/gPRH8MGHl+lYzcp5OhKQG0C3xEEW5f6MoNK738bsDn5mYPv278NmvRI0j9gekpuCTHNKU9MUC2OJxPjVXArrkmOkfvE1cdad9nNUs2nhU/Z1EMSOL2n3hW+7DTTJKwXs0vR9Pf5XFJ+AUgb48+HWtl9fUIYXkGr6ZgGX3J6UrY3Zq+BERvYcfwDEaIamPJW/l5L3FzQ9oTEiGmcJSVnUZRbFlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5471.namprd12.prod.outlook.com (2603:10b6:a03:300::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 15:39:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 15:39:35 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 0/4] Simplify the module and kconfig structure in vfio
Date:   Mon,  3 Oct 2022 12:39:29 -0300
Message-Id: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:208:236::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: f8895726-03d0-45a3-074b-08daa555791a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: co9uWkGLJrdPp7zZBX1+rf2XdhrJ8SkhGqidXvH28tBZ3hQmCS2rQz5N9Ds7KrnY64qHiLxFRyCmCadGVDEO9yeez+TRdZehKRvhztcS2JAXDZFvUS6n6cK0hpZ5vv93IdUD39L8YJ20ZQ5rpJPg+iO8RguZYq+0ml56y1xlklYFn1KmExRQw6MWtESSHbwniNt53EOkpU04m9bKtkP2bguDNqcn0FDJO3si5lFXTpgl0RSazBYVLU2UvJG17bvS2hXqwRH9ILGcUnhQVIb8iwE+e97qkNxEldPR34XGMUNk4iROBA/DWy3SPQ+kX/el0dMJPKkTPBqD8F7XRlFxHwlQzK2VN4igVLJ+y4kx/9Ox0KFvlLkKlz9cX1y44MFNmY5gAU4eBoBTFDkaVsiSK+C7/WjboewDNUM+A8qmaLQSjczjWgBJbtOA00XLGCB6IE1KpqiQbLDRWNzVwoedzZbEW4R1m0QxIgOCMUTIh308bAwfcq0lPA8FPmaLit6wDzBjEyuI+0OJ2M+vRqjc9o7fWdCrHkQZ8ZyVZWUKAUnQtjFQdwK46u4nQtb1++58hwMYmECRo+Zh86MZxwj7nx0Hf80zoCl1hyJQkIqmSwkIu1RLLQKZ6knXIXE/dVVAf8rFp9PlFb37tDLHYwLw/sZdkPrXcuFSe+CoOCmR3BMae2pjBF/JQ/G0uIaqTo6DF1odz2OMtYETs3Qm7inHOxSYk4L6D5OCZHSljP+WnNzOO5zpVCCc8gWRwC2e/TZEqk9hAHEoRgRxOMG9A2xx/+hi0qzosguI7m7uD9eGFGOcJtD/CyYHCCgc2NhXfSKkT2UdvO8cPk2aHQCD5/GhIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(6506007)(6666004)(38100700002)(8676002)(66556008)(66946007)(66476007)(36756003)(86362001)(478600001)(2616005)(186003)(26005)(6512007)(6486002)(966005)(110136005)(316002)(2906002)(5660300002)(8936002)(83380400001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PBxPX7tatFTVgzcScznL5YGmJjrLMpcCVx023o/J4LwzhumXEbPxcyCJu2xn?=
 =?us-ascii?Q?ZrbJfHV3RqiEIZKCUktpnI8lSyHxBYsBM3qA964E23mP7T2/2n//ZpZP+hH1?=
 =?us-ascii?Q?r2bW/dxh0wWakUxZCGF++88Kt3ht/C6khBXoDs92qxe/ljkHzcca8lSg7hl1?=
 =?us-ascii?Q?BIIwtfBz3RM3DwyuGMYvUxNOxIRqSyb/wIWdoFiKu/p2qXmj2eqGk7m3z609?=
 =?us-ascii?Q?IEQg5sOpKV7yHoyO32fUCnWdsf9QoKOlnhgsy4T6+ODvfZFyljWOeaoSxIEE?=
 =?us-ascii?Q?ln4DHPPbG1ZwgHsm/TLyiE+5YRIL4Gooe7InFR+NpcZ1ZS/nCtaFYKHKMzDE?=
 =?us-ascii?Q?cR+uGDn1VC1j1QNxREYzeeYVp01QZ+Jz9DlWVynOiQJqReHNhELJav3GXXg5?=
 =?us-ascii?Q?HMQqPMxLtTCgcF+qrtyoWbkpU9qbet9tlJ4yW1pKV2UO1UUcUmrz1QcKgjvS?=
 =?us-ascii?Q?vvKtOMHyKENexvi2OpNOeRgB4qR/liaeFD21OvItOokkjCTulgwd1NcYqFVD?=
 =?us-ascii?Q?kjVN4j9teOLHtBs8s/1DRls8WB4PrsQaJLYtkleetolRqHCGGE8245vUwn42?=
 =?us-ascii?Q?hZ113ppdjPJiOcJfqIFaFqTGcYTe+Z6MhgrHLxE0+gp5zfXmLgUDtzZFJW+L?=
 =?us-ascii?Q?fls/zUq9mhByzUv8FImwW/Z9PbTncrp7+U+HC0SbFlWRM5HSave/1dsSvli3?=
 =?us-ascii?Q?4SCeFnRHzUCZHRkv3eB1adcSrepKr4pIdApttLF0pDWXNmm9Sm1cyHxgqV0A?=
 =?us-ascii?Q?09m4FgAac0hnCnyRfMVagIG7jrmWcMbbsLidK3Hy9Q/EHUnQwdiEbpTc8gWO?=
 =?us-ascii?Q?KzhcZpXaer1hbzGlK0qP45UbVxWbkVVuB8oMPijaV3kzgxfXC3XthbD8v4xO?=
 =?us-ascii?Q?ONOuQIrZmviYWDD6GLB1tMmZvkqeSOOQTAD7E1TFTulEL872iXdFUMwBV3M5?=
 =?us-ascii?Q?R3uFju0cGGx5++v6hiG/T6fCSS4mNkbUL1URaLjyd6aLL+5B0/NWZse5XGrB?=
 =?us-ascii?Q?CfqWJRKLv2jLB4fmTAiigg+ct2r4D99YmDJ0OYmbAdu/cRpmrdfT7LKZUYWn?=
 =?us-ascii?Q?ykXw0fo3u6cXGTmlfYgFkljmSrt72RQYu4IWrX0O66xFaXmT2nP5kpHPppDQ?=
 =?us-ascii?Q?Sk+drF4GZzS2VmEUeXdhybwHiEXRQr1y9/QbKmZDrIvVaS3/7pmtqTdCw6JP?=
 =?us-ascii?Q?smiEpYlXrIndy4muVJPUFqDwK46vrbInMfLXfEjHwfEkwyB4YbL/gh6IkVMa?=
 =?us-ascii?Q?vs7vw8KIQ8zivtsavd5MNACNvngrDK+Y4AJ0InwJozn01UKELbS6AjO1WymG?=
 =?us-ascii?Q?wZAxpr26UZNbVduL3f0Vx6t/or8wn+WPlMojBunJfvSQKGtcLZTUH5UCDhMg?=
 =?us-ascii?Q?pAlFOAIGmGREmPo2tD7+16SzzvN6/Eac3np1qIdi5aZgGq8JxHajeYkhEuSP?=
 =?us-ascii?Q?uTFJZG+3hvNHtNmzDjx7Il6y58tHJjXd8Klwo2WHFewJU8LjG7V7/k17N50f?=
 =?us-ascii?Q?uK39cTbuKLWYJqskLZcxLhv8n7cCDmvM0sbZBukPBRHkTUfFM8XcOEdjV7IR?=
 =?us-ascii?Q?MVR67ZEhWiw6R3EkSos+cBU+kc0CMIB7cPcQsAoY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8895726-03d0-45a3-074b-08daa555791a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:39:35.1085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWZ9X6bM6EQJCktT/HIdAdRBaM0cFX93ALxM1iwgGGCPhBSuj1ch4sLUlQC+3ru2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5471
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series does a little house cleaning to remove the SPAPR exported
symbols and presense in the public header file and reduce the number of
modules that comprise VFIO.

v2:
 - Add stubs for vfio_virqfd_init()/vfio_virqfd_exit() so that linking
   works even if vfio_pci/etc is not selected
v1: https://lore.kernel.org/r/0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com

Jason Gunthorpe (4):
  vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
  vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
  vfio: Remove CONFIG_VFIO_SPAPR_EEH
  vfio: Fold vfio_virqfd.ko into vfio.ko

 drivers/vfio/Kconfig                |   5 --
 drivers/vfio/Makefile               |   5 +-
 drivers/vfio/pci/vfio_pci_priv.h    |  21 ++++++
 drivers/vfio/vfio.h                 |  13 ++++
 drivers/vfio/vfio_iommu_spapr_tce.c |  75 +++++++++++++++++++
 drivers/vfio/vfio_main.c            |   7 ++
 drivers/vfio/vfio_spapr_eeh.c       | 107 ----------------------------
 drivers/vfio/virqfd.c               |  16 +----
 include/linux/vfio.h                |  23 ------
 9 files changed, 119 insertions(+), 153 deletions(-)
 delete mode 100644 drivers/vfio/vfio_spapr_eeh.c


base-commit: 70481365703c5a8654c2b653cd35b8ae8650b6f3
-- 
2.37.3

