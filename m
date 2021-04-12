Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624EA35D363
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343846AbhDLWpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:45:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51076 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbhDLWp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMeqXX171561;
        Mon, 12 Apr 2021 22:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Vdq0sfvdZQvwtkc9zPZeUijbgZXubiWRlIgEczIcQCM=;
 b=Ypnt7Gl44rmmbG3X+1yJKTOaXz4w24wACATIOvqO+q6m1XdCo/FgqQuxvN4DgWHm3yRD
 zqi8gcrQhLZ8Avh0aB87PBXwBbcat90TNN2a8N8PuICTAHjDbETN6/CWvRI2w0p+NcBo
 3TPiuwsDJPJ9ERZ2m8NbYJmiYfSt6OEQJWeTbq6bxluWzlYluQ5399GI0B7PRvSi9dWN
 00HwBYTrQGjhIgfNAupiGXQrpOTOiG2bkh+bSdVSDEcSeSyyD5YGzuD9LqOBUm0Yhsd5
 dPsxn9XfdqJ5Vlp8/EA1PGHH30PcKLXJ8KiyQMEK816lduCR/sq5aWXmIC7AdrqkjgP0 ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37u3ymd9gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMfSgJ009379;
        Mon, 12 Apr 2021 22:45:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 37unsrhcj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tt8GuyY+992Dbz1RoMeTBcT+nqcXn5Zbn9bBVzRMUlqlSee94BucfTWa+//ar8TwRTxFXQ3F2e8ckXKkhMNbIe1DJmsMTFauXrVhHGjaH5I3XYCV7vzUt6/pqZNtcYk98au217KY/W+qH1DQLt/yfqbpb+yDkgqKK5NGE7SKeJy4TISmXzl7tPOSGrSRKyd+QepbPdsB2P/DvLD6UXyH3bT7eKwAQe4m2WraVZO4PYMqgcmsnPijdWRpL/yjUYYdCjuX2F0omUUfQyrdVpVDy4+D6EXUvR2HkrnwKe18nE32XD10ciSSY42hF7XNIE56aqWLOHNX1IBGTIuK222MxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdq0sfvdZQvwtkc9zPZeUijbgZXubiWRlIgEczIcQCM=;
 b=gzoSfLEYTHKAifpPllR5OXv1hlED6AnFOZcW4dI5tA+Fg6tAjspfPVvHn+MpK/SBvpHd/7cYl2/qHjG+LZqP1zDC92KiAR8ChwyFnrQ0oHmzBug5Rf7GB9B/1WOcZ1RI+de4ZjYHWRflqIRy7LCZYL+2vmTXbQOvFQwfc/pOIccIFinPmbHplvtuSu7Q186TqxuQ38emRVGt2cwCJEnLz34mkxszdaTlsf2THl3XGQtdsV3jk5Fbmi8TrFi2nF9YxXeT8q+J49FGOiDUGDzbOGIdUy6vDIkjMZ/XtYed95VdScnYJE6uE9AS6dbLOHfFBfYFZk+B7sOxQycgMPs4zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdq0sfvdZQvwtkc9zPZeUijbgZXubiWRlIgEczIcQCM=;
 b=sJJDPQOBedwobduiNPDfQFUa7Q0QVjt96X55OaBX/wuoygrEXzbVhEqyoqgtQIRP1w9UUJMABHP+XNF5GVEajXCAJXS9GeF/rJs3xsmi71Frzxi/e0D5wztJ71mez+3FhpncIM3zFlhCRF3xfYgdyUH4xdzeKUsWc8dd3yagRvY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:45:05 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:45:05 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 6/7 v7] nSVM: Define an exit code to reflect consistency check failure
