Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC08E351AB4
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhDASCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:46 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbhDAR7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:59:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617299980; x=1648835980;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fJslepXp59dsB1czjSf5F8Fsj5uqfotlI18+cU5AYyQ=;
  b=YFMCe9w9N74FNegQsQAh9+ra7jq6GN8P9yJPUZ90vbjluCNUQF6fgTye
   pnXvOBlfD6RlO0bIXP8l/+HnE9tfvVPc3bymHdVhztOZessII9fpPXGZH
   NIhQwqshmGNRdzFINl5DgQYtcgoaIUVwTCzGbhub+ctdTbeB27ucYHb5/
   D/7hDcFD8xsY2ho2hTNw4trAtvEWr9oeMDGEsqZ4QqnY2G1dqs6g0SIPq
   iz4zbYK22p80UDooSJZwgyhpJoEkjbjoJvTjTnKtXIrVcpwD65pCw2mXF
   z6DPTJzch4gVJIS+DacMEXyVPQKgXVwfDvfT/ingr+n0Q4IlmA6iCTElP
   A==;
IronPort-SDR: AAq24ikm/7OW3WotBo3IkfcsUmARMO4ozBpfd4hbM7fDk4yjsPlZcKv/h+SIc5HQ2fmOtrrPby
 lcmGWTejZPOyio05wnCIOzlb9bbPNWSKDkZTQnlBlm52VQooF49xoCYNGlEu80i9LUUgotmwrx
 qUVR+gDSz8xXJiXuGeZkfX6p2fhw4jCuNXriNdgTAMCQeQDlu3z+YqKU17lFPvmbqZFDgsPQnD
 Jvca9HppaFuAS+Y8Ey7/tDp94HN4IX/N4waK+kc+WVpxlnHNbCoGY7OceNrB+uSHCyLkfEu8ip
 j7c=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="164582858"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:36:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNuQ/NLTv4pglRFcGrJCyAnz0oa8RVttSc/qWbOhlhINyKGH+p305QvUqQz2/RL2Air0sPsaWGZgjO0Aa3p2H1MhV/viZ01oCy1Tx9GGNmexVi6IkHuE+bYnCUxfEWm5DEeoZoRznisxjxk3rK2Kcw7xwPQxSR7sFduKs8kA1BOcLssvyaWvu2rVKs9lpE1uCvovfUdDWLyPm1/aJGo6MnDZ0bpFCLk6JOpwz796ZDS+wzNDVIX2j3P6Cpzn7osP/Ru6zA1BbBrxOxrSDxG9gSarr6kDQnjKIEXKYNzGcoIsBch1w8XB/UvdFelLGiw2JCoUsPF+RPzA5cUvzZM2YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uK9D4EONOuH9qLts0ubfTL4vXYXw3flETTSMxqyMBeM=;
 b=JPLJAZldxwOtww1xyW97leu5V087h1TBSwpQQ+0uaZE9C9k+n1UUm97Vwx8egzjtRfj5IbK7Ys21eMtcqB9vhAlXnGEK9SU9hEEZm4zDfs6+fLw9cYSSG4+XqnI80ltq3PvNtiD/rUn3j8yiCYgWxIrZ7OQP58xpPvoIm5FFud5AjihsDRFHgyYjC0Fk3qTIxareURV0jMTmPSHpnRNw7nxXipiGVXwLNsFOiH6z71Pp+zRdJdHg1QXd8lV4ZlcU6zzl/Iqt5z9pJXLviQ/BXmH7dUACx08EdXrNEMSUMACdRTjnYHYWVItsR8CNt07oHypd6nW17X5GyiqP1IsqFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uK9D4EONOuH9qLts0ubfTL4vXYXw3flETTSMxqyMBeM=;
 b=VrykJgSaBvOI/A0cxFHJb0N2AdybqpAftyjZ0BfHcVLRnEGBN6fE6IGSPtAQNdTWuc3L52iM84YPABeD+1PQ3x/9Pii3H3RA8yKspkIvjGisjOtFVZnxGMC7DRct1WLoVSoHafdLlnMgtsJfOFb1uUQ8mtIJFK7NXjj/Psq/NRQ=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3865.namprd04.prod.outlook.com (2603:10b6:5:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:36:02 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:36:02 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v17 03/17] RISC-V: KVM: Implement VCPU create, init and destroy functions
