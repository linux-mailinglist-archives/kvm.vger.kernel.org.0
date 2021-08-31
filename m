Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B16B3FC156
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbhHaDIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:08:43 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:15841
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239495AbhHaDIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1xFxKlBM8mJcOJLmQPxtTQ0MYYdJWf4bxR8sNURG3akD6PnJzOI+KvvBRCstIHMeTidY2eWNUYUIVQgmalsj/5GnGVFWozWYZ5EHOEcsNNJDMhn0zNxKCUwhrZIDuf5a7Rq9NAFgwhRh7k7KLZM8GZg+Dnr7Wyo9IbG2K84mBHXBdYKC4Qg8jfCkCtIx0FDBWcC2xviyDmXE+CsbSTXKV/n6zGH+LWByTYNPPuXdKmlMdCn4kVDMdQ6tc9ViTbJ0n636xLD8yjd+4iJ7gGd0yST4xOVVHq3WBOXonEcgacfbcWcNBynxQRGYRFANm+hk0UTtvVykxS4tlv9tluaDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBQR3PlLgKXHIAgPGhDZTAgNlzXuAHQFjOqpjbPiCFM=;
 b=CruqpJEkdRMmSQOm4Y1mMPqs0xPIiVTk+5Oe5slgJkwXUmQIygkiOJyjcZ22OEMuc+hu68O9j5aGf1FD9QjFPfluakZSTx7+Q5ZsPGR26/s4tMhfA0bcSiAvcWDmxfU/leqFuGTm7DI4dQame+Q3rddu+H4WSUmS6vzi5ojseA1gM2jcd71ew2l7yV+9UQpiQZhi0IaAo/GdP7oEOvqIBU0aDUNEBa5n6n0uTlqZ94ZYtAavFrwsbiORwwOdSplhVH8QDEyiIgpJZmCxh91nwI9ukWPdtWwZgWeSk6ZJ3O8ljOqTmfTXSjizsB0/Rzb67fM6g4gfjTi4Gqv5MEYKug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBQR3PlLgKXHIAgPGhDZTAgNlzXuAHQFjOqpjbPiCFM=;
 b=gU6YasDl9hRIdW5m8LWzz9e+D3ibqfuruUQTKoDufnUGoNTo2dr1eB4sRuy+WFzP/X5H8FnuWo73WLQeebXTLFWy4/Xfo/QBohPeoMoyccbIIvV5lh25GmCEmFpdej1mLgEqNDSABz5Re62W6aLKTMv/3H7eu5uohmXqR6nl/HK7dmQzI186cv9aVs/C2+QX4menEHRyWB2JEN8Gf0tWiPgYrTX/3egMpPoMBp0EQVddSPgZZAiO5DMx4WYdE6VRgEdvFWDKCZsXwL6Ka1UqrUVMOFYeyjTL9YDkZT4hx8XqhBOAc1P2TlvN4fwfktxRPrV9s34peIvK2115XX3aog==
Received: from MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15) by
 DM5PR12MB2405.namprd12.prod.outlook.com (2603:10b6:4:b2::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.23; Tue, 31 Aug 2021 03:07:34 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::83) by MW2PR16CA0002.outlook.office365.com
 (2603:10b6:907::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
 2021 03:07:33 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
 2021 03:07:32 +0000
Received: from Asurada-Nvidia.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:32 +0000
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
Subject: [RFC][PATCH v2 13/13] iommu/nvidia-smmu-v3: Add mdev interface support
Date:   Mon, 30 Aug 2021 19:59:23 -0700
Message-ID: <20210831025923.15812-14-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c2e30b6-3247-4409-1714-08d96c2c7a5f
X-MS-TrafficTypeDiagnostic: DM5PR12MB2405:
X-Microsoft-Antispam-PRVS: <DM5PR12MB240549D466960AD4E862544EABCC9@DM5PR12MB2405.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehHsCphK9pRPOvXBhfEy6AYLy0tT0mAZ3Ai5rBCFDW5tVOb4nx7EpzBRGFuxYxwIMte11bHSBg7zgdGZ1DM6l0ioUKTke80bZLBUg0uOASWyx/AgaR7ArSZuM+eUyCTtU7hujkZT21ce4OnpDSFZRN23Ja+jdttfqd7aqjBB09OAaxQ+1mWkValMtVjqQw1BTG4pEaINDxEtMPay8Kv+Zi4ua1rerkwGImFNW9CAFCPWGQkH6nBSWD3nCm3rlEoxihUnL5avyWwXXA8zbssiIP71fd8T4zujF+l5tY5wpF4s5FTSpOAjrn/DuMntKudQg+2VTmqUVX46lKhg97eAo1kiRyZ2vc/F/bIKJgkmEBQA0n8qAU9nn1xmreWODiSxQv9KAzh9l/88b/cEVuGkgjdU7h++zyk8zpIIWzfwljGnDUurQ7cddhe0saCcMxeCNKFfRAFi6e1wT8BWbuXY9QpHe1ll3TFbNsUgo1ksCh6BFB39Xp7EYgdNTpAX+1xecQEnBrKBsacbv8eRAa9vCSct7kvRbIfa/UpmA7ffDKYFGY0G6NdeAmkwsBGdLwAXMmXpBXEk6j+oozIfrlvYYRA3UO8fXjI+aDsYI89AXarXYC7KhGwnu6KzVhmuPCwhW42vvIjH9+1kuqGZDSrScIRHcuxfkyOBQT+1s/IblFHeLMYDHhQ+1H58p4JaeUHGgsznOwvpf6x0dWsswPBLuhQ0kztntlpnsK4He/IZ5c8Pn30fVKZundwJejwDiHKz
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(2906002)(36906005)(83380400001)(5660300002)(86362001)(7416002)(426003)(4326008)(508600001)(186003)(336012)(70586007)(70206006)(7696005)(36756003)(2616005)(110136005)(26005)(356005)(30864003)(7636003)(54906003)(6666004)(8936002)(82310400003)(316002)(1076003)(47076005)(8676002)(2101003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:33.5639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2e30b6-3247-4409-1714-08d96c2c7a5f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2405
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nate Watterson <nwatterson@nvidia.com>

This patch adds initial mdev interface support for NVIDIA SMMU CMDQV
driver.

The NVIDIA SMMU CMDQV module has multiple virtual interfaces (VINTFs),
designed to be exposed to virtual machines running on the user space,
while each VINTF can allocate dedicated VCMDQs for TLB invalidations.

The hypervisor can import, to a VM, one of these interfaces via VFIO
mdev interface, to get access to VINTF registers in the host kernel.

Each VINTF has two pages of MMIO regions: PAGE0 and PAGE1. PAGE0 has
performance sensitive registers such as CONS_INDX and PROD_INDX that
should be programmed by the guest directly, so the driver has a mmap
implementation via the mdev interface to let user space get acces to
PAGE0 directly. PAGE1 then has two base address configuring registers
where the addresses should be translated from guest PAs to host PAs,
so they are handled via mdev read/write() to trap for replacements.

As previous patch mentioned, VINTF0 is reserved for the host kernel
(or hypervisor) use, a VINTFx (x > 0) should be allocated to a guest
VM. And from the guest perspective, the VINTFx (host) is seen as the
VINTF0 of the guest. Beside the two MMIO regions of VINTF0, the guest
VM also has the global configuration MMIO region as the host kernel
does, and this global region is also handled via mdev read/write()
to limit the guest to access the bits of its own.

Additionally, there were a couple of issues for this implementation:
1) Setting into VINTF CONFIG register the same VMID as SMMU's s2_cfg.
2) Before enabling the VINTF, programing up-to-16 sets of SID_REPLACE
   and SID_MATCH registers that stores physical stream IDs of host's
   and corresponding virtual stream IDs of guest's respectively.

