Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC4B51AD6B
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377444AbiEDTFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376492AbiEDTFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:05:31 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2089.outbound.protection.outlook.com [40.107.212.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F6B2DD71
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:01:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVOpCBFy1rZ52ePBB/0intbTl5epztRZzl7Z70euQpHEQgy9gE8C4bonJuSPgOja7tX7m4/QbXoDxDpolLOkspmfGeLXffDSctZ3E2yudQL3fy5+iNAUxwXYKwLekabwWvgEQ0U7zP0c1VZ+1RyxDPDCFFN0GcK4ULDAZCtJlN0NE4ph2iP4NLhUga6AITQa8aP9vCI+i6oAdK+x8ZdHwgqWonlJvaVr1j9gUXGA0MNqUc2vNR0b0qI8efHWtcLAAvdclnXH5baSVvYC04nT0tb6cr1ko9h+r+C6/lTKPkInYWc+FyuOM1oHJaRcf4vVJmAgzV6Y8M9kjbFPNIk4wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iZJnbIArUEmLZCCbNFzAM4qdQDXFkcCx+jKv1E8m3c=;
 b=VAkWpZlohFVu5hsjtsmcPN25mI4JiyyQwcymzVU6O881K14+JYCUaTc+YDo4t7/0AaqASZbMDmGXYDMEAA4dZOCQI8rAUWmAJ6+uuyR+w0Pld6JCr+SifwPGHcQjO8Svq6kQT5A4x1b6+vOfYz5s4UtKNUlQbyJyZOpVhedbUvHBcnFvasawFFZLb/ZRSaVUhNWa1fjY15VsWoBxwTBiDWtHS+BEjc3VI5ttfyEXy4QaDvQxHrerm90sW+8MnWHIHQvqh9MmGIB25QM/NwSPfyVv7t56j3yhl28uV4Z/0GGgl/xDWjsA7z3qUN4DN3nJYTOL512+zBuyg1AOZ9qOCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iZJnbIArUEmLZCCbNFzAM4qdQDXFkcCx+jKv1E8m3c=;
 b=aTfQsQ0pN2DV57xLPNZpE1X6X1k5mKYOjpAAYivld3F56jG80BLqt7+CmWpN+siZ8TvJgbCWoQxePkcBJhZ2qIGURgS9XLIocELfV7khGJA4hOMy4CSkW9xnY3OwAlH8ogYGSGymRKAqNuAhjgOA1/6fBrUNXA9YHoxUoBon11a9FtJWKmF/5TKJHyLggpMQa+dTijGX/eaG698JwpH9c66bgBOeq5v8r7Xk7tn+0LqxDakhaVzdr9QK/g9CowYA9o2co+VhkFwfj0xvKP+d7S9W62Lt27q6oNzTWAGeu1zDTBet3zLYBwvgvWosgB/0JQMIS14eg0EE3gQW+4gtbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 19:01:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:01:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v3 2/2] vfio/pci: Remove vfio_device_get_from_dev()
