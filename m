Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9943FC8CA
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 15:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbhHaNvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 09:51:37 -0400
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:54305
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239762AbhHaNvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 09:51:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QO+kGn7Q4SdYH7SFuVTLULwCNtebznU/Zj1S39mLrqlI7hxiItLOczQMbaCxnNTt5O3b2yuAuz+TdA2qHaHVbAfEwIT3ni9tsJMEmKzexk03bxmthTJaME2lcPaSwNcSa9QgEkfws8RgZsa1Mbc8fX2qm/vyVBiXnC8NkFTQi9ABMJ7hdFXWWsZzNlMwnmFeBxffGR47evXCBBYTdTnrX9luwV2yhbajTPZpng47j5uxWyg1jT1HIKg+qPA5ZXDcZMI6C3zbk//PzJeDfvtf0W2inFOKxva2TLt0ZTooU5mnMjFSmBvH1NTJEXPhMTUuDqKWtLoDGzoRm0oGx/14Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUui2uysRfUCFJz7+wbH5yJKtswdp5upkfmePPNXDuw=;
 b=U7eoiPu+w6E63SWJRBnznjp9v/LfBuZgMfyqmDYSC1r8FsV4UgU9hptvQBsLuZxMhc8iR5kuqJ44mL3lqlAierSaBY4O7TsrWznX8PJElX0f9ctNEg8b76elmN9pc6X5OAaKN2Z9pBgM00EfVw5iRMQQJj9awjgQ7QDkJ3YamZB3EvQnTFexaH348Wu2JIE/bOA5B6+0tOIF0lAVTy1NuZ6ukntP7KuAfGYymlPuoneQbfnO2iAq6JI5sQxjACafVLkcYnj9IWMCQSaH61tsqnQAwFEwrD8mKb6h4TbzxzRtCj1Y1UW4IJ+7VnuDfipNe37RQDu8lB5O0bz3ur6LjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUui2uysRfUCFJz7+wbH5yJKtswdp5upkfmePPNXDuw=;
 b=bdNm7j9AB8oMjYTEyQMy3xKBOaN9InBiWZ70RqbqZAQIZNDww9wMzNxJ//OhubMJnOwBGDa2i8b7nBlQPYVkeVjjm27XalRrVJgI7tdwaNvfobenJhyI1ias24ynfnkWJNp103A/Eyctgub33EdtAe72nH6tSG63cfxwfO9sqrvpdxpEtPRZXCN1tmZ3jNXr90Md3m2Y3Ab0IztMdde/9Qo1UeLe2qII3gSesz2L25Iu3JoXgNXml3VvmedRiuwQPzxvFt2iTLWxRGuolPfq0LKM5tJ3+yjYcUn1MfBkD18ed4niXpOej+ekGueprSEtcPKOn6nTX1A+TYhrs0WOwA==
Received: from BN6PR14CA0008.namprd14.prod.outlook.com (2603:10b6:404:79::18)
 by MN2PR12MB4157.namprd12.prod.outlook.com (2603:10b6:208:1db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Tue, 31 Aug
 2021 13:50:39 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::a4) by BN6PR14CA0008.outlook.office365.com
 (2603:10b6:404:79::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19 via Frontend
 Transport; Tue, 31 Aug 2021 13:50:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 13:50:39 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
 2021 13:50:39 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
 2021 13:50:39 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 31 Aug 2021 13:50:36 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>
CC:     <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Date:   Tue, 31 Aug 2021 16:50:35 +0300
Message-ID: <20210831135035.6443-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98969b72-0be7-45e1-7f5e-08d96c86514d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4157:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4157ACE8E062310823A0E81FDECC9@MN2PR12MB4157.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LeyLyo2yZr5vfcv7i+Y3FDpK2QfjodgWwaYjs2zeJvdk/vEp7wIDzsRBtdlGmktgAdb0a9dU9/pz3Q3I7aORAuaHUrDJvWx8++yy2GATCR9/fuq0do2IAFtOeFSRN2mQABIOeVVOrHx9zjAQoab0a1lnM6DPOnIDpUsrRIUYkX0c5gmpuqDYL3ywxU3RsRpnzVt+j0WJAlMaPuQ1GMDxGS3mntiz8txcGtlmvqPiMDqVa39ICFPmsnxRk2TTSwmGe0C1/gPYGcZVpR/Mg5sY8Fe0tFwfd7ZRSsG+wMe/PXKbD9ItcfJpF8HBGLIyRT46UfraAEJiP3d/ef/llJLSiTlt1Q9MSuqJ3+YLd3UOtlWE2JzKldWglmDI8/LuyANbocajptNpQcV5xBsAkwSKovtZ2jj8T8krLbH6YLT6Ypr3JQLsHuJCohUTzcInAhkwP8lq26jzOV+8eT+btMn3MzVGisvp5K8Qb/+cS8KKHD+HXXnhiF2/4szKET+crllEBwq6frfc+RoM0hmjL7VaujDsRJhbAn6ZhXVp/CVeCwe+P3RJSKfJHFcaRZo0eYE9GHhTPG9joApEUkNswUoKIVt7NGznqXbXJ233lLaDSnNOrfnTNc9i8I2gez6rFIEIktEd4RKvzWGIwPgIVJhzfH0PFzal9XyykGf7usGotwQTFFP3P4Z39hEU1wC/OkcvKJ54wAaYI0yJRtyngqxXsw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(316002)(2616005)(26005)(36860700001)(107886003)(508600001)(36756003)(70206006)(70586007)(186003)(1076003)(8676002)(2906002)(83380400001)(356005)(426003)(36906005)(336012)(7636003)(8936002)(110136005)(5660300002)(82310400003)(86362001)(54906003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 13:50:39.3407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98969b72-0be7-45e1-7f5e-08d96c86514d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4157
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes a user would like to control the amount of IO queues to be
created for a block device. For example, for limiting the memory
footprint of virtio-blk devices.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---

changes from v1:
 - use param_set_uint_minmax (from Christoph)
 - added "Should > 0" to module description

Note: This commit apply on top of Jens's branch for-5.15/drivers
---
 drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 4b49df2dfd23..9332fc4e9b31 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -24,6 +24,22 @@
 /* The maximum number of sg elements that fit into a virtqueue */
 #define VIRTIO_BLK_MAX_SG_ELEMS 32768
 
+static int virtblk_queue_count_set(const char *val,
+		const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
+}
+
+static const struct kernel_param_ops queue_count_ops = {
+	.set = virtblk_queue_count_set,
+	.get = param_get_uint,
+};
+
+static unsigned int num_io_queues;
+module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
+MODULE_PARM_DESC(num_io_queues,
+		 "Number of IO virt queues to use for blk device. Should > 0");
+
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
@@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
 	if (err)
 		num_vqs = 1;
 
-	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
+	num_vqs = min_t(unsigned int,
+			min_not_zero(num_io_queues, nr_cpu_ids),
+			num_vqs);
 
 	vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
 	if (!vblk->vqs)
-- 
2.18.1

