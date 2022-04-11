Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEE44FC025
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 17:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347718AbiDKPSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 11:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347708AbiDKPSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 11:18:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F94B1D8
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 08:16:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoK5RnJtTWkA17kL/NyLx58TuTidRXkKFHIkqPUAaFZeM6Z4SrLfXLhyRk2nJy6e8ngE6f8RhLAesYfmLKG7oLAYfmb3FObIjToYufFkHesv0FA29qEak2IehI1BSvGGLlE08MJwOmxcurJ4B7AJGjrMNO/FD9WblyQ3lgV6JS3j3iFsfCAssfSEHZmYNzui2+4+0KlMU2Cu5wI/sn+iPkDts14fyV6G6vAW/ARyRfyYV8ir/LuPwy8/mwT4xwj+z62ZLm1neeNCgEt8kgZLNLdf8upLFlN5usCMIKQYjqfQCOcKqcCKRArRCihjE1tzaU2J2guqzc9Djb4cZMy2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94v9L1nm3zMJSC05tg5Jp/cErAVjGxWbT0GRAB+Zf7E=;
 b=SGkFQi2cCura7v5VI4MIwW2uoJzEMwxs5JulapUv8zah1akS/RWNh0OYhivxUbirvWsbZeKE+p3PDaubtJt4AZPxXdVyiXm5nzGzmOeincHFB+ghPDLzBfOpy+XyGZObRN2Vm9zj9u706X2fpNq0AXdYN2Uxo4kau8DLJbz/4XNGsmHWmtkxYCJibJN2d72RRDx3Q4+NiPwOfnmLm+gdVU8zsTa6AU1F0CCcWDN+cUm5OTIh9YTcjp/i9p4EY7wkFCwqYwh4mRMYgBv3IMvGhjfmZruPgC10CRo+9Um+n4YLvw7f9wlafpnY3QsLeGwT3q65oKuPyjaQhqLEOaZSkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94v9L1nm3zMJSC05tg5Jp/cErAVjGxWbT0GRAB+Zf7E=;
 b=Odabw0q7Z2fW5U/RAWNiT1/NIssocuc9rPWIbNXRNDAn4TiwQYfdro5S2EW64bS9Bti+SGBcOLaWOfthHgSvDH9LUhLu0GGJrBwFcgrzuvD8ALrBNq0Sf+G+ZEPT4kTpkhqT0E5bE+EgWTRQ5uW9UkJwjph5V0m1nbOs71R5ajtQno7NqY9JGbrHPDpsDHbxKLsmCmJAN63nzJ2QXTT3Ux99zkQtsH168qOkf3D7r5sAIXsEIk7RKBs4Zr4uFMRhN5KEavZv7X6OYjfyKOPTUpexIYM5OItj5AgxQ9uWRNW7hkQKzaLva6j9ZWWTtmNreGJL4EHN8kzs783XwgrWYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5927.namprd12.prod.outlook.com (2603:10b6:510:1da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 11 Apr
 2022 15:16:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 15:16:11 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 1/4] iommu: Introduce the domain op enforce_cache_coherency()
