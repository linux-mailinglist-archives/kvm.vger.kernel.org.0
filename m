Return-Path: <kvm+bounces-6286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAC682E220
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 22:16:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E81991C22237
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 21:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC101B7F2;
	Mon, 15 Jan 2024 21:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tNQh7mdk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D361B5AA;
	Mon, 15 Jan 2024 21:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6BJHrR9kLm1+IwEzN2OlFltf8P8QxMi3C4B/L7F32HslpdVFR1FdBPCUzlMHvpog1gh01fw6FpfOAWd+aVWZ+bUtCDpUfcrm7HCCcUiM/6JlJeWcF7YiT1zgW+jg5OlFYNTRfeUYwqHgjASCW5E06xkd4coghrzRAQRaLLeHwH+iGJYl8+GNbjs0fdyvcaa5X8hQCY+lx59cqU8sAfOeTAHsz7PzhgzMBKKoaW2cmxQxQ22v59QXoPzOYcwYbu/B6Sri1z2qEEBSe9wciUFgmFiLDnyqvMZl3QaJdxOzZ+Jw+gyRqKkqELf3MXfVH44uewtV47DXuOwXmF5Qnma7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBXigad1j16HA0qtnl6WIqZKuEx8RaTrjlqP4/uEuqI=;
 b=IstpIIIEv632iQrwEvK6pj4/VFHA7N1DmhqyBzQjf/pSD3Cx4NFiZW+8fBhEHOwdUZlP7EEqIIEQNxUL47yR5Jt3JkhB5pQCz0ZxO9f7+Y6IiFRvmooDeWavERZBZuc9SzK0mfmb5AF44MopfoEzOgqXxqcp8b9q3Cd2A4qS6pedizF5Z1RHjb7ylCe47wza1WpVMeY0feMjSnHEALSORkNIWJdAlkBR+I7joF3XHUPhG7EOW7ZvrkJhCZO6a81dH7VeRB9vrJdKZfsT+1Iq0BtOITb3HMm7XcH13AiZikCUnc+7wZF1iHdJCqpRBSClKrqypHdP35NIAIYJTlpnAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBXigad1j16HA0qtnl6WIqZKuEx8RaTrjlqP4/uEuqI=;
 b=tNQh7mdkHYMsvGSWzyfoRWzX+rwmrf0gj67X+rC7UqKj7Bb/KSdBpLb9I6n330HXFH6j3ZOMk8+FeG+v+xPSoy7otRQB1hmh6owBA6Qro5q5w4zJ72zrtZnpIMafU4TQj0vOP0aaqqPdW5S+YzaUWZ8w5HuAb9BIGMFvoqTEzN6rIF2crVyAuiLyrNTqt5ogNyxZenTxtUtTsyePtFDg0EOhENEoGI/ep8ZJytg8usMesnhtB2V9VmoWvleX/TX5eqgmBrPE53AYpOLPHzDo+L2dMEAF/vy2YqDi9Q1u8nJJIMfVzFr+OMV3qj1esJv659Yg3tgCBUSXM+O6LWIyUw==
Received: from PH8PR07CA0025.namprd07.prod.outlook.com (2603:10b6:510:2cf::13)
 by DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Mon, 15 Jan
 2024 21:15:39 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:510:2cf:cafe::67) by PH8PR07CA0025.outlook.office365.com
 (2603:10b6:510:2cf::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.26 via Frontend
 Transport; Mon, 15 Jan 2024 21:15:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Mon, 15 Jan 2024 21:15:38 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 15 Jan
 2024 13:15:19 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 15 Jan
 2024 13:15:18 -0800
Received: from localhost.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 15 Jan 2024 13:15:18 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <brett.creeley@amd.com>,
	<horms@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v16 2/3] vfio/pci: implement range_intesect_range to determine range overlap
