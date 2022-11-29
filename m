Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E61563C96A
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbiK2Udp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbiK2UdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148D66C705
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFebpfR7IRiSNsIA7v9lzjF6Qb0g5zvGZMX6LEzCDjRaaI7scYhnr4m5IIyC1Zd5yzO1lvlM5EqHo3TrxU5Phyb3s55SfqXdqS2jxip10MJWndZa4fzUzR0mMVKL3DsKHYJpK7WNI/6Nzji1/iKW9VJGgRMa0B/tKn7lRou+QrQLrVQ1jchzhUH1ae44J1oPq8u1uArhHXhH4aUSiM7o3oWwOwVz+huzXAW0krAJ8WnnwCx/HgS4N4+8zPihUTC5mQutSb3grTuWT6gUT9Emoy4pQHggCpBkA8S4d7htcEmnldbC4yAYyqrDcBN2Q7THHTtf2DKnj9q2UannTp/9uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFvNYeBlzh6Z40+BPuQ0qq4fuXgiZD5DRpQXC+p+L5Y=;
 b=jZwv4YFShuH4QvcXNmDEj802QW8EAd4pgDJpXf3TZqxjWwjjvD6kY/oRU+3Bn9P2O3h3St6Zlu7BWA7Bo4ArE7G7Tj5XDvPwR6uNENaVXHSgIvM45SUaKwMfs3nkA7mY0PRrZkDFMR8jUhZg/EYUEvYqT6Bkw8rusrhpjkJBZdeSD78ZjaUl87h7ayVd/jC5A2AgApEYQxHu87OWY0tBlLz7Kna/BewEb0KbLL27u8ueRsmBg023JFIZA3LPQI8+5isi6EFtpQCjX4AAHuBlnuDDktZpjGBdknkVPIgZaNNL2Kj/8e8O6UlGiO0ajjVoZ08nZ7VZ1NEn1Ka9OXxj7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFvNYeBlzh6Z40+BPuQ0qq4fuXgiZD5DRpQXC+p+L5Y=;
 b=UPq4TY8L+uR3dfEyfe7aQsQCCbZz3UD+5S5bGN1HgT9ORAtk7XZ7Y8T4c2n2uJzs8v2vMw9Vk74R5khIr3F6c5HTwBj8qLXInrXd9qLKyCSwNp/h2GnjttnCr4aINpRIAFSWFl9P0GK8bcsTLHbVXe+UkugNYbfmfKlcCklnfa2/FM4/KP23aRecEJMsJxPE9E48VgORcOQs/KlEfH31j+uxtji1B8r4qTH6MhWyD3iwj3SWtknLLOsZ6iejq60k8xdVhRuiqca3LZ1Myuy+HEsnqp4qrmJl7dz3rd83YRU9wEkWoANRR4ay26PSOdkaBjWFTidpG3WYDgyXR9x8YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:32:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:32:03 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v4 10/10] iommufd: Allow iommufd to supply /dev/vfio/vfio
