Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5461509067
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381790AbiDTT0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381779AbiDTT0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742F745AE8
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOrMqnCUYWSEYyZsd2NLLQg8GqZsqOATrJehxeJK8MLdxHILz9gzY6+nSdMr8zomoqY19q/KDr/6PSkf/d/D8A1Et/Sj/L8fkZhjxHxsL9qZOBCUIQTHQ8xTJA5ljX8UKfSRj/N3s8xDLZOKukeeyCGrX7o/GfX1zhaiw53wPhiMUYLrToKlGxWZk3/GUsvh9gWhLX1/fW21axeTnzL+QzBp6RVn80/t2B+WaJd6Ab6Pn+4OEvfAMPQXJS3YWe+nqBo/cIcGMBWA0p4il8BocsTyinHzix4rucBKz5xR+fwDl/kehyBtHLt+/kKr+uH/qARyQCemGKY7zs5tD3cPyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peG8yk59Lq+LS+BJ9+PXG8JsMnm5EijEobHJD/bmmP0=;
 b=Zj7C4SrVWm8NxHhmrshWoXU3KOXDflWK2rS3XPuaa7yJpVFxyY6jVMQdGZSK4vthBK6ITvqu9ZkDtrSnaEutrTB1fazQpe6DVUxEcXg0nQpD4iayz278e/wXFGSKQ7T/BTcWa/UjWGsBqpRYxCpKX2XAQrpGr0LW6MiW5cmb/A4wDdVFgX5Yu/sMDp1zKZZPpOijnHJrmDq9inovnpNVwmpLerRZ6xyh4bklYqKhKutUHAp8drHV/ZOPa6SK0HMU8YB4md8ZHddTXCzFpCaNSD+luXmTuGsqp88uVOEVN2/SiJliyq4w3yDLAD3UQPsyxKHYCoejPslenmUKyMFQDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peG8yk59Lq+LS+BJ9+PXG8JsMnm5EijEobHJD/bmmP0=;
 b=sJhU6Q7CrYRlbA0/dQ5ZnZFix/wrRTLpbv+K1KbHQwwRVqJUTSnEtir4o3viiZok35Zbai/sIFB42c/mFNzCCSJlp7iI3CJ/dEP/by/NARxjeO0jNq1ts0TF/Q/qJUmkVGHZyXjW58Ln55Rv8QZK72tQOhC3Mm/oQQrgB7ORfxXxkB6FkzrKWrUrQEg3IP2EL2OlL/mt0SGDQ/KH5OD5TrnQCXyK79INROVVnz+jWo9k+Zj94v2OwY4r62zMgHnd19MmGxusMVmupMalJvWCaOogIrjNwCrVYrj6zTlL+ese3cVaDMSAbITYUC++zR3tgj5wC4QCn2bQqEEtVqKRtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 20 Apr
 2022 19:23:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 19:23:22 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 8/8] vfio/pci: Use the struct file as the handle not the vfio_group
