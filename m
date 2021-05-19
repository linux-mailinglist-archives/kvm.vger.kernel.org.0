Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BEC38857C
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353154AbhESDif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:38:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26421 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237831AbhESDiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395423; x=1652931423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uJ1cQ5TCpDg7lvQxp7VXMvRgqK+roZt/H/KHq2qUE58=;
  b=DcC/iGExITWXtZ8uEGQLaRcZ03cS+vDDabRFCIg7rqL7XXcSQjCF4xh3
   aaEBogRPYhss1B+b1mU9WPhF0peEBl+kPdrz5neCZjAaP0q7ZDpmoAEIA
   nGCQi9sNOgVUjI4+5EG8MGlVMQvF0liYSAoUyQsUJldv/KSjw7Vp6V09b
   M/Cxi+b0O9cRl3xX1G74HctkOPX7GXiEkDhCOYjW42PQxViCLrpTZW4NN
   LXv7RFRapf4GtDOOM+0M+BvIX7fZFlv/SO1mdMEpBcRW+KlCGmy+bsbcI
   oUcAZ4l3bEDGbNJfyZpwKLZ2k+hXN6rjrAYIl/6uem6QA/a7GDjP2jk/p
   Q==;
IronPort-SDR: Dk0GPvGz8GEtmiRhP2I8QpfMuZumbWf4B3UOawWqcFt/TQQnHe7AEMu1O9EyRXBkydH3weBLye
 2nspNLe87FahjqlJHKGtKsqWALnsjl2+rmTNOnOfAMAgxetpDVVRaU1oHmqQoibXt9hklDlruP
 S66fJuPT4V7J82TRGIXrdIgyuX8xYY2Zc0r0ER0a+l59mI5njHH2LAGbT6Q8RStWS6hd5rHsj/
 Lf6/LLEghw2iaj922gffyGs7LbtBb0tqA1EZFxC83k3EfvcU0kBHmk6UTl62LjHIA1pJ2biFfB
 HJE=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="167950769"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVtHUBHA9joNnvCyy+kuZc8zQ0YJRacZSqfQAex8TZuKt+PH7MFMmAb9MTZYPLko0H3CuCQ3H8wc82o/uw0xSq64RHkILGXK1OPVvkvOMB7EQBtPInmYr2BZjTf7IiRNWA/oajTgZHfx8Ro49UD1Voo/ue3dolTmMAo9IvK+gAXPf4+3rdrm+A3CwRsdgDdEjlFZhZpJ50FNHedrE3Hroi+YG2P0Vv5CJxvpE/8vdQbro3sGH1YFC6jeUeRfMMVe2vwZIBFNMD4gK2WaY0i+RgtcQfi82lUzlMuFPvybP+Sr4FooavjkrylDYt/TLy3EGUqvcP2CPO2M5eYGoRnTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLtRx8HEIyMKmZr25UUwzwkT9EU+mkHvtnR9EBUCMDA=;
 b=K9Pk3qDItm3r6t+u5vZpF6wcJtvEY4LQXEyWN1OeIzrgSUOnUuT+MHr/3P9NNG7CzOVWjdxTvrH5D6ec3tWowZcQeZI0lI55yYW9w5/QF2vGum9jO2CQqXzMALS9Uf8XKPqfIFSFoIC6OyUsP0p2fOkYnTHmnSfCjefCJlu3m2zfm0+yYSkBrecD7joi3ohRgTtrLg66jbSbqvj3CPZ9DLdIySQ+FgcU2TVhjUa3/6TfqOuA1xSCmeutyY4SypxDjywYpoJJL7gH/tyiyzpy7zu4/57Sz4V44kutKq2SZwsRm5XN3sw+3ukSqZXlyK7gnrN4JEcJIgI0IvI2pZ6oug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLtRx8HEIyMKmZr25UUwzwkT9EU+mkHvtnR9EBUCMDA=;
 b=yhiN3sSzkzOpOB85T7/xdP2aNrATCnXgK0VMlp7ugyufj+1ry1FWKLEs2zl+JOiDLfqpaAlIINCncEvCTYgE5u9aiwrQBk9tp7FK27jkOwf3qIdNYqi+Jhu4Ki//3lLyFDEQ8NfblBCct2dXZnxDzexYAp9qMR6w+OvsN6e4Ofs=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:37:01 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:01 +0000
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
Subject: [PATCH v18 09/18] RISC-V: KVM: Implement VMID allocator
Date:   Wed, 19 May 2021 09:05:44 +0530
Message-Id: <20210519033553.1110536-10-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:36:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0ddecf4-72b0-4f78-2c43-08d91a775d34
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB776161D532758A0A0CC6D8968D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sMS5EQHXlYc1ijVNv9RLkhtERn2opwO+fNOEsCboc4Ba+t6CEo4IUg2bMD3OGPKpFPyDmH78aDWmAAKzbijUbT9KlOfpsYITHfg+v4ajCi/fU7mr4BI0CzSsmVVgxD8bWynUoDKD6aRvEOmjG3YVnyAFrTTRyrE88CA5b4CKxncCD87b41DLMJIvc5/a2Ob8M9iouZZGU70aEXuICJlnEPvuOYzPi4oZmTRQIzrG4cMoztYivDcQIKDRZSDAbpg7nv9JlhEU/vbZQUtaenUNcwQExbqVJc25dByjrKi3z0GduOMXZ6h+hg0aNImT4vaV/6Mz/6uajxU58YLJyRJgtFIm07SRCuPian8FSJkOOFWZV4Dy/1mRqCcl2HI2GxHsFWGRCtOHLuuHbO5+J9ed+XoMtHt3wtfyGpqTCexkeV1bLYvACsxNL/y+rxnvNSYf1BdKE/1BCMAQfvAGM0Aln8mQdR+zte0lUOflza2bsIdDcjX3f7vqD1KfQ/Japmh0aO1vWHujxmHXRVX825fxT1JlO8NMtDLz856A5OBdMSx1ocLxzJ66jVHYTo4sIQEk1y+0iJGO3rsDWiPpqCQvEv7lHPTn+xPxBH+CyvKe1bm5CxILqdzrpb6zMf35L9kwnr1fg+4HwW5IMEuOdYDA2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(83380400001)(8676002)(6666004)(66556008)(36756003)(30864003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OuwbiA7H7ECcV/qWVsYb0zLL9GbHrkDrwhZzZz9xsz8pe5WQaBn7SzrjNlMM?=
 =?us-ascii?Q?z2j6E112Lre2g0j3FHwzaqM3SItxrZSshRWB3HVRKRdf2AK1GbvLLsimQvzO?=
 =?us-ascii?Q?wvMU4UFpySpYsdgFlyu/coIBPHlfrpc+j8QtfLo2ng544xKk0GI64kOuthse?=
 =?us-ascii?Q?2W9XkpmSIZS7QxyWdbvbcy5jkdeg3BHGXOjfbs31Na299WFm3539t/0+O/7O?=
 =?us-ascii?Q?rMyXVbPxPZW0A5GIhl4ojJ9lAgDVlXbBpXIG6TQVMAX5mfWtQJlS/yn0TJeb?=
 =?us-ascii?Q?SZkoH8snmfDBfgfNbYxR1qXmJf8t2Xh2O9nvVmVQLrfBEUpO/5UdVH+E4cSI?=
 =?us-ascii?Q?XHcFmXqCuxM1ZNeVpn9wp0F6HRuaG3MLJrnOxFaTDsT9Nt4T3QIsBLIOXiUQ?=
 =?us-ascii?Q?i/XReD9X7odGUuYGY0fBnLsNyqa9+jESDiuvqXtgYT2X8D4RfzoddUiK9RYS?=
 =?us-ascii?Q?P/mOgNF5zHvFdy6G8YqXjlrpeHEyqctcmYkxHex+uFhRpmjKpcWdQ19Lt0hA?=
 =?us-ascii?Q?RxgHq5BSnDPI6Ic+ThH1R/BhnaZmL1eWkUEbgG0APMggpVtB/2iBe4J6SRAU?=
 =?us-ascii?Q?+zHBUKuA5J+41Uyyu9OLsMvOxziss+O6QpmsG0yhC+ZqGt3sFIachfWWXoGc?=
 =?us-ascii?Q?T3ZZHnQHOJ84BxsmClKDdL4/EPcM0X+i6cZJtFF1byKFFgXYv2wmCeu6HG9k?=
 =?us-ascii?Q?pEfOyl2FykE1IelavubGa3c6NQ2ViDMII5dBBFZGifDjNbONYYqv9pjS7e0s?=
 =?us-ascii?Q?2OG1p6yDZwNksXSopkYJXJDR2aANuwP2qBo/9SnKEaD560GgWwRNUXTqkLKv?=
 =?us-ascii?Q?tMrxewNtZrsYdThYApp18EuNAHsPYUov6wOCW873EyvNhBY545dtsDboB57m?=
 =?us-ascii?Q?goKdeQeIPTWqpC878hvvTwYeHI4p6oaVZwmU/Pn2JLT2NhZMm0PDtW1aT9g7?=
 =?us-ascii?Q?wBtOHeVxwOR7MICViqGn0sjaJxJWfSvr2Bng1QDA4zo/f5+obLshaElia4jg?=
 =?us-ascii?Q?0WimbRGHLYVhVqWdInoaJ7YG5kbOz99Rkid8raA9TwaJcRtICsrdHErimr6J?=
 =?us-ascii?Q?o2FSEyvdLL50wUUDPXICy6dZWiY2iT/6AGRMBIl+rSbMea4I1hEwCDVIYZz/?=
 =?us-ascii?Q?xcob/YcliEYDfqTt2oecoM8jb5VmMU6csfk38WjMMO+9zA3jHwFy9X8tgSl9?=
 =?us-ascii?Q?OjbxeqAOmZcTcOupSfkfyFiotcSI3wotrrHAe/y2W32nZfLaca82vwC8HYgq?=
 =?us-ascii?Q?6CtUZfiaN2PxNCgNfnX3v5Mx3uuRVdD3jhE09qT6ag2LUBuitNBrFkjdV0vb?=
 =?us-ascii?Q?2Qvo2+K4vK9z/Q+1Erxtnqsp?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ddecf4-72b0-4f78-2c43-08d91a775d34
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:01.8060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFnJGVY9K/w+w7HZ2tHYXUxV3ZFunUBpAbhj+h4zmtkHqAE2eQzJOmwejY862cHtm4NtI5Laf89EsxlhOgf4nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement a simple VMID allocator for Guests/VMs which:
1. Detects number of VMID bits at boot-time
2. Uses atomic number to track VMID version and increments
   VMID version whenever we run-out of VMIDs
3. Flushes Guest TLBs on all host CPUs whenever we run-out
   of VMIDs
4. Force updates HW Stage2 VMID for each Guest VCPU whenever
   VMID changes using VCPU request KVM_REQ_UPDATE_HGATP

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  24 ++++++
 arch/riscv/kvm/Makefile           |   3 +-
 arch/riscv/kvm/main.c             |   4 +
 arch/riscv/kvm/tlb.S              |  74 ++++++++++++++++++
 arch/riscv/kvm/vcpu.c             |   9 +++
 arch/riscv/kvm/vm.c               |   6 ++
 arch/riscv/kvm/vmid.c             | 120 ++++++++++++++++++++++++++++++
 7 files changed, 239 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vmid.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index bd6d49aeebd9..40449ab2916d 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+#define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
@@ -48,7 +49,19 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_vmid {
+	/*
+	 * Writes to vmid_version and vmid happen with vmid_lock held
+	 * whereas reads happen without any lock held.
+	 */
+	unsigned long vmid_version;
+	unsigned long vmid;
+};
+
 struct kvm_arch {
+	/* stage2 vmid */
+	struct kvm_vmid vmid;
+
 	/* stage2 page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
@@ -178,6 +191,11 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa, unsigned long vmid);
+void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
+void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
+void __kvm_riscv_hfence_gvma_all(void);
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write);
@@ -186,6 +204,12 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
 
+void kvm_riscv_stage2_vmid_detect(void);
+unsigned long kvm_riscv_stage2_vmid_bits(void);
+int kvm_riscv_stage2_vmid_init(struct kvm *kvm);
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid);
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu);
+
 void __kvm_riscv_unpriv_trap(void);
 
 unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index e121b940c9ec..98b294cbd96d 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,7 +9,8 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
 kvm-objs := $(common-objs-y)
 
-kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
 
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index c717d37fd87f..998110227d1e 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -79,8 +79,12 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	kvm_riscv_stage2_vmid_detect();
+
 	kvm_info("hypervisor extension available\n");
 
+	kvm_info("VMID %ld bits available\n", kvm_riscv_stage2_vmid_bits());
+
 	return 0;
 }
 
diff --git a/arch/riscv/kvm/tlb.S b/arch/riscv/kvm/tlb.S
new file mode 100644
index 000000000000..c858570f0856
--- /dev/null
+++ b/arch/riscv/kvm/tlb.S
@@ -0,0 +1,74 @@
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
+
+	.text
+	.altmacro
+	.option norelax
+
+	/*
+	 * Instruction encoding of hfence.gvma is:
+	 * HFENCE.GVMA rs1, rs2
+	 * HFENCE.GVMA zero, rs2
+	 * HFENCE.GVMA rs1
+	 * HFENCE.GVMA
+	 *
+	 * rs1!=zero and rs2!=zero ==> HFENCE.GVMA rs1, rs2
+	 * rs1==zero and rs2!=zero ==> HFENCE.GVMA zero, rs2
+	 * rs1!=zero and rs2==zero ==> HFENCE.GVMA rs1
+	 * rs1==zero and rs2==zero ==> HFENCE.GVMA
+	 *
+	 * Instruction encoding of HFENCE.GVMA is:
+	 * 0110001 rs2(5) rs1(5) 000 00000 1110011
+	 */
+
+ENTRY(__kvm_riscv_hfence_gvma_vmid_gpa)
+	/*
+	 * rs1 = a0 (GPA)
+	 * rs2 = a1 (VMID)
+	 * HFENCE.GVMA a0, a1
+	 * 0110001 01011 01010 000 00000 1110011
+	 */
+	.word 0x62b50073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_vmid_gpa)
+
+ENTRY(__kvm_riscv_hfence_gvma_vmid)
+	/*
+	 * rs1 = zero
+	 * rs2 = a0 (VMID)
+	 * HFENCE.GVMA zero, a0
+	 * 0110001 01010 00000 000 00000 1110011
+	 */
+	.word 0x62a00073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_vmid)
+
+ENTRY(__kvm_riscv_hfence_gvma_gpa)
+	/*
+	 * rs1 = a0 (GPA)
+	 * rs2 = zero
+	 * HFENCE.GVMA a0
+	 * 0110001 00000 01010 000 00000 1110011
+	 */
+	.word 0x62050073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_gpa)
+
+ENTRY(__kvm_riscv_hfence_gvma_all)
+	/*
+	 * rs1 = zero
+	 * rs2 = zero
+	 * HFENCE.GVMA
+	 * 0110001 00000 00000 000 00000 1110011
+	 */
+	.word 0x62000073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_all)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 654a4834a317..cbaf14502c25 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -622,6 +622,12 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_riscv_reset_vcpu(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
+			kvm_riscv_stage2_update_hgatp(vcpu);
+
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
+			__kvm_riscv_hfence_gvma_all();
 	}
 }
 
