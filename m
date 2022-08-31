Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7055A8767
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiHaUQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiHaUQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:14 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378E8DF644
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdaYmx1aaZb8rnFC8ZbWvzWbPZ1fa0pV8Crk0MNi72is6e9FcC7Mg2EyzpmbTXPMi/Y9GWBFc9mcUXb61Pwhh/8nwub1rxIVsH5+6IaXl/xcJOob3PzZIcVkbNsUXYEyHHwJHJu9Shi/kbwAZd3vqxY1v3VO5wpAPR1qRwr67v2t2lBirV/lNwQCu8xpdScaKExJyMmJJ+J+/dmTlatn42cieSUPievC6xfdU+z1b049/nxGzjhvlYxXkVQBh0pdcYxYWzcvlRrzSQX9XR3IyqL/KcwD0K/LWLF7zYwtal+j62+7SeeXt0rx2TLQnmh6/F5Y5s4Pi2qXxKstNNfqHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAXRTta4yu96SV53XsXWJo5tW6VYfzxGUdSfkRYNUXc=;
 b=nCK6x/NhmEQpz1x5j1qgfJMnc4BTdNMdO0E+RO62h4W/iDPttym/x7Sy13G2iQv6goIAXYKdKrE8e6XS8q94QOiTFDzEE7yStJ7WYnGFrRoarDQbkyH/Rgl4ux+RKyhocGdqeeBlUZhEAsUj5ZmkZVHJDsa7eNmNyDZuna0tcU1ddnKZnGJkk917sXsQnCIw4BOVCyvo+x0mExM5qTPcTKjcAlLNvdpYSSqhAFD+NaI7e58+F3EuGn6ivhxA8jLlQcUGQQ5+f7hOetGHViuEPshRvz6irGGsOL3ugUc1nbD4skrc9RM30IjkRfUNJSKl66pOIN9gpCV7LVgyikI3WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAXRTta4yu96SV53XsXWJo5tW6VYfzxGUdSfkRYNUXc=;
 b=o4u/4GvQ3qDngXS9lt0MZX/H/KIkdUcpQo/lu6QajHQyXovZg7CwUJnU8JWrkySqULgjCNZyanB4BhwJcgUmf6EkIly2EEW0LNNHiurBhoJMO9/zZZdJon2t9cYWRD7RV1UbqHSv6VTxJOXKbQBej8ZNgluyarofZ5WbvO544V4yNb+9reelorDLn8bVeG0MtZoYqGCyfzuKCjFODMvp10ujFywNzY2+nYxADX3elG58JByLTw/H5ZTwWr05UJYOeynQ7C+3Qlx7XvqGwF93LiANL/N+w1ZKbMo0JkNTlPNGwPlSbUYd+NVo7J0d1plRr1Go1OKw+6zdRwmX42bn3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:09 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 2/8] vfio-pci: Break up vfio_pci_core_ioctl() into one function per ioctl
