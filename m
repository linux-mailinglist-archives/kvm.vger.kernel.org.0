Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2045B4F82CB
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344607AbiDGPZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344612AbiDGPZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:25:57 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2064.outbound.protection.outlook.com [40.107.101.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF4D217994
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:23:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXxzgTX/VnQmIHSdqFN2whLnyAd2/zVOET5Tv4NIMeGkcUNGfA+0ekaYf3c5WP7NqlWeKtnoQ0GlvQXnAPd4wlla3/5ctXWCLvgzdTC6maKjnRxKOztMJiX03H0uelUFeyRlOi6x93y8TMUnW9L+YFZtxxkqbuZH88iHTNU6yVNyDLQDfx8geA4GNA6A01KOQgTWKCQuKCHojEpwW+lAEizFAE5IzaLE6a/vdW+fY9b4dr0wmxD5+3/KIIBCn/u/+Dwu4c7tCwUvDoGjDUqn6Abex7b+g6WIK4K8AirYpsGW6vLJgH3psjJPSFX/ZXIvp3k/T/4t3rBH+gG/y1v2bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBfXtb0qKyKAC4Q4QQHeY6Ekv69FSJSiZz5PHSG6nwM=;
 b=YCWzWGWWp6wmBj2hRlFCLFBKDDHPkjqokkxHVMkTFConBSnYErjHTPH6gCBG8pZwq9n9sEwW/AEJBlo1ApemSabXzsFElAOXB6G4RyRtWangG4XkVCTFwZg3KafBxB4g/5Ox2T8l8bXE0GP9LdmtjwLertPGmtcSNeWwK//Kx5XuvdEHP27bZ1xnpVOvl4ZAiwOsX7KQ8tL9cCETdmYvGLiq69NDjLzyKhF5j2bvzXJo4PuNUlaNzmJlR+ylDkmKdbW4qVaIqpj03jUHaHKWip5tGfMrEzlFMafIFu2x2COQxt0lcy38Pf3Adg4W/3nhCdBmFxknt7PyedUHfBR0WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBfXtb0qKyKAC4Q4QQHeY6Ekv69FSJSiZz5PHSG6nwM=;
 b=JzH8q2MmeA6Vp+bYUA82/jdzzDJwl7vSo4vvi3jAE2n6yW48FH0/sYv2PtJKX1Q39Tdv3gHiWu8VOgD3xzfcby6NthgjclxF0Lva1AIosvt3k2FQXZhrYGgdZmZbDiouyArvWv4Sg+U63ceGSfZdoy4rLRSXKECJ0TJDdPDYiOJ/TXk79QlHHS+SuTUj7VX3fO7tP/YBCbs5dRptc+lkjd+esZ4aOqQDZ/Q//w7EniCeYk2WGsRmPeAxyJ0fEzA3eOHvIbuL2BWJwIGomag9nrXuq9lP27tE7Tax6nIWecZMBJ+IdXKa2MEy/Bjj/+oqTW741FxXsKjwUQR6ezwp4g==
Received: from MN2PR12MB4406.namprd12.prod.outlook.com (2603:10b6:208:268::23)
 by CY4PR12MB1590.namprd12.prod.outlook.com (2603:10b6:910:a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:23:52 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4406.namprd12.prod.outlook.com (2603:10b6:208:268::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:23:51 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:23:51 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 3/4] iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the cap flag for IOMMU_CACHE
Date:   Thu,  7 Apr 2022 12:23:46 -0300
Message-Id: <3-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:610:cc::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 429520b2-e40c-4557-4cfd-08da18aa9dd5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4406:EE_|CY4PR12MB1590:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4406543491910375B6B52F93C2E69@MN2PR12MB4406.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HU4WB26nUOygG7FVea7+krtchOqJBjYz09ZL++0o0W019/FIuGLg7CqgAfwoN+l7jEOdi8xEyKm7TMSHnVWvRJIk9mkdeu7YkN2T1V+pnoKNZPBMFTkQfa/DsD1k5jn1EVRQ064eJk9mDTUIRG4/0GndliKyE8tQsaGc4o6JlA+BHgUQ7VLer2olp45lMgYsmINOuoSTBYfYkUD4YbeAJsq7cahqRpptfcLtsduT1eIMIBAGl4h/3k2l8GJXxZjoyw1v/sEpVf+oTSlTIbPwSyOmFkUzu5WGz1R0dHRUxRNtvYBC/lSh3hNi9Rep1YvtV77w9IeGoKiLMwiNsrTaGd9+c78jxY5RYFR8t6bQc8PzYaDljvLAxgcU0zXsRYnn3tQkecP4x0K5mc8Esta2omrUdPy5VV3ip8sOmkSiX/Nu/kv/Y0ecd1a+WOyNf823cmnQ+pwBcYeL6xgTJfyrgiICpCJ2Fng+TQ5jv3CkQ4RQfUa/6PR3oJDZfyB92qY9aBUuXeZsikDc2sAieToeo9eDTtXItDiE5uuzNB5/Et0LGdcJByU4qlPMAT3v3GBQnFfcf4iqB4iq2hYruFGxUlf93C2qu3R27b0lS7pizDg1Y5g+9EbPn7e2hRifs3fLgdZ4aEdGGwAC6Jd5lAqY7HrXt5aYBdKYcdAFwTvlbAZ6p9qleXkrwot8dJnfE6rN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4406.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(6512007)(66476007)(4326008)(8676002)(66946007)(66556008)(6486002)(186003)(2906002)(6666004)(86362001)(6506007)(5660300002)(7416002)(508600001)(8936002)(2616005)(36756003)(110136005)(83380400001)(316002)(38100700002)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MTh8Iko22jkIopCVEee2ULvZ41uTeXNRmrFKJvPdMj4m8bHe8q5xqs0PMkVc?=
 =?us-ascii?Q?byEJJdkXHIZNws29jqPaVDM/oAdRjRoPoJdrTeEb2lNmrTB5k1Eq7Gy68Ymu?=
 =?us-ascii?Q?dWtqvDE/XSRkpOjsGu3G3Anx+iwqWacAqxEzSuDv1YuJk5ujBFc16+P5fIb5?=
 =?us-ascii?Q?r2ThWMPCVBGxLbWrp93aIGxDdKm9v5q6U9mWd0xLUV94wDXJjRPzQhEtP9QB?=
 =?us-ascii?Q?jIctbrKtWuNfcl4XlUTF3WFSxgCmrjan/3bbNNGm2KbgMqsL5z4572nt106A?=
 =?us-ascii?Q?4MfxYmmHnsqkFxTOzZ5SK6AabBiMJTcZk+2O6fnn/D0c87GjKy2tvD1dyyKk?=
 =?us-ascii?Q?t+B2rjN+PGWFSZoWmV+7giZT7HJJskLul7cOX8otv/wYGqKbvgtu5mRWupDD?=
 =?us-ascii?Q?hb/VM+66v0LfF6SPXtSeW4B/wNmBC8s6ScdE7jO2Dw5BeUkolMwipRtwXBad?=
 =?us-ascii?Q?x8h0PBIYorvtvuCS58zZAhUWQWB5l3GndYidWb9fs4P5Phw7+WwpqDaVY6U0?=
 =?us-ascii?Q?zix7+MxHEE4wR0huvyWF54P1g7LelNobfwU3cusOrinEtmvC6+sw3JFuiPSl?=
 =?us-ascii?Q?7+vChVFxHB0bEixr9a5ML39tv0qVi5EO8unHLGJ3pvMLxiGp4AMZ0mmNge5T?=
 =?us-ascii?Q?jYc9TwK4F7hnSmTCRECcs3F9V9ZS1uK2Fe0l5KTuQKOLMSmJ0oMotoyzG08I?=
 =?us-ascii?Q?cZwhZs+AD87OVhSXqgLAak6M8oZOOmmqE/HhMYwk2MUrStz8MSvKqBvKgNq4?=
 =?us-ascii?Q?Zbc3y3kgYFMnwkZNn+aP4ymP4UJIEP+LPmezksFW5ZSaKR/VROn/cBV1LPU3?=
 =?us-ascii?Q?KisWOCK54P2kU/pUsXUlDYVzc//L84iESZ+hjhZU0OEAQ2EpqqDAEFd2v6J0?=
 =?us-ascii?Q?imZQBTpINHRyGQceuTgHakdTrSJ8qi5do8SDhKwlsyyPHWJIY1L3uBPcOw0Y?=
 =?us-ascii?Q?Z91+XF8MQp6t8zz3YXwhgfSIlMY/eqPxBFAUOV/4+8laHdoTxFxYAAKd6MJ2?=
 =?us-ascii?Q?6klk1EsLfflFqlQtX2JhPzoNW5/UNHyvk5Djai30RNyd7tCcUMeufvplWEkL?=
 =?us-ascii?Q?h59bLuUPPyRnBTkojcADqcjeQo3shbNvtmarV6GcRtm4++V3OGXeL06LFXCe?=
 =?us-ascii?Q?wSbp6D9mC2AeGc9AaI8cyjiZdrAKgIu/Aa7iGqDRM5e9r8pZj4rtgN2Cxv8X?=
 =?us-ascii?Q?/pQdTV2mEKAvxZWjnKqeyy19LsRHyGrm20d0WxUJ6HMLEQ8ht3eXfls1tEht?=
 =?us-ascii?Q?50qyuG/JILnPOoWUetaDsv6UoEpsppO1xGdV8oWZFrhbuOim0SYUOkbRZWc+?=
 =?us-ascii?Q?BE7fCxxr8C54wIUV/aFLQqhmmIl9Q11RjufLHFoMTvAOY1ii/TJvRG4sl/o8?=
 =?us-ascii?Q?rB3rpnLfgOvnqHPPU4KDAiGkYIn6PXT3slMrYLdGIdRWUwAhuXwQG7Trirqn?=
 =?us-ascii?Q?Up9kKNAZzI3wqCY6HvZkHGp4UOlzODWDhTXSGS+eqN0N/Voupjeb6M2b6ZeA?=
 =?us-ascii?Q?pqyY/OovalEyAv/10Kgi0S9mSxz7qwa5q/q5VKZ74k0K+z/ppptbg1zCNifq?=
 =?us-ascii?Q?m7mUWl4KvkKgvGqzttVi/OpCJwqT1xq0h0R9NOK6iExzoO2DrfGvauPFi+Xd?=
 =?us-ascii?Q?5YxlG6k9nLkoLs/CvNAQR8blgNnzu/xO+3CQO9zYmsWMUP/2jJZIpHaxgJ+P?=
 =?us-ascii?Q?72hK/KsLU5Phozk2/9DM3XkRWDORKV8S6LBsYtPQh80gQfdCGMuU5/uGF7ZJ?=
 =?us-ascii?Q?eQNQqQcAuw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429520b2-e40c-4557-4cfd-08da18aa9dd5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:23:49.8636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUQGIMNCfW14ISXAIsam+1pxvFG6OkgypvLo1xWGHpdxWDf1g3V2N4LXMucKT05r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1590
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While the comment was correct that this flag was intended to convey the
block no-snoop support in the IOMMU, it has become widely implemented and
used to mean the IOMMU supports IOMMU_CACHE as a map flag. Only the Intel
driver was different.

Now that the Intel driver is using enforce_cache_coherency() update the
comment to make it clear that IOMMU_CAP_CACHE_COHERENCY is only about
IOMMU_CACHE.  Fix the Intel driver to return true since IOMMU_CACHE always
works.

The two places that test this flag, usnic and vdpa, are both assigning
userspace pages to a driver controlled iommu_domain and require
IOMMU_CACHE behavior as they offer no way for userspace to synchronize
caches.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 2 +-
 include/linux/iommu.h       | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 8f3674e997df06..14ba185175e9ec 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4556,7 +4556,7 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 static bool intel_iommu_capable(enum iommu_cap cap)
 {
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
-		return domain_update_iommu_snooping(NULL);
+		return true;
 	if (cap == IOMMU_CAP_INTR_REMAP)
 		return irq_remapping_enabled == 1;
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index fe4f24c469c373..fd58f7adc52796 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -103,8 +103,7 @@ static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
 }
 
 enum iommu_cap {
-	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
-					   transactions */
+	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU_CACHE is supported */
 	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
 	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
 };
-- 
2.35.1

