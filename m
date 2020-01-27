Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB4514A3FF
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbgA0MgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:36:13 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:4529 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729868AbgA0MgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:36:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580128572; x=1611664572;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FG1pjLRzFSIbSk8VxxvqUyBnuCH4QCr5VvPItyWjAZY=;
  b=puSq09XzhcfIBE3aw8NjIJS7mMSU3TYEWto+FpDpMEd/L/Nu9BCUDJ+c
   c/9JfpQyOuef2Vj70398AGM+PML/MTbkJZ0fLiD4djvpp1ZLLInyZSsuw
   394HmUba7O+XdXvh3l/hLbPR9wbdgLxLsT8YlM8ka1U7fBpB7B1PerI6M
   krk1a1iwbcBpHr7fcpm/tZbhHn2Fv6u3E+E7FAs++pK/GpEUik1g9a3mA
   lAbqkNZKgNIBAy0BZX/NxcnC+IuIY+dvTCz2GVV/zidwIKMVkC/HfwzFn
   eHf/4XAVGyoQhROvpy72HwbfcM8H74anCKc7nZzXMNTOLEr4NSebN8QXx
   g==;
IronPort-SDR: 8Xarib120AphJAvHWTjbdE+XZskwKf/r9CjvbPZCK/dj0tbyJwUEaTRY/Fxw0doZZ87B4UKcyc
 pnMzjiOFuV4AJrHqscQr1/dF9G4UgZ+Wze78iBMnifPd3H5U2e5un3v/ZaztIuQmurbhTqoRFK
 UuAqH6qMstZVG/A5ZIkRx1WfjP1P1biYw+WObZxysiofPQp6bKW1qMcCrYgRXhw0SONpZ5ZF6T
 IJ2B22IYBqOMZKOGr9fVLnICgTaw2UkxMOR5YBFYyaCO2l0ehW2a6N1ztGOzEg78Pgllm7MGAV
 xPY=
X-IronPort-AV: E=Sophos;i="5.70,369,1574092800"; 
   d="scan'208";a="128476111"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 20:36:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KI/5ZbsLZnpj7ZSIRZblG2SxxWTY3MNXu/AGft8O6N9skqwJM8zfSVYiA7VgZoATfOd0G1CeXZKjErYUxm+ac5rwedXBN8BqjorO4UyTrEpn4/O+ta4PbB1zSxn/lBbIhFTnSfKASgAafL28bYJuv0ycyUWxvs7zAURfo77Uj+Mu0dX8/pwHr4ZdOA9QsQhej8h81/koaliemGiyknjCHuBhP1hPesQKN7+W25gaVsgENX31dEavIkbDKMktgIslg+dR7P43rT9fVfKwdIuMlALdjRBKf9fJGZD7uA4p4cuZFvSB03bbJvYTRskf8jIRSSCzCWW2LFT+4kLLAdL3Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YglYYcKuhQDkuQ0pIhEsmt6tHFkeynrIHF/Dayk4N20=;
 b=eyhC6mV/r/Eo+AH1xGtVFRpEBad41nK1SWTCEgRRyVgxMWOhTCWMWovT6DTE8Ha6BnXEu6h6XD1rJT6/uNhiZQ40hKQ5TWAZ5A9HwlGO0r56gBnql6uP2f3ryX6cOmET8NGpmsQDImZajo56a1WTJOBXJvLoZW2EZRZoxfRXsU4w+O18TTY35WWG3g6BrNtqYMJD7nY/Fqqs9cLMrA4Fsaou0SwqIETqtqqK4KBrMhcPSzw9tamEUJIppel7yywC2jChSGvbF7PGcYEVJGyfkXcubRZjNdWpza6M89WV6fWnB3q6xh1SpoyzoyUibRDX/vhMpBAOwFd0Dp72wT9SOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YglYYcKuhQDkuQ0pIhEsmt6tHFkeynrIHF/Dayk4N20=;
 b=qdqTodL3GO/vUuWQgHZXQJErOOFaF1+tGWntSB/2NO05hkbcYe4Wcd1nFiorF8MO/vbUkri9BfH9cOFlvtWSgLT23VPuHxw151EJ7eApRFz4R9nf6gjako1EqEKGMRT/bafl40dEt4H8fvT3QLvnxnnooEieTziAFHbe30dbPtM=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6816.namprd04.prod.outlook.com (10.186.145.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 12:36:10 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 12:36:10 +0000
Received: from wdc.com (49.207.48.168) by MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 12:36:06 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH v2 3/8] riscv: Implement Guest/VM arch functions
Thread-Topic: [kvmtool RFC PATCH v2 3/8] riscv: Implement Guest/VM arch
 functions