Date:   Wed, 31 Aug 2022 17:15:57 -0300
Message-Id: <2-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0103.namprd05.prod.outlook.com
 (2603:10b6:803:42::20) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d3946b2-df96-4658-3c52-08da8b8da26d
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XccnJn2UIA7mYLm+WO6aMOxi6DeVpilaAWJX92MY98lDibB8tNYxGRpQ9PK9OA8fVFAFQpnWw8iXFpKo4nANjBWmPF9opdwezu3ZnZD2w2lP1HeJ9QM0FpzeEYW7CkK5nK5E4BrEOPXk7UD6BoF1Gtd7LVfSlgLvfvgEUSI4oMIk+npUDK7ILuG78NRL3NqN7KLHfCIeeYl+69gtDBvoEu73tkOK6z41u6S5wOdmo24lfKaTbXqwo5IRb1Nu++IyW1xzl2UjJr0VH/JMM0dW9H4d3QfJiQN5wt3Uf+O17wQLqvyXcjLSOeYBGWpFCsalo4j8TvcLGSpQg2fs8rmjMz9E9+I8FX+v1VBtsmnN0rhmXN6Fq5N33XBuEHZ3ujnik8Qx46UVIyLFYKE8uwbeLC8pS89O6a5Tq/rcefC6RdU09lVlq1bQ6EbkdrM2owCyIuk6FY+m+tCPT8eFVIsbGrMNoif9S4A0CS5fuoi3dGS0NFLetZFx9QhznOYrY8F6WABrl+/nqRTce0sHBEvmdWbUe4s0HvUDM5WxGP4oxvywQywYUoarAQcFxCttd97dYo+3yqXXKX6wC1Py8OOl9JV1b0AZzCsYXoVHIHzMokJb2g14YRBHiysVb/9oPxWEWaJHlZzTV1VnXfRR7nH3DscODLzA4DXqMkYxlOUM2y4QufR6maC8NFiAiIaJcI3PMcGNpcyWQ125ZOPOk1tIqAT4zOVY/N4KLYrlAgl4iYe4vm6hswxYh2FI3nxyfSzI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gJVn3u1q3Wkv6GMV9advlASYA5b7fTB/Gc1FufWl5B1TggVaEoJMDvkkG4zr?=
 =?us-ascii?Q?wPBzRz1McDUl5NSHKfsWu7GyFUrZGdDWk1JlIEwaEOQJ0gJeoqYRwzSG3lWj?=
 =?us-ascii?Q?Ib0URctsd2tCwjcRZKUBZXnFTrRZDmOxZxa7yWU7RmiFSRh4jFVN6QWxvUU5?=
 =?us-ascii?Q?Y/dhHrXL1FIspzKM+hHX2QTMOv6d/+JtyDu9buV24MmXgGK/aLNO7zTsbcj/?=
 =?us-ascii?Q?VqMPA7Jys/KTL8OaMdT8cqgfoVLkGuuYLnSSMRxhgRUrrcs/UhkRtPse/J3D?=
 =?us-ascii?Q?/Nj1lE2wZUcG998h7SWBy44Vc4OvzyF77CSw2bOC5DOQWMYJhPiBCmKs3P1I?=
 =?us-ascii?Q?b+VKOWw2ItAhy/pXSxGfZuSt1SRZgZ1vNfyONJVUaKu3pTMtWoVG3TYaeWG+?=
 =?us-ascii?Q?K2wf0YOAUHmFKtzGjoO5LJT3tFVdFRd5ngskMAbZiwOqTvgV9UBSshZgQiY5?=
 =?us-ascii?Q?2JD5s3NiX/c/UYfs4cI0/GWuQw9SQDLIU0B0WYV20qWB1r96ZzIVPUXZ2SOz?=
 =?us-ascii?Q?DJjIibw4GCPQJKVs3KApUJdvV8TLShufbbPtwOjClyGwU4V5JzxuBoNT6kcV?=
 =?us-ascii?Q?l/FCbrHo2Z77MgHrdGfWjSdwfauHViEgONh2G0iLgZoWUyhqUDnscEWN3Mez?=
 =?us-ascii?Q?yRWq8Gh19NVptPsN5CIp+4IQVHQLbRXz106Fz5YQBZcfRtsvWyf6DVxMGGlA?=
 =?us-ascii?Q?7v9e+9+NgonWzDc1A5FjK61WAp/8PzHv2Tf4p0IxCPerafX2mxGSWFN8XLPm?=
 =?us-ascii?Q?72qocTyJGsPwdd6Puz7lFFmUscMI6KBiqAG5SyJLpoj/+J+4QTPDyW0ipju/?=
 =?us-ascii?Q?EuKEeDrGdaqpwgMze8BEOEQlA+whLlMqDfhuj16d4fvyTEC7cSag66QRZjGs?=
 =?us-ascii?Q?vaw0OZpO1OvQewOhanFO0Kjc/VD4ggLQvT5gPvnvNDOeEy0dN0bSLG4WCj8p?=
 =?us-ascii?Q?N9U2IDERyEzVYEpTKdConfa2/8HVsIkUQFwopu1TDK5wdurJ4uq5Yd65RWI/?=
 =?us-ascii?Q?W+Z7YwEuvhy3sIndtEPPZUsLMfAxyvOA5SqfJIoVJZZDbAfqnz/ogBJGYgCY?=
 =?us-ascii?Q?V4Fb4orI81WTa5mJsltbAaK4oN63Jf38d4RRSgHF/uV1t+w/Ou/HTeWt17Jq?=
 =?us-ascii?Q?EsuM0TCZZtG9OAk1rGqOpjKqimMC6YihOG+4Ut6+cZM3K75pNLWsTEHTfw5m?=
 =?us-ascii?Q?rxLWcCg83sceoRuih1rv6MY/+JJFbL3ba6iI2EdSFCREHJtHE6LkDl55yCEQ?=
 =?us-ascii?Q?uwx0P9hgqFoyPp7kYDUFPGTq4t1ZYygLYkZlXK+8+WPkb3TLXw93u2eU5lfY?=
 =?us-ascii?Q?G2YnGWkl4fGvaLc1Jd145sNcJWz3SiyRwInuYtGl8IyVLPpBD1OZ9EeRnf2P?=
 =?us-ascii?Q?CKNs9rX+kQVm2qDw5YZQ30WpBIKj16LJ2ucnFSfUtgVajZlKkr6c4NTUFIoN?=
 =?us-ascii?Q?wHH1UfxN8S9c8Pys1+DDZKftoe3eEaIu9rc0vtrNFz9EB07CczgTGl1J49zF?=
 =?us-ascii?Q?BNpgK52hc66WdP4k4lEYXp43MwvxwCfKmMVA3cyCHyHLXNLMNeySGTthXMZA?=
 =?us-ascii?Q?yIbEF7d1fApJ7KddeaQR5U3c8nFJLvt039AyeUiV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3946b2-df96-4658-3c52-08da8b8da26d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:06.0251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiH+W44ecXDNpH5M9i8V0ww6TmLBniRxk52hajtYXlEw8yGSxBG6pUrHLS45SAFN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

