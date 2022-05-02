Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084F25175D4
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386670AbiEBRfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386639AbiEBRfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:35:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D976B62C5
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQD5Ylc8iUhVn4i2odGuFqE7aocF4vXA7piqTzCXc3SANn0T1neroBy3+GboEBxiYlVBGTYRsQRy+CCW1Fp/UGh1fHeGIDD6+3G1tMc/TsyiWIhe+9hxZ9iLzW003cuBPaeVO0PyuK6y5aPL7QONQ9dGC/wzMyQrNm3MDbuVNjjo7xqZSFAQ66rkR/C8iWrTD7cXKMjvzd+9qTWR5Ztt+hXlyhHssJXAF68f/+Yy1D61mX+fUmJ+apO/S6vad1fWDzF6AaiCHf/KfQZSiu+/wGNro/BFiRNaLXTMAXheSVd2aOtkZsc50VyxTrDQORn0gXBPeNraLyPHjEoo6ofG1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ww9bH2biUzKJJodU726/qqkRUF5l4LTSNft/M4XYHG0=;
 b=eNOTi3xoMJwDDlkbxu8rpGRGc4zOI5RKeMBQ2GzBjitIIVQ+htKjzmxUbeWI3YbB3oB2jhJjFwzpv7Z/l0WpvZkmf1hrFQ4igSqj88IsrA4lJbRrIh/zjW6qWDw8i+2Kaw1LYeY4bd41cCPh7X7PkqHItiwAJHDivc0mPHwDfkuEGL2ztWAFCSMN2Qsti8d2uSU1ed1dPZjgqG+/uBpuedELBXRf/PdHHIlR7CdiYxz/53Ym1x6G971IH4GlP+EmCgG7PqsCUlWY7oGJrWqfr89aBpvHTp4hMN+pU9N5VpUbU4zKMYN8jiW9RI2pDi+oe2COTryFAN7eyv8MjdWEqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ww9bH2biUzKJJodU726/qqkRUF5l4LTSNft/M4XYHG0=;
 b=ZDCCtphtmIqPeXZVI9zbgONpxqFvvpamcsztyEm/5BLCCrbV8P/fYnDRUJTxAtbrIIgx9eYkkZEuniQuTFbsH10uYMOaxyajl2POQEJb4ZE9M9V9QQrv4RX90IpDlq516HnDUbHR5c0Iu+q40u0qER7sfjeOxcGCcfdZj68GKh2jPq6P4OLdcqDEiKBJhTI05gktYGuWyJESCkIqXRjcYJ3ob+0TCPkKlPF67Ag8rh9o5vI3aEmC0IhBnBkWjXkgI4kkxvaZiSfFKQflXQXX/lUFOwQNGcfhRNzpWFfwqUHoziz37pjvTLuDiJUu8x8nziRdXhITJZDSHPA65mJY8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5458.namprd12.prod.outlook.com (2603:10b6:5:35b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 17:31:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:31:40 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: [PATCH v3 6/7] vfio: Remove dead code
Date:   Mon,  2 May 2022 14:31:36 -0300
Message-Id: <6-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0072.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01da8ae3-f4f5-457f-601c-08da2c619cf0
X-MS-TrafficTypeDiagnostic: CO6PR12MB5458:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB54583FC62383CD0C97771FCCC2C19@CO6PR12MB5458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zR5YygArsp/yBS93zqzoberdYk3ZISr8zPivqGxCc/kcZQ6riJfomXH1+cu7f6re0jIi5OPGjr+cawqhK+wa9EPM1dZVSATh4h6wUyIEOTC3WZoBMRLea8v6g/kjnqRnOrR8M6HbwLr4NEkdQQ0alUAXNF+p+cgXGvyCi+t2IGLgJe1WCHIVHf2U5vppVuMJMkmgekrxnkSaJC5e1KMjwE7isIGYI2E312Aeoxwk0Ot7Uz/4pgeXcdYx7sCC1E550g3DFFbnARUeOsRRF4G6lZeZfhugqtpI5h9YJnFL5jK4q24GZ9WTWEUQYK3Ldc12KY23GpmQFsEa/eY+YAyL2drEh3vcaz4R0hkMmvHGaQCuH/VEvzFmntOKSgg/cPWzrTWerGH/x3t5xc8VAxlNpAUm0oK8bK7guiS2D6O02FffIi4d09vbj6PHG5Idh6azxGlFkuviZflkd509/gVhbjgciB7p9JW+lGHbXUd/Xr9fEtCPqiaNEXyTXfMz5l6WwXVi7uvlw+bkk485mH2W/zG7TG7NUEvysb1ysFw6D+P1LjdX15nIZPeMGlVuuU11SyScSq5ZljjbdBcLdwQx+07B9XnWVjDn/xBWTw4GsWAXuJUiHRKMXLolgi2pSQU/rWMqfp/1kJl+JD1ybkpvgzOCFoCFTr4LmD+U1msIOeUF2lc51GhRB/JS3TbdWsBy+wSq/XwKiir7OmrNbIP/Ob+s6wFvrazcy/amwSL1oEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(109986005)(6486002)(508600001)(2616005)(86362001)(6512007)(26005)(6506007)(38100700002)(6666004)(316002)(66476007)(2906002)(66946007)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(4326008)(83380400001)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wLYwjBmv8F4/XVSq7gGH7ltPbxNPoCInpZo//9ZpznVxdnDHUIqXlfZrvK2e?=
 =?us-ascii?Q?x8LG1qV8rTI71vGc0ePrzH1D0fhayWZDnN3yEKNTQKqsLcufgLHD9rp0hzV8?=
 =?us-ascii?Q?MExHpIoZjXv5xNRcwkkCuOCP3z/22gTb9rugghKC3dYs6hLwsuSBZ9wl+aA/?=
 =?us-ascii?Q?sV2yu2iVcXjOqBwwGdZF9WoII1Fk6R5K9JjpkR1IEjXPr1qGx2ZSQ4HojVlZ?=
 =?us-ascii?Q?camUR+VjZQYPRQ9E/w7VI2PiWZ5MJmyp0nMm/68D80fiRELOhE6HuumFX2mq?=
 =?us-ascii?Q?e07mm6h1jM2Z+bDJlUzVWJyGRHxoBnRAWOWgVRlucL8vfhkQAQat/s4AguQL?=
 =?us-ascii?Q?jdudaIzxmr/pov0PmYs2FJAmFjDILIbcZDMk5SSMkvdP07oiFyIEsz3Ikvdy?=
 =?us-ascii?Q?8ySXfKKX1wR6lzwO6t6GmJNrGRjK7ge0QCuJPKjlqzUJXoYegm7pS6rIjZpl?=
 =?us-ascii?Q?Jb20BoZQALmfgp15kJJErmJXxKjk29DPL4C5/c+BO9fRp8ixDgHmpjowWMLn?=
 =?us-ascii?Q?XiZe+kRID+x0r2PAFc/7VlqJdxPyeQiVPRyaNT8zvx9VDzFH2TmwG93nPNrW?=
 =?us-ascii?Q?aKWHibCmOvRgkJb90xFdR596cw1UX/4t2r27kBESV/GEt1WY52zsKyUOyMOE?=
 =?us-ascii?Q?hh9jYn/7Dk5K6kk3iAG+TxzsZDmTOHQ3biX13NwfJJpiurCMDaGdvaZQlrFV?=
 =?us-ascii?Q?Vrajh20hSpPgp8LQROhCiK6Rs+/JUUTQiJkXn7dsfEfyKbyBT+MmwfadhluB?=
 =?us-ascii?Q?Ib7/IC2i/inl/n/YTz0GYtRaIFwa/H4NO1Lt+YRHJRpgaKSy9/VH1gJshRa8?=
 =?us-ascii?Q?h+g8zLIgAJfplWZAmVzZBd1R19KyhqjKxn1qzNbZEOG+Sl+EMnZd/jmJR7XN?=
 =?us-ascii?Q?XQ/YgZU7nwh2e7pgodhP153b4ACozsiPqRrDJyUINyn+dDNOtrdLeswFrbai?=
 =?us-ascii?Q?gkC8ELc/prgdON7Ihk+bni4f7whBrLeE7Son19QAinPdhampp7lzDyk8Dkzu?=
 =?us-ascii?Q?7BMtUCbmQx+AnK/e0oWDdZx/0x0BmpMs7c8lDGBrdYtfm7btF7KsWWC3iQhl?=
 =?us-ascii?Q?W7eZV9kHam9S25110iQKVINTEyBSoSOgvzo24BAoMGny0pDpxO8yuzd0w694?=
 =?us-ascii?Q?1Bq9YkdGAatomUohCT8ZWswRLzmu7OMFrOC6/fWf7F8W93arV5hcvnrsIt6r?=
 =?us-ascii?Q?nVZAjDkZ584x5lwk0IKT58UO9unfF1mnWW9XAd209ZHuAO+9gnoAoVkUYbuJ?=
 =?us-ascii?Q?283GmZyBkcd3JYKqgn+Nrf6h9IpR0+VkRtTkfI30Wb1uSRamIn498eyRAeUK?=
 =?us-ascii?Q?DMHQtc7/zFI1c2eUd9Oy/VJMQbOpuErFx8Y1UcjfnzkRMR06OWOwypWHD3Io?=
 =?us-ascii?Q?w84+Zrs+tEGCtUwY1KC5pJDiidhlaeHKxt3t4Ax3L0LHDZWnw67vpMVHPZ04?=
 =?us-ascii?Q?APDxP9C7Vv1eSe14reDlQsUlcL5KaSy8tp4MQ3SnrtExM/tHeQA4ci3f2L7r?=
 =?us-ascii?Q?J5hHw1+gDKfOMVVzVfpjE6CYQqkwEQhyaHI+ioCaZ3DT4XORV0K8Jcs+HOjI?=
 =?us-ascii?Q?adMKWOXhqwfcCWCPJzXo1M6EnTBzqlc5G8dXVqkVd5+MS1dSnMCkoR+uZu8f?=
 =?us-ascii?Q?RicBZXJvNEZitEyNAODbQw0xhs2BEn4fvpDgHPLG2DZRm//Bwri4DihP8Xf4?=
 =?us-ascii?Q?Thz2CsbJv7AcBJKSA10T/tQ8gshSeFe2Z1ytXdoZ+N4VZ44zp42A/evmfbqD?=
 =?us-ascii?Q?71JAROcDqg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01da8ae3-f4f5-457f-601c-08da2c619cf0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:31:38.4357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1vCd2C6mCAiFSD5KH71PE0Zvu7ASMgXWjE6l6qiKe7fZ5DJqvmSvgcFZMv+Bser
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5458
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that callers have been updated to use the vfio_device APIs the driver
facing group interface is no longer used, delete it:

- vfio_group_get_external_user_from_dev()
- vfio_group_pin_pages()
- vfio_group_unpin_pages()
- vfio_group_iommu_domain()

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 151 -------------------------------------------
 include/linux/vfio.h |  11 ----
 2 files changed, 162 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 7960a153879ba5..0184d760ec1e44 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1732,44 +1732,6 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
 }
 EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
 
