Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECAF12A5B5
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 04:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLYDA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 22:00:26 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60709 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLYDA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 22:00:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577242825; x=1608778825;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k8WkmdrxvXeWgu5n6ykO2rJL05Hd2wL5SpZ+PJ49JA4=;
  b=Ji313gdQ1m+9CoAH2Wmv3HW6a5+F2E6oqTVncw32CDZGKa9eJxmmY+Gb
   42/YszP4e0cBCEf2hFhZjXU7YPLg/oLMiLrYoKd6lDqKOQucD4WL4LmUr
   wb9gEM7Kqurnwo+lE6KoQAVgVU16pQEfuJJUQopBQ9tqOK+VaxK4u79c+
   chky9YJll/6Y66lrDpwgln5WVo5KDnhYgyFklUdOWwXh/TA5ktVlTSP5x
   a5AWyFsyTZTw2ewHLnMV0a82qCQ9bIItWBuzOfX20ixdH1bjVBWXQuk5g
   tiZsrqhQew6JI3jDADt4azD+haA7xaZgAx8d+EfErj6o5hkUmcZoON5Or
   Q==;
IronPort-SDR: 5ADsdxV0X6SeV6stwABHtoMLQOf/F7zGnF9ippnx8ZJrXnFY/2OxcXj7tGWeYFnw1Ac+vhhyPi
 uu1UFL0AbrMvJDfn79e3ubr3HP7R49SVRbKgl9eg3nCFtzh7rozYdyjkvpW95TU0/tainSauf0
 RKvRElH6XNVYpu1U7czWmLsWnHjjUpVBL+QaDx5hqPVx2WU3T10IZ4YjYcVpVQze4aUtbYxVXF
 GGh0LYtZyLSkImMIHwuQ4Eo7+yiBsaEdUJC5HcPjTMzzwEENlFx5eoYOSfK7QvHKK5H4f0Ndor
 lIk=
X-IronPort-AV: E=Sophos;i="5.69,353,1571673600"; 
   d="scan'208";a="126854676"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 25 Dec 2019 11:00:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObUGP7x1T2A/jItFajdCveZqMKUbxoa+Eq5Qdwi9nG/2YR3sh9+qb58sZ87XHo3jAqtP1WLF1gZBwBdImLK11zdnlAxtKfV4Y1gHIbrbyqGqVFZFxrTx7LLGCX2VicKEkxbCzH5Kq79LuHYZK7263mvWsgiYAxtdqHpt9gS2Gk1NO9KGrXJvil4FASW3JR3jpB7ef1u9IqA1rZPoiN3IkNwzpHAAotwXX2c0kdKS6KO2ySPoXUVmsvtao2NiCyW06I3KhsCOF3AWGZEu9dMQvvMHx/8CgZd2jiXc/sXDHXG/S8FYF3mC3yuiyEt/K6meYn4YrC8FcJ1T7Mf6W1/UhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOtboORL9ajL1bx5qrvZnUWRgxAEXMgYbS1kOaciHQM=;
 b=KyrNvHArf1tXvGRZ4LCnj0sf5mh7Fz7w+a5n0wq7ozpTZi4Glc2sVE9pDIMYg+SEbJ/k84GXQkDAySN53jcXcIECaF+ofywk36M5yV9q5CRyuRAQenaxbs6cJYAJ9KmAqhlKvNIQRRL1YM5OuGj0jsP28oEyqNBxJMdBY1QGuJdpgiFEtlEpmYRDWILguS6LkLQ12i/3EG9HS8+3S7WITHAN86yYdRBJZQUq+pkEWovyA2x4ErVLrl592oLT9oBoRvzliBQMha1/M4pRiLoF+E76/jJs3Bi+yA2CpaK4KV+7n+gHfIiYHUy5OsdEnPwsmHq3N/xQ10l+Nq1173fu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOtboORL9ajL1bx5qrvZnUWRgxAEXMgYbS1kOaciHQM=;
 b=nlit+WP91oPxXRScCAY28cUTMvJgCQ070yKNW5t0FwY0l6mOPn8/nYoGByl46YYKK7DtLUF6suP9L5kJBmhQuiqMCggpZjTBChYDndWR0btxAf26WLFGrc6eEdhJQkc4ZGN570S9MLeiBlhYLqx+MwV7r75cYEzzhYExYmvddGs=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5597.namprd04.prod.outlook.com (20.179.22.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Wed, 25 Dec 2019 03:00:24 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Wed, 25 Dec 2019
 03:00:24 +0000
Received: from wdc.com (106.51.19.73) by MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Wed, 25 Dec 2019 03:00:21 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH 3/8] riscv: Implement Guest/VM arch functions
Thread-Topic: [kvmtool RFC PATCH 3/8] riscv: Implement Guest/VM arch functions
Thread-Index: AQHVus9zGpQfJlH86kCOGUsVzcQrXQ==
Date:   Wed, 25 Dec 2019 03:00:23 +0000
Message-ID: <20191225025945.108466-4-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: aea10b54-41c3-49d0-a46a-08d788e69608
x-ms-traffictypediagnostic: MN2PR04MB5597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5597943C9E17AAF55F5DEAEF8D280@MN2PR04MB5597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(5660300002)(86362001)(2906002)(4326008)(54906003)(81156014)(81166006)(66946007)(8676002)(1076003)(6916009)(8886007)(71200400001)(44832011)(66556008)(64756008)(1006002)(66446008)(52116002)(66476007)(55236004)(7696005)(16526019)(186003)(316002)(26005)(55016002)(956004)(2616005)(36756003)(478600001)(8936002)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5597;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z+73bg2m+moF3SL8JNsMESAWLiertgzjF1sN9b7X7YXmdkgR9KE32TBffAPYsOp0uEa2HpyjawkUXuKGyNbS4I72fJCmETZSk+Rsjy9eddvPcWVGXmYIFKDFFnINXTixjRyPz/NkM9zACJvPEHuEvqcBaLJM6uH83DnP4h12yV3EzoL0+26uXb2bkBUpO8+6H+zQRfcUDOAYgl4R5dti/gBIIRcq4Em6pnDG8cEHobtKFL8c8W8k0DAVhPHRqK8akDf2tue8rRv8LqgDZ506CvPBxy5wgrQl2OewrsEq/6qSLJ+ojdl2rvQCIS4GAUJ8egdH3je5IKOhtHDh+U75Jhlg+Q+60KRHcDmxQ1NQV6vTKIteTc1PF3G/GJp5p3dM6abvwPuX/H8541OOzL33OOWmBDrxw/58SvhIlixWffipxx0fe6ARL0wdaIdrjjQeZUh29hA/GBpZcdhB8JHi5xQ10c3E+m+5l4XGNum2xqruzVTgLTd4ca3yyieVaPNY
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea10b54-41c3-49d0-a46a-08d788e69608
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2019 03:00:23.9147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /NktHu3C2+TdLLRaXVwtWtpdx9bHPpbt9dY/MVPO11KSXczoMEbWbPPTn93O0fdWnro5+4d6yO+zRoETkkwbdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5597
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements all kvm__arch_<xyz> Guest/VM arch functions.

