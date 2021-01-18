Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A42F9A0B
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbhARGkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:40:31 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:35419 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732646AbhARGkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:40:17 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 8DBC416B2;
        Mon, 18 Jan 2021 01:39:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 01:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=6/l1gmbJPtuhW
        OiIQ/udYtmodEoVrJsKo29dldMDHEM=; b=FCwq//oZhtYnvQ5/G2N69zhwSHFn2
        xiBIQTLr77eDTsVCnxI/33qB/0/uhS6lt20Xjuw1oq99p2tsoKwzbblXv0PBL4O7
        BCdGtkfym3bBe+6+DIHqwY6Yps7vouBukypWV9wUfApf6RsXXPTXi198HT6+4yd2
        sVtdSfYh2tr5WOCLv75tbE9VvGn4QS9HxjCYBAviQ/kZoMyfjPRFJtkVKxaaKUBO
        u5GQJkGy8NMGjf97Ww5lFiTItRdfdmi/tirvIipthVfo+PKqXtGYciieurnzx/pz
        tTizs450TM1FcWL15d3FjNT7WEgkJ0iTaR95BcqfA8VecKBdiXrZWiESQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=6/l1gmbJPtuhWOiIQ/udYtmodEoVrJsKo29dldMDHEM=; b=TlBhvzip
        EUXbSEDlq7kmayb7Suf/6s0ymvcOInPZb9T1I3B2wscjuyBpq5TSda/JohfnzeUt
        xWWEPIzUvEdT8WwOGfAgeEyCiyMMJF7NGg758RZwPYlv2KUfU837ztGRol9+uCWu
        HVzJcBfhkLoBf058m+KIN3cHGZd6jrPzW5ad47ePg3qzFCuOAj4YmcDKjVL4ZuK/
        o58bP+mwcACLIP1BA5796C2m7y+KpNldTDMWIafoOyLByZhDfC+YAQdirPX+RKA/
        HwY3DZ0tED+qZ+thNE8T93zsXh0Ur/WK92MiGOVu3TI3VM5iytLUJn6GIW0E/vwW
        0HxomvECAbnkiw==
X-ME-Sender: <xms:Ay0FYOlRajokC6i2T9gV_MkmrauGmeX-zdFWISJkHkGp_c3pp4QvCw>
    <xme:Ay0FYF1Snj13Po8qMXRXVWVJll1p7AyjuN6RKu-4XgfShtgUyH6nr42ymrm6kxbcN
    iswk0bTLKDEH0VqDBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpedtveehvdefleeghfeuveffjeeuffetffekhfeviedujeeiieevuddv
    iedtheffjeenucffohhmrghinhepohhpvghnghhrohhuphdrohhrghenucfkphepudduie
    drvddvkedrkeegrddvnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghi
    lhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:Ay0FYMr3hAVEFLNUcB8uqDOGDV1J-PvscjRvsv3V0UINDcFb65mN-g>
    <xmx:Ay0FYClpWK_F_dpIg3UZEL-m-hqRZuJmbEDMU263nGYYbMoz4GWtzA>
    <xmx:Ay0FYM1gL9MQJCQfsssTkhB-JPWyjo6N-WFaMnDUcpU1W2JmJmjqww>
    <xmx:Ay0FYP27vxm8Ru7QuyCzeBQ5eU7MHwuywXJRzGUwCYEGFjvENVPh7yJL6Aff38uq>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3F1C240066;
        Mon, 18 Jan 2021 01:38:52 -0500 (EST)
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
Subject: [PATCH v2 6/9] tests: Rename PAGE_SIZE definitions
Date:   Mon, 18 Jan 2021 14:38:05 +0800
Message-Id: <20210118063808.12471-7-jiaxun.yang@flygoat.com>
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

Self defined PAGE_SIZE is frequently used in tests, to prevent
collosion of definition, we give PAGE_SIZE definitons reasonable
prefixs.

