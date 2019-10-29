Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F64E9137
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 22:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfJ2VGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 17:06:17 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:43087 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbfJ2VGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 17:06:16 -0400
Received: by mail-pg1-f202.google.com with SMTP id k7so8579398pgq.10
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2019 14:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s0LL3QMWsuiEqCtNWEPr0+snNyRy5wSt166tuiwJ1PM=;
        b=GDuEgQa5IzN1Fs+AjMXv74Y0vW8FkJDnokCMD6F3f8Mb8DoBDgfhNjG81LUUAT/Tka
         V7Kx4kWnD/EzCK6q3xJ53Ylv+494y5Q6C9u+w32d6jqwesx6+H98Kzk5CcGmrgOvDVuD
         kZGJdfrKe2xXCVQFrZiQlNQcvNtuuETinTkh4Z5/WaClVdWIxAH964RuvRWOmMQghl9P
         Ey4qATHzZxIYdoqCIjpW92hUIPJMppxLIN87D62fzsMH/b985eIiPkccfYMDdI/THyUL
         p5roOI0L7ipwo22QWUdXulyYkNku1IZfukknZIPkntBdW+1KMeb+PDdjiUZtkogyVY6U
         Xiiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s0LL3QMWsuiEqCtNWEPr0+snNyRy5wSt166tuiwJ1PM=;
        b=VbGHLUW7BqFAz/17m+MoBCEqWtGnmW3TepMWVNeeb5yVgepTna3WvAUKR1xVGOaSgT
         cKvBzqyd8dvyROiO2d4YixGdVRwmn9iqQHaMw/9L/Wt3eFin4AiRQ6ti4TdHug/DwbVd
         fhxiQWfvSmepLJslbHXzd3MEgiHm83VikVO6MdHV92jBGM/FuUSxVn6/CWVQ++X6AwNc
         Q1hDss+OnGPNZRdcGjn+yXz4+nFskGM01x1ssCcrrvRIeEY2oZ8A5cV7WYq8SJ9wZ6If
         6WjOMb1XazmcskMHlOJ8y7dLu6rN31dBEwbG4aZJqbKE4dulWzV1d6T+25hh7JUzHFR2
         AljA==
X-Gm-Message-State: APjAAAWMW/Cc1jfeGexxm/pxD3Q28LIE8JnnanhDISWHPBxy43Mzd1hA
        zfjog1woLzkNvc6QlaXJdIgrG3WdPRPCVP5oXlD+U9N3+r50lN398AJGteKc72COGMIVDQWvfy9
        fHBgs9qWT+Z39SukKiKHrJKVoQXiBVq7SC0agQ3D1cO5I1MHA5UGhZz2PmCzzxHeOdY+w
X-Google-Smtp-Source: APXvYqxo02XGwLjhsXtFXwWeHw2JstknZEPNsFIkO9Pq29AoeISRzLuLrLGI7985CNrp2QRnUkcY87qCczZFXJ1A
X-Received: by 2002:a63:d802:: with SMTP id b2mr29766690pgh.414.1572383174296;
 Tue, 29 Oct 2019 14:06:14 -0700 (PDT)
Date:   Tue, 29 Oct 2019 14:05:53 -0700
In-Reply-To: <20191029210555.138393-1-aaronlewis@google.com>
Message-Id: <20191029210555.138393-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191029210555.138393-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH 2/4] kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES.  This needs to be done
due to the addition of the MSR-autostore area that will be added later
in this series.  After that the name AUTOLOAD will no longer make sense.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: Iafe7c3bfb90842a93d7c453a1d8c84a48d5fe7b0
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 arch/x86/kvm/vmx/vmx.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7970a2e8eae..c0160ca9ddba 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -940,8 +940,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	if (!entry_only)
 		j = find_msr(&m->host, msr);
 
-	if ((i < 0 && m->guest.nr == NR_AUTOLOAD_MSRS) ||
-		(j < 0 &&  m->host.nr == NR_AUTOLOAD_MSRS)) {
+	if ((i < 0 && m->guest.nr == NR_MSR_ENTRIES) ||
+		(j < 0 &&  m->host.nr == NR_MSR_ENTRIES)) {
 		printk_once(KERN_WARNING "Not enough msr switch entries. "
 				"Can't add msr %x\n", msr);
 		return;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bee16687dc0b..0c6835bd6945 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -22,11 +22,11 @@ extern u32 get_umwait_control_msr(void);
 
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
-#define NR_AUTOLOAD_MSRS 8
+#define NR_MSR_ENTRIES 8
 
 struct vmx_msrs {
 	unsigned int		nr;
-	struct vmx_msr_entry	val[NR_AUTOLOAD_MSRS];
+	struct vmx_msr_entry	val[NR_MSR_ENTRIES];
 };
 
 struct shared_msr_entry {
-- 
2.24.0.rc0.303.g954a862665-goog

