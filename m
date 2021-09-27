Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A08419381
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhI0LpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:45:13 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36452 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbhI0LnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:43:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742897; x=1664278897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=PCjEaBEyl20UIcQjjpwydFl6laBPbJVRjSvdD8QvuMQ=;
  b=QZmu6zI0BTHB3Ggqi8USJPW07PWvOrE5jsYRxA9/tp5SBwbXGNU6342Z
   7smEhznDHdshSohQuCIXtkwWMCsIla6hdh9PB9kp53I1yMFOHwZHrCOBw
   V+0tIl3P7q07WzKSYOK5557VRYRGBCm1EU0qyxkobL1bgrX+frTUpzd0i
   4xWXZK0UtOSRb49n4n8sB+r603dn2J0C+0YAYHSl5XnoRWeqBZ5iN2FUA
   OUE/QiKdgHrvi14ZCfzi1Wgiwhy0csgS9B6rOsHRXutIMmYRDJJKrQwDZ
   Kb2H4+WtYx1HHw3pZPpYji2SOax+yc3BXRyvRn+33S7r3XJ7Kiql9jzkl
   g==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181673073"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:41:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+NlQrkTYpdZk3grdxPDWafZgIFO8buAuGPz2UGdJm9KWKvZAA2FghOzktCeMmY1uKa5huHbhiyc9477AGtDYVQ4zfpBQLjgzxjZ1zgo4PyMzBzNhCLFl8tEBAMRrWxmfuOzdIldRjBfoxzX3QxLMUvVsfEznhXIxr6ZHfE98qGo0RJefkOO885EvFUfs5feyJ+TF0UjgknpYsW87idx/5UcLnTAkZgJmoxS7fvQ6gdCjvZyYuJ1O43aAx2SWuArPiRxT5NiIf1TFtZMP7d5Viip9BLznhtNI3OuT/3hYH94Up8ebO+apq0PigejbfHT780+HmMCpNB5j2ge0/jAlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4FSRDMZqvrOO7mkrFVo14uJ1QXDMxnyNF1hS60SUUbw=;
 b=ntnYCk3pl5BmXU5+TTGLYyP7ld3Rupz5ZJTgY0Xq/Nfw7Abw2okuvsQMxEIN53vuz0OCoHkRSpnEyXUBZJMoT4OPvOc0Es2HvN//m/iDRGsdYnr1RPMLxh1p8ZMTYWzj40Pi00Dw/2hm1Dlo0csStdxd1RIXqnnMa+gLRfU3wDSNvLqoNbpY1J1eW+6UeBEX6Z1gLjOgDP7R1IBiSoxexa/tbx/jCknotrS0ih5868x6CQjQ12OPPV+GBxrYoId9jPdUCMd6vfTsAzYFQ5NRN1VfGx5FJ8yPdB0qG0J5TFfp3DijFJCtif6Bbd7OyJ0QAwHlKePZfmjlpS1NtGz1Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FSRDMZqvrOO7mkrFVo14uJ1QXDMxnyNF1hS60SUUbw=;
 b=r2EVPlIaRpbk1z0hkw6effqMbdz2QO6TEct16zFrzPztjshFjPwK3/wOqOaesX4gEy/8ibP0qx1LW70IeCEX/pSo2bHPr3ava4d3zg8XylHaqQQEjvFbFrRkPMSrOZSZh01ijqJaVPZuTUAQnvQToE8yuNVecwWoZqD4FoHhsf4=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:41:33 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:41:33 +0000
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
Subject: [PATCH v20 11/17] RISC-V: KVM: Implement MMU notifiers
Date:   Mon, 27 Sep 2021 17:10:10 +0530
Message-Id: <20210927114016.1089328-12-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:41:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 593cfbf2-fd04-4649-fda7-08d981abc127
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB823608BCED8E57468DC5851D8DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UCyIkz334V/sMQjB84g/Q3BHpBeTEY6Dc1TWEwticB9GoHq36kC6sET744zZvggB0QPBEZ8H/q7SKyAJOhUm7DFkftbexYZUC95sSj+Xd2xNOhoey35uKOaL/FwAt6plaR/9TGB1BJqoX+aDVTeNRfvId9s7VYw6Aqil5iVDXJeKX5Wa6jgI/DYXhqgJInS1SPUogoD9J8pph1wsjdTRzlZAUJGiwlePgu33Fq0TdvxHE+XDY1PC94r6sFtaUJGjBjcgHRlolgJakFrfI17vyJWGqoAxDU2e97XyonNcJZcM5xrnaTfA11uHJCCQz0u2Lp7GUalOYjthx1Q2b3yQTMvPkwD8rQ674l+a2Bok7MLXfr3ufI4aRp4AUWgb+cp7/8UCZUZoGRjDa8bab3gp0C7aj861HpPyy3XvyGQPe+Xvdpx621cphBHgXl+h88rEoac1jKEGJa8Qi0vmO8E+KLrwquqJF4O5ADmBb717Xslf9zZKXc0QyGFHd6FR8SVA3GVRu+3mj0m38zQDgT2V2DJpoXG/TuWeBwRukb8XrcoUYRU6IDKO8EkAKHNAsZ6lSC19WjOfsqHoe8eKVCpRYueJruLQQzHoya0LyoLEf6x0n/5qd7wwL/2A7n1uUaKqsTNxBBZh20UojxRVgiRnPNbMTozqwJwSZGEZgNFcIBTgQ/0o8QfkVqS8oOyw3mt94kcyQFHCEUGfPHPyUEPBTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(44832011)(38100700002)(54906003)(110136005)(186003)(55016002)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(7416002)(26005)(83380400001)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N8kZ4VJOQox7/WFGigIZ2+K3/blxnQpj1eKHuvSyFsV+BGMypTQgLIaN8q1A?=
 =?us-ascii?Q?/6B9LdCAQL3B2HwE5m/dRWLwiYbCxRe3FG3A1Mbppj2qcuycCdgza5iZnBch?=
 =?us-ascii?Q?cTUrCCfgNA/J3IVebRZsQp/iNQI7RmrlLTWMagVlUmSvipJQWkauuf9sZt8s?=
 =?us-ascii?Q?WIziEJecuSSmQQAiDX/I/bgkCcbHCFp3/7qv7DnW75r2oAcgA+6DptORb2En?=
 =?us-ascii?Q?PO/rC/sgcvz3EyLS4dAh1Q+91ucx/P63inPXIywi0lgJdEPslleKneidps0a?=
 =?us-ascii?Q?/164FXk6CZnazfWxnjVTuwxTcfrfpPTZNWY3RHeHS9voVFjXV3MlacafLwDj?=
 =?us-ascii?Q?AEfWmHt+QgAw5oKdLfjUrp/H5uCNTChoPZWOC+LZ57/FGPuWQS05fxJ4M584?=
 =?us-ascii?Q?GL2wS4L5ZRMA6L/+vbNBHQNmhHRaBkMqqZFq/G1J6SHFaD/h1TX2Duj4oAa/?=
 =?us-ascii?Q?Zl4+QjjEhDMQI4SqQ2F8Un95pNm7Wzvv3OUEYawTAOIDXV9d8QZIWUmluFhK?=
 =?us-ascii?Q?h31nD4vp/yuneXW+1T+q5FZ9XhEQp6S4ri0zvn2g73GK2LB+a0H6+S+SUpSG?=
 =?us-ascii?Q?/jCGJQz7kq+gTod+a+mxzFLaRVWJlY+xWWctTa4RI8//NJA7HqbJB/maNwMN?=
 =?us-ascii?Q?M+EhgG2jyvF+8/yeNY6ozTgY6CZraHDjcZ10Hly9FPw0+V4oc2ZHHUvZz3C0?=
 =?us-ascii?Q?LZ6MX+syBjNsGur07s/rUshItEPjn2KTUnLV6aJgi9oeRas6dz0LBMbMFym9?=
 =?us-ascii?Q?5i5T7MTVLXCX9SNR2EUBiJo6cNgCopSI9r2fiJuOnS6EpNSZM5BIaIpW80wS?=
 =?us-ascii?Q?C6uN2sbn/EbNN9oJPwqkAZ7Drfs5fn/AurOzB6c54kHak24SmH5gBl6b4WHP?=
 =?us-ascii?Q?Oya7AfS69pR1x02w9bMA3QArIo2yWJsrG6RAiuCT0A2ZOykCwqfLz3bX//cM?=
 =?us-ascii?Q?kIdXrNObLhF0cQeW+dZbTL5WlIB/SLGg3bitmQnWVUyArfDiJVuawB1NZ/Rj?=
 =?us-ascii?Q?bQ0neLlrfYmXGO8yChs0Dsm4TdmdhayZdxVLt6lnjbQUEE2XORXneYOjCHpU?=
 =?us-ascii?Q?PfcUBb76DEhlaMTm/B+uD8Fp1KXFuB+NlX/RqB+mNGKkI0O2BHhkRYi8+RR5?=
 =?us-ascii?Q?ctnp29aQb/nPGiCs7ga+40pRwj+lfxs+ZZ5Vlk5pVRzQU795TsV8VwXyS/RP?=
 =?us-ascii?Q?H3Sw/6S3UF6Qikb8A+Mo0a0KQvopRtl2jB9FfU3k9YhGwuiAg0W5SqA+3nt6?=
 =?us-ascii?Q?ENVxRt71g8giXXgnr/1ap+NpZ0dVeG6xwQLOGick91/izpJn7OyuSupm2+qW?=
 =?us-ascii?Q?plwGVYoZ1Q8+BR7g1r2i+qNJ?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 593cfbf2-fd04-4649-fda7-08d981abc127
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:33.1760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsqX6dojlzCWAk5Leg9spCPKDoRkVI8cOzscaBD3qghZ8f6TWZrHe3aFCBJvLqMknMp02NNuEy2dA4qgXM8b7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements MMU notifiers for KVM RISC-V so that Guest
physical address space is in-sync with Host physical address space.

