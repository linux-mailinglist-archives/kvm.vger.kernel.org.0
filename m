Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45ECD1841F0
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgCMH6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:58:32 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:59666 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgCMH6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086312; x=1615622312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=tcSoLy1EnieZpT0caedtjDa7Hpimh/vLp79G6OSD2BY=;
  b=ar2ya/C6ss0rBwBGv9cKpzYqbub7cGcq3BpIwQ2ZFMBLMAEYDHsLBKlM
   7wLqNEq6tKTHXMetdmupYta1FZFh83ER0f5y+kqbOQqMdD3Gpp6ULvvSb
   TmJIQr2c1+p+FClV57eLzBdnluxOiyQ1UaBCsI8DzxHJHJ/jFVAveKe6S
   ZcdpfT3SI+Zj5Jzzw9keqUSYYDxEBLmJdwNT5MFv6rZ7RzmdjIxbtDGXB
   fyQaXRgqSnSFaq/SQRvDI3SpIdh/weq90YB4cmvm2yH6D537XEnDzeAtF
   N+QcmLTpJMWSnn/0/Ubwwuafpz3xXjTXRCcu66NhfiAkrOn0cNO72ZCtI
   w==;
IronPort-SDR: jbkrVR86R3XzxN7KyTX9N+3CEqO369pBZW9jydZUFhFMH87+HB8lndmSIuR0X2GYaGJMNSNAj0
 UQQM5yzf5thgxtj+fdefc55CUiDmr/a0yuycFMuBHhGbpnuRNhZn5Ype+qv+iRMdo30Jc/fmh1
 47AUcyE17dposchMhXD8BGbl/6TN2HbmxM+CvlzRzaZly96uGQ/uvnThYc1poPCCeIXGlQlbwq
 vLqfbXSFR6AwEQ0YrtB3W61tAJ55LxIhJQRWrAiy/Wgpd1Vws/6rVpRKp4f/S6HfkEATgVh7wj
 pfI=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="136737260"
Received: from mail-cys01nam02lp2053.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.53])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:58:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRw2WbYLzQcZLiMEwkkD0HkluvdibWPdApg8zol/1N/BC9FKDXKq2k3XgsVfQJjJu8XBBpSnxQPCxxnSuLL2H9/WK1UYS5RtUMh/W4FTB9OXEB46kqfbRPZID2JovmmV1vLmlLcp/2GhlMSdqzV83wRLH2IR+tmoI+ND613FSOC2d1fwpO6LcbQyW7vf8HOKL/90Taad0mVx/SGVFoBUv0nDoBFte+e6SAAeR3dB98/HFdKjYFrtxf/EwGzjUd8WZyEREJKwrBb4IyKsYOIcYGA1F2IyVOOs2Pz64ADvphYb+pi2qtYRha4+AZUoBnGXwPcC6+y52znPB4drAPDHsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSdJ4PfdlFJVjQ3OtupZHstMU6rZxhSt+M05Rz6UEFQ=;
 b=UvPuW+mNLB3b0jYzBy4s9Dkb0vqsiwNrVF9AAy/QTxmVvq9XF2YXYgP8hA7+68bpokxlDGHLtLxqhWbl/hmdbLu0xZ0JZcnvbYyfzxRLKTvL/kgGo0f1HBwZV4dauloqDMs9a3Qb4nWFcLtfcwjrEo2RuE09gYCaaIQgT5/s/LbQCoKuNo7XTrO01qobnVsQToe5YqL/7s1GMUPLEZZhBjBFHiiqYyvspz9aZuHfSeXfu/jo1yCNuMdTa66OKN3UwzJbbvFcM5gbRcXEe/lOboeLfPEV5ewwfionXSva2FDqpDIgNUAuWvUXgGJPcmssbJM3aTLJHcwWG+aw16o/sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSdJ4PfdlFJVjQ3OtupZHstMU6rZxhSt+M05Rz6UEFQ=;
 b=G33bbtNvZhFgkoRsOmDlL6aQgjR2JJLdI7iaNTOFVea0IAgVv7O52k4A5IhswWGP/8VtDJrgVz4ruTjDwS3kuGMeyZ/jOs68sOC4SXk5FuFGXRHl43FxvW4bEYjAH2UMV3Ma9WXkpCZuSvr1HvUY7+xSkuPBl5th7GbOGvFdRW4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6944.namprd04.prod.outlook.com (2603:10b6:208:1ed::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Fri, 13 Mar
 2020 07:58:24 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:58:23 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 11/20] RISC-V: KVM: Handle WFI exits for VCPU
