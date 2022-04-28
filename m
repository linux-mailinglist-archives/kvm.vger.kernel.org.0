Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E06513D3B
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352134AbiD1VPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352128AbiD1VPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:15:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F12B8119A
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:12:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIXQM2025808;
        Thu, 28 Apr 2022 21:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ROkY7Aelsj1vR2ocL/rt50z4ZMzKR+n2cnXW4RGlKNU=;
 b=WTnZjg5Cp/I6OhoDNiTCM8IyHgKfn4IAL4kkXo4tpaIqsxeiIcBWWQBW2KgMOO/j1s/s
 Q4MX9Y7KJdItKSNaELEmkttcQoCZIzdXTWNybR8opP/fg2RJkAv8OYVxUwIzrSmf3xmP
 A/zd5LC/h7Di8ckUM+txjv6bCIiGpPK3zupPu+UbKje1zF7c+eDlI980O4tJHxPGRZYl
 EfGeckGVCFJJZQeefZY/MohKYCtKfhfNkPgHjcjMnypECTnMtSBytRAF4UxVCvVVSQ/m
 u1Mz/tqrnQKXIv0t39Ql+OboyZ4h70s+Ap0wMw2fp2zyMwDr0uh69smJ9Ucsf3eghd2k TQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mwbhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5CuY028560;
        Thu, 28 Apr 2022 21:11:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79pb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8QuhZJqrN5untT465pVm79IaJPdCIgReQ1Wu8tk5IWi1yzi0AUM50AikC5hMOZ+TOjsOSK8ACdLrxVL4cJVVOXa1BuiYcsZh7/GjAmAK5kczZzTyTokvkaL1NRabXS0FseGsUtsySgliQqisy4EE1ZEdXOxxX/X/AXRUWuy8lnNbpowOBzEFk3Xv0UkqmPvfG6tI5gIbZ2/+Qx93YuvMPv/e+M/SeHNlyZ9Mv2n4ykFG7g8MGlAsPf0hvg+4vKb1pqVbBqqIyXtNictBzyQPhbvkz1w543+/fzd+5L1cEXNVbQIM3oSvmVJ5uOr/jCa2MuNrq8PVu3axzRRkH1EfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROkY7Aelsj1vR2ocL/rt50z4ZMzKR+n2cnXW4RGlKNU=;
 b=e5c2tUHF4AuuhYqgzjjps/9xdjZAuOl+zeHA9QwduSiB0/W9+pCKDiKBmAkf7kHDfo2IBStxiRcPWOuNoXQLl+l4UHWBTCMlsrarZfuByEGOBlacGGA39MjGVY/6ChD1kYYBs+rw0+EUpT8Khhud6QWBHvl3KjEsHZoVs7KWcOoK/iec3Kus8UM7Qhz6lu07+jnP4cbL2XXVckkLKGLaIGLjs55XIOaXQvaJZ1Lx9o1ewjPyrLeqJFQWtzV31TV2UcpOcvRj/0qnPTMyEomdgMW3FRU9gbtWJGXAIv4Js6E3HcZG7XLqtBE3uWT3aSqHWcOocK77Cn0LexAzvyfhfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROkY7Aelsj1vR2ocL/rt50z4ZMzKR+n2cnXW4RGlKNU=;
 b=Lci4Rvy240xGpzLsHNtLsvX7P9pLcks4ipInG13XleRkJBz/Nym2mZ1j6uwoB8D9rCCp2P2UPkhSgrqlPh5+KXy9dH2ENVEqILGtcmM7N1/Hi48H37vOyWUKQ1di+edbW0R3hmDFB8LopI8DtdXNp0Fbt0nQcIrghAhsnx/AnWc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3341.namprd10.prod.outlook.com (2603:10b6:208:12f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:11:37 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:35 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux-foundation.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC 18/19] iommu/intel: Access/Dirty bit support for SL domains
