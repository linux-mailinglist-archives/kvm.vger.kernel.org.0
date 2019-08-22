Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D469398E11
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbfHVInT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:43:19 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24071 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfHVInS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566463398; x=1597999398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HuIi0ISk7qcK1s+cVTnBDQjSLhCaUvSVip1PboxeQTg=;
  b=B2b1o2ZLxt1XH2FJdmWgOqe62ppltO5bWz+h+ukE9J3AkZN80jEOV/Kl
   fSrFsI/UAhzWKQ3MzSL0Jaz7qKfshW97VqQU9oBv37NQ+GAwvcxvsWicV
   ab5Zg2HrwViCtG2UXMP687GQZF+rIvNn09X2n9R5x4y+F3NuK83ssdN3s
   GqzThi7nk6AJi8/uGM78l0TWspAMPSDJEsV19YRuikYu5PpjSH3i7WrKa
   6fFy+W8R/q/vfClt5qKvvZmHBH+s/0imPqsYrljUo9xc1sI5BlsINjLI0
   TwX64tGQsZxZgHQCDlzE2LLW6MCqjXbztptjY0zbPomHIZdhodGv3TxL5
   w==;
IronPort-SDR: 9GxSZXeRecJZwUHtFwpXFWf/0/NhDfvNbFBVUYfEj27xcp/dE/jNLfacnRsdsw6aPGHlFvBF6b
 scFTKIO0Vx40d8/geAJmb3WCgYga5ZUuXrTaJHYK9PT3rVZm6OOj4d4LcymkFkVqw38VtULokb
 KVN4O85p7jTRZ9ohVS2xtdQZQ9OO5bvCwIFaBEUhGLne/tYC6ky5iIpiWK9lZ4I8HOqwQC2Ane
 1VrBslvYYuCOuZd7zotSpctQVczI+pJ8zcN76mKnPtY6YXAeqXqTHbNC5NFT/pPlcHD2g4E+X7
 a3U=
X-IronPort-AV: E=Sophos;i="5.64,416,1559491200"; 
   d="scan'208";a="116400262"
Received: from mail-bl2nam02lp2051.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.51])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 16:43:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjEw31TzKbDCutw7RvHHWj23+zPRMrLS1lZ/+fBrr9nLaSyZ/WLlSt+HK2zSgvbQJLY9aC/5OTgPoV7TX8SWm33lDgbQwj/o+SImPfrG1N/TJot7IOZkJxX7TqnL0qgPyGgJqoShrjsA+Ih1NfI1Zfddcc7jOz8wN9AT3jVJg6GrnPMypLwrOf1rb1+9z1Fjsid/pP9Qd0FMVGz+391hEw2AVlL63Ty72HEr8Wek54YNjRmMHYWCUqCKnCSHcHLsLBuNZHy0c1+0BolOAdqdE1/DWzRhew2QtrVPfq9MrLCvheZG4t0ropPkQAwzsdsK+JYR7F1E+fxQ1F66O/UEVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87n/BVikbMBj94riGr6wGXVpOZj99n9qnyY/e5VJ89w=;
 b=YFEIBHQS15zKnoQs8jdNcyoEqNH918SDhPgRumVEIMxJNiD7xjPvfWsfFVrvbsF25FE1x60fCgpIVRIvKuJYek0yOjNOYUs5iqfD0X6GoG/MLPVJRGuH8sFcBJLVRXJynJzfqhdZgFSV7iaVysZ2pQV4fAqHIdBQy/UAAM9bd2ztdGF/gaBLQtDriqSZvj7lCgjLM3svfXG6TkqE1aY2jyMFNEJfqcIWdvnEMbq55SR3opvwYuVVlNNlQssJVImsHjFTXTEbJFQXw8VZ37p+EK7Y4Wr64emqrnsAGzgggMb6kuLQbw5sELWtQFs1M+2+HQM9NKrbB2yGkjFWBbziBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87n/BVikbMBj94riGr6wGXVpOZj99n9qnyY/e5VJ89w=;
 b=LAjF2J4Hl74oWlDVLm4Gdxwu9S8DNFa/lFI2XHWb4U5eN62J+Yfn52B/wrgM6oNfg5X1ohaWE1oIBq7eydwaklAcTZ6ypa0h2JPrzkFE73Tz2lZFBSIRB7QGL4rfIBAVYKBSzfpIv0SgSBhb9m+xyJiCw2YjQqrN9L3ecMwSEm4=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7070.namprd04.prod.outlook.com (10.186.146.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 08:43:16 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 08:43:16 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v5 04/20] RISC-V: Add hypervisor extension related CSR defines
Thread-Topic: [PATCH v5 04/20] RISC-V: Add hypervisor extension related CSR
 defines
