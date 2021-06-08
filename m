Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5A839F4F4
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 13:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhFHLan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 07:30:43 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:53248
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231661AbhFHLan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 07:30:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqbC9oVp5Jodd74kzUvFgdPl0Ons+U310GGWe3AiNCWxCwbwlRRNgp/xDIAWAOxK8pbmWl71id5Nb6IHQvP9uXoWmKTr7ikiyXAJq2hHDlNhlb9jhGzDxgNXPQQ2ys1DCxxN1ktBUQBcNs4iM7Il+iLu3krOe+JaswTo+4A2LTguSXwYk+A2lpy3r5uZFMkr4/Q4HH2LCxg/PDRhnXW4mL7ccsz2GBwvvzphYW1xJyBbhFTzsVFyrqXYsdh7ea7odIhXypsJrDBUv9UbIE/ZGtTzwazQR8GZUrX9SrBy9FfKhT9EP4P1e5sa7swG0CEsmtq34laC9oLUGyuZYNoTBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3e9vJwVyVc3d2esNTfwKqxwgJYzB7efGTYefNWBa3vM=;
 b=XEUpb4/WGfDGd3wl9TmKMsOt1OroggFDDA9qXAK3v2Y3RSQoXtXP0/hL2CFC3PVa5L8U8XGhjUc0xyz7Ql5ze35BLf9Wjb+8479zL2n/ZdHmJSX7ww6a47bhDkaIjpMOPXK55gAEI2q/vzOqcu3qppmh7OzGhR+Idg3RPec1W61KS+/PW3reVNmHGJYvLAmhwzkwzQq03t39t23UuFbvO+MsgfqrgkGk0XbNUJNi2m5U1xtNcfJjqv7zIXsE7iJAhCcsZhnq0Xle5YU6dVkj/02BicO6UQeQ9h7uOhTDtOxC2REfZf7abKoDqzlV5qhBhHCY2cF3z2GX2mgMA6WlgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3e9vJwVyVc3d2esNTfwKqxwgJYzB7efGTYefNWBa3vM=;
 b=QBpNg/eAKBAB5SbtiHGwwZLdA+efCILjyHhdKOaiaYcpTEbTG0RLT9p+H+tSGQlXY87nsA0byiteCKBBq2eL7ZtIvO75FT6H5OIpP6u1RKpbnL1vvfAZJSr8mcpRe1j+TjePsdA7kcTPxXS+n/unC6csKiQN255FumCtXrkwNivGr74G9hqe5N/BlOzWKU9bQ1thg2Kmoz0dGKLz4O2wUHuVHYxonNrgOE/eCbJuNMFKXfjbwvRV5HVs/uGhApC5XqwI1l7VRfJNlK9h+2/o03z0pZd431pYMhe8gEFrZ1MHSOX9sQoauXSv4BHiSWYf8iGKgf3m7DQcouW6LYS5Zw==
Received: from MW4PR04CA0177.namprd04.prod.outlook.com (2603:10b6:303:85::32)
 by BL0PR12MB4738.namprd12.prod.outlook.com (2603:10b6:208:8e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 11:28:49 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::28) by MW4PR04CA0177.outlook.office365.com
 (2603:10b6:303:85::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Tue, 8 Jun 2021 11:28:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 11:28:48 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 11:28:48 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 11:28:46 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>
CC:     <kwankhede@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] vfio/iommu_type1: rename vfio_group struck to vfio_iommu_group
Date:   Tue, 8 Jun 2021 14:28:41 +0300
Message-ID: <20210608112841.51897-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dc594ac-fff1-4d05-018d-08d92a7095fd
X-MS-TrafficTypeDiagnostic: BL0PR12MB4738:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4738F58D448EC9EA613FA842DE379@BL0PR12MB4738.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:159;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j409YXyYzgW4D1ATa+7Fn+z8o7wA1icwkmXJFqPPF2cBzuobdttmF/szW7UhMKfkoFE0RK6Dhvqa4hoFdzzqCRhNUSsXU5CNXj0N64Xb13p2K0qJyfnHQPNwsJEskzU738lMfzdLwoxwREY+FbaN0tRpErhHMtb0jNWYxJ9vDZRrBsiCRwFkJBNcZ+GVlk25GqA27YNHCV2SJWkkzHdRBmKWLh5q6Xe052lV7Lc8U36M0iFDIrxVuE3v/PXpDMNo5OguTm/5u+lpPb+vH8XfycY2KGiSHUzFENZ593ypYI/0J0ZDrWbIgzeLJCIzfdH9pozePM3gOuqjd3DLB21l6LOrN8okCdnkfWVmTVCPg/ivYaoecYdnNZNlXtCaQ6aAfk3FTNhaANXdotj+mO86tnYW7ID9M06WpVzKPXnbtLUhrmvImjwSxrqxNv+LeFmQ5xNEliJ7rOnwy6SNwGkBFiwJNtfO3xdcJIAMFxEWK6ZtS3kiOD6ARRTtayf0aqFZt7SFeXFERLplAZRVcQfUJk9y4HVtzrnyOVd4XAiroCzJlVGHw88TgqBzDwgtdLZGqS6laOpyfS2+Ou6AdHBKQ75Ya+oUVhUlMnljtvk5yMqQ4hp8HHUopB4Y+lFyD5pGtTZzyNUUuZhWs0KzqegPew==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(36840700001)(46966006)(83380400001)(36860700001)(478600001)(70206006)(82740400003)(7636003)(8936002)(186003)(70586007)(6666004)(36756003)(86362001)(107886003)(356005)(8676002)(4326008)(110136005)(316002)(5660300002)(2906002)(1076003)(26005)(36906005)(82310400003)(2616005)(426003)(54906003)(336012)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 11:28:48.9647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc594ac-fff1-4d05-018d-08d92a7095fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4738
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_group structure is already defined in vfio module so in order
to improve code readability and for simplicity, rename the vfio_group
structure in vfio_iommu_type1 module to vfio_iommu_group.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 34 +++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a3e925a41b0d..830beb920a14 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -110,7 +110,7 @@ struct vfio_batch {
 	int			offset;		/* of next entry in pages */
 };
 
