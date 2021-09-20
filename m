Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60EC412A14
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 02:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbhIUAt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 20:49:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11546 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233944AbhIUAr5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 20:47:57 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KM7UvN018139;
        Tue, 21 Sep 2021 00:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=o/mAYhDI9AMydp1tjNZNSp//nnEHzVfDJ4Xbb/bt8MQ=;
 b=KRrtgRsFY9YBRRPlPail1+z737HC1Dws0bf8/dUpmM6vhK1B0SVhh1HvdI1i+gPZIow6
 0obQSck4gWwR4pO00bmy4uyEfgyti8VVkXKluvaJhLuBCAs/AZRIaku9NZAWS7AJLNSS
 3En7U4kkbU6AC4K7eoq63BmqBRZ3NKPqAkcY26h298TvXn2zgmOhU1qwtnNEyJwmAa0n
 GRdYE605b9Bs59LWCgd1W2GobPF6u01xUIkZCVR2pkYvol8915T+TRdtfP7IpmDDWojG
 VEbVd7sUDGsqg+244kpJHxoGBpJEU2EPRlNHRgnsq1WyjVHLqsXcWRQU83hTX77qW0fC vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66j2n5gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18L0fVtL058079;
        Tue, 21 Sep 2021 00:45:49 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by userp3030.oracle.com with ESMTP id 3b557w9vf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIxDaZ6+kQfaHTmOfVoCdKe6JRmeR6JILtvAnB7934YSIxGG0GCpGqotuIeeKlQ+o9Xrem8E/VwSsI01UGI7fsQAYcz3C+DOpbceQ2Ck0VIbz+6sksGWg4DRTRa2bGR+oXn2rJCziOevBcTwnDDuV/ZYN259aqD3+1UmC4W620gU+Hjp9aGZAgeKVUzu1GW1UxVMv6uASougwrm4oNXwzWy1/bhF9QdQRir9qR1yc6DX3wkBO+2Ba6pUqOvgnOy3yt95sXSSXXyWqlHGutbTTNNUn+IG0KkP+fKKeejSW9K0TkkB7Ww7WOJm0sI94nwSNtNk4FpcJtieB3ycOvQuvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=o/mAYhDI9AMydp1tjNZNSp//nnEHzVfDJ4Xbb/bt8MQ=;
 b=IMVxjpzTSIuKzIgTt/u82MUsrDjXWHSQndUMc9fNsbsj/WuYAgLcNYq4nmoa4xLvmafTq0KOrymbVeZbe8O1cqyuQJLHOSrSOJJYhtP8rzbfIK2tionzZ0PPgkr4LTXwnDGmBSHSLzo3jYJRUVlR+1FfyA7CLA6nMmu16fN/COAptbVhVkMupDd5FSFiFY59vLPm/zohcA3YV2s19LUl8EQcVc2cHWtDnfUvWLgxFUYbAzoKsqUCweuTbLthsD4am81XE58mzmjvXP6v63jNCTqVntoOCFf4o3MNwiDUrTg2vUPkRptmXRpH5bzRfd6oYJ9C1Hdqujt/R4gjlx3T8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/mAYhDI9AMydp1tjNZNSp//nnEHzVfDJ4Xbb/bt8MQ=;
 b=XZVCndRY4l6HmACTcxA1c9jS/mCblQc9tmXZflK6+Y9fyARNq2EDAAWfRs6wk3hqbJlkrfPkJJ5+6aiYZpR2npIjoI5klYVnK76i1yPh1pFEY2TbZzz+TGY40Mj6O9Wtu1OxKGkwH1wg8td9oxrjU8tR/TG0aU8rkMBtb3OTBHE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Tue, 21 Sep
 2021 00:45:48 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 00:45:48 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [TEST PATCH 4/5] X86: Add #define for FLUSHBYASID CPUID bit
