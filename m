Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6838251AD9D
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376705AbiEDTSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344852AbiEDTSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:31 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907F6488AD
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNrpD5A/UBlTT5EeS/GfusVYs9g/+nIMwv+PpreDxypBfrsmvIhP8DI2AJueLJk5oXx1PstX7hP06Mn6QlqXTj8aW3jZMEiXh3mPr/MCGvaO2fcpliweeyrIwD3zSGpi8fFboIp3VJnHD8JcWs1Ul01g+G72L2yevl8xp8L6K85/dYBz0KcUTns8SyUonuIPeS3fjaE7CkORghfbE1PC4yH5Bv30/i+zKR6SdbB4/E+p41OGmmXskvAR8rfipK8LXE5C8ee7b2ZXXGvIH8bvsyF0mYE87CAas10okQLCv/ZKciJVl9disUaO/toevOCrcpUFfMR+06pEiAFQV1sDPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nf58McU3l6tdGkf8Pqp+/ftF1D/wWaRqI4keQ4eJDtQ=;
 b=Iw5V8r4Zr7wTmAj0fIbqoGIFEQtcuQQtJmM3F9tb+ePw6/sEcKnj/fuBtYgfPA8ftPKvpM8AsiKafj0Pln8O5oKZlM3VEoCwNy/c0OLN3sQPvTR/DjVqY+bUMIx9h4pKRonurY6clejRSsoFghygNKvuW0cd2WCAFIvzoxpflMmaAb21OshUywQE3DQWZBcpUWoVx8l8mUzHCJvJstLyeT4DnXnqBtpH+QEW3bsdnH5pEOA1bxEMUmA86ABBue7ssvYD072RlGQNLYgx59BJmexNDf96nE4G/1adN3v/ik0pnyN0IIVEvqSHPT4sM2s0VP75/lEI4oOU9diA5pDSng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nf58McU3l6tdGkf8Pqp+/ftF1D/wWaRqI4keQ4eJDtQ=;
 b=GNW88VzQKRR3zs2+NnhZdVGgSCN0WBWCaufF0ZQj4vJ/ZXLYpjJrrURGIARZhQ+OAgPAe6KAaMP2Rm0l6Fy4X7IIOAoRyQkn1TgYnwCrw4vGOq7yFW/Ypl0mj38PCYbaaPfCy6onA+rBSW+FTeawgBe7J+5BK83aq9hQx1TPe4hOtNinlsAJkYLb3TWCBTihHEKBOJ/NRUyDByoV1KV2Ky7xsMNCmnQ+DothkmFJ9E2zok4+Gi6KTulY0gvduR+/W4NNB5mZQdexiLznWGfpERcZ4CJZRHAhHFA2V3qqiNGCTdIyb7ktBgmeFltkz6N2KaH7PxGO0NNNcDy/DbnLxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB2341.namprd12.prod.outlook.com (2603:10b6:4:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:51 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:51 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 2/8] kvm/vfio: Store the struct file in the kvm_vfio_group
