Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A96419946E
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgCaK4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 06:56:54 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:9652 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730410AbgCaK4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585652213; x=1617188213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8UZIMgOJZ98D8yX+X+bBBboRTF2TQiHqNlQH1ee2YFw=;
  b=QlqfpZYYXbYkex4nWi1CpzaRpqgVx9FPiojiQLkzwcTKQk+ROT7i2YiI
   /Uag3Y3xH7Vo7gtyDB1qL5UOxV+Cd8TagLYdQiuO4Svt9hBCOf7nB/9Yt
   O/HplIEGYryv81rAQccsbW11MqvBlBQ457P3jS9Z9O4TrB81QFZ45eXWy
   3IQ/uGoFKscDykIADu2JQLSVtOQP3Zn/Sjm49LH+n5l2I6pOvB4WoDutr
   +nmgtBUghkhkZRi40zFuSVpdiQv2ztmq4rCvzswzEIP/R5sAVWUQi+wpY
   SymsXD+r4fF+m5LkB3IZSe7Z6+9hFfD2dsThUCPP25QaD0oSMHWjn4dlB
   g==;
IronPort-SDR: b3o1crynlnLJLE4bQcYPe9Hie+JHj+itX7Lk6mshc8j9KGs1X3kIQDePuPr1ak6vRI40o0mXxB
 V7M50bSlN6/DB8QTPn3b1mT5lzZTj2iqjjasIFVRqWyP6toxfKrMmjEv1fYNaYwJfigeoR3qWt
 GC3gOCzx66MxR+NyNzQ2et8ZW09toVdsKgqcxjDxEDYBPaw/rC5cikmOVVvzMBeqtMxh0foJ+Y
 vVu1nBJI38ke75/L+hcOSsiYMpW7NEpfXIPVmF7LZA95XWzUT/1+2qZlABIdFH3OtL321tCwA0
 QD4=
X-IronPort-AV: E=Sophos;i="5.72,327,1580745600"; 
   d="scan'208";a="134016721"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2020 18:56:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUDyxiith2aBGy6QDNz8WRP2DWSU5jKh25de90F0zUs0aNEBhdDF+EzZZwG2SwAhJHX7HW042EcQdmzsiF5bykI1zmvHkNmcnh4zao7ONORNhowFtTndDoLWIdKMQ1Rz3WGVRERxRgWE4V4QpzkVo8W8jF4l/JP5K5mANVexSSSYNPeB0lzs4loACeZcHZ24xH6LKKicgPLIoxe3YOlJsNPpjQZwOOQ4N1C+UQULL86uGz2U6D85wDCoYROMJHUONXrTyCnqGwhDRjT4sg2VYTjYzYWce51LKXgJmnzc50XZBzg4e80X8+aVhShBYzdFAe1k5s7isukk+X2edeW98A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3AKzG8bs+8qOqof1BDhXb0KiLqzv84Zj0VQeowqYQmg=;
 b=fh0rO0FV5zNMyqFn8gsEfB0M072ToboSiaszB0b7qIFcvPxyNGqpp+WWMDfURAPiWHi5ZkpMxoU+pHG7gwCCRZZD3Fz7y4R+iPpUMXXBr8VBvCwD/Efgxs5Pa6UrjdRmOvTwiSeN/sDK3wbDOpcjG5GldmXaECwiBPW37e+y12iio5pXkDVPplHXrpRBvdqtT2rGsZYZOW32RDIS2RNW3ziNWFcTlMcdkjY0c8WAErY41ZOED7B1C+rF0gtOdAHJ0cy5IGuHE3ytEuLI3DVekyEG+Fig39x2HSBCyGs8gcpHv6vCwc0KEYCgiAWiYvvgxtoFWRjG+vN/UipF58qosg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3AKzG8bs+8qOqof1BDhXb0KiLqzv84Zj0VQeowqYQmg=;
 b=0D8ZRLnGbmF89pJCoxwx3wKZTW17igPZc6/ySWdZHSXfa5DyRX1iNdwp4l259Zzx8fCCTK6wmNMpa1ZYMldbFDYVA2ShlIRaRdrXNfesThBXSPAuzE4WjaDYnrosE5sAe0bkpaGDQqefayGbkYu9sOmMbwLf+4bLHLy8b+/Gb7U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB5981.namprd04.prod.outlook.com (2603:10b6:208:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 10:56:51 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 10:56:51 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v3 3/8] riscv: Implement Guest/VM arch functions
