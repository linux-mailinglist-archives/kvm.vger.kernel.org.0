Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE03257945
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgHaMbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:31:39 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45671 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgHaMbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877071; x=1630413071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=yrAiTXBm0yX+I4wim9zJ1EqhZZPxP9gTtngTuqTywEw=;
  b=eKNhIPTc0dg1lsKY3fea5PMOFYXiS/m6SlfEwRfvDQCZ8DJKilAyX+wy
   lBXnDt3MO9NocTP1bupQg2c9DOFKSlXbOE1dWpZ3Jfw5BO3uuimLtU+u6
   qD/C81zMUbm7wVk7qe8Rb7PzGoxJSAi6zra+bJDnIypYtMIvfBO+duTY6
   QMKlsMeFVdQ8OMWrgY+92kIW8O8RnaetBtoNvs9N6pVjqPRn8cqPOElo9
   SjphmLtUjVuy1/OjLFTR6zqd9/s0eov3U0MY0kumIwTJ/l5azDYOY62ab
   jtEusetBRUTEcbSHB4xf7SzUeWG1f3EOna0fiVhqoO9X9C0C1tkzFLq3u
   w==;
IronPort-SDR: RSq/BUNdheoIgqyNrA9hr30t+kZuh1WBjJo+nH3Y5WA3u7Zpl7KLFGwM2eZqNTYmhs9dcMoVvf
 cyH7/swZg81X50haUtL8jaxxjduluAkyABKb3P+jUIM4RUiP1rM4tqHShKYYLPVjE4MH+54Zof
 F+E9j73s4IgeTC4TnnTv+zz3FAOCr3kyrTG9ZbXx+Vvzhm2+tlV73CyII1SIX4N3sSgTwvtTE4
 jOyiX65S3lQ0OsKZAtE3S0Pot34313GBsBxBpwV8kC38u6U0SVK/aDW9GRX2LLE1/J6RVTT2zf
 o2Q=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="255743338"
