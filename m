Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E0851CCAD
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 01:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386717AbiEEXZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 19:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386677AbiEEXZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 19:25:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8A65F8D6
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 16:21:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVrtJ5yfnt0Y6HYOkyu2vE5QUEL80q6N3pGKMI52VO+nMPU87JzqoGd0HKc9VNsV10W+MysApT9FUOddMGyl0TjmH+TVaAt9u2vz3bzy7stxmBacX3EknB1lB1Cqt0p7Fu5fr8bxJXNOKskmSrxRfSBXot7/yI7ZxAhWFzIh1jz73Py7hpd9c3egblyG796pMJXOsqRbN9zarp5pD5ikifMysLTuETv9kHY73TfsB4zAzvOmGNdnL5Yzt/bwP0ZXjAhbv2Kf2+cpX4I3ngLJsdEiW7Vcm1XwCB+xEcWbUv6XeEFW/Jwk+Bw9SumqoByDN1t0Meu1Ai4Lok68YhHt2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1x7Z/FjQlaTg5rryn9R98d3O8cUrvtm/c+wP8cHH874=;
 b=Ge2b2hAiTlTORojjprksTsEgj0rSGuV3I+PNhYrf7mlGvD+hmjv4lfOqYPytZ0VqaXYErB3nah0OhOCaMXa2I0Rau8O4iKEZkjnC3kx7RY0eYY5CnfuY+hhpe71ItETQXMrqzwtziLIlY53qNPLBmkI+ll0nCbWQNdBY47gIRDOtAP91VCjyZuL9xrOSParMMVtYWtXNvBbK7JbR8V7LPRu098kRRD2X/+tmXkGHyash+490YN/JnyI0gwkZdDhPCYILv+HpQt3tjh1EIhF4SmjWvb3X7qlEWQ25A5BY9ayOdVukiOJvx0zyKojtb4V6I7YMcbrgGjYBVdf37Ku+aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1x7Z/FjQlaTg5rryn9R98d3O8cUrvtm/c+wP8cHH874=;
 b=iA86tBdnW22sIdWNLFMZUYW47K1aWBpJo+aVoDMdDyCECx8IGCBFSd5GVTMjtI1acwOKvtiWBN+uD41MycPyAIeQR6ivcwoV5FuPNfYWCut2xXVHuIyuPxziPrYTNsqka+rJZE8QWpQVpNfHUSozr+ko2pi4ZtvlhOtRGJ5TdBR2dFHVr34FtWSbPYd6lMZTmmNX0QlFumITnkS2OG87DbA6C5x0FdUppFPrWVgI2UxkHJGMSzUClvp0C31YzleXcn8COGWwwEKcGWYv7MP0YB2CqrpbI041gUyyEbYYa1IBeDYgn0JM8sssZ6SJxXFRQyCZ/F2aVSOwqNcQTuMfig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3275.namprd12.prod.outlook.com (2603:10b6:5:185::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Thu, 5 May
 2022 23:21:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 23:21:42 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v4 0/2] Remove vfio_device_get_from_dev()
