Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FECA351B52
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhDASHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:38 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44489 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235761AbhDASDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300220; x=1648836220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hq/a4qEFZAd4PoqxWBXij0OXr46LPsYHf9AlZ6YRd88=;
  b=V8P8dJxPjiTH5W5Qb23A+neKFO5JcGSrYRdAlHWwnJYrmYi+P1XKaz5Y
   ZwORAEuX6DLrsKiJXmAqPl25/z2GfaAHCW4P851GU8BmxCyULsi7sJWEZ
   3HiQYwo/2HmrKNUMSHqW2u9B/ngwLUzz3o/JjEK8pwpzv6miYYFqD3I2e
   RsjcyNI4j6Z/8+rJ0QAdhFxA4eGWmUHBztCrMx3zEYx2Oh2xGvEyWlKMZ
   sE55QPWKNDt+mLvxjq3Muoc7P5K7H+G6aEPJYa5dbFSs/4D8BevfsDoyT
   z/wsZMuyqs8zkUA8IPaK6gvX5PuLBNg3p8pE4ZjuN0yBg2u2Q0MjKXMl5
   g==;
IronPort-SDR: pHThliPsgYu8hB9zLnT3g9zkFg8yd3UUkCmOnOcvjbAppomw72YWoTesUk8bYkITiTZwFrTo1r
 dUxKrKVK/e2iqRjYjEiC8W9Lx8PWKavvp6Z4rxV2oP9vwAyGmu2idCAuRXWET0IzIZAFWYCdmW
 KuyvkrnBBaMXKv+KkAG+eLZHC3E7dNbjMXYcQJzYRixrgMCFIWPdq5/jMI4ueqVTCySSHGR2He
 Pin9Yc83sa+IA09k4jnQ87ZioP/VVVwac6f19oKtsTOSP4MnAY2bggHO5m3rWAoX2uzMg0Qzk6
 DeE=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="164583194"
Received: from mail-bl2nam02lp2056.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.56])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:42:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjR+GdLc3FwlgbxXmlwMuSv45S2S0r+HbQOlWu5YmeXNPF2OGscsc3hE0o2OCrGjamXyq560p9Gf8cXrV+CwoPad2PgCuBMNjeIiP0FmnoZbTIaEJViQJ7jUIUsgbDEJIpeZ+65F1uoc7AMbRb8eNH1HmOXpEqFMkGqFYw3yH8rujMIWq1Age51S4ftHY0EYLMa+2MwcztDFj/BE9I36FtehSXUFemXatSnJKJzeLeSqOYqiHoGa/J0OQ8dI9QF6AC/iKeBORUinqRe46456G2MVcNYo7fjVZdQv4UWk864MIvr3QLGa5ZbFqu8W/E7+vH75LncbuTE+D4mIxFa40Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=YyZFcfrzE3j1SjLWLQebsKnAWKBu7B3MAMKqzyz9xeuD/hVRXJ2CQiy8IeAeXGW690hEf8HbVG1gcoTSqsxv618p+aaUKDeYFz1Ej74sKdpKCDVFhjuQiv0aRVzfMfItZmX2sti0na9f/WO/XtgfELwBZ0rekJ9U8T0Yyf/ZWyGndEDOvxPMtGrPwmFvhwj3rWJO2o7utvkO0vmc+lbKOOA2wtGBUU3nu2ohypAqg/bS4KHetxdhmwv7//8QuWtuL0xmrOVWcmxYU0zhKGjdKIpwQBfkksubpFFgFM6FGa7tSwylp2y3pU8a+F5WnBgXGO5DDLDMNeFmauPaYWW8wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvDXBZzIshOXsk+q5fGaZOauRuAY1rXTzp0ffC9e6KY=;
 b=w9H5qfzE3fUx/LJcLd7Z2sXEF3G5eb5hqZtReRk9cH1/Eum2/tF0MRRr5ibe55RADjSTMNy/aYGd2gmIjb9CSpucqutK3ueyr65+NTCIRK0nKxocrpNbYf7QU4XsZGY6ntxiAOTLiuhXetoQiK/jTQJrtFMOQpEBBN3qf9QYVk0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0218.namprd04.prod.outlook.com (2603:10b6:3:77::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 1 Apr 2021 13:42:08 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:42:08 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v7 3/8] riscv: Implement Guest/VM arch functions
