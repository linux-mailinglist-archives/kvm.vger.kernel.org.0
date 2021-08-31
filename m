Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12083FC143
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbhHaDIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:08:39 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:48737
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232951AbhHaDI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lt/Dqf4ZGw4mNUcxHygmyKnoSt0V3SQhsQ8coy6qd8ZioQN3LaUlbgQsrzE8kJTiXXAWDLMBrg4WIKZI6Gzphf0Cf6wEwLUtrcMUa0OGPs23P3sV7XReJAo3TmKUakwc8yDSiRsnwgeFYG5II3pLCHYmQFHB6qg8F70mMq6gsohuh+T/61oNFzZbxyiG+N1QJ5KNe0GyhzFCg4/bOQ+5Yeh+jrrzltNUZ/ZoA2ewpFfmFtMi1b7Kc4ereB6lYz8vyNERu/zrgbkqwuH66Res7Ohxig8Clm4R7bVfTao4uRVfaw5z4XcbfOUhl4n1iqpyki2d/gZgaysATV8WnBj8gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrMOqGxGurmsFmCdMz+G0sNDtvATVDXIHl4AkPZBxqM=;
 b=e6WUaC/wZdCzEBTNhcGOIAC7NHLrJ4fhbYOacWNh34fpo3Rv4PVoPGtfdsK8HWaUo+xH167kOhNc/TL28HmG2peDrhI3KPT23MsyKAI6hXS8J35Nifp6RG52pe7ABX/+7iq0/+fui/XwXeBvoDWa6dyu0EbQfFWEtgi4j+cMdnA6pcI8JpI1zU0kj25Mn/mx9BZTMWaExBXiLpPLZkOmY6TBy1ozdizwGtRau4sFFG+KQkq+BJ1xRpYg9HJ+otLPrqGgL9H9OV7iYMzZ4tksuzV5VO2O1a9VicQXLGCVvW56HzkElZnue6y8q0uNgIzKN4pBSIgQz+poTVTRUlePzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrMOqGxGurmsFmCdMz+G0sNDtvATVDXIHl4AkPZBxqM=;
 b=KBV1T2Un9RT5Y5MvFOnCfTslr+flu3vmv1plIacxuMSHvGGfA8NO+cf1NlJUO0OmD9g1ecl0b1PfR9tUgOg9sI1HU4K7RGGi9RPT+DFPv+SZxuAbZUm3frMjm0hS4EbkPp5VoeCKKHUiYZ7OJhmGi94EhDVvcU99LlN+KORoTHuEoNSai2124aLoVt2c3RoLjH6zWCHuS2EkQJSkApwl73Q3ajuuXP+izPsA0RBQAjPUpa5KA4JkPLrS5X4aErxpkUk5O/nIn8e5+EZNsXAFTnJQMewPZ/xhwm8MB8nkqbAy+lyRbTn7G4W6rfN9ja1MR04hiQCx+Lb8KaNOH/ZBkA==
