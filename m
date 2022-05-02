Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40769517AFE
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiEBXq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbiEBXpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:45:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CC9DF2
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:42:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9vP+pyZ4pUrge0hbC92C7jpkhOcfDiaU+eNqCLxCCc8yTb/rNbktA/a69sJMvfAoghZhIDhS6E/hme0Tv782iqVkD6ZLPYQIe0WTSEDDKs43zJIqdatedFVA8MfD+qTWXho6DD0P56EB3aD/HcjmAAAUiEsbhqXrfFezu80DyGZIsBE1oBcWdEyTVNaSSAE10l+IXU2QZEuxDeqT4EOWiRpK/g4s+CSm6DoT9ahPQYQsvgwxoDr+fTVNRj4uNLehhqKXVrvcHZexc4QD9ZHpTG5cBDu0nZhoB/+tvJZrZvZNUO/4E6y+scfdQggUwqzCd8O6edmuGQR0GnM6ZJjLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9KhU4CeQU5x2bvgY0bQDQaNF4e47SbIWk5H7f1cReM8=;
 b=monJnYhj45QeaWkGl99JUzrHREFZRxNbqbAUN1FGRbh6GbNHzMyiQpPFP0IZihle/o2uWkGWFXuSF8vzuUAvzDZPoaT0ZPJv6hSkGJDw0+dnQ3eqEm7/RG9EAOgoHsXa02p5AyRdVbqe7dhp/UVR4ISRFoVLG9Fzkb1/g2jzT2lzivk/1+ISc8TBMR/6te6tqkEQxI2HBtOCZgRdloL/+qCB4QqEjw0E3+g0nwQUpON96DrGHMLVBYMdywc9gKuIxhQ9UK5kNxpSUeRzCoQJC5Hl9h9AXYnNFpy1UtczNRfNzjRyoFCv9ArPXgGAEFvjVZNowGCnZuzyPqLxqpoidg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KhU4CeQU5x2bvgY0bQDQaNF4e47SbIWk5H7f1cReM8=;
 b=cGNgNy4+BsQylOi+RHz1ZTdQxfaZYoyVUq3/iYChpvvKzyCMvgDFEu2h/Z3yE3hIPHEiSSprCJbMmUgUhrPKVCHpS4wJvs6UJTodSMPkVCde6tk7CimuXP28gpZx7QcEnsivyRnvea0n9MrCFOQ8TNVITF9aIRdiQqPQrh//sGq+ON7+kZhmzQ23U727LIfNg9FmjWyC/xsxwApAibOHdFsnjYI0VHYyyenBQLpB3IGhTlXF0dNyDv8Ckp9IML0rCsPlXNCb539scriB0NYucZsFe8Gz21RnCw2yp96pLvfUfrY6QjjYYj0iatGfP49khl8emZMz4k9XEB7JwcJG6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Mon, 2 May
 2022 23:42:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 23:42:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2] vfio/pci: Remove vfio_device_get_from_dev()