Date:   Mon, 11 Apr 2022 12:16:05 -0300
Message-Id: <1-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0117.namprd02.prod.outlook.com
 (2603:10b6:208:35::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f56c2e4-28aa-4d55-4589-08da1bce356d
X-MS-TrafficTypeDiagnostic: PH7PR12MB5927:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5927AE81C91CD7B356CCD339C2EA9@PH7PR12MB5927.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oafk+8DLNc/m9GaNu/w1wcAW/OkddhL4UooaKoTAlniZYOTTI79FRPGIgBwV/S9q9DaYnxxZo38aCudBumYgjkvE9B5ELoWd5MIJMW8/jVy4WeW9RV/V8rGA3dvqD+MTVoALy7Ot6Cd6SPDIVP2jf9oaLqF4ce+JP6Yu4BAcjHErTbY0yKOXEBYuYxDB8R9uEVHU/RkS8zfEe0dY8BinM3Z0QI2hoJC9+/CiCNPtve2wWVPJHCHgisRACu9I/Va9Sz9sGthussKjiZ/D5wvX3RFbRFFKt9htq3lcZMxQt/EbmO1iG/u0Mabf98FsQ31mzTo8x5YyRjiBGflbGMtHwFRrVL6i+b4/EgTV61bpZR8vjKNzM0cKGjQS8heRa4vUhLKTxIDckxrnkhnpCMB2T47pO8t88UuoCcHf8sriVkmQkWu/rRjTos5aPMhbszWi+sfmFk7sXJAteceUHa2YLoKuD0M0ZyBJPmvStkORiuC16TqtLaAHAbELuaJLE+68lEsXH8xUKkzsiahqQ6UnTgavqVjdGdBCchf1rxNUwPWwWKq7cCjbNHr3mXo/7dayfMZ+R5P1i26wsoxcLLcKS9gsKJLqEGZwGqRpnOyKhENwN4vj6lCoQL12zczvnDfVWogjq+ThvEbeSzo0hs1BL85rrE7IZxWsAsui3QZjZbng6LcUriIdbudlySS5FZzv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(54906003)(6512007)(38100700002)(8676002)(508600001)(6666004)(6506007)(8936002)(5660300002)(2616005)(4326008)(110136005)(316002)(83380400001)(86362001)(66946007)(66556008)(36756003)(66476007)(7416002)(186003)(26005)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jVaJpVT6EjJ6O1CaV4GxJ29ebSyb/OCNPePfVkl4n8dl3WFuPKTZbKO+DbKi?=
 =?us-ascii?Q?DhcsVRBICvehENDmn0VcgpM744cznq4UPxezo0jF20HMHsTfQvYqOaFZaN21?=
 =?us-ascii?Q?cWI+3JZhTszjcP8rSBzaQYhUmGFUUvwvaQaJ6K9DBhk762Dtw9+K7z3S8v9M?=
 =?us-ascii?Q?2+5NmrhUVucm5jvUkeCJUcJFE5BDANrHgDfymSCxD7xu9eK8WzokKxx3br1L?=
 =?us-ascii?Q?sZNRph2yt7rmlpBVOY5MnIwHIdedfd5K98bRpmmxSqg96cdyK6SDiQeCJ3B2?=
 =?us-ascii?Q?3MudJ1hrbmRSyMT8YPipBmlwLzN0XAU/8fQ/9KvrInDnZFUuDXeQVKb3ZoK4?=
 =?us-ascii?Q?bzteKnLzXbZ1SHb/alggR2V00jTR55R2GbgeFi6jNGwvLpZcwq4iIKgK8pRy?=
 =?us-ascii?Q?9Zd0+0asDTbkXh9DTBSH/FgTh3RRTv8n5bS8E599OGxT6945b+pHUO7kSCbQ?=
 =?us-ascii?Q?dO4pWHGsUpMZDasRAjwH2WlSrkaNf4CxWhMes96wvYp+9Rg9PeYWDfVPAmFM?=
 =?us-ascii?Q?2T55CzNTda/LG8tkkMsu97t2B9TvZTFGJ+5ZRfKx2Y7+OF1ybFcis4RMw/F/?=
 =?us-ascii?Q?bH5sxtA2Ch7T0DxuSKy92Oc9vUTLrdwKHtcl5Cy3/zgCKXktNbtWn3yHrTPq?=
 =?us-ascii?Q?SAsMXRaji5PVsSOgRfU9ClOgMja/F2ydU3aGA/obLC1/OUjdza5OUw8WyUKp?=
 =?us-ascii?Q?rP/jMgB8lyBcZ/P2qhwm9lfGBxpwg/JcIbg0RRwJ/1K9AlX0WR6YHtWI6Izq?=
 =?us-ascii?Q?zutCwFG8YV70reXvEXdAFgHVMsHStnEbLmDW4JheJ6pKpp+tE4Y7WFMGWXv8?=
 =?us-ascii?Q?FXEYu8JDlN38kIgsWPznONhcO3AEUksUZEVAZheHJhsMb0iQrPzOg/yRsyu8?=
 =?us-ascii?Q?1F9sputt8O73yk1RKu36yz0ENbFG3tVjt9rLmucDfDIs+j/cdANBfHis/As4?=
 =?us-ascii?Q?7zLZ9duf+DgnVKePaNVgwwIiRlx1E8G99a5ATDhvtLCwY8zLxZz+7DRq91/j?=
 =?us-ascii?Q?Clwlq6klE7RVWSOhX4WY5Q5CScJrvjbzsKuJCX7N1080KzS7+0qgCKct1XAY?=
 =?us-ascii?Q?oFLoYyqnHILlgME6YER1Ei3FqOiOoU/RQo/7txc9QzkQt8ci/bnnzHOLQ8HR?=
 =?us-ascii?Q?W6T3oVtU6hJkX/CiAFGs2cHIeJflECT5VpgdHQidpqXlPELsWLuZ4ybKUNYO?=
 =?us-ascii?Q?klmiUyV6/QceM37KUqmunIEUEQvaZ053cOeDRfInkE6FFEk0mTUEPpFpmLjG?=
 =?us-ascii?Q?QxCikNKqDFIorWHDIIZIALK0DkMfY9yH+b2Ay2BzT8F95xEQ6nrY2RzDUbyH?=
 =?us-ascii?Q?dI8SOQBDwjZvdvDqljiFJBUWLWFPOdyTo4gQEegqNbnEjTSSVmbw9Viqg/qA?=
 =?us-ascii?Q?DBVGf79lZBX9fAXLN8jaIam7NKSOWn+rpt8oDLG14rx4tSFmgw234D9UK+0h?=
 =?us-ascii?Q?jnwlKNldZkA+VI363gU+W2J8BdJhaUlJKWC/bCy87ZwjIV2qBJfBu6VAgx1L?=
 =?us-ascii?Q?oSLSxJoqybh81Ix6vPl7qrlcsKywke6j7XRKO/EG0i1vIIZvzOp3mbaXMN+K?=
 =?us-ascii?Q?2C1d33Mn4nMfGM4+rwuVh3xMISy/SUgkk+GdZIS6wT/CX7BNs8D1DPjE5Dui?=
 =?us-ascii?Q?6rwodTY6t15WIhMNzrt9RPczDoClg6eqX8L7gkJQKQPaMBwFwm7xm0ElpCYq?=
 =?us-ascii?Q?LCoDTIqhYayoNCD+Iz5jujQDi/gU/relDoRJBYQtmmg8a/+/pDUkzI4ioEB2?=
 =?us-ascii?Q?CDypI7zIxA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f56c2e4-28aa-4d55-4589-08da1bce356d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 15:16:10.0694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0IdehulBRyQpn/eDiIyubou7Gtk91b3x2R2zpxITVDY6ChuhA/B8VXrNw0FXYiah
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5927
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new mechanism will replace using IOMMU_CAP_CACHE_COHERENCY and
IOMMU_CACHE to control the no-snoop blocking behavior of the IOMMU.

Currently only Intel and AMD IOMMUs are known to support this
feature. They both implement it as an IOPTE bit, that when set, will cause
PCIe TLPs to that IOVA with the no-snoop bit set to be treated as though
the no-snoop bit was clear.

The new API is triggered by calling enforce_cache_coherency() before
mapping any IOVA to the domain which globally switches on no-snoop
blocking. This allows other implementations that might block no-snoop
globally and outside the IOPTE - AMD also documents such a HW capability.

Leave AMD out of sync with Intel and have it block no-snoop even for
in-kernel users. This can be trivially resolved in a follow up patch.

Only VFIO needs to call this API because it does not have detailed control
over the device to avoid requesting no-snoop behavior at the device
level. Other places using domains with real kernel drivers should simply
avoid asking their devices to set the no-snoop bit.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c   |  7 +++++++
 drivers/iommu/intel/iommu.c | 14 +++++++++++++-
 include/linux/intel-iommu.h |  1 +
 include/linux/iommu.h       |  4 ++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a1ada7bff44e61..e500b487eb3429 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2271,6 +2271,12 @@ static int amd_iommu_def_domain_type(struct device *dev)
 	return 0;
 }
 
