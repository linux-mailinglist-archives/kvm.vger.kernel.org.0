Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9392AB705
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgKILdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:33:54 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:19249 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbgKILdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:33:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921630; x=1636457630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=t/J5BhuLT+5vJaoywOQClLYe0pLHLd8PHzF4nEQxl8Y=;
  b=E975gf4E3nr2dht22xgW7VJQhQiQbuac5Mar4Sg6o5S3uY5I15C8ZYIC
   nQ9CmCQG2dW7vCGfnOQWi502+Bj7FhwNlg+K4qMzhecYnrEFiRtUa0aw5
   TgsyzD/rvx3I37UFkX/NttHXKBMHW83fiOOjJeuMZY2rg9SY8yuwgSnGw
   pU4dVeYqKeeZk9ZBMz7zvvnPLPunKPNlNQk3DpoPL4vAeIIpOjLwkcaeb
   orTILDTP+lCaLBDcPICnVLxUFRxVz9CLECjbh4gRNQ4TJHjM70A58IQfN
   CumI3Rnx9FOoPRUTp32HlZG3qBoRLGPVJjRINHas2daPpa6a7cj5Bl25r
   w==;
IronPort-SDR: Vjf+4iloCKfytQi9ibOL9AYv5aCEOcOcLmEnIMj8LIQzb1W2LkKOpmmj8si1EEGWTq+6/MsHt3
 NM8VnoagqCvlpr69Y47oXyO88vCqH07lLhgR/Bhr5ztAguZAgmgJuLBoafRfM9Inzc21RvWR4p
 9yA+tDrxSxk3jDIRyb+tB7t3ODJ3ZvqJKRc02UdUGUN1/qryHdz8kojcYt1Y3sKEaMeMKYiGU1
 wVyTswQ2D9841+y85yvIoY/wq0mFaCCi0MDyunFTXxNZL+IT40l3Z4lhm5HhHzu+WocCJMtWTx
 nWY=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="152286350"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:33:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjpryUpDEI8BoD7r42dGg1Hg5SmH61ZfVxiq9hjt6QgJ3vqx5M3ZipyWzlL2O7iexk+QjVISGCMLLXc+SdF030OLaKRkMmou7pfCGKgsYQ/M1D/PkRjeiiL5/mK3tH3lIl5YULo7ID7UuvaN1pcpJn+099cmCJExdAxuxCvEOiPtcCqo7A63Rc+EaJ9N/z4y+3u7V7G0JCoQSW7lD/fyQt7oGGUM95ARmp3sve/yQ+YoU3kIyst4314fn5CffuRoaWOruE1fEQq7Fy7OzcMp8CTp1vjEHRqWX4KZ3KVkMcE1+Ydg+7jaZwDCzP95/1cFA5a2sItQOARDozP4wLXzWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pT+3ONsRZew7hKC3TTIXCxmIgYa9u06HktJCk8qmInI=;
 b=oNgkrYUyDQjUHVDbePv915OXmTkd3xWcCghOT6iatIDUzl0xBPTgSSpSB29PIiJwdAXVQxXna07bVw4rvrvXHlsfaqUvv70FZiOX7ElwVtiYolODalp/mEKG+/O07plKVP41NeAQng0jbdytdYSfmtnB6KRkmKDMrobPh8W4nELIGw+YOfUxYPWmP3K9om+th7o4ZRC8zcql7qCeACR+ylOPtFBR9oZGPh+fsZiF5MLt1n56fC51jcZX2MXZ2eR6VfZKhJ4GnMW16/Zol62vWD0T9v+o+vkVAakeAk55i/2xnDQSOm/mSVsHkJZhLZ8KcBWFPYs+7l7z7Cy+XxrZKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pT+3ONsRZew7hKC3TTIXCxmIgYa9u06HktJCk8qmInI=;
 b=HytYuhULlrlMSHCBQBJ2z+FHYk8wr+JPrqmKWvT8nn0WdxH6cCwQ/ZmwD4Cox66XMXdO76hTTES0GfRcnXWDAL/dVb2lfQ6BR7CyVP619cyiEwonizDpEX+KKPOWAfT3nxUri5o2OpTy1cntgQ64f+rK4JnYsXAzAAp4V4y5ye8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3866.namprd04.prod.outlook.com (2603:10b6:5:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:33:46 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:33:46 +0000
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
Subject: [PATCH v15 03/17] RISC-V: KVM: Implement VCPU create, init and destroy functions
Date:   Mon,  9 Nov 2020 17:02:26 +0530
Message-Id: <20201109113240.3733496-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113240.3733496-1-anup.patel@wdc.com>
References: <20201109113240.3733496-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:33:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f4814fde-b469-4ca5-b023-08d884a3521e
X-MS-TrafficTypeDiagnostic: DM6PR04MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB38662E7E97A14CCE64FF60C58DEA0@DM6PR04MB3866.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gvsv02vFJkf6OV7XxKe2m0XQUXrEDjDiGF25hMF9eXFltmb7a8gnLcXNqMdH06axww/saTaHr7P/1Hap/SoabPjxroH/AhaR1GSi97uMH5pjI04SRAUg348wXF1Mk+02403dPgm6bQBubZ7vTJrj42flBGCb0KuY2KZhfps8fGl5ItfLWCRW3a/cE1ptkI5NDqkgGFF9f4c5gIO+jKSRSN7hTwwd7EBJaJ4b8x5AQpsSMp8GV1Us5BRBi5rar/qIed5KqN/sQ3su9SEjbsxoYzG4AW1pfMkj+NgEYiexHg5PUvrjXEcRF5D/a4M/h30M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(55016002)(7416002)(83380400001)(1076003)(44832011)(16526019)(186003)(316002)(26005)(8676002)(110136005)(54906003)(5660300002)(52116002)(7696005)(956004)(2616005)(478600001)(66476007)(66556008)(4326008)(66946007)(6666004)(2906002)(36756003)(86362001)(8886007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gFjDOgIWHSgdkWh8aN8Ap/O75o6GA0UTebNdxExjRlo+9/aJDovdpPJkQ3xZC64cdMqTPfZ0EbPSXl/tk46v6Kd3XE3xHarBjtxShlRgWdrp6g7S7NTDxErHp+bxYXAAWyjUfD6zEDlanAcAshLaqO6uh+btJ5CH6yi9If5tydDtidD278yJiPWNw57rB00hZtSVwFwYkCKuk3NY+LXRJIhqfGfZ8az+7OTwBXUl6tT0Pk1JpfTBTejoZVI2nt2cK+HlHGrF68wE2eZf/m+3mlLk+OBX6+Ft0MObM2HIX12GkFIREfbvZvjO3C87ktuZHof6+pGObT6HdqIh2hmZz+KwEUhEBxyJHn12VhPOryk1l2qdd/1bb/2YDh+CnFR8BHmoNe+hDhNv0uzMZrPM+hEdg3ednzQml/Z/LJYN2UY5Uj9WHsrdcRIIV0Nz5h974Ns0/QZF83asJ6EBtcE5/rW73CW4LMleOfoP6BC5quFdstRf/b9ggWdhF5qJVQEum3USAqWUmAvsuxE6lT105MV88enFFf6dwJ/JO9gj2o/5xFEGbqX5F0zSnyVswvaQW5bW7VCbWloSy3ir5gBzDMfZu2+9l37fwzJxxdZD+9ILJrVLkdZ0iRbTon5+903nbpJu4XXxv1duJX9oAvktgA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4814fde-b469-4ca5-b023-08d884a3521e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:33:46.6902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LO/L0iRhCa3BWMVC/bdOZkqh61L3cROWm90jqFgBfpjhBdllMTtSahNQbg/LrgN3gD55DzvS8WherI7Sgir7zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3866
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements VCPU create, init and destroy functions
required by generic KVM module. We don't have much dynamic
resources in struct kvm_vcpu_arch so these functions are quite
simple for KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h | 69 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 55 ++++++++++++++++++++----
 2 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index fdd63bafb714..43e85523a07e 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -63,7 +63,76 @@ struct kvm_cpu_trap {
 	unsigned long htinst;
 };
 
+struct kvm_cpu_context {
+	unsigned long zero;
+	unsigned long ra;
+	unsigned long sp;
+	unsigned long gp;
+	unsigned long tp;
+	unsigned long t0;
+	unsigned long t1;
+	unsigned long t2;
+	unsigned long s0;
+	unsigned long s1;
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+	unsigned long a4;
+	unsigned long a5;
+	unsigned long a6;
+	unsigned long a7;
+	unsigned long s2;
+	unsigned long s3;
+	unsigned long s4;
+	unsigned long s5;
+	unsigned long s6;
+	unsigned long s7;
+	unsigned long s8;
+	unsigned long s9;
+	unsigned long s10;
+	unsigned long s11;
+	unsigned long t3;
+	unsigned long t4;
+	unsigned long t5;
+	unsigned long t6;
+	unsigned long sepc;
+	unsigned long sstatus;
+	unsigned long hstatus;
+};
+
+struct kvm_vcpu_csr {
+	unsigned long vsstatus;
+	unsigned long hie;
+	unsigned long vstvec;
+	unsigned long vsscratch;
+	unsigned long vsepc;
+	unsigned long vscause;
+	unsigned long vstval;
+	unsigned long hvip;
+	unsigned long vsatp;
+	unsigned long scounteren;
+};
+
 struct kvm_vcpu_arch {
+	/* VCPU ran atleast once */
+	bool ran_atleast_once;
+
+	/* ISA feature bits (similar to MISA) */
+	unsigned long isa;
+
+	/* CPU context of Guest VCPU */
+	struct kvm_cpu_context guest_context;
+
+	/* CPU CSR context of Guest VCPU */
+	struct kvm_vcpu_csr guest_csr;
+
+	/* CPU context upon Guest VCPU reset */
+	struct kvm_cpu_context guest_reset_context;
+
+	/* CPU CSR context upon Guest VCPU reset */
+	struct kvm_vcpu_csr guest_reset_csr;
+
 	/* Don't run the VCPU (blocked) */
 	bool pause;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8d8d140a0caf..84deeddbffbe 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -35,6 +35,27 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+#define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
+				 riscv_isa_extension_mask(c) | \
+				 riscv_isa_extension_mask(d) | \
+				 riscv_isa_extension_mask(f) | \
+				 riscv_isa_extension_mask(i) | \
+				 riscv_isa_extension_mask(m) | \
+				 riscv_isa_extension_mask(s) | \
+				 riscv_isa_extension_mask(u))
+
+static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
+
+	memcpy(csr, reset_csr, sizeof(*csr));
+
+	memcpy(cntx, reset_cntx, sizeof(*cntx));
+}
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	return 0;
@@ -42,7 +63,25 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_cpu_context *cntx;
+
+	/* Mark this VCPU never ran */
+	vcpu->arch.ran_atleast_once = false;
+
+	/* Setup ISA features available to VCPU */
+	vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
+
+	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
+	cntx = &vcpu->arch.guest_reset_context;
+	cntx->sstatus = SR_SPP | SR_SPIE;
+	cntx->hstatus = 0;
+	cntx->hstatus |= HSTATUS_VTW;
+	cntx->hstatus |= HSTATUS_SPVP;
+	cntx->hstatus |= HSTATUS_SPV;
+
+	/* Reset VCPU */
+	kvm_riscv_reset_vcpu(vcpu);
+
 	return 0;
 }
 
@@ -55,15 +94,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 }
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	/* TODO: */
-	return 0;
-}
-
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	/* Flush the pages pre-allocated for Stage2 page table mappings */
+	kvm_riscv_stage2_flush_cache(vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
@@ -209,6 +243,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_trap trap;
 	struct kvm_run *run = vcpu->run;
 
+	/* Mark this VCPU ran at least once */
+	vcpu->arch.ran_atleast_once = true;
+
 	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/* Process MMIO value returned from user-space */
@@ -282,7 +319,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * get an interrupt between __kvm_riscv_switch_to() and
 		 * local_irq_enable() which can potentially change CSRs.
 		 */
-		trap.sepc = 0;
+		trap.sepc = vcpu->arch.guest_context.sepc;
 		trap.scause = csr_read(CSR_SCAUSE);
 		trap.stval = csr_read(CSR_STVAL);
 		trap.htval = csr_read(CSR_HTVAL);
-- 
2.25.1

