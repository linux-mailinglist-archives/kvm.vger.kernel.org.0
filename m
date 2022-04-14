Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15341501B40
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245117AbiDNSsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237531AbiDNSsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:38 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BE4DB4A3
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6e86QUUtekzQ3KCTB+NM1UXJdqiZLmBDJWjmvbCYIvD/6f8QQ5Klkb41XfjPgvpxoGiTKFFaYz05ojqW/aMZGrD7DqVs7ArdOBQcrDRtg99Ifxprl2Oe2TqfQ3E2SEMmEPaSRlGkFPFJhonmNU7akjNXhvlGyfABY454pzp5qKBIQgYcJsc0RUy0MpGtdeZVsI7neYYl8WPVMIsHDHIBEVoIJfMM3fWVkRn6d4wk6/wqJHmECcDIh6uvxUz6RGkCa4szErvycjEtiQGMPZD4YcKpHQFoaOlggDAJxYSaNp9gY0QBlNSUpM5KadJ/0HYHd7eSUEiyrR6pKSTsatoTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/SNkKGKalrgBn8yEcmVHVUP0zmqxUg29UXwAH85OOM=;
 b=UQfmKmNKAuF52VhmRA/g8mkiIDl0Iz+LmwAIA7Se+oFO/qmbX2/KeJK9JajM8xezBL0MrbMGof8PgkJDUiVDdGvaZV+nHQj64Ogkxd5VF97fG9CS4ufiklSmeEYlsLAEV2kXGuOe6u9TqVuV6lUhmToMc8OaF8Wx6bsilcM8sxq2CXkUGrFDVFyjAfxNrxLYwFpFYXxnJxTRf438mkWjLVVUUYYoNZK/a26e/CE6Uo8RX145epO83KHbPjyhjwh53hSfpB20Hk8ao3j6uIWg01v6pGfvvRRM5jV2xiYkSo19RCNW7fm9/9/oRAydJ6ndCkIB+JDnVPLOLlZBJsE2kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/SNkKGKalrgBn8yEcmVHVUP0zmqxUg29UXwAH85OOM=;
 b=jjvjhPMsrITrwI6OD9yTo3k5Y/CCk4xeMMJK7RFBb0a8p+VtbJiQ6rXcYFetgmuwL+w3GEXcX4NTSiKR5xw/6KQgdLoVk0ejdGRudB+7V3LbE9eIZbLiryNSHj6L2qEQZRrGN2bQYPO0dfDDp2l0Tu12PLItmRJlaiZQjMA60pDqq9AceXnFzpkIyugGAFtW0PsoiDsIGaO4Ez5E6cpbiUQZKLOf2T+/n5G6pQGywgAQ5i3Y4lJtfkcmQIjmQJSR1CYK5oH/6Hjn8sH7Oceoq5L+zNis/nkHYEKd5Upu3c4j3xb4hjSobGS7Q30SAgAlSlCCkMZOBTAm8mau+HNgGg==
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
Subject: [PATCH 01/10] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
Date:   Thu, 14 Apr 2022 15:46:00 -0300
Message-Id: <1-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0058.namprd02.prod.outlook.com
 (2603:10b6:207:3d::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4f854b9-8dbf-44a8-6284-08da1e470afa
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB53501BC0A8D3B7DFDA086348C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HRUaRpQDuR9uttGn2TrJ/XbPIWtNg2uCoh0X41vnHyHxBaLsqL3K/iNeb/hqG7ZGZXw2JgNc+DzWAzbzoj6dwLe+t6p1ZcygIJ3AZ5d1I5DQ2YVXegOBE1vuDujB0xmazZlhGxEZPQ7YUHQS1qjhKdo6GuWsg+Por9HxKiQAhvGun3caonjOldpd/4UTLcSrxOSYcY9yZexChQy0QfPuCK1QSAfDW5jpKczGSKLa7vfO4twFPU5DzoO9jYBibJCPKWHsIzqnriguQcSFU/SLOxnApizWpTdVfjqORR9O8N21hwxWEhXimwHVSFywHb8eIDwn0khYyli9BvTkJjj9m+sRPn5fy5ds/L/Zzi8wUKrO/EIRI+hzu1JNzj7g2ATmRRg0JZVwv9bunz8QWCEzQalFjXWNM0J/KypfmhzgaDLRQRN0EEKt/SM4LO8uAOIhpF177/jFTdoO10QIAm6WKnWkfcjtU6LOCYHosm0+Oel6qKKeXWDvqx9VawIl1vSaXRLdDepxcG97Pq5b/YB95zGzhB0sWo8UxzVH51YGeHNCdp7Sjfad5e6cxo9VDjL0QzPnlJiQH4SdFd7lQ2qm2wIUWayh7/zhJLHdln4JU/fs1nuG9x0BAWLAjr2iXNMoJZPJbQ94SDulhamwMXDysdh/S3r+eBio8uc82W4oxx5Ut4bTszIus+rr6npd/vp3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZaJ7/l6PEIWKadt90JAqcfmNspUSEPrtmPhcgNSrsn+aGIl2Oj4piS9+uZa?=
 =?us-ascii?Q?eZWA77d90EIqm01qBXXwznPH8tSqwnofifudbJyPT493OKzvucb43y+IcmG3?=
 =?us-ascii?Q?koB7FaeXka0MCag7uuBcAa6h2dq1Cf34SWOCIzE2JR3WiDFnhfk1uCzTNq7C?=
 =?us-ascii?Q?UjUnvopTp+P7ny+E/G1J8f2+glZ00OPQWApzZIRPJ3NJJ2UhMtgvnct09OVG?=
 =?us-ascii?Q?TcEck41Z7+ILh/GhSFoyH+ai4TwaLeI5de29ZgksAqv8wvneiAnDzjJw9x/M?=
 =?us-ascii?Q?+nJVhFx4NI4bu+IQv5KbC2NEsPB5kxshstnDoZXP3koYcx72u8HCKq40w8xL?=
 =?us-ascii?Q?gV0eVH3TE2BQ9rhBB1Bgl21SIDmC4HNcMFQSPTI6jQUJsXQCiRL/jTCNaNyr?=
 =?us-ascii?Q?lmh1Frso+pfsK+TBq+Z4FNL39/kgM86Ah6iaQ2f7X4tXfQICJYASXPvg7u1Y?=
 =?us-ascii?Q?kg/BoT9uQSdPO9Gvy3kDVj9j8eFw6Z4ETn+omFUPDIRN2cMMBBCBMCluv/kn?=
 =?us-ascii?Q?kcuveBdJUbpQVRX0aLBWn0vI8mERiSDuUobBV3ukcA/MovrHITigqcziPctZ?=
 =?us-ascii?Q?rBbnGP0UmS7jvOCIXtKBkiNKkTy7UPv+uqe1ofdjJFtP65rhTA3fFqrwla8I?=
 =?us-ascii?Q?gQZPbZQRybbcnyS0AVnFsFNZumn1h2dyPuOkWzr0fGdANKgkSL+EfIKlDaxS?=
 =?us-ascii?Q?wMfsedHynVV/Yh9Z9QUMAEB43Q5glNZ26nb0Y2sIZS6+c0ac5vbrlJBf4aLC?=
 =?us-ascii?Q?2jREccaJKqbg+qV4SmGuHdSknuyK4XqqHwrzjJUCgYn0B6pDSY1KSUYM77FQ?=
 =?us-ascii?Q?c4WK/it1lx9v0ZP8yLIKESVVi2d8rwkXzGC+m2a2U0d56iZyHWl57G5BN60D?=
 =?us-ascii?Q?Y0sLLG2mPVv3XirCl35545M9X6z2VYJRL64Hc+Is6tcKHQ7Y1TkK/A0xhXYB?=
 =?us-ascii?Q?bUnMk5djo/Y13QJ8gp7nFY8ZQOUERe5n3bICukxW1LUjyjpMIOt/bY5xGq0g?=
 =?us-ascii?Q?vuL8IpzV5CORPOlcLhjClBg6pi0Sep4ldpjt2qZsYsXkstynYJ8j4M4y0dY4?=
 =?us-ascii?Q?mAiQCdioaX27VRslmKZPsgw7kprpKwmqableLBtMpVk8Wk7sswvUa4gXJ9xo?=
 =?us-ascii?Q?KCoSbN0X2FW7SAaAncSx9oUdlzcyiOurSvj0py8xk89A2SubsNOCz83s1fuG?=
 =?us-ascii?Q?F49cMTwvBDcFMVlqM2dyvtVORIsR8pvdFWJiBXn9wDIEUnWPmUD3zdUPH652?=
 =?us-ascii?Q?+WvWREdF7nLNUAz+u0EOwe1FaoNDMGbrf79xhzN7k3Nt3k0RPBiTRuKKZb1Q?=
 =?us-ascii?Q?RWDDTCj+TClHtZrbCAaQklqgZ1b6p23H4/J0wle8qFyUUtkwzFagXrUDBfLK?=
 =?us-ascii?Q?TXsUVsECVNF8JAepX+38Y/rV342i2prpJM07o3movzqfPuscOn56Wgx5lhA1?=
 =?us-ascii?Q?uNNAuLcD9WoUvdAk3KfzscTTUmBdMBXVoXVsIxN44yAwh9DPDjLrUB6TwH2F?=
 =?us-ascii?Q?c0HO0U/Yww3vbkYEHTcZBUdOnmSzWID1NkEOFsXmk24VnzvkC+M2vuLWGUii?=
 =?us-ascii?Q?unrIy19uq5INY+VK3m8UbHrULamkxLVE2WFLP9cgiFoCV7CJcsdoRVMTSfqf?=
 =?us-ascii?Q?COCtM1KG4vcvJaq15ZbqVZPZ7NeJ53dw1Ubw7yuhlYmcBacbOtGOHKfGiELe?=
 =?us-ascii?Q?xT7BsSdiH7m8IzqZXzvDZavknYgOIOdosMV/bhaHYKvlUO5FBa4QKCkxjSR7?=
 =?us-ascii?Q?LuqERNiJ/w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f854b9-8dbf-44a8-6284-08da1e470afa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:10.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQV5tAcboHhY0063LVQDZ4MTWpVVasMxi1vHbvjx3vmGVzf/BwEyNQsTLyYG4RWg
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

To make it easier to read and change in following patches.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 271 ++++++++++++++++++++++++++----------------------
 1 file changed, 146 insertions(+), 125 deletions(-)

This is best viewed using 'git diff -b' to ignore the whitespace change.

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 8fcbc50221c2d2..a1167ab7a2246f 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -181,149 +181,170 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 	mutex_unlock(&kv->lock);
 }
 