Date:   Wed,  4 May 2022 16:14:40 -0300
Message-Id: <2-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0022.prod.exchangelabs.com (2603:10b6:208:71::35)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3fcb364-694d-4e6f-eb0f-08da2e025b4a
X-MS-TrafficTypeDiagnostic: DM5PR12MB2341:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB234108427C0A72B445958D41C2C39@DM5PR12MB2341.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qnne66YNi3JW4+5uX7lsiUCqhUt8Caa+KQGQTkHK1kQGJUMhF20XzyWRd5vk/lVp2hkG583mh4WLxlfTUsrBauD525Zp0qYG/M/uWMAr1dEKgA0o9BMKrrDtm5GmBYocXNducZnnEwqRXBTPSps/7sijd3ogu/tcLw10E1z8wCCQQOF2tji6MdmqoR++Y6S3MmX2w5+K/VXsoD0ED1Anw5HCIhuNP3LM0h4bhpwpOYfMKM6V5pnrXB3T4luju7+myGGDVkoHmNjcysOE08kWHQLsfR2dR7vmcwRyTxWA85737hsH6H80/ryqbV0BUcs+W0n/YsIP7HVrAmMVLw5fZf2vDpfY0XP8v/Kh50g+XDmZ9XzxOKrfPATLmYbH8xudRbvJt7rb2xHITWbkELbg5D4TqKfNMR7f4B5KOuVsgNSHUZNQf5nvi4Txm86MBP3lczsU7nvB5ODd5G8GgqYylfudpflTyCA1AKIznorAviW7+4SZe7VGcqfXxbAnrbddHtKsCb4ma5uY4o0lG0csHEuXUzWcdn2URnIcpD5cpUWGBzCp8fw9SG4UPbQwvL9E5PMctJrx3X9+ZgikJFhE5l7cs4GvhbqoHYZBP7hrYYnG2rprgBGybmC6p0lCItdpbbQih6TvvSJcJ0Emq7z6qC+rC64AlKuEhC4K7mznF7L53RgJOgNnKRXgwaZa6Hzi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(186003)(2616005)(66946007)(8676002)(6666004)(66476007)(6506007)(38100700002)(6512007)(4326008)(26005)(66556008)(6486002)(54906003)(316002)(83380400001)(110136005)(2906002)(86362001)(5660300002)(36756003)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JkzTNXtXKC/USF74TVi4nwTfTmYAe7x6DQGfTanwOQUptcvM/BaI6T2YGy5D?=
 =?us-ascii?Q?NwDVOgMYDTPZO39y3hTzi3W4gzkHY5uPC+lDDEe2Gke49ogRTCl+RFbEUi0m?=
 =?us-ascii?Q?5LM2pYWy9rxv0SPM1FWyAkwUVqYuwKDMxluhnn7h6SOxUPEybBtm6o95h8Ff?=
 =?us-ascii?Q?BG9PvIPpixUqskq1SUSv+s3AwIUQQfqke9VXyPdGvpLmLPI/0f1l2r92r2aJ?=
 =?us-ascii?Q?clFYEXjavQV6+wva+1MQLyagadWfS7IUEXFP0vwQJtTnNSPBkh+EOD2PDqvI?=
 =?us-ascii?Q?MWjT/jtzYmbIVMtPm1+NFtVGmqme7UIJcfqk8ICvuFXrYty46QyQt2JG+Pfc?=
 =?us-ascii?Q?Sbf4XoGlJBYDBSDFKWz7JcwK04O4XB2Uk3RaidRj4pQ+5az5E04wVRe30693?=
 =?us-ascii?Q?PuvPVmlWMUxGiEYEur0QfvC/vtTt+zP4RM5QKwS4MjEQ3hUD7DNAvKW0ae+o?=
 =?us-ascii?Q?4xKkkaYH232NHyAwmvAIJlfVxteaOcerIo4yHSx8PN+G4jRQ1wTA9q0sqMeF?=
 =?us-ascii?Q?t6w0u57cWiNlZSEOnCSfwJDmpU8sn8gkcyMc5+zR1Nz/lvCz49olhe6pyqo4?=
 =?us-ascii?Q?LNrtbGdfg/HFp/IobGqdG5/t3gtos27gP8MOkElpqxeM91aIvZzP2sAGxeqN?=
 =?us-ascii?Q?O39s9j4kb6uC1+rS7vR1uGpgGgbhgKhcT/wUrWIeUBod4tV31/35P0SIsqaI?=
 =?us-ascii?Q?Bf/C2A37Tw21mb4T1/X6KJTEBE+SeC5J/cAadYiSTUIHlG7K6e9f/c4uH5KQ?=
 =?us-ascii?Q?4JU7NS74agtXuH2G2tyVQBZnDPC4K540m1kUJjhRzgi+yf9QAkt20dh5L0io?=
 =?us-ascii?Q?BUvEcOfVpJI5s2WEPFX1Ed0JLZTKCdvNHphWmPnFQAFF3+q8HilhCKby+CSY?=
 =?us-ascii?Q?t5eFpp4mc7Ch9GWOA6HwsQIr1O5ypOiv12tenyQRYH8HKBDxCLrTpFtDKAQL?=
 =?us-ascii?Q?WSzU1XuAjHkvGsfUCdTjs/dHS1WP2yFz/2DEMUrkXPALZ4Q60t4TWqbSIqh9?=
 =?us-ascii?Q?laqcI9IgDz+N/8ME77luzvYdzh+D7o7kKHJuz0sWZxwj7DHlXRgk5PpRzNyA?=
 =?us-ascii?Q?n0T9zU1uVgqBj5lpV1zt44bciPELYjUiqRNsP61yucr2+/FWU8FO6FG6xzn3?=
 =?us-ascii?Q?OeXMJUhAWJCaMzCIVTPt9EKvSCRQVtO1mqKiCLJTYPdEA0qwcJuDpJ+jubRp?=
 =?us-ascii?Q?Cae98iadNO8nfFSFBaY/IICgE2Jfo098efqy3DfVJC7+UbNoIudn5G2kN2tu?=
 =?us-ascii?Q?EMJHP2OZHpNG8VjRaob4U9GcS/4+4SVK9QG8Ps+CL17ndGpbbeIpY3RCAwkM?=
 =?us-ascii?Q?AVAtAmgImVyV4tWu0H0JuTw7evQteYlxs1MF1NMDuGqKUfuZdKGVIAtC6jXU?=
 =?us-ascii?Q?TJPb+VdjUiEKUZ7ngKnJnF3Di1dSeG7JByEgcX3ZJuGqZ1JJm+hn++GvIxP5?=
 =?us-ascii?Q?AfuiQXXt65TmInQfcAo8iBYjAH7hrUODm3cVH08QsVNfnOUI4O2+M3X6tHpi?=
 =?us-ascii?Q?r9Yf2N7xu6GcCz4e72KGNUDpS+1n64J3aMrhaU2aM34jn+Ee3/WIlBcKAzOj?=
 =?us-ascii?Q?BoDk7+wozyNzKPOfDj4r8lTJfUIW74Ao1wAuO+uTukjcecDGf7bxEUFWw4Lf?=
 =?us-ascii?Q?UYXg+ARhDBEIehtVr0QmenxeRoXzhTZ4fi9pg2vaql9biv7rw5iq46kW9KVi?=
 =?us-ascii?Q?r53n9gjL+jv2ZfmmD0SEnsSgjCBbolrvXAioqauP9A6bofwn4fExlPsf8SOJ?=
 =?us-ascii?Q?cCD1vEk2Yg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3fcb364-694d-4e6f-eb0f-08da2e025b4a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:48.3888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOB9sRBBUmkpbsQn8ad4zOD6QABZZTXY+ccBNl44Rfm9s6jken2LjgFeqLf8jlxC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2341
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following patches will change the APIs to use the struct file as the handle
instead of the vfio_group, so hang on to a reference to it with the same
duration of as the vfio_group.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 59 ++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 512b3ca00f3f3b..3bd2615154d075 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -23,6 +23,7 @@
 
 struct kvm_vfio_group {
 	struct list_head node;
+	struct file *file;
 	struct vfio_group *vfio_group;
 };
 
