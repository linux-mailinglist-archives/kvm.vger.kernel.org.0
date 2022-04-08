Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1064F8CD7
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 05:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiDHBAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 21:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbiDHBAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 21:00:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1E7305B01;
        Thu,  7 Apr 2022 17:58:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8gap0h8ioGlGzuxb5R3RGGzWG9pzqYxgqqL6BaPdfKWADy6/ZIoVgGT9cZq2Jf8mJ7hU8WrN+uZE/0m7CVYBFJpjTzucu3lu6etKk5UmHPTLhWlc0MTmwNUJ9IKe1EwLRpc3WHEwkEEPApcf66nq86yT/QJlP0FaxVZKx1zmY6F+TQpz2t9hlM7VIWuO2w7m1aC+nAIGNgEHwavID44a3EuAMw/EVwKHJeYrOFC5FR4ha+HTkGzDmUrqrggeZhyhm7yy5b7OYNVXi5BojPspaBJWaZIhwq2NyiQWo34HKeV4WlC+t6ZSNaWxVtPxBanGxRy+easuiYdLZVN89sGJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iC/VVP9mxMKIXYeYHdjdLjxwj2oc3++XVXgPWx1y4ow=;
 b=eoDm2WuW6DF+0gwWhviF56bPDWnZ056L+5Ba69DMgiZP0OGalMbxIDo3cycnj/LD0b0OslIgMsGZriq4HiK1meAqQbrgF4Z2MMICvCf8FVMgMQ9lg1LhUTL+a247KmN027cksH+p2UnpBHW2LzREuy/09fRgvXWFskRTLpnCuhFxi5bm3fnuDYHF1lJwLGFuYfHK3i9tD8fJscb3NGT4+naMNr3dNPUra0+1GAA22kfl6RtK2xhHwol/e4TJ7xBAOAKq94akcHI8gdOyzPIK8Cd6nMPdZEtzGjNaF0qmzKNXed5NFq0cUgVXKOABrPzRi5sKAEzWWMrFe4cRbLHEfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=zytor.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iC/VVP9mxMKIXYeYHdjdLjxwj2oc3++XVXgPWx1y4ow=;
 b=arNkeQvW8+TjvK5P2RNl5IBektgPfSSdXFh7yoN9vwVT3EGx/NN9YgNERR/mldHMqW+/eFRDlsjHHP4uJpEWHE/m+dHlbkbSx58DSfoR7HcLIyv69fA+F06e/PwSbwPwBA3Gz2GOLJzSaLFVdKeDsqZXEGEJ7SSxHR09MhY2KQM=
Received: from BN9PR03CA0656.namprd03.prod.outlook.com (2603:10b6:408:13b::31)
 by MWHPR1201MB0144.namprd12.prod.outlook.com (2603:10b6:301:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Fri, 8 Apr
 2022 00:58:01 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::d8) by BN9PR03CA0656.outlook.office365.com
 (2603:10b6:408:13b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.23 via Frontend
 Transport; Fri, 8 Apr 2022 00:58:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Fri, 8 Apr 2022 00:58:00 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 7 Apr
 2022 19:57:58 -0500
Subject: [PATCH 2/2] KVM: SVM: Disable RDTSCP and TSC_AUX MSR intercepts when
 V_TSC_AUX is present
From:   Babu Moger <babu.moger@amd.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <wanpengli@tencent.com>, <joro@8bytes.org>, <babu.moger@amd.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
Date:   Thu, 7 Apr 2022 19:57:57 -0500
Message-ID: <164937947781.1047063.9230786680311460912.stgit@bmoger-ubuntu>
In-Reply-To: <164937947020.1047063.14919887750944564032.stgit@bmoger-ubuntu>
References: <164937947020.1047063.14919887750944564032.stgit@bmoger-ubuntu>
User-Agent: StGit/1.1.dev103+g5369f4c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c8239f8-27af-45ec-7440-08da18fad43b
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0144:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0144303753B034E530AAFF3A95E99@MWHPR1201MB0144.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WcSrj599ExfOynPALHyKnrkcEpIPQlS5oYwpBKdDdEgTuawoHWdSG3k8Hgq5/OMHeJDQy4V4giW6Y1iMCqxBtGJ+6Uo3QLioeU0wTcSQAwooNQFWsaXw/lIcdN1i/1krZTZaK+u0O63DqpYUy4DcNSZjsJBrRpLcbqy/B3DEQq2fXrnLKxmgnFyPvT2wpPNXTyQIcheOWubWv3xSkxC9iDmC6Z0wgOqj1FMjnEhBdDsXY+y8R9FYJ29TmoBn6X5AlZvkJrjQt+yGsx1JRBl5l65oKhTjpq0VNYirFQXyGx9xKD+jELN/FPUO5paG5scgPuX0/qPeriu+y4dW7bKGVYdpip14SVyur/Tls9l5gitY4JrWTfAUH1LFUhiz60iTzHHjlYvSGY4Y1ARXqj4tnnGeQ7hDMzDuv2Z3/zrmBwbKzsMemqYS4F0B+LAZj+i0TMvZ9turzsO0CrSquWzxEWxZH49f+oEfsuIuM2OisAZdY8YJ1+tlNPb6ujBmtdaenbrIgmDRN3JipaWufMAF+iCQUpI1N9NYnUdXPBz+gxWBInEcFutajyNi/VNLBpZA7pfXRSNDQlHSd6sl/YyszLsbOMhZ/lS1zaeiedSr1EVf1oyD7cjj6vCpXdgZZpo1gncxvLbw41eWUMVSuXGQVEyGaP2CsgzIInZ5zGOtxfDQVV81lL8MmFAFr64Ao+LEHJ7QMjuMLRwI71U1Ro5zymKVnS59WBaMKaPrM7qqK4I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(7916004)(4636009)(36840700001)(40470700004)(46966006)(110136005)(70586007)(8676002)(70206006)(4326008)(36860700001)(186003)(54906003)(5660300002)(16576012)(356005)(86362001)(81166007)(103116003)(508600001)(7416002)(16526019)(316002)(9686003)(26005)(8936002)(33716001)(82310400005)(44832011)(2906002)(426003)(336012)(47076005)(83380400001)(40460700003)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:58:00.7122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8239f8-27af-45ec-7440-08da18fad43b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/sev.c |    8 ++++++++=0A=
 arch/x86/kvm/svm/svm.c |    1 +=0A=
 arch/x86/kvm/svm/svm.h |    2 +-=0A=
 3 files changed, 10 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c=0A=
index c2fe89ecdb2d..d66265174c96 100644=0A=
--- a/arch/x86/kvm/svm/sev.c=0A=
+++ b/arch/x86/kvm/svm/sev.c=0A=
@@ -2920,6 +2920,14 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)=0A=
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