Date:   Tue, 29 Nov 2022 16:31:55 -0400
Message-Id: <10-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b43608e-eb9f-4796-99d7-08dad248c3bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBlglv8KoDR0MpoSTvZH8YY0oDlkW3WrMeQSrkv66d0uOwZ9Jt+28U4gXD5aMz4RWrFH2RkmYLkigyQ4hzpsXDoYsibbDkTIZ3WW/KYbodQWYbWBXoM+mjwsyMUwQbjoxNcgw7RPlXGrnyYeZ0apiI1p7Q8jkfvYUnMKWvi1/eSBeu7ButQHT8Z3nCVVYMyfIekfAabvGNegW5aO54tVFnSRHRuONlemmng7o8Wzk7lOrliNZ0OAnpXFW+A0Ic7vxKJweIYSpl8k/WkTqJMgoURbHurko/DZ1CD7j2pAdsj9McKJROFOQr4d90Jo/fJ5xguDFu2dzCNbXixhONkeKRecLi/LXZul4pqeg1dFxq9UdBczhhrEeNFjeYsrgZlHSG/irpHafFmPLe4U9FSD9S0euks7gKeTfuF6boYh5oufIYjGf1PwvgUpnZQ3GO7TpRw9L1KpUblIzF2AijuQiFfotHRH9scRxE36ki0f7Vc13tNRG/rF6Tcsiy2eYcGv/F1XgLMAS41RvJi8Lw5Zg3UtAqRtCFO4mb4/RaQSJtd+pf/pXsvRS0LJapJNISZKd4zd2VfCTEpydD0vzrvKbQylUuaBK55XgxIIUAAqy36tyAG5Qc5dpXt2A3b3OPrtz03XJATzscuLZiBYaypxzN+UPJa7xxN0GVVk11oQwGkMJe+5PPxA4mPP743cZ82v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(109986013)(451199015)(5660300002)(66946007)(7416002)(38100700002)(54906003)(186003)(6512007)(316002)(8936002)(36756003)(4326008)(8676002)(6666004)(66556008)(26005)(66476007)(6506007)(2616005)(41300700001)(86362001)(478600001)(6486002)(2906002)(83380400001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iq8wzvofWunvGNyzkJ2TzHxBoWIAM2E7rNO3S9emtH57tHmnS0pyCtV5g2zR?=
 =?us-ascii?Q?A0wvEsVcMvVxxMQqWKLCiQc8eYLeV5CZWBeavBoi4i8U6IqBF+Hb+s6RgMeq?=
 =?us-ascii?Q?CbKliV2KB397XHggkQQh/NhpHkx8B5D4voQg75WOX7cKnk3YOaftmIYr3Nju?=
 =?us-ascii?Q?TJm7H+Zot/6K4YzkDbw7MtqViL4ax16WXggwnJIbCnzM71FLF+RNR/oNqKhR?=
 =?us-ascii?Q?5XOLBadSo/c9ibPq3J+IgZ8zNDKPlOUQfFjc8E+UoAUqRNuWYprellNoYfa9?=
 =?us-ascii?Q?dE0Yvkr1c1TE1uCZfdHaezneH1Ca5TQmovRCzoaCqBqeC6ApUgvFJnmCi350?=
 =?us-ascii?Q?qpar8R3xjf/1+CgEQDX4l8mdeN52+GVC62ulZW7y9CwOTIRVZBZwrhg21yeS?=
 =?us-ascii?Q?yqYFqL1yA+TER6UF5PIqJUc27cWEKKZ51CE+TgGpFf9EwPKVbQI6SVCMHYNF?=
 =?us-ascii?Q?lpFY0FJzlc30CaiSYXHTtgPHIX2HgWTgp0RbQyMyJ+xAbcH++L9Osm0drSVu?=
 =?us-ascii?Q?riVNBEfPdxiTwA2Gr0EaJPj2YbDqXrxA5ijKBg+nfpUsSn7ludnJGwruoY9U?=
 =?us-ascii?Q?OB087IkQsmRgxLUq14e1tWBV0B2CJH6KAvVSOZOtyVhW8XTGBHA9Ccgs+Bc6?=
 =?us-ascii?Q?NuRyL39kq0DLmjMqRp6jyodB2xIavN6SB+jaCSO/Zexa6Fm6rZQwp65Szh4j?=
 =?us-ascii?Q?tqAGwJc35Y0QWor2EtpruLNTYFeWQwqgeBuu1h6XjUgX6tlmE+Z2kG7bhiG7?=
 =?us-ascii?Q?bSCrDgzELZdZxIJekGCMid8tsZHbbGIHjL4jCREcg9A8sm9sdDY9rHyDNMXQ?=
 =?us-ascii?Q?ujRhhQcm+w1kCaVowFjlALlhPX3vgk0XAcczcHcBJ9lkZ7cxCk5vYh8VHHDw?=
 =?us-ascii?Q?QaKdj53krYvFfPCqk9PZPAA9M3wNtYGU0cB3shRPSIJhfqkJvOMptDNDeemp?=
 =?us-ascii?Q?4Z6bPoGT+fh3BymWpjhBaooSfdPDsA0GEbXkGtD1f/eanOGfs45275Z15YeY?=
 =?us-ascii?Q?Hr3up+0Q+MUqYSu48N6VpYGpycEo2psk0wnzYWcQV6/Zm6wjPA0s5Yn2wpvB?=
 =?us-ascii?Q?j0Ed4herGKX0weJK9+RLYPZ8YFG204i2gCJntvvDCZucneS++RkMmmCAwKhN?=
 =?us-ascii?Q?/89QxqrfKqYrl8AlcRYBzwfhrbDd7zx40hdE7ogCRV/sPycDcq8vrB57g5t5?=
 =?us-ascii?Q?YY2DeZFVUA4DuhSaelyPQQQPIwyhO0WIy4tMkAxPQDqS7ezkRPT4QXEi90Ps?=
 =?us-ascii?Q?T6bmu+IVwPlerKRR8FDiTAQKApEQJj1ia4+pRlCvHNlqWdEGky3VNhm0y1H0?=
 =?us-ascii?Q?jUwZkcw58j5Z5TzMd4ThjBVC7hG4+4WKaWK66C9qtdkhD4rDxu7Ob40l0iv1?=
 =?us-ascii?Q?9tVsoUxmSmtJ6/9PksUCEAUw0gFnzljOftqVmEY+5BMSpinIDOdQNaeBpSRZ?=
 =?us-ascii?Q?xNfQK+gce17KlJn4BSlMSsLQE0O9TH1bN8Nxs5t0TfpScrDJNtaYAeoUzDVb?=
 =?us-ascii?Q?ASQ4/2CmeNJo8gEfpt2Mpsru88pp0ksJHBDVpwxiKwM+YQI8OeBkBH8C6N8q?=
 =?us-ascii?Q?MWMYa4IXX63Z+Qr1LaEaBYb7WAD7GGYLSYHzAGnO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b43608e-eb9f-4796-99d7-08dad248c3bd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:31:59.2150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o3tQzt3kQvC+2cOO7u22VxC9WcfbwA+n1VsKF+0DHPlmadyEp3zOCbewqc73+EaS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the VFIO container is compiled out, give a kconfig option for iommufd
to provide the miscdev node with the same name and permissions as vfio
uses.

The compatibility node supports the same ioctls as VFIO and automatically
enables the VFIO compatible pinned page accounting mode.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Kconfig | 20 +++++++++++++++++++
 drivers/iommu/iommufd/main.c  | 36 +++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 871244f2443fbb..8306616b6d8198 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -12,6 +12,26 @@ config IOMMUFD
 	  If you don't know what to do here, say N.
 
 if IOMMUFD
+config IOMMUFD_VFIO_CONTAINER
+	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
+	depends on VFIO && !VFIO_CONTAINER
+	default VFIO && !VFIO_CONTAINER
+	help
+	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
+	  IOMMUFD providing compatibility emulation to give the same ioctls.
+	  It provides an option to build a kernel with legacy VFIO components
+	  removed.
+
+	  IOMMUFD VFIO container emulation is known to lack certain features
+	  of the native VFIO container, such as no-IOMMU support, peer-to-peer
+	  DMA mapping, PPC IOMMU support, as well as other potentially
+	  undiscovered gaps.  This option is currently intended for the
+	  purpose of testing IOMMUFD with unmodified userspace supporting VFIO
+	  and making use of the Type1 VFIO IOMMU backend.  General purpose
+	  enabling of this option is currently discouraged.
+
+	  Unless testing IOMMUFD, say N here.
+
 config IOMMUFD_TEST
 	bool "IOMMU Userspace API Test support"
 	depends on DEBUG_KERNEL
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index bcb463e581009c..083e6fcbe10ad9 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -18,6 +18,7 @@
 #include <uapi/linux/iommufd.h>
 #include <linux/iommufd.h>
 
+#include "io_pagetable.h"
 #include "iommufd_private.h"
 #include "iommufd_test.h"
 
@@ -25,6 +26,7 @@ struct iommufd_object_ops {
 	void (*destroy)(struct iommufd_object *obj);
 };
 static const struct iommufd_object_ops iommufd_object_ops[];
+static struct miscdevice vfio_misc_dev;
 
 struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 					     size_t size,
@@ -170,6 +172,16 @@ static int iommufd_fops_open(struct inode *inode, struct file *filp)
 	if (!ictx)
 		return -ENOMEM;
 
+	/*
+	 * For compatibility with VFIO when /dev/vfio/vfio is opened we default
+	 * to the same rlimit accounting as vfio uses.
+	 */
+	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER) &&
+	    filp->private_data == &vfio_misc_dev) {
+		ictx->account_mode = IOPT_PAGES_ACCOUNT_MM;
+		pr_info_once("IOMMUFD is providing /dev/vfio/vfio, not VFIO.\n");
+	}
+
 	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 	ictx->file = filp;
 	filp->private_data = ictx;