Date: Mon, 15 Jan 2024 21:15:15 +0000
Message-ID: <20240115211516.635852-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240115211516.635852-1-ankita@nvidia.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|DM6PR12MB5520:EE_
X-MS-Office365-Filtering-Correlation-Id: 90f5d222-8c0e-416c-40a9-08dc160f1fa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d4fM4B3MvKqHbRaTcfq1h2bqLRmqabqLnJp4i6BPq59cyi2tLqaUqjCSBnSMtai4tRSDafHVkE5zVGkg3n8fFhjU2IM0xH2K70Rnco00FmXWY5HQJK1lP7KA/kaaJ24/+vZNXywnGW/MlpvlNGaK6klZbpHcZQRpHI6QoZys9aiJ5vRpai1t8eSz7EGpUOVHaNPpjUZY2XI8AcuV3Svu11sCIX9lzkn4efxZ49zpXlBHICOln15bLox+w+FX5YJidhxcE7Exz1R+tHKfBpHHaij8RkEbN567p7VJsUBlck7D3EyxEK4IzhnKyuZzStJaU1JpvfzZWh6m6ub9tF2E8pnEAjY1aorA9RaurBKqYM4KdKtuzkw8f+77ajt2UwCYnFvKHAFD0f9/pZE4Y37zfeNLZnzJxfsxIMi2ifWKuEVWGbhsuOa5rrrgSlHbnR+cQWMSQERhQ+WyEvWlyi+w1VmZdDlyzPy/v3RlcK2r+kaz1UAIzcN9lEYG4dEgh1hKQc5C1Vu7rLI2LQzw37dEHEvZ5rRb0053v58wbW0UjzO51x2OlU9qXkT5j7HOCP3vWDF6Xx2nMrji2ID2/rwA2Ef+vb3JshmmHJlMG8B4zRhYLHddjVi+PnU8UE7HLW3emyRShMFUvJvtcPVU82VmBhe+m8HDRz5bTaz28v2SNvCQaj8pYMUI07KTK9nL44IrV0kckxO9Jrdoenu19BFrER3aZss9LEpKAQMPQjZXRZ2DLl13S5XH1EOdR3mCxZajlAiIwiWPOao1qhdctqmq4vK2RrDYhS10WxnYFgeRA4M=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(1800799012)(82310400011)(451199024)(64100799003)(186009)(46966006)(40470700004)(36840700001)(54906003)(8936002)(316002)(110136005)(8676002)(966005)(5660300002)(478600001)(7696005)(2906002)(40460700003)(6666004)(40480700001)(2876002)(70586007)(2616005)(26005)(36756003)(1076003)(47076005)(336012)(426003)(83380400001)(4326008)(70206006)(36860700001)(41300700001)(82740400003)(356005)(7636003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2024 21:15:38.9802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f5d222-8c0e-416c-40a9-08dc160f1fa8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5520

From: Ankit Agrawal <ankita@nvidia.com>

Add a helper function to determine an overlap between two ranges.
If an overlap, the function returns the overlapping offset and size.

The VFIO PCI variant driver emulates the PCI config space BAR offset
registers. These offset may be accessed for read/write with a variety
of lengths including sub-word sizes from sub-word offsets. The driver
makes use of this helper function to read/write the targeted part of
the emulated register.

This is replicated from Yishai's work in
https://lore.kernel.org/all/20231207102820.74820-10-yishaih@nvidia.com

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 28 ++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h      |  6 ++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 7e2e62ab0869..b77c96fbc4b2 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1966,3 +1966,31 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	return done;
 }
+
+bool range_intersect_range(loff_t range1_start, size_t count1,
+			   loff_t range2_start, size_t count2,
+			   loff_t *start_offset,
+			   size_t *intersect_count,
+			   size_t *register_offset)
+{
+	if (range1_start <= range2_start &&
+	    range1_start + count1 > range2_start) {
+		*start_offset = range2_start - range1_start;
+		*intersect_count = min_t(size_t, count2,
+					 range1_start + count1 - range2_start);
+		*register_offset = 0;
+		return true;
+	}
+
+	if (range1_start > range2_start &&
+	    range1_start < range2_start + count2) {
+		*start_offset = 0;
+		*intersect_count = min_t(size_t, count1,
+					 range2_start + count2 - range1_start);
+		*register_offset = range1_start - range2_start;
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(range_intersect_range);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index d478e6f1be02..8a11047ac6c9 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -133,4 +133,10 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
 			       size_t x_end, bool iswrite);
+
+bool range_intersect_range(loff_t range1_start, size_t count1,
+			   loff_t range2_start, size_t count2,
+			   loff_t *start_offset,
+			   size_t *intersect_count,
+			   size_t *register_offset);
 #endif /* VFIO_PCI_CORE_H */
-- 
2.34.1


