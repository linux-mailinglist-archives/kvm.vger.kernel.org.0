Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E135121B1DE
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 11:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgGJJBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 05:01:14 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:6017 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJJBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 05:01:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594371673; x=1625907673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hq/a4qEFZAd4PoqxWBXij0OXr46LPsYHf9AlZ6YRd88=;
  b=TxH09ty/7E5ghQypACikEtcDUJazYZOVoSaKfR+gF47t7MeUeLGvm6Mr
   BWsoe/hDBOSpWZ7tg7Jzl8df+hWlf5BELwGZxMOrLCW9qU/x9wvH+jrY9
   Hpydj7/8U3mH2w5xP1CCWLEkVRn8mwlndjy2H9FsZhGM7F/q6/DaU3b+H
   LzoN6EPhvLhGcjLldjIgz6N4XW/Vc0Mu9IWA4+javYzolf28F3q3V2/Hn
   8R9A1sI2gPfA4j5dEt5dsHliM+SWLfRpdpKMezD8Duesmwxu9XHYYP2kU
   zkm4fPmg8VNOGkwTRjuTWeFhTl2IBCxv7VMrRLovyKgKJPKmiMdKKqEgw
   w==;
IronPort-SDR: xGUli4BT3i8qAL9my+mKyTeKx0yIalIExTjzGusssj4zHvlT74zO45YbQflYOvFYPrCIAGu6Mi
 bdGwEPkucLxQMtQmiCIEY04bDghbuKq1xiedd7V/noukBxxyWzo80+VicTCk5cCG5K1T8XR/bo
 xGB39SLpc05WLYoCwRocZ3cGiLEUVLKCjY/UuiMGODZVBf+1Z+KvMhNmN7CwLUkVORoXzacDUa
 zZ5CqtudVbNNjoNxFKEnv7aIBpWuMdMbZBNUhpstHYqGHLDpneyN4IIMo1HFUjOaHB5HaTAjv/
 tuA=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="142124252"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 17:01:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T11xIUH0UlO850d0N1L1CBh5qPOQqPkREPSbw9yDEQPgHCygs3Z768aNAcdT2qeEDQHV2nzK//j4ACSaXm2NMduDagRgfnVGsfjevxSMNEQtX+AdhmlU1/o2Fv2MVxwthH6aKQlX7PzF6jD4qGbyIZulbpXPy9eHjOF+p4q3N+csdSwvrACE+rKlN9jAtlL7gdavaHjEyL39nT5XbwC9fSMdnKkglfQhlrRemKIl74d2Jg/zSLz8kUt4D3U4/EGiHhXJ8BuAOQhchtQUiOIiKLQJtbmuTy2jkcj6W6aDIrZRHpdoP0x/0qzHz1DSg8mkRlW4HHiG5IsspxZu5FrK0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=gfpPolSNx10pU9bCkFV+VYKyRqip0DKEK8AeREH0NXKuv08Y8D8fcNTm2rm3MvyUIi8TVRxm1XE38JLb23Lp9rrkgqMm0xKk66Eskk9h0a6VrEWWJO8xCoyyotT4kJo/KUnzXTqY1drBOsQy2Rcyg2b+qnu/nUNVLd+kaOxSixdHp39PI8zfb95JnglGnMUXvYBvTg+pP8A/OfhvsAcKWgVBcKhfGYrjJyLNjvlj7AvKqJzOXt2dH1XPA3PyAt944G8CPK2kXZrj1NF85xtNrNoMnC+PI911QQels7yBLOkuodAzJY/PogC70l08QFq7FtMwSwgIqBtCIsHogdHG3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=u2gGxu+OiNCdS27ufWErwWO9w967QqMIfqqHUeAR49ounYRSNnx0dw47b4x0+GDm98eUy+QqzSBbFqDofvNhUgOnhhPyY83ymmAaP3Vyu7WJQggI+X7OSjJoOEMlWS5+GBULirEy1NxPhoqcrraJsmP+EiEYovkdCuYCj8zTaow=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0346.namprd04.prod.outlook.com (2603:10b6:3:6f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 09:01:11 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 09:01:11 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v4 3/8] riscv: Implement Guest/VM arch functions
Date:   Fri, 10 Jul 2020 14:30:30 +0530
Message-Id: <20200710090035.123941-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710090035.123941-1-anup.patel@wdc.com>
References: <20200710090035.123941-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 09:01:08 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84c9f31a-dea4-44b0-1d19-08d824afca9d
X-MS-TrafficTypeDiagnostic: DM5PR04MB0346:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB03464B93A149FEFE1E98B48B8D650@DM5PR04MB0346.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q06LVI+hG5/CHRyfTrd68NM+vFpRh8imYikKhfgypAz6FzD/F3T7DA0vQh0SEiehzE6hTU9jKltI+XbukGiHE4XpGuc7p2fb2eaL474phrStcYCvhRxeOytJ//gzoGOiqz/pmv2BPTQQhFZw+e73uqPzqv1iymkkTBN07uIqqgkT5Tmtd2o5cK27eyx95LIml/oAf7APgSRG3spIiBHwSurmyXErjjoX9BpHIO5FBgSOcZcVnfzKkZjAAHaaUcGVOlTf1xMtX9axV/S+V1C4ujbd2yd8orglF3CpDBhSK48yUohDTBJFwu8Th1lAoM7m+ulG7LVuK7U4Bc7yJ32Yxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(66476007)(186003)(66556008)(16526019)(6666004)(52116002)(8886007)(1076003)(6916009)(86362001)(7696005)(36756003)(26005)(66946007)(4326008)(5660300002)(8936002)(956004)(2906002)(2616005)(83380400001)(55016002)(478600001)(316002)(44832011)(8676002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nVfz4HcybrMDAZkPldCdRWbAiFGODN7kLIWHO31q/EUAzblkYixRNa+SwsEKxEgWJsDpATB5Q6eoX4I0M7+x1coNaejw4x7vr3H+1TXiQ6JMl8uCqXOQRbDjcr6LNFqz5ACES2iSnrShpfmxyfl2/y9ANzePL9fYyqiIn00NEd+eAvzlIJbLPUHQbi6Bq710UtJV5ZI9oJW+2FhfdZPZND6IifvE+njC6u6SbDA26gUN4ywNIKlYs8X799ryfoZwTxhsHbbO3htinfx7vRRX+8zXiNzGdBrrZK4i1E7W8p+R0humw7+VX7faZNWWy7gOcl8MOv1UK2XEuse6L7a2Gimvy/hUczz3Nr05IRUzL6iO1iWJGDg1a9B9ISFQIopoKQaxPRwZG4QI+coRVRkCGcEEwD4wyKdDoopPCK5lm3jE93lTSQHheIZu9Ij5C2IAQHWeCX0CbQiCy8fK7CsDeZoPjQ8ozT5dYp5jn0FacO4=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c9f31a-dea4-44b0-1d19-08d824afca9d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 09:01:11.3394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjJKb/KGW23EwtQJ79Uco8GpN4cgDZyhqqT8ASAhW2XAaRaBRUirQjeuLN0yE0jT4dOinRh1fFr1FzEFA2Ci8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0346
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

