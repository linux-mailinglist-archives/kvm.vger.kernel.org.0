Return-Path: <kvm+bounces-69832-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAG8BI12gGl88gIAu9opvQ
	(envelope-from <kvm+bounces-69832-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:03:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C434ACA6DF
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9FBCB301840F
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 10:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89259358D27;
	Mon,  2 Feb 2026 10:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="C0RnjXyG"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob02.noc.sony.co.jp (jpms-ob02.noc.sony.co.jp [211.125.140.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779A93563ED;
	Mon,  2 Feb 2026 10:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770026514; cv=none; b=lZuUfgNqL50Iu5TFHBaxhUJxwAeSOQhSkjB/TxQpQdDE7vS3EYRV+lHonbyL+VRHRs2eSW51wXVL5D2vTpofh9AGjP7gcSSqxBTdjdSE99K1SLbO5P2KmtLKIswblaYTk2iBJZrEbMP4bWpygXmXNvYKqWfuQbPYpRUrKVU6V2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770026514; c=relaxed/simple;
	bh=40ywH2ksTo16iKGC5c7aKcdzHSb3M0fEznHdLx5ChZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PQxxXoteCQKRyz1VoeH7w0BBJ/IA2dajzvpPtWFdY+o2wTENduCgiHbKEr6Y4Mhu9GMqteL/IbrRn2r6+v+/4LH6DpD94dXyXBIW+sdj6LIgDyj5zZ1kRc93qjy2sQLvZNjYa67bIXwaOW1iG9i8UEepulSiZD200PB1f4bduOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=C0RnjXyG; arc=none smtp.client-ip=211.125.140.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770026513; x=1801562513;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=UGbV0HlypAsqDyqCwF4KKZshjhbYqkotn40a85H3Q7U=;
  b=C0RnjXyG+jUqDIr0GpIb+DJXpv/B3+Q+C+vEk5IiGymjXOpVXZHkNqc+
   E4DSMNAduWiXf3gvNNSrY0kMTE2JWdRhIGHg1U5j5LDCYZgCWbqalWK3B
   c3ydlNRL0gxKUB5lE+OprnCvDsu1wpzJgDAOv6DrBa5rjmLHBs+dhXKhl
   qk78tvz343HMpIeH6wnJJQqQT6FSy4IqPOynnHIi+r4wcshwKDY7pHxdT
   wJOBQ/7R6X6JRxEAJctUnNtuNqwR9AtT8qKHpfp9otn3b1vpWHp4n0xkn
   v2RIDFKnsH+vWo7IBdGt1M/GCz40J/oUxOsjuxCkeT5Ew+4NE7pwbyBqC
   w==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 18:51:39 +0900
X-IronPort-AV: E=Sophos;i="6.21,268,1763391600"; 
   d="scan'208";a="607384938"
Received: from unknown (HELO [127.0.1.1]) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob1.noc.sony.co.jp with ESMTP; 02 Feb 2026 18:51:38 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
Date: Mon, 02 Feb 2026 18:51:04 +0900
Subject: [PATCH 3/3] x86/virt: rename x2apic_available to
 x2apic_without_ir_available
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260202-x2apic-fix-v1-3-71c8f488a88b@sony.com>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
In-Reply-To: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Suresh Siddha <suresh.b.siddha@intel.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Ajay Kaher <ajay.kaher@broadcom.com>, 
 Alexey Makhalov <alexey.makhalov@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev, 
 jailhouse-dev@googlegroups.com, kvm@vger.kernel.org, 
 xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>, 
 Shashank Balaji <shashank.mahadasyam@sony.com>, 
 Daniel Palmer <daniel.palmer@sony.com>, Tim Bird <tim.bird@sony.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8661;
 i=shashank.mahadasyam@sony.com; h=from:subject:message-id;
 bh=40ywH2ksTo16iKGC5c7aKcdzHSb3M0fEznHdLx5ChZY=;
 b=owGbwMvMwCU2bX1+URVTXyjjabUkhsyG4pV73BSkW2t+bFj8lP/axHMSXQ/nLg+dcOZBrWq1l
 IycyNnlHaUsDGJcDLJiiiylStW/9q4IWtJz5rUizBxWJpAhDFycAjAR/UqGn4xiaRxyy02Nn4be
 9Xesdnx9Matg+r2d2y7WH5tzzWHmuTSG/4lN6178i2r5JLaG8/tKKYYCxeYn2uGibz7WxSq6yev
 mMAAA
X-Developer-Key: i=shashank.mahadasyam@sony.com; a=openpgp;
 fpr=75227BFABDA852A48CCCEB2196AF6F727A028E55
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[31];
	TAGGED_FROM(0.00)[bounces-69832-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[sony.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sony.com:email,sony.com:dkim,sony.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C434ACA6DF
X-Rspamd-Action: no action

No functional change.

x86_init.hyper.x2apic_available is used only in try_to_enable_x2apic to check if
x2apic needs to be disabled if interrupt remapping support isn't present. But
the name x2apic_available doesn't reflect that usage.

This is what x2apic_available is set to for various hypervisors:

	acrn		boot_cpu_has(X86_FEATURE_X2APIC)
	mshyperv	boot_cpu_has(X86_FEATURE_X2APIC)
	xen		boot_cpu_has(X86_FEATURE_X2APIC) or false
	vmware		vmware_legacy_x2apic_available
	kvm		kvm_cpuid_base() != 0
	jailhouse	x2apic_enabled()
	bhyve		true
	default		false

Bare metal and vmware correctly check if x2apic is available without interrupt
remapping. The rest of them check if x2apic is enabled/supported, and kvm just
checks if the kernel is running on kvm. The other hypervisors may have to have
their checks audited.

Also fix the backwards pr_info message printed on disabling x2apic because of
lack of irq remapping support.

Compile tested with all the hypervisor guest support enabled.

Co-developed-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Shashank Balaji <shashank.mahadasyam@sony.com>
---
 arch/x86/include/asm/x86_init.h |  4 ++--
 arch/x86/kernel/apic/apic.c     |  4 ++--
 arch/x86/kernel/cpu/acrn.c      |  2 +-
 arch/x86/kernel/cpu/bhyve.c     |  2 +-
 arch/x86/kernel/cpu/mshyperv.c  |  2 +-
 arch/x86/kernel/cpu/vmware.c    |  2 +-
 arch/x86/kernel/jailhouse.c     |  2 +-
 arch/x86/kernel/kvm.c           |  2 +-
 arch/x86/kernel/x86_init.c      | 12 ++++++------
 arch/x86/xen/enlighten_hvm.c    |  4 ++--
 10 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 6c8a6ead84f6..b270d9eed755 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -116,7 +116,7 @@ struct x86_init_pci {
  * struct x86_hyper_init - x86 hypervisor init functions
  * @init_platform:		platform setup
  * @guest_late_init:		guest late init
- * @x2apic_available:		X2APIC detection
+ * @x2apic_without_ir_available: is x2apic available without irq remap?
  * @msi_ext_dest_id:		MSI supports 15-bit APIC IDs
  * @init_mem_mapping:		setup early mappings during init_mem_mapping()
  * @init_after_bootmem:		guest init after boot allocator is finished
@@ -124,7 +124,7 @@ struct x86_init_pci {
 struct x86_hyper_init {
 	void (*init_platform)(void);
 	void (*guest_late_init)(void);
-	bool (*x2apic_available)(void);
+	bool (*x2apic_without_ir_available)(void);
 	bool (*msi_ext_dest_id)(void);
 	void (*init_mem_mapping)(void);
 	void (*init_after_bootmem)(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index cc64d61f82cf..8820b631f8a2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1836,8 +1836,8 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		 * Using X2APIC without IR is not architecturally supported
 		 * on bare metal but may be supported in guests.
 		 */
-		if (!x86_init.hyper.x2apic_available()) {
-			pr_info("x2apic: IRQ remapping doesn't support X2APIC mode\n");
+		if (!x86_init.hyper.x2apic_without_ir_available()) {
+			pr_info("x2apic: Not supported without IRQ remapping\n");
 			x2apic_disable();
 			return;
 		}
diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
index 2c5b51aad91a..9204b98d4786 100644
--- a/arch/x86/kernel/cpu/acrn.c
+++ b/arch/x86/kernel/cpu/acrn.c
@@ -77,5 +77,5 @@ const __initconst struct hypervisor_x86 x86_hyper_acrn = {
 	.detect                 = acrn_detect,
 	.type			= X86_HYPER_ACRN,
 	.init.init_platform     = acrn_init_platform,
-	.init.x2apic_available  = acrn_x2apic_available,
+	.init.x2apic_without_ir_available = acrn_x2apic_available,
 };
diff --git a/arch/x86/kernel/cpu/bhyve.c b/arch/x86/kernel/cpu/bhyve.c
index f1a8ca3dd1ed..91a90a7459ce 100644
--- a/arch/x86/kernel/cpu/bhyve.c
+++ b/arch/x86/kernel/cpu/bhyve.c
@@ -61,6 +61,6 @@ const struct hypervisor_x86 x86_hyper_bhyve __refconst = {
 	.name			= "Bhyve",
 	.detect			= bhyve_detect,
 	.init.init_platform	= x86_init_noop,
-	.init.x2apic_available	= bhyve_x2apic_available,
+	.init.x2apic_without_ir_available = bhyve_x2apic_available,
 	.init.msi_ext_dest_id	= bhyve_ext_dest_id,
 };
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 579fb2c64cfd..61458855094a 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -760,7 +760,7 @@ const __initconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
 	.name			= "Microsoft Hyper-V",
 	.detect			= ms_hyperv_platform,
 	.type			= X86_HYPER_MS_HYPERV,
-	.init.x2apic_available	= ms_hyperv_x2apic_available,
+	.init.x2apic_without_ir_available = ms_hyperv_x2apic_available,
 	.init.msi_ext_dest_id	= ms_hyperv_msi_ext_dest_id,
 	.init.init_platform	= ms_hyperv_init_platform,
 	.init.guest_late_init	= ms_hyperv_late_init,
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index cb3f900c46fc..46d325818797 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -585,7 +585,7 @@ const __initconst struct hypervisor_x86 x86_hyper_vmware = {
 	.detect				= vmware_platform,
 	.type				= X86_HYPER_VMWARE,
 	.init.init_platform		= vmware_platform_setup,
-	.init.x2apic_available		= vmware_legacy_x2apic_available,
+	.init.x2apic_without_ir_available = vmware_legacy_x2apic_available,
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	.runtime.sev_es_hcall_prepare	= vmware_sev_es_hcall_prepare,
 	.runtime.sev_es_hcall_finish	= vmware_sev_es_hcall_finish,
diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
index 9e9a591a5fec..84a0bbe15989 100644
--- a/arch/x86/kernel/jailhouse.c
+++ b/arch/x86/kernel/jailhouse.c
@@ -291,6 +291,6 @@ const struct hypervisor_x86 x86_hyper_jailhouse __refconst = {
 	.name			= "Jailhouse",
 	.detect			= jailhouse_detect,
 	.init.init_platform	= jailhouse_init_platform,
-	.init.x2apic_available	= jailhouse_x2apic_available,
+	.init.x2apic_without_ir_available = jailhouse_x2apic_available,
 	.ignore_nopv		= true,
 };
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 37dc8465e0f5..709eba87d58e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1042,7 +1042,7 @@ const __initconst struct hypervisor_x86 x86_hyper_kvm = {
 	.detect				= kvm_detect,
 	.type				= X86_HYPER_KVM,
 	.init.guest_late_init		= kvm_guest_init,
-	.init.x2apic_available		= kvm_para_available,
+	.init.x2apic_without_ir_available = kvm_para_available,
 	.init.msi_ext_dest_id		= kvm_msi_ext_dest_id,
 	.init.init_platform		= kvm_init_platform,
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ebefb77c37bb..9ddf8c901ac6 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -112,12 +112,12 @@ struct x86_init_ops x86_init __initdata = {
 	},
 
 	.hyper = {
-		.init_platform		= x86_init_noop,
-		.guest_late_init	= x86_init_noop,
-		.x2apic_available	= bool_x86_init_noop,
-		.msi_ext_dest_id	= bool_x86_init_noop,
-		.init_mem_mapping	= x86_init_noop,
-		.init_after_bootmem	= x86_init_noop,
+		.init_platform			= x86_init_noop,
+		.guest_late_init		= x86_init_noop,
+		.x2apic_without_ir_available	= bool_x86_init_noop,
+		.msi_ext_dest_id		= bool_x86_init_noop,
+		.init_mem_mapping		= x86_init_noop,
+		.init_after_bootmem		= x86_init_noop,
 	},
 
 	.acpi = {
diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index fe57ff85d004..42f3d21f313d 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -311,7 +311,7 @@ static uint32_t __init xen_platform_hvm(void)
 		 * detect PVH and panic there.
 		 */
 		h->init_platform = x86_init_noop;
-		h->x2apic_available = bool_x86_init_noop;
+		h->x2apic_without_ir_available = bool_x86_init_noop;
 		h->init_mem_mapping = x86_init_noop;
 		h->init_after_bootmem = x86_init_noop;
 		h->guest_late_init = xen_hvm_guest_late_init;
@@ -325,7 +325,7 @@ struct hypervisor_x86 x86_hyper_xen_hvm __initdata = {
 	.detect                 = xen_platform_hvm,
 	.type			= X86_HYPER_XEN_HVM,
 	.init.init_platform     = xen_hvm_guest_init,
-	.init.x2apic_available  = xen_x2apic_available,
+	.init.x2apic_without_ir_available = xen_x2apic_available,
 	.init.init_mem_mapping	= xen_hvm_init_mem_mapping,
 	.init.guest_late_init	= xen_hvm_guest_late_init,
 	.init.msi_ext_dest_id   = msi_ext_dest_id,

-- 
2.43.0


