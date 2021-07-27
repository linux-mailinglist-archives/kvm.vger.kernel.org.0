Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013953D6E82
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhG0F7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:59:09 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34235 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbhG0F67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:58:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365540; x=1658901540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3T6BIqdImJLD+Gl72oXE1+Pj/lwAn13yBvzYhqfwkCo=;
  b=KXNyV8zMMHskcGuc3/VDm8MATNC5BBJyIMzqWI2YOoC+mbUi/7G1IEcX
   ttXYCSl8V4q54GUZ2w11UxYfA3HHMAadac7pMwQ34/iVYbycGh5c13PiB
   B2NecOV9nmnxT2QpHF1jEtS0DPbRu8utisTCNFOfwEomsBM92IhYzVfA2
   92FwJfd6KhojS8tPz1e9JqXiSIx31XVpMhm6L27dR5mEonhPDrki5+JS6
   DbhvP8O5BYLCDl0nbjtJEE63GdiYbiGejmmLKoybTSzuwKFbThlE2us0k
   xi7s+o4KNezMnfZsq4wiVonA+Le/ZBS4+Ph7c3gKH9z31lzU6MnJxmbko
   A==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="176146297"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:58:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VahcgVKCdSqs6Wl5aOGbTZxPpY7UNn53eghkEcBe4UVhMKmc+S4pWmHwX28/bamVnOsVytuTB0Iep0hsQhPFU8fVMWS+ARD1h4rhGxifosVoIntih910RBsPQZl11osrjLF6XYe6rY9e81Vq/sr2zjHWdXOobi42T6RQnJScTybTA+K6hdUH18QC+e6NrjuKd73M/0c0K+YttBgxfvV9wKMOkU2DkvEwchwIV45PxpfpQIWoj2v/dH/HTv0kOUGU/XHHPSbYNiksmOD632SMmN2JjNn0WLBseEyOqFVSofsloWPjhd5wQb8myipjqXcgJa1mK710TKNSThvvm9wv7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdWLYIEa3vTLGVwznRA3UCDWXdY/a5tQZfNkH/yDtjI=;
 b=oSomYJ4V7O68YR2i0kkjPPD0nj6v6BP14TPc+Lggqwy3194ZF0pt54yIs6FD3DADOdaMvYArHQ9M92R6aG/vzvJsmC1MeoGZKkPvQfI0YSX3Va6evFYU0QKPqmoJS9UbXU50gwoM0IPjdHuZc43L00kuenP7CjV+hfBYynlG5dXM7za+qypoO7rOv2pEmT4IwRk9cQOD4HON5RlmJIoVATg61aVX7ck8DMGMngVTZ9pVDjgUF8tz3EckHlYYhOJtuETb7vuMn/jBMIjKBC8vCbDB56w4XnSrnKyz8u1AAej5XMQ8ZSfdedhWDP9rzfgsNvikMzY3X8Au1Ml6M2Akfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdWLYIEa3vTLGVwznRA3UCDWXdY/a5tQZfNkH/yDtjI=;
 b=yY7PWmQp/0MGGZRJ2NNSfbw2lx7UYfQJ0n7liwDMa10OeY5jXxcxf56uNKOnXd1pg4yBR17cIBhf54oAwIMQTXzLjCyNURJWQI9420gdJvpXfxnHRrFbtXmWA0XfaKw/q+MF0zwJTpNzaO2Y6Lew9zfWmL3XPi+nUy/IwUjv2VI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8267.namprd04.prod.outlook.com (2603:10b6:303:152::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 05:58:55 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:58:55 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v8 1/8] update_headers: Sync-up ABI headers with Linux-5.14-rc3
