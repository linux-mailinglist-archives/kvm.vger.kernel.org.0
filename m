Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AA914A404
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgA0Mgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:36:38 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24731 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730435AbgA0Mgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:36:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580128614; x=1611664614;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SbeK9Hebz86LI1Y54XQ+0p/vaqjOc8twgMZgiEuEbTA=;
  b=Lh+0a62tW3+my0wK9PAlI2QVPMMRrqcKhlae7rEA8uLEb1WNiR3HTaEh
   E/eNkiHythXXCf5r+Ufw+J9H6z9p6YuCqZSBtHgXOMHXv6fv3c2KRxzWO
   I18V1IAoiYWb7e3Iiud0x57snDq9rx9dspRli5djigcGVdP9mP2brgxxU
   eKsHX8i+Q2/wu4brUnnHnd7xhHvWCw33/oB3y+aMcRb/ZzARPKUpP1i3R
   TNcQdP8Na6bwlgB3slYOZXFBPXeh4oUTrVSE0VKG50Rs7ZXhIhSAySg5n
   mDx/NHVi2pwVDsL7tmV5R5CQ+mtLhwG98BnVzvzMvL1PxV/7JYfh1DJOZ
   Q==;
IronPort-SDR: 5t16P07Soei8KE8fYfCqCwBRw3iBasb/US/TUSMJ69TcfrNSQBggVrt2MTCl/vxU+ZmStvcm9B
 rPL+xHp5jJWnRoBxfP3NokLgL6pG+0jRO2YPpdGud5R1LVNJHDANvMBsb4F/+V7z4xbx16h03e
 4rUcqMMhyzuTu91LDD7SHSzwisCc096BF74+FVFTNpF/DBHwJtc4G2to/8C7T6iMCroClyq/iY
 0w9mnQhductRcGlpB5D9RDbnYMbo8wCvSDDp2Xst9glgixWRmpnW0gLTQbTzVpGSuG3AoIzNCz
 SfY=
