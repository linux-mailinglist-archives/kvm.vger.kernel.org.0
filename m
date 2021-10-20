Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DC34350E3
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhJTRHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:07:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13384 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhJTRHp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:07:45 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KGAxTv000812;
        Wed, 20 Oct 2021 17:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=5e3m7RFk0g13enMURwPEocpGyUnHDjiZAEp5AA8VXa0=;
 b=YYQhUBNXSSjcaoKbV+ss2MrHtVkkYBWohcodIX4fAvqOaJfcTKemTJ7SztlanoauRGaj
 ZVkUN/SBNLkweDu+7ovtojBdFN9rkbHvt+2tgC7fZnmW25k87QY6lWfIe/bA7I1yawDH
 S12bIHixMYtrBELsfiRyRBVYsWBhmEpLLF4DunH7XfcgWkSrEp/GhzENGMBin0NL2E65
 1c+KGyQZkjIoGdd+Xz3PopYCqgu5zHJK53VzU9emz5tgP70kVbA44qghJKzd4hYdSFNa
 kc1QKvgmJBYhGeZSHL8AQUwg6atGWz6HOTi2EmsaGRBctIYm1Z+mAxs3KmPGmKlrKoF5 Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4scbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KGtYCU104288;
        Wed, 20 Oct 2021 17:05:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3020.oracle.com with ESMTP id 3br8gug6x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLHjb8tfft54e+C/E6ZY0dEPZaNJYiRk2JtNygmHzt6Od1EmQnzpLzmydCGwLo8ULmRN4GQ/OOzmE5zT4wX8hWoRYMUqyWfv8QXV2MyYjg4Ptx7dzD78k07vkcePSE4kXcIq51SNOtfZmuFTNvgXxVZFZoFdhtFJycpd+7lzZ29eDcmTV6k6Exn0dRuCoPjUmset2fv64gdxrDRRxMOKT1bmDzV+NNJb74hF1sGvSBblwibeBtIqfx8cBwUM1EVVLtTOUM4F9ATQ5cmjrW3HCbVRAdsLWYq/TSnbbYnJnxWt15GRbDbRbTbm6fa4HIESVhGbW8+nabEATTPhEJei7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5e3m7RFk0g13enMURwPEocpGyUnHDjiZAEp5AA8VXa0=;
 b=QOHB2kF88BZxHPw1k6laBKBXxKbBDuYFLEllU6QvimpIFK9RViNsrmTDeT2j3dMujOhefm6XUdgD4vcZftlUGf634hUb4lmh+UP03diW0nOVTXf9ROE2Vg/VU4grQ0wToMBf15hF2mwaKuY4u2XXpFh5yto57oiw884139XQqdWIXTPls2m2dJjpyHI7gRcORD7ipHZ6z/U8/2UhGlrz3n2rptzi395cb0ledTSgdCgxM7t97xrBSwNYoQahzL7XaHujQ5ZUCvExj/eJt9aKGj3aK6uyDzXMay/iQ1VSfVa5O0WVds7lGO9Fe5VsuQlbfnG+VjMSuzqt2m5v7vVbVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e3m7RFk0g13enMURwPEocpGyUnHDjiZAEp5AA8VXa0=;
 b=gYOLZiBd4yqGcF01yppXfdgtAnccMFzLW9FK3RfJcMY3pUu6UHI3zceVXf8NnF7cRw3yRaM07VbbUX+WTy/C9wczXEXClCvAYZA3Qd7yX/Uq+PDEXqhO+mci8gkV7P+IF+YwV9E45x8xCkSCqI6SopI7Elqo+bRnQL5hLOdZQIg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4484.namprd10.prod.outlook.com (2603:10b6:303:90::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:21 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:21 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 03/14] x86/asm: add uncached page clearing
