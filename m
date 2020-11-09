Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02ED22AB745
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgKILhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:37:48 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28161 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729899AbgKILhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:37:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921867; x=1636457867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hq/a4qEFZAd4PoqxWBXij0OXr46LPsYHf9AlZ6YRd88=;
  b=eI8wAdGDJmj3sGk23Iol4q1E6mLUZa9oSZs/VpojV2c1soA5MLlGJbeC
   ajy4V8MGR+zZOz5cPUqcdPcR9BOVwStct8FGYP6FsPSLx0RhkaoXObKjl
   pQJz8kP6OP9W1qq0DakgdonlpGZ8+NREBNADoGCx+YSc0bHyZQYvFAimK
   VfLBlsA1yn2Vx1HrbLCMdpI3wTuHXERBRVozcjguNAoRXiNsD7e7scSwl
   Nx8sPgkAfXuOSpH6+1JdbpM0rNg8/9C8RtFM8IUJRHoehM82Y0OWPSljR
   a8T7ftTsFThhq54RvlrxNp6JRK4+ahlEjnuBfS06j98b1k2jfGjvT2WUd
   Q==;
IronPort-SDR: DSBr1LOiWrm+OpWcmWrq1QrQJTyCSVHRhKSp1F9MD4HH3S9FNZHiOl+8NwgQicWMeIa2qIuIKI
 TavQvy4efCcjFTjciDwjVc6Y+IwtvKmwIMSmJufibaVUAPt0ZQ0XkPJHan5baUF7Pkz6mBhdfa
 NQgsn/j2TPOTY7qDAXOXOqyH0Dx7MXhRYQ+ly95BjkCjXLb43vbf/dBTLtwmKF5pBYbJ8ovpTH
 vSvlUjea9iHBb7L/pHSuRQ4egXc+/clOHHDj3oVQQ4B/mjlsIxfiCHHlZT6iGn/Cb5yjOJ7mhW
 DWc=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="153383041"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:37:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qzo7pLjUX1MhB8eOMBLYX+Dm2HtBUa5hWwJaGpygYiI3T1xF+rseGpTQ3CxUopjzjchun0s6+lf5AguNCWkiCR+kkQwEMcUcmUfUBatlMrvUTiYMC4H2nnUFCEK/w++OVkHQn8k44ogUZCmH9N6qjZxwmuFuQUWN6fR41H7rv4UG+fAxcHu0ojWYHfxBz3KV9uV7noQVGHtEM/oKzMes1bOTgCfTdaPTGpwChWuFecYHP9tWDYYCtH9HcWdOk+KtWH5PxDdAdycLLZE7hfe/2LSGZQgdztkX3+XxOtBVWnDF/3CI9p+mMmPiQnaqbhmpvLhJokc+XFyULIKfrPKzvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=Dx33w8t9gL1hsoTELUpczCgfI8bByHGVtuDyd4wtOgGOIw/dgFLi38B2ZPGnfXBLgym0GthYJ7QpKPQF7Yd4ULfXm0x3sxxCFHvEf1eSRjO4N8brC+ROZo0OzIkFkO4/tJy969Z015GnsODVwANzAwv/2uLq1Deiisw4KcS/Tq1DJ/NXbvI2k60o05xipCgdhjhF5irMOKVrYVlbVoga+UmZPgOBD9YHbZuhM77XPbDR02nMiIvZOA7GmPc9qYsCbqF0TZrXLhryreIzU0jsUO4sdBHMBmP0bRv5smpN7/N4PYr38b3qFNufs6BxF/Es1IsCmE8HVGeRxxv6tnFJxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=XM0qzJXMlLHY4mkOgVPaR3vug0VlT8aZZITMjasZIfRGaOghdlsEL1W21XzoKMqeQt/GeO1xwykKKm0B1TLk7IMdL1KWi71SY2dU5V+S+F1AUP8CHqXQiuqk1TdcEJek0rkVPgF9SeWztJvb1gGhccYNSCFFWAqcdKnZ/2BAe04=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5961.namprd04.prod.outlook.com (2603:10b6:5:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:37:45 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:37:45 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v5 3/8] riscv: Implement Guest/VM arch functions
Date:   Mon,  9 Nov 2020 17:06:50 +0530
Message-Id: <20201109113655.3733700-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113655.3733700-1-anup.patel@wdc.com>
References: <20201109113655.3733700-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34)
 To DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:37:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 69e99fca-5e95-4146-99f9-08d884a3e061
X-MS-TrafficTypeDiagnostic: DM6PR04MB5961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5961F445D6C2415A876D71718DEA0@DM6PR04MB5961.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4JOz1IwmUmdx4Bm62MsghLEURsvbdLcvLcV/AFx8fe5qPPAdlwnM0Xtnbi3RoucXP1BGoASr7mNxT8aw457I6zse7dW8RK2ImhMovAXPQH5iT9ZeyM5cX++aQRSsputSfEz5MOLZVXcKmBXVvPuuGuLoMpHM2MKerPbvAEKVW5xc53YCBi0t+TUeIR7d8SP7frA4+oZJ+tQvmxYTfprc97lKAJG8G8Aer5T2MPAncwA1X8Z6/cJak37DyTUBs8rtLHqXtu/k84F489ns3VKmf1AcQb3VK0qvkKU3DItEeXw/ZVdkVsmpdPpk15WvrdXL85fJLrT4Liv3vQyX/nOvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(8936002)(8676002)(86362001)(956004)(2616005)(44832011)(55016002)(66946007)(2906002)(83380400001)(6666004)(4326008)(66556008)(478600001)(316002)(7696005)(6916009)(66476007)(1076003)(5660300002)(26005)(16526019)(186003)(36756003)(52116002)(8886007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nAB91SFhFHtYR3SaTPQtiPDL3Tp7B4zDZaAJZx9fcx23MLaLq4ZQlJBS8q7VSYTiZnWuOfNzxj8Jth6xHCBkEX8ZtoBUoFmvgJRqnteyIISMRgcJO26CD6d8k59ZqkWhK/gtXLc1FCopROthkSsFv04E6mEXewqlWchhkUHJ8uak+dgp02MFSvyPRq2NTXdqFfLV/P/8nTLBl02+Tp4+cgYTfhS5pIu0AF1/DLjRaNGQ/RdoB+peyXWWjFnAzq+jWGwN8TB4W0ReiptNDV82tI4LKpVhYUAXXnj6eMMSeDWoRceXjdlUp6Y410zmZKLvCqDVSUcFyDXSnpJgv0sGwwfS+eMGCzX2xxqwEw82CK7xCa6ZrxkI4U8sRXQ7Po77jpMOjKzj1p/zc8du4F+bQoaSoaOq7nRfhqvXYQaSeuGUYe0jE2HQUgdyB2VyTNHE+DiI+UxBgz4KEMLHNS7dvJEMswF449TSKxvgyShvjFQistg8s9xyWepE+2Se00hloIdp7KFFn3aBVAJmR/qt1rJ6CPGS58CXiB5JC84ZYzTd78T6elAOXVkshchckzaml+4x//y0AZPcOsdknfoBvBzoVOeEk9Xt5zU0Yptq0elXCIfZi4zMmNVIclG6GPi2g4eIUhg0hHR2eyp8n6tYKw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e99fca-5e95-4146-99f9-08d884a3e061
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:37:45.3222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQn+aWZlvzhyRX3S0LeOcVsJceh6uabMhe3EogiO4e9hlYsGntibDrH97Y0pxze3X0BmNFjT7IDP1QvwFktjkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5961
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
index cebe362..26816f4 100644
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
2.25.1

