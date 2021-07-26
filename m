Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E463D66F8
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 20:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhGZSNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:13:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3630 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231921AbhGZSM6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 14:12:58 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QIlAAj007156;
        Mon, 26 Jul 2021 18:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=R2cwvFH36zsCvG2mXz0m2oYQVVBfKLJtAUePXtvu26E=;
 b=DvurOprklpxnrojWIJpwp6wWs/nKH8GQHfPWqj1MCcLyjzfd60UTFyQG5syvexzhfRd8
 vnMbtl1PQTIkig6+d3+CJU53N/X7tPGGwB3oNw2g659+I6Z5OgbVujN7Y9rr01G9j6me
 QnuDRt01HQ36I8vO/JtQpHJPoUC0svRrKEGusSNZdh3FlLDt6cCxL5oAhbAf6pkPJLjF
 FKnxzlcQNMYhpTHPG54w15Tcm0kwKosK1vCEh709h2mFpEy7vVuw7pFidfgQLe9iq9HZ
 WujhrKsE07M9r81pvRWL0GFx+dDoiRKKWFqm9cp6NIpN/5BpOqsXpWWUPaJEqLNyf0Rd nA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=R2cwvFH36zsCvG2mXz0m2oYQVVBfKLJtAUePXtvu26E=;
 b=K2cDVGkhloCFoSQMKVyo1fGijH6Ck8v9JL9UMWYEMolRslWhHDs2M0yx4UxT1q6WPQyy
 n7nYjxpQJv+CS3GUIKq/nUcAPh5FfCbNOvnLdMREu8i0V+Rjzkud7JhfYF8RK/hu1nEZ
 MVRvQLmfRGwwtZrQCGhqejnkTZcHVG05Zr5bO16epQUV2R6Cx6G72eWeuGcnD0Zibrzc
 MAexcGWmIiGUlSMDTENs3C72caRTQajGQbdRV16KTidlfzt48ROeirYoYvAvyix2IleS
 gigY/17PYp9U3IzeZUfmrmehc/JWjm503MP4X2Gw2AyPtWRstzLzjSnaDlG4wKT4waR8 hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a1up6s6ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:52:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QIonRs066815;
        Mon, 26 Jul 2021 18:52:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3a07yw1y6s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:52:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFIS9LU4f2gBtgRtfjOr91aGcn465M1md0CGtYPQDCfLoWe7UyC9YHuYw32txDEtQrYs5xjjOgSNKEOYksAq/rFD3CiSmjFejgEORG3M/SclRNi/yPZRXgFh2si4wz6dbY89O9Sg27YRMGYKrJ8o3CnpArTf9c3/Fvq4+DT0/n1L5Fk6d0Nl5Fx2lHUjkEeQl4gPUKQB+ej1LOfGQe9aTI0dxbgGQREIkXdVLqhck4NM/LcgvuUz1ux3srqjaXX/R22mkJPKdqYRXkhi+IfwX08gjs99uMEhsbDh5O++iheMNY/kpyal9a20QsdZ28eninXZ3Haj7B2/eenREFxD3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2cwvFH36zsCvG2mXz0m2oYQVVBfKLJtAUePXtvu26E=;
 b=B7C9QfjYOhLwht63iGJzCRLTHihGii3tiDJgVdRUPrPoh2+tP14onv5W6gP7/GACBKmhLygzjHhKKedfq/w48SrKzPebFvnns9wtoueNTEyaUO73O6GnysBPglSG+rRe2k9VxIphv2KMOtsW2PtQBOkGCGXZRDJ+x92zSinuSTIcGCRWdyg6tQQpWVGrscVmRcpmjc1XB8wtdBm/6FdQhSZCUgf36+VjOHbuF/wmc5lSOMSqnVImnJxI8iwFUiBOm/0PPayxvKwXhH1wj8yMZ/oLFM39lPuLT86Il6u4JXRoS5kVbfemwfhgXsHPQKILJKv0ovHZ99tVrLdV++AdQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2cwvFH36zsCvG2mXz0m2oYQVVBfKLJtAUePXtvu26E=;
 b=oXDboYl8BwpuR5howHFnIIy5noJig5foC4hnCAwXh2MO11Rvgjhg9u2Aasyk4ESD9hiHCsao2DMV6qH4ElIucP0kL+nGW8OfJi3kvfB0AdIvp3VaO3ow80lbMdYroX/OIxTOmNAc1Xp9BjUsjme8O3/NWS1nxJHMWX7E2wCXXfY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2765.namprd10.prod.outlook.com (2603:10b6:805:41::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 18:52:45 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 18:52:45 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        thomas.lendacky@amd.com
Subject: [PATCH 1/3] Test: x86: Move setter/getter for Debug registers to common library
Date:   Mon, 26 Jul 2021 14:02:24 -0400
Message-Id: <20210726180226.253738-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
References: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:1d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Mon, 26 Jul 2021 18:52:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78c4996e-129b-475a-7bb1-08d950668e6a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2765:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2765C6213A2BD7780DD2A60381E89@SN6PR10MB2765.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9dkN7EcLbdXND2GAHPyrELOxlq/Z7QRuy5HosuBrMldeppnbHcH2khP/yVUJ14MI78MF2Wt1OMT0sRs7gRctbz2zNYBSPpkFMiYycZfaqnAqUrmRYFjgvq1Rp5o0xKtdzpAFrZLDzSziHsozE4VVc+wL8Qez8kXrSI6Zc6pAIYao+aawzWpZxLC27tVt8HT0nXPTcwq2fy+YMbGepsNfM87U3vwsLBqHi60F1JrZhOGR8Qn8m5P8pbP0J8m5G5eZAxP7NtIjChr6OFfirqAjPghbXMAjfgOdhrI/s8YFqBu2gQb3w91gBVElCyWAHmIjrqDQ8o4Tdzbtf6aU60z9imEcIoKrzBPjHQCZjQIMHq21pSAJt1DZUSaOR/9nM4n6tc9fHQee2UmI+uhzL6tQCdE3jxATLB/MJV/WrFvBB43LrRpUGJ9tHSTcCW/QLtOY5who0YPKS35txXPCGgV7v6Hw10EjfAD//4lIVefL0QqaGVavWwlKsx60hJ73yPE0il2MwsGY2eyTmtI2pg/2XMs5RvT83q9yAesuxZJbma1pX6D7c079j/PwOMvXSSG8yK2iN7c4kZCEXQgyd8BtmEHDyJFkyEYMTtbnlZiVuqUOYeIaCw+1VaPFo+/l4T+p4vAjVuDJWEhzz6tlXTtP1quL9nK1UhHOkhEatjX/Ipc9+EkYhaxYc2J5xGBGcvv3On7dx5EsL9KKOQ87NYhbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(86362001)(8676002)(26005)(316002)(956004)(66946007)(66556008)(66476007)(2616005)(478600001)(4326008)(186003)(2906002)(83380400001)(7696005)(52116002)(36756003)(8936002)(6666004)(6916009)(44832011)(38100700002)(38350700002)(6486002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?50gEhchKC3p8a09VwvWEpTZsUvWFPzTSRtKoh5fIbkITCpuo63d7UyX9oaow?=
 =?us-ascii?Q?e6eNc8pfmDXnVQaky6moiIWJAKR3p3N5RfGoQR8PgCoZ3akqQUf4enFXl7eQ?=
 =?us-ascii?Q?XrBGEtNCqdTn0vrL2/DfahCwAslPIJbNoFNKo1L6k6G7d0PeFNGBJwoQjMTN?=
 =?us-ascii?Q?p7ZNiakQFFw/nlMSbNwGfLJ0iUdWpZUpWomeV4Q0H0OZHGt/1NBzmLjZBD0B?=
 =?us-ascii?Q?N7u2lVcqqI7JNvWWncFx0FLydAIeVe5y8bhT4oCtgD1Aax2kjKuJ8YsSdvP2?=
 =?us-ascii?Q?4t2N8vv3a+UzJUJfuq8A+dy7LvOY84a+MMRQX7nWFjuvt9U6n724SLZuAnQx?=
 =?us-ascii?Q?bEA82+/BSSDf16/nRUUDxjfEBQgMX6/lUi83Kx8RuxDyjIOOeE3Nqjzc8dE1?=
 =?us-ascii?Q?YNUeGLCIQ7uSsq5n2K6EFi1zXA43Dd0Z5ax7OIAIE50WYqRCrVi0UYhpRYDv?=
 =?us-ascii?Q?uCFkUaqJTO+Q497TP+FXZs4hFZSs5eqx1O7mYTT5qC7Ok9OYdAhxDn54ysv4?=
 =?us-ascii?Q?ih9NDs0cZgVzCuIFpN2fFTXcvW6mnu12e6oGd7B8F/9Can3ywgCxN5PpY3x/?=
 =?us-ascii?Q?wpXlankJkrsBZzmR0ykYmV4HB1i3F8hKNxwyxsrVIa6njqoYCEezV06GtKAa?=
 =?us-ascii?Q?950WJH24sjdZUzaHFY8hrtpM2o/+RXZqPbq8ZGpwGuVQGu5JU4lo6ttsUYUT?=
 =?us-ascii?Q?jysvjEbP5yvwJcOqlrK6EVh+p8RcUUdEMAONq6DOOPVNXyW/4yUTOi73JSJb?=
 =?us-ascii?Q?LYgpN4fvfI9EuDThdpsB9OtehwoWM2i0cbS8srHrv7hZQFzY0CDdQ4E6ieVW?=
 =?us-ascii?Q?WgjfHR+nlAm74FMjpqTZDzT5GsvVo7ocK4e7mNMGEosGbPcjtP5UBGB3JvVh?=
 =?us-ascii?Q?YVMtmKu7sQmCMug33Oe2S67/cTQrkqkYFnKdMslzYyfX+7HJkbQBMVe6PotT?=
 =?us-ascii?Q?/Y38tMwvXbm2LpFz8AZWDVIg2qJKkJSKhML/6aASkTsNcILPoFnGJgDJF0Mh?=
 =?us-ascii?Q?xwocAVKb64Oww/1nhQKPggYzhlOZj9fQhY+vva+JQy/ugnFdL1oaojuk30KX?=
 =?us-ascii?Q?PC6YFvCeTbTzxRM8PI6BfMJTbjMJezWjVJNw5+idTRmi8ocalps3QCgk9K8i?=
 =?us-ascii?Q?zdLwBh4v7BprynwDql1GrkAQl3a2hFKkLAvFj+qSlWYNQzTudMdTPdHLTfgm?=
 =?us-ascii?Q?2z2FCzz9NV5tqZvaeOaEBfpBsReB31DSHDQsWea2LcyLurWMbzDtrraVVsRu?=
 =?us-ascii?Q?Hd7zdjPMkeRy0GY6hJgDmfE71O6CEDBIlViQZL/VGpzE3Qqc6Sn2tRqPQ70d?=
 =?us-ascii?Q?D/BT+2OXetmW4MX5fxOU8mTz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c4996e-129b-475a-7bb1-08d950668e6a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 18:52:45.7794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxFBOUhszDI2ZE3qJuEux9yY1atkqYixYLDiqLkKRXaZYSg7k20ZOm980HE4jDahS14RQtFD10Jx7vrvq3bCVA4vWzi7sIPo+JSa9f+ik/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2765
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260110
X-Proofpoint-GUID: iBn-4HfwfWkaoqramaA3jj-LQuUqcVWM
X-Proofpoint-ORIG-GUID: iBn-4HfwfWkaoqramaA3jj-LQuUqcVWM
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The setter/getter functions for the DR0..DR4 registers exist in debug.c
test and hence they can not be re-used by other tests. Therefore, move
them to the common library.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/processor.h | 32 ++++++++++++++++++
 x86/debug.c         | 79 +++++++++++----------------------------------
 2 files changed, 51 insertions(+), 60 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 173520f..ec2e508 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -470,6 +470,38 @@ static inline u16 str(void)
     return val;
 }
 
