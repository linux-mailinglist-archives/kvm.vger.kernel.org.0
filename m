Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172AE347EB5
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbhCXRFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:49 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237053AbhCXRFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWIsyRFEZJ7KW6chubLFkfW0aZlnwfIYps+fkmwl7ef7mhSvwu3j4P212xwb7Cs3sYUfetxvc31taRsSrs/9UoaYqk19ZaLjXcsaSbiX4iPExaqBGxyKtoNDM+rkj713tqUY/J7T9JVr104mzaka+429o4w7iiYOk69NRJO9fakeInuSsy7KyUK3jSJA+7QE2uK1jr4EzcTgCprddJPxvlv/BD+Hv81Rf7DG6CBVKbQNTN3e3nx7TORUyxusTHtyd3VqXxTj4z/VmoLQKkiP9bOA4y5LVkUuvPPuuSLBrrsGcpOqhVqn3HoTzJewvoywLC63omrpNPb6JWOenMsZ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXuxXQ4tqvmrxI/BUP7vB4cfLO5sTDWVRfqUI4qssOA=;
 b=PuNRGCg92Lgpvdjt8UY9aKBciPGe3yYYmolW3plI1axQCQiekZWwe/BHStgWkrxFb45/3zs/Xkf75Yxwpae+jrdJepXtjbx/XfRKUc70bSVRi0Fawy2UD8sQqWEMD4Spcmg8dOf/z0yoDRt0IZ/IwpOi39DtjreP+EkNccyJBZjpO+5uCAeSnewGCA179YVsdXtTgWXCcIRi0vfaWYxDViCR0IRoB+6TdbR9lmSfDphAYwGICxPw6lDCDEWeu38Vv6b0Fw8z+FeuVCR823D9XjVyT+xLIZixQMjrM4J8z9ud2JR9EHImLcXJDyYsDaVN38hmSckldCAavyyKr/ygHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXuxXQ4tqvmrxI/BUP7vB4cfLO5sTDWVRfqUI4qssOA=;
 b=L8pBVHuS06oAW3EwFP/nzzd+RZKbOZsX5vwA6WswbEIOSJNvvWLljRvFltvpQGXWVg4nNVutAopb8sq5ZfwpJHas4hPOaNDBT7t5DpQNRChQex0E+4OmN77QhGRXS8G/Ji9PEOnISXmZUIC2F0oFG1MojrsQc1VfnQuEUMjtjec=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:04 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 16/30] KVM: SVM: add KVM_SNP_INIT command
Date:   Wed, 24 Mar 2021 12:04:22 -0500
Message-Id: <20210324170436.31843-17-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1b7e277-f662-46ce-cc02-08d8eee6f79d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4382842350C0FFFFF033ACE4E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOJhOxOYCFbSyB0NJebtuAea1MtoG2LJ7gp1PVTG3f0qObori1bcnVZowSrKgQz3oRM1OJ95cB0NJjwbj85Erbr0Da62lvK7cV2aIAZl/GnaWdJ3wHIP2yCxNQeOoiCa1RnDuEySu994cxaKnGlbO4EP4FX2+We4lPzBBGf3T6zv7s6dc5bZfvmpVuNGmxkIRcUnWlKjgBsLWW9hmt1ngE65kQnR60t5Y4d4BsDW9wVrxvGgSgpGtcN/mb9yC/QHW1cUxHX6rJUpOPmMz5yBe2ULSh3oThGjOQa9fAlSLC8OwnmxRVU5HrkPHy4hkpQO9pNfyq9IabnA4NeKeSpk/DGYlOP7Jiv+EgQ7PyrdDXfWICiUEl2+3pDLmmDiwI7u/0GRc8DDTuiCSttMFtFvV9E2FhWxwNtq27OZWmajPRfkYkKFkMXmNZvLSrs8SKJSJ6M05jRMthF776D0uB4zevYFbvsWgLTjp1t2P1JxI7Kx/80JcLNJ24ZvrupcxFudcQT2DLecLDol27H/qczUCFHoClN45J3mtWR/emxyhbNscUQZCchyb+f6+SrdciGqwG2+6Ep1URpALVT31QXWswDDN5XWNiXk1yZAE4kkmBQp+bZG+KxzaeTqXEKaYDFfV7IrHXeXR59KtPulx4xEiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oXafx1dIypzjScjtVqsXCyP/nJgg5663sHuYMltJtqCsUeVOa7J5SgPoXPNR?=
 =?us-ascii?Q?dWN93Op8yMmMtnsQU069pYP0bpZYPmDFQ8yv44cWOD1Yv54GXINDPRmjjzvm?=
 =?us-ascii?Q?KKvkPLuBGp9QvVcTqNJzGvwemOmMkHwkARGbwY7Q2lROHil1qvHjs68HwEgR?=
 =?us-ascii?Q?67GuO0QjL1J+0uBbMrFliZmjinlazM+mmj2ajkLO8AWDr2Gs3kIwFIyst7Fl?=
 =?us-ascii?Q?0Mws08gOn9gwm8+U08UuDl7t+ifvw9+9w6ke936k75etgW/VVL85SPonuzen?=
 =?us-ascii?Q?C1RtvXW9+WfYqJJvr643Ks/6iuObQ1EIwcW16XAaBxVyQ+Ed42wPebQkbHjy?=
 =?us-ascii?Q?m241QmhpaZdrQpVycIfNHhmjWm2+icDJ7kLIiet2g+bEKVETGZ6drL0gl5rZ?=
 =?us-ascii?Q?qxxjYVDByYUllUTEcwHihoLim2iqRy2Ri8jlNJDszlLTJpmBL4AeVdj+sOXm?=
 =?us-ascii?Q?LVgK3DXheuuwMSKv2rUa9ZYU1GEMTB9of+bAhyBYBT7CeroU1WOlGcNK8fWx?=
 =?us-ascii?Q?V8onpLKz0IxWhxtdQDnwezpYaOWNLXdG6QHSZMPBHI2MQL2+RpZcUbkPn5At?=
 =?us-ascii?Q?3uyNvZK6PIYKI0LH+wo56/iNcyZVpU1pJthx9jh7iyMVUWxBgqj6fZ2tJw5c?=
 =?us-ascii?Q?NSmZrKVUpfbEZv/E3LnZiDPaCekCUGwQAHu2P3WVd6xA5nrvIdJ3QY8CYDg2?=
 =?us-ascii?Q?H5IF2SV0e18xgWWrAN16ADCb+UKBVs4cSpXF3H6zEQxVhfwLKegSBctRJLot?=
 =?us-ascii?Q?Yq3cS0rjy5R3iISN1Sv5N3Pjy4xd1v2SHnlTh48O3Zy5Q7SrmdyWJse6EqDN?=
 =?us-ascii?Q?ZK6BKB+Y19y8HkakCE/hp82BojVi35+iAkvTsIf7L+UnZ/N03eqDnj8z+auO?=
 =?us-ascii?Q?hJVr7JS2eCq9QLCtla4tuWTI0xcgZ7VPI4xwwVW5W1u37yYElm3r0FQGnpg4?=
 =?us-ascii?Q?Volf+2pa0HODJAE/T+rdGhfgGb0jWjCFYJoIhdboQaWHfwNpw3ygYQ8XfAn3?=
 =?us-ascii?Q?5yo+iETJL81y067qmces2EqnMrn7UqZWoR9Z9MEzSSEo7/JDpT6cV0Gby1eM?=
 =?us-ascii?Q?0ZcjhZS7T1olE8hYhWXe+gijkbflmtiwl3lsb2ci+0zMiOb+Kyw+S0S8GbH1?=
 =?us-ascii?Q?dqARGozbO+P460ugmnVGitc5EJ7kcQitDkARc+UtN8+3ieWbQw8T/hgo9nNE?=
 =?us-ascii?Q?Q8nJLrEH9M8vbJyJx5cmgacmOA9gG8yf2yvvka90jFhSabQHmN3xx3AWAMC2?=
 =?us-ascii?Q?2InzALYxjPG4wSQKCefJyNgYYSgTDLVaEZVqav4MmjKFXYLUzti1cHi0j2pk?=
 =?us-ascii?Q?dhCtx7SOiQv1Br1gPw2s+WXF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b7e277-f662-46ce-cc02-08d8eee6f79d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:03.8786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jt2hguuXBGVTMl2wW9y5a2ojvstMtcpybB/swUuiV6ZMqrcMxJtSKsEZ0lB4F+Q7z+ED2QkDLMDpIYplUYJ6vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SNP_INIT command is used by the hypervisor to initialize the
