Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B59251AD99
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343831AbiEDTSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245642AbiEDTS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:28 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2D6488A9
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJW35aFhaiTTHFrFl2uQu9saiff768ekHCnO44QQdfu7M6brGVZEPrf+4AHfZQS8AwFOmO0GJTJmykXs0t61Q9FDi2kMlCwJUzr40el1Y7hOdMQDIalWun6fBpVttWDXERzFahNos4SZfF94Bs82/hlq11Lj3JKMTyvgh1oJ8IrPQS4HPhW+T7SiFT8PS6dWl0q+gWSTVqNJ688dL7sDQCD1kQeQ1Owfr71E/J8INFoUrNgnU3Dj2xxTcBA2ecr67hFAYtjdCnva4PfF8XGNY67cbrbPmJFlL6RuwxkDk9cQhxlizEQiIISFRfa81QwE4V+eT3NFSPPzT5fB4Ys7Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+F7uGJlXPxKFEHqXOtRmXbdXATq3BhcuyzDTo7474E=;
 b=aH+vTQY1+C6ypk1k6gNsys5/2yfeusm4cT4RhDayfBqv+FRlAC8KxvDdSoR9xtUgt0sjVhG+afQD5R7ijI3IV5uUx5ODqSG2RzN61DG42zc3RA1tLHcMkkSvc37I3r7BD7L7TxX1RgER+LO00YitBu/RpxC6FoXs+jAfoY6PvPiP4gWQ6wczCiaY66fzYso6Z6JJ1j4MNHXDRD6I2x5B/OWMoEMmgi80tmCg+UmBceLgXeQxvdSZVWNcAWfh/XM2uTrOyOsIT36x/pCrVJvE27Z/T4SLHHVj3wV0ZZy+8QzxeUfGfOuTLj7cp6t8+kHbcgWHAzHOGkwMhQcOM7Sw9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+F7uGJlXPxKFEHqXOtRmXbdXATq3BhcuyzDTo7474E=;
 b=EKkCQbKxLUN8qx/M4BHotgvDoAL2A2k3l7/Qw8+zeCdWyJyNruQoc3P19pwyI1dRa4ZXS1Fj6iqcerJuX28BA9cmtg4aBl0kQlfnffVAcGpXCN7XF4tWH0wQ0KlmtCJH3GQY4GZ5GeOi7QFnF1TkE5tx3n9vnnlJN/E1ucBpwTUo4dJ/xNglyole78A8C1kN3NNkPi3ro4/Fb6zZidpB4NufEf/4Mcvo57yMiOjwm7FJczk8atBgrLFgCEacuazeHhtVV2bE1FnZtehga2FjyScXXk2ZN4urqwKz2Qc5tEHvIvKYzSGX44DcANgj+8smnoH3wKlR0kuj+9jwCQlFlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB2341.namprd12.prod.outlook.com (2603:10b6:4:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 4/8] vfio: Remove vfio_external_group_match_file()
