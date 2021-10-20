Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCC14350E5
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhJTRH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:07:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27506 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhJTRHv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:07:51 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KG8qv0000775;
        Wed, 20 Oct 2021 17:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=j9Qxdl5cxtbjwrLaPscVf15GbrsPhI032wzU0oiqT50=;
 b=Iggy+Ch/eoQO+KC7oMwZ5279le9+ZyVtriW4d2ekJh2W8PYZytpM+xTFRtzhNrverrBf
 zGjzBPmwB2PiZo6Q36YJ79tC0Q0MxB/kV33oKzp7imDOtYW00xCUCIii5j3uCS4tT6ie
 TA82WelDZp66cBeVAeMouSEvgtqHIE2uEhPV5Mzc0ommQAP+2/7JjesNBlCbRsi4ywKe
 n7kkNtxfYok1qMuK5gUeo7XWcQR7dQ3GvrDsoXm8NJJPEUGsU4ObpnjyWIidD3Syp88m
 J1uwGPmtlfVOp+M0dkUpW79qnd+Cnh8cbBbGkZ8mJpv3zOoNObUgle3m7i2lEwSEP/EL Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4scc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KGtbNu104587;
        Wed, 20 Oct 2021 17:05:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 3br8gug71h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sy1jwYbV6S5IARF9J8+Ou8XX4JRVXepopkigPvWwtgO8BCOE7XWO9/fBExPa1znri9PFBQdHWQO8BBQSarN/Gyb+WjIvOLg6+IdW4en1V67S9eZsqrM6ZJmyGOvNRGFXiSAY4tb+xwmeT2ACVlTDGuTEh8oaOzrRfVuG4P6v8hzAciFRl/jX2BwCVvIDiLTHMW5JKhcxwTyXmv1VqVOUAlMyBpKQcnnKg1AyQIJE2Xwqf9+UUuaMcORgNZhscDUwXu5lNttP4QOZ0CA2MOm+z0FQ1iEoElZPlGo8XZ1rM6roVy2TjQf0x0UxmtCca0rW3Bc1BtnUyRIpS2PxUQKsGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9Qxdl5cxtbjwrLaPscVf15GbrsPhI032wzU0oiqT50=;
 b=Mh7fnNIBLX+PvEe3F7bCgdl+SU2nKZBLvg54KJs05eHyNUeepPlVDTLkw0B6eOent+sOWWGKJpMq81oDux1+DF0ef4sZ2RiKyIu1FQycQ7q0B6S+RpLC1zrNvFCSQohXhtuvJodUpPHeszWc9r8pGl4vdNqrjC1K6OBvSUGD0oSdAi9/asAiwcO2zprD7itJwOb2QlNvaD+O7jP27WJXfdlUfXEInh1JbKmpBKRLhblGvEVhBsOEycQc0DRr6vCWtiXDuvHlLk2bm+NbieI4NDKmM/ASPXllBi21l3uyUmXV8N2//Vw+O1rmndehA6fGnnyAcfilAPPqawG9Kahqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9Qxdl5cxtbjwrLaPscVf15GbrsPhI032wzU0oiqT50=;
 b=xmZErslYOBWR2UA16G4xJZhLA6+D09C8vFFfnVmWWY2tqNdN9ssnzw2xTm9cjDpH+JsfaQHZtgpzkNpgafEvSR6Zi8y1EjvSvJG9E4Rpxn0k5fiEhOxH0duWnehbGYsqpPHaETTrLkBvaEOTKCfpDzQVsITXKBpIZOK8jaeL9xc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:24 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:24 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 04/14] x86/asm: add clzero based page clearing
