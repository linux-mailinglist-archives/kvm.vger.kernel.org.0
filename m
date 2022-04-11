Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD384FBDEC
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346711AbiDKN6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 09:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346697AbiDKN6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 09:58:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AA92AE2B
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 06:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Me4Cyd62gPCljjPYoF67MPZZA55cr3b7PjHOuV5NkJ9E85U4vp3hmm8MYViTpFHsQCsCKrKvmLLA6spLVAdA+0m/AA+9EzjRr1IL6BOOdR0TyWI3zBzCkSQktP8H3SqlqbEZDzaGwUlmhctZQZlkP0K3zqHcFDcI/OxUyCGCsgJmjDjWvytpf4tdEuBOzxJm/Q4ILzWM+p6J/D8Q4YJWiPmL2TD5Jq9dVi43TCRDtXQno5eLyp0Oosqd12fxf5OMzZ37FHJXnXG3dwVqDFeJNbMKH/TImZLhhZ+4RHEfSW6kMq5ajxDQTAQwOavLTxL3dJsBXz9IjLuPBMhoKIfS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cD6NtkJtDioGtHeFSWJAVwimkKPIOi2YsIOTP83Af6M=;
 b=RMh4IAb0+tN6j1JFa7HJ8fnMgvB8RhlYkPfs39ypmzAzUpME5sJK4uskMG5hrRxPXBv0JxmzqiUNFjQnYoTdn0hOjj3cXp2PvChR+4AxjBOvVwMRsYbBiOa5HRbNvzsn3AVaBK6K2URg/Fq2tRGCc4lQ06d7P2MWKoZhm7zzYQyc5DVWuqAcmMWy3/YFjCsO1f3ioU+baaWop427RLpmmxt1t3Rh25idlGwsZFO04v8K8ZKxvVa/nRd4uaupPBPnvFwFQe+8z9DyDI6RJRERbcSHyIjiQlWtrXy4b/9MG3WuKRNQh/fkx0hzsPEs/My53H1FgNmCTqbp5b8e4avUzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cD6NtkJtDioGtHeFSWJAVwimkKPIOi2YsIOTP83Af6M=;
 b=trz7aEFPEjVRsXEwGEJyKvbjU95GJpDhBAyFbJT8/aEZnb5N0i6/iWb2mmC1YviEXG6Cr600RiXDOTPI2ib1+CEhb2m84uSLlDkbRrGsXV+JhzhWOWyDTvQjJFXlhqBbp3xVruO3ESIXXQIyTmJ6MweqIXKuNy7zQK/a/bvJLP/zhuojyixFPhzoPRKlkYiCu6m8zQ/vWUveZWNjprQ1ia3KjrSlwwnVWb9/LfPHj6udleGe1q20gT0yx5wu3ffipWKWMiEjdYFJ4P0TEIqjm+GIB+BtYDEvUu5aNNkfvLSsWKIrgoQ2FCg4UtrAGdQwBak5bfmxeizK0XlQve3JZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1295.namprd12.prod.outlook.com (2603:10b6:300:11::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 13:56:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 13:56:32 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v2] vfio/pci: Fix vf_token mechanism when device-specific VF drivers are used