@@ -667,6 +673,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/* Check conditions before entering the guest */
 		cond_resched();
 
+		kvm_riscv_stage2_vmid_update(vcpu);
+
 		kvm_riscv_check_vcpu_requests(vcpu);
 
 		preempt_disable();
@@ -703,6 +711,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_riscv_update_hvip(vcpu);
 
 		if (ret <= 0 ||
+		    kvm_riscv_stage2_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 496a86a74236..282d67617229 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -26,6 +26,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (r)
 		return r;
 
+	r = kvm_riscv_stage2_vmid_init(kvm);
+	if (r) {
+		kvm_riscv_stage2_free_pgd(kvm);
+		return r;
+	}
+
 	return 0;
 }
 
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
new file mode 100644
index 000000000000..aa643001bb6a
--- /dev/null
+++ b/arch/riscv/kvm/vmid.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/cpumask.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_csr.h>
+#include <asm/sbi.h>
+
+static unsigned long vmid_version = 1;
+static unsigned long vmid_next;
+static unsigned long vmid_bits;
+static DEFINE_SPINLOCK(vmid_lock);
+
+void kvm_riscv_stage2_vmid_detect(void)
+{
+	unsigned long old;
+
+	/* Figure-out number of VMID bits in HW */
+	old = csr_read(CSR_HGATP);
+	csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
+	vmid_bits = csr_read(CSR_HGATP);
+	vmid_bits = (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
+	vmid_bits = fls_long(vmid_bits);
+	csr_write(CSR_HGATP, old);
+
+	/* We polluted local TLB so flush all guest TLB */
+	__kvm_riscv_hfence_gvma_all();
+
+	/* We don't use VMID bits if they are not sufficient */
+	if ((1UL << vmid_bits) < num_possible_cpus())
+		vmid_bits = 0;
+}
+
+unsigned long kvm_riscv_stage2_vmid_bits(void)
+{
+	return vmid_bits;
+}
+
+int kvm_riscv_stage2_vmid_init(struct kvm *kvm)
+{
+	/* Mark the initial VMID and VMID version invalid */
+	kvm->arch.vmid.vmid_version = 0;
+	kvm->arch.vmid.vmid = 0;
+
+	return 0;
+}
+
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid)
+{
+	if (!vmid_bits)
+		return false;
+
+	return unlikely(READ_ONCE(vmid->vmid_version) !=
+			READ_ONCE(vmid_version));
+}
+
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_vcpu *v;
+	struct cpumask hmask;
+	struct kvm_vmid *vmid = &vcpu->kvm->arch.vmid;
+
+	if (!kvm_riscv_stage2_vmid_ver_changed(vmid))
+		return;
+
+	spin_lock(&vmid_lock);
+
+	/*
+	 * We need to re-check the vmid_version here to ensure that if
+	 * another vcpu already allocated a valid vmid for this vm.
+	 */
+	if (!kvm_riscv_stage2_vmid_ver_changed(vmid)) {
+		spin_unlock(&vmid_lock);
+		return;
+	}
+
+	/* First user of a new VMID version? */
+	if (unlikely(vmid_next == 0)) {
+		WRITE_ONCE(vmid_version, READ_ONCE(vmid_version) + 1);
+		vmid_next = 1;
+
+		/*
+		 * We ran out of VMIDs so we increment vmid_version and
+		 * start assigning VMIDs from 1.
+		 *
+		 * This also means existing VMIDs assignement to all Guest
+		 * instances is invalid and we have force VMID re-assignement
+		 * for all Guest instances. The Guest instances that were not
+		 * running will automatically pick-up new VMIDs because will
+		 * call kvm_riscv_stage2_vmid_update() whenever they enter
+		 * in-kernel run loop. For Guest instances that are already
+		 * running, we force VM exits on all host CPUs using IPI and
+		 * flush all Guest TLBs.
+		 */
+		riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
+		sbi_remote_hfence_gvma(cpumask_bits(&hmask), 0, 0);
+	}
+
+	vmid->vmid = vmid_next;
+	vmid_next++;
+	vmid_next &= (1 << vmid_bits) - 1;
+
+	WRITE_ONCE(vmid->vmid_version, READ_ONCE(vmid_version));
+
+	spin_unlock(&vmid_lock);
+
+	/* Request stage2 page table update for all VCPUs */
+	kvm_for_each_vcpu(i, v, vcpu->kvm)
+		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
+}
-- 
2.25.1

