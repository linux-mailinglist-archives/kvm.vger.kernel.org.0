Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40EB496829
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbiAUXTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiAUXTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:19:01 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6119C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:01 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id z20-20020a63d014000000b0034270332922so6377774pgf.1
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yksNPuWZyRhT13UzbVIIBoQZLyQViEwETeRZvr7mhpc=;
        b=fpAT37swEd1+omeDehJGa5RXdjQmX+AN1nr6+iYu4otYXj8RaZIInTl6kWf8jYHYli
         EqNHk3xlwjBWIiTxeuzkhaxgtSI6biS4W7bigs12zReZbjuBbr8rMZO4472xh+4jDp3P
         SzlLvT/vv/0JgTRIhrsbwVdtL8X6+pp2wVahm6mQIOjFGBcPJPeNq7aPDJFvLFAoGW19
         pGIIBsbya2Par2sjH0XvABqdz5t7ErsSAG5aWkZoP4HFrjgnGlbXfH5MygDsOqpI5upM
         OXbKV6hWBxs0hHxicAOKBj7dUwxftOst6rOFH54Qjj0JMWZQuQa0ErNV9EPRiM2SSNVX
         lYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yksNPuWZyRhT13UzbVIIBoQZLyQViEwETeRZvr7mhpc=;
        b=L3kLwbBHx2ZNUNAktgSESKngH/E/ADsHEQSxJx4T7NEki0Zf/Cr4zb3OjdmxGOOhHg
         xcBzH/9LarJUcT05XAXDLGVpo42ftxsQm8+fwaSWoxYFPHofIXW1Xwq8YoDwD2KOEDLG
         OITTlqECAkPKB/DNu3Cccnv4TO9yxaGOKlwV6FOxHcY3IZ5VFZTyAzy5ridaXPUafCV9
         L5A9WY5BSNkIPVZWtHeH4LW13lKqu5kFthm2/tR9C/llfu81JNSGue/ypFMEjk3Rb5XQ
         5NlPllLjePYq7ehoSry33lkh/MY9jOojw8YJ6qqJ6U1m4aynDPLE/gNK6nmwZqt/Tfl9
         2z9w==
X-Gm-Message-State: AOAM532gc/1qMSSHpY96f0oTusg7OLtUTb1vXltTFeH/mfXDJT56PEM3
        YRJ/E04BsHNmvxWObnhD3N0yAuFalnI=
X-Google-Smtp-Source: ABdhPJzcUdhxVZFKgm+Uhcbx6/C5bvruxo/XQ3/FuEQRT1vjpjyHQnHYz5bFSeFirkkJVbVGKV1eVGTeru8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1308:b0:4c5:e231:afd4 with SMTP id
 j8-20020a056a00130800b004c5e231afd4mr5762840pfu.34.1642807141259; Fri, 21 Jan
 2022 15:19:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:47 +0000
In-Reply-To: <20220121231852.1439917-1-seanjc@google.com>
Message-Id: <20220121231852.1439917-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 3/8] x86: smp: Replace spaces with tabs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace spaces with tabs in smp.c, and opportunistically clean up a
handful of minor coding style violations.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/smp.c | 129 +++++++++++++++++++++++++-------------------------
 1 file changed, 64 insertions(+), 65 deletions(-)

diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 2ac0ef74..b24675fd 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -21,128 +21,127 @@ static atomic_t active_cpus;
 
 static __attribute__((used)) void ipi(void)
 {
-    void (*function)(void *data) = ipi_function;
-    void *data = ipi_data;
-    bool wait = ipi_wait;
+	void (*function)(void *data) = ipi_function;
+	void *data = ipi_data;
+	bool wait = ipi_wait;
 
-    if (!wait) {
-	ipi_done = 1;
-	apic_write(APIC_EOI, 0);
-    }
-    function(data);
-    atomic_dec(&active_cpus);
-    if (wait) {
-	ipi_done = 1;
-	apic_write(APIC_EOI, 0);
-    }
+	if (!wait) {
+		ipi_done = 1;
+		apic_write(APIC_EOI, 0);
+	}
+	function(data);
+	atomic_dec(&active_cpus);
+	if (wait) {
+		ipi_done = 1;
+		apic_write(APIC_EOI, 0);
+	}
 }
 
 asm (
-     "ipi_entry: \n"
-     "   call ipi \n"
+	 "ipi_entry: \n"
+	 "   call ipi \n"
 #ifndef __x86_64__
-     "   iret"
+	 "   iret"
 #else
-     "   iretq"
+	 "   iretq"
 #endif
-     );
+	 );
 
 int cpu_count(void)
 {
-    return _cpu_count;
+	return _cpu_count;
 }
 
 int smp_id(void)
 {
-    unsigned id;
+	unsigned id;
 
-    asm ("mov %%gs:0, %0" : "=r"(id));
-    return id;
+	asm ("mov %%gs:0, %0" : "=r"(id));
+	return id;
 }
 
 static void setup_smp_id(void *data)
 {
-    asm ("mov %0, %%gs:0" : : "r"(apic_id()) : "memory");
+	asm ("mov %0, %%gs:0" : : "r"(apic_id()) : "memory");
 }
 
