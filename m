Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D58A437DF
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733080AbfFMPBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732538AbfFMOfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:35:31 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E678C30C31AA;
        Thu, 13 Jun 2019 14:35:24 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A8DD1001DC0;
        Thu, 13 Jun 2019 14:35:07 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: [PATCH v2 02/20] hw/i386/pc: Use size_t type to hold/return a size of array
Date:   Thu, 13 Jun 2019 16:34:28 +0200
Message-Id: <20190613143446.23937-3-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 13 Jun 2019 14:35:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Li Qiang <liq3ea@gmail.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c         | 4 ++--
 include/hw/i386/pc.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index bb3c74f4ca..ff0f6bbbb3 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -105,7 +105,7 @@ struct e820_table {
 
 static struct e820_table e820_reserve;
 static struct e820_entry *e820_table;
-static unsigned e820_entries;
+static size_t e820_entries;
 struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
 
 /* Physical Address of PVH entry point read from kernel ELF NOTE */
@@ -901,7 +901,7 @@ int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
     return e820_entries;
 }
 
-int e820_get_num_entries(void)
+size_t e820_get_num_entries(void)
 {
     return e820_entries;
 }
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 3b3a0d6e59..fc29893624 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -290,7 +290,7 @@ void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
 #define E820_UNUSABLE   5
 
 int e820_add_entry(uint64_t, uint64_t, uint32_t);
-int e820_get_num_entries(void);
+size_t e820_get_num_entries(void);
 bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
 
 extern GlobalProperty pc_compat_4_0_1[];
-- 
2.20.1

