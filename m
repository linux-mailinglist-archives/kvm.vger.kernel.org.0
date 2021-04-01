Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A9E351AB5
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbhDASCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:51 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24325 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237172AbhDAR7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617299983; x=1648835983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ruPEVg82ej9YTka+1qZra1OpSKHEe99uXBu80/jkvp8=;
  b=qydIl1rCEjVpTo1SOqjx52Td4uY+NrCKFGuQBbOyWP3Cr+cjh/anJ1bo
   ehFMCTy/4j6mETIh9QN3USzwlOX+S2h5BUCBaoebBWoz6WwtfWypT8xC5
   nGSlXDmVaKFWRwMhrMJNT6kz9vGcQF2smbNrdI6trJWcYD7+8btW+wp5Q
   AQ9lYrrqzAc1cSm0QY+5tKKVxQA4oF3QIKjVIorEtju5OgfPrv54LBoMI
   1T4S3qg7tO/a9MWUzXfYrJPejdobw9J8jO+W4CXAREbEb3E/IgeVW/zQq
   Rf8MU5+2aO7pA/miSl66faDUKxXo5VQ/XofAPwrOjjalGbTfZVOjT0nlK
   w==;
IronPort-SDR: As1NvVe+4Zpow75Ayoyb3753fVvpFCi1zEt3Ejl/sCk1qkMNTuyOfS59z3SHnE5iGRHau48oZk
 a/LwXXjaejcM6eyVyoGK/3fx4S8jSO0gC7PTDIMUUHGAXEYTqujG1D1rNIof4436TkT74bthYO
 IrX3K59Ihbm5N3G23tv9iRdg6fSl4Xyl+Nz3NPMegNQXgn6m8DtL9i6/48BSbWVwjdIYdk2SNM
 hRxaLSHJUGUrDexwFhIjisVSABlaVNm+NnWwRxd8qcAY6MrEOXMcqNo0lQvUOjD1LWNJoz9FkY
 LAs=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168041420"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:37:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buGpIn5JoOztonixj4MS1KrOzjG1IX2fHC2ym6hjpqPzRL6wlQL+qxy4gGDAhSTGWzw9i8bmzomjMblSu+l2UFTCMl/FUZmKnYhQgIOJrEvOQjnsHZq6o0CcqPD1VpSynpzRT4cCovRRLJvfqFmhVZdAJNalaLdvNd/NArTFDjLquHcosgs3IonK8v6lKVvsiZbwh7lv0NlxSXJqaaW/Qord68HbT+LZgJHBNA5pyvZgL9qzVjnmVHGh/Z2Uuk8FRn7rldeCXCK+LyxNrnilQyZAIOgr5w88JyLCZaFD0FC5r8TwP1pnQAJ5s/0gV4hni06TDjYXYxHw95pRHKGy1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jil8ykDTsOeotZYrnHIVAeg77Q7WpiSqkwk4ETF/rDw=;
 b=iXroh+99n1sBrrwaicvWML/9cja4LPmVY+sWga98qzTPf1tbeGhZdyC10Idtr9um15pzADjcDiZBAKztFYfARw5uA8HhZIls3GlVEkE0+imA6Jpo+3j4Gt/7AdydjrMzSHfAEspYeN2OOVXrOCTj0xrIeibOPMCwGfzpxug69o5FCXpDstTuuCdVA7IBQmuyXtMPM9azc/SNGywZ+yD1XhvonpJ/A7gp3Ouqdvjm380C1LLPpLrranxY47Rdl7sWHa7ASBcEu7te1J7oS+WrTUwlkCbgGu4iKf/GXP5Pb3wQQcMVN2eyJKN/CvMA/rzbB0E483Hw+M8OHTkk8ZjaeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jil8ykDTsOeotZYrnHIVAeg77Q7WpiSqkwk4ETF/rDw=;
 b=Sx7U0hznmsz/4JJd+V3OaVa8iyI2W+6+a+RMBU5L4/lukCoqjr0aHgMRE7+l73+bgwSgOHQ5wz3Jo856hFIht+bgYGre87X4AvLVw/XazYbfgd6jFMuAkWJn7CmEjKDC3N7JKrPo8A3u/9di4WZDjG2w66t/097n7VmLWLbgvEs=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:37:06 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:37:06 +0000
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
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH v17 07/17] RISC-V: KVM: Handle MMIO exits for VCPU
Date:   Thu,  1 Apr 2021 19:04:25 +0530
Message-Id: <20210401133435.383959-8-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:36:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0210944e-8e11-4308-8421-08d8f5133d9d
X-MS-TrafficTypeDiagnostic: DM6PR04MB6528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB6528352FECB68A39A3768C268D7B9@DM6PR04MB6528.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FYfGIFAOqpTrKlos14qDazE5bU6XDlDvIBhksK2rn7uWu1BXK0JCD/U1QON99jeXPLLhjZ+xqTfvmX9WNwDGg3vXXCQOus2HLLC8N51xCDRqclNV1YYZnBpDZYkk/ZRJE/mL/Y7MvNWqhOwKgioPoTbLOOhmeFWUflxeop/lrtXzchyvkgVQsRl7vfxXgLPVOrHpuxGIY3ORR/ZIIMV+MZG1LQVM0vnaBl+2nOWW/DulbycUhuAYhAt+hfSsjjAlPi2CBPUNspT3EX2yEwVwco2ggIuHfzemCAYGhWjCPbu7oseHpydMt+UgFHF40a1TGvcngH0m4/PzQ1G5kkQhDjTLR3TRUBxuKxZIjQ+bZAad64hb1FpvocMoxtqw6hetDE1MaDzRKALc9bkAPw1Ep3iNgv0FGpgi0UT0YQ/QPQAvRlUZYG/WAcm6gyeYcZC6l3Le3eNQFY6vEIq0SiWCiuqj+MoIR5wlBLS4NP0CobYpXJqunramIvcFreemF9X74wn5eSZZgOlGsVqaZiKlR1UOMm0oY5xu4pCsz/KOGJI6C2UBwWX02H9m++enRS3TVjZVlMPe7gLbQXiflAVF7nsGaboA0uB+K8Es5SlcWj7qZYus4j3aLPxTr7Vs2UawH5I9ZtwA1Ztf8wCClaRagPE1kweOEE/TkZZBs508FSk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(8886007)(16526019)(36756003)(186003)(4326008)(956004)(2616005)(6666004)(316002)(66556008)(478600001)(26005)(66476007)(2906002)(54906003)(7416002)(1076003)(8936002)(55016002)(86362001)(83380400001)(8676002)(52116002)(110136005)(7696005)(5660300002)(38100700001)(30864003)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tRtqg/nnSk98xoY3uOL+K4uqG9g7LCXPRgmRvqf6FWVcdICHwqRSs0Fz50TS?=
 =?us-ascii?Q?h/fZRHbStesvC32bddS05F2tntR1KKrspZTJQOCi+wMRjBMkFtb4eA/FwFxv?=
 =?us-ascii?Q?aHTlONngm6S+NobH2ylKjt5ubBKzRQNhz56zj8b1phvqD6reviir6oIqh4Jk?=
 =?us-ascii?Q?zwfxEsaA9pO2Ut8los0076xqGLY7YXN2xEUhYqy7qyNSgtx343GkWvesviTO?=
 =?us-ascii?Q?GIX3IkZ4Tz+Emp14YsZVtfS6dQVmiIPDxC7oI3OHT5wKSyS7gfxurA//hakY?=
 =?us-ascii?Q?wozDZNr0C4EYPMLpxnMGV7hNN1pWUalk7gdv40C/Z+CJcTJ0WbZHFzR8vGH/?=
 =?us-ascii?Q?e7HYRkcyFDLENDJW6urEBTg3eB8mSQE/cXSogFELDiICZ7lZFrRhx64hwgNT?=
 =?us-ascii?Q?OBxKAvMSYMSi+ZKeOXmpMnB1eow7oXcMdwT56aWQjolUk2txInILRCGfxwXr?=
 =?us-ascii?Q?KI0LVjq2VvaAhT57wqDkCNSDkO53BgzC6W+/6yXW3oj0a/o8JO7l6uJAK+9O?=
 =?us-ascii?Q?3kbAmc/RzMIMXyITJE2OdGRak48rWti5afy4x1Ex0jrfIosXK2A7bsjNx5ce?=
 =?us-ascii?Q?eHPZDwrvU1E3k2C9SVAq1kjIORa3A6wuThJCs3W+X2mZ0hs9894pDMauVBa/?=
 =?us-ascii?Q?KgCQn85WSyFKG/VJR2/hTDFMnyBfnxLCFrETsmAzi3BQ2YrSQFHBcihSXjuU?=
 =?us-ascii?Q?6lPZu0PeWNixDD8MGEva+kWTW1ge5gstMZ8pDys76XfL90jNLieDtHfEWdmZ?=
 =?us-ascii?Q?i0I4GfcSESoDMpyW0s1y3Xa6GEz+oXFnxsjUHr25gv5Goffucj6jTGSgX7sL?=
 =?us-ascii?Q?J364GZWVI7Ti9s7XCLIieXPqgU2Ao1QHmM3vxpaBQaBxiax3oM6MnUPZvkzz?=
 =?us-ascii?Q?NIrfpGU6eAD9C0lhGSN43/E3QJ7alO5cycHgNs7WSUDP6FZoIOJAE+jVBMXd?=
 =?us-ascii?Q?gGg3OLhDTOvRIeu82EclCk3rXd533jA3N6FQuUwH6u9c4CZDEC/ANRGkXRXi?=
 =?us-ascii?Q?g2+OxC3NJmQufQRkK+wKqmALlGDX6hvwmUL7shkR2VZQQIb2KNMz0GgGqsPh?=
 =?us-ascii?Q?3qqibkSRfNV7Qi4tlFyYKiZxTLyYbnnW3BSLw5liIzvMaiXnxyIugx6ObrW6?=
 =?us-ascii?Q?fW1orriL7Iu4Kjmryz9isIVYYrNEgDwDi2KTliqm7uW84kJe9AJw0ATm6076?=
 =?us-ascii?Q?sc+CKSPgBk+aRKLPlnZ4GrpZYvBRi7YdLQ4+qEWkf3Fsvg8so95CMYCuBWu1?=
 =?us-ascii?Q?1N/U68lNXiAAxoknRFOC3xVqDiMflDiLq8EKq2Ei6TpYmDZomRABTz/mEzDu?=
 =?us-ascii?Q?5uPOUy59EI+q3KPRg/ntbJyZRjqVsF9NDIDuTjLLwuqG+A=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0210944e-8e11-4308-8421-08d8f5133d9d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:37:06.1930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eApLiXq44+6WSgwc6dvNcJ4hhBl+ZQdII6lg5crlIVGCnE3tI2RR9yXnAzaCYYor+y8JM2PZSlN4A5ps2M0dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will get stage2 page faults whenever Guest/VM access SW emulated
