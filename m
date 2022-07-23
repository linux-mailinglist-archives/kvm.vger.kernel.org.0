Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9D257EB69
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 04:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiGWCFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 22:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbiGWCEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 22:04:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7934CBB20E;
        Fri, 22 Jul 2022 19:04:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuWlw5uEEspmsEeZe46/pB21QNsUFRLm7bKKUqhE0yEKyKAp/34tfUYonOsd7GFxCiVWH5OQsTjd/9EcdltwpRn1UIcpNGBo3CjN8VEu8Id3/mX8zI/cN/W7ihO+CJkISRnBARqBjMmAlC2kMLbo6U6lfWnopcp7GK+a7vz6KtxsoQiJ+/63IQEghdvW6cUv67UQtK5a9qX5LPaOF6uZk33iQ3FvXPA3qN4zKNRtcGl6ftg1AFGG6O1Jk/A4cVlx7z5J3lhqIUrFbU7OD/llYI26imf8hgJZKYvCtxlGNuTQJM4/vvVhH+q5MFgWbb0KjkGbhBVKOABZZ0hX5QIRvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vikqsyFr0cUNkzLiNnVEYY2PhcMznhk0zaOJOlwEqJw=;
 b=lY7L7vItQB9UR/UOVuG4wwhFWOTYJaWU8n+EGxVUg4ZsOrQoSRJ9A0j71twJdwWjy06rLpFQcWS9rVYiigFxf17RDOFsRYePHCwqu1e/MkI5kkzW3ckRuxuOPPPXxYJHlUflgis5h0rym1bEAgaEtZet0Zy8K8N4hv7Hu/0bPEtDpcwDfHgQ30WySAdKmJg4FhR649Ih6YmDLgMmFLooBelGqW4DcckVLhI0augSC6wbRn5VSFcbAHPV+FI/4g3B31xh3BavjtHDvua/YNlzfEi6lhynZ0PQQRDeiwMWKzdtOzJhxn1ZrvjpwfpDPo+7TwGkFpxspSnuT1QQSXoA2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vikqsyFr0cUNkzLiNnVEYY2PhcMznhk0zaOJOlwEqJw=;
 b=a+WzWoFB8F4vk6RH8zuvBedDSLX7VSdGfZMb86INxYXoOyRgXNmodJsj3q5A2vPUBYtvcGOGjpZZ+SQdmv6tTfG6t/LS3GEoddrikMBbtWfrKbvucm8oBhesdPXZPA6De2jOXdYHzERsil0kWslG+wjnrGsZTMgS6L6EKWKLdff+34ZQS1eQubl/wnChF42wd2SpIjoG8BbC/ZidTN5TKK5p0Y8ufHA1eU3yUIFuLmnV4BPDx1TCVNR+gXfAGq0gBcxtZkcCEqDIM0fNCh3PBuN34Msy9blCu3D+xMXvVxq70WTAkxTqiBtOAVGY7HX4cEt7G5CcFFpEd2KYlAhh/Q==