Date:   Wed,  4 May 2022 16:01:48 -0300
Message-Id: <2-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
In-Reply-To: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0009.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80e80fe1-a51a-46d0-aaf5-08da2e008b49
X-MS-TrafficTypeDiagnostic: MN2PR12MB4270:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4270085934C9CDC443267BF3C2C39@MN2PR12MB4270.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nGaWFpZWyaAvSGSCTVJlX6opV6IsxtwxDl9PdZNyZBLcNQDYqtfTtLqrdd2gvJ5EQK0Ls0PzU+8aBlnfFSZI30Resiyum1JjLa5te/Fh/hOubBF57b1s5oMHmNU7UYP4HZYbVrDlqL9H+x411g5GInGUTzg6LfzY4xELCov/IMOdr2M8KtnSYaQ/H+j6vWnJtgbP7bXLb3Yse64VhhOlVNl7kdoWxj6T4r+NqyN4qMAqslCtj1a7sakNaGDsy1NSDVJqyzGRch4Foj+kfF09a01aTQKOXEvs8iNSh3mtO0Iq/ii/kUMM7CDdi93HeSOy2OcynU4xRMaiqZP/D+oRAMDg0TqFV2DldR1EWiXYLBV0D+W2nWxYGLqlh7z4mw6yblvO65o7d/gOabDN5zFrnBzwP/189m8QjNAGvZ/Pmxf8OvHwCXOT2iBb2w3Q5K8eq93WusygsfmzRGIC/AY88uCvGzp1claDGJmbwGZJGvOQUS3pSKmNKfdT6z9OITvnj5qTsB/BVb7fgp54yD2Q1FcGBFmFD38V+2l/ixhnajeR/FBrOHnd6QxPaSQr+zwfXq5FiC7xuRBdAVxjePZbjxky1EPD2JwxLsYIvgembWTqEkYa0adYPxS7bELpHKKoHG8rXwJDFF8r5eUoyhhlj1tEA7Lm/GGvmj6hOnJ/VA1S/rB+dKhtYIfYaiGIVp/my8HLVVDcfDEUZjx94IMnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(36756003)(6506007)(8676002)(508600001)(6486002)(26005)(38100700002)(66946007)(4326008)(6512007)(66476007)(66556008)(86362001)(107886003)(8936002)(316002)(5660300002)(186003)(6636002)(110136005)(83380400001)(2616005)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z5ZmKJlGzPwtjsIJKh1BLaLU+OFCUms8tqcxWJ8tIQ0+gYTFfMMBIQS3capp?=
 =?us-ascii?Q?wVSg7H80M4N0MwplORRqGB/+Y3cmFANwuEnIL83W17PWhxS3vDDqfLwPKLXB?=
 =?us-ascii?Q?KOfbFVZJcScSZDvJZYRtG7MEHe2pumZHBUlI9d5YRX+r4HyHUY3aRt0quk+8?=
 =?us-ascii?Q?LbgFqk6QvBdrRmfA5LzroHJeEmYgdG5pgpm960BRc//dQ+O0JDt6FZyDs+tc?=
 =?us-ascii?Q?CPcoZJ4XwsDzSjJmy6T3vLg+QHSkOrTBLNfV+SBRD1UTQ9kradX0O3tgnSyy?=
 =?us-ascii?Q?FY0ZWQtXXS1CFMYILk5gN4sOwZWA7Aq4/eDtTtmPAxotTZErIzF4CDLaVy3/?=
 =?us-ascii?Q?JK8KDuZhygqI2p995fq5yIjst/54RW+Wv7ugbdxcsgD1OWVaZOvNf6LMFdMT?=
 =?us-ascii?Q?878hSsCKorjHRYVa9HCuj4qzQQd2uGnfWZRDdf/YOwc2KKGao+sxMll0BzHq?=
 =?us-ascii?Q?ZwzA9trXM3SAIqdq4ZXRXPFmaz1eVDO2g3+KtdrgUBdnq0k9GdieoKEfyz5G?=
 =?us-ascii?Q?pgPtdpUfBFbw1mVRsQKK0YjcpAR1yeXKDD+QcEkjyzReLZSEorvChwhAt6/S?=
 =?us-ascii?Q?KdkrW9aGkvnbLof8OCEej4jV2wR/s+Sb/LeCyIzi+SwC8dQISFo9V0pDPip2?=
 =?us-ascii?Q?SYL8vBNI254ozHlYr/rK1xJWKcNry0/qXnNIphfsyhXTdfE0++rC34AXQHeQ?=
 =?us-ascii?Q?kcxQfJ3eDkCduCrk2aZ4MdZMIs9UO3KYFERCkHgiaQ+geU72dD88Olg0G8iH?=
 =?us-ascii?Q?CaVpunEsE61b9dpWot9ERyChLlgyrZRAlllUIvQB9T4qlW+YbKDDkrYiHphp?=
 =?us-ascii?Q?O1QbH7dTlqoMv5uF/BfnOhFaEX5yyl6ELdesUDdh2u/U3jDYRC8/jjt9YyBO?=
 =?us-ascii?Q?jPAC1AC8Mzk8LcGkBquUOx0bi/hIvVAg5EKy0x91ZFuQY9OAtoVQ2UspyEPE?=
 =?us-ascii?Q?8cNJTtVFXenrbyi12cwWk4fHTLC78T+dHguNHs2TcYD+EXVjzQIbz6rTTmvf?=
 =?us-ascii?Q?hMHc28j7pat6ttYeNUmmQB629atcmA21G+n8Ol95pCOLEsgQqdD8G0SZswBe?=
 =?us-ascii?Q?9bOEbBXzCrG+MsUpSzjOF6KJlmYSc23sv9uXHzijCe5lIOJg8pObLTLlR2Rl?=
 =?us-ascii?Q?+G8hf6UqLneiVIABMFJIl1FGd7gu4Tr8Jc3KAMghUTo87DdEWiDTv8GURqV3?=
 =?us-ascii?Q?4xXUoZmhlxxAB+6mvTFTzGiSciULPpNfsMw7BlC8CSGCF6rs12yeRGE1+Dc/?=
 =?us-ascii?Q?88Z60S7WYQ9pp/eAJ9vJiPQzYg0wgHcI6q99PL+oiZ2iGvN15yhYcOKBE+AG?=
 =?us-ascii?Q?lN0VzMFIeXQRA89IeQBCpHPr1E2Nwz/WaGSMO0mDwyVAb5sKJDM2+a+v437X?=
 =?us-ascii?Q?ZK0N1b3zYK8lWcYAuvIpSeo+0NJeTQG4B2WzoL8Em1pXmxzrnzFMi1fojJV/?=
 =?us-ascii?Q?k6nn/P60gunyJysVla4VTK/YhbqpX4ZiumUNFIZ994VCBD9ybQtlhPd3HZgV?=
 =?us-ascii?Q?TjUqKRaCzYk+4sVdYOLX6MkqfiaCOD9jkm+LBIeKbipku6ymY1xzW1iMoc+f?=
 =?us-ascii?Q?rWz9JHMrQ1WtPnR8b9LZxfqHNY91ZJbLiTdgXaBu2QKOcL/N59JAu41Z4zyN?=
 =?us-ascii?Q?oy7aT4gLqZZwEUSAIpGQ68dFurmb1B5N9tjeZRbN/D3NGpuzBhRbz2zHxt/i?=
 =?us-ascii?Q?thNLiJxxf8HG6uQNhSszrw/UA+gdhYF4ZDoGLH5JWEyiZGUcrO57h00o26WS?=
 =?us-ascii?Q?Tr53oY+Zrg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e80fe1-a51a-46d0-aaf5-08da2e008b49
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:01:50.2303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNVjMRdL2DrHElKPCvRONxbDdtNlKKerGfRVShd56OE6Wddqypusg029yP/TAWBy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The last user of this function is in PCI callbacks that want to convert
their struct pci_dev to a vfio_device. Instead of searching use the
vfio_device available trivially through the drvdata.

