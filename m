Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D66501B36
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiDNSsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241689AbiDNSsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0CDDB4A3
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcbMO4hIVmQYwrK/4YyD0ZgD6kOyzDivWDWzQJEJUGIo9sE9GKFfTlC1EayzoudhG6m96Gb9r6EpRLVdrmHzx5hs3mOESCuKHURZu+hA+u1VRVsclqO1L1lwcIgrmA7w7EDiq5JPxEeOnhTCU6d4dYEzq4YtcTXUw5wAHhlqLjVHoNeHZscfnf06YMov/4P4j9FhDLB5TZGca4rg3X8Ccs6Vlia2GRlz51B7jBgHoTsqDh+g2xu0oBzgqLN826uEiXrg4NIXGtg5cf25d4UQ7ZXuWdcTXxyX0QwYD728NckNkPUeeKIQbkahSraJSdb7UsA2+74Tkrn+9xBcHc6p1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGtSlZNRZeoDsrjCSeQUZLNLc/2rz2tha0i7ukvfd9I=;
 b=FUWRsOSjJKtnOW1TB38wH6sUJiALgmDRDgMtHAhHFpIiTpjmqrDbUaCjulLCXDHqqK6elz+jlm5DY4Ux27abWW4hK8jb7Nw7uQ4Qz5KFseSFn7r14zOUC4pZQWKQHxaLqaSdh4MwtOkBPyg5G10IJtf5zUHHpMsnk4c7oHZbf0xKc50HYspjtT7aK4aW7lyG4UYMZkK0UzmSDJdCitPsm0aqI/ZMZCFbumgTneJht/AsiyO80Lk7PjkkEqZhapmsOFsxJXsm3qrhkkpkI/XBfPtDWDkfdytTJ6Y0dVIroPMi0MeNrBbOvlg2AfXomfSFvGMW0cOIlPGSaKIMSAUrog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGtSlZNRZeoDsrjCSeQUZLNLc/2rz2tha0i7ukvfd9I=;
 b=GFv8Kh4TEHvU4/SFojX3FbzIuA7kqdqtIU8dEGHviWQIkMUWOCLj8G/4a91zokiBoxTYliZTPELabMJy4W3mIAotZmCjDoDLNZS3V4wauGgCjgYu6WXNAMPVFXC4enL34199QasbVYguUbV34YGxPlUPcZw4GKQYQxFN1PbyWOXUIgO4LGd/Zp/mdMqPdPyOF+TMpogP+FxsFv/aUD6IBLvjF1A3KicR5OWZeU94/LIyLU0Tw/BGuY8PAU3kRg3Fgc73wjMxozGael0uAhzKGbT+Zia7DxehFYDYVu9fLZipbn8i3MIXIjg6AcRzPqtKrVpgkQpA5J8GRKyQPE6x7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:11 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 03/10] kvm/vfio: Store the struct file in the kvm_vfio_group
