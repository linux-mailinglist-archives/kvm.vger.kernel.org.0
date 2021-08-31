Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F203FC15F
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239484AbhHaDIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:08:32 -0400
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:12320
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231944AbhHaDI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrRLCdjAx7sXMidJrZtriRUfubCgLXKNHBQZfavXMXEtcfN7lOyRQFXdwiga9j0sl4ENxB+DwffBP4DE1ywB8CkufZfwPoO8la/9622qaP8orXbk+3Y4lgXyJVu4LRvyyy15wroYRBBI+IqoyVtRINcEtlFMmE9/G9mSqP3KC13L8lE9lQWtQsHvE03bNoQaKpUk4Qsy85iR2LuO/knqtt6GEsyEoYf7gSnFjzFH1llTLbArOBAIlOxIs6z4VzY7hw075NrB23LsbISqW7YZeR4OEaZSD0J5vENNuq059p37tTY+eY8uRFOKsZ05qd7zo8tH/hkYUBOwJJm0kSrvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPa02YAHGVtjdhyj7ZEuwlxcvKmyjH7cp6BNQPwjXK8=;
 b=f7+zNbGIdnqy6e8DgadauZuFUktR3QRnYMNBcdqwiK6AO5KDBHQnVMEDrksO74s2nH2blia+iogD72qcsTdMd59qiB3YGoI4gLaYtkBl+3L3BD+my0+pc3bjT2r9F2f4rA1qYHN1g/OUxB7t5RL+hHSk/W+7toM0AuIqOaFGYNjAIyQMU+7Z5/db2/BbZWZ8skzK7XBrAKd0GwjRQqLA+v1dOkvhRo5Y9qKNIXNd1V8rHkk4B28/vzuPnWYghwFV9gvDg+Lv1T9o09pdyiWprXKFFqZcZLaalpuHmiXA8dL/RA6umVhdJVu+OcGDbnAgRZIkYoRbbifhhElpGlZF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPa02YAHGVtjdhyj7ZEuwlxcvKmyjH7cp6BNQPwjXK8=;
 b=es2mQuI2JsGozxbBjvHVqi+VeRpySpHEOWjzbDOd6VHzt26Cli45o2kuoLeFwR5FZ7gLNHSti3h9pvehnSdQhW7X4pKEVJUdedZY2IYWNbVfLNrsI+gNPoXc9WptYjIZ3gEDIv1eLPUACXthyPATbjlownVzr2nLBu+PzBXmHQ+EYq2rw/1Le/8smJ9o8hcMqaedj2sgGiCjhgpQS4kb36VSze9lTgvieiUVtjRxCaAkYEbijFJmPweshkaSRMgoSgAXZZ60UPHgqbttQvvwFoxu3zKWyAKRfm4PjBkZSoAXpXySfxSRHgaOvlqkvTTzDThF7q6TmySfCfWr03KX/g==