Date:   Thu, 28 Apr 2022 22:09:32 +0100
Message-Id: <20220428210933.3583-19-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98248069-754b-44b7-dba7-08da295bad07
X-MS-TrafficTypeDiagnostic: MN2PR10MB3341:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB334196FDE3FDE019E32F89F3BBFD9@MN2PR10MB3341.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8R9A9IzkpqpaGTm/YI78TdzCbLm/dROxGRlSTPOyZvl/CIEtLsS/+NKHkn/8q8ZfEb4bKCbHP/824qlheoGI/JgIco6TAHJY8E9a86/M05+wjeeZ7GkmjORvGog3TVGiyWgeLafMAoQ8AYNL6kImxQDI6C7+A/tq4PYsYILIoYSZp2Nb0g+wrG3r+QSm0Mk3GYNsmeQWYM2GgnLJSqEq5l1NrsQXBye9WipTpH16qz1jL1DzXprqMsGvAC+vLL1DHCHIliIHxmHe03hAKMMUgMoT8wuATnGL/2mlZDFU42wmLBL4jJj3icIYi7jkQ0PanEMQmhnRv9BYnlP8xpKMYq1ZdTwd9vaPUxjP7/K4Sn1AnQAVQ/ZNSSUURRUIfRA2ODupS/VxCAD6CHtb6eqwvQH0ZhTqk1BKN/3d1oJB2lWcrmRikSKIcrvn+iiHJfK6/ZcZ7WkpUlseUf0CtXIHJw5uHQeYcovJiUiKFCN3gDBQ9b9hLgOIR0Fy6uaElz4ffJXbPUu0YIzPOCV5jeDs4mI0uQmAfA6GABq8DtY1lmEJtEIFeuY1Aq5Npsszij0Gq99/BRUrlP1TuYOCI+W6nNozJmMbVHN3a+n85DFhJu6Hnj+5yMabFSUbLHHWM05npD62JQutROIrkltBltmkmpVPO5nyx4KuZcFCecWQN8WcfN8ur95xIW8bjLJfoC9WjgH/RuLZS6KQaczcL71/xdYVNwIYsDNIoduUpURCq4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(103116003)(83380400001)(508600001)(1076003)(2616005)(52116002)(26005)(6506007)(6666004)(186003)(2906002)(7416002)(36756003)(316002)(5660300002)(6916009)(86362001)(54906003)(38100700002)(38350700002)(8676002)(4326008)(66476007)(8936002)(66946007)(66556008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V+9nPfqV4t8t7kkUhKw1awpOYQOpckudN/YmaOq6H+WxNnE8lOVg22Mpq7ET?=
 =?us-ascii?Q?Xp5styW+QdFPi26zM1jJm/Fgq26eX27VHdGkhH+pyP0EEtbB3iaBPqH1Qmtn?=
 =?us-ascii?Q?wiwMd4HoLxohTQ2JfuBIAl11PtGh/E/l8pHlJtcGZwwFWtC40nmTL3NUrVBN?=
 =?us-ascii?Q?BA4SWMTiyII9I3Ze/qw3XA1ExEiswmHo9ndPm39QJx4+PTZBhMYAcVm0AqnU?=
 =?us-ascii?Q?0No9l535yWeRxe/lhnB/UySUMdEnr48DLemIIY23vFojW1v0WuvVsVrUVFs1?=
 =?us-ascii?Q?Xswuta3FxrDt6y3rH0kqhscc1xIZ7RyDvr1IWwkl0N/1dHYCneFaqerNYclN?=
 =?us-ascii?Q?pRIqsMLqYthZfmA5QW1lIufyg+8oMPa2wnjniAGwtEzNepTPjz5ZVjbKKOf9?=
 =?us-ascii?Q?XZjKlCo5JBs/KKcr9eSPu0ssIibDfCQDxBgKXoas6l6+Y0sWTAMdbC2nOHrR?=
 =?us-ascii?Q?pqZaRprGe0G+GD7INFr57SGEHHW7Zh5SYlysUIH00K9mTemRL3aUf27MeBzi?=
 =?us-ascii?Q?QKMpyXKYWHAi4JtA8y+DUs9mxSbrDnDf+V3hX3ffe2w3nBc6BfnazccrVslu?=
 =?us-ascii?Q?2vgqqtMp4bLXraYD0xVPE+LSSdsD+OGAsXe+EJg2zhUDqiJkWLn/dXjaOuaT?=
 =?us-ascii?Q?jxV203xZT3x0e+vt5QUervJN1hydln90zON0S3tk65GAnmN/zwX6UAp4NS0I?=
 =?us-ascii?Q?l0y7x4Bt67kAR+ukfFQaizOxiREg9KUUrlEQ9bU3fpACLzR8RK3a4EBC5RGu?=
 =?us-ascii?Q?SvrpofbGXS0IT6RG7ZY3wjm3ApJ+lrUiQDcTw/KEB2tA/g2GZC1S9ABMkaFv?=
 =?us-ascii?Q?1hgJwpxlMGrJSKX9qI/u26Oyx0LGY9ToEwkldMlbghYdaIp7l+W0e+MJ7Cxr?=
 =?us-ascii?Q?wDVsd2mqYg5mHgTHUhf8qAOaT/KcJBQ20Q6lFv8nWygeklLi3DMDVPPFOUvj?=
 =?us-ascii?Q?hD4dy+QKpIdcUzHaxrgtwwqu87MWmyadd6LEJa3k3ZqtpKgEyo9roAJnk6Uk?=
 =?us-ascii?Q?TloYwM4t3uYqlx1FcPzrKjzNBHL4EYBPXCxEbmzZu07gnzyfPKwZUrAGAW51?=
 =?us-ascii?Q?QdS3FurofkIvvAkx/TJUeOiQ1mZ0W+QWOH5z4PF806azIEm7sk99NRXuUJvv?=
 =?us-ascii?Q?xT48R0E2jLgx44IeCtl1Iyejhi+k+xg5lT4NBI01ViR5/O3/wO9Xj67hlKGM?=
 =?us-ascii?Q?QByuk9+9czjrsGgcnuUeaiu4vgFnazDCEVKLM43QDW7C9pmI89AS6vnHPFr+?=
 =?us-ascii?Q?iOp7EOf29b2Fdv9LMRuG23qxznk/JWPId38R6NX9e6pKjXY+ZyqAv/FJwjVL?=
 =?us-ascii?Q?Im7Dn2kABLWvsJVcnetMtkhqGF69tN7esoSnaIIfzcAe+hbzp4gYQ+9LSdA7?=
 =?us-ascii?Q?5f9VA33jNXKKudodzyEMiZ3mMRDRr6GanAin2BBPlFRYl9XJX/Rm9laAjkpp?=
 =?us-ascii?Q?1dCAi7JkTGusnzkWaICXnLqcMehCKTv61f4xm9kyEkyxVWpLT6Qw2kJk86CK?=
 =?us-ascii?Q?VSLd6nrG5DohA2Vx4lM15/+2s4W/oPbttE46WuUu42adaoguh9RGe+UNRhIy?=
 =?us-ascii?Q?avaYklYgslt6iQsF8KbkmLlDd3DRaIszeWez35uFMYrLAims6wYAo/dUsXjI?=
 =?us-ascii?Q?tjPrNs5g3IXDUeMKmO9JNl+YG4LciFwSPiM+CcukX8WwbLjwtz6KASYF8KKq?=
 =?us-ascii?Q?FFlU+mR4mPoqDUTw0wilUStlJiNpDGatZdb97WShHkLXZVbmVFns6eh02OS4?=
 =?us-ascii?Q?X2rLW5ILnxLVgGtmaTUE2Ijqeys8NRc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98248069-754b-44b7-dba7-08da295bad07
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:35.1063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ySyZA+nqhZX/xlzW2VUDt1cMza9glgYPWqVhOM1R4iuTnJ/ELR5ZXiiCfJ3oPqIonjDGmnHf4L8r8A6WRtLcZt3mEcT4ruNTsTdW+cDThs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3341
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: UYVQXTM4UAtdFQ8hrbdtbzWtBJ21GMvk
X-Proofpoint-ORIG-GUID: UYVQXTM4UAtdFQ8hrbdtbzWtBJ21GMvk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU advertises Access/Dirty bits if the extended capability
DMAR register reports it (ECAP, mnemonic ECAP.SSADS). The first
stage table, though, has not bit for advertising, unless referenced via
a scalable-mode PASID Entry. Relevant Intel IOMMU SDM ref for first stage
table "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second
stage table "3.7.2 Accessed and Dirty Flags".

To enable it scalable-mode for the second-stage table is required,
solimit the use of dirty-bit to scalable-mode and discarding the
first stage configured DMAR domains. To use SSADS, we set a bit in
the scalable-mode PASID Table entry, by setting bit 9 (SSADE). When
doing so, flush all iommu caches. Relevant SDM refs:

"3.7.2 Accessed and Dirty Flags"
"6.5.3.3 Guidance to Software for Invalidations,
 Table 23. Guidance to Software for Invalidations"

Dirty bit on the PTE is located in the same location (bit 9). The IOTLB
caches some attributes when SSADE is enabled and dirty-ness information,
so we also need to flush IOTLB to make sure IOMMU attempts to set the
dirty bit again. Relevant manuals over the hardware translation is
chapter 6 with some special mention to:

"6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
"6.2.4 IOTLB"

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
Shouldn't probably be as aggresive as to flush all; needs
checking with hardware (and invalidations guidance) as to understand
what exactly needs flush.
---
 drivers/iommu/intel/iommu.c | 109 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel/pasid.c |  76 +++++++++++++++++++++++++
 drivers/iommu/intel/pasid.h |   7 +++
 include/linux/intel-iommu.h |  14 +++++
 4 files changed, 206 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ce33f85c72ab..92af43f27241 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5089,6 +5089,113 @@ static void intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
 	}
 }
 
