Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376D7199455
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbgCaKyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 06:54:12 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22753 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731032AbgCaKyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585652050; x=1617188050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=hCV9cdc6Fp3NqQWL8aKVi01/VI6R+pVpC+IF2Y9q/OI=;
  b=MtP+hOqfXDe8KnSqU6Z85Khpzr7BAKlXypLgBNG7mIj1SSt8cSuJB5iy
   sHUz8nviWJpWGI4aXkydWNbweq9JehpxfAbMPC1lpaNkMee4/lMaGJ1G4
   M1tTHMJRU2eIWQqWz9EeBEUOoZ89qE87A/BvdZCezlbx55T+lCqqkJW1K
   jUtnnU11r6BJTWW0zMedR0XSpW1ATKy4vUZXZ5VkS0ndhxlMFmmPtIRTd
   JAjDBgfm+I8jekLFxg+cwqVCjLYKd68VylXmbiBwMVlJmXNnJAXWB9smm
   aib2tg+DEzc5YADgwY9KCGtWccJcwvQv5GVHEAYBEOwM/ZTHlH5utpdHP
   g==;
IronPort-SDR: Dy6l8dC4BdEMxcguyn79jkIG0fkZeC96jrZ0Ft3Q+SJh6DyUbSBMykeQ3wRJpFJn9lgplASaVY
 5uctOcE7CaFiVn74xidFeXf1F6rSAvQ5NMFcSwHSc3kRU7VgJU7j8wm9bNyLH5Rkiy1tyxwwkl
 u8JmJVMjR58WUrFUMKFugvyMTWxUg1Aghi5pyVr45kXkqfNWOzJtiAwMynj0CN+SBLjxuIGoS6
 EJqUQT2EZ8fPRloveRGO+eVvTOC583xfuOLaAfdabu/arNIOmwgXe8F2ce1ZwCTnCaMEejMzfK
 KWc=
X-IronPort-AV: E=Sophos;i="5.72,327,1580745600"; 
   d="scan'208";a="242563784"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2020 18:54:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhvzdeYktTBRUX9Eghf0JUjbL1M/vezV7XndnJZt56A5E6N/YNVPyGEsxRN4dfrcmhg3HfHsu2zS3VbR4FOU6dSzE+IxXque/KgFK7z2Jp8HgUSiEPmjfFC9FWGFcWkjICGZ3oH0Uh/wizZ9R8v0OV+GJ2MigiqiNr2ohD0U7y6zXSWW7IszJCJGv/5M1W71pJcnL8CEcS3uVdP5VtGi9XFgsYcM3bOJv3313pMAhDc8A8Wv4wZF2Jtx2/mBMdEbpTvP9FQCZLVYb6P99sXbBnuINcYAso9e8lc9DQWrZSqR5WH5Mq+EuVgxf6XAqh0+To2diWVEQVSHwKspS94E1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3GwJpWVBw/WimHmjjjeXlHbjuEa7ggS6BIIQQtF8oo=;
 b=R3f/q7bjgUciaI4UyZIxKS2AfqDvPnj7hsu07wxApJzYh5APVE0O6sMub6HZJPaKggBnVzEvbmIYQqDIDEUHGF+JTmJCVYq1FUaBmFM0vcUc46PPS3jfjf6WaRGUScOXASxYxwsJJh0jVFWPE+UDA0FXytHnuIoOGYjzHi/ZTUfhrIFOpqMddDw5OXicmNLL59MkBsqPEBlLbM634ajYz4d6ZJgoIsUPQKLMyE6jIWjzl+kVD959q6uzTl/EMcFYgib42+EwM4Ftayd51YpYHFmHzPYiE2QGrX/8iXrEiR5V9gcv540jbt7EOIFBgsYORH64mmUqXWVY+KjQVgFKOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3GwJpWVBw/WimHmjjjeXlHbjuEa7ggS6BIIQQtF8oo=;
 b=ZfBoQhooT7cE/IID4nZ6wLhR07NndUpU7swmAesChH96aM0jwdVAmKbRW+FwT3+uVdHD3qZRmnJR8sMYlU56xfYw5WIoE6PEhPbESk+h/r5X6V+2+Xh1ihbbaYYZeQPU1wrigscd6zhLTE1ouD+iuxVOnUU3ZAgVjrEhqkr28YM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB7088.namprd04.prod.outlook.com (2603:10b6:208:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 10:54:08 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 10:54:08 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v3 1/8] update_headers: Sync-up ABI headers with Linux-5.6-rc5
