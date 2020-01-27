Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B9B14A3FD
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbgA0MgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:36:04 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:4509 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729868AbgA0MgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:36:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580128562; x=1611664562;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9uAyxwPTbPHGRWGGdDPJKb3hPSPge7ga0ymvBLIQCjE=;
  b=T9pPwsAYlWGHcO8z5NPptLze70a5nl+Tv0sQXA4Q41bDbL76j+ZULSOn
   mi2sFPqY96lkhxQc9jggRDT2oX5a3tjPJF3VObsyhRpiRcmi35ozaFNcz
   uc1INjvUQLHzlU2J1L9Aw7aCuO+/AKUuFjR7EwAbtLA7CydLqy8fO6meg
   BimNgXRahqTItR6cI7fep9I9IvP+3bxWqC3i0H7T6Lzw3/GcPVgYIL6Fi
   eDB6owj33Wka9IsZhaGRXo/2EXaWF8ynIFDV97HdDmYOH16GbAtmGgFKw
   s7B4EL+7x4cbp2g21rIEqSbBVeOXv3ppf4PX9ubrjlnjaOIaVt+By76CU
   g==;
IronPort-SDR: fsOLWJarsRyPf8E8BdyN5iGfQQz6x00MHwgMqRRedRuU4lEZ+VnJHwEIfx9sQ9YYrkMTBOOFIt
 KkNrCcyMRsHqtr0CRWUOgI8EKy6wqLhHo4Mh+W3xunu6IZr3kDD91OmRgMsszbCAyCbO01W0ei
 34lT2p/+wEI9mgFFG9gOhQ0mIoL8yoiLwVBcSFUVhBJkG6PnLTnuuBnLSKhTkfBnWrR62XM+0s
 LW6bAvbrKXsHHL74I447tXwGKuGkohe04uhBeJyFIGVzxu8mND20HqseUoUtExh2Bz5HbhNQPF
 dzo=
X-IronPort-AV: E=Sophos;i="5.70,369,1574092800"; 
   d="scan'208";a="128476082"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 20:36:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nu6WBoiKvKpX2Go97ayYnLQev5oJ6cf+ayTMC9RDrlH+wO6Wyt7Afluuu+a4yCitRScg9cwgmSQeYGB8sNqwFh5sNpsyuP19+MX0g4Z6y7oWdSczf6jyc/vesF9NHA/FdgydFFdi6fk9P+o07jaBevs+7u/oxCQbVkDQXUEFwwIY1MKlrxumKdWt3UnUCjDjpmeKUls433otWFA2a98z9UEnlf5b7DSnWDDBXD2q+3FUZM+1DDhvb6QLzWfFgUwS/Vr2pcVNys58PeArdTq5zXsDUwZJO5wLaJTtK1dFViOiYqdCbMPyy1eB8tfA9Gx1enKuTxYYDbstIvMLSs081Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4YkFa03dgbiSlO2HLH5jlHKon49iUZYuIiYSldGZj4=;
 b=b7JYaXMdO/vV39mMvjhZPIp5oY1h0RhGLtoIt55K7OsJV7dx/jw1PvqXQ1e09zbNwkbLJ+6R7CzwYfewOXTF2r8MUj34mUABfMw148r2W3VyYNFx6u7NaVn/cPYPcJpfPplFddQO8OBSjo3c4SQwpMpuHqcZvx+op4LYEeL6hN95UUPrdf2R7aS2gvTeYu6gdfyKPYIGAXF9mkhj91LHDAyVxOGCV0cBQTdj/gb3xVM+IcgqzGpeXZHCXtNtbQqOgPzjWO0PacV7zNv+E7PISJNGt2f2uoEtHoCEmxowOT4LBj8YoK5aMf90sl9SV5BM8lPIF3uIlyftE+YklWLtNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4YkFa03dgbiSlO2HLH5jlHKon49iUZYuIiYSldGZj4=;
 b=dUZGJ8HFJS7WXGFcVQyjelM65oL5MgQDMMXD0WKL70eBqOkmOuAUlNNhtDMvXr0HqEOqdS99ENegqFI9RJi1sC1IboswQX070P3z2EtdOdk6Hevfv3A/KS98y/K8X+BDAvf/HbsnWTuOYGwIggw8Mdwo0ZXlYft421PHG4Jbroo=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6735.namprd04.prod.outlook.com (10.186.147.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 12:36:01 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 12:36:01 +0000
Received: from wdc.com (49.207.48.168) by MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 12:35:57 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH v2 1/8] update_headers: Sync-up ABI headers with
 Linux-5.5-rc3
Thread-Topic: [kvmtool RFC PATCH v2 1/8] update_headers: Sync-up ABI headers
 with Linux-5.5-rc3
Thread-Index: AQHV1Q5VSbgZvVYGzUe/2Q+qCGEMkA==
Date:   Mon, 27 Jan 2020 12:36:01 +0000
Message-ID: <20200127123527.106825-2-anup.patel@wdc.com>
References: <20200127123527.106825-1-anup.patel@wdc.com>
In-Reply-To: <20200127123527.106825-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.48.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c620bad7-dab8-4784-e753-08d7a325776c
x-ms-traffictypediagnostic: MN2PR04MB6735:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB67359AB2449D890FE67CA40F8D0B0@MN2PR04MB6735.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:541;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(189003)(199004)(2616005)(956004)(44832011)(86362001)(186003)(16526019)(4326008)(54906003)(2906002)(5660300002)(55016002)(26005)(316002)(6916009)(55236004)(71200400001)(8886007)(8936002)(8676002)(6666004)(1006002)(81166006)(81156014)(36756003)(52116002)(7696005)(1076003)(66946007)(478600001)(64756008)(66556008)(66446008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6735;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RFsymJo+opCHZ+oLA6qzRRylPduH15IjMEbeiuzxHb2nvpOBhCxqbGpRcO8H3w/h4N06uQf3+WcCF+DgNJT8Z+2//vvdNi/51OBUE2avQ0OnSUDm5R8Ii3YUTeuhDSUxG9ygpc8bXbhg/PvjPqZbKvp8E3N0Bfp6Ig+pWdp42s2OkakWm5OzBsKhsOqCK+ZkIpJXEDLy+ETJkhzdk64nijO3idzm8zzlCz20CP2u/pkqG190K242LEdFGMkVDpsAiwGWoHVh1YjOi3NSqf0vlyhGARXA4bpAq7Ggs2Bnu2AQ/cAeHK1VA9D6qowiG4AoDVPgaXWuuZyb2mL+dEPdyss0cu49z6zpQL9riMeIiSE+aeIg69EdVxhYFt99Ws0IIU+lpUn+Ge3K7TFehmDt/gpyv0WyEE5ornjyovG3lJm+diACr/CXxJXuKgwvaY2T
x-ms-exchange-antispam-messagedata: CJcWpwbrbGhS7w+2LvQSFRnFH6s+rQxYvJnmJY0j9baPpYJx0Tdl/A66XRG2/ZzroYfzxOoPbbp95IBjYbFiI058D5DOzHs+rh3cki2g08p0EKHqyLuTPRDvEOudy3Qxo7wx1fERxN5AUd2r+Zo/Kg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c620bad7-dab8-4784-e753-08d7a325776c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 12:36:01.1426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QHyYN9dzm1Ey42+kWiVL1O3Tcw1vo2sBGahX6TQdGc5GFc8E+H3WFKSyx+5WfSh+iR5AfuVwfEjjksVAk9zdDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6735
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