-/*
- * External user API, exported by symbols to be linked dynamically.
- * The external user passes in a device pointer
- * to verify that:
- *	- A VFIO group is assiciated with the device;
- *	- IOMMU is set for the group.
- * If both checks passed, vfio_group_get_external_user_from_dev()
- * increments the container user counter to prevent the VFIO group
- * from disposal before external user exits and returns the pointer
- * to the VFIO group.
- *
- * When the external user finishes using the VFIO group, it calls
- * vfio_group_put_external_user() to release the VFIO group and
- * decrement the container user counter.
- *
- * @dev [in]	: device
- * Return error PTR or pointer to VFIO group.
- */
-
-struct vfio_group *vfio_group_get_external_user_from_dev(struct device *dev)
-{
-	struct vfio_group *group;
-	int ret;
-
-	group = vfio_group_get_from_dev(dev);
-	if (!group)
-		return ERR_PTR(-ENODEV);
-
-	ret = vfio_group_add_container_user(group);
-	if (ret) {
-		vfio_group_put(group);
-		return ERR_PTR(ret);
-	}
-
-	return group;
-}
-EXPORT_SYMBOL_GPL(vfio_group_get_external_user_from_dev);
-
 void vfio_group_put_external_user(struct vfio_group *group)
 {
 	vfio_group_try_dissolve_container(group);
@@ -2003,101 +1965,6 @@ int vfio_unpin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 }
 EXPORT_SYMBOL(vfio_unpin_pages);
 
