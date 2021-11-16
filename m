Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E03452994
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhKPF1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:27:16 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41796 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbhKPFZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637040163; x=1668576163;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=oL8ZvAdEEJWfjVtDKdVGFmlIGElqU0PIYbwirzM4IlU=;
  b=cIBunuBLRuKjWKAryLgQShc7dm7gl6yLLP/9rJFXoxBQPSlPZotTNREd
   Ir9U5JZe72DqBeB320n8yKsaG+CUKVMy3j3Ou1N4mxN8fZSS3jHEDU+Od
   r9II5Q92RCVnh/pGOfUobv+QPoqx25cO0AfvdgzI5LqJNachWtUN8WwqD
   ZLKmeRRdjEubtT8JDUYRNuoZhT+chk5WDhST0QnnwbP3YYSkUCxSkpCgU
   rZHcSifnbAdM6b/qssmW137F/H81GMP60jmL6V2xrkcS+NT6dFTabN0tP
   KOyaC8CqXvEQOQye5RlCIMfR47kNAbR7iPQBRS8ZtMvLcCShF8O6VX2f0
   w==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="289638119"
Received: from mail-bn8nam08lp2041.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 13:22:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLkGU1sebD9UEMqpSylH3AgQsmT/rhdlq6PkM6DCN6EewK9DBQtr7HC800BIT+mUzpd7TRerwUeA3anbgmM0FVAajrTKpm0Q33hzmS7GbclTi4KTEVw0zeks3bqHx8OLOV0zwJ/XRGVZCd19gwGpVfbUK/gcWWbTKCFrmjDvdA1NxEq6UNEdGGz14zL9oH7xQSquAcVfSpOtPMLAzcPgQwMDfi/mElLGxFG8/8TFBIkyUBRO02QmXf0zlqtq2i3DyCrSDulKRtOyws1Kl20IWBkNEXr2hXTYubJH2Lqb+0jfUqOc5V8q0pmC+rel6K71X9mmoYfPAj26EanxwFveRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lD/hXrWD0OMtKKR7ONko7GGNWSO97GtHYLyvaHhhgYk=;
 b=Q74jKOqmCdL0ZjaMTAFN1TMW93Lyr03vjdDcUC3A1XdTqyf6Krh4zm0EnUH2U0TvkMJc8X4hVyStbLoJUcEo2TQS2ucFbjkkDuC5Z1EBp951YlDWl4/sgH/qCoIukY/TAvPpI7twEOejX7gkm+9VTYr0P7JvVsntzl4wMQXBYso+tboSto5aLkGBj/2ujwkrYokmMqiqcNwiThXujew6joiZJj6+FulbeRyU6t0bmKMWXWa+kzHNf192c4BdF682Ou6EQQQ0Wgj32Y0dwnTCmkxdBpV1Sn66DdKA3CaYtPGwoHLn6l3fmCckoIPL5oS6bLb2U7Eq0UudDf6dHwq6YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lD/hXrWD0OMtKKR7ONko7GGNWSO97GtHYLyvaHhhgYk=;
 b=tRxhQ4LdPMLQlR0Lf+Z4jzLAL80Z2FqrnxNRcKYA5gj2s2f64Hu1dVci4p+6BE8YxvKvAci8JHGKd6+GvC/HYtbOmmPt0gGw6zZ1zt/7DwfYX8hii26t2SeSrYRUExnxM6wqFEU53z6AeMhUBVU+XwXFkG4+gzUMG97s1HVZzQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8347.namprd04.prod.outlook.com (2603:10b6:303:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 16 Nov
 2021 05:22:09 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 05:22:09 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v10 kvmtool 3/8] riscv: Implement Guest/VM arch functions
