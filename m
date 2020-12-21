Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264D72DF752
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 01:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgLUAzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 19:55:14 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:58751 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbgLUAzN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Dec 2020 19:55:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 16A10580424;
        Sun, 20 Dec 2020 19:54:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 20 Dec 2020 19:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=G6GrFNYxw3Hpn
        lVCxc/Y26AMqdyir1vl9w0Jd4+e1xY=; b=m3VXv3fTWuG+aNWC2Bx7t9oV0jzRa
        446f7x6Jki/oxhC8SWH0+X7gF9mqAd9HdAXkOcXQyXl/BdPyGPFili6UyEuhExIs
        WN//+2jp8oBvMWzEl9eZX5vpsMBwvODI6+yn3olSZFiN+KrsnpemEkErL2k7cKK5
        ap83ZfnlGz5ebZCxT+fDSav8CaWKWmacLO3Xn/7d9yVM43Qzb+Y7lxLz9qcd3G5s
        vHELtXU3LbhFAEYWiKiQpMGMmSCovFfy4j8rB4Ue/T9kAE/gbtV+QXhD86LRhJz4
        8YmLL22xbEdYmyCsPtD/wLMq4IUZHiqvghkiAorwX8Dhu7zwtxSS5rnng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=G6GrFNYxw3HpnlVCxc/Y26AMqdyir1vl9w0Jd4+e1xY=; b=h77b8TCU
        wSGbAzb6GrMsCt4X7FEOkEr/a2aCMzvKdYCGYtuFs+r++hQGgDLqg7bosOyZZnYT
        bzzpPXc3GXas1euO6lEUorHjV+lRtSRaWSCLxVgSAet+enIxSAzInVsSbwLFB/3z
        RxNnLyuux798GDVmgBXalxxObKbw9ld+KkoNCT7feWPafxvytStRqIuIGjC5QuQS
        HuiB9UX0lUCfwlpp6IDxMbcuySHAnKpUkZzFDtjssOed1XIEa63a+j0YQz/XuBjy
        1EqE1VcICjQjc3sH9/yLhShQfVdracLxM9TRf+C5/jmjC1UIAwZofzslpLoapKE0
        YuaP/kwO12kkIQ==
X-ME-Sender: <xms:OfLfX0I-VeQKpZRdijoLZAGNLXpr3RxjUBKYar8qPRZGL2SwpIp6ow>
    <xme:OfLfX0LqCLdXk8ZWe6zhmEt4Z_TPxy-BOQpc6nBTrB1zXljY6WBnkI2lYwIMg4HWY
    IdrFGXOK-8GFLgFzRY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtuddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepgeduheekudduheektedvveffieevteetfeefieekudffieduudet
    vdetffeileeknecuffhomhgrihhnpehophgvnhhgrhhouhhprdhorhhgpdhphhihshhitg
    grlhhmvghmohhrhigslhhotghkrdhruhhnnecukfhppeeghedrfeefrdehtddrvdehgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgi
    hunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:OfLfX0tiexmnrlWm05fe77Bbjn8d8de3YOhLTXQLvSbjMwXGZEQwPQ>
    <xmx:OfLfXxao359w91XssSEuGeRf46M_XEW1F2lElbfOPDMdkblFefxBqA>
    <xmx:OfLfX7YZykcPmV0qmeYBUi8OesIUYggtZLKBta9R3zz1iQg60FXxZg>
    <xmx:OfLfXxx9-VNDQvkfy9MvdItXzE3GsgJmbteGJiCTVCswZ7j9GroAsyfexKJjpz8D>
