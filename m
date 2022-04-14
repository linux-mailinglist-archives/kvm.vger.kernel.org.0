Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38AE501B38
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbiDNSst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243078AbiDNSsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B08FDBD0E
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJ4VUFqjNpF0qcWl0H5R1wUAiXO4mtQM2Wy/q1AEMqqRIDpNf7OBR5/Ok+pdrdWv2JWXdl/F2voh//cUNDVw7cZYAqFu3Re4GGMcDRJPxDBB2ttNx4mzkv0mAw8AqLQxeXVFXf8STM0lN/s7s98ihsM1TtY92Cy5BLVkWp3/SwHcj2zkzZl3ZXYkJyF4GHSZb4r+gA1njmtacAvygKwGIm+C9rufs5chNyHM/7SaIeqzi0vk3kmTUcn/eT7rM07ip+N3P4FCZQYRNunebZK7s+orKmH0VM+/hoSuTzMz01JvWnTCrzd9w+Jn7A2lSvlH0F9vobv7WqN3j7LV9MRs+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEXEuNzQXJGQo/64zsNXYPhQ/3p/634HLl7StvnVBQ4=;
 b=Mr0hqPMcPTOStiqiHoxWLy8XzNy0qSYA3tj0jWc/Kv0HmQ2KpdTD5dj9f92uRnNbq/vqj51cTeFEiH4XFC5MzOcOvSjFbFgko+6rPZrEoDbKy7ZyxVO3LToROnF33uQKGOKTFed7J77lJ1VJN9jofrWK3NuEW8RFKOiQvTLbmK54wD5iB18RmQKgei5zKpWbgyelJA9mJGEhrbLHtY5zEBCQjij0KayhkOfcvZmV6m+kBPMD4GE0YWW8i+JctwrDEkGGLtCA9Qbw26sjoBSvrU96j2U66I7GGCLYtEqbEbXlkDWvz/BKrjmaXNH9z0DN50CeHJ+2NWvqSAS9BrzxKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEXEuNzQXJGQo/64zsNXYPhQ/3p/634HLl7StvnVBQ4=;
 b=eqWDI+ZkscRLmeXwctde8ljh8yPIqu+eG6ym1tcFk7RBGCHRfAvJ6K9Rd+SnMIVZXw2g1jjYih8CAAS+FF36iUEM/CvOKBVS+ec6lnlGhfwiiozS/3NR/+U5kRt7akkt5EVpAI2qJ5kX5DZnDto/sVw7emR38DuJ2Ymd+QszvjLhoOxqWxyb6fuxkHj3OFDAOxiUdagV3gI+AbCYWl7hS11k8F/NrPAPXL+HWPvgKPSkaxLDWcSnc7Mru+Zc+IIzu3ZuhmWhGhbo5Jt3Z8wzQIDDJcldAae2GEx0sGAx3W7FyKXfSlMnby9GmUg43kTsADPhWHXSugwIr2JyVwNr/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:12 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 02/10] kvm/vfio: Reduce the scope of PPC #ifdefs
