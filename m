Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1476C412A0E
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 02:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhIUAtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 20:49:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54722 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhIUArj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 20:47:39 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KM70Um018157;
        Tue, 21 Sep 2021 00:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0fi7IHX5c3D9IODpEptTKcUKHaYHTK/x3npWuO0hE38=;
 b=PyiHieYiYAc1PFwSKzKKqTOaAz96m//tURhC07L09MuAaLapg+7Z2Betz1a+NiV9K+zd
 rGzhxw9XFqeaB3DKspqPsGrMvj6s4nesD9THTltGz4aOXSQ/+2+Srp/R+AM0w1h9ftTT
 YadMAKGpky5mOABdzJXfWL6VBpu93oahvsCVMXXo1E11Ethow2K/i3sgzEz/UyJ3bCAm
 wJGGbXCWybUfWDcRty2ApYxn5OudU2aSk6VOX/nwTd5clN0ptSzWhmPXkGWMTG5E58Ga
 PQHGM80z3/yID+7lFsVhOwnHuzTz9G5TZsZTOHgsxE5Cj+J218Cu8lZXRyeku8LfZFAH kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66j2n5ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18L0etY9023812;
        Tue, 21 Sep 2021 00:45:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by aserp3030.oracle.com with ESMTP id 3b565db8ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRMkjcZ23WsWIPIx1lDXUFjgPPgsO6M/zitZ8HGS165X7uMkLN2pRT4vXmaycgxblc2GT/s5gsS407F4P9NpEJ/NQzCouvquH9jPu5OiBVqgxqLbB3rRlBhEZ4O90JjLWzAzrSf+exi6GFA/q5fLmJqDFZBWBFxjxhiRh5xFEAQ2XAQStqKgTXkXQ2vjo3DpFR8z5eRJRlllTY/2c4V6Ta9imelJH5xwKBPm1CWlr02etyzelnNyOiAg9Co2EmVKc94NUuoufrAxj4ZweRw+gnXGi4JFcl/wD3JzJECKttzySDEu8KCF1bs1OVig/hlamF5iPDVcPRL4mpm4XHnd3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0fi7IHX5c3D9IODpEptTKcUKHaYHTK/x3npWuO0hE38=;
 b=CE22Xf569c/c3ppggMYxE1g7htp4+MJDNtrkSO7HPvFgEivsPNBB8pCPht2Z4tx/R+LrI/UfaX6HbpShYKR+Rg6AEvabWOdsU5SJMfSgTQeddc2BtpqldyyQF0NdG9AGy5YcydEx6KuVKr3oYu63X/tL2jGllE/M6s/axK0hGys0NmrnY/bcliaHV9u06fw13iNzUdTJBD9tzxhP1K56NkWohjsV10y3RUybHtvxzazgoUDMOjwmxMO3CS66HSDSBQuqLwFPLjkSnd4EgTsXyR9FlKfevGPxWmHbpogZBeZOW5XlxPm+9+QGV8zFcdZVsSHU4UqlRtlsbz7md72ytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fi7IHX5c3D9IODpEptTKcUKHaYHTK/x3npWuO0hE38=;
 b=HQx62kaHNyJwFWEVyexLPJCSnhR3LXwpC2DluxdTHZa/FTTdVw+j37iDbOzePtxpXZHDqisTW3POQoL7MlEDvPhR25JyzyJartC60/rkyZfMS3Wc1h2a4gxR7bfoSUgTwf/cvRSbmf2sTWkf02C8DBcEP2wsRZ2iS1fiefLan70=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3086.namprd10.prod.outlook.com (2603:10b6:805:d6::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 00:45:42 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 00:45:42 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 0/5] nSVM: Check for optional commands and reserved encodins of TLB_CONTROL in nested guests