Received: from BN6PR16CA0039.namprd16.prod.outlook.com (2603:10b6:405:14::25)
 by BY5PR12MB4856.namprd12.prod.outlook.com (2603:10b6:a03:1d5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Tue, 31 Aug
 2021 03:07:32 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::7) by BN6PR16CA0039.outlook.office365.com
 (2603:10b6:405:14::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:31 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Aug
 2021 20:07:30 -0700
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
Subject: [RFC][PATCH v2 02/13] vfio: add VFIO_IOMMU_GET_VMID and VFIO_IOMMU_SET_VMID
Date:   Mon, 30 Aug 2021 19:59:12 -0700
Message-ID: <20210831025923.15812-3-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5c4edaf-da3f-4c55-83c9-08d96c2c7944
X-MS-TrafficTypeDiagnostic: BY5PR12MB4856:
X-Microsoft-Antispam-PRVS: <BY5PR12MB48560A8CF61A6C804C65F3C8ABCC9@BY5PR12MB4856.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8RbGzxNMkBSwDAvXLUmoG2qI039equ4+dWoQv2k/9DqimgGJrukr+Lc9bMdvJHxUWXVbiINe9Q3YfgAiLO7pSf47KwO5Vt+Twcc5ohBtPlHtT3KB65iBYyvr21b2POR4w/klETJe7uOBdQv3ufUwTPScXKOgkjV6eoNZsSMl43TDDdK7mBw3qVgKvfgmQ3ESwhgZIELvCtb9wUoWMvOQhuiaBD6SlfgTnjCpicd3UH4Fq3cmgxJ6/VekDUpd5a8isplpuJIURk4AXpMtX51M6KD1kxcJT4POU2O/dJB6NaWIXQ3cZet2KMseIgVN/zjQn4QW72Ih3yMKfCd1lzfHXeMtxXrFd76T6Voq6q8x9DJ4uZp61VIcqnZpBn3+oFiN2wYHGHw6RFTVPimFjyp9WJHvAqTwdJZge76mE9daNStjWnTXnf/3Gh/csyLkvuZpms80z1C7NIA0zzdcRf1su6bArRkIycanMzgq0qD7oxMcZZ6NJyfA8W0/9wsY1io1zOPLo4sQTHr6XGBvK3SCGpPWScFigqKQQ4+mGHFJhPrmupxmGsWEwwMxMQp/RQyn7HHmoukSTqw0qtx31JU0gUBTiWF6aHyjexCoLk7sGtaq80WFCudfjQvQO6DweFKqQ9O8DLmwIcZWt4g6VQ6BCBBd/ea11MFQbstmbtce5lZ6IoXb27zCZO6rdS3ZxvdSlsq2r+j2ybfgDHKKHehpXvGTm4vXhsCfXLQyAEVdadQ=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(36840700001)(46966006)(186003)(2906002)(8936002)(4326008)(426003)(86362001)(7416002)(478600001)(54906003)(26005)(110136005)(6666004)(336012)(1076003)(70586007)(7696005)(8676002)(70206006)(316002)(36756003)(7636003)(82740400003)(2616005)(82310400003)(36860700001)(5660300002)(47076005)(83380400001)(356005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:31.6940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c4edaf-da3f-4c55-83c9-08d96c2c7944
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4856
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a pair of new ioctl commands to communicate with
user space (virtual machine hypervisor) to get and set VMID that
indicates a Virtual Machine Identifier, being used by some IOMMU
to tag TLB entries -- similar to CPU MMU, using this VMID number
allows IOMMU to invalidate at the same time TLBs of the same VM.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio.c       | 13 +++++++++++++
 include/uapi/linux/vfio.h | 26 ++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3c034fe14ccb..c17b25c127a2 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -59,6 +59,7 @@ struct vfio_container {
 	struct rw_semaphore		group_lock;
 	struct vfio_iommu_driver	*iommu_driver;
 	void				*iommu_data;
+	u32				vmid;
 	bool				noiommu;
 };
 
@@ -1190,6 +1191,16 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 	case VFIO_SET_IOMMU:
 		ret = vfio_ioctl_set_iommu(container, arg);
 		break;
+	case VFIO_IOMMU_GET_VMID:
+		ret = copy_to_user((void __user *)arg, &container->vmid,
+				   sizeof(u32)) ? -EFAULT : 0;
+		break;
+	case VFIO_IOMMU_SET_VMID:
+		if ((u32)arg == VFIO_IOMMU_VMID_INVALID)
+			return -EINVAL;
+		container->vmid = (u32)arg;
+		ret = 0;
+		break;
 	default:
 		driver = container->iommu_driver;
 		data = container->iommu_data;
@@ -1213,6 +1224,8 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 	init_rwsem(&container->group_lock);
 	kref_init(&container->kref);
 
+	container->vmid = VFIO_IOMMU_VMID_INVALID;
+
 	filep->private_data = container;
 
 	return 0;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..58c5fa6aaca6 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1216,6 +1216,32 @@ struct vfio_iommu_type1_dirty_bitmap_get {
 
 #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/**
+ * VFIO_IOMMU_GET_VMID - _IOWR(VFIO_TYPE, VFIO_BASE + 22, __u32 *vmid)
+ * VFIO_IOMMU_SET_VMID - _IOWR(VFIO_TYPE, VFIO_BASE + 23, __u32 vmid)
+ *
+ * IOCTLs are used for VMID alignment between Kernel and User Space hypervisor.
+ * In a virtualization use case, a guest owns the first stage translation, and
+ * the hypervisor owns the second stage translation. VMID is an Virtual Machine
+ * Identifier that is to tag TLB entries of a VM. If a VM has multiple physical
+ * devices being assigned to it, while these devices are under different IOMMU
+ * domains, the VMIDs in the second stage configurations of these IOMMU domains
+ * could be aligned to a unified VMID value. This could be achieved by using
+ * these two IOCTLs.
+ *
+ * Caller should get VMID upon its initial value when the first physical device
+ * is assigned to the VM.
+ *
+ * Caller then should set VMID to share the same VMID value with other physical
+ * devices being assigned to the same VM.
+ *
+ */
+#define VFIO_IOMMU_VMID_INVALID		(-1U)
+
+#define VFIO_IOMMU_GET_VMID		_IO(VFIO_TYPE, VFIO_BASE + 22)
+
+#define VFIO_IOMMU_SET_VMID		_IO(VFIO_TYPE, VFIO_BASE + 23)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.17.1

