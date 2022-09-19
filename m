Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962B25BD824
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 01:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiISXTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 19:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiISXTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 19:19:08 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C9C4B0F8
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:19:07 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u9so2193742ejy.5
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=GY9FLwpbhpko1ROroTaJ6wfQD1OQmuRWRFOe6XO0HkE=;
        b=WvtWhaz7RfTahuePkkE9xIcuGxfWCiGa1wTboB9PRKNnjFohCiK5pF4LK4IJs9vf5N
         yZ9b8tZiP/Tk5sTxggCXSX9hx4EUFuokcV4BrpDDY1zJG3SQgv2WDt7AMvozCWevYw/y
         FMq1uucw4j5Oqi3St2U+VPdyyKPs808bAQonJw6bTfZqftbvg4Azml8efQ5tZ1HTfiv1
         i2uAlpDSRqaRvcSiFKosYvLwQd4zFza7DGwVf1WV4BT2+jgksxTrQDJm9O6L00Q8j9I8
         4KmIJLgd7IBUyEMozx+cv/IZSOQLBXyIH5zHVtq82KU+JwLn3+FsLbrutbLKXuQqQsVI
         bQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GY9FLwpbhpko1ROroTaJ6wfQD1OQmuRWRFOe6XO0HkE=;
        b=ERPZQSlgnM5CUfwVP+twA03pyxS7nzkYhUZCRMdmwtwS7ZL+YtqTqAXchxp6h2BZPl
         91J+iHuFp6p8UBTVX6JQwkVMEp9s5B6jqGac07F4yFc4emHEUAxeB8lLhKqO6iiWNrnT
         C6qFsnekShfo//FZXfscqvt3Wpxr+Mz2leTCH9hF0JWloAo95YNm0+s+35DiKKK76W9K
         aDsdx1L069t+4lv6/Fie8a+CA3RL0XRx41ln75OZw/w1DSFqY5yz61li552Cseq0qNO1
         x7oZwt7qAo0KyrO8w0NMj8rBF8r8/NkK0UQKSkpE45yahx/LEicUHuTkHFwBVmNsoLyX
         uyOw==
X-Gm-Message-State: ACrzQf2gLEU6Mu0pQRgvm32UJlZyrUU0DYk5Z600rvQLt5hGJnCIt/qn
        tjKEJzpNprZF0RFfhEWGcwQ=
X-Google-Smtp-Source: AMsMyM4qkgaEMGM0QJXD77Pkxb2n4WftV+KsIglPwhyeQygcGRI6lNjr6tviLaBlIrFPXV7KHzllzg==
X-Received: by 2002:a17:907:3e86:b0:6f5:917:10cc with SMTP id hs6-20020a1709073e8600b006f5091710ccmr15309153ejc.53.1663629545495;
        Mon, 19 Sep 2022 16:19:05 -0700 (PDT)
Received: from localhost.localdomain (dynamic-078-054-077-055.78.54.pool.telefonica.de. [78.54.77.55])
        by smtp.gmail.com with ESMTPSA id rn24-20020a170906d93800b00780f6071b5dsm4800926ejb.188.2022.09.19.16.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 16:19:05 -0700 (PDT)
From:   Bernhard Beschow <shentey@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bandan Das <bsd@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Sergio Lopez <slp@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Cameron Esfahani <dirty@apple.com>,
        Michael Rolnik <mrolnik@gmail.com>,
        Song Gao <gaosong@loongson.cn>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Greg Kurz <groug@kaod.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Peter Xu <peterx@redhat.com>, Joel Stanley <joel@jms.id.au>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        qemu-ppc@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Helge Deller <deller@gmx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-riscv@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Alexander Graf <agraf@csgraf.de>,
        Thomas Huth <thuth@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Eric Farman <farman@linux.ibm.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Alexander Bulekov <alxndr@bu.edu>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        xen-devel@lists.xenproject.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Snow <jsnow@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair@alistair23.me>,
        Jason Herne <jjherne@linux.ibm.com>,
        Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 8/9] softmmu/physmem: Let SysBusState absorb memory region and address space singletons
