Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1082F5E6BA4
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiIVTUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiIVTUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:20:37 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835F1E11FA
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:20:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XG/eQgjeYwb4PN0Kh7pA7MY7Bl87SQU+cjSabbCtFcipxpwvgUBjh2LgIX3merOsXG+w97JfJXLYqHFlVuQKp4XCemqVH8uuGgK6NZBvUtYPqygitY12cwnKVw9PkuZ0MfOCQkMilIyioGM2d3v60IxaxbtZFvUiTXV4ucoIs6KJ3onL4GA/y+vNCnuLy2LOThqAo9CC4CPJ/0TGwpvtFtfl+oCnrkgePf5VB4uc9ndrPymjPilcpBtNdIKPT51ILnW4gsTdr30ru3JQGi6I7cmESch1GdQr9Fz280GeRbcBw7cQXw1beeLx/PFqv57JB3mq22aix3J2AQKOO6gnjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owtCa0xepT8DPxSoLH9xS29k2K6bh8LCfGIXnCyQ8YE=;
 b=ZzXAQHF+cEtLWW7qlSAb2MAUobqyp79nDHIanMd9l6I7/thQAkMOJ1fx1sM9K95L3L9ORS2aOGuY45B1isBXgYnr2uS3GZC8OFcJus9pjxo1v/bc8AB2t61CfdRva6+fg8sniecrhk13/YGpAV9wVo0UpbkodvdSVE5Gr0srYeJG9fHCWtnVTV6NspXqsmZWZimmoNjvHyOW2yQoObyROAiylN0JcuswJAkOsiXOpJvDYc94C6DvbLLEe+alGPFcBaBTHGkUoGYnOldi0TZkr0U9noVDP9M+Noehnh6DybvvymnGa0SCeEWQARKqG6o0Ma6Fk7wRH9/NL+zTsFr9SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owtCa0xepT8DPxSoLH9xS29k2K6bh8LCfGIXnCyQ8YE=;
 b=STh19uhIuutrIW8xlAOA2FbcJTiG2HbEG9w+bIsUNpQkztWrmvSae/upS5sNdvKQytWPOeDNjXQ515Td9pwpib7rTdcr2ZDzV1RYEBmyATvHtLb8pbY1vBSBhNFBU5APPqWNXBxpQCcUvAMq/ADFb8jTHB0Qc+UXuExVZWHEK2RbAYb/jh/c7PbWJpnE22KNS4/ANxRq+TQZLW/wRGNhI5zq5xsZzRCj464SHHC3YyDdtBqDfjWTGxdtkDxXkPBDCljagLtVpLETNv48gJ9YW0yKSLiLlqdaGZ/j4/heQgDFlUr0+RDXEqEhro+zq9g3pYuqM7/9oV/UkFHOJoWJFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 19:20:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:20:28 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 6/8] vfio: Rename vfio_ioctl_check_extension()