And in this patch, we add a pair of ->attach_dev and ->detach_dev and
implement them in the following ways:
1) For each VINTF, pre-allocating a VMID on the bitmap of arm_smmu_v3
   driver to create a link between VINTF index and VMID, so either of
   them can be quickly looked up using the counterpart later.
2) Programming PHY_SID into SID_REPLACE (corresponding register), yet
   writing iommu_group_id (a fake VIRT_SID) into SID_MATCH, as it is
   the only shared information of a passthrough device between a host
   kernel and a hypervisor. So the hypervisor is responsible to match
   the iommu_group_id and then to replace it with a virtual SID.
3) Note that, by doing (1) the VMID is now created along with a VINTF
   in the nvidia_smmu_cmdqv_mdev_create() function, which is executed
   before a hypervisor or VM starts, comparing to previous situation:
   we added a few patches to let arm-smmu-v3 driver allocate a shared
   VMID in arm_smmu_attach_dev() function, when the first passthrough
   device is added to the VM. This means that, in the new situation,
   the shared VMID needs to be passed to the hypervisor, before any
   passthrough device gets attached. So, we reuse VFIO_IOMMU_GET_VMID
   command via the mdev ioctl interface to pass the VMID to the CMDQV
   device model, then to the SMMUv3 device model, so that hypervisor
   can set the same VMID to all IOMMU domains of passthrough devices
   using the previous pathway via VFIO core back to SMMUv3 driver.

Signed-off-by: Nate Watterson <nwatterson@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   6 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +
 .../iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c    | 817 ++++++++++++++++++
 3 files changed, 825 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1b9459592f76..fc543181ddde 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2389,6 +2389,9 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master, struct device *d
 	if (!smmu_domain)
 		return;
 
