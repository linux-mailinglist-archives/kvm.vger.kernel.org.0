Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEA8351B48
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhDASHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:23 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59599 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbhDASB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300120; x=1648836120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=S5WJCfzGwc0V6vjvIjOZglMiKjc2Njw/uCB7lEDYg1o=;
  b=YSQqyQOIhIqyfr8HobQglo+o6kofvCQ+a9LqoavUAaKvJnU1G/VziGNo
   uD+UBWnC8yScGC8WLo2Ja5jhGPA5RXM5nJZcYekHirtTU6nBJHSv/SZnl
   HtFlGIOyDnDIpttGYELmr9306p/vs+56gR1Bs8m6l/NL+kcLerSDV1h4M
   tpRJ11O3BNPGYJ47AHBGx3CdrHay0r8JC13ORrBheucYZAzXAjfd5dHyV
   D2TgP6NbF9u6GSi5tX9CdVZsMU73xJe4KsRTeRhzGdMtNfVSO+Bhqag79
   uckqR5iNjFFW7nsRvqM8Rc1PoG70RE12Wg6CJhKllCNGcd1B787ftgN2z
   w==;
IronPort-SDR: QVRLNL/0SZWo70sHSAyiOppPB63irsn/jB+EMDZ33oVSMKHlpaEa8zfkRgvgYGvlJZi1yDT6Sz
 YcvC2hEZptPsgFVTWsU9Zcv/qtxSGdjtsK+1S6YmKs2A5ubF7OhmwwHQlgnuTwGR2YApSrGx3p
 S5VeH+w8gd7l4TetNcmpfze4rYxWCfsX7IE48iaVa9WG1VeZYaDaUc9t2ex7/MGjPv5Jn1fU4x
 PyRFS8+Za5MQg0Jw9i8QhnYEBEAlLXce9uV+7ADoeqwICfFZSHQsI/jl/nXZNts9odVd222j+w
 0AA=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="163447708"
Received: from mail-bl2nam02lp2054.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.54])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:41:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLzscncMnMrkUaKiQ9VaRI0715DOMxBcCec4KT/QSC2mHIrb+PJ7nbn2V6eUlOzuW08vnZ3GggZWlWATbbKY/Q7NGrRmJTsPi1q8dj3tJ50GV1adSSIoUabZQDGtqkXAAonf5Nna0k04UZ2jzaCqEURXc+5CEztOeYKSHlD5WWzAR9LeQOc0m7zbwlI4EWEcqYbDVXmp6FrExeFYdG0vqgJkTIfLiBPxnhrGtIaEeGrOlj+lASFRqTCs3NQwciRnEtN2xtN4FUYbrv26OYgomz595T1WflWjmQG4zGBrreaRoKR5TULfuaUIV8vSl3RUqo9SPq0feMVnqyWRYYNdCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFS3SBKKuMgh8t7IBlXsOQ6jU6wRnxfBx64PT9eis3w=;
 b=Yxrye90v570wDDBOmPoO5dCKRspjogDDrUS2YsLKr/4SlYNcy/bdMnY1q/2+XfXjtfYuQ1qzS8DW86K6M5e4yASM+t2TDnANhPoR2dswWZNR7y+HaTXfRJb5x0iiKAyhE4KuePvNYX6H1/Z+BFn7sRAuS2CRNXve308M9U6swXKz2czWFCln1HuSHcsDUEQeHnGhxeGjP1ITkTNkvuP/nqxSIXcGUdNi9Ap/91s0bol+fF/L75toFId2X+U9+w7QndAm3bjNz5ZydsLqnES+2/as7UD0lHR2Uw1LWp5LEKRFSPQrPdliZkYNjGhdI9oeZiDavq4jYWdQPnteIcAX/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFS3SBKKuMgh8t7IBlXsOQ6jU6wRnxfBx64PT9eis3w=;
 b=p22UryhWT8qpU4aZ5WEFDmiPbEm68oNuCTZs6zrV6YaMIEvlnbF0WEh7nUT/UDqhbXEgcG6a1/S3zNa3S9J+inqKpe/tSP3RuDDi0PNxTe4MREVgtPWB3z/VDe3d/A8TFzvqXXv2ioAPdducyeLcpYRaMfLLaOc/1OSnvux2I4o=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0218.namprd04.prod.outlook.com (2603:10b6:3:77::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 1 Apr 2021 13:41:46 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:41:46 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v7 1/8] update_headers: Sync-up ABI headers with Linux-5.12-rc5
