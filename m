Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D02E1BB7AA
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgD1Heo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:34:44 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:32002 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgD1Hen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059283; x=1619595283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EB5sxr4KpsuOatyl9M1fQRCpJYhTQw8PSc/3PyB1svo=;
  b=lEDT28VbNUKWzVhDDrbKYXbM77YtElxPJBwxwMhrf2AzrYun4R4gPN4C
   fuV+zXqpztEvm6Kk1Exswf+pd0pnCFJYQ6FGfn+RMpjYHRHzOLfh+FzxZ
   3FTFn9wVjUJfUAntVNUxzdKdrdsf1UqTB8djPNUygr129ramvDOjqqmIM
   jUFsYOlDtz/AAF8NW/jbB9cyTeZXw2/S6G+KR8yDqRtXzmGfHfaRtyWr/
   NKsimeDY7hxWh86fMdxg4SlrIDgoXZT/2xvk2OuwMsX46uIx6ZvRVjL7B
   79TRaCRjSdvvoAVbCdpwRVmNfo+V6ihPnykjApdxopndCH/VPzEZueu8I
   w==;
IronPort-SDR: S2HWCiUWHvqkhqxxGRFl8kJy/1rYcPqFLRZRFgLHjg/Qv931U3atM97Xx5/DCa6VicwlYrAFDM
 l3pXEsKNeQOzJJpYx7Wu79SetIIxATgIOEDMytOkVxwWn3GwjKFbBkaObMCryQFxk6gI2Q2Tov
 BrREqVOQpTO5B2SD65TNW2ehs6F6IeTgFxqb1LLj3f3+35vl5rSw0I1WfBKrtmQb8k8Qf5Z8i2
 DEKb2/DoWXvuaNFv1H3INEitUThzca98njWrS6h9e2ygM5Vfx3YV4bzsLC34hFp5mf9wQtQX3a
 7VE=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="136630254"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:34:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjnuUw9DVWMfwIndKZBEQwZCNuOq0BqJ34xYg+crOr8Q4/3RjXtPtuS/KdrTlCKp8tTP8psyXD2P0ukrr4s4A9Y1CBoP+3BSc3vQkT7A6yVb/SS8eYApaCz2DKNKS70uYgBRm8gljrTs3EZxFjkWi5IZAxOabJWe8FQgACybx3AV37t+6oUsjNK7dAjvX7hkwUeltw2k5dOPX2zV53DWTSuaUdzSrcNti1ufXhWjfYPAbVwpkVkArATV4ZysqSfOIwklCtF0SGJx2v3Ps/k6sxl7Q+c1jwpHEpq5gICsIy02Y7kkkRigbx1FMmNlDm4Ao+K0ek6RKU/+bFf1NoAU0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK9OdkNMetdVxI4we/WQNUXA35syfWjjEGSzpz1lps8=;
 b=au3woG0PGOQ9GHVUeoB7u/Ci9Wj5+YWo33nvAu6TxKZq8yFd18PHmNVs1KInTEz7JcaCAejnkrtHXLM55u6HXK7PVDQUxYk6YZ+XFfwjLCXtAOtQmqGpbjnMOaX497ecpJi5UFDmm2AhvxwlIe54HRz3ppxGk0Urasgvdp4Yr9QE6gokTNyEs4O6fV89/uhFSYuEHNGyIP4F+yPMpCrJsPZhQkvos3qDbmbFkJKi8AwxP5nRDu9p8fSbJ+NSIt4+/IKnwI7dSM+FwDYtQ9hIBFKRAJLuWj2xHnCBRZE51YHsMJKiI/z0C4OO/cj1SBIzw6o96N/A86EUolR7lTgmXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK9OdkNMetdVxI4we/WQNUXA35syfWjjEGSzpz1lps8=;
 b=iqDlp926PhCRU0J5Ca+MlpL6Ds0ftzRPC8Ukr3xb+SzIAMk+UCnZn74B4K89ZJ/xvUXlF6221f4tu69o2C9bOxLX9JEte/e3xVGOruuvlJU9d+tAh05Ub7QLQshqNtKE1J4obhgOdEvk+b4lI78gwl4ZUhGIx8tlE2NPDU+SP+I=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5929.namprd04.prod.outlook.com (2603:10b6:5:170::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:34:40 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:34:40 +0000
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
Subject: [PATCH v12 08/17] RISC-V: KVM: Handle WFI exits for VCPU
Date:   Tue, 28 Apr 2020 13:03:03 +0530
Message-Id: <20200428073312.324684-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428073312.324684-1-anup.patel@wdc.com>
References: <20200428073312.324684-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:34:35 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 778235f9-fefc-4765-2c88-08d7eb469ca6
X-MS-TrafficTypeDiagnostic: DM6PR04MB5929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB59297FCBACC09FB3FA90E32F8DAC0@DM6PR04MB5929.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(1076003)(66946007)(2906002)(5660300002)(66556008)(66476007)(7416002)(86362001)(478600001)(55236004)(55016002)(186003)(8936002)(316002)(4326008)(7696005)(36756003)(956004)(110136005)(8886007)(2616005)(6666004)(26005)(16526019)(54906003)(44832011)(52116002)(81156014)(1006002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4vsmi3OSJvxRdYfwLUkGcBwqsdCh8tmXXKfhzzpIvpQMCAYU/OOKgZpAqlmauJjeBWi25sJb4Rocskp1bjqEhiIr1f2O0iFSUJnGUcSc3MYi1Hc1eIqTvbO1r1Zx6zg1dbbjGIJf/ePtWo3OBMbXsre5VujqGua+4UlbJBy0hKJuXb8dSkkRfJUakD5eTrlTbgivDq/5scMtUZctJKeYHAg2X8PVnfsmX/iVX024eQTzZSdIVbeTdH2YBp1NnrBIGfIdkQTLKMFQyaD9TY1Q+DRYa5O529oSni1Ds+54e/mhbntriwVC7DpDkx75TH2/2uWPzt3s7j1E8JvoDChwaoGa2YUvS37x1GkLAkhWGJDYNBU+XfjSdJB3wVeYPwicI1uY+4TfBE9jUFHinoQjXQowQhpvCkyPdcZiZqBVuz6KnO4XwMQwqo3kPdZjqBQ1
X-MS-Exchange-AntiSpam-MessageData: ps3MjWYuc7xpxXN1J3ZunSrUQhsuCCKYydFhexwWq4GzkYEbVied23KotHfJvIcoidBL8DuLqpP62LmJtcOTlFQMgEpc0A9X6tfkYd+lZfGynvSUADZ3FsAhAIBx3OAJt2vEd6tGRe2vzpJXmD3UUaOrpOtJXeeSUUVjiMLjTolA7keKt7V52RcmleC5RuuixWBwoF2DI11hKb5CFlhzov/InWw6peIFiWTR5qm/l8UoK6PUpEeAgTqW4MMlk7xV9ZdRPMh3u87mj6/1t4jCp0W1Vv1f9BC4VP7aZYUhxOmSX3gymrgY/gKrV6bDRJuyWvs7KqqD9iKNhM6MwIBePc0eZ7lMlzvQANSG3RgZvbkBOtsBH1qi0upZBMkPKQq9hKqRuGnFz9PU5trKjiQaj/SpUOzdvr1ziyFY6yVZwfR05k8OWw6sqVGtKcYimY/teZf+Se/wfhsbjFRefqnKuYWlSgSOIFgx3h73iQoY6vN5wBL3XB7xCnruSdGOBPo64n9hShvnuozxXpuuxszUvxS3C5YrlgsHuNtRlg4RpYO4MvSzmhFc1N8gxXOwBH+voGsF7krL9di2QCa3Ej3ReFz1QpBzIN1x2ETV2MMVjTofr59sduCHOFlqXno2iDmgoap8eTc/6OKGjA2TY+sij/3KQC5vIXBcYNUJ81HkPb3f6U5KEve/dkQa5urdklYWwJB27cfKnAsoFSGSkNWSFuLdmeQmtqhbZfgl76mlhilM6ETlsaGYdjaIjbl2X0MQfp5xKeN5Tja99omFMVSj7kgnoUxtEpHZnvFGZ2ZUNp8=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 778235f9-fefc-4765-2c88-08d7eb469ca6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:34:40.7466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvdlyLraZ2kbRrFIMbiwIbDDVOnKzNV19DYAT4Kp/ZFYQdcDF7bJnCuAm4JisF26BA/IMAnqu30VvkCWRMs+yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5929
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
 arch/riscv/kvm/vcpu_exit.c | 76 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 35101ba8814d..2384b4bf4939 100644
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
+static int illegal_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
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
@@ -549,6 +621,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	ret = -EFAULT;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (trap->scause) {
+	case EXC_INST_ILLEGAL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = illegal_inst_fault(vcpu, run, trap);
+		break;
 	case EXC_INST_GUEST_PAGE_FAULT:
 	case EXC_LOAD_GUEST_PAGE_FAULT:
 	case EXC_STORE_GUEST_PAGE_FAULT:
-- 
2.25.1

