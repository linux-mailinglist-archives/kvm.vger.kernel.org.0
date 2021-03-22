Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE58344F62
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhCVS7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:59:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhCVS6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 14:58:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MInu5S005223;
        Mon, 22 Mar 2021 18:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=GapxKE9GulK0jHGJWCpUwhHJ1St2QDENULrhnSqfhuQ=;
 b=EqWPUxbuyzkbgLYtxhmWRGFMc4U96RYFvwF8WLfWgeUPGxY+gKkH6F8BUFhHWsmqy5mU
 BwE/ZsmvLWmY99Wg7q1RtvoCn8A/5RPZ/FxSdW5Q9MqYo1z7qV9Ft10LImgDn6FPbjja
 1/2Z8+6Y8M/IihBhN0eGLqTKHR1s+8aC08kaKaeJoJuJ7OM5+eKwmPt80sk75vvCrjln
 XfM6igVUZ5T+9QHTpjmKXifgL731UUy381EdnNxCLjwMd8nrXiTVysaFeXNdAD30TIPS
 SyPdakE3N5X8l61wcZHNQoKj0FDqazEi3QvK5jUNt+Vf8za2uhm6qqDce5HCFTJNyKdK JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37d9pmvg45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIo8Ir135034;
        Mon, 22 Mar 2021 18:58:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3020.oracle.com with ESMTP id 37dttqxyc5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaqaDkeAhHGnN3L0svMA5ADMWTAcagQ5voVDcVB6MIwpv5imWXh/sv/65CVVrxPZj2aQDONZegsM90tuoQEMf5Zgmn4Gt0eIJCTcrczP9Mh808C4VSZLMX0PCuf4r+LmRHijYv5u4KWNBVaOwXUGINKk8VTmeVOr+WV1KsGwi02L20IR6d99S39TNwkaSbpp1bF8yHb17OMyVzWLkWEijYAOkd9uDQtJQtOda794ghl7BMipY/7/cC5CjmhhTlOS8TtYf86B/2a8/dYgTj3EQ0YiO4KAgKFUTyi5hdP/gctxIZZWiT7oBqFzvvcMWtIklEXuze99QBQ9YKNhJssfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GapxKE9GulK0jHGJWCpUwhHJ1St2QDENULrhnSqfhuQ=;
 b=iEDgAE3cyLrjJYfiL8d2l3K4/SFCoZhMK9flVpJ2Jk9aG0evwYTQ5/Q/dM8CnW+I8UZ/EsCy8kQlceAtC9AcFOZEz06qVah9ekqOftjMF8qvXH0CEIj2jxoz2dSQBCJX+ImPjYnVLmUvKcjGa23vmQRT6HGmv1+cLt8So6VdDHtfnzry6RQE1kx3+buOo+DuZtZ1YX4ENGzSDC89dm70CAGsBbG6rXxNURrZ2DSM2Hq/+o0A9LUqTWVTSwsNSIW/U+qU44qkmqlT9aE5QK+a8W5bHD4pyjE/Q5XfVkLqxFAgkriV+GUpaYwg1VMLpIdfuXMJ593nwTZNBe7sgozTPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GapxKE9GulK0jHGJWCpUwhHJ1St2QDENULrhnSqfhuQ=;
 b=N77jW3eP531TcHl4VQW0GkP+IJL3vN5GQ/aWulnm9AaDPGjGeJjfGg5KqIQWKFuThqqSCb1Rur7d7WdIBaDBIKE3F2px4ynVCtngtTPZXtO8n+OEMeutBpXhSaIy+1trJcd3emruUgpdZAKMvV4NbeiLrs9k7H5KAajK+//w+RE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 18:58:41 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 18:58:41 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/4 v4] KVM: nSVM: Trigger synthetic #DB intercept following completion of single-stepped VMRUN instruction