+	if (master->smmu->impl && master->smmu->impl->detach_dev)
+		master->smmu->impl->detach_dev(smmu_domain, dev);
+
 	arm_smmu_disable_ats(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
@@ -2471,6 +2474,9 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	arm_smmu_enable_ats(master);
 
+	if (smmu->impl && smmu->impl->attach_dev)
+		ret = smmu->impl->attach_dev(smmu_domain, dev);
+
 out_unlock:
 	mutex_unlock(&smmu_domain->init_mutex);
 	return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bb903a7fa662..a872c0d2f23c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -817,6 +817,8 @@ static inline void arm_smmu_sva_notifier_synchronize(void) {}
 struct arm_smmu_impl {
 	int (*device_reset)(struct arm_smmu_device *smmu);
 	struct arm_smmu_cmdq *(*get_cmdq)(struct arm_smmu_device *smmu, u64 *cmds, int n);
+	int (*attach_dev)(struct arm_smmu_domain *smmu_domain, struct device *dev);
+	void (*detach_dev)(struct arm_smmu_domain *smmu_domain, struct device *dev);
 };
 
 struct arm_smmu_device *arm_smmu_v3_impl_init(struct arm_smmu_device *smmu);
diff --git a/drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c
index 0c92fe433c6e..265681ba96bc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c
@@ -7,7 +7,10 @@
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
 #include <linux/iopoll.h>
+#include <linux/kvm_host.h>
+#include <linux/mdev.h>
 #include <linux/platform_device.h>
+#include <linux/vfio.h>
 
 #include <acpi/acpixf.h>
 
@@ -20,14 +23,17 @@
 #define NVIDIA_CMDQV_CONFIG_SIZE	(SZ_64K)
 #define NVIDIA_VCMDQ_BASE		(0 + SZ_64K)
 #define NVIDIA_VCMDQ_SIZE		(SZ_64K * 2) /* PAGE0 and PAGE1 */
+#define NVIDIA_VINTF_VCMDQ_BASE		(NVIDIA_VCMDQ_BASE + NVIDIA_VCMDQ_SIZE)
 
 /* CMDQV global config regs */
 #define NVIDIA_CMDQV_CONFIG		0x0000
 #define  CMDQV_EN			BIT(0)
 
 #define NVIDIA_CMDQV_PARAM		0x0004
+#define  CMDQV_NUM_SID_PER_VM_LOG2	GENMASK(15, 12)
 #define  CMDQV_NUM_VINTF_LOG2		GENMASK(11, 8)
 #define  CMDQV_NUM_VCMDQ_LOG2		GENMASK(7, 4)
+#define  CMDQV_VER			GENMASK(3, 0)
 
 #define NVIDIA_CMDQV_STATUS		0x0008
 #define  CMDQV_STATUS			GENMASK(2, 1)
@@ -45,6 +51,12 @@
 /* VINTF config regs */
 #define NVIDIA_CMDQV_VINTF(v)		(0x1000 + 0x100*(v))
 
+#define NVIDIA_VINTFi_CONFIG(i)		(NVIDIA_CMDQV_VINTF(i) + NVIDIA_VINTF_CONFIG)
+#define NVIDIA_VINTFi_STATUS(i)		(NVIDIA_CMDQV_VINTF(i) + NVIDIA_VINTF_STATUS)
+#define NVIDIA_VINTFi_SID_MATCH(i, s)	(NVIDIA_CMDQV_VINTF(i) + NVIDIA_VINTF_SID_MATCH(s))
+#define NVIDIA_VINTFi_SID_REPLACE(i, s)	(NVIDIA_CMDQV_VINTF(i) + NVIDIA_VINTF_SID_REPLACE(s))
+#define NVIDIA_VINTFi_CMDQ_ERR_MAP(i)	(NVIDIA_CMDQV_VINTF(i) + NVIDIA_VINTF_CMDQ_ERR_MAP)
+
 #define NVIDIA_VINTF_CONFIG		0x0000
 #define  VINTF_HYP_OWN			BIT(17)
 #define  VINTF_VMID			GENMASK(16, 1)
@@ -54,6 +66,11 @@
 #define  VINTF_STATUS			GENMASK(3, 1)
 #define  VINTF_ENABLED			BIT(0)
 
+#define NVIDIA_VINTF_SID_MATCH(s)	(0x0040 + 0x4*(s))
+#define NVIDIA_VINTF_SID_REPLACE(s)	(0x0080 + 0x4*(s))
+
+#define NVIDIA_VINTF_CMDQ_ERR_MAP	0x00C0
+
 /* VCMDQ config regs */
 /* -- PAGE0 -- */
 #define NVIDIA_CMDQV_VCMDQ(q)		(NVIDIA_VCMDQ_BASE + 0x80*(q))
@@ -77,13 +94,30 @@
 #define  VCMDQ_ADDR			GENMASK(63, 5)
 #define  VCMDQ_LOG2SIZE			GENMASK(4, 0)
 
+#define NVIDIA_VCMDQ0_BASE_L		0x00000	/* offset to NVIDIA_VCMDQ_BASE_L(0) */
+#define NVIDIA_VCMDQ0_BASE_H		0x00004	/* offset to NVIDIA_VCMDQ_BASE_L(0) */
+#define NVIDIA_VCMDQ0_CONS_INDX_BASE_L	0x00008	/* offset to NVIDIA_VCMDQ_BASE_L(0) */
+#define NVIDIA_VCMDQ0_CONS_INDX_BASE_H	0x0000C	/* offset to NVIDIA_VCMDQ_BASE_L(0) */
+
+/* VINTF logical-VCMDQ regs */
+#define NVIDIA_VINTFi_VCMDQ_BASE(i)	(NVIDIA_VINTF_VCMDQ_BASE + NVIDIA_VCMDQ_SIZE*(i))
+#define NVIDIA_VINTFi_VCMDQ(i, q)	(NVIDIA_VINTFi_VCMDQ_BASE(i) + 0x80*(q))
+
 struct nvidia_smmu_vintf {
 	u16			idx;
+	u16			vmid;
 	u32			cfg;
 	u32			status;
 
 	void __iomem		*base;
+	void __iomem		*vcmdq_base;
 	struct arm_smmu_cmdq	*vcmdqs;
+
+#define NVIDIA_SMMU_VINTF_MAX_SIDS 16
+	DECLARE_BITMAP(sid_map, NVIDIA_SMMU_VINTF_MAX_SIDS);
+	u32			sid_replace[NVIDIA_SMMU_VINTF_MAX_SIDS];
+
+	spinlock_t		lock;
 };
 
 struct nvidia_smmu {
@@ -91,6 +125,8 @@ struct nvidia_smmu {
 
 	struct device		*cmdqv_dev;
 	void __iomem		*cmdqv_base;
+	resource_size_t		ioaddr;
+	resource_size_t		ioaddr_size;
 	int			cmdqv_irq;
 
 	/* CMDQV Hardware Params */
@@ -98,10 +134,38 @@ struct nvidia_smmu {
 	u16			num_total_vcmdqs;
 	u16			num_vcmdqs_per_vintf;
 
+#define NVIDIA_SMMU_MAX_VINTFS	(1 << 6)
+	DECLARE_BITMAP(vintf_map, NVIDIA_SMMU_MAX_VINTFS);
+
 	/* CMDQV_VINTF(0) reserved for host kernel use */
 	struct nvidia_smmu_vintf vintf0;
+
+	struct nvidia_smmu_vintf **vmid_mappings;
+
+#ifdef CONFIG_VFIO_MDEV_DEVICE
+	/* CMDQV_VINTFs exposed to userspace via mdev */
+	struct nvidia_cmdqv_mdev **vintf_mdev;
+	/* Cache for two 64-bit VCMDQ base addresses */
+	struct nvidia_cmdqv_vcmdq_regcache {
+		u64		base_addr;
+		u64		cons_addr;
+	} *vcmdq_regcache;
+	struct mutex		mdev_lock;
+	struct mutex		vmid_lock;
+#endif
 };
 
+#ifdef CONFIG_VFIO_MDEV_DEVICE
+struct nvidia_cmdqv_mdev {
+	struct nvidia_smmu	*nsmmu;
+	struct mdev_device	*mdev;
+	struct nvidia_smmu_vintf *vintf;
+
+	struct notifier_block	group_notifier;
+	struct kvm		*kvm;
+};
+#endif
+
 static irqreturn_t nvidia_smmu_cmdqv_isr(int irq, void *devid)
 {
 	struct nvidia_smmu *nsmmu = (struct nvidia_smmu *)devid;
@@ -135,6 +199,61 @@ static irqreturn_t nvidia_smmu_cmdqv_isr(int irq, void *devid)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_VFIO_MDEV_DEVICE
+struct mdev_parent_ops nvidia_smmu_cmdqv_mdev_ops;
+
+int nvidia_smmu_cmdqv_mdev_init(struct nvidia_smmu *nsmmu)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev;
+	int ret;
+
+	/* Skip mdev init unless there are available VINTFs */
+	if (nsmmu->num_total_vintfs <= 1)
+		return 0;
+
+	nsmmu->vintf_mdev = devm_kcalloc(nsmmu->cmdqv_dev, nsmmu->num_total_vintfs,
+					 sizeof(*nsmmu->vintf_mdev), GFP_KERNEL);
+	if (!nsmmu->vintf_mdev)
+		return -ENOMEM;
+
+	nsmmu->vcmdq_regcache = devm_kcalloc(nsmmu->cmdqv_dev, nsmmu->num_total_vcmdqs,
+					     sizeof(*nsmmu->vcmdq_regcache), GFP_KERNEL);
+	if (!nsmmu->vcmdq_regcache)
+		return -ENOMEM;
+
+	nsmmu->vmid_mappings = devm_kcalloc(nsmmu->cmdqv_dev, 1 << nsmmu->smmu.vmid_bits,
+					    sizeof(*nsmmu->vmid_mappings), GFP_KERNEL);
+	if (!nsmmu->vmid_mappings)
+		return -ENOMEM;
+
+	mutex_init(&nsmmu->mdev_lock);
+	mutex_init(&nsmmu->vmid_lock);
+
+	/* Add a dummy mdev instance to represent vintf0 */
+	cmdqv_mdev = devm_kzalloc(nsmmu->cmdqv_dev, sizeof(*cmdqv_mdev), GFP_KERNEL);
+	if (!cmdqv_mdev)
+		return -ENOMEM;
+
+	cmdqv_mdev->nsmmu = nsmmu;
+	nsmmu->vintf_mdev[0] = cmdqv_mdev;
+
+	ret = mdev_register_device(nsmmu->cmdqv_dev, &nvidia_smmu_cmdqv_mdev_ops);
+	if (ret) {
+		dev_err(nsmmu->cmdqv_dev, "failed to register mdev device: %d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(to_platform_device(nsmmu->cmdqv_dev), nsmmu);
+
+	return ret;
+}
+#else
+int nvidia_smmu_cmdqv_mdev_init(struct nvidia_smmu *nsmmu)
+{
+	return 0;
+}
+#endif
+
 /* Adapt struct arm_smmu_cmdq init sequences from arm-smmu-v3.c for VCMDQs */
 static int nvidia_smmu_init_one_arm_smmu_cmdq(struct nvidia_smmu *nsmmu,
 					      struct arm_smmu_cmdq *cmdq,
@@ -255,6 +374,16 @@ static int nvidia_smmu_cmdqv_init(struct nvidia_smmu *nsmmu)
 			 qidx, vintf0->idx, qidx);
 	}
 
+	/* Log this vintf0 in vintf_map */
+	set_bit(0, nsmmu->vintf_map);
+
+	spin_lock_init(&vintf0->lock);
+
+#ifdef CONFIG_VFIO_MDEV_DEVICE
+	if (nsmmu->vintf_mdev && nsmmu->vintf_mdev[0])
+		nsmmu->vintf_mdev[0]->vintf = vintf0;
+#endif
+
 	return 0;
 }
 
@@ -269,6 +398,9 @@ static int nvidia_smmu_probe(struct nvidia_smmu *nsmmu)
 	if (!res)
 		return -ENXIO;
 
+	nsmmu->ioaddr = res->start;
+	nsmmu->ioaddr_size = resource_size(res);
+
 	nsmmu->cmdqv_base = devm_ioremap_resource(nsmmu->cmdqv_dev, res);
 	if (IS_ERR(nsmmu->cmdqv_base))
 		return PTR_ERR(nsmmu->cmdqv_base);
@@ -366,9 +498,131 @@ static int nvidia_smmu_device_reset(struct arm_smmu_device *smmu)
 	return 0;
 }
 
+static int nvidia_smmu_bitmap_alloc(unsigned long *map, int size)
+{
+	int idx;
+
+	do {
+		idx = find_first_zero_bit(map, size);
+		if (idx == size)
+			return -ENOSPC;
+	} while (test_and_set_bit(idx, map));
+
+	return idx;
+}
+
+static void nvidia_smmu_bitmap_free(unsigned long *map, int idx)
+{
+	clear_bit(idx, map);
+}
+
+static int nvidia_smmu_attach_dev(struct arm_smmu_domain *smmu_domain, struct device *dev)
+{
+	struct nvidia_smmu *nsmmu = (struct nvidia_smmu *)smmu_domain->smmu;
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+	struct nvidia_smmu_vintf *vintf = &nsmmu->vintf0;
+	int i, slot;
+
+#ifdef CONFIG_VFIO_MDEV_DEVICE
+	/* Repoint vintf to the corresponding one for Nested Translation mode */
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED) {
+		u16 vmid = smmu_domain->s2_cfg.vmid;
+
+		mutex_lock(&nsmmu->vmid_lock);
+		vintf = nsmmu->vmid_mappings[vmid];
+		mutex_unlock(&nsmmu->vmid_lock);
+		if (!vintf) {
+			dev_err(nsmmu->cmdqv_dev, "failed to find vintf\n");
+			return -EINVAL;
+		}
+	}
+#endif
+
+	for (i = 0; i < fwspec->num_ids; i++) {
+		unsigned int sid = fwspec->ids[i];
+		unsigned long flags;
+
+		/* Find an empty slot of SID_MATCH and SID_REPLACE */
+		slot = nvidia_smmu_bitmap_alloc(vintf->sid_map, NVIDIA_SMMU_VINTF_MAX_SIDS);
+		if (slot < 0)
+			return -EBUSY;
+
+		/* Write PHY_SID to SID_REPLACE and cache it for quick lookup */
+		writel_relaxed(sid, vintf->base + NVIDIA_VINTF_SID_REPLACE(slot));
+
+		spin_lock_irqsave(&vintf->lock, flags);
+		vintf->sid_replace[slot] = sid;
+		spin_unlock_irqrestore(&vintf->lock, flags);
+
+		if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED) {
+			struct iommu_group *group = iommu_group_get(dev);
+
+			/*
+			 * Mark SID_MATCH with iommu_group_id, without setting ENABLE bit
+			 * This allows hypervisor to look up one SID_MATCH register that
+			 * matches with the same iommu_group_id, and to eventually update
+			 * VIRT_SID in SID_MATCH.
+			 */
+			writel_relaxed(iommu_group_id(group) << 1,
+				       vintf->base + NVIDIA_VINTF_SID_MATCH(slot));
+		}
+	}
+
+	return 0;
+}
+
+static void nvidia_smmu_detach_dev(struct arm_smmu_domain *smmu_domain, struct device *dev)
+{
+	struct nvidia_smmu *nsmmu = (struct nvidia_smmu *)smmu_domain->smmu;
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+	struct nvidia_smmu_vintf *vintf = &nsmmu->vintf0;
+	int i, slot;
+
+#ifdef CONFIG_VFIO_MDEV_DEVICE
+	/* Replace vintf0 with the corresponding one for Nested Translation mode */
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED) {
+		u16 vmid =  smmu_domain->s2_cfg.vmid;
+
+		mutex_lock(&nsmmu->vmid_lock);
+		vintf = nsmmu->vmid_mappings[vmid];
+		mutex_unlock(&nsmmu->vmid_lock);
+		if (!vintf) {
+			dev_err(nsmmu->cmdqv_dev, "failed to find vintf\n");
+			return;
+		}
+	}
+#endif
+
+	for (i = 0; i < fwspec->num_ids; i++) {
+		unsigned int sid = fwspec->ids[i];
+		unsigned long flags;
+
+		spin_lock_irqsave(&vintf->lock, flags);
+
+		/* Find a SID_REPLACE register matching sid */
+		for (slot = 0; slot < ARRAY_SIZE(vintf->sid_replace); slot++)
+			if (sid == vintf->sid_replace[slot])
+				break;
+
+		spin_unlock_irqrestore(&vintf->lock, flags);
+
+		if (slot == ARRAY_SIZE(vintf->sid_replace)) {
+			dev_dbg(nsmmu->cmdqv_dev, "failed to find vintf\n");
+			return;
+		}
+
+		writel_relaxed(0, vintf->base + NVIDIA_VINTF_SID_REPLACE(slot));
+		writel_relaxed(0, vintf->base + NVIDIA_VINTF_SID_MATCH(slot));
+
+		nvidia_smmu_bitmap_free(vintf->sid_map, slot);
+	}
+}
+
 const struct arm_smmu_impl nvidia_smmu_impl = {
 	.device_reset = nvidia_smmu_device_reset,
 	.get_cmdq = nvidia_smmu_get_cmdq,
+	.attach_dev = nvidia_smmu_attach_dev,
+	.detach_dev = nvidia_smmu_detach_dev,
 };
 
 #ifdef CONFIG_ACPI
