Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A16C513D44
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352093AbiD1VPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352106AbiD1VPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:15:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0E07E5B0
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJNZ6V015535;
        Thu, 28 Apr 2022 21:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vE0QWVVrTtjt87BKiGfmPH/zxKy32tdNkxDJ+qV7PZQ=;
 b=eGfTJh5ifXypV+6SwoU5VaiFaM9k/7HAfvVE95dHx9GOLGFAmqnQiL9QCQ8fRUFnXxak
 S3iilEZ2nCq1cZjYRaPCaD9MAx7j2dWn24zncMG04KZe+l2JvndrSRKB3UrvDUCEP3D9
 0dmBvtnmm7CeqFuE5O6/fhbYte9A02yFht4XjvS8My5Pml5eL2Ok/K6BdUnnSgoHws6O
 iGq/ninG8UUXnZcgZTGLhdtGe/TCaoDoMFGob3p0kdl68SgHvCLhkPnGG4C0I6B9NsO8
 srezDsZAJ2k5rzVTv0FTNoHBzzd1bbR/jm1hXTBbvYCc9iemnd2GTDcjZqd8dSYNczFf OA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw5x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6ce3028671;
        Thu, 28 Apr 2022 21:11:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ype99g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR84YHuUIyW1gI3AOnvCnhdJkrxUoGjqdAviTf4PmwEle+ScUXhGU7vj9F213SSXaugl/yTPka63zyS2nGwoqwk10BeMHilmDU65pZLext3jJMltGLJFRDAExN+vb88mRkRNJg/hOVdh42G0sfRvaay9DeFXZpFGkWsz8M5FjfdrVzN5nuwK8ODauo7reVppIckXucnfmVv1luAZXHmnzA/E8TDtFr2SzezFg2wG9evAffooCBHtJiTUHKbw6NIcRnqSfi+6zQr3Kmjao49h5QYje9ZtitKe/88kca6s339dthNffIX+s44RbaQAoaxgdZyoBeK9dNS+5548QXySnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vE0QWVVrTtjt87BKiGfmPH/zxKy32tdNkxDJ+qV7PZQ=;
 b=BGB5FRR72NSuVjkA8RO1ys+OPIY8muMyW3kzbXF3RNnGIZOe+/mRNAmJKk3j5KPR1MIpNP0WwSdbIzkWzMU9g4jnCQ3+G+tRneXewukoKhwEZqZd3Q9N2JD3gNv3nzJV1CmBRK133kem9WYP34XjMPGHy4VuY7lrkgbxN1iY0fLaChJrMCfm0xor6ng80+A6iKj+sEGxeWBHwnfMtOb0qLgojdt6lDPPc1cyAi7RImnLIROsdnEiL+tu2Xn/oe0hofCRO+MTlFktkRrPxHQBkIV8tZE0xpB5SalTdc3aZ3mNy+YIuuFMvOV822VL01nMnfQsWac+daDpCNqpPMt7fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vE0QWVVrTtjt87BKiGfmPH/zxKy32tdNkxDJ+qV7PZQ=;
 b=hTz/T6MbOA8Q7f1zKIbYQczMizGHiBNAuMi7wUxkuieqYmBcsAINNMwY7Cjbr3ukRrlJ0G4Az57fXtZ16WURe0P2UfJ1uGynqY7dD3dB3aFoYQYg4lg4YY9k1tWtgoF24ktGpJbePn500XUxHNucca5nmYt2mtsiLUheZmvMV30=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3341.namprd10.prod.outlook.com (2603:10b6:208:12f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:11:24 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:24 +0000
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
Subject: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add set_dirty_tracking_range() support
Date:   Thu, 28 Apr 2022 22:09:29 +0100
Message-Id: <20220428210933.3583-16-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66a4f652-d6bb-480f-e15a-08da295ba6b5
X-MS-TrafficTypeDiagnostic: MN2PR10MB3341:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB33410FECF463831A619F4C6CBBFD9@MN2PR10MB3341.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9L0oI7J3jEz/VMuND6m5tDNoAuBfyGWd0Jge5hFw8bhWogwCs5F4ExWlD1A407E+dB4LdTREf2mGSjj/d5tEaGsRzFUzYibl6Z4Q8AjOhX3WN3g3JD5GjSMUEeYGRkgWpHMUxKi9fUQdZwoEq27KLVVJhZJqzGUpJ+aBUwcXBjDOyI1q6AGwtPpSz+kaSfceJVBNUdHRoFfk52Pdy+FT/P+dIRwPOW/IfutP+G+SqRoo3DKJvi299mnU//NqxquhL+4k0oedlyoEtFWTFb8JonpNMpuwbogS3ZirGF8HgiHiZ1IUMfm+vSH4H0hqQoQ8NRjpk+6pogfJdV+47V2MrZOdc8QT4iZJAlq8a1CzY1JGuv2O+bA5kxZEUa6Ijlrz0aymuoUeOd5vNzqQcbkJiznhaMTgH1iXKz9mbk5cXRcs2xF7ArlY5GaTZ8SEnroBiE58ZKVMzSiy6gVmPB37yf2Z7aj1/sn80gSxVUr2yCeSGehBxTZ1Xp9YSGo8TZU6XZw27P4vAOPEl5OjpOpdhmRLcBlNfCa9vs9G9Xg+gPrKC1DBFJDW81IHShoUwMmff0uvNqp8Eq+KPRfIfWYmDyNOQEDif/KuehU9umeUkHjfGS3X8K8Ulxnh7jTzAU2qa0neR5rSueqz29vW01hPgbEO95oyFMe1e2sXxack/I6921VP/nvoWO/InLykr97xbFxcND0/rmqLBfneRFQu7llVGVtn0E/w6atV0d17j2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(103116003)(508600001)(1076003)(2616005)(52116002)(26005)(6506007)(186003)(2906002)(7416002)(36756003)(316002)(5660300002)(6916009)(86362001)(54906003)(38100700002)(38350700002)(8676002)(4326008)(66476007)(8936002)(66946007)(66556008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FvNEYDqpRwsuDeS9nDENou7JgCdZsHG2HduQHcmWf03cndXTmoI8Sr9P15+z?=
 =?us-ascii?Q?hq2Nb9vlBUDSpshgtTZRJXHHp3K58mE0f57S+nhWXy9MCpYG+8nm0jSlqkT6?=
 =?us-ascii?Q?Tixp7vlXTpLWJTUptGd7IcqRbQgkYFo2HAaZdke+fKsP5nwHFzUzizZQXqiT?=
 =?us-ascii?Q?oY2IOKXuRcZlgS8k4gDYR1z6wTgxPTG+iM+06/IFmyiq8uKnwjE6HadPbg1o?=
 =?us-ascii?Q?r39qGtG36HIFXpHcViuJdciJV2fyCLhXjxU5CJuf+Ltx3TwW9fKCiQjQbhE1?=
 =?us-ascii?Q?cKVXDmaBvGq1qEgnvt2PAghigJcow+lodbhUHJEA377xD1PFF0WRhPSjpfsD?=
 =?us-ascii?Q?CODmy8guPqVLpQM6QMvfqZSjn8C3R8sGK2eZQig5DHbNpL21Qd7k2mWjuq6d?=
 =?us-ascii?Q?4SWIRbEhgDqzouuKTetZNmS/1Ch2pq/+LLSrtNuG8x44JE9oE1zWVZnyGcfN?=
 =?us-ascii?Q?Gz+SVVyVtKL59tJRO3pkh+k/+7ErLOcCruOTMePwFugHmQduZFixxa7+eSr6?=
 =?us-ascii?Q?1Jpv0dthL+wzfw/5m140Lp1ePMvXzHmyLd3Spo/ydyei8pi9gP9Ce6SYCgSh?=
 =?us-ascii?Q?MA2P6o7a0Dg20fElZDcY7RO/H+Uu2SNqfcQ+8X9cwdFjPDK6hWQ9ifeUvsDk?=
 =?us-ascii?Q?p+PSCcMF+fjBdEqBBXKpRdTRtEfYJYoBrL0iWuiEpBFeYbnXIzhzW2CqNUkv?=
 =?us-ascii?Q?K2+bigzWEEFb1L+/PpGqMhXiCKFhph+g9Bt5hVPBqLmJOS8GiGcyw9vn5WDO?=
 =?us-ascii?Q?vLLAzebzAo77ftWwqvZXh4mby2KpAoho0jQfZAnOIqBitnQE5M6arbjmAmAJ?=
 =?us-ascii?Q?4rDpXAPvVLpzlhRzE+jSRJoomi5EQtfqMH4BmHXNwgxTf0sK+ZCW85no7Ebg?=
 =?us-ascii?Q?Ds9qniOEko00GKe83U5cBQf7xF/VoAljk+be5jMtaN+bWYr2yiqVjyW7bRuW?=
 =?us-ascii?Q?1+vNTBeTjmhHA2K8T5AY3gfrQRyrIUjCMZxe5V1N/Lc9v3MkcdSukIpMIOVX?=
 =?us-ascii?Q?P2xNC4tQc2WipVTunZJcHO/SHn0lZQ0MvCm+Ic51ejC+GyI+H5ZvjiwkaBB2?=
 =?us-ascii?Q?GVBhH0v5awICNhMU+KRaUs7m+6e2F17VTAR47lzFeQT0XEtBgAiHRbxj2cdT?=
 =?us-ascii?Q?4rkkNwuBU2aw7Zj1DV4QQnHI7UQYPmdBVu/L1X0DZi0k24bvs3jJdrhOzHFN?=
 =?us-ascii?Q?dPFZ4nOnJrCYk2hNVWSlQPLK0OiefoWvIai+aFssBO5npUBzsfEC7z20n6yV?=
 =?us-ascii?Q?D9bk2ziVcKmLorv/DSnI52nGFCT3PEdwjHa3ctWkB7WuIIWUwHS9QoJUjcj7?=
 =?us-ascii?Q?euo5KD+4AUdwyZ6MnIs7mpQKLx6MJGN1EbbU+v8FskSqI0pvGWi+ecVTrPAt?=
 =?us-ascii?Q?6ZLNDcuBm68Vp2RJoijweg+l77UEHYjGl4EFSjpGmM3m3oEcHRE35qqe1IXA?=
 =?us-ascii?Q?KfQe60pn05EMCMjLLf8rQ6weS+fuDu7+86dTl8ADAZtMSo1Hyb6yLYY/DtAN?=
 =?us-ascii?Q?ON29xikfNvd9V6azEhJqMBj7hGrp8lgiaJVXvmiieQveBZX0qXzGjcb9XoPa?=
 =?us-ascii?Q?qhBtY+YoMNpbO5yuT54dY25A0l9hgnvh1vOyWAtcv53sVHfZHzaVq0zu8nst?=
 =?us-ascii?Q?a8vAZzR+fc9yyeys+rWfsRUpdlhBXh0a2jOwN2UtcaGMYPiyqE0sU5v5miSv?=
 =?us-ascii?Q?/LDLp8+c5yndwtObPfjUU7fCe9YbfMVJvAKE2Ltujk2vVAEgsgfHFv4XFfxj?=
 =?us-ascii?Q?Cf6iZyeoBhZJ8/DSW6e7eag91C4mDc4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a4f652-d6bb-480f-e15a-08da295ba6b5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:24.4858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QAqAeKnf0feaSPLAfRxLf0wfH0fTXvh5O0L9cBcmXhHRMYoK5mbR0enXJO6IVYjmS7sc4ypjjAWSRlK2FrDfIsWuJjDwAtwfc8P8tRQ/xCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3341
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=806 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: vVRJIhrcq9srBDqbF8FwwHyUpinzIFop
X-Proofpoint-GUID: vVRJIhrcq9srBDqbF8FwwHyUpinzIFop
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to .read_and_clear_dirty() use the page table
walker helper functions and set DBM|RDONLY bit, thus
switching the IOPTE to writeable-clean.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 ++++++++++++
 drivers/iommu/io-pgtable-arm.c              | 52 +++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 232057d20197..1ca72fcca930 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2769,6 +2769,34 @@ static int arm_smmu_read_and_clear_dirty(struct iommu_domain *domain,
 	return ret;
 }
 
+static int arm_smmu_set_dirty_tracking(struct iommu_domain *domain,
+				       unsigned long iova, size_t size,
+				       struct iommu_iotlb_gather *iotlb_gather,
+				       bool enabled)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	int ret;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_HD) ||
+	    !(smmu->features & ARM_SMMU_FEAT_BBML2))
+		return -ENODEV;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -EINVAL;
+
+	if (!ops || !ops->set_dirty_tracking) {
+		pr_err_once("io-pgtable don't support dirty tracking\n");
+		return -ENODEV;
+	}
+
+	ret = ops->set_dirty_tracking(ops, iova, size, enabled);
+	iommu_iotlb_gather_add_range(iotlb_gather, iova, size);
+
+	return ret;
+}
+
 static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
 {
 	return iommu_fwspec_add_ids(dev, args->args, 1);
@@ -2898,6 +2926,7 @@ static struct iommu_ops arm_smmu_ops = {
 		.enable_nesting		= arm_smmu_enable_nesting,
 		.free			= arm_smmu_domain_free,
 		.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
+		.set_dirty_tracking_range = arm_smmu_set_dirty_tracking,
 	}
 };
 
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 3c99028d315a..361410aa836c 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -76,6 +76,7 @@
 #define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
 #define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
 #define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