MMIO device or unmapped Guest RAM.

This patch implements MMIO read/write emulation by extracting MMIO
details from the trapped load/store instruction and forwarding the
MMIO read/write to user-space. The actual MMIO emulation will happen
in user-space and KVM kernel module will only take care of register
updates before resuming the trapped VCPU.

The handling for stage2 page faults for unmapped Guest RAM will be
implemeted by a separate patch later.

[jiangyifei: ioeventfd and in-kernel mmio device support]
Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  22 ++
 arch/riscv/kernel/asm-offsets.c   |   6 +
 arch/riscv/kvm/Kconfig            |   1 +
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/mmu.c              |   8 +
 arch/riscv/kvm/vcpu_exit.c        | 592 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vcpu_switch.S      |  23 ++
 arch/riscv/kvm/vm.c               |   1 +
 8 files changed, 651 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index ca9b8dfcd406..7541018314a4 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -54,6 +54,14 @@ struct kvm_arch {
 	phys_addr_t pgd_phys;
 };
 
+struct kvm_mmio_decode {
+	unsigned long insn;
+	int insn_len;
+	int len;
+	int shift;
+	int return_handled;
+};
+
 struct kvm_cpu_trap {
 	unsigned long sepc;
 	unsigned long scause;
@@ -152,6 +160,9 @@ struct kvm_vcpu_arch {
 	unsigned long irqs_pending;
 	unsigned long irqs_pending_mask;
 
+	/* MMIO instruction details */
+	struct kvm_mmio_decode mmio_decode;
+
 	/* VCPU power-off state */
 	bool power_off;
 
@@ -168,11 +179,22 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
+			 struct kvm_memory_slot *memslot,
+			 gpa_t gpa, unsigned long hva, bool is_write);
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
 
+void __kvm_riscv_unpriv_trap(void);
+
+unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
+					 bool read_insn,
+					 unsigned long guest_addr,
+					 struct kvm_cpu_trap *trap);
+void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
+				  struct kvm_cpu_trap *trap);
 int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 21f867d35b65..21e7cf76948d 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -189,6 +189,12 @@ void asm_offsets(void)
 	OFFSET(KVM_ARCH_HOST_STVEC, kvm_vcpu_arch, host_stvec);
 	OFFSET(KVM_ARCH_HOST_SCOUNTEREN, kvm_vcpu_arch, host_scounteren);
 
