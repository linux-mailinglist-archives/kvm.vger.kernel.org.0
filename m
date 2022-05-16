Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25A552956A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349417AbiEPXlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350456AbiEPXl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:41:27 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEA818B3C
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:41:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h71AnmH09ES3cDfDnpdypN5XHzEpZrxkroQXD3LLQfoW+nZJFc5d3IS4mpenWgdizD2hjW6bs3ZwTNi05g3o2crgvE8EuEDVEEWliZ+14eBHO/tFrfUo3sSLb7QYW/lE3Gi0pIuheo0EQgBS2oSynUCSfM0wVsWtG5w2FQdeD/8aunVv5BXKmT8go+lfDfE542wTHPRcEh7ZA2BlkbWTWrBPbSIZlZWwARIk0HoAodTvEUWZ/SuCJkDvZZmpfz+tBBw/j/fH2B9wACYWS/SosfuKrvXTtysE6kPNZtmVUKwCbvd44D4Slz+QizWfFZ3wcL1uPy+KWSC0WFOt/F+Phg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ex9MM2eZei7PX8w8dZSV8v9zW9DYpr915X/gkIcGxtg=;
 b=Z2ZQHfFl31rj3Rjn5LqUOrfFEL+1BMScgK0LqaaOV54r9wkWkTHvJ3InCy5A0n5HrWVIe8ayYUF9uErbCCjjXJW3qP149PwkPJII9VfcYpOf+qvcbDoqJNCLzqoIgCvXTjf1D/iHwWCCWjLewu0ozMn4o6pmYHYMgrWc7R1GU4Ezgt5jpMmSfTXDVUnahRw6rOCVOoBlqcHoRFANVfE5/mLbVPKbl6lgsgVpraqR7FhiQhBpvtQjWPxTjz2pjPKVft2iAXN8UXHBJma4lWO3lBoqWugeReJAhcQjqgtHaAW3zHQRP9+GrUPdmz9OjwerXIt9FqYfmuiuqthHD/Pczg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex9MM2eZei7PX8w8dZSV8v9zW9DYpr915X/gkIcGxtg=;
 b=h0BKL7xEeErbw4TnQdyfWqwPwzAG922wsf5HQBeiDwpvjXumnQT451BouPd907DiRJIF9Lgl8GjbAHJN+KPMlHGTotn9KTxcWCHZ1gPWqe66XyoUdkhUjFenDWnQJYCL2Uq+76yo51aVUj/UzjwNvGUtVf3+0N1O5qjyOzTOAL/dw2mQXtRcyaZ2F5pOeof7KxsTM9txPZBY/WDKSgPyjpCWqFfuZIa6y0aqRkO2NxyX6XzmVkew8jfJAFI1LDvSuFcOPvAW+Q1ELwfqW5gh02rvTqcK1DYoSAhu8A4FdvdDPav4gDP0T04kdmrIK5UgfOeAlnVDMH5zuzuX6nYAXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3319.namprd12.prod.outlook.com (2603:10b6:a03:dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 23:41:24 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:41:24 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v2 2/6] vfio: Change struct vfio_group::opened from an atomic to bool
