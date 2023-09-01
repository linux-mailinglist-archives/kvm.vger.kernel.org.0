Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764C77903C1
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351083AbjIAWuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351086AbjIAWuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 18:50:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050B1E5B
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 15:50:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59222a14ee1so30237827b3.1
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 15:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693608616; x=1694213416; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mi8kN2V/PmfjoqL/WNq2YxxWTqvv0j5fmwWTlPyDpS4=;
        b=Q++cdHUWlKx3WxIfrmzcg8/Z4aB5Rvp0I2pQQ0dhYeK7Lzbi2pVdh/M3ro6nTeMIPv
         A7HVjvMm2iYuohBxsD37etdgl7es8RXSCT1P7NIH1BK0vjiZL5s6AaA4HgDPpzwrrszl
         TB8JOJMLjqzayMWDjxMH7zmHMaKzmL7FvxLUjaiey8QuI2UhzapZbzQN5lMVtN1i61J4
         gcNRFu4Ps1kxV09OIvemiRX7fZdQxZBCSlg2DHMfcuC5WZO/nk3eWaMLRqVgw2fXLqjF
         4c2kzTAQ/ZmjqCXCPEFA3KryqC85Pf4+lCzGa0/61HUCPT9Ura5jWM7TaCrxHsU/AYcK
         Qjrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608616; x=1694213416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mi8kN2V/PmfjoqL/WNq2YxxWTqvv0j5fmwWTlPyDpS4=;
        b=RGiAoeNqFzxQxDummdkQgJTKCTXFGjkr2csGv0mvlHMfIEfDSRmvYUf31si/JGl+iQ
         9d0ivabfESOkZN0hskMcoBvNEz8F48dnQ/23+YvrwfQJcZKKOqLqrdg0rrbV55lXFSON
         VO3J4XpRGDIk2QDn6YKG5+IT08FHTjA8Qgs10xu9SSBGW5YN6evcVxugGtGNDkkD0sQc
         N7iEzXi8hAQtpipkjDHizbfGn7XPV1h7UgGVPu9AypMpitNd3DbhaZq1hUb2GKX7Tlmu
         CcDTwjmuC2b/hRGYfEQnIiS/HGxb9QFHw02WxDvzmfwl9IZABVjWiDmYHSMnq+SJREaY
         onlA==
X-Gm-Message-State: AOJu0YwiS5z/v5OTK9oSo/ffe6xJvgevpsZE5FcBKGISIGic6CSFzRXj
        4TPVkn/6e/7g8RReC8ml4EYQ1AzCrVo=
X-Google-Smtp-Source: AGHT+IFqxVFI4CzFmZzzVuZO+71Vw0bTY1wEJTOyQedgjLupxVJ/LI0XsQYAPIT5VO5itRSzxhz2BPVWs7Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c103:0:b0:589:9ebc:4bfc with SMTP id
 f3-20020a81c103000000b005899ebc4bfcmr109361ywi.9.1693608616193; Fri, 01 Sep
 2023 15:50:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 15:50:00 -0700
In-Reply-To: <20230901225004.3604702-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230901225004.3604702-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901225004.3604702-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 4/7] nVMX: Rename vmlaunch_succeeds() to vmlaunch()
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

Rename vmlaunch_succeeds() to just vmlaunch(), the "succeeds" postfix is
misleading for any test that expects VMLAUNCH to _fail_ as it gives the
false impression that the helper expects VMLAUNCH to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 03da5307..376d0a53 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3290,7 +3290,7 @@ static void invvpid_test(void)
  * VMLAUNCH fails early and execution falls through to the next
  * instruction.
  */
-static bool vmlaunch_succeeds(void)
+static bool vmlaunch(void)
 {
 	u32 exit_reason;
 
@@ -3320,7 +3320,7 @@ success:
  */
 static void test_vmx_vmlaunch(u32 xerror)
 {
-	bool success = vmlaunch_succeeds();
+	bool success = vmlaunch();
 	u32 vmx_inst_err;
 
 	report(success == !xerror, "vmlaunch %s",
@@ -3339,7 +3339,7 @@ static void test_vmx_vmlaunch(u32 xerror)
  */
 static void test_vmx_vmlaunch2(u32 xerror1, u32 xerror2)
 {
-	bool success = vmlaunch_succeeds();
+	bool success = vmlaunch();
 	u32 vmx_inst_err;
 
 	if (!xerror1 == !xerror2)
@@ -3487,7 +3487,7 @@ static void test_secondary_processor_based_ctls(void)
 	 */
 	vmcs_write(CPU_EXEC_CTRL0, primary & ~CPU_SECONDARY);
 	vmcs_write(CPU_EXEC_CTRL1, ~0);
-	report(vmlaunch_succeeds(),
+	report(vmlaunch(),
 	       "Secondary processor-based controls ignored");
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	vmcs_write(CPU_EXEC_CTRL0, primary);
@@ -7320,7 +7320,7 @@ static void test_pgc_vmlaunch(u32 xerror, u32 xreason, bool xfail, bool host)
 	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
 
 	if (host) {
-		success = vmlaunch_succeeds();
+		success = vmlaunch();
 		obs = rdmsr(data->msr);
 		if (!success) {
 			inst_err = vmcs_read(VMX_INST_ERROR);
-- 
2.42.0.283.g2d96d420d3-goog