Received: from MWHPR07CA0014.namprd07.prod.outlook.com (2603:10b6:300:116::24)
 by DM5PR1201MB0091.namprd12.prod.outlook.com (2603:10b6:4:57::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Tue, 31 Aug
 2021 03:07:32 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::50) by MWHPR07CA0014.outlook.office365.com
 (2603:10b6:300:116::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:31 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
 2021 03:07:30 +0000
Received: from Asurada-Nvidia.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:30 +0000
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>, <corbet@lwn.net>
CC:     <nicoleotsuka@gmail.com>, <vdumpa@nvidia.com>,
        <thierry.reding@gmail.com>, <linux-tegra@vger.kernel.org>,
        <nwatterson@nvidia.com>, <Jonathan.Cameron@huawei.com>,
        <jean-philippe@linaro.org>, <song.bao.hua@hisilicon.com>,
        <eric.auger@redhat.com>, <thunder.leizhen@huawei.com>,
        <yuzenghui@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [RFC][PATCH v2 04/13] vfio: add set_vmid and get_vmid for vfio_iommu_type1
Date:   Mon, 30 Aug 2021 19:59:14 -0700
Message-ID: <20210831025923.15812-5-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ec9e46b-e366-4cf8-f6b3-08d96c2c7941
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0091:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB00913AB33FE29DD22126705DABCC9@DM5PR1201MB0091.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3rTT76KiffEVcyLRNPGPBBgg+qEj2IpEQ0nv5wun9UlRtIWoagOlCbvCkjWEX8cUvvHSKkb1FlB84eo2or3sVLvk/hVPvuFedtcJjoocjTS19WSj4Y5NCdNna9zXRmKvwj2IsCjwZ6RtO02V1P68uzdbTe67ESy17dwAxaEhxNS9fZPus8gDDpMbubp70S4H0fmqlOH72Av/vuWcuYecC+ke1hcHkRf8OrlRjeswtxu49liquwUvXujmddx539cyYEoc/lBaJIUo1r9mMEUc2Xc/CUGKwMKtTEgLJsOI21rOplDUp45m6UGrIBj7Ou/qIEzrg5Hl7BaZCvAhcBJzceYEIIK7uiz1dx4ZUOi6qzVaVV9ZYHdgwL1eVdwmV/OokpREjcCp2AyPXeWKWQ27LR1UYvgV+L5CQzuZ2E/10YW71VMQuStiIT6whIbHjS+GS0Q24fikTK+DPlH/nRByIcKly+wbVegCXS5ulMn6RvpxHJjNJy5bVxvKI9HTHNQfuDdoPmu23onQ3mOT7h6JbOUrPrhUYKvtocYg8JUYSquz9f3Y2f7cBbGu+1SDIXVSnmtBVic3gJe6v18I3nd+Af7+xuJMba1jW5B9pH11G2aRrucXSKn167QX+L4WVm+jBYV+W4v+2D4NxgN8At2JlKkxGJYzjLIE+zSW5SFesJpQZK6dG3T+WoPT9++t3R64z4DJUaUhmdJ2TcNmzE2qV+KdMQNdQVSO+nymNPPzUs=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(36840700001)(8676002)(186003)(82310400003)(6666004)(7696005)(36756003)(47076005)(70206006)(7416002)(8936002)(4326008)(426003)(2906002)(82740400003)(5660300002)(36906005)(356005)(86362001)(316002)(2616005)(36860700001)(336012)(1076003)(110136005)(7636003)(478600001)(26005)(54906003)(70586007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:31.7283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec9e46b-e366-4cf8-f6b3-08d96c2c7941
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A VMID is generated in an IOMMU driver, being called from this
->attach_group() callback. So call ->get_vmid() right after it
creates a new VMID, and call ->set_vmid() before it, to let it
reuse the same VMID.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio.c  | 12 ++++++++++++
 include/linux/vfio.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c17b25c127a2..8b7442deca93 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1080,9 +1080,21 @@ static int __vfio_container_attach_groups(struct vfio_container *container,
 	int ret = -ENODEV;
 
 	list_for_each_entry(group, &container->group_list, container_next) {
+		if (driver->ops->set_vmid && container->vmid != VFIO_IOMMU_VMID_INVALID) {
+			ret = driver->ops->set_vmid(data, container->vmid);
+			if (ret)
+				goto unwind;
+		}
+
 		ret = driver->ops->attach_group(data, group->iommu_group);
 		if (ret)
 			goto unwind;
+
+		if (driver->ops->get_vmid && container->vmid == VFIO_IOMMU_VMID_INVALID) {
+			ret = driver->ops->get_vmid(data, &container->vmid);
+			if (ret)
+				goto unwind;
+		}
 	}
 
 	return ret;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b53a9557884a..b43e7cbef4ab 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -126,6 +126,8 @@ struct vfio_iommu_driver_ops {
 						   struct iommu_group *group);
 	void		(*notify)(void *iommu_data,
 				  enum vfio_iommu_notify_type event);
+	int		(*set_vmid)(void *iommu_data, u32 vmid);
+	int		(*get_vmid)(void *iommu_data, u32 *vmid);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
-- 
2.17.1