Date:   Thu, 14 Apr 2022 15:46:01 -0300
Message-Id: <2-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:208:23b::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08a4d47b-809b-4be1-433d-08da1e470ba1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB53503CD861270ED816EF5783C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0G2Ni0ZwipN6bDmz5MMvwGW0+RCRizeYShJ5Kw8u79qrAuOcN1RvtvFYR1Y5n09yNLpT9JQ/IIHpQvoZFTg6HsjpIi6G8N6E0vcbEHPHUH13YQ8uWtQO8Ot0okkuI/LWXFKDryfPECW7QBjgLLsCF4WPBpVcvBnCQXIiL7wLlf9HKX1VhUkB98FhSSQ+t/LbJK01G1Kb9NtBBX0xaPRrE6E2Aym9oWiZoLnDSf2gp1g07p+qXaVtS1e79WhKDDEfbyR+QpzYkww3KM4Km/tdqeQKPR6ZNkOdTN/gSRbIfXxuGevIGRRpcG+kSstHqwjq/0eFi3a/Il2G5tWctVnKahsGplkFa5jqe1Fik6Yrl11kyl6LvycFYU1Jyzdn0bsvFffE98cs/fCL0YAYffnI1MiuJxSRMq88Yuodso1sKI4NtrvjsfDooZVfQDBD8378fGWnm9wJsSe0ryungQsTpoWAfOPkjVSE0tH2fjl6HQ3jcMLXURpssM+2Z1k4hNxJYCUoY34nD7QqfERre4X/v39q/Na3rF3MXXU7gPRrRrmZ+ZNMM4X4fZItAHExTxghtILcPSiZvs47UX+uypXB/011RzOOhtoAMwx0Dkq6Iigq3gGl7aAzKsN78KG/fCDlNa9NqVX1SJdeBqkiv8HULurrSImo6Ro+dZWbT4ECy2uoz23CNwg7yqNU7u3Cr1NSF6l+uQKG+45lqwwv4XwdPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0t8FL0+rwf//OXx80FSLEPImgO3/TdJ8MZ6M6t0PL2KuNGb/00HXQvdHcC8G?=
 =?us-ascii?Q?UOiwBpS3FCPcJWvRbGMpKROGlzAu5Fd4gHO5xk4Fnb9nCUrzMYg6JK46f6j2?=
 =?us-ascii?Q?7R02+6FhTduF8+dSr0w0sgYa7mtRV5XJC98pHdE3y1dBWd3c17oWjVRx5atB?=
 =?us-ascii?Q?jX27bvKa7vUfCnbltRCx2MSyl8iRii4KBcvZHeH2oxJVk3vLtZpqD6rymFZQ?=
 =?us-ascii?Q?PnDL0DSuMvCWtE1gAd9mU4HEglC2WtABu05q4bWEIX/ffO0C9Wja18/XVfN2?=
 =?us-ascii?Q?13gKWiJW3qbz3mMNMSGtq8e3CCwlWVXzo67kn4Ln5GQgkm0qc7daJVH5PSzp?=
 =?us-ascii?Q?uj/NFkZxsfJ/3NE8DAsS1PCNTayOozI1H0tm2xuaBarV1/oM0CbKyPMKj9ML?=
 =?us-ascii?Q?CGX2NKbpgTplK3C+aM7k9eZCPt0hHQeG6NnwOcsSvOMJHrEZlIE3uOkbjMAS?=
 =?us-ascii?Q?RGmOsgzlmE0MyEJqE4Ud8Iwn7tLyOa2geovzdhOP4w6DBEAk/+28dz+WLfPi?=
 =?us-ascii?Q?GYtimta3cRylRZl7U6mFRymPKG6ZrRXNR/RCDiRiDTulguqDinjQbUHcFVs+?=
 =?us-ascii?Q?c1qMJ1JIlaug889Zmxtr5N8ZGPx6SosYkdBLND9ujTdBU91xQPPbjuaE+am0?=
 =?us-ascii?Q?ab/EORlRmu6IKi2wvoXVA5FY6hXzSzvsU0w76hQNTjBg/GZ8fzmEzTaMayCr?=
 =?us-ascii?Q?iS7yZGwkLIRXpWo6UUcBK9wWXrhrm1cr4gYfs3Q7pYo/m13RSc0FsqKhUFxX?=
 =?us-ascii?Q?QrozHWXtB8PDse5M4CM8J1UCrnfJgJJ6e+33nzvYXol2Gcq61ACO72WCCWBo?=
 =?us-ascii?Q?7H2DdETcUKKnkg8AnWXCmNQcoeue7TfcRmnoG121fjeZ/VF/aoqjcbdyW3pk?=
 =?us-ascii?Q?6NFQkgp4lfBcTvp7376n+4jI9poRtU7uI/Px039xT/1QKEXwJwCEqAkosinB?=
 =?us-ascii?Q?U3shbGYZCne0Ar0w9dB9h35vbYJBaLeeE97G63KIgz7Q24NVQ0NDagIxXWru?=
 =?us-ascii?Q?1I48M3fcCmlr4A6oZO6zOvs0cLAOIVsn8CyPELNdKHixoRrmDTfQ7d63BDrN?=
 =?us-ascii?Q?1lGIL1JeVqUQBuppnmw+loFzXC5i+v0UIYkVaqcZ2Lfh/A90/muPWkLt7YHU?=
 =?us-ascii?Q?mqrVztcOfMqJ3IWRqd8GAMCMGvptHp6mZEkQaA5ECyYlKCaaQZTGj6pH3ljO?=
 =?us-ascii?Q?hB1ts3sIxo5QT/tCTivZ9djGZYdZFv2iaJaC6h/oyJYTvh6BJeTlLhYXbuW8?=
 =?us-ascii?Q?La159CvcwQ/pLPHixQMHz/iWxy9HQWqyu47dF3WMRYxS1VjUuURsQPSNqVr4?=
 =?us-ascii?Q?RdoKri4/gT2rX73SBhW8Mm8mcKbUYNysiBp+OulXTk3F08Y3qiJPHQbx4iG+?=
 =?us-ascii?Q?9lcmnD/kPmyAPVj+8keIKfdQO8qjUOZBfvmwUz3tTk8qoL6UQiR+66+V8JAn?=
 =?us-ascii?Q?bmhrWIFs+Y8SqZG3sHGJK9FXaCuPhopyXIR5R8kpIujkSt7LDwu1F5Cglbtw?=
 =?us-ascii?Q?VOPpkQhozSeU6GKzzkX7FkgH4adPVgYolCtDv5Zyya034Se2PnACsCsXaNEO?=
 =?us-ascii?Q?RREQO9VCrUumQL+ypEwHAo2oTLFkKxU5rFetOV24+INMRafc+9Ag++EhD5Xw?=
 =?us-ascii?Q?r1jWNpS2mHphHHaelBuRbl+vRPEHZWCh5WnY6mwhIKeg9HAVIo3ZRU8FiaZ5?=
 =?us-ascii?Q?Tw+7u8UJQZZHhWyrrq/xjSCdB4PFNAqcds9kVlW/9DhC+uxyqm4PhYuzeOKf?=
 =?us-ascii?Q?EAYH6qn1sQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a4d47b-809b-4be1-433d-08da1e470ba1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:11.4694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WpsMU+igl2XKh0MMeiCAkILH5CuJdCzZK1sBvJZFImY+7EA90VsTzVQ9cql3SYQL
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

