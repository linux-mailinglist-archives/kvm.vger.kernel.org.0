Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8B31841E7
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgCMH5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:57:42 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61189 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgCMH5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086262; x=1615622262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=TuE0WWlQMDc84XCF3FID2HNyE/MlgKkPTVowXNeF/AI=;
  b=TLXyV2D0K1OliYilsvH1zMNBi69Ej7cXEpT5Y9Wiy1MdHBHelGY3Ucj5
   gyUMMucUq4noPEzhpQ+P5iWbQyorvu7awGfoc+OJMSpGSZi0otOCXKT5D
   YTZJ+hNS68ufNv9fZjvOFkB/8cEP9nOx26EnlsmlDjp4a9LeonT4Ta/i4
   WeaONRZ76Rrc0eDsVgexzfPvBIbQI86jvKU6dABbLFStiE6NFvhVwiW8/
   Bs9ltE5itm1S7jscPvXeGufV42XPZtj+2zLBXOcAnJP2H2HB5DWP7arLR
   vj1ZBx0JcS59XaiaXaao26Fv/Gcc5rvDscIVQunO5+Be/0ZWfU4SUZZGG
   g==;
IronPort-SDR: trJAbPeZHTYYWJPhTDBGS8ASpL7b+NqOjGnwhhiqhFxg6LnFKLjZarRUL3ooJPjJbTW+9hFA1q
 Cm1pPVr1xWje0W2GBcfttH8KtSHq5xZ0OTzxeQeuOv19BnHuKd+xwstjCqkSME88lXz1VRCkKF
 9PrzZi5dc6FfLg29W9iFzPgI5BXa8VpDZHbjhXqoEjiCLLzGk/ppqMamXLm4BmdItwjdtS639S
 2HxFWZVWQTOtkv7OwLjcxQcQDMpgBrqxWnKCXreweJxPOUSQgqM38BX8L1GIwuOlN96f19zxXu
 hwE=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="240664365"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:57:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0RWS/YchiQtXg0DP77wqSSAG8Ja1U7BDuQCanwi7MrP311fplSa9EBiapHsrLN6eaZrNZBaHesk/S3uiBUs9B+eTRuxknJNL1p9FRlBikh9qHlzYrbAf3MkNaqpQcFs804vkDdGhC1DIlegDaY29PG0zEjM4hRwniEYXZ9uOqn6Kqi8ZYvZctdwFfkz43LDT7I7vOaRDtlpUSxt4MOlQZ2o8K33H0kkce6nudOrxLWHfyQYJ+Q4ssCWyYmgKPwxw0Ck6FazbdLMPlnYhzDher55Wixg1dIbBMlT9uje9Wwhgd+0wr6Ert08RzVK09rv3Tp+oS/VVryxtdeSMTRgHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WK7z6cvnL8d03JPUkB1ScL66qjC35+YJBmF1Gfd69Oo=;
 b=UALi/X2XZb8hQjEaoRGG8MBJFKIp8k3PvDd9GwXaSivy2flg2htE540xqok5tAEWdhv64Py0fT1hRAafI6tZCfJldZTWQRzME64leWswtKuBVIL3ygEWAiSEJYZFPRi+MpwxmJ9QFJSDPA+hNY/2L2i1RcngOix6tBCnVYPllwZKhZApUbajVzOICcM4SUV17viCP1LQq/CRSlBZiolwLXmPcs8ZWC7O3vWVKVD1arpBm2mwbeQyodNUBNtcjS6y2pOHSE1laB/6fCR8ghPNNCHOhTwW9r/3Aby8+NtVjo5VjxAAQXcjwROxLXepsLwHFON10LBj0RT8N8EKxDCQfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WK7z6cvnL8d03JPUkB1ScL66qjC35+YJBmF1Gfd69Oo=;
 b=lZ37sv4E8/85LO6eN4SKPdlAiToRpv570M70JjMEQTm4SP67LbSm+XXI+mhyWXF+5uwUpmFEk2GKCNDtzYku9Y+BbiDYhyyDCRkAIjU1i1rYmXVfxhPaNzE+cOepAGJkaererqdo01yrED+A/ciJqFntnuYIOJjEdjuMBiUliH8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6319.namprd04.prod.outlook.com (2603:10b6:208:1aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 13 Mar
 2020 07:57:38 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:57:38 +0000
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
Subject: [PATCH v11 09/20] RISC-V: KVM: Implement VCPU world-switch
Date:   Fri, 13 Mar 2020 13:21:20 +0530
Message-Id: <20200313075131.69837-10-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:56:18 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b3b118c3-13b3-458d-f574-08d7c72431cc
X-MS-TrafficTypeDiagnostic: MN2PR04MB6319:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB63190D9851F5D4C74087C9148DFA0@MN2PR04MB6319.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(199004)(1006002)(478600001)(2616005)(956004)(8886007)(8936002)(7416002)(36756003)(81156014)(16526019)(81166006)(1076003)(55016002)(186003)(52116002)(86362001)(26005)(44832011)(7696005)(8676002)(54906003)(5660300002)(4326008)(66556008)(30864003)(316002)(6666004)(66476007)(110136005)(66946007)(2906002)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6319;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BRICOGZo1Nt0NihnKYYW1i4DD/yQhj5aAj37hwgnF/SDN24E7cVYpmUZDQm7HXLtGy/pGOqm7yhoxcdLETaFItKZNvGvL7sbNNGBaHI4LoYQ/jjBS76cNj5LEUJAcqgUgB3xxizzo0wbYOV6pO107sWyfExpRtCnX1HGZwyBXnN9bJznFHS4vLD1oQMAYcWyUqpnI74vwmRU7b0eBYowUb91S5x9Lbra4s7rzSwiy3/W39PtlW+qiP7hBAlztnYZqJOZWjK+8sm6M4Hy7LARNEFGdOCgSrfkPUL/Ga0PkAxXr1GggS1ZJF3B68WMDryR2icSzyOFVMaCyftsjjIUxTRSd3OJ10ntd36U5f7q4rInhkobOnJK6vVk+HA88Ye9GGqXjtgr0T5rtkydzmF5pnJh0njRj4bvRi/I/M/Y4bFc2rQ5+a8JAKXZWksnb0G8G5squN7EA1B8nb97VSxreEO5LW24I75rZ7LIIOwD/q1xBGitsZ0hoKjb6gyF/Y8cQupJysxU2DaB2Yd1DA7EdQ==
X-MS-Exchange-AntiSpam-MessageData: UN4uUxRBjZ+CJ8GsETuU9o2eT0Pjov5yEGM3G7AicBRiTdgxCL7ikIi9Z6fjBtvW4VrJK2s+xHxtByG8lrvFihXDlf1qUAEyp8tqZtKaOKPm68IPlH2qGMIaX9DTjxIFLzvYH7xCmUrw+T89L5RC0Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b118c3-13b3-458d-f574-08d7c72431cc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:57:38.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Yw3WuzQBaYfOKoVXfr4RJmxGEeCn1jWe4QuQl/DF9GmhgosWdukV/BBoGCs2t3pihunL6WctHdThEbvieO3ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6319
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
 arch/riscv/include/asm/kvm_host.h |   9 +-
 arch/riscv/kernel/asm-offsets.c   |  76 ++++++++++++
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu.c             |  30 ++++-
 arch/riscv/kvm/vcpu_switch.S      | 194 ++++++++++++++++++++++++++++++
 5 files changed, 307 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_switch.S

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 94ae81220ac6..70413ebcf4db 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -110,6 +110,13 @@ struct kvm_vcpu_arch {
 	/* ISA feature bits (similar to MISA) */
 	unsigned long isa;
 
+	/* SSCRATCH and STVEC of Host */
+	unsigned long host_sscratch;
+	unsigned long host_stvec;
+
+	/* CPU context of Host */
+	struct kvm_cpu_context host_context;
+
 	/* CPU context of Guest VCPU */
 	struct kvm_cpu_context guest_context;
 
@@ -160,7 +167,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long scause, unsigned long stval,
 			unsigned long htval, unsigned long htinst);
 
-static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
+void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 07cb9c10de4e..3a230882b91e 100644
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
 
@@ -109,6 +111,80 @@ void asm_offsets(void)
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
index 4ccb895fffa2..99acd836ba06 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -576,14 +576,40 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
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
+	csr_write(CSR_HIP, csr->hip);
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
+	csr->hip = csr_read(CSR_HIP);
+	csr->vsatp = csr_read(CSR_VSATP);
 }
 
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
new file mode 100644
index 000000000000..e1a17df1b379
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -0,0 +1,194 @@
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
+	/* Save Host SSTATUS, HSTATUS, SCRATCH and STVEC */
+	csrr	t0, CSR_SSTATUS
+	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
+	csrr	t1, CSR_HSTATUS
+	REG_S	t1, (KVM_ARCH_HOST_HSTATUS)(a0)
+	csrr	t2, CSR_SSCRATCH
+	REG_S	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
+	csrr	t3, CSR_STVEC
+	REG_S	t3, (KVM_ARCH_HOST_STVEC)(a0)
+
+	/* Change Host exception vector to return path */
+	la	t4, __kvm_switch_return
+	csrw	CSR_STVEC, t4
+
+	/* Restore Guest HSTATUS, SSTATUS and SEPC */
+	REG_L	t4, (KVM_ARCH_GUEST_SEPC)(a0)
+	csrw	CSR_SEPC, t4
+	REG_L	t5, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	csrw	CSR_SSTATUS, t5
+	REG_L	t6, (KVM_ARCH_GUEST_HSTATUS)(a0)
+	csrw	CSR_HSTATUS, t6
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
+	/* Save Host A0 in SSCRATCH */
+	csrw	CSR_SSCRATCH, a0
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
+	/* Save Guest A0 */
+	csrr	t0, CSR_SSCRATCH
+	REG_S	t0, (KVM_ARCH_GUEST_A0)(a0)
+
+	/* Save Guest HSTATUS, SSTATUS, and SEPC */
+	csrr	t0, CSR_SEPC
+	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
+	csrr	t1, CSR_SSTATUS
+	REG_S	t1, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	csrr	t2, CSR_HSTATUS
+	REG_S	t2, (KVM_ARCH_GUEST_HSTATUS)(a0)
+
+	/* Restore Host SSTATUS, HSTATUS, SCRATCH and STVEC */
+	REG_L	t3, (KVM_ARCH_HOST_SSTATUS)(a0)
+	csrw	CSR_SSTATUS, t3
+	REG_L	t4, (KVM_ARCH_HOST_HSTATUS)(a0)
+	csrw	CSR_HSTATUS, t4
+	REG_L	t5, (KVM_ARCH_HOST_SSCRATCH)(a0)
+	csrw	CSR_SSCRATCH, t5
+	REG_L	t6, (KVM_ARCH_HOST_STVEC)(a0)
+	csrw	CSR_STVEC, t6
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
2.17.1

