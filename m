Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12DF3FB552
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbhH3MCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:02:55 -0400
Received: from mail-mw2nam12on2047.outbound.protection.outlook.com ([40.107.244.47]:54529
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236821AbhH3MCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 08:02:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7LeNls1hwjRGiX8NJkELmTCoBIKfZGEiCoe5Zeg+4bymJhn5LEIPzWwK4Pu97DgPyEMVPIy2kUW2t+yNuYjqAqhCG6JtVphF/Kr+yH/zWNtZsKXUkKH3BiMVLlzdW8xLUnQWHu1R9Ub9KALK3zlgzlAJdCkTgZzWyl4FZ/PxgY/KcrnIbJQxkHnCAR2EBMk5Cj1/78yJ/H+wtcE6GayHRl4J/nBH/XGtHyyVwYAxw/PjVeYnj4pvbyrcWub+GDXGM+5QNu973kTwZd3GyJM8e3cE2+4SE+kHVR4Sn+WOBMzPVm1/gHzB9QXwgOx2RItUu7EAScTnindC2Iy1ifd/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cy2cXRdTh3QnwcfkQsQzEouhmuGaV9pkDAc4lxKt4fo=;
 b=MWNkBlOTG9R0NDfwd2B/2hIUhPP2eN2H+cKIrP5S66lH26kWgqzjMxAocvwECbttFQNDF8hCQZgmxdUyoRPnM1Hn8T2zZ1OC0KppJ4Dm6Mi78Si5YkregqNLdKGkm2FNpR6NsIqBQptr9vb1Ik20SXIzWfGX6lH/Zj58DeNRYKeOnLWwLY+LMVC80hnSzwrSfevBGjP9IsAH6+x4KmLnhqepXh77yFs/qn+xUdOshcUd649Z6LBwzZKkMZkF1TJ3I3f71ShJI9X0O/0dg7SbMeIPLCkouDbI/N8CFbZJ74sw0JF7M+H7nqrohV3c+kWxgj9REd7DVGqrtmtNoADNXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cy2cXRdTh3QnwcfkQsQzEouhmuGaV9pkDAc4lxKt4fo=;
 b=hHFH0+1605hdVJweTFTGSYYsR93HnFamBLs8Zp5L1dcwBlhkIyLW0W9OdCrf909hRL6cmIkrTiDiz8ay3I6JCdG2p3xlOb9UFPOnHME0umqupo96aUpnKFZ5FE2U2yqdaQ1Ifg71JRGUJgCf5VDeVkkDqCk8Gt82dDPp/Wg9/EwjHOLX+0pBV8ZAbpVKiUErbQ86sWRVYXLLo5DVsPXjKrySDiMGnANmqBk913/K1ubV+K3lpzukfEaIluLunLLbnhiC35X+YeBd4UZyB0S1hGs+DjGCLSw8xRQQc1/5wiW+3coQm0LsAExvXRvrq6oMMP8V0ilWDeUw+OUiHE9HeA==
Received: from BN9PR03CA0089.namprd03.prod.outlook.com (2603:10b6:408:fc::34)
 by CY4PR1201MB0183.namprd12.prod.outlook.com (2603:10b6:910:20::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Mon, 30 Aug
 2021 12:01:16 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::60) by BN9PR03CA0089.outlook.office365.com
 (2603:10b6:408:fc::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Mon, 30 Aug 2021 12:01:16 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 216.228.112.32) smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not
 signed) header.d=none;redhat.com; dmarc=temperror action=none
 header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 12:01:15 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Aug
 2021 05:00:25 -0700
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 30 Aug 2021 12:00:24 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>
CC:     <oren@nvidia.com>, <linux-block@vger.kernel.org>,
        <axboe@kernel.dk>, "Max Gurtovoy" <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] virtio-blk: add num_io_queues module parameter
Date:   Mon, 30 Aug 2021 15:00:23 +0300
Message-ID: <20210830120023.22202-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50850952-ace1-4974-c4e7-08d96badde3e
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0183:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0183D1CF6BEF9B05A4BDD063DECB9@CY4PR1201MB0183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47xnmBzOnZvGFX+J5ehCiqGyqOK73pdsBxSzHgoajKiBdc6E66fuewzPyBrQQ7HK2bE7eD3KVLCrhTxECtB7CGBRGCJ2Rtbj7NlqpKoP1Lzy5Vo8A5iCJCPTcU7dyCBbf1UcqxUyUALxtK49MWlbPQne66Ov+Gnx+66hUdKgcenii8KbCo0meHgy4BKDwQWTx41oGUQhHMf7EUVpBQrTPxYXh80B3L11LGUIfh1cpa23ynVrlc/05VAjSAn+BvEP7z0Xqj4V3O1zTpllYeyIuMMRs+ggEZlUH9dncJxG2YpXq9aEp66HAexfRA8zoCn0MjlqqnUwEwCGdRjMJ8TZECd9IMnwKfzZFd7gMIP9DDonSRhpY3nCZUd1GGT0Gwt0Jl1vi7qPkOFe77u0bNlMZdk0b/3tQVPqNVMwawSZGfxcBWpKRlODJoHzKMVTW1pk5eCQ7y74I4Lfh0ba5Or9VAsLEZzU1iBnONoQ9Mn0syPJYlUKdbX3lYpcbc0wNN8Q48e9LWjGLxITlKEpArG1Of9PYBba23Vic/lJPkUh3UzUrsPG61j1F4BUqBVuxcYKRxFd1pefHQCMrbTOhL+3EFejkZ0HNSio2+MwemZCNxaEnp+CsSwYEgQzZvAZodbgIGEr22/n/1d6SU5vu3+fT4dbos6Oa1osxuEJ/hXGjVuND89dySPBZ/15Fc/sAUyWq+g9RMFagB4DjJanYEYqow==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(36860700001)(107886003)(70206006)(47076005)(1076003)(26005)(82740400003)(86362001)(110136005)(356005)(83380400001)(70586007)(186003)(5660300002)(478600001)(36756003)(8676002)(316002)(7636003)(426003)(63350400001)(336012)(63370400001)(82310400003)(2906002)(2616005)(8936002)(54906003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 12:01:15.0226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50850952-ace1-4974-c4e7-08d96badde3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0183
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes a user would like to control the amount of IO queues to be
created for a block device. For example, for limiting the memory
footprint of virtio-blk devices.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/block/virtio_blk.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index e574fbf5e6df..77e8468e8593 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -24,6 +24,28 @@
 /* The maximum number of sg elements that fit into a virtqueue */
 #define VIRTIO_BLK_MAX_SG_ELEMS 32768
 
+static int virtblk_queue_count_set(const char *val,
+		const struct kernel_param *kp)
+{
+	unsigned int n;
+	int ret;
+
+	ret = kstrtouint(val, 10, &n);
+	if (ret != 0 || n > nr_cpu_ids)
+		return -EINVAL;
+	return param_set_uint(val, kp);
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
+		 "Number of IO virt queues to use for blk device.");
+
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
@@ -501,7 +523,9 @@ static int init_vq(struct virtio_blk *vblk)
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

