Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875FD3FC16B
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbhHaDJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:09:48 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:1117
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239469AbhHaDIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq4Eg3QQR/y80Wnl1YFQq3uw0w1BERxc9J16Wdjre5aliTxUHChXnFq6PMGzt7PSm3x/c7AdNq0qki2wgiDZaLPeCHl4cK8FANHCxhJpFWHDwtfDGtowsxxRvAqgiommj4fknS7cMzxC5kKQnP5qYlQfRD0qvZzo6GVC7bClMHvvRT8pD8nyBGZg+FlDl6JQE0UatTVi4ZMlP4qE1jp7OtZBBHIKiMCSAx98bt7MdiZPPoOwv9R286zpBWwOqGT6dvetT2Irdd2p8VAB5zFE/f9rDdnrOwqyr3z+01HfUxQKdlvpQAHwPPW1t5Fn1sb0bGCqcsYw2bep+EulOqCAwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRoWwVZ0qFjyy84HJrH7KnAp6D0Tim4zu0pbGXeP1U0=;
 b=Li60Y9CyWh/dEtAnKkr2VUjBYMIVNrvAGhJHq3U+l6XtcylsTWoni2Vhv8qV3MV20zuK8KkJfhYAilitr4pQ16uH9fx9JXV0/BvmtETkDcDSCfW/NwEYO3ki1vvrNTt0NWMY2Ye4WamBjRwq5oqcYwIMFLVIsYbhBpKiWTUOG14AZuMSnNU6WcQQP7U+HhCp6IEBNgR54R4Rqhk6YtDiLVFXcdtliKhkq8h10vPSWdzm0ia4NXmqD/upW8/XltbaifrV9M+THjOEBtH0exApdP3HGYelU2JTbSt8M5wU4Wz5mcMigiYbCrFJynAtFK5u0cNwlLkcUGlTwjN9Sq+lJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRoWwVZ0qFjyy84HJrH7KnAp6D0Tim4zu0pbGXeP1U0=;
 b=W4sUj1v/EGdu4mFXeCmwT6kFEFSxezJkRhm3n8Si5M1Ukl0ZpOmcQJUCZ5KsG2Hi622ySIAkAS4xhRwc2xKf+LXEfM+uPxmhE+LoWd1QCCJovZM95G2Z8ZWT3XXemzt3ZHihfpTfRlRmc6mnTmHzECl/iBpr2UwCFIJlNF1y0QaVf2Vf9YIQCtNffLhUUPjbmGdb7KLIswKHgL0kx17KtvZoKdpAzfb2bKRsXj3T3T2O7frY524M3i2e7qN9w+9x7gUqZMfFxYptH1h4WIBgMEFP2PBAk+goYvZ6C+HsA0SpHjAvuuD3hTfRF7VKzVhwXSmtmngyOSd6IGrZCCExsA==
