Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E272F9A0A
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbhARGka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:40:30 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:45017 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731791AbhARGkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:40:17 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 66B3316B0;
        Mon, 18 Jan 2021 01:38:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 01:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=JTe4D5W39+VsE
        I965mQwGabhGQ49JRkP3Msu7hBi17U=; b=roAetzHyYROCAOKzP4DJ32++2D8em
        t1XzogpI2+0xrZ1G0Hd5WDAHMMY9cG0YXaP9o3iDRi+2optlQlbak/qNG9aE+3Ho
        Xah7Svm6qKbhk9nsgMdSb31Tv8nX1TFA1fYDskblNF+c+GRNsApFtEHyJOT98Zh4
        ECYM/ivkxTV4yW/9172fHhBk2PcgPjP5jHy3oFpFHfmru5PS8SwTwJnYdtjwRGFC
        jlgwo9Kg7Wp+JlGl3gTDDq46dac/vpFRMbltzWQo4mRaE/ZkuNc3rFmSSXkCL+Dq
        nv1JgW+m0Ay8AAW64tAXFEBJuQPalYPRcW3GRGJzgWKPXDH4sNLONxifA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=JTe4D5W39+VsEI965mQwGabhGQ49JRkP3Msu7hBi17U=; b=iI/ZXW6S
        YEDfWT71qXGiVYFdL2SpiwMZeSp07qGQXljtV76iEemQb6D4U4DojAm61JTULBnL
        VgJAyEPUuiycUXPfexfcZiKpWn5pTBH6nP+8lnYdjAeJF8JFKOOzMgkQk7yaNYlX
        1I5F4UbtH0sa/bLslt1AlsJzXw3UDDgRaJeTjxnOH/2L6LzMrlKmxri5x6ljEibU
        RBDKsa7qtDnR/3rBdJHLzw4R9kINgvXZf2mhtCfXlxtYKlpv28QRub3KNF2f/rJz
        MoHF2/WCbAqtZxSrhJVsBQ49a8RcOhto9u2F6tPfNym5XfvSqvBM4GkWRNfYUJY8
        fZBtrNfYnJEjlw==
X-ME-Sender: <xms:_CwFYCXLcg77GOkPOtCAVaw2V2lJLBhLB75eFiOGnC1PIGqWMj4tSw>
    <xme:_CwFYOnYde20oj7O6kPwIvBev_GZDt5Tik0JAWskv7_Yu9fdJqKlLX7WRrvcb26Eq
    j9kqithOLKmRqZDJTE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeegudehkeduudehkeetvdevffeiveetteeffeeikeduffeiuddutedv
    teffieelkeenucffohhmrghinhepohhpvghnghhrohhuphdrohhrghdpphhhhihsihgtrg
    hlmhgvmhhorhihsghlohgtkhdrrhhunhenucfkphepudduiedrvddvkedrkeegrddvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguh
    hnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:_CwFYGYJO_iKwnpEF_Jpv9mmox9YbiRAbw18T28SoRVFeJR8jJpvVQ>
    <xmx:_CwFYJUQgB6-3cj5feAqsTfjUMmMJFpEI_jJh1XSzG5dHvhBKNBuBg>
    <xmx:_CwFYMmxDMcrKvU0C02dbNq8bpdV0Czlh_OvTEEaGl5a98QbzsS9zw>
    <xmx:_CwFYAkjsIxVPVFN49Tr98cmaj-WPMITWayLvoUowJb2e5L7W0SZ2d2y3-VTtG5d>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D2D924005C;
        Mon, 18 Jan 2021 01:38:46 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2 5/9] elf2dmp: Rename PAGE_SIZE to ELF2DMP_PAGE_SIZE
Date:   Mon, 18 Jan 2021 14:38:04 +0800
Message-Id: <20210118063808.12471-6-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 contrib/elf2dmp/addrspace.h |  6 +++---
 contrib/elf2dmp/addrspace.c |  4 ++--
 contrib/elf2dmp/main.c      | 18 +++++++++---------
 3 files changed, 14 insertions(+), 14 deletions(-)

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
2.30.0