Date:   Wed, 20 Apr 2022 16:23:17 -0300
Message-Id: <8-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:208:236::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 439581c0-8970-4e0b-51b3-08da230339fd
X-MS-TrafficTypeDiagnostic: BY5PR12MB4131:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB413193F523194798DC8B2802C2F59@BY5PR12MB4131.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOVdiXhxzk56p5/JBa5LBetfLAbywf0oEZMzCxWOhTMZm+Q3UCuyH9eaTOBsAuOtdqpB3CKn5LF30Fj8FRQFXCp42wjYwBSQPR4Pdygxe4lfSs2eV+CG7OuhG2s4yp+1l8EjJp7N3DTkiAKy7wjzuoGo2S6dftv69ncNyb2BDnIGOTR4nLdyS8/bDdWyAz1Zfn3qPo9dtridhlU6x9R5kTjkPYVccLAbTpcAX89PSXtGBnzgOICHez+tcE3vAFMiMak9nborD3fB0cFz3d3ehBYOeDZxwAeHkvO2KfKd/kCU3dZOZRXeat5fPOn63a/aN4COOpGgD3XNWGKeusQP+/TxEMuKWODI4hZB0GUdKVMz46bY3z0PLnUpc1pMMMG5wbItijnl2vQHDsPqjFBVEGCAG262O50wGTVSc4e2c1fNhyu83XDL1rVkz2qkAEfvi3toyOaQj8jwQxvE3/6ijlnqVpiCoHu4MTzQd07HUvWbwWMBBMv5mF/6VSYQzQFbv3JRA2AfvkGXbWlEn+WKZRvFE8VyelKMoGxkHjKeUyL0SOicCYJCvvHG5gJtR+QxXNh5hSXW+pLHVf9yBNr2EwkHezbsyv2Vw1BSuFn3genuarxVLuyyZLFT5ufXTE5A8LRQ7YWb+DKflQQt3NAxiz2uIh+SD/Dj6mcKJCG3oydFgcF9MtPk7LmnBVxtiWj2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(38100700002)(6512007)(36756003)(6506007)(66946007)(2616005)(186003)(6666004)(66476007)(8676002)(66556008)(8936002)(316002)(4326008)(5660300002)(86362001)(83380400001)(110136005)(54906003)(508600001)(6486002)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AWPeHTDLI1/IdCQk4z5ETjNaqR3xm600NtoUQlxvIsX0NYuvHb5FxDQ9vt2N?=
 =?us-ascii?Q?qy15h3MvBqWOYsXdQMoLxySVWZH1DJ6xw74Wdt11zQZIuqNkZb8jO9hJ9Np4?=
 =?us-ascii?Q?xN+EGeZwMCf/NC2OFC0aDvFbzQdYfNyLyKlEaSDzZRnSQl2DGgIJ8Z1S3Pd+?=
 =?us-ascii?Q?ePOhHWfGy+Xf5+hNSkSsl4Aq7U7eY7JM7qJWwVgSr0ReiLAm85JiUqohCd/J?=
 =?us-ascii?Q?I2fuyHTi2e0s7+6HeBXa+1TuMlkLYRNL3c0SjSUHaLBjOzew5GYQDzBp3Vn/?=
 =?us-ascii?Q?WnyWe1o9XJzhvOFKq0XI02Gmf1dsxBGm7kwNSBQ7BaRLO7X/X03QP2KOspTD?=
 =?us-ascii?Q?7Tb02v+ud7VPyHErAcnm5HMGnx7DTHaJ5JoiEd0SRBgYOxpfeWEFrXih2Qvo?=
 =?us-ascii?Q?7H0xyF5+uyhQTHaqMt7yLmNZ9lKRfnkbL3Ojz3KD15lCqpX3ale4g+Zw8Lve?=
 =?us-ascii?Q?Ys8AFHbKL8foCmj3QTvZkhQtDW9SOc2dZ1FaqL7cDe1lGd5JjHGITv36HKHa?=
 =?us-ascii?Q?mZ7bqAKZQWsBHwd97ebVR+cSN0SoaTTbBbZ5MR09bi5ouvV552oyhjGyk7Op?=
 =?us-ascii?Q?hcn7vfOFkRTn8HQ7oqQNBFL9+U9OGBMLFEQc7RU25acXHnxrH1dZZZL2E8t9?=
 =?us-ascii?Q?ootevnRuYyjCsCNsviFSTQhlpI2WCg+WVPKfHbrQplNR9oPYdd174TDNfKZg?=
 =?us-ascii?Q?h/HEnVw4l6otYL/4qmGhXkCNqA5B3o/gPAIkkEPkUleDrWiYRYEwx7l1Hdr1?=
 =?us-ascii?Q?HxG60nyD0vYIBM5dKNR+jyoCXZtxURn57ijVrmemS4sjk7ZFGIwpRP5+FZAU?=
 =?us-ascii?Q?jTk9aBoEcgYouG6YEQZ9ipLDpCzej7zj9HIISNc2A5U/5fLY6UV5Zft15vF8?=
 =?us-ascii?Q?vC62v3+mN2BQdDwfMMJx8bYLPT1FzBV0MQUk8SAgbaAvbQRMsZ96u3YLqhwJ?=
 =?us-ascii?Q?XVfC3Wb2/1uYTMwW1rig4Jygfa5pB+GDI5IG9Q2PDKSvukbw2r96gqqFjzs+?=
 =?us-ascii?Q?2nb8/tCrK/LLG2ZTBwtj4MORypdEGtPj28Wmx7hWgdinVsHcCAu752bSRch2?=
 =?us-ascii?Q?zorEf0e9oDxWaPnrPX3H5qHysTp7IpNvcaGEnl00N3sjRlgvv3OJKqKosZF2?=
 =?us-ascii?Q?ziJbI+HV0CJlX4ZQw4iU7e1yVdQljRDon5EUjlpSqBLEYxf/nyNnE97pPUtO?=
 =?us-ascii?Q?wU80k1TUkbb4EJI6eeG7AvfRFr99IzswtobHXpNfTdFukDBW2KLHalG2AC/p?=
 =?us-ascii?Q?lEPt6TqYL+B5RZJjuNYZnQsndc+i/T25Th7VwO1T5f6kcrq2rkSyJnRMqD7W?=
 =?us-ascii?Q?+Zl2XIWxdl+XySIeNSiRvCDbsYhm6qjWwMx69i6YVWhX+re5WQY59gJwrrDV?=
 =?us-ascii?Q?RtgMbve1x5RPIcs/QvKebiZE31ZhWmJauMYxit/d2RDFtMtR08+rbtlFCoyk?=
 =?us-ascii?Q?beVEQmfGUhDeG+jv9hoUbtlMeaZbHhq4NPiPuQNcAbyO1NFyGCVFXSswHPy3?=
 =?us-ascii?Q?CowfivjmKbgwmJOiwyy28wCDWZX+AA0tNM+4zJg87CyO0/QNpB4CmV+G6c0K?=
 =?us-ascii?Q?17+StO7Q7hwyhA772AqxrGcfOT1MGrt2EbYwTFUB5frH/Y/K5YiqkoqXmSB2?=
 =?us-ascii?Q?/YYz/QaEX1kEw6Z8YfjMFeCo6cYpxqZ6eaXTA+9I4mQcMuka3AVqMkq2CV9c?=
 =?us-ascii?Q?b3FO+q4JATKgJ/FxCz3o3cRuNRztt6bIRh2s3jaaFNpSTzl7ky7SqjJGPg4o?=
 =?us-ascii?Q?hWe++fpK1g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439581c0-8970-4e0b-51b3-08da230339fd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:19.2674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96vzdnlgJdQ2EkPI5+GHw4uFMo/9B/FciVD7nEuBKKc9PVsMx3JQiNXDFZBnYtPj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4131
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO PCI does a security check as part of hot reset to prove that the user
has permission to manipulate all the devices that will be impacted by the
reset.