@@ -426,7 +680,570 @@ struct arm_smmu_device *nvidia_smmu_v3_impl_init(struct arm_smmu_device *smmu)
 	if (ret)
 		return ERR_PTR(ret);
 
+	ret = nvidia_smmu_cmdqv_mdev_init(nsmmu);
+	if (ret)
+		return ERR_PTR(ret);
+
 	nsmmu->smmu.impl = &nvidia_smmu_impl;
 
 	return &nsmmu->smmu;
 }
+
+#ifdef CONFIG_VFIO_MDEV_DEVICE
+#define mdev_name(m) dev_name(mdev_dev(m))
+
+int nvidia_smmu_cmdqv_mdev_create(struct mdev_device *mdev)
+{
+	struct device *parent_dev = mdev_parent_dev(mdev);
+	struct nvidia_smmu *nsmmu = platform_get_drvdata(to_platform_device(parent_dev));
+	struct nvidia_cmdqv_mdev *cmdqv_mdev;
+	struct nvidia_smmu_vintf *vintf;
+	int vmid, idx, ret;
+	u32 regval;
+
+	cmdqv_mdev = kzalloc(sizeof(*cmdqv_mdev), GFP_KERNEL);
+	if (!cmdqv_mdev)
+		return -ENOMEM;
+
+	cmdqv_mdev->vintf = kzalloc(sizeof(*cmdqv_mdev->vintf), GFP_KERNEL);
+	if (!cmdqv_mdev->vintf) {
+		ret = -ENOMEM;
+		goto free_mdev;
+	}
+
+	cmdqv_mdev->mdev = mdev;
+	cmdqv_mdev->nsmmu = nsmmu;
+	vintf = cmdqv_mdev->vintf;
+
+	mutex_lock(&nsmmu->mdev_lock);
+	idx = nvidia_smmu_bitmap_alloc(nsmmu->vintf_map, nsmmu->num_total_vintfs);
+	if (idx < 0) {
+		dev_err(nsmmu->cmdqv_dev, "failed to allocate vintfs\n");
+		mutex_unlock(&nsmmu->mdev_lock);
+		ret = -EBUSY;
+		goto free_vintf;
+	}
+	nsmmu->vintf_mdev[idx] = cmdqv_mdev;
+	mutex_unlock(&nsmmu->mdev_lock);
+
+	mutex_lock(&nsmmu->vmid_lock);
+	vmid = arm_smmu_vmid_alloc(&nsmmu->smmu);
+	if (vmid < 0) {
+		dev_err(nsmmu->cmdqv_dev, "failed to allocate vmid\n");
+		mutex_unlock(&nsmmu->vmid_lock);
+		ret = -EBUSY;
+		goto free_vintf_map;
+	}
+
+	/* Create mapping between vmid and vintf */
+	nsmmu->vmid_mappings[vmid] = vintf;
+	mutex_unlock(&nsmmu->vmid_lock);
+
+	vintf->idx = idx;
+	vintf->vmid = vmid;
+	vintf->base = nsmmu->cmdqv_base + NVIDIA_CMDQV_VINTF(idx);
+
+	spin_lock_init(&vintf->lock);
+	mdev_set_drvdata(mdev, cmdqv_mdev);
+
+	writel_relaxed(0, vintf->base + NVIDIA_VINTF_CONFIG);
+
+	/* Point to NVIDIA_VINTFi_VCMDQ_BASE */
+	vintf->vcmdq_base = nsmmu->cmdqv_base + NVIDIA_VINTFi_VCMDQ_BASE(vintf->idx);
+
+	/* Alloc VCMDQs (2n, 2n+1, 2n+2, ...) to VINTF(idx) as logical-VCMDQ (0, 1, 2, ...) */
+	for (idx = 0; idx < nsmmu->num_vcmdqs_per_vintf; idx++) {
+		u16 vcmdq_idx = nsmmu->num_vcmdqs_per_vintf * vintf->idx + idx;
+
+		regval = FIELD_PREP(CMDQV_CMDQ_ALLOC_VINTF, vintf->idx);
+		regval |= FIELD_PREP(CMDQV_CMDQ_ALLOC_LVCMDQ, idx);
+		regval |= CMDQV_CMDQ_ALLOCATED;
+		writel_relaxed(regval, nsmmu->cmdqv_base + NVIDIA_CMDQV_CMDQ_ALLOC(vcmdq_idx));
+
+		dev_info(nsmmu->cmdqv_dev, "allocated VCMDQ%u to VINTF%u as logical-VCMDQ%u\n",
+			 vcmdq_idx, vintf->idx, idx);
+	}
+
+	dev_dbg(nsmmu->cmdqv_dev, "allocated VINTF%u to mdev_device (%s) binding to vmid (%d)\n",
+		vintf->idx, dev_name(mdev_dev(mdev)), vintf->vmid);
+
+	return 0;
+
+free_vintf_map:
+	nvidia_smmu_bitmap_free(nsmmu->vintf_map, idx);
+free_vintf:
+	kfree(cmdqv_mdev->vintf);
+free_mdev:
+	kfree(cmdqv_mdev);
+
+	return ret;
+}
+
+int nvidia_smmu_cmdqv_mdev_remove(struct mdev_device *mdev)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev = mdev_get_drvdata(mdev);
+	struct nvidia_smmu_vintf *vintf = cmdqv_mdev->vintf;
+	struct nvidia_smmu *nsmmu = cmdqv_mdev->nsmmu;
+	u16 idx;
+
+	/* Deallocate VCMDQs of the VINTF(idx) */
+	for (idx = 0; idx < nsmmu->num_vcmdqs_per_vintf; idx++) {
+		u16 vcmdq_idx = nsmmu->num_vcmdqs_per_vintf * vintf->idx + idx;
+
+		writel_relaxed(0, nsmmu->cmdqv_base + NVIDIA_CMDQV_CMDQ_ALLOC(vcmdq_idx));
+
+		dev_info(nsmmu->cmdqv_dev, "deallocated VCMDQ%u to VINTF%u\n",
+			 vcmdq_idx, vintf->idx);
+	}
+
+	/* Disable and cleanup VINTF configurations */
+	writel_relaxed(0, vintf->base + NVIDIA_VINTF_CONFIG);
+
+	mutex_lock(&nsmmu->mdev_lock);
+	nvidia_smmu_bitmap_free(nsmmu->vintf_map, vintf->idx);
+	nsmmu->vintf_mdev[vintf->idx] = NULL;
+	mutex_unlock(&nsmmu->mdev_lock);
+
+	mutex_lock(&nsmmu->vmid_lock);
+	arm_smmu_vmid_free(&nsmmu->smmu, vintf->vmid);
+	nsmmu->vmid_mappings[vintf->vmid] = NULL;
+	mutex_unlock(&nsmmu->vmid_lock);
+
+	mdev_set_drvdata(mdev, NULL);
+	kfree(cmdqv_mdev->vintf);
+	kfree(cmdqv_mdev);
+
+	return 0;
+}
+
+static int nvidia_smmu_cmdqv_mdev_group_notifier(struct notifier_block *nb,
+						 unsigned long action, void *data)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev =
+		container_of(nb, struct nvidia_cmdqv_mdev, group_notifier);
+
+	if (action == VFIO_GROUP_NOTIFY_SET_KVM)
+		cmdqv_mdev->kvm = data;
+
+	return NOTIFY_OK;
+}
+
+int nvidia_smmu_cmdqv_mdev_open(struct mdev_device *mdev)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev = mdev_get_drvdata(mdev);
+	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
+	struct device *dev = mdev_dev(mdev);
+	int ret;
+
+	cmdqv_mdev->group_notifier.notifier_call = nvidia_smmu_cmdqv_mdev_group_notifier;
+
+	ret = vfio_register_notifier(dev, VFIO_GROUP_NOTIFY, &events, &cmdqv_mdev->group_notifier);
+	if (ret)
+		dev_err(mdev_dev(mdev), "failed to register group notifier: %d\n", ret);
+
+	return ret;
+}
+
+void nvidia_smmu_cmdqv_mdev_release(struct mdev_device *mdev)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev = mdev_get_drvdata(mdev);
+	struct device *dev = mdev_dev(mdev);
+
+	vfio_unregister_notifier(dev, VFIO_GROUP_NOTIFY, &cmdqv_mdev->group_notifier);
+}
+
+ssize_t nvidia_smmu_cmdqv_mdev_read(struct mdev_device *mdev, char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev = mdev_get_drvdata(mdev);
+	struct nvidia_smmu_vintf *vintf = cmdqv_mdev->vintf;
+	struct nvidia_smmu *nsmmu = cmdqv_mdev->nsmmu;
+	struct device *dev = mdev_dev(mdev);
+	loff_t reg_offset = *ppos, reg;
+	u64 regval = 0;
+	u16 idx, slot;
+
+	/* Only support aligned 32/64-bit accesses */
+	if (!count || (count % 4) || count > 8 || (reg_offset % count))
+		return -EINVAL;
+
+	switch (reg_offset) {
+	case NVIDIA_CMDQV_CONFIG:
+		regval = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_CONFIG);
+		break;
+	case NVIDIA_CMDQV_STATUS:
+		regval = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_STATUS);
+		break;
+	case NVIDIA_CMDQV_PARAM:
+		/*
+		 * Guest shall import only one of the VINTFs using mdev interface,
+		 * so limit the numbers of VINTF and VCMDQs in the PARAM register.
+		 */
+		regval = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_PARAM);
+		regval &= ~(CMDQV_NUM_VINTF_LOG2 | CMDQV_NUM_VCMDQ_LOG2);
+		regval |= FIELD_PREP(CMDQV_NUM_VINTF_LOG2, 0);
+		regval |= FIELD_PREP(CMDQV_NUM_VCMDQ_LOG2, ilog2(nsmmu->num_vcmdqs_per_vintf));
+		break;
+	case NVIDIA_CMDQV_VINTF_ERR_MAP:
+		/* Translate the value to bit 0 as guest can only see vintf0 */
+		regval = readl_relaxed(vintf->base + NVIDIA_VINTF_STATUS);
+		regval = !!FIELD_GET(VINTF_STATUS, regval);
+		break;
+	case NVIDIA_CMDQV_VINTF_INT_MASK:
+		/* Translate the value to bit 0 as guest can only see vintf0 */
+		regval = readq_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_VINTF_INT_MASK);
+		regval = !!(regval & BIT(vintf->idx));
+		break;
+	case NVIDIA_CMDQV_VCMDQ_ERR_MAP:
+		regval = readq_relaxed(vintf->base + NVIDIA_VINTF_CMDQ_ERR_MAP);
+		break;
+	case NVIDIA_CMDQV_CMDQ_ALLOC(0) ... NVIDIA_CMDQV_CMDQ_ALLOC(128):
+		if (idx >= nsmmu->num_vcmdqs_per_vintf) {
+			/* Guest only has limited number of VMCDQs for one VINTF */
+			regval = 0;
+		} else {
+			/* We have allocated VCMDQs, so just report it constantly */
+			idx = (reg_offset - NVIDIA_CMDQV_CMDQ_ALLOC(0)) / 4;
+			regval = FIELD_PREP(CMDQV_CMDQ_ALLOC_LVCMDQ, idx) | CMDQV_CMDQ_ALLOCATED;
+		}
+		break;
+	case NVIDIA_VINTFi_CONFIG(0):
+		regval = readl_relaxed(vintf->base + NVIDIA_VINTF_CONFIG);
+		/* Guest should not see the VMID field */
+		regval &= ~(VINTF_VMID);
+		break;
+	case NVIDIA_VINTFi_STATUS(0):
+		regval = readl_relaxed(vintf->base + NVIDIA_VINTF_STATUS);
+		break;
+	case NVIDIA_VINTFi_SID_MATCH(0, 0) ... NVIDIA_VINTFi_SID_MATCH(0, 15):
+		slot = (reg_offset - NVIDIA_VINTFi_SID_MATCH(0, 0)) / 0x4;
+		regval = readl_relaxed(vintf->base + NVIDIA_VINTF_SID_MATCH(slot));
+		break;
+	case NVIDIA_VINTFi_SID_REPLACE(0, 0) ... NVIDIA_VINTFi_SID_REPLACE(0, 15):
+		/* Guest should not see the PHY_SID but know whether it is set or not */
+		slot = (reg_offset - NVIDIA_VINTFi_SID_REPLACE(0, 0)) / 0x4;
+		regval = !!readl_relaxed(vintf->base + NVIDIA_VINTF_SID_REPLACE(slot));
+		break;
+	case NVIDIA_VINTFi_CMDQ_ERR_MAP(0):
+		regval = readl_relaxed(vintf->base + NVIDIA_VINTF_CMDQ_ERR_MAP);
+		break;
+	case NVIDIA_CMDQV_VCMDQ(0) ... NVIDIA_CMDQV_VCMDQ(128):
+		/* We allow fallback reading of VCMDQ PAGE0 upon a warning */
+		dev_warn(dev, "read access at 0x%llx should go through mmap instead!", reg_offset);
+
+		/* Adjust reg_offset since we're reading base on VINTF logical-VCMDQ space */
+		regval = readl_relaxed(vintf->vcmdq_base + reg_offset - NVIDIA_CMDQV_VCMDQ(0));
+		break;
+	case NVIDIA_VCMDQ_BASE_L(0) ... NVIDIA_VCMDQ_BASE_L(128):
+		/* Decipher idx and reg of VCMDQ */
+		idx = (reg_offset - NVIDIA_VCMDQ_BASE_L(0)) / 0x80;
+		reg = reg_offset - NVIDIA_VCMDQ_BASE_L(idx);
+
+		switch (reg) {
+		case NVIDIA_VCMDQ0_BASE_L:
+			regval = nsmmu->vcmdq_regcache[idx].base_addr;
+			if (count == 4)
+				regval = lower_32_bits(regval);
+			break;
+		case NVIDIA_VCMDQ0_BASE_H:
+			regval = upper_32_bits(nsmmu->vcmdq_regcache[idx].base_addr);
+			break;
+		case NVIDIA_VCMDQ0_CONS_INDX_BASE_L:
+			regval = nsmmu->vcmdq_regcache[idx].cons_addr;
+			if (count == 4)
+				regval = lower_32_bits(regval);
+			break;
+		case NVIDIA_VCMDQ0_CONS_INDX_BASE_H:
+			regval = upper_32_bits(nsmmu->vcmdq_regcache[idx].cons_addr);
+			break;
+		default:
+			dev_err(dev, "unknown base address read access at 0x%llX\n", reg_offset);
+			break;
+		}
+		break;
+	default:
+		dev_err(dev, "unhandled read access at 0x%llX\n", reg_offset);
+		return -EINVAL;
+	}
+
+	if (copy_to_user(buf, &regval, count))
+		return -EFAULT;
+	*ppos += count;
+
+	return count;
+}
+
+static u64 nvidia_smmu_cmdqv_mdev_gpa_to_pa(struct nvidia_cmdqv_mdev *cmdqv_mdev, u64 gpa)
+{
+	u64 gfn, hfn, hva, hpa, pg_offset;
+	struct page *pg;
+	long num_pages;
+
+	gfn = gpa_to_gfn(gpa);
+	pg_offset = gpa ^ gfn_to_gpa(gfn);
+
+	hva = gfn_to_hva(cmdqv_mdev->kvm, gfn);
+	if (kvm_is_error_hva(hva))
+		return 0;
+
+	num_pages = get_user_pages(hva, 1, FOLL_GET | FOLL_WRITE, &pg, NULL);
+	if (num_pages < 1)
+		return 0;
+
+	hfn = page_to_pfn(pg);
+	hpa = pfn_to_hpa(hfn);
+
+	return hpa | pg_offset;
+}
+
+ssize_t nvidia_smmu_cmdqv_mdev_write(struct mdev_device *mdev, const char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev = mdev_get_drvdata(mdev);
+	struct nvidia_smmu_vintf *vintf = cmdqv_mdev->vintf;
+	struct nvidia_smmu *nsmmu = cmdqv_mdev->nsmmu;
+	struct device *dev = mdev_dev(mdev);
+	loff_t reg_offset = *ppos, reg;
+	u64 mask = U32_MAX;
+	u64 regval = 0x0;
+	u16 idx, slot;
+
+	/* Only support aligned 32/64-bit accesses */
+	if (!count || (count % 4) || count > 8 || (reg_offset % count))
+		return -EINVAL;
+
+	/* Get the value to be written to the register at reg_offset */
+	if (copy_from_user(&regval, buf, count))
+		return -EFAULT;
+
+	switch (reg_offset) {
+	case NVIDIA_VINTFi_CONFIG(0):
+		regval &= ~(VINTF_VMID);
+		regval |= FIELD_PREP(VINTF_VMID, vintf->vmid);
+		writel_relaxed(regval, vintf->base + NVIDIA_VINTF_CONFIG);
+		break;
+	case NVIDIA_CMDQV_CMDQ_ALLOC(0) ... NVIDIA_CMDQV_CMDQ_ALLOC(128):
+		/* Ignore since VCMDQs were already allocated to the VINTF */
+		break;
+	case NVIDIA_VINTFi_SID_MATCH(0, 0) ... NVIDIA_VINTFi_SID_MATCH(0, 15):
+		slot = (reg_offset - NVIDIA_VINTFi_SID_MATCH(0, 0)) / 0x4;
+		writel_relaxed(regval, vintf->base + NVIDIA_VINTF_SID_MATCH(slot));
+		break;
+	case NVIDIA_VINTFi_SID_REPLACE(0, 0) ... NVIDIA_VINTFi_SID_REPLACE(0, 15):
+		/* Guest should not alter the value */
+		break;
+	case NVIDIA_CMDQV_VCMDQ(0) ... NVIDIA_CMDQV_VCMDQ(128):
+		/* We allow fallback writing at VCMDQ PAGE0 upon a warning */
+		dev_warn(dev, "write access at 0x%llx should go through mmap instead!", reg_offset);
+
+		/* Adjust reg_offset since we're reading base on VINTF logical-VCMDQ space */
+		writel_relaxed(regval, vintf->vcmdq_base + reg_offset - NVIDIA_CMDQV_VCMDQ(0));
+		break;
+	case NVIDIA_VCMDQ_BASE_L(0) ... NVIDIA_VCMDQ_BASE_L(128):
+		/* Decipher idx and reg of VCMDQ */
+		idx = (reg_offset - NVIDIA_VCMDQ_BASE_L(0)) / 0x80;
+		reg = reg_offset - NVIDIA_VCMDQ_BASE_L(idx);
+
+		switch (reg) {
+		case NVIDIA_VCMDQ0_BASE_L:
+			if (count == 8)
+				mask = U64_MAX;
+			regval &= mask;
+			nsmmu->vcmdq_regcache[idx].base_addr &= ~mask;
+			nsmmu->vcmdq_regcache[idx].base_addr |= regval;
+			regval = nsmmu->vcmdq_regcache[idx].base_addr;
+			break;
+		case NVIDIA_VCMDQ0_BASE_H:
+			nsmmu->vcmdq_regcache[idx].base_addr &= U32_MAX;
+			nsmmu->vcmdq_regcache[idx].base_addr |= regval << 32;
+			regval = nsmmu->vcmdq_regcache[idx].base_addr;
+			break;
+		case NVIDIA_VCMDQ0_CONS_INDX_BASE_L:
+			if (count == 8)
+				mask = U64_MAX;
+			regval &= mask;
+			nsmmu->vcmdq_regcache[idx].cons_addr &= ~mask;
+			nsmmu->vcmdq_regcache[idx].cons_addr |= regval;
+			regval = nsmmu->vcmdq_regcache[idx].cons_addr;
+			break;
+		case NVIDIA_VCMDQ0_CONS_INDX_BASE_H:
+			nsmmu->vcmdq_regcache[idx].cons_addr &= U32_MAX;
+			nsmmu->vcmdq_regcache[idx].cons_addr |= regval << 32;
+			regval = nsmmu->vcmdq_regcache[idx].cons_addr;
+			break;
+		default:
+			dev_err(dev, "unknown base address write access at 0x%llX\n", reg_offset);
+			return -EFAULT;
+		}
+
+		/* Translate guest PA to host PA before writing to the address register */
+		regval = nvidia_smmu_cmdqv_mdev_gpa_to_pa(cmdqv_mdev, regval);
+
+		/* Do not fail mdev write as higher/lower addresses can be written separately */
+		if (!regval)
+			dev_dbg(dev, "failed to convert guest address for VCMDQ%d\n", idx);
+
+		/* Adjust reg_offset since we're accessing it via the VINTF CMDQ aperture */
+		reg_offset -= NVIDIA_CMDQV_VCMDQ(0);
+		if (count == 8)
+			writeq_relaxed(regval, vintf->vcmdq_base + reg_offset);
+		else
+			writel_relaxed(regval, vintf->vcmdq_base + reg_offset);
+		break;
+
+	default:
+		dev_err(dev, "unhandled write access at 0x%llX\n", reg_offset);
+		return -EINVAL;
+	}
+
+	*ppos += count;
+	return count;
+}
+
+long nvidia_smmu_cmdqv_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd, unsigned long arg)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev = mdev_get_drvdata(mdev);
+	struct nvidia_smmu_vintf *vintf = cmdqv_mdev->vintf;
+	struct device *dev = mdev_dev(mdev);
+	struct vfio_device_info device_info;
+	struct vfio_region_info region_info;
+	unsigned long minsz;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&device_info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (device_info.argsz < minsz)
+			return -EINVAL;
+
+		device_info.flags = 0;
+		device_info.num_irqs = 0;
+		/* MMIO Regions: [0] - CMDQV_CONFIG, [1] - VCMDQ_PAGE0, [2] - VCMDQ_PAGE1 */
+		device_info.num_regions = 3;
+
+		return copy_to_user((void __user *)arg, &device_info, minsz) ? -EFAULT : 0;
+	case VFIO_DEVICE_GET_REGION_INFO:
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&region_info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (region_info.argsz < minsz)
+			return -EINVAL;
+
+		if (region_info.index >= 3)
+			return -EINVAL;
+
+		/* MMIO Regions: [0] - CMDQV_CONFIG, [1] - VCMDQ_PAGE0, [2] - VCMDQ_PAGE1 */
+		region_info.size = SZ_64K;
+		region_info.offset = region_info.index * SZ_64K;
+		region_info.flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE;
+		/* In case of VCMDQ_PAGE0, add FLAG_MMAP */
+		if (region_info.index == 1)
+			region_info.flags |= VFIO_REGION_INFO_FLAG_MMAP;
+
+		return copy_to_user((void __user *)arg, &region_info, minsz) ? -EFAULT : 0;
+	case VFIO_IOMMU_GET_VMID:
+		return copy_to_user((void __user *)arg, &vintf->vmid, sizeof(u16)) ? -EFAULT : 0;
+	default:
+		dev_err(dev, "unhandled ioctl cmd 0x%X\n", cmd);
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+int nvidia_smmu_cmdqv_mdev_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+{
+	struct nvidia_cmdqv_mdev *cmdqv_mdev = mdev_get_drvdata(mdev);
+	struct nvidia_smmu_vintf *vintf = cmdqv_mdev->vintf;
+	struct nvidia_smmu *nsmmu = cmdqv_mdev->nsmmu;
+	struct device *dev = mdev_dev(mdev);
+	unsigned int region_idx;
+	unsigned long size;
+
+	/* Make sure that only VCMDQ_PAGE0 MMIO region can be mmapped */
+	region_idx = (vma->vm_pgoff << PAGE_SHIFT) / SZ_64K;
+	if (region_idx != 0x1) {
+		dev_err(dev, "mmap unsupported for region_idx %d", region_idx);
+		return -EINVAL;
+	}
+
+	size = vma->vm_end - vma->vm_start;
+	if (size > SZ_64K)
+		return -EINVAL;
+
+	/* Fixup the VMA */
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	/* Map PAGE0 of VINTF[idx] */
+	vma->vm_pgoff = nsmmu->ioaddr + NVIDIA_VINTFi_VCMDQ_BASE(vintf->idx);
+	vma->vm_pgoff >>= PAGE_SHIFT;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, size, vma->vm_page_prot);
+}
+
+static ssize_t name_show(struct mdev_type *mtype,
+			 struct mdev_type_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", "NVIDIA_SMMU_CMDQV_VINTF - (2 VCMDQs/VINTF)");
+}
+static MDEV_TYPE_ATTR_RO(name);
+
+static ssize_t available_instances_show(struct mdev_type *mtype,
+					struct mdev_type_attribute *attr, char *buf)
+{
+	struct device *parent_dev = mtype_get_parent_dev(mtype);
+	struct nvidia_smmu *nsmmu = platform_get_drvdata(to_platform_device(parent_dev));
+	u16 idx, cnt = 0;
+
+	mutex_lock(&nsmmu->mdev_lock);
+	for (idx = 0; idx < nsmmu->num_total_vintfs; idx++)
+		cnt += !nsmmu->vintf_mdev[idx];
+	mutex_unlock(&nsmmu->mdev_lock);
+
+	return sprintf(buf, "%d\n", cnt);
+}
+static MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t device_api_show(struct mdev_type *mtype,
+			       struct mdev_type_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PLATFORM_STRING);
+}
+static MDEV_TYPE_ATTR_RO(device_api);
+
+static struct attribute *mdev_types_attrs[] = {
+	&mdev_type_attr_name.attr,
+	&mdev_type_attr_device_api.attr,
+	&mdev_type_attr_available_instances.attr,
+	NULL,
+};
+
+static struct attribute_group mdev_type_group1 = {
+	.name  = "nvidia_cmdqv_vintf",
+	.attrs = mdev_types_attrs,
+};
+
+static struct attribute_group *mdev_type_groups[] = {
+	&mdev_type_group1,
+	NULL,
+};
+
+struct mdev_parent_ops nvidia_smmu_cmdqv_mdev_ops = {
+	.owner = THIS_MODULE,
+	.supported_type_groups = mdev_type_groups,
+	.create = nvidia_smmu_cmdqv_mdev_create,
+	.remove = nvidia_smmu_cmdqv_mdev_remove,
+	.open = nvidia_smmu_cmdqv_mdev_open,
+	.release = nvidia_smmu_cmdqv_mdev_release,
+	.read = nvidia_smmu_cmdqv_mdev_read,
+	.write = nvidia_smmu_cmdqv_mdev_write,
+	.ioctl = nvidia_smmu_cmdqv_mdev_ioctl,
+	.mmap = nvidia_smmu_cmdqv_mdev_mmap,
+};
+
+#endif /* CONFIG_VFIO_MDEV_DEVICE */
-- 
2.17.1

