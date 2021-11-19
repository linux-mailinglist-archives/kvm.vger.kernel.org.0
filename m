Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFB6456F01
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhKSMs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:48:58 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59245 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbhKSMs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:48:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637325956; x=1668861956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=oL8ZvAdEEJWfjVtDKdVGFmlIGElqU0PIYbwirzM4IlU=;
  b=rRWN+RkLk4f/Nnu7jK4wTOevfBYq8IJ0jrH08wEDN6FzKLBLzwWIf1sY
   Gz12fzebXrP2PIqyT4AZB7HmDx/YGLTkHjY/lA7He7qnLPFPz8a9/iyeu
   0gSsxoDFr3tyiKZhW4nyBmyYCIEtleqCv0lSebLEussb9VEBlUrtj1Tjz
   /slsERurmBdJmvpqhv176uetLhh1axx7mH5R5K4PXXZQM3DAj5BvQadYW
   PGEgxgQ9S2khjdGRzxbdy+3EcA11bhcEgGg34zbWHd67vUaIQKMi4DL/j
   VS9YEnmnOq1HPq8dBuuSx/o8auUamLPuBzGgtUqSkh8vdDjWG/I93yUBb
   g==;
X-IronPort-AV: E=Sophos;i="5.87,247,1631548800"; 
   d="scan'208";a="290021299"
Received: from mail-dm6nam08lp2040.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.40])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 20:45:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bq0opUk+SRlAtuexq70z9ld5/6wRf9dHAc3vxTWp9BJSC5qOj6EqDXN8Gx4tc35AzbpYvZveuADo2/nclX9c8a4ybbxQduSbhB47HmKcsRHuPFl/Is/O0g+r6X907lOyzF+D65Gz7njbpgmZlD2Z2E5gDqKAmS9Ab78tO6NDO+TFJO7GBN86pGpk71MaDho86M5VgX3nFBbhMbBo1mS9Mq4AgZbSNRWYLEh4U/D9h4cHPB5ZnGEU7OdZQyWUJ5Ppl9UT0C7wk2VZdOvBMT99WZS+Gmhwv4857UxXDYlWhUDpCZGs4FkwJpjkrQQ9vxr6fEi0qSZ+kdi4vhoRXmkF+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lD/hXrWD0OMtKKR7ONko7GGNWSO97GtHYLyvaHhhgYk=;
 b=gMtR2FOdS+vasm0FpfKMoOnFnekLazChCi8CPbC3YbIHZsR00LYpHdL0Or0AXM8sZ2OwBVDfmYxNpEk0WFXohEoWc+qg1I0XLH3nyh01Y3yqYfPCkqo77U/DTOIRxebkOrmcyuivUrMeT153jEbr7MRs1MXKyd/TefFhUutKJSBCbf/Z8KQfdlU3BwPNyl9DsYsRt89JrWLvy3U11eNrJeriaKfsLR5hQY6jCycyJ/q52ow5fPbV+Yn4xIkIICAhVou45Vc3g1TunlA7N13SEgWEaMWlm5+eP1MEQ219FXCfLVqFpMmdu2zZSJt1MgBW5LyzmVdwrbWS47d8KNbnrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lD/hXrWD0OMtKKR7ONko7GGNWSO97GtHYLyvaHhhgYk=;
 b=Egw5IClOAOKY15cOjakMNnk8aLKsq/+R9W3HBqH5rLtj2tz16hXLz57EHRGj82oL+cpSS0qoDhEn08NZj2CBborLY5g+jsJiIUmITqOIijRmxU/g9Ct4DQzjpgGbYPw+iAFqpI8+NmLVQurcjirq5ajPhi9OLMoaQH2WEkwG3DU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Fri, 19 Nov
 2021 12:45:54 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 12:45:54 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 kvmtool 3/8] riscv: Implement Guest/VM arch functions