+static inline void write_dr0(void *val)
+{
+    asm volatile ("mov %0, %%dr0" : : "r"(val) : "memory");
+}
+
+static inline void write_dr1(void *val)
+{
+    asm volatile ("mov %0, %%dr1" : : "r"(val) : "memory");
+}
+
+static inline void write_dr2(void *val)
+{
+    asm volatile ("mov %0, %%dr2" : : "r"(val) : "memory");
+}
+
+static inline void write_dr3(void *val)
+{
+    asm volatile ("mov %0, %%dr3" : : "r"(val) : "memory");
+}
+
+static inline void write_dr4(ulong val)
+{
+    asm volatile ("mov %0, %%dr4" : : "r"(val) : "memory");
+}
+
+static inline ulong read_dr4(void)
+{
+    ulong val;
+    asm volatile ("mov %%dr4, %0" : "=r"(val));
+    return val;
+}
+
 static inline void write_dr6(ulong val)
 {
     asm volatile ("mov %0, %%dr6" : : "r"(val) : "memory");
diff --git a/x86/debug.c b/x86/debug.c
index 382fdde..6b3ff4e 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -18,58 +18,17 @@ static volatile unsigned long db_addr[10], dr6[10];
 static volatile unsigned int n;
 static volatile unsigned long value;
 
-static unsigned long get_dr4(void)
-{
-	unsigned long value;
-
-	asm volatile("mov %%dr4, %0" : "=r" (value));
-	return value;
-}
-
-static unsigned long get_dr6(void)
-{
-	unsigned long value;
-
-	asm volatile("mov %%dr6,%0" : "=r" (value));
-	return value;
-}
-
-static void set_dr0(void *value)
-{
-	asm volatile("mov %0,%%dr0" : : "r" (value));
-}
-
-static void set_dr1(void *value)
-{
-	asm volatile("mov %0,%%dr1" : : "r" (value));
-}
-
-static void set_dr4(unsigned long value)
-{
-	asm volatile("mov %0,%%dr4" : : "r" (value));
-}
-
-static void set_dr6(unsigned long value)
-{
-	asm volatile("mov %0,%%dr6" : : "r" (value));
-}
-
-static void set_dr7(unsigned long value)
-{
-	asm volatile("mov %0,%%dr7" : : "r" (value));
-}
-
 static void handle_db(struct ex_regs *regs)
 {
 	db_addr[n] = regs->rip;
-	dr6[n] = get_dr6();
+	dr6[n] = read_dr6();
 
 	if (dr6[n] & 0x1)
 		regs->rflags |= (1 << 16);
 
 	if (++n >= 10) {
 		regs->rflags &= ~(1 << 8);
-		set_dr7(0x00000400);
+		write_dr7(0x00000400);
 	}
 }
 
@@ -105,15 +64,15 @@ int main(int ac, char **av)
 	got_ud = 0;
 	cr4 = read_cr4();
 	write_cr4(cr4 & ~X86_CR4_DE);
-	set_dr4(0);
-	set_dr6(0xffff4ff2);
-	report(get_dr4() == 0xffff4ff2 && !got_ud, "reading DR4 with CR4.DE == 0");
+	write_dr4(0);
+	write_dr6(0xffff4ff2);
+	report(read_dr4() == 0xffff4ff2 && !got_ud, "reading DR4 with CR4.DE == 0");
 
 	cr4 = read_cr4();
 	write_cr4(cr4 | X86_CR4_DE);
-	get_dr4();
+	read_dr4();
 	report(got_ud, "reading DR4 with CR4.DE == 1");
-	set_dr6(0);
+	write_dr6(0);
 
 	extern unsigned char sw_bp;
 	asm volatile("int3; sw_bp:");
@@ -121,8 +80,8 @@ int main(int ac, char **av)
 
 	n = 0;
 	extern unsigned char hw_bp1;
-	set_dr0(&hw_bp1);
-	set_dr7(0x00000402);
+	write_dr0(&hw_bp1);
+	write_dr7(0x00000402);
 	asm volatile("hw_bp1: nop");
 	report(n == 1 &&
 	       db_addr[0] == ((unsigned long)&hw_bp1) && dr6[0] == 0xffff0ff1,
@@ -130,15 +89,15 @@ int main(int ac, char **av)
 
 	n = 0;
 	extern unsigned char hw_bp2;
-	set_dr0(&hw_bp2);
-	set_dr6(0x00004002);
+	write_dr0(&hw_bp2);
+	write_dr6(0x00004002);
 	asm volatile("hw_bp2: nop");
 	report(n == 1 &&
 	       db_addr[0] == ((unsigned long)&hw_bp2) && dr6[0] == 0xffff4ff1,
 	       "hw breakpoint (test that dr6.BS is not cleared)");
 
 	n = 0;
-	set_dr6(0);
+	write_dr6(0);
 	asm volatile(
 		"pushf\n\t"
 		"pop %%rax\n\t"
@@ -161,7 +120,7 @@ int main(int ac, char **av)
 	 * emulated. Test that single stepping works on emulated instructions.
 	 */
 	n = 0;
-	set_dr6(0);
+	write_dr6(0);
 	asm volatile(
 		"pushf\n\t"
 		"pop %%rax\n\t"
@@ -188,8 +147,8 @@ int main(int ac, char **av)
 	       "single step emulated instructions");
 
 	n = 0;
-	set_dr1((void *)&value);
-	set_dr7(0x00d0040a); // 4-byte write
+	write_dr1((void *)&value);
+	write_dr7(0x00d0040a); // 4-byte write
 
 	extern unsigned char hw_wp1;
 	asm volatile(
@@ -201,7 +160,7 @@ int main(int ac, char **av)
 	       "hw watchpoint (test that dr6.BS is not cleared)");
 
 	n = 0;
-	set_dr6(0);
+	write_dr6(0);
 
 	extern unsigned char hw_wp2;
 	asm volatile(
@@ -213,16 +172,16 @@ int main(int ac, char **av)
 	       "hw watchpoint (test that dr6.BS is not set)");
 
 	n = 0;
-	set_dr6(0);
+	write_dr6(0);
 	extern unsigned char sw_icebp;
 	asm volatile(".byte 0xf1; sw_icebp:");
 	report(n == 1 &&
 	       db_addr[0] == (unsigned long)&sw_icebp && dr6[0] == 0xffff0ff0,
 	       "icebp");
 
-	set_dr7(0x400);
+	write_dr7(0x400);
 	value = KERNEL_DS;
-	set_dr7(0x00f0040a); // 4-byte read or write
+	write_dr7(0x00f0040a); // 4-byte read or write
 
 	/*
 	 * Each invocation of the handler should shift n by 1 and set bit 0 to 1.
-- 
2.27.0

