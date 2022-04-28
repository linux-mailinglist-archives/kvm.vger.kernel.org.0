Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF1513D4F
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352209AbiD1VSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352188AbiD1VS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:18:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD8939E
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:15:13 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJeCYB011361;
        Thu, 28 Apr 2022 21:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uLQ3pNyCklPet7NMJWxmx5V7hT41k/68i3XrBGB8yQI=;
 b=vDwv9sz7CjI8Bx6tpp/alrhiiQQz2n3gJk/ps+ZiAJ1Fy83pSIwvQDF3F/9Ny/i3/zQD
 PUEvACSFlhGwSjfsrEmLsQsGpyShD64cJ/17twbrcpz7qt8ToXssdEm5QGtS3lP5q/i/
 2BLZnquYIXuXV7tZBPMhc5mkv8kxVjCsVEYyuvgdYZWwUMWMm84R/Z4zJBspcJ1DI5Ib
 dA4hjvnEDw9GiQL/+YuRV7ilmRO7DK19RNQSTYvnTR5jZXaiALGsyzm2xvVD0vOSESjb
 WosNwxVwpYV6kr88NE3xmBlYLuZr4QrPgQPAM/bvrHWP6Pm2SwkwsrelGZPRU5pwc8fg 4w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4nbag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6cfF028671;
        Thu, 28 Apr 2022 21:14:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ypebx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EH4KbKjF9KtnX5bjAEZgmkkZVVc+Ulz/YMcn643Gk8D++WZWJxfZANhJPnGGxX++6NQJSp0ApnixTl+M0A37wevHrr2MduQCvoLxevxQ7pPr2u/KqBL20wrSiGZiEplH7+1Ygc83K1qlHdcGKurW4McYwZJISo8+QugtJxT6SqyG4mLvgmhtkLAcS6C0A5DU3uj9SzeToCOF2iFMd7Z+sG+SeE1a82bmfe6C+RcDBM4RHFWUQ7xPfD29CxZjZVSZTh6Pl9SAW6Qe0bhUK8J2kaCT22qeoXoNCe9JkzNVey6+/QjDe9Foc+VMr/XUfzsg0XrYiLiKznlXHf8q5GHFzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLQ3pNyCklPet7NMJWxmx5V7hT41k/68i3XrBGB8yQI=;
 b=RFDLnXeLF2JzyqKwL7cLgi9QCGxlXKUviHWJKWYSRcnaGd4oow161v7+mRaUHGLP9Sd5Yg2ABIsL0ASGRZ3h0q2nWNZ0yapGME80jRXp99Zllm28ywEOmD8gJDd8iVAFRfhHC1RZCKwT4NQXFfovBYIARr9RELwHW3SoKe69t0pDgZiKguu2VpCWEtj0sigXgrFeMKAQVmCkO7+6My/S5nLxHe0jT+lXGm0p+iM6Q2gcZJPhy6J5TnLtqTlON5DHLjfoqXWdo7Uz9rFhZVwvqE+5VyewyJq0KKcZ1eNGPCX8H+RE6Bfe5zxm5nV0FyQwk8R8tBO+cgUOM/+cjLlaAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLQ3pNyCklPet7NMJWxmx5V7hT41k/68i3XrBGB8yQI=;
 b=x5yb0uo9bGg2vUaxT/m1db0TasKzr5LbcW40Bps6rzknV2OSkppIA8LBJXSL3OnBdYjfIGLultMxboWc+0j8HynyeKzD0ACOPAVa080dpYf7MJJCK4Rz14FoFKIGBfnXzTJlNbdwM366+iS7+/dtv2EoxvA1C+cf/eVhlHICo58=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5289.namprd10.prod.outlook.com (2603:10b6:610:d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 21:14:54 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:54 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>, kvm@vger.kernel.org
Subject: [PATCH RFC 10/10] hw/vfio: Add nr of dirty pages to tracepoints
Date:   Thu, 28 Apr 2022 22:13:51 +0100
Message-Id: <20220428211351.3897-11-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6060bcd-ceaa-4e87-f9f1-08da295c239d
X-MS-TrafficTypeDiagnostic: CH0PR10MB5289:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5289CD82B8F2C94D96DEAEC8BBFD9@CH0PR10MB5289.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9dH8wcFjuNCNffm5kVkShr2F4Z5wQnG7dZWa/KmKnv4bG3hGFUPUgU41OEiQrVuucSRhATWdB+5dKwiD5t7xYcxRZx52rrjjNUk65A+aZtsOBVE225V9QaUdsZeF+DGtG5BaGd6e/B/ffnEbwCLBK/mkKqS0qGtSIZF+O28OHfrDm9QeoOrF6Xzdda1tuxsS7ftAzvr5GN3YP9tll7Z9bfqxUCtGS5vjbNiWY4PtmiG1hcLXm3/B2LDp9AMOB9RLcxRpE+z6cL6HPTAwQqBcpoRxW/0LaFFQn4rnXZTQK8obGCQFzfEPk8HrQpxGcYoKnKqqJyHNKGRxPcOhOxbPOVjhs1AzWFSmqEKRDLgB1CEAu5K4HZRE41Zd60l2hnUDMO3f0XUtTnSn4FqMWAg6N2xUCY5sMJ8SbH8OXdRXRu/GuhLjzg1S+FvfGffTaPNeEqp2g1chtLLcPWnDA8PtCqHsIi/SFEiuYi2KM7kiH2IaN/4sCblOJbLgdTEmmmxVTRhla27V6M9PJBZfnwYrRogxdP/8zOoc6bllg1x4Vu6jNlADvz5+gXflbdKcfth+LAcbatm2QkX8wFwElFxUcskJPYPelG/bK9iEEUTLf28Y1izS0odwqGz0YYCEB9/oba1nsUGtJSMWJKioJ4vfOWbwGtKtixVvluvcVjsfD3TImzZMtPY6jM847yHmOrGNkonawhOKqk05hr6rt+Tuyeznt9phvY6z3Dhtg7M9nU8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(54906003)(186003)(1076003)(38350700002)(38100700002)(5660300002)(2616005)(7416002)(103116003)(26005)(316002)(6916009)(36756003)(66946007)(8676002)(66476007)(4326008)(66556008)(8936002)(52116002)(86362001)(6512007)(2906002)(6486002)(508600001)(83380400001)(6506007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1FTa4BeeUv2/FdTO10R/a6pqaLmW0gP0mDZ0SNEzJiv+MlriOKuTS54ZdI4h?=
 =?us-ascii?Q?zwqgKKmhRE0M2kv1WLaDNfVo3i/mrnLEv3mPXLDKqrUk41BGOeBeCf5+UP3w?=
 =?us-ascii?Q?m6DAk8U10LWReYViUr7fNeJdYD5Vd8bvMW9Ph3PhLfRp6dTt/IgVOproPfkn?=
 =?us-ascii?Q?9aAI51LchHq45OwcKe1d2oDvzXwYjEeI3Xc5T82iNjEULbDMqb/YBiXVLPQP?=
 =?us-ascii?Q?n9QSBLRZOEmGoZLfGGhYwdYwNAlvz7umtXD7vx8ZJZZh0iSyhn4TuD1kdG0b?=
 =?us-ascii?Q?OS/YmcKDOHkN0Jt21+RX8C7tPLCox7v7VmeTDGCe0Rb0y9vdnU5zayBjhdHH?=
 =?us-ascii?Q?rA0FykgjR892KF5rQjjksz+45iXzC0T7vXP0C0XnDFumyIh7ro7M/rehmuV9?=
 =?us-ascii?Q?m/0XQwVwvO2gElKv5PYvdyeL1qh7qXKjbFLg2rsfP7FeGM7NiMlGrImssJkr?=
 =?us-ascii?Q?FkbA+RVX6Zhdce+wKZT0WI8Tr7pL+gn+HBdwuy1DPY3z2/AqvoPv8/rduLyN?=
 =?us-ascii?Q?fcRmHz4Sjzna0ylm/PqkNlRitKpGD+M2vCaFlV5bs3l9jyZlMipvnhfi0MY2?=
 =?us-ascii?Q?10c3pQ2Tatcb3GNBc0+ztKRTC/BgnlhzmPm6ar4TZ8j8j8Y7xHsfccS3aMYR?=
 =?us-ascii?Q?fFwsqXeRayf101/ZqpbkQbpzYIdc2j5hWwtbSvuCEwV8SHDFl22ORIomACG1?=
 =?us-ascii?Q?aQG5arA6NtLPZwZyc1GNQ1GmExXfERzqxiiAnSc+/k0UWomcygkzxhDw4ax1?=
 =?us-ascii?Q?1namOpyYY0gdDRg3avJtaMFftOHjATVGSEekBwIhZP7hy+etIcNitlRnXjy1?=
 =?us-ascii?Q?pQ7vmmRAsnaNFdo4wi8mx2xQiQwiFBPzJu/FHJth4Krmpv9A1S2YT5smkrWr?=
 =?us-ascii?Q?a078jX6+g0R+ig/UhYes4zj6VTbL8RNjjuF6dhjvahHNe0dTyEI4UZRojafL?=
 =?us-ascii?Q?nqCvjK4/dnGmnNKbokrgyRUEr7u+rvdt7tw1+2Rs+YCVH2ZzeOakFnkLWd5a?=
 =?us-ascii?Q?gJdivGYp7ZvcwpqxQMp2Vc56vLNKp94uBU9p2wk+vIRH91qbSRUzj1Wk5aWr?=
 =?us-ascii?Q?twcSIthOZcuhj7iAWFfhfH5JJGaGxDn2xnViLBK9pc8VdXlfy3usFkluTGSE?=
 =?us-ascii?Q?aN3N3DaeJUfCB0s8fKEldnhe+VtKFmg0ae2rT6VhOl68KY5jhMmWB3uYpK8A?=
 =?us-ascii?Q?nw9DiXcYLH/Av/ux9ZbznYpNCreiBhWMcrtUaUlAuFq+d1KhYz60wUMv+lPP?=
 =?us-ascii?Q?pazUqjVjgM83Q1dlmEsmcH/irW08XFHB5H0QxXdocm29rWcTaNksnvqq8WN3?=
 =?us-ascii?Q?Dxx+DQqsg3fSZ/hmTyY2OTfAgL2k8+t5AvbE2g6jzSQCIwiKwvsUfg5Bwq1Q?=
 =?us-ascii?Q?l/GbTnHoyUu5D/0MmFZdYCTBxouG6hq5a7P6gI5C+VL9cmK1Aq+RmMWWpA2t?=
 =?us-ascii?Q?NGKGgkLDRcD0HXfS1v6Y+OTG0t3gVtfimU8hTFx8XbUERKWI0GWuh/vO2JcE?=
 =?us-ascii?Q?9ePBm6sm/kqGrULCVYlL54yVVkIjEmat1hnOWA9JjjHqJxAOMR4ZyJxD1mvm?=
 =?us-ascii?Q?xnWcQBmZTP6r/VvaTIl22NuQCoF8374BKggDbeevV1mWIblou0uv09wo7RTx?=
 =?us-ascii?Q?WhhN1CVH6aS4Zd45spvVOQuncqPhz4uOwjP4SIhhGIGVtisp752Tk7ibvVtW?=
 =?us-ascii?Q?xz7kuX3TIGuhNeBelMkfr02pq6zM8dxROh2mWu45j1OVi6aQF0NDyr6Hn6n/?=
 =?us-ascii?Q?lvEg9W19IEVv6xwl4xPgxpFqwAB4GFA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6060bcd-ceaa-4e87-f9f1-08da295c239d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:54.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqdFJXXcfimt8uvEtBvwBZAPw/KhOJ/6EzK5E+8bkrw3jxrP+qeLUBSsS3dXaFaOmu6cKP5O5H/GTooZ4m05FRyHWrFIP2qs9eZskABhl9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: 1v2Bot937BZeU0lKtC6tyEDrGWiC92O2
X-Proofpoint-ORIG-GUID: 1v2Bot937BZeU0lKtC6tyEDrGWiC92O2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print the number of dirty pages after calling
cpu_physical_memory_set_lebitmap() on the vfio_get_dirty_bitmap
tracepoint. Additionally, print the number of dirty pages to
capture the unmap case under a new tracepoint called
vfio_set_dirty_pages.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 hw/vfio/container.c  | 12 +++++++++---
 hw/vfio/iommufd.c    | 10 ++++++----
 hw/vfio/trace-events |  3 ++-
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index fff8319c0036..b17d3499d9a1 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -146,6 +146,7 @@ static int vfio_dma_unmap_bitmap(VFIOLegacyContainer *container,
     struct vfio_iommu_type1_dma_unmap *unmap;
     struct vfio_bitmap *bitmap;
     uint64_t pages = REAL_HOST_PAGE_ALIGN(size) / qemu_real_host_page_size;
+    uint64_t dirty;
     int ret;
 
     unmap = g_malloc0(sizeof(*unmap) + sizeof(*bitmap));
@@ -181,8 +182,11 @@ static int vfio_dma_unmap_bitmap(VFIOLegacyContainer *container,
 
     ret = ioctl(container->fd, VFIO_IOMMU_UNMAP_DMA, unmap);
     if (!ret) {
+        dirty = total_dirty_pages;
         cpu_physical_memory_set_dirty_lebitmap((unsigned long *)bitmap->data,
                 iotlb->translated_addr, pages);
+        trace_vfio_set_dirty_pages(container->fd, iova, size,
+                                   total_dirty_pages - dirty);
     } else {
         error_report("VFIO_UNMAP_DMA with DIRTY_BITMAP : %m");
     }
@@ -312,7 +316,7 @@ static int vfio_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iova,
                                                   VFIOLegacyContainer, obj);
     struct vfio_iommu_type1_dirty_bitmap *dbitmap;
     struct vfio_iommu_type1_dirty_bitmap_get *range;
-    uint64_t pages;
+    uint64_t pages, dirty;
     int ret;
 
     if (!memory_global_dirty_devices()) {
@@ -351,11 +355,13 @@ static int vfio_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iova,
         goto err_out;
     }
 
+
+    dirty = total_dirty_pages;
     cpu_physical_memory_set_dirty_lebitmap((unsigned long *)range->bitmap.data,
                                             ram_addr, pages);
-
     trace_vfio_get_dirty_bitmap(container->fd, range->iova, range->size,
-                                range->bitmap.size, ram_addr);
+                                range->bitmap.size, ram_addr,
+                                total_dirty_pages - dirty);
 err_out:
     g_free(range->bitmap.data);
     g_free(dbitmap);
diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
index 4686cc713aac..461030bb7135 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -77,7 +77,7 @@ static int iommufd_copy(VFIOContainer *src, VFIOContainer *dst,
 static int iommufd_unmap_bitmap(int iommufd, int ioas_id, hwaddr iova,
                                 ram_addr_t size, ram_addr_t translated)
 {
-    unsigned long *data, pgsize, bitmap_size, pages;
+    unsigned long *data, pgsize, bitmap_size, pages, dirty;
     int ret;
 
     pgsize = qemu_real_host_page_size;
@@ -95,9 +95,10 @@ static int iommufd_unmap_bitmap(int iommufd, int ioas_id, hwaddr iova,
         goto err_out;
     }
 
+    dirty = total_dirty_pages;
     cpu_physical_memory_set_dirty_lebitmap(data, translated, pages);
 
-    trace_vfio_get_dirty_bitmap(iommufd, iova, size, bitmap_size, translated);
+    trace_vfio_set_dirty_pages(iommufd, iova, size, total_dirty_pages - dirty);
 
 err_out:
     g_free(data);
@@ -148,7 +149,7 @@ static int iommufd_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iova,
                                                    VFIOIOMMUFDContainer, obj);
     int ret;
     VFIOIOASHwpt *hwpt;
-    unsigned long *data, page_size, bitmap_size, pages;
+    unsigned long *data, page_size, bitmap_size, pages, dirty;
 
     if (!memory_global_dirty_devices()) {
         return 0;
@@ -176,10 +177,11 @@ static int iommufd_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iova,
         }
     }
 
+    dirty = total_dirty_pages;
     cpu_physical_memory_set_dirty_lebitmap(data, ram_addr, pages);
 
     trace_vfio_get_dirty_bitmap(container->iommufd, iova, size, bitmap_size,
-                                ram_addr);
+                                ram_addr, total_dirty_pages - dirty);
 
 err_out:
     g_free(data);
diff --git a/hw/vfio/trace-events b/hw/vfio/trace-events
index 51f04b0b80b8..c8d6348469aa 100644
--- a/hw/vfio/trace-events
+++ b/hw/vfio/trace-events
@@ -163,7 +163,8 @@ vfio_load_device_config_state(const char *name) " (%s)"
 vfio_load_state(const char *name, uint64_t data) " (%s) data 0x%"PRIx64
 vfio_load_state_device_data(const char *name, uint64_t data_offset, uint64_t data_size) " (%s) Offset 0x%"PRIx64" size 0x%"PRIx64
 vfio_load_cleanup(const char *name) " (%s)"
-vfio_get_dirty_bitmap(int fd, uint64_t iova, uint64_t size, uint64_t bitmap_size, uint64_t start) "container fd=%d, iova=0x%"PRIx64" size= 0x%"PRIx64" bitmap_size=0x%"PRIx64" start=0x%"PRIx64
+vfio_get_dirty_bitmap(int fd, uint64_t iova, uint64_t size, uint64_t bitmap_size, uint64_t start, uint64_t dirty) "container fd=%d, iova=0x%"PRIx64" size= 0x%"PRIx64" bitmap_size=0x%"PRIx64" start=0x%"PRIx64" dirty=%"PRIu64
+vfio_set_dirty_pages(int fd, uint64_t iova, uint64_t size, uint64_t nr_pages) "container fd=%d, iova=0x%"PRIx64" size=0x%"PRIx64" nr_pages=%"PRIu64
 vfio_iommu_map_dirty_notify(uint64_t iova_start, uint64_t iova_end) "iommu dirty @ 0x%"PRIx64" - 0x%"PRIx64
 
 #iommufd.c
-- 
2.17.2

