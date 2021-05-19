Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E093388575
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353117AbhESDiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:38:19 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26406 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353021AbhESDiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395414; x=1652931414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=re8wC0bfkAE8Airo/VneTgIQeJkCrq4erAywfaJbZCE=;
  b=rVUwgLaBIt6Qrtq2ep8XryF+CDpEH96dFdW9Cx9WYCQJ5Dtrne34wCnX
   nYRhgaLp4mWCoJSfdi0ea7SVzsOHg23cRMbxmcrxvkPShaepUqECnLE94
   3Q/sUqJRJnYsi/Xh2P5zIM/rzbi6Zr3zXu8idIga+YM/1zKnhnp+EFbm4
   +ie+lYmG6SDZtkHxY5hppVWK9gpI+JqMxDt0tCsT7111qw1OsIB2/zY3l
   cV/VpROKMxwGe6loEB7AXtHTCxtkhFJ9O/tPztcFPi4oZ5jy2o3GyOQWm
   7l3ag9ukTenXYtixdz/1kWhshgIHYRLCAZDsbQEydahMkrMWgAoUyttn7
   w==;
IronPort-SDR: zGORIfJch8boQjPnxrNzPuvYzbeTn8ASV7ZvVlJPBU24zsBq8zrSQF5tbu+N18RNhC1hjHvoq1
 MKNLs0ObZYKGFL6eaVbwhNnBRvI8ZK/TsesknsN3BoGrrdnAQXb/d/kqsdjOcpUQbHtXXp5C8i
 VJZ2g0A1c/6euTyVTbLlxShQuHIBwvn2e8hQo0KhujpRsHQ6T1wxNHk3HXKTILhVhhJJN4dhiS
 loHF+io6+IExuVdk41JCo0rL26xTBdwD12bi16Jg6NgPZ+FRt3m2M6qFsYGoZND19V2rF52Bst
 byY=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="167950723"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:36:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWzs0WhVOXoSN10mKt9PKIIi1mLP1FK1P0oUGtueOzeTbrzyRuxClkjWcSeCEdydFDvGa1nr86NdgjSGWLxgBPvS6oWMFr+YHeVoLthV9zkdxudeMHrRsJOEzvAh8ChqsKzTXev/UzYq2oFZx1+meYCH56xYvR10nreNgBIbiaWCDP8EnpUu1IhelU2FakpShfNcHgJ9zk6lZUmWCIzx2OgQEBQJR+w6FD5kmaAxBCSbKuAPCaVj1+VDG7yNdzu7u94dp/7d1coqUWIBR0+6kTcbV1y7xiMveDtOqom0R2ezZJZMTCztvimXd7IIEWQhPMWmlgX0FpwncY0SnEciIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGCwkJ1CrFj+L3N7REmVRM/BpEG197QqQzcEqPJSNb0=;
 b=OCpmz2XS6nHt5Hq8j5+73Ua4Fw6BhMck+6XzR/r3hZZlJNVaWUT1S8WLlam9JUZJYCQxwT42WSv2A29Fi37JjaH9SZkfT5FsHHJEDOPx7bQ1PoHTkMJTdMthYJnpixYQJgCFSxGV5EpknGxMYZvxq01VqHMsne9U+jD1r5TU7mtokKrGQHTErDGT7IdqeIVxnYXNHZVoy1Nq+jyxSqvIIpcFYoXYs1/xYfBY6KC+IPJsDPywXrXlPjJ11xYhoK39EZMsOtIcmGHKXqlojM8m4qK0Hzvuo3RVWMWOgkkrHMQpuqheUOxfs9Y+ePzYtBgBkartTqJpdY9Sw/JVx8JE6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGCwkJ1CrFj+L3N7REmVRM/BpEG197QqQzcEqPJSNb0=;
 b=d1OL3cQ7OULOPFnKB67qIRgPW8Rmck+V4093nmu03xna7+KPQaWyWI6tU9W8u2QaUjkEKLZxU1u92DN6Y9dxLZrA0OSd6oZLj1kYqg/7d7o5yTEqtJu8X3BuT2lnKpdrx1YzXJtEapsgkerD8o0Y2fSXAW6BVsi3Xg1YWrt/tb8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:36:52 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:36:52 +0000
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
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>,
        Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH v18 07/18] RISC-V: KVM: Handle MMIO exits for VCPU