X-IronPort-AV: E=Sophos;i="5.70,369,1574092800"; 
   d="scan'208";a="230173202"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 20:36:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIsj5Z4kBZDI2QjHSN1+dEqw3ZBUf3FmZlII6WWsi5KtKRB0Z+bAxYE982u3o7AftzwB120Ll9FJhv/kguewx2+DXKPl+lZwDwljIp6EBFmzr7mpa1W8cy8KT88mwzPcykiwz9BR7jwwPI+Z0woQqbMmrsB3G3LQSMvU3fgKgaG/RqV2MjnJyKlUBzqFcTbHebAf1oMlkqZqjbrj+Wbwg09RaoO5NKTfHlOMVm/dMMriOrg7Ie12dVDMNVS8TuRMx+YvNquI4VAhSfwRBRCaAnfitaCzyZzXRqFJNKg9ooovgjxTSb0aTj4XHuckyjGEuvqvPIzQxjMOyCFFEuG78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQog6pF+V8Jm58Se3xHIwh/8szeNbCRXd0YvA+n0VZ0=;
 b=H1Oc04JmAqFsx+xFU1Pn+yvF0bEVc7LV3R6mitOzl4u0dnFdF/iBVzWA/cQG9NAOa3PJcSdKn2mXq2g8SLnBIs3M3orV48aApigXas/EVCzqQ2f66MaY61mB6lIGZl13RQC0Kz0v6AO8NA2wxH7bX2IlAfdzz2oimwIZzFRTsLmOx7Z9LPsUWYWSUEFpHPKmo6sOMsZmzPuW5ZQs2IjT0BkXhCPeN/93fGt+hsgKGPINIg+GX3S1LK5b5hbVpEGLBJE2xDKjloKOzRwmb8j744Rm/GUV59ftn/lF/h3x1bI/vVD2YLQBsWVzEegBwk3nL5zWhoa5M4wzy/WpdnT8ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQog6pF+V8Jm58Se3xHIwh/8szeNbCRXd0YvA+n0VZ0=;
 b=I6uHTi6CfDd0C2IVa5kg4tNDHWRU02zCEr6j5nDp490QdsGswCS26rhPYw/dKcJcAaF4OMhBPO3HyCJb7Gll6txt6ue59B2YpUaaMCKdxHJkaQEgX3nfAtEq+bmKpTv84RclwklZeS2HJ9mu/ti2vWArNpd71XBjmL/VxUcmtQs=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6816.namprd04.prod.outlook.com (10.186.145.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 12:36:35 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 12:36:35 +0000
Received: from wdc.com (49.207.48.168) by MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 12:36:32 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH v2 8/8] riscv: Generate PCI host DT node
Thread-Topic: [kvmtool RFC PATCH v2 8/8] riscv: Generate PCI host DT node
Thread-Index: AQHV1Q5pc9nInC2qUkaALyDT8Pfpcw==
Date:   Mon, 27 Jan 2020 12:36:35 +0000
Message-ID: <20200127123527.106825-9-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: d0640c0b-6b45-4e13-7389-08d7a3258c01
x-ms-traffictypediagnostic: MN2PR04MB6816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6816EB17C93F782CD1C724FE8D0B0@MN2PR04MB6816.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(44832011)(5660300002)(2906002)(55236004)(54906003)(86362001)(7696005)(4326008)(55016002)(478600001)(2616005)(81156014)(956004)(8676002)(52116002)(81166006)(1076003)(8886007)(8936002)(71200400001)(66946007)(26005)(1006002)(66476007)(6916009)(66556008)(64756008)(16526019)(316002)(66446008)(36756003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6816;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sk7Ss1JSQmnVpGd90o7+c/kXV+HN/JOMEbD7oFBW/GkMqCMnA31HJ8H7ixbQoEat3EXkLXDzs5RvF4OzTe+qa2Vfq77TisjUUBF3PEl4whEPxs32KhdAFTd0Q2LAyB7hrW1p/5p8HfFMcIHlbw4fwPgSrYMbEvrZSHOAKdaCVYnIve8xWQ7UuSJ7qFoouQh83TcB6BPzW7+owrcYnmo1DGzQFfpHuUY66l3pEpU2Q24CifuA6FsZGyKl2UyvvYZJeG6O80mblb08YFQFl40bZTCujXSDPl3VNL6EaBlMjA+3KQyE46c/uKxaVgckCR5OB8Oh/qmdV503ybubzpJrmGQeZT/O2ceIdpL9Gmtqq7WL2TK/QAxL1Cu4hk9dF/3jb6vlvhxHB8xz9BjhhuvhXY1QimevcqHsBcfHlxwLqxQU4udKkyXzT9p3FVaPeyTF
x-ms-exchange-antispam-messagedata: x5gvCcGtHO9sR4wpbCLEBkRENmI3EmmgBB+D9TiD33xgn6aqMD3msi/i1+95FmXBR0q0Nsj7WTZCpZz1qTM20lN0rd2AhM463Lhp3cFG0BHEEd3EoesNUZpz3O7yLb5NLOKi5XDbH3lYwGLhZ8sDGQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0640c0b-6b45-4e13-7389-08d7a3258c01
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 12:36:35.5906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nIMzJPLCYfOOY3mfHmNXz27/qiK4MQWQECmqcXNS1cVS1WIjPS5rGbnp1EJ4JFHXMrEgUR0vvMk69HWOoBUqBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6816
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch extends FDT generation to generate PCI host DT node.

Of course, PCI host for Guest/VM is not useful at the moment
because it's mostly for PCI pass-through and we don't have
IOMMU and interrupt routing available for KVM RISC-V. In future,
we might be able to use PCI host for VirtIO PCI transport or
other software emulated PCI devices.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Makefile                     |   1 +
 riscv/fdt.c                  |   3 +
 riscv/include/kvm/kvm-arch.h |   2 +
 riscv/pci.c                  | 109 +++++++++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+)
 create mode 100644 riscv/pci.c

diff --git a/Makefile b/Makefile
index fb78fa2..fa5e4f7 100644
--- a/Makefile
+++ b/Makefile
@@ -201,6 +201,7 @@ ifeq ($(ARCH),riscv)
 	OBJS		+=3D riscv/irq.o
 	OBJS		+=3D riscv/kvm.o
 	OBJS		+=3D riscv/kvm-cpu.o
+	OBJS		+=3D riscv/pci.o
 	OBJS		+=3D riscv/plic.o
=20
 	ARCH_WANT_LIBFDT :=3D y
diff --git a/riscv/fdt.c b/riscv/fdt.c
index 3b56e30..fc8aa88 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -167,6 +167,9 @@ static int setup_fdt(struct kvm *kvm)
 		dev_hdr =3D device__next_dev(dev_hdr);
 	}
=20
+	/* PCI host controller */
+	pci__generate_fdt_nodes(fdt);
+
 	_FDT(fdt_end_node(fdt));
=20
 	if (fdt_stdout_path) {
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 630cd6b..bc66e3b 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -80,4 +80,6 @@ void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_=
type irq_type);
=20
 void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