-struct vfio_group {
+struct vfio_iommu_group {
 	struct iommu_group	*iommu_group;
 	struct list_head	next;
 	bool			mdev_group;	/* An mdev group */
@@ -160,8 +160,9 @@ struct vfio_regions {
 
 static int put_pfn(unsigned long pfn, int prot);
 
-static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
-					       struct iommu_group *iommu_group);
+static struct vfio_iommu_group*
+vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
+			    struct iommu_group *iommu_group);
 
 /*
  * This code handles mapping and unmapping of user data buffers
@@ -836,7 +837,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 				      unsigned long *phys_pfn)
 {
 	struct vfio_iommu *iommu = iommu_data;
-	struct vfio_group *group;
+	struct vfio_iommu_group *group;
 	int i, j, ret;
 	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
@@ -1875,10 +1876,10 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain)
 	__free_pages(pages, order);
 }
 
-static struct vfio_group *find_iommu_group(struct vfio_domain *domain,
-					   struct iommu_group *iommu_group)
+static struct vfio_iommu_group *find_iommu_group(struct vfio_domain *domain,
+						 struct iommu_group *iommu_group)
 {
-	struct vfio_group *g;
+	struct vfio_iommu_group *g;
 
 	list_for_each_entry(g, &domain->group_list, next) {
 		if (g->iommu_group == iommu_group)
@@ -1888,11 +1889,12 @@ static struct vfio_group *find_iommu_group(struct vfio_domain *domain,
 	return NULL;
 }
 
-static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
-					       struct iommu_group *iommu_group)
+static struct vfio_iommu_group*
+vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
+			    struct iommu_group *iommu_group)
 {
 	struct vfio_domain *domain;
-	struct vfio_group *group = NULL;
+	struct vfio_iommu_group *group = NULL;
 
 	list_for_each_entry(domain, &iommu->domain_list, next) {
 		group = find_iommu_group(domain, iommu_group);
@@ -1967,7 +1969,7 @@ static int vfio_mdev_detach_domain(struct device *dev, void *data)
 }
 
 static int vfio_iommu_attach_group(struct vfio_domain *domain,
-				   struct vfio_group *group)
+				   struct vfio_iommu_group *group)
 {
 	if (group->mdev_group)
 		return iommu_group_for_each_dev(group->iommu_group,
@@ -1978,7 +1980,7 @@ static int vfio_iommu_attach_group(struct vfio_domain *domain,
 }
 
 static void vfio_iommu_detach_group(struct vfio_domain *domain,
-				    struct vfio_group *group)
+				    struct vfio_iommu_group *group)
 {
 	if (group->mdev_group)
 		iommu_group_for_each_dev(group->iommu_group, domain->domain,
@@ -2242,7 +2244,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
 	struct vfio_iommu *iommu = iommu_data;
-	struct vfio_group *group;
+	struct vfio_iommu_group *group;
 	struct vfio_domain *domain, *d;
 	struct bus_type *bus = NULL;
 	int ret;
@@ -2518,7 +2520,7 @@ static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
 				   struct list_head *iova_copy)
 {
 	struct vfio_domain *d;
-	struct vfio_group *g;
+	struct vfio_iommu_group *g;
 	struct vfio_iova *node;
 	dma_addr_t start, end;
 	LIST_HEAD(resv_regions);
@@ -2560,7 +2562,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain;
-	struct vfio_group *group;
+	struct vfio_iommu_group *group;
 	bool update_dirty_scope = false;
 	LIST_HEAD(iova_copy);
 
@@ -2681,7 +2683,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 
 static void vfio_release_domain(struct vfio_domain *domain, bool external)
 {
-	struct vfio_group *group, *group_tmp;
+	struct vfio_iommu_group *group, *group_tmp;
 
 	list_for_each_entry_safe(group, group_tmp,
 				 &domain->group_list, next) {
-- 
2.18.1

