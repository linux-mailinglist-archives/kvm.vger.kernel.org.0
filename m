Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB42F91A14
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 00:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfHRWzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Aug 2019 18:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbfHRWzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Aug 2019 18:55:15 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 522D13082D9E;
        Sun, 18 Aug 2019 22:55:15 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-33.brq.redhat.com [10.40.204.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C226D1C1;
        Sun, 18 Aug 2019 22:55:10 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 06/15] hw/i386/pc: Pass the apic_id_limit value by argument
Date:   Mon, 19 Aug 2019 00:54:05 +0200
Message-Id: <20190818225414.22590-7-philmd@redhat.com>
In-Reply-To: <20190818225414.22590-1-philmd@redhat.com>
References: <20190818225414.22590-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sun, 18 Aug 2019 22:55:15 +0000 (UTC)
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
index 4963551ee8..b97d1991cf 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -934,7 +934,8 @@ static void pc_build_smbios(PCMachineState *pcms)
 }
 
 static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms,
-                                      uint16_t boot_cpus)
+                                      uint16_t boot_cpus,
+                                      uint16_t apic_id_limit)
 {
     FWCfgState *fw_cfg;
     uint64_t *numa_fw_cfg;
@@ -1855,7 +1856,7 @@ void pc_memory_init(PCMachineState *pcms,
                                         option_rom_mr,
                                         1);
 
-    fw_cfg = fw_cfg_arch_create(pcms, pcms->boot_cpus);
+    fw_cfg = fw_cfg_arch_create(pcms, pcms->boot_cpus, pcms->apic_id_limit);
 
     rom_set_fw(fw_cfg);
 
-- 
2.20.1