Date:   Fri, 13 Mar 2020 13:21:22 +0530
Message-Id: <20200313075131.69837-12-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:58:16 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 04c69c8e-60cd-47a9-499e-08d7c7244dda
X-MS-TrafficTypeDiagnostic: MN2PR04MB6944:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB694457021CD9F6CDBF55E85E8DFA0@MN2PR04MB6944.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(199004)(26005)(4326008)(44832011)(55016002)(1076003)(8936002)(478600001)(86362001)(36756003)(66556008)(16526019)(66946007)(956004)(66476007)(186003)(2616005)(316002)(7416002)(6666004)(1006002)(110136005)(8886007)(8676002)(2906002)(81166006)(81156014)(5660300002)(54906003)(52116002)(7696005)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6944;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAn2BgCfnsBRRyisMyiPyWMmzmXbjfGIXAZAa7R9iNXQf2iVqi0l3WyQgENWLl/l4I9GCSeSSaqi/1c5YEpW8frprGUxrAf0tRla+7cbDJycXE1H8MwB0ClfHTP0MPLFRpg+WddYBeX6dgG2e44ZujMRh0ZKEl2Cz1vdg7riM6W/lLcGlLxs28OWIgC0wy6rM3mVTVoZvqqrwig7NrDW3tu0ZnF7lw/AacmJ8XA2AaerPSvtyPGKvHbU5c3YsjexbAsJrgOh5LkDGKW5PToOa3CRq8olcCi2ba6abaDcmcckqIfzNUgHZ8QL0zcqu3T8k96o8g2k21unRZSBH23b5jgROg7RdG9raE+s+3DsOpFoPYHsSJPEEKJHg6G0JnM37Y8xWzIylogKBfYMrNx0gDxQVFa4li4N41mYoH3Gf9GxwScXsMg0hgF2V9SyFb4rYMxR2+2GkTCLcmnzZLcOZSaPmQKIV9gkf0vHlqIXMsWaMF4rFOrAfsqDb8InVwsHFkPIjzTGGJoN86WVBLXr3Q==
X-MS-Exchange-AntiSpam-MessageData: RIbT1J/UoYm5jAdCEFL/49YVqndJbUlJtSRwaLORlkwOEDn0rkZx42OxliIEJhesUiZ1kTk/u5yLyUcFTuM/bvK0rdWDeJcriQ3NAZ1lFSfH9hAfLhz43CkkXm2elgbGAPaN2WtYSWGqjYGtdJfTFA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c69c8e-60cd-47a9-499e-08d7c7244dda
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:58:23.8104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNSTmB4SQSrLMHIc7Z3ENIgpYxJ3Rr9LX7elIxvqjD/Xqzuej0jr9xUBiy1tI042EU5iei6bv66yr6DCNW8kFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6944
Sender: kvm-owner@vger.kernel.org
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
 arch/riscv/kvm/vcpu_exit.c | 72 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index cbf973c5f2fb..8d0ae1a23b70 100644
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
@@ -116,6 +123,67 @@
 				 (s32)(((insn) >> 7) & 0x1f))
 #define MASK_FUNCT3		0x7000
 
+static int truly_illegal_insn(struct kvm_vcpu *vcpu,
+			      struct kvm_run *run,
+			      ulong insn)
+{
+	/* Redirect trap to Guest VCPU */
+	kvm_riscv_vcpu_trap_redirect(vcpu, EXC_INST_ILLEGAL, insn);
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
+static int illegal_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			      unsigned long insn)
+{
+	unsigned long ut_scause = 0;
+	struct kvm_cpu_context *ct;
+
+	if (unlikely(INSN_IS_16BIT(insn))) {
+		if (insn == 0) {
+			ct = &vcpu->arch.guest_context;
+			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
+							  ct->sepc,
+							  &ut_scause);
+			if (ut_scause) {
+				if (ut_scause == EXC_LOAD_PAGE_FAULT)
+					ut_scause = EXC_INST_PAGE_FAULT;
+				kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause,
+							     ct->sepc);
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
@@ -537,6 +605,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	ret = -EFAULT;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (scause) {
+	case EXC_INST_ILLEGAL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = illegal_inst_fault(vcpu, run, stval);
+		break;
 	case EXC_INST_GUEST_PAGE_FAULT:
 	case EXC_LOAD_GUEST_PAGE_FAULT:
 	case EXC_STORE_GUEST_PAGE_FAULT:
-- 
2.17.1

