Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D9370C314
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 18:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjEVQNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 12:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbjEVQN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 12:13:27 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45EBB6
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:13:26 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 370723F526
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684772002;
        bh=yEoXhOv9392G4YyVtPika8TuddyFutw1yuUvDKTMDXc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=WZAkvBik5wa79VE7Idp3tQYhg14zHkrgDhu8rA7vqtlzOqq7BafNhexk8b7htU0y0
         UGa33jGd71X8MU9gMPxeLZHFMvW+zmuD6dIywbRVLy8fDGbDPXaN9aFN068NvxwbL0
         1KYLEmd/XLkVZ0PSvo2ujaH6KUjiE1TpH+WMZ+Bwscx6D6QMWYM3KtOE+Z8/29yoId
         iqWu0Tg5ZVf7pXdE3uffJSUZDwK2/UqXR/ksDyELn6XwIvB7YL8kF32CySw9kO2Zoa
         gEw/Y4kKBoMSEo2MAtc7R8OLWx06DTG5s8Ybj4J6wNzEQsNeAXvzUbl8BdDHoLYPUi
         Dttr1R5xFH2Fg==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-510d8e4416cso6659725a12.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684772001; x=1687364001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEoXhOv9392G4YyVtPika8TuddyFutw1yuUvDKTMDXc=;
        b=kFbh3Kru5FvjB+Rffg9YzAa2aZDw2+1WXmBQXv7AdjuiRZ4B5wfhQwORSMDDpSrSix
         Oj9jQWbj3sUvmyLva/+XpSxyMpO+JAW45CBZsg6ysqlBkfrpoyml1OMoulofLaXigq1m
         IwmR5nIeUpTEO7eUezuE8hOPgKEnSKvdWWOWB9EQwaQUXtvvgJuSKB1CXLzK8bTmwvYB
         X39AEjuCHpzUBUcs3VXw+SfYU/wetUE63lr4kJEJICVXXpAJY+qQWnnhadDesL7q/+1s
         0GyWSDoseNgBaKkeOdLlNqO7Cq3QzeQWyGFPnvfLutAkKeAoWrEl/fSDIlDmKjuC90pr
         AKAA==
X-Gm-Message-State: AC+VfDxoao6JwVB2U+nhOnDMmeW/0m+tFPZs7rvgwbSO5M9o3miHisPx
        Xqk91FNlJYiPFTXbKsQt58Fy0kG9bYDzOSPoPq8TNTbpM68hifI9jZ9/FJrX8W8PtIdlAl5AdCt
        fN9L7y809uEwjCLZR2w9rNit8mfzV7Q==
X-Received: by 2002:a17:906:58c7:b0:96b:e93:3a9f with SMTP id e7-20020a17090658c700b0096b0e933a9fmr11141498ejs.20.1684772001414;
        Mon, 22 May 2023 09:13:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6dUWTXh+XjI7wSktkwgjubPt+RAL8UbOeWuwZfD0kG6B2OVu9hYOQ/teuL04KXyyfGDkSquQ==
X-Received: by 2002:a17:906:58c7:b0:96b:e93:3a9f with SMTP id e7-20020a17090658c700b0096b0e933a9fmr11141482ejs.20.1684772001173;
        Mon, 22 May 2023 09:13:21 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090682c700b009658475919csm3225039ejy.188.2023.05.22.09.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 09:13:20 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     pbonzini@redhat.com
Cc:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Sean Christopherson <seanjc@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 2/2] KVM: SVM: enhance info printk's in SEV init
Date:   Mon, 22 May 2023 18:12:48 +0200
Message-Id: <20230522161249.800829-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230522161249.800829-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230522161249.800829-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's print available ASID ranges for SEV/SEV-ES guests.
This information can be useful for system administrator
to debug if SEV/SEV-ES fails to enable.

There are a few reasons.
SEV:
- NPT is disabled (module parameter)
- CPU lacks some features (sev, decodeassists)
- Maximum SEV ASID is 0

SEV-ES:
- mmio_caching is disabled (module parameter)
- CPU lacks sev_es feature
- Minimum SEV ASID value is 1 (can be adjusted in BIOS/UEFI)

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v2:
	- print only the ASID ranges according to Sean's suggestion
---
 arch/x86/kvm/svm/sev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cc832a8d1bca..fff63d1f2a34 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2224,7 +2224,6 @@ void __init sev_hardware_setup(void)
 		goto out;
 	}
 
-	pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -2252,10 +2251,16 @@ void __init sev_hardware_setup(void)
 	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
 		goto out;
 
-	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
 	sev_es_supported = true;
 
 out:
+	if (boot_cpu_has(X86_FEATURE_SEV))
+		pr_info("SEV %s (ASIDs %u - %u)\n",
+			sev_supported ? "enabled" : "disabled", min_sev_asid, max_sev_asid);
+	if (boot_cpu_has(X86_FEATURE_SEV_ES))
+		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
+			sev_es_supported ? "enabled" : "disabled", 1, min_sev_asid - 1);
+
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
 #endif
-- 
2.34.1

