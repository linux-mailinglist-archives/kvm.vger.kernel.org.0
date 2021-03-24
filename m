Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB54E3480C2
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 19:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbhCXSjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 14:39:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbhCXSis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 14:38:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIPba9047435;
        Wed, 24 Mar 2021 18:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ovKKeLIITNnOyf7sYV7ejNLNQPh7Qh+PcU7ZNzLbbR4=;
 b=ROVeNDiMxBbMZPDtLIWfujOxX1OGdIwF+LaEaBerhAx55Dlq78M+5qXtSBSrVnkPMglP
 +BZFfkU8cHeS9WGXyzwii5r0blkXmohuwGRi6GLVEm9aocVDDWYXBYk4Ah2ER9Jxe3Oj
 SowmjDv8NamwzDyuB5XqbEmwgGvtosS1RUYXnP6DyVsBvR5YmA2QlH9Kjblfd3eKQk2l
 MiANHRxhHwxYgsv+FYFOUZ98HHDomJYqmgL4pDbApKcqpA2zDyM1hKxhBqcOFUThgagm
 D3VHtV/KmENqaLI7WEJlz2ck49yENApDhKwR2p9hDKJ4OsZZTbrlr3Z1HJIB6C8uh0oS 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mktnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIQFYJ167607;
        Wed, 24 Mar 2021 18:38:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 37dtttpj5x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZVNV7PECT23hhKAItgpOLUZ+WczJ6Zgrt4wVpTRxU0cr5LUIRXY5PxWSKfZRTZACl8U5CQwTcxpan1PBLmhvRuaLDX6wI0ezuyTofuf6Kh4uD+UUNVQutqZsFA6uAk5LBY7lncIt542yTJWWFgl0sXyaV4wQ4LzEhaIz/yF17aPGCYbBQuZ85yo7gl7wmw0E71P2+B4ZzSJM3x8oWPINyW1pJNFr+E+GioTPJS+bjC5qQsg9D5MEun1hfgCXTTJudDTZPi5c7jqHybaGIrbJP/yurFxLuxcjtlBDoIoJSymUWdBrPS5OcDpigYr6/JLThv2AMVWPl0DyduV7Pex8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovKKeLIITNnOyf7sYV7ejNLNQPh7Qh+PcU7ZNzLbbR4=;
 b=hiEKPEBRe4Vhcikd1xI9NIAj8sO/BUUerrHDY0ijQkAYPaTeoqnCdVi/nC1cTuUvgQYb8x8UrhNTlXSP/vTjX+KqWdVqalrk4/nW/mZaz9lVpzIoc/Epoq73KIBArlr4NYtW8wP0NQ/ZRUWFFX8pau06feFeXKN4szi3JtHHTElOI4SdR8n4nShX40g7O/2hfAU5sSjr2bgJjT6mSU57/OlgA8cIPEZnsMsua0GR90CnZehcLNM949kikGejpAumKve3i6uFucASTsh32cBsNO8mLpKF7R2uEeZfYSJ11p16SJESMYOSd2zDD3aFEqR2iv0BK3k9/KPOWizRbY82vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovKKeLIITNnOyf7sYV7ejNLNQPh7Qh+PcU7ZNzLbbR4=;
 b=MZ+wIi3sNi0qbgFYYdFnRYljWfc922zvU1q6mU0QlXkmApXrVIVDAKJ8GVZAVj/b3KZRMpw6zQP6dkh/Y5NWOwrIDa8QBKrv6oIp7Uks/x9jqaLJUQpBUeVV5ZQc72K0IoJWFVHyJa7baEW0J4axIsYbc4um1gMzNBsvnhcnM70=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 18:38:42 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Wed, 24 Mar 2021
 18:38:42 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/5 v4] KVM: SVM: Move IOPM_ALLOC_ORDER and MSRPM_ALLOC_ORDER #defines to svm.h
