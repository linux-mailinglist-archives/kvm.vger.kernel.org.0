Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED25F51CCA8
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 01:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386686AbiEEXZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 19:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbiEEXZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 19:25:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A605F8D6
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 16:21:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKGg3msnnSzJS3V9tpzVoKRY3t3Wh62rnsSvchX0Kg9d9of7Xwz2bhQwaHxeOetAbAGXEMn+rBYnOWKTOaKWqTG+1GNTW6cFGqiLj5I+qHW8Qc/lQxBgqeKS4Ndf2OBUmQNRgVI1pEwgy9sd8dVc5C66yqmbdUy4iWLfS9xkQ4P3Wmo8b5aXRG8EVNvj20lxdJtj3nt+ITzSgofijGMJTCHP2N3MQsjXPDsV2qNimPpCsGqQYCs2/q9EivOVEr18ayeG62GN6EZL9a07uYxvi05g4lzLZED3oa7KWaYAXzKLmtmaXRisBwu5YpeeGHaxPHsq00LX3tBJBqFexmzD6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xD1UUkZ2IYr4vZDcWRNCvfmK5YlhiixGi/yMgC9AoSo=;
 b=P9vwKtVcn8CKzX6VUimAvR1aUYjo4YfAOIGQQ+uyw58AJF+vSIechGixvrBpxMa2MuODcOXvAOp7bR6KTjU2QbKDIzDiIX0N4mEiaOkHgHs4FR+o8EPvMbbmE/odb9CWBzVcgR5dur3Wt/Wkv2fhdX/CuWIfa3epY2FYFQYr5xItDRvv4hdeYLhspuRaM6MpV4xB3OWAxWfdVWPJMOMLn/MVFzAZALbCuVClNc9a8kN1lZ9cGDeufvon+p3ZhrvPGAuUlQ5s5pRURmG14RNQQBCa9bqagg14/uH48sxMeWUBQ99y+1DKUoFL9vSOK9+zsRnSr5O65W7hB7YStrIxjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xD1UUkZ2IYr4vZDcWRNCvfmK5YlhiixGi/yMgC9AoSo=;
 b=NzQEWVJ+V24umLbxyjlm0ljXSrkVUyKEEQTu/jAHixPfOhv940tPBk7WmdZ0SqNxXVlzQEZtcMbjOKZN99yBr7+lsvdOjET/bheDsOMj+pjf1zkHqidKPq62ygfOdJr1ebha2VG4KmF2WY8UlI29owPgn/ENKi+zOhnQsvR1USmkkyY4aehvQB2Dd8+gZBvQk4f8M0wUHcajNW2vyW2JUy2dsRdqxtblLW/B06GI+9ycXEjvNfGzoY1DsQrpUQ3AsV8//5uNgMOJV/LBf2wjzuZ/1ZdfhAyp9gdVLUlY+2oK83vGCLR2spdSjSPKK27703Ha9Z4oeiw28E39mCPYxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3275.namprd12.prod.outlook.com (2603:10b6:5:185::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Thu, 5 May
 2022 23:21:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 23:21:41 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v4 1/2] vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata
Date:   Thu,  5 May 2022 20:21:39 -0300
Message-Id: <1-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
In-Reply-To: <0-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0434.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3983fcd-1013-40c9-c37b-08da2eee0329
X-MS-TrafficTypeDiagnostic: DM6PR12MB3275:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB32757C3FD6F7CB49D9002301C2C29@DM6PR12MB3275.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZbLxC3T2o1+nGFpHWOx4X2ZyZwsaNbr3hXVErFxSP/4XmCQiG9i9dAHFau15sinDU694MY064zgjxIzOrHLwRmNZQYgjI7jYuRGU/ixyGxR7GeY3Z7cQp4xWB4Y+SHPgg5aXmmx0lCcgmYG2G9h7PVL8S1FPIMtuY87KDoreEv01pMV8kDYdcRW8KgesAQJGFOPOSvyfepRehaPrpmeIrJD8BIlUvQpzZE6ZsM4eW59TGsjqLE3Udl1g+BP49syYAo1Xs6PeGHXoKqlgIVi9VFqfQDTWZmj7TKwITo2lzFiAoUbyVkwRdqhojZcPS+POOkWLSAGKTf1eJLuzufQzp03CW9TGyyj8NgK1xwTLqFVIbY0kvDJByW3sG3S3I/SJUKzt2a+bi8HaxGHU4XmesJGLa3oZKqIw5mHoIaYpmqqWXXE2GJemNsGJLlNMbOKOsD5bUbxwbcJSq014TOxUcRn4LXgpxlX9CwppSEAw+JMgO8cFosG7kdcHh2Dfk75Xrx3pY/n0WUQQRjHNqpEF1HXfk4dUQGKcI8zIS+KhrpWcJ52mjzjDyHfP9iHggniZttvZQOXZf7iTP3tYRR4efhEUG2x9Q/Ea89stJ8ajrXsSJ915TxPFCEd8e2VP703w9jgFgF0oQTHZlG3ks1xEXvKlSJxz3G7OodzQGF9Gem/sMG/rpqUz3MGYQPxb/WA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6512007)(6506007)(4326008)(66556008)(38100700002)(66476007)(26005)(8676002)(86362001)(508600001)(107886003)(110136005)(36756003)(5660300002)(2616005)(186003)(2906002)(54906003)(6636002)(6486002)(316002)(83380400001)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2jCRblk9HtA8OBmZo9p7OyKpJeDAWQDiT/f5ShVLkdEGamw7Ucx9iceyL9eK?=
 =?us-ascii?Q?RP2PuH1IAaCsXlMtvpM62Aex1N9zxTSygCo5WBeS7DJFip07CBasM6oxG8Gj?=
 =?us-ascii?Q?nYEc6qTtrcySpZDR25pFGYLHh425ArjtgZnmLjjAnivTfm/lbJQoHOLddXH6?=
 =?us-ascii?Q?MTBKz9NXa9e/o5ZFfTEDUlk3q69szHCsNqsRZjDUlPmSYQBCD9chCDao1QKq?=
 =?us-ascii?Q?wh+8jcw/IgNmeEJp8vZktLvA+U8zH3fYA1yPXylEwWOMyRIY56QT4lDyRqU3?=
 =?us-ascii?Q?I237HJ23lZpPiPa4PIU4IkF9Senk4H6v2BttTHhquiW+CBCM2YBWeYIxshwb?=
 =?us-ascii?Q?QwaMV1u1/8Dem3aFMJdVx59JcGO/ZOc7ADqrWh6mFwqCmqjcUQn88DoqXLCI?=
 =?us-ascii?Q?NzYMWK1fXveCiNgMwmKlizen0EwGS7c/VzvlWX/zD1dC7o0vtiquOESfJmVQ?=
 =?us-ascii?Q?xXQbIwcTwdvLBjGVl3krbz1GRwdmexdqf3V4aKecra9HBkE+zF/1wxmUxkEk?=
 =?us-ascii?Q?NSF25o9LM/Uc6JhEFtrOQXjGtXnApiAx4/e0rzEC7BWQa0Kjy4OlWuTe9S0o?=
 =?us-ascii?Q?i8rX9Lp/8KFHydrHbMNvU1qzWssRldWGTN1iZ2sgNJuG6kjSUvUMsdMPacD2?=
 =?us-ascii?Q?dw11Pa8BCPbJtTIf0Qvgq3eJO13YP6yV5YPKBuEOULduGpvihNceKgZEQosB?=
 =?us-ascii?Q?9z58ciVZMyY/BjqWA5iUGiqE9ZBbeMvk73gp6KA0dUfKb370OjexV9LWdVKV?=
 =?us-ascii?Q?IUBj9ImiLfqFhBPmaMwf/GKUKKvTd2B90c+HqfX8tN4TYCOv3TEyxecXTfef?=
 =?us-ascii?Q?iib8Ga9VRqa6jkt/8W5yX8VUy5lbjXH/sEckvd7JQEae7v7I+z4oKq3/mFpx?=
 =?us-ascii?Q?iNSZQ0/SqBGPygc37fzueucZ7sZDYkTdBl6RXApr5bmu4RvxX5DqOP7bixz5?=
 =?us-ascii?Q?7M7AKlECjyoUAS2/Hk2lG9AvwAclv2JZ+feVUp0mFtyvnTwuFbT4zalgseWv?=
 =?us-ascii?Q?+QjDBYT8CwjBltUaCTI0g36aj45d3wb7P0CKblUGjxdHXZu9aMuY+WdpX4AD?=
 =?us-ascii?Q?YbRVKvUXeBh4aoNozl693gOik/5fSCfa4nG0kKCvrN/+WKr+NVkjbdzdlF6M?=
 =?us-ascii?Q?trKFwEOe11Czeblx6jQYyIdN+z5V6kmm+6OfVpY+NFq9ALs1eZ0ynWlCLI11?=
 =?us-ascii?Q?jg0A4kRY4y7MLUNzdAeM+6Nqfsqmv6pj5TpWdmYI5MlBg3/aO/GTSyFwhiNF?=
 =?us-ascii?Q?/kMSTQof/1Nb5RhYjqxPlLSgI/cRTUrY0UkvzCbz3uTZjYqDKpp1DHIUZI6B?=
 =?us-ascii?Q?QTnn+5h/kz/1naww1mEZZic1wkawAxLjAZIpoVtvnCCs3e9gZcl0gqvMiyop?=
 =?us-ascii?Q?fv4KIsdS9xKtD8f2kfbV36VDy61ODLgDPuqrVA1ZAHN7PdXQlrR4vP7h+3W+?=
 =?us-ascii?Q?gGJPVT9K9jVbCuiDZ1sVIQd4oPHzySNEejlKT0QATP7CQY42oidQovbkSb4+?=
 =?us-ascii?Q?RUwrmV0og8lpmjMkI3QJOLKup6RBCJPk2JM84isPwtwLdQRdH25STVLtCzzz?=
 =?us-ascii?Q?h+L9s5AbdY7bl45U1chPiNv/MR7I5XejLJsinhJWTi3cv5CHV2fXpO08GIZA?=
 =?us-ascii?Q?Cokc4Ej1MleO/pJXtIhy8Z5HQVup+C3ecjUBjI6wsnlIxc3T5a8VC2iRmrJQ?=
 =?us-ascii?Q?3JPR59C+k5BYAB0lQuIpcR/VYepS+PGNbksh3ST/beN5A7nOfJsJeI+NJ9aH?=
 =?us-ascii?Q?33np7L17WQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3983fcd-1013-40c9-c37b-08da2eee0329
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 23:21:41.7915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhtE4KwnLdU7atq2asWeplf11N5rMDys/JgceSw91Lzqm6UlaIlyQjXqh4861Bah
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