Use IS_ENABLED and static inlines instead of just ifdef'ing away all the
PPC code. This allows it to be compile tested on all platforms and makes
it easier to maintain.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

I'm not a big fan if #ifdefs around #include, but lack a better idea - these
weird spapr things should not be part of the generic kvm arch API at least,
IMHO.

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index a1167ab7a2246f..9b942f447df79d 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -19,6 +19,16 @@
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 #include <asm/kvm_ppc.h>
+#else
+static long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
+		struct iommu_group *grp)
+{
+	return -EINVAL;
+}
+static void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
+					      struct iommu_group *grp)
+{
+}
 #endif
 
 struct kvm_vfio_group {
@@ -106,7 +116,6 @@ static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
 	return ret > 0;
 }
 
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group)
 {
 	int (*fn)(struct vfio_group *);
@@ -137,15 +146,18 @@ static struct iommu_group *kvm_vfio_group_get_iommu_group(
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 		struct vfio_group *vfio_group)
 {
-	struct iommu_group *grp = kvm_vfio_group_get_iommu_group(vfio_group);
+	struct iommu_group *grp;
 
+	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
+		return;
+
+	grp = kvm_vfio_group_get_iommu_group(vfio_group);
 	if (WARN_ON_ONCE(!grp))
 		return;
 
 	kvm_spapr_tce_release_iommu_group(kvm, grp);
 	iommu_group_put(grp);
 }
-#endif
 
 /*
  * Groups can use the same or different IOMMU domains.  If the same then
@@ -253,9 +265,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 
 		list_del(&kvg->node);
 		kvm_arch_end_assignment(dev->kvm);
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
-#endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		kfree(kvg);
@@ -272,7 +282,6 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 	return ret;
 }
 
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 					void __user *arg)
 {
@@ -284,6 +293,9 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	struct iommu_group *grp;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
+		return -ENXIO;
+
 	if (copy_from_user(&param, arg, sizeof(struct kvm_vfio_spapr_tce)))
 		return -EFAULT;
 
@@ -323,7 +335,6 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	kvm_vfio_group_put_external_user(vfio_group);
 	return ret;
 }
-#endif
 
 static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 {
@@ -341,10 +352,8 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 			return -EFAULT;
 		return kvm_vfio_group_del(dev, fd);
 
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
 		return kvm_vfio_group_set_spapr_tce(dev, (void __user *)arg);
-#endif
 	}
 
 	return -ENXIO;
@@ -369,9 +378,10 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_VFIO_GROUP_ADD:
 		case KVM_DEV_VFIO_GROUP_DEL:
-#ifdef CONFIG_SPAPR_TCE_IOMMU
+			return 0;
 		case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
-#endif
+			if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
+				break;
 			return 0;
 		}
 
@@ -387,9 +397,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 	struct kvm_vfio_group *kvg, *tmp;
 
 	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
-#endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		list_del(&kvg->node);
-- 
2.35.1