This will allow swapping, page migration, etc to work transparently
with KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  2 +
 arch/riscv/kvm/Kconfig            |  1 +
 arch/riscv/kvm/mmu.c              | 90 +++++++++++++++++++++++++++++--
 arch/riscv/kvm/vm.c               |  1 +
 4 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 2e71a353395e..17ed90a4798e 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -196,6 +196,8 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+#define KVM_ARCH_WANT_MMU_NOTIFIER
+
 void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa, unsigned long vmid);
 void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
 void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 633063edaee8..a712bb910cda 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -20,6 +20,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
 	depends on RISCV_SBI && MMU
+	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select KVM_MMIO
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index fa9a4f9b9542..3a00c2df7640 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -300,7 +300,8 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 	}
 }
 
-static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
+			       gpa_t size, bool may_block)
 {
 	int ret;
 	pte_t *ptep;
@@ -325,6 +326,13 @@ static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
 
 next:
 		addr += page_size;
+
+		/*
+		 * If the range is too large, release the kvm->mmu_lock
+		 * to prevent starvation and lockup detector warnings.
+		 */
+		if (may_block && addr < end)
+			cond_resched_lock(&kvm->mmu_lock);
 	}
 }
 
@@ -405,7 +413,6 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 out:
 	stage2_cache_flush(&pcache);
 	return ret;