Date:   Mon, 12 Apr 2021 17:56:10 -0400
Message-Id: <20210412215611.110095-7-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:45:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3eb1c28b-3265-4f17-0dfc-08d8fe049da7
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3088FDD901ADE89491BC1E9C81709@SN6PR10MB3088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZI4F9mIwFUXybm4R6XlPjpm0xyze1oKSa2pGs4MLYKwZGLkPBtcFj609KFVscrH+RyJZIWYf//MagA4yF3o4+fr3QnfgfAqMcBxew6B2ppINxFqS6QTm0W3bxG2ItN9ZgQSx3yhywM4IWTR6lnNymQaVpiwifpR1MluOwcx5xS+h0uVHJkh9mff12d3vlsvIHepEdEHGLgTtRacVwcZKNupAbY+UApOhIGVn6BU71d5ml4npbJPEz0031m7aOt70ydAlm+M4HO4gWXly7OGUn0Zv7wY9Cje3XuQS1V3teK6oDFH1OM+//XTJ5Jr7VPyEPWla136uQeCNO7/zkYZTVmsRBlHU6+ut90OmtGPge2mQTuEKT9eqvTtsbP+mxhVbh+gCQNMPBdpYm9wiX0ZPZfV7cJydGH1t6vk08USsU7QWF6SCFzi4s0q8UAmxO5ItSNosJXZcyA5KkIG4CeznMEy5MW5gBF1FuX2rmdYLBXPMmYDA6/MrYunt0Hl/LGyND9lOnmVqVUsvK9RjEq80Ua3t2mSqdzkLbo7c8CDfsLj9i6BtLszJ9D/7yY0EAJ1rc+iAsdWeGDCXSMseGVThaSgXWJee2n9prbKnowclvWxTUHgZrK57M4j4Y3fyJ8OqhprIApQIYPf0dd4urqAB/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(4744005)(83380400001)(86362001)(2906002)(956004)(316002)(1076003)(6666004)(2616005)(478600001)(4326008)(8676002)(7696005)(36756003)(6486002)(52116002)(26005)(5660300002)(186003)(16526019)(44832011)(66946007)(66556008)(38100700002)(6916009)(38350700002)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?33hy0d6Hdo10NPSFBCNKGS9GUuG678++N+emFzgfTCFjMSfNzUVsV5Jcb2mP?=
 =?us-ascii?Q?1qHbNQJAzC4aD8doXQAxNzUjk3meQvsVRojHrRiYuIwU/TfY75WM2gl1OhLT?=
 =?us-ascii?Q?1sb9E2I1rQbNEspIw1bJCH9BfolhL4NdUQXIp9L3ZsSLCbCr0gUATSq0+3Yt?=
 =?us-ascii?Q?BnpkOPL6ZR5gHegM3RNTm4j7b/J7znn9WuHzFk+C0B4yza1glqp/Y5ImAkPv?=
 =?us-ascii?Q?EJxvA83/sYQAXONrlIin/Jmhwu/aysjtA5bivJ37d+je/QVZxpKY8CX0PUyv?=
 =?us-ascii?Q?GiB6rFWZ1jqQ+OtxvGF7K1DWnpgUsz/MfvuFsNpg1O5n+XOaGM9nCDsXGN8W?=
 =?us-ascii?Q?ZcJj/Ys8gVzixSfhgd/ynNSspGp+4m6dBjtR/wzSQLHp+rd/mcXgAyzFPCXA?=
 =?us-ascii?Q?p4LTkCYhGkMtTROwwN8dZfSS/3+TRTu8afQSOMmsjNTLmg2HQBncxsLXLrcD?=
 =?us-ascii?Q?hVE8p2VbPvAB5D004w0Cf6osG+LVBdCPoepTXPO3V/p6IJskS0PX4Vy2/EfE?=
 =?us-ascii?Q?3UwOjcngKmdE/eMeLHTeVQQrARxFAqbxn82VA1muvQ3U40VP1aONrsT4/qjT?=
 =?us-ascii?Q?Ej/RLv01fNSJtcIBUBWEh8eQmCMTiPGsDSgtviH36vH18YBoR8LM7Rom1z/Z?=
 =?us-ascii?Q?P0GI7Q3+IYJvx+c+7pBftIT0+HxtNK1cBat4SvYyuxHg/48vRzIo1w8t36IS?=
 =?us-ascii?Q?HtnwZ+Wn2TxIM4W8tGNGLFSIfzKZqS+OBFubIrTSBvdClI77a1yWZZXiRoEt?=
 =?us-ascii?Q?z11pPh4MlaBTOo846AwqnNPLKLDt91PYeyz8yFsWbi6ravItYqaRLs31NtbY?=
 =?us-ascii?Q?tL1G5x9649uf8Boti3oII2/aUngQLXiDEkUIlDl9WazZK8yZLbhmTYItpnP6?=
 =?us-ascii?Q?ZhxvfVVAiv1izZF5KDKh1MFij3XfMwXfdNHdW78BHfaw2hLhfKttF8mj4N/2?=
 =?us-ascii?Q?KjrrG73FLdPNN1bPBTMbSBie2C6wdovWRewgIfvJzKyZ3vIm8BQocctjQcq4?=
 =?us-ascii?Q?iJgN/TH1lLOG6JgTEA62ZOOa6To3DARSOYVF11ju5FCzLqpGGFVqBQBhGCuy?=
 =?us-ascii?Q?42vJ/z/Ke69j0i2eX0e3IM4W4DLtWzLcx39bL5lQrcj1KMWwEPH8hhCcQhou?=
 =?us-ascii?Q?1SVA1+7J9jp8JuAL+m2WWEhZ0qslMFn8O08p0GkgNnXJQFRZ5nyK+uiDr1DE?=
 =?us-ascii?Q?TIaexh1gA2cl9+/w30V5G65MxgxIYEXU5rWdxYLq97knrAI20fNew3Tw78El?=
 =?us-ascii?Q?x0LT2AAbHsRVj9hZITwgVyj1r5kXJ8b7xZ6NVAvSWnwTYfhdCWBdfEedA5XT?=
 =?us-ascii?Q?5ECGx+NXElNSsVHm5GYgVD+P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb1c28b-3265-4f17-0dfc-08d8fe049da7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:45:05.3349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ezJhbWK2VyXIAWTl36l1YJoXVOB/dx9h6sUPJ303GX8O0+d0UMD84mzxK5W3SFEn7kd8iMVRlIcCqzL5eOIr2AWcQmihl58gXovxHbGhyz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
X-Proofpoint-GUID: tcv92qh5512y8ilVF1zc1cd8L5X-O0W7
X-Proofpoint-ORIG-GUID: tcv92qh5512y8ilVF1zc1cd8L5X-O0W7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define an exit code that reflects failures in consistency checking during
VMRUN. KVM sets bit 63 in EXIT CODE when it detects invalid guest state
during VMRUN consistency checking.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/svm.h b/x86/svm.h
index a0863b8..48a07e7 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -321,6 +321,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_NPF  		0x400
 
 #define SVM_EXIT_ERR		-1
+#define	SVM_CONSISTENCY_ERR	1 << 31
 
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
-- 
2.27.0

