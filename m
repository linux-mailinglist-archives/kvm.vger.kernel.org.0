Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9698C501B3B
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbiDNSsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiDNSsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C829DB498
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/BtMIkxxh3TfIg+XWgNNjoGsQmRN93J0D173VYCDfSqE+Scnb1Wl/5RRNEVJgq80WCYTLeGOogZMP6R7acyCDpBmkB5oay2khFbMUHSHS+b0jp/Fo3UNekuJJTyvMTIKxjxnYn2kPpTq+Nof//oOevw78BTavQhhhvKqufkwTnRqSybSvM2KyFYRvTinqrUBE5Jz6CIPfvAQn6mXnykfGaW8hsuBuyOiIpHCBhoJEbkRCttjS6a/2oK4c72npzemL13TfyYWKz+5EIuGVR1AlQa1KbFLAV7EXuDCe6M0d6vj7YpCElgwQlE8yE91CFQkZuXMpMKkt+8Z5c3RiEY0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKavb8q6HM8BxRHUCIzLukvxZ2U+kIoAL1WUbjJXBTc=;
 b=SuDtRaFYp9qjOGb+Oy0KfozjmcpeeB6Rp5wMz/jH/7nATJYR3eUq5eMcha+6EXybDzxlBa1ZDSDujh9q3qLl46lfNTKLvjlkFC1GJwA7bWGezvTCd6vz4acMDTDrvVclgc174a09RRP/hs5Gs6R1XfJcIZqKHX8wGfLHNCkDtqb49IeiyD57gzOqTjlPmf1SmgK/aPPKT1CGTExPKaFAUcnek1t0loRef4DtRs4r9X/KOABOfoH3zm/vnWyk/tXOyX0w+pUYk2dMPbhQ26sGDgSQ+7wIt28ikmd/Nlct/Kd1H2UfK3e991PGqFVTo8bVgPksiifgL3444Te2ykN6sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKavb8q6HM8BxRHUCIzLukvxZ2U+kIoAL1WUbjJXBTc=;
 b=udl7t3FoOXYZcPuuxzHjOhq3ZLu6j8xviuude5sGkq5KIA6zNOYQDx7M6jMxgnL8kWsqwqFjjOdTxE1CIj9UdN3GKuAJ/IVMdUS2riWuT9MOLFONso5nbcBKkpH01UEkMPBTnQbBacOWbhIR+WSHtG/GaRQ/q0CDhiRftCePynJbf9yCw6BYDi6rZFBAupOMddAHw1h0ynlQO84mdvqTyuclxwossOHkhvK4mamwyKSJcu3Zv15P3UHjGdl2nsELKfEsrhRyTmHF9IsvuzE/5uylZKs+KkoGyH8AOMJoWlU7cXwBFhWm4jcy71f9hdm+bFve2ybuyh6UVmklSAh7/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:10 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 06/10] vfio: Remove vfio_external_group_match_file()
