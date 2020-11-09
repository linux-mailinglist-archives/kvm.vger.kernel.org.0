Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860EA2AB700
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbgKILdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:33:42 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25576 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729812AbgKILdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:33:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921620; x=1636457620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EK/5efwN5ctponF7YeDfvp60Cq6LVz8yReJHQCaEMVs=;
  b=SlSnl5UPdGmr/nDoyDL008Q0GCnot070T8DM9u4gSeQCXQFtPMCwJa/D
   jz4nWrm4VyrZkzKPYvzr0cVtKlP28Dz11oOPLA/iLJ+yO86fw6bxAv7ll
   2KkmedS+esiJ56w44lRDCDrCdWbZb4MOcYxoKmiUeTRhkVcUwhFhZTmXr
   eFHou0PO5J9BA4nXB81ljyvSD+W4PpcxeweXIC3W5Vl/luOMlCxh/vMTa
   A7EN+GZ86RSBm+fhFo3zK9Fe1/SEy/wj7NaQahuxG6s5bZfB7PyAxMgIt
   NcVCqQGXOCH83K4STjnfIHonXuhy4zX7UIg9tEPD4H6qSyQrgzsfu5HLJ
   Q==;
IronPort-SDR: 5OsgOFmcNpuDX+iGQU/SXNXhGRW0s8qPXfQxakRsreICA8y6GRqz24PhRyP0W7+QIdvOb1w5xb
 SmVfKgJutSpSJpolF1TShM5OnqfmhwBaTLN/13fMY8ZOoManuFqTeP4VPaPrkeeTDZgY8y4tr2
 jFqt3g0/h3WKGl0JFvyhcvmut02xTS1BTDQyn3OVTc9m2En2cX89Ux1Ij0jP9gtf80gNoCYVfQ
 mpKYKbraGcpKKEGVQCAAfjJAW0I8qgqgOWWM6RS7brSo59KaUVdZrErzLZ9Y+fUCXaULqlBkTE
 q3o=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="153382732"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:33:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vj/EXjXoK2jnIkFLtSDAgl5lBRdh9P7U1lhGwZH/ftgEcpUllXWf//NZYfzRMOwWKobYf+0A32wMd4K8cANVM/rvqQiN4hBCZBWdvNM057BYHv1+SD645Jo9oZbe6QmdbazpBlxeNYNL6HrTMU/ZVX6r4skm4MG5ozb6bcFcb2TjrP38VXsTMNocL8q+VnOm86Uj4jA1fNyezq/2ve/SJ43EMni9ij0n9MRPhgutsOHtkGkvRjkcVS4ozhzDCKN63raTRmxMGup+jXBVuU2hChU8IjgVinrTnRRmZJPbAsOo1u1YQcgxjMil16JCK78dHFrB2TEZkg80hA6LELEG8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHs+gj89i8AEy86hjmH6iBGFS+byJUeIDojUGHCPg8A=;
 b=kidGzpkKltVf+Ohh7S++9COw1NQGk1K2Cy075ZwhgTMy8WQ5WvP6ETq57S8msV9SWG7fCfJ0bQ1oTG0X+S2LiZjQ1XPTtvh1LTcKHw//DtbmNGnj3q7upX4qEV+/qmM+2YTKzxQcwXsF2Lh8RlHWl+NlEotwzWWWrt29AXqwKVT+yXsJJe4+jmpOjBEHpKfqibeInVCSNQs4qOdU4LhhGDLcm2/FdokEMUeqzA3id0HP04PhZnE78P2Ek1oHAFlanoTHMDrs31VAuGHmqT44Yu7lekF7YivZHtAyuImJji5GUIVUSHMRLy6ROtCX1n0C62Jo0LGO0HnxdI9FB3zc0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHs+gj89i8AEy86hjmH6iBGFS+byJUeIDojUGHCPg8A=;
 b=U/K03Vzht8AbUctdjvK/Lrs06LS9s9B81/yNeTmnzHxEQHqZgfv/b5OWCYoB/i6ZPunZVjLgB2Vt933kbQ44+ueA+BPTy7ta55DIKP4ZFk2skM1mbktcLDfolpIHv9Kcw9JL5ydDXm8tZn8jWNirmyfF0hyYbcbgDgeRhsknlqs=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3866.namprd04.prod.outlook.com (2603:10b6:5:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:33:36 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:33:36 +0000
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
Subject: [PATCH v15 01/17] RISC-V: Add hypervisor extension related CSR defines
Date:   Mon,  9 Nov 2020 17:02:24 +0530
Message-Id: <20201109113240.3733496-2-anup.patel@wdc.com>
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
Received: from wdc.com (122.171.188.68) by MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:33:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc26e639-e8d5-4553-0466-08d884a34bdc
X-MS-TrafficTypeDiagnostic: DM6PR04MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB3866983AA1F5233060533CEA8DEA0@DM6PR04MB3866.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:11;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PjUh8ZJftseg4VCfPREzifnvfncaK7UURBvxBSr15J2h4d4wAIHBLLMnFQduBZhzWY2aXgqmvGWvVkPuRm2LrN6kKqJKaCGQYeqSfwnK6RbwHHMo+ZjTTOrJfty5osOt697nQmrP6VLTbgnR5H+MpPL4E4zexDjCTchctRdmRcWvSOmwJf9WymXjKFq4swWeejQF5AM9jLGNuf8vAr+8aEfvlmgw2vGM/A1PpvgVTPSpkr6pm/Aj5HrlEsUxYL4rx4cGgVZdWNJWshvGwEGsgNhrCcFezgmpU8t9oAau46BYN4Xr5rCIVKNrFcihU8h44Ch8FlhVG2oNK9XS4/qzCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(55016002)(7416002)(83380400001)(1076003)(44832011)(16526019)(186003)(316002)(26005)(8676002)(110136005)(54906003)(5660300002)(52116002)(7696005)(956004)(2616005)(478600001)(66476007)(66556008)(4326008)(66946007)(6666004)(2906002)(36756003)(86362001)(8886007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: D/Pg7N2nxqBRXQ+NPe+eHa5Z+UQSQ9ZuY7Qbh51UeeK5Ld31ZsNAuObqmYkBl6Ekip8YQ0WCzVz9FJ4VkN2RRS4lgzMMs6WWwY8+A93LCXew0lx3a6LWmFT8A1PC4uya7leTKZuSlySee8HVBl891+OKafvDHxCtg6qzit2kZ+rMuc4ONdrf9nZi75R1kvcoH+slAcpCbnkJT9HD2bVgKpVbJ17MGcz3Dz3af5NxpptswKO7VMygGEju24/m221dXLNbrolSEEvfJYfBn8FO+ZU+WkuXSXYNFnoz6gTGPPhXCIJpED7LEYOCs4kSZjrT+McIXjQ/9m0VEELtuLPOHg9jmAIP722Hyseu58HvMj9iPPpxj8cJUYmu0vJDBru3OWVvX0720isPe7TLXrfzJM0zwwAL72wEXrS0fUF/fcrGSWOP7u11TEDrgfC10UBQLyYSJHybJywSVMD/kiOsYwqY55I/RaaWjoRA5gGxBcmvBPYcAT07tKDg5QIqf7DIG5LTb/SjXS0aRrOLxdWBaouC512hvSxAQBR6quEOuVjb2LgQa+WfYxp+INSNFkmqrCj1kQtWM9deQKCiByC/CT7GcKOYtuvritnLBJoupci7kdiwkiGkEN0UIeF9sJ3frDMC4PYziyu6v7tyZyHFFw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc26e639-e8d5-4553-0466-08d884a34bdc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:33:36.2169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Wf+XYY7RTcdrJEEJk8ed/9lK+t7JZK19rLpU6+0ZoTe+2WuTpQLKPyxa7bcu96uKfCcQ6kdcL0so5d05ICZ1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3866
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch extends asm/csr.h by adding RISC-V hypervisor extension
related defines.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/csr.h | 89 ++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index cec462e198ce..bc825693e0e3 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -30,6 +30,8 @@
 #define SR_XS_CLEAN	_AC(0x00010000, UL)
 #define SR_XS_DIRTY	_AC(0x00018000, UL)
 
+#define SR_MXR		_AC(0x00080000, UL)
+
 #ifndef CONFIG_64BIT
 #define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
 #else
@@ -52,22 +54,32 @@
 
 /* Interrupt causes (minus the high bit) */
 #define IRQ_S_SOFT		1
+#define IRQ_VS_SOFT		2
 #define IRQ_M_SOFT		3
 #define IRQ_S_TIMER		5
+#define IRQ_VS_TIMER		6
 #define IRQ_M_TIMER		7
 #define IRQ_S_EXT		9
+#define IRQ_VS_EXT		10
 #define IRQ_M_EXT		11
 
 /* Exception causes */
 #define EXC_INST_MISALIGNED	0
 #define EXC_INST_ACCESS		1
+#define EXC_INST_ILLEGAL	2
 #define EXC_BREAKPOINT		3
 #define EXC_LOAD_ACCESS		5
 #define EXC_STORE_ACCESS	7
 #define EXC_SYSCALL		8
+#define EXC_HYPERVISOR_SYSCALL	9
+#define EXC_SUPERVISOR_SYSCALL	10
 #define EXC_INST_PAGE_FAULT	12
 #define EXC_LOAD_PAGE_FAULT	13
 #define EXC_STORE_PAGE_FAULT	15
+#define EXC_INST_GUEST_PAGE_FAULT	20
+#define EXC_LOAD_GUEST_PAGE_FAULT	21
+#define EXC_VIRTUAL_INST_FAULT	22
+#define EXC_STORE_GUEST_PAGE_FAULT	23
 
 /* PMP configuration */
 #define PMP_R			0x01
@@ -79,6 +91,58 @@
 #define PMP_A_NAPOT		0x18
 #define PMP_L			0x80
 
+/* HSTATUS flags */
+#ifdef CONFIG_64BIT
+#define HSTATUS_VSXL		_AC(0x300000000, UL)
+#define HSTATUS_VSXL_SHIFT	32
+#endif
+#define HSTATUS_VTSR		_AC(0x00400000, UL)
+#define HSTATUS_VTW		_AC(0x00200000, UL)
+#define HSTATUS_VTVM		_AC(0x00100000, UL)
+#define HSTATUS_VGEIN		_AC(0x0003f000, UL)
+#define HSTATUS_VGEIN_SHIFT	12
+#define HSTATUS_HU		_AC(0x00000200, UL)
+#define HSTATUS_SPVP		_AC(0x00000100, UL)
+#define HSTATUS_SPV		_AC(0x00000080, UL)
+#define HSTATUS_GVA		_AC(0x00000040, UL)
+#define HSTATUS_VSBE		_AC(0x00000020, UL)
+
+/* HGATP flags */
+#define HGATP_MODE_OFF		_AC(0, UL)
+#define HGATP_MODE_SV32X4	_AC(1, UL)
+#define HGATP_MODE_SV39X4	_AC(8, UL)
+#define HGATP_MODE_SV48X4	_AC(9, UL)
+
+#define HGATP32_MODE_SHIFT	31
+#define HGATP32_VMID_SHIFT	22
+#define HGATP32_VMID_MASK	_AC(0x1FC00000, UL)
+#define HGATP32_PPN		_AC(0x003FFFFF, UL)
+
+#define HGATP64_MODE_SHIFT	60
+#define HGATP64_VMID_SHIFT	44
+#define HGATP64_VMID_MASK	_AC(0x03FFF00000000000, UL)
+#define HGATP64_PPN		_AC(0x00000FFFFFFFFFFF, UL)
+
+#define HGATP_PAGE_SHIFT	12
+
+#ifdef CONFIG_64BIT
+#define HGATP_PPN		HGATP64_PPN
+#define HGATP_VMID_SHIFT	HGATP64_VMID_SHIFT
+#define HGATP_VMID_MASK		HGATP64_VMID_MASK
+#define HGATP_MODE_SHIFT	HGATP64_MODE_SHIFT
+#else
+#define HGATP_PPN		HGATP32_PPN
+#define HGATP_VMID_SHIFT	HGATP32_VMID_SHIFT
+#define HGATP_VMID_MASK		HGATP32_VMID_MASK
+#define HGATP_MODE_SHIFT	HGATP32_MODE_SHIFT
+#endif
+
+/* VSIP & HVIP relation */
+#define VSIP_TO_HVIP_SHIFT	(IRQ_VS_SOFT - IRQ_S_SOFT)
+#define VSIP_VALID_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
+				 (_AC(1, UL) << IRQ_S_TIMER) | \
+				 (_AC(1, UL) << IRQ_S_EXT))
+
 /* symbolic CSR names: */
 #define CSR_CYCLE		0xc00
 #define CSR_TIME		0xc01
@@ -98,6 +162,31 @@
 #define CSR_SIP			0x144
 #define CSR_SATP		0x180
 
+#define CSR_VSSTATUS		0x200
+#define CSR_VSIE		0x204
+#define CSR_VSTVEC		0x205
+#define CSR_VSSCRATCH		0x240
+#define CSR_VSEPC		0x241
+#define CSR_VSCAUSE		0x242
+#define CSR_VSTVAL		0x243
+#define CSR_VSIP		0x244
+#define CSR_VSATP		0x280
+
+#define CSR_HSTATUS		0x600
+#define CSR_HEDELEG		0x602
+#define CSR_HIDELEG		0x603
+#define CSR_HIE			0x604
+#define CSR_HTIMEDELTA		0x605
+#define CSR_HCOUNTEREN		0x606
+#define CSR_HGEIE		0x607
+#define CSR_HTIMEDELTAH		0x615
+#define CSR_HTVAL		0x643
+#define CSR_HIP			0x644
+#define CSR_HVIP		0x645
+#define CSR_HTINST		0x64a
+#define CSR_HGATP		0x680
+#define CSR_HGEIP		0xe12
+
 #define CSR_MSTATUS		0x300
 #define CSR_MISA		0x301
 #define CSR_MIE			0x304
-- 
2.25.1

