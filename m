Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00224F990A
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 17:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiDHPMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 11:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiDHPMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 11:12:24 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1F5D1100
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 08:10:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+KDMGY0ekiXqeAi9h9l7OUhNh68yc9htDtLB1BFkGLwyC7XC3Vjop+iuUHtAO2pBWDnYdgTadzpa85XNOqa8ctAD6c6O1n0/AxDVKe+MdhWWpbDMOhmUSpgrnskDhKDqw9sXO5yl/kIpoHiOa0olI9awqmfrYU+q4fxwstXcG8vWmBoS2A+g7L++hofrIvFb6sUo4Og2y/N2vBfK8W+mJp1XPerTESUefXbJcwUS+RRt/LJrop4V0fCGiKbMFUlrwo8HjDH6fzgH7BDyaQoCts9CyDnp4GRatoIrUIVEhzNL9QVoMX6ZOV4mZe1zJ5otwylLDp5CRIYKsmD2hvmrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dV8rhHmNWxUq9q8uHIUlQi2UUT3dWT2Cu1VmQaQJOk4=;
 b=c9NzSm3dNa0X0JpvwRK68cb291DfUEzbhlI4s/NGZ2gUUGPb6JaOVEn1JE7pqfm5gvZWlnkUaW/h+3+jCNuDB5Ir7QjL/D3dQ5320tvnvmEQmXXHePY6TLotUDgdd7e1B4vyFJ0gnV/eKTB/XJe8JZ7T4G3z4w8cBTmXP+B4Ti2tj+fGywTHgk8d8n65UrNK99RV7LIDZK34mE7AEO0d7CORTpyiBwGYXTOFGLZAmQnMxyKv1c/jRXF1gpNQxEKo/dzN7GI2Cb7j1HXBSwkqaeaj+kMiSr/pYFORP60Aet+OMn8SUx6CfDu6B7PrBqYIOa/dAHaueY5HTV5mP/95PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV8rhHmNWxUq9q8uHIUlQi2UUT3dWT2Cu1VmQaQJOk4=;
 b=hGeUcdHZGYz7A459Hb9VQ1R80qC4/h4Z1mKbbSf4Ai3ahFByiE1rxSCVVgoZXW8kPoFF+0op16JuH4d1kb/5yF6Fwi3zdJes8tboluK9ljmlC+SBTxgKREKNo9D30F/uNDAJJHac6JR7+uqFMTX0qGXJQ71FL9JgmPx098Idtdcd38/cLsNwL/cAQxzViKGCho3rXqQ1+ed/9HLF8eOx6yUnZcaxR7/1ZNi6Be2/35lVnr5Z6xWzs4Ks+FGq3/bvuyEJuVJPq45B5t36yygxBVSK+vucsLO2QI2/af78JmPi5SpIZ7oFJXbGpvbMJs41UNvhODaP+DzhZLLug0U6gg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3788.namprd12.prod.outlook.com (2603:10b6:5:1c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 15:10:16 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 15:10:16 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH] vfio/pci: Fix vf_token mechanism when device-specific VF drivers are used
