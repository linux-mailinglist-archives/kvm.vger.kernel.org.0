Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36CB3FC148
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhHaDIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:08:41 -0400
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:46177
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235848AbhHaDI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXQY2/c8UMoTWvjadwUZizDdwcwOOlTs16EJmI/1Uoy/R6BCys/qBWZdji2qYL/GJ9chN1kvlbIzACv8kYSob3DMV/IGft61fLWdrcCmRmY8+viXkntrw3AHs4BX8x6xVA5y1CagaTxBpbLZicTXOTaC/dEACvp6Tvj6a3PJcoa253nilBrDLeeG8sSQRMq4lgeuUzor9q+qLThtkJMS97eWeBs5akCuUVles0YyszH7eIy9Yajm0tBKJdphswfb6V6sJhj9sdekILE6pP2HSKC3agrP76GxOujItSNras90aW3VXa9U3LZNtb81LW8nkCXIaS5T4CjNbrJIKJC/hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDMbfms/MBqimrI6f6S49Ejrs+ZoatK/kDmg/MWh+Og=;
 b=jINwnZCt5l/WXhOFgKx7e3u9V1mFGjnajdBYDP4qAzFuGUlItsH8yDPy5r6jBSOgQp/3VveUsjHsdxy8kIHMdtF56C661DgRsCbAmI/yhGeneTzMQolxkbkkCNcjprxgAoIxzWZfy9UORE1yNZNav89Svbb0sGwqLuzmSPVLx1mJqLLIWQRDW2EFc8bRPgkRNeBZ6HWXIUVEifWcWS3HGcJ7KFNm7OM+7bYFihtJizlKX3BRUslOXrCm79Xk7NyyU5KpzqYFb1hFSrhdEE1ox+KKpFWI0dXTpXzG48ELJeCEPDRWYRqfh1yKK0eYKWRRbNZXIdHGpJTgWaW8FtfwyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDMbfms/MBqimrI6f6S49Ejrs+ZoatK/kDmg/MWh+Og=;
 b=dDAf/HoCD4Tx/T4i9EmTIlL+USUM0WWtVSTEZCxaH8VJA5sszJWK4TMPON1NPAZ/U1pCJF7MlPfo6aUecJ+XBwdmOdmr3/NOGZ+txO+EfMvXTx1YlcoHf2jsHCaBFN3sNLCQmpjMkZMCcudkznzHXVL55hcp1KJyyOqw8IIG31wMIhi3AZyKerUe4Q9riZbSeiTxQXz7haRotF4DUDOKssMqQ7PRu36uTowGlKNCQ6MFvaqEMtaKLeujn4/WQvoNJ/jVkjWKjDhtyrCDUAk7zkt/wRVjvozGeZ90SMs6iFskNAgkzM5QpxGQbO3Rak4eBTZYOCICAZfYecBKzMNwMQ==