Date:   Fri, 19 Nov 2021 18:15:10 +0530
Message-Id: <20211119124515.89439-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119124515.89439-1-anup.patel@wdc.com>
References: <20211119124515.89439-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25)
 To CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.171.140.195) by MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 12:45:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fa2971d-3e85-4a35-7fd7-08d9ab5a8634
X-MS-TrafficTypeDiagnostic: CO6PR04MB8377:
X-Microsoft-Antispam-PRVS: <CO6PR04MB83776494E5098D6F5AEC72BE8D9C9@CO6PR04MB8377.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Asqj9Dgyj58rR9/2PT2HRPIyWjs1X362+asKwtpDTaFAZPr7+KKKhQWBhCBvjpBX6cJPybxvseSJ5K4HwddK+vw7SGpSzL17SODuoN4WWPDzpAr+uizlPZLVHbb15QRf9L6xx19kRwbUGmFwNx5XEauWTmqL4GrhmaTr2K087dF4M6yNVgCPxut/2Qhtou6kIXWSIAFiXecmlGYznp0YTGvqmKebDQrznsN1B68DKWZ4n/3lbv2BvW1KVJCbKfK6HPwXR5Sx7kEmgoC4hEu9Ipr57rz0Jxkj/rDihszPzIUa2sVUxzWxThnuvxDttTDGxGmLNaWtg7G9jBJN4uhNNeK4R6GrGW5ny/h49n05AdZtOoYyM/CTpklBP7n6RSOJAKLqgo7dvUqbUkgkuyAHZaGqRGoSZt7bQXMaXTsXh7dhL8xU9M5edZoqgYWvCyYBQoTdaxx3Wzdugr10qJSPFIHP6m5u3OCr9NSg8j+5/Fg3C3xF19Dm5rF+mMa/UQJP193Ryxu4oHbIglSPjyn/mfYKHwNRxypQSZyf0czPSMVZqmCW6E6j/KopLLChtBV0QMOaBqzvkgy1KaK0mhq/PEeFZ0yAEPRgGhL+ltGyFXczklkgeqHnI94XfZghIx8UnKsPDuBuvDCcRf3mSdf8asSbZJi9mPwl1HwKGz3TZvMMJ5MVYjlzbB9QvK45KkDGh92MCoocnhxqCVUqAxvOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6666004)(1076003)(54906003)(66946007)(508600001)(8676002)(55016002)(186003)(82960400001)(2616005)(956004)(7696005)(36756003)(2906002)(4326008)(5660300002)(26005)(316002)(66476007)(66556008)(8886007)(83380400001)(38350700002)(52116002)(44832011)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N71bN3tzHLuLu6F+XrT7GisNQMgmGCRyR/a29x88F1nrnDBijgzmLzJDMf+B?=
 =?us-ascii?Q?QaoBo3Wf3IsmBJU6PDDIzOz5kjFQ8UKm4pV6GCmE+DQyBz59NiycnoOrVT/A?=
 =?us-ascii?Q?ldT4APDUKS9PZdHIKw32R2tKjqdUZP7j12YoHSc1BWGQSubEqNDW6Kjcsr4I?=
 =?us-ascii?Q?k9uAXztwIUutCuKD4v+RQpb8kBwIXbpXTdZzosmaC0FplfBRd1jLQA8M0dxy?=
 =?us-ascii?Q?MebsAFzHRyub1EK823673cyLVpWBTcVoK1+IIymsT/02zgti4Trd0lS3p/aV?=
 =?us-ascii?Q?5EUXnzwF9DoxCTL8kfwieT0Itslf3LuXrRWXuohbYqJ77rPJs1RBOBZn+MC1?=
 =?us-ascii?Q?J1mCT2n14xHpKOY0cDs45rNG6v4Upa8ASRofW2LZNrDm332GXfMjHZSOxCuM?=
 =?us-ascii?Q?hCyPT3YT968grCkVnP+P4tG7Zm6LUBKPL2MJeahN1dpTqvx4Nad3capYl+W/?=
 =?us-ascii?Q?5EJ/H0yVLop2U8VUMXOh49MiqMjw+VFSd8/5zlY19YJIYHa+/8jLSnxFz8lw?=
 =?us-ascii?Q?3raoKjzSvSGiF9ade9f9dC+REWeI7+rAx0v4SAarV8ae/9SYZl2NN03t9k8h?=
 =?us-ascii?Q?oRRE/Q4NckRv6bVOOEVVnRcrjiQvKIIuHjPKiavTU7RWevpbSRJU1BDTOqhe?=
 =?us-ascii?Q?vg/J2Rvh1jdlxucCi5vu+QP5CSdPV6CNy4ENes9+38gFGPKMROzt3Aiyi54T?=
 =?us-ascii?Q?eJ04Fvdg8G1Kbk1Z61ircbSVeCsri+NYH9WbDMy5jI8iejaZoJ+1+ZVlCyuH?=
 =?us-ascii?Q?9fx4+XBuITCE/SuO1mPyBfx4lLORAg/NwqcJjFYoSg6IvZKVPyhy3fz1jnQP?=
 =?us-ascii?Q?hzk3uF6RjK0oKFwQlthMPwCqpTsazANxLIaa5Itj+FC6Vp8Hl2xpmhfqcukz?=
 =?us-ascii?Q?LdLZ9CpI9mRf4aHb2fej+GKWiMiQXOMgpEyYDBGH1S0vwDUeh2gpULkEFMLK?=
 =?us-ascii?Q?49i2HDrP17VSYK1fK+LuS3KBX3TWtOycY1dUK3V6J5Px3xAeh5ae6CKSjDkq?=
 =?us-ascii?Q?PRwKipbMZVQzAuLr+VlwIkFgwUCA3hxgllNqyj1tWQ+ll+Gx4E82iwtygAM1?=
 =?us-ascii?Q?JMNC3aeraXaVMJmp6aZtD0Jy/fWtbS7DPUHyo8+y3Q8+hKjIXp9ccmbyHUBm?=
 =?us-ascii?Q?hQLRM0tIeaLU1fMkAiXIxJnmfMdok9nwtWYwGhhsVBD05NyvrGmWuPNQ1Kq7?=
 =?us-ascii?Q?TAbSDLTaVLXJl29WAOTmtiD8PPJd42jzZLwd53P5Haat8/Zn/IElZRn069Oi?=
 =?us-ascii?Q?bfuy3utunQXcHc4jMWsXIglVkli4qqPNpQ7Kl1hISDXnEuiypCze/FbGmTwX?=
 =?us-ascii?Q?mvBbl3+spnDHlidM8a5nKg97bVhOdlMGh+3b+ZE2kCwZi5Hdu95osYn83TgU?=
 =?us-ascii?Q?wKaRIsk3+JNyzzFFGPQCeAuj9Mo7vhexYq/AkFBph9Po6TeV87X23y/zZNdN?=
 =?us-ascii?Q?Q4wfndUcbx1A02OEq9Svef5HdLlwvB5d+52eKKCOyEg4TfMjEoTccw5HRHcZ?=
 =?us-ascii?Q?BanhveWhIFzkgVc2XwQirMdmB6w8qUXBa2C/IbKBc62t53RAXu8CO0LWMb50?=
 =?us-ascii?Q?J6VmGGsx1PQadRDCrxCnZhXFH4VP+M7mr6p7eCNlFpRgEz1P/Fb5sk/jO/PR?=
 =?us-ascii?Q?vrGhdPKlJlUTvsqk1881Ljc=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa2971d-3e85-4a35-7fd7-08d9ab5a8634
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 12:45:53.7904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BiadLHI8vIutdktUnokNBwiArvFeyRc/R2KBF3dVmi7oGX+7I7Za5V8WT5uffIU7X7pg+TQst1msibymsunYbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
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

