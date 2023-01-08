Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D21D661644
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 16:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbjAHPpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 10:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjAHPph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 10:45:37 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D97FD0F
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 07:45:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWIPCqXb8FYyvFYLjnoFK37H/2ZppK/XsR4CMFUYrd5RzXBYMjJ094vKL0mF7dnV4xcIgN0ZgF+a5uDrR+a1aaB3t6+LppvqWULLhQky6QUM1UV3oo7SrHMHtwDawBOyLQZGYRxvDE4xu4JLUN6dKKnXERwPA6MfTc2THr1y78Egk/6Y92fLlL6NuTtVN7Cffy4tTbfpDcU3Y1K78JdvumBBrJqYLa8nuZBeJC8M+zGZkm/ID9E8+lRXe6uvCU+R/atzQ+w2ewytkUngO9QV5Ig3Qh/20EWxE1uNIgJE5CL9TRk8W6Hm7vHbUz+eRWP1JcS9F/yi2pbOlCmMhAHfKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oJOaRRrzNvtr8kjofNopJWbe597DxfGmksah0Zx548=;
 b=TptRchyZuImRJ8yMHzEyBkGmm2yspbw1/2uahn3IxI0QWDj6fRQAMFsS4bSO6hjXDzIlvcLYY7+Gp1NG89uSOoKR4OQq4hEAwdn27VagYD3gJ5NxqLXwcwXiznv8NgQkBdKYEf6BLd22w89FTW+YSM347QnJMzBX+J4/fqiAbu1zNfkcMxihLqnJDV27htpTCUP8yhg94GAy5IS8HeodNRKCkXsxPFKzJ4XeTV7IxpZc7zfcvgUYRJQ2UC+Ji77VXaBcbiSrB5g6P9YH/dsjOzXXBksfwPvmFtdXE4BCFfS/EWL0KMhY95JpfXXuRpI0xqIcvGoE7a7mbTKxdEt9lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oJOaRRrzNvtr8kjofNopJWbe597DxfGmksah0Zx548=;
 b=NToFaa2qX4/tQbjcrqxvGOWLsA2I8/QqRtp42i6NW7wYslYI2BR5PCAhx2uO05cOm+hwBYKa/A8yjJy158RoRbcWKJ1S2vaoW5+PLG9WUIvN1vmLXwLshDqFZ66EmDTEhIbXCU6BYm8AK2JRPPqH932PuzXdneKa1a1jFywMcBlbBNsl8JetAbqo48RqyjVrmG0q1qZ0Yx3GNQzsVeGD9+rTVYj7G5mpCD26sSkhnk4LODVeCselJSKI61Jou2aPI4uQc66Qg1BoZDKEKgUhIszX2n5U30uGwBqeW0hi+/LGCio/hrbLTxLDaoQ2Zwp3VdJB43sKoI13Vz0o6loa4w==
Received: from MW4PR04CA0073.namprd04.prod.outlook.com (2603:10b6:303:6b::18)
 by DS0PR12MB7605.namprd12.prod.outlook.com (2603:10b6:8:13d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 15:45:32 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::f7) by MW4PR04CA0073.outlook.office365.com
 (2603:10b6:303:6b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Sun, 8 Jan 2023 15:45:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.6 via Frontend Transport; Sun, 8 Jan 2023 15:45:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:21 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:21 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sun, 8 Jan
 2023 07:45:17 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V1 vfio 4/6] vfio/hisi: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date:   Sun, 8 Jan 2023 17:44:25 +0200
Message-ID: <20230108154427.32609-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT043:EE_|DS0PR12MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e98078b-e5f4-40bb-51b7-08daf18f6063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1JgEFgpF4Vo0vko/aMCet5YxyEnOCW6GODlz8VsreZHFw9tNgaT6equDwvgtT9240ZaQPoXpyqnUE8rrc7tH7pyTV1GRrUkAwzioIv62C1YBlJgPnkNSOUSwruTzaKwQnMGNeqs3M5W6LDUSmyD4h/MwkeWMFqJLhnhFL6sNNw6zWlYiFl+TLbHHUuJA84EyIcOkRRXOfvU0k7lj4wuzCSdx8YgCZDHm2NZMtG59dGTtvkubPo3fP4mWV2LzeoEyu9zS6kDS6TGk8/IPoGGKWIYs1OTbLrvmI+P37u3yzpqkl8wHDeJQb/AmA4pzp70jJRtfaMUQ7La96fGoau7abkePdIg1QhdNSGvCccX7pxvwJtakjLl+xaUuxWbry2YVyvP1iENNkKtijLU17UUs3o0X8p38oA91nTBXzHpBi3ekvhx/yNWM2E3+qZQkcx/sUCY1DzVG2zj9ULWYtLzPqAB779hqPvnSGBph5xHfnOcIty+PORV04zuHGKImvVaDXFrLN78sGeUr/TxqeUIJNfrrT0XN5GmNB0rhW1XCJ2wWn69vi6T+FRAfIk78cQW33RH1pxJUMbzIkH+wDOHaXyobdm9dcm8Bmx58b72ukW5R3TRK2CYkayukY97hzIzNuLfIo1d2ZdI6/SsRGfcZYF3fcIHcuRZS8nSyyB0vOE15Bp1yt35xenGGWf4CqLWBU8UhdF6KH7AIxf+xPKLjeA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(7636003)(356005)(82740400003)(36860700001)(70586007)(8676002)(70206006)(4326008)(54906003)(40460700003)(41300700001)(86362001)(110136005)(6636002)(316002)(40480700001)(5660300002)(2906002)(8936002)(2616005)(336012)(1076003)(426003)(47076005)(83380400001)(478600001)(82310400005)(7696005)(186003)(26005)(6666004)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:45:32.4523
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e98078b-e5f4-40bb-51b7-08daf18f6063
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7605
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use GFP_KERNEL_ACCOUNT for userspace persistent allocations.

The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
is untrusted allocation triggered from userspace and should be a subject
of kmem accountingis, and as such it is controlled by the cgroup
mechanism.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 0bba3b05c6c7..a117eaf21c14 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -744,7 +744,7 @@ hisi_acc_vf_pci_resume(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	struct hisi_acc_vf_migration_file *migf;
 
-	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
 	if (!migf)
 		return ERR_PTR(-ENOMEM);
 
@@ -863,7 +863,7 @@ hisi_acc_open_saving_migf(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	struct hisi_acc_vf_migration_file *migf;
 	int ret;
 
-	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
 	if (!migf)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.18.1

