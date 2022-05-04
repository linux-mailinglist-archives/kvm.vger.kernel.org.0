Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019ED51AD9B
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376625AbiEDTSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343672AbiEDTSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E270488B1
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Giuqv9xmeH35WAjwmjrNMOGIqTxzpLRrsHeAxbFPH2WP8Xaxz2IBdjypCM7BoE8i5eC6XD580hB55JimWgBXYE7NfDFHmJ0FC+vC6MjbIAxZ6A6uSLTT6x27ONPMs+VKFcj9nShIeXRntlk9y7zMq7N7mGXopohImHE4y3gtEMse2kKcC/T9cqOuwIf1ySzIwnS7EbOIShXnNzk8xK6edbDbP5C6l3SvO6avR3vwO4OFDGIxJZD/P58swdCEtbeTFjhsyljqS8VFRON/3/hsLfPZ65Q+7ATrmD7mP8saILJcj2+1FOmkmxRkj3Lk5z0iQFMLAPMJnDaLo9UJCzN6nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMneuFc5Pth/DWVc9PhPAe2/sRatsCSljJOgO5BpU/I=;
 b=haX7+4sYf6ETtNACANxT6l9oFGEjdZXWEPt1ddgsYq8/SBEQqewEhQq4MLQ2iZj2ZuyPnxNwIbXdN3jayEl4bzIe72nMMJoGDQn4oWhwgYpeVtpMCRhIdNrvQMwcCYFb1i6zFzWzXwIp0UcJaLgP2Vlob7DJfw7FhS/ONIs7BG6nHaQrZhBGpY+fxYllPXjoCJWEVv4nXM+rLmTNHYJKcAC7pGDj6x9evGq/8Ja/bt+6D/r4sX8eSV8PR4KVw43pAk8tn6Q9eGFozboY2LgRMTcebskhVwbStIv1ZaBOoXXMUkbT6n/rSwIJlZUwAXwXRIYJnBhFbIE50IclVVwHZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMneuFc5Pth/DWVc9PhPAe2/sRatsCSljJOgO5BpU/I=;
 b=Qum5hvyJUfaomkgJawgCxaGRALOQyQEKegY2prgphc224h3l/yZ4/VIsskna66nxQuPu/iNaCIpjTFGoXENnhJkIVZoBl0PHT025WhPBrIkxgNxElK+7WqwrT6DOK/pGJ9fyNvnm7Lc+d4n6lObMBxRkPvFUk1HDt8X0y7XpiTYCrzo82nkUIgSPzNjWxDkumY8ijsMh/PM0TA2hZx8I+l8P0b/bHxWX4TM+vvM/0UUIQ96M7nEDBCrzlzbvHmMooGA7tEvELEeEA6jPydVDe5OwLI+CFSRBp1TvvOw6ox0FwyK7CF9REYW4ZFlkLDXw8Dz8z3vGW53h02lyZNuH5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1419.namprd12.prod.outlook.com (2603:10b6:3:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:48 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 6/8] vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()