Received: from mail-sn1nam02lp2052.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.52])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:31:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwbEMdFsgljrxHg2qxnyd08Nnia+fVbQtBf4mg2BbMbdzLxhMETBjdFyA23KmIfLTmT2j8ar6OgvM3KEk65kIDicKuN2AbtPZEmzVE6aK97MAMc0AnL+3qsrdg3jtOONA2b3pYyIsWUykstEXwX03vbv5GzXu+HNqzVspG/knPi1y0zl1QJ9c0knv6CT4ujSr9gA8n1RKmyseh3OWHHRcF+9if4f6NfnoPFZncFj76mqnB3TU64TYRGJbGvqPKH7RJN2O6eS/ddkMwO/pT6/t2kYL9L0Ms+oyDtuRHo3G96tCVvszaHk0Vin/Ub2yAMqz6cMm55XZ1H1VFBYrOt4ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsNEFrlhdM0P+GxTagvhNugZJ+qLn/xtCZf5nFxwEeE=;
 b=KkxlAUm4msgXZXtfUPbmBQEcEBwH7Y408GZ6bLOiGQhY3kLaIZvhPjZXncbY3UjeonfLLCIHJ+u7GYBgD26Xcc6QCzf6YqBPu9lXpyHqYZVJzrU8P5lHR+gQgCdJcojVMNqpOQj3E8Wiwr4kKW6bURGMYtUHVl0ls5Bp2rAH96FIyYxYxnBwVhHaZJcqYwWtse7kVNAn1xFeLTxwBPSumABbAe2X7R082oKH3tJoqfuj0YhDPp4M6WYPH3In3rcvFPhJJBH5Hg8fNgWW1gGTmjdNJFt2bKv4vcB0KUoUKKLboqsmmR2fkTZHkgTLA7V1qotvmS/OBV3Nvb5v9FB8Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsNEFrlhdM0P+GxTagvhNugZJ+qLn/xtCZf5nFxwEeE=;
 b=SavzG9rWvgOm0F3gH1oUx1jlapGKnTTXODcEfEl8J1hDcVK/NGGHOnsV/GyTla474iFcocQwj3n6T9zQ9Fb0wmIvWDENrtyVugn8l8eiim29yw2wswUlmlkGkvWzuiRpjlpXJslBf4BDA9/Ya63eC0bJ9lyyk4fzyrU7zaOtCR4=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6092.namprd04.prod.outlook.com (2603:10b6:5:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Mon, 31 Aug
 2020 12:31:09 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:31:09 +0000
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
Subject: [PATCH v14 06/17] RISC-V: KVM: Implement VCPU world-switch
Date:   Mon, 31 Aug 2020 18:00:04 +0530
Message-Id: <20200831123015.336047-7-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831123015.336047-1-anup.patel@wdc.com>
References: <20200831123015.336047-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::32) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:31:05 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a7c91ee-cbe4-4f90-3b06-08d84da9bd3c
X-MS-TrafficTypeDiagnostic: DM6PR04MB6092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB609233059E25742FBE3FBC2C8D510@DM6PR04MB6092.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDcDoNkLN9QAuP582133Sk1ayCYdX5aY7BILx3K38k70nn4+XQOpFjbf2V30WtQ5J82BYiOP1a9ZtjqMLZZhQC9VZuSl9mNNZh/J9iHmtT1DEXJgq6zXRLYxAdoAzoGBxe1cs79hHtOpJMkxwY76nRrZzeZNGYRlsYxGyCAR3fxihzO+kMMCu0CSLs0O+JKP6hO6JuoGoqyPSqVfDvB+Btu1kTb12F3/n1gwhoTFrIP026tmZqJGlRWMo1x8fMMdUnPsjMZ1iQ617+kQH8Pe2GzX8QNRxrKe70KT11awi+Yi55dQCLQ1IbuQ/M/vXrHg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(44832011)(52116002)(8676002)(86362001)(36756003)(478600001)(6486002)(7416002)(30864003)(110136005)(8936002)(54906003)(83380400001)(66946007)(1076003)(66556008)(2906002)(26005)(186003)(66476007)(956004)(316002)(16576012)(4326008)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /NL9QeXCuN6hwiZmkxWvToq9mUWYLYcWgU4XRLRgNa9xX9iqx70RJqaBjSkrOQEYSbTwelx3XiI/zcY6a8tk3tuObfPn0SaNkqx1v9Lj15Wbhzut/fXRGkfMBnwB30CplZm1ula+v6wuwGQxv3ad9HvsxsVWfSlqr9+FTLA16mXVj3wXSv6ASEHDXd9dRpPiA6ujPhk/1EPUPNxgPno05zfmlCb43xz5OO+/a/o3cCzZ7cfUMnj3tHsK9BQuDvDCMFbpwscMgFlvzw/h/bbXIsqsLb4ilIiVwMWh9bBIQD70jzRtoAi0ZA+uutFlGgzPB5edxfG/0RrtCPMydXWtLA70ofktNh86d0J8qKGfVpWKNpMJj83/uLO4eEsFlN6LPJ0IfovvxLa2iUL2s4vKbi1u+BZhupcDdn4NxDBBc5Je879YtRpVI1fiCLMqANB0aVB2rvrKZZ9BpUkh8RsUScdty1jf8pOMFAZhYYmIJDrIInusoFSoL4PXxh5JxIWXtMSQHvU+28mjZjVJE7QKRAlaVq+LFxsjI8Bl7I2GE6+doTRiYrwx3Wmi27nPJeiBTSGYoKQCy3+fPMl4ZWHHdA271GoYHE8xqD1jvnZxdrAz35fn6yLdw/7DC1x5jmJ2kjeQuUvk/8frnFm7Tr2nlw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7c91ee-cbe4-4f90-3b06-08d84da9bd3c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:31:09.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZxcS+udJ3c4MKo3itLLUfkAeV7d+Rb9rEXwqluJwfhuDBt7tZ4T2vEWiM1o0iIqLQKjMmTBgVlBs7JbwamrAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements the VCPU world-switch for KVM RISC-V.