Date:   Tue, 27 Jul 2021 11:28:18 +0530
Message-Id: <20210727055825.2742954-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055825.2742954-1-anup.patel@wdc.com>
References: <20210727055825.2742954-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::12) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 05:58:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20ba125c-8c9a-4f04-0f49-08d950c39e2a
X-MS-TrafficTypeDiagnostic: CO1PR04MB8267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB82675CF39D58FEB5EAF879CA8DE99@CO1PR04MB8267.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBpMwAUAadDmqKiNtlIioOymfH9SGj2PIWsZQoSGbUsQXqHU5ilds0MV40PPM55PUh0E+dL9sLypo8UbHL3vtWmVHNPHQM44CoUv4E3cAyb6lH006jJxzKUzIoth52bcW+hGsyMeBe5hrDXfFi1+FX3otDw/VC4Gg6lU43IOXs8M85k9aRYg7+zJsjRoW895AoTaT2r7v8F362us7OpRg9xhvFbAk/eX2bFs3cczbaZGJK9Iq8b91UBadIj6RpeQHirae4SRYcdngIW05aR3jaQnHeLmYd4teiHuzmn6yRCSIfP+yc0HNkf1TOz66ZnFyYWJJ1WNXEWJvg60C7unmtG5ntSz9ZOHRAPdBnX8ihTiXnjmDCymKZ0KJ6SltTbTirHniQX8fCFvJpP8VxjEmSmpuECpHgXuH2Zumu0n/Y8CI6hGHwcbbZ1LYMyfonYgGfubf3nWdFO4j/ucMugtxnacAqiYKpgj0Lv8c4momgmF8p8xd3GYkanynX7lLeleZKrfGJLybywahWNOBkki14kGH1kX2BIKPfTUm+9qU+ouvFI60lVUVFXzLHJUTMVxKyBUjaNoyuaWyhoQ7/SYaM851p3mabdGxBlKmfc8pLWGM84G3esMjdlBO7f88Ogsq/TeiGfV3TMiAspzFQG4Qq2jh7oBpavGQ6LXU7bF1FB16BiqMdT5fQrg4g2Pt3YTI8Gv8B+cugKJthqUI5rwqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(5660300002)(36756003)(6916009)(54906003)(8676002)(83380400001)(8886007)(55016002)(316002)(956004)(2616005)(66556008)(4326008)(66946007)(66476007)(86362001)(38100700002)(38350700002)(30864003)(7696005)(52116002)(2906002)(478600001)(44832011)(26005)(6666004)(1076003)(8936002)(186003)(15650500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6y5nTMudDOKN2PcvzD5TTOl75l7SAVxgwzLdrIfWA8rkWxXUKNDvlXijKi+?=
 =?us-ascii?Q?JTrSFJ2kuOW6dqRh1Y5egLe4nzgSkbwNUcPhBSeKPWlTDCkirkdfw1GKUbjQ?=
 =?us-ascii?Q?pg/t3rL20Svt3uuRtaCGzAG6rLLLoMfiorCY2FIQEBUGG/tfj0LoGBqppmPO?=
 =?us-ascii?Q?67INYTaykt+b//MFIdZP/qoQndQtjNo5gicXshRGK7LQUjWm0J8JCfyOUs/3?=
 =?us-ascii?Q?MwSxrxobFccfT7OO7T8AHBmUJce2kU3W3npRM578owvukBchhy8amwYwj0Ft?=
 =?us-ascii?Q?zMsbk04yuInFyLAGl+a+C/rfnN8lKYD0ew+BtiUATHKr34Y/G0bbli0ym0nW?=
 =?us-ascii?Q?r45mPtZrDNGIljpGnFI4g9mVvJNDmSDBgGmQP3o1aDtaoo3p6o1VrdfBkS+I?=
 =?us-ascii?Q?N2xDkEZKf1HMIFwudA/wYVWGzKUFDP/v0wCq4d2gE6i3Li8Eg/spvlHazBJD?=
 =?us-ascii?Q?rnf8QiVW8QJbl6L5X2iuvUh92etP8qCGU7BfSJAne4Cpa1ZT1wv3Xe09o4Cm?=
 =?us-ascii?Q?WY7n88mNKEP78PWdAmujmh/91NX/TpWxB2phnc5lJ0e3mD9nGNV/Z8fmD/FB?=
 =?us-ascii?Q?V3O7iH5+zEf13+jE9J+lMl5GvWGiv9vP2Q+totz1asEh0EbAmu/3MNT6s33G?=
 =?us-ascii?Q?RgjAXYlkO2NXtbudU5ZpqpiuSXWpBKBimDy/va9z1+W5iS7BDiZ9qkyFjZT7?=
 =?us-ascii?Q?ZlGrD5J4G2WhJT4XIbf7Ls2SND3SeCZP3NYchS2h52f62FPUQlc4VOHdbJnu?=
 =?us-ascii?Q?LpxC+c13h5mO3u9rYr4XMWFqK7l6G/SXO1A3AJB0DzGVjraIfEwHEx9JwsAb?=
 =?us-ascii?Q?pBDeMGUDpGFM86JsFw8nD7SXNgE95vfGBdPXufdckbFHvRQWuVNM8M35oiqL?=
 =?us-ascii?Q?oLsJBHRgVmcKjvPgbX+YVZeafxnuXjc/Vppqu9AXGStc0qttTkPx8C73GWHp?=
 =?us-ascii?Q?ovq7kLATj/fHXe25VbyBTI1jmEBwAZGE4sr5skWBLctepFMlZcHCDbV6XTtI?=
 =?us-ascii?Q?lxHu9fjqVkgBp6/gNIIjQGXPJb/jQU+vMfnQu77x91yL/WboqhDBM32xcXI/?=
 =?us-ascii?Q?IukHlfI39xreeDwl4XDx3Ja23jDDtmUGLtH+4JVKftxebQSoSziiPl3tJrOY?=
 =?us-ascii?Q?vrDeoU1W83ej3+eF492EbUQ2fZwG6U4p8Be04Z421FOLnvTMX6SytBZI4NP6?=
 =?us-ascii?Q?v4cJsXcJVPnro2aWl3EVVYQKjHLGkiFPjax5GruqXdfuT0bQNjc5JXM2TJ+5?=
 =?us-ascii?Q?jo5bpvt+3ThWeyyHBU3ud6Ucr0U9hIiukpfnkw3h52Vtco6sP+c6aQCXW3tg?=
 =?us-ascii?Q?od1saWuoMdovZrFw5G3JHBAB?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ba125c-8c9a-4f04-0f49-08d950c39e2a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:58:55.5392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hrwgQ3bxTEshJ4ddQdLhm9K3bXmzyh6qYOxSr4VVLqamO2T1MbHgWYyYMJ2FiF6IVFSJglnveTVKffPAgHmng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We sync-up all ABI headers with Linux-5.14-rc3 so that RISC-V
specfic changes in include/linux/kvm.h are available.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arm/aarch64/include/asm/kvm.h |  56 ++++-
 include/linux/kvm.h           | 420 +++++++++++++++++++++++++++++++++-
 powerpc/include/asm/kvm.h     |  10 +
 x86/include/asm/kvm.h         |  59 ++++-
 4 files changed, 532 insertions(+), 13 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 9a50771..b3edde6 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -156,7 +156,19 @@ struct kvm_sync_regs {
 	__u64 device_irq_level;
 };
 
-struct kvm_arch_memory_slot {
+/*
+ * PMU filter structure. Describe a range of events with a particular
+ * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
+ */
+struct kvm_pmu_event_filter {
+	__u16	base_event;
+	__u16	nevents;
+
+#define KVM_PMU_EVENT_ALLOW	0
+#define KVM_PMU_EVENT_DENY	1
+
+	__u8	action;
+	__u8	pad[3];
 };
 
 /* for KVM_GET/SET_VCPU_EVENTS */
@@ -164,13 +176,25 @@ struct kvm_vcpu_events {
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
 };
 
+struct kvm_arm_copy_mte_tags {
+	__u64 guest_ipa;
+	__u64 length;
+	void __user *addr;
+	__u64 flags;
+	__u64 reserved[2];
+};
+
+#define KVM_ARM_TAGS_TO_GUEST		0
+#define KVM_ARM_TAGS_FROM_GUEST		1
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
@@ -219,10 +243,18 @@ struct kvm_vcpu_events {
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
@@ -233,6 +265,15 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL		0
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL		1
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED	2
+
+/*
+ * Only two states can be presented by the host kernel:
+ * - NOT_REQUIRED: the guest doesn't need to do anything
+ * - NOT_AVAIL: the guest isn't mitigated (it can still use SSBS if available)
+ *
+ * All the other values are deprecated. The host still accepts all
+ * values (they are ABI), but will narrow them to the above two.
+ */
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL		0
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN		1
@@ -320,13 +361,18 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
+#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
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
index 5e3f12d..8b0f50c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -8,6 +8,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
@@ -116,7 +117,7 @@ struct kvm_irq_level {
 	 * ACPI gsi notion of irq.
 	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
 	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
-	 * For ARM: See Documentation/virt/kvm/api.txt
+	 * For ARM: See Documentation/virt/kvm/api.rst
 	 */
 	union {
 		__u32 irq;
@@ -188,10 +189,13 @@ struct kvm_s390_cmma_log {
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
+#define KVM_EXIT_HYPERV_SYNDBG         3
 	__u32 type;
+	__u32 pad1;
 	union {
 		struct {
 			__u32 msr;
+			__u32 pad2;
 			__u64 control;
 			__u64 evt_page;
 			__u64 msg_page;
@@ -201,6 +205,29 @@ struct kvm_hyperv_exit {
 			__u64 result;
 			__u64 params[2];
 		} hcall;
+		struct {
+			__u32 msr;
+			__u32 pad2;
+			__u64 control;
+			__u64 status;
+			__u64 send_page;
+			__u64 recv_page;
+			__u64 pending_page;
+		} syndbg;
+	} u;
+};
+
+struct kvm_xen_exit {
+#define KVM_EXIT_XEN_HCALL          1
+	__u32 type;
+	union {
+		struct {
+			__u32 longmode;
+			__u32 cpl;
+			__u64 input;
+			__u64 result;
+			__u64 params[6];
+		} hcall;
 	} u;
 };
 
@@ -235,6 +262,14 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_X86_RDMSR        29
+#define KVM_EXIT_X86_WRMSR        30
+#define KVM_EXIT_DIRTY_RING_FULL  31
+#define KVM_EXIT_AP_RESET_HOLD    32
+#define KVM_EXIT_X86_BUS_LOCK     33
+#define KVM_EXIT_XEN              34
+#define KVM_EXIT_RISCV_SBI        35
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -243,6 +278,11 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
+
+/* Flags that describe what fields in emulation_failure hold valid data. */
+#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -274,6 +314,7 @@ struct kvm_run {
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu;
 		} fail_entry;
 		/* KVM_EXIT_EXCEPTION */
 		struct {
@@ -346,6 +387,25 @@ struct kvm_run {
 			__u32 ndata;
 			__u64 data[16];
 		} internal;
+		/*
+		 * KVM_INTERNAL_ERROR_EMULATION
+		 *
+		 * "struct emulation_failure" is an overlay of "struct internal"
+		 * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
+		 * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
+		 * sub-types, this struct is ABI!  It also needs to be backwards
+		 * compatible with "struct internal".  Take special care that
+		 * "ndata" is correct, that new fields are enumerated in "flags",
+		 * and that each flag enumerates fields that are 64-bit aligned
+		 * and sized (so that ndata+internal.data[] is valid/accurate).
+		 */
+		struct {
+			__u32 suberror;
+			__u32 ndata;
+			__u64 flags;
+			__u8  insn_size;
+			__u8  insn_bytes[15];
+		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
 			__u64 gprs[32];
@@ -392,6 +452,31 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
+		/* KVM_EXIT_ARM_NISV */
+		struct {
+			__u64 esr_iss;
+			__u64 fault_ipa;
+		} arm_nisv;
+		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
+		struct {
+			__u8 error; /* user -> kernel */
+			__u8 pad[7];
+#define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
+#define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
+#define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
+			__u32 reason; /* kernel -> user */
+			__u32 index; /* kernel -> user */
+			__u64 data; /* kernel <-> user */
+		} msr;
+		/* KVM_EXIT_XEN */
+		struct kvm_xen_exit xen;
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
@@ -466,12 +551,17 @@ struct kvm_s390_mem_op {
 	__u32 size;		/* amount of bytes */
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
-	__u8 ar;		/* the access register number */
-	__u8 reserved[31];	/* should be set to 0 */
+	union {
+		__u8 ar;	/* the access register number */
+		__u32 sida_offset; /* offset into the sida */
+		__u8 reserved[32]; /* should be set to 0 */
+	};
 };
 /* types for kvm_s390_mem_op->op */
 #define KVM_S390_MEMOP_LOGICAL_READ	0
 #define KVM_S390_MEMOP_LOGICAL_WRITE	1
+#define KVM_S390_MEMOP_SIDA_READ	2
+#define KVM_S390_MEMOP_SIDA_WRITE	3
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
@@ -533,6 +623,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_CHECK_STOP        6
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
+#define KVM_MP_STATE_AP_RESET_HOLD     9
 
 struct kvm_mp_state {
 	__u32 mp_state;
@@ -764,9 +855,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2
 
-/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
-#define KVM_VM_MIPS_TE		0
+/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
+#define KVM_VM_MIPS_AUTO	0
 #define KVM_VM_MIPS_VZ		1
+#define KVM_VM_MIPS_TE		2
 
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
@@ -996,6 +1088,38 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
+#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
+#define KVM_CAP_ARM_NISV_TO_USER 177
+#define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_S390_PROTECTED 180
+#define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_HALT_POLL 182
+#define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_LAST_CPU 184
+#define KVM_CAP_SMALLER_MAXPHYADDR 185
+#define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_STEAL_TIME 187
+#define KVM_CAP_X86_USER_SPACE_MSR 188
+#define KVM_CAP_X86_MSR_FILTER 189
+#define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
+#define KVM_CAP_SYS_HYPERV_CPUID 191
+#define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_X86_BUS_LOCK_EXIT 193
+#define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_SET_GUEST_DEBUG2 195
+#define KVM_CAP_SGX_ATTRIBUTE 196
+#define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
+#define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_HYPERV_ENFORCE_CPUID 199
+#define KVM_CAP_SREGS2 200
+#define KVM_CAP_EXIT_HYPERCALL 201
+#define KVM_CAP_PPC_RPT_INVALIDATE 202
+#define KVM_CAP_BINARY_STATS_FD 203
+#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
+#define KVM_CAP_ARM_MTE 205
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1069,6 +1193,11 @@ struct kvm_x86_mce {
 #endif
 
 #ifdef KVM_CAP_XEN_HVM
+#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
@@ -1086,7 +1215,7 @@ struct kvm_xen_hvm_config {
  *
  * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
  * the irqfd to operate in resampling mode for level triggered interrupt
- * emulation.  See Documentation/virt/kvm/api.txt.
+ * emulation.  See Documentation/virt/kvm/api.rst.
  */
 #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
 
@@ -1142,6 +1271,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1222,6 +1352,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1332,6 +1464,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
+#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
+#define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1450,12 +1584,109 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
 #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
 
-/* Available with KVM_CAP_HYPERV_CPUID */
+/* Available with KVM_CAP_HYPERV_CPUID (vcpu) / KVM_CAP_SYS_HYPERV_CPUID (system) */
 #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
 
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with  KVM_CAP_S390_VCPU_RESETS */
+#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
+#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
+
+struct kvm_s390_pv_sec_parm {
+	__u64 origin;
+	__u64 length;
+};
+
+struct kvm_s390_pv_unp {
+	__u64 addr;
+	__u64 size;
+	__u64 tweak;
+};
+
+enum pv_cmd_id {
+	KVM_PV_ENABLE,
+	KVM_PV_DISABLE,
+	KVM_PV_SET_SEC_PARMS,
+	KVM_PV_UNPACK,
+	KVM_PV_VERIFY,
+	KVM_PV_PREP_RESET,
+	KVM_PV_UNSHARE_ALL,
+};
+
+struct kvm_pv_cmd {
+	__u32 cmd;	/* Command to be executed */
+	__u16 rc;	/* Ultravisor return code */
+	__u16 rrc;	/* Ultravisor return reason code */
+	__u64 data;	/* Data or address */
+	__u32 flags;    /* flags for future extensions. Must be 0 for now */
+	__u32 reserved[3];
+};
+
+/* Available with KVM_CAP_S390_PROTECTED */
+#define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
+
+/* Available with KVM_CAP_X86_MSR_FILTER */
+#define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
+
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
+
+/* Per-VM Xen attributes */
+#define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
+#define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u8 long_mode;
+		__u8 vector;
+		struct {
+			__u64 gfn;
+		} shared_info;
+		__u64 pad[8];
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+
+/* Per-vCPU Xen attributes */
+#define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
+#define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
+
+#define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
+#define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
+
+struct kvm_xen_vcpu_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 gpa;
+		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1484,6 +1715,10 @@ enum sev_cmd_id {
 	KVM_SEV_DBG_ENCRYPT,
 	/* Guest certificates commands */
 	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
+	/* Guest Migration Extension */
+	KVM_SEV_SEND_CANCEL,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1536,6 +1771,51 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+};
+
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_send_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
@@ -1606,4 +1886,130 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
+#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
+
+/*
+ * Arch needs to define the macro after implementing the dirty ring
+ * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
+ * starting page offset of the dirty ring structures.
+ */
+#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
+#define KVM_DIRTY_LOG_PAGE_OFFSET 0
+#endif
+
+/*
+ * KVM dirty GFN flags, defined as:
+ *
+ * |---------------+---------------+--------------|
+ * | bit 1 (reset) | bit 0 (dirty) | Status       |
+ * |---------------+---------------+--------------|
+ * |             0 |             0 | Invalid GFN  |
+ * |             0 |             1 | Dirty GFN    |
+ * |             1 |             X | GFN to reset |
+ * |---------------+---------------+--------------|
+ *
+ * Lifecycle of a dirty GFN goes like:
+ *
+ *      dirtied         harvested        reset
+ * 00 -----------> 01 -------------> 1X -------+
+ *  ^                                          |
+ *  |                                          |
+ *  +------------------------------------------+
+ *
+ * The userspace program is only responsible for the 01->1X state
+ * conversion after harvesting an entry.  Also, it must not skip any
+ * dirty bits, so that dirty bits are always harvested in sequence.
+ */
+#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
+#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
+#define KVM_DIRTY_GFN_F_MASK            0x3
+
+/*
+ * KVM dirty rings should be mapped at KVM_DIRTY_LOG_PAGE_OFFSET of
+ * per-vcpu mmaped regions as an array of struct kvm_dirty_gfn.  The
+ * size of the gfn buffer is decided by the first argument when
+ * enabling KVM_CAP_DIRTY_LOG_RING.
+ */
+struct kvm_dirty_gfn {
+	__u32 flags;
+	__u32 slot;
+	__u64 offset;
+};
+
+#define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
+#define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
+
+/**
+ * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
+ * @flags: Some extra information for header, always 0 for now.
+ * @name_size: The size in bytes of the memory which contains statistics
+ *             name string including trailing '\0'. The memory is allocated
+ *             at the send of statistics descriptor.
+ * @num_desc: The number of statistics the vm or vcpu has.
+ * @id_offset: The offset of the vm/vcpu stats' id string in the file pointed
+ *             by vm/vcpu stats fd.
+ * @desc_offset: The offset of the vm/vcpu stats' descriptor block in the file
+ *               pointd by vm/vcpu stats fd.
+ * @data_offset: The offset of the vm/vcpu stats' data block in the file
+ *               pointed by vm/vcpu stats fd.
+ *
+ * This is the header userspace needs to read from stats fd before any other
+ * readings. It is used by userspace to discover all the information about the
+ * vm/vcpu's binary statistics.
+ * Userspace reads this header from the start of the vm/vcpu's stats fd.
+ */
+struct kvm_stats_header {
+	__u32 flags;
+	__u32 name_size;
+	__u32 num_desc;
+	__u32 id_offset;
+	__u32 desc_offset;
+	__u32 data_offset;
+};
+
+#define KVM_STATS_TYPE_SHIFT		0
+#define KVM_STATS_TYPE_MASK		(0xF << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_PEAK
+
+#define KVM_STATS_UNIT_SHIFT		4
+#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_NONE		(0x0 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
+
+#define KVM_STATS_BASE_SHIFT		8
+#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
+#define KVM_STATS_BASE_POW10		(0x0 << KVM_STATS_BASE_SHIFT)
+#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
+#define KVM_STATS_BASE_MAX		KVM_STATS_BASE_POW2
+
+/**
+ * struct kvm_stats_desc - Descriptor of a KVM statistics.
+ * @flags: Annotations of the stats, like type, unit, etc.
+ * @exponent: Used together with @flags to determine the unit.
+ * @size: The number of data items for this stats.
+ *        Every data item is of type __u64.
+ * @offset: The offset of the stats to the start of stat structure in
+ *          struture kvm or kvm_vcpu.
+ * @unused: Unused field for future usage. Always 0 for now.
+ * @name: The name string for the stats. Its size is indicated by the
+ *        &kvm_stats_header->name_size.
+ */
+struct kvm_stats_desc {
+	__u32 flags;
+	__s16 exponent;
+	__u16 size;
+	__u32 offset;
+	__u32 unused;
+	char name[];
+};
+
+#define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
+
 #endif /* __LINUX_KVM_H */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index b0f72de..9f18fa0 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -640,6 +640,13 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_ONLINE	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbf)
 #define KVM_REG_PPC_PTCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc0)
 
+/* POWER10 registers */
+#define KVM_REG_PPC_MMCR3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc1)
+#define KVM_REG_PPC_SIER2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc2)
+#define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
+#define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
+#define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
+
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
  */
@@ -667,6 +674,8 @@ struct kvm_ppc_cpu_char {
 
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
+#define KVM_DEV_XICS_GRP_CTRL		2
+#define   KVM_DEV_XICS_NR_SERVERS	1
 
 /* Layout of 64-bit source attribute values */
 #define  KVM_XICS_DESTINATION_SHIFT	0
@@ -683,6 +692,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_DEV_XIVE_GRP_CTRL		1
 #define   KVM_DEV_XIVE_RESET		1
 #define   KVM_DEV_XIVE_EQ_SYNC		2
+#define   KVM_DEV_XIVE_NR_SERVERS	3
 #define KVM_DEV_XIVE_GRP_SOURCE		2	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_SOURCE_CONFIG	3	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_EQ_CONFIG	4	/* 64-bit EQ identifier */
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 503d3f4..a6c327f 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -12,6 +12,7 @@
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
@@ -111,6 +112,7 @@ struct kvm_ioapic_state {
 #define KVM_NR_IRQCHIPS          3
 
 #define KVM_RUN_X86_SMM		 (1 << 0)
+#define KVM_RUN_X86_BUS_LOCK     (1 << 1)
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
@@ -157,6 +159,19 @@ struct kvm_sregs {
 	__u64 interrupt_bitmap[(KVM_NR_INTERRUPTS + 63) / 64];
 };
 
+struct kvm_sregs2 {
+	/* out (KVM_GET_SREGS2) / in (KVM_SET_SREGS2) */
+	struct kvm_segment cs, ds, es, fs, gs, ss;
+	struct kvm_segment tr, ldt;
+	struct kvm_dtable gdt, idt;
+	__u64 cr0, cr2, cr3, cr4, cr8;
+	__u64 efer;
+	__u64 apic_base;
+	__u64 flags;
+	__u64 pdptrs[4];
+};
+#define KVM_SREGS2_FLAGS_PDPTRS_VALID 1
+
 /* for KVM_GET_FPU and KVM_SET_FPU */
 struct kvm_fpu {
 	__u8  fpr[8][16];
@@ -192,6 +207,26 @@ struct kvm_msr_list {
 	__u32 indices[0];
 };
 
+/* Maximum size of any access bitmap in bytes */
+#define KVM_MSR_FILTER_MAX_BITMAP_SIZE 0x600
+
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range {
+#define KVM_MSR_FILTER_READ  (1 << 0)
+#define KVM_MSR_FILTER_WRITE (1 << 1)
+	__u32 flags;
+	__u32 nmsrs; /* number of msrs in bitmap */
+	__u32 base;  /* MSR index the bitmap starts at */
+	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+};
+
+#define KVM_MSR_FILTER_MAX_RANGES 16
+struct kvm_msr_filter {
+#define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+	__u32 flags;
+	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
 
 struct kvm_cpuid_entry {
 	__u32 function;
@@ -385,17 +420,23 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
-#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
+#define KVM_STATE_NESTED_FORMAT_SVM	1
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
+#define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+#define KVM_STATE_NESTED_GIF_SET	0x00000100
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
 #define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
 
+#define KVM_STATE_NESTED_SVM_VMCB_SIZE	0x1000
+
+#define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -408,6 +449,20 @@ struct kvm_vmx_nested_state_hdr {
 	struct {
 		__u16 flags;
 	} smm;
+
+	__u16 pad;
+
+	__u32 flags;
+	__u64 preemption_timer_deadline;
+};
+
+struct kvm_svm_nested_state_data {
+	/* Save area only used if KVM_STATE_NESTED_RUN_PENDING.  */
+	__u8 vmcb12[KVM_STATE_NESTED_SVM_VMCB_SIZE];
+};
+
+struct kvm_svm_nested_state_hdr {
+	__u64 vmcb_pa;
 };
 
 /* for KVM_CAP_NESTED_STATE */
@@ -418,6 +473,7 @@ struct kvm_nested_state {
 
 	union {
 		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
@@ -430,6 +486,7 @@ struct kvm_nested_state {
 	 */
 	union {
 		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
 	} data;
 };
 
-- 
2.25.1

