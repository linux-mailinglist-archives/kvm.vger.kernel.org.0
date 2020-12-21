Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A4B2DF754
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 01:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgLUAzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 19:55:35 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:58109 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbgLUAzf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Dec 2020 19:55:35 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 17363580427;
        Sun, 20 Dec 2020 19:54:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 20 Dec 2020 19:54:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=zCKncd9YBiJLe
        /SIK46OV+jqTbALSNNeyfKkVIBdzbQ=; b=bVgCmclr1Iko8K5v3zpByutM15xeU
        E6An0F6L9PO65AO2T4DBJXskDWWOYSiap1ieS8GPXoVTsm01JV4RE7Zdj8b3q6vf
        t3VdrPZnRCHSXVyUhXn8MU4IPR8RDOrF0f4hIDSvRc/nHauok9LBw5/pGXSvfszK
        1A7zAyp2yoEgcg22nSt3QY8JBClBMrMl3CTIeOQ2Tnt48CrbxrQgZf5uuBAOPetX
        +Iyr7ZXrLLhFHgcXoWf5BAw4og/j8hlNXAGQS6KbhcneQIkzVUGo6LBHNdvrWJuI
        AK9Lbi0SsVqc53CEwg9zGn8gVhSkW5DWJbB5Mg6RhquQnC1n0hMYwamGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zCKncd9YBiJLe/SIK46OV+jqTbALSNNeyfKkVIBdzbQ=; b=MdzJ7l3Z
        GlxIEztRG70zvXN8MmOKTf0hidDPSyjfdmjiJATwdniN4lfx0JLYKkca+972hI/R
        AOe2ntN5MFNqvV6NXJ8O7Q0BD0vfjC2wIsKcNT5rragJwK5b6TXNdYATN2REpRln
        IneBvHJHG9UG9uXgLXXrXxerw9zitbvBG15KOP9ib82bVXwZwF55D/PXl3iHnj9k
        r1taxEbC3FO8GbsjFsYGpbfmDP5TB6uF4faLpQcTU1Y9ZYBuUkaxBUhNVmAxiwU0
        EJdXiYqlXlnjeVQ6c9MMz2N4+wZFrFZZRIyucKeJRvSk+437Bk2f9RdQ+m0OdJfQ
        8DJToMpINHWfvg==
X-ME-Sender: <xms:RPLfXxIRc5Lcm4-jP30K8aA4Ty5RvfQDu635aIrMeE6iOjkroxT25g>
    <xme:RPLfX9KM4lyVQy8NgqXgP8CfjfCEM51bI8m_ioF8vJMFpqpUtW-7uImbuYvkJC3Pc
    mgKAS_xCvb8r77GyxY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtuddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnheptdevhedvfeelgefhueevffejueffteffkefhveeiudejieeivedu
    vdeitdehffejnecuffhomhgrihhnpehophgvnhhgrhhouhhprdhorhhgnecukfhppeeghe
    drfeefrdehtddrvdehgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:RPLfX5v58vsx7hk9EXBceeO0bvPDgFwLIYSpNWt9ZkGyHvI2MhEGwA>
    <xmx:RPLfXyb1fFy53ncaANO-XuiRweLnYNC-5Zt8KTRlQO5A7qfSC29X_A>
    <xmx:RPLfX4ZJwNS5nW45vxaQPkJXixaYTXUXzycYASTr8WqOp4b0JaTsPA>
    <xmx:RPLfX-ytoaboPKuev0Okn0NbMBNFS8PAkjAC7OGFN5OsjZoTXG5UWvPYlvVOp6JX>
