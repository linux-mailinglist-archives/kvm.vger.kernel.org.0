Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0878391B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfHFS5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:40914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfHFS5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:57:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715123"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 06 Aug 2019 11:57:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 20/20] i440fx: Add support for SGX EPC
Date:   Tue,  6 Aug 2019 11:56:49 -0700
Message-Id: <20190806185649.2476-21-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806185649.2476-1-sean.j.christopherson@intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGX EPC virtualization is currently only support by KVM.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 hw/i386/pc_piix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index c2280c72ef..3e70c6e311 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -151,6 +151,9 @@ static void pc_init1(MachineState *machine,
             pcms->above_4g_mem_size = 0;
             pcms->below_4g_mem_size = machine->ram_size;
         }
+        if (pcmc->pci_enabled) {
+            pc_machine_init_sgx_epc(pcms);
+        }
     }
 
     pc_cpus_init(pcms);
-- 
2.22.0