These functions mostly deal with:
1. Guest/VM RAM initialization
2. Updating terminals on character read
3. Loading kernel and initrd images

Firmware loading is not implemented currently because initially we
will be booting kernel directly without any bootloader. In future,
we will certainly support firmware loading.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 riscv/include/kvm/kvm-arch.h |  15 +++++
 riscv/kvm.c                  | 126 +++++++++++++++++++++++++++++++++--
 2 files changed, 135 insertions(+), 6 deletions(-)

diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 7e9c578..b3ec2d6 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -45,6 +45,21 @@
 struct kvm;
=20
 struct kvm_arch {
+	/*
+	 * We may have to align the guest memory for virtio, so keep the
+	 * original pointers here for munmap.
+	 */
+	void	*ram_alloc_start;
+	u64	ram_alloc_size;
+
+	/*
+	 * Guest addresses for memory layout.
+	 */
+	u64	memory_guest_start;
+	u64	kern_guest_start;
+	u64	initrd_guest_start;
+	u64	initrd_size;
+	u64	dtb_guest_start;
 };
=20
 static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
diff --git a/riscv/kvm.c b/riscv/kvm.c
index e816ef5..c0d3639 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -1,5 +1,7 @@
 #include "kvm/kvm.h"
 #include "kvm/util.h"
+#include "kvm/8250-serial.h"
+#include "kvm/virtio-console.h"
 #include "kvm/fdt.h"
=20
 #include <linux/kernel.h>
@@ -19,33 +21,145 @@ bool kvm__arch_cpu_supports_vm(void)
=20
 void kvm__init_ram(struct kvm *kvm)
 {
-	/* TODO: */
+	int err;
+	u64 phys_start, phys_size;
+	void *host_mem;
+
+	phys_start	=3D RISCV_RAM;
+	phys_size	=3D kvm->ram_size;
+	host_mem	=3D kvm->ram_start;
+
+	err =3D kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	if (err)
+		die("Failed to register %lld bytes of memory at physical "
+		    "address 0x%llx [err %d]", phys_size, phys_start, err);
+
+	kvm->arch.memory_guest_start =3D phys_start;
 }
