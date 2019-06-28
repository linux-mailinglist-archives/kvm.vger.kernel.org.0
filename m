Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188BB5A8CF
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 05:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfF2DxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 23:53:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37942 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfF2DxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 23:53:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id 9so3534609ple.5
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 20:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kg9cnhfWN92/dS8254v6me5wI97CqKprJYMTUglwb9U=;
        b=MGP5B2704yGyNXdggsl8qxtBCfU+GUokWXioeIOLudoFxBYsSQPOsXG2AaJ28cYCEc
         FRgt3d5/50IAiH1teixRxEH6ZsTNJQws51ejZBCA1sXV4ksQk/wppB2I4mUgks+Lk8iM
         w/WksduNTI4fcUhCfXZYkgf4HjniJy5RW+4GBfp+puJJCb4p9P8saHWg02mObpdfimPb
         +1NSUyhic0e7e+btphdsj0joGMcuYEMDYTY1HD1T4/ZVdTxItI4FYA0xWB/tzWLwiisA
         6jvHnqQnJOQiB3CGu+ksSBT0pwYGnW+J8YUOzK5xVL6/cBuv1hDGq6htRMXKhcN2Wo4z
         nRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kg9cnhfWN92/dS8254v6me5wI97CqKprJYMTUglwb9U=;
        b=T9uxv1YVEBMzo4oqCwWtsh5lwiIHvmW7GrXa+rrwZZmwmiXlLULMWGNeDtUtYf+jpG
         rSG9WtqIVEutntcgHEOS43x+OOP0yAKmonrE70Lth/ER38C89deUwcY+TidzIv2BtXro
         Yu+PoIz5boVDNYoJ9YQxVbUpz3NRnqdS7R+9aTode8Uk3lD4295QMyVshfUUQjXfmnE3
         QtXm7kvrEHg7bdlIIZJpfkinVN/AkMhvZHaNjx5tzv6l3JRZXs/57MCdgaOc3pYxFWwu
         iVmXPpo1UfWc3UX6eEj3nsFVkmFkRPx1mTbITcE36L/YQqocIDFzAsSlOeR30loQdY/x
         KH7Q==
X-Gm-Message-State: APjAAAVlxXgtIphj1LOQgaLojv8pO9F76polqGLsL1hTybjMmEh0XEmY
        kV3mMve7oVXkECO98DYqtMc=
X-Google-Smtp-Source: APXvYqxXnEIEy73Hu/wps0mZPeVGh0ERbrnCDlsFuZbsCHjP6WGG9kovK/qdqSC28dlPTNNYVQxD2A==
X-Received: by 2002:a17:902:7295:: with SMTP id d21mr14474835pll.299.1561780393221;
        Fri, 28 Jun 2019 20:53:13 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p27sm5597052pfq.136.2019.06.28.20.53.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 20:53:12 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 2/3] x86/vmx: Use plus for positive filters
Date:   Fri, 28 Jun 2019 13:30:18 -0700
Message-Id: <20190628203019.3220-3-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628203019.3220-1-nadav.amit@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To introduce general boot parameters, avoid vmx boot parameters from
colliding with the general ones. Precede the vmx test names with a plus
sign ('+') to indicate a test should be executed in vmx, and ignore
those that are not preceded with '-' or '+'.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/unittests.cfg | 32 ++++++++++++++++----------------
 x86/vmx.c         |  4 ++--
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 694ee3d..dc7a85d 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -58,55 +58,55 @@ smp = 3
 
 [vmexit_cpuid]
 file = vmexit.flat
-extra_params = -append 'cpuid'
+extra_params = -append '+cpuid'
 groups = vmexit
 
 [vmexit_vmcall]
 file = vmexit.flat
-extra_params = -append 'vmcall'
+extra_params = -append '+vmcall'
 groups = vmexit
 
 [vmexit_mov_from_cr8]
 file = vmexit.flat
-extra_params = -append 'mov_from_cr8'
+extra_params = -append '+mov_from_cr8'
 groups = vmexit
 
 [vmexit_mov_to_cr8]
 file = vmexit.flat
-extra_params = -append 'mov_to_cr8'
+extra_params = -append '+mov_to_cr8'
 groups = vmexit
 
 [vmexit_inl_pmtimer]
 file = vmexit.flat
-extra_params = -append 'inl_from_pmtimer'
+extra_params = -append '+inl_from_pmtimer'
 groups = vmexit
 
 [vmexit_ipi]
 file = vmexit.flat
 smp = 2
-extra_params = -append 'ipi'
+extra_params = -append '+ipi'
 groups = vmexit
 
 [vmexit_ipi_halt]
 file = vmexit.flat
 smp = 2
-extra_params = -append 'ipi_halt'
+extra_params = -append '+ipi_halt'
 groups = vmexit
 
 [vmexit_ple_round_robin]
 file = vmexit.flat
-extra_params = -append 'ple_round_robin'
+extra_params = -append '+ple_round_robin'
 groups = vmexit
 
 [vmexit_tscdeadline]
 file = vmexit.flat
 groups = vmexit
-extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline
+extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append '+tscdeadline'
 
 [vmexit_tscdeadline_immed]
 file = vmexit.flat
 groups = vmexit
-extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
+extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append '+tscdeadline_immed'
 
 [access]
 file = access.flat
@@ -233,27 +233,27 @@ groups = vmx
 
 [ept]
 file = vmx.flat
-extra_params = -cpu host,host-phys-bits,+vmx -m 2560 -append "ept_access*"
+extra_params = -cpu host,host-phys-bits,+vmx -m 2560 -append "+ept_access*"
 arch = x86_64
 groups = vmx
 
 [vmx_eoi_bitmap_ioapic_scan]
 file = vmx.flat
 smp = 2
-extra_params = -cpu host,+vmx -m 2048 -append vmx_eoi_bitmap_ioapic_scan_test
+extra_params = -cpu host,+vmx -m 2048 -append '+vmx_eoi_bitmap_ioapic_scan_test'
 arch = x86_64
 groups = vmx
 
 [vmx_hlt_with_rvi_test]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append vmx_hlt_with_rvi_test
+extra_params = -cpu host,+vmx -append '+vmx_hlt_with_rvi_test'
 arch = x86_64
 groups = vmx
 timeout = 10
 
 [vmx_apicv_test]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test"
+extra_params = -cpu host,+vmx -append "+apic_reg_virt_test +virt_x2apic_mode_test"
 arch = x86_64
 groups = vmx
 timeout = 10
@@ -261,13 +261,13 @@ timeout = 10
 [vmx_apic_passthrough_thread]
 file = vmx.flat
 smp = 2
-extra_params = -cpu host,+vmx -m 2048 -append vmx_apic_passthrough_thread_test
+extra_params = -cpu host,+vmx -m 2048 -append '+vmx_apic_passthrough_thread_test'
 arch = x86_64
 groups = vmx
 
 [vmx_vmcs_shadow_test]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append vmx_vmcs_shadow_test
+extra_params = -cpu host,+vmx -append '+vmx_vmcs_shadow_test'
 arch = x86_64
 groups = vmx
 
diff --git a/x86/vmx.c b/x86/vmx.c
index 872ba11..1aa1ade 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1894,9 +1894,9 @@ test_wanted(const char *name, const char *filters[], int filter_count)
 		if (filter[0] == '-') {
 			if (simple_glob(clean_name, filter + 1))
 				return false;
-		} else {
+		} else if (filter[0] == '+') {
 			positive = true;
-			match |= simple_glob(clean_name, filter);
+			match |= simple_glob(clean_name, filter + 1);
 		}
 	}
 
-- 
2.17.1

