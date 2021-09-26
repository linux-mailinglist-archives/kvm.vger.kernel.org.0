Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EF9418999
	for <lists+kvm@lfdr.de>; Sun, 26 Sep 2021 16:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhIZO5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Sep 2021 10:57:04 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:51041
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231865AbhIZO5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Sep 2021 10:57:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HR71c4gMVygp/IheM+sNgb+EK+ubWH76DaM9oNoVrcMyCPnPad9VshBY690eUtTdb0aw0/YaPH3RtU+lMgvrWBVpKpeb3tDZ2nLQPuS/EiipEbKmUPguAv4eG5H9FwoaHY6a3wdxEx7r4WYY1fAL8zFWhynx7NfwkCNeYcHKO+l1SPDp9s+BIPqN2t8/WMbJJ/UDZxCNU8BzC00FAouy2cws21nut3PWu7R6WnleF6P5XzzwPUzsXYsZlgr9jpSkHogRkktluuV94cpcJbUDpljZ4HzgSLOTuctDY7GnNZGn0QV+zxXvn+goQGlFOQFcgLp/vqknBRDlNY2MGUCvBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uHRr66ZZatUZhyxix272XCfk+BCj1odz2JKSclFs09s=;
 b=AamoXTsgPFd4chvX9VNhrNUXh73Y7gnaj86EsFtCfhwyqJowSTLN8oX1becztTJ4j6AixgpI8Q4eer9FbuOrMLCx8hErKYTq2ZTYg8tuzc6zhr3u4RzXg4GFFW3qANDG4HTzZWlWBAxBQ8gyZGPZ8wsD+O535Gx0lMYUdMnA+kFab/croOGCi8FKtTviDv/MPa5S5njagKGHmvli10fBSDJJSbPcUHZyeM165Nz/IKKnDU8fRl6ukVDseuCCCDReGzulIVMq6U8QKOVkMdXZwAQTshEpH4CD20OaW/qdyhDL5pxnDX7AqVgyyLsWmXXqgBlwCPvIdMji7QB5YCO9gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHRr66ZZatUZhyxix272XCfk+BCj1odz2JKSclFs09s=;
 b=C+LPyeCoSXR6glajUmAu0tNaKL+J/ZYXzamVaUwGwPlc+vlmOhBJWvBW9yKrMV059KXGG4+EdLb+73+A1sfBnUCSduyvqo2RodJEuHfPpzqucxXHD/p6/AZ9PBDRnfEcbY8iF8tq6dEoTMNFsk732A2Ul/eHekxdYKL5o6VXUk3x9QAOre6XkYQtuU8JlsUskS9WgBczlxxy/UpdjDMiqEOS5L3DpFHH6ZLE5k2wbeNlKqERRaRWHy6KSZiJMhsduhfKJh+BsC/uw97JThiKlN/N7i+xkOcPAyD7FhOZmSviP1l6Qu4GvmSLptEFC6Th3WJ725ObrS7Rk15XeLO/Lg==