Date:   Wed, 19 May 2021 09:05:42 +0530
Message-Id: <20210519033553.1110536-8-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:36:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e798634-add4-410b-c394-08d91a77574f
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7761F8B4091B1E6DE70C8E928D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tpkM4r/9wcEuOaGCumYQN78kSFAVCVv9E8rl0CmGxF+1jhKrFMXCJLSTtkBDzIf2qWbjvI5ziVWqIAcHtYCCBMGX2GytIH2RI3a8+jW6JOCXkYARHauz35oYLh9eK5mVPBuTvnuTUs6tdwiU3cBN/cg2wzAnBscEwwFlYkyjJ/euiYPgUE4fuqMPwWKGYz/AxIYpbIZd823lTsp7jwziEC1Vxe1z6Z9v/+q77UwgZnWBeeTO9NkuJjAu4pfE1Vn2EDDnXchsG5/yTZu7UdF1QV034xg8JsQeuvDs90ltW7dgUH1TBL3SaciGjGMsG+U7R38027tA+lcYEwvusRsiq5qq1ZdHZ4HfJynZDLMjWJHIVJh+7rfKIIkWS8PA83iLc45CDbUYwHSuQJhg5nd5S9G5PFGfANkjpJliiFxKELcnSlDY77pjMtxOdjKivw5bL6e+uMvPOGHgViM60Z0YPgVbdBBBBOT4KwAGh08/x1cd9FjYWd0sd1XqJNsFt8IUSuFJv8fqa56RZ+5bOwz5BhmXa2NIWl4bai0V1xk8QocjLU720SqPn6rqwrGXOrHCk8hA+1D90mbsrYuzT24rInrM4ospbLLayUHsrfH06NmnYUgr9i6aXmbVoVOWPlzZmIuK10K0Afqv8E9v0YLJZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(83380400001)(8676002)(6666004)(66556008)(36756003)(30864003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5NltNsIpF6fiUizrGaUDjnUZQr2z3IaX0poAH2pbmP1rYn/he77yeybA3nk3?=
 =?us-ascii?Q?L7dW7fwY0B7Fpx/U4h8UE2k4ELeAfukvN/B2sLc7BbUIr+Wrb3CJRv6XNlgr?=
 =?us-ascii?Q?s5wSxq6JoAZvVKSdoD0lTbUaY0BYJ2uKyM4x9XXcpzPkeZsJ6feDXCSzm3nG?=
 =?us-ascii?Q?4i9TxwNZXf83V64UlxhV3PSx/8F3MKko/+cImdRP/y4e7Rr2+iCH8Qp3N+pz?=
 =?us-ascii?Q?Jvsx1fqBljxDATvkXgGzVkEBeCNJfY17W2d4H/Cc2Q0PeBpkoxfaD8qJiOgV?=
 =?us-ascii?Q?7SNW+4xSQ/fzW+ccH10bH4zB0nQ6L/UUamT0bgo+iaiwvJyuraWnxH5wpo6k?=
 =?us-ascii?Q?gLsWP//EzbanjXoCrzUSh/bK9DJxIy+ojAHiqtt6dfQVP2wxjJn/Liyn8I3h?=
 =?us-ascii?Q?sEeVSXdm23SYI4EBnd+NgYgdEoxYfArvCAnHxkSHifR2VjChQJBDygo46ip7?=
 =?us-ascii?Q?jY7Fp6ALHB+XPpHWANP8ondxXT8YOVZ4Fy6LMUjDB4REZsFOjKgozRU9ngDn?=
 =?us-ascii?Q?WMsv4zIQ3+vUTT3EoIuNNSYb+TYbOH+CdifZ1ylb5hPUNq7HA5wQjn3h4t8U?=
 =?us-ascii?Q?G0oOPx/wc6357Gy3GxlY/d9FRPRy2Bkl4/xuYVOHn3Knk2uVI9dBQRlEmato?=
 =?us-ascii?Q?9x05RAunnRqcp53K6NS8nwbXRGopGOb8pEbHRsx45joJHlFm4a0I35PnSRBe?=
 =?us-ascii?Q?ttGM8Nt+gSRaJjhq5atg6I2rklhG0pA2x/pIYHUBC+OHHBn2pMUks6PDwici?=
 =?us-ascii?Q?xuSxtLFAPjEmNizX4zQcyp/XiTJmS3cL4q2JZFvOqc4Vq+LqklPxnfnN26JY?=
 =?us-ascii?Q?WUW+IXXS1MZioLJwAVcTULwtyboUmuqCo8pKfn6CsQtWpz9U6n4wCuEulxyM?=
 =?us-ascii?Q?s9WzEmZLsiDfHLn/MqJZv4Wc9ZDoz7rrGQ23b4ajoKpSwmhq7XBMyClZOWCS?=
 =?us-ascii?Q?L2VKJSvfoOO26j2MWqtrydx2iRJKu5imTa8t54C2uN7UzTPmgTMFSmJ/fGox?=
 =?us-ascii?Q?INXpke74qVs4vNYC4uOQRc3nGY8ItU2sDzhuAp6K3jWn3IlzRIcPZOTNduk8?=
 =?us-ascii?Q?dfIwCGMd9OccnyA6xVVzNyLo8zlprmeWuKlRRaQmYM9VETcoAJ/liJFXk7t1?=
 =?us-ascii?Q?XHL1Rm7SwcgUy4p6z9GgByM5nC1gEnh78JvHLUTmTc3AnMwVu9H2xJokGO99?=
 =?us-ascii?Q?PNcLJ9rcbk8KmfJO1KyEEOgPokIFqOhmWkfRa3VwQ/xSeAzWO9Q0i3+tP4Vn?=
 =?us-ascii?Q?5yrvdyzfZY7YaX+Qpdxy6Lp8PaSS9JCyI+oaF4CiZ/e4XWYKnPvWfMYiDjkr?=
 =?us-ascii?Q?8RpY2VNld13M1SbqeyfA2HlN?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e798634-add4-410b-c394-08d91a77574f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:36:51.9454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzkcK/dsCa9Ir9sCGII4Ik5F9QgUpXBmYNhI9N8R8RtYmTP4K7zeYuTvxClf6Eghr6Cl9670hCMgT/JMAB1Dfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
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
 arch/riscv/kvm/Kconfig            |   1 +
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/mmu.c              |   8 +
 arch/riscv/kvm/riscv_offsets.c    |   6 +
 arch/riscv/kvm/vcpu_exit.c        | 592 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vcpu_switch.S      |  23 ++
 arch/riscv/kvm/vm.c               |   1 +
 8 files changed, 651 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 25b24606a89c..bd6d49aeebd9 100644
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
 
@@ -167,11 +178,22 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
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
index f3b60e8045a5..e121b940c9ec 100644
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
diff --git a/arch/riscv/kvm/riscv_offsets.c b/arch/riscv/kvm/riscv_offsets.c
index a3d4effe9947..3c92d2a1ee82 100644
--- a/arch/riscv/kvm/riscv_offsets.c
+++ b/arch/riscv/kvm/riscv_offsets.c
@@ -88,5 +88,11 @@ int main(void)
 	OFFSET(KVM_ARCH_HOST_STVEC, kvm_vcpu_arch, host_stvec);
 	OFFSET(KVM_ARCH_HOST_SCOUNTEREN, kvm_vcpu_arch, host_scounteren);
 
+	OFFSET(KVM_ARCH_TRAP_SEPC, kvm_cpu_trap, sepc);
+	OFFSET(KVM_ARCH_TRAP_SCAUSE, kvm_cpu_trap, scause);
+	OFFSET(KVM_ARCH_TRAP_STVAL, kvm_cpu_trap, stval);
+	OFFSET(KVM_ARCH_TRAP_HTVAL, kvm_cpu_trap, htval);
+	OFFSET(KVM_ARCH_TRAP_HTINST, kvm_cpu_trap, htinst);
+
 	return 0;
 }
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 4484e9200fe4..80ab07ff0313 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -6,9 +6,518 @@
  *     Anup Patel <anup.patel@wdc.com>
  */
 
+#include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <asm/kvm_csr.h>
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
index 20237940db03..68d461729fd2 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -202,3 +202,26 @@ __kvm_switch_return:
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