Date:   Tue, 20 Sep 2022 01:17:19 +0200
Message-Id: <20220919231720.163121-9-shentey@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919231720.163121-1-shentey@gmail.com>
References: <20220919231720.163121-1-shentey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These singletons are actually properties of the system bus but so far it
hasn't been modelled that way. Fix this to make this relationship very
obvious.

The idea of the patch is to restrain futher proliferation of the use of
get_system_memory() and get_system_io() which are "temprary interfaces"
"until a proper bus interface is available". This should now be the
case.

Note that the new attributes are values rather than a pointers. This
trades pointer dereferences for pointer arithmetic. The idea is to
reduce cache misses - a rule of thumb says that every pointer
dereference causes a cache miss while arithmetic is basically free.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 include/exec/address-spaces.h | 19 ++++++++++++---
 include/hw/sysbus.h           |  6 +++++
 softmmu/physmem.c             | 46 ++++++++++++++++++-----------------
 3 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/include/exec/address-spaces.h b/include/exec/address-spaces.h
index d5c8cbd718..b31bd8dcf0 100644
--- a/include/exec/address-spaces.h
+++ b/include/exec/address-spaces.h
@@ -23,17 +23,28 @@
 
 #ifndef CONFIG_USER_ONLY
 
-/* Get the root memory region.  This interface should only be used temporarily
- * until a proper bus interface is available.
+/**
+ * Get the root memory region.  This is a legacy function, provided for
+ * compatibility. Prefer using SysBusState::system_memory directly.
  */
 MemoryRegion *get_system_memory(void);
 
-/* Get the root I/O port region.  This interface should only be used
- * temporarily until a proper bus interface is available.
+/**
+ * Get the root I/O port region.  This is a legacy function, provided for
+ * compatibility. Prefer using SysBusState::system_io directly.
  */
 MemoryRegion *get_system_io(void);
 
+/**
+ * Get the root memory address space.  This is a legacy function, provided for
+ * compatibility. Prefer using SysBusState::address_space_memory directly.
+ */
 AddressSpace *get_address_space_memory(void);
+
+/**
+ * Get the root I/O port address space.  This is a legacy function, provided
+ * for compatibility. Prefer using SysBusState::address_space_io directly.
+ */
 AddressSpace *get_address_space_io(void);
 
 #endif
diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
index 5bb3b88501..516e9091dc 100644
--- a/include/hw/sysbus.h
+++ b/include/hw/sysbus.h
@@ -17,6 +17,12 @@ struct SysBusState {
     /*< private >*/
     BusState parent_obj;
     /*< public >*/
+
+    MemoryRegion system_memory;
+    MemoryRegion system_io;
+
+    AddressSpace address_space_io;
+    AddressSpace address_space_memory;
 };
 
 #define TYPE_SYS_BUS_DEVICE "sys-bus-device"
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 0ac920d446..07e9a9171c 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -86,12 +86,6 @@
  */
 RAMList ram_list = { .blocks = QLIST_HEAD_INITIALIZER(ram_list.blocks) };
 
-static MemoryRegion *system_memory;
-static MemoryRegion *system_io;
-
-static AddressSpace address_space_io;
-static AddressSpace address_space_memory;
-
 static MemoryRegion io_mem_unassigned;
 
 typedef struct PhysPageEntry PhysPageEntry;
@@ -146,7 +140,7 @@ typedef struct subpage_t {
 #define PHYS_SECTION_UNASSIGNED 0
 
 static void io_mem_init(void);
-static void memory_map_init(void);
+static void memory_map_init(SysBusState *sysbus);
 static void tcg_log_global_after_sync(MemoryListener *listener);
 static void tcg_commit(MemoryListener *listener);
 
@@ -2667,37 +2661,45 @@ static void tcg_commit(MemoryListener *listener)
     tlb_flush(cpuas->cpu);
 }
 
