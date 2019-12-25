Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961AE12A5BA
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 04:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfLYDAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 22:00:53 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:18645 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbfLYDAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 22:00:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577242866; x=1608778866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Izfao+Gt84hom3Z9uqW0gnKHIOz/66lOkq4GRNQT21U=;
  b=o4Wkp5lC2PuKKlO6V2aoKsDEU1ewGYTE/AwBOP3IOS8YAF1ohSFnDEpD
   uVg21uws+V5gZHEe8IjueuDAivM+FkWDduseSejKBblZMEhTxVjO/8JD3
   hJOXXR1l9KoGATLrmcMkWSdn36v7e/WuPZBRQyMKGTFgsO8bnEH45S6Qu
   ql0DUtWXhB8eyZgMfyLsPxV0d6EwHUaYmUPU9uI/YWirqeKg2euNkZhUz
   GRBzoYF6WNm1yID4j1f4NKcmlA4FTQkc7OzRqvb7SBL7+zaif7V130lVt
   78Yl1oGsLhi1ayk1mgFZUkk5SkugZFkxkwh0mokn1j98DfQpS4TOK9nJk
   A==;
IronPort-SDR: Km8FUS3aejlnARf6suqWIzqaisPlmnJUjVcMXCy3FTaZgraIbkyvMwZ8PVITgD4tfeC2iQf4An
 rBI+tQxB72ayIn8BgOK2EzOlSV9P1SaEVGK6lliimVJe5T9fToijU4NomI+9AC/rThhy47jkJg
 Q6t933V0ovXdQEdrgHE/iZhgeo2LDDqRwTJ8SzvSg7/um7R2C8SaE+4N340BVuH/dwDW6R6LBl
 8EyneL75mFNdWbcc5LiDUn4mdQgYl2Na25K6HjDTNxsDc5fRN5i2d0OVXpwuk8PNFUNn0cW7k9
 M38=
X-IronPort-AV: E=Sophos;i="5.69,353,1571673600"; 
   d="scan'208";a="227751832"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 25 Dec 2019 11:00:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DqqYObzlif6Ocga867KI46t05OxkUGTd68mwQhOtuT45S7lErcCQG6jS5K/+qrxRXNK4ygsXcRP8OL77TVYb6LF7cdL+8v++jUPMMCNbEsXCGHXrh9FKeC5PrWdQkLaEwh8D6wLnKM7DTkJq/X1PEoC1Jk/08MgyripK4CUiOK8Ak4yRuTXaoZZWaZ8RlzFE568+dSapWv9HfIqg4v8HVODRHyqaMGwbEay2xczlKYYsK2EKlXrdHw7l9jpwjkPMjlHdN/f4TEX88cTgL5xYny+aehjsjEz9rBZK8wFqGGPB5xNWsCp7xrpBaO22Zu3X0OmCgz8iZLMLOJ9Zb5apjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFaO/JM2jRk0PXpBrVn3x4Zx+/vpep7/B9nOrE04Kak=;
 b=i7XDJa+sk0gCYLXTHU2D9uKy5/0N2JVLg86zNf8e0S/nhoRO+sv8UcdzjEE4dxzL/snFaesKecumDPWZpEMYM3kACbSkW4Dk/sXaz6iXvrA7JByOdSWZ8T4RK7JrzNTxxSF0S992VXiC12qRGezDoDKxb7P667bHuh2FEMbzwoFNW3lY9onicS82PtobSnYAkDEeCItD2rw5VwQ1Nzzh5b7bi7+Bq+pVnHqk6Ske2jP8lk0RaqWH5HUWoYhnghuC3BUJBR9jGYMIydJYVDGIfPVxqDDhs4m5J7uwjXoOjSh9J1IPgzBuMuEzpZtc3CqORsJnxK8ld25ss08eC444YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFaO/JM2jRk0PXpBrVn3x4Zx+/vpep7/B9nOrE04Kak=;
 b=TEOMR7MzyNI5DKckmr0Xhxob1JSj1LGngY5SL+ljk55vb5qRjWDIiFFb0oaYDo3NcA+kRLH/TPVjH0sTP5EIVzTyEB7tLMBz8NsseSj0jbQ8XUkEwAIS9NkUZUkcIRjONrGp0hRG6FM6XJuc86DElDeje6cCfVZGFEcbp1Fy+No=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5597.namprd04.prod.outlook.com (20.179.22.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Wed, 25 Dec 2019 03:00:44 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Wed, 25 Dec 2019
 03:00:44 +0000
Received: from wdc.com (106.51.19.73) by MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Wed, 25 Dec 2019 03:00:41 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH 8/8] riscv: Generate PCI host DT node
Thread-Topic: [kvmtool RFC PATCH 8/8] riscv: Generate PCI host DT node
Thread-Index: AQHVus9/uPMDxJI6OUWRrFMCHyYUcA==
Date:   Wed, 25 Dec 2019 03:00:43 +0000
Message-ID: <20191225025945.108466-9-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 8761b41f-8acc-45ba-f7c7-08d788e6a1e5
x-ms-traffictypediagnostic: MN2PR04MB5597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB559709CC708C5B404B25DC178D280@MN2PR04MB5597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(5660300002)(86362001)(2906002)(4326008)(54906003)(81156014)(81166006)(66946007)(8676002)(1076003)(6916009)(8886007)(71200400001)(44832011)(66556008)(64756008)(1006002)(66446008)(52116002)(66476007)(55236004)(7696005)(16526019)(186003)(316002)(26005)(55016002)(956004)(2616005)(36756003)(478600001)(8936002)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5597;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XhUnMMxEYLgZHuQ74Kps2u+B0LnClfwutt5tywywUR/Cxlphe94REFTg64FY2qZmlExSy2562f69fo+F5bFov0vulxi7NeGkyd3g4S3VPi76l4yPFUGp5KjLQ/yoqx5p0O/XrSFDpcDLWWG8umxAO1b9g030y7FuLXb1TmmjVG5S1QxVu6qJAfZ+JOVb2DCxgtWCb4uDPEjeHrJndRnQ+7Ama8DOdKGbfw3xlIsGs/Tzb+tZyEfF1sGUIlH1GwLuy9Lbj+jJXkCy0+38hrKVF909E9uf/2e8IfkAZy2Tvffj/CPuYEKdn8BycsqwooYADRV5z5+8RbfNWKu4muDjEV62cg95u8ShzuzEkK6N7TY92o6MmqtPrpQ9RESm3BTDbulnE3XThOpTkCaBMdgR04tdEOUwKlVV+OacfU5Xe6yjy4K0mt0vhHbYtj3qn7xYv5WsflTYc9VCnq8mPulZVPr+XY+RzxZNB0tAdJRIfKE2xbzMRrlPwmTTeqbkDq0P
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8761b41f-8acc-45ba-f7c7-08d788e6a1e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2019 03:00:43.8321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdzie6aUY8TUWJA1HYl8hSVBAUl26N49NYuyVOQzD2yclE6SSnPBi6x6UrIkMhoFY8/e1ev6ky+oHNOmCYdesA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5597
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
index 7d3fd73..54a8c69 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -74,4 +74,6 @@ void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_=
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

