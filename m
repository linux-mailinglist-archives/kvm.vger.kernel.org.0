Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E8564773E
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiLHU0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLHU0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:44 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D570B7E822;
        Thu,  8 Dec 2022 12:26:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwCapo2zZwK4+wDcF2bFtucTFd3VEY4Zl8Ap/oLThAf2gF7oZ2kwqd76F+CN0/6kiuqQOZsGxh5+YcCLVHx2W1qnMAYzoBnIwL4XcJcOZwoIFHvaBDe5dDKXr9NIHQdsKi8wz5rhqTVXAMtpKzEjbF1qkX6rinkSJX5mTxED5QJZQbWuQB6m3q3YrZg+3mFtIG1vq91UpfauQRRjfcQ/bYdUJMZzY8z80PCtCUTIYQbP0wL88fXg0jYz8HyYtISgPok8bSIgE81MjQyRhwJJ+i1FP/uoYo49atA2DfRZOjO6J8cC3nzOC+PKKa4wDG/f3V5wZuP/6rnweQWF6+hh3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s17iSIHEWLvLcqni5gT0nA9zsp7aUjUx2va6NFHyS4A=;
 b=OfVm+Z2R8lfgvlztvrJflJ0e9OcnRipwDdxPF8hztZN8VcaRgW0nsa5jalleVhnpkwrbwTHbW059Xh9n2DDl2XdyuSsD+bR/45UJ6ZmRST31EUv8W/yBoH8QuCDATSedDkqH9CXB0LYq9euUFbZ9uMZLBbZeBrp+7rN20mn+2bSyQ0nqpXnbKrEApkvohh2kTyhM80Y7LsNh30RdHBXhJ08c98fUDDZefCbmlT8xpQdmAyVgx4Syn48Gmg6her/M8m8md/TY3zJxTGctvgdDCPpZan3J4MvkPyzKoPX9Xt9TNjYT0e2hRBo1nwu3wBFQIdjkzZYIgTKQoq8CD1L2Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s17iSIHEWLvLcqni5gT0nA9zsp7aUjUx2va6NFHyS4A=;
 b=YR97Gcx0+kv8wydcd9dHSmijWq9GCRH//8MpEMWeovTLs4U9Kj1GaNIQ6AgGXPtSAj8lsW3aZ3X4yq4iz7KU32hd00PC96rhuVHBvWPKtD6miSG4yKiOTu5x7Z0m7YvsD1l2eT3eymqHJzGuUKu4S+biVJwuV/QTsVuOEamC5JeFhElD+vBUs000Hl/KmyLv7WaZ6F3WpU65AgtsC+3k6ALy2ucd+oXF7Vux3ZpCxe9O3oEPBO4piIbOoOOm5bSBnvJKPGRA+9IcQv9+LRo9fRg9auMFZsM2aN7QD7rfXCX8Ei9q/k231eh2oIBx4MqiRDBbG/VrgUv2mtt2HncD2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:41 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd 7/9] iommu/x86: Replace IOMMU_CAP_INTR_REMAP with IRQ_DOMAIN_FLAG_SECURE_MSI