Received: from MWHPR07CA0007.namprd07.prod.outlook.com (2603:10b6:300:116::17)
 by BY5PR12MB5509.namprd12.prod.outlook.com (2603:10b6:a03:1d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Tue, 31 Aug
 2021 03:07:32 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::b1) by MWHPR07CA0007.outlook.office365.com
 (2603:10b6:300:116::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:32 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
 2021 03:07:31 +0000
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
Subject: [RFC][PATCH v2 07/13] iommu/arm-smmu-v3: Add shared VMID support for NESTING
Date:   Mon, 30 Aug 2021 19:59:17 -0700
Message-ID: <20210831025923.15812-8-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 525f8d83-ce64-4678-a839-08d96c2c79bb
X-MS-TrafficTypeDiagnostic: BY5PR12MB5509:
X-Microsoft-Antispam-PRVS: <BY5PR12MB55099D0214B4DFB72F3C38FBABCC9@BY5PR12MB5509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNJ9XZVNTEu5rbzPzu15BUtktXAgjYh9KB/v/PC1eV9bUsrGSCU4A2nTODwHL1Jr5/hSDozqJWCJD5IqAODvDZwW1spF+s3MUyG9D7aevu59zdy1DVr/H31PpGBONbwAacKGGkJAGqnpk4jnobPHPsR6gS2r27yOwUZ4KjGjoiGSxZug4YPLxvDQMAifpDqp5jCAHx9yQVjrkTEz3N8DKm7jLR0Wr3fPXn+Mmq7gW1DJoKzazEXqLF6doM79dq2XygFRc46UZcsSjjg6lqQVUh9IVa8fDCoVyPDv/uP2eoSkpneHp8QFa9GWSq/baMvq6GYGob5Fb5rpFAQBKiWDKi9UhyAFDkOM6o3HfX3E2d62uCPv0Co7gLaFSfC/fMVwIIu9X4szjHnAWN26/FJyf7A+AGnvJGzL4JFPckCYJxJR5mSqraumgApF3UcVTbkULWJdC2KKxh+0+CmB34nLCgeQcxwzWwjPQjtGzQA0VWhRfd5olHWqPIf/3jNDIEzepxhzbD4G+5mwhX8c2FIPtuYfJ/2wZjIp4hv8q3rt193fldTpYICt7V+CsuhqQ9FpvRkK3C4pDxh+gRNohnhc1OgQWuzBtNI1sRVqMeoPgOj6BiJKRLeI2y8K6DxEsrhW5pfTk4g8OdaGm4LRzTasZEBuyaKHMLOnphA4nNKDFJRbBbv7Dh96YIDwt1RxGgHLR5lUBgnbTR9l10ZbDH+KeHoNfDEx6Lh1ylOPZqDYfUM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(36840700001)(46966006)(1076003)(186003)(36906005)(70206006)(36860700001)(8936002)(2906002)(2616005)(426003)(356005)(4326008)(336012)(26005)(6666004)(8676002)(82310400003)(47076005)(478600001)(86362001)(7416002)(83380400001)(316002)(36756003)(110136005)(5660300002)(7636003)(54906003)(82740400003)(70586007)(7696005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:32.5218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 525f8d83-ce64-4678-a839-08d96c2c79bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A VMID can be shared among iommu domains being attached to the same
Virtual Machine in order to improve utilization of TLB cache.

This patch implements ->set_nesting_vmid() and ->get_nesting_vmid()
to set/get s2_cfg->vmid for nesting cases, and then changes to reuse
the VMID.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 65 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 +
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a388e318f86e..c0ae117711fa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2051,7 +2051,7 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 		mutex_unlock(&arm_smmu_asid_lock);
 	} else {
 		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
+		if (cfg->vmid && !atomic_dec_return(&smmu->vmid_refcnts[cfg->vmid]))
 			arm_smmu_bitmap_free(smmu->vmid_map, cfg->vmid);
 	}
 
@@ -2121,17 +2121,28 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 				       struct arm_smmu_master *master,
 				       struct io_pgtable_cfg *pgtbl_cfg)
 {
-	int vmid;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
 	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr;
 
-	vmid = arm_smmu_bitmap_alloc(smmu->vmid_map, smmu->vmid_bits);
-	if (vmid < 0)
-		return vmid;
+	/*
+	 * For a nested case where there are multiple passthrough devices to a
+	 * VM, they share a commond VMID, allocated when the first passthrough
+	 * device is attached to the VM. So the cfg->vmid might be already set
+	 * in arm_smmu_set_nesting_vmid(), reported from the hypervisor. In this
+	 * case, simply reuse the shared VMID and increase its refcount.
+	 */
+	if (!cfg->vmid) {
+		int vmid = arm_smmu_bitmap_alloc(smmu->vmid_map, smmu->vmid_bits);
+
+		if (vmid < 0)
+			return vmid;
+		cfg->vmid = (u16)vmid;
+	}
+
+	atomic_inc(&smmu->vmid_refcnts[cfg->vmid]);
 
 	vtcr = &pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
-	cfg->vmid	= (u16)vmid;
 	cfg->vttbr	= pgtbl_cfg->arm_lpae_s2_cfg.vttbr;
 	cfg->vtcr	= FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
 			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
@@ -2731,6 +2742,44 @@ static int arm_smmu_enable_nesting(struct iommu_domain *domain)
 	return ret;
 }
 
+static int arm_smmu_set_nesting_vmid(struct iommu_domain *domain, u32 vmid)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
+	int ret = 0;
+
+	if (vmid == IOMMU_VMID_INVALID)
+		return -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	if (smmu_domain->smmu || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		ret = -EPERM;
+	else
+		s2_cfg->vmid = vmid;
+	mutex_unlock(&smmu_domain->init_mutex);
+
+	return ret;
+}
+
+static int arm_smmu_get_nesting_vmid(struct iommu_domain *domain, u32 *vmid)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
+	int ret = 0;
+
+	if (!vmid)
+		return -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	if (smmu_domain->smmu || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		ret = -EPERM;
+	else
+		*vmid = s2_cfg->vmid;
+	mutex_unlock(&smmu_domain->init_mutex);
+
+	return ret;
+}
+
 static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
 {
 	return iommu_fwspec_add_ids(dev, args->args, 1);
@@ -2845,6 +2894,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
 	.enable_nesting		= arm_smmu_enable_nesting,
+	.set_nesting_vmid	= arm_smmu_set_nesting_vmid,
+	.get_nesting_vmid	= arm_smmu_get_nesting_vmid,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
@@ -3530,6 +3581,8 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	/* ASID/VMID sizes */
 	smmu->asid_bits = reg & IDR0_ASID16 ? 16 : 8;
 	smmu->vmid_bits = reg & IDR0_VMID16 ? 16 : 8;
+	smmu->vmid_refcnts = devm_kcalloc(smmu->dev, 1 << smmu->vmid_bits,
+					  sizeof(*smmu->vmid_refcnts), GFP_KERNEL);
 
 	/* IDR1 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4cb136f07914..ea2c61d52df8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -664,6 +664,7 @@ struct arm_smmu_device {
 #define ARM_SMMU_MAX_VMIDS		(1 << 16)
 	unsigned int			vmid_bits;
 	DECLARE_BITMAP(vmid_map, ARM_SMMU_MAX_VMIDS);
+	atomic_t			*vmid_refcnts;
 
 	unsigned int			ssid_bits;
 	unsigned int			sid_bits;
-- 
2.17.1