Date:   Mon, 16 May 2022 20:41:18 -0300
Message-Id: <2-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0242.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c15a721-e356-44ed-7100-08da3795960d
X-MS-TrafficTypeDiagnostic: BYAPR12MB3319:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3319798917A9A7E90B66389BC2CF9@BYAPR12MB3319.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o8yF2Y26iL83DlWE71NyFKKEz49wRrfgKwa6iGnNJYxNeEcvbG+HRihJ7noB3O9C3FCeL7ZruHITVyrDsGTxNGDYrbIAicYQ63JOftluYzwjrRF5/cZf+1EcgQuc6VrCNXKIaKS96yNR4riLR5+jx/Ndvx0iAgnSPkX0ejQgHRBGzcIdAOUcDO+V2K6KGU3MQx1jV1ooL1n+6ncqKED4RsuLfskQwmrPVOdCOBU85JhzuAkHHbsQ39T6RM6KP0oz9dC3m7O8UcJsi6rKQQYFtr4NXCan/UDVgnzXVAtp56U0+ibgsQ0WpY7yczeXx3Wa+OtZdyHsyThFmNdd001JwztjOdNIMualiJfbE8LwKOEwEpqd0BFU+f7tkJtGhMVAMKgajjNmGAU38wmnt243YQurPj/mU7wG3c2gBcc8eyIFRv+Z5L1zdD1d7NWVOGstQkq40Am+gts1es6doOHxVTkuq8XJxnDMGpmitFBZRDTb9YcioLKpZRJNuqpTZVEuDf0dHHS2vPbk1qbZ7l/vpNJ6Ow27zFd7Gw6/jo0UE6HKh9BFhav24uhPk4jH+cLXfFxcLhKumgzf+Bi4h0kc8hBg5SjHElFparFBBIz2C4tnUIJIM1YE+a+35lMO3YU9uMSVjYo8ZQrhiBNHBY8O1UrBfnIgPENf03sZ0BCo3QeuQzyc7W7EO5CZ787j7ljKFWstxN0GBkG6CJI9P8MP/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66946007)(66556008)(8936002)(4326008)(8676002)(66476007)(86362001)(508600001)(6486002)(186003)(26005)(6506007)(36756003)(2616005)(107886003)(2906002)(54906003)(6666004)(38100700002)(83380400001)(6512007)(110136005)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KRUMTuJpcLZVGusrHWXD2/MlcT4Ofki+vCfQkyG1UOrOdWTRDPyuUAOcg0MD?=
 =?us-ascii?Q?hmW4ov5PQbLV3LviZjFvYarOel6ua2/0jCbYgI2hMH9Oxr6t/bgnGunuiJIf?=
 =?us-ascii?Q?suJUe4t0wUAZ98HfRUi0rSntWPR0EBCDmg9LFojfQBrsP398RQO9SOGPqB7q?=
 =?us-ascii?Q?uP4fM+ALkWpTDbmrcXs1z9a9+A4yFL5NAsQKIrEDnGGNr7+oqkgKyajZlad+?=
 =?us-ascii?Q?fSFx5SXqVCaqLMASI3YCE1B+YkuMxg+eUkPLtEdg2EkFIIwfzBrqcCi+8PMZ?=
 =?us-ascii?Q?IucjlfFifAywzTctolmduYFRB4Tlvzx2a8n/pJsX61vIrkVrLtyczbiJmQ1J?=
 =?us-ascii?Q?JV3lzNuWUXqWKaPRwXZKyvtnYxK62F7D16hkHYug3gUkl3r1q001nOB8IbHj?=
 =?us-ascii?Q?v1CJQF3pBYLMFT06LhYSkvlEAeSAYdwqg9QIFL+mxQWRl9eY0E0Wua/7w3+a?=
 =?us-ascii?Q?70a5ctFc1/ayh5ExVl+Jso5YS7kGjYTe9rwnTiT2IQc5C5Nodh0GikR/r2Ox?=
 =?us-ascii?Q?JEt96kzhShRg/CcukHuYiwziQNRqu5Oy4KDRo2v9fOk1f/KHphqVdKtNErbm?=
 =?us-ascii?Q?p3knFzRNbsPNiPgoftpEE4u48ij/ZRa2m29e9SgTdHubH++xemHXMbe0Hf2X?=
 =?us-ascii?Q?i9sVUhOOBiTOhlEy45D3HWVIuKQ1ulfNsTsTVhxMNPyhS75v8hKCHZ2k9pY2?=
 =?us-ascii?Q?N6zahB+MOzVdh2pltNeICmRAlrb8cx44fbFLrn+q3iPJt3fTqbTui0w9j6iQ?=
 =?us-ascii?Q?2ofCWsRblIcXDcnL4FreqAtoeKG3rL1aAvenEbPC6M5XtmSoaAideuARjTYm?=
 =?us-ascii?Q?aXBuitmulV+h2G6w/7TcXSMhFC1VyhcMZw0RhMxmF2WbwD4t9y+TVoI3znik?=
 =?us-ascii?Q?pszgYvycqs33XNjbtirY0zrdXYVBS+tWbw25WHWfsNw9x77hYyWw8bTtNONR?=
 =?us-ascii?Q?rcmbxJYBmxT8gAK7BQxuGRZwWxbe7znI2T6qO/VvdDi3SdldWf8+4UVJKmDY?=
 =?us-ascii?Q?etWM0bgXoFPH1MAoUIZJ+8bYzJR0oISZAcBhnT5+IP0LQkaMUlDyyy/vIskB?=
 =?us-ascii?Q?cFRpNgag5OQpr8KJuzf18kOvA+Gvm38cXCz//hyyTpnQl6kyKnogOjVRScNm?=
 =?us-ascii?Q?V1fjM44wvK7gt32RazSecdvvIIvcFxTG1GagDWU7lgSu8GbJohROi2g3TgiA?=
 =?us-ascii?Q?Y8H9ROM67pITbZQ0RLOgD6h91JAU7mkCWv/dyc6tI0mDyqj8iFUOua9Uchfp?=
 =?us-ascii?Q?iplxdxCZf7mV2P4woBcw0u8pS3P38JklQsk0zxTGOFGvjuGrSda4NxAzcnHI?=
 =?us-ascii?Q?yl6BvzA1bBZKV181csvGMpQXkJhSrjauSr3wv+5qJ0DA+QkrK8qe2fUb1GXm?=
 =?us-ascii?Q?Di2gH1r6VpOIxM1d9U8VEQnaf80RXaqJ0IeHodpf+XFXwDXxSGSJ14+XpMEo?=
 =?us-ascii?Q?mf51jSBS8JSTHaf1Sij6cmmQtMAg9l+LLPPV9FM1GBTaXOkGNRH0ufH1WYhK?=
 =?us-ascii?Q?zLDxxeFeQ9AAC2XqZKz6oX13U71JSgvGg/axQpnI2diz5PEFwNJHEuB5tDRv?=
 =?us-ascii?Q?4OWqGQfJZAg5q0N9R1sFf/EhTZNNGxSkMiMqNOe77Ncvexb9bNs0e5FidiL/?=
 =?us-ascii?Q?Q5gynP8ZCRW+umdJYMTHnM/ZIQJXkYMBkGOYc0gwDsf4/YDtyof0X9oqRibt?=
 =?us-ascii?Q?oK76qJPkmxa+482p9FzQpa21SJprwwMs3v19b07pkCA4VCD9ZdWijWM4KuV3?=
 =?us-ascii?Q?QvyktLpj/w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c15a721-e356-44ed-7100-08da3795960d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:41:23.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRHZsS4P1WVtCrzjxnMPWv5eB+uYE7xt4/3KkYMlIy/muPc67LZ6hMwOH6SfNrm7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3319
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is not a performance path, just use the group_rwsem to protect the
value.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 46 ++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4261eeec9e73c6..12d4b3efd4639e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -73,7 +73,7 @@ struct vfio_group {
 	struct mutex			device_lock;
 	struct list_head		vfio_next;
 	struct list_head		container_next;
-	atomic_t			opened;
+	bool				opened;
 	enum vfio_group_type		type;
 	unsigned int			dev_counter;
 	struct rw_semaphore		group_rwsem;
@@ -1213,30 +1213,30 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_group *group =
 		container_of(inode->i_cdev, struct vfio_group, cdev);
-	int opened;
+	int ret;
 
-	/* users can be zero if this races with vfio_group_put() */
-	if (!refcount_inc_not_zero(&group->users))
-		return -ENODEV;
+	down_write(&group->group_rwsem);
 
-	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
-		vfio_group_put(group);
-		return -EPERM;
+	/* users can be zero if this races with vfio_group_put() */
+	if (!refcount_inc_not_zero(&group->users)) {
+		ret = -ENODEV;
+		goto err_unlock;
 	}
 
-	/* Do we need multiple instances of the group open?  Seems not. */
-	opened = atomic_cmpxchg(&group->opened, 0, 1);
-	if (opened) {
-		vfio_group_put(group);
-		return -EBUSY;
+	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
+		ret = -EPERM;
+		goto err_put;
 	}
 
-	/* Is something still in use from a previous open? */
-	if (group->container) {
-		atomic_dec(&group->opened);
-		vfio_group_put(group);
-		return -EBUSY;
+	/*
+	 * Do we need multiple instances of the group open?  Seems not.
+	 * Is something still in use from a previous open?
+	 */
+	if (group->opened || group->container) {
+		ret = -EBUSY;
+		goto err_put;
 	}
+	group->opened = true;
 
 	/* Warn if previous user didn't cleanup and re-init to drop them */
 	if (WARN_ON(group->notifier.head))
@@ -1244,7 +1244,13 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 
 	filep->private_data = group;
 
+	up_write(&group->group_rwsem);
 	return 0;
+err_put:
+	vfio_group_put(group);
+err_unlock:
+	up_write(&group->group_rwsem);
+	return ret;
 }
 
 static int vfio_group_fops_release(struct inode *inode, struct file *filep)
@@ -1255,7 +1261,9 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 
 	vfio_group_try_dissolve_container(group);
 
-	atomic_dec(&group->opened);
+	down_write(&group->group_rwsem);
+	group->opened = false;
+	up_write(&group->group_rwsem);
 
 	vfio_group_put(group);
 
-- 
2.36.0

