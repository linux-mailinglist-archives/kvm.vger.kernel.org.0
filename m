Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4FE726978
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjFGTII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjFGTIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:08:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D504D19BB;
        Wed,  7 Jun 2023 12:08:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357Eld0H002221;
        Wed, 7 Jun 2023 19:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=amLanG+wAGneUDD/UNJ5ywYeuDXcV6daXAu3+ff+5m8=;
 b=kFewRn/GdVvrh4jOfw09+Cm/zbWBj2C+wj4MFEHi7GHZpQgDgerIMcvV8nxWD6ghg6zL
 OZ3aEjrKc0tswYKrfCrX7m+9sFHjykoUdmj5N321waqyGU/0ONo+UXo7hUhbeS2kcycY
 +cSSwcnRbGNEwueV8ZKNx+dm+004Zni07dPd4zSks2IDSCsx9gkPY+ee83Mm5SiuEcVW
 JxdbBqFZLSMjRs2JN/CK97oMg/Cx4UBMCyhOQQxuKy9dbjA2MhK5hxjoIGB0+eMdo1B6
 RbPjP4srIctSUZhfRvHJp8uVQWY+vz4GSIY1/o1+47QeJvSS0QotDq3PBGAuNCcOKGCU VA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6u2j25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jun 2023 19:08:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357HnRfO002925;
        Wed, 7 Jun 2023 19:08:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6kp2eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jun 2023 19:08:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ju+o3uj8xbQ1G62Ao3chnCsgS/fVKc+bsYuj0h2TtCP8vNAzG0HO9+6gGqoZH2WgiL3QjObNlCAleO/oTIl0E451PyAr4xIY8XDZR7tRSpuRg9h0B6iYvQgfMGeQLuDgLV8lcOBTY1wkaoicoRuhy48LhIOBFNMnn77MoNv8DV9tiDRlMxiZDC1YmpIEorB9OpC3sRcIPsritEoj94nkzER43S62UPlFbyJDTgkSk+KJv0/L1fP+3I4ogsjLzasyZp6FawTe1htIRfxzPprhmH9FF2Fx7Qmv4UT3pgE7rCkqLV5aTTQC1hzr4LezpXm4ThWV7Y8VtQrUY5NEu521qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amLanG+wAGneUDD/UNJ5ywYeuDXcV6daXAu3+ff+5m8=;
 b=NoPGTrghoeNs6ccBKHExY4aCrJW6UsLvwRl7E2hvW59ZgdLPyn1EyaHyx2S09ZWg9/phLxMpGPSrmuWTYjPKwD26SrAOcmu9vVISmXJU01xuWW9aiOYrU/iZEZNZjUGyH+XAw6K1XGxj7eWoHpuXaLUhuVwAEtiI+Q518x/zR0EI2UxKHb29P+FXzdvTCDkA5WyIN6nw5Qr9ZzOw+e1wgGzHzfVwmFhnfVt0O01R9eKdb6RmGAAqeBJSB/5QB3muGJBb/XJYoFyMB5LbkjfesZUjzarjcDpbc8dUN5HwjiW55UjJ0kl/9UKa7EHkrG4koYDKRI2DlArLwIRuFJhX1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amLanG+wAGneUDD/UNJ5ywYeuDXcV6daXAu3+ff+5m8=;
 b=JmZ1uJFvoaIpzV4bvJh9ezwpWcEJQRmCFDm9EuteMMT2Qr+jDughfpW8H7R1tHVYagXkIJ83pbfPZZ3xu9Q0gRL9aXUiRnmYMot9t/MwG88nbrj2YalGYRrIQlbvy3ZFA2lzIRRlbY+MuGpMRIqqU0ihkKNAHMNhufeYuAw38bg=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by MN6PR10MB7468.namprd10.prod.outlook.com (2603:10b6:208:47b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 19:07:58 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::d9c0:689a:147b:ced5]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::d9c0:689a:147b:ced5%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 19:07:58 +0000