Date:   Thu,  5 May 2022 20:21:38 -0300
Message-Id: <0-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0041.prod.exchangelabs.com (2603:10b6:208:23f::10)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e40af70-d857-414d-e7ec-08da2eee0330
X-MS-TrafficTypeDiagnostic: DM6PR12MB3275:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB32751D8A5F15C17550A7EF69C2C29@DM6PR12MB3275.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SZ3cAzRG574povrGWwy5pW/PCCBBw2YWzqOS1pH74j0KwtAwdWPKUqRbM44WuztWAAcK0eF8A/dzcryY4ehE4fyupq0qDG5b1iiaZVGhAbVGpcXptSSV0XL3pf0auLVRYLDVvT+0GWSpTKp0wGfeeBHOmQrXeIww2e2Texyn9dE1h/NPRY//Jt4O15j3BYdYm+HPDkPpmfRHGUs9BQHFCMT2ToVyN3CD4IezMSuyiJTzv6F8dbVcFSFYfcyLd5UfAe3Ki2AfUUEAryYbUQi5IWwgXVJjdIlswY9lwMdKrHqvcI9k1pzbtTPYtByNldukmMutp0pKA9GZggmFGoU9harJG5GglwHS3vvPcpHThx+IBqpj5ATWd+btuQQ7YmyqDH3GmBRJC2B7g/4HzGP+jnq+CixGCP9iWvVlnvFvLvV2RChy+/rwoNTlf9aTzKazMRZa8qFpH47NsnvxmKU1CAGd8SmIiRyfxFEZ/CJXY800FU5Ls5pvusC4Gt0ax6SG3YRz4HDylE96AxJ5VDk4f/UKTyqivLs2nbnEAlmLOQYUwMpIlJ6ItWGqeqKLlakgf23Dsy/yDrj4j67K5PuJoi2GYtPH7V1T9m+RxzL/P16MMchxxlEcIh3Tinx9WhFiDfjwCBpUxr0DJ8Xg8ypdHv0kQaEyouaWHKiMboYeADMoAjk7c4MVIKPdPspDuj+4e27OySO32jzRF9nXGs7tHHzrZUYeGEATOYkfOdsvfANHm592zlJ27eVHqnn/ZlqHOimPU8rrSfaq8b42tspI6tAGBlBeF2ON13NC7D5V5+1OEICe7iD/KjBmMq49z+qE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6666004)(6512007)(6506007)(4326008)(66556008)(38100700002)(66476007)(26005)(8676002)(86362001)(508600001)(107886003)(110136005)(36756003)(5660300002)(2616005)(186003)(2906002)(54906003)(6636002)(6486002)(316002)(966005)(83380400001)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cCzPBfaNAKUQ+/yVyuuaO5PKGCK1aJ27j9CZa4KrXutf90g6YQm6OgTner+K?=
 =?us-ascii?Q?wMf+jolqOzVcjRqmsdxvTefS6uhJu+SYCtXAV14hfb2fNi2wfYXemsu1GOs/?=
 =?us-ascii?Q?phBnmSm0Upj6S9zy8L9R6cqwHb58pd7X67GFBXU3FjGkyotwA53JmRMlu5nG?=
 =?us-ascii?Q?0EcYhl97Q1YkPB+CllpIa01G0JlPh6MZN8pw8YmL8cD2RK6wlaK33bO++Vrp?=
 =?us-ascii?Q?/JnJ1kYhZtPyDMgCx6OYxLzHBEvbETrQ0AjbhM0tdHcF8dvFaycpNHcR2eX3?=
 =?us-ascii?Q?tHdNpPeiVxHm3odCI9mxGt4aB2actM4kE8ad4wkJjv9x1HyVVQ1Gmb1dwMPz?=
 =?us-ascii?Q?pJoD6QRDN5tWaXBHnPYGkioO+aoNdUyhDKqYmfzpsUbQr3zezq5wXlHSGKhy?=
 =?us-ascii?Q?2MQ6nxL0jEqoGiL1p80+XnsNckPwoPaPA4rUinf61A/hB6/8aQANIh8MDlXh?=
 =?us-ascii?Q?gUWlN8boucFl5hYNV+OW2G3ZgkLnynWoPezgta2mp8Rs3GWqfFkjcieTuiOt?=
 =?us-ascii?Q?uZOqHH/FYGJVvKQ775LBcjDjZcM7dQcFwBJ90kXeuh6s5sw6ciIw1qmjL33i?=
 =?us-ascii?Q?LlBkrlIPPqKtwrxes4HlNfu/PCqP/8ePjaNpRYM2vYonZrlOXbCGRkkISTTK?=
 =?us-ascii?Q?bNlfh516TaiQLblvmjafsLHb4zHxEHUc01yHOlh/3m5uGo0jHJuSBBp8mq5B?=
 =?us-ascii?Q?tOJa8VIHnyySQ8I1RWhqbuxk2w7xFECO3FB0QD9Wjwg7VtHTp97h17ndY417?=
 =?us-ascii?Q?BIUe9YjPD3IJTLgwYCO+zNzigPTv52x3CH7+xogTCU3lAe76jCseNuM7kbxI?=
 =?us-ascii?Q?YQqLUca5Rz3L3RtZ2KRdkyfMgLIYtZGwJCwmE1AQwr9D8mOVA5R09BSAZM+B?=
 =?us-ascii?Q?kzNiJryr33tZ1Jh+ebZ8SF6ZS/NN03cWelUywiCDL412IWoiiwLS6I8R6pC6?=
 =?us-ascii?Q?gW+3JS7QFgkfloqXISbMdQvq+BXfmQuw1kgJrNEWbLNzOUd5a534AnTXZ2O2?=
 =?us-ascii?Q?ebPy/FxyNr5NleMPfdXqKuI9WVa5dJ1TJYYES3OSnUbLSRCpMsck5trAVM5j?=
 =?us-ascii?Q?h0r+d2ITu6ron7dwlQRClIAGonJCAvoMZKtwo8W+bpCx1RA5H1YdgAlGU8xt?=
 =?us-ascii?Q?irD8WCkJzLKV+oI7dPaNyOAmvo4gRJsBQ+cEk8muIsWpExfUeRusWRJgwtpP?=
 =?us-ascii?Q?NBVGs2VTcWcF2N3TY0pg/y6Ocu5U8WcObA/BYn+9e/61zhT3ZmKODUYrov5M?=
 =?us-ascii?Q?ke5C+eu8VrGucMCEmRpi1pe9l6YOTfNYkj9isSsaWsP1pxGBw8eidr8GlW2o?=
 =?us-ascii?Q?XxRNEBelY6xCorvMbSimqlWJljHDoI4WQuv4/YXqy4RLNO+FJLDId+2CwOcW?=
 =?us-ascii?Q?me3W6eUgvGxK+WMLP6n+vUXa60iIWt5nPqzjEf56UBXfFqh4uD8tf1LqU2Wf?=
 =?us-ascii?Q?Hj+cD81rfKs0zKEIQ/6hSZHIveJNZ+mEOgOj5KjJrv9jgshIhdze8+yZciSP?=
 =?us-ascii?Q?jT/CNoxXVie+muTJNXFg9zB0EYGhkoIUMSxDgWyrq82NEcZMy1a4/efuPQUI?=
 =?us-ascii?Q?lH2C0CuoS1h7G2FhX6y97i4vnrkEst2GyaL/muGcA/1Wvx3McW/NNACdytK9?=
 =?us-ascii?Q?A6DeEUfTmjP9tfczRzcnXPr0VrwNSrvHPF7fWd5BACd4/Ra04H1AcN3nL/Nc?=
 =?us-ascii?Q?27Hciv9X6X6wKIScGDnF6JdW7jRuU3a75z0TnU9ZtU32IyujG6iVV0MVaaGv?=
 =?us-ascii?Q?fD3gE6IAEA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e40af70-d857-414d-e7ec-08da2eee0330
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 23:21:41.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBx6Q62qgl85NhGmNwW1waq7zbEu7z3rE4h1dHpauimJS3/ErKzpaUtrnOwnvtYT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3275
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

