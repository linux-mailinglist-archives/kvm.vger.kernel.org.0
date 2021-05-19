Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BA8388568
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbhESDh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:37:58 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:39980 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353015AbhESDhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395395; x=1652931395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=g0y1LLqsAQbgGcTB7yyO+j2n6YdaOfGADjLml2x8Gw8=;
  b=Av7EqT50sEAz9fzoqYwzp1VNCM6jaAxuC2yPVO7g2qwxFcbwPKPupE5k
   2ExTNdlcMqPSkWuIf25D7tEg/Hkqj0vvJYH1c86c7jAbyxPB/tfgLB8GI
   /CJujxSqT85b2fpJ08HO0dQAmQ52W68xJzaZ96QmWZBylaJBrYXY4p5aL
   j+7l4v4JM7+tNnoRtRsm8875GeOEJxblkKTNmZNNOp9hruQfeKrfhkaJ9
   4i527olCf4XnPDnyJe/6tEd8CMbA3Lbcl/prtqTIJU4TUgq33iGyn1B4+
   lE4Fsyzm2eP2jYG96yBw4wYkVdr8fFtILxmgwCHJ1F/DwiPtgH//sMGN/
   A==;
IronPort-SDR: u2eqxU2BvMHB8RIKnLT+cs5i+2vI5NO0OZlrcSPQMjKIAKWxOzivrPtYGhYS6rw3DtnVT5DMZD
 BvNfi9M/mEbte8c+FY1vCsH6mwoDApDa0oFd3vDVR8Sb7TerMj2jFvf5FiobA/LDDU6jTFb9U9
 KQPexCvzVHy+66bQ6d8xpO16gVVfdb5a5IvDhs2xdlAfdErVSt/DST+Fp2gGNX0g7z+nfYRsXk
 j7AJkgNC3uyMVyfdfs0JJVViUcD3K1lldKUs1G+PvAdQQ++K+9cVamWsI9t/OBs7nmfXgz/UnN
 iz4=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="279883819"
Received: from mail-mw2nam08lp2176.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.176])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:36:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtLl5K4asEI2l8+Zr7mqbW3+rFmei5sk0KXPpBzaXqc+PY3QJaLIuifTVuRH2NaMH/Bt33GSYe+0I9S64R4THzFKOOqYvFGLbwv00Msqk5SXt750b3jAN6d17U7dOZGYSKBKyhzX1hz0MfWaJR0Ao7PrN2ldfq/Fca3BTrXL1bjKCTOzzE3jb0I5/Kk7/+yVY6Zl4LDOKM+Yx6mO13zJrmxiLxkD/WxZKMExFoLxi5lhoMk80nuZIK2dLIJqkeNR1VSjK4nLfhgNh1nChVHGRf3vBrnNJsAGMwyIxg5EINI+3DTzSrJOa4kDOae0FPAhhotaWJFHVGOVMKPW9Gw0Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcGcOu640gXaG2SwnL2pfueS2NAu2u+R8oJU+8PmOVw=;
 b=I/C97N1ZQvm9m0oWjJ+eE9Si7kVYlJZgNr8RiR1pdOYHlxi0qxWU36/EZrkGBcSzGGcWnJqZKZcvFSoJa0S1GlYXG/zqvW/aQ8Mtl03HRvvtaokNpRMWRJ1IK5gzVi3l1RJIDdC458loMKhPCG9T4sS3xZJifJd6gGVfieA8ZLZDargw+T0S1CsBzoxiCJKllgPfbg+U9jsib7jyTAKo9AVTrXkILCZBoOMNqVQ076QZPvmqY7P6QYYRI7IbA2xHMclrx1lIQ8imuzqrvlFdq2DDkkFztjHb6iOKioUAbJxHPPeKQFOlopAdrh3D5w5MnET+ypV4lVDZqbeZnxaa+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcGcOu640gXaG2SwnL2pfueS2NAu2u+R8oJU+8PmOVw=;
 b=TfOG0VXCMItAKK6XvDoDw/DsCME5jP6j9Tpo1kjMJ7wVYtageQkHWjk7RK0OGFYisvG//U8AxYppy0phN7pwMC9dxNXmufkv5saKjA52pbDxMN00ueCOlUdmpWoeT6OCLIUWaljzaKhrLV4FTdZ9OyXtUxH8aCB2zcQEKXAPGS8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:36:32 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:36:32 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 03/18] RISC-V: KVM: Implement VCPU create, init and destroy functions