Received: from BN9P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::20)
 by SN6PR12MB4717.namprd12.prod.outlook.com (2603:10b6:805:e2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 03:07:31 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::c) by BN9P222CA0015.outlook.office365.com
 (2603:10b6:408:10c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:30 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
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
Subject: [RFC][PATCH v2 01/13] iommu: Add set_nesting_vmid/get_nesting_vmid functions
Date:   Mon, 30 Aug 2021 19:59:11 -0700
Message-ID: <20210831025923.15812-2-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4956911e-727e-44dc-3606-08d96c2c78cc
X-MS-TrafficTypeDiagnostic: SN6PR12MB4717:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4717B51C508DA6952E77F1FAABCC9@SN6PR12MB4717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: upqo3zLCzUfotU+WTyAYedipiOzp+sb9g8lHi/ujeplvDdrwTuPbEQExnehM1dTycNjwISUFaLbUrLxWSm+io0ubaQzE3nvZArGpjScw3ea8fXQ4fwqEubUbtnjN7GJFpfuksjfzgHHos01E4i2lunWyvhi78VTQROhqLAWaAKwUm1+wBpi7gCqSfda1cb68Yyf5jtrvs4M7fudaNDZdFeev+5MOOzm2pd2SBxxisdwBk/Aw0cAJv2lFFCLxn9SmbSQp6zQiNfFaKvklxHaoSHiIHszpSQVcf2UAcBcWEEVuq6jRoswF3YJE16zWUAs6T874bJ6xqLon+G+1Aakvj2ZZMHiwV39VE5mXx0phbbGPkjVhl9YusCOFn8TW6mxkuykmNhyJVXrom7zTzwFxljOs3kaXNxX4aPnSnuEBIdM8cT0B43qQTk1ND2riXnZsQZOSxyePL27COOPxMesetCpns6LCFwgL070mVnWoU6yespo+LjwdDpv0D16YyrlGuesSgF1pCxsTXCbl9C+ZPgMqSY7cXB1p/dVFa3Wv4Nq1Oqkx2T41p0Qu508qeZeWXtJ07cOvxei61cDCRvblGN5otFOEOaHMyz65zgDhitYljhEUx0TdTxTDXUsTo8mcfLcaF64trT1b0pBdUHXV5W1UOqra/L5YKux94U6K63Z/uKf7ThDrq4mxuj3sxgG9ynTFGoCLuQmk9L9VM6GYOxbszYWFK19ZSCTDgalIzkc=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(46966006)(36840700001)(5660300002)(36860700001)(336012)(426003)(2906002)(1076003)(83380400001)(186003)(2616005)(82740400003)(36756003)(86362001)(7696005)(478600001)(7636003)(82310400003)(8676002)(356005)(36906005)(26005)(54906003)(316002)(70206006)(7416002)(6666004)(110136005)(70586007)(47076005)(8936002)(4326008)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:30.8986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4956911e-727e-44dc-3606-08d96c2c78cc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMID stands for Virtual Machine Identifier, being used to tag
TLB entries to indicate which VM they belong to. This is used
by some IOMMU like SMMUv3 for virtualization case, in nesting
mode.

So this patch adds a pair of new iommu_ops callback functions
with a pair of exported set/get functions to allow VFIO core
to get access of the VMID value in an IOMMU driver.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommu.c | 20 ++++++++++++++++++++
 include/linux/iommu.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3303d707bab4..051f2df36dc0 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2774,6 +2774,26 @@ int iommu_enable_nesting(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL_GPL(iommu_enable_nesting);
 
+int iommu_set_nesting_vmid(struct iommu_domain *domain, u32 vmid)
+{
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
+		return -EINVAL;
+	if (!domain->ops->set_nesting_vmid)
+		return -EINVAL;
+	return domain->ops->set_nesting_vmid(domain, vmid);
+}
+EXPORT_SYMBOL_GPL(iommu_set_nesting_vmid);
+
+int iommu_get_nesting_vmid(struct iommu_domain *domain, u32 *vmid)
+{
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
+		return -EINVAL;
+	if (!domain->ops->get_nesting_vmid)
+		return -EINVAL;
+	return domain->ops->get_nesting_vmid(domain, vmid);
+}
+EXPORT_SYMBOL_GPL(iommu_get_nesting_vmid);
+
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirk)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d2f3435e7d17..bda6b3450909 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -163,6 +163,7 @@ enum iommu_dev_features {
 };
 
 #define IOMMU_PASID_INVALID	(-1U)
+#define IOMMU_VMID_INVALID	(-1U)
 
 #ifdef CONFIG_IOMMU_API
 
@@ -269,6 +270,8 @@ struct iommu_ops {
 	void (*probe_finalize)(struct device *dev);
 	struct iommu_group *(*device_group)(struct device *dev);
 	int (*enable_nesting)(struct iommu_domain *domain);
+	int (*set_nesting_vmid)(struct iommu_domain *domain, u32 vmid);
+	int (*get_nesting_vmid)(struct iommu_domain *domain, u32 *vmid);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
 
@@ -500,6 +503,8 @@ extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
 int iommu_enable_nesting(struct iommu_domain *domain);
+int iommu_set_nesting_vmid(struct iommu_domain *domain, u32 vmid);
+int iommu_get_nesting_vmid(struct iommu_domain *domain, u32 *vmid);
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks);
 
-- 
2.17.1