Date:   Thu,  1 Apr 2021 19:04:21 +0530
Message-Id: <20210401133435.383959-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401133435.383959-1-anup.patel@wdc.com>
References: <20210401133435.383959-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:35:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de67681e-aa4e-44fb-06a8-08d8f513179b
X-MS-TrafficTypeDiagnostic: DM6PR04MB3865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB3865759A6360D4B1332073428D7B9@DM6PR04MB3865.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YlRsS8akagnEVUMrzSJwVzKhqm2B5EnaKvRRfh9Ey3gFvKOiUO7kb9dFXdUs3FpgQtLtpYa+BOPcrOi7Ve4tOuAnB8/cA3gqVbgjPDaLfNf12Hu18QuXAUHTJFq4hWEsUON7BLMKmnGqAMeWV2NnluvBq2oSxaHGIFmbbs9tDssJisIOerVXPlFbPGeHbAxu4yLVfxkj1wF8m/mpnpZ/u0G7deRP87Jkny9lZMfNFjAubfJTkWhEy4JNJsbjAE3X3vDtr4OP5qKK+C1q65b/WeLb/aLtXoWJhg6PTYrhfG9RV5cs9lTIyBJTbPYIDk5E/NcCGinrPqArd5Ozu2rLNQANWXMNCbZRibG6SFgmS/sb/h1j6/isIekFwZTjcSavrM+D1T5stS0tPv8jHCX6MflWOzIeVT2y2IRSfYNdN392F05urMEQFsRdi0YcnB9uXtLcgaxsYtjZMSRTGYcyte/OcmFnNdAXL7X6i2AnxoKDCSF9pjGl+iCmnzL2jeMLyOzTY1J8aSk1Q3AIUGmRFA502O5RCJUpI8fwA5vxe9L3qOaImmOe8sN5q7wAMtBHvl+Uz5R40i+ZwN4GBiJEOC6GiBolaTo7Tq5y1IwLyjDQf7iMGfEgJhYYAdH/KSozvl9+6hAOC5vjcEdhNsV09HRF7dWJvrgX0SVTDhD6K/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(6666004)(36756003)(55016002)(26005)(2906002)(83380400001)(66556008)(66476007)(5660300002)(66946007)(7416002)(186003)(16526019)(7696005)(956004)(2616005)(8886007)(38100700001)(8936002)(52116002)(44832011)(54906003)(110136005)(8676002)(316002)(86362001)(4326008)(1076003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Md1g3d+JzbCH8/6u8F6PkArTla85pEKPou96uUdGOhBq6lVP+pKgtIXqphXi?=
 =?us-ascii?Q?9TRC94BwWHkQwzu8E9lPgtcX3Ac9PQH2/ym0bP5RkSJSi2BZcKBKYQNAenmA?=
 =?us-ascii?Q?NJg62q8iLieaOV6ncDTW4o3FP9UpqexGwUuqhgEokOallAghDX/pvaqgolSg?=
 =?us-ascii?Q?sd9bUtNRtWRlpWI9JQx7TL375E2HLOSknhadDlzgwxquOK2mUqz4psmwdIGg?=
 =?us-ascii?Q?H0Z7OaFK8E9eyv6j9gsintLX/PjAklqdsJfuEK7UJk6Vi79u1IqFHN/2OXSL?=
 =?us-ascii?Q?3QEAHdRLWEO+EL2yVEEdOkREDu5IXUPM/41FFun3Ytj0tlwPpZpgTEXI4pcZ?=
 =?us-ascii?Q?ao8CHkWsqc2JSB9rMmrk79JDYa+SOpgjcWeh8v75Os710rhT8q5WIoTj+g7Z?=
 =?us-ascii?Q?jgPVnZMouEjbjbSF9UT09FeyO2HZPu+Xc/fFjw4G8D1XUIF1S+HvnOWOejA+?=
 =?us-ascii?Q?TcYYAykrws+Qz5JmzE/ZHaSZD4+LFigdfNXP8CrXlId7HGs0ZqcBNTnujPPA?=
 =?us-ascii?Q?hF5Smqj6BqNSUT8TjVpCKCZlhZiSKl62osxxU2/BaU8quGEPcf64leDvKJlg?=
 =?us-ascii?Q?9nANtAuC7E2yyzFdGS1Ucjk7DLaBP1UtvrIW/TklfKHOnofVnOKXa/+cy3fJ?=
 =?us-ascii?Q?ePfjMIspsF06ujJzG9Lyo70tvDk0jmUYFKM6Ie389v+EYy84NLI21ozQgMm/?=
 =?us-ascii?Q?Zc2cd9RUIjK3hECOBv2yy+P6DrrGIF2MaWO2b6gS5QHZ65rI/xaX8hyqom4D?=
 =?us-ascii?Q?3AQ6UHikEIM23OcvS4FVHcXGK2OnyLCD6VkKCR3rgSrFgiub18dlY5x7NQr/?=
 =?us-ascii?Q?A4Y37Uw9+GDGy2TosDT6967ITeM8utPBLbGozZyGNSFKkBzeYgMLE3B6I9lg?=
 =?us-ascii?Q?YFZNonSDPrwyH/Cl7zzPv7gZL6eG4S8b58ess2bAGRerzTv5pxOL77iIaucM?=
 =?us-ascii?Q?1BWqe68h68P97ESXvT4r6b/thdEA0Fl+UVxb9pRdPRz4t6yqwKAPz+z1cPtp?=
 =?us-ascii?Q?g6geYa/vhEKbt9shVYnvrR60N+KThUU5lxuAE+GCs24Z5bTD08d8cyrk1YOz?=
 =?us-ascii?Q?GH4FVpohGLXMPlNnfp2KZwVB1JuaYPytXX1ZqPyqlB2dwX+VF00WGnAabArl?=
 =?us-ascii?Q?irZRUZD+1vj9rr2WBZj6sJTfnqoQlV8G45GncfrvAa/xyYtJymMD53kNDaWH?=
 =?us-ascii?Q?4LubeeOAcUfgjjYQzLdk7pL1BxZJcSXQFSatYmc6pg2kdNEMAjIaRYbK6t98?=
 =?us-ascii?Q?b9KWaAhDxD+aI2hLoynqMVDTwKaZriP+QRLvYO9atYYcS1XgTONbdwoveSKh?=
 =?us-ascii?Q?Ua4hwmBWZOTfpfOVH4NVEY/FVQlMtrMMZDf4dSGRAOgexw=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de67681e-aa4e-44fb-06a8-08d8f513179b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:36:02.4083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9pvzPsFA0JqV3dWZFNnefJrxxyT3ReQcxLpMFR9e767LWaQpmFAV39ZZZqHWX3IJpWJoznWJS13U7hAqph/RrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3865
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements VCPU create, init and destroy functions
required by generic KVM module. We don't have much dynamic
resources in struct kvm_vcpu_arch so these functions are quite
simple for KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h | 69 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 55 ++++++++++++++++++++----
 2 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index e1a8f89b2b81..2796a4211508 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -62,7 +62,76 @@ struct kvm_cpu_trap {
 	unsigned long htinst;
 };
 
+struct kvm_cpu_context {
+	unsigned long zero;
+	unsigned long ra;
+	unsigned long sp;
+	unsigned long gp;
+	unsigned long tp;
+	unsigned long t0;
+	unsigned long t1;
+	unsigned long t2;
+	unsigned long s0;
+	unsigned long s1;
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+	unsigned long a4;
+	unsigned long a5;
+	unsigned long a6;
+	unsigned long a7;
+	unsigned long s2;
+	unsigned long s3;
+	unsigned long s4;
+	unsigned long s5;
+	unsigned long s6;
+	unsigned long s7;
+	unsigned long s8;
+	unsigned long s9;
+	unsigned long s10;
+	unsigned long s11;
+	unsigned long t3;
+	unsigned long t4;
+	unsigned long t5;
+	unsigned long t6;
+	unsigned long sepc;
+	unsigned long sstatus;
+	unsigned long hstatus;
+};
+
+struct kvm_vcpu_csr {
+	unsigned long vsstatus;
+	unsigned long hie;
+	unsigned long vstvec;
+	unsigned long vsscratch;
+	unsigned long vsepc;
+	unsigned long vscause;
+	unsigned long vstval;
+	unsigned long hvip;
+	unsigned long vsatp;
+	unsigned long scounteren;
+};
+
 struct kvm_vcpu_arch {
+	/* VCPU ran atleast once */
+	bool ran_atleast_once;
+
+	/* ISA feature bits (similar to MISA) */
+	unsigned long isa;
+
+	/* CPU context of Guest VCPU */
+	struct kvm_cpu_context guest_context;
+
+	/* CPU CSR context of Guest VCPU */
+	struct kvm_vcpu_csr guest_csr;
+
+	/* CPU context upon Guest VCPU reset */
+	struct kvm_cpu_context guest_reset_context;
+
+	/* CPU CSR context upon Guest VCPU reset */
+	struct kvm_vcpu_csr guest_reset_csr;
+
 	/* Don't run the VCPU (blocked) */
 	bool pause;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 6f1c6c8049e1..d87f56126df6 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -35,6 +35,27 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+#define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
+				 riscv_isa_extension_mask(c) | \
+				 riscv_isa_extension_mask(d) | \
+				 riscv_isa_extension_mask(f) | \
+				 riscv_isa_extension_mask(i) | \
+				 riscv_isa_extension_mask(m) | \
+				 riscv_isa_extension_mask(s) | \
+				 riscv_isa_extension_mask(u))
+
+static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
+
+	memcpy(csr, reset_csr, sizeof(*csr));
+
+	memcpy(cntx, reset_cntx, sizeof(*cntx));
+}
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	return 0;
@@ -42,7 +63,25 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_cpu_context *cntx;
+
+	/* Mark this VCPU never ran */
+	vcpu->arch.ran_atleast_once = false;
+
+	/* Setup ISA features available to VCPU */
+	vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
+
+	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
+	cntx = &vcpu->arch.guest_reset_context;
+	cntx->sstatus = SR_SPP | SR_SPIE;
+	cntx->hstatus = 0;
+	cntx->hstatus |= HSTATUS_VTW;
+	cntx->hstatus |= HSTATUS_SPVP;
+	cntx->hstatus |= HSTATUS_SPV;
+
+	/* Reset VCPU */
+	kvm_riscv_reset_vcpu(vcpu);
+
 	return 0;
 }
 
@@ -50,15 +89,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 }
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	/* TODO: */
-	return 0;
-}
-
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	/* Flush the pages pre-allocated for Stage2 page table mappings */
+	kvm_riscv_stage2_flush_cache(vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
@@ -194,6 +228,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_trap trap;
 	struct kvm_run *run = vcpu->run;
 
+	/* Mark this VCPU ran at least once */
+	vcpu->arch.ran_atleast_once = true;
+
 	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/* Process MMIO value returned from user-space */
@@ -267,7 +304,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * get an interrupt between __kvm_riscv_switch_to() and
 		 * local_irq_enable() which can potentially change CSRs.
 		 */
-		trap.sepc = 0;
+		trap.sepc = vcpu->arch.guest_context.sepc;
 		trap.scause = csr_read(CSR_SCAUSE);
 		trap.stval = csr_read(CSR_STVAL);
 		trap.htval = csr_read(CSR_HTVAL);
-- 
2.25.1

