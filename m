Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C84513D49
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352164AbiD1VSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352159AbiD1VSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:18:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F0480220
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:14:44 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJNZ7F015535;
        Thu, 28 Apr 2022 21:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6L+x/ixhtAuKHsky57sR9gRqvlDbipRnaxnBJSyFZ54=;
 b=0x/AyyvoGMlbsGigV4Mf6Bzb5jzIv1L1twxaUVhH7H+pI/pTmv2qMQ9uf/MSojiFabYW
 41mFPI4Tgwj+oX2VPmBGtuRpk0Vdg0nRKEYeX11TQT2wjDe9xxBTzVSZ/FrX4FZPUBhG
 7zrLvP8y4PWSkEoKDiCe8FrETxfWUkmFZ/Mur91KlahZ25g2HEqgeXy0fe5u56iBUByw
 pWY1OHSGqYw2uIa2mnRBSKWJp+pOCVh3+0/tQ6gEMMjC2SdQAPEHFgXsK/4niWXfp4of
 OOA2vdcfaDdHLMHotsZ584LlzBPvRE7Uk9qlcpGun3LrtoDarLq1SFjH2VVg0R47K+HF bQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw632-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5CI0028545;
        Thu, 28 Apr 2022 21:14:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79qy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhtdQzhg7hWvt7I4mvmi99TiHOk2tKfqUC1ioZcYhWz/fajbXFWu3klKpWSkQ8AoYLc2Ce6xwX6Vep8NWaC+t2afSU6oMMY+vNoJ9W+0kEChLufo1TkNx+2hpyLeYYD37eOcIMZCHrvp3+cog0i/E0aCoVzKymNvwcDlYDrGHjVylttH7UeRND8a6tba5oR21+vR49Zi0+doI8MFKQ1aCHBrjNHwuqPPY+9DIyGHJNjeNhIi+1/PQONSBv+FXoMVUVK1/GJSX4lEvppDxIHqeOyVAK/ezptL8QrtewLo3n+Ct8dPwPWZuEdUaCccWYJWw3IROQ8V134Y/5xu09AF0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6L+x/ixhtAuKHsky57sR9gRqvlDbipRnaxnBJSyFZ54=;
 b=ZM9O1Wh/FAjIdsVInWxBu2msaiKkn5BsF3sQPQWWUN+3sHceBKmxGgDn1Hwcb0s2bZ3RrWmBCT0WgMTYMjJURrvRniefJpXh7spsqsXn7JFKr1rhl5KjPsoEOAusH9jLcIHqUP+S0hXa261719vsq75oDUTgUJzxPzuh6cyE+N/3j0Nr0k05t5UT7unefXAh86mouCxE3Q1tggeL4tmn/Om7TytfGCAd1dxsZ25RXv7sMMHUWxrRHNbmWEi3jJ8TZoiH11YSNWQzum+G1gJhRGivfLyriuTR6JL5Br+Sfpmf7nFWJslPy8brHRCAaF022wV+MiJmDbYPmLpo48+nnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6L+x/ixhtAuKHsky57sR9gRqvlDbipRnaxnBJSyFZ54=;
 b=wAEXSQ0a9TG5MH531MYEogK1K1EMvWbLIbty7G2Y3d2k/aLdzf1gxCrWncJb4poM5WtQ6VV0URL0k7lcxIS+6IqnRDi16GR6U/KcUKDJz6SOWmkm2o9tWoVU+gCyzT/Y9Pv2fKHOmUbdVYbnDJ9b6Ny27RAj+ps+PUGQ7sj1jD8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5289.namprd10.prod.outlook.com (2603:10b6:610:d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 21:14:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:17 +0000
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
Subject: [PATCH RFC 02/10] amd-iommu: Access/Dirty bit support
Date:   Thu, 28 Apr 2022 22:13:43 +0100
Message-Id: <20220428211351.3897-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbcfeb57-9b36-44f8-66b8-08da295c0cf0
X-MS-TrafficTypeDiagnostic: CH0PR10MB5289:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB528979E2B17C9F2E0F805D7DBBFD9@CH0PR10MB5289.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lz8xT1qSqiE9kZ3Nj8TdKi+cAGMiR3gr/WBUiLDBcB9qZbVHWtzJz+g+K5BD/3wu6icxVHMCFfNj1Z//w1//oDDLZzYPfSnzZ2d9Vecrsv71Q0iv03JUYEJgeH98NIThS9CraHvK21kFOeQNpBNxdlmWtpMGvdvyOcdVvpl7XBnfXY2tqARU9Da9aKoFb1CPdlHMLuM3TMUoW2gW/CqSOX9a+LEwK+61HG7rjHAzEZOtoYk4D0iRHuCXHu691AKMQed8TLGVLZC5PvDAH88cSJe6MRNCFxMbHizB/JBPr/meG1PFMEJeEIc7JL3zHiQur+WUo4O0/ADVnmbVqCIkroy2f4PJRkUU523PRSa71XOMJg7QMM0NPnl+2Z2wLbYPTSEnv5xoqHXZ/uTmbGyx4ZGInKQxDVUbOHuudSdNnXgM87k3+CH+8ue2l9w0w2BzCEe4K654YcjrsSn5n+uXEdwaq0wXRYsptD3KEWgrNGlN5cFzom2/lnM+YlPg5jgodQrunhvc4VODNHKyl2SEF41g+eKxZd2TtB+fjNPQvEWhtspvWlHDdzYnqMB3+ZSBzWOODG7aRQ2iqKB2aJAg/4YiZRrDl+2j04XlGZVO0a1N9vHxB0AjpHTwdG7T5N0J8zNgM0QQ0LuKu9GoK32OZgzN3h7iPsMPo5bNMte2qXdksX7QUmIkjZqBhFPG3SVrw31ijTPFE82P2CnuihFsDfG2HhJZKQ/mxx0XBE/Zypc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(54906003)(186003)(1076003)(38350700002)(38100700002)(5660300002)(2616005)(7416002)(103116003)(26005)(316002)(6916009)(36756003)(66946007)(8676002)(66476007)(4326008)(66556008)(8936002)(52116002)(86362001)(6512007)(2906002)(6486002)(508600001)(83380400001)(6506007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KVLE7IEPGnkkzdJnvxbAoOGq2F93zzelvhz7b1XdA3PThLzwhCQ1kRmUv572?=
 =?us-ascii?Q?SEzx+/tvG3HMYvq/JXaqMbQGI9AC1pb5dMkYRHluZSBIG3pqv/W44omxzzaw?=
 =?us-ascii?Q?O+oWFv/cgyBtE7/2sF++zEP6eMVNSoe119L6HxUiWjRN1XJAvz0Lhtd0DcSI?=
 =?us-ascii?Q?Q1tvu2WB8jx9E5YjmEQDsQZxWzKRGAC/BE3qp1GDpdQZjjUYV33Z8FzhrO4k?=
 =?us-ascii?Q?6vC88EBU8Vvzcxy3AbBo3deGh3vGGhglZBzrx5DIwJ2T+WFBZv2xQX0xWWZY?=
 =?us-ascii?Q?1Hdvwex+5t8oqQRxcMXFl115T5K3ZbdyJyckT66shC5r0L/A+LmimBijcloS?=
 =?us-ascii?Q?/gCWHec4rtKiL4/l4qrUvIskQcTMDeF5t/cAOay+mteE26iEi4W88frPRoFl?=
 =?us-ascii?Q?FSsjye4KNrIIVpQnjyzzFoWudLtJQeI1iZf9qvjky/7CX6DpraZpCdo+yAdA?=
 =?us-ascii?Q?h3ds6GSiWCBCggECTBSu0otxhXDf8Eh1rxzeRytd9Ga9bUvbqYHvJsDhRtcV?=
 =?us-ascii?Q?TAU4hSQnqziWPF8Lm2maSNdxTKhzq57V8+77LBKlbVTmf5c013L+XtqEAoOW?=
 =?us-ascii?Q?hgIwFw/gD/vqeTYad2lOm0fMFSfmGGp1XjMKmtRKkEnrTTIkp6ooKdapzb4B?=
 =?us-ascii?Q?a57KoJVBziwInl2aNLarFM4EDE7NrJmGdKaWKVyNU19pUqAcGSqZjlUUYony?=
 =?us-ascii?Q?HJ5CqVk7Vp8UOjYxc0Cik0qRPDQ4r7rVipJCvzqYll4mJrhXMfAqNtZdk501?=
 =?us-ascii?Q?Q5yGIuXmTjYrL9ijh+KWwA1rsMe5LsIcP8OZKcmKWk8dC6y8eGcFV+bnpme0?=
 =?us-ascii?Q?D93MaWvXI8spHS2rL313ga0rz4mTo0yLlFQAWka7jrdQFiGt3THF3Mlouv22?=
 =?us-ascii?Q?dRmnYJPXi8gFrHD+tBglWgc5uUWHsdAFicKABsK5KHB4yVJQe65ocFr7Z9eS?=
 =?us-ascii?Q?AdTM/PG8LHJut3RHHhaZjs3EDlmpg5cKtIgnBJ6Wuoh17ON52aVR9R1/8Oad?=
 =?us-ascii?Q?rcYkocPkQct65r7vZYbYQj9IXV7Ske8GudcW8Ga4riilwacAdP7pY2dlb1jM?=
 =?us-ascii?Q?rxj8Dt42MzhBqTrDNVNvDyhJ6QWPSlSFDzzF974wNUw0BAj7SStxcjewdGqY?=
 =?us-ascii?Q?GfkNwHGprUof2O/JMAm8mYzIB0nXd+aW9owlnqZafrA9/3rnBaxxTc7e0FG+?=
 =?us-ascii?Q?og6DcXqH72ToAA/YaGWGXhAFtjtD8tmLag0awQNOgdZx64hFxZoePzBQD+Vc?=
 =?us-ascii?Q?4auH+vqSVUSFaaBPkBSnD5UHG2qhKlk7aSO16YuQHuF999ZBV8I1hHLGLWE7?=
 =?us-ascii?Q?qNf9e73lU/Zy/JZcVrvkNFNh9BLw80Auz+dpjJ9O0Obxb0kpkjri+VqQHXuh?=
 =?us-ascii?Q?5UKxmWkJfl7mqfSZ4y+Mcv/Z40a4677YfgIVHXxcMO53R48m2fQKByrBvuKx?=
 =?us-ascii?Q?kbiNb9+ADQlYSkhxV9SqybNGpNGgwmBDgBr/e/Mwvqk8jwdfwb2KAHz0Sk6I?=
 =?us-ascii?Q?EbbgD0KtLmxtHdA/ovSo0npvLKNawUOTalL+QLG8aOohmVW2+T+iIhs844de?=
 =?us-ascii?Q?kR01qibavEWazyA+v6uhC5sQgslUIpfTQR3xE7aYiXcGRc7X2XWpziDawN70?=
 =?us-ascii?Q?XCYriCRZxYHD6c8UOTOSCdpy6Fc+l3P404/JrCeYV9snGIuqlUSYDJ4lgLDQ?=
 =?us-ascii?Q?u+1xuVf1nFSNi7dEUNYIaUBmAhkfOth6COsm/z6GEulOOtukO/da1u0DUmz0?=
 =?us-ascii?Q?1UKy6dHLpQRqgJNrexviF5H2U4CZlSw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbcfeb57-9b36-44f8-66b8-08da295c0cf0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:17.2467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQ0e0jNUabVGwaeJXEazUZGE3PvC2IiX/2WAXw0GBF/9h1Nc2XACW72VqluCMY08VLOov9lr42nna8FgO3kYiv2Fg1S25OkNkZA7WCvfzxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: NX8haWPZHlupofFFMAfE9qmEEynNw8Ok
X-Proofpoint-GUID: NX8haWPZHlupofFFMAfE9qmEEynNw8Ok
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU advertises Access/Dirty bits if the extended feature
register reports it. Relevant AMD IOMMU SDM ref[0]
"1.3.8 Enhanced Support for Access and Dirty Bits"

To enable it we set the DTE flag in bits 7 and 8 to enable
access, or access+dirty. With that, the IOMMU starts
marking the D and A flags on every Memory Request or ATS
translation request.  Relevant AMD IOMMU SDM ref [0],
"Table 7. Device Table Entry (DTE) Field Definitions"
particularly the entry "HAD". The cached DTE information
is then used on amdvi_had_update on both when we do an IO
page walk, or when we found an IOTLB entry for it.

To actually toggle on and off it's relatively simple as it's setting
2 bits on DTE and flush the device DTE cache. The information
is then cleared and set again on the next device context
cached or IOVA.

Worthwhile sections from AMD IOMMU SDM:

"2.2.3.1 Host Access Support"
"2.2.3.2 Host Dirty Support"

For details on how IOMMU hardware updates the dirty bit see,
and expects from its consequent clearing by CPU:

"2.2.7.4 Updating Accessed and Dirty Bits in the Guest Address Tables"
"2.2.7.5 Clearing Accessed and Dirty Bits"

This is useful to help prototypization of IOMMU dirty tracking,
particularly the IOMMUFD and VFIO sides.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 hw/i386/amd_iommu.c  | 52 ++++++++++++++++++++++++++++++++++++++++++++
 hw/i386/amd_iommu.h  | 11 ++++++++--
 hw/i386/trace-events |  2 ++
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index 25b5c3be70ea..7f48a2601579 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -24,6 +24,7 @@
 #include "hw/i386/pc.h"
 #include "hw/pci/msi.h"
 #include "hw/pci/pci_bus.h"
+#include "hw/qdev-properties.h"
 #include "migration/vmstate.h"
 #include "amd_iommu.h"
 #include "qapi/error.h"
@@ -901,6 +902,48 @@ static inline uint64_t amdvi_get_pte_entry(AMDVIState *s, uint64_t pte_addr,
     return pte;
 }
 
+static inline int amdvi_set_pte_entry(AMDVIState *s, uint64_t pte_addr,
+                                      uint16_t devid, uint64_t pte)
+{
+    if (dma_memory_write(&address_space_memory, pte_addr, &pte, sizeof(pte),
+                         MEMTXATTRS_UNSPECIFIED)) {
+        trace_amdvi_get_pte_hwerror(pte_addr);
+        amdvi_log_pagetab_error(s, devid, pte_addr, 0);
+        return -EINVAL;
+    }
+    return 0;
+}
+
+/*
+ * Checks if A/D bits need to be updated.
+ * It can only be called when PTE permissions have been
+ * validated against he transaction-requested ones.
+ */
+static bool amdvi_had_update(AMDVIAddressSpace *as, uint64_t dte,
+                             uint64_t *pte, unsigned perms)
+{
+    bool is_write = perms & AMDVI_PERM_WRITE;
+    bool dirty, access;
+
+    dirty = access = false;
+
+    if (is_write && (dte & AMDVI_DEV_HADEN) &&
+        !(*pte & AMDVI_DEV_PERM_DIRTY)) {
+        *pte |= AMDVI_DEV_PERM_DIRTY;
+        trace_amdvi_hd_update(*pte);
+        dirty = true;
+    }
+
+    if ((!is_write | dirty) && (dte & AMDVI_DEV_HAEN) &&
+        !(*pte & AMDVI_DEV_PERM_ACCESS)) {
+        *pte |= AMDVI_DEV_PERM_ACCESS;
+        trace_amdvi_ha_update(*pte);
+        access = true;
+    }
+
+    return dirty || access;
+}
+
 static void amdvi_page_walk(AMDVIAddressSpace *as, uint64_t *dte,
                             IOMMUTLBEntry *ret, unsigned perms,
                             hwaddr addr, uint64_t *iotlb_pte,
@@ -948,6 +991,11 @@ static void amdvi_page_walk(AMDVIAddressSpace *as, uint64_t *dte,
             page_mask = pte_get_page_mask(oldlevel);
         }
 
+        if (amdvi_had_update(as, dte[0], &pte, perms)) {
+            amdvi_set_pte_entry(as->iommu_state, pte_addr, as->devfn,
+                                cpu_to_le64(pte));
+        }
+
         /* get access permissions from pte */
         ret->iova = addr & page_mask;
         ret->translated_addr = (pte & AMDVI_DEV_PT_ROOT_MASK) & page_mask;
@@ -977,6 +1025,10 @@ static void amdvi_do_translate(AMDVIAddressSpace *as, hwaddr addr,
     if (iotlb_entry) {
         trace_amdvi_iotlb_hit(PCI_BUS_NUM(devid), PCI_SLOT(devid),
                 PCI_FUNC(devid), addr, iotlb_entry->translated_addr);
+        if (amdvi_had_update(as, iotlb_entry->dte_flags,
+                             &iotlb_entry->pte, iotlb_entry->perms))
+            amdvi_set_pte_entry(as->iommu_state, iotlb_entry->pte_addr,
+                                as->devfn, cpu_to_le64(iotlb_entry->pte));
         ret->iova = addr & ~iotlb_entry->page_mask;
         ret->translated_addr = iotlb_entry->translated_addr;
         ret->addr_mask = iotlb_entry->page_mask;
diff --git a/hw/i386/amd_iommu.h b/hw/i386/amd_iommu.h
index 79d38a3e4184..b794596aa07d 100644
--- a/hw/i386/amd_iommu.h
+++ b/hw/i386/amd_iommu.h
@@ -135,6 +135,10 @@
 #define AMDVI_DEV_PERM_SHIFT              61
 #define AMDVI_DEV_PERM_READ               (1ULL << 61)
 #define AMDVI_DEV_PERM_WRITE              (1ULL << 62)
+#define AMDVI_DEV_PERM_ACCESS             (1ULL << 5)
+#define AMDVI_DEV_PERM_DIRTY              (1ULL << 6)
+#define AMDVI_DEV_HADEN                   (3ULL << 7)
+#define AMDVI_DEV_HAEN                    (1ULL << 7)
 
 /* Device table entry bits 64:127 */
 #define AMDVI_DEV_DOMID_ID_MASK          ((1ULL << 16) - 1)
@@ -159,9 +163,11 @@
 #define AMDVI_FEATURE_GA                  (1ULL << 7) /* guest VAPIC support */
 #define AMDVI_FEATURE_HE                  (1ULL << 8) /* hardware error regs */
 #define AMDVI_FEATURE_PC                  (1ULL << 9) /* Perf counters       */
+#define AMDVI_FEATURE_HD                  (1ULL << 52) /* Host Dirty support */
+#define AMDVI_FEATURE_HA                  (1ULL << 49) /* Host Access        */
 
 /* reserved DTE bits */
-#define AMDVI_DTE_LOWER_QUAD_RESERVED  0x80300000000000fc
+#define AMDVI_DTE_LOWER_QUAD_RESERVED  0x803000000000006c
 #define AMDVI_DTE_MIDDLE_QUAD_RESERVED 0x0000000000000100
 #define AMDVI_DTE_UPPER_QUAD_RESERVED  0x08f0000000000000
 
@@ -176,7 +182,8 @@
 /* extended feature support */
 #define AMDVI_EXT_FEATURES (AMDVI_FEATURE_PREFETCH | AMDVI_FEATURE_PPR | \
         AMDVI_FEATURE_IA | AMDVI_FEATURE_GT | AMDVI_FEATURE_HE | \
-        AMDVI_GATS_MODE | AMDVI_HATS_MODE | AMDVI_FEATURE_GA)
+        AMDVI_GATS_MODE | AMDVI_HATS_MODE | AMDVI_FEATURE_GA | \
+        AMDVI_FEATURE_HD | AMDVI_FEATURE_HA)
 
 /* capabilities header */
 #define AMDVI_CAPAB_FEATURES (AMDVI_CAPAB_FLAT_EXT | \
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index e49814dd642d..eb5f075873cd 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -107,6 +107,8 @@ amdvi_ir_intctl(uint8_t val) "int_ctl 0x%"PRIx8
 amdvi_ir_target_abort(const char *str) "%s"
 amdvi_ir_delivery_mode(const char *str) "%s"
 amdvi_ir_irte_ga_val(uint64_t hi, uint64_t lo) "hi 0x%"PRIx64" lo 0x%"PRIx64
+amdvi_ha_update(uint64_t pte) "pte 0x%"PRIx64
+amdvi_hd_update(uint64_t pte) "pte 0x%"PRIx64
 
 # vmport.c
 vmport_register(unsigned char command, void *func, void *opaque) "command: 0x%02x func: %p opaque: %p"
-- 
2.17.2