[1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 tests/migration/stress.c            | 10 ++---
 tests/qtest/libqos/malloc-pc.c      |  4 +-
 tests/qtest/libqos/malloc-spapr.c   |  4 +-
 tests/qtest/m25p80-test.c           | 54 +++++++++++-----------
 tests/tcg/multiarch/system/memory.c |  6 +--
 tests/test-xbzrle.c                 | 70 ++++++++++++++---------------
 6 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/tests/migration/stress.c b/tests/migration/stress.c
index de45e8e490..b7240a15c8 100644
--- a/tests/migration/stress.c
+++ b/tests/migration/stress.c
@@ -27,7 +27,7 @@
 
 const char *argv0;
 
-#define PAGE_SIZE 4096
+#define RAM_PAGE_SIZE 4096
 
 #ifndef CONFIG_GETTID
 static int gettid(void)
@@ -158,11 +158,11 @@ static unsigned long long now(void)
 
 static void stressone(unsigned long long ramsizeMB)
 {
-    size_t pagesPerMB = 1024 * 1024 / PAGE_SIZE;
+    size_t pagesPerMB = 1024 * 1024 / RAM_PAGE_SIZE;
     g_autofree char *ram = g_malloc(ramsizeMB * 1024 * 1024);
     char *ramptr;
     size_t i, j, k;
-    g_autofree char *data = g_malloc(PAGE_SIZE);
+    g_autofree char *data = g_malloc(RAM_PAGE_SIZE);
     char *dataptr;
     size_t nMB = 0;
     unsigned long long before, after;
@@ -174,7 +174,7 @@ static void stressone(unsigned long long ramsizeMB)
      * calloc instead :-) */
     memset(ram, 0xfe, ramsizeMB * 1024 * 1024);
 
-    if (random_bytes(data, PAGE_SIZE) < 0) {
+    if (random_bytes(data, RAM_PAGE_SIZE) < 0) {
         return;
     }
 
@@ -186,7 +186,7 @@ static void stressone(unsigned long long ramsizeMB)
         for (i = 0; i < ramsizeMB; i++, nMB++) {
             for (j = 0; j < pagesPerMB; j++) {
                 dataptr = data;
-                for (k = 0; k < PAGE_SIZE; k += sizeof(long long)) {
+                for (k = 0; k < RAM_PAGE_SIZE; k += sizeof(long long)) {
                     ramptr += sizeof(long long);
                     dataptr += sizeof(long long);
                     *(unsigned long long *)ramptr ^= *(unsigned long long *)dataptr;
diff --git a/tests/qtest/libqos/malloc-pc.c b/tests/qtest/libqos/malloc-pc.c
index 16ff9609cc..f1e3b392a5 100644
--- a/tests/qtest/libqos/malloc-pc.c
+++ b/tests/qtest/libqos/malloc-pc.c
@@ -18,7 +18,7 @@
 
 #include "qemu-common.h"
 
-#define PAGE_SIZE (4096)
+#define ALLOC_PAGE_SIZE (4096)
 
 void pc_alloc_init(QGuestAllocator *s, QTestState *qts, QAllocOpts flags)
 {
@@ -26,7 +26,7 @@ void pc_alloc_init(QGuestAllocator *s, QTestState *qts, QAllocOpts flags)
     QFWCFG *fw_cfg = pc_fw_cfg_init(qts);
 
     ram_size = qfw_cfg_get_u64(fw_cfg, FW_CFG_RAM_SIZE);
-    alloc_init(s, flags, 1 << 20, MIN(ram_size, 0xE0000000), PAGE_SIZE);
+    alloc_init(s, flags, 1 << 20, MIN(ram_size, 0xE0000000), ALLOC_PAGE_SIZE);
 
     /* clean-up */
     pc_fw_cfg_uninit(fw_cfg);
diff --git a/tests/qtest/libqos/malloc-spapr.c b/tests/qtest/libqos/malloc-spapr.c
index 84862e4876..05b306c191 100644
--- a/tests/qtest/libqos/malloc-spapr.c
+++ b/tests/qtest/libqos/malloc-spapr.c
@@ -10,7 +10,7 @@
 
 #include "qemu-common.h"
 
-#define PAGE_SIZE 4096
+#define SPAPR_PAGE_SIZE 4096
 
 /* Memory must be a multiple of 256 MB,
  * so we have at least 256MB
@@ -19,5 +19,5 @@
 
 void spapr_alloc_init(QGuestAllocator *s, QTestState *qts, QAllocOpts flags)
 {
-    alloc_init(s, flags, 1 << 20, SPAPR_MIN_SIZE, PAGE_SIZE);
+    alloc_init(s, flags, 1 << 20, SPAPR_MIN_SIZE, SPAPR_PAGE_SIZE);
 }
diff --git a/tests/qtest/m25p80-test.c b/tests/qtest/m25p80-test.c
index 50c6b79fb3..f860cef5f0 100644
--- a/tests/qtest/m25p80-test.c
+++ b/tests/qtest/m25p80-test.c
@@ -62,7 +62,7 @@ enum {
 #define FLASH_JEDEC         0x20ba19  /* n25q256a */
 #define FLASH_SIZE          (32 * 1024 * 1024)
 
-#define PAGE_SIZE           256
+#define FLASH_PAGE_SIZE           256
 
 /*
  * Use an explicit bswap for the values read/wrote to the flash region
@@ -165,7 +165,7 @@ static void read_page(uint32_t addr, uint32_t *page)
     writel(ASPEED_FLASH_BASE, make_be32(addr));
 
     /* Continuous read are supported */
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         page[i] = make_be32(readl(ASPEED_FLASH_BASE));
     }
     spi_ctrl_stop_user();
@@ -178,15 +178,15 @@ static void read_page_mem(uint32_t addr, uint32_t *page)
     /* move out USER mode to use direct reads from the AHB bus */
     spi_ctrl_setmode(CTRL_READMODE, READ);
 
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         page[i] = make_be32(readl(ASPEED_FLASH_BASE + addr + i * 4));
     }
 }
 
 static void test_erase_sector(void)
 {
-    uint32_t some_page_addr = 0x600 * PAGE_SIZE;
-    uint32_t page[PAGE_SIZE / 4];
+    uint32_t some_page_addr = 0x600 * FLASH_PAGE_SIZE;
+    uint32_t page[FLASH_PAGE_SIZE / 4];
     int i;
 
     spi_conf(CONF_ENABLE_W0);
@@ -200,14 +200,14 @@ static void test_erase_sector(void)
 
     /* Previous page should be full of zeroes as backend is not
      * initialized */
-    read_page(some_page_addr - PAGE_SIZE, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    read_page(some_page_addr - FLASH_PAGE_SIZE, page);
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, 0x0);
     }
 
     /* But this one was erased */
     read_page(some_page_addr, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, 0xffffffff);
     }
 
@@ -216,8 +216,8 @@ static void test_erase_sector(void)
 
 static void test_erase_all(void)
 {
-    uint32_t some_page_addr = 0x15000 * PAGE_SIZE;
-    uint32_t page[PAGE_SIZE / 4];
+    uint32_t some_page_addr = 0x15000 * FLASH_PAGE_SIZE;
+    uint32_t page[FLASH_PAGE_SIZE / 4];
     int i;
 
     spi_conf(CONF_ENABLE_W0);
@@ -225,7 +225,7 @@ static void test_erase_all(void)
     /* Check some random page. Should be full of zeroes as backend is
      * not initialized */
     read_page(some_page_addr, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, 0x0);
     }
 
@@ -236,7 +236,7 @@ static void test_erase_all(void)
 
     /* Recheck that some random page */
     read_page(some_page_addr, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, 0xffffffff);
     }
 
@@ -245,9 +245,9 @@ static void test_erase_all(void)
 
 static void test_write_page(void)
 {
-    uint32_t my_page_addr = 0x14000 * PAGE_SIZE; /* beyond 16MB */
-    uint32_t some_page_addr = 0x15000 * PAGE_SIZE;
-    uint32_t page[PAGE_SIZE / 4];
+    uint32_t my_page_addr = 0x14000 * FLASH_PAGE_SIZE; /* beyond 16MB */
+    uint32_t some_page_addr = 0x15000 * FLASH_PAGE_SIZE;
+    uint32_t page[FLASH_PAGE_SIZE / 4];
     int i;
 
     spi_conf(CONF_ENABLE_W0);
@@ -259,20 +259,20 @@ static void test_write_page(void)
     writel(ASPEED_FLASH_BASE, make_be32(my_page_addr));
 
     /* Fill the page with its own addresses */
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         writel(ASPEED_FLASH_BASE, make_be32(my_page_addr + i * 4));
     }
     spi_ctrl_stop_user();
 
     /* Check what was written */
     read_page(my_page_addr, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, my_page_addr + i * 4);
     }
 
     /* Check some other page. It should be full of 0xff */
     read_page(some_page_addr, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, 0xffffffff);
     }
 