Received: from BN0PR04CA0187.namprd04.prod.outlook.com (2603:10b6:408:e9::12)
 by SA1PR12MB6679.namprd12.prod.outlook.com (2603:10b6:806:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sat, 23 Jul
 2022 02:04:24 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::59) by BN0PR04CA0187.outlook.office365.com
 (2603:10b6:408:e9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15 via Frontend
 Transport; Sat, 23 Jul 2022 02:04:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Sat, 23 Jul 2022 02:04:24 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sat, 23 Jul 2022 02:04:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 22 Jul 2022 19:04:23 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 22 Jul 2022 19:04:21 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <kwankhede@nvidia.com>, <corbet@lwn.net>, <hca@linux.ibm.com>,
        <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <tvrtko.ursulin@linux.intel.com>,
        <airlied@linux.ie>, <daniel@ffwll.ch>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <freude@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <hch@infradead.org>
CC:     <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <terrence.xu@intel.com>
Subject: [PATCH v4 08/10] vfio: Rename user_iova of vfio_dma_rw()
Date:   Fri, 22 Jul 2022 19:02:54 -0700
Message-ID: <20220723020256.30081-9-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220723020256.30081-1-nicolinc@nvidia.com>
References: <20220723020256.30081-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d623102a-1fc3-45ab-ffa2-08da6c4faa61
X-MS-TrafficTypeDiagnostic: SA1PR12MB6679:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FzCFZ2U4Nn9FoB9ZXaV6n8D5mil5MuZkm0yi1LvijFA4jI7orIX/7wbu3vmHO5OeLP/JboD0gK+gtZEJ0Tn5J9yEM4zjbSvVlu60WqW9a6od+11ah0x4NQ53ky8zS0p5qKovYgkMMKdvGgEzbZKdwJVoCc5Rz5f0d6az1GYaCqaTF+paOLF/IFSIMBHrfKGsUJkxnphRbXTGjyIdZq3uAPO7ZHbF84kNlEZXKnPUgtBz/V+AUkuqdFU3M1k/EYF3Le/leqpUUpBxQgyjtC3GBjQYSyFxi1oJ4sJu0mP4SudH7LNwx+FHUH/eniWI2+m4k2QxZP0Mfr6gzIyVH3sozIlDX15MnbdhP2OhMFAXFwiP4yi/0leOlTx013X73m+8MkXLF7BNfgHR1bD5c9751NQkAsTTD0CApCrUfZaROfu1SrINzjqwjXIZxxRpVf2onaN2bYTcmxpEnFFktWWbE78QWODD4ARTr87df7jaPzSQ8OekJj6xwqadpZ7AczQ52+8sVvqOyJ1oFrxNQHUbbn6DZeCXwVsU3OIsuF0vDVUqHCmqlyUT77nFunqVNNniKNQpG9bJHu8ozHABzsC33GVbeTkn/igq7Ie2iwcWGKHjexDZwImch3FT2bSK6subRuVrB9Lf9OzFHtcLj38zwCCoQjLJc3NztjgSrYOJqLpnuA4sPSJSuXsdIlPY65sQj0Wn5jIVyV1yYiPvqIp6U/QOVhakBgxlIL/v6PDudr1AUdfTZeJnu53Oz2lITZuXCPRS619QYLaWwvOuYIeuKUnZ96M5TCVvYol8mUs3COQqCn/c1TlhRuIM7ILvYTZwnFngwBgmA1onOAliPqHWmZrfjwZROTfMWb2JhYaib2Rg9VqnrP7pv8JWsEkxcZ/3BZf/FlDnVsd0Yjqai+bOGQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(40470700004)(1076003)(186003)(336012)(8676002)(4326008)(70206006)(426003)(47076005)(70586007)(6666004)(7696005)(41300700001)(26005)(7406005)(2906002)(8936002)(40460700003)(2616005)(7416002)(86362001)(478600001)(5660300002)(82740400003)(921005)(36756003)(316002)(356005)(81166007)(110136005)(83380400001)(82310400005)(54906003)(36860700001)(40480700001)(2101003)(83996005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2022 02:04:24.1393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d623102a-1fc3-45ab-ffa2-08da6c4faa61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6679
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the updated vfio_pin/unpin_pages(), use the simpler "iova".

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio.c  | 6 +++---
 include/linux/vfio.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index ffd1a492eea9..606a20b605ba 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2012,13 +2012,13 @@ EXPORT_SYMBOL(vfio_unpin_pages);
  * not a real device DMA, it is not necessary to pin the user space memory.
  *
  * @device [in]		: VFIO device
- * @user_iova [in]	: base IOVA of a user space buffer
+ * @iova [in]		: base IOVA of a user space buffer
  * @data [in]		: pointer to kernel buffer
  * @len [in]		: kernel buffer length
  * @write		: indicate read or write
  * Return error code on failure or 0 on success.
  */
-int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova, void *data,
+int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 		size_t len, bool write)
 {
 	struct vfio_container *container;
@@ -2034,7 +2034,7 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova, void *data,
 
 	if (likely(driver && driver->ops->dma_rw))
 		ret = driver->ops->dma_rw(container->iommu_data,
-					  user_iova, data, len, write);
+					  iova, data, len, write);
 	else
 		ret = -ENOTTY;
 	return ret;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 9e3b6abcf890..acefd663e63b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -164,7 +164,7 @@ bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
 int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 		   int npage, int prot, unsigned long *phys_pfn);
 void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage);
-int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
+int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova,
 		void *data, size_t len, bool write);
 
 /*
-- 
2.17.1