Date:   Mon, 20 Sep 2021 19:51:33 -0400
Message-Id: <20210920235134.101970-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::15) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR02CA0002.namprd02.prod.outlook.com (2603:10b6:a02:ee::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 00:45:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3683ef48-dd29-44eb-3450-08d97c992747
X-MS-TrafficTypeDiagnostic: SA2PR10MB4426:
X-Microsoft-Antispam-PRVS: <SA2PR10MB442690EC69732133969195EF81A19@SA2PR10MB4426.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwKxsTIgme7pZOcKLBszEZQ7Wkhblc4s7zc5DRQwR5p6Wr8PT/8WF7uivZulHROks9PKcUiTDpvE6o1PWmTbzMnKm0GPdW8QMKdmVhDzvZ7D72hujrFBQDeT/ivkNgdjlv0XV7iQ7ZjmBrpjKD9V6K/IfstMO2u+srt3Hrr6nZYt6Z0wZQqtJs84AmrKh2/pZkE/bxtYUVjuFPAaeIO5c+DUNVp9vSsivCwRUUFnlRSmYX94dzxUE9G1npzR8kYAAylbAxZ+pNNrtxjlPMqOl171Oz7zer7Gscu6JVRWk4ZJV/gK0Tger4uH9CKjY/60e288Gmnco6U3mGg3ZkPy4jQ3vcvs+k4Nj75klZvHvkyNDbpRoIEzSKWm8HZmF7OL/CwDcgCepl+YG36XUN4Tb+XiHrOxufRf8yNmr+BQX8UfMRiPuNT1Yg+UPHe/CphifaoJByT7nxRYqeJfc1QqJMKGdJTpJZQTxx8kWGxD9R+5mjtVnvky5ex7Et1pzQ3ZTd4thSBfcQT/51qMcT9vmFLsY1SJHApXi+YqZ6ktTGAXl1kCbq+IOu9TlQ7eFCUGZKOMKPd8lNzxWt8Heq94cDBdaHz4ibxIGT3trUnGStEO1lnsQ/4UQ+YhW9FlaC/B9D+mkQTa/hJoc/F5OTn39HdAwkZcQU/mY9HD4x1VMQXw4JHPLjKyu1ZixA7e4/lM7kqTX6R4mNxqFd/ak/tOmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(2616005)(5660300002)(2906002)(66946007)(956004)(66476007)(66556008)(6666004)(186003)(26005)(8676002)(7696005)(52116002)(38100700002)(38350700002)(6486002)(478600001)(44832011)(6916009)(86362001)(8936002)(4744005)(4326008)(316002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oRnawmzYjvNUctgMFUP2bY0XNnwddI2dmtZsPAY+Ob73dn5O7n8+GCWJJxUt?=
 =?us-ascii?Q?OOtihsAPz2wBMTBD7pBGBUJxE1cFIk7QwBXQ8MUAKcI7Ak1E6+K6gHAXBf4b?=
 =?us-ascii?Q?JaL4wFOdODonLdXNYR2MOamfSyUgFphAb63B4ltP9jVrx7cJdJZVavkWHQy2?=
 =?us-ascii?Q?gIPBoPWGarm4RZDA8HS8/Pv3c9VoIqhoguO2+DkI+/8RNGyN31VSpFJH02lk?=
 =?us-ascii?Q?pe1GlxsXiM6Osk6zaeQ+qTVRu2fOJ+owdqB3y8U2Z9PmeIJhwvBdJpnZsxPk?=
 =?us-ascii?Q?p5WpVv08eP2TXZWJYdkYPEizbFkAgKb5UFA/inklZVfOkZ43MT93blvWYOEg?=
 =?us-ascii?Q?THFdXjDVHvmAfOZCXIvlWOwpoQFmJeaRZRzsuY59OwOcuIRelWg8wp/x7Fez?=
 =?us-ascii?Q?QbXFbh5zB/W1WTsx0HnR3J2daDxEwF553wZGhy5/b7IXN69laexoqCNnAu0y?=
 =?us-ascii?Q?nQy7Cbw17vSXSv3Iymaz9mY9i4AsLCoow/RvLFh1i6oqrVAgyv6HO3/rpIO/?=
 =?us-ascii?Q?UwT8S4ePrKZ+qdL+b6yKxJBKeYwil9EvhEuzpcRvDUkbdLbm1GN+1j4crIUH?=
 =?us-ascii?Q?Dfr2YpRqTL+XDjA0HlKiGU3id1irEEez+pt3xBZD1NMgzadWSIW+42I4k4PN?=
 =?us-ascii?Q?pNMMRQVHChcRLC94Onf0tmyO6fETsm1VhSnEshlZ1xEGMz7dmnqtJUmskMIe?=
 =?us-ascii?Q?6opFy4kKSd6GDPVSehn8JWr1EsbV+PGEP1y95rGI7vGix3zd9tBx8MbglUdp?=
 =?us-ascii?Q?BcQzU56RQz19mWJ013cz21JS4vH88viDdCUmPI7P56b4Pgkpoy6dYXLh0buU?=
 =?us-ascii?Q?/fnszhkb2Z8p46XaDZngikm1IsxZn2G+b2knQ5biKx7EjBanyTT3vzdpuBRq?=
 =?us-ascii?Q?nSntv5rG7CRJw4WWZJ4T0T9ip95dKL6V/i7gjAjwwtRVgJE89K0OAk/r1CnV?=
 =?us-ascii?Q?vXbF/fAxRph5WUeC/NYs8JBjeNrmxL91itC2d7M461tdw3l3dEWw9oaw/baA?=
 =?us-ascii?Q?y+ZsgXy4eQS4WlsRf0Zls5TILiVSfZyXa+/YsOeJDvgQBGFwCLiMqfjDn5gx?=
 =?us-ascii?Q?zA1Yu5AGWmI4UtEwGhSWtK7bTJU7g3hps4c7E0eC+FWLfZqbsCr2hI+p2P9e?=
 =?us-ascii?Q?MWUB3L6By9AqCio73rXj3bKxdppXXjY8E6OEaDHgGwiEd9zvnb8fulFYeeHt?=
 =?us-ascii?Q?LJkN+8XQPykwSUKhZuSWspocXouAWuDFL3cFl6U0zJSgPU/VeDgOWP+946mG?=
 =?us-ascii?Q?KiW7VMGa0opd1sA3CZNyE0okF7lvvSAfqvEqwqON2pkfbsllUVPxi+1oMCbM?=
 =?us-ascii?Q?xJAenZfEaDAEvKdnMJt9rEz8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3683ef48-dd29-44eb-3450-08d97c992747
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 00:45:48.2672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGGLyuzPvwxBhcz5FoNukjUAby/X9pWpzmllJrxonyxch7gI9CAGXK086t1d+Uj4LyFyrvVb4WI4KITE83C55zDJ7kYpgcUfnBQS/NKXX5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210001
X-Proofpoint-GUID: u7cV9tKlhUbojuB7mkpAR3zuR_X7pORt
X-Proofpoint-ORIG-GUID: u7cV9tKlhUbojuB7mkpAR3zuR_X7pORt
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/processor.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index f380321..9c716de 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -188,6 +188,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_AMD_IBPB		(CPUID(0x80000008, 0, EBX, 12))
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
+#define	X86_FEATURE_FLUSHBYASID		(CPUID(0x8000000A, 0, EDX, 6))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
 
 
-- 
2.27.0