Date:   Thu, 14 Apr 2022 15:46:02 -0300
Message-Id: <3-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a45cd342-6b5b-4686-afe9-08da1e470b08
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5350C200FEC077EC9F76ED42C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EwqP/qWP8EoGsY3jFFzasK0YZ1teLl1ajX9Vf1KGExnz1rr2PglzMiNX+nCjeSzluj8DlBQxLjfyOV5QEbom3Xx7iPqe8Pqsru435fdqA+bn1hIO2pOxC4xFeadx0k870kmHdLszReB/j6Oxb0qinuPz8LVcBskCYZeSj+ER3dsGPXZ3pIYusYKqKjrhBfWmyB1F4hQu/yF/qoU1D269SlAvm6lQdVLFw9hp+L0mBBaxINBXOpNkACLLxk7alnzDxRZ+qpOpV8PONCvNUPIJg4xU0KN904+jsvfHq+2iPS3FfN+O7E4qrIKm4LLYdszUE9QPgx9QnZlMYUSWxr6zRRG+MkemO2QGY63Owu4k7t4iq+xiHco30p+tuP7kTeHICb5ZQdDdQdBA17HoTL7GommTWlHDafyw+oQEikycpudVfdX90mshr4pf2Oy6vl/JGyj/q2Z3W6+9wkExnLSV9cfjV4pDv79KPQ1c3e4nTkPDoQJuxn6zLtF4GJzzoLmTzRLrkdVLjWK69l/MVUA/uiyGYOcy7iIy0iGKY65THH6VrRq1Mp18fwChjS58mDE1LMelDfD02r5hXSl8+PtDVhCaa7TGX7swmxEZ9i/AfEXK93fnMC5E7HjY8JNknwL2fu7LR1ytdHe47VGGj1+zqbNyEQU5tukpaDUrNa8lintNshdNgmWbR7TDuR7DmsuL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mTcFp2a1qhEhrqMudTarAw109ZLiM/RDIBq57DdxZI2NVmpzGMsAUu2iNXmK?=
 =?us-ascii?Q?QpKrurr+lhQi3HayKDR0CWp0fq1RN0S7/7qQxD5T/kATMn7yD3Oc8/6zVgiD?=
 =?us-ascii?Q?Lu8NSKmwdCcJ71h0LZyNNb85gX0pPEVkVnEIfJdQinDTW/j7Pt1OO6JIiRHi?=
 =?us-ascii?Q?PCWtvFcJwtO8Ja5MifKKKe/GTWwi5l3G3EcSWaSkEzTRqOrWbhVyGeiqGhfQ?=
 =?us-ascii?Q?Vd3zLit5UDf3aC4y+2hKis8bnJDw+2mDCpkw43XdJ/jyGjA1aZhwx/ywxdk9?=
 =?us-ascii?Q?lzLxrJwPkez/i7v1N7mANLbfiARCSjocrV3FYZo12yU9jRVrcg4f5oF/AUEb?=
 =?us-ascii?Q?7/mMslaNNvucSIaaGdzh0VRxq+gNO9ZCncEQb0OIq175VJVe6Zaua2SmfPcM?=
 =?us-ascii?Q?v4FXwD+piJeWvbAnYt15Bq3zGWLD0LWwwRa4DL0a6RpAezZv+kFwww1D6m5s?=
 =?us-ascii?Q?vTs2Gp/Ci4BtdjirnwHZE1iNGtGJsQnjuBY2Qlcypbquiic3p4sv9ELkwhrG?=
 =?us-ascii?Q?8k+mFbvIP+smOoss7SuKaSyooaJyObU3cyr0A0C2xWx+csy2at7H+w2djZEG?=
 =?us-ascii?Q?3+37wjky38OVYi6ah0sNUICK2vrGYGWDKkb5exPTl8tMTZkLVkfTJ2VnLOGg?=
 =?us-ascii?Q?oQbj8U1e8ABFkHdHIOLP/q1m3VK7n59TBtSbEpFTsaSaezU80wp0U6sdmvVR?=
 =?us-ascii?Q?iuMXgbNuSBtDbLOp/1VTxecy4rCyI0HGoDo/3HTzohVoT1ixY3PSuwY9Gl9C?=
 =?us-ascii?Q?7PMWP8KSROPZ9gsvUfd1Vyzj9ynoQxhJ1ii6GdE/uBMGoUpCWJK9pUJmtNqr?=
 =?us-ascii?Q?i3jXKSfgonpAFOse06WBxX46uinbX6vARWoQ7VeoBfBRjA8wNQcHj+1oRqGx?=
 =?us-ascii?Q?9Ke2yMpi4/HpHhpTbNPGhX2TZ+qjdzj0ZZJPiWeDIyJpsCAAILH9HFoG9pc2?=
 =?us-ascii?Q?waDcQ007jF8WgoKLzbZPRLmeeg538mUg+7knPH8OCWww8vNpVLKHtUV4w/k2?=
 =?us-ascii?Q?92rmFAE8/N3vqptECxWgAkrw/Ha12IXtjmXn+KvPrVQ+qyCoJxi4eqXM0lBq?=
 =?us-ascii?Q?LemDezJ8oqQP1vmrN4UPDyju3bbk42g4k/3L2YPPmuCdrnX+p8pBBO7UwYR+?=
 =?us-ascii?Q?y0cyo3G+QAu2y8K9yt544d3i/mc/5gc37Enydux/0zUPuUV8MH/G6GpbwsIO?=
 =?us-ascii?Q?jblHfsgbiSidnBbXN4KEvPTJwe5r2DgC9ciItTf8OJVHxA6UlN73fla3uRTt?=
 =?us-ascii?Q?fH4xG6E3eQpkEJSJb3MG10o9WsQ1xamtI3eV3Zz+mKKHhgKkju1IV2/DtZT/?=
 =?us-ascii?Q?4iwv/rd4kY4BDCNnzWz3VVg0lZW/ulDM9921s/cS4JkVRZPQ3Ruorcz9PPBJ?=
 =?us-ascii?Q?r26xXUaCDb8tlXk4cc/5WrisPwnLyfnvMgsje9fLcYreulzqzdyjFseyKuJr?=
 =?us-ascii?Q?nfPOYmzNY48DMWtZwWQKSA1EuUui6MRFClzAeITblfzfg3YEaTRVir0EQLGy?=
 =?us-ascii?Q?lO6hFSptpOingkQvyq+zAwkjWqmQc/S8HmTXnthlbM5543bF3QJ9sfThGqDJ?=
 =?us-ascii?Q?BxvSINVGHJxGIbCs+VCWUgxd3iW0UaLZsPs/QduL9yyHbVhkSWsfdRAsRM5c?=
 =?us-ascii?Q?eVNlvmtQgZth8Q1m5lL1wZYoH9JEOET9jp/SSQR9Bbk0H6MbJ8gZXcVOBYzz?=
 =?us-ascii?Q?r474SRAV0Yd/+Bj7+M78TrymRBRgn7/7erlucGvi1fi2aVlNiW1W4vfF0pO/?=
 =?us-ascii?Q?HG1D3daDfA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a45cd342-6b5b-4686-afe9-08da1e470b08
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:10.5163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4pVVpu2yaElKZF4msOOhLZPDiwWT4WOH3cmCQ2mVjFEMaSveitsShtrNFLb9hqe7
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