Date:   Wed, 19 May 2021 09:05:38 +0530
Message-Id: <20210519033553.1110536-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:36:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abb6590b-495e-464d-9a56-08d91a774b77
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB77618B340DBD7955841D54318D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7vmOeHAXkYGyunRnAEtuCq6wqC4qZ4DNfSKFgBavqiU8W7rTep90QBUlzReS2Oi0twzbBkwG+IvxQ4QKGj/w1wYhMk3qhPR0b1Lg9gWGsTaodygEkwI2DGiKEvRumZ2E/Z2cmo0JQ6M5hcotohGHcZRdWS1ZxmjPc1SKv1Kg6bE6X1wkLGKyTCTrPM6r/Vy7THT222nL3HccBGL2gFCENxyYHEk4GlNb8b3y4kWoXrZw2PN5N5PsybsPTcTxHHXWu5gtFDChsCbV6QKqb3SbSdY9O1U9oVOAy5SkyxeXTD0Hj1ajMYFopcOH4Mvkanz9D96jQnuSx1Z6pqoCd9CZ0+csKvN91B1Uj1qMSuzH+j3znutOnfw5z0rUZud63nIcqICjYISccXWY3SQCtdY7CATlHyaj14MGvmT7QquWFfZ9g4OVUOw0U4O7r5/mS92kwV43qMvKFr/iBeLaO4+t8ozmHlXhIUhaqUNKFFt4w/qcUV1LnevhpzwUouUNnqD5UoL+/GC+ItuTPFBhgZEtxsq2xrqL8BHZAUgq3+kFCa54xa1ZAow43ngaAKVTz0fv3G+QqRFppERRIF8/C4L7fmhKTKSb6pJdg04huUwkh2t8Ckgtp2mkEmfqFPSSgD6L2f3K4m6EuUblsWXjxR6PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(83380400001)(8676002)(6666004)(66556008)(36756003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ka6xWYQsRYChY5/uEkEPSwIQoBNGiN8YUx/M5biE/lSbkAptEVQPMUSnphHb?=
 =?us-ascii?Q?+92/UjaKbFlc3/Dbi+mIUt6scLuh8IM33MbuX9RiM9lrIAK3L9ZP2+O8jwZ8?=
 =?us-ascii?Q?FKcZbqzluWAULDVfxFvfxAkdU3jpbGxev/TZlZToCayVqIJ/qLUHd0YLxO94?=
 =?us-ascii?Q?13Y28QGAQ0ATTZM3uenzAbfM0EdXOyFLZVF08XuUSjFR2YG1OWtLL6nESmBq?=
 =?us-ascii?Q?IbURTJAQK2LkSL1VuLGFjbShLWqWLC67PGO5AKfrXEqvEY9uwuU3beNEZm6j?=
 =?us-ascii?Q?RPG0FQwsZ86rV4syQMXVffrBMjpCobJ7ydxs2Whpg1np7HnnsBgHZb4Ymdov?=
 =?us-ascii?Q?IoWmgVQPBCqtjFZwG0Jc/BS2SBwuIExkBhGJc+Q/3QgR99h496corP5eaZBt?=
 =?us-ascii?Q?OD8QGHng0UMv2ugjMXdd+8FDG37p5Mn7blusNpTf6lCMkayuErnrqSk4q1gf?=
 =?us-ascii?Q?1D/SYsxxAYJsCafPhgT+TpVbVejSVZzivGe9AMEnZLPa5UMtIr7l/dWIxEnQ?=
 =?us-ascii?Q?4kMTtZowRsZsvskpqpz2GeZ2aC7G/MZgMP43F4vJ1N1EBXPfJUCsPeRzPTgW?=
 =?us-ascii?Q?QZEslH6mdF24HP0LBXfTN9SQh8JYxFV4GoV0VT84pb3r4wg21Nd4sOpHqw11?=
 =?us-ascii?Q?oabxM3uTjD7mhb+iOE8IrH5lvW3nOrN9LmKcUurTV/Gmg6XZSRoEeFXkf5Zl?=
 =?us-ascii?Q?Fa0uPB/non98OWISX28jZ9ygzcRO5MLkZQ0vCy8C6hsmjCHcy6HmbXky4tMN?=
 =?us-ascii?Q?YN5BkiZLuD58W7JJ/Wuy0kflWijYID4tu9OvNxxBpDlMZ0n/YJ99R4401ccj?=
 =?us-ascii?Q?08IUZo+NJgmUNxfkzJds+eIMMU4s3bso8/wCoZU+bmgJVolX16xbnEG55zMk?=
 =?us-ascii?Q?FQYnGviS7TjKbE9Z4V+1387ILRXEP86CJ/0znfYggxiWTngrw5t1vBI39CYs?=
 =?us-ascii?Q?DRBKEAOzo78P/or9jnzm6KMdzYrBaWzfUdcSnpGFsw5kIAkSYdm7KFIzU+jS?=
 =?us-ascii?Q?C6f6pCWsDEvnBbKtg6aJUjRkkDXdJhXTYOqTcuajPclCZWIFIoTsdK1V9tok?=
 =?us-ascii?Q?MX1UvtdnQeDAHZ5Cs4pvfP5Rs8tAtz1YAHgH4JCnrXP8/qstroFJ5fng/CL2?=
 =?us-ascii?Q?R14CKVKWToN7TDOoM5y6aGCsgYbHP8e0YCOFN5UZcr1kDugOer1om33Fsarw?=
 =?us-ascii?Q?pNXOPdkbgwRib9CBKLLdV5lWij1/ME2FfvFZDNmJsSGCdBXwRRwwF7bN6GxP?=
 =?us-ascii?Q?4/r57eGq8jEA/aaS7GjEO+GAKiiRfXmHS7cyawW1Q22jkG5Wu0/w9xb1soOm?=
 =?us-ascii?Q?LBZoS4eQImXg1lypL0/E7r3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb6590b-495e-464d-9a56-08d91a774b77
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:36:32.2202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /64iuW4QqqBcATOZKuQevMiGVWY32Bs58NZF52ixJxl6TeMKgW1w34XkGc2O4dYTugfljIIwaUq93KycU6f2hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
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
index 2068475bd168..cf2a23bbd560 100644
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
+	/* VCPU ran at least once */
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
index d76cecf93de4..904d908a7544 100644
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