When a callback in the device_driver is called, the caller must hold the
device_lock() on dev. The purpose of the device_lock is to prevent
remove() from being called (see __device_release_driver), and allow the
driver to safely interact with its drvdata without races.

The PCI core correctly follows this and holds the device_lock() when
calling error_detected (see report_error_detected) and
sriov_configure (see sriov_numvfs_store).

Further, since the drvdata holds a positive refcount on the vfio_device
any access of the drvdata, under the device_lock(), from a driver callback
needs no further protection or refcounting.

Thus the remark in the vfio_device_get_from_dev() comment does not apply
here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
remove callbacks under the device_lock() and cannot race with the
remaining callers.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      |  4 +++-
 drivers/vfio/pci/vfio_pci_core.c | 32 ++++++--------------------------
 drivers/vfio/vfio.c              | 26 +-------------------------
 include/linux/vfio.h             |  2 --
 include/linux/vfio_pci_core.h    |  3 ++-
 5 files changed, 12 insertions(+), 55 deletions(-)

The only change here is that vfio_pci_core_aer_err_detected() now calls
drvdata intead of taking the right type in, and the origin aer ops struct is
retained.

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2b047469e02fee..ba60195cefb302 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -174,10 +174,12 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 
 static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
 	if (!enable_sriov)
 		return -ENOENT;
 