@@ -400,6 +412,15 @@ static struct miscdevice iommu_misc_dev = {
 	.mode = 0660,
 };
 
+
+static struct miscdevice vfio_misc_dev = {
+	.minor = VFIO_MINOR,
+	.name = "vfio",
+	.fops = &iommufd_fops,
+	.nodename = "vfio/vfio",
+	.mode = 0666,
+};
+
 static int __init iommufd_init(void)
 {
 	int ret;
@@ -407,18 +428,33 @@ static int __init iommufd_init(void)
 	ret = misc_register(&iommu_misc_dev);
 	if (ret)
 		return ret;
+
+	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER)) {
+		ret = misc_register(&vfio_misc_dev);
+		if (ret)
+			goto err_misc;
+	}
 	iommufd_test_init();
 	return 0;
+err_misc:
+	misc_deregister(&iommu_misc_dev);
+	return ret;
 }
 
 static void __exit iommufd_exit(void)
 {
 	iommufd_test_exit();
+	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER))
+		misc_deregister(&vfio_misc_dev);
 	misc_deregister(&iommu_misc_dev);
 }
 
 module_init(iommufd_init);
 module_exit(iommufd_exit);
 
+#if IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER)
+MODULE_ALIAS_MISCDEV(VFIO_MINOR);
+MODULE_ALIAS("devname:vfio/vfio");
+#endif
 MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
 MODULE_LICENSE("GPL");
-- 
2.38.1

