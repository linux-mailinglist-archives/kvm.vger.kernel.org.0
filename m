Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CADF12A5B3
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 04:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLYDAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 22:00:19 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60709 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfLYDAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 22:00:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577242819; x=1608778819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9uAyxwPTbPHGRWGGdDPJKb3hPSPge7ga0ymvBLIQCjE=;
  b=S0+GOOo2vN3Yr6OKSD9k18IsTx1YW6CdnF5jccRNljEUutDqb5G3qHGr
   Z6AA3c42A43ZjAt7w9x2zDdIjuGKLR/7/0CjU1SCE2P/kIcWXJXNX2y6q
   xA6B1D5VS18koMsCpnegdnP8v7BR13SjOUt7UB6YoARUaZFYs7mqxTWdq
   xRCytkS5Cg3DYEYLSXdn06nSu/l3somdzv1xozae7IfPMTWL7QOAWaAdO
   ecoio5lkJegP4f75x571hdhyK/7ijMly7vl3GPNet7eFIFhkFcW9BnZpE
   wHu8S2S1T4lf6F8XShNO5xerh69ml8QMA88S7Y6vtrwQ6GIv9r1RzUXRj
   g==;
IronPort-SDR: LH712Gpc6U3n+Ulc2gPtcmatOPC1xodPRTZg9R7Ipf/RoCi9mqvR3Pn9b9NPjcGMyvxJiEhghj
 Dgu/BpW9r8dQbHCAfQvZi7Sc69Kd4ZzbYRIKngODyoHTezf02ZMmfKmWM8x3TmDnWXd5Z43iJ6
 7TvyKEMS3ZnpzJe3FUYrMJIHuqcBJnCjRZI2SpuF2Z5UUR+sB5anBHLw8KJSNflcp565fgzAvt
 4Kv+XrVXCCeUQRbSWfpoZ8S9pNlM5ZXVkefke3bnFN0ETgIlQUv7bKn+YMXLW/GJLcW7GLB7ne
 xsY=
X-IronPort-AV: E=Sophos;i="5.69,353,1571673600"; 
   d="scan'208";a="126854665"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 25 Dec 2019 11:00:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+/qn4Ay2hGS43yJ+anl30egcs5YoEHV+BjATt640ym5+AOMWKfRv5TpwOjALf/IDSOwR0WmubL/maLDy8ZiTGk7wdE0biV78AbAqjaQOgbFDLjfKb+GcNSrXy59t+zKE736MeqxBytlz2GMb5MyJL+fcrIs28LW06ZbTtJWYD6XlxcZFeMgQXaq3sQAWWVt67bmbl5J5UKcJ7BL7U52WrqR0efi7opNhCDo9eB3pOJXJtLJZ6BD0JdDn13oMYOL5xGwjf+dprAE7jhsErfsPTE5MMjaMysJkIRZCvppTS60WkUiFKy6lh69MVJl01FBxiycYyr1iFG/lMZBFK/Nlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4YkFa03dgbiSlO2HLH5jlHKon49iUZYuIiYSldGZj4=;
 b=Jp4CmZ0iastWzt+F3JGe598xm9iBI/JSaFrp+EHLZ46Gjomu5xpbRRF/IEW2j9uAXSCiC3tPh5ylc3V0syvbrRPE52pMXkDOYa9Ndj45Z1EqnBtDaGOBXSO3mflbVRNzFjVT4p+KSkFHLmJ1/oSIxWYd1FUgmCSdBMBb91PNtr0wUnPSUUdTl0uR7UOBtAMUl/rEp0M/a4Jh5qMLyg/VS3GZuVnB5l0czy5zw1T+1JjZ2jHeis+Pta8R8rn8leBYzJ7BR6p75Mt3Z7isTFjkSF8gl/uZWA0ZjNQTu3zM9Znc5blCKl2k2n7X78cA4Nk9+enizqq3Wmojsmc8X2jymw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4YkFa03dgbiSlO2HLH5jlHKon49iUZYuIiYSldGZj4=;
 b=U3pjF0Rl9IgKQzVW7RksA2B3P7DP+I4X2yL0WDpjLsa9DewuO2hn/lNHh10CA4ExlcKvS/jCwdjR3vK3jQLpklMzEzm7D8LFAM3L8De0RbnQzFY2Jo6cDRWisGNPmGf39CLeI3N6UmMQ/m4DEuAAvHoUIT5LMe17VE0O7Gg0TQg=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5597.namprd04.prod.outlook.com (20.179.22.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Wed, 25 Dec 2019 03:00:16 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Wed, 25 Dec 2019
 03:00:16 +0000
Received: from wdc.com (106.51.19.73) by MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Wed, 25 Dec 2019 03:00:13 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH 1/8] update_headers: Sync-up ABI headers with
 Linux-5.5-rc3