-static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
+static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
 	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
-	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
 	struct fd f;
-	int32_t fd;
 	int ret;
 
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	vfio_group = kvm_vfio_group_get_external_user(f.file);
+	fdput(f);
+
+	if (IS_ERR(vfio_group))
+		return PTR_ERR(vfio_group);
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (kvg->vfio_group == vfio_group) {
+			ret = -EEXIST;
+			goto err_unlock;
+		}
+	}
+
+	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
+	if (!kvg) {
+		ret = -ENOMEM;
+		goto err_unlock;
+	}
+
+	list_add_tail(&kvg->node, &kv->group_list);
+	kvg->vfio_group = vfio_group;
+
+	kvm_arch_start_assignment(dev->kvm);
+
+	mutex_unlock(&kv->lock);
+
+	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
+	kvm_vfio_update_coherency(dev);
+
+	return 0;
+err_unlock:
+	mutex_unlock(&kv->lock);
+	kvm_vfio_group_put_external_user(vfio_group);
+	return ret;
+}
+
+static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_group *kvg;
+	struct fd f;
+	int ret;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	ret = -ENOENT;
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
+							f.file))
+			continue;
+
+		list_del(&kvg->node);
+		kvm_arch_end_assignment(dev->kvm);
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+#endif
+		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		kfree(kvg);
+		ret = 0;
+		break;
+	}
+
+	mutex_unlock(&kv->lock);
+
+	fdput(f);
+
+	kvm_vfio_update_coherency(dev);
+
+	return ret;
+}
+
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
+					void __user *arg)
+{
+	struct kvm_vfio_spapr_tce param;
+	struct kvm_vfio *kv = dev->private;
+	struct vfio_group *vfio_group;
+	struct kvm_vfio_group *kvg;
+	struct fd f;
+	struct iommu_group *grp;
+	int ret;
+
+	if (copy_from_user(&param, arg, sizeof(struct kvm_vfio_spapr_tce)))
+		return -EFAULT;
+
+	f = fdget(param.groupfd);
+	if (!f.file)
+		return -EBADF;
+
+	vfio_group = kvm_vfio_group_get_external_user(f.file);
+	fdput(f);
+
+	if (IS_ERR(vfio_group))
+		return PTR_ERR(vfio_group);
+
+	grp = kvm_vfio_group_get_iommu_group(vfio_group);
+	if (WARN_ON_ONCE(!grp)) {
+		ret = -EIO;
+		goto err_put_external;
+	}
+
+	ret = -ENOENT;
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (kvg->vfio_group != vfio_group)
+			continue;
+
+		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
+						       grp);
+		break;
+	}
+
+	mutex_unlock(&kv->lock);
+
+	iommu_group_put(grp);
+err_put_external:
+	kvm_vfio_group_put_external_user(vfio_group);
+	return ret;
+}
+#endif
+
+static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
+{
+	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
+	int32_t fd;
+
 	switch (attr) {
 	case KVM_DEV_VFIO_GROUP_ADD:
 		if (get_user(fd, argp))
 			return -EFAULT;
-
-		f = fdget(fd);
-		if (!f.file)
-			return -EBADF;
-
-		vfio_group = kvm_vfio_group_get_external_user(f.file);
-		fdput(f);
-
-		if (IS_ERR(vfio_group))
-			return PTR_ERR(vfio_group);
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (kvg->vfio_group == vfio_group) {
-				mutex_unlock(&kv->lock);
-				kvm_vfio_group_put_external_user(vfio_group);
-				return -EEXIST;
-			}
-		}
-
-		kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
-		if (!kvg) {
-			mutex_unlock(&kv->lock);
-			kvm_vfio_group_put_external_user(vfio_group);
-			return -ENOMEM;
-		}
-
-		list_add_tail(&kvg->node, &kv->group_list);
-		kvg->vfio_group = vfio_group;
-
-		kvm_arch_start_assignment(dev->kvm);
-
-		mutex_unlock(&kv->lock);
-
-		kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
-
-		kvm_vfio_update_coherency(dev);
-
-		return 0;
+		return kvm_vfio_group_add(dev, fd);
 
 	case KVM_DEV_VFIO_GROUP_DEL:
 		if (get_user(fd, argp))
 			return -EFAULT;
+		return kvm_vfio_group_del(dev, fd);
 
-		f = fdget(fd);
-		if (!f.file)
-			return -EBADF;
-
-		ret = -ENOENT;
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
-								f.file))
-				continue;
-
-			list_del(&kvg->node);
-			kvm_arch_end_assignment(dev->kvm);
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-			kvm_spapr_tce_release_vfio_group(dev->kvm,
-							 kvg->vfio_group);
+	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
+		return kvm_vfio_group_set_spapr_tce(dev, (void __user *)arg);
 #endif