Date:   Mon,  2 May 2022 20:42:11 -0300
Message-Id: <0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0136.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fadf227-ca76-494a-086c-08da2c9561c5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB41923F6581CE1BCAD1F92823C2C19@MN2PR12MB4192.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1v8Y1FEMUu/Qd5FNbq+uEHHbKLd2AAyNrSJOOKtKs5D4kp/YpFHXl7A/7BhicDm1xOpYTXP+h/UXENgIFFSVoVMpQY/pYQs76JvKSGyCbcZx9r7q1lNXSyLDQhfYUnfGBAG14CtuIxBWlj3gjrTSFjp30Os494Z7zO4Y5ygGxseUcc4fiXcVNaRx8qfXfpjWSeLxkHn+2+enlKZ+4ObtSVQ4WVAOUgICPMazwYMrl/lQwmihsYYMsRF455gem5uQANlIyE10K/aCwNShOPI3HX0RctKhPFQ+97o1ryStdkH5OxIy43Pxhe6FsLZif9jtc98xYGCcjE0jmNuQGPnU4EdlW4bTkjP7LYXdgMA1zmq8KHNqS/8lJJvbJFvELki0WY3PywelrnE+8W7zRVrmeEXav45lfyndmz2/n4JHT3dqLSB0sn/IpsRxHQOD9p+gLuf0IO3ajE0q8PO4eyYAnACwW3HAhBE3cbUWYmW00GD9iM6ucYlDblhGiekbuXPz0c9Nt55r3joHNV9lUkHVXNeSWTvioyaaAMRpYJHAqkWZvPr8XFRLu//8NzFRbpJLxWAjna6SLHINK3Zik98Q41fklTckNakjBwvCn6+s6Dw77X1WfLf5sLYvsBfJ4O+DqncvHDuhacnisX2daNHqErxXNSGpxDd27yh8bK/atWr/1rRQ/nmzD20lnqKaRDuiR7Ug+xWo4hRBVcYNFFD2BqwvKW6UksY62bQvcGJMrCNcKBxO77OkdHHmLBJB6Pjdfe/c+ooIWnqUK2CkQoachA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(36756003)(186003)(6636002)(110136005)(38100700002)(6506007)(5660300002)(316002)(8676002)(66946007)(83380400001)(8936002)(66476007)(4326008)(66556008)(2906002)(508600001)(86362001)(2616005)(6486002)(966005)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hhKejFo1GnvC6hkfNlvRMTKwbw3ii0bsTzLRvFXLnRUSosQ2Ia9hE572o2/0?=
 =?us-ascii?Q?teSsrEGsN6sc7s8aV29UTeIkJmd6wFIEkH5ZaskxOqAoSMF33oOPnL4hnrbz?=
 =?us-ascii?Q?NRz/ugnTpitdNm4v+J68kLP8r3RsnkJXM6I7HvyZreY6/tOO1yfFZ+yqwOK6?=
 =?us-ascii?Q?fFJPuLOn2BsCi+FgE0Irj1aTVnK7QerlxeOypCy9b1VgudDrG9lf0iaz4cT9?=
 =?us-ascii?Q?b7J6YxHB15EfdR6vst5M6gSib8fxr6yvvzMVkzRvFfy9dvsWn6OuD7tlHPEr?=
 =?us-ascii?Q?1I1d4XFdHwQ+ZUiLq+LWiqxSYJiKsrRjqAP9SKXgJGrcFltc8w2P/kWS5/og?=
 =?us-ascii?Q?PA4vsJaim1wJofe+AOCuxV8DknXnfeS1EKh9ExJshzQMqG61VhbLew5/VNLA?=
 =?us-ascii?Q?CN8JynKRAm5U/gsd4QzCVC/PWQ+hYvvAe6BwbDjIlLwM2+vZlMd80KAgR27S?=
 =?us-ascii?Q?/KyDsuM1ai2y7JoOz5nXDOzmY87rzFKHGoEBGvoH3Vep4w2sPuywjAbn1teh?=
 =?us-ascii?Q?iUjhi3ZDxnUM2g3NM2HTZL4c8L4nQYnx3AChy59HnwkNCIPPsuwXMMa1/Wou?=
 =?us-ascii?Q?AvBT+OgaRRKiTFC7+2gLEvfjj3eYHmDV0PBAjXUyPznegfqjQAkbcLSt9+AQ?=
 =?us-ascii?Q?kIfz/q/7Y5WR1iETPBfts7AoVA04XclRFtV48kAaq3iKNZlGrX2SlHvwIH4D?=
 =?us-ascii?Q?U6u07nP3lgkUjRH2DuAKKPkUI5RaVF/tOOIk5eba+tXKk01VUEj6ainaIOix?=
 =?us-ascii?Q?0FpgPIxpEln1JIBwJE/NWyJONCIdr3ypf9ZG+rpil5O4d4MfIKK8DBX/gZV3?=
 =?us-ascii?Q?u8Cp0/hUvOHfSFNxrRwYD7NJ1l9a7pESSz3DmYgcWLPvI+hDRtW7Q+sMCKfx?=
 =?us-ascii?Q?zNiny+qZC6Dfbp3FmvPD4paHKZujCa0g5m7/1JeXLa6RdwV1a8I0nyJUsazx?=
 =?us-ascii?Q?TgmqrlIehyO2g80QwUuvjlhZipceDrT3KYcBuQFi7Vuq/hDCnWkm96eLjS1l?=
 =?us-ascii?Q?6xYr1r1h6IOvHZ3tupmBQB5XQ5APCfNoTBO7Jsf+4wERlopd9ntmaTyp5qUh?=
 =?us-ascii?Q?1jEa0Ahpxa7fplXI5AtwdOV0Osjd4AKYlxEzeW6vLmCD+CsvdOqukDG5xnnW?=
 =?us-ascii?Q?746IcCV19r8UWch7Hk8tSUFve5Woo8Du9AFuOYXfbWsH2QNSjbemETnC+MAh?=
 =?us-ascii?Q?/XcGExOfBODNjBEJ4sl6a4IyeDstawp7pDlWbJP9rHBd+NSys2SR+WPG8XMD?=
 =?us-ascii?Q?4ni8DkOYPlO5dnU2piE1b2ovyEMzryLcPiCOtjMDhgm4/f34juUv1vTYhcBx?=
 =?us-ascii?Q?vRQ9N9AbvduziBDH3QsQb9ouob9SqOTXDKd/bcQ5yGAaDLbslq2+AddQPlyC?=
 =?us-ascii?Q?cxSAH+cMwZMscf/L0/s2ILHrM4HBHw1Ie3k/eLslNY9lRQ/40sjsjkrOxJ44?=
 =?us-ascii?Q?jLq0yxc4u5VyLFwE0lgJEMI4+ZV5xBESiFNvsjuMw6FiYdT1pdLp1/4hefM0?=
 =?us-ascii?Q?BF992yNJSlmRZVNtINWQn1gggwXtsA2WcZbTJYvAc+0j7G4hEtpLjMwM7E++?=
 =?us-ascii?Q?JyNLfVJtCI1VkuSpig3WBs50utvpSCAZHV4Sun0w5o08wpK//hTGDaWwMeu5?=
 =?us-ascii?Q?agJsDTqF6GBVPUotpafj0gZKZH8jhfvKxG6i4CTksi/OTHGnJV3ZYFBFGuY3?=
 =?us-ascii?Q?uVN3ejTk7N1PldItqWwZjTmVIj51+28b3ur100o81c8fUEA6TQ4AOr3sFUyi?=
 =?us-ascii?Q?WkmdufwHDQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fadf227-ca76-494a-086c-08da2c9561c5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 23:42:13.1053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SV8wkp7LuNTQ3cLQL0miUSXSBHV8yTgEdQ6qWEld5YfURP2E5aEuVczpOYEdxxv3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4192
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The last user of this function is in PCI callbacks that want to convert
their struct pci_dev to a vfio_device. Instead of searching use the
vfio_device available trivially through the drvdata.

