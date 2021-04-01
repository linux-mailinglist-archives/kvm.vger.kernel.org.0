Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4905351B44
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhDASHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:11 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24190 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbhDASBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300103; x=1648836103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=8WjELUyEWFgOO9PJfLTe7LIuvVnMx7WB9bialeDHDlM=;
  b=ZWzh2ilPg/epsRPg5mlwbtzJF/okOutu8YRFetGBpHzQ2oXQbUKLVCzS
   S4c5Rt5WeOPfbuq+0iXyTAT/lXrO5NNKmFjQXQsmj3BVkWLYQJ2977+xG
   LgBjWfEk9Ent4HRCVXDwXx3r202RrXJ/gNE3PoAvXr/J7yDSwcNMx6n34
   fSz51Pc/NP8TXoNHKYCW2IILDMISIH4/UM9t//9p2MD89X1iIZp9X4W+T
   KH0Dom/YP0EiTxtIxohknCtnYIejxy5r8l3tyrBsL4hUGTDhhAv0NTCQR
   KSL8aD/INh9Tnhey1+qvvIba9gt0E/l+nl4OFfveBgkDHlyJjLsgsdwIn
   A==;
IronPort-SDR: xETTGaOdxH3+tx50MeyEeP9AsqvoA6FBi0QWWpHvKdbqgiHUxWWYLDpJ29k1b5TkvJW94VWjJo
 Pqe8Gv2s3LXd1XHNlMh6WWwCH1HWSXhEf0sGLDdZHHAyXFv4AnKwoXtTMPWwWBLTuIriE9hB5J
 5wahpH+H0eBejU6uWxTj0lhNkmrLCeh/FBT4vxaYcimOPrUbFcUqGoKwNGXz5AH4pVT0Os+VgE
 H+bmRt8oGlvAkZfl4CH9+TpfaNVqoS4Ge0RgTKd+Sbg7Bhlw9PUvgtTYILeWw1a3N7BU7YhLhY
 h/Y=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168041423"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:37:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d26GEsLcfbqTdMCk8rlY3Yel2+c6wsdnnHyQnTarNH6brHxa3/62+prkfTNP9CEmKp/L6feovyeEnkfTsB/OKiT4HXRtt6zEDnM8YVjw89bIOK3Lsed+N3qOUvYIa4W6ckm54J8bazN+d28DZRa60nfwk4VRPy5gfygyvVOPw2agudqiMxtk8GH+6t3oQ6O8ZPg5F7nMWM/K1IIRVCwsHIW06+kSuq8fAuWnbJKX5awUxqACiFf+KbuJVUosG4qQmEA+qw6AyrfqXz1e7Z0mlUwPzbdhgnIE+ErJsPM5oa5idrBTPr5lnSIBBhxKKnhIyKOOgb/UCto+ojbu8JZeuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHS3rsJ7aNjjgERKEoyEmsnZwdhhC6uxjhr7XZvP+S0=;
 b=m5IaAeCVmSaykTxTZ+LMyOlONouy2w7DtnZr909EemRx0K/H/LR54uChfEfBbC0jEkYmU+CuK4PfewxVDtpAx3d3qC5DqTcnzIyQWA3wYtr341dks3ncZECuQOGz6jqF8qJeSSfpD4zr0qAcJ6XNhwYwCgCPJWDY2ymkcyhhNWXvGagFpdCwLEvT7SMagappSvGxvsli5rgaie+0t6hiA0QPvIA9AQUz/HO7agtx5z8mhHX1mD/0o1F22esdvWpQqFS/b2UBVzmJM4X3vlSEKhe3RvV90NU31pFfZ3IXJbOcuDHQzvWa/tHIpMdW/sFh33EfUcEIQa0UHZVp+3QGEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHS3rsJ7aNjjgERKEoyEmsnZwdhhC6uxjhr7XZvP+S0=;
 b=pb7HmHee4bMkWVS2Lt11ej/86D+c6NUTJbGTynW8TYrO5zJFFhNMAjW1Ejtoo0vTp3eEw4R/9MgDiRi/klZordpCZe8RyHCgIRXotSTT7C49eE7u6vIFZQ8gTgAI9Ql5c+SNDiGjy7Cmz4Pfl2wms6vk+FVKKtJtZXd0byD2BH8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:37:14 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:37:14 +0000
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
Subject: [PATCH v17 08/17] RISC-V: KVM: Handle WFI exits for VCPU
Date:   Thu,  1 Apr 2021 19:04:26 +0530
Message-Id: <20210401133435.383959-9-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:37:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72c44c85-83cc-4b87-3026-08d8f5134240
X-MS-TrafficTypeDiagnostic: DM6PR04MB6528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB652832967C9AE515C4D4857D8D7B9@DM6PR04MB6528.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J0iiDJk1GYyl49RQ5uGttxd4IORusf9y+NoKe3p4QZ/M6Dsfg+HTUvtwlG0dD1TOJLH8nKxMwkqX0xbCzZ+s63DyVM1LWZ/zOdAYJnV3dCl0WC2jU/OKfDP0fBAZIEaDjRQ0CLoP+jNKxH3srBeKNJ/Qin8V52Zb3DcQTnnfs+jaw2/qrDRC0/tR9qDSiACgl1Bqbwcq8EoqHsth23P1FP9MlPRRZFlvIsutU7ATmK505bGY9L47eCAFsqFpz+wFY9ERR4UvWsO0j/o60ogHpKslwTOtbNSLrl6j/bjj559hoC5Fe8EVckQ2LQI7Fy1sJgvpbHy0BH+C798A41BefFT7A3y9Lbhv40ds2DqKuBoSeSa1HY3VI7zTf/Rzg0EsKBtn1+FozHPHtKFM397VqvYGPTUqSA44CT3JHSB3l4zP4WF/GnulUdH6Qv1Uof/PUnvDP1WKhjcomrKS7nsuTVYoHGrX4M0qqV3wc7E+/rBrtYHODfQG5MRtPRVdM2rLKTqdtI0DTdceFS002Q/yNXM8abcLnF8WOwFF2hqfY/CSUtkR+wArNuoeERvikgRYoWW1iPXITk3VGq8zZ6goCSxWhALzMsnr81C/nr9Y7nhaBos4sK1mAuqJZE11g711p93P6TQBrzwqPg9anlED7THnVYyw0hO74YJTd/PIKjg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(8886007)(16526019)(36756003)(186003)(4326008)(956004)(2616005)(6666004)(316002)(66556008)(478600001)(26005)(66476007)(2906002)(54906003)(7416002)(1076003)(8936002)(55016002)(86362001)(83380400001)(8676002)(52116002)(110136005)(7696005)(5660300002)(38100700001)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KfTz1Cq/vb8drio+fIAYWs/9vm5SRDS5knk8Qw/le3rgnESJw1aqzJsYGcao?=
 =?us-ascii?Q?KnyIPIT4U3O04odXCDy5pwS7ZP3lz6oP4qpZTIS2VPtbp7GgkH8o0Ku6+CUz?=
 =?us-ascii?Q?oTpuk4vEfLUhMxfPlI0slIiFibjUBF7SVvxx01Lahyj/FTJrEhGCFh6ZDQmc?=
 =?us-ascii?Q?NEVCgbTl6/CckQ5jpXTdFUfGT+p6hKhJWgKGUOjzH5OTXUI81yhwa9UtA6E0?=
 =?us-ascii?Q?bYpxvSa88BD87vr1gUEv2k7sDT/Ak6eR03vEMd3q9w65+4RFZKymuI7R11RC?=
 =?us-ascii?Q?cHDhvAkwHj86EfClgAwfEjCKa/3DejR6oxqVr7leU6TqAUq8KTYDqWpv1D8N?=
 =?us-ascii?Q?RxpO85eDVLdXLqPhX08EeXzA7I8IpyWdXHIOEoIX8BENBghPMp1GYt304EGd?=
 =?us-ascii?Q?yvBcGZvp2g3L2Iy3KadCf3FmLRAb7N/ldZYDiJkgDiEB/zlI05nPYrjk48tX?=
 =?us-ascii?Q?kF/QRVBRK8rncYhcxaXano+UzZTpMIooGHMgh98asovrx7klPYSotToxQhBM?=
 =?us-ascii?Q?4b/Lg2wQC2qUWUiX7qoEcMnXoQ8vXkNW3MuISsDdBsa3T+BFozsoJa8ykZnW?=
 =?us-ascii?Q?YqOx776Dgb/c4pWdWth2pL+EaRMfm+SKkNrZousOBUVAgRuTCeKYP6XnldPu?=
 =?us-ascii?Q?uQi8gmex1ZMP9HgNDydnHQOorFDqk6mN36F2aKJWCxs4eEcRwe29dIuyugTm?=
 =?us-ascii?Q?w5U77D/O4LlL6QUYTSBgQUhpKT5DhP+0sH5o/cWK8ZA1GopPVjC+FfGYSU1d?=
 =?us-ascii?Q?wjReKB7yXZCOTOjshfFBn5/luvVHq2mDOSiPhCmbeKNrJUHn247lr9X+pPlz?=
 =?us-ascii?Q?YcQuHV436qxxRNNehum8vcO662gApOEIp4idHno5TSMI9GFsj9hPLiacjiml?=
 =?us-ascii?Q?6X/QFWZGWsnvFhJcnXPBjHgbfcFcxaz/evCbXJA2AB1kYNUaWAzSjY27qWhs?=
 =?us-ascii?Q?wrPUBYE5bMe4zwlJQQnh5h1K5jYWX6flUYgKgI8dJ0Gx032yKnK3WQqr+ony?=
 =?us-ascii?Q?zAbb/WQYjc0jT6XEkfpAoiQ/pcAxrzpmrvrkGC9Vj6MFp44ksgALdU4SyiaO?=
 =?us-ascii?Q?lyCvQ1YMG8NHP+jTnVWeaqqbbeju/E132gBkLtj0SZtNjLRgrfOaCllnKMB8?=
 =?us-ascii?Q?fhfHwGcgnFR7J2KgTI5rHmea2Z+2MaZRwxFjJ6spTtw1Jw5KBFrPLztk2n1S?=
 =?us-ascii?Q?O+AZbcf0wSSdqJMgt60dEKSMo+zRtj0H1/9vE5kB70y3PdIKFMFWeyimjxvf?=
 =?us-ascii?Q?CbgJMHBjZjVg3rUKzXFM20NjalqJATzSDLQa4Wavcfa0P31nrEH5iIZlgsvd?=
 =?us-ascii?Q?sCRXbZplXEJdwFPT4cyKEbJo735NeIECBKmIVSix2i6U0A=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c44c85-83cc-4b87-3026-08d8f5134240
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:37:14.1269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IL8tIofOJfm3/lBZ5tbJegdVDfo952KX4Ml2+orOmxqVZ3RaBdOuhj7EAErReZ+DMVzJsvAPyIL45ctF3xfFLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We get illegal instruction trap whenever Guest/VM executes WFI
instruction.

