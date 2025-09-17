Return-Path: <kvm+bounces-57870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6A7B7F350
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AF212A16C3
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3425F332A43;
	Wed, 17 Sep 2025 13:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="DUSefoHX"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE7332A35
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114241; cv=none; b=R82OBzWX07M7ueCqpagP/TVzzvrWNnFhI11rQ2BAVxcbtekzc/IV1phuoIO+2gKEM4SyDkQtGaU59EyXAOT0Jl1Spkl0nM7K+n4Qelzye2a4//gvdZrPqOhSNA2VA3NHl9Cibs7syizm0xSkrbfjLd6FYwWZ4y5pjCtguc1aFec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114241; c=relaxed/simple;
	bh=jm1YsbFzxkREYxDGmYSKlngq5Gj/Gjcfwpv6Cw/Htkw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aRWwmy0lsOwinfxVuE/xzh4UZcNhQhRia4G4Ln8uX6686gZFKVt8ieu1wQw8w5fW7mwOxGmsfe/ld/Kc0iCxzLDeB1uzBpDNqFvMx9RCG8ZJtE8SNgb+Glm3PcI6yMhDPWV5fq3eiDpVBrVuM4AQbP2u85kZQTLmx6HtMa1+Wnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=DUSefoHX reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6j008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:35 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=SN54eqMpyxZn5t52ldVheDzKEoBDUBkvg/chu4l0yTs=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113796; v=1;
        b=DUSefoHX+5AQ41jKoyMQZ/520KnWRg3PTuzflX+/GPXZq3riyQSurxvuJq6Y+xeA
         sc0QE5yEaHKX31nXhL9x1HMWA8aCw1Kd//xPmJ1dS9TuYPRYEBUV3wIEZhunNBJy
         KSkDKTovU4HxAGab/4PCRKGMY+wWz4sLV/SxfhbPFp4A9F+HbrufBwEu6zktI+9n
         37l8Va3KoDIqMDlZsWOzKy4/48ABx7OARe8Nt0FjkxJ7uloAMGpNVwmyed0owEJw
         5AyPLLiP+X0+9IMBiwGrNzhPbldNRxURcOfovreIznCLAPrtI/DRx+W457D9g07k
         PFKYTh6R/xZXDBSuQAmfDQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:17 +0900
Subject: [PATCH 05/35] hw/arm: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-5-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
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
 hw/arm/armv7m.c         | 2 +-
 hw/arm/aspeed_ast27x0.c | 2 +-
 hw/arm/smmu-common.c    | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
index 7fa854bc14df..54d0d9f78207 100644
--- a/hw/arm/armv7m.c
+++ b/hw/arm/armv7m.c
@@ -117,7 +117,7 @@ static void bitband_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->source_as, NULL, s->source_memory, "bitband-source");
+    address_space_init(&s->source_as, OBJECT(s), s->source_memory, "as");
 }
 
 /* Board init.  */
diff --git a/hw/arm/aspeed_ast27x0.c b/hw/arm/aspeed_ast27x0.c
index f8c0ac5f87df..7fe097ad3f11 100644
--- a/hw/arm/aspeed_ast27x0.c
+++ b/hw/arm/aspeed_ast27x0.c
@@ -387,7 +387,7 @@ static bool aspeed_soc_ast2700_dram_init(DeviceState *dev, Error **errp)
     memory_region_init(&s->dram_container, OBJECT(s), "ram-container",
                        ram_size);
     memory_region_add_subregion(&s->dram_container, 0, s->dram_mr);
-    address_space_init(&s->dram_as, NULL, s->dram_mr, "dram");
+    address_space_init(&s->dram_as, OBJECT(s), s->dram_mr, "dram-as");
 
     /*
      * Add a memory region beyond the RAM region to emulate
diff --git a/hw/arm/smmu-common.c b/hw/arm/smmu-common.c
index 081c50750947..7c1648165b9f 100644
--- a/hw/arm/smmu-common.c
+++ b/hw/arm/smmu-common.c
@@ -863,6 +863,7 @@ static AddressSpace *smmu_find_add_as(PCIBus *bus, void *opaque, int devfn)
     sdev = sbus->pbdev[devfn];
     if (!sdev) {
         char *name = g_strdup_printf("%s-%d-%d", s->mrtypename, devfn, index++);
+        g_autofree char *as_name = g_strconcat(name, "-as", NULL);
 
         sdev = sbus->pbdev[devfn] = g_new0(SMMUDevice, 1);
 
@@ -873,8 +874,8 @@ static AddressSpace *smmu_find_add_as(PCIBus *bus, void *opaque, int devfn)
         memory_region_init_iommu(&sdev->iommu, sizeof(sdev->iommu),
                                  s->mrtypename,
                                  OBJECT(s), name, UINT64_MAX);
-        address_space_init(&sdev->as, NULL,
-                           MEMORY_REGION(&sdev->iommu), name);
+        address_space_init(&sdev->as, OBJECT(s),
+                           MEMORY_REGION(&sdev->iommu), as_name);
         trace_smmu_add_mr(name);
         g_free(name);
     }

-- 
2.51.0