Use a new API vfio_file_has_dev() to perform this security check against
the struct file directly and remove the vfio_group from VFIO PCI.

Since VFIO PCI was the last user of vfio_group_get_external_user() remove
it as well.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 42 ++++++++++-----------
 drivers/vfio/vfio.c              | 63 +++++++++-----------------------
 include/linux/vfio.h             |  2 +-
 3 files changed, 40 insertions(+), 67 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b7bb16f92ac628..465c42f53fd2fc 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -577,7 +577,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 
 struct vfio_pci_group_info {
 	int count;
-	struct vfio_group **groups;
+	struct file **files;
 };
 
 static bool vfio_pci_dev_below_slot(struct pci_dev *pdev, struct pci_slot *slot)
@@ -1039,10 +1039,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 	} else if (cmd == VFIO_DEVICE_PCI_HOT_RESET) {
 		struct vfio_pci_hot_reset hdr;
 		int32_t *group_fds;
-		struct vfio_group **groups;
+		struct file **files;
 		struct vfio_pci_group_info info;
 		bool slot = false;
-		int group_idx, count = 0, ret = 0;
+		int file_idx, count = 0, ret = 0;
 
 		minsz = offsetofend(struct vfio_pci_hot_reset, count);
 
@@ -1075,17 +1075,17 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			return -EINVAL;
 
 		group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
-		groups = kcalloc(hdr.count, sizeof(*groups), GFP_KERNEL);
-		if (!group_fds || !groups) {
+		files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
+		if (!group_fds || !files) {
 			kfree(group_fds);
-			kfree(groups);
+			kfree(files);
 			return -ENOMEM;
 		}
 
 		if (copy_from_user(group_fds, (void __user *)(arg + minsz),
 				   hdr.count * sizeof(*group_fds))) {
 			kfree(group_fds);
-			kfree(groups);
+			kfree(files);
 			return -EFAULT;
 		}
 
@@ -1094,22 +1094,22 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		 * user interface and store the group and iommu ID.  This
 		 * ensures the group is held across the reset.
 		 */
-		for (group_idx = 0; group_idx < hdr.count; group_idx++) {
-			struct vfio_group *group;
-			struct fd f = fdget(group_fds[group_idx]);
-			if (!f.file) {
+		for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+			struct file *file = fget(group_fds[file_idx]);
+
+			if (!file) {
 				ret = -EBADF;
 				break;
 			}
 
-			group = vfio_group_get_external_user(f.file);
-			fdput(f);
-			if (IS_ERR(group)) {
-				ret = PTR_ERR(group);
+			/* Ensure the FD is a vfio group FD.*/
+			if (!vfio_file_iommu_group(file)) {
+				fput(file);
+				ret = -EINVAL;
 				break;
 			}
 
-			groups[group_idx] = group;
+			files[file_idx] = file;
 		}
 
 		kfree(group_fds);
@@ -1119,15 +1119,15 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			goto hot_reset_release;
 
 		info.count = hdr.count;
-		info.groups = groups;
+		info.files = files;
 
 		ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
 
 hot_reset_release:
-		for (group_idx--; group_idx >= 0; group_idx--)
-			vfio_group_put_external_user(groups[group_idx]);
+		for (file_idx--; file_idx >= 0; file_idx--)
+			fput(files[file_idx]);
 
-		kfree(groups);
+		kfree(files);
 		return ret;
 	} else if (cmd == VFIO_DEVICE_IOEVENTFD) {
 		struct vfio_device_ioeventfd ioeventfd;
@@ -1964,7 +1964,7 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 	unsigned int i;
 
 	for (i = 0; i < groups->count; i++)
-		if (groups->groups[i] == vdev->vdev.group)
+		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
 			return true;
 	return false;
 }
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 7d0fad02936f69..ff5f6e0f285faa 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1899,51 +1899,6 @@ static const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
-/*
- * External user API, exported by symbols to be linked dynamically.
- *
- * The protocol includes:
- *  1. do normal VFIO init operation:
- *	- opening a new container;
- *	- attaching group(s) to it;
- *	- setting an IOMMU driver for a container.
- * When IOMMU is set for a container, all groups in it are
- * considered ready to use by an external user.
- *
- * 2. User space passes a group fd to an external user.
- * The external user calls vfio_group_get_external_user()
- * to verify that:
- *	- the group is initialized;
- *	- IOMMU is set for it.
- * If both checks passed, vfio_group_get_external_user()
- * increments the container user counter to prevent
- * the VFIO group from disposal before KVM exits.
- *
- * 3. When the external KVM finishes, it calls
- * vfio_group_put_external_user() to release the VFIO group.
- * This call decrements the container user counter.
- */
-struct vfio_group *vfio_group_get_external_user(struct file *filep)
-{
-	struct vfio_group *group = filep->private_data;
-	int ret;
-
-	if (filep->f_op != &vfio_group_fops)
-		return ERR_PTR(-EINVAL);
-
-	ret = vfio_group_add_container_user(group);
-	if (ret)
-		return ERR_PTR(ret);
-
-	/*
-	 * Since the caller holds the fget on the file group->users must be >= 1
-	 */
-	vfio_group_get(group);
-
-	return group;
-}
-EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
-
 /*
  * External user API, exported by symbols to be linked dynamically.
  * The external user passes in a device pointer
@@ -2056,6 +2011,24 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
+/**
+ * vfio_file_has_dev - True if the VFIO file is a handle for device
+ * @file: VFIO file to check
+ * @device: Device that must be part of the file
+ *
+ * Returns true if given file has permission to manipulate the given device.
+ */
+bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
+{
+	struct vfio_group *group = file->private_data;
+
+	if (file->f_op != &vfio_group_fops)
+		return false;
+
+	return group == device->group;
+}
+EXPORT_SYMBOL_GPL(vfio_file_has_dev);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index cbd9103b5c1223..e8be8ec40f2b50 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -140,13 +140,13 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 /*
  * External user API
  */
-extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
 extern struct iommu_group *vfio_file_iommu_group(struct file *file);
 extern bool vfio_file_enforced_coherent(struct file *file);
 extern void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
+extern bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.36.0