Date:   Wed, 20 Oct 2021 10:02:54 -0700
Message-Id: <20211020170305.376118-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:302:1::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MW2PR2101CA0011.namprd21.prod.outlook.com (2603:10b6:302:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.1 via Frontend Transport; Wed, 20 Oct 2021 17:05:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 819273ee-24d4-4308-d690-08d993ebcca7
X-MS-TrafficTypeDiagnostic: CO1PR10MB4484:
X-Microsoft-Antispam-PRVS: <CO1PR10MB448440A4268DDDCE23B528B8CEBE9@CO1PR10MB4484.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BRer0C9+nvrTRI+Rj36XjQzAwHt/K/gmtLuwP6Mspq5VZ4k4RL7woWlfkMeV?=
 =?us-ascii?Q?OB38s7dcy+AlyPuYkDlrXbwIvysmsUybgRxnuqfcdEcdwTX+yJXrixcOUdSZ?=
 =?us-ascii?Q?eS6TZ+umGlVxq6Rrxl855D+OrXhF2xzeA1uMefV0kut0Qm2w8Fe49tQSzJkF?=
 =?us-ascii?Q?Aaz1iXSeB/nKBQiOdT7H0jG7oZXLxttqlPb+FNqkNJY1KQu/2S3b2EcfAcA0?=
 =?us-ascii?Q?5K1PAtykI8E2QkAyht8jBL/Bi7ADVT2YSgfqe1C4Y3+pEgvUqMv/KjLXtjaq?=
 =?us-ascii?Q?njB9xS2xpsiswfnbXt3f1YV4XmXlQYxbWcOllF5rS4O/joFz2+YS5xZh5jGK?=
 =?us-ascii?Q?plcTC+B1mrMU4hogvXr2g7jPVNm8N25IuHOUQvtFlzct2NSkW3mkpkqpVxxj?=
 =?us-ascii?Q?pkzpEB5pCg8e2+h7euBEW2VKkwT/z8w60o2r4Y7TpnrTDN5rJqia7zzIoUuF?=
 =?us-ascii?Q?hybX7gMNG1z9TtIDeeuciGZeH6r1o8L5DyoWt/5r5GjzFW9fvxAQhXyn72bM?=
 =?us-ascii?Q?Zu4H+JTsBiL0R7ShnGil3L3yGKo8I0FnXgUSvGImMIYd9gFyQlOqOa7SDKtm?=
 =?us-ascii?Q?XLMfplUDpj6lZdAxG2dKTr5OUYX2ovQFYq4O4H1pga04em1zBEjMlZNvtocD?=
 =?us-ascii?Q?/xUHBuar3lmPltxpU84nEN/9rJkm/Nm0wo765FlRPPb7iTldJUQgou8hRSEP?=
 =?us-ascii?Q?w7K32eiCLTdJ5n12gd/qE0QD2pMIVVrEmbpPpejP1JzzRhZGrs4sXaDA0n05?=
 =?us-ascii?Q?69ms9qBU+tBcz+H/lySvAsRFDObhW5NXKqKn/SSJifsBrWx9UMaDQTSy0rUG?=
 =?us-ascii?Q?HetyzcEGW125J21YHoDLtMCt3It09wSzeXQgIrknE7tLzxLABgA7m1v3y/ux?=
 =?us-ascii?Q?8EnHKmvGgl+rtMeezsbQI+zcTSZ7ZwKkoZjzGaQO8t08zRSvBT8xFDHfqsX5?=
 =?us-ascii?Q?MZEXYuFLmh3kcA0EPoBK8ZbKXojLgalbn/q36MY2A+QGdR+dIZM6ddECyPca?=
 =?us-ascii?Q?+mBmvO54vlu8ocJPCQpHFnDWiw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(8676002)(6496006)(508600001)(4326008)(8936002)(2616005)(38100700002)(1076003)(66556008)(38350700002)(6486002)(6666004)(103116003)(5660300002)(956004)(316002)(26005)(107886003)(2906002)(66476007)(86362001)(52116002)(66946007)(186003)(83380400001)(36756003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ytnfARfC8dPpI8TugRfO6UMAirx66//oV0JHL6rS5rhe7Y0JkDcrIoChGly?=
 =?us-ascii?Q?VJ2q+0qLpSbxxbqYlyF3ERfA+4Y4+ys4THr1+KvyzxpH03dQvnDT/WDICBst?=
 =?us-ascii?Q?7KF5fols0Yv0vbMxIhi2IVR28T+sq3pT2sjFqXb26mJxAkenEayjq4pND48H?=
 =?us-ascii?Q?PwsVcoBQIhfPm/kznrGYbq5hjWVMoqYEoeCfNh6SLdWgwBtJrxXpVwDpSDqz?=
 =?us-ascii?Q?5mfKWWl/At3z+5FCT2/ZqpOKNpq2saPmeXSbtxKwB/uYdnrCF1Cx23F+/gQx?=
 =?us-ascii?Q?isfJ4IbYuiCYA1HsVLGya2BIH6ucRUz1HYaB1ypWrSF6U7pkOajX3y2Kjyv/?=
 =?us-ascii?Q?hzuUegZfChtb0phg8jxQ6XmfHWfZbVajqmAbGB6c58pT4LRsU7eV/o0/V4Z7?=
 =?us-ascii?Q?9+8v9+GImJ+V9cMKrcKRwAsJGM6jO+kXsOgOBosnqdtSh2V9g1biIWZ8cMSW?=
 =?us-ascii?Q?DLqf2LuQBTWIBKJejzWHUVgeRsMMzmk6ap7W8Kkcl3TjNvnohAj71nNhDH+W?=
 =?us-ascii?Q?Q8kiNGc0RUGkjwaJVkt7comC0UeuP5iKah/iYK73q1N9k4mN11isHqZO71UB?=
 =?us-ascii?Q?Od4X8q2eZXjO8RlV7YYxCzkhOemArdbNwDEQGXZVw9B1Kzi/TVcwahzdMS1I?=
 =?us-ascii?Q?0NwAziAm2ni0A0jJwE66apZ6Adi9klaGyhJWg1cHNxIR6HtvgS+ceFn4JAq3?=
 =?us-ascii?Q?cexbuiB9kHgVjtgXfLlbmRM5O008pYPbsFKMW0bBFwtABj0mo/FsdDYWU3fx?=
 =?us-ascii?Q?nvnkC35yVZu/Y1LQzX3SoM68cdBtXA1ENsDcl4kgGHfZWoF3ujpCLqWrvT5r?=
 =?us-ascii?Q?mpn8Qa4eXC7i3OilRrYJKXXYO3c/YTcETc1Awpa9/2nfQOMzzBRp2XO3vyXv?=
 =?us-ascii?Q?SoP6V1dYt1XGrqWe42dcOe3K5llFJC7lZ+xpveasH1RY+bvnuzXwcQGhl+5J?=
 =?us-ascii?Q?tFCrmYZZ6EYq+XMF1aLLOZjCxMZ93AMPerhcPuY41joU0QU5PhxAlL6L9lpK?=
 =?us-ascii?Q?wk6xRzmUFCmRimtqcFxoQ7SnVXN7uzAOokl1/kRR2+ZtZ6Avi9/Z4XTRJJQW?=
 =?us-ascii?Q?s7Dkt13bAOO97nJUkjodP8Mj2j3KUPQRrM9zpMY9DPItSQ3+V3xuc06Fec5t?=
 =?us-ascii?Q?o4VUp9dOFPu+qZ+ui/6pAgx5w+2Kz0lr9C2BCMxfLiSpnTXpa71z9sarT344?=
 =?us-ascii?Q?AwsAYIY1j5CjvxN1+od9jhBzDIzlzE3VBMTNmTvhG/D73WxRlxQUgoqKQ5p4?=
 =?us-ascii?Q?/MjwIBidrJD5WqRI56sofKMKO08TKwKienZ22XIog+OJAnf8cskVqirM4m+U?=
 =?us-ascii?Q?r/Ly3qLTWTpzLvxMGskUU28ANTCsSIdUIYJR4UwR5QidKN8aaiKDWDIvTt5g?=
 =?us-ascii?Q?W5Jbdu2tIFAcQooeuriw/Ur20q5m6jFAzN3hL9p9UBtEq0qpee6k5b4uKIO2?=
 =?us-ascii?Q?yCrsmay3Tx+0ScjslsDn14NPxzV0PjCK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 819273ee-24d4-4308-d690-08d993ebcca7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:21.2453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200095
X-Proofpoint-GUID: bQY9z3vYS46VaB6t7UnpnmOGe2cde42v
X-Proofpoint-ORIG-GUID: bQY9z3vYS46VaB6t7UnpnmOGe2cde42v
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add clear_page_movnt(), which uses MOVNTI as the underlying primitive.
MOVNTI skips the memory hierarchy, so this provides a non cache-polluting
implementation of clear_page().

MOVNTI, from the Intel SDM, Volume 2B, 4-101:
 "The non-temporal hint is implemented by using a write combining (WC)
  memory type protocol when writing the data to memory. Using this
  protocol, the processor does not write the data into the cache
  hierarchy, nor does it fetch the corresponding cache line from memory
  into the cache hierarchy."

The AMD Arch Manual has something similar to say as well.

One use-case is to handle zeroing large extents where this can help by
not needlessly bring in cache-lines that would never get accessed.
Also, often clear_page_movnt() based clearing is faster once extent
sizes are O(LLC-size).

As the excerpt notes, MOVNTI is weakly ordered with respect to other
instructions operating on the memory hierarchy. This needs to be
handled by the caller by executing an SFENCE when done.

The implementation is fairly straight-forward. We unroll the inner loop
to keep it similar to memset_movnti(), so we can use that to gauge the
clear_page_movnt() performance via perf bench mem memset.

 # Intel Icelake-X
 # Performance comparison of 'perf bench mem memset -l 1' for x86-64-stosb
 # (X86_FEATURE_ERMS) and x86-64-movnt:

 System:      Oracle X9-2 (2 nodes * 32 cores * 2 threads)
 Processor:   Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Icelake-X)
 Memory:      512 GB evenly split between nodes
 LLC-size:    48MB for each node (32-cores * 2-threads)
 no_turbo: 1, Microcode: 0xd0001e0, scaling-governor: performance

              x86-64-stosb (5 runs)     x86-64-movnt (5 runs)      diff
              ----------------------    ---------------------      -------
     size            BW   (   stdev)          BW   (   stdev)

      2MB      14.37 GB/s ( +- 1.55)     12.59 GB/s ( +- 1.20)     -12.38%
     16MB      16.93 GB/s ( +- 2.61)     15.91 GB/s ( +- 2.74)      -6.02%
    128MB      12.12 GB/s ( +- 1.06)     22.33 GB/s ( +- 1.84)     +84.24%
   1024MB      12.12 GB/s ( +- 0.02)     23.92 GB/s ( +- 0.14)     +97.35%
   4096MB      12.08 GB/s ( +- 0.02)     23.98 GB/s ( +- 0.18)     +98.50%

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/page_64.h |  1 +
 arch/x86/lib/clear_page_64.S   | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 4bde0dc66100..cfb95069cf9e 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -43,6 +43,7 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 void clear_page_orig(void *page);
 void clear_page_rep(void *page);
 void clear_page_erms(void *page);
+void clear_page_movnt(void *page);
 
 static inline void clear_page(void *page)
 {
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index c4c7dd115953..578f40db0716 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -50,3 +50,29 @@ SYM_FUNC_START(clear_page_erms)
 	ret
 SYM_FUNC_END(clear_page_erms)
 EXPORT_SYMBOL_GPL(clear_page_erms)
+
+/*
+ * Zero a page.
+ * %rdi - page
+ *
+ * Caller needs to issue a sfence at the end.
+ */
+SYM_FUNC_START(clear_page_movnt)
+	xorl	%eax,%eax
+	movl	$4096,%ecx
+
+	.p2align 4
+.Lstart:
+        movnti  %rax, 0x00(%rdi)
+        movnti  %rax, 0x08(%rdi)
+        movnti  %rax, 0x10(%rdi)
+        movnti  %rax, 0x18(%rdi)
+        movnti  %rax, 0x20(%rdi)
+        movnti  %rax, 0x28(%rdi)
+        movnti  %rax, 0x30(%rdi)
+        movnti  %rax, 0x38(%rdi)
+        addq    $0x40, %rdi
+        subl    $0x40, %ecx
+        ja      .Lstart
+	ret
+SYM_FUNC_END(clear_page_movnt)
-- 
2.29.2