v4:
 - Put back missing rebase hunk for vfio_group_get_from_dev()
 - Move the WARN_ON to vfio_pci_core_register_device() and move the
   dev_set_drvdata() to match
v3: https://lore.kernel.org/r/0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com
 - Directly access the drvdata from vfio_pci_core by making drvdata always
   point to the core struct. This will help later patches adding PM
   callbacks as well.
v2: https://lore.kernel.org/r/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com
 - Rebase on the vfio_mdev_no_group branch
 - Delete vfio_group_get_from_dev() as well due to the rebase
v1: https://lore.kernel.org/r/0-v1-7f2292e6b2ba+44839-vfio_get_from_dev_jgg@nvidia.com

Jason Gunthorpe (2):
  vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in
    drvdata
  vfio/pci: Remove vfio_device_get_from_dev()

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 15 +++++--
 drivers/vfio/pci/mlx5/main.c                  | 15 +++++--
 drivers/vfio/pci/vfio_pci.c                   |  6 ++-
 drivers/vfio/pci/vfio_pci_core.c              | 36 +++++-----------
 drivers/vfio/vfio.c                           | 41 +------------------
 include/linux/vfio.h                          |  2 -
 include/linux/vfio_pci_core.h                 |  3 +-
 7 files changed, 39 insertions(+), 79 deletions(-)


base-commit: 21ce7c292b5684f930cc63f3841ec692bbd6c10a
-- 
2.36.0