Date:   Thu, 22 Sep 2022 16:20:24 -0300
Message-Id: <6-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: eec17d5c-75da-41e8-4ef3-08da9ccf8162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PoTpRpLqz/5MiJhecg5EtyoqLMJ8Z/dN5174boeopC1JFylWg0WYT8g8SnMs57SgKZId3ury0LF2glNGrvroLpne4+J95TCYVZ0bb3YEMt8OeeLDEiDkv97za8eDEXwGmc/4iGEe4eCSM+jEKj0CdHIn1+cf8cPP23p6HXmS6QA0rFY3lQY2EuU8Hb2F+RqP+UfY1jGKYMApLUM/Dz2Alk4J/059agu5hgVA/3uQi/YmNNenrwEU89A3xwXeDX/FtJFh/thmzTIGlx3T8N41hshi7XKhJheqGdIz3hpe1O9fLaqoMZKSzSEGcefNwPEt6J9RVGzU6XNrzOty60BTjVj4G3LWSWCFq37Vdfhq9PFMmseLFjeJA5oSMiTfxZyPPw6NuHC5io5JY5ozl8TR/cu9xSHmdmgHBHlwswHxnG1PvtAEEEICYScUj7fpihPHNcH2s7EpJjZfYZ3sajzx7wWi6jnHH4Cp8acogwU2/fviCz3EseiSzAN5Q+UKBJFwzGo+iSMYUGGSJibrKv9rh+q/lehLYLY2J+uQQqNW3yXHIEqXOM2k5HQ67+XNWoYChw2KM2rthug4gbEJU0Nyc/OesLAjSAa9dlJ5dWg0En2Lb2De/7++4zn/5zTshMFtqhtXqwj/u97CZqXrXeNLKEEYlujTzC2JBIuF15/9ZQUeEVH4NhWp7GxWL4zJUAmkv8ehFEjWUIcxlrfDhOd9Roj6ecMpAXRcm9fziqLW1v9yGwITG0eyfHOuZIMyo/iU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(6506007)(6666004)(26005)(6512007)(86362001)(4326008)(8676002)(66476007)(66556008)(38100700002)(110136005)(66946007)(41300700001)(36756003)(83380400001)(2616005)(6486002)(478600001)(2906002)(316002)(5660300002)(186003)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6qoZArp7w3OkLQhOX1d4cLDyeWGv1OWZdJ8mb5C7hA/NlAa9VbcghoED0MH4?=
 =?us-ascii?Q?hPNoyGVm2xuyzpFAzi0fVbu1KRyIok9L7a3s7plfOyFtnyWPKr5f/3aTTb/j?=
 =?us-ascii?Q?jDt8bGxrR0d3rUMokSuNUn4g9BJK4FQb/6GnQx0nF1rgkMWaVCTBQwkFfMgP?=
 =?us-ascii?Q?wd+RrsImQX2HlL8J0zEOQalgkI2MTYHo6uUd1hAoLkN93B/bc05FLaXRHJcv?=
 =?us-ascii?Q?qhZDzMovmt660CwlY4WnUqUnB5eiRcpGN8FuqSJZ1eimT29C72VlA2eizGKD?=
 =?us-ascii?Q?VhoDXM0388BRAOS8a4i2wcAiOeRO+NeeVIeMr2MMZDHYiK6J0k5eegfHIkUf?=
 =?us-ascii?Q?rd0pZHMRenrtYvpqTspMkdkilVrsfkB06hxIHjpCOBgbb9920Q8jQNTcRuoC?=
 =?us-ascii?Q?x4YwlViYUXuvcVm2eTDku03TikN7gS6U/ot9dA5Ayb9VjuAtQBMaHD6MiDix?=
 =?us-ascii?Q?RYEdJK2VZkYOPAF8dz16gA9Ibnpa4kG/GGmSgrpTljK6vEFFWhEvwLN00rO0?=
 =?us-ascii?Q?NXC5R7fm5Y58dBqlWuqcOkz+WM4imOgL93e2HRhL7chJ93nR79rXtB0ykfIk?=
 =?us-ascii?Q?tgSsB8DnCS88KWAt9ozDx1oa7pe70G9zEMus8d2PQmdnYAY45HZrC7WmLpS4?=
 =?us-ascii?Q?FoKmBFuB0IRGfR2blNt4u1UZa/INYcDVvhgjiah248Vto8Ce9O/4zxrnVcHx?=
 =?us-ascii?Q?ompsVG2ZH3r5ueCGvFmSC2WVll5GB8/cGBVAZA6ETbRmnZ+0V+XRqKdkBH5t?=
 =?us-ascii?Q?fNdnyjbeFLKAbNBtlf1uwtTklYtiHMjJ8wJmDeBcSHBafCyYO8YHDcx86OE0?=
 =?us-ascii?Q?xmUrXxeOxW0xm+wY40UbWeo184TnDm2d9Bf+CmirwAGgSjC5VeAOdpwRHjGA?=
 =?us-ascii?Q?9ah4F/ovUcs0AGWUGs/PtZcB8iyljH8WtcPqe2VuWPt+Y2EBy47af70CHIOi?=
 =?us-ascii?Q?Szvz2595K1EVzfdfEzPkPwP6xiiyqb2IpN6O/TLD2tS9qU6xc3W7PscMEG9g?=
 =?us-ascii?Q?0//YO1mtmWlGYFHsUUGbb3iQD2Yh36djb7vViBdjqmdKmGeHxhDpM3cAc0fa?=
 =?us-ascii?Q?PfwN9Z8e2baM6g/y8LhkdIyrXX5ZQ96hhvg/xSQG4CC47IvJCGJOI100bVI1?=
 =?us-ascii?Q?oDZ3n6AFDzyM0LT7/a4fefVYiza1KRrKjuJYJNgLL6lvcyZ9ZQr1hF0lPZaZ?=
 =?us-ascii?Q?eTMEhst9Xu33EK8yoUXg/Up1+CcbmtS3kOt9bgBV8JufxlfE2TEpti91x0lV?=
 =?us-ascii?Q?o6hRgiJvIAxdnD15RyveSvz1pophab4UherL2+jzXsM8803/7Rzy3dsS3vJc?=
 =?us-ascii?Q?1yVdJNRHe6FBhEMJgxKEEAN7hVwkwaqO0RwNpth6hSX4UylPDVKjIQMwSYfI?=
 =?us-ascii?Q?H5zgghCJbvG8owQzVaKD97nM9kxjn4mEoCU/ukyFvMrtbZ0KrLis0Eyp43HV?=
 =?us-ascii?Q?J9cHmOpQTo7NM/KAyyyptoGKGibvt/1H/c3EK3/TQGa3vrNPkvspOPj1N8Nq?=
 =?us-ascii?Q?4jZ7cEel4XWXRMrLReGh5L0aZN6eDgT/2WxbbwQPjXI/JjzfU4x1kmj3a7+z?=
 =?us-ascii?Q?cw4NtaTq/zLnuUHE5R8xHJ7YdD+9zeA8BviRwnJ7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec17d5c-75da-41e8-4ef3-08da9ccf8162
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:20:27.0619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zBYJBhrA4knnBPdL31+SQfI4daZSp6EDtqZmekBIcI7aQbOXWqoLml89dDNDWB4V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To vfio_container_ioctl_check_extension().