+static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	/* IOMMU_PTE_FC is always set */
+	return true;
+}
+
 const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
 	.domain_alloc = amd_iommu_domain_alloc,
@@ -2293,6 +2299,7 @@ const struct iommu_ops amd_iommu_ops = {
 		.flush_iotlb_all = amd_iommu_flush_iotlb_all,
 		.iotlb_sync	= amd_iommu_iotlb_sync,
 		.free		= amd_iommu_domain_free,
+		.enforce_cache_coherency = amd_iommu_enforce_cache_coherency,
 	}
 };
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index df5c62ecf942b8..8e8adecc6a434e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4422,7 +4422,8 @@ static int intel_iommu_map(struct iommu_domain *domain,
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= DMA_PTE_WRITE;
-	if ((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping)
+	if (((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping) ||
+	    dmar_domain->force_snooping)
 		prot |= DMA_PTE_SNP;
 
 	max_addr = iova + size;
@@ -4545,6 +4546,16 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	return phys;
 }
 
+static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+
+	if (!dmar_domain->iommu_snooping)
+		return false;
+	dmar_domain->force_snooping = true;
+	return true;
+}
+
 static bool intel_iommu_capable(enum iommu_cap cap)
 {
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
@@ -4898,6 +4909,7 @@ const struct iommu_ops intel_iommu_ops = {
 		.iotlb_sync		= intel_iommu_tlb_sync,
 		.iova_to_phys		= intel_iommu_iova_to_phys,
 		.free			= intel_iommu_domain_free,
+		.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
 	}
 };
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 2f9891cb3d0014..4c2baf2446c277 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -540,6 +540,7 @@ struct dmar_domain {
 	u8 has_iotlb_device: 1;
 	u8 iommu_coherency: 1;		/* indicate coherency of iommu access */
 	u8 iommu_snooping: 1;		/* indicate snooping control feature */
+	u8 force_snooping : 1;		/* Create IOPTEs with snoop control */
 
 	struct list_head devices;	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9208eca4b0d1ac..fe4f24c469c373 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -272,6 +272,9 @@ struct iommu_ops {
  * @iotlb_sync: Flush all queued ranges from the hardware TLBs and empty flush
  *            queue
  * @iova_to_phys: translate iova to physical address
+ * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
+ *                           including no-snoop TLPs on PCIe or other platform
+ *                           specific mechanisms.
  * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
@@ -300,6 +303,7 @@ struct iommu_domain_ops {
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    dma_addr_t iova);
 
+	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
 	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
-- 
2.35.1