Date:   Mon, 22 Mar 2021 14:10:04 -0400
Message-Id: <20210322181007.71519-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
References: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: CH2PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:610:60::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by CH2PR14CA0021.namprd14.prod.outlook.com (2603:10b6:610:60::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 18:58:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 706d0823-cd26-43a3-dcf0-08d8ed648226
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB479518AC6C8323D00FE530F881659@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zJSzcsl4I9Vav1NL8I5wpI28Oa8KOBzctwU8/qZYyVogO7T7TiPyIVvAw6gTZ71yNi322HRgQtyO57jdHrOpIMeclXECXrbXZCzpZoC4rkezNoafo80M7wy6b7tPbG9DYhD2rvXRZ2yCa549U/Loje5SBK0duwVxRmqTl/68Bzl/5unWVhmmhKVznyoPl7S/vhNQoKda7tsjWsB2xgCiOctxjpLd9BIoJawzVBoPZHADjQe8lRQ0QIU5fto38t5QK4m/gJlfKq1UezPrzfswpd927vCa838GYptT4nEiYEkZ/x/XUeJC2WSi7OwM9RZYdP74wEqJF12ofATKCWpRmwVgjFBgSbAghdRAkypaskTiBRDYaP/wbthxQ8+VKCa8yBuipBwCiDxX783MmHvtD47Ear9UHQKNxPFHz2uX923jccHojp1+nEwrvktG0p0MS+wTFlOp+pJSopWpsFbj5lQZUvDJawBIGVT7KFc6+1EJLgL9zcRGOpYEUb8iJ6CgyFDBCxFt2TC5ydd88KkkjgbnZCtgADvOoCd9IgyK+LcMtd2G1j8ykUhyW9F73bo/ZHR0weQlJefU8ZQIqgGWHrYqWdxomGazFYC2/TgWV8q34BwVJMYwOXAGngBF4RH5JDFEMgnDcbnsSTIi5bMzPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(6486002)(2906002)(16526019)(186003)(6666004)(26005)(44832011)(5660300002)(66556008)(86362001)(52116002)(4326008)(2616005)(316002)(8936002)(1076003)(7696005)(38100700001)(36756003)(478600001)(66946007)(8676002)(956004)(66476007)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?E6g0jRrKYn4gxVXvJ3QWoXI/l6C5mNRdHyNll2+1imj0JlE8JjV0CJYoEMVa?=
 =?us-ascii?Q?6AvYRIacmeZW+V8RNXEuUeH9/2KnaF0xaLXLgDAttp53jmLbSeo+7v2VJ/tV?=
 =?us-ascii?Q?/S8JpK1PycHhX/M9rG+JBxG0VIWT6in07IvIzywzLFz/ZhZ0YgT/IQ7A2eMW?=
 =?us-ascii?Q?YjPV8Ot4S5etCLHcJ+WVxvBWxehGGABtc0iLKhRqxIeCdjYjer91+q4KO5Za?=
 =?us-ascii?Q?FmaoF885mPwtMsiLfpvg4Td6qLeEjMl38RacN4r4M3Kfms+MXzwal9et+yMF?=
 =?us-ascii?Q?9wD7dL3jBpVgrmmDuFl+LV+ovJw+Jdgr2klRRSaNI2TAkv2NI137RfiJ3B92?=
 =?us-ascii?Q?DWZN3TcNmKr3b5Iw6irSfWxbwd3sgHKURCBBdZnIU6wzgcZr3vE/AdoMxgCV?=
 =?us-ascii?Q?UJ9s5IRy9WO6YAqWfvbaFVzZEOGwR4tzEb21vpT6n64fA0yFyFzzv2qvDV6O?=
 =?us-ascii?Q?EOEa3+055Pz6tvQl2p0c8NHqsMgtloHgKy1Zx/g4m3XHUrUEZcLeSZdyR/Gp?=
 =?us-ascii?Q?V+gtHDbxmi5rW/Ab82GTj7A19vTbMmnXWTQzGFOLD47SoZLS/srH/uSNdmoV?=
 =?us-ascii?Q?1aAyPOdlin4vnPHsRpc3HEyB1DgrgTzqSt5x4HGc5NPG4vdXwl91kI0nr8ks?=
 =?us-ascii?Q?C/cx/trHWx7XiI8v9zLXyWkgVczKTolIahoWG4/VNgpqGsLCGAfubfMfPud9?=
 =?us-ascii?Q?+avYdVXvxu1OnHt9b0+oFbeGndmFcH2sGRePLpj05Bytof8i/5p5vAtASssb?=
 =?us-ascii?Q?aukD2RIfc0khyaOaAgFGszSPFB7Hd0GiRPyPGoyBdYBgYJbQdkNZgAXUFA7n?=
 =?us-ascii?Q?xEZV/ZTcK14zHtmZ9fZQlN5Ur0wnaxVtpHi0BAMU19EnGlyjQZ0ztmZ1SrTR?=
 =?us-ascii?Q?Vc+0TKGVuzdHPsTcTMIhXrAqVtjFk+aB3GKo3YAg5plc6tpiQc7zQGvMio35?=
 =?us-ascii?Q?Scm3N9rBm6Ziu1U8fbRvXD1ttZkLR0m6GzJ3ME2utoLg0k41uvA9fIJRlgC/?=
 =?us-ascii?Q?X7Z89dlp7XsjkquKZvq+MiN5KQjX4N0prUxj/Kkam11x0ghfEGqOSqwbuH8p?=
 =?us-ascii?Q?tqgxKrc/0FPvSiqzZ7vp1D7jLNLtNJiv4aQphvSfIz/oV9tu7EfPOFUIyque?=
 =?us-ascii?Q?JvkJZ5wJhlcpiPxwhn2BIh5kOtvcIcWYfDos4YM5ElldTpA0iMvjdiYIFFet?=
 =?us-ascii?Q?Xv5Bk6Yr3Ntodpd2P6NTzO9n9bM8fOKg41b/44joO2JY5TwO0VtT+t7vgza6?=
 =?us-ascii?Q?vIwi/Zmrzk+v05kWF3pl4l9qxTUqpv3hJeIoBZp/grwtQjxGWZh7BQ5vv9Vg?=
 =?us-ascii?Q?cnOTx8udPc4y9h2OL+Jnbgn8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 706d0823-cd26-43a3-dcf0-08d8ed648226
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 18:58:41.2840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8U8G/zxJgD+qzPNq5+FuFBpoLoqBeKx7+vlQqHKJgHwr22EWLVKhmTe1wezoLwdsFp5pT5E9Pg6x1enuwQIKZMnEd9lZIZ69tKjuekPj0Eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to APM, the #DB intercept for a single-stepped VMRUN must happen
after the completion of that instruction, when the guest does #VMEXIT to
the host. However, in the current implementation of KVM, the #DB intercept
for a single-stepped VMRUN happens after the completion of the instruction
that follows the VMRUN instruction. When the #DB intercept handler is
invoked, it shows the RIP of the instruction that follows VMRUN, instead of
of VMRUN itself. This is an incorrect RIP as far as single-stepping VMRUN
is concerned.

This patch fixes the problem by checking for the condtion that the VMRUN
instruction is being single-stepped and if so, triggers a synthetic #DB
intercept so that the #DB for the VMRUN is accounted for at the right time.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
---
 arch/x86/kvm/svm/svm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58a45bb139f8..085aa02f584d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3825,6 +3825,21 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	trace_kvm_entry(vcpu);
 
+	if (unlikely(to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_VMRUN &&
+	    to_svm(vcpu)->vmcb->save.rflags & X86_EFLAGS_TF)) {
+		/*
+		 * We are here following a VMRUN that is being
+		 * single-stepped. The #DB intercept that is due for this
+		 * single-stepping, will only be triggered when we execute
+		 * the next VCPU instruction via _svm_vcpu_run(). But it
+		 * will be too late. So we fake a #DB intercept by setting
+		 * the appropriate exit code and returning to our caller
+		 * right from here so that the due #DB can be accounted for.
+		 */
+		svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + DB_VECTOR;
+		return EXIT_FASTPATH_NONE;
+	}
+
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
-- 
2.27.0

