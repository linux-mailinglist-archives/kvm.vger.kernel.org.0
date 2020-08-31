Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDC6257947
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgHaMb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:31:58 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:41556 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgHaMbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877077; x=1630413077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=8rZA6M42m928JvWwemPq1UKKrr9hBYMd/AbaHvqqAEk=;
  b=F84+OkRCaS1HBBvi2moNckhlUyE6fr5koCNG6bppMHHrZvRVxYkW/MX4
   lV0/ssOoXFmKh7u0d1I40Jn+iFqT4XdMBBR9cOYqfuOelYLyG5LN2hcTD
   DK1Edvcbk/zcIZBvH4sIVu8CPxL1OxKxAa2aaIXK9rodonVsccRu4IDr3
   OdBrLbF9bu8MlNOIcrGiIWUW5ej7ewCc98M+2R8SnCLvRpOu+wmjEAnOb
   WHISNR3WxvsWUlx/nKNzCvtWiZYfuXGDoYYzG9HuCiJKDbf1lUn96bdbP
   ShsU1T2OkrtXGApDgqpNARvdTs+MXDlc7S/JKwClDBrVt907wx9hpvzVq
   w==;
IronPort-SDR: O0M22xRMdP1N4uLnrJUoCWx59VuqNmE9uMGBxIdRJF9iCn3HeoVpGwz4ubnXv9OCSiZRZ/Kxbw
 N38at9oKCQuNmr0g6LCx/TG9LpzTLXhhvBanwFPMeCqMLdR08eac89QUYxDvj6k0b2RlUl6Vjw
 BAQFDhbRobwC2mOqT07tExOJNKn7/Cu0+N6kgEoXmThMNhS22ozK9z+AXuXQDghG0qGwUOfZbL
 ljbvJS5w3BbtFEr/gmNsQJG/sDObCg3ql3cUEthz+1ji40Kp8lBpQ+n38y+RnpzLTYwK3TQ+kX
 5Fo=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="150559605"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:31:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBl3z6i438hXs6viWNkKXGajLWzEmM/ukY3ZUZ04MY+vWr4/z1V1r/X/hA8j/thw8HIo6dO6uhIDnGJgUWOF/0nU+6O04eOyaLV6LijE78EkMII9HwF2YxaI7WqzMVeETHtoxnCBHvH4xRpL7o9vMVDGAMKw3dg7SPOhsy5DvSXcNi24Rng94NVGIronhaKHWofzGdqdZPtSvYRkpT15UTCZ9lxS+OT4dUVZ13ODKTxaD0wDG8WiXllkdx3K3mKodE4PvoJLoWMaTEm0Punuii/2brLTHMIwH7sZozY3r5Gg+I88Pbo5xrOMAkvvrd3Kh+xALjoTgBs2x52OZ85bgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZM0fiJRz2MsWPmfrssonYGMSNvbZnyPSCsUmH79EVM=;
 b=P7ACltod9RXkBhw46cKYDAKghSATKFd7swREDM49Oq7SmY5n1Aj3zttVMb1U3RWDDsyFkNbRHNOj60LMfQJ5C4JW2584/tkQTiy1aSl75UEXdxrK0QiTIQP+PGKfrGyiad/HYyb7p+dMBejveo/JhWXymqIPiEENRocNdhpz4EQ8Bu3uUpvA6KKXAlOuMFEU7dWjNAEtK+beloyDObDaFctHXwbbmcfEjWePX9YzH0xDq0ZbbJMxF+e8sgSB8dJOWwfrOcfVtIlWonCGUm5yZxnc7tg93jt5HL4Xhav0t0XKRp9MFtV44vQNyqMSzhveOf7oV21xCYsD2bU9yg1OhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZM0fiJRz2MsWPmfrssonYGMSNvbZnyPSCsUmH79EVM=;
 b=lETSlbRn9895WkwmBC3WshwMcS5m3La9BWShuM5lGkU3UHiisY7SuAhdzbAnR921eNp+uh1QxSzMMfqANjTefO6R7f0Z7X5fSfKNyQu5J0lXy6dTXO40QCxyKct7pUNxUskbpLOQDoCKersVOSKWtaMnbI21fye3DY552l8sL+k=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6092.namprd04.prod.outlook.com (2603:10b6:5:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Mon, 31 Aug
 2020 12:31:15 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:31:14 +0000
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
Subject: [PATCH v14 07/17] RISC-V: KVM: Handle MMIO exits for VCPU
Date:   Mon, 31 Aug 2020 18:00:05 +0530
Message-Id: <20200831123015.336047-8-anup.patel@wdc.com>
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
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:31:10 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d6aca263-e9d1-4446-eb8a-08d84da9c04e
X-MS-TrafficTypeDiagnostic: DM6PR04MB6092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB60926122ACE0359E8DCF39628D510@DM6PR04MB6092.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQ0EX40O7R96eoBfgiTmQrpG2JSdsG7DQoPI2Dzxd0XceLKgjNSLDNUOlW2DwENPl8iMyt+uNbvGfxEbT2HUio5pkosttYxCP/qTrzZIo38uAfBk/WpSmi8YIVSVIbyNAfG2QLfvpP29iVOrbsvqVEgerAcclTrh1FUQYF5UkZ4MA5zOH88KyADmT1p9PLM2GAB7TWCEYlGeZDo96cC2ct7oEBuhTf5Y+sMKFDe9+W7Jtv4W8NMNEKWcH+9NmXvS9VFBEBysNL0crMMS2z/6IXLUBtqwx4FBLqwTUb4NoqD9uk7EnU/xwEYFi6TF+pOe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(44832011)(6666004)(52116002)(8676002)(86362001)(36756003)(478600001)(6486002)(7416002)(30864003)(110136005)(8936002)(54906003)(83380400001)(66946007)(1076003)(66556008)(2906002)(26005)(186003)(66476007)(956004)(316002)(16576012)(4326008)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yzwVaBpH6OEcsZSdgGpW4Nq62O1Gar02O532KQ98oQ1Kqt6FX7vdswF48OF9z+RkwcKZz59Yo6lGG2DfQbACRVZnG+CfB3HKEnIL+TmuVJj6FFEP80tBjGeClpe2imNwTQMUx3FR4gkaNHwPG5x3hjgJ6JGjzc9MDRFEQ5675TPZN0J/baCTrHDUW1lsD9kvk9meyu39XsyspbujdBCPWXA5+jFl5O+GaXePcWLv8JNnnEBEZGmt6twk7pa61Zcj09Kv0NzACqRWVuNviCdoBXHQJ6yWFWbhxjkJQSRhl1NHw4AnLsAXHLSINJZa47oopM1LgSkCQjTLWI/sfOTgNNhcY9xoFQ41cREXvhtR/YQsEVPOEexIM+4P42KjoEMBAyKLn4HRk+AhNk2nuOPc2c1NI8iF+96R4XS7Wj5p9dVmerKIUD2uVb6VdnTnC2bFokTBSz4AJMuGdgWPY9kA4IAm82qkhemgYxottGOHdh4mpQcKzQK9ez9d8TAgGok08vClAo9fb+qtnfj8hbqoGkDF6ZtWIH55Vkyxv5JPSPxd1gFlocmPjbyA7aXhxQGdssoVWaP3Z0u1gdEa11Xv1Gz+wWB6cnjNPJIcswYxAoYBn7iyTdNjmK6F2nGzpna0hyGcFUfcrg9iJ4w0Sfq8NA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6aca263-e9d1-4446-eb8a-08d84da9c04e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:31:14.8451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyINJ+BR7KvkyBYlXAPUm6CdfBGjvOwugL/p+Qoxa1DwQgHlpaWhURk8jtg/9i229cfwN9se5c/FVNPjuRDSRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6092
Sender: kvm-owner@vger.kernel.org
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
index e2f5523e26de..bfc9fca6b049 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -55,6 +55,14 @@ struct kvm_arch {
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
@@ -153,6 +161,9 @@ struct kvm_vcpu_arch {
 	unsigned long irqs_pending;
 	unsigned long irqs_pending_mask;
 
+	/* MMIO instruction details */
+	struct kvm_mmio_decode mmio_decode;
+
 	/* VCPU power-off state */
 	bool power_off;
 
@@ -169,11 +180,22 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
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
index 83425ce20804..cde94c0239d6 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -184,6 +184,12 @@ void asm_offsets(void)
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
index ec13507e8a18..8fb356e68cc5 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -64,6 +64,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
index 4484e9200fe4..9a0d2a57ced5 100644
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
+	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
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
+	bool writable;
+	gfn_t gfn;
+	int ret;
+
+	fault_addr = (trap->htval << 2) | (trap->stval & 0x3);
+	gfn = fault_addr >> PAGE_SHIFT;
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
+
+	if (kvm_is_error_hva(hva) ||
+	    (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writable)) {
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
index 5174b025ff4e..13fb56906da2 100644
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
+	 * is 4-byte long and blindly increment SEPC by 4.
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