=20
 void kvm__arch_delete_ram(struct kvm *kvm)
 {
-	/* TODO: */
+	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
 }
=20
 void kvm__arch_read_term(struct kvm *kvm)
 {
-	/* TODO: */
+	serial8250__update_consoles(kvm);
+	virtio_console__inject_interrupt(kvm);
 }
=20
 void kvm__arch_set_cmdline(char *cmdline, bool video)
 {
-	/* TODO: */
 }
=20
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_s=
ize)
 {
-	/* TODO: */
+	/*
+	 * Allocate guest memory. We must align our buffer to 64K to
+	 * correlate with the maximum guest page size for virtio-mmio.
+	 * If using THP, then our minimal alignment becomes 2M.
+	 * 2M trumps 64K, so let's go with that.
+	 */
+	kvm->ram_size =3D min(ram_size, (u64)RISCV_MAX_MEMORY(kvm));
+	kvm->arch.ram_alloc_size =3D kvm->ram_size + SZ_2M;
+	kvm->arch.ram_alloc_start =3D mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
+						kvm->arch.ram_alloc_size);
+
+	if (kvm->arch.ram_alloc_start =3D=3D MAP_FAILED)
+		die("Failed to map %lld bytes for guest memory (%d)",
+		    kvm->arch.ram_alloc_size, errno);
+
+	kvm->ram_start =3D (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start=
,
+					SZ_2M);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_MERGEABLE);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_HUGEPAGE);
 }
=20
+#define FDT_ALIGN	SZ_4M
+#define INITRD_ALIGN	4
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_in=
itrd,
 				 const char *kernel_cmdline)
 {
-	/* TODO: */
+	void *pos, *kernel_end, *limit;
+	unsigned long guest_addr, kernel_offset;
+	ssize_t file_size;
+
+	/*
+	 * Linux requires the initrd and dtb to be mapped inside lowmem,
+	 * so we can't just place them at the top of memory.
+	 */
+	limit =3D kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
+
+#if __riscv_xlen =3D=3D 64
+	/* Linux expects to be booted at 2M boundary for RV64 */
+	kernel_offset =3D 0x200000;
+#else
+	/* Linux expects to be booted at 4M boundary for RV32 */
+	kernel_offset =3D 0x400000;
+#endif
+
+	pos =3D kvm->ram_start + kernel_offset;
+	kvm->arch.kern_guest_start =3D host_to_guest_flat(kvm, pos);
+	file_size =3D read_file(fd_kernel, pos, limit - pos);
+	if (file_size < 0) {
+		if (errno =3D=3D ENOMEM)
+			die("kernel image too big to fit in guest memory.");
+
+		die_perror("kernel read");
+	}
+	kernel_end =3D pos + file_size;
+	pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
+		 kvm->arch.kern_guest_start, file_size);
+
+	/* Place FDT just after kernel at FDT_ALIGN address */
+	pos =3D kernel_end + FDT_ALIGN;
+	guest_addr =3D ALIGN(host_to_guest_flat(kvm, pos), FDT_ALIGN);
+	pos =3D guest_flat_to_host(kvm, guest_addr);
+	if (pos < kernel_end)
+		die("fdt overlaps with kernel image.");
+
+	kvm->arch.dtb_guest_start =3D guest_addr;
+	pr_debug("Placing fdt at 0x%llx - 0x%llx",
+		 kvm->arch.dtb_guest_start,
+		 host_to_guest_flat(kvm, limit));
+	limit =3D pos;
+
+	/* ... and finally the initrd, if we have one. */
+	if (fd_initrd !=3D -1) {
+		struct stat sb;
+		unsigned long initrd_start;
+
+		if (fstat(fd_initrd, &sb))
+			die_perror("fstat");
+
+		pos -=3D (sb.st_size + INITRD_ALIGN);
+		guest_addr =3D ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN);
+		pos =3D guest_flat_to_host(kvm, guest_addr);
+		if (pos < kernel_end)
+			die("initrd overlaps with kernel image.");
+
+		initrd_start =3D guest_addr;
+		file_size =3D read_file(fd_initrd, pos, limit - pos);
+		if (file_size =3D=3D -1) {
+			if (errno =3D=3D ENOMEM)
+				die("initrd too big to fit in guest memory.");
+
+			die_perror("initrd read");
+		}
+
+		kvm->arch.initrd_guest_start =3D initrd_start;
+		kvm->arch.initrd_size =3D file_size;
+		pr_debug("Loaded initrd to 0x%llx (%llu bytes)",
+			 kvm->arch.initrd_guest_start,
+			 kvm->arch.initrd_size);
+	} else {
+		kvm->arch.initrd_size =3D 0;
+	}
+
 	return true;
 }
=20
--=20
2.17.1