Received: from strike.U-LINK.com (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1EF424005A;
        Sun, 20 Dec 2020 19:54:07 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Alistair Francis <alistair@alistair23.me>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org
Subject: [PATCH 5/9] elf2dmp: Rename PAGE_SIZE to ELF2DMP_PAGE_SIZE
Date:   Mon, 21 Dec 2020 08:53:14 +0800
Message-Id: <20201221005318.11866-6-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As per POSIX specification of limits.h [1], OS libc may define
PAGE_SIZE in limits.h.

To prevent collosion of definition, we rename PAGE_SIZE here.

[1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 contrib/elf2dmp/addrspace.c |  4 ++--
 contrib/elf2dmp/addrspace.h |  6 +++---
 contrib/elf2dmp/main.c      | 18 +++++++++---------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/contrib/elf2dmp/addrspace.c b/contrib/elf2dmp/addrspace.c
index 8a76069cb5..53ded17061 100644
--- a/contrib/elf2dmp/addrspace.c
+++ b/contrib/elf2dmp/addrspace.c
@@ -207,8 +207,8 @@ int va_space_rw(struct va_space *vs, uint64_t addr,
         void *buf, size_t size, int is_write)
 {
     while (size) {
-        uint64_t page = addr & PFN_MASK;
-        size_t s = (page + PAGE_SIZE) - addr;
+        uint64_t page = addr & ELF2DMP_PFN_MASK;
+        size_t s = (page + ELF2DMP_PAGE_SIZE) - addr;
         void *ptr;
 
         s = (s > size) ? size : s;
diff --git a/contrib/elf2dmp/addrspace.h b/contrib/elf2dmp/addrspace.h
index d87f6a18c6..00b44c1218 100644
--- a/contrib/elf2dmp/addrspace.h
+++ b/contrib/elf2dmp/addrspace.h
@@ -10,9 +10,9 @@
 
 #include "qemu_elf.h"
 
-#define PAGE_BITS 12
-#define PAGE_SIZE (1ULL << PAGE_BITS)
-#define PFN_MASK (~(PAGE_SIZE - 1))
+#define ELF2DMP_PAGE_BITS 12
+#define ELF2DMP_PAGE_SIZE (1ULL << ELF2DMP_PAGE_BITS)
+#define ELF2DMP_PFN_MASK (~(ELF2DMP_PAGE_SIZE - 1))
 
 #define INVALID_PA  UINT64_MAX
 
diff --git a/contrib/elf2dmp/main.c b/contrib/elf2dmp/main.c
index ac746e49e0..20b477d582 100644
--- a/contrib/elf2dmp/main.c
+++ b/contrib/elf2dmp/main.c
@@ -244,8 +244,8 @@ static int fill_header(WinDumpHeader64 *hdr, struct pa_space *ps,
     WinDumpHeader64 h;
     size_t i;
 
-    QEMU_BUILD_BUG_ON(KUSD_OFFSET_SUITE_MASK >= PAGE_SIZE);
-    QEMU_BUILD_BUG_ON(KUSD_OFFSET_PRODUCT_TYPE >= PAGE_SIZE);
+    QEMU_BUILD_BUG_ON(KUSD_OFFSET_SUITE_MASK >= ELF2DMP_PAGE_SIZE);
+    QEMU_BUILD_BUG_ON(KUSD_OFFSET_PRODUCT_TYPE >= ELF2DMP_PAGE_SIZE);
 
     if (!suite_mask || !product_type) {
         return 1;
@@ -281,14 +281,14 @@ static int fill_header(WinDumpHeader64 *hdr, struct pa_space *ps,
     };
 
     for (i = 0; i < ps->block_nr; i++) {
-        h.PhysicalMemoryBlock.NumberOfPages += ps->block[i].size / PAGE_SIZE;
+        h.PhysicalMemoryBlock.NumberOfPages += ps->block[i].size / ELF2DMP_PAGE_SIZE;
         h.PhysicalMemoryBlock.Run[i] = (WinDumpPhyMemRun64) {
-            .BasePage = ps->block[i].paddr / PAGE_SIZE,
-            .PageCount = ps->block[i].size / PAGE_SIZE,
+            .BasePage = ps->block[i].paddr / ELF2DMP_PAGE_SIZE,
+            .PageCount = ps->block[i].size / ELF2DMP_PAGE_SIZE,
         };
     }
 
-    h.RequiredDumpSpace += h.PhysicalMemoryBlock.NumberOfPages << PAGE_BITS;
+    h.RequiredDumpSpace += h.PhysicalMemoryBlock.NumberOfPages << ELF2DMP_PAGE_BITS;
 
     *hdr = h;
 
@@ -379,7 +379,7 @@ static int pe_get_pdb_symstore_hash(uint64_t base, void *start_addr,
     size_t pdb_name_sz;
     size_t i;
 
-    QEMU_BUILD_BUG_ON(sizeof(*dos_hdr) >= PAGE_SIZE);
+    QEMU_BUILD_BUG_ON(sizeof(*dos_hdr) >= ELF2DMP_PAGE_SIZE);
 
     if (memcmp(&dos_hdr->e_magic, e_magic, sizeof(e_magic))) {
         return 1;
@@ -509,10 +509,10 @@ int main(int argc, char *argv[])
     }
     printf("CPU #0 IDT[0] -> 0x%016"PRIx64"\n", idt_desc_addr(first_idt_desc));
 
-    KernBase = idt_desc_addr(first_idt_desc) & ~(PAGE_SIZE - 1);
+    KernBase = idt_desc_addr(first_idt_desc) & ~(ELF2DMP_PAGE_SIZE - 1);
     printf("Searching kernel downwards from 0x%016"PRIx64"...\n", KernBase);
 
-    for (; KernBase >= 0xfffff78000000000; KernBase -= PAGE_SIZE) {
+    for (; KernBase >= 0xfffff78000000000; KernBase -= ELF2DMP_PAGE_SIZE) {
         nt_start_addr = va_space_resolve(&vs, KernBase);
         if (!nt_start_addr) {
             continue;
-- 
2.29.2

