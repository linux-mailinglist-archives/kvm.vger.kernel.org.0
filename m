Return-Path: <kvm+bounces-57865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC49B7F166
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 415106275F0
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A256215F4A;
	Wed, 17 Sep 2025 13:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="kYxhy6+9"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD0E285073
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114045; cv=none; b=qkABI2uP0Sor7QxoNkqwvtNAx/tCBH6rYZX90jGRgC0V/S6Q7khDg3ExqnBxiqdr4S3QRkrP9re85FdDhfdsQC+oA0JShD5XPBCfHUthMSsfNCkR4OlCGsxG/brOnNAYTqj7YV02mzKKG7q6Zm2Qk0qGGkUFDan0SPaU4SF8CDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114045; c=relaxed/simple;
	bh=lg+my7ZC9b+gBetZjSZ3hEffJBVc6Y/9GydKkSj6hwA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hj/RMT0k/yiVI3qNoVJhO3u7hX6r5BNwria/iH6giNx4C4In0nyO2Qvl2lnALTlachC6H6MfJQJpH4voIVbc9IxyZUGW4N/B4eRqmPrE4sw5/PgYYG1SYSi8Y+dhSRX0ZX2eQtwdcoWDHLK1QrVFYnSFlLDmHJKwNxeU6z+GN0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=kYxhy6+9 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN7B008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:56 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=QBwrwrnsE1FoC507zgp90eTWpyZH/hajqME9o3OUmT4=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113817; v=1;
        b=kYxhy6+9dqTDk/uCvtp8qrxm6EFeDZp+tr0d4KtbPV3tOn6ezkr/WCTdJhOqhN2s
         /ldESHLVVgrZ2ZgMTakYedXLE2tsNxs5WMMy+mdKXWKGMFmlMa6TtKlnoW3G7nIp
         1u6KYk8jrVsmGSP8/jyzKMvei5raAklSfI0GjrFEoijcKg50cu9RiorVHt6dX3Vw
         4cwNeDvMERqWMj0aapNap1/TfbiUpn+LlKMULQl8NjcplNhEEhzm3VA9NyCidwbD
         V2vVeR4E992wgVQnFahlId4fRs6WJWJ3P5rUzkIKW8BN8OZ/h7561tDF4+Gf7bgm
         6oojDAoTjZJg92PfQyhC/w==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:43 +0900
Subject: [PATCH 31/35] system/physmem: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-31-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Steven Lee <steven_lee@aspeedtech.com>, Troy Lee <leetroy@gmail.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
        Helge Deller <deller@gmx.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?utf-8?q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <arikalo@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Ninad Palsule <ninad@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        =?utf-8?q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Aditya Gupta <adityag@linux.ibm.com>,
        Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bernhard Beschow <shentey@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        Bin Meng <bmeng.cn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-179e8

Make AddressSpaces QOM objects to ensure that they are destroyed when
their owners are finalized and also to get a unique path for debugging
output.

The name arguments were used to distinguish AddresSpaces in debugging
output, but they will represent property names after QOM-ification and
debugging output will show QOM paths. So change them to make them more
concise and also avoid conflicts with other properties.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 include/exec/cpu-common.h |  4 ++--
 system/physmem.c          | 17 ++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 9b658a3f48f7..420e7a71001a 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -105,7 +105,7 @@ size_t qemu_ram_pagesize_largest(void);
  * cpu_address_space_init:
  * @cpu: CPU to add this address space to
  * @asidx: integer index of this address space
- * @prefix: prefix to be used as name of address space
+ * @name: name of address space
  * @mr: the root memory region of address space
  *
  * Add the specified address space to the CPU's cpu_ases list.
@@ -121,7 +121,7 @@ size_t qemu_ram_pagesize_largest(void);
  * Note that with KVM only one address space is supported.
  */
 void cpu_address_space_init(CPUState *cpu, int asidx,
-                            const char *prefix, MemoryRegion *mr);
+                            const char *name, MemoryRegion *mr);
 /**
  * cpu_address_space_destroy:
  * @cpu: CPU for which address space needs to be destroyed
diff --git a/system/physmem.c b/system/physmem.c
index 6190eca7daed..7fa7b9ee6b76 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -774,16 +774,13 @@ hwaddr memory_region_section_get_iotlb(CPUState *cpu,
 #endif /* CONFIG_TCG */
 
 void cpu_address_space_init(CPUState *cpu, int asidx,
-                            const char *prefix, MemoryRegion *mr)
+                            const char *name, MemoryRegion *mr)
 {
     CPUAddressSpace *newas;
     AddressSpace *as = g_new0(AddressSpace, 1);
-    char *as_name;
 
     assert(mr);
-    as_name = g_strdup_printf("%s-%d", prefix, cpu->cpu_index);
-    address_space_init(as, NULL, mr, as_name);
-    g_free(as_name);
+    address_space_init(as, OBJECT(cpu), mr, name);
 
     /* Target code should have set num_ases before calling us */
     assert(asidx < cpu->num_ases);
@@ -831,7 +828,7 @@ void cpu_address_space_destroy(CPUState *cpu, int asidx)
         memory_listener_unregister(&cpuas->tcg_as_listener);
     }
 
-    address_space_destroy(cpuas->as);
+    object_unparent(OBJECT(cpuas->as));
     call_rcu1(&cpuas->as->rcu, address_space_free);
 
     if (asidx == 0) {
@@ -2814,15 +2811,17 @@ static void tcg_commit(MemoryListener *listener)
 
 static void memory_map_init(void)
 {
-    system_memory = g_malloc(sizeof(*system_memory));
+    Object *owner = machine_get_container("unattached");
 
+    system_memory = g_malloc(sizeof(*system_memory));
     memory_region_init(system_memory, NULL, "system", UINT64_MAX);
-    address_space_init(&address_space_memory, NULL, system_memory, "memory");
+    address_space_init(&address_space_memory, owner, system_memory,
+                       "system-as");
 
     system_io = g_malloc(sizeof(*system_io));
     memory_region_init_io(system_io, NULL, &unassigned_io_ops, NULL, "io",
                           65536);
-    address_space_init(&address_space_io, NULL, system_io, "I/O");
+    address_space_init(&address_space_io, owner, system_io, "io-as");
 }
 
 MemoryRegion *get_system_memory(void)

-- 
2.51.0


