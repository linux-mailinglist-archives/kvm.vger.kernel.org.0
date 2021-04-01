Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC24C351AAE
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbhDASCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:43 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55706 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbhDAR7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617299961; x=1648835961;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Cv7WX2EE1SbRar1JoxqAaBKIwtCLmzEkTXxez0zd1NE=;
  b=VefwTBhqIY/1qCC4APKzzLMz5g5BPkoqQIOB0+PPaxZLVTKK0nwI7TcU
   vtTYNMNetITR44ih321obiVfUwA5W3E4MLTiufxWqEmqgpmKqkhGW8seJ
   7Ly6pxJTH3sS6s6NUhGE+nFP3Wmro/NDFXiuviuNQxYO/PJPa0XoePxPY
   Blbxs23rymC+hOpGXzrUVFVSvgFWCEcxTacI1+hQsisuC1cMW/YmgStq2
   2jqr3gKhXLDh9yTh1RljvOH0cDW+gg23xAPMnUB2K2zvKhwMO85MWTffp
   v6z5nmsGYw7aYvAxtbpEzoitEPCZhp8WN56N+vuWzSCIhvcs4lJ7L+3OG
   g==;
IronPort-SDR: WSFNYfDvccBw5H31ocTZJiVYzQ3t/pK67Q3lEGB+wSDHzpNIt+Gd+2J8q5/wNa3y20OU+5AfjI
 ubQXlWsj+A/RlnPdtbGff1C3JkF+47IJxrrY333YcSXgSf4Anu6anE2NzGuc/V4sAs6/sFpTu3
 r7KX+m1mjd8VeWYKKwCfEU3sjysX2HTy2qmQOqz/jACfMiez8Q61uRalCRWIHJQXawadZ6Riyi
 SplCFtyFGTNAAMcBCTWuK6hBOJ3a+ZloPHa1KuIRa/JWDRHWpjqbe1V937ArcH/Xfrpduu5PY2
 g5Y=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="163561074"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:37:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvP+TWZEpgm60+UTpZ9xfcBDASt+MN50cn2cvf/g4uRSRL9X+WwVqKQaEqie5zoumMgMXaLMqko9tGAG6vssiDkkm5jsBvZeU70kL46XDwTkMqxrOoK6VkDev/cbfKuLNDn59YINAsBDNsdTuu9PQ656rRk/Ty6YM0URZPbYhPKctvMFkb2M3smlljsE/4g441Vb0UhzHPwuzd3huE+OXxhOwcNVyCGM9KenJDvlnMkxOv22xuZnpz99FSwpvsJ15trAJppvmMRn0QzyfgWlzDtbWbwr9jpTm4tCHcZ6oOJlUSUhEHM8rDwU1yNR66I+nta2D+0vqijqTOGEyprIMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Jj3CxBbVd76X3DYsqH5OF8ruAN4DCs8ldmy6Vz7apg=;
 b=gV7bP5caEIPotXURMyAbZNOnaVJ9S65zCt9MuLdNmnwEvCzqp5CgAGdW9w+qHYuT0VrtydYzkcG6gjK0HEwR/F2igUCg2+ckx6Rvz5pA7A3IfKy4MnWXUhodHE9insif680JV60ZS12H8lWd7xkpA9xq29XWDlke2+6jRQ+YXoV5LwV+YaCVcnfQQpSMtUoKetpdRYOKIB23njLaSlrOmO6BGxpJGFIuBJKRiKw7ZFtc+q9UJnsw6rNquKxLHr66fkBecs8EN5u02WUtANHO5GJPIcZauaUnrCYty1XiyG3Cyd5N6sf6Z/4N5kK2BWuLtYZQmRtNxIORg3yJ7VkFOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Jj3CxBbVd76X3DYsqH5OF8ruAN4DCs8ldmy6Vz7apg=;
 b=Tj6HQ0a0A9+Nr4KbMuw1ZG9fp7bhUiArDBFIixtFy4RbqoSfyyFXXFpuyf/z7wSdbpdiUvWQlg2YlWBMz5f7CAbQxvD+3Vi/mYiDo8lgJabfPsj9ME/rhS4LkSWXOFqqNd2Iq7cVBA7bQIAzEveloGIxyhhDhFtIaV0uDVYeylI=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:37:32 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:37:32 +0000
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
Subject: [PATCH v17 09/17] RISC-V: KVM: Implement VMID allocator
Date:   Thu,  1 Apr 2021 19:04:27 +0530
Message-Id: <20210401133435.383959-10-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:37:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4ef0fc9-d327-47b4-7319-08d8f5134d36
X-MS-TrafficTypeDiagnostic: DM6PR04MB6528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB652839622D54E76D1AA969498D7B9@DM6PR04MB6528.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VazmdDQTTQyJHXLODQgGNS7EmpiFGqADanHFm7NPI7+9MJhQTNksJdzi/b46DM8OfitS6BWv80CM9N3ukGiEpajV2O7MrDJsSrC2VXqngizEU5mIX/pGx5uAf0vzQxvVejsisxUtNWBY46NVcZnxO0JnwV/ZExMVnxGAZJzpJwOhA3HKzg/Dko3q+goZeO4Z1izl8xmh8vGBhrVAgf6xsLpAmK5Yjkx+dJm9pWGRb+jWhxKabK0COjrP6NpwF9ZJKOAxXVXR7GANW+ZiER1xffbPYs5LHmC5gJcB7CsvtIXMBhBxRDyInd/jve7TU3kKY+qiSIV0nc6paIKLK1A3ucoVOl/ymXRF2nMVaCUg3Fu24O1eeQvGkWtJDx+yqo7wMwNolEd2weUNMwCLt1nmPg5WIv1O7WB+lpN10c8WsCP3orTmJPaTBlibpbJi/CUeWYqonMw93+eYoa2x2/XNBJ/9Cg5KhuzEuyvz4vrWUH0Yx37JJeRvH7plJwmuzRt+Qo/s4IhHWrZXX/VOQl0OV1g87FKkDtVgO3cFb2j6yM4/rhextHIrym9QUDP884e7/A2ko+x760RKx8hNY1TLUuuik00orNQSsMiF/nhccKCeU7ASRBrRHgIk6nSX3i7/noENcBmgDMGHAn1yvRSAkNLY6f/ik6zAwaAv0+e/huc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(8886007)(16526019)(36756003)(186003)(4326008)(956004)(2616005)(6666004)(316002)(66556008)(478600001)(26005)(66476007)(2906002)(54906003)(7416002)(1076003)(8936002)(55016002)(86362001)(83380400001)(8676002)(52116002)(110136005)(7696005)(5660300002)(38100700001)(30864003)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pBZSXNaNVOOEpcDNDrR/uMy35qT8rNmySHv3a1bAI+l9KPx3NiY9rbSZhimD?=
 =?us-ascii?Q?PNk1Z/1AL4kDXvhGIt9VO5PdqklW3sSays9FSirzzMtbztOnkruTTl9nkNfe?=
 =?us-ascii?Q?3TiFsLZXb9KgzPA1bA/rkmGQ+XM7V1S8EeBu5WytltQDfTz5kGcHYsx9rW9I?=
 =?us-ascii?Q?gZOR71ISi+/wNJd5C9CEgt63xXi33wSJG0GvIGtbXo76LGh6AjgiuLhZK/xl?=
 =?us-ascii?Q?t+IDTi2Gqid2GkA6IEnuWqCXHri59vQqlvJOeZeT/3+RaBCTLiztP5MrR2wT?=
 =?us-ascii?Q?1MXcI7SLeyvAl/1g2+kuFMBZYytvkatVgdGYncBPWCA9TYxIIPmuv/BiwCIQ?=
 =?us-ascii?Q?FFM4+6uEjYoYbxdTktvcZt4BrLaYan2Esqdy896G8UpDUW9RCCkU5LTa/5Oo?=
 =?us-ascii?Q?PNS2RwCYsruiM6obq7/+tIbT0l65keMFZxX05Hyv97adQTCChj3MlAQ1itnp?=
 =?us-ascii?Q?yv1QTDzEe4w3A+SaTesC6hM/BMpdQf394ihDoHM085Adarp3MQdY2IwpPxFC?=
 =?us-ascii?Q?ik25HzBPpobgsyR7jDGrCTEHqL46m7nUvSeJF6X48HDC392AKGJqfX7lTe9y?=
 =?us-ascii?Q?wQTKtD9MiUkEuGQfFxtqiMMf3DGAs51GlEUMlgCYAl+YICsWNXcwilJQeKoD?=
 =?us-ascii?Q?Cu5JSFQ8bnB2I8ne5hUyhbRmXV9XpxYDbotj8tp7SiyebKsyG6UpU0GrTxfh?=
 =?us-ascii?Q?JxRCYVH1uFfUsHKilusg6RZ/VOFicoVGTl5p/kXMy9d5L4Nx4MNuvDd6Rygd?=
 =?us-ascii?Q?Wtl+qOofK+5HhFJrAF6wHLHobOTatnC7CIjeIxksP28/i2B1QnrltvRDm/8W?=
 =?us-ascii?Q?EIUCbjif0Rnv2YNe5/bT0rlWDBG+KcnJS5zWLBZ0zWXmadvvL+F1WY+AFUIE?=
 =?us-ascii?Q?Xp4m2OKEVc6Ujw/TTNnbjbOAahdCazpiBICShIbrt4OXkrUkfLXVBzONl363?=
 =?us-ascii?Q?Jv8ObDwhgFBUyqcn0kUqTPTS7w9allP2QeduHQLlYVk0vr//iQ2hEmyAApq2?=
 =?us-ascii?Q?WZQGXGXSL05MfU66Fc3AlM+2mtdews1ANrPNht+3A53wLi2wxoo8zcKH0Dnw?=
 =?us-ascii?Q?L4OX19PALgteUHgXDTsv55FpkTrfG/Em+SLMRHI/yuI9y+Xjp8chSLO+xrRP?=
 =?us-ascii?Q?U75t1av1WNOgNesSJ5kq6ZL1nq1JdIQZKaARWbbc2iSLwBngahoIKuX6G/5I?=
 =?us-ascii?Q?RIAMyMoPzrupun+YuVb2R0cB7XHRM4J6fS8lJyvBDlqFtJlWk7eNmNVervdV?=
 =?us-ascii?Q?XR29pDK9M/mPGHcgAlyssz6P8PDFzkHilF18lmCPRQ+mRsgzuKn/LeUEOgJs?=
 =?us-ascii?Q?F87PkPKstGMwjhCiSU60sGJUOLo//vVpy/kv5A5nQDfE7g=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ef0fc9-d327-47b4-7319-08d8f5134d36
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:37:32.5300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGQ7wyTPBiJqL4eLEYeSEK93b6PSa8h9/llKbJhfZAOYcOpdJMajqsT66LcdOK44Q2ebpZuslm1Qj88NBHZqLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528
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
index 7541018314a4..8612d8b35322 100644
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
@@ -179,6 +192,11 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
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
@@ -187,6 +205,12 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
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
index 54991cc55c00..b32f60edf48c 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,6 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
 kvm-objs := $(common-objs-y)
 
-kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 47926f0c175d..49a4941e3838 100644
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
index bf42afad9d9d..dcb2014cb2fc 100644
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
index 000000000000..2c6253b293bc
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
+#include <asm/csr.h>
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

