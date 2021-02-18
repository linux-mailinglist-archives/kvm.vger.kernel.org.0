Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB3631E378
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 01:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhBRAXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 19:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhBRAXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 19:23:10 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04E6C06178B
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:28 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id x21so183322qkm.19
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=B5/JuJRrp4tSajA98STkVloyawJT2dkhjvJPRU2rLz4=;
        b=Pxbyk9AivqqatV9+7lD7nBGmULHWAXryKVycSN4YNyFk+Prlc3uYkF0/S62lmq+Ho6
         pVVoz+DDKbn2IoQ4fnuH/kkf8RvPQepWzVOlvuTOPuAQVn6jtb1iDLuBUae6IR6cFKBD
         f7+QGHXHmQqec7Bn2MXy7d6klV/ybmA3t7mbl0Ut1WR1QNhD+WJWy51DP/x9R9KkVaav
         IDD1UDMYFTV77gtvpS7atAx2rbGoKJkJjxrh7MukqBJxtWjImBNaNOlVehJ7w2Yqb7J7
         130GePYF2UleSyNJL6O8z8cOhGee5NUK5E9m8aR0gU/86rySc970DYLgWPczSTpmxOwM
         ca8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=B5/JuJRrp4tSajA98STkVloyawJT2dkhjvJPRU2rLz4=;
        b=lfAhVxtyVKF8A0zEe/DyQcmuz4tVgEfCmn+jJSCyQRszJol1rCVk1SffhN3HkH1WFZ
         QhMOXUTA81BfD8qopMiWtXiydmgc4lLJ9lTTdrmAQXtu1QZhvCboRkgLr/94UXF7lSBe
         kVmvzUOflDIyPTBwL6/e+GfvOwuCpyP3G80d11kSH4TIo+5H0KLbLAvwQO4MPk1qarLt
         1mxOsrfYHTp/YFmRKz00OdHZnO6ECSBaILx/iICu9UKTanlnfrHRORzk0jq4kE5RU4Vl
         vtYhSryTstfBIX7F2UpptHaePW+dhvNcZNDVWmiSVPoVPa9jqorSDj32+W76EHcmihEa
         ezdw==
X-Gm-Message-State: AOAM533aAFTt0pmOTFxN+i42wRAjWW6dRaZXOCx5QdsAxNKY7SYMjeyn
        vXm/2xSoygneatXmR3K8nRsT+vuv5mE=
X-Google-Smtp-Source: ABdhPJyNrZbxoI3xWUsnoAsyuGYyp0dOsQOnKcKSnbFW79GKS9497OaOqtfbsd7Nxe4jRuOSDHoYpjxqjJU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
 (user=seanjc job=sendgmr) by 2002:ad4:54ad:: with SMTP id r13mr1772282qvy.48.1613607748144;
 Wed, 17 Feb 2021 16:22:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 17 Feb 2021 16:22:11 -0800
In-Reply-To: <20210218002212.2904647-1-seanjc@google.com>
Message-Id: <20210218002212.2904647-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210218002212.2904647-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 5/6] x86: nVMX: Use more descriptive name for
 GDT/IDT limit tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly state that the invalid limit tests are testing a limit
greater than 0xffff.  Simply stating the field name is not helpful since
it's already printed on failure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 94ab499..1097a53 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8205,7 +8205,7 @@ static void vmx_guest_state_area_test(void)
 	for (i = 16; i <= 31; i++) {
 		u32 tmp = guest_desc_limit_saved | (1ull << i);
 		vmcs_write(GUEST_LIMIT_GDTR, tmp);
-		test_guest_state("GUEST_LIMIT_GDTR", true, tmp, "GUEST_LIMIT_GDTR");
+		test_guest_state("GDT.limit > 0xffff", true, tmp, "GUEST_LIMIT_GDTR");
 	}
 	vmcs_write(GUEST_LIMIT_GDTR, guest_desc_limit_saved);
 
@@ -8213,7 +8213,7 @@ static void vmx_guest_state_area_test(void)
 	for (i = 16; i <= 31; i++) {
 		u32 tmp = guest_desc_limit_saved | (1ull << i);
 		vmcs_write(GUEST_LIMIT_IDTR, tmp);
-		test_guest_state("GUEST_LIMIT_IDTR", true, tmp, "GUEST_LIMIT_IDTR");
+		test_guest_state("IDT.limit > 0xffff", true, tmp, "GUEST_LIMIT_IDTR");
 	}
 	vmcs_write(GUEST_LIMIT_IDTR, guest_desc_limit_saved);
 
-- 
2.30.0.478.g8a0d178c01-goog