SEV-SNP platform context. In a typical workflow, this command should be the
first command issued. When creating SEV-SNP guest, the VMM must use this
command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 41 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c   |  5 +++++
 arch/x86/kvm/svm/svm.h   |  1 +
 include/uapi/linux/kvm.h |  3 +++
 4 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4d5be5d2b05c..36042a2b19b3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -189,7 +189,10 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (asid < 0)
 		return ret;
 
-	ret = sev_platform_init(&argp->error);
+	if (sev->snp_active)
+		ret = sev_snp_init(&argp->error);
+	else
+		ret = sev_platform_init(&argp->error);
 	if (ret)
 		goto e_free;
 
@@ -206,12 +209,19 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	int ret;
+
 	if (!sev_es)
 		return -ENOTTY;
 
+	/* Must be set so that sev_asid_new() allocates ASID from the ES ASID range. */
 	to_kvm_svm(kvm)->sev_info.es_active = true;
 
-	return sev_guest_init(kvm, argp);
+	ret = sev_guest_init(kvm, argp);
+	if (ret)
+		to_kvm_svm(kvm)->sev_info.es_active = false;
+
+	return ret;
 }
 
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
@@ -1042,6 +1052,23 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_snp_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	int rc;
+
+	if (!sev_snp)
+		return -ENOTTY;
+
+	rc = sev_es_guest_init(kvm, argp);
+	if (rc)
+		return rc;
+
+	sev->snp_active = true;
+
+	return 0;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1092,6 +1119,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_LAUNCH_SECRET:
 		r = sev_launch_secret(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_INIT:
+		r = sev_snp_guest_init(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1955,6 +1985,13 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    svm->ghcb_sa, svm->ghcb_sa_len, in);
 }
 
+void sev_snp_init_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb_save_area *save = &svm->vmcb->save;
+
+	save->sev_features |= SVM_SEV_FEATURES_SNP_ACTIVE;
+}
+
 void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 13df2cbfc361..72fc1bd8737c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1281,6 +1281,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 			/* Perform SEV-ES specific VMCB updates */
 			sev_es_init_vmcb(svm);
 		}
+
+		if (sev_snp_guest(svm->vcpu.kvm)) {
+			/* Perform SEV-SNP specific VMCB Updates */
+			sev_snp_init_vmcb(svm);
+		}
 	}
 
 	vmcb_mark_all_dirty(svm->vmcb);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9e8cd39bd703..9d41735699c6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -604,6 +604,7 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
 void sev_es_vcpu_put(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void sev_snp_init_vmcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 374c67875cdb..e0e7dd71a863 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1594,6 +1594,9 @@ enum sev_cmd_id {
 	/* Guest certificates commands */
 	KVM_SEV_CERT_EXPORT,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT,
+
 	KVM_SEV_NR_MAX,
 };
 
-- 
2.17.1