Thread-Index: AQHVWMWj40Hr9hNq7keckrs8n3d6qA==
Date:   Thu, 22 Aug 2019 08:43:15 +0000
Message-ID: <20190822084131.114764-5-anup.patel@wdc.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
In-Reply-To: <20190822084131.114764-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [199.255.44.175]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20c9a51c-073d-43ae-db65-08d726dcc5f6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB7070;
x-ms-traffictypediagnostic: MN2PR04MB7070:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7070FCAF3CB8B5D1DA29ACA48DA50@MN2PR04MB7070.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(86362001)(25786009)(110136005)(486006)(316002)(52116002)(446003)(54906003)(76176011)(476003)(11346002)(36756003)(14454004)(8676002)(44832011)(6506007)(81166006)(256004)(386003)(2906002)(99286004)(2616005)(66446008)(81156014)(66556008)(64756008)(66476007)(3846002)(6512007)(4326008)(1076003)(305945005)(7736002)(50226002)(66946007)(53936002)(186003)(26005)(478600001)(6436002)(102836004)(6486002)(5660300002)(71200400001)(6116002)(8936002)(66066001)(71190400001)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7070;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jMqVCWcYCJz88LrA1dyzPUNNITcbSj/1Gd4gbrAEAtOTJXSDq3NHwOXfR0pLerR+Oj+m1KjRhMURawPxsVTQ1rdF9YHh3vZid97chMT2APUR6SLOqjW5kQDERz7HudBYWHHhZyNU2pFamf9mh0e/NNhnbJ0gysu1bJH+CZwkVPe6b4r95oKuzL+4MzqfIma9/TYkCfXE/BybjpXdmbJVV8bJ55bjouOwvCQQvq7ciVXJuwrm9AMu2ZUvgjbqKQgDdYdsetGSPthigr+MmWAu714VViR51eqL7wZrdRPQccFGK3G0wY2WkPZLy/65rroe891HdhzTByfQwOLDqTHRuESHp/zN8UkA5qUBcptmSF6XOWuH6Q1GQ2OVGfTcX7u+hnJGKFLMgpIImDU8gx5ZQNxLgmfOZWpvcNvGp4HLCCk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c9a51c-073d-43ae-db65-08d726dcc5f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:43:15.9980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fQWnKyohC1fyAlIh1NQai1PwfOcmI1PyQdYo89v4VlGlRXJbdARZnsM5Wmx9CivRArNi1jMNf6Qn9mnt492AAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7070
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch extends asm/csr.h by adding RISC-V hypervisor extension
related defines.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/csr.h | 58 ++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index a18923fa23c8..059c5cb22aaf 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -27,6 +27,8 @@
 #define SR_XS_CLEAN	_AC(0x00010000, UL)
 #define SR_XS_DIRTY	_AC(0x00018000, UL)
=20
+#define SR_MXR		_AC(0x00080000, UL)
+
 #ifndef CONFIG_64BIT
 #define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
 #else
@@ -59,10 +61,13 @@
=20
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
@@ -72,6 +77,43 @@
 #define SIE_STIE		(_AC(0x1, UL) << IRQ_S_TIMER)
 #define SIE_SEIE		(_AC(0x1, UL) << IRQ_S_EXT)
=20
+/* HSTATUS flags */
+#define HSTATUS_VTSR		_AC(0x00400000, UL)
+#define HSTATUS_VTVM		_AC(0x00100000, UL)
+#define HSTATUS_SP2V		_AC(0x00000200, UL)
+#define HSTATUS_SP2P		_AC(0x00000100, UL)
+#define HSTATUS_SPV		_AC(0x00000080, UL)
+#define HSTATUS_STL		_AC(0x00000040, UL)
+#define HSTATUS_SPRV		_AC(0x00000001, UL)
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
+#ifdef CONFIG_64BIT
+#define HGATP_PPN		HGATP64_PPN
+#define HGATP_VMID_SHIFT	HGATP64_VMID_SHIFT
+#define HGATP_VMID_MASK		HGATP64_VMID_MASK
+#define HGATP_MODE		(HGATP_MODE_SV39X4 << HGATP64_MODE_SHIFT)
+#else
+#define HGATP_PPN		HGATP32_PPN
+#define HGATP_VMID_SHIFT	HGATP32_VMID_SHIFT
+#define HGATP_VMID_MASK		HGATP32_VMID_MASK
+#define HGATP_MODE		(HGATP_MODE_SV32X4 << HGATP32_MODE_SHIFT)
+#endif
+
 #define CSR_CYCLE		0xc00
 #define CSR_TIME		0xc01
 #define CSR_INSTRET		0xc02
@@ -85,6 +127,22 @@
 #define CSR_STVAL		0x143
 #define CSR_SIP			0x144
 #define CSR_SATP		0x180
+
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
+#define CSR_HGATP		0x680
+
 #define CSR_CYCLEH		0xc80
 #define CSR_TIMEH		0xc81
 #define CSR_INSTRETH		0xc82
--=20
2.17.1

