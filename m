Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F8B60167B
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiJQSir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJQSin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:38:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869F672FCB
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:38:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYRwskmc5tCAw9cHIuIIlDtzVKAhDIZ5qTbNlkKPPMUgHNA539uDhejvZQBA7Gm4aLM0yk30QLoEdRY1TCjaA2qdrOvnQrw/F5cQdsORUVEO8PykXEPCpgj1ZqK0TKNSncoqN/Rb7lGzko8kA83PqHxSJDxFpRSZ/vTGJgAOaJAIM/8zbw5krVfiR8Othh/xLszFnAmmM4Iwrx8BIdTX8xU1k9lTZ9wMy1Vv5RH8lVTAdN6JnHyXaOHglznLsav0ha01pJqCjWAnxO6Nf/6vnbWxnSeVUO3Ovy3Q+galzt2l4OUMAQf0ptBoBFsDHkNYAvWrL9aey9qULfiR4bsySA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbXVuIc1fEGgbhiP5FiQbQ92CjY09dMWScZCFkvdp6k=;
 b=D0wXFnQdapuMyB3MmM3qU0KtQUNhiIE5xtqXLwnB3z5nd2xNVo3u0tQyAH3loKe8JHR1aPIsgZLvWa1u/btR8+XLNt4NxqBPBNBFjlSp90M/ecz7jjvmTvJgNOTI5QtTv/cHSUHwzfFXZafOb7RiaZzms4I/uvo94ar/oJJlLYvAcvj/wdN/8IYx9V08hTjQLc/LiS/W5v5qumAIfZ9bZbCj8OHv3PnnO7qlZD1OIqQYTxHaSxZLZcak2I0xF9Glf/5EvIir9W8NdrJLlG2GlXwaoqr2a0gDpMlLqasqMtuK6V0PNPxLYgw94QUTPjJNQuANy2UN3tJyGOL8NoNyuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbXVuIc1fEGgbhiP5FiQbQ92CjY09dMWScZCFkvdp6k=;
 b=lucNHEjKqeQHTaq+T7fiDM0aSkvGSiMcFYDS1Ssthc19tTTunFFY97ZqQmi/1QfgMi15O4NjrdU1XbjMWg2BEEnFBcy7qbzjGdQTn8Akzeq5jUrhKXApfgsEqJaiaVUz9QdOQUEMOV8ELwTMbboLJ56tB6kIZTcqWNTXSMy3q/0IDG2M/Ccu+jbWwTCLoP/ue8uKX+yA1olXyisQeratkP+0YqHz4Qn5BrjlgAG+M5hERr+9cWJoIHUdmUyuJU5zLq88Cwj8QJnKciIUxAg7f3LYnq10UpTooIxIM81kVMXLgW5zD4jEKFSkapEqzVoT/2xz2rWZ+LFMjwyLdQP0GA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 18:38:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 18:38:37 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 0/5] Simplify the module and kconfig structure in vfio
