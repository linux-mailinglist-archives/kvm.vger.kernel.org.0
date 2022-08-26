Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C421B5A300D
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245417AbiHZTeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 15:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiHZTeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 15:34:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C44DE0965;
        Fri, 26 Aug 2022 12:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/0FnRQUFDdmeFVjByToDg4exFakj97fHGqFHrJOJMySHKwIoxrWXEPrGCc89ob7p/kGxabhxVqsz3oQ5vR+ivT+Xpl8gn2J0IxTdPQ6nNWkTccLTU1Lc1eS5iOhZv6zYGKDydkGtYHJeW2BjzfkCu5UjMmxtEoVQ+Q/cLui5JQ0+K4EHJIeUmV54dHS8bFiDDKwinHpxwQuGAFaX5TuXMixxvskKD3cbWlFkgFNrUtijrznr6a+hFsB8r3spSYM9+bdf00+G92RYZiGRI5I72ClIJeqvcGAOpZrSazJBj0a4s3x6XzbICnBU4/zupwqlKBo5eNOqe4GApA9KpyGRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOSsGaUFPvMJUXmRLjrJKv1TyMlel4SS6pE2xKU4HVg=;
 b=bBrG/pJB+z04asVIcb94l46acbxAI50EB3XPzS7KxVhq72u8U1nQerX4bstl+X73DM2a8eMx3bjF6OmX6mMClzWs5WTcPLE4V8/m46xPq7barlkNWxeHLpRBJ4OwH2ZSm4jGqXpe78UuXuB+64CuoY1Ho2clgVASMGtHmnhOCe4xgRaokKzix+C3zLGuAWWnjEt2IiyDhbW6vrC12v4gOV7oqLJtQ8sW8wMZpc2i+t5lLBH4uf7o4YEaQHhsh+vMRAhbXPwbFk0hCtK+jZQliisTntBpDTS0BESIh1+DEh6hHGYVNcS+iKoZIyzxaTzGSbMZLFZ5dD0E5WNvE4u1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOSsGaUFPvMJUXmRLjrJKv1TyMlel4SS6pE2xKU4HVg=;
 b=R4LYlbWxKg4b2xKMUjURADqyzCqmzgxfeT6SPhHKZzhi1rxOCGKA/RJviyMmiEMb+jADqGDyJatqSMid0uQ1kn2JiNDQ2fg2CBxZfti5bDk73vKfqV5VNuoYeRSm6QxAOUWsryXB8FLaSp0l4JfUftjI7MnDpPEtCueKU9dPajlkKjjfAkFjMbBowP4PSwzQbHZLll/OCLTTvt3S/gxixLbxFZO2CdwQRGuRqEtQtgJkAj1X5vlv5s36gH5+jXNR9bBbZ2PlAy+rmjReNbPj2yZKWZ1+qmuyw16+4pHxEKZ7aAbwTSHO4Fv1OteUNwTR+6993mSOlIvo46fdwYa3Vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Fri, 26 Aug
 2022 19:34:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 19:34:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 0/3] Remove private items from linux/vfio_pci_core.h