-static void __on_cpu(int cpu, void (*function)(void *data), void *data,
-                     int wait)
+static void __on_cpu(int cpu, void (*function)(void *data), void *data, int wait)
 {
-    unsigned int target = id_map[cpu];
+	const u32 ipi_icr = APIC_INT_ASSERT | APIC_DEST_PHYSICAL | APIC_DM_FIXED | IPI_VECTOR;
+	unsigned int target = id_map[cpu];
 
-    spin_lock(&ipi_lock);
-    if (target == smp_id())
-	function(data);
-    else {
-	atomic_inc(&active_cpus);
-	ipi_done = 0;
-	ipi_function = function;
-	ipi_data = data;
-	ipi_wait = wait;
-	apic_icr_write(APIC_INT_ASSERT | APIC_DEST_PHYSICAL | APIC_DM_FIXED
-                       | IPI_VECTOR, target);
-	while (!ipi_done)
-	    ;
-    }
-    spin_unlock(&ipi_lock);
+	spin_lock(&ipi_lock);
+	if (target == smp_id()) {
+		function(data);
+	} else {
+		atomic_inc(&active_cpus);
+		ipi_done = 0;
+		ipi_function = function;
+		ipi_data = data;
+		ipi_wait = wait;
+		apic_icr_write(ipi_icr, target);
+		while (!ipi_done)
+			;
+	}
+	spin_unlock(&ipi_lock);
 }
 
 void on_cpu(int cpu, void (*function)(void *data), void *data)
 {
-    __on_cpu(cpu, function, data, 1);
+	__on_cpu(cpu, function, data, 1);
 }
 
 void on_cpu_async(int cpu, void (*function)(void *data), void *data)
 {
-    __on_cpu(cpu, function, data, 0);
+	__on_cpu(cpu, function, data, 0);
 }
 
 void on_cpus(void (*function)(void *data), void *data)
 {
-    int cpu;
+	int cpu;
 
-    for (cpu = cpu_count() - 1; cpu >= 0; --cpu)
-        on_cpu_async(cpu, function, data);
+	for (cpu = cpu_count() - 1; cpu >= 0; --cpu)
+		on_cpu_async(cpu, function, data);
 
-    while (cpus_active() > 1)
-        pause();
+	while (cpus_active() > 1)
+		pause();
 }
 
 int cpus_active(void)
 {
-    return atomic_read(&active_cpus);
+	return atomic_read(&active_cpus);
 }
 
 void smp_init(void)
 {
-    int i;
-    void ipi_entry(void);
+	int i;
+	void ipi_entry(void);
 
-    _cpu_count = fwcfg_get_nb_cpus();
+	_cpu_count = fwcfg_get_nb_cpus();
 
-    setup_idt();
-    init_apic_map();
-    set_idt_entry(IPI_VECTOR, ipi_entry, 0);
+	setup_idt();
+	init_apic_map();
+	set_idt_entry(IPI_VECTOR, ipi_entry, 0);
 
-    setup_smp_id(0);
-    for (i = 1; i < cpu_count(); ++i)
-        on_cpu(i, setup_smp_id, 0);
+	setup_smp_id(0);
+	for (i = 1; i < cpu_count(); ++i)
+		on_cpu(i, setup_smp_id, 0);
 
-    atomic_inc(&active_cpus);
+	atomic_inc(&active_cpus);
 }
 
 static void do_reset_apic(void *data)
 {
-    reset_apic();
+	reset_apic();
 }
 
 void smp_reset_apic(void)
 {
-    int i;
+	int i;
 
-    reset_apic();
-    for (i = 1; i < cpu_count(); ++i)
-        on_cpu(i, do_reset_apic, 0);
+	reset_apic();
+	for (i = 1; i < cpu_count(); ++i)
+		on_cpu(i, do_reset_apic, 0);
 
-    atomic_inc(&active_cpus);
+	atomic_inc(&active_cpus);
 }
-- 
2.35.0.rc0.227.g00780c9af4-goog

