Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4333C45D2CD
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353653AbhKYCFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353462AbhKYCDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:02 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81387C0619EC
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:30:00 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id v18-20020a170902e8d200b00141df2da949so1514904plg.10
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vAe3I3R0ljUR1SuEkrtojHDrAkJO+GvXbKGWe5WLhco=;
        b=H0p7LYpDpX/XgKSR+tGFXUjjZIVA9CedsLxx3A1s4ZNX269AexuKy7aIHeFmnmYI7K
         cyLNiHU1ZQBEld1cfZJbKXE9L2ni6YL2LtvVZmvRu0LExiD7zaXhGtlXjLzhOHw1n8Kk
         x52XAf+f3Yeaf3YJwYsnhRWhVo5Xgqd5kd8WHYPnuKM6UVe2kwFUIv8YZ7fOXzVpyPrC
         SGb1UHrR/R3g3kg5Qv3oLCJ25ujrJvW7K/aT+j1Fy1tqy+RiWBLP2kg8K6XmylRgVPoh
         mNfgEk2W+QjSXRn9axM9l72cUsdLbk50Vb5SZRQSFgMh/7Ou+k2qvrowO6pb58SDf4/h
         7cRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vAe3I3R0ljUR1SuEkrtojHDrAkJO+GvXbKGWe5WLhco=;
        b=43s6sg1PkomPhkz8I4cigFx3TC9kx9nkLVs0/WpvhsGxKDj6fjCsZUH8guR466mbAw
         pEOUBEYTKT2F2oan0pzyFFdEht9obhMVrmgSEZlAb0FYM4WuKAW0gLvK/91T7aRMF6bj
         xHBsHEipk1dfO/nznrCv8eTHQNuJXW2rxxGKDPPjJZHxpjABfcgnDS6HuX3whjp3OZbF
         5ku1bxWiJVXp2T+u9Jai82eHz7sCD/FkRvQ6gzRlMazHXuUgkQK8RmvVyxqCP8tCs4kU
         z/DOx1q09ksPRkj+J7lMsbIp9yhifAGCk/9ZbOuMiBYSh3vTtUVVgwakl2xFF5+xllcR
         XMPw==
X-Gm-Message-State: AOAM5318uB8iGg7li6xR4qslCiXkN5HLWEMT4vLcExHBj8AcK7e52dkf
        3G6gf8p9uN08dYVURT6TrCluptKY8t8=
X-Google-Smtp-Source: ABdhPJyJe32hRL31KJ4BKK2yM/Viv1YZz++NRJURxNinJGobF4GZmWhDNsJRBk7Mv4lqflixVSME44gzAJo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b411:b0:143:6fe8:c60e with SMTP id
 x17-20020a170902b41100b001436fe8c60emr25001890plr.41.1637803800060; Wed, 24
 Nov 2021 17:30:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:55 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-38-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 37/39] nVMX: Rename awful "ctrl" booleans to "is_ctrl_valid"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename ctrl to is_ctrl_valid in several tests.  The variables are bools
that, *** drum roll ***, track if a control setting is valid.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index bdf541b..316105b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3819,7 +3819,7 @@ static void test_apic_virtual_ctls(void)
 	u32 saved_secondary = vmcs_read(CPU_EXEC_CTRL1);
 	u32 primary = saved_primary;
 	u32 secondary = saved_secondary;
-	bool ctrl = false;
+	bool is_ctrl_valid = false;
 	char str[10] = "disabled";
 	u8 i = 0, j;
 
@@ -3838,18 +3838,18 @@ static void test_apic_virtual_ctls(void)
 		for (j = 1; j < 8; j++) {
 			secondary &= ~(CPU_VIRT_X2APIC | CPU_APIC_REG_VIRT | CPU_VINTD);
 			if (primary & CPU_TPR_SHADOW) {
-				ctrl = true;
+				is_ctrl_valid = true;
 			} else {
 				if (! set_bit_pattern(j, &secondary))
-					ctrl = true;
+					is_ctrl_valid = true;
 				else
-					ctrl = false;
+					is_ctrl_valid = false;
 			}
 
 			vmcs_write(CPU_EXEC_CTRL1, secondary);
 			report_prefix_pushf("Use TPR shadow %s, virtualize x2APIC mode %s, APIC-register virtualization %s, virtual-interrupt delivery %s",
 				str, (secondary & CPU_VIRT_X2APIC) ? "enabled" : "disabled", (secondary & CPU_APIC_REG_VIRT) ? "enabled" : "disabled", (secondary & CPU_VINTD) ? "enabled" : "disabled");
-			if (ctrl)
+			if (is_ctrl_valid)
 				test_vmx_valid_controls();
 			else
 				test_vmx_invalid_controls();
@@ -3946,11 +3946,11 @@ static void test_virtual_intr_ctls(void)
 	vmcs_write(PIN_CONTROLS, saved_pin);
 }
 
-static void test_pi_desc_addr(u64 addr, bool ctrl)
+static void test_pi_desc_addr(u64 addr, bool is_ctrl_valid)
 {
 	vmcs_write(POSTED_INTR_DESC_ADDR, addr);
 	report_prefix_pushf("Process-posted-interrupts enabled; posted-interrupt-descriptor-address 0x%lx", addr);
-	if (ctrl)
+	if (is_ctrl_valid)
 		test_vmx_valid_controls();
 	else
 		test_vmx_invalid_controls();
@@ -4674,12 +4674,12 @@ done:
 	vmcs_write(PIN_CONTROLS, pin_ctrls);
 }
 
-static void test_eptp_ad_bit(u64 eptp, bool ctrl)
+static void test_eptp_ad_bit(u64 eptp, bool is_ctrl_valid)
 {
 	vmcs_write(EPTP, eptp);
 	report_prefix_pushf("Enable-EPT enabled; EPT accessed and dirty flag %s",
 	    (eptp & EPTP_AD_FLAG) ? "1": "0");
-	if (ctrl)
+	if (is_ctrl_valid)
 		test_vmx_valid_controls();
 	else
 		test_vmx_invalid_controls();
-- 
2.34.0.rc2.393.gf8c9666880-goog

