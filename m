Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999A414A402
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgA0Mg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:36:27 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:13111 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730616AbgA0Mg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:36:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580128586; x=1611664586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZvjWRtrU6EIIRWFQ/zz/jAJPFYViSnAFES2NH+jJW2U=;
  b=Mqa4msjyIj/MGNbSsUq2fgGhMAlcYB0BwqPTpiIoPdQ6uhMTN9TgUCPU
   f4fjuW3efqf2eQugz610CznPAygfRuzw+0Sx7oTo2ccHfJ/tM7e7Pia3d
   g7VOwiUUJ0Y1gShqpZQ0szACiUdS6RaeP1YSMAtc31HnhjRtSADy3tNOh
   u0rYs6hjzhlJ6xYZ6E6k9wrdYGJAXmPOSnqEyMvnmv52gHBDk18lSSKl8
   z3c+O6ESF0ZYO9Yub/Z5rd+R9IKdFD4iXrRVbNeJnGNw6wimFAcUOwvma
   FodoqNsLwRC3ZkHSRL5dV7E/2KYzRFrL745DSHlw6X0ngl4JwyFg7AP+g
   A==;
IronPort-SDR: 29pnJrfV2U+6+vnIYMhNqcZStGUPleH0ae2+i5nP8bSnzOaogZiV9SutXH/DNPl647mjHfTrD4
 ELuhs5sz9w/NWxWz+NOJDNWj4Op5gFthHVVYoWl9ssgW18JdL3XSvjbc3xy9rhsHTxQAFGHSFj
 oUFEngVyiT+EYX/RQXJtLUXpcpe9Lan4mKORdtE+/eoSektIPlDZuXSD3yj6AGCS+9eaTmf+go
 pCKum855sFyzoNtKJrF3poetxVcB9fdqyEa5fKBOufr3kJTgda0/Cm8dD1vRyjPQptiGx8n0db
 qDU=
X-IronPort-AV: E=Sophos;i="5.70,369,1574092800"; 
   d="scan'208";a="129933654"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 20:36:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9dH9mHeQmEgjPXjoEmB1P9FyYGhiPbl05tRZesiJoJlobZTU0kTBtfn5CN7jCyyhsKw/Qm/0ZoIjlS/DX4jtWRgrMT2zPhgSH8l7LKZZ+i2kcRnsknLfUfZroLPPHb2tsBCSkvQWTh9enMBKRniFaeBFnk3ZegrQEYjPD+P6lgyOJIJyF0TyggChpal0dYNluLKnAbE0mJiUpPmC7/oVJGItEbPmRU+mNpSaoplqj/5gt9ABNoo3z4yjUVhku1YWPL0+rvlFxO7jSb6MB5rKoPfAlVfI5RyGY52Hvhit4bvKcG+/BqzHiAUissWg9vzkwMcg5+NTfBYnY8n65AdhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpA0uLYbbz5x7AssKMq0EyoGn2ahJf7e+H7OuiK77ys=;
 b=f+uuHyAlqkQUI7U7VBWAYNsRSZ8yE+PIx+g7svr5iZjNKu10u9ufBLH3ls+RWmjASfdzio7iu0Lmuawjn8JUHcNb0BnTjvBSYxSTWTMEt/9xQJk1zJX5i/zilacsTq5Gd4dDavvx3KGovbO+NhPgGvHLJccWeLgyzJGl3AExJAWFMRqAF7/HY16ShfxBulzlJ2uldvZ9Uu6HNMWPi0STn8xjtVXhjCQ5pSDyALdcUY8JV1ifrBgrRiD9hBlyBIdMNFGUuzq5DFhsePjqSa7P7bQ6ie3XOyRisZoI0ISagv5gh3hcfkiWQ88sekB2e6ot8a/jl11GN+6gYiCiVLw6Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpA0uLYbbz5x7AssKMq0EyoGn2ahJf7e+H7OuiK77ys=;
 b=YANQEcfmgi55HjV+QcOonIglydE9P75vOXP/+rXcoOeF58Bs1ZPAc5IZXKnPdsTbDSq+DmjcICFlSxKfvEgPCk8Exnl4vf24uOIcWHT59JKkCKb6tYosxQrIW+0/B5JiT4X6o3Hc3uD9uho1ctFIcVeoABAJRBu1EDdD3Fx92Fo=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6816.namprd04.prod.outlook.com (10.186.145.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 12:36:24 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 12:36:24 +0000
Received: from wdc.com (49.207.48.168) by MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 12:36:21 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH v2 6/8] riscv: Generate FDT at runtime for
 Guest/VM