Date:   Thu,  1 Apr 2021 19:10:49 +0530
Message-Id: <20210401134056.384038-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401134056.384038-1-anup.patel@wdc.com>
References: <20210401134056.384038-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::29) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:41:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63cdb502-9b42-433d-be07-08d8f513e466
X-MS-TrafficTypeDiagnostic: DM5PR04MB0218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB02186C6B5EE3962D1FFE70BC8D7B9@DM5PR04MB0218.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +trStXJhNnmbYZzEnPHFktEstdjq5pExWFxEdqNHlsciynpsSMEW4RvRK1WOxOlsUX2j2NnlUgWKLjSelgGVK31QIbJwi216DHcfuKh3+fC+AHy8lT8stvbYRyJQwZ4V+TBd/IivTCD90rcbRvyDKCX6cLlYYOtkfmCQecMixl/V2zbjhMDJOfi1Bi62yDF5oVgRfnmqGWogOlvtRCqovWiIzjzJMhdnAp5ziI7ykgXGkL81CiCgUYj4oAUT+TWXdxOso82LWpjPRgHV5Vi12GBoovV4nyJj0bDlU7TQ3Uqpsr5q7bj/3Iatr+gxeI5vIuDzvERDks+VpaxoLFt4dc97saVK7enYtvs/+2PRSkLFVNt96D1n2XM902bCg2AndEboiIuG2+12cUexFFzemQJmg9EPT5/z9NY/GwRogx4aD3COKyrSfu1DB0F/JmI0poRTlAVXip91R/xgRUOMhxH86ojHd3zE4j5bYOdgfcYj8JZbbOjWPhrtmpdNZfzlOkxxD4bItb7E8YgA7bEUQw8mXcvCvAU98yN0sWvu+apptP+tpkU41sGuImgy9pWqkZbmOXlu39QxPwJQPdt5Ca9ocljygR/RAxtzCbK4Ldi9gf3gl03H9BF9Kcvt+Vq4vGeOtz2NKlxGMnd5mmbSJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(38100700001)(8676002)(316002)(36756003)(8886007)(86362001)(66946007)(2906002)(186003)(16526019)(44832011)(1076003)(54906003)(30864003)(2616005)(956004)(83380400001)(478600001)(66556008)(66476007)(7696005)(26005)(8936002)(5660300002)(4326008)(52116002)(55016002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eiBNdsyt0I6921dSXige2jFvhnfiYL5sAvfqRXt8GUxuZgKq5leMMK6QnjkT?=
 =?us-ascii?Q?Q4RdDa8bUZ39spoZOUgUrCGEYQOVV9YVwLukBnksUbg65tFMYwSkwCdgH6vc?=
 =?us-ascii?Q?mxFN2BRe9HZuRmtUjlhSz+aj15dRLQ8Y7XyPGJnEYALrc1VlrpBsLFr01WjB?=
 =?us-ascii?Q?LjzS8e9g/RFQWAJcNhL0UH4z3ujlz9wPLXK1G5ILK25bCimCx+/D5gFleWep?=
 =?us-ascii?Q?2y7fNQr6Gv232owoSL9zhxovwcRT9WSZ5B5YU+ZdYAXTwTRADMtjX/WYw/2U?=
 =?us-ascii?Q?o30e0h2uylHU8mW5mrs6afJ4RjZ2p/7Gx+NRsFbJjB/HsZQWuJ0y7JZMuQBU?=
 =?us-ascii?Q?JGPOfysDVpRTXP5oMLmGfffRFbbAZlizdlG6F4Oo45WE/LnxM9TKyBg4RPqt?=
 =?us-ascii?Q?8GSye0zrzbBIghNf+5sHfgrQBwEPEAaYQVbWNpkKN3ACw0Z1FJfK3rgdMvqz?=
 =?us-ascii?Q?TZwllEK7p8cLffwbPC1bn7zEGopIWv8VxMkU3GVfqawvbfkS+R65LcujwkNq?=
 =?us-ascii?Q?QIPfAGaVXLCD9kTXCByqeyM1GCCyxsduCwfPmpZpsiyZ829Mt4SkCHPbB5TV?=
 =?us-ascii?Q?8ZIParg+aAuZhfTpdiFMAPZHjLc0PXDbmiUDo2dU9KtMDFU6/TqmcaUpNgMl?=
 =?us-ascii?Q?n7tdy8y+ViymRFsH4esoMJ8VJukKZBsO9MN5aufv4h1wMuI2Q08Y4ulRqhoX?=
 =?us-ascii?Q?qwXSKVSavzSAVOteHX2Udh6I4caknLLceKydkihtkggcMs7HQcllo5csMZDl?=
 =?us-ascii?Q?0ruxsfP4aKBkiQhipoei7QwEvRcMR+iBpCiliQuaSmFrJjZYCrw+IjnrZMFf?=
 =?us-ascii?Q?ot2KbFwJNUso02XfywKNrxuF7q7TRmKHSeCjZx7uinQ//5LSm6JvHMIpTfuA?=
 =?us-ascii?Q?9N3XuHFknzK/ltjOX/cs8qPal31Ujne6/B7Rd6ImW+yOZrG2ScN81378FY3K?=
 =?us-ascii?Q?k5B+FMTJStzVAkKzpVB6kLpS+FNW3EacCAEKJPRvSGmA+cQ3DAdoHnYZZu+y?=
 =?us-ascii?Q?+PBeWWxl6Hwn+2h2gvUc5KfBLJM8y1z0TAaxu6pnlYXXmSyNulvLyP4niUvu?=
 =?us-ascii?Q?gjproxi6E97Nj/ZBpdEPZmaucFwESo/94Krey5g1jflPfH7OiuSMRN55Dy09?=
 =?us-ascii?Q?oxC3sfWXjeXWDZRaktq8WuSbtzjGamW9o4e43Nr67FCf+Iy+wrJqtoAMfsDd?=
 =?us-ascii?Q?PMGmIrngLqe/nHi2urqV57llZtcoY3j9iw3jzOjSOGsZdfDiE5wgXt6bUB//?=
 =?us-ascii?Q?O7Vou3oyerKrq2DqXcNHF0B9i+4gThFdNj8sDTFp0YyMbuF4eY8Ay2cJicCI?=
 =?us-ascii?Q?te2oPqRovfd++N6ekCvo2xHH?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63cdb502-9b42-433d-be07-08d8f513e466
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:41:46.0415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwSvcbWsfzE2GJDN13I7im4Co5vAmcxRsOmxPuK/6pQ+4bGmyl+MWPJy5JJYrP1PEraLH1lq4oaA8Bwawzao8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We sync-up all ABI headers with Linux-5.12-rc5 so that RISC-V
specfic changes in include/linux/kvm.h are available.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arm/aarch64/include/asm/kvm.h |  45 +++++-
 include/linux/kvm.h           | 269 +++++++++++++++++++++++++++++++++-
 powerpc/include/asm/kvm.h     |  10 ++
 x86/include/asm/kvm.h         |  44 +++++-
 4 files changed, 355 insertions(+), 13 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 9a50771..24223ad 100644
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
@@ -164,8 +176,9 @@ struct kvm_vcpu_events {
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
@@ -219,10 +232,18 @@ struct kvm_vcpu_events {
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
@@ -233,6 +254,15 @@ struct kvm_vcpu_events {
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
@@ -320,13 +350,18 @@ struct kvm_vcpu_events {
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
index 5e3f12d..da0c11c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -116,7 +116,7 @@ struct kvm_irq_level {
 	 * ACPI gsi notion of irq.
 	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
 	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
-	 * For ARM: See Documentation/virt/kvm/api.txt
+	 * For ARM: See Documentation/virt/kvm/api.rst
 	 */
 	union {
 		__u32 irq;
@@ -188,10 +188,13 @@ struct kvm_s390_cmma_log {
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
@@ -201,6 +204,29 @@ struct kvm_hyperv_exit {
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
 
@@ -235,6 +261,14 @@ struct kvm_hyperv_exit {
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
@@ -243,6 +277,8 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -274,6 +310,7 @@ struct kvm_run {
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu;
 		} fail_entry;
 		/* KVM_EXIT_EXCEPTION */
 		struct {
@@ -392,6 +429,31 @@ struct kvm_run {
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
@@ -466,12 +528,17 @@ struct kvm_s390_mem_op {
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
@@ -533,6 +600,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_CHECK_STOP        6
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
+#define KVM_MP_STATE_AP_RESET_HOLD     9
 
 struct kvm_mp_state {
 	__u32 mp_state;
@@ -764,9 +832,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2
 
-/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
-#define KVM_VM_MIPS_TE		0
+/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
+#define KVM_VM_MIPS_AUTO	0
 #define KVM_VM_MIPS_VZ		1
+#define KVM_VM_MIPS_TE		2
 
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
@@ -996,6 +1065,27 @@ struct kvm_ppc_resize_hpt {
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
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1069,6 +1159,11 @@ struct kvm_x86_mce {
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
@@ -1086,7 +1181,7 @@ struct kvm_xen_hvm_config {
  *
  * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
  * the irqfd to operate in resampling mode for level triggered interrupt
- * emulation.  See Documentation/virt/kvm/api.txt.
+ * emulation.  See Documentation/virt/kvm/api.rst.
  */
 #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
 
@@ -1142,6 +1237,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1222,6 +1318,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1332,6 +1430,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
+#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1450,12 +1549,106 @@ struct kvm_enc_region {
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
@@ -1484,6 +1677,8 @@ enum sev_cmd_id {
 	KVM_SEV_DBG_ENCRYPT,
 	/* Guest certificates commands */
 	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1536,6 +1731,12 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
@@ -1606,4 +1807,58 @@ struct kvm_hyperv_eventfd {
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
+#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
+#define KVM_DIRTY_GFN_F_RESET           BIT(1)
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
index 503d3f4..5a3022c 100644
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
@@ -192,6 +194,26 @@ struct kvm_msr_list {
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
@@ -385,17 +407,23 @@ struct kvm_sync_regs {
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
@@ -408,6 +436,18 @@ struct kvm_vmx_nested_state_hdr {
 	struct {
 		__u16 flags;
 	} smm;
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
@@ -418,6 +458,7 @@ struct kvm_nested_state {
 
 	union {
 		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
@@ -430,6 +471,7 @@ struct kvm_nested_state {
 	 */
 	union {
 		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
 	} data;
 };
 
-- 
2.25.1

