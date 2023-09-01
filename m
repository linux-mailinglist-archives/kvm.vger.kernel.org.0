Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE317903BE
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351014AbjIAWuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351051AbjIAWuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 18:50:14 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9ACCED
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 15:50:10 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-594e1154756so27903387b3.2
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 15:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693608609; x=1694213409; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m3U2Jv+rY4cJWic+upFKLa7cRlmi7+8eEWizhIWM1ro=;
        b=X9RpIGbVzsLc/Fit+yvKKeLGnbqWEaT9pvmfBqa6PCy42yOLXmC9jMhuY04+fY4I1z
         1hQQVLxg68jcKnOMsZu5EIe5mN/FV5QrzMJQeudzxj5krfEQHMSf1L3bCYs+AmaGl4jE
         W5YjrDAl5tzM+ZCLiQ2Yn3/EApBJSiZIm37DTHF81znn/bv6oHMdalyt6Rywecx3G7tT
         YZuIAdoYyJfkCmQ7IxIij+yPj5SyDJPwSFzW2e/nQWX0fUnetezDE5TrN7ROGexK+KjP
         HCanbTA1eR2nMxtAEI1yj1rjNvQNLvOEfm0D51gxEK9tO7IlXnRPSteqer16XsJaJT60
         C5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608609; x=1694213409;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3U2Jv+rY4cJWic+upFKLa7cRlmi7+8eEWizhIWM1ro=;
        b=M4CXaaCUgAeiincSRpJFe4x77wBEIurcq4jFUM5h4M1w5Pob7xs60KU7JvB1rdpHMO
         j264Ld4BWR3eX6zW/4rZOMXt7topwvVSHEvFOz/G9x/tYQXsrZEyq0oOUqBkZzPw5/8w
         S6hQxroe8GgO9v5+P1zPnRs7rhOsZquZWi/zoTLP3hWElZ2TotFs2yi+VuGqQIoGunH2
         1/CRF8ybQSsFbBUB2YPyHcTqyhCJYEwnxy4tTJFFl+jY7lJH0SBNPL6vpYUGSAhLAdtj
         0MTVh+X/PrHARvC7XBdW4boY6UfLT08RGADOddLWME72Sq1VT+NSC1tLyAeEQNFsldKm
         GXYg==
X-Gm-Message-State: AOJu0Yx4PtQJOJlE65odm7bSMp5atlFScpuHdgmFrsbDGKIro+c9wFKK
        OZ0c8PqyfiCD0Sr7jrHqRXRLyGIBj9Q=
X-Google-Smtp-Source: AGHT+IHlPDm4KbHkxwoivLjlniiRN+rU1fhd21F58CjDWJEtlNPSXL9eOV8mMzPuGMWfx9MSLCGIYm1+cFo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b1c9:0:b0:589:a644:d328 with SMTP id
 p192-20020a81b1c9000000b00589a644d328mr106166ywh.9.1693608609625; Fri, 01 Sep
 2023 15:50:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 15:49:57 -0700
In-Reply-To: <20230901225004.3604702-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230901225004.3604702-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901225004.3604702-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/7] nVMX: Test CR4.PCIDE can be set for 64-bit
 host iff PCID is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that PCID is actually supported before verifying that it can be set
in vmcs.HOST_CR4 for 64-bit hosts.  PCID is all but ubiquitous on modern
CPUs, but PCID may be hidden by the host to workaround a TLB flushing bug
on Alderlake and Raptorlake.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7952ccb9..226f526d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7625,10 +7625,12 @@ static void test_host_addr_size(void)
 		test_vmx_vmlaunch(0);
 		report_prefix_pop();
 
-		vmcs_write(HOST_CR4, cr4_saved | X86_CR4_PCIDE);
-		report_prefix_pushf("\"CR4.PCIDE\" set");
-		test_vmx_vmlaunch(0);
-		report_prefix_pop();
+		if (this_cpu_has(X86_FEATURE_PCID)) {
+			vmcs_write(HOST_CR4, cr4_saved | X86_CR4_PCIDE);
+			report_prefix_pushf("\"CR4.PCIDE\" set");
+			test_vmx_vmlaunch(0);
+			report_prefix_pop();
+		}
 
 		for (i = 32; i <= 63; i = i + 4) {
 			tmp = rip_saved | 1ull << i;
-- 
2.42.0.283.g2d96d420d3-goog