-			kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
-			kvm_vfio_group_put_external_user(kvg->vfio_group);
-			kfree(kvg);
-			ret = 0;
-			break;
-		}
-
-		mutex_unlock(&kv->lock);
-
-		fdput(f);
-
-		kvm_vfio_update_coherency(dev);
-
-		return ret;
-
-#ifdef CONFIG_SPAPR_TCE_IOMMU
-	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: {
-		struct kvm_vfio_spapr_tce param;
-		struct kvm_vfio *kv = dev->private;
-		struct vfio_group *vfio_group;
-		struct kvm_vfio_group *kvg;
-		struct fd f;
-		struct iommu_group *grp;
-
-		if (copy_from_user(&param, (void __user *)arg,
-				sizeof(struct kvm_vfio_spapr_tce)))
-			return -EFAULT;
-
-		f = fdget(param.groupfd);
-		if (!f.file)
-			return -EBADF;
-
-		vfio_group = kvm_vfio_group_get_external_user(f.file);
-		fdput(f);
-
-		if (IS_ERR(vfio_group))
-			return PTR_ERR(vfio_group);
-
-		grp = kvm_vfio_group_get_iommu_group(vfio_group);
-		if (WARN_ON_ONCE(!grp)) {
-			kvm_vfio_group_put_external_user(vfio_group);
-			return -EIO;
-		}
-
-		ret = -ENOENT;
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (kvg->vfio_group != vfio_group)
-				continue;
-
-			ret = kvm_spapr_tce_attach_iommu_group(dev->kvm,
-					param.tablefd, grp);
-			break;
-		}
-
-		mutex_unlock(&kv->lock);
-
-		iommu_group_put(grp);
-		kvm_vfio_group_put_external_user(vfio_group);
-
-		return ret;
-	}
-#endif /* CONFIG_SPAPR_TCE_IOMMU */
 	}
 
 	return -ENXIO;
-- 
2.35.1