@@ -281,9 +281,9 @@ static void test_write_page(void)
 
 static void test_read_page_mem(void)
 {
-    uint32_t my_page_addr = 0x14000 * PAGE_SIZE; /* beyond 16MB */
-    uint32_t some_page_addr = 0x15000 * PAGE_SIZE;
-    uint32_t page[PAGE_SIZE / 4];
+    uint32_t my_page_addr = 0x14000 * FLASH_PAGE_SIZE; /* beyond 16MB */
+    uint32_t some_page_addr = 0x15000 * FLASH_PAGE_SIZE;
+    uint32_t page[FLASH_PAGE_SIZE / 4];
     int i;
 
     /* Enable 4BYTE mode for controller. This is should be strapped by
@@ -300,13 +300,13 @@ static void test_read_page_mem(void)
 
     /* Check what was written */
     read_page_mem(my_page_addr, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, my_page_addr + i * 4);
     }
 
     /* Check some other page. It should be full of 0xff */
     read_page_mem(some_page_addr, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, 0xffffffff);
     }
 
@@ -315,8 +315,8 @@ static void test_read_page_mem(void)
 
 static void test_write_page_mem(void)
 {
-    uint32_t my_page_addr = 0x15000 * PAGE_SIZE;
-    uint32_t page[PAGE_SIZE / 4];
+    uint32_t my_page_addr = 0x15000 * FLASH_PAGE_SIZE;
+    uint32_t page[FLASH_PAGE_SIZE / 4];
     int i;
 
     /* Enable 4BYTE mode for controller. This is should be strapped by
@@ -334,14 +334,14 @@ static void test_write_page_mem(void)
     /* move out USER mode to use direct writes to the AHB bus */
     spi_ctrl_setmode(CTRL_WRITEMODE, PP);
 
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         writel(ASPEED_FLASH_BASE + my_page_addr + i * 4,
                make_be32(my_page_addr + i * 4));
     }
 
     /* Check what was written */
     read_page_mem(my_page_addr, page);