Having a consistent pointer in the drvdata will allow the next patch to
make use of the drvdata from some of the core code helpers.

Use a WARN_ON inside vfio_pci_core_enable() to detect drivers that miss
this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 15 +++++++++++----
 drivers/vfio/pci/mlx5/main.c                   | 15 +++++++++++----
 drivers/vfio/pci/vfio_pci.c                    |  2 +-
 drivers/vfio/pci/vfio_pci_core.c               |  4 ++++
 4 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 767b5d47631a49..e92376837b29e6 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -337,6 +337,14 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
 	return 0;
 }
 
+static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct hisi_acc_vf_core_device,
+			    core_device);
+}
+
 static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			    struct hisi_qm *qm)
 {
@@ -962,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 
 static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
 				VFIO_MIGRATION_STOP_COPY)
@@ -1274,11 +1282,10 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 					  &hisi_acc_vfio_pci_ops);
 	}
 
+	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
 		goto out_free;
-
-	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
 	return 0;
 
 out_free:
@@ -1289,7 +1296,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 
 static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
 	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee97..9f59f5807b8ab1 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -39,6 +39,14 @@ struct mlx5vf_pci_core_device {
 	struct mlx5_vf_migration_file *saving_migf;
 };
 
+static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct mlx5vf_pci_core_device,
+			    core_device);
+}
+
 static struct page *
 mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 			  unsigned long offset)
@@ -505,7 +513,7 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
 
 static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	if (!mvdev->migrate_cap)
 		return;
@@ -614,11 +622,10 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 		}
 	}
 
+	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
 		goto out_free;
-
-	dev_set_drvdata(&pdev->dev, mvdev);
 	return 0;
 
 out_free:
@@ -629,7 +636,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 
 static void mlx5vf_pci_remove(struct pci_dev *pdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 58839206d1ca7f..e34db35b8d61a1 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -151,10 +151,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 	vfio_pci_core_init_device(vdev, pdev, &vfio_pci_ops);
 
+	dev_set_drvdata(&pdev->dev, vdev);
 	ret = vfio_pci_core_register_device(vdev);
 	if (ret)
 		goto out_free;
-	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_free:
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 06b6f3594a1316..65587fd5c021bb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1821,6 +1821,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
 
+	/* Drivers must set the vfio_pci_core_device to their drvdata */
+	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
+		return -EINVAL;
+
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
-- 
2.36.0