Thread-Index: AQHV1Q5aS4dNVduMv0Sx5YtsqhfBQQ==
Date:   Mon, 27 Jan 2020 12:36:10 +0000
Message-ID: <20200127123527.106825-4-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 6a6a94d1-a34f-4c5b-026d-08d7a3257cfe
x-ms-traffictypediagnostic: MN2PR04MB6816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6816362CB2ED2C090D998D158D0B0@MN2PR04MB6816.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(44832011)(5660300002)(2906002)(55236004)(54906003)(86362001)(7696005)(4326008)(55016002)(478600001)(2616005)(81156014)(956004)(8676002)(52116002)(81166006)(1076003)(8886007)(8936002)(71200400001)(66946007)(26005)(1006002)(6666004)(66476007)(6916009)(66556008)(64756008)(16526019)(316002)(66446008)(36756003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6816;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jP0h6rO/6jSMNSh/B4Qo+XJVOvfohD25bbT4L20Oc1KqXMd3K7FRwRh3QgJyyNzwzLtaIWhmIrMVUG1dRuMIvrgN7T5exQFUeY3jA7DsfpKoVF9j14Vg94fzLg2Bauia+O2LcMOVa7dVQlIUc0W48KGlRgf/QCX0c3Glpnr33K+DoppbnaV9LWv03TuyS0Ym2OBBq9NfQs14bmyBW0To0cC/3y7yphkS/Oo+8ZiyGSdRpe2KgxqrFqKFH8DyTP8ct9T4UEeaOEoi1pjoJMrO9ySVYEx7NhKdVizxjNRU0PtgribdHPBdgY1SWYEWrZxtw539Q2SOxyZq5iOM5t7evugxymAi7A0SFexez0Bnpk4mQw8wu8wNoc4MKmR1Qqt9TWdyjtgC6N58PP8fkIp5VW6al5fIvVDYG/66QlHL5a+MxZWll5Kr+E6ABjZuTd8K
x-ms-exchange-antispam-messagedata: XtDwG0A4c73h9pD1Ul+qakzbFPscFgjFTX1VfL+Dii+eKqVW1YE3GQ3aAVmvH9W9I+ZYV48zG8BTgM/kyCKel0gHEQi0kee/Px8gtuf8jXufcKwsnKRQjqfvINIxpDpyJaHUq2hkNPCdkIgboL4veg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6a94d1-a34f-4c5b-026d-08d7a3257cfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 12:36:10.3742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 42dKTAwEqmFagisGM3ZVIRw0n7RjN7wD95pQLFn1nQBKVT26eR2RBTnz3tU/bp+cev+fSAiy382yLIWuJSzuFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6816
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
 riscv/kvm.c                  | 125 +++++++++++++++++++++++++++++++++--
 2 files changed, 134 insertions(+), 6 deletions(-)

diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 6ab93cb..6f64f55 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -51,6 +51,21 @@
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
index e816ef5..84e0277 100644
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
@@ -19,33 +21,144 @@ bool kvm__arch_cpu_supports_vm(void)
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
+#define INITRD_ALIGN	8
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
+
+	/* ... and finally the initrd, if we have one. */
+	if (fd_initrd !=3D -1) {
+		struct stat sb;
+		unsigned long initrd_start;
+
+		if (fstat(fd_initrd, &sb))
+			die_perror("fstat");
+
+		pos =3D limit - (sb.st_size + INITRD_ALIGN);
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