This patch handles WFI trap by blocking the trapped VCPU using
kvm_vcpu_block() API. The blocked VCPU will be automatically
resumed whenever a VCPU interrupt is injected from user-space
or from in-kernel IRQCHIP emulation.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/kvm/vcpu_exit.c | 76 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index dc66be032ad7..1873b8c35101 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -12,6 +12,13 @@
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
 
+#define INSN_OPCODE_MASK	0x007c
+#define INSN_OPCODE_SHIFT	2
+#define INSN_OPCODE_SYSTEM	28
+
+#define INSN_MASK_WFI		0xffffff00
+#define INSN_MATCH_WFI		0x10500000
+
 #define INSN_MATCH_LB		0x3
 #define INSN_MASK_LB		0x707f
 #define INSN_MATCH_LH		0x1003
@@ -116,6 +123,71 @@
 				 (s32)(((insn) >> 7) & 0x1f))
 #define MASK_FUNCT3		0x7000
 
+static int truly_illegal_insn(struct kvm_vcpu *vcpu,
+			      struct kvm_run *run,
+			      ulong insn)
+{
+	struct kvm_cpu_trap utrap = { 0 };
+
+	/* Redirect trap to Guest VCPU */
+	utrap.sepc = vcpu->arch.guest_context.sepc;
+	utrap.scause = EXC_INST_ILLEGAL;
+	utrap.stval = insn;
+	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+
+	return 1;
+}
+
+static int system_opcode_insn(struct kvm_vcpu *vcpu,
+			      struct kvm_run *run,
+			      ulong insn)
+{
+	if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
+		vcpu->stat.wfi_exit_stat++;
+		if (!kvm_arch_vcpu_runnable(vcpu)) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			kvm_vcpu_block(vcpu);
+			vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		}
+		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
+		return 1;
+	}
+
+	return truly_illegal_insn(vcpu, run, insn);
+}
+
+static int virtual_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			      struct kvm_cpu_trap *trap)
+{
+	unsigned long insn = trap->stval;
+	struct kvm_cpu_trap utrap = { 0 };
+	struct kvm_cpu_context *ct;
+
+	if (unlikely(INSN_IS_16BIT(insn))) {
+		if (insn == 0) {
+			ct = &vcpu->arch.guest_context;
+			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
+							  ct->sepc,
+							  &utrap);
+			if (utrap.scause) {
+				utrap.sepc = ct->sepc;
+				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+				return 1;
+			}
+		}
+		if (INSN_IS_16BIT(insn))
+			return truly_illegal_insn(vcpu, run, insn);
+	}
+
+	switch ((insn & INSN_OPCODE_MASK) >> INSN_OPCODE_SHIFT) {
+	case INSN_OPCODE_SYSTEM:
+		return system_opcode_insn(vcpu, run, insn);
+	default:
+		return truly_illegal_insn(vcpu, run, insn);
+	}
+}
+
 static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long fault_addr, unsigned long htinst)
 {
@@ -596,6 +668,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	ret = -EFAULT;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (trap->scause) {
+	case EXC_VIRTUAL_INST_FAULT:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = virtual_inst_fault(vcpu, run, trap);
+		break;
 	case EXC_INST_GUEST_PAGE_FAULT:
 	case EXC_LOAD_GUEST_PAGE_FAULT:
 	case EXC_STORE_GUEST_PAGE_FAULT:
-- 
2.25.1