-	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
+	return vfio_pci_core_sriov_configure(vdev, nr_virtfn);
 }
 
 static const struct pci_device_id vfio_pci_table[] = {
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 53ad39d617653d..728756d0a6fd87 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1894,9 +1894,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
-	struct pci_dev *pdev = vdev->pdev;
-
-	vfio_pci_core_sriov_configure(pdev, 0);
+	vfio_pci_core_sriov_configure(vdev, 0);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
@@ -1911,14 +1909,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state)
 {
-	struct vfio_pci_core_device *vdev;
-	struct vfio_device *device;
-
-	device = vfio_device_get_from_dev(&pdev->dev);
-	if (device == NULL)
-		return PCI_ERS_RESULT_DISCONNECT;
-
-	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
 
 	mutex_lock(&vdev->igate);
 
@@ -1927,26 +1918,18 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 
 	mutex_unlock(&vdev->igate);
 
-	vfio_device_put(device);
-
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
-int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
+				  int nr_virtfn)
 {
-	struct vfio_pci_core_device *vdev;
-	struct vfio_device *device;
+	struct pci_dev *pdev = vdev->pdev;
 	int ret = 0;
 
 	device_lock_assert(&pdev->dev);
 
-	device = vfio_device_get_from_dev(&pdev->dev);
-	if (!device)
-		return -ENODEV;
-
-	vdev = container_of(device, struct vfio_pci_core_device, vdev);
-
 	if (nr_virtfn) {
 		mutex_lock(&vfio_pci_sriov_pfs_mutex);
 		/*
@@ -1964,8 +1947,7 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 		ret = pci_enable_sriov(pdev, nr_virtfn);
 		if (ret)
 			goto out_del;
-		ret = nr_virtfn;
-		goto out_put;
+		return nr_virtfn;
 	}
 
 	pci_disable_sriov(pdev);
@@ -1975,8 +1957,6 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	list_del_init(&vdev->sriov_pfs_item);
 out_unlock:
 	mutex_unlock(&vfio_pci_sriov_pfs_mutex);
-out_put:
-	vfio_device_put(device);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a4555014bd1e72..74e4197105904e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -492,12 +492,11 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
  * Device objects - create, release, get, put, search
  */
 /* Device reference always implies a group reference */
-void vfio_device_put(struct vfio_device *device)
+static void vfio_device_put(struct vfio_device *device)
 {
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
-EXPORT_SYMBOL_GPL(vfio_device_put);
 
 static bool vfio_device_try_get(struct vfio_device *device)
 {
@@ -831,29 +830,6 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
 
-/*
- * Get a reference to the vfio_device for a device.  Even if the
- * caller thinks they own the device, they could be racing with a
- * release call path, so we can't trust drvdata for the shortcut.
- * Go the long way around, from the iommu_group to the vfio_group
- * to the vfio_device.
- */
-struct vfio_device *vfio_device_get_from_dev(struct device *dev)
-{
-	struct vfio_group *group;
-	struct vfio_device *device;
-
-	group = vfio_group_get_from_dev(dev);
-	if (!group)
-		return NULL;
-
-	device = vfio_group_get_device(group, dev);
-	vfio_group_put(group);
-
-	return device;
-}
-EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
-
 static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 						     char *buf)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 66dda06ec42d1b..ae06731d947bf7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -125,8 +125,6 @@ void vfio_uninit_group_dev(struct vfio_device *device);
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
-extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
-extern void vfio_device_put(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 48f2dd3c568c83..23c176d4b073f1 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -227,8 +227,9 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
-int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
 extern const struct pci_error_handlers vfio_pci_core_err_handlers;
+int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
+				  int nr_virtfn);
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
-- 
2.36.0

