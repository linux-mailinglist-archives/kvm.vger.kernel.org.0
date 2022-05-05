Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6984F51CCA9
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 01:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386703AbiEEXZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 19:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343575AbiEEXZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 19:25:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089D5606D5
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 16:21:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aD023H2yo5R8WWc3rzDd0ofbd/TEcpPUgP/1sE6xRNpYmlgOnQ1N+Dcw7ReNfVpuh59awLukyOU9i8kyIDlvMn4vuqeWCOONPhJB8XeKHQGatIwWVSWg2V9S17r/yobOIQ+n8Wz9UZmey56k924SiopIcvreKgQFbSWJCuL3DttrpXQuhaGkM3zEd+amOkbjZeWYfkGpKf5UN+fyKkwB++SKLq2A3/2a4NqSGygOpnssvpslnOk+Z/iq1A1CIPmB59vSel+5pZmtNdoyWDEz/mF5aSVwUO61w+XIOUSLStVpkXS9+Jb8umZjFpPPVIPM0EJq7GJQ/ZYPt6mx7ze1ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztpQEA9EhRIuIFv5E+MIYd7F1uLogu75mWu4lIqo7qk=;
 b=LoKtO9+oEcxUcxXs/IfXLx9NZ1bfSwiC2tl8VZo9oToJsZ/J37gd9FZJn9GbbvRS0POAYTGIBM1QzqOxv8Q0RFGBVKZE3sR2/Pn3W2LE0/OUyAWrD2rSwUBlRp0yCzduiaSJ/wztr2oTb5XxlFbHcni4MmmDq7NSdu8oHa4ZnjwGM7iJlZjd0hf9BZ03jFtrW3nWvJRekHRiLQIUrC6HpSjCJWoAAWA+0hb77OwgMmbDLOjUF1Qtdr4DiK0C0FixoLEabdS/b+8GKrxqLCBNtwmcL4p30CNlnBCe9QjumFP5WYj3AgfUGTXl7UzsXLEENwahCwGw1WAOiOh9gFt4lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztpQEA9EhRIuIFv5E+MIYd7F1uLogu75mWu4lIqo7qk=;
 b=kSs4jbzXgYLSB1EIZmPqsgl7IMcx3zVBX1PjmAjGn6UJfb5sh9bZWUAo4Z9FYfGSYGSZzoRr3x/x3UL1jxX5Bt3/DinPKAktNqvuJurZT5uNzIgZiGrm5n60VnFOJAQeSGJ7JX1imjw0Pt3cFbRwFVjgtxP5LKdQopyUwYeZ5kji8pKLC7Ab5U4oi1SdvCqjcQgWPIkh25D1L31z5aur459tIVJUJQHNsEz9sbWOn+8K8nPHySY9r0HfGPsoUgUxhZXJLM7cSpCLqEhZ1SLhyNKc16WY4zdoMu7pafiJ5Vpk8VVVa+oayGOfe93OZN/0XmRggJRDoWJxuo2ovt3PaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3275.namprd12.prod.outlook.com (2603:10b6:5:185::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Thu, 5 May
 2022 23:21:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 23:21:42 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v4 2/2] vfio/pci: Remove vfio_device_get_from_dev()
