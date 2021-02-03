Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C51A30D29A
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 05:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhBCEWe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 23:22:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55650 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbhBCEU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 23:20:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131OPTO196046;
        Wed, 3 Feb 2021 01:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=K/JC/iwkXinVeXeqOK1vvJXyi9JTK1hUBoMhLH2IIo0=;
 b=IOKTpro4IJ/REGZJeDwn0YGfT7xcSldKUIgaJLU5BT7P7WJkWu3sSvrni0h4ywTi9okP
 x9Rcub+eZkDSAxZ7iP1gG5/j1IG+X04Fk6sHEjBDwYGnfQVKtp9tjX4Iq04kKsD06xmi
 VsYUarx/saDlxcXL/hQV56BsazrIZKTDHV7XMMZTe/OsdCFS4VoEP1VQq3cOGBlNhDDa
 paCaqCNDnwZN1hg7ziI309BmXV3B9gqY6L228zqu6FnNud4BaZwGWeeiIvhmGCa1zw3s
 m9JCbuxvxUD3Tpx1exhejZy+K08q309SfL8YKAssWyLEePezOJPiGr9EvBOAJapSObjJ xA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36dn4wkg5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131QYPk101028;
        Wed, 3 Feb 2021 01:28:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 36dhcxnvvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRQK6sk5WGastNooi3i52iweq5RHLNv2mQAFC11sHuPls1idlBixY+rwWHm4i0xd7fkwuIFGQYOifmlY3jEgzmUaOCXtsApdliucAXCtmeYbBx4Q6D12AE20AX0XyAJrtCNQu8GlF9bhGpyf4df2T05PL2CHy2ZLLkJJ0AFPN9vPgzl6Cla9SKENxFdZ3Gh3WHPtne5BV4QvbW0ID2V95ph5JoIjERKyDB73pOewUgwso/OK+VLxG+D1CSIvulxJyG0LmMffqcTuuUo/Ahk3sMKzRiA2Z71ZppkSlRBfu2H2ctAmlpM/GgDmDHap82frnp/E3ZvmJafN1yoSbxGgdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/JC/iwkXinVeXeqOK1vvJXyi9JTK1hUBoMhLH2IIo0=;
 b=O7vecxrYztrtotmX0vCyZb1eUYBHTn4RPmSV+ynrg1NavmXv0tuCYkhuLuo1R5ReJCz9Khh2U8IoO0TV9dTBM7beK1YbRC09DNpUlRs3hDowx8ymhxNTPC2usAzroznhap4E2h/xx9EFROPOsIKPy4po67VqsIqI4WJyZSGkUMHOEuf2mpae/Dlrygkb41yN1BS/xBQLPk0E7aZYH/tcbyLOLwJn4PIejno21DnzDmDq1Qf0iwSraagqfaRSDh8+FJGMnJJFwshxpAFbiDKigKIUkBVF3YStCYTlYlN8nQmzSQxEDge19cUzprfcA0SHAHWeO2op+bY4yaLt6DSZpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/JC/iwkXinVeXeqOK1vvJXyi9JTK1hUBoMhLH2IIo0=;
 b=z6ZQVNE8Thnbi6E6KsP1ilVs6xbYjj1eNME5WBAT518wM5lkquzGLnH34YICuc/8MKq6SvUZgrOY6sQuX7+wT1YKP3U/ZtZsU+3q+LBvJEt87693QvniGw4oAecDiSpQh9EubUHZv9mU6bVAvMedtTkKpPgVuJgvVKLsyIWKAO0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DS7PR10MB4941.namprd10.prod.outlook.com (2603:10b6:5:38f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Wed, 3 Feb 2021 01:28:37 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba%4]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 01:28:37 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/5 v3] KVM: SVM: Move IOPM_ALLOC_ORDER and MSRPM_ALLOC_ORDER #defines to svm.h