+	OFFSET(KVM_ARCH_TRAP_SEPC, kvm_cpu_trap, sepc);
+	OFFSET(KVM_ARCH_TRAP_SCAUSE, kvm_cpu_trap, scause);
+	OFFSET(KVM_ARCH_TRAP_STVAL, kvm_cpu_trap, stval);
+	OFFSET(KVM_ARCH_TRAP_HTVAL, kvm_cpu_trap, htval);
+	OFFSET(KVM_ARCH_TRAP_HTINST, kvm_cpu_trap, htinst);
+
 	/*
 	 * THREAD_{F,X}* might be larger than a S-type offset can handle, but
 	 * these are used in performance-sensitive assembly so we can't resort
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 88edd477b3a8..b42979f84042 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select ANON_INODES
 	select KVM_MMIO
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select HAVE_KVM_EVENTFD
 	select SRCU
 	help
 	  Support hosting virtualized guest machines.
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 845579273727..54991cc55c00 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -3,6 +3,7 @@
 #
 
 common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+common-objs-y += $(addprefix ../../../virt/kvm/, eventfd.o)
 
 ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index abfd2b22fa8e..8ec10ef861e7 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -58,6 +58,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return 0;
 }
 
+int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
+			 struct kvm_memory_slot *memslot,
+			 gpa_t gpa, unsigned long hva, bool is_write)
+{
+	/* TODO: */
+	return 0;
+}
+
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
 {
 	/* TODO: */
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 4484e9200fe4..dc66be032ad7 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -6,9 +6,518 @@
  *     Anup Patel <anup.patel@wdc.com>
  */
 
+#include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <asm/csr.h>
+
+#define INSN_MATCH_LB		0x3
+#define INSN_MASK_LB		0x707f
+#define INSN_MATCH_LH		0x1003
+#define INSN_MASK_LH		0x707f
+#define INSN_MATCH_LW		0x2003
+#define INSN_MASK_LW		0x707f
+#define INSN_MATCH_LD		0x3003
+#define INSN_MASK_LD		0x707f
+#define INSN_MATCH_LBU		0x4003
+#define INSN_MASK_LBU		0x707f
+#define INSN_MATCH_LHU		0x5003
+#define INSN_MASK_LHU		0x707f
+#define INSN_MATCH_LWU		0x6003
+#define INSN_MASK_LWU		0x707f
+#define INSN_MATCH_SB		0x23
+#define INSN_MASK_SB		0x707f
+#define INSN_MATCH_SH		0x1023
+#define INSN_MASK_SH		0x707f
+#define INSN_MATCH_SW		0x2023
+#define INSN_MASK_SW		0x707f
+#define INSN_MATCH_SD		0x3023
+#define INSN_MASK_SD		0x707f
+
+#define INSN_MATCH_C_LD		0x6000
+#define INSN_MASK_C_LD		0xe003
+#define INSN_MATCH_C_SD		0xe000
+#define INSN_MASK_C_SD		0xe003
+#define INSN_MATCH_C_LW		0x4000
+#define INSN_MASK_C_LW		0xe003
+#define INSN_MATCH_C_SW		0xc000
+#define INSN_MASK_C_SW		0xe003
+#define INSN_MATCH_C_LDSP	0x6002
+#define INSN_MASK_C_LDSP	0xe003
+#define INSN_MATCH_C_SDSP	0xe002
+#define INSN_MASK_C_SDSP	0xe003
+#define INSN_MATCH_C_LWSP	0x4002
+#define INSN_MASK_C_LWSP	0xe003
+#define INSN_MATCH_C_SWSP	0xc002
+#define INSN_MASK_C_SWSP	0xe003
+
+#define INSN_16BIT_MASK		0x3
+
+#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
+
+#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
+
+#ifdef CONFIG_64BIT
+#define LOG_REGBYTES		3
+#else
+#define LOG_REGBYTES		2
+#endif
+#define REGBYTES		(1 << LOG_REGBYTES)
+
+#define SH_RD			7
+#define SH_RS1			15
+#define SH_RS2			20
+#define SH_RS2C			2
+
+#define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
+#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
+				 (RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 5, 1) << 6))
+#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 5, 2) << 6))
+#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
+				 (RV_X(x, 12, 1) << 5) | \
+				 (RV_X(x, 2, 2) << 6))
+#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
+				 (RV_X(x, 12, 1) << 5) | \
+				 (RV_X(x, 2, 3) << 6))
+#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
+				 (RV_X(x, 7, 2) << 6))
+#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 7, 3) << 6))
+#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
+#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
+#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
+
+#define SHIFT_RIGHT(x, y)		\
+	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
+
+#define REG_MASK			\
+	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
+
+#define REG_OFFSET(insn, pos)		\
+	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
+
+#define REG_PTR(insn, pos, regs)	\
+	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
+
+#define GET_RM(insn)		(((insn) >> 12) & 7)
+
+#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
+#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
+#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
+#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
+#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
+#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
+#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
+#define IMM_I(insn)		((s32)(insn) >> 20)
+#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
+				 (s32)(((insn) >> 7) & 0x1f))
+#define MASK_FUNCT3		0x7000
+
+static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			unsigned long fault_addr, unsigned long htinst)
+{
+	u8 data_buf[8];
+	unsigned long insn;
+	int shift = 0, len = 0, insn_len = 0;
+	struct kvm_cpu_trap utrap = { 0 };
+	struct kvm_cpu_context *ct = &vcpu->arch.guest_context;
+
+	/* Determine trapped instruction */
+	if (htinst & 0x1) {
+		/*
+		 * Bit[0] == 1 implies trapped instruction value is
+		 * transformed instruction or custom instruction.
+		 */
+		insn = htinst | INSN_16BIT_MASK;
+		insn_len = (htinst & BIT(1)) ? INSN_LEN(insn) : 2;
+	} else {
+		/*
+		 * Bit[0] == 0 implies trapped instruction value is
+		 * zero or special value.
+		 */
+		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
+						  &utrap);
+		if (utrap.scause) {
+			/* Redirect trap if we failed to read instruction */
+			utrap.sepc = ct->sepc;
+			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+			return 1;
+		}
+		insn_len = INSN_LEN(insn);
+	}
+
+	/* Decode length of MMIO and shift */
+	if ((insn & INSN_MASK_LW) == INSN_MATCH_LW) {
+		len = 4;
+		shift = 8 * (sizeof(ulong) - len);
+	} else if ((insn & INSN_MASK_LB) == INSN_MATCH_LB) {
+		len = 1;
+		shift = 8 * (sizeof(ulong) - len);
+	} else if ((insn & INSN_MASK_LBU) == INSN_MATCH_LBU) {
+		len = 1;
+		shift = 8 * (sizeof(ulong) - len);
+#ifdef CONFIG_64BIT
+	} else if ((insn & INSN_MASK_LD) == INSN_MATCH_LD) {
+		len = 8;
+		shift = 8 * (sizeof(ulong) - len);
+	} else if ((insn & INSN_MASK_LWU) == INSN_MATCH_LWU) {
+		len = 4;
+#endif
+	} else if ((insn & INSN_MASK_LH) == INSN_MATCH_LH) {
+		len = 2;
+		shift = 8 * (sizeof(ulong) - len);
+	} else if ((insn & INSN_MASK_LHU) == INSN_MATCH_LHU) {
+		len = 2;
+#ifdef CONFIG_64BIT
+	} else if ((insn & INSN_MASK_C_LD) == INSN_MATCH_C_LD) {
+		len = 8;
+		shift = 8 * (sizeof(ulong) - len);
+		insn = RVC_RS2S(insn) << SH_RD;
+	} else if ((insn & INSN_MASK_C_LDSP) == INSN_MATCH_C_LDSP &&
+		   ((insn >> SH_RD) & 0x1f)) {
+		len = 8;
+		shift = 8 * (sizeof(ulong) - len);
+#endif
+	} else if ((insn & INSN_MASK_C_LW) == INSN_MATCH_C_LW) {
+		len = 4;
+		shift = 8 * (sizeof(ulong) - len);
+		insn = RVC_RS2S(insn) << SH_RD;
+	} else if ((insn & INSN_MASK_C_LWSP) == INSN_MATCH_C_LWSP &&
+		   ((insn >> SH_RD) & 0x1f)) {
+		len = 4;
+		shift = 8 * (sizeof(ulong) - len);
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	/* Fault address should be aligned to length of MMIO */
+	if (fault_addr & (len - 1))
+		return -EIO;
+
+	/* Save instruction decode info */
+	vcpu->arch.mmio_decode.insn = insn;
+	vcpu->arch.mmio_decode.insn_len = insn_len;
+	vcpu->arch.mmio_decode.shift = shift;
+	vcpu->arch.mmio_decode.len = len;
+	vcpu->arch.mmio_decode.return_handled = 0;
+
+	/* Update MMIO details in kvm_run struct */
+	run->mmio.is_write = false;
+	run->mmio.phys_addr = fault_addr;
+	run->mmio.len = len;
+
+	/* Try to handle MMIO access in the kernel */
+	if (!kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_addr, len, data_buf)) {
+		/* Successfully handled MMIO access in the kernel so resume */
+		memcpy(run->mmio.data, data_buf, len);
+		vcpu->stat.mmio_exit_kernel++;
+		kvm_riscv_vcpu_mmio_return(vcpu, run);
+		return 1;
+	}
+
+	/* Exit to userspace for MMIO emulation */
+	vcpu->stat.mmio_exit_user++;
+	run->exit_reason = KVM_EXIT_MMIO;
+
+	return 0;
+}
+
+static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			 unsigned long fault_addr, unsigned long htinst)
+{
+	u8 data8;
+	u16 data16;
+	u32 data32;
+	u64 data64;
+	ulong data;
+	unsigned long insn;
+	int len = 0, insn_len = 0;
+	struct kvm_cpu_trap utrap = { 0 };
+	struct kvm_cpu_context *ct = &vcpu->arch.guest_context;
+
+	/* Determine trapped instruction */
+	if (htinst & 0x1) {
+		/*
+		 * Bit[0] == 1 implies trapped instruction value is
+		 * transformed instruction or custom instruction.
+		 */
+		insn = htinst | INSN_16BIT_MASK;
+		insn_len = (htinst & BIT(1)) ? INSN_LEN(insn) : 2;
+	} else {
+		/*
+		 * Bit[0] == 0 implies trapped instruction value is
+		 * zero or special value.
+		 */
+		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
+						  &utrap);
+		if (utrap.scause) {
+			/* Redirect trap if we failed to read instruction */
+			utrap.sepc = ct->sepc;
+			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+			return 1;
+		}
+		insn_len = INSN_LEN(insn);
+	}
+
+	data = GET_RS2(insn, &vcpu->arch.guest_context);
+	data8 = data16 = data32 = data64 = data;
+
+	if ((insn & INSN_MASK_SW) == INSN_MATCH_SW) {
+		len = 4;
+	} else if ((insn & INSN_MASK_SB) == INSN_MATCH_SB) {
+		len = 1;
+#ifdef CONFIG_64BIT
+	} else if ((insn & INSN_MASK_SD) == INSN_MATCH_SD) {
+		len = 8;
+#endif
+	} else if ((insn & INSN_MASK_SH) == INSN_MATCH_SH) {
+		len = 2;
+#ifdef CONFIG_64BIT
+	} else if ((insn & INSN_MASK_C_SD) == INSN_MATCH_C_SD) {
+		len = 8;
+		data64 = GET_RS2S(insn, &vcpu->arch.guest_context);
+	} else if ((insn & INSN_MASK_C_SDSP) == INSN_MATCH_C_SDSP &&
+		   ((insn >> SH_RD) & 0x1f)) {
+		len = 8;
+		data64 = GET_RS2C(insn, &vcpu->arch.guest_context);
+#endif
+	} else if ((insn & INSN_MASK_C_SW) == INSN_MATCH_C_SW) {
+		len = 4;
+		data32 = GET_RS2S(insn, &vcpu->arch.guest_context);
+	} else if ((insn & INSN_MASK_C_SWSP) == INSN_MATCH_C_SWSP &&
+		   ((insn >> SH_RD) & 0x1f)) {
+		len = 4;
+		data32 = GET_RS2C(insn, &vcpu->arch.guest_context);
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	/* Fault address should be aligned to length of MMIO */
+	if (fault_addr & (len - 1))
+		return -EIO;
+
+	/* Save instruction decode info */
+	vcpu->arch.mmio_decode.insn = insn;
+	vcpu->arch.mmio_decode.insn_len = insn_len;
+	vcpu->arch.mmio_decode.shift = 0;
+	vcpu->arch.mmio_decode.len = len;
+	vcpu->arch.mmio_decode.return_handled = 0;
+
+	/* Copy data to kvm_run instance */
+	switch (len) {
+	case 1:
+		*((u8 *)run->mmio.data) = data8;
+		break;
+	case 2:
+		*((u16 *)run->mmio.data) = data16;
+		break;
+	case 4:
+		*((u32 *)run->mmio.data) = data32;
+		break;
+	case 8:
+		*((u64 *)run->mmio.data) = data64;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	};
+
+	/* Update MMIO details in kvm_run struct */
+	run->mmio.is_write = true;
+	run->mmio.phys_addr = fault_addr;
+	run->mmio.len = len;
+
+	/* Try to handle MMIO access in the kernel */
+	if (!kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
+			      fault_addr, len, run->mmio.data)) {
+		/* Successfully handled MMIO access in the kernel so resume */
+		vcpu->stat.mmio_exit_kernel++;
+		kvm_riscv_vcpu_mmio_return(vcpu, run);
+		return 1;
+	}
+
+	/* Exit to userspace for MMIO emulation */
+	vcpu->stat.mmio_exit_user++;
+	run->exit_reason = KVM_EXIT_MMIO;
+
+	return 0;
+}
+
+static int stage2_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			     struct kvm_cpu_trap *trap)
+{
+	struct kvm_memory_slot *memslot;
+	unsigned long hva, fault_addr;
+	bool writeable;
+	gfn_t gfn;
+	int ret;
+
+	fault_addr = (trap->htval << 2) | (trap->stval & 0x3);
+	gfn = fault_addr >> PAGE_SHIFT;
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writeable);
+
+	if (kvm_is_error_hva(hva) ||
+	    (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writeable)) {
+		switch (trap->scause) {
+		case EXC_LOAD_GUEST_PAGE_FAULT:
+			return emulate_load(vcpu, run, fault_addr,
+					    trap->htinst);
+		case EXC_STORE_GUEST_PAGE_FAULT:
+			return emulate_store(vcpu, run, fault_addr,
+					     trap->htinst);
+		default:
+			return -EOPNOTSUPP;
+		};
+	}
+
+	ret = kvm_riscv_stage2_map(vcpu, memslot, fault_addr, hva,
+		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
+	if (ret < 0)
+		return ret;
+
+	return 1;
+}
+
+/**
+ * kvm_riscv_vcpu_unpriv_read -- Read machine word from Guest memory
+ *
+ * @vcpu: The VCPU pointer
+ * @read_insn: Flag representing whether we are reading instruction
+ * @guest_addr: Guest address to read
+ * @trap: Output pointer to trap details
+ */
+unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
+					 bool read_insn,
+					 unsigned long guest_addr,
+					 struct kvm_cpu_trap *trap)
+{
+	register unsigned long taddr asm("a0") = (unsigned long)trap;
+	register unsigned long ttmp asm("a1");
+	register unsigned long val asm("t0");
+	register unsigned long tmp asm("t1");
+	register unsigned long addr asm("t2") = guest_addr;
+	unsigned long flags;
+	unsigned long old_stvec, old_hstatus;
+
+	local_irq_save(flags);
+
+	old_hstatus = csr_swap(CSR_HSTATUS, vcpu->arch.guest_context.hstatus);
+	old_stvec = csr_swap(CSR_STVEC, (ulong)&__kvm_riscv_unpriv_trap);
+
+	if (read_insn) {
+		/*
+		 * HLVX.HU instruction
+		 * 0110010 00011 rs1 100 rd 1110011
+		 */
+		asm volatile ("\n"
+			".option push\n"
+			".option norvc\n"
+			"add %[ttmp], %[taddr], 0\n"
+			/*
+			 * HLVX.HU %[val], (%[addr])
+			 * HLVX.HU t0, (t2)
+			 * 0110010 00011 00111 100 00101 1110011
+			 */
+			".word 0x6433c2f3\n"
+			"andi %[tmp], %[val], 3\n"
+			"addi %[tmp], %[tmp], -3\n"
+			"bne %[tmp], zero, 2f\n"
+			"addi %[addr], %[addr], 2\n"
+			/*
+			 * HLVX.HU %[tmp], (%[addr])
+			 * HLVX.HU t1, (t2)
+			 * 0110010 00011 00111 100 00110 1110011
+			 */
+			".word 0x6433c373\n"
+			"sll %[tmp], %[tmp], 16\n"
+			"add %[val], %[val], %[tmp]\n"
+			"2:\n"
+			".option pop"
+		: [val] "=&r" (val), [tmp] "=&r" (tmp),
+		  [taddr] "+&r" (taddr), [ttmp] "+&r" (ttmp),
+		  [addr] "+&r" (addr) : : "memory");
+
+		if (trap->scause == EXC_LOAD_PAGE_FAULT)
+			trap->scause = EXC_INST_PAGE_FAULT;
+	} else {
+		/*
+		 * HLV.D instruction
+		 * 0110110 00000 rs1 100 rd 1110011
+		 *
+		 * HLV.W instruction
+		 * 0110100 00000 rs1 100 rd 1110011
+		 */
+		asm volatile ("\n"
+			".option push\n"
+			".option norvc\n"
+			"add %[ttmp], %[taddr], 0\n"
+#ifdef CONFIG_64BIT
+			/*
+			 * HLV.D %[val], (%[addr])
+			 * HLV.D t0, (t2)
+			 * 0110110 00000 00111 100 00101 1110011
+			 */
+			".word 0x6c03c2f3\n"
+#else
+			/*
+			 * HLV.W %[val], (%[addr])
+			 * HLV.W t0, (t2)
+			 * 0110100 00000 00111 100 00101 1110011
+			 */
+			".word 0x6803c2f3\n"
+#endif
+			".option pop"
+		: [val] "=&r" (val),
+		  [taddr] "+&r" (taddr), [ttmp] "+&r" (ttmp)
+		: [addr] "r" (addr) : "memory");
+	}
+
+	csr_write(CSR_STVEC, old_stvec);
+	csr_write(CSR_HSTATUS, old_hstatus);
+
+	local_irq_restore(flags);
+
+	return val;
+}
+
+/**
+ * kvm_riscv_vcpu_trap_redirect -- Redirect trap to Guest
+ *
+ * @vcpu: The VCPU pointer
+ * @trap: Trap details
+ */
+void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
+				  struct kvm_cpu_trap *trap)
+{
+	unsigned long vsstatus = csr_read(CSR_VSSTATUS);
+
+	/* Change Guest SSTATUS.SPP bit */
+	vsstatus &= ~SR_SPP;
+	if (vcpu->arch.guest_context.sstatus & SR_SPP)
+		vsstatus |= SR_SPP;
+
+	/* Change Guest SSTATUS.SPIE bit */
+	vsstatus &= ~SR_SPIE;
+	if (vsstatus & SR_SIE)
+		vsstatus |= SR_SPIE;
+
+	/* Clear Guest SSTATUS.SIE bit */
+	vsstatus &= ~SR_SIE;
+
+	/* Update Guest SSTATUS */
+	csr_write(CSR_VSSTATUS, vsstatus);
+
+	/* Update Guest SCAUSE, STVAL, and SEPC */
+	csr_write(CSR_VSCAUSE, trap->scause);
+	csr_write(CSR_VSTVAL, trap->stval);
+	csr_write(CSR_VSEPC, trap->sepc);
+
+	/* Set Guest PC to Guest exception vector */
+	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
+}
 
 /**
  * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulation
@@ -19,7 +528,54 @@
  */
 int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	/* TODO: */
