Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC26E8D1F
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbjDTIsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 04:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjDTIrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 04:47:55 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CAC5599
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 01:47:43 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4AF6241B37
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 08:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681980462;
        bh=QUa3auAj4u9NqRTBT9WVcUeMs8DEO6WQSLZjTthBB3A=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=nmCdT5ZHmnT7A7DA4OX4xBVkbWKNP2NQn2RXdz88XT988P8SQbeThehfIufYBWzw+
         IeB7pea2xl5lr45vg347i0rlq+IxMunly7GWSqfmjNaU/6JGy5u2XrRRmiGkjQGmfL
         QHRJBeR/CYjQRFGcqDECnEcxth0/noZbFwSHWWtCf8iZg7zWjD6GEq/b4yAQ2mPv3P
         huGdkmBzfxaMUoKsoamvrekEGg0ed6q/jjPhI7HjSFh0KIgRsYZeNZExtW+bBQUx2f
         QYGh4kBba18/GTBercMJEB2Gnnl0tam1DGCqvGSVKNUVQfRLFerz+hrMVKKqNzGGyC
         xP7L9KpJbrxNw==
Received: by mail-ed1-f70.google.com with SMTP id h8-20020a50cdc8000000b00506a09c4a49so1211835edj.9
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 01:47:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681980459; x=1684572459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QUa3auAj4u9NqRTBT9WVcUeMs8DEO6WQSLZjTthBB3A=;
        b=OhAtBAF7TpUTfbipMHAUv4M/llvHFoxzAW88CS6dLfa2X5pM4ATQmAoswAcXGhvHpY
         pb70xn4m/JB2bfjXIgnzMbsuVjdUFKVyS2VUeL/TPonwYQ3F6w8KnixmxnMqHrgqRkHK
         9GifIZ67UdNPLk5X6A9HSTRPvTLQFe6JbWW0mQBQvSvftxBwpgFO/QJJdahoUQgRho6A
         /wGmkqOg20KauWVhjzqps+lTVkxXpsDX6gh7p8yTv6gfSvPRTUgZP7q1jPRGdudBO6Xd
         Q/TkP4+IsGFzeZkhe3ax940TC+ROhe4QoAl39AaumedlZcjbFM+3J92Rq1zlrZ1PAYuV
         +vsQ==
X-Gm-Message-State: AAQBX9fKT9x28HM158Tm3MeAQcfPYOh1OM4TQr/YcQWGYeLhfu4F6CN5
        hjxkMkcOPVQMuT7hql8XyIgMFN7OHcF+mXOsms5ThaMcflTV0X11iYZxHLeXi2vfRO8IThBj8e0
        diLQaAlcjOHAmh2okeE+Z/ozSbNnYgw==
X-Received: by 2002:a17:906:3512:b0:94f:12c0:4c8f with SMTP id r18-20020a170906351200b0094f12c04c8fmr820690eja.50.1681980459546;
        Thu, 20 Apr 2023 01:47:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZzV+Zu8+SSa+Fm3TdTM/basx1ZOevVs7KCOHxWHbqRAxUygjWfAeKhy8CpvyHsuSUMo+P3vg==
X-Received: by 2002:a17:906:3512:b0:94f:12c0:4c8f with SMTP id r18-20020a170906351200b0094f12c04c8fmr820671eja.50.1681980459275;
        Thu, 20 Apr 2023 01:47:39 -0700 (PDT)
Received: from amikhalitsyn.. (ip5f5bd076.dynamic.kabel-deutschland.de. [95.91.208.118])
        by smtp.gmail.com with ESMTPSA id k26-20020aa7c39a000000b005068053b53dsm500964edq.73.2023.04.20.01.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:47:38 -0700 (PDT)
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
Subject: [PATCH RESEND 2/2] KVM: SVM: add some info prints to SEV init
Date:   Thu, 20 Apr 2023 10:47:17 +0200
Message-Id: <20230420084717.111024-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420084717.111024-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230420084717.111024-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
enabling a little bit handier for users. Right now it's too hard
to guess why SEV/SEV-ES are failing to enable.

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
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a42536a0681a..14cbb8f14c6b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2168,17 +2168,24 @@ void __init sev_hardware_setup(void)
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
-	if (!sev_enabled || !npt_enabled)
+	if (!sev_enabled)
 		goto out;
 
+	if (!npt_enabled) {
+		pr_info("Failed to enable AMD SEV as it requires Nested Paging to be enabled\n");
+		goto out;
+	}
+
 	/*
 	 * SEV must obviously be supported in hardware.  Sanity check that the
 	 * CPU supports decode assists, which is mandatory for SEV guests to
 	 * support instruction emulation.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_SEV) ||
-	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)))
+	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS))) {
+		pr_info("Failed to enable AMD SEV as it requires decodeassists and sev CPU features\n");
 		goto out;
+	}
 
 	/* Retrieve SEV CPUID information */
 	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
@@ -2188,8 +2195,10 @@ void __init sev_hardware_setup(void)
 
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = ecx;
-	if (!max_sev_asid)
+	if (!max_sev_asid) {
+		pr_info("Failed to enable SEV as the maximum SEV ASID value is 0.\n");
 		goto out;
+	}
 
 	/* Minimum ASID value that should be used for SEV guest */
 	min_sev_asid = edx;
@@ -2234,16 +2243,22 @@ void __init sev_hardware_setup(void)
 	 * instead relies on #NPF(RSVD) being reflected into the guest as #VC
 	 * (the guest can then do a #VMGEXIT to request MMIO emulation).
 	 */
-	if (!enable_mmio_caching)
+	if (!enable_mmio_caching) {
+		pr_info("Failed to enable SEV-ES as it requires MMIO caching to be enabled\n");
 		goto out;
+	}
 
 	/* Does the CPU support SEV-ES? */
-	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
+	if (!boot_cpu_has(X86_FEATURE_SEV_ES)) {
+		pr_info("Failed to enable SEV-ES as it requires sev_es CPU feature\n");
 		goto out;
+	}
 
 	/* Has the system been allocated ASIDs for SEV-ES? */
-	if (min_sev_asid == 1)
+	if (min_sev_asid == 1) {
+		pr_info("Failed to enable SEV-ES as the minimum SEV ASID value is 1.\n");
 		goto out;
+	}
 
 	sev_es_asid_count = min_sev_asid - 1;
 	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
-- 
2.34.1