Date:   Thu,  5 May 2022 20:21:40 -0300
Message-Id: <2-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
In-Reply-To: <0-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0412.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d31739e-3bc1-44d7-9d66-08da2eee0322
X-MS-TrafficTypeDiagnostic: DM6PR12MB3275:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB327512C813CF3224055449BFC2C29@DM6PR12MB3275.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgsHOjZ6rriir4plQpSrOo6i8rA5xpr34K/Zgn36pzjp4OF4REahuZv2XAIrQnugJQpsb8FZLick0Ke0bHm9i2EKeu/RzP/R7mh4lmI2kjMWAvfKKNRwuaqio9J7L0MGwKI9c7VW/Yh347ri7qf9O6oANvGrwAxRc530I1cd4uON5PMnFWl/tvEDdueziEiMxYEoYpUnG4chZXYePgaJSHViVT2GS0dK8eGcErwke1rECrDBpW+RjRBEQqeMTZJ/PmmdYdO5RFFhx1DlEKnZWrluuFfM7oHRjTLCGV7Gk+3PB9KkHtzLIDqLsH+dIXD6EwvIkoGTUf2tj5kJP3pspFg5VwK2iwk15ZtQEwLKPbDt6XOPlZKiUC9Qi2CyYcDmbKDQ36s3T/SAAzxtcssH2b4FmRp0JTI88B7kDU3dSeCocs0jwfYywAYu2tTahVdfMC78/11cb5oWG/MrVPY4+8QDDrKgmjjP7oMZcjq+1E4g8/hxFkP0c8lM65DXcpF0ro2gW5HOQuC7ekCM+X+ct77a2fdmc/Nf/ufcG1biKU2w8aJW5C8bl5Cn1aaH2AX5bxUDNZLLGbF6WDi5KNumHc/dMPyqlbV4cht5exZR/lUP3TlgsR339yPYN9BraqixKCguBaDmYBc0/kE9kh4eWEQjO96PA1HnM8VJGuphe8LG+ZxsNDaWN+XJLo9Hg/8UOV9Fz6eHM9+Cqv5+3ywdOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6512007)(6506007)(4326008)(66556008)(38100700002)(66476007)(26005)(8676002)(86362001)(508600001)(107886003)(110136005)(36756003)(5660300002)(2616005)(186003)(2906002)(54906003)(6636002)(6486002)(316002)(83380400001)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dA6zL5DJThhrNpqJbrcmawvnZJp2IQw7WRqvQjK9w8brfrvEFVhRfWqeIZty?=
 =?us-ascii?Q?p8NhdgfdsHVy2KFf6epQMu70GrSxDcPSVO4vMflWsLMuVZzyN9lmHk9jSTCh?=
 =?us-ascii?Q?vn/kS/9Pg/kE+tjE7Yank/1v3/aQiEefggrZHEGaUAkDc56CoodtU/I4ikdf?=
 =?us-ascii?Q?OPCeVNY8TZSwhRes6L41Vh3lk5oyI2dbvxa+QD/2aDl65Qjb9IXOuycKV3nF?=
 =?us-ascii?Q?ID1bLo946n7KWR/rFQpAEfv4EZpdyPqHlHR5szO3TMJBsLPPzZiZSjgs2wEW?=
 =?us-ascii?Q?l8GMNygCAMeVp/sD9sDjat1vio8yOOsLmnXueS9uCRivvN+MZs5QL7q+IKJi?=
 =?us-ascii?Q?fDe0s9hLTOwtdCsuVBcjcdXOSWWtJg2niQVufbblsb2XADRJ/NeUxxlnQ41b?=
 =?us-ascii?Q?KMPLGEH9MUrt0h5qjDTSSYyt14JRaV1/244Wxf7EFYWWCPlzu0veFuQYdtEy?=
 =?us-ascii?Q?Ewg7XE8IyiZZdB2jRxWsTrN5Upuwlv1ayulIT/Jv7qG6i3dvP78HDxKIyXtq?=
 =?us-ascii?Q?NZhFHd5k5vZgI2lKSo7Zme5QFeB/Ckpt/49DOQS+nhxscVzbxSytZJBsWJcl?=
 =?us-ascii?Q?6a5d3L6vY0eeiwcwN3y4DHmfFhIzZo8B6VG3D7Cby3jm6sWW7XQ/c8Yea1Gd?=
 =?us-ascii?Q?myK00DpEOnMIgLeWXX2K8z6iy0RMI9W4yqBwu3NI5AxikNB4s8DvIgmK8PGL?=
 =?us-ascii?Q?65Dl6Uk81bV9jcTwxFNa6wekXNMVxeqMvmY+H6ikCh0IVnKJHEL07Jb8BXeG?=
 =?us-ascii?Q?2ylyFO56blbpO6rATi2vCWLJO5fDZQCqz/1Yvk9EwgQmHptDhoZhCxv4bC6/?=
 =?us-ascii?Q?tBVLZs4eiBrMFaEfJfcifnZ/obEQiGfS2Hfp5ZD1lABOOk76rjIIlNSS+Up7?=
 =?us-ascii?Q?7t5nynSBlwHMUz3wjn3e8+UnvtTHMPThmL2icrGkhUavK+iM+QokU2KjZPAt?=
 =?us-ascii?Q?5aHq5vxPYW+/EuEavJmaCVUsBUw+RJt2QbsUpSCknZhq0ONTkE690eVmJP1q?=
 =?us-ascii?Q?Rwr2xkkm1yF38EksjMA7UWIyeqzeHhMxK2PfTzsi2CSeibF5nyvoTGaIdPpK?=
 =?us-ascii?Q?cTiTXl2gGT2caxZUnkVr7ffh45pVK1PO/uB/luU04wvKKzetFJrm2Hx5p0vS?=
 =?us-ascii?Q?X0S7fLnIAV3jJTsNyyJwp7yBXP4a7MlRAZkqFY/n/YvAXn882nIYwkWIkb8G?=
 =?us-ascii?Q?8IEwERQJWwM5gnWWX+/L0NDr/hv8thP93cgowY8eP16bVCXbq++7zmfrjwLP?=
 =?us-ascii?Q?TXc6Mp06WETWQytwvSd8x/0gp4T/Mxg0AtSd6JZMA4qhNdktPg84llqN5noq?=
 =?us-ascii?Q?zWAI9B2ncbj1qFQBslQ1SrFUkK8DESBrys4kZKoeI5xecISEBXKyOFZM8FEm?=
 =?us-ascii?Q?qLe7LJemkM9lOg06cgf1qKIxxtvHB39T1ZENB4SlquNvKhQ/LUBbb0hMeus1?=
 =?us-ascii?Q?8qzuwvYPY4z2bBwoCVg1oEw0JOevOdcdKmGqSBnbzhrji3c4aSLoLXQCkb0C?=
 =?us-ascii?Q?M1upvNVDIlExdlSI4L68DSQ3qdICFuO08TbIVakAqgU+Eko40iANovTYz5e1?=
 =?us-ascii?Q?EoF6+zxtGyCfiX3NX1koVdEno+YWeOTtHKtfGFqwu9HCqp0U2T44ajZyIDiJ?=
 =?us-ascii?Q?8bcbHGlTEMZCJnh7IqyeQh0IkfTv/9ePjI/KihglWDl91Nzrlu5wmd9lTj76?=
 =?us-ascii?Q?V360NeGA0usrda4OUVeqwCAiRW6ZscXgoJc4RvJrSUC2sIg9HnzOaNykH+HI?=
 =?us-ascii?Q?xx12XWwjKg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d31739e-3bc1-44d7-9d66-08da2eee0322
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 23:21:41.8227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tr0wz6yNS8CzAa3xC1snqjO+jYot/CVBQbAlf4t6Szfnwek4NwW4ciSK6PEJDWkQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3275
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
 drivers/vfio/pci/vfio_pci_core.c | 32 +++++--------------------
 drivers/vfio/vfio.c              | 41 +-------------------------------
 include/linux/vfio.h             |  2 --
 include/linux/vfio_pci_core.h    |  3 ++-
 5 files changed, 12 insertions(+), 70 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e34db35b8d61a1..4d1a97415a27bf 100644
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
index 65587fd5c021bb..100ab98c7ff021 100644
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
index f7d1898129ad1c..fcff23fd256a67 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -444,31 +444,15 @@ static void vfio_group_get(struct vfio_group *group)
 	refcount_inc(&group->users);
 }
 
-static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
-{
-	struct iommu_group *iommu_group;
-	struct vfio_group *group;
-
-	iommu_group = iommu_group_get(dev);
-	if (!iommu_group)
-		return NULL;
-
-	group = vfio_group_get_from_iommu(iommu_group);
-	iommu_group_put(iommu_group);
-
-	return group;
-}
-
 /*
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
@@ -633,29 +617,6 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device)
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
index 9a9981c2622896..de8dd31b0639b0 100644
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