Date:   Tue, 16 Nov 2021 10:51:25 +0530
Message-Id: <20211116052130.173679-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116052130.173679-1-anup.patel@wdc.com>
References: <20211116052130.173679-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (223.182.253.112) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 05:22:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9fd6d62-1b5b-445b-586e-08d9a8c109be
X-MS-TrafficTypeDiagnostic: CO6PR04MB8347:
X-Microsoft-Antispam-PRVS: <CO6PR04MB83479F7538DC571834613BAB8D999@CO6PR04MB8347.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VDt3xn4FQxG+JBd9HqE/DPGOCXuMRnqULhAu08bQm0/EOgIjLZ3Dumwq/1Aaim8FttL2rDfufUH0yprB5Ht8JEumvMakLRXzwDr/Y/jI87Mt61qhpWqyk66J8y7GlJGBZ+eI+lGy/nBVqUIm74az0uNV+JgtXxubVVHrZRRxEF9jLVFbfoZohqtNNXy+aHqot7nnSyTJmyC63fSwYYa75bOWHWsvI4lzcTNU+7JgaQoaggpS+b2mnGUwtt2UOY6LzWYEBfkSu+PKtWBNDmlsNRuVDebSd/OodBCLPKfjwPWN9hY22r0Yx/xtOULCjPZJ94bpA2hBLyz8EubS1VyoQ3sJgnGyTHAEuZfn0Q1b+fWKHLZT+ajpjTEW2Rr9roDs+Rpb4/rQv6J/Hwb2GRen35kcLStkzHJwm4WSCCQpf8AyOt8RBJvZC1VHcrwNRfvFJLwd1EVEwxUBv6crSKogtTmda66MlgvWUhmy4SUbBTAWVR4Iyh42nsc6udbA9PTNDyoPn5AP4dkWrKLKWmtoganAFxGJONrhwy0dXxsCtqkcQRm12QXKUhwCE/9BisQrAOp8+cpNQPaDqZ36ppnr+Qz9VY+ft3CqAfS+qUf5SozK/JbpRk3RvDAjMg2lPEvJOLEWZ2qnhne/Xb3IyLcUynjpuilg1vSnuMR/nKaQgYri0s5edoZEVb8v6mvCxc5L3ZD+cum0QfIimbnpTmbBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(186003)(4326008)(54906003)(956004)(6666004)(1076003)(2616005)(26005)(38350700002)(508600001)(86362001)(38100700002)(82960400001)(36756003)(52116002)(7696005)(8676002)(66556008)(2906002)(8936002)(83380400001)(5660300002)(316002)(66476007)(66946007)(8886007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B49rr/nBqsen++M/a/dEzRzlCk0mfAYZd7eYnRad3ama+LP4OJawMVS8INd6?=
 =?us-ascii?Q?GwKO6J4scz4LseRXH5XYsvbiy3cLwJbXXv+gj74gA07HrOlUJNTFf2Gj4C5s?=
 =?us-ascii?Q?svvg0jqezyjrz0H6W9lBZ+dUXYb+sz8Wk9PJdYyQHTO/0tRfVAxePAGhIxS8?=
 =?us-ascii?Q?EOIPcRSrz3oj3XKx+HIJyXjMX9YHiKSNY3wSa9eyBTkveGgk2xCdCT6Qhj7B?=
 =?us-ascii?Q?NytV6O4b6S7TeK+VWAvJGKVmS6049w3VWUtQI78h/UgRCrft/scKTsb6JWG2?=
 =?us-ascii?Q?RCFltMv/JVFKhf6EFxOjLC+RtwHu4EXvkTKCxcaNooYDc3sw+mlEnoEByJhm?=
 =?us-ascii?Q?aztBumZQmRdHone8vywMQ1QRYr4w01GpxGs3yvFrcyLZ5aQ4gQVVybubejqV?=
 =?us-ascii?Q?voOFMoOp0O5t2DThKB8Ik0Bymgy/VIs5/eVQrKsT9e3u6Jvqrva4XWCZRONQ?=
 =?us-ascii?Q?dPG7gHNaJVBk4JqYkHrePtRJq5s36pyai4xc1+MmS2xj5EdYOINIAt9pz9ox?=
 =?us-ascii?Q?V/DlXAf3jOUxtmzTf0ByGNRamDk+rhmyzfouh7oWCfid+QjBsM1i7w1gcOqb?=
 =?us-ascii?Q?shTkwnFvkXU99Eyh77T3SbEyO13q7WSKZqoYkb2Tn/IJBczQ285huzHgRbp+?=
 =?us-ascii?Q?RURbPuRqqZAUEE1GfN2VLG1rGigg+r+bAM0IvsbOgQp+yCX9/N7ooVDc+svS?=
 =?us-ascii?Q?cugBkURHFz+/5VtEanP3dUriD8LH807OqTJ6c5wKW9lVIs3+DzqJDXNZ632E?=
 =?us-ascii?Q?i+KNYu3zTZT60FnMtzid5n9AOJbPN4kb0DA7HsEYl1P5+em2DybIYg0kWIqe?=
 =?us-ascii?Q?dvsTaCeH1VoZn6tzsTLUA11dSic2kvCGfA//g4SZ3641f57z1tSey4j7Vn9V?=
 =?us-ascii?Q?AqDmu+NOLToEqqcebPslXwSTWkMwMkunQSbhxZJM2vEYRSMoV6wYBka8pY0i?=
 =?us-ascii?Q?hiIK59ZZ1qsqQcfQggsRms64ah6toNoJsj+Z01UHldToQB7ANihRHFKuQGxa?=
 =?us-ascii?Q?97n6rdduEgFfm950Msr2yflKlvTmqEbRi7CfHO5nhf2hgh9cd+wkUCydqJT0?=
 =?us-ascii?Q?ygfRazL/h0XA55vDWeYLrSgGLrXb4eJSDiMlhWHn8n0b39wjHE/oY7yIJFka?=
 =?us-ascii?Q?qsUoihZ8CVbQIDSyXum+2I+BDYHs3yv96RrPNI4USu19MypCIcMFCAd8W5w/?=
 =?us-ascii?Q?+fSE+A7yPS6ZN+S+9VHs4uxUjhIureN93Zb4hSpwXeMO5p2IrNbyvUVlhxWP?=
 =?us-ascii?Q?JjcMtETDF8lVHiz3yjGgVJ9TYaFrHNZuAXlAmucG/F1z90b/T5THCxdK+Oi2?=
 =?us-ascii?Q?yRZ7TYNNG3IhYoJ20lZdIc/mzme5eCVVbpdC8aDWg5b45/AXCJM/MDKXDxFL?=
 =?us-ascii?Q?OqNxmzyZ4FAHIQUn1fCQo5oXlHkocRKeCRHNE93utwQnNexNxrFauivnf16h?=
 =?us-ascii?Q?Ecv9pZbe6cpmXFYzyuFTICsLU15I0fiVeDEn7I4dVbcvsk1h7Xz2ZkCmKlO/?=
 =?us-ascii?Q?pq4DJYz8Krs/AVloQz/+4jutKOcm4H7MMbCDmxfKOBYSVxBV8PzYz1+k4EsJ?=
 =?us-ascii?Q?6M07akiyjJVEyniIQBjTvLhxOxepaN3XW+BWVHpitXfHr9iCl+k1PjWOpGhC?=
 =?us-ascii?Q?O2MnZyJOtLhFhfBSS9J5WqQ=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fd6d62-1b5b-445b-586e-08d9a8c109be
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 05:22:09.6305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eSs2VPfRrIcBXcFHpxv/ZqbS1Wj/G36UcnGwRlHdiBTju6w8m1slKFqMGtAprratpJaaO/fDfECdyr7+6lPnbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8347
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
index 01d88ed..300538d 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -55,6 +55,21 @@
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