+	u8 data8;
+	u16 data16;
+	u32 data32;
+	u64 data64;
+	ulong insn;
+	int len, shift;
+
+	if (vcpu->arch.mmio_decode.return_handled)
+		return 0;
+
+	vcpu->arch.mmio_decode.return_handled = 1;
+	insn = vcpu->arch.mmio_decode.insn;
+
+	if (run->mmio.is_write)
+		goto done;
+
+	len = vcpu->arch.mmio_decode.len;
+	shift = vcpu->arch.mmio_decode.shift;
+
+	switch (len) {
+	case 1:
+		data8 = *((u8 *)run->mmio.data);
+		SET_RD(insn, &vcpu->arch.guest_context,
+			(ulong)data8 << shift >> shift);
+		break;
+	case 2:
+		data16 = *((u16 *)run->mmio.data);
+		SET_RD(insn, &vcpu->arch.guest_context,
+			(ulong)data16 << shift >> shift);
+		break;
+	case 4:
+		data32 = *((u32 *)run->mmio.data);
+		SET_RD(insn, &vcpu->arch.guest_context,
+			(ulong)data32 << shift >> shift);
+		break;
+	case 8:
+		data64 = *((u64 *)run->mmio.data);
+		SET_RD(insn, &vcpu->arch.guest_context,
+			(ulong)data64 << shift >> shift);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	};
+
+done:
+	/* Move to next instruction */
+	vcpu->arch.guest_context.sepc += vcpu->arch.mmio_decode.insn_len;
+
 	return 0;
 }
 
