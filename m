Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBED91050D6
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKUKps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:45:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39350 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUKps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 05:45:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so3104350wmi.4;
        Thu, 21 Nov 2019 02:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=cxS5SnfMHCr10pDxeGM/7sjAasmtfI9lheTpz/ICL50=;
        b=NMLOmZbG1QR7h4UQQ4HZf1hVPYrxEm1ZJNehrqPfkOdCdfWlHrkopiy3UcAmeWWXPu
         46EUdDIIlNcH92rVn/4LIabijIkjTfKTwTBuFQIsx0UZj2M/998qHZEhVFjyCV0grzQs
         V9KHSnlF3ookG3Vb7mK3stgJbIQgH9sUPko33b+e0raVFDd+rU9jlRePXW0qC7J8SGal
         u8BPmeIdrwAaeT9KW8IfMnz0nFh7C1N7MHKPQ+ykh3k0X5090qbFW865LYHXlHXSH+jy
         M48ZZR0NzvTjY4m4z8mg5o8iTic2mlCtNlWqH5xKttE01xzDgrZaYFJJ9qK/HfhfcGxl
         rbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=cxS5SnfMHCr10pDxeGM/7sjAasmtfI9lheTpz/ICL50=;
        b=NWAo5RDhqKJeMp/yPIM6YrWwGIZNh750NJw498Y0xXuX6R/68XSKI6c5iP8SYnaPrg
         lIKqW0Ou7qDhONEugk17Un3aXmWDr4L9dtnCIVgEgLy9ZNZgbd+gZJ04Altzi2o3OnC3
         +/U92zARydFNkVRML09/3eJhn63Va86pJzR2Td43k2W9TxSG8HZSG/nSXRiDGLOsFEo0
         JkPzIJcVpLxXun2oZUW/4s11Clob8nEtqUXXAuOU73tUiIHAWXtaPvOV+HH5LEGQBz9X
         XoG3zWTe/QlyJDsfP5NqAGNiE9s6AvmcXc7AejG0eCqjPaT5v7WIOwL3vB8MVU2Zsein
         PVHQ==
X-Gm-Message-State: APjAAAXLNb8GQYT9DPwkOct0bbdxUIVG+HuTlcQNWseazFR9n2vjyolL
        tjyET1H7DO/B6IA7MqpPmLTPsVje
X-Google-Smtp-Source: APXvYqxILiCiMhr9y5tsRaYve/TJEB3kVlTw+lE1x7awLVKtBnT5EdHOOOgqYiCiqzHchAY+PNQ0LA==
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr9552009wmi.124.1574333145541;
        Thu, 21 Nov 2019 02:45:45 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id k1sm2871745wrp.29.2019.11.21.02.45.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:45:45 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Feiner <pfeiner@google.com>
Subject: [PATCH] KVM: x86: create mmu/ subdirectory
Date:   Thu, 21 Nov 2019 11:45:43 +0100
Message-Id: <1574333143-27723-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Preparatory work for shattering mmu.c into multiple files.  Besides making it easier
to follow, this will also make it possible to write unit tests for various parts.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Makefile                | 4 ++--
 arch/x86/kvm/{ => mmu}/mmu.c         | 0
 arch/x86/kvm/{ => mmu}/page_track.c  | 0
 arch/x86/kvm/{ => mmu}/paging_tmpl.h | 0
 4 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/x86/kvm/{ => mmu}/mmu.c (100%)
 rename arch/x86/kvm/{ => mmu}/page_track.c (100%)
 rename arch/x86/kvm/{ => mmu}/paging_tmpl.h (100%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31ecf7a76d5a..b19ef421084d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -8,9 +8,9 @@ kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
-kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
+kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
-			   hyperv.o page_track.o debugfs.o
+			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
 kvm-amd-y		+= svm.o pmu_amd.o
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu/mmu.c
similarity index 100%
rename from arch/x86/kvm/mmu.c
rename to arch/x86/kvm/mmu/mmu.c
diff --git a/arch/x86/kvm/page_track.c b/arch/x86/kvm/mmu/page_track.c
similarity index 100%
rename from arch/x86/kvm/page_track.c
rename to arch/x86/kvm/mmu/page_track.c
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
similarity index 100%
rename from arch/x86/kvm/paging_tmpl.h
rename to arch/x86/kvm/mmu/paging_tmpl.h
-- 
1.8.3.1