500 lines is a bit long for a single function, move the bodies of each
ioctl into separate functions and leave behind a switch statement to
dispatch them. This patch just adds the function declarations and does not
fix the indenting. The next patch will restore the indenting.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 97 ++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 84279b6941bc2a..85b9720e77d284 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -689,21 +689,15 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
 
-long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
-		unsigned long arg)
+static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
+				   void __user *arg)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(core_vdev, struct vfio_pci_core_device, vdev);
-	unsigned long minsz;
-
-	if (cmd == VFIO_DEVICE_GET_INFO) {
+	unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
 		struct vfio_device_info info;
 		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
 		unsigned long capsz;
 		int ret;
 
-		minsz = offsetofend(struct vfio_device_info, num_irqs);
-
 		/* For backward compatibility, cannot require this */
 		capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
 
@@ -752,15 +746,17 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
+}
 
-	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
+					  void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
 		struct pci_dev *pdev = vdev->pdev;
 		struct vfio_region_info info;
 		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
 		int i, ret;
 
-		minsz = offsetofend(struct vfio_region_info, offset);
-
 		if (copy_from_user(&info, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -897,12 +893,14 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
+}
 
-	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
+static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
+				       void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
 		struct vfio_irq_info info;
 
-		minsz = offsetofend(struct vfio_irq_info, count);
-
 		if (copy_from_user(&info, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -933,15 +931,17 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
+}
 
-	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
+static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
+				   void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
 		struct vfio_irq_set hdr;
 		u8 *data = NULL;
 		int max, ret = 0;
 		size_t data_size = 0;
 
-		minsz = offsetofend(struct vfio_irq_set, count);
-
 		if (copy_from_user(&hdr, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -968,8 +968,11 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		kfree(data);
 
 		return ret;
+}
 
-	} else if (cmd == VFIO_DEVICE_RESET) {
+static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
+				void __user *arg)
+{
 		int ret;
 
 		if (!vdev->reset_works)
@@ -993,16 +996,20 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		up_write(&vdev->memory_lock);
 
 		return ret;
+}
 
-	} else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
+static int
+vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
+				      void __user *arg)
+{
+	unsigned long minsz =
+		offsetofend(struct vfio_pci_hot_reset_info, count);
 		struct vfio_pci_hot_reset_info hdr;
 		struct vfio_pci_fill_info fill = { 0 };
 		struct vfio_pci_dependent_device *devices = NULL;
 		bool slot = false;
 		int ret = 0;
 
-		minsz = offsetofend(struct vfio_pci_hot_reset_info, count);
-
 		if (copy_from_user(&hdr, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -1066,8 +1073,12 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		kfree(devices);
 		return ret;
+}
 
-	} else if (cmd == VFIO_DEVICE_PCI_HOT_RESET) {
+static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
+					void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
 		struct vfio_pci_hot_reset hdr;
 		int32_t *group_fds;
 		struct file **files;
@@ -1075,8 +1086,6 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		bool slot = false;
 		int file_idx, count = 0, ret = 0;
 
-		minsz = offsetofend(struct vfio_pci_hot_reset, count);
-
 		if (copy_from_user(&hdr, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -1160,12 +1169,15 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		kfree(files);
 		return ret;
-	} else if (cmd == VFIO_DEVICE_IOEVENTFD) {
+}
+
+static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
+				    void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_device_ioeventfd, fd);
 		struct vfio_device_ioeventfd ioeventfd;
 		int count;
 
-		minsz = offsetofend(struct vfio_device_ioeventfd, fd);
-
 		if (copy_from_user(&ioeventfd, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -1182,8 +1194,35 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return vfio_pci_ioeventfd(vdev, ioeventfd.offset,
 					  ioeventfd.data, count, ioeventfd.fd);
+}
+
+long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			 unsigned long arg)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+		return vfio_pci_ioctl_get_info(vdev, uarg);
+	case VFIO_DEVICE_GET_IRQ_INFO:
+		return vfio_pci_ioctl_get_irq_info(vdev, uarg);
+	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
+		return vfio_pci_ioctl_get_pci_hot_reset_info(vdev, uarg);
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return vfio_pci_ioctl_get_region_info(vdev, uarg);
+	case VFIO_DEVICE_IOEVENTFD:
+		return vfio_pci_ioctl_ioeventfd(vdev, uarg);
+	case VFIO_DEVICE_PCI_HOT_RESET:
+		return vfio_pci_ioctl_pci_hot_reset(vdev, uarg);
+	case VFIO_DEVICE_RESET:
+		return vfio_pci_ioctl_reset(vdev, uarg);
+	case VFIO_DEVICE_SET_IRQS:
+		return vfio_pci_ioctl_set_irqs(vdev, uarg);
+	default:
+		return -ENOTTY;
 	}
-	return -ENOTTY;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
-- 
2.37.2