When a callback in the device_driver is called, the caller must hold the
device_lock() on dev. The purpose of the device_lock is to prevent
remove() from being called (see __device_release_driver), and allow the
driver to safely interact with its drvdata without races.

The PCI core correctly follows this and holds the device_lock() when
calling error_detected (see report_error_detected) and
sriov_configure (see sriov_numvfs_store).

Further, since the drvdata holds a positive refcount on the vfio_device
any access of the drvdata, under the driver_lock, from a driver callback
needs no further protection or refcounting.

Thus the remark in the vfio_device_get_from_dev() comment does not apply
here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
remove callbacks under the driver lock and cannot race with the remaining
callers.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 12 +++++-
 drivers/vfio/pci/mlx5/main.c                  | 10 ++++-
 drivers/vfio/pci/vfio_pci.c                   | 18 +++++++-
 drivers/vfio/pci/vfio_pci_core.c              | 42 ++++---------------
 drivers/vfio/vfio.c                           | 41 +-----------------
 include/linux/vfio.h                          |  2 -
 include/linux/vfio_pci_core.h                 |  9 ++--
 7 files changed, 50 insertions(+), 84 deletions(-)

v2:
 - Rebase on the vfio_mdev_no_group branch, which is on top of gvt & iommu
 - Delete vfio_group_get_from_dev() as well due to the rebase
