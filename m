Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFE5513D50
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352199AbiD1VSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352191AbiD1VS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:18:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D725D13CE7
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:15:07 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJQIuC011396;
        Thu, 28 Apr 2022 21:14:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZKZqly/G7fQLwRqYKlVrLmaDOezKg4pluWDfPOLVfcA=;
 b=ruLYfRdKSZjNh48MPSc7I1qOYuS0pr0v/L5TN1BLtBzHZVxRIcmtdQJMIXjJkUZ6LV7Q
 Yatsrl7fSBW/E6DqAqyv/2wreh8G645V452W4QQy58PeFtl5tjic+GHNWTZnMakfj/b4
 O3qhd0Ho6sjwwo5D9u25G/ZCVrlTtaid6qITNwLrkvvxENPgt+cvXGtt3qhrEgvGgzZZ
 T+coWWpepJlFjSwxo0SeoyWbWcZolbNFMeQnA9ATzCUdcgvrEkckEaZHgnrnogFj8NjN
 ecNIf4LDDd9ACJ1BrkTXy4wcBjUctPzddhFzGXcwmiP4RvSa78jHHMeh6qYrE3+G1/YK mg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4nba6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6cKC028689;
        Thu, 28 Apr 2022 21:14:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ypebvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njR537Kan5OTlw5X7QYJl/qz7l8MedUXNs9joZVPbvHTWtyGhMLKG18Kj+4K1N3Hv5ALfcAjtYhBQ+4+m2gEM+1851RtkyKce/00BLpR/4QkMHRVDlZCXX7z1AZO+FpsK0XCsRtZsqI3pRDXDFj1vn293dum+R9iLfmT2jMoakMVvxwhXNq7vzO/aPX86pvA0UrSNMsLN3MxP8fNBhhZw/flWMh0KD603EQXa2nOMveq+4sbhmFFGE9A3gZuWPHVVBLM91S2EVa7zBPHKxoGPsMfUyHuppOlAd9uz1T7jC9HGkQzbt1vd652TxtpElaLGL8y/Bbkc9yzPg6D1Cn3cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKZqly/G7fQLwRqYKlVrLmaDOezKg4pluWDfPOLVfcA=;
 b=VTLp39k0xmRjIdDOijWz4H9Q4n7zC0bomSDjG4h4XmrH+fkgjJGaVl3GaRPIlUre5g6xwe1Ct4VfcEDUtFrwk1zTofn+2EitaeB7uSEFEQFpOHLiveX4b33ktBRQ3nhSL+owhfONXdRtYYSs5CbP1xsG359QhqDVDemr5O73+mbgsr6AGO++NSvhvudlgx2UQRm5FETcR5jJFtk3E8hv70D6iOFv6EQNWLM3/PHY+H7A/zrzYYTimGHIh9Og1z/nbh25u1pVkXlhZ7bah1fi8Eb/3Lx7rXjZ/CyzorJ57iTvwcrs7oCPTsa9Gs8FDhLZopCqCeTPOifOJzLSgJetqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKZqly/G7fQLwRqYKlVrLmaDOezKg4pluWDfPOLVfcA=;
 b=jjOHm+ZBgPQghA+RcpyPB8AySFWamTyUhi3HJwAR8BByw48toDpyWSBgc860aiTuZl0n/P/DGhbff1POOxjEiQ9RE88tjE1EN82D+jqQCqj8BAm1Isl0Av0/bcdhKycRoeTNlrOKxmM4cyS3z/TEiaWGPMqoueU7oH88vKBjfas=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5289.namprd10.prod.outlook.com (2603:10b6:610:d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 21:14:46 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:45 +0000
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
Subject: [PATCH RFC 08/10] vfio/iommufd: Add IOAS_UNMAP_DIRTY support
Date:   Thu, 28 Apr 2022 22:13:49 +0100
Message-Id: <20220428211351.3897-9-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba2e3aa6-ab0f-46a7-7cee-08da295c1e3d
X-MS-TrafficTypeDiagnostic: CH0PR10MB5289:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5289A624D92A7FB58DFD0141BBFD9@CH0PR10MB5289.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKDS5VDqouV1BnjB81sD8z7+aKd2yoGTDA3q6dLtElQMaSeFnf8M6Qd62xWBHr3Q7UUHnQwkVIm575sr76v5dh27jZD00xk4uBmJzUQ8P4djJH7FClYcf/axov+yghX3BmWHVhMKmdNufdIgneJDJ8phLUynFlCUNluUBwspzfKnsDjt7HmU1SCBHHrTJICHkWhFbL4xUiXMEqyV8Y9/5C6xNK9CjTj938Av9J+51GZd+z+CYPPgSfAcuT3Uv5ypxTGkdSdSILEOwWZpZnegoqKTSzDB5XFwjJhabPQBvJFOkV06G8kU7p8DQYdtJf4nOWJZgi7aaA/ERkfWBp9efU3Y8n0+8sCqVDdIcAY0ZtU+ie8+sECxyqwAmqJrJUzAjm4GSrTbQQ4DSQejcuUS2kGrKH1oxLXZgpzJwM6QrMYiMZiJSnbSP5YRCyfeY+Vg24E6jmLItK/6ATNADEEqwcUclXe83avQpNTbU/ImdopikH32GhuhYU5sLsmLlcy3vHlQRjsZD5OxT6rHW111T4dZPHZzCC3lrF28axxz3OYZsQilB3dmloEUgIoGO2so+li553nulpr4JqnNsVC1U18llUOzOstunUj1ZGj3ZkPQwOrMJP7h5EIjj3X9lYAEekOyNfU6v7IYVHtJjnmCkjm0AH3gzr6335BTA7FQjyEKu5nxM09OR6s8JMv7P2SyBXwGvKQTZsmUbmm9BJJlWoJa/s0KovimbO3RTUEVUps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(186003)(1076003)(38350700002)(38100700002)(5660300002)(2616005)(7416002)(103116003)(26005)(316002)(6916009)(36756003)(66946007)(8676002)(66476007)(4326008)(66556008)(8936002)(52116002)(86362001)(6512007)(2906002)(6486002)(508600001)(83380400001)(6506007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J5Jv/K9ADjxt5i/bNg9BrycdOYTDQ9QPDyS9fdrvcMgsql0NzeETXkGc+O/Q?=
 =?us-ascii?Q?cujiok6qPqHBjzO3amcTjYKsKuEmXg39HylOBtIciiPpi8fhI0n4hALWStgX?=
 =?us-ascii?Q?rotvNmpaihlJPVyg8X6LrXQzILubcTwR2SBOiyz7+Z+SpbSqe8OEHRza9sVJ?=
 =?us-ascii?Q?vUwPCXArJ7tMUtBjnkUxyDDUB4ISFqpRxI9J6H2rDbUDIim3pCgw2p2E6iHO?=
 =?us-ascii?Q?365zJ3vEBTJWEkqwC4u59xcVXYKFolbZWpGWl47T36FCV4yUPQHLV/nugTTL?=
 =?us-ascii?Q?bp6e2yV6D7kZva5Jt9kQEOg/2gQTfxSClTnoBjnl7qPAwzGglYNxtzYoRZ4b?=
 =?us-ascii?Q?P/+wCit6Jls+l0TI5Lzi+2lE60o872U6ag+R0N8zgWbPo4Q5NBH9HumW0w64?=
 =?us-ascii?Q?WAqqFO71mRZSaWFWAUuqfhjLKC+6/rn1LcEI4BgZ9A1RLvw/dzgy7bNzmMUo?=
 =?us-ascii?Q?fRr+puIEeOyCoLQK0pIXs7TNEhDYFVJakQE0P5yyeH8zYwGOag1v5zgzJIUE?=
 =?us-ascii?Q?0nhbB7vKOJ+4ZFKf9ZBn88vXXSRET3x4jl6ZOsl2pITMPtd5PKx0LiJfid8g?=
 =?us-ascii?Q?jkUeJFvtabDZ2WK84H2VsNmRYhyuVkte55ENsWWTs2cFc62BrpRE61IUTdrx?=
 =?us-ascii?Q?EoBnRZXF0Y5l5L7vyDU6R3JZZXibNoVPgn4KzB7e/uuHsdhFhj+OHrRNCRAd?=
 =?us-ascii?Q?goT3vBkQaUS0Jl7dsVbdUjZX1QfCKaChBLtI0YcLRAqI+gYqPSJfuNEh/kxD?=
 =?us-ascii?Q?iPiSf4a1SIy95f4ftH7g6wFJqQ70wjfiSHnaOn8qL/gH++eDrdUNrtDNJ5XM?=
 =?us-ascii?Q?IPxCLe/xe4qcSyQHkku1tG707LYq0IVoggeF9n+YIbNjarmE5BCcy7hVaHdf?=
 =?us-ascii?Q?gZ8ICfZueUBlYnT/E2CZWzxHZk4KP/MyXYNwQ1Xf0yQniTijMnBI7IJ3FLaM?=
 =?us-ascii?Q?OOtySwiKoXAEmMI4j4eR+SGuHqwfJxy+8al5+Uv57eFKiJ9K/Zj8/2BMiYRn?=
 =?us-ascii?Q?7pil9i2UKY4SQJX9IDM5AW5QmMo4KrTts+FS33VzN5gnOotrShPztXpDBxKG?=
 =?us-ascii?Q?c0FgAPNy8FzcuPm6/gf5Jt8JC16wDnad/GoTIbfQwW0NnJx6bJy0amCMuiPl?=
 =?us-ascii?Q?a966HxavRvsecsAz7D6WSvse3IVKD3Kp+b86zkMUJMMBgk3vCu9dh9BTG43D?=
 =?us-ascii?Q?ygZx8lEKTCw2YWH2kxqVbLuIJkiVkqFNTBvIORN0CDwQUc5Q3g4K6dEBuB4B?=
 =?us-ascii?Q?3/8f088LH+d9LPws9Mv3lIYL/PIXAQ26dO3QQcTBTcrq210pNqOmP5MU6fgl?=
 =?us-ascii?Q?FHNuyqilPBsdZyAy+fqHDVPg40YdmSUENqhfcZA2DBwvkbjcREPjpoyDY0Sw?=
 =?us-ascii?Q?uasZI/zr2aYPEz+4IAhb9511R9swFEaECuOWi7bQbR/T6dkK/7WBpA0X5P2W?=
 =?us-ascii?Q?RMIu49gB7UCA+CCMC9PhznpICiJ9Ag7weHbOU2dMrrPJwXEAMVM8n7D2lFJ3?=
 =?us-ascii?Q?BBW32NztK+n9y7LVieYHjWN++Gy49R8cqRHL6pxOtp23j65N7mxbqeTmJZYY?=
 =?us-ascii?Q?7Gr5nfoIb0RO84G6MwGfoiSlSqz3Xgge88iSXeFZSC88caBd8ncEVhbWKX3Q?=
 =?us-ascii?Q?1xc8LaAlGc80tPkiYH++C0hk8SKPnlERI1JWGeWR8rvN8Ntaf9crfidhoS8w?=
 =?us-ascii?Q?yNDkONjyI+FhtlZFkQ0qRys6V0E1DGk7KjeQLstbWI7njCOd5ZyHEek4jVoa?=
 =?us-ascii?Q?qaWFWp74aT3Gsa7ExBNFyVUCyUApU64=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2e3aa6-ab0f-46a7-7cee-08da295c1e3d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:45.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iP8WcXycWW9T5atJbhnTv96W7BPgyVPk9waK/rWM9xaff0wutaoI84G7MaytB+cSgWnZ4oZFla/4s1DmLsmZScHcZujIkg9NncbjIh/Nz8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: ChmZh7ID6gbAqvP6PjPzcXElhtpWDS4v
X-Proofpoint-ORIG-GUID: ChmZh7ID6gbAqvP6PjPzcXElhtpWDS4v
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ioctl(iommufd, IOAS_UNMAP_DIRTY) performs an unmap
of an IOVA range and returns whether or not it was dirty.

The kernel atomically clears the IOPTE while telling if
the old IOPTE was dirty or not. This in theory is needed
for the vIOMMU case to handle a potentially erronous guest
PCI device performing DMA on an IOVA that is simultaneous
being IOMMU-unmap... to then transfer that dirty page into
the destination.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 hw/iommufd/iommufd.c         | 21 +++++++++++
 hw/iommufd/trace-events      |  1 +
 hw/vfio/iommufd.c            | 72 +++++++++++++++++++++++++++++++++++-
 include/hw/iommufd/iommufd.h |  3 ++
 4 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/hw/iommufd/iommufd.c b/hw/iommufd/iommufd.c
index bc870b5e9b2f..0f7d9f22ae52 100644
--- a/hw/iommufd/iommufd.c
+++ b/hw/iommufd/iommufd.c
@@ -243,6 +243,27 @@ int iommufd_get_dirty_iova(int iommufd, uint32_t hwpt_id, uint64_t iova,
     return !ret ? 0 : -errno;
 }
 
+int iommufd_unmap_dma_dirty(int iommufd, uint32_t ioas, hwaddr iova,
+                            ram_addr_t size, uint64_t page_size, uint64_t *data)
+{
+    int ret;
+    struct iommu_ioas_unmap_dirty unmap = {
+        .size = sizeof(unmap),
+        .ioas_id = ioas,
+        .bitmap = {
+            .iova = iova, .length = size,
+            .page_size = page_size, .data = (__u64 *)data,
+        },
+    };
+
+    ret = ioctl(iommufd, IOMMU_IOAS_UNMAP_DIRTY, &unmap);
+    trace_iommufd_unmap_dma_dirty(iommufd, ioas, iova, size, page_size, ret);
+    if (ret) {
+        error_report("IOMMU_IOAS_UNMAP_DIRTY failed: %s", strerror(errno));
+    }
+    return !ret ? 0 : -errno;
+}
+
 static void iommufd_register_types(void)
 {
     qemu_mutex_init(&iommufd_lock);
diff --git a/hw/iommufd/trace-events b/hw/iommufd/trace-events
index 9fe2cc60c6fe..3e99290a9a77 100644
--- a/hw/iommufd/trace-events
+++ b/hw/iommufd/trace-events
@@ -11,3 +11,4 @@ iommufd_map_dma(int iommufd, uint32_t ioas, uint64_t iova, uint64_t size, void *
 iommufd_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas, uint64_t iova, uint64_t size, bool readonly, int ret) " iommufd=%d src_ioas=%d dst_ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" readonly=%d (%d)"
 iommufd_set_dirty(int iommufd, uint32_t hwpt_id, bool start, int ret) " iommufd=%d hwpt=%d enable=%d (%d)"
 iommufd_get_dirty_iova(int iommufd, uint32_t hwpt_id, uint64_t iova, uint64_t size, uint64_t page_size, int ret) " iommufd=%d hwpt=%d iova=0x%"PRIx64" size=0x%"PRIx64" page_size=0x%"PRIx64" (%d)"
+iommufd_unmap_dma_dirty(int iommufd, uint32_t ioas, uint64_t iova, uint64_t size, uint64_t page_size, int ret) " iommufd=%d ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" page_size=0x%"PRIx64" (%d)"
diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
index 6c12239a40ab..d75ecbf2ae52 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -36,6 +36,8 @@
 #include "exec/ram_addr.h"
 #include "migration/migration.h"
 
+static bool vfio_devices_all_running_and_saving(VFIOContainer *container);
+
 static bool iommufd_check_extension(VFIOContainer *bcontainer,
                                     VFIOContainerFeature feat)
 {
@@ -72,6 +74,36 @@ static int iommufd_copy(VFIOContainer *src, VFIOContainer *dst,
                             container_dst->ioas_id, iova, size, readonly);
 }
 
+static int iommufd_unmap_bitmap(int iommufd, int ioas_id, hwaddr iova,
+                                ram_addr_t size, ram_addr_t translated)
+{
+    unsigned long *data, pgsize, bitmap_size, pages;
+    int ret;
+
+    pgsize = qemu_real_host_page_size;
+    pages = REAL_HOST_PAGE_ALIGN(size) / qemu_real_host_page_size;
+    bitmap_size = ROUND_UP(pages, sizeof(__u64) * BITS_PER_BYTE) /
+                                         BITS_PER_BYTE;
+    data = g_try_malloc0(bitmap_size);
+    if (!data) {
+        ret = -ENOMEM;
+        goto err_out;
+    }
+
+    ret = iommufd_unmap_dma_dirty(iommufd, ioas_id, iova, size, pgsize, data);
+    if (ret) {
+        goto err_out;
+    }
+
+    cpu_physical_memory_set_dirty_lebitmap(data, translated, pages);
+
+    trace_vfio_get_dirty_bitmap(iommufd, iova, size, bitmap_size, translated);
+
+err_out:
+    g_free(data);
+    return ret;
+}
+
 static int iommufd_unmap(VFIOContainer *bcontainer,
                          hwaddr iova, ram_addr_t size,
                          IOMMUTLBEntry *iotlb)
@@ -79,7 +111,13 @@ static int iommufd_unmap(VFIOContainer *bcontainer,
     VFIOIOMMUFDContainer *container = container_of(bcontainer,
                                                    VFIOIOMMUFDContainer, obj);
 
-    /* TODO: Handle dma_unmap_bitmap with iotlb args (migration) */
+    if (iotlb && bcontainer->dirty_pages_supported &&
+        vfio_devices_all_running_and_saving(bcontainer)) {
+        return iommufd_unmap_bitmap(container->iommufd,
+                                    container->ioas_id, iova, size,
+                                    iotlb->translated_addr);
+    }
+
     return iommufd_unmap_dma(container->iommufd,
                              container->ioas_id, iova, size);
 }
@@ -367,6 +405,38 @@ static int vfio_device_reset(VFIODevice *vbasedev)
     return 0;
 }
 
+static bool vfio_devices_all_running_and_saving(VFIOContainer *bcontainer)
+{
+    MigrationState *ms = migrate_get_current();
+    VFIOIOMMUFDContainer *container;
+    VFIODevice *vbasedev;
+    VFIOIOASHwpt *hwpt;
+
+    if (!migration_is_setup_or_active(ms->state)) {
+        return false;
+    }
+
+    container = container_of(bcontainer, VFIOIOMMUFDContainer, obj);
+
+    QLIST_FOREACH(hwpt, &container->hwpt_list, next) {
+        QLIST_FOREACH(vbasedev, &hwpt->device_list, hwpt_next) {
+            VFIOMigration *migration = vbasedev->migration;
+
+            if (!migration) {
+                return false;
+            }
+
+            if ((migration->device_state & VFIO_DEVICE_STATE_SAVING) &&
+                (migration->device_state & VFIO_DEVICE_STATE_RUNNING)) {
+                continue;
+            } else {
+                return false;
+            }
+        }
+    }
+    return true;
+}
+
 static bool vfio_iommufd_devices_all_dirty_tracking(VFIOContainer *bcontainer)
 {
     MigrationState *ms = migrate_get_current();
diff --git a/include/hw/iommufd/iommufd.h b/include/hw/iommufd/iommufd.h
index 9b467e57723b..2c58b95d619c 100644
--- a/include/hw/iommufd/iommufd.h
+++ b/include/hw/iommufd/iommufd.h
@@ -36,5 +36,8 @@ int iommufd_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas,
 int iommufd_set_dirty_tracking(int iommufd, uint32_t hwpt_id, bool start);
 int iommufd_get_dirty_iova(int iommufd, uint32_t hwpt_id, uint64_t iova,
                            ram_addr_t size, uint64_t page_size, uint64_t *data);
+int iommufd_unmap_dma_dirty(int iommufd, uint32_t ioas, hwaddr iova,
+                            ram_addr_t size, uint64_t page_size,
+                            uint64_t *data);
 bool iommufd_supported(void);
 #endif /* HW_IOMMUFD_IOMMUFD_H */
-- 
2.17.2

