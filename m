Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744D93D6E84
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhG0F7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:59:14 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33299 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbhG0F7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365543; x=1658901543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hq/a4qEFZAd4PoqxWBXij0OXr46LPsYHf9AlZ6YRd88=;
  b=eIvD5mYocyO9xFFEBFNZ+++YhOY58eaKnyhr3upmtJqmZqFQw3BQ1wV+
   nfsklrH6OTduFWRIU0Uk332VCpb9hNEz+B8a/j9nJPxaTm7zqLt23H1jc
   seIVKQuG+Rupit+hex9rALb4ya6wLE3qAYOxI/ktlNRhSGx2ktl8nJkqb
   3LtwhYPZwT6fl7xgRIBx4SBClERBB1+nGVnWJWMIn1DV21LqSgnOdJhhe
   e4JVVaH4z8RAAEAR2F3DAa2KU2s18PR6mZpUqqAhOMwAJhnTT4aLJAfLU
   cXYZ19V8a9nG3EgvIjvy4a2on8FIPSIwrr9/ddyR83QNiLVDCBswxbXhq
   w==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="180386106"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:59:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8T2ItvSCGG2uM6p+sp37C66k3v0wzbWwsyHiCKiOV6PArwA2RiDolsa7DDkdoxDHNnHA+LQGdSM/Qm3mGrAVLiafO1crOMjzn9rxgAkj768JUykdiKW9Qg0nsTas2/S4XtNNehpPFozx9qlfFVIt/ER+x+vJW2Lfbpa29Fz0TShWePg1XHd/dsKZfFznennqWUd/PTXEsU426EZuCjxw81Af/JfD2nSOnbRbkiH69d8SZP0E66IPEY/0kCl8GqQ7C9osyAlcr2BayWzlpfak1741Xa33PabP8TgEyzRDRTE4EkXXSAeXoIijJbrOeBlbuTPVfsVG/tingvmLINOgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=drW2DpNkUQ7qiB9ut4uc61ShQlc8m6x64VYRt2wC3bgvi3Ph/rt+mDuDyZCZIOdbrikLh0GjI0FTstTZN3+uRS4H8QFs/FeRJbOAr6knPY+NHNue9yDwGwb6jWIF7oM/0bVnnlg3r+8Jq/f5KJiMC6WDjovT76pDHPFiKuijc1WkNvZxslvXVHSeiYEPjHDyj9zydfi/6ZIwIGP9iXO6WsHaW8UdyU3HIm25JLv5Y1uZ+/LAkE8lrNVj3MT2PO9KNItWmnG2JnGVumBxw25/vDbmopN56CqYJ5/aVrTRO50bxvwXHpPCcPGI9GgF9BT/+SsQlO+XwNcqnLu1l5FPkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=E2/UcqE2dozSkYKa2rHhmgDEvdKrB8yQcnHVhPofiDdOJOZx9c+y4IZZmibjwfCqFEeGInuiQygJyvhUiXlQMu34Vk4es0i5won1BFliBaYnwunCB0MEEBOlXt3s/qVk3J8u5a8b4cFtihmR4k/JHEOenFUc3AdEZArVxEsRr2Y=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7747.namprd04.prod.outlook.com (2603:10b6:5:35b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 05:59:01 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:59:01 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v8 3/8] riscv: Implement Guest/VM arch functions
