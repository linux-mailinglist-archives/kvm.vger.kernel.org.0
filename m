Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85277389AFA
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 03:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhETBk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 21:40:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53436 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhETBk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 21:40:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1ZTgC188633;
        Thu, 20 May 2021 01:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=X9nZzRREkyV+7w0ezhIoXIO70C5RUrZFGycjB+9JfHA=;
 b=LbBKLNhobZn+yzpfn84dgvXo72oEtyCJPNBtuGRg+yTXVs8gmQKj4/NhaoNmQpt9wOUb
 UWkJi5IyhEwIzNntRV6lhhmBYm4iKPZVv+JBoAh4yAcunuBOmYtbf5CkTinOixKKKj+/
 ds2EVcy+cpEn9CK4fyg/9FFb0fA21GsJsVEFf5S3R0maswOtj5E54dLCsVhhf6D6yj/2
 lkyYUvdkYn2oSVEFpZhTSZG3zGW8KQc4Pc1dCp3X1DzqY9yPCVJSYmWwsHaHR6F/502Y
 /+sdUR9BrQEibVkTWY9qELxPwecKQtIEdOot7Ux4FpP20lIv3JjnBcX4cOIDZag9A6Df WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38j6xnk77f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1ZNZ5034122;
        Thu, 20 May 2021 01:39:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3020.oracle.com with ESMTP id 38n4918ajc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwUWAFTV0jq5JcrdKsMJGAKVgBOD9MFjyA2pFLIbs0JNMdTbzUUKvi0tUmJW+/Jt4Siy3kW1/D+lIkWc8Q7F1PjTn8pRsFLxGP0LlDtqoU6cpaCqNRnKhHSUy8qTN32AI/ADQfvI/eG3jbzvLItHLsMAyKtWkZItqZMxAHFWtC8+5HG4tIcuYeCH3I4sVsN7RP/LQY0k9alt7B0+FSotPh+YDOL26IZaqohqrEiQ5yH9qKl876q9TaXViJMCqj/ZYjTAAobzEq3aJowLa+obNsM0GdhpDlWyeVG6ko/8MySdrgNHLwc4Lo9/kERcjLk9VzQQ1DE3Sd2hqyNmSQ5Gcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9nZzRREkyV+7w0ezhIoXIO70C5RUrZFGycjB+9JfHA=;
 b=BgV5xZiIPoCN/XWplLPg7ZojSjKMO7Qpz8PgVgZcXOtvHj1PZb8Xo6JPrzzmdX/xiYHWrSOfXv5pnoxtH1zZkoYFl5SigiRdZLrutkr8EpIEfrMQzZx6kakNPqOYGkgasiKbnqqXfcJS4/Yz4gmCfF2WxAIO4RoQojQ2GnvAaiJNBoSeR0DjLvIrDc9gPciSVuWB31teMDpcO29lDirv17fu+LFKO5OzU0Svlhz4TGW+TF/qNR04wycYAi5J410DrP0oNpCiIpefvSUwcHZAuPIqmUBul1TdoTpXt+oKnnNZPRdz+Um323sUIA1vZ5TIGRQ2RmuoZ2KsXEV9odnJRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9nZzRREkyV+7w0ezhIoXIO70C5RUrZFGycjB+9JfHA=;
 b=udtbQKM/NtzHuYTfiO72V+yFoYxvkbVJA8VRECgtnKcfkZ/UkNCmhhNza6pchD9CNtUQTakpIH1S8PovPk9nON3Ff7Cv+acNnIDfPZxn5vGhnjlltlKYC/QcgCcNqnw5GsL+sTV7IE4k/YnKTNp9e1OcoDAP8OgCTWpA/F3n4C0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 01:39:30 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 01:39:30 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/4 v2] KVM: nVMX: nSVM: Add a new debugfs statistic to show how many VCPUs have run nested guests