Date:   Wed,  4 May 2022 16:14:44 -0300
Message-Id: <6-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:207:3c::46) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f2b0f3b-faa5-4d52-ccff-08da2e025ae6
X-MS-TrafficTypeDiagnostic: DM5PR12MB1419:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB14194CDD4D376A128E897FA2C2C39@DM5PR12MB1419.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zDXmruRfULiaG10Tcv4ZoszQNo1pYaS9jLNXBomuzlX0w8D6TGAKuZA1cy6gjFwUxlyTo/iD4au/nrCp0s0iS8dn2B2UQeTeymcuo3VUm1B6DpHUjLEjQs4yEC9OPDRmsZ6YrCPAuz1YyrqH4NwSL09mZOUZlyUBjxmJzGrXYUr8Bfuv9oTkvTPQrJFdHSny5irxz5+eMn2gKOzZYA48jbc/R2wsZfZLxTN7i71gK5SGcTdPKUUXu1VmqzgL3gpgtbiuPw8iR9kkGCXwYmt/MZ2hxeENK4EIvKdFU37LqBnodQSyFEc++aMWO66G6Wu9pWMGTTZIFAiEfQDYf5lCApUpae2IKkdVMcUOLybo9YQ1f+NliryUkd6kQGpWb7nFdT108DYBuRz0a9V+UO+dhOQL+Sgpc9cSMItkkHtScnJgCPCj0/HPpgh6rMpld60FYc1AVoS8pWYx9GlT0wiP6nqx+Y6LJbzFuUCg4f3tcagGS8u3+L7oWr55vBu8m9JQPPyENhwRrJS9C5mbm6//Gondw4YD+tJ+jTznbV8bUUM3ZcBCsK2WLzDQXXS5+zgfaJbDtVBTjDLabn8lYUzuE/fdFHwd8/qyYIUC2Lk7LMJriaQ3xgfaBfBLyLvwSMFdIPGsEnzKAhllI85XDqNBtEiMcUbGMV9jgAZCeqyy+YHb4r9X8q7CLob8A7ddikIFTZlQMVIMWpNKqYcwGvPapQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(110136005)(54906003)(5660300002)(6512007)(86362001)(508600001)(316002)(2906002)(2616005)(6486002)(83380400001)(36756003)(6666004)(186003)(26005)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y/r9kEZ9A5ZFK9py/nnWjcgCSy9O2JG92UivZ7l29Z3axtG/CJ0NQPrS3XEg?=
 =?us-ascii?Q?G86avvIb9U8zeYRMXDeRJH+0xYeOHUJbDWRwMO01dr0+QwnAM1fdLpZ3cw7x?=
 =?us-ascii?Q?e+zkuubClUrW7ELcCOt3E6MZnBSaYKc7KKx6gtFrZBIpmrj+iIlnILuhYbwg?=
 =?us-ascii?Q?oNkc006ovHaip3toeMzWrQZcfOgrZ6eMycc9pNfmMDZvH4L8r/qW+5bcbDhV?=
 =?us-ascii?Q?vsgf/582IJgOgZbQI+oaVeq2g7nedhzic69bYVp4tBW3Dwmunrt5FEHLIzyQ?=
 =?us-ascii?Q?D9C+slQRWlJU0lIckcVVmPowxcdKV6UekBXQteQnD/NaHVvBqHfXYW9lm797?=
 =?us-ascii?Q?IWCpfFcBts2qtINXYKgKk4bcpVUTD7HLdZ3DhBELgM0/de6lnH4q+Ojp5cdp?=
 =?us-ascii?Q?uU/QsZeL4x6Ox1QotsQn6/V2JRLr65XHotKMdpR75+R0z0UAJhDGsjYcDZJp?=
 =?us-ascii?Q?QEuqJ4aISci6ypi8ACLQFfHAUjE/NfSKD6QOe+uwXji0wXvWd80HF+KVGdI5?=
 =?us-ascii?Q?EWY0fjoxgu9OuXZMflsG+fMbJ7kFNdBUt+bzh/WT/5mc7Ykowui2Ob57zhAQ?=
 =?us-ascii?Q?IepSREXfneqWeaW5Kdr3XowyejMNuE18RYG1RQ6mIb+nX0UUs6YOzrPWtHS8?=
 =?us-ascii?Q?Wpps3IwcH8cL+MeFCv/0Hz0WQvXeevUGWMB8JfSuOS8LSCQqFbHSGaSvgBqW?=
 =?us-ascii?Q?EReIMaGFbDXQbvtuIRb7ThidQzAKy+nis5fTy0hrRRU2fDdZaIKlDkW7bo8o?=
 =?us-ascii?Q?fKkSm0RbZrMwX9VzdvcmySkMMm+8Qn1ClzAdkeuTEWyqkksFP1yZtQcoVz9T?=
 =?us-ascii?Q?uLJR3tJZD/2iqwViEWlz2NXSEG5oaJrLnQE/OjDw1g5ezd+XzXgCyjMWoJ8s?=
 =?us-ascii?Q?uVkzJrZnswfWE3HwpRrlIwQEWKOVHvNfYeOhBfQe41gTFuqeyozYx1mbkXA6?=
 =?us-ascii?Q?L9I5QGJoND3U2gvCNLdHqZtkS7IUyTHM0UItoGG0SSJ0I8V6QeMAodHb1YER?=
 =?us-ascii?Q?fBv4T0yRhDTPP4R7GbRGu6XN0+8xaEoiB+3CyrumHujW80Y1q/WS558vxlhg?=
 =?us-ascii?Q?o8zpzK1/hlSyEK9Y32tcsCjo0nkSmEhHsCjzHvMg/EPV1emOg5diKUx/QVTf?=
 =?us-ascii?Q?CyPhV4Fg2htEHe3Rhc4R9hmv5QPfwUfdR4bXidEgyyNW2JH/GtcsgQoTja9W?=
 =?us-ascii?Q?a+OCRh96WxuLfPcrXWkyXJ9qDXX71ShbIBZhqjW4d7wExQtQBbtq5HfrYb1U?=
 =?us-ascii?Q?VA6qTSPGXBjgnKp/K4M+F3QYIXCWqtJKwxPgsi/CtLtyMCYV9sjOB7gGjtTu?=
 =?us-ascii?Q?0CDYmHQgYxqVpzCO6fzGKpdMxlj4Xrh1HngSbNTvQr3cCkSzVI93zmdkfrp6?=
 =?us-ascii?Q?yhDGp1SHuwW6BiWPCErXrkm+TtQ7SSwqgamWBN4HWI8UJW9vg7CoH1T3/u6N?=
 =?us-ascii?Q?hUr6dw8gfIL2tBtaZRtc/v3yvztP3f9vk3xi3FehBO5RWg97ceTAIy6K1ZQl?=
 =?us-ascii?Q?1Nr1EN3bs/yUIfIRKchWpH/c1EmbFUG88oU4+fjV3eUoF6NKy0gIBSDMHg2a?=
 =?us-ascii?Q?RfS5K65b4CelCQoG7RP4G/1U/k27kQDwsU0UJMmEyGQuuEDbND8hlsXlXuzr?=
 =?us-ascii?Q?zRzvDku6t5pjUzjLadOjWUy/lanCeBrWaeZrCAmxRBDHsm99mh3asgAjIunz?=
 =?us-ascii?Q?KWAMP/qO/cjVi1h0HjkbK69rsk1us58IOWclCko4j+F3dcZ45TKoa02+kdm9?=
 =?us-ascii?Q?O4xgCyIHQQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2b0f3b-faa5-4d52-ccff-08da2e025ae6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:47.7328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9A0O4/ZaILb+tgI0VuG0Ph6x/pUc2x6wkKj92qy/sxgN2ig/AGeDvau4nX76xAu/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1419
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just change the argument from struct vfio_group to struct file *.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 29 +++++++++++++++++++++--------
 include/linux/vfio.h |  5 +++--
 virt/kvm/vfio.c      | 16 ++++++++--------
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index ee38b4d88d5d47..efb817c211fa89 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1751,6 +1751,27 @@ bool vfio_file_enforced_coherent(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
 
+/**
+ * vfio_file_set_kvm - Link a kvm with VFIO drivers
+ * @file: VFIO group file
+ * @kvm: KVM to link
+ *
+ * The kvm pointer will be forwarded to all the vfio_device's attached to the
+ * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
+ */
+void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
+{
+	struct vfio_group *group = file->private_data;
+
+	if (file->f_op != &vfio_group_fops)
+		return;
+
+	group->kvm = kvm;
+	blocking_notifier_call_chain(&group->notifier,
+				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
+}
+EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
+
 /*
  * Sub-module support
  */
@@ -2018,14 +2039,6 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 	return ret;
 }
 
-void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
-{
-	group->kvm = kvm;
-	blocking_notifier_call_chain(&group->notifier,
-				VFIO_GROUP_NOTIFY_SET_KVM, kvm);
-}
-EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
-
 static int vfio_register_group_notifier(struct vfio_group *group,
 					unsigned long *events,
 					struct notifier_block *nb)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 601f311f6c2e55..b32641e350157a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,8 @@
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
+struct kvm;
+
 /*
  * VFIO devices can be placed in a set, this allows all devices to share this
  * structure and the VFIO core will provide a lock that is held around
@@ -140,6 +142,7 @@ extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct iommu_group *vfio_file_iommu_group(struct file *file);
 extern bool vfio_file_enforced_coherent(struct file *file);
+extern void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
@@ -170,8 +173,6 @@ extern int vfio_unregister_notifier(struct vfio_device *dev,
 				    enum vfio_notify_type type,
 				    struct notifier_block *nb);
 
-struct kvm;
-extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 
 /*
  * Sub-module helpers
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index d44cb3efb0b94a..b4e1bc22b7c5c7 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -62,17 +62,17 @@ static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 	symbol_put(vfio_group_put_external_user);
 }
 
-static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
+static void kvm_vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
-	void (*fn)(struct vfio_group *, struct kvm *);
+	void (*fn)(struct file *file, struct kvm *kvm);
 
-	fn = symbol_get(vfio_group_set_kvm);
+	fn = symbol_get(vfio_file_set_kvm);
 	if (!fn)
 		return;
 
-	fn(group, kvm);
+	fn(file, kvm);
 
-	symbol_put(vfio_group_set_kvm);
+	symbol_put(vfio_file_set_kvm);
 }
 
 static bool kvm_vfio_file_enforced_coherent(struct file *file)
@@ -195,7 +195,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 
 	mutex_unlock(&kv->lock);
 
-	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
+	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
@@ -231,7 +231,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
-		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvm_vfio_file_set_kvm(kvg->file, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->file);
 		kfree(kvg);
@@ -360,7 +360,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
-		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvm_vfio_file_set_kvm(kvg->file, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->file);
 		list_del(&kvg->node);
-- 
2.36.0