Date:   Mon, 11 Apr 2022 10:56:31 -0300
Message-Id: <0-v2-fe53fe3adce2+265-vfio_vf_token_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0016.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15bde07b-87a6-414d-a6eb-08da1bc315fa
X-MS-TrafficTypeDiagnostic: MWHPR12MB1295:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1295AC2B5BBF8B710C47CC63C2EA9@MWHPR12MB1295.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SacQIUlrQxAQwHA6nzUqsghPpHgheeUXcJoxAJDW4qfuXiU8HKn6fkanIR+jEPT7nrVl1XWfsY62R0MJ4NUU1Lnnkp0Qi24RPxywu22v4wXRgFRvy4Xsdt1ASONRp4NlWu1PJR4osusTtxmlgw4X0XTw22UPCYxF0hVhrCNJgXdHCdTEqRKN3ttOpkmcoYNBUjGCnYTiB75f7/Ko/l/WlZnTkIKtd5TERI8FSfjYUHuULAQsjazi3qQimT62+BpswCuWx/hRxuk3Sl/J+iedfCn0Tut7TL2WsSInbvQun05FJoJAEeFwBnbol9Vsa0MlwP/ARxV6ElY1c3KLIDxyaYezEgwCvCh9+e9HDA2cN2KeBQO7vaHcXy4ni7lgw5gzAaIysyXKZKl6VUO3R2RAf/bOmcJYqtIDpOqBtsNwtZCoZNxQVsHGhd/cBcXJShUnSlAOkZw+Obin0NebjiPXTmtDQ799s51ki5mu4VLzyJeoEQUkdGZR8KATHV4KC8pV3odzZ+4Uxn48y7Ttmue+7zoJriRfXRbYtd47yVUv9gXi9axxiXl11RMAXaKNybTK6U3gdzF91uMY6ATcA4gzvfgIYihawoewW76io2Dmh0KqzuXq5x5Q2i+/vBMo/gfvueJxaQB1Gs0BcVTSe2NkC+nvzZj2CiwzTkjqbTBM8zK+CXw2xSz0aG5S730E1fQHuwjx3tYEHQMKXBIt8dcuQ6LS7rpz3twlftuxkkvHd9o7Izo2Gql5wycfiGewVrwjJJYv2790ul3eC2i0tdzp1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(66476007)(26005)(6512007)(4326008)(8676002)(6506007)(316002)(2906002)(38100700002)(83380400001)(966005)(6486002)(508600001)(110136005)(86362001)(54906003)(186003)(5660300002)(36756003)(8936002)(107886003)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ehVqyJaqlfyvvmispxH8nqsbS4Rpk2C0L6fEe+Rov/86SBY05P3JJvYwc8iA?=
 =?us-ascii?Q?K96Sv0U9OcYEEk18m2Kf1g7PAuSQS6stkIo7/WklX2VH/qmDIYyViM2frmQ2?=
 =?us-ascii?Q?z5zt4WMbRzfvOB9CbRDsFkjVR986zNfC8lGxy+XRTuDlqRkRj+/xPuDrrVFw?=
 =?us-ascii?Q?iHgaMA1hQFJoLBs3DDy1RDQqBECwvTt+Hcad0GHjPMT0nKBBgj9PnuEIhn65?=
 =?us-ascii?Q?2A/QAxuk1bvH9mfuHPF2f3rfB4dzfK3YCCIpo3AWEbX3fgP1abVSt4Cm44nj?=
 =?us-ascii?Q?006eqjjWRL+2AIJ7KnMQddawT3JYd3EvL1dHzDp1Yfj6MbZzcd7n1f09ClWS?=
 =?us-ascii?Q?k2fOgLWVp184mXlM2AVghGU2q7vCWJoK38+g+DgVsxUsPp1O+7j1AHqKj9CQ?=
 =?us-ascii?Q?3QrCrgWe3N1iTyitJV5tW7C9XcYwT5iIfbNTbROLCPT3Uvl+8lxcv3G0kRlS?=
 =?us-ascii?Q?3xdaWCeB5Y7ATQ03muewGkEC1NP0ZycG1+OCiAUgs2cvWHDZ+BC955CrCsqD?=
 =?us-ascii?Q?vEci42iJd61tjNsLSWwzLw+d0+da7m235ioY4FOV06lSNuqp4YXRqG0Fm+Xa?=
 =?us-ascii?Q?rWEiYiP07bcD2rbZZ2qeq33hkeaZkktS5VYY3WEwQw+6wEEJla0DlFtfWyb4?=
 =?us-ascii?Q?k22ebNcnZKX6I0rCBUF7cwQ0wW+k6V/eqR6alhadC44aymFKW7BcL7HMP6r6?=
 =?us-ascii?Q?wFNs96+NdXfSjrbtg/Y0t++fRoDDFF5ysJbG3XmlcM4H/jBJyJyK0AIYK0pJ?=
 =?us-ascii?Q?mHqGe+r95e98U6nDlDQT8PeDV61qBeUGRgE+eMgFamapDKsBXyRWWSdfWCZd?=
 =?us-ascii?Q?bEsxSVLQ8yGfA7V0UMu8uuiiHImo+eB2t4UETFLtQXd1C3oMvxfS05HZFwhr?=
 =?us-ascii?Q?1yFLr7xX5Zc0wROns7umTx9Slo51CK3B354dk2BB0RX5xQuKv3pxU0skbLog?=
 =?us-ascii?Q?muBQMBid4gIfBv2qSlxEP734oe6rPW1gpWZWrzHhaMCUWxHcTFHv43o+eoD9?=
 =?us-ascii?Q?+iza+gOhuKINOFZk5LYVm5ywcNRXQLkwi7elb6AuEkMhazHMFAxToAq35q7w?=
 =?us-ascii?Q?3Wjv1Cw+6JJcMN+niGjQK3gUkGR4KSPAg7aO6gqSHvZThqt4SPRpcyYMWwdy?=
 =?us-ascii?Q?sqa5GYwDacMREL3UxO3HKusgJMW6PAt/dOCRUS/TgMhFYNP+nwF/b5zkH+99?=
 =?us-ascii?Q?wxiT6OLze4GDkLAcRDptiHpWHUkoGk5LgFtVyBGaIGe/efebt0iwUlw0BivT?=
 =?us-ascii?Q?8jq6EsA9HSyyU/oEzhtwUbrrQsJMEZBT/goicciG/YtSyQPD9j8AaoE7r6SU?=
 =?us-ascii?Q?bx9y1F1GfhL+5AKf29FOvJLonpQsr6sq1M/aC8PJAyqpFT/tzhCEEGMXepoF?=
 =?us-ascii?Q?tS72Mlq7eAfslR52sTj6JFD4EW38BvoJZjTCj9tIU9ApVJ80Eeg9oS9U1U02?=
 =?us-ascii?Q?DLxMVxRez/nWuTY5VTIAcqYjFLjvrhHo19Rmv/mE3rMwrbbeERlM6Wl5v8z0?=
 =?us-ascii?Q?JLM8ME4DSBJvvciPv6dB9XAUWb3Q9MyhcIRyyzQlye+UzSKXuQFEEisuEN71?=
 =?us-ascii?Q?xKSOweDMngMDtiS9GleZNwdUKnYNLNntXXtowur8qWKxNC3EDEURuIcDy4Ep?=
 =?us-ascii?Q?mNM/1LOrOY4L10WC8RuQYnHAVHvlzYZiw55N9UJBTyChjnMoDo146MTmkBp0?=
 =?us-ascii?Q?rL0f5wgm2p6x/mXAPaKtyZLDNTZj6LdIzMV5QHx9ix+m12s/E18/t1qPk4XN?=
 =?us-ascii?Q?n3jzrObQ9g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15bde07b-87a6-414d-a6eb-08da1bc315fa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 13:56:32.9073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NA5d8RacTqPilbjpSvoPVgA8ifwLNTYVnBGCrRhnLzemA7Xk/zzCuJfBWXsfos72
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1295
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