+static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
+					  bool enable)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct device_domain_info *info;
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	if (list_empty(&dmar_domain->devices)) {
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		return ret;
+	}
+
+	list_for_each_entry(info, &dmar_domain->devices, link) {
+		if (!info->dev || (info->domain != dmar_domain))
+			continue;
+
+		/* Dirty tracking is second-stage level SM only */
+		if ((info->domain && domain_use_first_level(info->domain)) ||
+		    !ecap_slads(info->iommu->ecap) ||
+		    !sm_supported(info->iommu) || !intel_iommu_sm) {
+			ret = -EOPNOTSUPP;
+			continue;
+		}
+
+		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
+						     info->dev, PASID_RID2PASID,
+						     enable);
+		if (ret)
+			break;
+	}
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+
+	/*
+	 * We need to flush context TLB and IOTLB with any cached translations
+	 * to force the incoming DMA requests for have its IOTLB entries tagged
+	 * with A/D bits
+	 */
+	intel_flush_iotlb_all(domain);
+	return ret;
+}
+
+static int intel_iommu_get_dirty_tracking(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct device_domain_info *info;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	list_for_each_entry(info, &dmar_domain->devices, link) {
+		if (!info->dev || (info->domain != dmar_domain))
+			continue;
+
+		/* Dirty tracking is second-stage level SM only */
+		if ((info->domain && domain_use_first_level(info->domain)) ||
+		    !ecap_slads(info->iommu->ecap) ||
+		    !sm_supported(info->iommu) || !intel_iommu_sm) {
+			ret = -EOPNOTSUPP;
+			continue;
+		}
+
+		if (!intel_pasid_dirty_tracking_enabled(info->iommu, info->domain,
+						 info->dev, PASID_RID2PASID)) {
+			ret = -EINVAL;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+
+	return ret;
+}
+
+static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
+					    unsigned long iova, size_t size,
+					    struct iommu_dirty_bitmap *dirty)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	unsigned long end = iova + size - 1;
+	unsigned long pgsize;
+	int ret;
+
+	ret = intel_iommu_get_dirty_tracking(domain);
+	if (ret)
+		return ret;
+
+	do {
+		struct dma_pte *pte;
+		int lvl = 0;
+
+		pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl);
+		pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
+		if (!pte || !dma_pte_present(pte)) {
+			iova += pgsize;
+			continue;
+		}
+
+		/* It is writable, set the bitmap */
+		if (dma_sl_pte_test_and_clear_dirty(pte))
+			iommu_dirty_bitmap_record(dirty, iova, pgsize);
+		iova += pgsize;
+	} while (iova < end);
+
+	return 0;
+}
+
 const struct iommu_ops intel_iommu_ops = {
 	.capable		= intel_iommu_capable,
 	.domain_alloc		= intel_iommu_domain_alloc,
@@ -5119,6 +5226,8 @@ const struct iommu_ops intel_iommu_ops = {
 		.iotlb_sync		= intel_iommu_tlb_sync,
 		.iova_to_phys		= intel_iommu_iova_to_phys,
 		.free			= intel_iommu_domain_free,
+		.set_dirty_tracking	= intel_iommu_set_dirty_tracking,
+		.read_and_clear_dirty   = intel_iommu_read_and_clear_dirty,
 	}
 };
 
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 10fb82ea467d..90c7e018bc5c 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -331,6 +331,11 @@ static inline void pasid_set_bits(u64 *ptr, u64 mask, u64 bits)
 	WRITE_ONCE(*ptr, (old & ~mask) | bits);
 }
 