Date:   Wed, 19 May 2021 20:50:11 -0400
Message-Id: <20210520005012.68377-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA9PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:806:a7::8) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA9PR10CA0003.namprd10.prod.outlook.com (2603:10b6:806:a7::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Thu, 20 May 2021 01:39:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2a70a04-1e54-4e33-f580-08d91b301c6f
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3088DEC2EA86312F63EC5EA3812A9@SN6PR10MB3088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /t6zPW6iYnDrIJVnYPM/OLnIsD0D2G219XsgAVy9ZkDWeJyzHHw2quVqqqeAS/2AvqTJ11n6sQzTPTaPB9Pr14/5UY7mm5VCT4GlVCh8iDdJhF1fMp/My4QNjBvQjvXx3/7i2BAse93KhYw14syMxeexg7GnYRAHrvb9tQSZCMjkJfbXrSAX2BbOfhS5d5eOym479qq3xUYikiuChDa+3DDd3TTe4yJw/BYY01g2cPazgHR81SRYfcLCaeSdDDLTFQFttcqPCMLGIBq2Aw56xKIlgoJE9Kksbwb0qp4GJfo4Ihb5hO7vnOFg44X5gOOn1UGD2Dkgtt4E45QL9Evppw0tLgBycrudEuyhVbsNI5vNi5Y7TtM+P/hgMrQwFcvZHjR/gZl6C3h4H66nCldYjOf7O/UEgScZcxN5GhzxfS2YAGCaxdES7REeppm5T37USz/FvLKJIEHv9vMYI8hNt2jEMhtDvFbShr3af7EK+WeqofQa2uIrBjLlfu506hrYP8nJOU49x5kPGhTgDDoaQrWbOLHZQOvkVZNN13qpKXSTlUE9Gyt2m9Qwv+eEntP4GOAmFCJRX4W1YbRKQvW0z1ZYsU6Ml1bdwABvVRsvXL8jBVgXiWTsS8R8Teo4Y1Jzd1UMd5UVVoLTIy9nMz8wfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(83380400001)(44832011)(2906002)(316002)(66556008)(8936002)(66476007)(66946007)(4326008)(5660300002)(6486002)(36756003)(86362001)(6666004)(7696005)(1076003)(26005)(38350700002)(478600001)(16526019)(38100700002)(186003)(2616005)(6916009)(956004)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RA+l6WNtVeazNd+7q1xLgRTq4dHV3lzBj6FtnCCDJmDWncaJCTAWrP9zry/y?=
 =?us-ascii?Q?N/kASb1hSg9H1hwVPb4vLQVVZ5AukozTAPC2ICKtg8hNnUOYFaGv3QUtxbn8?=
 =?us-ascii?Q?0wwSWwrUnPlBI3n5oEimRf0eK5FyfBfJIRGKSCyprDxVkVzn7JAIX1a1w2yb?=
 =?us-ascii?Q?YFUEdupEP9TYXjbYsAeQRt6KUOu8AADPycNazTBw5i/fUqAl9xce9ODFGUBS?=
 =?us-ascii?Q?RHrNJqMtqGtEPVbvdcSxVuTh6/M6Aiqh9XODd/63PEmM4asWkdHxd4jbuKCL?=
 =?us-ascii?Q?Q+Tq4Uqvd+pM8dAoPTlFncmdOjIZPYcivgCEddA45IAia3k0dZxpgJE0Kgp5?=
 =?us-ascii?Q?HPTUMdxZlFA/q8bqyeVfYeMipoLRz8SFRBfiElDrGj1mRfyYIAF3vzuRcl8n?=
 =?us-ascii?Q?IDQ2p8oaJJBn0Kfl53XAH5RYYFPDiDhKlM6okw2T2zpJpwCzcAIfJXRg2VWf?=
 =?us-ascii?Q?P0dnJbnacHranlVJLBD7o5va1JD1FQDzTr3HU00p7NnkB9Exgw43N+lcSxnZ?=
 =?us-ascii?Q?fC52p/H8IGxP/XRpccMKQkbZUBZiBmmeuxuB6vyRm6pJxx+cnT03jGN7XztF?=
 =?us-ascii?Q?9ZcoAGtnGd7Fxzw3wi/+cF89b5R6TQ0cvhFp9PXaxJzJQCZEyeU1BtdNyqg6?=
 =?us-ascii?Q?0+P5wYQ4H/DtOlhVyhUlAh8FGCp88AIxI+KBIT2jNE9yT4vc7Y3sX3/wL3vp?=
 =?us-ascii?Q?OgEoZW9EViZXUZrhqOn9I/EWgwvht6T3y4YnPNlO/4tQCgrihys/7Rtm2uVG?=
 =?us-ascii?Q?gkT9ot1RI1K412Vv9ddDg8lE5p+unbES6m2vfZouqjE9hIDGCLM73aRzBA9P?=
 =?us-ascii?Q?93sp/rNTj+WLGNvFlYzXvq6MaMqdcwoLG3t9+Xd5dOQdE99QCB5Snu+/sdml?=
 =?us-ascii?Q?gRVn/unZcyVPtZNubSXd0cpZMtLEKShUBiuSCRlvfw5jTl5hNnyt88NVNuUO?=
 =?us-ascii?Q?d3B5qv9xmpwR5eYYqTkUukdr7Ita/EsSIkm1cHQFe2QtavmV2Ng4JA3x9t+C?=
 =?us-ascii?Q?spoJ4jOjt/0jiUkyT0MazJak9snDxpggSLiVB1VTuN1euDT8KAbDfV0Yaks/?=
 =?us-ascii?Q?56hiExToS4JqUiATBtOPqnsD5xM7Y2m+FWKM4pEShhhl7igQ+bm5osd8+hFW?=
 =?us-ascii?Q?a6jg7lk7ZR0fo7shBO8tSGzunf5RSQDW5IiSdaux8w+qafPabk0yipXcE8N/?=
 =?us-ascii?Q?2c0KYRK7suwo7u3OU9+Fp1X3iQ9uYp/dBHqgP8RvhBfdwXrXOAb3lv55CWaN?=
 =?us-ascii?Q?5TAL+w0P0c5KDyrtgVnZ58swIbgZhinSKv+OzU8x6N/tC53I6mc3m44Ritl5?=
 =?us-ascii?Q?y+rZGgW20Cjd511/QGTLWAa5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a70a04-1e54-4e33-f580-08d91b301c6f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 01:39:30.0964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGUZs2dreHuEsI4Ye198ImymL4CJ/GiYt21P6g8nbdF7g7ihJb/Uo3HMDZccwGCnvNbDAyAIVuLjqshT+mvCo+0MZj2V+ahlwTeizF9B2l4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200007
X-Proofpoint-GUID: JXIIsZsPx-owPwYXZBRtp90PsWbk5Q3V
X-Proofpoint-ORIG-GUID: JXIIsZsPx-owPwYXZBRtp90PsWbk5Q3V
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new debugfs statistic to show how many VCPUs have run nested guests.
This statistic considers only the first time a given VCPU successfully runs
a nested guest.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
Suggested-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/svm.c          | 5 ++++-
 arch/x86/kvm/vmx/vmx.c          | 5 ++++-
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cf8557b2b90f..a19fe2cfaa93 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1138,6 +1138,7 @@ struct kvm_vm_stat {
 	ulong lpages;
 	ulong nx_lpage_splits;
 	ulong max_mmu_page_hash_collisions;
+	ulong vcpus_ran_nested;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 57c351640355..d1871c51411f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3876,8 +3876,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Track VMRUNs that have made past consistency checking */
 		if (svm->nested.nested_run_pending &&
 		    svm->vmcb->control.exit_code != SVM_EXIT_ERR &&
-		    svm->vmcb->control.exit_code != SVM_EXIT_NPF)
+		    svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
+			if (!vcpu->stat.nested_runs)
+				++vcpu->kvm->stat.vcpus_ran_nested;
                         ++vcpu->stat.nested_runs;
+		}
 
 		svm->nested.nested_run_pending = 0;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fa8df7ab2756..dc29aa926be6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6845,8 +6845,11 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		 * checking.
 		 */
 		if (vmx->nested.nested_run_pending &&
-		    !vmx->exit_reason.failed_vmentry)
+		    !vmx->exit_reason.failed_vmentry) {
+			if (!vcpu->stat.nested_runs)
+				++vcpu->kvm->stat.vcpus_ran_nested;
 			++vcpu->stat.nested_runs;
+		}
 
 		vmx->nested.nested_run_pending = 0;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d1f51f6c344..cbca3609a152 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -257,6 +257,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VM_STAT("largepages", lpages, .mode = 0444),
 	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
 	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
+	VM_STAT("vcpus_ran_nested", vcpus_ran_nested),
 	{ NULL }
 };
 
-- 
2.27.0