get_pf_vdev() tries to check if a PF is a VFIO PF by looking at the driver:

       if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {

However now that we have multiple VF and PF drivers this is no longer
reliable.

This means that security tests realted to vf_token can be skipped by
mixing and matching different VFIO PCI drivers.

Instead of trying to use the driver core to find the PF devices maintain a
linked list of all PF vfio_pci_core_device's that we have called
pci_enable_sriov() on.

When registering a VF just search the list to see if the PF is present and
record the match permanently in the struct. PCI core locking prevents a PF
from passing pci_disable_sriov() while VF drivers are attached so the VFIO
owned PF becomes a static property of the VF.

In common cases where vfio does not own the PF the global list remains
empty and the VF's pointer is statically NULL.

This also fixes a lockdep splat from recursive locking of the
vfio_group::device_lock between vfio_device_get_from_name() and
vfio_device_get_from_dev(). If the VF and PF share the same group this
would deadlock.

Fixes: ff53edf6d6ab ("vfio/pci: Split the pci_driver code out of vfio_pci_core.c")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 122 ++++++++++++++++++-------------
 include/linux/vfio_pci_core.h    |   2 +
 2 files changed, 73 insertions(+), 51 deletions(-)

v2:
 - Ensure pci_enable_sriov() and list_add_tail() are called only once per
   device
 - Add a device_lock_assert() to make it clear how the pci_enable_sriov() and
   pci_disable_sriov() calls are being locked
v1: https://lore.kernel.org/r/0-v1-466f18ca49f5+26f-vfio_vf_token_jgg@nvidia.com

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b7bb16f92ac628..8bf0f18e668a32 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -36,6 +36,10 @@ static bool nointxmask;
 static bool disable_vga;
 static bool disable_idle_d3;
 
+/* List of PF's that vfio_pci_core_sriov_configure() has been called on */
+static DEFINE_MUTEX(vfio_pci_sriov_pfs_mutex);
+static LIST_HEAD(vfio_pci_sriov_pfs);
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -434,47 +438,17 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
-static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
-{
-	struct pci_dev *physfn = pci_physfn(vdev->pdev);
-	struct vfio_device *pf_dev;
-
-	if (!vdev->pdev->is_virtfn)
-		return NULL;
-
-	pf_dev = vfio_device_get_from_dev(&physfn->dev);
-	if (!pf_dev)
-		return NULL;
-
-	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
-		vfio_device_put(pf_dev);
-		return NULL;
-	}
-
-	return container_of(pf_dev, struct vfio_pci_core_device, vdev);
-}
-
-static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val)
-{
-	struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
-
-	if (!pf_vdev)
-		return;
-
-	mutex_lock(&pf_vdev->vf_token->lock);
-	pf_vdev->vf_token->users += val;
-	WARN_ON(pf_vdev->vf_token->users < 0);
-	mutex_unlock(&pf_vdev->vf_token->lock);
-
-	vfio_device_put(&pf_vdev->vdev);
-}
-
 void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
