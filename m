Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7943FC167
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbhHaDJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:09:44 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:35585
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239451AbhHaDI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eikqjWxYEk4pWud+eeUCbNaGi/9tKxekex/EuxIKAecTHKMQZ0U8lNbEuKx6iK+Uo0SSViGPctZCe/nTrS9mFMMdlcLMyF0e5uF5fGWt3rpJY98mm5rYW4VZDea2P9tU2gssgVbXqC5xFEI4C5lJN7ytXCWYHoWSQTJQkAJQJ2B/L6IXtd4gFIOsh0BNaStO6ra5ohji7eHjewLqtTmggFhJMs2r3q7+JQ97vhNnTDJKpXwRZWJmSW9MT7pUa/FMEm/MlmNOXo9uzDmUh7809/sbFhtBeOJsTg6LZ7ODyc0XlumRL9cH/bY/4kJk2i4QA9FhJNvVHcZ4/OHotYZWWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbDG0zI6j2pw6aVQqaU7ogclbWFVfc3P5oXdSAnOhAA=;
 b=O0bpK/0NNlBgO8XlkP+Hem9LgKWfxtEsm6bJPFiU8KbyDTKOswBeHg0bgxmeXFfwHl8SrMyVqDgMMFMc8twgbERTZPzAgdlVe0fRpcqy0x5QTtVpvrLIfFsYqb0/+HhwdDwifl7sf7KpETlSSdKuAQdt5DEP7N8ChCbaFsneu2MA1+G5ZxWa9Z21LcGIYiDsnlc+rOj/3HJwScBkrR1RqfkR+zvBfTPiz8lIGG2oh3XRX/MgV1e2YQfJDZ08exJwlqJ4t8T4Tqvr/dNOwinUsgiJteI9C06NdrzhaT7R8C+KTb/w9Mx/YZBV1TlJzFQa+cSg0taG2FHHpxkWUZYeug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbDG0zI6j2pw6aVQqaU7ogclbWFVfc3P5oXdSAnOhAA=;
 b=kgLOptub1TVUiXPHT4Ge+7siZlimlD0awScMvc/4XzsAMMU/6GkbtfSt+bM8uAuDl2p1jjVWIrwc0Vpj1ZSFZN+PhGXlAYJ9QlqOkXA4z92jUJkzJHUc1S0t7DrK30wVCQQe2VkgECGLg5xnWnYYiQ6FgWQ6f/ZbrZsfk9SsdxlamJYYzKniy3yiyA0TZA9pcYSl/5Mw17AIrXYW/8pZIYDlkHPpYbieARk029drpUt10sGjkZ5zJybl5NLQHIFCxiD7zyeRbGhyz5vigOoDj4typfVQipoU+/HeU/MEwwHnLOohpK3yEAY+sYNaDYtJf0tUjkH67NIMPDcVMGVrvA==
Received: from BN6PR16CA0033.namprd16.prod.outlook.com (2603:10b6:405:14::19)
 by DM5PR1201MB0235.namprd12.prod.outlook.com (2603:10b6:4:4f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Tue, 31 Aug
 2021 03:07:33 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::1c) by BN6PR16CA0033.outlook.office365.com
 (2603:10b6:405:14::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:32 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Aug
 2021 20:07:31 -0700
Received: from Asurada-Nvidia.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:31 +0000
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
Subject: [RFC][PATCH v2 08/13] iommu/arm-smmu-v3: Add VMID alloc/free helpers
Date:   Mon, 30 Aug 2021 19:59:18 -0700
Message-ID: <20210831025923.15812-9-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ee3b801-5141-4d08-3af7-08d96c2c79f0
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0235:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0235EC8F24104CB9BB557922ABCC9@DM5PR1201MB0235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HV9wxzwE5Y9MOelAVlk/7KpB1KkxnNllpsqTIyPnzWK4q3hVp/db0TYlyWk9d/9Pa+eGZaGwqgI+9OZaPH0erLu0X8fhVjtnRtDkgZC2iJGpBGHj6KoK8NCqVH/7zTKy4qHdZxScUf2ykAW4vf2bc39JwZJBMrdZgG+gyA6CnPBy/Dr2Q4i8JDBpmN1QyXf5OWCBDlTt7Ck4uklbaGC1ivGVhiadgxvz7hB9GyxOB3E2V8avrCQpn99gcTv7mvGVHYn+n3EfqnmPswE1OHXWptAxk8LCjFw5pbwp68YySbb8F/YwKppNrEG0CRo1bishJ1cpD7dIYk5E53xO4sIPk6VYBlwhGZsIuesRx1AI9qNkcO6mLU8j6Prx32NRarn3f21Lfd/rtEIakrbT9zGVAJhlwpZMHvBSiYqtvYA+3zpki0ZEh8QOpJKfZjFsTFMRj/wWyUbQdMg0dWsRIhKWYuyKfA+gj53gLxbeBdOezDjBFK1pWqGaUpW8UYYHtghyF15u4Xm5iFCW+YX1u2Xop5jMyYHBharOqhHD6D3/IguqUbRi0h7LD82u12eLQeACc1/pHeixcLKh2BujPXTGYxbR7Xf2tsh0TgBXMbS9IZmNAbVwLdxku3lTpyA1g+f5tGb/SB2kMnxpekeIMAB8fzCNxcsjCjPO+Uy7furdBz9UholPShKOGXC8BAUPaXWozPPXv/O29guiRF9toE7Sf59fuatMLEER7axDuQbqnus=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(8936002)(36860700001)(82740400003)(336012)(478600001)(82310400003)(47076005)(1076003)(26005)(7696005)(426003)(7416002)(4326008)(316002)(2616005)(5660300002)(7636003)(86362001)(8676002)(54906003)(110136005)(70206006)(2906002)(6666004)(36756003)(186003)(356005)(70586007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:32.8094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee3b801-5141-4d08-3af7-08d96c2c79f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

NVIDIA implementation needs to link its Virtual Interface to a
VMID, before a device gets attached to the corresponding iommu
domain. One way to ensure that is to allocate a VMID from impl
side and to pass it down to virtual machine hypervisor so that
later it can set it back to passthrough devices' iommu domains
calling newly added arm_smmu_set/get_nesting_vmid() functions.

This patch adds a pair of helpers to allocate and free VMID in
the bitmap.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c0ae117711fa..497d55ec659b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2032,6 +2032,16 @@ static void arm_smmu_bitmap_free(unsigned long *map, int idx)
 	clear_bit(idx, map);
 }
 
+int arm_smmu_vmid_alloc(struct arm_smmu_device *smmu)
+{
+	return arm_smmu_bitmap_alloc(smmu->vmid_map, smmu->vmid_bits);
+}
+
+void arm_smmu_vmid_free(struct arm_smmu_device *smmu, u16 vmid)
+{
+	arm_smmu_bitmap_free(smmu->vmid_map, vmid);
+}
+
 static void arm_smmu_domain_free(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ea2c61d52df8..20463d17fd9f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -749,6 +749,9 @@ bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
 int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 			    unsigned long iova, size_t size);
 
+int arm_smmu_vmid_alloc(struct arm_smmu_device *smmu);
+void arm_smmu_vmid_free(struct arm_smmu_device *smmu, u16 vmid);
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 bool arm_smmu_master_sva_supported(struct arm_smmu_master *master);
-- 
2.17.1