-/*
- * Pin a set of guest IOVA PFNs and return their associated host PFNs for a
- * VFIO group.
- *
- * The caller needs to call vfio_group_get_external_user() or
- * vfio_group_get_external_user_from_dev() prior to calling this interface,
- * so as to prevent the VFIO group from disposal in the middle of the call.
- * But it can keep the reference to the VFIO group for several calls into
- * this interface.
- * After finishing using of the VFIO group, the caller needs to release the
- * VFIO group by calling vfio_group_put_external_user().
- *
- * @group [in]		: VFIO group
- * @user_iova_pfn [in]	: array of user/guest IOVA PFNs to be pinned.
- * @npage [in]		: count of elements in user_iova_pfn array.
- *			  This count should not be greater
- *			  VFIO_PIN_PAGES_MAX_ENTRIES.
- * @prot [in]		: protection flags
- * @phys_pfn [out]	: array of host PFNs
- * Return error or number of pages pinned.
- */
-int vfio_group_pin_pages(struct vfio_group *group,
-			 unsigned long *user_iova_pfn, int npage,
-			 int prot, unsigned long *phys_pfn)
-{
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-	int ret;
-
-	if (!group || !user_iova_pfn || !phys_pfn || !npage)
-		return -EINVAL;
-
-	if (group->dev_counter > 1)
-		return -EINVAL;
-
-	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
-		return -E2BIG;
-
-	container = group->container;
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->pin_pages))
-		ret = driver->ops->pin_pages(container->iommu_data,
-					     group->iommu_group, user_iova_pfn,
-					     npage, prot, phys_pfn);
-	else
-		ret = -ENOTTY;
-
-	return ret;
-}
-EXPORT_SYMBOL(vfio_group_pin_pages);
-
-/*
- * Unpin a set of guest IOVA PFNs for a VFIO group.
- *
- * The caller needs to call vfio_group_get_external_user() or
- * vfio_group_get_external_user_from_dev() prior to calling this interface,
- * so as to prevent the VFIO group from disposal in the middle of the call.
- * But it can keep the reference to the VFIO group for several calls into
- * this interface.
- * After finishing using of the VFIO group, the caller needs to release the
- * VFIO group by calling vfio_group_put_external_user().
- *
- * @group [in]		: vfio group
- * @user_iova_pfn [in]	: array of user/guest IOVA PFNs to be unpinned.
- * @npage [in]		: count of elements in user_iova_pfn array.
- *			  This count should not be greater than
- *			  VFIO_PIN_PAGES_MAX_ENTRIES.
- * Return error or number of pages unpinned.
- */
-int vfio_group_unpin_pages(struct vfio_group *group,
-			   unsigned long *user_iova_pfn, int npage)
-{
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-	int ret;
-
-	if (!group || !user_iova_pfn || !npage)
-		return -EINVAL;
-
-	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
-		return -E2BIG;
-
-	container = group->container;
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->unpin_pages))
-		ret = driver->ops->unpin_pages(container->iommu_data,
-					       user_iova_pfn, npage);
-	else
-		ret = -ENOTTY;
-
-	return ret;
-}
-EXPORT_SYMBOL(vfio_group_unpin_pages);
-
-
 /*
  * This interface allows the CPUs to perform some sort of virtual DMA on
  * behalf of the device.
@@ -2300,24 +2167,6 @@ int vfio_unregister_notifier(struct vfio_device *dev,
 }
 EXPORT_SYMBOL(vfio_unregister_notifier);
 
-struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group)
-{
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-
-	if (!group)
-		return ERR_PTR(-EINVAL);
-
-	container = group->container;
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->group_iommu_domain))
-		return driver->ops->group_iommu_domain(container->iommu_data,
-						       group->iommu_group);
-
-	return ERR_PTR(-ENOTTY);
-}
-EXPORT_SYMBOL_GPL(vfio_group_iommu_domain);
-
 /*
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 91d46e532ca104..9a9981c2622896 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -140,8 +140,6 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  */
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
-extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
-								*dev);
 extern bool vfio_external_group_match_file(struct vfio_group *group,
 					   struct file *filep);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
@@ -154,18 +152,9 @@ extern int vfio_pin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 			  int npage, int prot, unsigned long *phys_pfn);
 extern int vfio_unpin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 			    int npage);
-
-extern int vfio_group_pin_pages(struct vfio_group *group,
-				unsigned long *user_iova_pfn, int npage,
-				int prot, unsigned long *phys_pfn);
-extern int vfio_group_unpin_pages(struct vfio_group *group,
-				  unsigned long *user_iova_pfn, int npage);
-
 extern int vfio_dma_rw(struct vfio_device *vdev, dma_addr_t user_iova,
 		       void *data, size_t len, bool write);
 
-extern struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group);
-
 /* each type has independent events */
 enum vfio_notify_type {
 	VFIO_IOMMU_NOTIFY = 0,
-- 
2.36.0