-    for (i = 0; i < PAGE_SIZE / 4; i++) {
+    for (i = 0; i < FLASH_PAGE_SIZE / 4; i++) {
         g_assert_cmphex(page[i], ==, my_page_addr + i * 4);
     }
 
diff --git a/tests/tcg/multiarch/system/memory.c b/tests/tcg/multiarch/system/memory.c
index d124502d73..eb0ec6f8eb 100644
--- a/tests/tcg/multiarch/system/memory.c
+++ b/tests/tcg/multiarch/system/memory.c
@@ -20,12 +20,12 @@
 # error "Target does not specify CHECK_UNALIGNED"
 #endif
 
-#define PAGE_SIZE 4096             /* nominal 4k "pages" */
-#define TEST_SIZE (PAGE_SIZE * 4)  /* 4 pages */
+#define MEM_PAGE_SIZE 4096             /* nominal 4k "pages" */
+#define TEST_SIZE (MEM_PAGE_SIZE * 4)  /* 4 pages */
 
 #define ARRAY_SIZE(x) ((sizeof(x) / sizeof((x)[0])))
 
-__attribute__((aligned(PAGE_SIZE)))
+__attribute__((aligned(MEM_PAGE_SIZE)))
 static uint8_t test_data[TEST_SIZE];
 
 typedef void (*init_ufn) (int offset);
diff --git a/tests/test-xbzrle.c b/tests/test-xbzrle.c
index f5e08de91e..795d6f1cba 100644
--- a/tests/test-xbzrle.c
+++ b/tests/test-xbzrle.c
@@ -15,7 +15,7 @@
 #include "qemu/cutils.h"
 #include "../migration/xbzrle.h"
 
-#define PAGE_SIZE 4096
+#define XBZRLE_PAGE_SIZE 4096
 
 static void test_uleb(void)
 {
@@ -41,11 +41,11 @@ static void test_uleb(void)
 
 static void test_encode_decode_zero(void)
 {
-    uint8_t *buffer = g_malloc0(PAGE_SIZE);
-    uint8_t *compressed = g_malloc0(PAGE_SIZE);
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed = g_malloc0(XBZRLE_PAGE_SIZE);
     int i = 0;
     int dlen = 0;
-    int diff_len = g_test_rand_int_range(0, PAGE_SIZE - 1006);
+    int diff_len = g_test_rand_int_range(0, XBZRLE_PAGE_SIZE - 1006);
 
     for (i = diff_len; i > 0; i--) {
         buffer[1000 + i] = i;
@@ -55,8 +55,8 @@ static void test_encode_decode_zero(void)
     buffer[1000 + diff_len + 5] = 105;
 
     /* encode zero page */
-    dlen = xbzrle_encode_buffer(buffer, buffer, PAGE_SIZE, compressed,
-                       PAGE_SIZE);
+    dlen = xbzrle_encode_buffer(buffer, buffer, XBZRLE_PAGE_SIZE, compressed,
+                       XBZRLE_PAGE_SIZE);
     g_assert(dlen == 0);
 
     g_free(buffer);
@@ -65,11 +65,11 @@ static void test_encode_decode_zero(void)
 
 static void test_encode_decode_unchanged(void)
 {
-    uint8_t *compressed = g_malloc0(PAGE_SIZE);
-    uint8_t *test = g_malloc0(PAGE_SIZE);
+    uint8_t *compressed = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
     int i = 0;
     int dlen = 0;
-    int diff_len = g_test_rand_int_range(0, PAGE_SIZE - 1006);
+    int diff_len = g_test_rand_int_range(0, XBZRLE_PAGE_SIZE - 1006);
 
     for (i = diff_len; i > 0; i--) {
         test[1000 + i] = i + 4;
@@ -79,8 +79,8 @@ static void test_encode_decode_unchanged(void)
     test[1000 + diff_len + 5] = 109;
 
     /* test unchanged buffer */
-    dlen = xbzrle_encode_buffer(test, test, PAGE_SIZE, compressed,
-                                PAGE_SIZE);
+    dlen = xbzrle_encode_buffer(test, test, XBZRLE_PAGE_SIZE, compressed,
+                                XBZRLE_PAGE_SIZE);
     g_assert(dlen == 0);
 
     g_free(test);
@@ -89,21 +89,21 @@ static void test_encode_decode_unchanged(void)
 
 static void test_encode_decode_1_byte(void)
 {
-    uint8_t *buffer = g_malloc0(PAGE_SIZE);
-    uint8_t *test = g_malloc0(PAGE_SIZE);
-    uint8_t *compressed = g_malloc(PAGE_SIZE);
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed = g_malloc(XBZRLE_PAGE_SIZE);
     int dlen = 0, rc = 0;
     uint8_t buf[2];
 
-    test[PAGE_SIZE - 1] = 1;
+    test[XBZRLE_PAGE_SIZE - 1] = 1;
 
-    dlen = xbzrle_encode_buffer(buffer, test, PAGE_SIZE, compressed,
-                       PAGE_SIZE);
+    dlen = xbzrle_encode_buffer(buffer, test, XBZRLE_PAGE_SIZE, compressed,
+                       XBZRLE_PAGE_SIZE);
     g_assert(dlen == (uleb128_encode_small(&buf[0], 4095) + 2));
 
-    rc = xbzrle_decode_buffer(compressed, dlen, buffer, PAGE_SIZE);
-    g_assert(rc == PAGE_SIZE);
-    g_assert(memcmp(test, buffer, PAGE_SIZE) == 0);
+    rc = xbzrle_decode_buffer(compressed, dlen, buffer, XBZRLE_PAGE_SIZE);
+    g_assert(rc == XBZRLE_PAGE_SIZE);
+    g_assert(memcmp(test, buffer, XBZRLE_PAGE_SIZE) == 0);
 
     g_free(buffer);
     g_free(compressed);
@@ -112,18 +112,18 @@ static void test_encode_decode_1_byte(void)
 
 static void test_encode_decode_overflow(void)
 {
-    uint8_t *compressed = g_malloc0(PAGE_SIZE);
-    uint8_t *test = g_malloc0(PAGE_SIZE);
-    uint8_t *buffer = g_malloc0(PAGE_SIZE);
+    uint8_t *compressed = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
     int i = 0, rc = 0;
 
-    for (i = 0; i < PAGE_SIZE / 2 - 1; i++) {
+    for (i = 0; i < XBZRLE_PAGE_SIZE / 2 - 1; i++) {
         test[i * 2] = 1;
     }
 
     /* encode overflow */
-    rc = xbzrle_encode_buffer(buffer, test, PAGE_SIZE, compressed,
-                              PAGE_SIZE);
+    rc = xbzrle_encode_buffer(buffer, test, XBZRLE_PAGE_SIZE, compressed,
+                              XBZRLE_PAGE_SIZE);
     g_assert(rc == -1);
 
     g_free(buffer);
@@ -133,13 +133,13 @@ static void test_encode_decode_overflow(void)
 
 static void encode_decode_range(void)
 {
-    uint8_t *buffer = g_malloc0(PAGE_SIZE);
-    uint8_t *compressed = g_malloc(PAGE_SIZE);
-    uint8_t *test = g_malloc0(PAGE_SIZE);
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed = g_malloc(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
     int i = 0, rc = 0;
     int dlen = 0;
 
-    int diff_len = g_test_rand_int_range(0, PAGE_SIZE - 1006);
+    int diff_len = g_test_rand_int_range(0, XBZRLE_PAGE_SIZE - 1006);
 
     for (i = diff_len; i > 0; i--) {
         buffer[1000 + i] = i;
@@ -153,12 +153,12 @@ static void encode_decode_range(void)
     test[1000 + diff_len + 5] = 109;
 
     /* test encode/decode */
-    dlen = xbzrle_encode_buffer(test, buffer, PAGE_SIZE, compressed,
-                                PAGE_SIZE);
+    dlen = xbzrle_encode_buffer(test, buffer, XBZRLE_PAGE_SIZE, compressed,
+                                XBZRLE_PAGE_SIZE);
 
-    rc = xbzrle_decode_buffer(compressed, dlen, test, PAGE_SIZE);
-    g_assert(rc < PAGE_SIZE);
-    g_assert(memcmp(test, buffer, PAGE_SIZE) == 0);
+    rc = xbzrle_decode_buffer(compressed, dlen, test, XBZRLE_PAGE_SIZE);
+    g_assert(rc < XBZRLE_PAGE_SIZE);
+    g_assert(memcmp(test, buffer, XBZRLE_PAGE_SIZE) == 0);
 
     g_free(buffer);
     g_free(compressed);
-- 
2.30.0