Date:   Tue, 31 Mar 2020 16:23:28 +0530
Message-Id: <20200331105333.52296-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331105333.52296-1-anup.patel@wdc.com>
References: <20200331105333.52296-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.117) by BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 10:56:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [49.207.59.117]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1f9e5ab-7692-4101-f675-08d7d56237a0
X-MS-TrafficTypeDiagnostic: MN2PR04MB5981:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB598119822F272420E14B049E8DC80@MN2PR04MB5981.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6061.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(7696005)(44832011)(2616005)(36756003)(16526019)(956004)(26005)(8676002)(5660300002)(55016002)(52116002)(186003)(478600001)(6916009)(81156014)(54906003)(8886007)(55236004)(2906002)(86362001)(81166006)(8936002)(1006002)(316002)(66556008)(6666004)(66476007)(66946007)(1076003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFrvxEHswqhC+Avl3nXiKPgBbSWNNcIH0hz75qSaEJUGrJSzGMQu5+nsvJ7G1uoUmcx7cTBgquU5m3WtcpBJ1igjDhWhaK1sP1ZwHId9Md+q8QH/9ikzPxeAZLYvUyGZMlUEdB0XbJTImWHFQXX0E6YC96A0aUANTVFZgyeR8ELotItQIcMnZWnIN0BRw6UG6AbSMgYbCiULLwITsNjNR6BSZFV8NPQi1zGIAXhXBlShbprjFsP3LxWkBclPwqR2OK9SxXKbvAOKe4dDFkcW7QQ9atSZCftqMi6sHgS4pCcufNxC0bOI/MUBY2H6J/0/d96TGRzSgb6GrRMTGWsFNDBniho0BKMEhcC1HyQIDCKxlWTIYCWwWzfxxfS2spxn/Y/BefB1dAl0VGA7b89n6/0PQQyq1BVZkXhMujaEdo754ZqU26SSLIKvUHxO0+mW
X-MS-Exchange-AntiSpam-MessageData: KYsH+an/ZaNTy8mvO7Kz9DqG+tTU2ejv3xnYYxy81XcH5WfijJGvaPhbYR8G9RNwjoW6xpJpr3rcb/NeYuDkRtxvZRPkvMPpkYuNVXkJFGiue0Meo39ZTnYCXB12WPJTEzolLsB0Q3xrdOWfAktxnA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f9e5ab-7692-4101-f675-08d7d56237a0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 10:56:51.7039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nhawWBMZw6xGgUVfNZssdzowsZKt7RY8lNK8Zmp77foLLtvX8A7Gdo0Oq7xJi+aSZ30vc7bGxsXrIETXhpVLzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5981
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
 
 #include <linux/kernel.h>
@@ -19,33 +21,144 @@ bool kvm__arch_cpu_supports_vm(void)
 
 void kvm__init_ram(struct kvm *kvm)
 {
-	/* TODO: */
+	int err;
+	u64 phys_start, phys_size;
+	void *host_mem;
+
+	phys_start	= RISCV_RAM;
+	phys_size	= kvm->ram_size;
+	host_mem	= kvm->ram_start;
+
+	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	if (err)
+		die("Failed to register %lld bytes of memory at physical "
+		    "address 0x%llx [err %d]", phys_size, phys_start, err);
+
+	kvm->arch.memory_guest_start = phys_start;
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
 {
-	/* TODO: */
+	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
 }
 
 void kvm__arch_read_term(struct kvm *kvm)
 {
-	/* TODO: */
+	serial8250__update_consoles(kvm);
+	virtio_console__inject_interrupt(kvm);
 }
 
 void kvm__arch_set_cmdline(char *cmdline, bool video)
 {
-	/* TODO: */
 }
 
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 {
-	/* TODO: */
+	/*
+	 * Allocate guest memory. We must align our buffer to 64K to
+	 * correlate with the maximum guest page size for virtio-mmio.
+	 * If using THP, then our minimal alignment becomes 2M.
+	 * 2M trumps 64K, so let's go with that.
+	 */
+	kvm->ram_size = min(ram_size, (u64)RISCV_MAX_MEMORY(kvm));
+	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
+	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
+						kvm->arch.ram_alloc_size);
+
+	if (kvm->arch.ram_alloc_start == MAP_FAILED)
+		die("Failed to map %lld bytes for guest memory (%d)",
+		    kvm->arch.ram_alloc_size, errno);
+
+	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
+					SZ_2M);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_MERGEABLE);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_HUGEPAGE);
 }
 
+#define FDT_ALIGN	SZ_4M
+#define INITRD_ALIGN	8
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
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
+	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
+
+#if __riscv_xlen == 64
+	/* Linux expects to be booted at 2M boundary for RV64 */
+	kernel_offset = 0x200000;
+#else
+	/* Linux expects to be booted at 4M boundary for RV32 */
+	kernel_offset = 0x400000;
+#endif
+
+	pos = kvm->ram_start + kernel_offset;
+	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
+	file_size = read_file(fd_kernel, pos, limit - pos);
+	if (file_size < 0) {
+		if (errno == ENOMEM)
+			die("kernel image too big to fit in guest memory.");
+
+		die_perror("kernel read");
+	}
+	kernel_end = pos + file_size;
+	pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
+		 kvm->arch.kern_guest_start, file_size);
+
+	/* Place FDT just after kernel at FDT_ALIGN address */
+	pos = kernel_end + FDT_ALIGN;
+	guest_addr = ALIGN(host_to_guest_flat(kvm, pos), FDT_ALIGN);
+	pos = guest_flat_to_host(kvm, guest_addr);
+	if (pos < kernel_end)
+		die("fdt overlaps with kernel image.");
+
+	kvm->arch.dtb_guest_start = guest_addr;
+	pr_debug("Placing fdt at 0x%llx - 0x%llx",
+		 kvm->arch.dtb_guest_start,
+		 host_to_guest_flat(kvm, limit));
+
+	/* ... and finally the initrd, if we have one. */
+	if (fd_initrd != -1) {
+		struct stat sb;
+		unsigned long initrd_start;
+
+		if (fstat(fd_initrd, &sb))
+			die_perror("fstat");
+
+		pos = limit - (sb.st_size + INITRD_ALIGN);
+		guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN);
+		pos = guest_flat_to_host(kvm, guest_addr);
+		if (pos < kernel_end)
+			die("initrd overlaps with kernel image.");
+
+		initrd_start = guest_addr;
+		file_size = read_file(fd_initrd, pos, limit - pos);
+		if (file_size == -1) {
+			if (errno == ENOMEM)
+				die("initrd too big to fit in guest memory.");
+
+			die_perror("initrd read");
+		}
+
+		kvm->arch.initrd_guest_start = initrd_start;
+		kvm->arch.initrd_size = file_size;
+		pr_debug("Loaded initrd to 0x%llx (%llu bytes)",
+			 kvm->arch.initrd_guest_start,
+			 kvm->arch.initrd_size);
+	} else {
+		kvm->arch.initrd_size = 0;
+	}
+
 	return true;
 }
 
-- 
2.17.1