From:   Sidhartha Kumar <sidhartha.kumar@oracle.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com
Cc:     khalid.aziz@oracle.com,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH] vfio/iommu_type1: acquire iommu lock in vfio_iommu_type1_release()
Date:   Wed,  7 Jun 2023 12:07:52 -0700
Message-Id: <20230607190752.216801-1-sidhartha.kumar@oracle.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::7) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|MN6PR10MB7468:EE_
X-MS-Office365-Filtering-Correlation-Id: 528e30ad-34bb-44ec-e2b3-08db678a81d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0TAvEUB8mPwXvEbcvDrpvAf+y8dSeh4poUEqYulkjgQ3h6GYqMIxOyO/8YmNHL0pcTPEEJPo1h2LrubVlWO9RXAnK8UXaPhoUI/8qifxD0C3vVemYU7f4O195KorMm12z7X3JsMXL6gvqBB1gJOsMSur5AHli36Ih0Ky15xyI+jJvYXqz+EXy/qHtaw/wXAnYcWzGw8n0ilERJlv6xDJNqoDkffSol4u5kVn5axJWeRhkDBPk6mqbsI80QZSA4ARyYdrbocIRdfJAen1bD00TLPmjjzCzkHuNhbfcnfeYtk7SmsPIDG5ESLbiTDzwPwc6UZNzzojG81PZIZtrt/pJFFoKEbZMRzoQcIAy25q50yr5EmD1ZcTUTvvWWnSCNOqldGm+6n2WBW4nCUivisdLtfyFv1f1O002slHzssXstl9t2ozZue7fzpp7xf82rbZrjtEcDrBGYNzJuQG3cYiN/IvfDOQug92ipNC7+Vbdt0BTs3fPlEJxwc1Ta9VNnQd7FD3wMKuhV3Hrd9Bjc1BDriwFaa+ph7ZMO5juftVNiW/i20Cg8uCFLorFfGEy08f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199021)(2906002)(83380400001)(2616005)(36756003)(86362001)(38100700002)(6486002)(41300700001)(6666004)(5660300002)(316002)(107886003)(8676002)(8936002)(478600001)(66556008)(66946007)(66476007)(4326008)(6512007)(6506007)(1076003)(186003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zidr9j+t7sraT/piJYob8DF6P6n7U77N+y9UgYGcQ8NhCVAt05LompnIhc8V?=
 =?us-ascii?Q?bRdslzFTq6cmzoC61/PQ26G4L9y3T5AG9odlwg0SLtYpmOFX9LEGKYQpB+Sy?=
 =?us-ascii?Q?6NjB8Ze6CXBeIWsVj5HK8PxIRhj5J6GQSF92tlOW/r6GUEM59DAt7hMQosYO?=
 =?us-ascii?Q?KHB+IHKgcK8FQbQ1a7HyWXOu3jLEz8OVwtx7aw82P/T6mvZXeYwbZnabqEbN?=
 =?us-ascii?Q?bjKtrbknyHozjSraDy6BMheDTlcUBeGaj+vzR5mzI0dKMbGNp2T3xt1Qy8Hc?=
 =?us-ascii?Q?V2Hu4Zw6tnh9EMnlFkufun+OfMWaH1qyyWUEauYxGu+so/D7nGrgYhs3vDHj?=
 =?us-ascii?Q?b3dmRva8odSFLxg9DGrN1D177njuFWlcSFk25/sQ3aJgC8CypUWcnPj7tIiw?=
 =?us-ascii?Q?RfaldGR9HB8PBmhagHaenTfJRrUP/MIQX8l/te2RAF7V1QOFGt76H2VL6JG6?=
 =?us-ascii?Q?BuQrKmW36O0B8yazykmgH/Q21qkIq4XJxQDY1LGBBJC1R9JI+v3vnwiH29iH?=
 =?us-ascii?Q?XNX7PHr1T+LUrkYY0sbUBxlme1yth7fIoyf5jwh0BT2zE1JYOTdtZ/TUZNdF?=
 =?us-ascii?Q?EW//vKQHWw2uOb3UW+j4Cyy+bTP1bW040Ab0rTz1yXgmFdN5J1uay/a1UWoM?=
 =?us-ascii?Q?rIMkBA0om/MfHv9dU1zScd18JoXo1RDQCjwxcxYK5Ceh8Ci7OvmTqFnS9b+M?=
 =?us-ascii?Q?SfZi3GaQSaXH+hf6zYIPssd6lH5pOktJSAkfWKYmUDPB1LmTRNdsMJbnaD+N?=
 =?us-ascii?Q?7c8pGGPhnv2gUO1kKcAsaQ8LRyA8HpALdtDeV1P9OA7E0irzHyaGij5HmvqY?=
 =?us-ascii?Q?ccoWL9Ug/+4OBU0xbpxeN8POJMzyxMcmBLP1Y3GXvunC0F4Affqv5goqr/At?=
 =?us-ascii?Q?7cK3CX4THpVoYBruBn/yQnifNBzUn48OXvif/2HJxfuWLUnCoXp5qTgdHYmK?=
 =?us-ascii?Q?ssPeoeDskRQ741jarWeQqwbuAclFYZpVkxRN4xBD9Kg9GJA2QHxsc3oRPa8H?=
 =?us-ascii?Q?bzqQPA//xOyfrCLxKUK4YY9ukaIt3qi0QcZY7Jnyowt4MrJ8N8NhFYA776Gm?=
 =?us-ascii?Q?jotTtLVCwPLZ5/saGkAJ7dDMQ7GWeYIoaejdpc4Ropo42uDkN3kGxZx7PkVg?=
 =?us-ascii?Q?bYZcq2ub+9uI2RvKqrigtgqJcogLZMLjfn/bRuUurBbKNnhBAZplSXzJOKVd?=
 =?us-ascii?Q?d6nZ5YHUhBovf41WAO1DZavPdkKr3c04mjTFhLB+nsNyQAsoZOXumWTrPo3X?=
 =?us-ascii?Q?0R0CRVNZYoQfPyo8V9Za1aietqeblbWM0NwXqFbsMfeq/ivxyfTmo755v4z/?=
 =?us-ascii?Q?H1BgwGFPC+R8JNPx61Gx/qtDQEDEekxkBMWRD/0Mt1btHaCYqm213A6IJ3g7?=
 =?us-ascii?Q?11Ybjezkkm1LQlzxbWgWZQhViGrq6DJtAUgaAhUReseRL4ebQmKSp3zq//7k?=
 =?us-ascii?Q?PTp3MI9c2TDBT7EdQJ9kmlXl/fVhyVESfaiz2EAAGY3a2BiwfnU1674Xr6iJ?=
 =?us-ascii?Q?ghLMvxAMd/jTuIVJpBKVtB0RdGn7ivpNvAQMyLjowIyqMIge+nWukcMtNtcR?=
 =?us-ascii?Q?eYO3HnZMuPj0DM4nIuz2NpJ0Fjo0FtUQRC+EjNZH+vgJbCjQPW3mPo1fYeER?=
 =?us-ascii?Q?/qTYNoDdAIdcp2z0XFX5PmM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4MzjQ4FOHHtIvoCq70Y4jHiEXkG7zkNchdn4Pi/Rw80x6/Ri6siN9BECD8mpJ4mwkggpOvYz0YKsdDv4nEjCs2pf3UQbFQWcJNTk1av/PUtZBnfI30AV+OfCFeuvC5tWiuw0Z8Un/QyHhP+mpRj1kvmaX48QCkxspREL2BtNw8hrcFqKr8yNsSbilNPyuQkLzoIqg4aokpjK5Kb+NQbvVsvIQKCFxbE1tdmfulapUBgfEVLv700m/0FxIH8qzw3AQgm1jo9pqVKmvQZiINyMxExuXjCU9AcpLUw8Wa5YgPF8yLS4f4KAs27htHQ6Y064VxJLFJjR74W5F9fcOARV1nxyFpgByPQvtcR9YTOzLZzp6gy5zQXHwQ2kefRl3ARuYF6VBCO4vj2VBltP5W7xDRRBIaP7wVfn8DgwKimfQcSrVm85zb/UtcVTS81/TuRiTIqFpKcbqpJSp1+3lHaC1MuUFoqEV1DdkRtNgSCmaXD1nX97nA6uSZ38O8tLCXmr8vz5Q8ytEtU+xA9ligT5/ZJ8FvHimB/O9mGrJcJRQhB5FJ+88eXvYYQzoTfmGS1SKGkR84fq62gbjfWb8sfnZcu21Vt9M7CloGZY1NfDPOUilK9sdL6w1aQanKZrkbSLAyJAfcnsNqylQ/CSinWyFSVtFtRxOWxloPTKC/7ln+EmfXWUE4JysQMrKua3Rh/w2TSbNmA9NCk+KHwbvjM8lbb3kTTRasnCUz3oOf3Nrnmo9HX3E0UcldjvArXvVK7t0EKu7wmWBHP+LbbfEnBFObUdDI6urNN9kx9Ux1bKTOg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528e30ad-34bb-44ec-e2b3-08db678a81d1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 19:07:58.5726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AobQkVoZbVPlwPNsT7WxZUGzPgM5wsU1ZJT/2rQ4tePPFvScAakDNLkyqOQ1YzysJK6ai3EGMBmxixeDTM7wJSncB/6RZD7lyG3nSPk97ZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7468
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_10,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306070165
X-Proofpoint-GUID: I316xnDsL3eRMMC0aOQfa3UXw_arI8dh
X-Proofpoint-ORIG-GUID: I316xnDsL3eRMMC0aOQfa3UXw_arI8dh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From vfio_iommu_type1_release() there is a code path:

vfio_iommu_unmap_unpin_all()
 vfio_remove_dma()
    vfio_unmap_unpin()
      unmap_unpin_slow()
        vfio_unpin_pages_remote()
          vfio_find_vpfn()

This path is taken without acquiring the iommu lock so it could lead to
a race condition in the traversal of the pfn_list rb tree. The lack of
the iommu lock in vfio_iommu_type1_release() was confirmed by adding a

WARN_ON(!mutex_is_locked(&iommu->lock))

which was reported in dmesg. Fix this potential race by adding a iommu
lock and release in vfio_iommu_type1_release().

Suggested-by: Khalid Aziz <khalid.aziz@oracle.com>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 306e6f1d1c70e..7d2fea1b483dc 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2601,7 +2601,9 @@ static void vfio_iommu_type1_release(void *iommu_data)
 		kfree(group);
 	}
 
+	mutex_lock(&iommu->lock);
 	vfio_iommu_unmap_unpin_all(iommu);
+	mutex_unlock(&iommu->lock);
 
 	list_for_each_entry_safe(domain, domain_tmp,
 				 &iommu->domain_list, next) {
-- 
2.40.1

