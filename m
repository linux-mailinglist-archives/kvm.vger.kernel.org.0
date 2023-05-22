Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F0070C312
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbjEVQNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 12:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjEVQNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 12:13:23 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044A5DB
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:13:22 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 577F83F4EE
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684772000;
        bh=4rb90djqBbs5XuYtW3R9I7+5RrdmbXXkWM9Wptt0JPo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=kGbV8pY6g9wUtSipAX/32hBadyjG1AiedXvrjmwkF3oO7/uSu9R4x+mffgGu0Ui+7
         r4iZZnCECP/IBrKFNAu9oPnDH0oZvaHTGxImB9tWQilrZ3IniZ7Bh0xyGXAZYz2DFi
         0vTguQO80p9zoRpd+wQdEt1OG/nGEucPQ+B7PvnUNkMPoMYQUSgkBJJuRnEczwxeCY
         AxG4b2XI88C0L9xdLUziA3HWQ7eQioj9OOnw0gHxKCA2Zbb5oluBBRODkhoNPXoXGR
         L0GZUrexZSCDyDZkG4C3xwJrrZWzUBvuxhA7Du+lwmf3P4q2mAoOm4Q+b7tLtaklsP
         SJ8abN8cAAi6A==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94a348facbbso790579166b.1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:13:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684771998; x=1687363998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4rb90djqBbs5XuYtW3R9I7+5RrdmbXXkWM9Wptt0JPo=;
        b=jxKjH2jobqPYNLPIX2cB9RL1KjJEFQdY5IQ6QmpxHkBx0dAOldXhcZK1iVNoKrfZ+s
         /8vnBQB+kpqi8LQGm3CO2wLvh8H64CKScgQBwzbjCjwQFI/C3pEB3vNcno41OkCikSdl
         Si2rhmO4KspKcCU2HIsxw3nXOCqaRCX8q7M1u3/fgwOxy4urbRP+dJo1r/ThHNkoE3RH
         e3YU8ncX/zDjnqdl5KHl3CxTJ75dwOBiHtASUK2WNOgZGXqX62wKkoiVamzngql6/B/+
         9AHCK9/8FEf1BBh1j9+HVY7fst1o/wu2X/92c0UblLfzzaEu4YbK/tQMxI0cwAV2ibPs
         kNRA==
X-Gm-Message-State: AC+VfDzODbJB5LiGEqWcSj1DFPb6LOqSi45lt9fopyGjaNu4HebSi7H+
        A88bY/wv/2jo406t3y5B7VyBwgC411ADni4kh8H/p5TME+a7636rQzY2QXOoAlWQLgYbzUaf6Ex
        3hAXZYVQYbHDpmzRYdxRmLmysTI7+rg==
X-Received: by 2002:a17:907:e8c:b0:965:ff38:2fbb with SMTP id ho12-20020a1709070e8c00b00965ff382fbbmr11057650ejc.1.1684771998136;
        Mon, 22 May 2023 09:13:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6sFu9ZDMMoJ+qT7dryKzCzvkxh7vw6VbgF+1fgPmovvfOkC6jSGHbWPbUIqDC9vc4/EtEUfg==
X-Received: by 2002:a17:907:e8c:b0:965:ff38:2fbb with SMTP id ho12-20020a1709070e8c00b00965ff382fbbmr11057638ejc.1.1684771997945;
        Mon, 22 May 2023 09:13:17 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090682c700b009658475919csm3225039ejy.188.2023.05.22.09.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 09:13:17 -0700 (PDT)
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
Subject: [PATCH v2 1/2] KVM: SVM: free sev_*asid_bitmap init if SEV init fails
Date:   Mon, 22 May 2023 18:12:47 +0200
Message-Id: <20230522161249.800829-2-aleksandr.mikhalitsyn@canonical.com>
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

If misc_cg_set_capacity() fails for some reason then we have
a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
not a case right now, because misc_cg_set_capacity() just can't
fail and check inside it is always successful.

But let's fix that for code consistency.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 arch/x86/kvm/svm/sev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 69ae5e1b3120..cc832a8d1bca 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2216,8 +2216,13 @@ void __init sev_hardware_setup(void)
 	}
 
 	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
+	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count)) {
+		bitmap_free(sev_reclaim_asid_bitmap);
+		sev_reclaim_asid_bitmap = NULL;
+		bitmap_free(sev_asid_bitmap);
+		sev_asid_bitmap = NULL;
 		goto out;
+	}
 
 	pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
 	sev_supported = true;
-- 
2.34.1