Received: from strike.U-LINK.com (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A242240057;
        Sun, 20 Dec 2020 19:54:17 -0500 (EST)
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
Subject: [PATCH 6/9] hw/block/nand: Rename PAGE_SIZE to NAND_PAGE_SIZE
Date:   Mon, 21 Dec 2020 08:53:15 +0800
Message-Id: <20201221005318.11866-7-jiaxun.yang@flygoat.com>
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
 hw/block/nand.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/hw/block/nand.c b/hw/block/nand.c
index 1d7a48a2ec..17645667d8 100644
--- a/hw/block/nand.c
+++ b/hw/block/nand.c
@@ -114,24 +114,24 @@ static void mem_and(uint8_t *dest, const uint8_t *src, size_t n)
 # define NAND_IO
 
 # define PAGE(addr)		((addr) >> ADDR_SHIFT)
-# define PAGE_START(page)	(PAGE(page) * (PAGE_SIZE + OOB_SIZE))
+# define PAGE_START(page)	(PAGE(page) * (NAND_PAGE_SIZE + OOB_SIZE))
 # define PAGE_MASK		((1 << ADDR_SHIFT) - 1)
 # define OOB_SHIFT		(PAGE_SHIFT - 5)
 # define OOB_SIZE		(1 << OOB_SHIFT)
 # define SECTOR(addr)		((addr) >> (9 + ADDR_SHIFT - PAGE_SHIFT))
 # define SECTOR_OFFSET(addr)	((addr) & ((511 >> PAGE_SHIFT) << 8))
 
-# define PAGE_SIZE		256
+# define NAND_PAGE_SIZE     256
 # define PAGE_SHIFT		8
 # define PAGE_SECTORS		1
 # define ADDR_SHIFT		8
 # include "nand.c"
-# define PAGE_SIZE		512
+# define NAND_PAGE_SIZE     512
 # define PAGE_SHIFT		9
 # define PAGE_SECTORS		1
 # define ADDR_SHIFT		8
 # include "nand.c"
-# define PAGE_SIZE		2048
+# define NAND_PAGE_SIZE		2048
 # define PAGE_SHIFT		11
 # define PAGE_SECTORS		4
 # define ADDR_SHIFT		16
@@ -661,7 +661,7 @@ type_init(nand_register_types)
 #else
 
 /* Program a single page */
-static void glue(nand_blk_write_, PAGE_SIZE)(NANDFlashState *s)
+static void glue(nand_blk_write_, NAND_PAGE_SIZE)(NANDFlashState *s)
 {
     uint64_t off, page, sector, soff;
     uint8_t iobuf[(PAGE_SECTORS + 2) * 0x200];
@@ -681,11 +681,11 @@ static void glue(nand_blk_write_, PAGE_SIZE)(NANDFlashState *s)
             return;
         }
 
-        mem_and(iobuf + (soff | off), s->io, MIN(s->iolen, PAGE_SIZE - off));
-        if (off + s->iolen > PAGE_SIZE) {
+        mem_and(iobuf + (soff | off), s->io, MIN(s->iolen, NAND_PAGE_SIZE - off));
+        if (off + s->iolen > NAND_PAGE_SIZE) {
             page = PAGE(s->addr);
-            mem_and(s->storage + (page << OOB_SHIFT), s->io + PAGE_SIZE - off,
-                            MIN(OOB_SIZE, off + s->iolen - PAGE_SIZE));
+            mem_and(s->storage + (page << OOB_SHIFT), s->io + NAND_PAGE_SIZE - off,
+                            MIN(OOB_SIZE, off + s->iolen - NAND_PAGE_SIZE));
         }
 
         if (blk_pwrite(s->blk, sector << BDRV_SECTOR_BITS, iobuf,
@@ -713,7 +713,7 @@ static void glue(nand_blk_write_, PAGE_SIZE)(NANDFlashState *s)
 }
 
 /* Erase a single block */
-static void glue(nand_blk_erase_, PAGE_SIZE)(NANDFlashState *s)
+static void glue(nand_blk_erase_, NAND_PAGE_SIZE)(NANDFlashState *s)
 {
     uint64_t i, page, addr;
     uint8_t iobuf[0x200] = { [0 ... 0x1ff] = 0xff, };
@@ -725,7 +725,7 @@ static void glue(nand_blk_erase_, PAGE_SIZE)(NANDFlashState *s)
 
     if (!s->blk) {
         memset(s->storage + PAGE_START(addr),
-                        0xff, (PAGE_SIZE + OOB_SIZE) << s->erase_shift);
+                        0xff, (NAND_PAGE_SIZE + OOB_SIZE) << s->erase_shift);
     } else if (s->mem_oob) {
         memset(s->storage + (PAGE(addr) << OOB_SHIFT),
                         0xff, OOB_SIZE << s->erase_shift);
@@ -751,7 +751,7 @@ static void glue(nand_blk_erase_, PAGE_SIZE)(NANDFlashState *s)
 
         memset(iobuf, 0xff, 0x200);
         i = (addr & ~0x1ff) + 0x200;
-        for (addr += ((PAGE_SIZE + OOB_SIZE) << s->erase_shift) - 0x200;
+        for (addr += ((NAND_PAGE_SIZE + OOB_SIZE) << s->erase_shift) - 0x200;
                         i < addr; i += 0x200) {
             if (blk_pwrite(s->blk, i, iobuf, BDRV_SECTOR_SIZE, 0) < 0) {
                 printf("%s: write error in sector %" PRIu64 "\n",
@@ -772,7 +772,7 @@ static void glue(nand_blk_erase_, PAGE_SIZE)(NANDFlashState *s)
     }
 }
 
-static void glue(nand_blk_load_, PAGE_SIZE)(NANDFlashState *s,
+static void glue(nand_blk_load_, NAND_PAGE_SIZE)(NANDFlashState *s,
                 uint64_t addr, int offset)
 {
     if (PAGE(addr) >= s->pages) {
@@ -786,7 +786,7 @@ static void glue(nand_blk_load_, PAGE_SIZE)(NANDFlashState *s,
                 printf("%s: read error in sector %" PRIu64 "\n",
                                 __func__, SECTOR(addr));
             }
-            memcpy(s->io + SECTOR_OFFSET(s->addr) + PAGE_SIZE,
+            memcpy(s->io + SECTOR_OFFSET(s->addr) + NAND_PAGE_SIZE,
                             s->storage + (PAGE(s->addr) << OOB_SHIFT),
                             OOB_SIZE);
             s->ioaddr = s->io + SECTOR_OFFSET(s->addr) + offset;
@@ -800,23 +800,23 @@ static void glue(nand_blk_load_, PAGE_SIZE)(NANDFlashState *s,
         }
     } else {
         memcpy(s->io, s->storage + PAGE_START(s->addr) +
-                        offset, PAGE_SIZE + OOB_SIZE - offset);
+                        offset, NAND_PAGE_SIZE + OOB_SIZE - offset);
         s->ioaddr = s->io;
     }
 }
 
-static void glue(nand_init_, PAGE_SIZE)(NANDFlashState *s)
+static void glue(nand_init_, NAND_PAGE_SIZE)(NANDFlashState *s)
 {
     s->oob_shift = PAGE_SHIFT - 5;
     s->pages = s->size >> PAGE_SHIFT;
     s->addr_shift = ADDR_SHIFT;
 
-    s->blk_erase = glue(nand_blk_erase_, PAGE_SIZE);
-    s->blk_write = glue(nand_blk_write_, PAGE_SIZE);
-    s->blk_load = glue(nand_blk_load_, PAGE_SIZE);
+    s->blk_erase = glue(nand_blk_erase_, NAND_PAGE_SIZE);
+    s->blk_write = glue(nand_blk_write_, NAND_PAGE_SIZE);
+    s->blk_load = glue(nand_blk_load_, NAND_PAGE_SIZE);
 }
 
-# undef PAGE_SIZE
+# undef NAND_PAGE_SIZE
 # undef PAGE_SHIFT
 # undef PAGE_SECTORS
 # undef ADDR_SHIFT
-- 
2.29.2

