Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EBD2F78D0
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbhAOMXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:23:46 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11796 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730584AbhAOMXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713424; x=1642249424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hq/a4qEFZAd4PoqxWBXij0OXr46LPsYHf9AlZ6YRd88=;
  b=HZwdiv1JdKqChBUwxKaOYYgfUgD+PCCcjm8fo4Ysql9Vrzu2QREcfbXy
   qcBERjcgbQWgtKZLNPh/nLP9S3AgMyeWufiXDmYvkcUA0MskqHN5v9PDW
   my1lrrfmnJb2hrZyr9j2t1yneo/H855VgjH1qOaGBGQpTbzPnJsUM2JF8
   5SZTCokiklblVXjOzI4xI7YwZ3BqoCFCTB9S8J/Nio4zispZm5v1oqY9I
   yS8NxJyn8+5JS+D2lisdxPjPONmO9qEvVq+JCKKBipOjFC9VAUzkmMFHC
   I+AC4cGceNwMPYeTg88DMEFFyRk6Yn3r4rmQg0+u4O4ew4608xl43wkE+
   Q==;
IronPort-SDR: 2mPBXpjZN+FBYhUP1L4VHAD4TkpETXNzLcmb2tkDzn8PlO7JqEi5a6XehXz9jtc6FS8OL53Fmp
 mKRnx7B1ivfeywvt7uF8Uj+FmSM9BQmKKjwC52LIH+GpeNm3ahxqww5zZoaUGcoMcsVAN09OuI
 e6vs4WQLETMX5YLaSthOeIp5aXdTc5SH2edMk3mC2zCBp/tPXmVcOGlcrt2jPWVvmkspLcbS7Y
 BJz2NHzID36R6iq+ISMHTBw2lvSbIvavxuo+UL+98OtYEB2Vx4W1bwoYWMsZQXNRc+qyeBMFnY
 rEM=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="161949697"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:22:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq+WJnP3cMDzHLSN781mWEKNU7neI2DYCJ71DZEiSZUG+zCyV4YbBDhprSZOsXPXAAjUexOIKC57NF7umfYCz+aifNg/aonLZ6YJPLmnz/HAB6WD4BvUmRP6Gwy1lHAXiLU46FUoEkXu++RoZAJCJDV3/jdyRsap5Jkr4r7t1aT8dSrtENkBN7sjzh3aPIN4yXRvz0npjIYCMmk5tOdGmr+4+GlasCV8NgJuuLHGoOb5LL2Yn8YKXGYoTdtfyW1sjrD9Nvy6SSNBSABu0RTU/ubDU49+uFSfycXRb5JBcpmX0lg+3ExSoUn6FVclAuR3DdJD7YKxcO5qeyf9zajRxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=BDVoBxGaY5FQHh7wlhpOwPJZE0TX+uU/gTFsTkRNXeKUv6ocgXQWZG8TS+O3FrPeg8a65dzllEngbNRCV8tLqyRlrx+GC/GnTRVRjze71n1oi6XQoqznhMh1yp+qc4CdDSONCkstvly0oc2l/WMxz8US6RY9Chc3t5T/6X4Wee1sSJx9D+nsN/gDbH8g8C6eeRnT4ztLOatRspgAV+3qytHXww47eXWcSsOePFcD1FJvU2vIZUiEIemDRGx9Qlk38KCC6BvHUazggJf2urPdd+Ad0vk4e36MCWx09ZaVECN2zM80hCxBDOcmqAueOtjL5W8M/13lL1HiMQwldfvmWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=Fjj6cnnAT1IGyGtR5VxF1n56IYKlEIrS2OzYnaLbeoGZRtR+UCXAHkNHxHI+jJGFhVh/UNjH9rNBT6hpF6XH5Wv4Ph6TE507SW5fKguI6/k7dlhqZJW0dj6IFcwvPm5W1gh/Mmo1OcFu1zzBnyM0bDsMvY1x4u71CblpXPPoT6s=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:22:37 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:22:37 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v6 3/8] riscv: Implement Guest/VM arch functions
