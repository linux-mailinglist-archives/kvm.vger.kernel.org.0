Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F306145D2C3
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352759AbhKYCDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352965AbhKYCBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:11 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF271C0619E2
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:44 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id bl6-20020a05620a1a8600b0046803c08cccso4374492qkb.15
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WuRnaFSHqSjJ7borPLEG9bJcvlsOL2cdT1Ww4orxAOI=;
        b=T22yF94hL+DDd2r1JYiqm2P6miPPFxDWmoypeDWoo4YVf8galmUyYu29OE4itIjG7y
         jokigBRr8E0ERJKf4pr59SCtY5rcJoovaCWPneK/1ImmVjbQEUPp46NQdnQaO3WkkWoX
         9MBOCvWXNvwqEGJSX3HQ8mn2XHfb9X9RBbfT1UxVf1Mu0cs289wx4feh/VwwcR3Jknkk
         ZiOq9QErWOeiQleQsjTCxJYdgXy1itJMoWA7tmpgAOrYkQNlaXD4kB3YbUFvkgRTXvt9
         sAOLzG/m2IvjJ3qALuTmzRXHDgUJYFoERgSrsUF+D6gjx3k2NMwx/G3ljkShibyvywxR
         xDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WuRnaFSHqSjJ7borPLEG9bJcvlsOL2cdT1Ww4orxAOI=;
        b=6+dl6L6+QKbyz/IFhTF/OQ4eSW8TMbJM33mN/IH3+uV08KRnJQH7B50y1D0PQ7vbm9
         n351tpJM7T9/0WZRXOfzur+am7EHsYqnc7xU6fCLtt/CAgR6Nrb+4PEk8t28dmj6C1rx
         Ykl7xJWbBFnuZhaYuIKjURgfDrL3o3cAUHd+So/jfRlupPpZ64qpHajmpa99JnZF+a+X
         jy/80vxsFC2+L50/ap8NFoO5cSyFp2XhZc4S/33jWH7KcCfRDPMiLA3JbnSw6oTilKXV
         DKj/FDF+KbUEoK3mFYe5TD/IfdyXsSHNno4MnBzThu62xbSJAj82ELR7V2NlCjPMRdyW
         XICw==
X-Gm-Message-State: AOAM531EtJTGvET2/9ie61XK1ve2j7GfMPRx0OX9RIslDFeepDNRl8q5
        VzExcwQUv7T4OV9GZCkUU0w+VZ2PLvs=
X-Google-Smtp-Source: ABdhPJwZwWYRbmVCp3TQ33h+msbNbJsgoLFo29qdlfdLlprwyeN5nBhqQxEmm3bXmsiMPn23uoXiTfGV/mY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:2342:: with SMTP id j63mr2070523ybj.22.1637803783873;
 Wed, 24 Nov 2021 17:29:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:45 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-28-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 27/39] nVMX: Drop unused and useless
 vpid_sync() helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop vpid_sync(), it's unused for good reason.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 18 ------------------
 x86/vmx.h |  1 -
 2 files changed, 19 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index eb5417b..e499704 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1164,24 +1164,6 @@ void set_ept_pte(unsigned long *pml4, unsigned long guest_addr,
 	pt[offset] = pte_val;
 }
 
-void vpid_sync(int type, u16 vpid)
-{
-	switch(type) {
-	case INVVPID_CONTEXT_GLOBAL:
-		if (ept_vpid.val & VPID_CAP_INVVPID_CXTGLB) {
-			invvpid(INVVPID_CONTEXT_GLOBAL, vpid, 0);
-			break;
-		}
-	case INVVPID_ALL:
-		if (ept_vpid.val & VPID_CAP_INVVPID_ALL) {
-			invvpid(INVVPID_ALL, vpid, 0);
-			break;
-		}
-	default:
-		printf("WARNING: invvpid is not supported\n");
-	}
-}
-
 static void init_vmcs_ctrl(void)
 {
 	/* 26.2 CHECKS ON VMX CONTROLS AND HOST-STATE AREA */
diff --git a/x86/vmx.h b/x86/vmx.h
index 0b7fb20..4936120 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -983,7 +983,6 @@ int init_vmcs(struct vmcs **vmcs);
 const char *exit_reason_description(u64 reason);
 void print_vmexit_info(union exit_reason exit_reason);
 void print_vmentry_failure_info(struct vmentry_result *result);
-void vpid_sync(int type, u16 vpid);
 void install_ept_entry(unsigned long *pml4, int pte_level,
 		unsigned long guest_addr, unsigned long pte,
 		unsigned long *pt_page);
-- 
2.34.0.rc2.393.gf8c9666880-goog

