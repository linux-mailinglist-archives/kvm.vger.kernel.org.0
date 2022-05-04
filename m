Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18E51AD69
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357259AbiEDTF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343627AbiEDTF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:05:28 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2089.outbound.protection.outlook.com [40.107.212.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01E52DD71
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:01:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8k6MciZHtcif9nmc1O/kbw9AV+Cr2yf+qq9MY6Ud7ijOfJG3oxSXnpIRx570QKtRvKe9hUogKDSgeyP0dtXm98ka8t6q0Iwcg9OZoCiaqAUZMRwstRSO6sDAspepEZghiJulWsIQxnVMf5ci7WzGXsV/ibzVFOcYBdB9I0rbKx0VQupiBlfzKE7R2gAZqKDtO7uZOD5wa/QNbT2X98feLc+13OToEdizeZXPlERyMK/Ae+q8u4tiksGj1fBNcdjL4Te5VI1Mhw98TEpMl+9uXl5cMGAhg8eYBetEI7F2iFEl4hUtS3mutQDdS/8DpoFiltmmnt2c5iJKTyFgCAc+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gm7GQaHRVEPQtJmWTP9Hyo2CKce9ffedHqLaVOv220c=;
 b=A+uNMCM0kR5axz3x8n9hxmAOaZUNEnXQi/i4mb7ADPrC3ogbuVTS+/lH8l+o3vpHLBhJiDjIZntrN/VW5brd9DMOZCNDlAytXQR3r91w8IQKSohkBJ86gha0dudj4P+qssRwnNQJVMdphU0EpZQAlH9F6IwVpxnz17/g96jqRA8zsk3EqHCgrFzqvMnjOR4FWCPNILWDEvJSJh2vyiuaYIyDo51QZAWpVKhQ8+IredC5G1Ihk26Q7a+7BuRgmqszmAYVXRJQ+QyWx9YjVq9GrOjeAuKe/KhdYTRKVEc+iCriVGx/s6A7Rm74IdAMKhGYFbhwvqRoNzOYnJo2q7x35Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm7GQaHRVEPQtJmWTP9Hyo2CKce9ffedHqLaVOv220c=;
 b=Y9i32rD2Z8IvQzqljbP3q07cNXngWXf1J+rGe1uOH65BrwfIghg0ETvOmaJLjxv6BQUX6nfpNNrYZEokEcebFxHThlE8SuuRXluZHCQRx8hTI/YtrVhQHwcoQZBNoxrVPOF32MpaAvrFwhy3inBnaR+dZrpIsa/JCyVa5EbFJ1+AwD5w/NLjZFDdacNixHKAND3W5ZTSOOZkywPUDLp9GkvYVyjIHIe90IA7ccTHU7B4CpDlYXtHIl9x/sOc3C/+b5HwGoUp9Q6qhb9IYDZh4Xf775C203Dtwo22MXs5DqKnx6Y9NTvRsN6tBzmuGJSk1L1HC+9+1xcIK3zszv2tvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 19:01:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:01:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v3 0/2] Remove vfio_device_get_from_dev()
