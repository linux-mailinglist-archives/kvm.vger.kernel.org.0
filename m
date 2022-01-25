Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB8E49BD2F
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 21:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiAYUbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 15:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiAYUbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 15:31:44 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BC0C06173B
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:31:44 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k13-20020a65434d000000b00342d8eb46b4so12331745pgq.23
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wkxsBL5x1pNRUbZ9MZHRKA3ddUsleEy1gx0hvtCSCA8=;
        b=Yeg9Xl5M94Mus86eYJ0AhQLtm+oQv4DurYsM+hLqOCI+rIJwbIlssxIs6k3nFG/gWC
         dnveMeuv9DSts6YAzamvqsetjWFO1E+Om1vKIJV3Cx9dEZvAO2guO2CCP+6tydG21xwa
         7WsFpD2iPCzKVMsO1dJt8ZkadzcfofDN4w8SOro+NJViYTMziGCSRvcRCxZUwhu5BPv/
         0dhjcDXrpzZyiFuKzRqLh2jgq7tz9EGd2HHLjPxpoXvDcX18lwwzh/sYZ5LG8uYVEEeJ
         XoGWTz9kWnDk50ZLC371uW0Hw8+c3c9P2TgP3LP97YzZgQemXq5cxbYXMSc7AGLDn3aw
         L1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wkxsBL5x1pNRUbZ9MZHRKA3ddUsleEy1gx0hvtCSCA8=;
        b=L753iRXGAurzFJC1Dk3rXVmbcnhQCm1umGe7BSSa6bziqspCqP8G8dT5W/WQJOHgfh
         IBK45TRu+VHHTZyWkkOzHBew7zUEN66dc9uSb6bHXVqd62HXO+SvrjBZDDWBSGE4I5ax
         3U+pNoMvZEB1ZNuxI9nPiMHx1fMjb/R4KxnDHoRNEWQiEHq+enCApMhh6i3rzDucufem
         JeK+7icDBbXgHcP0hCp1Hgiv+enPsK7hVnv7MqHUalrK/Zt47nLMNB/3gMIOMOUswsao
         X6Tjhe6PkWS8gTYdcSgXN2qC2Mu31MmA0cub+q/+EECqWrecFimURgLufN4szTnmk7Ms
         RIpQ==
X-Gm-Message-State: AOAM533oZ5L4eRvJw3fdaVvzLGYoaH91eyEiQ2+tIKj8l8wGFC5EVQb8
        lOYExOL8Aah8ev1y8A1z5CsH4abKpSEQ/J2i/5KqpGa1T94A88H64w66veglLolZ8a/JC2Zv+ku
        WATV+yk/dFRgjqKBP/pBMBcE0WNihGDu/OYbajkMY+jWGa04E7djSi/NzZUaXDQs5121a
X-Google-Smtp-Source: ABdhPJz8dhJbzY8Ovi1pKs+jwWRMC+cKcRppcvd+ziBjZisYVmAghFFzEWqrwCyrPnLsSZJ7gCybfo8iRUJiNZrw
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1486:b0:4c8:ad4f:6b24 with
 SMTP id v6-20020a056a00148600b004c8ad4f6b24mr12619788pfu.16.1643142703856;
 Tue, 25 Jan 2022 12:31:43 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:31:24 +0000
In-Reply-To: <20220125203127.1161838-1-aaronlewis@google.com>
Message-Id: <20220125203127.1161838-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220125203127.1161838-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v5 1/4] x86: Make exception_mnemonic() visible
 to the tests
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

exception_mnemonic() is a useful function for more than just desc.c.
Make it global, so it can be used in other KUT tests.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c | 2 +-
 lib/x86/desc.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 16b7256..c2eb16e 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -91,7 +91,7 @@ struct ex_record {
 
 extern struct ex_record exception_table_start, exception_table_end;
 
-static const char* exception_mnemonic(int vector)
+const char* exception_mnemonic(int vector)
 {
 	switch(vector) {
 	case 0: return "#DE";
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 9b81da0..ad6277b 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -224,6 +224,7 @@ void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
 void unhandled_exception(struct ex_regs *regs, bool cpu);
+const char* exception_mnemonic(int vector);
 
 bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
 			void *data);
-- 
2.35.0.rc0.227.g00780c9af4-goog