Date:   Wed, 20 Oct 2021 10:02:55 -0700
Message-Id: <20211020170305.376118-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1701CA0001.namprd17.prod.outlook.com
 (2603:10b6:301:14::11) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MWHPR1701CA0001.namprd17.prod.outlook.com (2603:10b6:301:14::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Wed, 20 Oct 2021 17:05:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7914022a-422d-4a94-c2d0-08d993ebce5c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB457739DC57231B690F438A14CEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Or4dUUvIUkpHbBdaP29AToVUGv5oJZyyedA/5eAkdzDMtXR+fyTIJ3yqHbSP?=
 =?us-ascii?Q?B0x5ux2mBEWNP30YmPUWvIE35s3W2kiblF3nSUE7Kh13/XNlJwi8gq8AxQQm?=
 =?us-ascii?Q?bwx5g0nEE8NJB7zwf9vWgijTEKgoLe6RuhWZNqoKqcip9BCCsITOWMDRyl0w?=
 =?us-ascii?Q?llLB4W8ja5Qn2mHHaBpvxqCZTMykLMkRcAcZxdYf3uwDAW3xqmq3masZVs9d?=
 =?us-ascii?Q?r+b8h/qwGEOIJxZ8nYmXuGZbnzM0agwKivmAePSUGBLb0HBSdQji9bnWTc4w?=
 =?us-ascii?Q?ULpUC+N+4Ven4kjDERHjnlZULmJBTVmVHgll6SzIAzO6jcCTuD3zVDCQNUVK?=
 =?us-ascii?Q?2fv83N8zXo0kL9Rv9970jALCIKHim7Y/iDwjdkKUw1s6rOW+SEKrSbBfKn/F?=
 =?us-ascii?Q?OUGU8UxNL7nl7dARZtVARXaeCzih1fPdWFJH2EmJHoYDTeg90FI2BRZ8vgzl?=
 =?us-ascii?Q?6aZKKB2CjfmXBO+rnvssa5w8eXSCbrRqTo7UT67thH4DDh7fDSvLj2M5IgX5?=
 =?us-ascii?Q?kWgW/WTbKJXWLXgfdtCzzgMRA71VgxwEdpIJhPdDmXT8EH7MqREZBJIsW8uN?=
 =?us-ascii?Q?0m9t43ZqWGwV43fmmA8xch+LvsMqb2jB9Ceb1jmEBt/fq4kaCYdC9Y5AvBSV?=
 =?us-ascii?Q?5ht+RBPHHQS9D7L4ArI5XPYpkW76KWEmNgZyKIZDv5vOx+n5kWjH4XASha/K?=
 =?us-ascii?Q?nJIC1Lc00oSMlsG5PTAYJ3kMQ9kZ7mDnxGrlEuP4rYBCGMcdP8Tih22+qdj4?=
 =?us-ascii?Q?PkFZFkq+eNadQ4GAL7uC5ih+nmoCDJmtp13H6qyGLEa3tfcF8GuBXGw1X1HB?=
 =?us-ascii?Q?1NUf6AHlEFjWS62dPbkF9va86yT6BSCAsCKtfplksXOF6sqz4HbWo5SRNC35?=
 =?us-ascii?Q?HZezl+bPREtJbpp+S3nxCSiynRJ4W1p9Kl4+CGQPbA/pMk+263YJcVMcrqAn?=
 =?us-ascii?Q?J+yH52YqdgKJnkGAWaVwUFzEQ+jQ3uqvthrHJIKIieJTuON4FdrtlTIYCm16?=
 =?us-ascii?Q?8PfiU2YNEphnFaUARiOBAYczhZ2UXOHDFZC9gMEY8x8P5e4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(83380400001)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XrhWhUpgPHv0dOa4b0GNmvHLxYiCF8qDu432VsE//hQKBVI5V5lylaTd43Qz?=
 =?us-ascii?Q?y+h0qhxfU9OQk02zRXIrLfFQcQDFSrN9ywBp8eBkEXLbwbsK+nLp1jyFb4Xv?=
 =?us-ascii?Q?gP1fznTIqB6b+LJBvPDL8mhLyzaz0qJcUQ44PeLE4nTvGU01E5Q2sm3Vx5v+?=
 =?us-ascii?Q?ddtYnZ3NAOwXbIlo05Ww89woU7CR5B7RP5m8EIKsgCUeeeBprZ3S4IL5qu7w?=
 =?us-ascii?Q?WOjvtPK538qfaA7HFPkG0sSGT+wbSiLaXKQTCtR/HLkWay48cF/pBUr2BEDT?=
 =?us-ascii?Q?iTqv4XBFheiD8Eu9wqZ0wDFrm9ueP5yXktYKtCkAQEqzux6tTiPCD0FakAEg?=
 =?us-ascii?Q?uUxSNvLUlLJCYkYBYidzNdImfY2aUTVut2Y1t1mDR4jnB6O6hfspMY0Exm82?=
 =?us-ascii?Q?3poiVtk5tUzd4KTm7MDj2HuuWuLuy+gm7PUMJjVPgaE+ru2TVFslpZXDiRYl?=
 =?us-ascii?Q?2aaEuX1EKNorm4M0pDar7OV42WIW0AgaHHMpwlKkWBPveyut+bw3O0gu0lBd?=
 =?us-ascii?Q?rpCnzASjQHkwcRRfX+VfWlE6hmlZmLM+B/ETuf/uV6p0kaPdYLNQYmmMnOpE?=
 =?us-ascii?Q?XTIlCT/BBIS3ItBHm8f4UFTxA67oUoN5lKC8CialqwO8cdLMaBOUcJ8F0vmH?=
 =?us-ascii?Q?Vwhu1b/pPcKHCYoWmZtxKFyQI3NuRtIvXvqV6sxkeqBM7XmaSSmHy7KjDDcA?=
 =?us-ascii?Q?TRyGVhi5+Gl40R5dmGHdcX1np5Cj46BOf2k6EJcnpR3Hxqtc8Ob6Wc4SZ1Jb?=
 =?us-ascii?Q?WiYGdvtE9T+jBAj7eR0ihY5BwGAnG4gZC+64YIb162h8GxjcDXmjASiKj1vk?=
 =?us-ascii?Q?IEVvnfYfMdhmdQnj2RDIv99//JkXqp72yx98CvcuFC7p1nPkOICtNvZsJHh6?=
 =?us-ascii?Q?Z/VqVIxSlXKvaoNQiF30FFomS+Wr2wvCGxfUzlzpfBkQDFx5bgXT0cL+WCKl?=
 =?us-ascii?Q?0OZtLrp4+L8da+YMgxNNOCutOZzvQjPTCpcZ5PkhgSgc1bIa4kHXLLF71T6v?=
 =?us-ascii?Q?Jlp/OcAdkWaIMy2FvM1y+C4eq7KX3Yx2bNd6KXQVX6XBShEnIQ7b4qbVjN0f?=
 =?us-ascii?Q?oc7dfPvwvFRkFEj3pn1NUPKB0abmorqqdo7FJT0chmxnCer+7X1FzoohxuJt?=
 =?us-ascii?Q?QFZ7qXMWtYk0UuK+oB7yhdBpZeS4DeO797J2AgJzlUBaMz38IvjeCeSreebq?=
 =?us-ascii?Q?hxhaa7CjJdDmcMAHhTIMjX1uraWWJXnUyDtJPGeRxA+Cjqc53EYl1esLTRYq?=
 =?us-ascii?Q?Dq5Uk4ecN+BA29QwU2YYw/QZvAO6rREH9+0XbnkSHFpXY6IP/hqqzNuyajdT?=
 =?us-ascii?Q?avE3yecoCYsu13F4jEAlnrZ4RVYOwPi64tGRfVcKco4crwhO1+RxVz0ckZzl?=
 =?us-ascii?Q?ozUJX7PWlnXjN1NiYcFsOcZgqsZ5TgWRo5IS3Hf93x3wwxW5qN4WT4cROBP+?=
 =?us-ascii?Q?N3POkILvBu86sVfHPDl+OA0aUJpKMZle?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7914022a-422d-4a94-c2d0-08d993ebce5c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:24.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200095
X-Proofpoint-GUID: 9_jWjnAdBB-xF-a_J6oHPhY7SbdzWyuj
X-Proofpoint-ORIG-GUID: 9_jWjnAdBB-xF-a_J6oHPhY7SbdzWyuj
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add clear_page_clzero(), which uses CLZERO as the underlying primitive.
CLZERO skips the memory hierarchy, so this provides a non-polluting
implementation of clear_page(). Available if X86_FEATURE_CLZERO is set.

CLZERO, from the AMD architecture guide (Vol 3, Rev 3.30):
 "Clears the cache line specified by the logical address in rAX by
  writing a zero to every byte in the line. The instruction uses an
  implied non temporal memory type, similar to a streaming store, and
  uses the write combining protocol to minimize cache pollution.

  CLZERO is weakly-ordered with respect to other instructions that
  operate on memory. Software should use an SFENCE or stronger to
  enforce memory ordering of CLZERO with respect to other store
  instructions.

  The CLZERO instruction executes at any privilege level. CLZERO
  performs all the segmentation and paging checks that a store of
  the specified cache line would perform."

The use-case is similar to clear_page_movnt(), except that
clear_page_clzero() is expected to be more performant.

Cc: jon.grimm@amd.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/page_64.h |  1 +
 arch/x86/lib/clear_page_64.S   | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index cfb95069cf9e..3c53f8ef8818 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -44,6 +44,7 @@ void clear_page_orig(void *page);
 void clear_page_rep(void *page);
 void clear_page_erms(void *page);
 void clear_page_movnt(void *page);
+void clear_page_clzero(void *page);
 
 static inline void clear_page(void *page)
 {
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index 578f40db0716..1cb29a4454e1 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -76,3 +76,22 @@ SYM_FUNC_START(clear_page_movnt)
         ja      .Lstart
 	ret
 SYM_FUNC_END(clear_page_movnt)
+
+/*
+ * Zero a page using clzero (on AMD.)
+ * %rdi - page
+ *
+ * Caller needs to issue a sfence at the end.
+ */
+SYM_FUNC_START(clear_page_clzero)
+	movl	$4096,%ecx
+	movq	%rdi,%rax
+
+	.p2align 4
+.Liter:
+        clzero
+        addq    $0x40, %rax
+        sub     $0x40, %ecx
+        ja      .Liter
+	ret
+SYM_FUNC_END(clear_page_clzero)
-- 
2.29.2

