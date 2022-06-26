Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9046F55B058
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 10:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiFZIkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 04:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiFZIke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 04:40:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFEE12AB3
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 01:40:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g03JJcFn+zBkrt5a9WqZbt/iMxfEMa04+MPdCvdN7kqsdUc7fQSRQtCWpCPjrthcdsMthfl/pnYcTEEvBztEWrxJBU5NofrTqJGWBNZ+q3pX5x8gBNE2t73Sng8hLRP3FPAoi+JzTtzoHgNF6lFN/x5NkdEKW6HuUMeTiY9bJlqR8TORjHQDtVNgqtoCkX8sI38FqYwWgHwLA/4BE+W/Vh7f6TAqIrUM5TecfnrgWiO3ECkqqtZ/yTqF2zdTibefTg/2GtFb90YMI31Zo6RO4Ull/rcf4b8CbLgANpfe0UbOjkA19T77AA9GJ0/XoCqOF06Kc8zdKmfvKoR7nb4tyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27cUp5YF6l4g49IsHe0/qoE3oAqHsCxOhUHvoPzSTbk=;
 b=G9fc+EW3oNoZdNVB8DMHTYP5WEdWZHTRAGxYABYALBJmLMlHgtTfiVv3dcRVDGY2hAd6HJyrt3As9NaZxUY8QKgGv1/gJt7gDjrSAEC+DdIYizbhMDGbGRp4XVdMKAYbNNWlWY9aQKKWgpJN6oTSdLF30TPEdlzhO+BErVxcTeuGptbJR8SqQ1Q1HW89WcUxjD2N2oAFeI8yTXIbrJMk+wTcsjJpLsnsC6cC0hLoEpqM7OEGXsPaFOm7xmLxcTIccph9jyIGnACORk5mL9IQWGZvl0peWGHVhbPHfnZD5XtGgqJfqH/NeYAHfOaiHVnelvj1g86D9+bbvFdouG9PFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27cUp5YF6l4g49IsHe0/qoE3oAqHsCxOhUHvoPzSTbk=;
 b=exz8TocstfICAD/F1b8baAuV+4VDtZZM+Cs9qdRIWyNnB96O5eYj5z/uyu9FpysGmvf/uxSM3LpCxID47doUtiINTXJeOjZTnpjkuu23/JRm897LVNW1u2XR9yXqRBKiWg2hKj5xBWWG2GhlzgWamBqS8Rj2n8ENzwED2FP07mjr2yrrANjNiezwUyn3BRA9mM5tyVY6Ya7jwt2+UVcLAWNcfWwEl1louyPU/oc4tC/550Tum0fP0FsqImWwtQ42WoDnf+SGnOngX++Vuatc2SiKO62EoHSuulcBIX+OuEmuQsEXpotTPP/QB/5j/cq8Tuaf1cnnLMgK9xSjIofUZQ==
Received: from BN1PR13CA0020.namprd13.prod.outlook.com (2603:10b6:408:e2::25)
 by SN6PR12MB4670.namprd12.prod.outlook.com (2603:10b6:805:11::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Sun, 26 Jun
 2022 08:40:30 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::f9) by BN1PR13CA0020.outlook.office365.com
 (2603:10b6:408:e2::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.11 via Frontend
 Transport; Sun, 26 Jun 2022 08:40:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Sun, 26 Jun 2022 08:40:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 26 Jun
 2022 08:40:29 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 26 Jun
 2022 01:40:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 26 Jun
 2022 01:40:25 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH V1 vfio 0/2] Migration few enhancements
