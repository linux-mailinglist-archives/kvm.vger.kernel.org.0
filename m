Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF43F35206B
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 22:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhDAUJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 16:09:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39176 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbhDAUJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 16:09:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K4TYg169270;
        Thu, 1 Apr 2021 20:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=Gjjnv/rKHcH75xkbOxFp0jfg9u1cY/0TaQa/RVe4HVMeLHeH/g1RckfdNQBCr3HX7uDR
 3LP+mh42141/7O0rNp12xCqHk+8B0OAPhr6KOPy1KlsZJooakNIsdNy+RBMcEx8L1Hxc
 IpbR6urSOBL9zB6PEvo3o80QdS8hIIymAeEllglcc8joDtpIfVS8SPV7p1xc6ZAqoQ7/
 9FYtAdQUAf1d2Coltctua7HxzqixRHfpgyTBsqb3q4Tj1V6ZFNQu53N3dIHkkqJ7GgGE
 n4Afm7nYoXTBkNUPt3HNPB8AzsRNdGz7a+gCAwLEqUBIExwQuVSCMrxJL9vxP1mId3e0 vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37n2akk3c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K0x0f178319;
        Thu, 1 Apr 2021 20:09:28 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        by aserp3020.oracle.com with ESMTP id 37n2abq9vg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBY27q1KutrQdi+u016F/8R4sdmmTnsqW4G7jOYmp9glzZzpWDMznNYWNQZnsJekexT4UwuXCfI/92/IqERdjF1SrFu+Ibsx2Ul/R9q432/0TcnWa/fU0F2mFCESFh1S0CJ3cGbfWgIg6ZdAwrbABnfD+WQExeR8co7Ta4S5nY/PcwrUlveSlU5+qr5uNEWZetSDCGaaVJ2LN7lByMGixZWV709TDraDIHkz9dDOt5QUkkOquPOC2MrYr8RNmEuKEiZY2BNlHXWdT0tqvJdS0Zz+8tux73LqihfZiE0+Qz1YguFSytU4EVdK94kfnad2/klPciwaAKPq2fbMcT1Rjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=gnP0EGb5TaEWYd7MxHlfxhjC/qIjlkApyCFvVWagIg1I8WjgxJuBHlBenL3RL8DPGf9wyXysVGvt6l76zpO7EeaSnP/H/Y+H+Y6xRdbZXFdwCxh1+wwGPd2be/CXwFzu+4tMetpN1Aq7BeeKuVA8t3LTK6utFEa0whMQtzG1D626IGVh2wzvoF/2Had9WUD8MJHTh7XxO/fslUxoSYVDn1ZkMJ/++GcKtuEYLbxc47WHku89upLV8i+JT6t6ImogT66tRpX6odC32dOtV/nuXEiYViCDp0GRET3d5qVBUNDBl38t28QprtxEBBG5cvJobNMnElGniS7fJ9QA3l5GBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=GW8nQ+pr+FYmjwyaO9GfsmG7xdTBdZvfKd4pbdx0EEg28lsLquwx1b/W2gv1+6RrnstZB+7yVFMxzLlazp16hai4bh3whnWppC0pq7PQKRpb+ibyQQeRlD+8lJ5luOyqyyHqtPX+13a2VK3q4yP2pcMYF5o8mUUqlG41tAFOE40=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM5PR1001MB2091.namprd10.prod.outlook.com (2603:10b6:4:2c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.33; Thu, 1 Apr 2021 20:09:27 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b%3]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 20:09:27 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 5/5 v5] SVM: Use ALIGN macro when aligning 'io_bitmap_area'