Date:   Tue,  2 Feb 2021 19:40:31 -0500
Message-Id: <20210203004035.101292-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
References: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR05CA0073.namprd05.prod.outlook.com (2603:10b6:a03:332::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 01:28:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f61fe6e-167a-4127-bd08-08d8c7e3079b
X-MS-TrafficTypeDiagnostic: DS7PR10MB4941:
X-Microsoft-Antispam-PRVS: <DS7PR10MB494134FDF91485483186182481B49@DS7PR10MB4941.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/XJCh2OrFxTBXbe/IOHKmbMpfbgPj+34/UTq9b2ZGX6X3WBrFfm4TZOY4bvbohNcnKLN9f0fVJKgLLvYAd+A7ZSnu4+QWqlmMN5sDKo5z+jHdb2jW7fwGMk2MjXDiGMqDwYedHnuGHA25SmP7ZD5JM1MKc5P+dwsoqlO3WlaFNugl/sJJiZUCI0304l6k0qaWFD+qnDfVkSGCAE1bqaM/SDOp7iNlA80bPStdrFi67Y5OiPdNL3eHgw4RtC437hSg99qIdotQWMi/nzttGpV18QAVnEN0MXaPS/uncQFFMyS2RHDu15N62CHU7Qpr861yyZN4SGJOxGkeoCtXM39VO3Kcf1xLcvBmnyA1Hj2EeIrvyEzEUBz5BylRGIOe4XFIo0ftCDTMgwXE6beIPDRpiLMeH8CglC2tgGSsvddclS6moQoQUzOoitKYCVhHBduYeeKuVPsjSRTe6TfUHBq5kFkRwMOdkjTm8sK4ZqNuW8fBHH/NLLTr/rsTLV7bF4MgCbvI9xBjZrB4IXsYezsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39860400002)(396003)(316002)(36756003)(7696005)(6486002)(83380400001)(6666004)(2616005)(8936002)(1076003)(66946007)(2906002)(186003)(4326008)(5660300002)(86362001)(6916009)(66556008)(16526019)(44832011)(956004)(26005)(52116002)(66476007)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4qqYfF1HV0kb789o9P12YKscQmX/rl+woVKlnVonnHF1qLySnSDIhdNGPrrs?=
 =?us-ascii?Q?hyI5SXsf5W29ML34s5E/7N754kJfRYQQDCXtR9bq9K5/e++Gizun6ntvd6Sp?=
 =?us-ascii?Q?RSXVVtz8uGi6sTgeqlKU9/MfUwemty0vW4vU2o3L/ewE6hLPIwB++AF/mlgX?=
 =?us-ascii?Q?AS8AlnfMwWeb7TdFLXBMrp5FCXbo+uQGNDnt22RNqWgtnR28XoecvgFCMpi4?=
 =?us-ascii?Q?3t36HFAXQGJz+6E8GyFPsZ9tYmtaHg4QuNL+8XnUYad+/pj8zUckzsLPPSWS?=
 =?us-ascii?Q?5iOaaLlPIPMzsvs1fuJimokfaH5GFczzKX/9VKEb2I7QmFpn5vgkfQ2hGRHT?=
 =?us-ascii?Q?RVjETYkJdcMpudqA8J0nkHKJ8QHyKVH8JmK578dDMzmC3jUXj+kEj6YbZTWX?=
 =?us-ascii?Q?eUzSjvHkiVoARVnVqeBlVl8+wqYrAe36jwuYq40D9YddSKUdFI2lyyb1ZrPN?=
 =?us-ascii?Q?wgZ9yTpq5FnsVTcYYdpkJFD/AHEItH0a/KrjtZLZGK9cYyIO6o0/PqfEye3B?=
 =?us-ascii?Q?eyj1iljfJB+WqqfQqsydPQV/OjP8I9OsmgVY0Yi7CnWp4LPuYv93l7XLa1WD?=
 =?us-ascii?Q?3ogjVsq4KKUNjm3H6M7It9ztupp9fvqCifBusNHu0PAkk3mZ/nbTO9P5o+Vn?=
 =?us-ascii?Q?mLoYgGwMVBTq2Onv8Y+/nqe461OvLi7AwRAcB+Rf7V1DgGvZb0KyJxPhUbuZ?=
 =?us-ascii?Q?xrMpKgLY2SYnWjpc3ozJMOtvlHE2SR8084rxC6rIZW4IP+lT7Uukb3dv3FoN?=
 =?us-ascii?Q?cgX4mHhu65pmVMRd9RZThNi/iZVzr5RnDGMdMoMJQr3Hz20Q2klki00wyYRF?=
 =?us-ascii?Q?vB02iNZ/sUc5VDeZR5fylLKRAZqwtLcxim/UE/wIBXKGw6NzB8D1psGYfKs5?=
 =?us-ascii?Q?ppGmJNevcFw5UDcjcWabsNHV9HS5W0GNRh0nP7CPtOJngrMaCAAt0dfPW6fR?=
 =?us-ascii?Q?Dwg3oYta2MZZhKYSDNFVPE/kn6kdmhgTeqc+fBwlhjRMubkkpzjcKexur3fm?=
 =?us-ascii?Q?YOu3D5qclbJ2+xKYtQgwRHSFGTgxMKJWQ3qtVA3XxKZLGlfSHBH5ftF9gxO1?=
 =?us-ascii?Q?YDR28Qa7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f61fe6e-167a-4127-bd08-08d8c7e3079b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:28:37.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alZq75si0vrNAYefmY4LmC2QvI0ksiiyvvGXNDejCu1iScLEUT/USXkKhVc6dyhXp2UelGxyLZzkBbckE3wmm2zjx99lf/0mV/tOm4Mcs+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These #defines will be used by nested.c in the next patch. So move these to
svm.h.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 3 ---
 arch/x86/kvm/svm/svm.h | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f923e14e87df..1641cb8ac5dd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -55,9 +55,6 @@ static const struct x86_cpu_id svm_cpu_id[] = {
 MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 #endif
 
-#define IOPM_ALLOC_ORDER 2
-#define MSRPM_ALLOC_ORDER 1
-
 #define SEG_TYPE_LDT 2
 #define SEG_TYPE_BUSY_TSS16 3
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0fe874ae5498..f529a259a03e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -42,6 +42,9 @@ static const struct svm_host_save_msrs {
 };
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
+#define IOPM_ALLOC_ORDER 2
+#define MSRPM_ALLOC_ORDER 1
+
 #define MAX_DIRECT_ACCESS_MSRS	18
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
-- 
2.27.0

