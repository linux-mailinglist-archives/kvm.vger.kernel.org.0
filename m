Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3299C5BD05
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 15:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfGANfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 09:35:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbfGANfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 09:35:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 856883086268;
        Mon,  1 Jul 2019 13:35:50 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28512608BA;
        Mon,  1 Jul 2019 13:35:46 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: [PATCH v3 01/15] hw/i386/pc: Use e820_get_num_entries() to access e820_entries
Date:   Mon,  1 Jul 2019 15:35:22 +0200
Message-Id: <20190701133536.28946-2-philmd@redhat.com>
In-Reply-To: <20190701133536.28946-1-philmd@redhat.com>
References: <20190701133536.28946-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 01 Jul 2019 13:35:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To be able to extract the e820* code out of this file (in the next
patch), access e820_entries with its correct helper.

Reviewed-by: Li Qiang <liq3ea@gmail.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index e96360b47a..691726b85b 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1020,7 +1020,7 @@ static FWCfgState *bochs_bios_init(AddressSpace *as, PCMachineState *pcms)
     fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
                      &e820_reserve, sizeof(e820_reserve));
     fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
-                    sizeof(struct e820_entry) * e820_entries);
+                    sizeof(struct e820_entry) * e820_get_num_entries());
 
     fw_cfg_add_bytes(fw_cfg, FW_CFG_HPET, &hpet_cfg, sizeof(hpet_cfg));
     /* allocate memory for the NUMA channel: one (64bit) word for the number
-- 
2.20.1