-static void memory_map_init(void)
+static void memory_map_init(SysBusState *sysbus)
 {
-    system_memory = g_malloc(sizeof(*system_memory));
+    MemoryRegion *system_memory = &sysbus->system_memory;
+    MemoryRegion *system_io = &sysbus->system_io;
 
     memory_region_init(system_memory, NULL, "system", UINT64_MAX);
-    address_space_init(&address_space_memory, system_memory, "memory");
+    address_space_init(&sysbus->address_space_memory, system_memory, "memory");
 
-    system_io = g_malloc(sizeof(*system_io));
     memory_region_init_io(system_io, NULL, &unassigned_io_ops, NULL, "io",
                           65536);
-    address_space_init(&address_space_io, system_io, "I/O");
+    address_space_init(&sysbus->address_space_io, system_io, "I/O");
 }
 
 MemoryRegion *get_system_memory(void)
 {
-    return system_memory;
+    assert(current_machine);
+
+    return &current_machine->main_system_bus.system_memory;
 }
 
 MemoryRegion *get_system_io(void)
 {
-    return system_io;
+    assert(current_machine);
+
+    return &current_machine->main_system_bus.system_io;
 }
 
 AddressSpace *get_address_space_memory(void)
 {
-    return &address_space_memory;
+    assert(current_machine);
+
+    return &current_machine->main_system_bus.address_space_memory;
 }
 
 AddressSpace *get_address_space_io(void)
 {
-    return &address_space_io;
+    assert(current_machine);
+
+    return &current_machine->main_system_bus.address_space_io;
 }
 
 static void invalidate_and_set_dirty(MemoryRegion *mr, hwaddr addr,
@@ -3003,7 +3005,7 @@ MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
 void cpu_physical_memory_rw(hwaddr addr, void *buf,
                             hwaddr len, bool is_write)
 {
-    address_space_rw(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
+    address_space_rw(get_address_space_memory(), addr, MEMTXATTRS_UNSPECIFIED,
                      buf, len, is_write);
 }
 
@@ -3074,7 +3076,7 @@ void cpu_flush_icache_range(hwaddr start, hwaddr len)
         return;
     }
 
-    address_space_write_rom_internal(&address_space_memory,
+    address_space_write_rom_internal(get_address_space_memory(),
                                      start, MEMTXATTRS_UNSPECIFIED,
                                      NULL, len, FLUSH_CACHE);
 }
@@ -3140,7 +3142,7 @@ void cpu_exec_init_all(void)
      */
     finalize_target_page_bits();
     io_mem_init();
-    memory_map_init();
+    memory_map_init(&current_machine->main_system_bus);
     qemu_mutex_init(&map_client_list_lock);
 }
 
@@ -3322,14 +3324,14 @@ void *cpu_physical_memory_map(hwaddr addr,
                               hwaddr *plen,
                               bool is_write)
 {
-    return address_space_map(&address_space_memory, addr, plen, is_write,
+    return address_space_map(get_address_space_memory(), addr, plen, is_write,
                              MEMTXATTRS_UNSPECIFIED);
 }
 
 void cpu_physical_memory_unmap(void *buffer, hwaddr len,
                                bool is_write, hwaddr access_len)
 {
-    return address_space_unmap(&address_space_memory, buffer, len,
+    return address_space_unmap(get_address_space_memory(), buffer, len,
                                is_write, access_len);
 }
 
@@ -3554,7 +3556,7 @@ bool cpu_physical_memory_is_io(hwaddr phys_addr)
     bool res;
 
     RCU_READ_LOCK_GUARD();
-    mr = address_space_translate(&address_space_memory,
+    mr = address_space_translate(get_address_space_memory(),
                                  phys_addr, &phys_addr, &l, false,
                                  MEMTXATTRS_UNSPECIFIED);
 
-- 
2.37.3

