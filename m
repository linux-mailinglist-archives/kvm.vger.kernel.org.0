Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855E936DE89
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 19:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbhD1RlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 13:41:20 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:40304 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242705AbhD1RlI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 13:41:08 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13SHUJgB020655;
        Wed, 28 Apr 2021 10:39:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=5FdrwWxs92QDTjrlGBRdAVvKaRrOt1nkH4EwHDh6O68=;
 b=F6y1OTDxzs6yEqWqN97M+dLN8t4yCbBZmRv0JVLuxuEubsl2XuDnWW9ycvg4EqKFfuDc
 D0DItpkQY0H9F+jNf2dWKKv4BK7joWIxujppqD9JtSgv0EpIXAicM2aoVsxmB/SqAjlR
 YiakblKjSMJtC95arPP4grhlbJZetFSc+LjHmRYgjQo7vTn1enInY41rRK6ZGi0y2XJf
 xPPvU9smfWnHCYiCv3tBaM7CleszwLUS6O9KDA9bIMcslaHdVhhO+dTknHqs70tRZeJ2
 Y0eAjd0kGJ5z+OKoqI4mi5sYS9LG6YltQ+yoXzaUbQ8Lf50SCWH7if1jJiFwKxOD5vJ6 yQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-002c1b01.pphosted.com with ESMTP id 386gy93f0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 10:39:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EldOCsIFU4tOn6B3A/4T+nF2r1AxFNNbesb1ZDUoUyBnAtnItbwp0DMFi+J+q4gtokRRZvsVK5CnjiW80EtFZVkMOKEIny1RlQpf6nreqgexaIV04VOukeVE/JJFlQNdzdUHbCSgm6VCyt10lWbh/tHtIRgMBuULWFiawPPJ13JNnMpSjGbuOOMKTQBWd+LeuhEYqowQCQogtKEtPX66VjE34za5BWxF3hyE3tqdamHSJiaRZ1MkgIPmsL6uPkSY2OQYU7PK+MpYRAId42FDBjVbpQ/hLQGQfrvvpVeUKTUkUmUPpobmjYJVn2b7bUUxf0C6+Yr8FEC11eoXTl8ubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FdrwWxs92QDTjrlGBRdAVvKaRrOt1nkH4EwHDh6O68=;
 b=I5cPHQByhjg+qwn8JNvMjvPJ+gdgjkKtyJ91hIPRJ0P/b0T6HmARCCmsqkiUMIAb4CBfCfbgkmYY9IAhHuFK5Uhtjhir94w7pj+7fb20mjjV5zgNnWpdMMnBMFpTVJRAARmZEBJo5VlbkIod4DdyDQ8hMklyZVqiIbuHctSx4VlQJAxFIMVp6UbwsSKDraaT3S1lpXkInatkQfJfOlK/EtGR1piHuvRKi+DMlsnqlY+TQPowyg6reARCeSjopAgaP+/AJIaYk2fN1HeG9am7iKbzC+YhFrUZqPYFu3+ypnEsP7d4Wv6Q4xlp6fFWELIKQfcyLecAxkcV1fWtMliULQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: nutanix.com; dkim=none (message not signed)
 header.d=none;nutanix.com; dmarc=none action=none header.from=nutanix.com;
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB4882.namprd02.prod.outlook.com (2603:10b6:208:5d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Wed, 28 Apr
 2021 17:39:15 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 17:39:15 +0000
From:   Jon Kohler <jon@nutanix.com>
Cc:     Jon Kohler <jon@nutanix.com>,
        Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: x86: move srcu lock out of kvm_vcpu_check_block
Date:   Wed, 28 Apr 2021 13:38:19 -0400
Message-Id: <20210428173820.13051-1-jon@nutanix.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2601:19b:c501:64d0:f5f6:aad4:1b61:d025]
X-ClientProxiedBy: BYAPR08CA0062.namprd08.prod.outlook.com
 (2603:10b6:a03:117::39) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02F13YVQ05N.corp.nutanix.com (2601:19b:c501:64d0:f5f6:aad4:1b61:d025) by BYAPR08CA0062.namprd08.prod.outlook.com (2603:10b6:a03:117::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 17:39:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be679128-6c58-4275-731e-08d90a6c8a86
X-MS-TrafficTypeDiagnostic: BL0PR02MB4882:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR02MB4882D67F5E3F7EA6D980CF2DAF409@BL0PR02MB4882.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMFZuCTTZe21jSo39j9PFvokiG5r+7Gyo8YXNeoJKUky3tx9QdFz/HqzP+nN2Vu3cG31oTQ/hAPwFhuzBfTw4b6x6eRSYXKZKLvcIL4eQ9aYXPHMm21KUZCZKp0pq55Nr4KasZ85wqOv0VJm+ysvHjGq+6zHVpQdFD7fD57YvnyDrmLCXqWuMhcsN/sAOPBuRwYyAR92+0j9kAIvVB4cAWrCr3zNGDYDFGcYtCPL9TGbW5qSgQ8pfViCZoyv1U4vpNhVuUL7yLeEB51kSxZfe3Tcxie8q1jo7kME9GMe3Uio9rn3KE9kCnwh37JEOPBG3asQsZKi7HX52u+dPSH/NikOicajzpPQGSaijm9p9CoN/RxKmEITmwzhckH8oHs3JGAnWUljC7R6iR9LtDZlqJL1amlz/j8JG1Be7HeZlgnTh/BKk0Sd8Rh4ED4jKZfnwDqnRg6JTsRzF2UAT9xjiIFoBtvWa1Rg849gUh3YJ4fv0bKJS+VbMyfDCEQWYKdpJw3wHt54WTQMcU8/37I0IpKpLqP7lt0Y/7Wl1kMQvxx7qz3sK/abbiz2Sog0LD1aS0a16BZWuLaKJhRkNcWmRE2cZsMYpLuPaQa7JdBQtyn5O++ctQpd50q9u37/ZaVINpeWqtNRsvSx607HLUu6+Q66Kz1POrUF9EV7ode4R5YSmY98v7elfokKq5246l8IeJeP1bvm/26ih4reOqBw5zWKZ0scy7L4vIn0mfVDG+SbRrPy7ypZxXXkP25RqcWL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(39860400002)(346002)(4326008)(8936002)(7416002)(2906002)(8676002)(109986005)(66476007)(966005)(2616005)(5660300002)(6486002)(66946007)(66556008)(316002)(16526019)(186003)(38100700002)(7696005)(36756003)(478600001)(1076003)(54906003)(86362001)(83380400001)(52116002)(266003)(46800400005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?u8FAdnGq6pl6sn6hPgufCNkI6ABtNH2f4mKiJNZ3P/nkBlvMvnrdpJlz1YLP?=
 =?us-ascii?Q?EsfhYKhyjejVEPaYMgHTbnp19j1Isdg07x1pQ8X3MsLzLpTannfgE/Q+YYLA?=
 =?us-ascii?Q?vcUzz9/l1bmjsZgJTZl6ld8NOhngQNoZNmjPdd9d+V5ioyf5b8Cc7tkxJY3P?=
 =?us-ascii?Q?K7pS7T4tNOC63i3BAfNH65mosDnLCz5ZxhKj+e/7NhpxwlL0VBT88GBGlF2k?=
 =?us-ascii?Q?QjuaojMxEvI+GzAZDHZJoNIX0xAH4QGuJM1fDa08Aq/0KnJfn/K1bQIA1eN/?=
 =?us-ascii?Q?c4B7Rg4dpFbM/PidiNcsfZLMH0TgXdZuaUwN2FHOmJnewOhBMH9X25CiTKgG?=
 =?us-ascii?Q?SihwnIr9X9hLjvFpXz+CqiVp5Ag2IBeSUE24f47GQOgZeoAWkl9LVn4uynbK?=
 =?us-ascii?Q?Kt3xduYoTYKfwuJF0Pga34PsHgg30gVBcfhZQBXR7UlnSBKHs54kn2x3GFU6?=
 =?us-ascii?Q?VTAal0GLx6TE2bZcJRrAMXbBbRI7PW9bnh1DSx2WcWij8JNt7UeR4Q6j7ajS?=
 =?us-ascii?Q?09RnAk5ry70iYtqBl2szmMpyOj17DTpfT1NWb1aemzwygLSCL/1Klwj7bW/+?=
 =?us-ascii?Q?pg1jv5Wl8+XbFcRZNxL/IG62CmMjufZpOMwtnY2Lew37V68nlqdSJTfj+Ug1?=
 =?us-ascii?Q?uukTzxxSy4WKyj2jeanw4qqpPRco1Wz9/wysWW+3JKPOMq7mf78nkjSXdjAE?=
 =?us-ascii?Q?a6c67wUSE1ldxg88ZxE5iLV3DgbSDrNXC951koD5d7TOalwlw/EzFxniiz8g?=
 =?us-ascii?Q?cHWrliTl7j4IZQ9yPaTHXkaho8gqzd7kSzIKtkRXcxbAIGAXxoKLHHz7nPNU?=
 =?us-ascii?Q?afnEvEYkvXqyOYYKOp5TNw+PxfSFHFNpR/9SJu4Eo9VElBbq96q2+FIqm2Y9?=
 =?us-ascii?Q?z2+EszaOE07+DdePyu0Qt5dwfLxedoNrXrNtDoLpfawtUF9Ldi1SZi3tyMh/?=
 =?us-ascii?Q?GLAafp9cngmWo+h12CcZf/bIWLEyZW+tVZrJKo8SIlQky0IdpqTK8QxmloVY?=
 =?us-ascii?Q?1M75gBJMyY9TI05CG6cDRKBoswK4TB1zuHGzPCDfeVgNOwjX6SaxTUver+Vj?=
 =?us-ascii?Q?rs/dABKniI1OqT4iohdTV1iGgviWwlzDeyDSLWBFdd/hwyL+cE40NqJzCew4?=
 =?us-ascii?Q?KOj6Vp4TN3BQQg2PKZhdvHDdBu+GPKh8JiDh86kGtJgsihK1x4b9U2tfrWYW?=
 =?us-ascii?Q?WJopP/53CzRm6l+d2p6JkkU1Ce6v+b2x448pHLfSP+oj9WSlR45/ONyVutZi?=
 =?us-ascii?Q?MqfQ7axj5W9iKewPRgQigvjD3J2BuLw2/KgAzjlZJA076y9ayCJiM4uO/t0h?=
 =?us-ascii?Q?QCTurDKwFwMPukUbor5iT3HO5gcHNdIH8yALM+G/WbBUdbxwAZdujtbuHxQ6?=
 =?us-ascii?Q?c2EJFoDkUEz3RopQUz8/PRhP1kO6?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be679128-6c58-4275-731e-08d90a6c8a86
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 17:39:15.1835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGtjWrfluWDiUQL+VvqZQr5oU4GOkekmBRjRwymYtdYg6aWlmE9Yv4zl+VXzvFZ4ONA0RDtfbddvxrNvJ42LAR2KlyHocEEra2G/YVBWhB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4882
X-Proofpoint-ORIG-GUID: YUwRs1ugoCbkzxrpZmJJb3OJNX-uJYvP
X-Proofpoint-GUID: YUwRs1ugoCbkzxrpZmJJb3OJNX-uJYvP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_10:2021-04-28,2021-04-28 signatures=0
X-Proofpoint-Spam-Reason: safe
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using halt polling on x86, srcu_read_lock + unlock overhead [1] is
high in a bursty workload, showing as ~8% of samples in a 60-sec flame
graph.

kvm_vcpu_block calls kvm_vcpu_check_block for both halt polling and
normal blocking. kvm_vcpu_check_block takes srcu_read on kvm->srcu.
This was added in 50c28f21d0 to support fast CR3 and was questioned [2]
at the time but made it in such that we take the lock even for
non-nested. This only appears to be valid for nested situations, where
we will eventually call kvm_vcpu_running and vmx_check_nested_events.
This check is hidden behind is_guest_mode() and therefore does not
seem to apply to non-nested workloads.

To improve performance, this moves kvm->srcu lock logic from
kvm_vcpu_check_block to kvm_vcpu_running and wraps directly around
check_events. Also adds a hint for callers to tell
kvm_vcpu_running whether or not to acquire srcu, which is useful in
situations where the lock may already be held. With this in place, we
see roughly 5% improvement in an internal benchmark [3] and no more
impact from this lock on non-nested workloads.

[1] perf top output in heavy workload
Overhead  Shared Object  Symbol
   9.24%  [kernel]       [k] __srcu_read_lock
   7.48%  [kernel]       [k] __srcu_read_unlock

[2] Locking originally discussed here
https://patchwork.kernel.org/project/kvm/patch/20180612225244.71856-9-junaids@google.com/

[3] Internal benchmark details
Fixed-rate 100 GBytes/second 1MB random read IO ran against the
internal in-memory read cache of Nutanix AOS, 16 threads on a 22
vCPU CentOS 7.9 VM. Before: ~120us avg latency, After: ~113us.

Fixes: 50c28f21d0 ("kvm: x86: Use fast CR3 switch for nested VMX")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Reviewed-by: Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>
Reviewed-by: Raphael Norwitz <raphael.norwitz@nutanix.com>
Cc: Junaid Shahid <junaids@google.com>
---
 arch/x86/kvm/x86.c  | 24 +++++++++++++++++++-----
 virt/kvm/kvm_main.c | 21 +++++++--------------
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index efc7a82ab140..354f690cc982 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9273,10 +9273,24 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 	return 1;
 }

-static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
+static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu, bool acquire_srcu)
 {
-	if (is_guest_mode(vcpu))
-		kvm_x86_ops.nested_ops->check_events(vcpu);
+	if (is_guest_mode(vcpu)) {
+		if (acquire_srcu) {
+			/*
+			 * We need to lock because check_events could call
+			 * nested_vmx_vmexit() which might need to resolve a
+			 * valid memslot. We will have this lock only when
+			 * called from vcpu_run but not when called from
+			 * kvm_vcpu_check_block > kvm_arch_vcpu_runnable.
+			 */
+			int idx = srcu_read_lock(&vcpu->kvm->srcu);
+			kvm_x86_ops.nested_ops->check_events(vcpu);
+			srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		} else {
+			kvm_x86_ops.nested_ops->check_events(vcpu);
+		}
+	}

 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
@@ -9291,7 +9305,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;

 	for (;;) {
-		if (kvm_vcpu_running(vcpu)) {
+		if (kvm_vcpu_running(vcpu, false)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
 			r = vcpu_block(kvm, vcpu);
@@ -10999,7 +11013,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)

 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
+	return kvm_vcpu_running(vcpu, true) || kvm_vcpu_has_events(vcpu);
 }

 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 383df23514b9..05e29aed35b5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2783,22 +2783,15 @@ static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)

 static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 {
-	int ret = -EINTR;
-	int idx = srcu_read_lock(&vcpu->kvm->srcu);
-
 	if (kvm_arch_vcpu_runnable(vcpu)) {
 		kvm_make_request(KVM_REQ_UNHALT, vcpu);
-		goto out;
+		return -EINTR;
 	}
-	if (kvm_cpu_has_pending_timer(vcpu))
-		goto out;
-	if (signal_pending(current))
-		goto out;

-	ret = 0;
-out:
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	return ret;
+	if (kvm_cpu_has_pending_timer(vcpu) || signal_pending(current))
+		return -EINTR;
+
+	return 0;
 }

 static inline void
--
2.24.3 (Apple Git-128)