Date:   Fri,  8 Apr 2022 12:10:15 -0300
Message-Id: <0-v1-466f18ca49f5+26f-vfio_vf_token_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2e9dd1f-5c44-4c3c-ed5f-08da1971e336
X-MS-TrafficTypeDiagnostic: DM6PR12MB3788:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3788B8E15B02119C329ADB9CC2E99@DM6PR12MB3788.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zY1IhDheLZDPwSoPYuBQLzObMmOzp/RLILJxUQXMu4DKz3YwpkJk1naGFUOVOObklFIaJpeL4bkHvDEedw1CgccZ0C4KKby7YtdCWtcLIYJud2VbmuDUFhzA3xtgirFEX7hqb0N7xkAbzhC//u9kmuyM3pfCPndbRoU1Lc9691mbsSOA0iq86AKlp/1NLjVoe+sCLsNy5ALYBOkw+DlG2vAgH+1mnqmNE9s7Iw3O2rJ9cFiZZE/2vCe9UwveqOnVnwKIbH63V5kiuMO8KnEaJ+UTQEiXXpRm0PDSdu3/af++w/uw6n1/lL/mD/j0Am9B731KFnyGo63CJp3NcG4ZVsdapH+/Iv/jTPNl79+Rkf692bYEyzW4H0foldAugXHnmGC54+hn5liOOJ/4zIE2TIDyQ3nm5qxeqhaFgn2XJgsJkIUn46r3r1QVvu/5E9oHXD5VNN+erJUARU84jnL/12VXd2BxsjA8xNPsmq58QWzq1NlTOR6Fh2pOqFvlo4WLNDh84KH48H69To0s3iJROYhTzVANiKDI/Cw8n1gmGUUA54igXBl/jW0GngZ0ANbjs75KeRnJ2G5MA0UhJGbjmOEZjDR0B+L5SdAbfI1gBicazvq5ysOOYGqTJSxXfhzN9nPseCV4sBm6ibyKNE4NaFSckJomdxn4oNaOW1h6zc7aKJP2+MtcDp3J6QTohU3n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(66946007)(186003)(508600001)(6486002)(38100700002)(36756003)(5660300002)(2616005)(4326008)(8676002)(6506007)(2906002)(316002)(66476007)(66556008)(107886003)(86362001)(6512007)(8936002)(26005)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qMJzNgLccY3DybzDQHrRobnEIo7sOnfRWOq5e2PgMwePlsREPdd9hsm5Cl5f?=
 =?us-ascii?Q?Rndu2VPScH2a08fdj8b1P79bRz7KMtss6t441YeqDUVUhzrtyeX78vBNbyJm?=
 =?us-ascii?Q?pqBSUN3wyTquyQtfzcCjJQvc+IM0Nsegps/8Qw2cFixesFdYhgOoQ7E191im?=
 =?us-ascii?Q?LL1ESMRNS+cSEgK6rx99zteT7JOICv3lxrJ4trST1EykW7AbPPMOg5BarZAA?=
 =?us-ascii?Q?nL+cN3gFBiJ2UKodFiSZF729AeAkroyrnWQFsSxg90JGehYMws84CcOHh0gO?=
 =?us-ascii?Q?MHnZVjNtnN1qS4pvBQAaZfoheHkFozJacHpIEtyy5I8lZvdm7cUCTvRYxN3h?=
 =?us-ascii?Q?4Km8nUFIJbDidyMUe1ZX+8kzUlrtd35mcn0n9We1Fj/Uk+TpPtZY4OuT1FKE?=
 =?us-ascii?Q?JqscMiBYa+un6a4+Tg8sCaB0W0u42vA/U3sXBp+3mmi+I5vJfNHwTLq7Str/?=
 =?us-ascii?Q?4ybkL4Fv5/5ZDYfCK0vhbocO88jh7HR9EK265JP29JESWAfRKiDDLykQ4U5r?=
 =?us-ascii?Q?Vg23g2tUUpYxhyzkmnkUTsXIfscM/DA7ch2HJ0+eHqi0JR97wTXf1SSEF3dg?=
 =?us-ascii?Q?YmWGqNDZ6JZpaD/aUFFvEJDfJEh3C6ZBG1cxdzxUfBW81Bt9tJun9w0JsO1e?=
 =?us-ascii?Q?R/FBlDdImr+rtKrYGXxGtjjA/t0zYwbgPCSkU4zT+KZ2CU8BMasvM0PEgEBA?=
 =?us-ascii?Q?I2bS0idAxm0/W3AsSQwZSSXp7DgLH1TBXPVMAfxH6SaL0UgHhHGxz6QxnzXO?=
 =?us-ascii?Q?K7tT5XZr3lzjZwoS+D25FqeHEmfxkLl+/R0ypibW/pO4+MQIvUZIvZsyVRJF?=
 =?us-ascii?Q?SojUHTBcQBRrlKYXUObIJD1S+kNTsArU3yaxQp+VgyVzlCfocerQUOiSfGJE?=
 =?us-ascii?Q?xXdyJ8h8zUE6ENI981bJLAK6ARIcZxh9Z2oGMYft8k1GU4jgTH0ZMXGaEcpJ?=
 =?us-ascii?Q?wWFsa8nvCzdt18TiAnJqspYnCe9zWvEXfK31c6YJ72/zNLNtUCndPIBiaqBs?=
 =?us-ascii?Q?kFTYa+9+/MPQ5burgTR5iNFl4+I7qHtD6ow+VhXZ+hsGkAUoJGydKBQZ8l+U?=
 =?us-ascii?Q?9O2oLxsX34Lm7tuPx4h09Q1uFbspXgZqeRtgyCtih+PMgIFYImS8EgDB29HD?=
 =?us-ascii?Q?nuX+EadXXkcLofb76jlXcpABeYDr1/LCU85iGjff0c1EWP6Hlj5xLeRjyPpC?=
 =?us-ascii?Q?ruk2hg/Gvit9uOkw2xjnOH42O8cbAQaC4fmIwJ00pdXfYBlaHvfRvaszRrOn?=
 =?us-ascii?Q?KTOlsJd+jpAdeEG1TQ1Co7KmY1jCUXp1eFxmQ/p1kbkp8XuQUaW01Xg0NaHq?=
 =?us-ascii?Q?lOODBEsr5GHohKG4x92wgNp+WIDycHj7Mpz1VoDysB/l+YKP2lQsAMfE8wm3?=
 =?us-ascii?Q?lXJR+T2uixlE8+k65LTSxvtqvBQMvgpp6lqN8CFe4RU7/o0SDZbymVlv9ibv?=
 =?us-ascii?Q?YRlU6QPHCXtLhfwGuVAFs1J1f569r4Zt7E6yZEgeZI3snelTpEIpQz2g3U8P?=
 =?us-ascii?Q?6decX6r+UoVmd487OB9chhV8HEFvXLYl472vT3Mcsn7SOdXDNVMST9rH0KuE?=
 =?us-ascii?Q?sluC9VmAUoJSLj3g+wgsTLe3hxHfppxPJ/QoslfMkzji3zwObYtEEaBUXGgR?=
 =?us-ascii?Q?UbYxe2I0TTTQb2AlVwmGH9KEzfMRVt3GcJb6DjlPhvdryYiuGtn1nXkcO7iV?=
 =?us-ascii?Q?t5W86c9rjJlbg8WqGkyhkozrt3AUTPg2rRnrA4dXq0859Riw1k0vPbRio6NB?=
 =?us-ascii?Q?hHJYB7pezg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e9dd1f-5c44-4c3c-ed5f-08da1971e336
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 15:10:16.1622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfDdw84W8c8wXrQqNUZF8Gg/TzFeBLYjjAvnR9W+GtsjXf7AlT9wSgxX9DVtCtlU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3788
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
 drivers/vfio/pci/vfio_pci_core.c | 109 ++++++++++++++++---------------
 include/linux/vfio_pci_core.h    |   2 +
 2 files changed, 60 insertions(+), 51 deletions(-)

This is probably for the rc cycle since it only became a problem when the
migration drivers were merged.

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b7bb16f92ac628..156efe33427e13 100644
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
 
@@ -1935,6 +1927,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	int ret = 0;
 
@@ -1942,14 +1935,28 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	if (!device)
 		return -ENODEV;
 
-	if (nr_virtfn == 0)
-		pci_disable_sriov(pdev);
-	else
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	if (nr_virtfn) {
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
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

base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
2.35.1