Date:   Thu, 14 Apr 2022 15:46:05 -0300
Message-Id: <6-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:208:91::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14d388df-5d38-4867-26f6-08da1e470aff
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5350E3F84829A580F6B0A257C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: niZyzWJRHm/JyQCPPWl/Xh93eHqhi4iDnUPrQTnxdFoeqvPs6ZF/vAFVF6q4GmbHzTPKcGJbvxYdf4tHzzGxjvBKpqaBxcrGt1is/Q6yy+fuasXR/IGSfBRpdlpmuXnpzD8N4peWVrYocbOVghNmi7vQeCh5ofz4f4S8WXPrVaqgmozioV93W3j4Jo13nLsS3vzAWiFNERCqeCu1PRQPk8PwGnuWoFg3rNeMDiG+c0Fg+3r4Q9vyCgxxvl0SFuudVwGclX9OhQ1WnTE+AKKj24rJialT1fq50GIQU7ohyRhddlZoAVxp6j2J3IpAhtCD2KS1nDMQewSAQuSeRJFmGZ0eAkXopk+XhPcFO2XdwQC3McYb8giGtmaAe5KDqp9bZKcEcqs1BjR+778eMRj9WlD8BnuyxqPqLNQfyQuO26nhznucU3j5i21vGC86TAmOoz29YxfR2niZDS1KGL4MVzF1nPhwxZ0nc4W6ntif237+k4A+XN+YTJk8IjwrLnaNmzrH4EmHZ8/nhoERmNhVhWr1tfaWD94jXUpux4wst5H5NkYQQK6XytNFd3pFtuQDj3fVG+o7dNoOBZXZBdwBVXahXU7noB+ZHBotahXLM97cQfbzOdMZl30yJjOtrcxBQtj1OMz1y+rvRcV3+bRPhzSKpTt1KHbxjD5Xnd4nDRCyH92d077UjZNogh8vVYJ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hvToUDGhdWVFjBtwPay2W45VmX+1+ycv4Y1MPaFpKso48TNByjQ0lTRaJ/Zy?=
 =?us-ascii?Q?oj/UuQbjVLSy5nEgHZTHqHVX01+kxrvUx5LCgUrOFv1jiigg+rAhsvuHW/Ya?=
 =?us-ascii?Q?W4FmgUjM4T8tLFZEttDwxaUv7moEd8ib8XgFThguZ+bE7aHiIZzjbYRPK4qg?=
 =?us-ascii?Q?SKwmbq/CNl0KzWUOC6JA9qh6kPFdL3BQiguT4bXLh5QEF/xOIwH9J0uxXiyJ?=
 =?us-ascii?Q?546vDIsnVJEWy6aMj3FkCFyBRT1PB06EcGzN6uh2ewbUhBXp3u4Yfzq57Jtu?=
 =?us-ascii?Q?tx9cVYdhwsytCVHpIAIknY08e7d/5AQlddv3asZ+scHjhSqTtIqV8UO977Ai?=
 =?us-ascii?Q?HKII8GiOLMcEUBpw1ILNKIlHohvUYXhjLHr0/67U69zSvmyaY9cSpy6aOX+N?=
 =?us-ascii?Q?txmX5j4zxXGY+/O24eg35DVj1TOhST3JzxoOHNr35r91Tw2cjnlNmAmEWHlV?=
 =?us-ascii?Q?XAt6mBvVq1D2fuRgy712qVGQkRtp5cPVshmZhpR4puGqrAyd3fYanfsJ6W2q?=
 =?us-ascii?Q?BHO1PhcdiPHNs/SZ9ySL3sB1Y2FEd2AxWQ7deIEsfFW2TJM7p7jhQ/Y5PaNc?=
 =?us-ascii?Q?eKd8omlpAGzVIlIDT9J/AT1D2CEZ32aNDvvwMniYYBmlW2HV0Qt5l/kaSn5P?=
 =?us-ascii?Q?bHFEjsSmV3dgDPUkGVXxioNWFoYVNkPTtrlJBr1bd6Uyg3Dr/vlwzSv/WDuD?=
 =?us-ascii?Q?MVwY1vip/AlnJkdCucZ6D6A7Wp40GVldwlRtyBxVohnFpSyITxSGeXmrBmlS?=
 =?us-ascii?Q?8s+A8d/5GIsGPqIDR1Xm07rs4/cb8K8AVpeQO+xbPiWmEAJpOGvVD7vId93J?=
 =?us-ascii?Q?T0+Hnp8H3hZsFBYxNrgSj54oXlDyv7FaK3RIgub7cfcHUzR2Qz2oTcWf40MT?=
 =?us-ascii?Q?ePGzdTgMeyR28L4J8xPR4fkj+zAkXBnXxpAh4SYJrO3rd5cjccjuL5bHJ/Lm?=
 =?us-ascii?Q?l39LocBqZEj0eOVG9z0Tq1rxW+pKF+3IL7Nhcjyu2thHHmi8BomJVwTnt3lP?=
 =?us-ascii?Q?vbcvdC+77g8YhlRkZbc+Yc6qLN5cSpWBSsZmtqN9oisUmTdEryRMpRq3EvB7?=
 =?us-ascii?Q?k2NRfbZSZosYoXYqVPtT2jE4ZIBr8WAqnDTzOLJ4KuJzPoR7sCoC/XQwHSYd?=
 =?us-ascii?Q?t8wfBAhQFhI9wWXkvuqknRlM1RasrRbXnyAL7U0UnUkLgdRBM8MWlZPI8UXj?=
 =?us-ascii?Q?36xkGFykOKCsMApMEYuc6RiYamDvTvj4tvYyRM7xQP3TgXie610imEPzdufW?=
 =?us-ascii?Q?A0ogLgMh0vg/EHoQd2IgTb8bs7m7Ptc9C89LBSOIUoy8SCmzmQXJp7yJ2AAN?=
 =?us-ascii?Q?7jdS5qsViYdMn91ZjHjioNekKTHVLOalGTmpz9uUHDlGqybRw+5ImFs2ydpO?=
 =?us-ascii?Q?9Q7FEbtgxztzDWZI+jQq208X+E2QLgMtQz4x3aePCZmgtvKfMzws5o0npeko?=
 =?us-ascii?Q?2GuvIgcxynhnxrI3fe1UGYNEV82918bSuJ5xSafWSVYFPt0XTTZF9HSq7JFW?=
 =?us-ascii?Q?T2uX4h03OdZO0EGJiPiZ4Q4GV9+odYsxdAwOKMBzVHoKh7YS82o7dQ318Wlu?=
 =?us-ascii?Q?5+OBGxlJLIrSVXFu762Xa6tbARC9B6d0E/nmBhggXfZHlJ2/s0FLX+vwprnh?=
 =?us-ascii?Q?Nv/nPoDmJTZCTv09IRdryyNX2LQJRFzWIkd97at4i46WgcPOBs5lNtggA7h3?=
 =?us-ascii?Q?UIyeomoJAFqjmnCsNZ6OLcIUetaSCPd6HurGfhGaygnVnzV3VmyaTcptxstJ?=
 =?us-ascii?Q?T4vqfrtKRA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d388df-5d38-4867-26f6-08da1e470aff
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:10.3601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mk3sgu4Uhi5wd9TE50eed+r2J72LTnILFatHfflWqSYTw367VaJTEnEqpci9ulns
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_group_fops_open() ensures there is only ever one struct file open for
any struct vfio_group at any time:

	/* Do we need multiple instances of the group open?  Seems not. */
	opened = atomic_cmpxchg(&group->opened, 0, 1);
	if (opened) {
		vfio_group_put(group);
		return -EBUSY;

Therefor the struct file * can be used directly to search the list of VFIO
groups that KVM keeps instead of using the
vfio_external_group_match_file() callback to try to figure out if the
passed in FD matches the list or not.

Delete vfio_external_group_match_file().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  |  9 ---------
 include/linux/vfio.h |  2 --
 virt/kvm/vfio.c      | 19 +------------------
 3 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4d62de69705573..eb65b4c80ece64 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1989,15 +1989,6 @@ void vfio_group_put_external_user(struct vfio_group *group)
 }
 EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
 