Date:   Thu,  8 Dec 2022 16:26:34 -0400
Message-Id: <7-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cb709ed-7f45-41a2-0fd6-08dad95a8257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pP2Dtcfsq8+mx/bGzWG2iL7L1iYAtbsUHReh2xjfIWDvZNsfoVqCyFt3HYkUfjUDQBN9kBsvoOo/nkHFzmb5LRZJsLciZI4tdgHngo7ov8Ez83N5gVO5dY7DZi/1ddWr9K+SLXj/GoSuXG0P4SU3PsFIkq4hFLzJyWsQVeGVsQIYqF++W68PBEUKll+UAYweFXLdqIn9QdiIBgjoAUEZ4CBUqghft/fOYLbCZatukd+eRMDD/EzDWW2YU6dURYFTLpeUaEvM2l5wOZavtaRfMZbY/IUcxc56mHa3NqBVvwrn+3/+KXo56e4dLQGmHCRzlCN6wYffkrEkj0cDr0XMoReSzuh/UYgD5OA+Dmr2xkpjVbG4+u9BTMqRuYYxPoq3pbOAc5PlpXyNVDToKA72Nc8goh7JSBKLR/pEdddr9Dk+4YXkujOTgAD1OTahwbKnxeyKb1KrJoMCeENvQlGzLj5fBSK5fvOpMrWsMszHyM0upzeHKfxSh3W6v1wbWxIpooK+RVdIp3LbuAym7cVN6+hFP8ynpQuEtsHLZS07/avJ2Z40ik+bo3Npzau+30urLgDn4/ITzacz5tl+d9MtZTqxsJmLu/UE65/wS9IKn3DHiisGnbG2IKx5J0PxoNFMV+dl7W5wmRBOJzl1XlBJp+HjXUXYmnxo6r9zHX2Qn/Z25+v7HKr+SRMIMOO13lpI0Z05bwz5WzzcH3QUu+2Jag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7V0FDcNNKPUR8uC4Iv53n2+IIln+kLFafCMKdqO2HUfIcyXqauolc2Pl+xDW?=
 =?us-ascii?Q?jM1d/8JvjBpH2Ft+VpNPqdrGMhujQ8FdKlwS1n5FCwumMjHKnMPfdtN5p99r?=
 =?us-ascii?Q?rzQNAqNnSlKrs1jtD4jDBilDsG+HNW0J1ZtVNYHLBZwAtBGCHP1//73zGjsw?=
 =?us-ascii?Q?6ygwnrYvW9FEL5iUEY76DjmFkoeR/Hi3O/Iiy6VfrbY3qwGjSwpvV2PVfIjx?=
 =?us-ascii?Q?YSlOWz9Y7+SK6bwUSHhSncEhGTBmVsQ8xFmqJjXJJwJcE6vRFUs6GeflUMEj?=
 =?us-ascii?Q?X/aOjVoenmk0vG5XMfMikk2eYfSgejHzSWe/FmFp+qZlhfOQoVufPm/QDtnS?=
 =?us-ascii?Q?1AuvSwYjgXEizH5lxMMtkeMOrVeiBMR9Q6OvUX+jfqzqoP4rctg8n6A/TGWK?=
 =?us-ascii?Q?TitIte0Q0//njZgURfFkHThjgWF6ZE46yE+rjO62eE6nD/bBiW4f4nSIcp9N?=
 =?us-ascii?Q?7tDeXgQayBbcNOL4kLVdU77fz74D42gooCfkCW0Yay1Fw16bc6E78g9tPvxg?=
 =?us-ascii?Q?C7kdBmqTCPLh2X62ATVglpvn8/fzJHGObQHUxInvxlRJgoun/vZizSMNR7Xi?=
 =?us-ascii?Q?1NN+kk3thWOash9s475f8fXha//2Du1uyDbXc5zGKn0Rqi+Gw0XKuwKAr/hN?=
 =?us-ascii?Q?jab+IIhgxJ393kf4PBNAgQBPnpzVsXxhf0vIo26CYo+xnAHJBIUTaU6lR5Rz?=
 =?us-ascii?Q?NdHXtiWpQ8YJBU65vfjA5uy+i+b9l5vcSqGl3rs6MyLNZ6cnflgL5Xd5kDjd?=
 =?us-ascii?Q?hzcGDPuXYp9CW7lWdjXcFm2GfkfgWWSdDf48f/Dt3ULr88MJeZBgLK0FfBJN?=
 =?us-ascii?Q?AP9sUMJWT6zh+En4X3TSj5JAz4yTBpUgKA1ikskBooJ3x53j1T09qKLJLoXg?=
 =?us-ascii?Q?QZj78KJ8VT4DpftiwvLLnIjS1pIQPWbDycC2Q2kSrhevM/9fHgjMnO2E3JCT?=
 =?us-ascii?Q?ayKVKKkUJy3UMUPdNoWwK+jEGKhhYduJM0W7/ZfKrTHVsFLPIwWgYfJEgP+I?=
 =?us-ascii?Q?KdUiPmelGIqnREnKpOqSZBFLU/6tcWY2W4zpbe+sNRwB647WtCNgUfhWki9i?=
 =?us-ascii?Q?kSedUYSMmMdsOYOdVHmrABjKUxkuor4J0AzUvjeADN1wJdEtQofi+W1oWUF7?=
 =?us-ascii?Q?c+iL/pVTuRa6SqfgLKJFTc+Mm4du30VDss21kq+8Ec6iAHOAWjfUUFb1X4kC?=
 =?us-ascii?Q?nTTog/6qKec2NyawVoscsneUa+Nd29xo56OZ+nnzzXh/+qiB01N+7LOBC+uP?=
 =?us-ascii?Q?H2DUO/2NnZ7edHnyzqnsVUEVw+CNs4Z8owQhXO+m3MVWXhcVE1kdA3x7EIV6?=
 =?us-ascii?Q?Bq7JOG+6pguwsCOqT6EL2Al2UpPcrHScciw/FHo+LayZkMWDm/nHQeOai4NS?=
 =?us-ascii?Q?/mFe2cg/SES3Skd2ZFdnUO5VlvgAme5x6lVYqggDVvEzbFhEFVcuLIrAAsru?=
 =?us-ascii?Q?wDgloy+84nIx3Kd0uxfZNVss13W33ZmcADNxqYbKKHoIQaKX8dHWKnnGx/8t?=
 =?us-ascii?Q?5ZxfW/vAqQCoQCnmgGz584bP7MSBok9WQIYmvW9f08XstuZsgbH6YSPmcQor?=
 =?us-ascii?Q?of+I/nyqjd8gcXE7Jiay1JLJxPuutcuje8T8WEBV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb709ed-7f45-41a2-0fd6-08dad95a8257
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:38.5717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Wxvwq4YKn2p4HCZgsL95RPUDyOOqiaRq37zkN/LG7SzvxHllinvCQW/g/v338sY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On x86 platforms when the HW can support interrupt remapping the iommu
driver creates an irq_domain for the IR hardware and creates a child MSI
irq_domain.