Date:   Wed,  4 May 2022 16:01:46 -0300
Message-Id: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0413.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3850ab55-8907-4e21-d786-08da2e008b12
X-MS-TrafficTypeDiagnostic: MN2PR12MB4270:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4270D61D72A022ED795D2505C2C39@MN2PR12MB4270.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5IrJhNMpRbJ67TYHQk8xYww/iikE9X8wS8bP8TBpaiG5hQG0vTL+kXb8T8I7w+jl0u8joLIHXqY6fyWA/th92Klbip8vWm5iimGizQlBiYwvKybe8DNDOh7BvkJnNOsxIoOzaz5PF7dy3iGCtWpprUw7B6NitPrexeZZOkEs84bU77qnlS0xsT1QAi9nUn4JSiGlm+W6ckSlkerxKRdAvyxD1qZSM/IqDrgA9H04NWdA0An1V8ZER+ET9eAxTg+9/Ou4Z/c+Ch+k59XmUqGkBp1BrZdfWeEu/1GaIYDWhw7ZIG4gVObAliT0oTbQc1awWXDqe8HiEiWmuS7UVAkgXGbgTiVmyUbkoH9I1PcPFdp7QZYxNAZu/bP6gQIRC+ePsp25I3uLD2smLkwTqZfFO2n5Gbjr7agV1R3qO79kYDI494/VR7vj9ZndlWLd/I2Tb8XAU+y0qyQ13s56mkPdyTASCRq6jlcT2jF+J4bUalKMEOEswRczQzrkXbJXNWn8LaFFb/ea///Qow/ZcIPVMOeGwQdG+Ic1dNA5HLVwcGO2QKv0TtJ57yz1mY3uk4UyBoEoP3Fx6NOC9+RCQkCQzB4OhkRWVGX96yb+IJqQEXtbJ5Kdmgp2uwoaA18F0VieeoocochrCJVoYJ0gUf30WdpJujCZ8/6EGDpAK+P4sIYo4h5ChlKwBw8yNwIkQ7FCnkSW8+imPHY11tKt1p9V0Nh1EmVIfsGd53JpnTUkUbbEeuhAWL24nKHpP0PgYdB0XIwLLLHNK7ND4SUjV03V7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6666004)(36756003)(6506007)(8676002)(508600001)(6486002)(966005)(26005)(38100700002)(66946007)(4326008)(6512007)(66476007)(66556008)(86362001)(107886003)(8936002)(316002)(5660300002)(186003)(6636002)(110136005)(83380400001)(2616005)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tFo/HXPUrMnSLy7vXqhc0aGogjNpSGI3oFMEKSqmjklsVleAe3Sqy+r5dK7q?=
 =?us-ascii?Q?TLJfHZcus7vkR0TVUk+vYuc1fyX3ZHwGIqwYMEYpdj2bHuXIYpag2NUa3g1i?=
 =?us-ascii?Q?L9h2TsVMvwj6FwBBbTrs56/O6xP3hlcPhAIetmVx/zMHJ59Se/v2MWbjUWFN?=
 =?us-ascii?Q?qx8bOtcM903zLhxutDDu2AShgrXo84BbzRe+KGf95uG8Mvvjgbm2tth/BZkq?=
 =?us-ascii?Q?b28rEDvq4ReUzDi2RfdlCrn63QEDLm82q8kL81KA3wANPHzeJaEZNvzdFRg7?=
 =?us-ascii?Q?WyoDy7zMSo0b+gt3n+QoUXht5L8Y/TL4wRHORbtEorvNgIbkIEvL8aJFrFiu?=
 =?us-ascii?Q?CHI3U7IXUBm6F0l6XViVlhln8ljKMcQvqbgg9qLmwMJIBuYCAgcgTjw54iRu?=
 =?us-ascii?Q?M6xxvGPrfAHkRK1Hk7MEW2bN4hYMZLsBG/3G22oEWumKcxqS+DpgmeEmeFfc?=
 =?us-ascii?Q?aqzpAYgRLw3bBMuHKScbar8jI1VSiXQj8ARqzz+79u+N/4AJT61wgS3hdtSm?=
 =?us-ascii?Q?AIo07ElA8z2Da+Oa8Uv+BFomA2rkYgwMMvbZdNyWJF3FrqVS8Vx17OmYkqGE?=
 =?us-ascii?Q?Y13B50hiZUGXJ96Wta6GWzu1kFlOJhTMyfssiAQMiM4Ar4zcJVlzFntt2tes?=
 =?us-ascii?Q?RrarVVzBX2NxHGQXrRq4yUid16qZluBFJA9eKyS0S2AYWmGxX/TDQTlulpLw?=
 =?us-ascii?Q?Zj6mSvonOO+kDRor2VPHMX+ilt5xsDTzfkDkpS8/OvGnaFGj5tlwraLfaGur?=
 =?us-ascii?Q?k2/2txBNfAs4Rd2aw/GvLUYBaVCzedh8A5zsCBzhE640uL2IkLpOit//Y4Sp?=
 =?us-ascii?Q?TtksJrS07EUUD4NZWWCmK6oiZ9jfwG+a3prp9iSEj6NhSZkBOEYB6HVPySt9?=
 =?us-ascii?Q?Ebr/6NAjPSjUwhyJRf8uPcJPB4LL6n1M84nBw9WgdWaIVYjC5ZA/mjXGSfnI?=
 =?us-ascii?Q?3NZWBpLl1FSt8wkYXu54j1gzNQzy5aBcFl0PC3YPe2J+g8FyjQajCqv5t+Tu?=
 =?us-ascii?Q?L7H4lAG7VZ59wSWnL2FVw9b8b4RKONYJHIYdHCMHT2yRUCLjwJrwFUwCB4l8?=
 =?us-ascii?Q?vdVl4z+TLatPq7B1fg0YdlaUMIZ0SsU7k23m1d/CRJRANINgVtI1zQxNGFNr?=
 =?us-ascii?Q?XMcBU4EKbBkuybWCreLsClVDJYWAN+XeHIj25OTYMgS9ILhNo7orO6mPQK9R?=
 =?us-ascii?Q?TYsgsvLvz6oob0a4YW78Nu3AGyGAXRQwPbMTrZXv0YMed7mnEfyLpIBhFwn4?=
 =?us-ascii?Q?FmHegLxhwfPH5W8uTzfCN0VSmm9M5KaWunl6mfNh0Avvpkv8b1U38/sKItYB?=
 =?us-ascii?Q?812d6WeIvmzh/tqxLLKDMFsYDZBRYSZgiibhQTGRZ2LJz2iT4t4pEvBRSpPI?=
 =?us-ascii?Q?9+rnqXkP/o38Nzs/JwzjH+S8DD50oZFw89WIuXsOKuCsg9xyzw3yCsALKzI6?=
 =?us-ascii?Q?4oQhJMylVg7EWFlqKVZOJETM501tWZRfD/zXeOwsjS9rsVos3WAF+Bt9NrTN?=
 =?us-ascii?Q?BYswyjUqiy2Be2TFpZXIIBydVO/bJze4fr0JUzIRNMC2CTxUi/W4lze1JnFr?=
 =?us-ascii?Q?t9WaMFncj0Wk3dtlmKbHL1DlwQZ49+B/v3ZYhYvznLZN/n89lunxDq7GMayn?=
 =?us-ascii?Q?4hHTk+S3KH1MS2k0Ris9Cn4haVIIUH0JTSFqxvBvtLnFoeIQxkImqXugIPCz?=
 =?us-ascii?Q?YlYKDK90K1caJf77Ta5YRGunMHdvE9wsebImDwFKUuQmtyVs8bjxDxQs23zi?=
 =?us-ascii?Q?nhPEFuWAXg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3850ab55-8907-4e21-d786-08da2e008b12
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:01:49.7460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJ/6eJIkb0Hbj9kkrUeomw7DlsualC6Dx+zlg1KapVs01evDojpd+a3x75cbUMQG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use drvdata instead of searching to find the struct vfio_device for the
pci_driver callbacks.

This applies on top of the gvt series and at least rc3 - there are no
conflicts with the mdev vfio_group series, or the iommu series.

v2:
 - Directly access the drvdata from vfio_pci_core by making drvdata always
   point to the core struct. This will help later patches adding PM
   callbacks as well.
v1: https://lore.kernel.org/r/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com

Cc: Abhishek Sahu <abhsahu@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (2):
  vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in
    drvdata
  vfio/pci: Remove vfio_device_get_from_dev()

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 14 ++++++--
 drivers/vfio/pci/mlx5/main.c                  | 14 ++++++--
 drivers/vfio/pci/vfio_pci.c                   |  4 ++-
 drivers/vfio/pci/vfio_pci_core.c              | 36 ++++++-------------
 drivers/vfio/vfio.c                           | 26 +-------------
 include/linux/vfio.h                          |  2 --
 include/linux/vfio_pci_core.h                 |  3 +-
 7 files changed, 38 insertions(+), 61 deletions(-)


base-commit: 758f579843974e9603191d2d77589af98001e3b3
-- 
2.36.0