Date:   Wed,  4 May 2022 16:14:42 -0300
Message-Id: <4-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:208:23b::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8525803-f287-47af-c743-08da2e025b24
X-MS-TrafficTypeDiagnostic: DM5PR12MB2341:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB23413C3CC74FA3BC913F79BDC2C39@DM5PR12MB2341.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2RAofpDcMHZsij2B0lCwRO4WCM4U7lpI6GXmNXpGdklKNnG5ZTITsQDdD7nOKs5f4H+QrYexbLAokWJn04CPBlC3s7BKDPJNcFzW2I2D0Dmp0hK6/w8VDJ9X9J+bmlQBpyJU8kK9yZfb7fRlYfhAdc6qkh0UBr7cIuatThQSXE2OZaot0W11Qj9WkntULOqcXxkKr82y5d2pXJl28ZtJH5RTfo7g0+7V1n3h0SRYzzH15v3bYWMav9T306/8WFD4+d0GQK7f4COZvPsySmibg3DeP1BBX9SfTGXO74x/o1n3RikW1Csl7sHI1Uqc9RmZWPT41OO0AlQUZ9DaiWSrxkU/bLlJkUA7zKysSZg1VAsN/uE+H7opYU4McTns2gnDzjiH0+j6Pc6S1X54yzcNd1Fex2aiB7VQ0Ss/IBt6YyPqSr00IF+2BDzLyJag9SpzRpWnsjvYXJE+KQaFFg8xZCe8jrH7UeHNBe8qg1J1bnzq7vKB0Aem57O9Wr2P2HvHYg145S5LNCyrqFf7HxmBHlipOoYWg0HAK4Rl/+5d4ccJ+cfpU1+8u+35bsYyVf9/jy6FeCyT+jV198cfuH4cj3UBxS9hqtz3MNUIPyckJBdKQc10kK57GHRHLYhmEbgtAzw2aNnC+m9IEiZxraLZ5pbVxSYhveliyK3YeM48PlRCBxVGQaRRk4dyqoyyakLPltZTqOF4kIymTsp+FeIpkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(186003)(2616005)(66946007)(8676002)(6666004)(66476007)(6506007)(38100700002)(6512007)(4326008)(26005)(66556008)(6486002)(54906003)(316002)(83380400001)(110136005)(2906002)(86362001)(5660300002)(36756003)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+PQUhj6eMeLot0IO1dhtRJR93z5SkE7WzqaenZgbsj9GstE9tpmqG7G2/kyN?=
 =?us-ascii?Q?ry9LYp5mF5kIDqcGkOIslUkGlzADNzS5rerLrkZC+gulhVNGYLdubBT820IR?=
 =?us-ascii?Q?jGXolYl/3wdCal5DzsnQTKtpcZmwCWSvBIPClTxcgoehgPb1a4Bn44ZV26f1?=
 =?us-ascii?Q?SpyOOOROMys8Z3ZemoqpDNg0pXhW6l/ebYv7Rgt0J4ouXeNeJVYmSKnpYQkS?=
 =?us-ascii?Q?RvruDKXRK6MZfy6PX7pjOiCv1J7qN5J9jIq9ymJWDZPn8aaiJwRaXsfpsWDn?=
 =?us-ascii?Q?473ElrkY/ZfUqT5T/gjqlUaDYrj7lAisgyXPl9uBZLDQEpQCrLOAJKFjN3pf?=
 =?us-ascii?Q?fyfzFrngvpA3Wh340Lc3HjChDh+xH0NWopxhCnfI7eMRTON//VBkVJM2yYQr?=
 =?us-ascii?Q?DAQc7Lmimu9ajvUWOwIn+Wk/RSXylgFpw8GyuFXSAEuE4WuNZ9fXZcjHEEnd?=
 =?us-ascii?Q?AXEsmTvigX4ymtSQSYt2GuZU4Rnfb7dUa7JPN7mkYcbOELux0jwcOM2ssi3j?=
 =?us-ascii?Q?nY9XMYLsc/T1qq15/d4c0VMPAX+6t8Lwx9+yFKYv+3qGb5U7cM6KI5ljn6B2?=
 =?us-ascii?Q?TLP5bTmYBigMzdGnZkolzvereOZeB1Ea8kSGdgdgXwJ35EY834Q27THil5L1?=
 =?us-ascii?Q?RFqPqkngnvQ3ZO+46IdKhMLODKPYf6/PDxHx8JadlYnyON7zCvLiTDy4vDGc?=
 =?us-ascii?Q?XkbPshu1SMDw6F2IUPXpzFZ//RTVQLU0GPxCSErq8CC7P/NCsUFn84aFslNG?=
 =?us-ascii?Q?OJ5QqSkZtnFfXqA/I4JV4NNwquYyiYqrFBd142FnnhIMaHvpEJLRte74X+pq?=
 =?us-ascii?Q?6aFEc1mmXuz0kmvJzphtSFfUudNSQrHh7D7npqBZUSW7JKTDJzTmVOOCaiK+?=
 =?us-ascii?Q?qq0Ew3x9dxOzc5j+Q5xpNJK2iA9Uv0C2nCsUuMH4xOfMLi7ZN4TqNOUGXRtx?=
 =?us-ascii?Q?bEF/nYzNbsAm+68tPsRq+1N9LAMWij4bhFhVu3BYxIOivwGnaxFDV7UhyW7q?=
 =?us-ascii?Q?WsHyde2unlR/RVis6H9iNxf4heMjdVE7DZm/d7L0ro/hgrOt4r/3auGCKWOL?=
 =?us-ascii?Q?Syc+6IT+c1pGfy601U+YYwlG/rDx/jenbKkO5wuVdGPUBkYSUeY9N3gphMpS?=
 =?us-ascii?Q?fkWydCLO8/9O6LY/DaOI5sJ2FY1Zm2QC+mtAh7JKDKmScJ85BxpwK9H8q3Tp?=
 =?us-ascii?Q?BpD+t60ulJjv1aIt3/pU/T8OB8DESd8zsNDtTIn1ZtGnyFiUKrJZnA4vJ6F1?=
 =?us-ascii?Q?2FALLyObSWAsTqjsAlU7YlZjIsPiZc8Ej3W7feD9HWtKKTSAubQF4C2wGFj/?=
 =?us-ascii?Q?3cvwyw+c2EaqXm7YDtP4dhCk//3lux4uCqyGLXJKawg80Jpgtt0OiaoZ4DrM?=
 =?us-ascii?Q?HW51rXMcs9SacIZTrd3+w/IHXvW0BBu092nXUVIUnTmbpHYAfkkfAkudIfA0?=
 =?us-ascii?Q?qCjYxBsuEWab3o3W3BIryBJU6lf7TCXQBhW6Bzz3mGUyKsvux0T2eXguMNRw?=
 =?us-ascii?Q?0ftIz59YVa9R8b6MTdKya0Vnhm3mtYscv/eo8lefLA6nflE0GgLiV8j+khlj?=
 =?us-ascii?Q?qXVeUsImpLck6XjMkjnG2ww/phhiI11O1PJcIcV6OLFAe+n1JTN+qrlOlljP?=
 =?us-ascii?Q?mk9Bkvrt+N4zUAfLYSwjEgY2GCBRWM7LawSFtt2vGG9IgBJggoa73K9JbWt2?=
 =?us-ascii?Q?LIDFUweoSKmiTAfn2JS3RkN0ayLk+2iHHeEXKLJKSUVJU8N4jB5/R9doQUUC?=
 =?us-ascii?Q?eq59ePUvvw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8525803-f287-47af-c743-08da2e025b24
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:48.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JqyveBEdp8zkBVSQGP/sB7DCT3fcctoLLJ4GJJzAIgpX4SN0y9/wIrRzmQH+nrcW
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  |  9 ---------
 include/linux/vfio.h |  2 --
 virt/kvm/vfio.c      | 19 +------------------
 3 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4f031ea4cacb9d..a451800becfd86 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1705,15 +1705,6 @@ void vfio_group_put_external_user(struct vfio_group *group)
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
  * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
  * @file: VFIO group file
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 86b49fe33eaea1..4108034805fe6a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -138,8 +138,6 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  */
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
-extern bool vfio_external_group_match_file(struct vfio_group *group,
-					   struct file *filep);
 extern struct iommu_group *vfio_file_iommu_group(struct file *file);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 9b7384dde158c1..0b84916c3f71a0 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -49,22 +49,6 @@ static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
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
@@ -239,8 +223,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
-							f.file))
+		if (kvg->file != f.file)
 			continue;
 
 		list_del(&kvg->node);
-- 
2.36.0