Date:   Thu,  1 Apr 2021 19:10:51 +0530
Message-Id: <20210401134056.384038-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401134056.384038-1-anup.patel@wdc.com>
References: <20210401134056.384038-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::29) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:41:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be2fbc17-ecf3-4f9f-3d7d-08d8f513f18f
X-MS-TrafficTypeDiagnostic: DM5PR04MB0218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB02189A7C7F1FEF196AF151698D7B9@DM5PR04MB0218.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jiOy9fJWx77pjhSnD5sb/NgHhZiqu+3Qv4bJRds61VV/c+uTk9uezYgPRBEacwCdscDOjvptYOekwhLCS8xE5ODF7Ff07ruZ6mfcwOpbBZTydvufUaFmkuqXZZ8KaMrz+Ftu8Y/OHG6furNz8dKi+XuIQF6y0QnhpwnFntpFKX3mdbz2KiPWacx5CrALrYKOpJ6wFR4dnyVUoSB3XxfYRSb8n8dMS0+SpaVCHjhNl6tuLitIsTEF95F3yK4gclRSiQmimUph85+nqLXnbpkD4cg3dQS46w26XzWh6Q3MTl5mxsFL/BWr8mqrAZZ1ztpX+KVodciDcUhK9Cx5peOXohLj4/dEF0foPAOArnK7/rNq9rbBCNaVOYVQY67+mVnxAuJ9gRMukumaGv4Ft1Ibp94gci328d5KdG2Xcqwh1H6fHBmcPZ6MEP5Tk/WhpBKYU/lHcMVOyZ6ovMKhSkvDk6Z0C+bg2iYDnRfq1XUm290eiJycvZbASUTcNQ43QOQm+ITAjKwjHqSZvsGnF7nikH4Zt5LSzFolYzbFUWlXsWcMSSbYnfessiKg3ABTKeiZO6LwMM7gIhcatBV7Y4uy6qcOpBhng11SpBk6a7YxXFXnyOys+p7kUFUdMoe7s0kcFuCKOI48kdQFfYfAi4RaVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(38100700001)(8676002)(6666004)(316002)(36756003)(8886007)(86362001)(66946007)(2906002)(186003)(16526019)(44832011)(1076003)(54906003)(2616005)(956004)(83380400001)(478600001)(66556008)(66476007)(7696005)(26005)(8936002)(5660300002)(4326008)(52116002)(55016002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?44TJCQpsrHlZur/u8N4loqlzASJiGip4qQoWHv1/0Aiw/ME/MTrkepUoNBQ2?=
 =?us-ascii?Q?uMYEQ89Vz2xH4yB1XrsJoVl7vAUU7zzdirjAp1lwjL1U0PRbJ10PkCDdVnIl?=
 =?us-ascii?Q?6vKwzkfBEwRn6YkfrYVOQLWU7pP/rDnmeBEhJQfHRWloOal88cfYUnHSe1Kv?=
 =?us-ascii?Q?kyXK0KSbiYJIMzn9n8OsWodBAivYR+1xsdA//x5MQmXhXHi9w5sEIART+GvE?=
 =?us-ascii?Q?2/wOn4mc5pr1eTwqhEkUIR37BJmlsqxQxLHv8jwJ3nO1YqZmMojqU045nsvT?=
 =?us-ascii?Q?HtoZmRZq8Z/v1uTnwTGEDKjIsq4zUX9hKT9FN1IYuoD6d+eDbjL2MFhBBjkE?=
 =?us-ascii?Q?9LIv7Bz+ESzVdOxx89tSarNuq7kWaf+vDUMWRUVEeCt28EaBnqI69Og6QbkZ?=
 =?us-ascii?Q?5F42wX+rJmMJMANJgwpA2lB5ivz/GofeajfYq0sq/wyugt5rGwb9jaElq1Lc?=
 =?us-ascii?Q?eClxNiIwUJZ/Gze1lawwdFAmezYfsqreYF2S9efkWxCd57sWE4LNzVzSA1Zh?=
 =?us-ascii?Q?I+35xSewQI0nyWpJNhq353DryUxskKjc9CECqh9HYNroyYnx0dJdxPoNIyvG?=
 =?us-ascii?Q?lL2oskw/FCPzQ2Awb3iScu7K8iuElXH9FcZYXvLTHF/PC29NkcAgswLjX0J6?=
 =?us-ascii?Q?NmrQbDoTOO84UW4or3JDVAUJIiVYI/R6eIFAoT7wRm8UmqAI/5hHGu/uhjjt?=
 =?us-ascii?Q?WCh1m20NV/IRd/yStrwnbvM4kgSCttdn4jjJeOcV+grzuhIL3xV2nCELwgIp?=
 =?us-ascii?Q?B6yfmm18gY3uVa1COXcC6vuRMHyLtbw6KrEtXUyTiZTYE8R9B7Uqfs208/lq?=
 =?us-ascii?Q?ygUtnsxfJSR7mOAVgaUTJyZdslpSm72H3U1sALjD/qXJWjwBu/dzj4KV35Dl?=
 =?us-ascii?Q?BbW0tC9EcVIVvkWJbmzW+Bh7FSVC5TrpRg6fmV2I2QX87xTKlmV547yM2t39?=
 =?us-ascii?Q?s4vZodre9nRx0eio/lwjxVlJ/uYbC6gIRrCr4rKR2kKOz25xQ9GiXMvvpzZC?=
 =?us-ascii?Q?oqPSCPAz4+MyoO7IuIF7uDPT86prva0MO1J9KXFHsFkOQQwmZ7Ck3Uhgqw24?=
 =?us-ascii?Q?fp++OZusuEwHp9mor09IXcyL9V+elosHmky3mzEY+Qg76aXM1EfBo4p4xacI?=
 =?us-ascii?Q?LVVSRZosQ7v6wyFkh+EULgeCMLGmdD1J1bm1xW7zI5BoQHcfcRxhO/FdQpsS?=
 =?us-ascii?Q?gyzWCWrCbVAN+36LZ8AShLyBKWxE1N292aHh8pjwptxf8x9CjB3nX5l/K/2v?=
 =?us-ascii?Q?sUQg8nU1HQuTNvgAQOiDi6/bOhJ5oz5Oth+8962lftUwNKlqXKF+Kx1CGDg+?=
 =?us-ascii?Q?UV9IScjydlQSHKAXKtZjmcWQ?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2fbc17-ecf3-4f9f-3d7d-08d8f513f18f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:42:08.0134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoUStIBG4O7y1CVjjXYKeBL9Hyd3we2e+GJWLm6JWZ1K7pe5GeaZcjwLiWI8XSpufns+W3ho+npwPafBiFvbgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0218
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