Date:   Tue, 27 Jul 2021 11:28:20 +0530
Message-Id: <20210727055825.2742954-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055825.2742954-1-anup.patel@wdc.com>
References: <20210727055825.2742954-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::12) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 05:58:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 337f99d5-f8c5-44ba-b220-08d950c3a173
X-MS-TrafficTypeDiagnostic: CO6PR04MB7747:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7747B12B4468E7B5B5D6EDB48DE99@CO6PR04MB7747.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 496b7Op1aTzMCxs85PxRZmD6xvH6a7lsjJSaNDXa5wpfE/gDhgel7Jh8GKZkM8n4bvbZqnsmW2WsReW6BhnxejqIEvutBH9UVfG0PGcPSEcC/faLcLCFfmoYNmFiP5sEf/IMNgaiF7+O2ZigZOB/LD1RHGcpR7z6QHa6kudd1pNr8/VVp4uV9NbDw2hZf6xXUxrjIqKWWdv4zTpkopBrC7bKAH7YojKHVY35gLv57iNzDFPjXJHSxSljA6eWFN5HTA9uNXHRKdiEhGZ3vXNfakBr00ei0pdVwejql+VOzVbncAVDqP9zSkf49+KKwGKbvowobE7VBex2LYWlrvxysb4+zv8UVZhd4n7LwfCXKTQsqzXa6EqdlYaH6UcXnpebnRCsHyv1zTk6qJP2f4gnR8XRVNEoATZdan0EB4032c9ZXruaZOBXDllVcsbbIKXSzJlLYfn5/JJn2ssRG9ohIFflsJ15eQKWRG7WncW+o9mUMoaIrDAJ6wKYgZsD5LO4dpepztWSI7ua1hfVGZguPErcMVuUzjw81guHOAt+Se0uGkKBL3YLE5yzxw40ox2MxIaP6JML4oDxfIZR/R4Tx4LzGqlnZ2UDTrLqHp3Jja/zFv0dCrfqhcRRrB0JKWZU2dHBf2t/YWx92jF53iuFweZfwneRhrQ+7xOCQIc8XUf7RsE56hB2UlipoAsnKq3TjzcVcutfasoufynJoe2HgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(6666004)(86362001)(6916009)(478600001)(2906002)(2616005)(26005)(8936002)(52116002)(1076003)(186003)(44832011)(8676002)(956004)(55016002)(7696005)(54906003)(316002)(66556008)(66946007)(66476007)(8886007)(38100700002)(5660300002)(4326008)(83380400001)(38350700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ckt30KN7FyD2BwrTTi/+YJCgOk/JZX0B8UPwBmzgz4YxsDbdz6lW+sjYujX?=
 =?us-ascii?Q?WwDHRenuU6KFXMVkAeRQ5+KmsC6SzPuvr8O5zaOkc7bg6K+k7rXjHy6+pUjG?=
 =?us-ascii?Q?E/r+5OJzEUR/P/1zQOR8AtiyOV6lDAg0fPKWuKZYjpdNYwehhNDWUwP7TvJe?=
 =?us-ascii?Q?KLLN31bhYtBZEhfjNeRUaGChbFF6mrTTbb+2Zd37hZDYcmVF0BseXvcJFgPU?=
 =?us-ascii?Q?S0AOQ+gJKrfu3wqQ806J521kErNOc2E7VnsZLTrC/mrKwjy8qJs+mXqr7cch?=
 =?us-ascii?Q?C1ABwNG4QIHyj6UrTQK73SbmqjZRX7OUyin2kwICPDch+IznZmLTCIVpeVX5?=
 =?us-ascii?Q?oF5qr+pcg6d4PcculSa8lWvH35ZF/xeu5HaymkQtY87UDS5+Cbxc8MKuwl8m?=
 =?us-ascii?Q?MGleSoK4vZUQDmWGCixYkTtb3KHberLsnu3+w4FmVdqD+LjzxRAeOBCwgU6l?=
 =?us-ascii?Q?8+XkII2wNuI2oIzRa0RcXsVsS8vvnQX5/S4XWjL5t95inxp8Fs/teupX3u7x?=
 =?us-ascii?Q?nLaPq8+EqBQthLwpwA2IFBksVbJMz5gaoVjgmvIwlM5GeqHnefWXmcQRmAyX?=
 =?us-ascii?Q?f8M/nA+I6ozPPTLei+r+wKTeCi6etMv58Ocn/BK2eOg6KsMmDtxhDU95J+f2?=
 =?us-ascii?Q?WtyBbPXQr9xFDMCLwlngWFnnPWGL6Z0072TfSGC4xxjRYuOHYZVztNm/XOou?=
 =?us-ascii?Q?3HUaAua7f3JVsB9u5wvduIj2IOpvwaTHHyzbSUSIeIBO33tSylTKZgp0tvPm?=
 =?us-ascii?Q?8U2ofSVe3ZBCd0cC+ZhpY1UJVbNMd0FFZwZY0gE9AmqYrMaBDfwSaYGQkmxV?=
 =?us-ascii?Q?6nBb8cMa99QkLzRA8WvjHzZbx02xDguZ+HALuFAqPQTuWFlzQkU1gDXJU4Y5?=
 =?us-ascii?Q?GclK+FTzDrXZdWLd1vrJdHwI2TSqQMmGEd8gAnvfZjitv/JAsvBC6m3Mi2aI?=
 =?us-ascii?Q?BAg8bTDmXidporvR0TYV2mahf4qrGXSku0H3YyzBaZXuMHrIg0Qvg8KBOnFy?=
 =?us-ascii?Q?16pEUTGbEliZ5yUg7XPFa/+FPpQa6IgRBsymwzfBJlHWtOkwUMGE0dZzMz3f?=
 =?us-ascii?Q?WnqnZbetkltZy5LhtcRTtLlQsjJpHhLSVHTuKYiO+LNlJ7G1P/IGH9yN19DN?=
 =?us-ascii?Q?szaJdst6EZQgSDOofM3P7WLUEhTIl5l7TPkIqjKR6RIsiSB5pp7yRlqpZcA7?=
 =?us-ascii?Q?Mutxt3Q8V5zFf9b+WQDETNR9oe0CokC7vURgDoIuE67fd997Bac5wbwsg0i0?=
 =?us-ascii?Q?FTppyUy0zN+BwT7Ag0Aq3j3HAnyc/iIYDSCiEnc9AJiEmDSzq/824/mQxuAG?=
 =?us-ascii?Q?BtwkhySEQXZjMpbLDdm3TNtU?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 337f99d5-f8c5-44ba-b220-08d950c3a173
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:59:00.8498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBUY4RcOq8yqQ1JlZRIgKEpwTjFOWdJL1lpMzS0B3W3g/hlL/kVhw2/WCBp1SUu+v/mDu21rniN23SK5VhBiHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7747
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