@@ -30,6 +586,36 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap)
 {
-	/* TODO: */
-	return 0;
+	int ret;
+
+	/* If we got host interrupt then do nothing */
+	if (trap->scause & CAUSE_IRQ_FLAG)
+		return 1;
+
+	/* Handle guest traps */
+	ret = -EFAULT;
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+	switch (trap->scause) {
+	case EXC_INST_GUEST_PAGE_FAULT:
+	case EXC_LOAD_GUEST_PAGE_FAULT:
+	case EXC_STORE_GUEST_PAGE_FAULT:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = stage2_page_fault(vcpu, run, trap);
+		break;
+	default:
+		break;
+	};
+
+	/* Print details in-case of error */
+	if (ret < 0) {
+		kvm_err("VCPU exit error %d\n", ret);
+		kvm_err("SEPC=0x%lx SSTATUS=0x%lx HSTATUS=0x%lx\n",
+			vcpu->arch.guest_context.sepc,
+			vcpu->arch.guest_context.sstatus,
+			vcpu->arch.guest_context.hstatus);
+		kvm_err("SCAUSE=0x%lx STVAL=0x%lx HTVAL=0x%lx HTINST=0x%lx\n",
+			trap->scause, trap->stval, trap->htval, trap->htinst);
+	}
+
+	return ret;
 }
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index 5174b025ff4e..e22721e1b892 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -201,3 +201,26 @@ __kvm_switch_return:
 	/* Return to C code */
 	ret
 ENDPROC(__kvm_riscv_switch_to)