Date:   Thu,  1 Apr 2021 15:20:33 -0400
Message-Id: <20210401192033.91150-6-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
References: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:a03:114::25) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR21CA0015.namprd21.prod.outlook.com (2603:10b6:a03:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.0 via Frontend Transport; Thu, 1 Apr 2021 20:09:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5848a9b2-670f-482b-fb34-08d8f54a0d15
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2091:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB20914EEAD035D9A2A2F7C985817B9@DM5PR1001MB2091.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbfrVX54BzM8ply+sGFdr4dURgCQigsha4E4H7KG0rHZTaABnHBP6zDBlKX4/IrbFXR/Fji3QkMBS6DRxqmpUx9eDgVQDabaViVF0Ixto8DBD7sxosboUyao1bL88W8s6xAvE4/KSx4nibAVT/CPeyVgS/C69yJyoHpQpXkHD6OHskE2ubwciHJtDnrBsawEflM+oFCajTAiA9K1sNy6l8UEOS68jsrU+uo8f57kGUh3Y9TkEBIh+Ea6UQ7gr3foRgbUJQhROiaai2I2xTubqpQ7e448qyFnd2HFNE3tY0uuFLG07RIW5mXluTd0ag+lKOZkCMCVcbu5SnLWeYjNRR4CIy1H0u3CrgU9JKym4jlF40KZxjLKjDHNZgXfiIq5eM/HXum6YLpP3qP0jVjCxpHQpCc/B08I4ORw61XgC+lgdzIwcjhDsgQCKGWkMCGi41KVYbJfVAjfGGCC1KOhvjdM58fWosIOeR7wigMdvjFuOCO/0qy4/fyoZul5gqeHz4NN9uJiV+FBN89WJmoBYtbFbBHv+ZhQnDBh6cmtJZHyLUKwaZH+t7RMANIbwmLDkovhpLDoYLcwRaJ/p6drCcGWtq2SV7XbYp8JZ3/iwvjPDG8RnyRWRDHpTC7JNdoQQHwtUVH2MuMAglzQcDq6sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(66476007)(86362001)(2616005)(66946007)(4326008)(2906002)(186003)(6486002)(6666004)(36756003)(316002)(38100700001)(8936002)(7696005)(478600001)(5660300002)(4744005)(8676002)(16526019)(66556008)(83380400001)(6916009)(44832011)(956004)(26005)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bweeXKdlE4JIeOnfV3vZahrarS1HcFx0GbHVl9KKZUwQp4ois6m+BQ6+i7z9?=
 =?us-ascii?Q?YgeVqXvxS3XFflfQF+NwaHqS8KCrTm40cRSIIgLkQXJ4m3Y6fxgChIAgcHi8?=
 =?us-ascii?Q?I7KV1/Z9tWzc+4swKn2DC4Kmm4tEb3Syb4ft0viDtPjtYyHSUlxdB6fQUvC8?=
 =?us-ascii?Q?czHWPcfGRhKFSrD6NY5n7+4s3ISwSi64u0SKHzeEtBFEpkMrnYxxwS4Gowat?=
 =?us-ascii?Q?geQqoWsmBbkr9vqX9f5DuC7fptIzTNO7wTBfDu2poGPTg4As7xPV3eXMQmOv?=
 =?us-ascii?Q?UQ/M7N8qFWgIq/gdFuXtxL4cX6VaODnlfq57jYjkG2ra7DpiJnb9T6AnU8rb?=
 =?us-ascii?Q?LjP8kjwKMkGsqRV7Z8u3U9j3mGfAsSAEk9XzTu4Kb2cLDnUK66Nga8X6/cSd?=
 =?us-ascii?Q?Iv1AmWb4IPCg+ceJ9xmsi87EFlADnQWCtZjnk4VVyaOoNYKnhgmkWJLyYbyU?=
 =?us-ascii?Q?5k9M4IDzThkkJZ8A6IfIttl+4PHXwUdgdfGxvxFt24I6vayGkbwcSifOTDVd?=
 =?us-ascii?Q?Nw94JYgsip9tllIRqo0kVWPOpSwCe3nkdGgyMPTNTAOPner0o6hWWEDFkYuy?=
 =?us-ascii?Q?r6IN0aT/0VD3qGQm8BN+wxkILxVc5+DzNs3LcTbt1I1rLExtEBUCrJL+d1V/?=
 =?us-ascii?Q?dNYQhf8kignTfFzurqrUiSIGvzYbJTQgVveEdIuuDcD/oYIdmCte6KwSKdXy?=
 =?us-ascii?Q?mqYhX0bWiweYTGQ+L0Fxej+gTaJ5m85agm7d824bX1ar8A5rFuCVkhqY7WcX?=
 =?us-ascii?Q?uXdahEsV0p4XyARB2NAghjDtuMEEnJOqyNO+Tc46PZOFC94X9aAvHWXlzFiJ?=
 =?us-ascii?Q?HFz74HL2x3QE362hrmrnpbi42ldemxZUKnTOxSx3miU/ioHfOfzMUi/d6/Ae?=
 =?us-ascii?Q?Ir6UAx0MsEXrT+LD2ugqhE6E/t4SaLargn+c7+sv/ZhElEWjZlnylQ9sebA+?=
 =?us-ascii?Q?kr4b2DCZtwiQJuLmSzmVutJamnZwm1a86Con/jOjlqTrSeYyDrU9yXhF5S90?=
 =?us-ascii?Q?rMNIQKwwaXGRba/E1MZ9lRfNHodvx2N6WiiOMdqBDyh9kyFVr2OLSCxgSZeK?=
 =?us-ascii?Q?1XVUSzTU9A/H9JNqeGF888o+CRD61n7LtlUgX9M2sLAWJQUIMJ2XY7EOJIXw?=
 =?us-ascii?Q?hKyrlT15NT+gKsp8OjHWqzLO+WLYYQZzI+a5WRW9BcPMD6f67HTfenFEFrmy?=
 =?us-ascii?Q?FmGrHBgZhWIK3PQh6ipP8xtrs/vwU+L+3BuHFsLnJ+8LQML/aBIiB1v+a1ye?=
 =?us-ascii?Q?lK9+QDigLwBV/B6htPrAo1sxA6ZFv2HNJbvpYFXZFNNlxZbQgNGFBMkKvMV+?=
 =?us-ascii?Q?V02r8JA5MhVUCKXZWwtvILlz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5848a9b2-670f-482b-fb34-08d8f54a0d15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 20:09:27.1413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jy7KpfXm7rn+d9JzkEa7VvIETC6+gqFhgf3uC6IDO8CFhr8MtkCNAGO0EftYElDf/LOF9Y6iGzKKEDTxGaKS+CoxzEwAOphBEQgwIi6zZ/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010128
X-Proofpoint-ORIG-GUID: z4aYFItOdXP01rZ-SOfEGwnpOu_bCWW6
X-Proofpoint-GUID: z4aYFItOdXP01rZ-SOfEGwnpOu_bCWW6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the macro is available and we already use it for MSR bitmap table, use
it for aligning IO bitmap table also.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index a1808c7..846cf2a 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -298,7 +298,7 @@ static void setup_svm(void)
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX);
 
-	io_bitmap = (void *) (((ulong)io_bitmap_area + 4095) & ~4095);
+	io_bitmap = (void *) ALIGN((ulong)io_bitmap_area, PAGE_SIZE);
 
 	msr_bitmap = (void *) ALIGN((ulong)msr_bitmap_area, PAGE_SIZE);
 
-- 
2.27.0