@@ -186,23 +187,17 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	struct kvm_vfio *kv = dev->private;
 	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
-	struct fd f;
+	struct file *filp;
 	int ret;
 
-	f = fdget(fd);
-	if (!f.file)
+	filp = fget(fd);
+	if (!filp)
 		return -EBADF;
 
-	vfio_group = kvm_vfio_group_get_external_user(f.file);
-	fdput(f);
-
-	if (IS_ERR(vfio_group))
-		return PTR_ERR(vfio_group);
-
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->vfio_group == vfio_group) {
+		if (kvg->file == filp) {
 			ret = -EEXIST;
 			goto err_unlock;
 		}
@@ -214,6 +209,13 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		goto err_unlock;
 	}
 
+	vfio_group = kvm_vfio_group_get_external_user(filp);
+	if (IS_ERR(vfio_group)) {
+		ret = PTR_ERR(vfio_group);
+		goto err_free;
+	}
+
+	kvg->file = filp;
 	list_add_tail(&kvg->node, &kv->group_list);
 	kvg->vfio_group = vfio_group;
 
@@ -225,9 +227,11 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
+err_free:
+	kfree(kvg);
 err_unlock:
 	mutex_unlock(&kv->lock);
-	kvm_vfio_group_put_external_user(vfio_group);
+	fput(filp);
 	return ret;
 }
 
@@ -258,6 +262,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 #endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		fput(kvg->file);
 		kfree(kvg);
 		ret = 0;
 		break;
@@ -278,10 +283,8 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 {
 	struct kvm_vfio_spapr_tce param;
 	struct kvm_vfio *kv = dev->private;
-	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
 	struct fd f;
-	struct iommu_group *grp;
 	int ret;
 
 	if (copy_from_user(&param, arg, sizeof(struct kvm_vfio_spapr_tce)))
@@ -291,36 +294,31 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	if (!f.file)
 		return -EBADF;
 
-	vfio_group = kvm_vfio_group_get_external_user(f.file);
-	fdput(f);
-
-	if (IS_ERR(vfio_group))
-		return PTR_ERR(vfio_group);
-
-	grp = kvm_vfio_group_get_iommu_group(vfio_group);
-	if (WARN_ON_ONCE(!grp)) {
-		ret = -EIO;
-		goto err_put_external;
-	}
-
 	ret = -ENOENT;
 
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->vfio_group != vfio_group)
+		struct iommu_group *grp;
+
+		if (kvg->file != f.file)
 			continue;
 
+		grp = kvm_vfio_group_get_iommu_group(kvg->vfio_group);
+		if (WARN_ON_ONCE(!grp)) {
+			ret = -EIO;
+			goto err_fdput;
+		}
+
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
 						       grp);
+		iommu_group_put(grp);
 		break;
 	}
 
 	mutex_unlock(&kv->lock);
-
-	iommu_group_put(grp);
-err_put_external:
-	kvm_vfio_group_put_external_user(vfio_group);
+err_fdput:
+	fdput(f);
 	return ret;
 }
 #endif
@@ -394,6 +392,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 #endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		fput(kvg->file);
 		list_del(&kvg->node);
 		kfree(kvg);
 		kvm_arch_end_assignment(dev->kvm);
-- 
2.36.0