-	vfio_pci_vf_token_user_add(vdev, -1);
+	if (vdev->sriov_pf_core_dev) {
+		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
+		WARN_ON(!vdev->sriov_pf_core_dev->vf_token->users);
+		vdev->sriov_pf_core_dev->vf_token->users--;
+		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
+	}
 	vfio_spapr_pci_eeh_release(vdev->pdev);
 	vfio_pci_core_disable(vdev);
 
@@ -495,7 +469,12 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
-	vfio_pci_vf_token_user_add(vdev, 1);
+
+	if (vdev->sriov_pf_core_dev) {
+		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
+		vdev->sriov_pf_core_dev->vf_token->users++;
+		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
+	}
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
@@ -1583,11 +1562,8 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 	 *
 	 * If the VF token is provided but unused, an error is generated.
 	 */
-	if (!vdev->pdev->is_virtfn && !vdev->vf_token && !vf_token)
-		return 0; /* No VF token provided or required */
-
 	if (vdev->pdev->is_virtfn) {
-		struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
+		struct vfio_pci_core_device *pf_vdev = vdev->sriov_pf_core_dev;
 		bool match;
 
 		if (!pf_vdev) {
@@ -1600,7 +1576,6 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		}
 
 		if (!vf_token) {
-			vfio_device_put(&pf_vdev->vdev);
 			pci_info_ratelimited(vdev->pdev,
 				"VF token required to access device\n");
 			return -EACCES;
@@ -1610,8 +1585,6 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		match = uuid_equal(uuid, &pf_vdev->vf_token->uuid);
 		mutex_unlock(&pf_vdev->vf_token->lock);
 
-		vfio_device_put(&pf_vdev->vdev);
-
 		if (!match) {
 			pci_info_ratelimited(vdev->pdev,
 				"Incorrect VF token provided for device\n");
@@ -1732,10 +1705,28 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_core_device *cur;
+	struct pci_dev *physfn;
 	int ret;
 
-	if (!pdev->is_physfn)
+	if (!pdev->is_physfn) {
+		/*
+		 * If this VF was created by our vfio_pci_core_sriov_configure()
+		 * then we can find the PF vfio_pci_core_device now, and due to
+		 * the locking in pci_disable_sriov() it cannot change until
+		 * this VF device driver is removed.
+		 */
+		physfn = pci_physfn(vdev->pdev);
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
+		list_for_each_entry (cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
+			if (cur->pdev == physfn) {
+				vdev->sriov_pf_core_dev = cur;
+				break;
+			}
+		}
+		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
 		return 0;
+	}
 
 	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
 	if (!vdev->vf_token)
@@ -1805,6 +1796,7 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
+	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
@@ -1896,7 +1888,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 
-	pci_disable_sriov(pdev);
+	vfio_pci_core_sriov_configure(pdev, 0);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
@@ -1935,21 +1927,49 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	int ret = 0;
 
+	device_lock_assert(&pdev->dev);
+
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return -ENODEV;
 
-	if (nr_virtfn == 0)
-		pci_disable_sriov(pdev);
-	else
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	if (nr_virtfn) {
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
+		/*
+		 * The thread that adds the vdev to the list is the only thread
+		 * that gets to call pci_enable_sriov() and we will only allow
+		 * it to be called once without going through
+		 * pci_disable_sriov()
+		 */
+		if (!list_empty(&vdev->sriov_pfs_item)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
+		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
 		ret = pci_enable_sriov(pdev, nr_virtfn);
+		if (ret)
+			goto out_del;
+		ret = nr_virtfn;
+		goto out_put;
+	}
 
+	pci_disable_sriov(pdev);
+
+out_del:
+	mutex_lock(&vfio_pci_sriov_pfs_mutex);
+	list_del_init(&vdev->sriov_pfs_item);
+out_unlock:
+	mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+out_put:
 	vfio_device_put(device);
-
-	return ret < 0 ? ret : nr_virtfn;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 74a4a0f17b28bd..48f2dd3c568c83 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -133,6 +133,8 @@ struct vfio_pci_core_device {
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
+	struct list_head		sriov_pfs_item;
+	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct mutex		vma_lock;
 	struct list_head	vma_list;

base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
-- 
2.35.1