-
 }
 
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
@@ -547,7 +554,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
 		stage2_unmap_range(kvm, mem->guest_phys_addr,
-				   mem->memory_size);
+				   mem->memory_size, false);
 	spin_unlock(&kvm->mmu_lock);
 
 out:
@@ -555,6 +562,73 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return ret;
 }
 
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	stage2_unmap_range(kvm, range->start << PAGE_SHIFT,
+			   (range->end - range->start) << PAGE_SHIFT,
+			   range->may_block);
+	return 0;
+}
+
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	int ret;
+	kvm_pfn_t pfn = pte_pfn(range->pte);
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	WARN_ON(range->end - range->start != 1);
+
+	ret = stage2_map_page(kvm, NULL, range->start << PAGE_SHIFT,
+			      __pfn_to_phys(pfn), PAGE_SIZE, true, true);
+	if (ret) {
+		kvm_debug("Failed to map stage2 page (error %d)\n", ret);
+		return 1;
+	}
+
+	return 0;
+}
+
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	pte_t *ptep;
+	u32 ptep_level = 0;
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
+
+	if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
+				   &ptep, &ptep_level))
+		return 0;
+
+	return ptep_test_and_clear_young(NULL, 0, ptep);
+}
+
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	pte_t *ptep;
+	u32 ptep_level = 0;
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
+
+	if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
+				   &ptep, &ptep_level))
+		return 0;
+
+	return pte_young(*ptep);
+}
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write)
@@ -569,7 +643,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
-	unsigned long vma_pagesize;
+	unsigned long vma_pagesize, mmu_seq;
 
 	mmap_read_lock(current->mm);
 
@@ -608,6 +682,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 		return ret;
 	}
 
+	mmu_seq = kvm->mmu_notifier_seq;
+
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
@@ -626,6 +702,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 
 	spin_lock(&kvm->mmu_lock);
 
+	if (mmu_notifier_retry(kvm, mmu_seq))
+		goto out_unlock;
+
 	if (writeable) {
 		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
@@ -639,6 +718,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	if (ret)
 		kvm_err("Failed to map in stage2\n");
 
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
@@ -675,7 +755,7 @@ void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		stage2_unmap_range(kvm, 0UL, stage2_gpa_size);
+		stage2_unmap_range(kvm, 0UL, stage2_gpa_size, false);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index e2834ab9044c..892d020674c0 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -65,6 +65,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_READONLY_MEM:
-- 
2.25.1