When the global irq_remapping_enabled is set, the IR MSI domain is
assigned to the PCI devices (by intel_irq_remap_add_device(), or
amd_iommu_set_pci_msi_domain()) making those devices have the secure MSI
property.

Due to how interrupt domains work, setting IRQ_DOMAIN_FLAG_SECURE_MSI on
the parent IR domain will cause all struct devices attached to it to
return true from msi_device_has_secure_msi(). This replaces the
IOMMU_CAP_INTR_REMAP flag as all places using IOMMU_CAP_INTR_REMAP also
call msi_device_has_secure_msi()

Set the flag and delete the cap.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c           | 5 ++---
 drivers/iommu/intel/iommu.c         | 2 --
 drivers/iommu/intel/irq_remapping.c | 3 ++-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 8d37d9087fab28..a8ddcf42dd15c1 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2272,8 +2272,6 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_INTR_REMAP:
-		return (irq_remapping_enabled == 1);
 	case IOMMU_CAP_NOEXEC:
 		return false;
 	case IOMMU_CAP_PRE_BOOT_PROTECTION:
@@ -3672,7 +3670,8 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 	}
 
 	irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_AMDVI);
-	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
+	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT |
+				   IRQ_DOMAIN_FLAG_SECURE_MSI;
 
 	if (amd_iommu_np_cache)
 		iommu->ir_domain->msi_parent_ops = &virt_amdvi_msi_parent_ops;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ebe44a07c4b00e..8037a599ade0d6 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4453,8 +4453,6 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_INTR_REMAP:
-		return irq_remapping_enabled == 1;
 	case IOMMU_CAP_PRE_BOOT_PROTECTION:
 		return dmar_platform_optin();
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index a723f53ba472f9..0972f47e6ec166 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -576,7 +576,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 	}
 
 	irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_DMAR);
-	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
+	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT |
+				   IRQ_DOMAIN_FLAG_SECURE_MSI;
 
 	if (cap_caching_mode(iommu->cap))
 		iommu->ir_domain->msi_parent_ops = &virt_dmar_msi_parent_ops;
-- 
2.38.1