Date:   Fri, 26 Aug 2022 16:34:00 -0300
Message-Id: <0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0021.namprd15.prod.outlook.com
 (2603:10b6:207:17::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b15e8b5e-3370-4678-e744-08da8799ef59
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1BQQ6t2Cl0QUxRwHQ15DhPO6jqoiecyJxVh+ljQYV/w58XG3k9rAGEEmlbiJJnD8DB5PhtpJ/JFpg8YGbSjuzVRNvRi1w1mW02KJlAR/KEV78U789CrvE9kWzeZTuOnale3LdVsHQA2qZ3C+ht0WZ+xz3FFvI+J6b0xUZfbrOIpbE9gomTG6AhDWIZuhq9/9BPrzjqKZ0a0cCVQBVL5qk79vzRCWvbmI8hz000v1i0QoJmsRsmXTIyay1vikKJ6cTGd++f5GLjhd/KqgTZmQ8iSEoWWA0JpcYSrWuOriHPdvbu4j7PxnvBgBfdE7gii7BF68DP09NALG3qwTHSjC1Y+E+1Gtwh3LauVcA9sKPuAGgwpL69wvUKbQjXWhD3xuuDfwjQAm0Aahr8kS0icaemejvCvhPAXBWcnem6KRuNW6L1BZHj8Vo2Oqs3i2YmAmj7sr1FqVKubBY6UChxx3FR9GACXe66cjUizNI33H+Kpz1qCvjYmA1G23BeLzdJKQGuqEHdubkGr5FHivN/wE42Bj+C0X3nQU5NGhNJNXcC4Khaa3nEAuEIG/sejF5I7AiUuhWwNZsdr//UlHmAWG5p2fApwH/wnx8/md2yr78UbUyPcBcKpIKpdQ171XJzha2w4xOIkz9CMUlYB9NaB0tW/4NU75EkFivp9biiHU3/Y9W1li9IAaAOrFgAKX3YxycwA0GYOs/eSfZRNuLJwSDLJ8yolTvy8jqCgsJgAbkS4yyBWpj2uNwlh34Cdh8EbDOwzAR3b09bW40Y7xbw1vylUQUxorKHwe4KPO0pdBwoQLhc3bie1y6fh6lTpt+5ELF7ejb8ozlTC1PAABPYvs4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(8936002)(966005)(83380400001)(2906002)(478600001)(2616005)(6486002)(5660300002)(36756003)(66476007)(316002)(38100700002)(6666004)(8676002)(66556008)(86362001)(110136005)(6512007)(186003)(41300700001)(26005)(66946007)(6506007)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o3XPuQEySKVHkmuwfZ/I2+uBijLRWtUx5haYCR8NpCOXC5w2kLMESZHOSuVa?=
 =?us-ascii?Q?AoG0t5udQr+vs/0NkXx6NvRL8e0DkNBgH3nyWMEo1Wb3tYVlUyuRd2zf83Yg?=
 =?us-ascii?Q?MLah0lqxBw67XkPLK9jkQPRtryXJ8h8QyZ0MYyZxM9Op2942jGAa4xSgGI9K?=
 =?us-ascii?Q?SwAzIvkD7JQ3E1F0vD9TK4jUQ/qasgmD46lO9lLlaFHcqGfpmt5jAhxTkLbB?=
 =?us-ascii?Q?L5Fbun9cMFTGhWMg0OaSeaCG8Fhd7kZ1NtnaoO1R/SPITaMAgtTjPW0ouNKY?=
 =?us-ascii?Q?mVVoxA1Jm1d28T2h4FOqXG9HKQYdW2qHim/0FzyrNm92nGqByGz/6gxR/vQv?=
 =?us-ascii?Q?jtHDyQBU7JGJ8suuh7snJnqudHQdW0Or4c0PNL9CwNhiU7u8ijlQ4CyLzVg2?=
 =?us-ascii?Q?lJ6ZE77nsNupO7rGAXDB07sRgvnXFxUVB/aOeoORRVGBmsR2O6E+IAGqQ8Ys?=
 =?us-ascii?Q?JwhBgz97cL7YrGIAzwba+F7CTBBwqIuLOsLN7/KUOOYUxJH2TAxBdsnHiNvC?=
 =?us-ascii?Q?9i2xQnRcp4I2knvb77qMPWBgxsYSWklw5GvU+orI8ReVKZU1m5S7n5AhTa0b?=
 =?us-ascii?Q?XiBYFUURNa0qp8ae4GXDtFqDBDAlSAxc/HmmyItP2yCDsbVSxXwhTypvwXl6?=
 =?us-ascii?Q?NGwaUZTz35USJiu6CPS7FTmINKhEpOOGH4Y/EjHsCHf9498udBrg8zPh4EwI?=
 =?us-ascii?Q?8/AadBpEmm1prZKNf1Z66IdlnfiB9CpKoQw8Pd0jFTUonm/97Cc1eP5RyWFf?=
 =?us-ascii?Q?l7qovlOWMhXlLJu+VuDIYMp1Wl9HgQhGzptsBetkxOkpKPQZlQ4OyR/CV+fR?=
 =?us-ascii?Q?/AVgPE0hH5VDoqX6zCdsp5UGmKEPto4RKOsdj2YTwP4xIFGLDajOcoKBBr5c?=
 =?us-ascii?Q?EXcxs9sOs93ERyaUO9KLL8RAMupd1AveJdRKrwtpehl7SEj+67uJ5a/h8fLN?=
 =?us-ascii?Q?QfgOJo4VukkEWW0f0y118FOaUsnjR0ytLmxrvFvcF7v98xptpNMJxMH5sz36?=
 =?us-ascii?Q?nOdqGPlxpEta2uv8PchdAFkf207LVQWcWAWhd1ZWr3sgpspgXl63DFfZ4Kgh?=
 =?us-ascii?Q?8ns7tqLi9ta1Tw2cGK5EGgaJbAYpcqSaadEjPkLsKpdmXPQA3p8qq5wtC8Pw?=
 =?us-ascii?Q?BsCCOhNQPwFeR43t2pAnOz2DwdmZsb7vKyp63gEOzVLT06x2SxjDLVuegiGu?=
 =?us-ascii?Q?c7Z0/hcoSJV7514uzVIs4omUGzQoypizmSb0LGaWeh1qTSzH/NR60AizFhtE?=
 =?us-ascii?Q?APLHM7pqfWzXa+kkcbVWLHZAFlxCOE+xARBizDIHLVhGjWScVe7dJeFVeO49?=
 =?us-ascii?Q?xfUr22tD87LqLSc2U/84bF1IH7JRbY8vZwBm1fEUpOgIwmCLgsJgTzWygl8N?=
 =?us-ascii?Q?LiKrvW4nUEtxGC19/qu/xMf4+5R3d9ZMQEXtMmPQSKmw9M3eIAX7paHUHGys?=
 =?us-ascii?Q?+RZEGv5RkvXQZ+l2uV1a0wcV0TPxjBbMCwtdzFrpNoDqqGkWw2xHtA23BZiK?=
 =?us-ascii?Q?WZw5IuecTGYiyWG3SCf7BuBuz/6fC2rqJRmLUiF5Q/hbBWvdlZjpr26HMv21?=
 =?us-ascii?Q?t6ehZ/uGG8pOB7TMTm9NhBPJb6ErL1hT78aoMDU4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b15e8b5e-3370-4678-e744-08da8799ef59
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 19:34:04.3301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zl+Df6JWIcX+NgscbzShjpN8of2qPS+dp5ooahS+2t+rtQ4x4LJifI2ujf40t3tf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The include/linux header should only include things that are intended to
be used outside the internal implementation of the vfio_pci_core
module. Several internal-only items were left over in this file after the
conversion from vfio_pci.

Transfer most of the items to a new vfio_pci_priv.h located under
drivers/vfio/pci/.

v2:
 - Add "vfio/pci: Rename vfio_pci_register_dev_region()"v1: https://lore.kernel.org/r/0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com
v1: https://lore.kernel.org/r/0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (3):
  vfio/pci: Split linux/vfio_pci_core.h
  vfio/pci: Rename vfio_pci_register_dev_region()
  vfio/pci: Simplify the is_intx/msi/msix/etc defines

 drivers/vfio/pci/vfio_pci.c        |   2 +-
 drivers/vfio/pci/vfio_pci_config.c |   4 +-
 drivers/vfio/pci/vfio_pci_core.c   |  29 ++++--
 drivers/vfio/pci/vfio_pci_igd.c    |   8 +-
 drivers/vfio/pci/vfio_pci_intrs.c  |  28 +++++-
 drivers/vfio/pci/vfio_pci_priv.h   | 104 +++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_rdwr.c   |   2 +-
 drivers/vfio/pci/vfio_pci_zdev.c   |   2 +-
 include/linux/vfio_pci_core.h      | 140 +----------------------------
 9 files changed, 167 insertions(+), 152 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_priv.h


base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
-- 
2.37.2