A following patch will turn this into a non-static function, make it clear
it is related to the container.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3cb52e9ab035a5..33e55e40c41698 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -813,8 +813,9 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 /*
  * VFIO base fd, /dev/vfio/vfio
  */
-static long vfio_ioctl_check_extension(struct vfio_container *container,
-				       unsigned long arg)
+static long
+vfio_container_ioctl_check_extension(struct vfio_container *container,
+				     unsigned long arg)
 {
 	struct vfio_iommu_driver *driver;
 	long ret = 0;
@@ -971,7 +972,7 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 		ret = VFIO_API_VERSION;
 		break;
 	case VFIO_CHECK_EXTENSION:
-		ret = vfio_ioctl_check_extension(container, arg);
+		ret = vfio_container_ioctl_check_extension(container, arg);
 		break;
 	case VFIO_SET_IOMMU:
 		ret = vfio_ioctl_set_iommu(container, arg);
@@ -2100,8 +2101,8 @@ bool vfio_file_enforced_coherent(struct file *file)
 
 	down_read(&group->group_rwsem);
 	if (group->container) {
-		ret = vfio_ioctl_check_extension(group->container,
-						 VFIO_DMA_CC_IOMMU);
+		ret = vfio_container_ioctl_check_extension(group->container,
+							   VFIO_DMA_CC_IOMMU);
 	} else {
 		/*
 		 * Since the coherency state is determined only once a container
-- 
2.37.3