Date:   Sun, 26 Jun 2022 11:39:56 +0300
Message-ID: <20220626083958.54175-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffe15117-37d7-403f-7741-08da574f86b4
X-MS-TrafficTypeDiagnostic: SN6PR12MB4670:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cU7Z7/15dadp1ScJQIwQ05FEGsGT4RDwJgHDpBcvd1pig8P3iQ2qGPC0IplqP+rjT6LKvG48Zm88/twIyLIwCVR/TdguYKoPFi1hdZVLbvwYJXKfQyMU1J/waOKSI77sk+eL1h8iTFFk2UIswGtlMioCzk8WvdGrz/Nolih0KO2BQmYp3308SWS/Vf8SkGfL3fpyzosSJBX/sXRRomf5JWaeLSH293Rs/+aJR8RqK6dstx5VGraVI86Ri9Vu3KNoL0YAvFfS1cMVJFOF6Tsx04nwisBX8cCxq02KIi6cmqRK+gqu56sM7oSGMVh/U8wyYpTkSrFp4sG0ZUP056y0W8Ry/uaArD3qjnH+Bu1Sm/b6ZHdNCZAB+U+fCfPfpoil4Y/C67TVuCXhWUVkeG/1mR7BmmgwpM3MiUOh6czNJRSZ2Pt5DEXF78sh+cO8Ileaqu6h6BASjp61c+H6sDnvOWsWYgMoKqwuo80/Nj/G5rOfo+BOA5vhfBA3sShy77oTVrxDri9nNP5Jv3hHfBnn6reehWtSVs5yxeBggBdo0xXQdaeiK5solBcrbn60sPaJWD0jF29ntl+xnlst9nlAc4Xkas5xNOQN5vIzmhtpWYmavj+b+bshgpWbSIcQaSYOPvqf3hQFNtZyk1BuJuWzXIzv2Gr/FKzQ6b0iaR63Fk8Y2kLl9c3qhNfr7SSxvVIkA5G2m8qk5KruPl2ikXfEJ7VTR01ZVh/JA/0+00E/3h+o/F0f5mg00zQ3f4RCTQMReLByimusG9VZuGaAY7Zxvk7lm0o1v2B5O55lNErPYnO1LDT4t2IcsVwjDCpXY9KM3wfE11Pl0TzbOFYuOh7qQv86TTXopY8PpswzQyfYU0Dc+6yo82huBm5VI13CJGdIHTS7QRiRTvWhcT2HVSW/QQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966006)(36840700001)(40470700004)(7696005)(1076003)(40460700003)(336012)(36756003)(8676002)(41300700001)(6666004)(5660300002)(81166007)(83380400001)(54906003)(110136005)(4326008)(426003)(186003)(356005)(316002)(66574015)(82310400005)(966005)(70206006)(86362001)(82740400003)(40480700001)(2906002)(70586007)(26005)(47076005)(36860700001)(2616005)(478600001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2022 08:40:29.8790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe15117-37d7-403f-7741-08da574f86b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4670
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series includes few enhancements in the migration area and some
fixes in mlx5 driver as of below.

It splits migration ops from the main device ops, this enables a driver
to safely set its migration's ops only when migration is supported and
leave the other code around (e.g., core, driver) clean.

Registering different structs based on the device capabilities might
start to hit combinatorial explosion when we'll introduce ops for dirty
logging that may be optional too.

As part of that, adapt mlx5 to this scheme and fix some issues around
its migration capable usage.

V1:
- Add a comment about the required usage of 'mig_ops' as was suggested
  by Alex.
- Add Kevin's Reviewed-by tag.

V0:
https://lore.kernel.org/all/20220616170118.497620ba.alex.williamson@redhat.com/T/

Yishai

Yishai Hadas (2):
  vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
  vfio: Split migration ops from main device ops

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 11 +++++--
 drivers/vfio/pci/mlx5/cmd.c                   | 14 ++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |  4 ++-
 drivers/vfio/pci/mlx5/main.c                  | 11 ++++---
 drivers/vfio/vfio.c                           | 13 ++++----
 include/linux/vfio.h                          | 30 ++++++++++++-------
 6 files changed, 58 insertions(+), 25 deletions(-)

-- 
2.18.1