Thread-Topic: [kvmtool RFC PATCH v2 6/8] riscv: Generate FDT at runtime for
 Guest/VM
Thread-Index: AQHV1Q5j/XN2WpXE20GdlRGXgIQOWw==
Date:   Mon, 27 Jan 2020 12:36:24 +0000
Message-ID: <20200127123527.106825-7-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: b0016c4a-70a6-471c-09a4-08d7a3258585
x-ms-traffictypediagnostic: MN2PR04MB6816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6816230F48131C6A8970CE858D0B0@MN2PR04MB6816.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:31;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(44832011)(5660300002)(2906002)(55236004)(54906003)(86362001)(7696005)(4326008)(55016002)(478600001)(2616005)(81156014)(956004)(8676002)(52116002)(81166006)(1076003)(8886007)(8936002)(71200400001)(66946007)(26005)(1006002)(66476007)(6916009)(66556008)(64756008)(16526019)(316002)(66446008)(36756003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6816;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZG631Tr3q4hcvdoPtMgInwOQb2rklna0dD1h2O0xAAbypeVriUDwLHAqbNXkwHRgIGeVwXY8EL+UMp3XNNIjWigGQlfqfJWv54Rie8WqBjc+kgRfgd15KTuElJ+4N4UaVtQ2yZlmAn35pDtzvGhZrPhbyvXXsVwmZeu+FLB/X33ArQ7EvIvlpKIlOwiC4tX8UQW5o9eV0fC4GdP/W4RoXWMXW0KOOqcC/vXxQafaUm7C5vjiKHEzP6I14sLskNbfdHeibHTsDYX+uIAGCeVfm5g6gj/rYzyh2ZYWaCzhShGL7np1KQ31pdygLiZPTHI2Y1/OrOWMbvHtwLsZat22tEMmsMjPlVGyWpEQ8fpor5bLQiHPdNlGTaI2Po8OEOmNWZ0sBFwPB/FQplktkMgemTW/gvcC1SFvUnnHDkL69oIraVmXyQqgU7ebVjbm9OhH
x-ms-exchange-antispam-messagedata: 47QrVpO17Xy3L8bxIVhB2YMcWJ/6DDkMdiXpcFlseY3eXpBpCHmZhuJX05XsRH37ttC9NHWuf7vkuiwUMTMleypaTojtOM7/NC69VBmcQYIZ9O4h0Ml1ZiRsu8K7UdY8yi6napySadxiFeS7t6CB1Q==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0016c4a-70a6-471c-09a4-08d7a3258585
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 12:36:24.6909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rgzmj4uqUFsFK3CRwzWxpmDWqEiQRPKN3PZ8QOXjRQS5217gAZE0gYykVFVMuIInsoO6vLhfDb2SDbvZSnftiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6816
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We generate FDT at runtime for RISC-V Guest/VM so that KVMTOOL users
don't have to pass FDT separately via command-line parameters.

Also, we provide "--dump-dtb <filename>" command-line option to dump
generated FDT into a file for debugging purpose.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Makefile                            |   1 +
 riscv/fdt.c                         | 192 ++++++++++++++++++++++++++++
 riscv/include/kvm/fdt-arch.h        |   4 +
 riscv/include/kvm/kvm-arch.h        |   2 +
 riscv/include/kvm/kvm-config-arch.h |   6 +
 riscv/plic.c                        |  50 ++++++++
 6 files changed, 255 insertions(+)
 create mode 100644 riscv/fdt.c

diff --git a/Makefile b/Makefile
index 3220ad3..fb78fa2 100644
--- a/Makefile
+++ b/Makefile
@@ -196,6 +196,7 @@ endif
 ifeq ($(ARCH),riscv)
 	DEFINES		+=3D -DCONFIG_RISCV
 	ARCH_INCLUDE	:=3D riscv/include
+	OBJS		+=3D riscv/fdt.o
 	OBJS		+=3D riscv/ioport.o
 	OBJS		+=3D riscv/irq.o
 	OBJS		+=3D riscv/kvm.o
diff --git a/riscv/fdt.c b/riscv/fdt.c
new file mode 100644
index 0000000..3b56e30
--- /dev/null
+++ b/riscv/fdt.c
@@ -0,0 +1,192 @@
+#include "kvm/devices.h"
+#include "kvm/fdt.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+
+#include <stdbool.h>
+
+#include <linux/byteorder.h>
+#include <linux/kernel.h>
+#include <linux/sizes.h>
+
+static void dump_fdt(const char *dtb_file, void *fdt)
+{
+	int count, fd;
+
+	fd =3D open(dtb_file, O_CREAT | O_TRUNC | O_RDWR, 0666);
+	if (fd < 0)
+		die("Failed to write dtb to %s", dtb_file);
+
+	count =3D write(fd, fdt, FDT_MAX_SIZE);
+	if (count < 0)
+		die_perror("Failed to dump dtb");
+
+	pr_debug("Wrote %d bytes to dtb %s", count, dtb_file);
+	close(fd);
+}
+
+#define CPU_NAME_MAX_LEN 15
+#define CPU_ISA_MAX_LEN 128
+static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
+{
+	int cpu, pos, i, index, valid_isa_len;
+	const char *valid_isa_order =3D "IEMAFDQCLBJTPVNSUHKORWXYZG";
+
+	_FDT(fdt_begin_node(fdt, "cpus"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x0));
+	_FDT(fdt_property_cell(fdt, "timebase-frequency",
+				kvm->cpus[0]->riscv_timebase));
+
+	for (cpu =3D 0; cpu < kvm->nrcpus; ++cpu) {
+		char cpu_name[CPU_NAME_MAX_LEN];
+		char cpu_isa[CPU_ISA_MAX_LEN];
+		struct kvm_cpu *vcpu =3D kvm->cpus[cpu];
+
+		snprintf(cpu_name, CPU_NAME_MAX_LEN, "cpu@%x", cpu);
+
+		snprintf(cpu_isa, CPU_ISA_MAX_LEN, "rv%ld", vcpu->riscv_xlen);
+		pos =3D strlen(cpu_isa);
+		valid_isa_len =3D strlen(valid_isa_order);
+		for (i =3D 0; i < valid_isa_len; i++) {
+			index =3D valid_isa_order[i] - 'A';
+			if (vcpu->riscv_isa & (1 << (index)))
+				cpu_isa[pos++] =3D 'a' + index;
+		}
+		cpu_isa[pos] =3D '\0';
+
+		_FDT(fdt_begin_node(fdt, cpu_name));
+		_FDT(fdt_property_string(fdt, "device_type", "cpu"));
+		_FDT(fdt_property_string(fdt, "compatible", "riscv"));
+		if (vcpu->riscv_xlen =3D=3D 64)
+			_FDT(fdt_property_string(fdt, "mmu-type",
+						 "riscv,sv48"));
+		else
+			_FDT(fdt_property_string(fdt, "mmu-type",
+						 "riscv,sv32"));
+		_FDT(fdt_property_string(fdt, "riscv,isa", cpu_isa));
+		_FDT(fdt_property_cell(fdt, "reg", cpu));
+		_FDT(fdt_property_string(fdt, "status", "okay"));
+
+		_FDT(fdt_begin_node(fdt, "interrupt-controller"));
+		_FDT(fdt_property_string(fdt, "compatible", "riscv,cpu-intc"));
+		_FDT(fdt_property_cell(fdt, "#interrupt-cells", 1));
+		_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+		_FDT(fdt_property_cell(fdt, "phandle",
+					PHANDLE_CPU_INTC_BASE + cpu));
+		_FDT(fdt_end_node(fdt));
+
+		_FDT(fdt_end_node(fdt));
+	}
+
+	_FDT(fdt_end_node(fdt));
+}
+
+static int setup_fdt(struct kvm *kvm)
+{
+	struct device_header *dev_hdr;
+	u8 staging_fdt[FDT_MAX_SIZE];
+	u64 mem_reg_prop[]	=3D {
+		cpu_to_fdt64(kvm->arch.memory_guest_start),
+		cpu_to_fdt64(kvm->ram_size),
+	};
+	void *fdt		=3D staging_fdt;
+	void *fdt_dest		=3D guest_flat_to_host(kvm,
+						     kvm->arch.dtb_guest_start);
+	void (*generate_mmio_fdt_nodes)(void *, struct device_header *,
+					void (*)(void *, u8, enum irq_type));
+
+	/* Create new tree without a reserve map */
+	_FDT(fdt_create(fdt, FDT_MAX_SIZE));
+	_FDT(fdt_finish_reservemap(fdt));
+
+	/* Header */
+	_FDT(fdt_begin_node(fdt, ""));
+	_FDT(fdt_property_cell(fdt, "interrupt-parent", PHANDLE_PLIC));
+	_FDT(fdt_property_string(fdt, "compatible", "linux,dummy-virt"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
+
+	/* /chosen */
+	_FDT(fdt_begin_node(fdt, "chosen"));
+
+	/* Pass on our amended command line to a Linux kernel only. */
+	if (kvm->cfg.firmware_filename) {
+		if (kvm->cfg.kernel_cmdline)
+			_FDT(fdt_property_string(fdt, "bootargs",
+						 kvm->cfg.kernel_cmdline));
+	} else
+		_FDT(fdt_property_string(fdt, "bootargs",
+					 kvm->cfg.real_cmdline));
+
+	_FDT(fdt_property_string(fdt, "stdout-path", "serial0"));
+
+	/* Initrd */
+	if (kvm->arch.initrd_size !=3D 0) {
+		u64 ird_st_prop =3D cpu_to_fdt64(kvm->arch.initrd_guest_start);
+		u64 ird_end_prop =3D cpu_to_fdt64(kvm->arch.initrd_guest_start +
+					       kvm->arch.initrd_size);
+
+		_FDT(fdt_property(fdt, "linux,initrd-start",
+				   &ird_st_prop, sizeof(ird_st_prop)));
+		_FDT(fdt_property(fdt, "linux,initrd-end",
+				   &ird_end_prop, sizeof(ird_end_prop)));
+	}
+
+	_FDT(fdt_end_node(fdt));
+
+	/* Memory */
+	_FDT(fdt_begin_node(fdt, "memory"));
+	_FDT(fdt_property_string(fdt, "device_type", "memory"));
+	_FDT(fdt_property(fdt, "reg", mem_reg_prop, sizeof(mem_reg_prop)));
+	_FDT(fdt_end_node(fdt));
+
+	/* CPUs */
+	generate_cpu_nodes(fdt, kvm);
+
+	/* Simple Bus */
+	_FDT(fdt_begin_node(fdt, "smb"));
+	_FDT(fdt_property_string(fdt, "compatible", "simple-bus"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
+	_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+	/* Virtio MMIO devices */
+	dev_hdr =3D device__first_dev(DEVICE_BUS_MMIO);
+	while (dev_hdr) {
+		generate_mmio_fdt_nodes =3D dev_hdr->data;
+		generate_mmio_fdt_nodes(fdt, dev_hdr, plic__generate_irq_prop);
+		dev_hdr =3D device__next_dev(dev_hdr);
+	}
+
+	/* IOPORT devices */
+	dev_hdr =3D device__first_dev(DEVICE_BUS_IOPORT);
+	while (dev_hdr) {
+		generate_mmio_fdt_nodes =3D dev_hdr->data;
+		generate_mmio_fdt_nodes(fdt, dev_hdr, plic__generate_irq_prop);
+		dev_hdr =3D device__next_dev(dev_hdr);
+	}
+
+	_FDT(fdt_end_node(fdt));
+
+	if (fdt_stdout_path) {
+		_FDT(fdt_begin_node(fdt, "aliases"));
+		_FDT(fdt_property_string(fdt, "serial0", fdt_stdout_path));
+		_FDT(fdt_end_node(fdt));
+
+		free(fdt_stdout_path);
+		fdt_stdout_path =3D NULL;
+	}
+
+	/* Finalise. */
+	_FDT(fdt_end_node(fdt));
+	_FDT(fdt_finish(fdt));
+
+	_FDT(fdt_open_into(fdt, fdt_dest, FDT_MAX_SIZE));
+	_FDT(fdt_pack(fdt_dest));
+
+	if (kvm->cfg.arch.dump_dtb_filename)
+		dump_fdt(kvm->cfg.arch.dump_dtb_filename, fdt_dest);
+	return 0;
+}
+late_init(setup_fdt);
diff --git a/riscv/include/kvm/fdt-arch.h b/riscv/include/kvm/fdt-arch.h
index 9450fc5..f7548e8 100644
--- a/riscv/include/kvm/fdt-arch.h
+++ b/riscv/include/kvm/fdt-arch.h
@@ -1,4 +1,8 @@
 #ifndef KVM__KVM_FDT_H
 #define KVM__KVM_FDT_H
=20
+enum phandles {PHANDLE_RESERVED =3D 0, PHANDLE_PLIC, PHANDLES_MAX};
+
+#define PHANDLE_CPU_INTC_BASE	PHANDLES_MAX
+
 #endif /* KVM__KVM_FDT_H */
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 20e9f09..630cd6b 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -76,6 +76,8 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_a=
ddr)
=20
 enum irq_type;
=20
+void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
+
 void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
=20
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-co=
nfig-arch.h
index 60c7333..526fca2 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -4,6 +4,12 @@
 #include "kvm/parse-options.h"
=20
 struct kvm_config_arch {
+	const char	*dump_dtb_filename;
 };
=20
+#define OPT_ARCH_RUN(pfx, cfg)						\
+	pfx,								\
+	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
+		   ".dtb file", "Dump generated .dtb to specified file"),
+
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/riscv/plic.c b/riscv/plic.c
index 93bfbc5..1112d16 100644
--- a/riscv/plic.c
+++ b/riscv/plic.c
@@ -1,5 +1,6 @@
=20
 #include "kvm/devices.h"
+#include "kvm/fdt.h"
 #include "kvm/ioeventfd.h"
 #include "kvm/ioport.h"
 #include "kvm/kvm.h"
@@ -455,6 +456,54 @@ static void plic__mmio_callback(struct kvm_cpu *vcpu,
 	}
 }
=20
+void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
+{
+	u32 irq_prop[] =3D {
+		cpu_to_fdt32(irq)
+	};
+
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+}
+
+static void plic__generate_fdt_node(void *fdt,
+				    struct device_header *dev_hdr,
+				    void (*generate_irq_prop)(void *fdt,
+							      u8 irq,
+							      enum irq_type))
+{
+	u32 i;
+	u32 reg_cells[4], *irq_cells;
+
+	reg_cells[0] =3D 0;
+	reg_cells[1] =3D cpu_to_fdt32(RISCV_PLIC);
+	reg_cells[2] =3D 0;
+	reg_cells[3] =3D cpu_to_fdt32(RISCV_PLIC_SIZE);
+
+	irq_cells =3D calloc(plic.num_context * 2, sizeof(u32));
+	if (!irq_cells)
+		die("Failed to alloc irq_cells");
+
+	_FDT(fdt_begin_node(fdt, "interrupt-controller@0c000000"));
+	_FDT(fdt_property_string(fdt, "compatible", "riscv,plic0"));
+	_FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 1));
+	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+	_FDT(fdt_property_cell(fdt, "riscv,max-priority", plic.max_prio));
+	_FDT(fdt_property_cell(fdt, "riscv,ndev", MAX_DEVICES));
+	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_PLIC));
+	for (i =3D 0; i < (plic.num_context / 2); i++) {
+		irq_cells[4*i + 0] =3D cpu_to_fdt32(PHANDLE_CPU_INTC_BASE + i);
+		irq_cells[4*i + 1] =3D cpu_to_fdt32(0xffffffff);
+		irq_cells[4*i + 2] =3D cpu_to_fdt32(PHANDLE_CPU_INTC_BASE + i);
+		irq_cells[4*i + 3] =3D cpu_to_fdt32(9);
+	}
+	_FDT(fdt_property(fdt, "interrupts-extended", irq_cells,
+			  sizeof(u32) * plic.num_context * 2));
+	_FDT(fdt_end_node(fdt));
+
+	free(irq_cells);
+}
+
 static int plic__init(struct kvm *kvm)
 {
 	u32 i;
@@ -463,6 +512,7 @@ static int plic__init(struct kvm *kvm)
 	plic.kvm =3D kvm;
 	plic.dev_hdr =3D (struct device_header) {
 		.bus_type	=3D DEVICE_BUS_MMIO,
+		.data		=3D plic__generate_fdt_node,
 	};
=20
 	plic.num_irq =3D MAX_DEVICES;
--=20
2.17.1