v1: https://lore.kernel.org/r/0-v1-7f2292e6b2ba+44839-vfio_get_from_dev_jgg@nvidia.com

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 767b5d47631a49..14bf85ff6cbe96 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1305,9 +1305,19 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
 
+static pci_ers_result_t hisi_acc_aer_err_detected(struct pci_dev *pdev,
+						  pci_channel_state_t state)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev =
+		dev_get_drvdata(&pdev->dev);
+
+	return vfio_pci_core_aer_err_detected(&hisi_acc_vdev->core_device,
+					      state);
+}
+
 static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
 	.reset_done = hisi_acc_vf_pci_aer_reset_done,
-	.error_detected = vfio_pci_core_aer_err_detected,
+	.error_detected = hisi_acc_aer_err_detected,
 };
 
 static struct pci_driver hisi_acc_vfio_pci_driver = {
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee97..fbba1d52a4cf64 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -643,9 +643,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
 
+static pci_ers_result_t mlx5vf_pci_aer_err_detected(struct pci_dev *pdev,
+						    pci_channel_state_t state)
+{
+	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+
+	return vfio_pci_core_aer_err_detected(&mvdev->core_device, state);
+}
+
 static const struct pci_error_handlers mlx5vf_err_handlers = {
 	.reset_done = mlx5vf_pci_aer_reset_done,
-	.error_detected = vfio_pci_core_aer_err_detected,
+	.error_detected = mlx5vf_pci_aer_err_detected,
 };
 
 static struct pci_driver mlx5vf_pci_driver = {
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 58839206d1ca7f..fbd413a4c54360 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -174,10 +174,12 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 
 static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
 	if (!enable_sriov)
 		return -ENOENT;
 
-	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
+	return vfio_pci_core_sriov_configure(vdev, nr_virtfn);
 }
 
 static const struct pci_device_id vfio_pci_table[] = {
@@ -187,13 +189,25 @@ static const struct pci_device_id vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, vfio_pci_table);
 
+static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
+						  pci_channel_state_t state)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
+	return vfio_pci_core_aer_err_detected(vdev, state);
+}
+
+static const struct pci_error_handlers vfio_pci_err_handlers = {
+	.error_detected = vfio_pci_aer_err_detected,
+};
+
 static struct pci_driver vfio_pci_driver = {
 	.name			= "vfio-pci",
 	.id_table		= vfio_pci_table,
 	.probe			= vfio_pci_probe,
 	.remove			= vfio_pci_remove,
 	.sriov_configure	= vfio_pci_sriov_configure,
-	.err_handler		= &vfio_pci_core_err_handlers,
+	.err_handler		= &vfio_pci_err_handlers,
 	.driver_managed_dma	= true,
 };
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 06b6f3594a1316..9778d713f546d2 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1890,9 +1890,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
-	struct pci_dev *pdev = vdev->pdev;
-
-	vfio_pci_core_sriov_configure(pdev, 0);
+	vfio_pci_core_sriov_configure(vdev, 0);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
@@ -1904,18 +1902,10 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
-pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
-						pci_channel_state_t state)
+pci_ers_result_t
+vfio_pci_core_aer_err_detected(struct vfio_pci_core_device *vdev,
+			       pci_channel_state_t state)
 {
-	struct vfio_pci_core_device *vdev;
-	struct vfio_device *device;
-
-	device = vfio_device_get_from_dev(&pdev->dev);
-	if (device == NULL)
-		return PCI_ERS_RESULT_DISCONNECT;
-
-	vdev = container_of(device, struct vfio_pci_core_device, vdev);
-
 	mutex_lock(&vdev->igate);
 
 	if (vdev->err_trigger)
@@ -1923,26 +1913,18 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 
 	mutex_unlock(&vdev->igate);
 
-	vfio_device_put(device);
-
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
-int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
+				  int nr_virtfn)
 {
-	struct vfio_pci_core_device *vdev;
-	struct vfio_device *device;
+	struct pci_dev *pdev = vdev->pdev;
 	int ret = 0;
 
 	device_lock_assert(&pdev->dev);
 
-	device = vfio_device_get_from_dev(&pdev->dev);
-	if (!device)
-		return -ENODEV;
-
-	vdev = container_of(device, struct vfio_pci_core_device, vdev);
-
 	if (nr_virtfn) {
 		mutex_lock(&vfio_pci_sriov_pfs_mutex);
 		/*
@@ -1960,8 +1942,7 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 		ret = pci_enable_sriov(pdev, nr_virtfn);
 		if (ret)
 			goto out_del;
-		ret = nr_virtfn;
-		goto out_put;
+		return ret;
 	}
 
 	pci_disable_sriov(pdev);
@@ -1971,17 +1952,10 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	list_del_init(&vdev->sriov_pfs_item);
 out_unlock:
 	mutex_unlock(&vfio_pci_sriov_pfs_mutex);
-out_put:
-	vfio_device_put(device);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
-const struct pci_error_handlers vfio_pci_core_err_handlers = {
-	.error_detected = vfio_pci_core_aer_err_detected,
-};
-EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
-
 static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 			       struct vfio_pci_group_info *groups)
 {
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index f7d1898129ad1c..fcff23fd256a67 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -444,31 +444,15 @@ static void vfio_group_get(struct vfio_group *group)
 	refcount_inc(&group->users);
 }
 
-static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
-{
-	struct iommu_group *iommu_group;
-	struct vfio_group *group;
-
-	iommu_group = iommu_group_get(dev);
-	if (!iommu_group)
-		return NULL;
-
-	group = vfio_group_get_from_iommu(iommu_group);
-	iommu_group_put(iommu_group);
-
-	return group;
-}
-
 /*
  * Device objects - create, release, get, put, search
  */
 /* Device reference always implies a group reference */
-void vfio_device_put(struct vfio_device *device)
+static void vfio_device_put(struct vfio_device *device)
 {
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
-EXPORT_SYMBOL_GPL(vfio_device_put);
 
 static bool vfio_device_try_get(struct vfio_device *device)
 {
@@ -633,29 +617,6 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
 
-/*
- * Get a reference to the vfio_device for a device.  Even if the
- * caller thinks they own the device, they could be racing with a
- * release call path, so we can't trust drvdata for the shortcut.
- * Go the long way around, from the iommu_group to the vfio_group
- * to the vfio_device.
- */
-struct vfio_device *vfio_device_get_from_dev(struct device *dev)
-{
-	struct vfio_group *group;
-	struct vfio_device *device;
-
-	group = vfio_group_get_from_dev(dev);
-	if (!group)
-		return NULL;
-
-	device = vfio_group_get_device(group, dev);
-	vfio_group_put(group);
-
-	return device;
-}
-EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
-
 static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 						     char *buf)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 9a9981c2622896..de8dd31b0639b0 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -125,8 +125,6 @@ void vfio_uninit_group_dev(struct vfio_device *device);
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
-extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
-extern void vfio_device_put(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 48f2dd3c568c83..a0978ce126395c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -227,8 +227,8 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
-int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
-extern const struct pci_error_handlers vfio_pci_core_err_handlers;
+int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
+				  int nr_virtfn);
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
@@ -243,8 +243,9 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
-pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
-						pci_channel_state_t state);
+pci_ers_result_t
+vfio_pci_core_aer_err_detected(struct vfio_pci_core_device *vdev,
+			       pci_channel_state_t state);
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {

base-commit: 21ce7c292b5684f930cc63f3841ec692bbd6c10a
-- 
2.36.0