Received: from DS7PR03CA0197.namprd03.prod.outlook.com (2603:10b6:5:3b6::22)
 by MN2PR12MB2973.namprd12.prod.outlook.com (2603:10b6:208:cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sun, 26 Sep
 2021 14:55:24 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::8e) by DS7PR03CA0197.outlook.office365.com
 (2603:10b6:5:3b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Sun, 26 Sep 2021 14:55:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Sun, 26 Sep 2021 14:55:22 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 26 Sep
 2021 14:55:22 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 26 Sep 2021 14:55:19 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>, <israelr@nvidia.com>,
        <hch@infradead.org>, <linux-block@vger.kernel.org>,
        <axboe@kernel.dk>, "Max Gurtovoy" <mgurtovoy@nvidia.com>
Subject: [PATCH 1/2] virtio: introduce virtio_dev_to_node helper
Date:   Sun, 26 Sep 2021 17:55:17 +0300
Message-ID: <20210926145518.64164-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21971e1f-abe1-42df-4ad0-08d980fdaabc
X-MS-TrafficTypeDiagnostic: MN2PR12MB2973:
X-Microsoft-Antispam-PRVS: <MN2PR12MB2973AB5ECCD75B6C0145DE8DDEA69@MN2PR12MB2973.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: egfdnvEWT393RWJMsAgCSsj9myhQWp2dqW1NhFq0AF+nFjfoC6aJEH8HILOZD6FwXdQHavjMlIR49PGnDqpD2qnWcfHcSrrx5dsEfJCi0vlxmiyt4/oPNekp5Pf7YuTRSnws6KD7pH1M87g60ObEgWQwGeZp5IbX7qonFKdS9DrYpL2zQuQ6oWFZtNobjz77cl9c/9zxZL99tA6keUyzgv4ieoL/RH0fOzpQyf8vdIgSycLp125h8BcL4sZQXRyY/GI8HJf4y9BQCYwNvYTwzW+UWq8kczg8LCufGWCTGJ85e7d3y/5rUlQ0BkqWPsXxO8eeR1galn81ip4iRk7CzJltG3pGfJwKwIBcJLTKQ1xvCubg+U6nAosijU8/xNDxIKBaHlC1EEU1Zy3AbbvK0B/2nKcBATvMmYJVlsW/xBUZx+N4ZTzlrYdKEWRlZRw8p+QJpgQLtCGwA+4OInnLO8YK0tsybqVMpgXllztCoo+AZV9gBVTM00gOzR6afBdpXWPBoLGkD4UobCgz/09P0HFqKGa1OgdnXqAXrpfxguq+Cck48w7aKqV9BCnDUmdXjslFSoCdDU7vo5k3oLHzKTF9jGE4FpGmD9jxUu13b0+dE+d2LbZWO089pEl2v9Y3XH41gzoPoZwBpUvVnF60d24oNXPYmb0JW2LPwex71ONQ/WbtqSGc3Bl3m2T+bln5rxddp270KadvO+Te58/xIQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(86362001)(8936002)(70586007)(54906003)(70206006)(47076005)(5660300002)(107886003)(26005)(356005)(316002)(186003)(36860700001)(36906005)(508600001)(82310400003)(4326008)(2616005)(7636003)(1076003)(8676002)(336012)(426003)(36756003)(110136005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2021 14:55:22.8004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21971e1f-abe1-42df-4ad0-08d980fdaabc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2973
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Also expose numa_node field as a sysfs attribute. Now virtio device
drivers will be able to allocate memory that is node-local to the
device. This significantly helps performance and it's oftenly used in
other drivers such as NVMe, for example.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/virtio/virtio.c | 10 ++++++++++
 include/linux/virtio.h  | 13 +++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 588e02fb91d3..bdbd76c5c58c 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -60,12 +60,22 @@ static ssize_t features_show(struct device *_d,
 }
 static DEVICE_ATTR_RO(features);
 
+static ssize_t numa_node_show(struct device *_d,
+			      struct device_attribute *attr, char *buf)
+{
+	struct virtio_device *vdev = dev_to_virtio(_d);
+
+	return sysfs_emit(buf, "%d\n", virtio_dev_to_node(vdev));
+}
+static DEVICE_ATTR_RO(numa_node);
+
 static struct attribute *virtio_dev_attrs[] = {
 	&dev_attr_device.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_status.attr,
 	&dev_attr_modalias.attr,
 	&dev_attr_features.attr,
+	&dev_attr_numa_node.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(virtio_dev);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 41edbc01ffa4..05b586ac71d1 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -125,6 +125,19 @@ static inline struct virtio_device *dev_to_virtio(struct device *_dev)
 	return container_of(_dev, struct virtio_device, dev);
 }
 
+/**
+ * virtio_dev_to_node - return the NUMA node for a given virtio device
+ * @vdev:	device to get the NUMA node for.
+ */
+static inline int virtio_dev_to_node(struct virtio_device *vdev)
+{
+	struct device *parent = vdev->dev.parent;
+
+	if (!parent)
+		return NUMA_NO_NODE;
+	return dev_to_node(parent);
+}
+
 void virtio_add_status(struct virtio_device *dev, unsigned int status);
 int register_virtio_device(struct virtio_device *dev);
 void unregister_virtio_device(struct virtio_device *dev);
-- 
2.18.1

