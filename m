Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A9507B5A
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 22:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355235AbiDSU5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 16:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357853AbiDSU5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 16:57:36 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2069.outbound.protection.outlook.com [40.107.212.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDF65F9B;
        Tue, 19 Apr 2022 13:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C52651VRG7LyoVxJIi0utzpfsSu/ezu9QEYSE5laVl1F5igEr4BWoTEImd7bLQ2KTT8yUFYXo5oJ91SQrPo+beMd74W+tT+vFBr34pGwjm55jN6mWAU2GBAxYMY4XHCjs3J6rAQIlo74BYCRyzy22BO9cJyspIbKD0uD4RrUE0H4ni2pUtGOqfQHeHsEEyhphjxyNAhUC0hL12fsNJm1jKApcUC/IBfQSNTlU+LbPT/Jh9w826SxqH3iMaGxVnkH1yWFEdcSFJ6O42XQfF3aisF/8ZV2VQ06a3sJ3rGlzd8rSeEOy3QhT9xzWNDdRqyQvYWTv2jr51+hETM4U0UCfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8zI4wck8peKxsE69gJdhhoNhlWkBaLxnd0ET/ZtB/g=;
 b=D86XSwuVNV4ir+sXZ9qt6qBndiwxJ9GHOHwvlAL8kPpq5RLJx2gUjWtLis+qQ2eSX8KivgRjhEVFo1DZTwh8Up18DpETf0bADsV3CDLkZ6AKh4uLmsa/hgwvj4TYU8J2mojH9evmpd0VTnNurjNbXGgdMVeCMhbcyO5W1xCcrbsFjZ5mr4Gl4ullW2UkhTzYgfBMXe8aFdqv9jq3NgTidWUMCLYHRxjwOeyA2R7sJ7b8VyExoeWomj5XH/nwR9Tz71KWba3ye8uoPyDsknlHULK30MeT36WfWaVBYL4iJf/mrUALyxQbDBWp8n106pC2jfousrhPZOJHXvUJmU7hnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=tencent.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8zI4wck8peKxsE69gJdhhoNhlWkBaLxnd0ET/ZtB/g=;
 b=3y8sz4XhsP3rZTyRXdGLncRgPk2gN0bCm4EVCTzMgDoCiHWdNi1s1hIhkExyU00Vg40AARb6R8pujgB+wlqtoD1c/bhLsIAgmfabuVtsOFuBoirh64ruxsEaS+xM8wnaGAaXE+Kn5cq1E+G8IxrFFvzf7cThHAH6nBLhlrrgLVc=
Received: from BN0PR04CA0118.namprd04.prod.outlook.com (2603:10b6:408:ec::33)
 by DM5PR1201MB0092.namprd12.prod.outlook.com (2603:10b6:4:54::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 20:54:48 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::73) by BN0PR04CA0118.outlook.office365.com
 (2603:10b6:408:ec::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Tue, 19 Apr 2022 20:54:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 20:54:46 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 19 Apr
 2022 15:54:44 -0500
Subject: [PATCH v2 2/2] KVM: SVM: Disable RDTSCP and TSC_AUX MSR intercepts
 when V_TSC_AUX is present
From:   Babu Moger <babu.moger@amd.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <wanpengli@tencent.com>, <joro@8bytes.org>, <babu.moger@amd.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
Date:   Tue, 19 Apr 2022 15:54:44 -0500
Message-ID: <165040164424.1399644.13833277687385156344.stgit@bmoger-ubuntu>
In-Reply-To: <165040157111.1399644.6123821125319995316.stgit@bmoger-ubuntu>
References: <165040157111.1399644.6123821125319995316.stgit@bmoger-ubuntu>
User-Agent: StGit/1.1.dev103+g5369f4c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27d69068-ea0b-4172-9b6a-08da2246d66c
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0092:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB009255CC110590C6F035A9DD95F29@DM5PR1201MB0092.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UL+RkrhGS+8TbumJscwdKVA+P+KIzwR2TCdORggslEiLBmJuBIIg4AJvXKf4LUtW3+mZ4G1OGpfdEqPhoqF/E7DiYM6AunJDJ/dA6hBU1Kf0yOMXnbCraOj44hIUGKWvnX8UvSSXzI9K+fnktq7waB4f4x50OhpCEU4voUnaE//OgltJNPVfIdT2Ywn5wOtx1X0uAJxBfz6IK18Fa13bW+f4xIjdGKJUha9DLMpaXach4uyJArtDAQiPAZKsoE6/zDmEpwaTVIulAolM/6zAKH1EP7xeY0l6av4OYZFVnB3NEnmLb4zn4cUYOpv3otLiudTO8M9oU6SIP6btLPmFoHCP/bNt6K4VgGZBMYA2a8//GoQhcSJmUMwX+j889WJrx6zKSmIqVuCfHtSa+6cN2IhAeNrWrK8DWgyPJEdTVUIJUYJIFf74gbkit55Xsa3h2Zk6M0VyOjgvm4sxU/ROzuEwW6ulxwOCphX/VZKyd1u0wv2x8CaAbILZdxHBJxKKWRCD4+VC+SOlkxb/+KcfUn46iZ2OwNXMsUAZDwTtlKOs9rNjXHbws3XtRUMQ9Eh4XDTox0lOfw0+AFsT8n/dqtCJ40irpxo0grxYGfpTM9bZlHMsh9vtz+8VoognMPdex21hRlF9aPI2B87vr/aB+vc/cr0FaeGlZMYbt6rrpUDeJ0GBtRlbBD4KU9p2+6qkrza5malvLvywCUlHSACW3U07eakaw8INIgo//yLbPg9qSNngaimI7yRJCPBZg+hvIq+KXWg1VYMXyLtR/+BbbpndN8zvKVhchYmHInRSbp5XXK2ro+r/7CYo8IjLBsp1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(7916004)(46966006)(40470700004)(36840700001)(40460700003)(33716001)(2906002)(36860700001)(966005)(47076005)(426003)(103116003)(508600001)(336012)(83380400001)(16526019)(26005)(186003)(9686003)(5660300002)(86362001)(82310400005)(7416002)(70586007)(8936002)(4326008)(8676002)(316002)(70206006)(81166007)(356005)(110136005)(44832011)(16576012)(54906003)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 20:54:46.6374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d69068-ea0b-4172-9b6a-08da2246d66c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TSC_AUX virtualization feature allows AMD SEV-ES guests to securely use=
=0A=
TSC_AUX (auxiliary time stamp counter data) in the RDTSCP and RDPID=0A=
instructions. The TSC_AUX value is set using the WRMSR instruction to the=
=0A=
TSC_AUX MSR (0xC0000103). It is read by the RDMSR, RDTSCP and RDPID=0A=
instructions. If the read/write of the TSC_AUX MSR is intercepted, then=0A=
RDTSCP and RDPID must also be intercepted when TSC_AUX virtualization=0A=
is present. However, the RDPID instruction can't be intercepted. This means=
=0A=
that when TSC_AUX virtualization is present, RDTSCP and TSC_AUX MSR=0A=
read/write must not be intercepted for SEV-ES (or SEV-SNP) guests.=0A=
=0A=
Signed-off-by: Babu Moger <babu.moger@amd.com>=0A=
---=0A=
v2:=0A=
No changes from v1.=0A=
=0A=
v1:=0A=
https://lore.kernel.org/kvm/164937947781.1047063.9230786680311460912.stgit@=
bmoger-ubuntu/=0A=
=0A=
 arch/x86/kvm/svm/sev.c |    8 ++++++++=0A=
 arch/x86/kvm/svm/svm.c |    1 +=0A=
 arch/x86/kvm/svm/svm.h |    2 +-=0A=
 3 files changed, 10 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c=0A=
index 537aaddc852f..b0ead47c85e5 100644=0A=
--- a/arch/x86/kvm/svm/sev.c=0A=
+++ b/arch/x86/kvm/svm/sev.c=0A=
@@ -2922,6 +2922,14 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)=0A=
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);=0A=
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);=0A=
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);=0A=
+=0A=
+	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&=0A=
+	    (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP) ||=0A=
+	     guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDPID))) {=0A=
+		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);=0A=
+		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))=0A=
+			svm_clr_intercept(svm, INTERCEPT_RDTSCP);=0A=
+	}=0A=
 }=0A=
 =0A=
 void sev_es_vcpu_reset(struct vcpu_svm *svm)=0A=
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c=0A=
index bd4c64b362d2..526dc1be1c3c 100644=0A=
--- a/arch/x86/kvm/svm/svm.c=0A=
+++ b/arch/x86/kvm/svm/svm.c=0A=
@@ -101,6 +101,7 @@ static const struct svm_direct_access_msrs {=0A=
 	{ .index =3D MSR_EFER,				.always =3D false },=0A=
 	{ .index =3D MSR_IA32_CR_PAT,			.always =3D false },=0A=
 	{ .index =3D MSR_AMD64_SEV_ES_GHCB,		.always =3D true  },=0A=
+	{ .index =3D MSR_TSC_AUX,				.always =3D false },=0A=
 	{ .index =3D MSR_INVALID,				.always =3D false },=0A=
 };=0A=
 =0A=
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h=0A=
index f77a7d2d39dd..da701edec93b 100644=0A=
--- a/arch/x86/kvm/svm/svm.h=0A=
+++ b/arch/x86/kvm/svm/svm.h=0A=
@@ -29,7 +29,7 @@=0A=
 #define	IOPM_SIZE PAGE_SIZE * 3=0A=
 #define	MSRPM_SIZE PAGE_SIZE * 2=0A=
 =0A=
-#define MAX_DIRECT_ACCESS_MSRS	20=0A=
+#define MAX_DIRECT_ACCESS_MSRS	21=0A=
 #define MSRPM_OFFSETS	16=0A=
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;=0A=
 extern bool npt_enabled;=0A=
=0A=