+#define ARM_LPAE_PTE_DBM_BIT		51
 #define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
 #define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
 #define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
@@ -836,6 +837,56 @@ static int arm_lpae_read_and_clear_dirty(struct io_pgtable_ops *ops,
 				     __arm_lpae_read_and_clear_dirty, dirty);
 }
 
+static int __arm_lpae_set_dirty_modifier(unsigned long iova, size_t size,
+					 arm_lpae_iopte *ptep, void *opaque)
+{
+	bool enabled = *((bool *) opaque);
+	arm_lpae_iopte pte;
+
+	pte = READ_ONCE(*ptep);
+	if (WARN_ON(!pte))
+		return -EINVAL;
+
+	if ((pte & ARM_LPAE_PTE_AP_WRITABLE) == ARM_LPAE_PTE_AP_RDONLY)
+		return -EINVAL;
+
+	if (!(enabled ^ !(pte & ARM_LPAE_PTE_DBM)))
+		return 0;
+
+	pte = enabled ? pte | (ARM_LPAE_PTE_DBM | ARM_LPAE_PTE_AP_RDONLY) :
+		pte & ~(ARM_LPAE_PTE_DBM | ARM_LPAE_PTE_AP_RDONLY);
+
+	WRITE_ONCE(*ptep, pte);
+	return 0;
+}
+
+
+static int arm_lpae_set_dirty_tracking(struct io_pgtable_ops *ops,
+				       unsigned long iova, size_t size,
+				       bool enabled)
+{
+	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
+	struct io_pgtable_cfg *cfg = &data->iop.cfg;
+	arm_lpae_iopte *ptep = data->pgd;
+	int lvl = data->start_level;
+	long iaext = (s64)iova >> cfg->ias;
+
+	if (WARN_ON(!size || (size & cfg->pgsize_bitmap) != size))
+		return -EINVAL;
+
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
+		iaext = ~iaext;
+	if (WARN_ON(iaext))
+		return -EINVAL;
+
+	if (data->iop.fmt != ARM_64_LPAE_S1 &&
+	    data->iop.fmt != ARM_32_LPAE_S1)
+		return -EINVAL;
+
+	return __arm_lpae_iopte_walk(data, iova, size, lvl, ptep,
+				     __arm_lpae_set_dirty_modifier, &enabled);
+}
+
 static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
 {
 	unsigned long granule, page_sizes;
@@ -917,6 +968,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
 		.unmap_pages	= arm_lpae_unmap_pages,
 		.iova_to_phys	= arm_lpae_iova_to_phys,
 		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
+		.set_dirty_tracking   = arm_lpae_set_dirty_tracking,
 	};
 
 	return data;
-- 
2.17.2