+
+ENTRY(__kvm_riscv_unpriv_trap)
+	/*
+	 * We assume that faulting unpriv load/store instruction is
+	 * 4-byte long and blindly increment SEPC by 4.
+	 *
+	 * The trap details will be saved at address pointed by 'A0'
+	 * register and we use 'A1' register as temporary.
+	 */
+	csrr	a1, CSR_SEPC
+	REG_S	a1, (KVM_ARCH_TRAP_SEPC)(a0)
+	addi	a1, a1, 4
+	csrw	CSR_SEPC, a1
+	csrr	a1, CSR_SCAUSE
+	REG_S	a1, (KVM_ARCH_TRAP_SCAUSE)(a0)
+	csrr	a1, CSR_STVAL
+	REG_S	a1, (KVM_ARCH_TRAP_STVAL)(a0)
+	csrr	a1, CSR_HTVAL
+	REG_S	a1, (KVM_ARCH_TRAP_HTVAL)(a0)
+	csrr	a1, CSR_HTINST
+	REG_S	a1, (KVM_ARCH_TRAP_HTINST)(a0)
+	sret
+ENDPROC(__kvm_riscv_unpriv_trap)
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index d6776b4819bb..496a86a74236 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -46,6 +46,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	int r;
 
 	switch (ext) {
+	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
-- 
2.25.1