Date:   Fri, 15 Jan 2021 17:51:55 +0530
Message-Id: <20210115122200.114625-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115122200.114625-1-anup.patel@wdc.com>
References: <20210115122200.114625-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:22:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e0548714-ff8a-40cd-c53a-08d8b9503e2e
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB43300A6063406D8F9E983BA78DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zLNhA6zRPAvGv1pkybjRigvuQblwHeeAHECgQYed0D3I/CoDhm6bT2vEVGEFpr2PIgBFHGT/OGeCVAElOscFdETZNIJP0d3RB0rmQKnV48eJcwqXfeLxGIBdJpEfuU/qLGZoSiLEbu9zQ0jHzS58lGQ10N2yLfBz0s7uVoktQ8TjB6jG6GvU70QBfFnzFBP5kXNmtyIyloi9iu9O5ZF0yFM+FLv2ibkIHJb3L6janCyoaD2bUbineActchZXX6LJP85rAjt+evx5jF3XhdBkR8wS14QjK51Dxt5tPfZLGRGuw8HGMS8XorAXoUQw4v2rsVETivTrQAwKp3wT+bVFwTtrs/Fim6VnnDMwnPpLo28I4U6Pi2J2QAEEcZyIgKz5OE8vQIhK23FQlQ71wtchFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(66946007)(316002)(1076003)(66476007)(8936002)(186003)(66556008)(86362001)(16526019)(36756003)(6916009)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4VGs9MF9Dwe0ujewA1LkIuYn7Wggve6iBAIlF19Tt+mDKwAjAA4y+9qg5fef?=
 =?us-ascii?Q?Ur86nEXXtiqIq7DpLmUNrgs4OG9Wrgl+Zn7CWhaZcgSDLG9hfCOiz3zze3BA?=
 =?us-ascii?Q?6IcBOlV3+VFpvDxHIY9QNAR56Kt5VlckEoEkTXcC6LQJkMxkc4EJzY2RPekc?=
 =?us-ascii?Q?2AO1olGW+sjxRa6wCnaRVfQDUFY038JR+fbuH2C3dU4edhxYiHztURvr7hTO?=
 =?us-ascii?Q?BGwkf8ZDkWIqbMSwG0EMKp6oiUgfcVD+xh4u2aNy/ZdtKIxcmE3HfNE8Z3+R?=
 =?us-ascii?Q?qtfwWPUfKEWThYNgFxZ3f0npvoSiXWnAa0ucbaMrFJ4xGxTna3I1FRftKCPh?=
 =?us-ascii?Q?chszieN+G0IejIvxgXnI+fI/RpROVT7P+QIgDmQ8kty366nuv9u+vxTff9CG?=
 =?us-ascii?Q?/84JCXLYQFqgLCesCGV937j91DCFnnc2wIB6gsCrzWCabJ2BNe7etG5TowwY?=
 =?us-ascii?Q?O1pVhIzpAFv2Frkn0LCMJJqFBFiITHVySTKtS8UbBGhRqt2lGHFHQV7KqglN?=
 =?us-ascii?Q?H8ChTFfkrUtKhoPLRqYkVhr0m57H+wvD0WdJ6rOiKCwyIVR4ofHTfz+/MgDM?=
 =?us-ascii?Q?6OrzKo4vzVt/80QHn0tX/t3aKDVjqxo+vK26Q1PVCVjjRbMhFjinBP+Ie3aq?=
 =?us-ascii?Q?D640V5xpu34wRIkMaa0wBQbDohUm19xH/44BQibo1O1tklWJYXgrJW4FftAH?=
 =?us-ascii?Q?ViY5VFJ7aLKv19riCwxhZ6hvvhj4/UMo9K627hCqi9xuL2GonWV7pmjwYtTw?=
 =?us-ascii?Q?Hwk6fhVszdbn8a+9rpGNhTYEhYb4iv3RxOttibtGaFtpykn8T4dzMm2qwgOU?=
 =?us-ascii?Q?NIA7vMSQHqUoWv1x24Wdxb6oRPGAFpqTCg/lvIoS978qYri9mkW/JfIn9wcp?=
 =?us-ascii?Q?VHcGI8YQXULcChE6knBSU6YtWDtCrnZdFmes4JT2S9RvOu5+owlhDa4wtES5?=
 =?us-ascii?Q?RTHpPcIHeZymlGgwWdMmoLNYy78yVGsGBTXNC3tNiiHJ9VMoAQpfmtE4qY2c?=
 =?us-ascii?Q?t13k?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0548714-ff8a-40cd-c53a-08d8b9503e2e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:22:37.6412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZaXCl0Mzycxa7qrmLmzOn8tWNr1iwRQevEnNQHoI4KTb7E0zl4BryaxVkbyquew88KKWc1TLmx00fCizwWxyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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

