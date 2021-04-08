Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51431357DD0
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 10:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhDHIL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 04:11:29 -0400
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:48513
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229586AbhDHIL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 04:11:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwwW7awgXWVpJ5UYnkyFs4vr4Z/i+vk+Lsn6FYQk6hfUl2HEG4O3zuFmjb6063Yjf6WqvtU3lKrLGEnUHDpUB8wVVopI8kd9ry7vruC+S1ZTTfe8/m9lJu51VAmlwVyv6AVVvNYfHHF6BaFc6EP5simU0RXpJLuJsQvV8KJTe/MBvQSkGinaE28bYb3g/g7YhBHcYh/sNAWxyr0SfuhFJ2InVuNIzvkbsDJySAV+K4FTM9b9XVj5YV0dpp26lnN4MQVVm5wcdK2gTh8qGPp12xnpcy0WnJHhTquPsl/NGNHelQP8mce26Uy4gOles4bdS8M1pC1aUXJQFQEZVyAXHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0EBD+tNxua7zQadLmEJYcvQW9eBq9/zvN7Jf2FQjKQ=;
 b=a1sWIHlOBLxrSXY29Liat71ws8NOiYMpCnYNzt3ST2Z4CQXkAbPoctunoTPm2L54sJmofH6pEH0NM9k2PaoIuzVv+NfS45Run+Lhv78qpWZh7vqH5USC9PAeCuXkqqQsCnBuoFZwRu+9D+Pl8K44zDjf41JDH9G8XCURIwOvj9OfWz7cEq+Fwo12REhd7yf4rGhDaEJ/+zGAvlV3weOFv6jIB3YxZ88cMnjSS65dRIcgmf30Nt1am0lAtdZg93Wpx1JQigfAXI0BB8+zRViOSf5Nts567nxbpPHiJKUmx+7fPsm2ZQKBG7xzssJ0SMN4KvwyWxhq6LmiaZP5k5p9+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0EBD+tNxua7zQadLmEJYcvQW9eBq9/zvN7Jf2FQjKQ=;
 b=OrddH+RvnSigswpS7fqjuGIFbbN202X9Caez9LTqDWrebtiyMZtq9Y+iPWnKRBAHo5/c7u0VkvmxSa6AmolpVDvelnLZhgKzYpZt6vhfi5wOYC/Bu8vvOqAHhw8eGXL8s8D77Ztk+OwONO9yJXjSgwZh4WcKbidyj8Z0rRSDNmkrcQjH6d/EzLRR3ug5yDtaaLdfTzoQkWsyyrkteoYqTm3n8XFOOmvS+c/08OULx1H9OSLRK2HBRwzvUobIbCYt8LZxIdgk6+ogkltkvdSPl8bk7ND66KNoFXRzU5NfxBYjIJJqWKD+W7+gysGCq2vqCEFp1Ljzj+/rNDYr2JikOA==
Received: from BN9PR03CA0530.namprd03.prod.outlook.com (2603:10b6:408:131::25)
 by DM8PR12MB5462.namprd12.prod.outlook.com (2603:10b6:8:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Thu, 8 Apr
 2021 08:11:16 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::91) by BN9PR03CA0530.outlook.office365.com
 (2603:10b6:408:131::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 08:11:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 08:11:16 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 01:11:14 -0700
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 01:11:12 -0700
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>, <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v2 2/3] virito_pci: add timeout to reset device operation
Date:   Thu, 8 Apr 2021 08:11:08 +0000
Message-ID: <20210408081109.56537-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210408081109.56537-1-mgurtovoy@nvidia.com>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 837c7ef2-80dd-46bb-f0a1-08d8fa65e20a
X-MS-TrafficTypeDiagnostic: DM8PR12MB5462:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5462EAE2D8BE03478E5E8B7EDE749@DM8PR12MB5462.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FWta67gtv69ELFRYMwt4P3GfGcmSmkBwFJNPxYbFEoPNGAg7tu3/rB8gd36SfqoJlUumKg8AZDs6IvUDBoBH42tx4oNpGxT50sJ3ld0ypNKf01+e0o/CHcAl12bNds7gsCXruXAtVK9UIIbfuAeQZAF5jutlb/I0I2WgXqhAOeRjKmgHHoAZKmZ7rkfnIO685IroHHUFKAKtdy72/md94Uc9muBLx0POFEEWTj6DABzFLFf4barKMkfAcgLtlbWWLYIzZJsLmHlxXPGJvouYyr4piYquGIdEgS/JK5mFSptujcEdJ0GRcADMcWiJ+C0ccL8aXggtpxt86exMUpZcN//6LX/9qT9gcYF7gTgoRdyvz29UV2Qk1WFkQNNx4iA7SoLknKF9AcKnXKPBnD/3VnuKLjl1mRTyynDospBwuL97GdO6x+0AFANuXrl6K8CK+A/uJ0zWlLFu6yvlN/ybId/d3NgeTJONLNmE3o9UMwqQVe+ZrWGK+9D9+85BD9OoU+Z3h9UoofL5hlVRzp4JS1e6O9H/JCdkWy3DrGYwneUQtPwU/+ESJc5RFooNuS0aAmXE1sfaGOUTzcFQnV6NWJLHuQBNsPTCk51Wv4ekUjaXYMs7s36755XlqWuQRY/gQWHc4kTOSO3lM+zk4Syfqn+FlHBYPbwqL9bhjUWJzg8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(336012)(8676002)(7636003)(426003)(83380400001)(70206006)(2616005)(110136005)(1076003)(82310400003)(5660300002)(36860700001)(26005)(186003)(54906003)(86362001)(70586007)(356005)(107886003)(82740400003)(8936002)(4326008)(47076005)(36756003)(316002)(478600001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 08:11:16.1355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 837c7ef2-80dd-46bb-f0a1-08d8fa65e20a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5462
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the spec after writing 0 to device_status, the driver MUST
wait for a read of device_status to return 0 before reinitializing the
device. In case we have a device that won't return 0, the reset
operation will loop forever and cause the host/vm to stuck. Set timeout
for 3 minutes before giving up on the device.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/virtio/virtio_pci_modern.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index cc3412a96a17..dcee616e8d21 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -162,6 +162,7 @@ static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	unsigned long timeout = jiffies + msecs_to_jiffies(180000);
 
 	/* 0 status means a reset. */
 	vp_modern_set_status(mdev, 0);
@@ -169,9 +170,16 @@ static int vp_reset(struct virtio_device *vdev)
 	 * device_status to return 0 before reinitializing the device.
 	 * This will flush out the status write, and flush in device writes,
 	 * including MSI-X interrupts, if any.
+	 * Set a timeout before giving up on the device.
 	 */
-	while (vp_modern_get_status(mdev))
+	while (vp_modern_get_status(mdev)) {
+		if (time_after(jiffies, timeout)) {
+			dev_err(&vdev->dev, "virtio: device not ready. "
+				"Aborting. Try again later\n");
+			return -EAGAIN;
+		}
 		msleep(1);
+	}
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
 	return 0;
-- 
2.25.4