The KVM RISC-V world-switch (i.e. __kvm_riscv_switch_to()) mostly
switches general purpose registers, SSTATUS, STVEC, SSCRATCH and
HSTATUS CSRs. Other CSRs are switched via vcpu_load() and vcpu_put()
interface in kvm_arch_vcpu_load() and kvm_arch_vcpu_put() functions
respectively.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  10 +-
 arch/riscv/kernel/asm-offsets.c   |  78 ++++++++++++
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu.c             |  30 ++++-
 arch/riscv/kvm/vcpu_switch.S      | 203 ++++++++++++++++++++++++++++++
 5 files changed, 319 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_switch.S

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 8829bed4517f..e2f5523e26de 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -121,6 +121,14 @@ struct kvm_vcpu_arch {
 	/* ISA feature bits (similar to MISA) */
 	unsigned long isa;
 
+	/* SSCRATCH, STVEC, and SCOUNTEREN of Host */
+	unsigned long host_sscratch;
+	unsigned long host_stvec;
+	unsigned long host_scounteren;
+
+	/* CPU context of Host */
+	struct kvm_cpu_context host_context;
+
 	/* CPU context of Guest VCPU */
 	struct kvm_cpu_context guest_context;
 
@@ -170,7 +178,7 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
-static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
+void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index db203442c08f..83425ce20804 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -7,7 +7,9 @@
 #define GENERATING_ASM_OFFSETS
 
 #include <linux/kbuild.h>
+#include <linux/mm.h>
 #include <linux/sched.h>
+#include <asm/kvm_host.h>
 #include <asm/thread_info.h>
 #include <asm/ptrace.h>
 
@@ -106,6 +108,82 @@ void asm_offsets(void)
 	OFFSET(PT_BADADDR, pt_regs, badaddr);
 	OFFSET(PT_CAUSE, pt_regs, cause);
 
+	OFFSET(KVM_ARCH_GUEST_ZERO, kvm_vcpu_arch, guest_context.zero);
+	OFFSET(KVM_ARCH_GUEST_RA, kvm_vcpu_arch, guest_context.ra);
+	OFFSET(KVM_ARCH_GUEST_SP, kvm_vcpu_arch, guest_context.sp);
+	OFFSET(KVM_ARCH_GUEST_GP, kvm_vcpu_arch, guest_context.gp);
+	OFFSET(KVM_ARCH_GUEST_TP, kvm_vcpu_arch, guest_context.tp);
+	OFFSET(KVM_ARCH_GUEST_T0, kvm_vcpu_arch, guest_context.t0);
+	OFFSET(KVM_ARCH_GUEST_T1, kvm_vcpu_arch, guest_context.t1);
+	OFFSET(KVM_ARCH_GUEST_T2, kvm_vcpu_arch, guest_context.t2);
+	OFFSET(KVM_ARCH_GUEST_S0, kvm_vcpu_arch, guest_context.s0);
+	OFFSET(KVM_ARCH_GUEST_S1, kvm_vcpu_arch, guest_context.s1);
+	OFFSET(KVM_ARCH_GUEST_A0, kvm_vcpu_arch, guest_context.a0);
+	OFFSET(KVM_ARCH_GUEST_A1, kvm_vcpu_arch, guest_context.a1);
+	OFFSET(KVM_ARCH_GUEST_A2, kvm_vcpu_arch, guest_context.a2);
+	OFFSET(KVM_ARCH_GUEST_A3, kvm_vcpu_arch, guest_context.a3);
+	OFFSET(KVM_ARCH_GUEST_A4, kvm_vcpu_arch, guest_context.a4);
+	OFFSET(KVM_ARCH_GUEST_A5, kvm_vcpu_arch, guest_context.a5);
+	OFFSET(KVM_ARCH_GUEST_A6, kvm_vcpu_arch, guest_context.a6);
+	OFFSET(KVM_ARCH_GUEST_A7, kvm_vcpu_arch, guest_context.a7);
+	OFFSET(KVM_ARCH_GUEST_S2, kvm_vcpu_arch, guest_context.s2);
+	OFFSET(KVM_ARCH_GUEST_S3, kvm_vcpu_arch, guest_context.s3);
+	OFFSET(KVM_ARCH_GUEST_S4, kvm_vcpu_arch, guest_context.s4);
+	OFFSET(KVM_ARCH_GUEST_S5, kvm_vcpu_arch, guest_context.s5);
+	OFFSET(KVM_ARCH_GUEST_S6, kvm_vcpu_arch, guest_context.s6);
+	OFFSET(KVM_ARCH_GUEST_S7, kvm_vcpu_arch, guest_context.s7);
+	OFFSET(KVM_ARCH_GUEST_S8, kvm_vcpu_arch, guest_context.s8);
+	OFFSET(KVM_ARCH_GUEST_S9, kvm_vcpu_arch, guest_context.s9);
+	OFFSET(KVM_ARCH_GUEST_S10, kvm_vcpu_arch, guest_context.s10);
+	OFFSET(KVM_ARCH_GUEST_S11, kvm_vcpu_arch, guest_context.s11);
+	OFFSET(KVM_ARCH_GUEST_T3, kvm_vcpu_arch, guest_context.t3);
+	OFFSET(KVM_ARCH_GUEST_T4, kvm_vcpu_arch, guest_context.t4);
+	OFFSET(KVM_ARCH_GUEST_T5, kvm_vcpu_arch, guest_context.t5);
+	OFFSET(KVM_ARCH_GUEST_T6, kvm_vcpu_arch, guest_context.t6);
+	OFFSET(KVM_ARCH_GUEST_SEPC, kvm_vcpu_arch, guest_context.sepc);
+	OFFSET(KVM_ARCH_GUEST_SSTATUS, kvm_vcpu_arch, guest_context.sstatus);
+	OFFSET(KVM_ARCH_GUEST_HSTATUS, kvm_vcpu_arch, guest_context.hstatus);
+	OFFSET(KVM_ARCH_GUEST_SCOUNTEREN, kvm_vcpu_arch, guest_csr.scounteren);
+
+	OFFSET(KVM_ARCH_HOST_ZERO, kvm_vcpu_arch, host_context.zero);
+	OFFSET(KVM_ARCH_HOST_RA, kvm_vcpu_arch, host_context.ra);
+	OFFSET(KVM_ARCH_HOST_SP, kvm_vcpu_arch, host_context.sp);
+	OFFSET(KVM_ARCH_HOST_GP, kvm_vcpu_arch, host_context.gp);
+	OFFSET(KVM_ARCH_HOST_TP, kvm_vcpu_arch, host_context.tp);
+	OFFSET(KVM_ARCH_HOST_T0, kvm_vcpu_arch, host_context.t0);
+	OFFSET(KVM_ARCH_HOST_T1, kvm_vcpu_arch, host_context.t1);
+	OFFSET(KVM_ARCH_HOST_T2, kvm_vcpu_arch, host_context.t2);
+	OFFSET(KVM_ARCH_HOST_S0, kvm_vcpu_arch, host_context.s0);
+	OFFSET(KVM_ARCH_HOST_S1, kvm_vcpu_arch, host_context.s1);
+	OFFSET(KVM_ARCH_HOST_A0, kvm_vcpu_arch, host_context.a0);
+	OFFSET(KVM_ARCH_HOST_A1, kvm_vcpu_arch, host_context.a1);
+	OFFSET(KVM_ARCH_HOST_A2, kvm_vcpu_arch, host_context.a2);
+	OFFSET(KVM_ARCH_HOST_A3, kvm_vcpu_arch, host_context.a3);
+	OFFSET(KVM_ARCH_HOST_A4, kvm_vcpu_arch, host_context.a4);
+	OFFSET(KVM_ARCH_HOST_A5, kvm_vcpu_arch, host_context.a5);
+	OFFSET(KVM_ARCH_HOST_A6, kvm_vcpu_arch, host_context.a6);
+	OFFSET(KVM_ARCH_HOST_A7, kvm_vcpu_arch, host_context.a7);
+	OFFSET(KVM_ARCH_HOST_S2, kvm_vcpu_arch, host_context.s2);
+	OFFSET(KVM_ARCH_HOST_S3, kvm_vcpu_arch, host_context.s3);
+	OFFSET(KVM_ARCH_HOST_S4, kvm_vcpu_arch, host_context.s4);
+	OFFSET(KVM_ARCH_HOST_S5, kvm_vcpu_arch, host_context.s5);
+	OFFSET(KVM_ARCH_HOST_S6, kvm_vcpu_arch, host_context.s6);
+	OFFSET(KVM_ARCH_HOST_S7, kvm_vcpu_arch, host_context.s7);
+	OFFSET(KVM_ARCH_HOST_S8, kvm_vcpu_arch, host_context.s8);
+	OFFSET(KVM_ARCH_HOST_S9, kvm_vcpu_arch, host_context.s9);
+	OFFSET(KVM_ARCH_HOST_S10, kvm_vcpu_arch, host_context.s10);
+	OFFSET(KVM_ARCH_HOST_S11, kvm_vcpu_arch, host_context.s11);
+	OFFSET(KVM_ARCH_HOST_T3, kvm_vcpu_arch, host_context.t3);
+	OFFSET(KVM_ARCH_HOST_T4, kvm_vcpu_arch, host_context.t4);
+	OFFSET(KVM_ARCH_HOST_T5, kvm_vcpu_arch, host_context.t5);
+	OFFSET(KVM_ARCH_HOST_T6, kvm_vcpu_arch, host_context.t6);
+	OFFSET(KVM_ARCH_HOST_SEPC, kvm_vcpu_arch, host_context.sepc);
+	OFFSET(KVM_ARCH_HOST_SSTATUS, kvm_vcpu_arch, host_context.sstatus);
+	OFFSET(KVM_ARCH_HOST_HSTATUS, kvm_vcpu_arch, host_context.hstatus);
+	OFFSET(KVM_ARCH_HOST_SSCRATCH, kvm_vcpu_arch, host_sscratch);
+	OFFSET(KVM_ARCH_HOST_STVEC, kvm_vcpu_arch, host_stvec);
+	OFFSET(KVM_ARCH_HOST_SCOUNTEREN, kvm_vcpu_arch, host_scounteren);
+
 	/*
 	 * THREAD_{F,X}* might be larger than a S-type offset can handle, but
 	 * these are used in performance-sensitive assembly so we can't resort
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 37b5a59d4f4f..845579273727 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -8,6 +8,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
 kvm-objs := $(common-objs-y)
 
-kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o
+kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e38eedc784a7..43962a25fa55 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -580,14 +580,40 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	/* TODO: */
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	csr_write(CSR_VSSTATUS, csr->vsstatus);
+	csr_write(CSR_HIE, csr->hie);
+	csr_write(CSR_VSTVEC, csr->vstvec);
+	csr_write(CSR_VSSCRATCH, csr->vsscratch);
+	csr_write(CSR_VSEPC, csr->vsepc);
+	csr_write(CSR_VSCAUSE, csr->vscause);
+	csr_write(CSR_VSTVAL, csr->vstval);
+	csr_write(CSR_HVIP, csr->hvip);
+	csr_write(CSR_VSATP, csr->vsatp);
 
 	kvm_riscv_stage2_update_hgatp(vcpu);
+
+	vcpu->cpu = cpu;
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	vcpu->cpu = -1;
+
+	csr_write(CSR_HGATP, 0);
+
+	csr->vsstatus = csr_read(CSR_VSSTATUS);
+	csr->hie = csr_read(CSR_HIE);
+	csr->vstvec = csr_read(CSR_VSTVEC);
+	csr->vsscratch = csr_read(CSR_VSSCRATCH);
+	csr->vsepc = csr_read(CSR_VSEPC);
+	csr->vscause = csr_read(CSR_VSCAUSE);
+	csr->vstval = csr_read(CSR_VSTVAL);
+	csr->hvip = csr_read(CSR_HVIP);
+	csr->vsatp = csr_read(CSR_VSATP);
 }
 
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
new file mode 100644
index 000000000000..5174b025ff4e
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -0,0 +1,203 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
+#include <asm/csr.h>
+
+	.text
+	.altmacro
+	.option norelax
+
+ENTRY(__kvm_riscv_switch_to)
+	/* Save Host GPRs (except A0 and T0-T6) */
+	REG_S	ra, (KVM_ARCH_HOST_RA)(a0)
+	REG_S	sp, (KVM_ARCH_HOST_SP)(a0)
+	REG_S	gp, (KVM_ARCH_HOST_GP)(a0)
+	REG_S	tp, (KVM_ARCH_HOST_TP)(a0)
+	REG_S	s0, (KVM_ARCH_HOST_S0)(a0)
+	REG_S	s1, (KVM_ARCH_HOST_S1)(a0)
+	REG_S	a1, (KVM_ARCH_HOST_A1)(a0)
+	REG_S	a2, (KVM_ARCH_HOST_A2)(a0)
+	REG_S	a3, (KVM_ARCH_HOST_A3)(a0)
+	REG_S	a4, (KVM_ARCH_HOST_A4)(a0)
+	REG_S	a5, (KVM_ARCH_HOST_A5)(a0)
+	REG_S	a6, (KVM_ARCH_HOST_A6)(a0)
+	REG_S	a7, (KVM_ARCH_HOST_A7)(a0)
+	REG_S	s2, (KVM_ARCH_HOST_S2)(a0)
+	REG_S	s3, (KVM_ARCH_HOST_S3)(a0)
+	REG_S	s4, (KVM_ARCH_HOST_S4)(a0)
+	REG_S	s5, (KVM_ARCH_HOST_S5)(a0)
+	REG_S	s6, (KVM_ARCH_HOST_S6)(a0)
+	REG_S	s7, (KVM_ARCH_HOST_S7)(a0)
+	REG_S	s8, (KVM_ARCH_HOST_S8)(a0)
+	REG_S	s9, (KVM_ARCH_HOST_S9)(a0)
+	REG_S	s10, (KVM_ARCH_HOST_S10)(a0)
+	REG_S	s11, (KVM_ARCH_HOST_S11)(a0)
+
+	/* Save Host and Restore Guest SSTATUS */
+	REG_L	t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	csrrw	t0, CSR_SSTATUS, t0
+	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
+
+	/* Save Host and Restore Guest HSTATUS */
+	REG_L	t1, (KVM_ARCH_GUEST_HSTATUS)(a0)
+	csrrw	t1, CSR_HSTATUS, t1
+	REG_S	t1, (KVM_ARCH_HOST_HSTATUS)(a0)
+
+	/* Save Host and Restore Guest SCOUNTEREN */
+	REG_L	t2, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
+	csrrw	t2, CSR_SCOUNTEREN, t2
+	REG_S	t2, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
+
+	/* Save Host SSCRATCH and change it to struct kvm_vcpu_arch pointer */
+	csrrw	t3, CSR_SSCRATCH, a0
+	REG_S	t3, (KVM_ARCH_HOST_SSCRATCH)(a0)
+
+	/* Save Host STVEC and change it to return path */
+	la	t4, __kvm_switch_return
+	csrrw	t4, CSR_STVEC, t4
+	REG_S	t4, (KVM_ARCH_HOST_STVEC)(a0)
+
+	/* Restore Guest SEPC */
+	REG_L	t0, (KVM_ARCH_GUEST_SEPC)(a0)
+	csrw	CSR_SEPC, t0
+
+	/* Restore Guest GPRs (except A0) */
+	REG_L	ra, (KVM_ARCH_GUEST_RA)(a0)
+	REG_L	sp, (KVM_ARCH_GUEST_SP)(a0)
+	REG_L	gp, (KVM_ARCH_GUEST_GP)(a0)
+	REG_L	tp, (KVM_ARCH_GUEST_TP)(a0)
+	REG_L	t0, (KVM_ARCH_GUEST_T0)(a0)
+	REG_L	t1, (KVM_ARCH_GUEST_T1)(a0)
+	REG_L	t2, (KVM_ARCH_GUEST_T2)(a0)
+	REG_L	s0, (KVM_ARCH_GUEST_S0)(a0)
+	REG_L	s1, (KVM_ARCH_GUEST_S1)(a0)
+	REG_L	a1, (KVM_ARCH_GUEST_A1)(a0)
+	REG_L	a2, (KVM_ARCH_GUEST_A2)(a0)
+	REG_L	a3, (KVM_ARCH_GUEST_A3)(a0)
+	REG_L	a4, (KVM_ARCH_GUEST_A4)(a0)
+	REG_L	a5, (KVM_ARCH_GUEST_A5)(a0)
+	REG_L	a6, (KVM_ARCH_GUEST_A6)(a0)
+	REG_L	a7, (KVM_ARCH_GUEST_A7)(a0)
+	REG_L	s2, (KVM_ARCH_GUEST_S2)(a0)
+	REG_L	s3, (KVM_ARCH_GUEST_S3)(a0)
+	REG_L	s4, (KVM_ARCH_GUEST_S4)(a0)
+	REG_L	s5, (KVM_ARCH_GUEST_S5)(a0)
+	REG_L	s6, (KVM_ARCH_GUEST_S6)(a0)
+	REG_L	s7, (KVM_ARCH_GUEST_S7)(a0)
+	REG_L	s8, (KVM_ARCH_GUEST_S8)(a0)
+	REG_L	s9, (KVM_ARCH_GUEST_S9)(a0)
+	REG_L	s10, (KVM_ARCH_GUEST_S10)(a0)
+	REG_L	s11, (KVM_ARCH_GUEST_S11)(a0)
+	REG_L	t3, (KVM_ARCH_GUEST_T3)(a0)
+	REG_L	t4, (KVM_ARCH_GUEST_T4)(a0)
+	REG_L	t5, (KVM_ARCH_GUEST_T5)(a0)
+	REG_L	t6, (KVM_ARCH_GUEST_T6)(a0)
+
+	/* Restore Guest A0 */
+	REG_L	a0, (KVM_ARCH_GUEST_A0)(a0)
+
+	/* Resume Guest */
+	sret
+
+	/* Back to Host */
+	.align 2
+__kvm_switch_return:
+	/* Swap Guest A0 with SSCRATCH */
+	csrrw	a0, CSR_SSCRATCH, a0
+
+	/* Save Guest GPRs (except A0) */
+	REG_S	ra, (KVM_ARCH_GUEST_RA)(a0)
+	REG_S	sp, (KVM_ARCH_GUEST_SP)(a0)
+	REG_S	gp, (KVM_ARCH_GUEST_GP)(a0)
+	REG_S	tp, (KVM_ARCH_GUEST_TP)(a0)
+	REG_S	t0, (KVM_ARCH_GUEST_T0)(a0)
+	REG_S	t1, (KVM_ARCH_GUEST_T1)(a0)
+	REG_S	t2, (KVM_ARCH_GUEST_T2)(a0)
+	REG_S	s0, (KVM_ARCH_GUEST_S0)(a0)
+	REG_S	s1, (KVM_ARCH_GUEST_S1)(a0)
+	REG_S	a1, (KVM_ARCH_GUEST_A1)(a0)
+	REG_S	a2, (KVM_ARCH_GUEST_A2)(a0)
+	REG_S	a3, (KVM_ARCH_GUEST_A3)(a0)
+	REG_S	a4, (KVM_ARCH_GUEST_A4)(a0)
+	REG_S	a5, (KVM_ARCH_GUEST_A5)(a0)
+	REG_S	a6, (KVM_ARCH_GUEST_A6)(a0)
+	REG_S	a7, (KVM_ARCH_GUEST_A7)(a0)
+	REG_S	s2, (KVM_ARCH_GUEST_S2)(a0)
+	REG_S	s3, (KVM_ARCH_GUEST_S3)(a0)
+	REG_S	s4, (KVM_ARCH_GUEST_S4)(a0)
+	REG_S	s5, (KVM_ARCH_GUEST_S5)(a0)
+	REG_S	s6, (KVM_ARCH_GUEST_S6)(a0)
+	REG_S	s7, (KVM_ARCH_GUEST_S7)(a0)
+	REG_S	s8, (KVM_ARCH_GUEST_S8)(a0)
+	REG_S	s9, (KVM_ARCH_GUEST_S9)(a0)
+	REG_S	s10, (KVM_ARCH_GUEST_S10)(a0)
+	REG_S	s11, (KVM_ARCH_GUEST_S11)(a0)
+	REG_S	t3, (KVM_ARCH_GUEST_T3)(a0)
+	REG_S	t4, (KVM_ARCH_GUEST_T4)(a0)
+	REG_S	t5, (KVM_ARCH_GUEST_T5)(a0)
+	REG_S	t6, (KVM_ARCH_GUEST_T6)(a0)
+
+	/* Save Guest SEPC */
+	csrr	t0, CSR_SEPC
+	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
+
+	/* Restore Host STVEC */
+	REG_L	t1, (KVM_ARCH_HOST_STVEC)(a0)
+	csrw	CSR_STVEC, t1
+
+	/* Save Guest A0 and Restore Host SSCRATCH */
+	REG_L	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
+	csrrw	t2, CSR_SSCRATCH, t2
+	REG_S	t2, (KVM_ARCH_GUEST_A0)(a0)
+
+	/* Save Guest and Restore Host SCOUNTEREN */
+	REG_L	t3, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
+	csrrw	t3, CSR_SCOUNTEREN, t3
+	REG_S	t3, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
+
+	/* Save Guest and Restore Host HSTATUS */
+	REG_L	t4, (KVM_ARCH_HOST_HSTATUS)(a0)
+	csrrw	t4, CSR_HSTATUS, t4
+	REG_S	t4, (KVM_ARCH_GUEST_HSTATUS)(a0)
+
+	/* Save Guest and Restore Host SSTATUS */
+	REG_L	t5, (KVM_ARCH_HOST_SSTATUS)(a0)
+	csrrw	t5, CSR_SSTATUS, t5
+	REG_S	t5, (KVM_ARCH_GUEST_SSTATUS)(a0)
+
+	/* Restore Host GPRs (except A0 and T0-T6) */
+	REG_L	ra, (KVM_ARCH_HOST_RA)(a0)
+	REG_L	sp, (KVM_ARCH_HOST_SP)(a0)
+	REG_L	gp, (KVM_ARCH_HOST_GP)(a0)
+	REG_L	tp, (KVM_ARCH_HOST_TP)(a0)
+	REG_L	s0, (KVM_ARCH_HOST_S0)(a0)
+	REG_L	s1, (KVM_ARCH_HOST_S1)(a0)
+	REG_L	a1, (KVM_ARCH_HOST_A1)(a0)
+	REG_L	a2, (KVM_ARCH_HOST_A2)(a0)
+	REG_L	a3, (KVM_ARCH_HOST_A3)(a0)
+	REG_L	a4, (KVM_ARCH_HOST_A4)(a0)
+	REG_L	a5, (KVM_ARCH_HOST_A5)(a0)
+	REG_L	a6, (KVM_ARCH_HOST_A6)(a0)
+	REG_L	a7, (KVM_ARCH_HOST_A7)(a0)
+	REG_L	s2, (KVM_ARCH_HOST_S2)(a0)
+	REG_L	s3, (KVM_ARCH_HOST_S3)(a0)
+	REG_L	s4, (KVM_ARCH_HOST_S4)(a0)
+	REG_L	s5, (KVM_ARCH_HOST_S5)(a0)
+	REG_L	s6, (KVM_ARCH_HOST_S6)(a0)
+	REG_L	s7, (KVM_ARCH_HOST_S7)(a0)
+	REG_L	s8, (KVM_ARCH_HOST_S8)(a0)
+	REG_L	s9, (KVM_ARCH_HOST_S9)(a0)
+	REG_L	s10, (KVM_ARCH_HOST_S10)(a0)
+	REG_L	s11, (KVM_ARCH_HOST_S11)(a0)
+
+	/* Return to C code */
+	ret
+ENDPROC(__kvm_riscv_switch_to)
-- 
2.25.1