=20
+void pci__generate_fdt_nodes(void *fdt);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/pci.c b/riscv/pci.c
new file mode 100644
index 0000000..666a452
--- /dev/null
+++ b/riscv/pci.c
@@ -0,0 +1,109 @@
+#include "kvm/devices.h"
+#include "kvm/fdt.h"
+#include "kvm/kvm.h"
+#include "kvm/of_pci.h"
+#include "kvm/pci.h"
+#include "kvm/util.h"
+
+/*
+ * An entry in the interrupt-map table looks like:
+ * <pci unit address> <pci interrupt pin> <plic phandle> <plic interrupt>
+ */
+
+struct of_interrupt_map_entry {
+	struct of_pci_irq_mask		pci_irq_mask;
+	u32				plic_phandle;
+	u32				plic_irq;
+} __attribute__((packed));
+
+void pci__generate_fdt_nodes(void *fdt)
+{
+	struct device_header *dev_hdr;
+	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
+	unsigned nentries =3D 0;
+	/* Bus range */
+	u32 bus_range[] =3D { cpu_to_fdt32(0), cpu_to_fdt32(1), };
+	/* Configuration Space */
+	u64 cfg_reg_prop[] =3D { cpu_to_fdt64(KVM_PCI_CFG_AREA),
+			       cpu_to_fdt64(RISCV_PCI_CFG_SIZE), };
+	/* Describe the memory ranges */
+	struct of_pci_ranges_entry ranges[] =3D {
+		{
+			.pci_addr =3D {
+				.hi	=3D cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_IO)),
+				.mid	=3D 0,
+				.lo	=3D 0,
+			},
+			.cpu_addr	=3D cpu_to_fdt64(KVM_IOPORT_AREA),
+			.length		=3D cpu_to_fdt64(RISCV_IOPORT_SIZE),
+		},
+		{
+			.pci_addr =3D {
+				.hi	=3D cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_M32)),
+				.mid	=3D cpu_to_fdt32(KVM_PCI_MMIO_AREA >> 32),
+				.lo	=3D cpu_to_fdt32(KVM_PCI_MMIO_AREA),
+			},
+			.cpu_addr	=3D cpu_to_fdt64(KVM_PCI_MMIO_AREA),
+			.length		=3D cpu_to_fdt64(RISCV_PCI_MMIO_SIZE),
+		},
+	};
+
+	/* Boilerplate PCI properties */
+	_FDT(fdt_begin_node(fdt, "pci"));
+	_FDT(fdt_property_string(fdt, "device_type", "pci"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x3));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 0x1));
+	_FDT(fdt_property_string(fdt, "compatible", "pci-host-cam-generic"));
+	_FDT(fdt_property(fdt, "dma-coherent", NULL, 0));
+
+	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
+	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
+	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
+
+	/* Generate the interrupt map ... */
+	dev_hdr =3D device__first_dev(DEVICE_BUS_PCI);
+	while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
+		struct of_interrupt_map_entry *entry =3D &irq_map[nentries];
+		struct pci_device_header *pci_hdr =3D dev_hdr->data;
+		u8 dev_num =3D dev_hdr->dev_num;
+		u8 pin =3D pci_hdr->irq_pin;
+		u8 irq =3D pci_hdr->irq_line;
+
+		*entry =3D (struct of_interrupt_map_entry) {
+			.pci_irq_mask =3D {
+				.pci_addr =3D {
+					.hi	=3D cpu_to_fdt32(of_pci_b_ddddd(dev_num)),
+					.mid	=3D 0,
+					.lo	=3D 0,
+				},
+				.pci_pin	=3D cpu_to_fdt32(pin),
+			},
+			.plic_phandle	=3D cpu_to_fdt32(PHANDLE_PLIC),
+			.plic_irq	=3D cpu_to_fdt32(irq),
+		};
+
+		nentries++;
+		dev_hdr =3D device__next_dev(dev_hdr);
+	}
+
+	_FDT(fdt_property(fdt, "interrupt-map", irq_map,
+			  sizeof(struct of_interrupt_map_entry) * nentries));
+
+	/* ... and the corresponding mask. */
+	if (nentries) {
+		struct of_pci_irq_mask irq_mask =3D {
+			.pci_addr =3D {
+				.hi	=3D cpu_to_fdt32(of_pci_b_ddddd(-1)),
+				.mid	=3D 0,
+				.lo	=3D 0,
+			},
+			.pci_pin	=3D cpu_to_fdt32(7),
+		};
+
+		_FDT(fdt_property(fdt, "interrupt-map-mask", &irq_mask,
+				  sizeof(irq_mask)));
+	}
+
+	_FDT(fdt_end_node(fdt));
+}
--=20
2.17.1