-bool vfio_external_group_match_file(struct vfio_group *test_group,
-				    struct file *filep)
-{
-	struct vfio_group *group = filep->private_data;
-
-	return (filep->f_op == &vfio_group_fops) && (group == test_group);
-}
-EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
-
 /**
  * vfio_file_iommu_group - Return the struct iommu_group for the vfio file
  * @filep: VFIO file
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e5ca7d5a0f1584..d09a1856d4e5ea 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -145,8 +145,6 @@ extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
-extern bool vfio_external_group_match_file(struct vfio_group *group,
-					   struct file *filep);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
 const struct vfio_file_ops *vfio_file_get_ops(struct file *filep);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 743e4870fa1825..955cabc0683b29 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -60,22 +60,6 @@ static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
 	return vfio_group;
 }
 
-static bool kvm_vfio_external_group_match_file(struct vfio_group *group,
-					       struct file *filep)
-{
-	bool ret, (*fn)(struct vfio_group *, struct file *);
-
-	fn = symbol_get(vfio_external_group_match_file);
-	if (!fn)
-		return false;
-
-	ret = fn(group, filep);
-
-	symbol_put(vfio_external_group_match_file);
-
-	return ret;
-}
-
 static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 {
 	void (*fn)(struct vfio_group *);
@@ -244,8 +228,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
-							f.file))
+		if (kvg->filp != f.file)
 			continue;
 
 		list_del(&kvg->node);
-- 
2.35.1

