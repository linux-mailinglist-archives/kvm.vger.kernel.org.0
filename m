Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C704E639D
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 13:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiCXMsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 08:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346410AbiCXMsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 08:48:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DA8A9976
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 05:46:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEn9cvuD65yhPdNf0HGvVZ6g+Qo5eNIfgk43QLhqs968qA/Jywbz3QVgeacEzIjAT4EV0QcTmY4lN25TLLL9ZQo97TCqiW/xOAwbvKYmrBMbo4Q1ZGx9eKR1U7cWNKkVfBmIBEbZxvUnRQFg/FOtfer44MGTFYiKCopCTM2pDNiF5FXolgKzQN6rOkNxLR//6Z+doPiew02fgvDKhOd+QSru33tE7933BmBZE4JLJgiSjhEtIuXMw60gblzk+SX4C7UWkcr15NRF7gOdjOPvaf60pYGWdoVvlG7XtauULqr1OKCLZTzTg3sL1UV7xT/tREf0YmxjsrGd9YlU0Jw6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0vyq7u2dmz6kZektDZbXnT3mjHsc6nuDl/K8lRWWoI=;
 b=IaL56o6w9UxQRezPiZbhenLzUpcwMkFk+33ZX7d15pqL0XXXXR+Q+Ziw7tGIKWZJtPVWGC1E/Cna7ADbjBYx1kJ6NZfX+INgnTmze2tOEFtZNLvTvxq3Ll6Vg7yjPlJyqji5xPVU5Fx/1CnzEGa+GbwJr68mQJqoYN3ywLOm6uZUa9HqhiLIf8TcbWFS1e84X2BQDLevDLeM9ZV9+MSnrU9dpzn7MAxrqZsl+7E4Z8Or3pZBcyPKztBcqSH+vYsNlA0OoeG4tKESyEvibgXXF8YGhp23Q6UoLLObH3ZHArAyVtX/N+VdF/VIMv9p7KOdumiMyIx+hjpq4YFI0RdEJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0vyq7u2dmz6kZektDZbXnT3mjHsc6nuDl/K8lRWWoI=;
 b=VvHdOU7/HsNj1PZg/KuhsJpSfEUiHTknINjB1KZ1gKvztNs2s8V7TwRYrepAJ7KVsp/hJVE4lFT1JXb5PHY1gwgdXbOlSiv2PW7D/QKneswl5bde5gjzTsY2ri/uaQA4tO/7zZAcpvVqEurBBeE2escbZBo5kZeuTX3pFqCSXThb/3GxdTDf5ZYp2onhYcSiYQDBlviq996IGcxr/TT3GJcS6zKOFw3AfI/IZnGz1iZ8Cw95QWIvCVZA+UEUu4KJXZcTIts26EO/9FMm1K1kb3KAl+5RDjsHPbygwMnwNe/WnLcsdkEibKX8hJHhb2jPGjdJR5LNl/d2jFOrHobqAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB5704.namprd12.prod.outlook.com (2603:10b6:a03:9d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Thu, 24 Mar
 2022 12:46:36 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.019; Thu, 24 Mar 2022
 12:46:36 +0000
Date:   Thu, 24 Mar 2022 09:46:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 07/12] iommufd: Data structure to provide IOVA to PFN
 mapping