Date:   Wed, 24 Mar 2021 13:50:02 -0400
Message-Id: <20210324175006.75054-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
References: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:c0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Wed, 24 Mar 2021 18:38:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fe74b40-3715-4ee5-38aa-08d8eef40c54
X-MS-TrafficTypeDiagnostic: SA2PR10MB4665:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4665D614EB1AAE5160DFDA5981639@SA2PR10MB4665.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5VSKIaVyoOfClAgEn+jaf65a9qO/MC1aNoYrUiJiueG+WbFJ3xjaJtnfWA1VfsucmyFrW94JvbERcHN8ZezaXDPmK+AUL5I+CcARDGF0hyV0kBzvFr04vL45Al79dkK7QOcjdVv1arGU0uj3dknzmHBKdGQy1QbsuUEYBpT/X4QZjQWWKcmc4JW8yzdZkPYtEmOe/gN3+7MyMtOgETgdlIOnMVizzBUwdA3rTmEYusVp1ZKoIwmWJw/gmYFQWzWzD1vJ7Gaikkt7BUfXleKdXmculWIfPLk/iiwZETrUwm/rM4a3OThsEDrVoHu0AQvmUiptGKZSd3cFVg1XO+E6TXBrQYV5KNh/Nl9Eto5zxPGFVXeqULP4O5NcD+44QDS3Qu9wcF1KE+R+lbubUhSwWNkd/g1ZK2WmVE2C3K1djHcYOFVN4XMtMIOHHw9ORxXHxHqZpbDzWFA9Ufddb5F0M1oLN/SbtTDfzqz9HPZJHRY1jeK8EGA/HqD1n6wr+wkwmH/VnikK/7Su7lTeq8zl5MJ7SU4n+87rJI3drlEVhBfixt/LxnryCkCMX4gzlQku4T3ctmd+Ym9C7wt6Yh/6bmOHARq2X6r63yGgNuY3d5GtAo0Dqwsrah5Ihff1euKY4v0RyMuroAyLUQ7MM4qxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(66946007)(6486002)(36756003)(16526019)(186003)(478600001)(6666004)(956004)(1076003)(6916009)(2616005)(8676002)(38100700001)(4326008)(83380400001)(44832011)(316002)(66476007)(66556008)(5660300002)(2906002)(7696005)(52116002)(8936002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zrdPEycOCvUJ1M6TgcI+Rfn5vK3odD9tRwiexNUGMr/vg3kcyN6OfCqWuXL2?=
 =?us-ascii?Q?E/Mmhwamad5oWpG2XAQ3WMecWgsNNZyhuUaa7azPDCk0Hx7Vujr4mj89Rc+8?=
 =?us-ascii?Q?HRfFwcD65bXVngxzuPYDcWWTOTNYv1U4dtcpxC5LqDLiTXydj3fPt/ubBMCl?=
 =?us-ascii?Q?MF30mRvkXOHb7UPCWa/LonCfbroREBgbyuApJUIjbbXKtTOv/YTzw4LxTbxL?=
 =?us-ascii?Q?VmqR0YzVuI4fjnq7GxJbmLRXt/FDFCxdZ/q8CqR1tIM0jgqAMwcVGhUswHhA?=
 =?us-ascii?Q?l6Y2r5hzUPowauVJ3TKc7Rv9OJxG6bklZY8CNqeyU/3subvGuxnAhBwBm/Yq?=
 =?us-ascii?Q?Tf9N2Lmvbl7cBFt6T5OHHjKuIT6vWJR2nSrcfJIdQbhu1cxwE5PGxMuzwAcN?=
 =?us-ascii?Q?doFwlthmX1q1vuH4RKV2+V20wn3szGnTbEd2nOV2Q/VyaBZ3/9vMAXMiRH9H?=
 =?us-ascii?Q?wKE0m5LYnDFhOVwpuU8eZR7qqkagEg8XJquLwIpnEOz51ZCr99OCehtlG6z/?=
 =?us-ascii?Q?F/qI4QrC/ncrdHZY+MCACFB42SKDtz/8RyZlJudTWD+KI3QuoUlKjQAAu34a?=
 =?us-ascii?Q?T6Bkol6b0JJsIbWFRNum642Z2G62OACvrQiq/d0XadI4+3nhHhRDIiMmFjfH?=
 =?us-ascii?Q?b8K2Zqj5JNcp8JJ9POCJy33kmbDlIRP4iYTxjXgH6gBdhIBk9oM6Yjtvx8bn?=
 =?us-ascii?Q?cv4wcSjGTuD7TsYOVsWHfF0UtGdANHRrSb4gTMID6aIpxkEYml/Iu1cweTJq?=
 =?us-ascii?Q?whKXyI2FS7aF4/sWYIVcaUzP/78OsfEcmdSphTzUzSJFtHQit8MmdG0Gpp1R?=
 =?us-ascii?Q?b+do3OlHvz9ANaKDnvDxc/c3Po57pLO+DnaIBzprHvVUkzrByXKwEKQUxJXA?=
 =?us-ascii?Q?EWDxP9cQ38Ph9Hzdtopqamov/TcdXdnHcrzaqc1qwUET9m2IoCenutZLyfx0?=
 =?us-ascii?Q?tvmGJiGylSu7vmTkGG2F+HraVOvoSdo8eeFu1EFAP+b+KLQNZ/RtEsSyuYgU?=
 =?us-ascii?Q?J/MeziQ4mFST2YrDmjtTzvh2ZaFTSMuKstRqEnddAOLeJcf1m26L82kh3tl2?=
 =?us-ascii?Q?ckwkHeKLReUMxH+FFIIpNe8aFfyzEFsVZ89ZG98stCr5iNmxzPYm+71STyPM?=
 =?us-ascii?Q?aFZ2LokJOlOZHzJXuyqQR9KHXzmUZFCAo7szob4vatukPs4iowiGBcqVhLub?=
 =?us-ascii?Q?UlU8BT4oqkaYpNmNvMIEnwzDhAedLMm8iKbPJR2Fk2G3GBhlQbSojqd2NFyV?=
 =?us-ascii?Q?+OAG6bMHcePXPYR1jCl1SXDZTg01L8XfeRTwwDSrSMBBMiq8UbGkPawZcWYC?=
 =?us-ascii?Q?5GN5A9HEhH+0cxEdCy9lBufc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe74b40-3715-4ee5-38aa-08d8eef40c54
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 18:38:42.0861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1sItQcec1iiMDgZlSY0Xt4Kb3bkBbIgeIOEZhSVVsi2nDGy2pcN48LlGoszy5XS5Dgl8TvPRH1g9Sm9HCPtkM/zMoblmwItiJ1LsIsAbJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
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
index 58a45bb139f8..a3d8699e70d6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -56,9 +56,6 @@ static const struct x86_cpu_id svm_cpu_id[] = {
 MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 #endif
 
-#define IOPM_ALLOC_ORDER 2
-#define MSRPM_ALLOC_ORDER 1
-
 #define SEG_TYPE_LDT 2
 #define SEG_TYPE_BUSY_TSS16 3
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..ae0a629b3ec6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -28,6 +28,9 @@ static const u32 host_save_user_msrs[] = {
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