Date:   Tue, 31 Mar 2020 16:23:26 +0530
Message-Id: <20200331105333.52296-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331105333.52296-1-anup.patel@wdc.com>
References: <20200331105333.52296-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.117) by BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 10:54:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [49.207.59.117]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 526ba48e-811a-4d71-0cca-08d7d561d687
X-MS-TrafficTypeDiagnostic: MN2PR04MB7088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB7088547C09C7A2FE34A2AE118DC80@MN2PR04MB7088.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6061.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(8886007)(1006002)(6666004)(2906002)(478600001)(316002)(7696005)(52116002)(36756003)(6916009)(54906003)(16526019)(81156014)(8676002)(186003)(2616005)(81166006)(1076003)(8936002)(55016002)(44832011)(5660300002)(956004)(66946007)(66556008)(86362001)(26005)(4326008)(66476007)(55236004);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uk7rUDHul7yLGBXCWFvNo8PkAo9iRwifCEYKqq//MlVKbl9mdecR/agzjCPrqf9LJQjgWBcheu84xSSK0BAVLHTCuDglSC6YIICXcaVs70X3rZx5VRsWMEDYcYMfC1hgsGlC54zyjRW6b/nMoUA0dXeidwavOTGjhsveNfgtT/vv2llfBQTDYKLqFV27zRL5cStVkVpghRX3H7m2wYrF0P6U2XVr6nvqiZzCLafgQGwHbi39OETQ3j9rPPh3nbMbYodDbUqOZRs4o4Jetn+yFUb7lz1/OhbmrIcWc1Gqm8/Siq85KibbzPe57FXcam7Gze+IU/KB0rr1bcB+jTvNEuNgRLeqQxkwcyV0ezGAwpRzLzADC39jmkwjdNrNPIAcXQbFjwn52WFJ58hDRYVTTjp6GvHs3OKoFoVjHxlmvkb5KlzREnm8kwj/jdYEzvc1
X-MS-Exchange-AntiSpam-MessageData: d1vjy7PCloNaVyxx+eTVpxyhznSB9m77+WDupFbaUBH3A2gci/kcD0IlNmtM7h/vmmmEcS2bVHK8tTGUES+PHaYyGao1d+JjN5HLECaxd25/hMgkc1b8NXtlDV3L4hYHUXVZ/Wp+dQ10gKBCQ/0RQw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526ba48e-811a-4d71-0cca-08d7d561d687
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 10:54:08.7461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7T9Hb6Y3YVyIYCasKbC0/xALguS4uWk5qt5aSdLfj19y0uY2+3mFsHZ/wbqV5BDKERilzyvZOtWKqcwGVvE+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We sync-up all ABI headers with Linux-5.6-rc5. This will allow
us to use ONE_REG interface for KVMTOOL RISC-V port.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arm/aarch32/include/asm/kvm.h |  7 +++++--
 arm/aarch64/include/asm/kvm.h | 21 +++++++++++++++++----
 include/linux/kvm.h           | 30 ++++++++++++++++++++++++++++++
 powerpc/include/asm/kvm.h     |  3 +++
 x86/include/asm/kvm.h         |  1 +
 5 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
index a4217c1..03cd7c1 100644
--- a/arm/aarch32/include/asm/kvm.h
+++ b/arm/aarch32/include/asm/kvm.h
@@ -131,8 +131,9 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
@@ -266,8 +267,10 @@ struct kvm_vcpu_events {
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* KVM_IRQ_LINE irq field index values */
+#define KVM_ARM_IRQ_VCPU2_SHIFT		28
+#define KVM_ARM_IRQ_VCPU2_MASK		0xf
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
 #define KVM_ARM_IRQ_VCPU_SHIFT		16
 #define KVM_ARM_IRQ_VCPU_MASK		0xff
 #define KVM_ARM_IRQ_NUM_SHIFT		0
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 9a50771..ba85bb2 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -164,8 +164,9 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
@@ -219,10 +220,18 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_PTIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 2, 2)
 #define KVM_REG_ARM_PTIMER_CNT		ARM64_SYS_REG(3, 3, 14, 0, 1)
 
-/* EL0 Virtual Timer Registers */
+/*
+ * EL0 Virtual Timer Registers
+ *
+ * WARNING:
+ *      KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT are not defined
+ *      with the appropriate register encodings.  Their values have been
+ *      accidentally swapped.  As this is set API, the definitions here
+ *      must be used, rather than ones derived from the encodings.
+ */
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
-#define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
+#define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 
 /* KVM-as-firmware specific pseudo-registers */
 #define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
@@ -323,10 +332,14 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define KVM_ARM_VCPU_PVTIME_CTRL	2
+#define   KVM_ARM_VCPU_PVTIME_IPA	0
 
 /* KVM_IRQ_LINE irq field index values */
+#define KVM_ARM_IRQ_VCPU2_SHIFT		28
+#define KVM_ARM_IRQ_VCPU2_MASK		0xf
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
 #define KVM_ARM_IRQ_VCPU_SHIFT		16
 #define KVM_ARM_IRQ_VCPU_MASK		0xff
 #define KVM_ARM_IRQ_NUM_SHIFT		0
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5e3f12d..2a8d582 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -235,6 +235,8 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_RISCV_SBI        28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -243,6 +245,8 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -392,6 +396,18 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
+		/* KVM_EXIT_ARM_NISV */
+		struct {
+			__u64 esr_iss;
+			__u64 fault_ipa;
+		} arm_nisv;
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -996,6 +1012,12 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
+#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
+#define KVM_CAP_ARM_NISV_TO_USER 177
+#define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_S390_VCPU_RESETS 179
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1142,6 +1164,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1222,6 +1245,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1332,6 +1357,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
+#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1456,6 +1482,10 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with  KVM_CAP_S390_VCPU_RESETS */
+#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
+#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index b0f72de..264e266 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -667,6 +667,8 @@ struct kvm_ppc_cpu_char {
 
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
+#define KVM_DEV_XICS_GRP_CTRL		2
+#define   KVM_DEV_XICS_NR_SERVERS	1
 
 /* Layout of 64-bit source attribute values */
 #define  KVM_XICS_DESTINATION_SHIFT	0
@@ -683,6 +685,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_DEV_XIVE_GRP_CTRL		1
 #define   KVM_DEV_XIVE_RESET		1
 #define   KVM_DEV_XIVE_EQ_SYNC		2
+#define   KVM_DEV_XIVE_NR_SERVERS	3
 #define KVM_DEV_XIVE_GRP_SOURCE		2	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_SOURCE_CONFIG	3	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_EQ_CONFIG	4	/* 64-bit EQ identifier */
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 503d3f4..3f3f780 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -390,6 +390,7 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
+#define KVM_STATE_NESTED_MTF_PENDING	0x00000008
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
-- 
2.17.1