Thread-Topic: [kvmtool RFC PATCH 1/8] update_headers: Sync-up ABI headers with
 Linux-5.5-rc3
Thread-Index: AQHVus9uADFpxo6O5U2AUwBDP3nTWA==
Date:   Wed, 25 Dec 2019 03:00:16 +0000
Message-ID: <20191225025945.108466-2-anup.patel@wdc.com>
References: <20191225025945.108466-1-anup.patel@wdc.com>
In-Reply-To: <20191225025945.108466-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::26) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.19.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f7e844bd-5c75-4b88-7276-08d788e69141
x-ms-traffictypediagnostic: MN2PR04MB5597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB55978D5496B0D77AF67504598D280@MN2PR04MB5597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:541;
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(5660300002)(86362001)(2906002)(4326008)(54906003)(81156014)(81166006)(66946007)(8676002)(1076003)(6916009)(8886007)(71200400001)(44832011)(66556008)(64756008)(1006002)(66446008)(52116002)(66476007)(55236004)(7696005)(16526019)(186003)(316002)(26005)(55016002)(956004)(2616005)(36756003)(478600001)(8936002)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5597;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8t55IRsfi4HazG5qDB9JMlIcAUhVvMou2qB/lMGSNAM/IzLlVi4sDqk1ziRqwt/WG2OOv/xSs/foB58Lc+RZ24bFQuc6DykJc+BPYreATXmyxeGMBWdT+6UCWOydxysHkeGDr6FcRY79sdb+4JOut910gfCBwxOcZaENk1axR0KHVqt9aafnaxUFWTbTacHcCpk1slliXxG1cQWx0iMh59JRAsatzElmBgN4oV+DqD9LRS3cNmHMyBExEJInlC7iU+wg2EymOal3NPtaPyIOiYiLAnIGSBBioVsVzH13BKKqgeZYaUaBmAT7Mkt944xUWpRCbexYrdXgCty1rLfwN1q1Oa2ifviKAR2SDYp9y5kvnzG2e8+IeZ+338bAoTESzU5K+fy4+9WlYbt688v+jpO24B4AuwSzYsPD4IIrqM2waAlZGkhtPA/zzKeEsT1pfd1tyElHD+gjjSqNPbHh0796E6MQTvj3p3OwpsQ967bcAuggH/wx1jAsmb+wQtjB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e844bd-5c75-4b88-7276-08d788e69141
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2019 03:00:16.1353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8PIDA/UNSpmsZN1oBYDa7UVzpOxGqbcMbtGzMXnoqfipAQUnvrDAWZDE5wLRLMB9BV6jDc80/7uUt4yrF+12Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5597
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We sync-up all ABI headers with Linux-5.5-rc3. This will allow
us to use ONE_REG interface for KVMTOOL RISC-V port.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arm/aarch32/include/asm/kvm.h |  7 +++++--
 arm/aarch64/include/asm/kvm.h |  9 +++++++--
 include/linux/kvm.h           | 25 +++++++++++++++++++++++++
 powerpc/include/asm/kvm.h     |  3 +++
 4 files changed, 40 insertions(+), 4 deletions(-)

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
=20
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
index 9a50771..820e575 100644
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
@@ -323,10 +324,14 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define KVM_ARM_VCPU_PVTIME_CTRL	2
+#define   KVM_ARM_VCPU_PVTIME_IPA	0
=20
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
index 5e3f12d..b6a90dd 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -235,6 +235,8 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_RISCV_SBI        28
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -243,6 +245,8 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
=20
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=3D0) */
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
@@ -996,6 +1012,11 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
+#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
+#define KVM_CAP_ARM_NISV_TO_USER 177
+#define KVM_CAP_ARM_INJECT_EXT_DABT 178
=20
 #ifdef KVM_CAP_IRQ_ROUTING
=20
@@ -1142,6 +1163,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
=20
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1222,6 +1244,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
=20
@@ -1332,6 +1356,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_=
filter)
+#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
=20
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index b0f72de..264e266 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -667,6 +667,8 @@ struct kvm_ppc_cpu_char {
=20
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
+#define KVM_DEV_XICS_GRP_CTRL		2
+#define   KVM_DEV_XICS_NR_SERVERS	1
=20
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
--=20
2.17.1