Date:   Mon, 17 Oct 2022 15:38:28 -0300
Message-Id: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0163.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: 824c0dc6-9464-4bd0-167f-08dab06ecd72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 88q2DYRAawV+qRCSE9Utrt2OGv/G1lN5SwPvzUGai3saPYO4tumiV0qMYK/IJfbBzB3/US29aqhNm+76vYSVEHh4ldvfONZgtbHzhKbVZ3YafnaHaKitX1q4kxlhOzr0yYgoPDBoji0nkSjc0H1r4lHLB/0rX5tCudABVQcfTgVIRxFhf+Bl4yyG1b2UgjElcmEVYSj2pFK4JsSx+quUSVd8SbOP95WShsw2Z9gSsvE31YsRx+78QLxQGSHMVERg33Rg88bxGR6GE/tSovG/L2CZFLzYlm/VehoTOeVATuU27/uQB2w/HEYcYtg/cFxZH2ubGzh0Cw3y1SCqKHb5q3NQmtVpr1q3RqYwUpaSRTlMgXJppq4ipl4jCqKYyhHiqvkU9svK/2Z/Od8DRSIZSeeR+5cKPYyutnLexpn4tSi6xtEDES8LZYrQMEdseerxfyYFuHPudHoitvIrg4re5SC3XfLU+yb0GkP+OxUUzI6QEiIDgEp5Hp1ZGY8veGg0xvtP3SIwMzVWv7oMV145yypW4udMDJ0aoq82mJeRbC9Lj9GnHTS+CvB40Ivgtsr7vOTxNUUyvXqoyU9FAee5K3VlUJEbeKAHlu6jb87OFvT7ghS2MUeEiUGEvqggXkUeHEX1CvZcIdgksZZDXiEb8t5iSjTyXcLiGlgbReecPpHyRjWSx1H3fv5IK06PcmNd7OqzGixhgM2P/vhlPTXmpPxBr7l0a4UuWCaPUfhM5IGAKL1yZBXYp9BL1ReR689nNoEylhStgt3yFiN6EZmW8LBKpo2Gm1lHmksaMVc8SwJME03xkUNI5LfreUZohIkP4qvXTXhqDK1C1kd5sceAbRHiJZi/tta9jt7nQvUSmm52rP9uFUViSSUITAFYZfYE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(316002)(110136005)(186003)(36756003)(2616005)(6506007)(2906002)(8936002)(26005)(86362001)(41300700001)(83380400001)(6512007)(6666004)(66946007)(66556008)(66476007)(5660300002)(8676002)(6486002)(966005)(478600001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Ub/KGbvtIZIzTg+w+I2Q9+Fyy2SFpXl/XGwbk+wT7vPDHpW57HXxmuD856z?=
 =?us-ascii?Q?mSAqFdC5LTrdYNSJ1IiYYLyDKUhS12xJWWd8N0LIcgTZtiRwgdW1CqhE3xh4?=
 =?us-ascii?Q?axoZbK2VAg9Rzxxo6EM9s3eytp0px37TTLkg2lyCaW/bBLRMPnnVc2KfWluC?=
 =?us-ascii?Q?eWMy6pMd/x8/qsEmP7mRf25Z6h8gWcabmS8t8G+v4+raqbA79umeWPOD+OLY?=
 =?us-ascii?Q?vbegUySPt7Vft3Fvs9G40dtPbwgAITikn6DoQUmQV3/DHxIQ9m1fd+W72cJx?=
 =?us-ascii?Q?5eA2XJiu3sL7h2fLU4zv3eOCisIxa73fAUVulcJzD5ikVReW3WiC+RhPoLvK?=
 =?us-ascii?Q?EWYyvmPpUX6TyfEk2F/2MznyeQHD1y3KLLCTlFkocaX5glHKd7yt76keC4RS?=
 =?us-ascii?Q?CMUfkNoeCiWDixRcS2xhJfdJ3F6Fy6rjc5XcNq/hTHmzzgZRmfw3atXCDzLH?=
 =?us-ascii?Q?Kpebbz6/npMxIokV+SPFaqCDuMbfJFHQz/zMtkGEcV2ke0aMy+lpwPUhnhac?=
 =?us-ascii?Q?74qh6chhaWczjJCTmP/1MGlyFPRsugRETgF/2D2NuAutegMeRDnhZ4WgUSX+?=
 =?us-ascii?Q?4ZHrJ562xnE1nO9jdBonfEk0MLJWKe+02kgrGv1ZGhPIw1xbJpPYZt4h2dRE?=
 =?us-ascii?Q?lTk8bV6U/MXocwbDYkg74XNp7k6Va43RYzt9K7obKoEwCwcpzWh19YuEL4hw?=
 =?us-ascii?Q?lLRMjQftF6ldgHnB8zJOwJxYLEvNLdc7sNo2k8Ay2cxEH3uHyveglzjGcowu?=
 =?us-ascii?Q?ujkkfris+vKdVJNSCDL6z4ScEsiYsrLkiW4O10o/Y+SneFCSXQ576VH4oNvT?=
 =?us-ascii?Q?gBhs3HbVZ0dceLHxhzUbNdAnG6/SROSutCvMicM3fvhLhv8WV5kBLa/nrIAB?=
 =?us-ascii?Q?areoH0pFG5BKqTNd1xTLxyrts6fKpR5c41r8RPB5QFuEgYoMM7dKlqHudpom?=
 =?us-ascii?Q?MaxEXtvD6IyfiGDW6emGISpw4DvisVVvknvKQ3WaVrLcpbmb9p2i5MpeTlef?=
 =?us-ascii?Q?AGC53GsLHYu+WL/P6wQsybXrxHzvJropggVN2tEgwWNHQPjmISWCKzXZepP/?=
 =?us-ascii?Q?q16Be7K1C7qSEzlr/qkTeTjQvLFvxlUhZZXpgLaxsYrhZv8AFNpc90vZ2UsM?=
 =?us-ascii?Q?3TwfrMYji6I7CnQEGKB8y8Zx1/c1t+y40CwEEwiyKK3WV3NM7w31gpESmOPS?=
 =?us-ascii?Q?NgLBTxXMlLpCOI1vpPcmm3X42kYDNbJmMT03LSrlc1Pk1mrhxjcYJW6ZlyVM?=
 =?us-ascii?Q?b4B+3kg9IV7msbb4zSBLYm0YDTj5sM1tNl4JC2McU5lFVloPlyBODZbLFfLt?=
 =?us-ascii?Q?Aw09QgkoFZ28C0wqhFhGsjyQ4ZcV56N9qXoGkt0CgXAIVU2erlaAuGAWlOvG?=
 =?us-ascii?Q?MpL2wXP8hE1yhisPp41CIN+E/4rTafXfiq9zwZO6zxwX6um4DB5oybTr/DAE?=
 =?us-ascii?Q?CCCJ4NyDo5MMnoJiGMyAjve3676R4LyrzW84EavNcr9QI11HSwjqZzTljb2l?=
 =?us-ascii?Q?sEyGQonY71rE4SxZdoTH4GYkwgyfzrS5En2KDk83vb8FdvPnQzQHFreqMIu7?=
 =?us-ascii?Q?4hPRvrOTfiSTtpjx+5A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 824c0dc6-9464-4bd0-167f-08dab06ecd72
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 18:38:36.7293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A06AESmU/fo2UR0Fy/BLTkq4FmJN4HDLLWOGxbrAn9VUKuDSdCtvStZoJLcsM/ka
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series does a little house cleaning to remove the SPAPR exported
symbols, presence in the public header file, and reduce the number of
modules that comprise VFIO.

v3:
 - New patch to fold SPAPR VFIO_CHECK_EXTENSION EEH code into the actual ioctl
 - Remove the 'case VFIO_EEH_PE_OP' indenting level
 - Just open code the calls and #ifdefs to eeh_dev_open()/release()
   instead of using inline wrappers
 - Rebase to v6.1-rc1
v2: https://lore.kernel.org/r/0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com
 - Add stubs for vfio_virqfd_init()/vfio_virqfd_exit() so that linking
   works even if vfio_pci/etc is not selected
v1: https://lore.kernel.org/r/0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (5):
  vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
  vfio/spapr: Move VFIO_CHECK_EXTENSION into tce_iommu_ioctl()
  vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
  vfio: Remove CONFIG_VFIO_SPAPR_EEH
  vfio: Fold vfio_virqfd.ko into vfio.ko

 drivers/vfio/Kconfig                |   7 +-
 drivers/vfio/Makefile               |   5 +-
 drivers/vfio/pci/vfio_pci_core.c    |  11 ++-
 drivers/vfio/pci/vfio_pci_priv.h    |   1 -
 drivers/vfio/vfio.h                 |  13 ++++
 drivers/vfio/vfio_iommu_spapr_tce.c |  75 ++++++++++++++++---
 drivers/vfio/vfio_main.c            |   7 ++
 drivers/vfio/vfio_spapr_eeh.c       | 107 ----------------------------
 drivers/vfio/virqfd.c               |  17 +----
 include/linux/vfio.h                |  23 ------
 10 files changed, 101 insertions(+), 165 deletions(-)
 delete mode 100644 drivers/vfio/vfio_spapr_eeh.c


base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.38.0

