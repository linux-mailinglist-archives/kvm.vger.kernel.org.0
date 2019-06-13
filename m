Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A6A437D3
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733033AbfFMPB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732551AbfFMOg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:36:26 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD9307E459;
        Thu, 13 Jun 2019 14:36:25 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A953F1001B2A;
        Thu, 13 Jun 2019 14:36:13 +0000 (UTC)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 11/20] hw/i386/pc: Pass the apic_id_limit value by argument
Date:   Thu, 13 Jun 2019 16:34:37 +0200
Message-Id: <20190613143446.23937-12-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 13 Jun 2019 14:36:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the apic_id_limit value by argument, this will
allow us to remove the PCMachineState argument later.

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 4c5a968143..7f5215965e 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -933,7 +933,8 @@ static void pc_build_smbios(PCMachineState *pcms)
 }
 
 static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms,
-                                      uint16_t boot_cpus)
+                                      uint16_t boot_cpus,
+                                      uint16_t apic_id_limit)
 {
     FWCfgState *fw_cfg;
     uint64_t *numa_fw_cfg;
@@ -1767,7 +1768,7 @@ void pc_memory_init(PCMachineState *pcms,
                                         option_rom_mr,
                                         1);
 
-    fw_cfg = fw_cfg_arch_create(pcms, pcms->boot_cpus);
+    fw_cfg = fw_cfg_arch_create(pcms, pcms->boot_cpus, pcms->apic_id_limit);
 
     rom_set_fw(fw_cfg);
 
-- 
2.20.1