Message-ID: <20220324124635.GA1287230@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220322161544.54fd459d.alex.williamson@redhat.com>
 <20220323181532.GA1184709@nvidia.com>
 <BN9PR11MB5276D51A07EF91D19A78C6B08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276D51A07EF91D19A78C6B08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0042.namprd20.prod.outlook.com
 (2603:10b6:208:235::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ebcd9d0-b9cc-433c-a3ad-08da0d94553d
X-MS-TrafficTypeDiagnostic: BYAPR12MB5704:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB570446313CD71BD89F664A66C2199@BYAPR12MB5704.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a9q7JdX9uEmSM6F3V+N4WLOna8Q46xpxHxXbOxGdECweONusT0SJkHGHH/qww4A/fCKDUSdUGDuz3I9yKIhE0jctJoyJjNRXth+AXHWHMfCK6gw9LaGkiJIu6BeOQUpM+FJiwSwA69U/hKo6HYZ7xoOXX09nPcWvrwKI5v37hlCodzuvJE09e68SQ004/x0p45lmX+/FxwiRQhklNpa2dzjyj9VuQSz/G6WRIbyTWCZiB7fCIQH+nE9wWnIx1Xnu36pSBQbYg6lO6O6cvfSkcHwqzsBh43NUgGYkjwYd8BveLdaHr7CoDygwFM4T+fBZH5WYmD4ldYxOvYMmAH/NKMGwIFQw/Nl24yx79iSXE+zDxILtStwAaXqfR5wavzYXA1BI39mMSwLfRjWuLDETuw3shjxnqaQwJzAzAzYoiuXOZn5pgtmeDemSCrbpqxlWAEh2Ac+PQyflWPikHRoyCF6k/ELBgMbVWkA4tJ2qoXTJmP+DkQ0OXa4I/Kie/IvJDv1+1FgXbgRwffFLNho5ur3nzFJdYy3yxIgyufFQgsWg29u23uaxlbLyCqR7enwFYHYbmUPoDvsWVsZwMNRaXZrEU1ZfMow2VBj/EvdsKGx5rEWu44SjesBPGU99nQm+CUYQy2z45A1TGYW2/X2Phg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(8676002)(6486002)(26005)(66556008)(4326008)(36756003)(66476007)(83380400001)(66946007)(8936002)(38100700002)(7416002)(2616005)(5660300002)(316002)(6512007)(1076003)(6916009)(54906003)(33656002)(6506007)(2906002)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VW2nBxhMxWp4MHdsJTN2y/4iGNeFGP+Cofb/i14nfBIsugd6cqJ+f16gr4+6?=
 =?us-ascii?Q?CnIw0JR9zHTKzsFaTZSEAfC6IKpuBBCBvbePAERtiUukl/8PZx78b1EgGAue?=
 =?us-ascii?Q?kk3Krq+FjJqY4e7wHJobc4m4IXFHCdaqSJkyMP+Yns4Hn8QPy5Ue1bnL5dgN?=
 =?us-ascii?Q?Sl+0sX62FNREolF7CBXIBlebymgKeOrT2c/Em4xbz4zA5bIe3Ygp2x8tDGKc?=
 =?us-ascii?Q?zLDU5NQeKX1ovazeBJUzBmWD+mXMeHhiPmwtoKDOSZ2RplN4i7XEGLxmUS6Q?=
 =?us-ascii?Q?/NDS5LL5GuGVwxGH8l1YRin+EpjDyGYD5OlgfcOZ/I7elAuaRgiOTx5H8cNe?=
 =?us-ascii?Q?w4Z0GErT4wKFuRN+WMFGlLlTWcgobN0eMuKmbN9Qgrz7/GMV3fKCaxT/lXSU?=
 =?us-ascii?Q?OyqEMGGwLL2I5IcvastdXHRKRe+RIjcSF8cOW+j07MbC8z/pwNftBbubAZSm?=
 =?us-ascii?Q?eTFGJY5uqZ9xNh/SgRIIHNfbAN53AHRtMoF0UFaVyqKBK9aTeNqNt3g9fHnr?=
 =?us-ascii?Q?3XgGXdZoFVW/bRELCpAbzZ9RtcwXaShSNbqlGHr7EsRr5Ti+DIgr7hQ5lsrY?=
 =?us-ascii?Q?AWayJrEtRIHCAdhVB/rW+IOCaYoWTf2j30kxJELCS1fzVXs+KEvLG6lbXdHQ?=
 =?us-ascii?Q?UCaJ6XNhhTFA5yK6NIy1lCzfpKO6An21SkqLdDhQ2xSw28EeLKv4Ou9MqN1G?=
 =?us-ascii?Q?+teF8Ocrrru96hiX6aotQuNiEnBm7x8sIo/6W/2JXTwKGvcSVqX7bseuisjD?=
 =?us-ascii?Q?PNWBUui5QIsvPdy2VnRpEViUloyCULkuPWqlUKt08gCBP4TRUzYwgxsU3uvW?=
 =?us-ascii?Q?gm4AjBU5Puzc3iGQnRkhtnU6OF82D0ZZGuX0LvvtJkRF8OS31DDM03BxmHAw?=
 =?us-ascii?Q?LxvFpMFET718IO0ebsWBUiXcA5SmHpqU5sNDEfQooriSBN9SJO/fqqCj62Aa?=
 =?us-ascii?Q?wSawd1rZsUUhGcmxAfhfS5EoQb/rpEek1+EzI4XWlD7FnnEKrFhKEWl029B8?=
 =?us-ascii?Q?FHUf/LRB2DY96xFDezIKPujsoACkT7VVz8mijyhalvsQHJ00qOhbX4Jmyg25?=
 =?us-ascii?Q?ZT5ZWItrYkiCvmd/Tmb1V8Iil3Qrz+0g+/cMWCNml6UvMWxmNvjc7/lYl5YX?=
 =?us-ascii?Q?GgEktNc5EepNrxgdXgNqgMlAbdilCZ4D1THT9cO6hZQrKZov+L4g7YlnAvyb?=
 =?us-ascii?Q?AvW8cVJ7r+LHWiT9XmyvZ4MyRInR1shYL5Svp0bz3OKRYTynVzM7AWrQhqna?=
 =?us-ascii?Q?6sSgTBTbuExuJqK4v80Z5HCh82kCkMY6lgzo7omszM0DPYNJsy1atUYVFmko?=
 =?us-ascii?Q?/npc9RQTZHw1EfgcviOZqZLB4flwdylu660sxTbVzsA2xj7g0zg6hlTYpZPR?=
 =?us-ascii?Q?0B8132Rgr+PQ63mYusqs80klYHOrurc3WRYpQRpkPcDoS8hWWF8uV+PcSRB9?=
 =?us-ascii?Q?J4eQQ78qh1SIa8VvLWHRlmyJh0kZgUGQGS28CK98PZ4eKYEAR27oM5aRw9HU?=
 =?us-ascii?Q?jEo0tdTVvtWj4WCpM1Ary7WMckIPkut565XrbyAIx7pNH3qe40NT79ijwGuW?=
 =?us-ascii?Q?jpV6fpkGuOi7cCTdwFQy4C/pGL+EmUUOYBhsJr6Qv26ldVeyWhXnLWEgCaZI?=
 =?us-ascii?Q?GIliMOD+/+R+RoYfo2o9Zyk4y3nlwIVUXP78CYidEP5ALGnSYhgQkdzSxDcD?=
 =?us-ascii?Q?Un1AMVoJvCD2SzxKfgjkbsJ/Gtmv+PK+a+GnAlWLuke1Vrc7gQ3xDlw3cA/r?=
 =?us-ascii?Q?Ccz9YIqmyQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebcd9d0-b9cc-433c-a3ad-08da0d94553d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 12:46:36.5126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /02/Utx2kCvNSACBYs+JFh3qkxZw5zz1bhcqz0SpAML0Z71DH9wUs7hW/OU3gyOH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB5704
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 03:09:46AM +0000, Tian, Kevin wrote:
> +		/*
> +		 * Can't cross areas that are not aligned to the system page
> +		 * size with this API.
> +		 */
> +		if (cur_iova % PAGE_SIZE) {
> +			rc = -EINVAL;
> +			goto out_remove;
> +		}
> 
> Currently it's done after iopt_pages_add_user() but before cur_iova 
> is adjusted, which implies the last add_user() will not be reverted in
> case of failed check here.

Oh, yes that's right too..

The above is wrong even, it didn't get fixed when page_offset was
done.

So more like this:

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 1c08ae9b848fcf..9505f119df982e 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -23,7 +23,7 @@ static unsigned long iopt_area_iova_to_index(struct iopt_area *area,
 	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
 		WARN_ON(iova < iopt_area_iova(area) ||
 			iova > iopt_area_last_iova(area));
-	return (iova - (iopt_area_iova(area) & PAGE_MASK)) / PAGE_SIZE;
+	return (iova - (iopt_area_iova(area) - area->page_offset)) / PAGE_SIZE;
 }
 
 static struct iopt_area *iopt_find_exact_area(struct io_pagetable *iopt,
@@ -436,31 +436,45 @@ int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
 		unsigned long index;
 
 		/* Need contiguous areas in the access */
-		if (iopt_area_iova(area) < cur_iova || !area->pages) {
+		if (iopt_area_iova(area) > cur_iova || !area->pages) {
 			rc = -EINVAL;
 			goto out_remove;
 		}
 
 		index = iopt_area_iova_to_index(area, cur_iova);
 		last_index = iopt_area_iova_to_index(area, last);
+
+		/*
+		 * The API can only return aligned pages, so the starting point
+		 * must be at a page boundary.
+		 */
+		if ((cur_iova - (iopt_area_iova(area) - area->page_offset)) %
+		    PAGE_SIZE) {
+			rc = -EINVAL;
+			goto out_remove;
+		}
+
+		/*
+		 * and an interior ending point must be at a page boundary
+		 */
+		if (last != last_iova &&
+		    (iopt_area_last_iova(area) - cur_iova + 1) % PAGE_SIZE) {
+			rc = -EINVAL;
+			goto out_remove;
+		}
+
 		rc = iopt_pages_add_user(area->pages, index, last_index,
 					 out_pages, write);
 		if (rc)
 			goto out_remove;
 		if (last == last_iova)
 			break;
-		/*
-		 * Can't cross areas that are not aligned to the system page
-		 * size with this API.
-		 */
-		if (cur_iova % PAGE_SIZE) {
-			rc = -EINVAL;
-			goto out_remove;
-		}
 		cur_iova = last + 1;
 		out_pages += last_index - index;
 		atomic_inc(&area->num_users);
 	}
+	if (cur_iova != last_iova)
+		goto out_remove;
 
 	up_read(&iopt->iova_rwsem);
 	return 0;
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 5c47d706ed9449..a46e0f0ae82553 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1221,5 +1221,6 @@ TEST_F(vfio_compat_mock_domain, get_info)
 /* FIXME test VFIO_IOMMU_MAP_DMA */
 /* FIXME test VFIO_IOMMU_UNMAP_DMA */
 /* FIXME test 2k iova alignment */
+/* FIXME cover boundary cases for iopt_access_pages()  */
 
 TEST_HARNESS_MAIN