+static inline u64 pasid_get_bits(u64 *ptr)
+{
+	return READ_ONCE(*ptr);
+}
+
 /*
  * Setup the DID(Domain Identifier) field (Bit 64~79) of scalable mode
  * PASID entry.
@@ -389,6 +394,36 @@ static inline void pasid_set_fault_enable(struct pasid_entry *pe)
 	pasid_set_bits(&pe->val[0], 1 << 1, 0);
 }
 
+/*
+ * Enable second level A/D bits by setting the SLADE (Second Level
+ * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
+ * entry.
+ */
+static inline void pasid_set_ssade(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[0], 1 << 9, 1 << 9);
+}
+
+/*
+ * Enable second level A/D bits by setting the SLADE (Second Level
+ * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
+ * entry.
+ */
+static inline void pasid_clear_ssade(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[0], 1 << 9, 0);
+}
+
+/*
+ * Checks if second level A/D bits by setting the SLADE (Second Level
+ * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
+ * entry is enabled.
+ */
+static inline bool pasid_get_ssade(struct pasid_entry *pe)
+{
+	return pasid_get_bits(&pe->val[0]) & (1 << 9);
+}
+
 /*
  * Setup the SRE(Supervisor Request Enable) field (Bit 128) of a
  * scalable mode PASID entry.
@@ -725,6 +760,47 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	return 0;
 }
 
+/*
+ * Set up dirty tracking on a second only translation type.
+ */
+int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u32 pasid,
+				     bool enabled)
+{
+	struct pasid_entry *pte;
+
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		dev_err(dev, "Failed to get pasid entry of PASID %d\n", pasid);
+		return -ENODEV;
+	}
+
+	if (enabled)
+		pasid_set_ssade(pte);
+	else
+		pasid_clear_ssade(pte);
+	return 0;
+}
+
+/*
+ * Set up dirty tracking on a second only translation type.
+ */
+bool intel_pasid_dirty_tracking_enabled(struct intel_iommu *iommu,
+					struct dmar_domain *domain,
+					struct device *dev, u32 pasid)
+{
+	struct pasid_entry *pte;
+
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		dev_err(dev, "Failed to get pasid entry of PASID %d\n", pasid);
+		return false;
+	}
+
+	return pasid_get_ssade(pte);
+}
+
 /*
  * Set up the scalable mode pasid entry for passthrough translation type.
  */
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index ab4408c824a5..3dab86017228 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -115,6 +115,13 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid);
+int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u32 pasid,
+				     bool enabled);
+bool intel_pasid_dirty_tracking_enabled(struct intel_iommu *iommu,
+					struct dmar_domain *domain,
+					struct device *dev, u32 pasid);
 int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid);
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 5cfda90b2cca..1328d1805197 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -47,6 +47,9 @@
 #define DMA_FL_PTE_DIRTY	BIT_ULL(6)
 #define DMA_FL_PTE_XD		BIT_ULL(63)
 
+#define DMA_SL_PTE_DIRTY_BIT	9
+#define DMA_SL_PTE_DIRTY	BIT_ULL(DMA_SL_PTE_DIRTY_BIT)
+
 #define ADDR_WIDTH_5LEVEL	(57)
 #define ADDR_WIDTH_4LEVEL	(48)
 
@@ -677,6 +680,17 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 	return (pte->val & 3) != 0;
 }
 
+static inline bool dma_sl_pte_dirty(struct dma_pte *pte)
+{
+	return (pte->val & DMA_SL_PTE_DIRTY) != 0;
+}
+
+static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte)
+{
+	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
+				  (unsigned long *)&pte->val);
+}
+
 static inline bool dma_pte_superpage(struct dma_pte *pte)
 {
 	return (pte->val & DMA_PTE_LARGE_PAGE);
-- 
2.17.2

