Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC3731E37A
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 01:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBRAXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 19:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhBRAXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 19:23:37 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE30C061574
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:31 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id j6so140144qvo.11
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZhQicEFmrpuvHlcNr0+AZHJmdWlkJ87sdk7eG/kCGi0=;
        b=OvFcaTvTg7Mho7C/LKicQIKI2e36a2VoL8uFa+yIHFuxyV+RvzeVPJdShrXdRPG09o
         Z0sXWmbbZzafeGea1oAiOZmAPDrhzsZRbR0xRLNvLybeb44eb9tGU+2/MrDoixIa86j5
         daOAVLi3zdUpjWDTkN7Rs2g6iBdBRRyG4tV+MCOYFbJ37iAhcduaL4Mq47tTEdFB6dob
         6qkNmY4BgzYGO/E5NnReCJfHqORvje94lD/kUGhWLYi0eX9CeGVCFdw3EZwrL44Je/oN
         6gE6Z+Mg8Q1+CnLf5J/WLR0xDa8oLCGAV+3PfGFRn440FAQBpNjZ8tDqJ/BEYovJMdDG
         R5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZhQicEFmrpuvHlcNr0+AZHJmdWlkJ87sdk7eG/kCGi0=;
        b=T/LVQvDMsCxgEJFvLCUe6AxExknOwRafG5n1JfzK0liEh+kPyIjK4QLLzoQH3xX1lB
         N/C7hOkBOKmMjJ20vu1oeO4ColKytMzBJ2THtpq30y6iHyfF8mW9xbDGEvmbBW/YnnsR
         xktLm6vCOxBkaZ6NqJs638+XdA4QbgFMGnpX8gr+4PYEIDDgY5QMJhz1ESfjF5txzoss
         AX66ml3n+vcK2VZWcwFKSlAUdNbWYmPWyeRFmxZNDglFz2wgV54IC4HBzr7CGzo2/LX4
         U2FkpSqwMhXOpPN5qb9bnRH7H6jXK97e5BNQWmiM015BFhTZ0bF6toh0ZrlgvenZn804
         KN0Q==
X-Gm-Message-State: AOAM5333zpQSRTqjo97twHdXtEZIKIqHfDSSDY5Ga2ZGlHRV4dZ5Iskg
        tp7/qdi1c5aKMeSyslxpvXARdhGhWUs=
X-Google-Smtp-Source: ABdhPJzfHGLj42+lIXpEGOYvtsbIeKTTQlFHTvb6BgWIgAuGy+Pej59hPRPjv03/mMCuoJlvNcwGOK2NnGE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
 (user=seanjc job=sendgmr) by 2002:a0c:c687:: with SMTP id d7mr1854255qvj.17.1613607750422;
 Wed, 17 Feb 2021 16:22:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 17 Feb 2021 16:22:12 -0800
In-Reply-To: <20210218002212.2904647-1-seanjc@google.com>
Message-Id: <20210218002212.2904647-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210218002212.2904647-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 6/6] x86: nVMX: Add an equals sign to show
 value assoc. in test_guest_state()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Insert "=" between the field name and its value when reporting a failure
in test_guest_state() to make it obvious that the number is the value of
the field.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1097a53..f9883f0 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5556,7 +5556,7 @@ static void test_guest_state(const char *test, bool xfail, u64 field,
 	       ((xfail && result.exit_reason.basic == VMX_FAIL_STATE) ||
 	        (!xfail && result.exit_reason.basic == VMX_VMCALL)) &&
 		(!xfail || vmcs_read(EXI_QUALIFICATION) == ENTRY_FAIL_DEFAULT),
-	        "%s, %s %lx", test, field_name, field);
+	        "%s, %s = %lx", test, field_name, field);
 
 	if (!result.exit_reason.failed_vmentry)
 		skip_exit_insn();
-- 
2.30.0.478.g8a0d178c01-goog