Date:   Mon, 20 Sep 2021 19:51:29 -0400
Message-Id: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::15) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR02CA0002.namprd02.prod.outlook.com (2603:10b6:a02:ee::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 00:45:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 436d2e03-81d1-4f6f-2cba-08d97c9923a6
X-MS-TrafficTypeDiagnostic: SN6PR10MB3086:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3086CD3E5A4D6DCC51D93A4B81A19@SN6PR10MB3086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rTSdBTVdNycqiMgTUjd4q5sMU/IeQCZxuFI7XoCMgR7Hu3s4RpnFTIOusvgfAecUONhOVt/KOsIN/lIErEWUBSRmEA+HM/p+W7XldegbfyNKMVn5qaVu1wnm9oD9Xz0taBBaIogTzC7wzkhzTDzYpT9vgriFDAhBgBHAr853Gmm9n2bSJnBgaS4TrCguiqhFf3J0D9YhiU7HsfSReNFQnFOf6xWlWw0W18nDopcTV8mMsIGDoGBLiPTjKoYAnvLGf1Yc9i1xZB78KRQZW6++5atqKm8wwowv00OApQLqMEgsDAu7Tfx5+p+J+0CENl4/IUefov5UAlwOyKx2nKZQQGdwOPFj3py7xOi+MNGqrkOoKnNYSSj+5QTKkXClHhJPR4eEbgJJPqP4I5gnWIUwq1p9iBZ74MrgpFgM8YBVBKSjhbE95Q8OamWOLPRPKScGjiWxrmFIekErazj36RHBP8bvKDmK75nvam3NfzWN1MFUnlmyIuUDBxs1bDlt98EmDG27uymEfyIudWS3o/y1DlknT9cHvs1gRG0WOelWPx6IgyPYSkskudH5RVZxhWsbbz8UpPP9kwooKZa4HwI9RggCxzLdPYPn7rJIUAQOGrR8iZvODyNAxJSIGEsKujF0/tmts5Uv+aWGzh6NKc4oRvPb+snVIfmUzaH7JpCsQjldoe1BOK3nRTCuY32R4Pf0/PqMIyM+23MO0Uck0MD3zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(396003)(346002)(136003)(66946007)(2616005)(316002)(186003)(8936002)(86362001)(38350700002)(6666004)(478600001)(2906002)(38100700002)(6486002)(1076003)(5660300002)(956004)(66556008)(8676002)(4326008)(66476007)(26005)(36756003)(6916009)(52116002)(44832011)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VUCErkrMEIanStoLYBOc07SrDGXmZwsbU2L5bVy1rgXM3AwEj4ZCpF9H3hMW?=
 =?us-ascii?Q?Mjo+cvMVfjx7KWjTjh6d1PKmtF9+ww4wKm4c60WvN/+Bb5DzUpXbBl4btLPw?=
 =?us-ascii?Q?mDCnc4zonfJPu2CjW7qmWTWkb37x9/m7VR1yJaWGrPjTx8mR5ROq8Lj1lgmp?=
 =?us-ascii?Q?jsxKZfG3CgvnDhnwZW09uWa6oMtYzkPHdJ2ra9cErJgG9pI4e5fNVNBZjzJ5?=
 =?us-ascii?Q?wY2KmmH9JixyLwR62oDLdzzjj0gywbpWOx2TzOuSB8d70SRnKL61MwQ3uzt7?=
 =?us-ascii?Q?BHmVshacX+P5mGxLxfWVfldCBS/4lWPuDnMe2tNmi4w7vJRZBq8NJhGqwbsD?=
 =?us-ascii?Q?3osF5jHqWlm4njbc/mkBzj2mEIFoKho4KvdASyBH9P8wbWPAx7Pd8apiLgI8?=
 =?us-ascii?Q?YuovmAStmbHBWrVDchm8J2Pu+fUoWB+hkCgGdZiSWkWmpHOYAv+ocwk6qMJG?=
 =?us-ascii?Q?wFhTpyrY9htZNQ7PYVKtUJ/fLzmPyoXh8/K517cto25NwmxAQhRmUlxK/tcR?=
 =?us-ascii?Q?MDlolZ45m1re19/7uTuaEYoa9zhNrtU7zpEI6aazJOgD8hFYbOmh9fdIFYxW?=
 =?us-ascii?Q?S2sp2h2MROWHahbP2O/3SJixP1fz+qwBHouwvrjl5OgC9kSq3f1Vge5TeuCN?=
 =?us-ascii?Q?NsFZa13UgCYhyafTDBAjnb7/Ut3q6WJFb9G9WECNZG4IxmDbCcFhGE4HBU9A?=
 =?us-ascii?Q?KUJo1n4CdkS1wtHbmBGijcSkxBZqkZppiMILcPZ1NKVuKtH7ZIHP2moz2+Rw?=
 =?us-ascii?Q?efZaFYdj1dYerl4Q6kjC9RuDOFW4gzbXxGIEWQuq/IsKi+OH4whHTxwDN44y?=
 =?us-ascii?Q?3NPyqTD0j7KoTXBmRmSD0vT3qMVUhVED80njtxdiKNcGg84rM/HvwkQJN5cG?=
 =?us-ascii?Q?8Js9L14CObiyfobwstGOqsk8tiF057XvKO9iUxsKkm5QSM6OrTFM9WekVGSY?=
 =?us-ascii?Q?aiUunTV8pFiel1iFuGaK0qJH67RAvdPRJF16Mq20BgfohGKjH8mwcx4MyYWN?=
 =?us-ascii?Q?b4b+3U7Y7/Bi4nnUxt7LZBJoMfXZOXEpadE0yhYS8PFnnlv9hHLlcSI/g+Wz?=
 =?us-ascii?Q?xB8wI8Qhu6MZ9dN2sGp3wB3sEBHgsLEj+OP4GFT9MsPSYPsWDJg/KHR+uvX8?=
 =?us-ascii?Q?AL9DnpX2EftjXv8BSlNdSx4rQJX14lNu3MK6a2ui5i/wG2z40U9msKMXjyTp?=
 =?us-ascii?Q?O9a9XtAR0kQ/FgeVhh5RSU83+JQKaQAYlnFdSWmem76xAq7nLcE7cWde0R7v?=
 =?us-ascii?Q?zxoFiEAigm/qtTDvtDGoINLXkEZ0KuQraTaIz7jn4VqlCr7cbZJPTbXFxLr2?=
 =?us-ascii?Q?ZSLQsElkt35aQ3UDbs04AWu9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436d2e03-81d1-4f6f-2cba-08d97c9923a6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 00:45:42.1478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODhgpZ78R/Gi9/GpXWKN1242zymIr7h0WtaS8RaW76q0SRJb7cahQAG4lvyQ/6A6ynI7KVHhkykZQRrd8AGHRgO22ClvGSN8xpqNFteZQHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3086
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=522
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210001
X-Proofpoint-GUID: aALSC8z9NmyB187CMCxQ66aOwgMJuriW
X-Proofpoint-ORIG-GUID: aALSC8z9NmyB187CMCxQ66aOwgMJuriW
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "TLB Flush" in APM vol 2,

    "Support for TLB_CONTROL commands other than the first two, is
     optional and is indicated by CPUID Fn8000_000A_EDX[FlushByAsid].

     All encodings of TLB_CONTROL not defined in the APM are reserved."

Patch# 1: Exposes FLUSHBYASID CPUID feature to nestsed guests.
Patch# 2: Adds KVM checks for ptional commands and reserved encodings of
	  TLB_CONTROL.
Patch# 3: Adds #defines for valid encodings of TLB_CONTROL.
Patch# 4: Adds #define for FLUSHBYASID CPUID bit.
Patch# 5: Adds kvm-unit-tests for optional commands and reserved encodings
	  of TLB_CONTROL.

[PATCH 1/5] nSVM: Expose FLUSHBYASID CPUID feature to nested guests
[PATCH 2/5] nSVM: Check for optional commands and reserved encodings of
[TEST PATCH 3/5] SVM: Add #defines for valid encodings of TLB_CONTROL VMCB
[TEST PATCH 4/5] X86: Add #define for FLUSHBYASID CPUID bit
[TEST PATCH 5/5] nSVM: Test optional commands and reserved encodings of TLB_CONTROL in nested VMCB

 arch/x86/kvm/svm/nested.c | 19 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  3 +++
 2 files changed, 22 insertions(+)

Krish Sadhukhan (2):
      nSVM: Expose FLUSHBYASID CPUID feature to nested guests
      nSVM: Check for optional commands and reserved encodings of TLB_CONTROL in nested VMCB

 lib/x86/processor.h |  1 +
 x86/svm.h           |  5 +++++
 x86/svm_tests.c     | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

Krish Sadhukhan (3):
      SVM: Add #defines for valid encodings of TLB_CONTROL VMCB field
      X86: Add #define for FLUSHBYASID CPUID bit
      nSVM: Test optional commands and reserved encodings of TLB_CONTROL in nested VMCB