Following patches will chage the APIs to use the struct file as the handle
instead of the vfio_group, so hang on to a reference to it with the same
duration of as the vfio_group.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 9b942f447df79d..7e1793a1f5f1fd 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -33,6 +33,7 @@ static void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
 
 struct kvm_vfio_group {
 	struct list_head node;
+	struct file *filp;
 	struct vfio_group *vfio_group;
 };
 
@@ -198,23 +199,17 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
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
+		if (kvg->filp == filp) {
 			ret = -EEXIST;
 			goto err_unlock;
 		}
@@ -226,6 +221,13 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		goto err_unlock;
 	}
 
+	vfio_group = kvm_vfio_group_get_external_user(filp);
+	if (IS_ERR(vfio_group)) {
+		ret = PTR_ERR(vfio_group);
+		goto err_free;
+	}
+
+	kvg->filp = filp;
 	list_add_tail(&kvg->node, &kv->group_list);
 	kvg->vfio_group = vfio_group;
 
@@ -237,9 +239,11 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
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
 
@@ -268,6 +272,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		fput(kvg->filp);
 		kfree(kvg);
 		ret = 0;
 		break;
@@ -304,10 +309,10 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 		return -EBADF;
 
 	vfio_group = kvm_vfio_group_get_external_user(f.file);
-	fdput(f);
-
-	if (IS_ERR(vfio_group))
-		return PTR_ERR(vfio_group);
+	if (IS_ERR(vfio_group)) {
+		ret = PTR_ERR(vfio_group);
+		goto err_fdput;
+	}
 
 	grp = kvm_vfio_group_get_iommu_group(vfio_group);
 	if (WARN_ON_ONCE(!grp)) {
@@ -320,7 +325,7 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->vfio_group != vfio_group)
+		if (kvg->filp != f.file)
 			continue;
 
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
@@ -333,6 +338,8 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	iommu_group_put(grp);
 err_put_external:
 	kvm_vfio_group_put_external_user(vfio_group);
+err_fdput:
+	fdput(f);
 	return ret;
 }
 
@@ -400,6 +407,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		fput(kvg->filp);
 		list_del(&kvg->node);
 		kfree(kvg);
 		kvm_arch_end_assignment(dev->kvm);
-- 
2.35.1

