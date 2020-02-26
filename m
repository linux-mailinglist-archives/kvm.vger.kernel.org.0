Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5133116FB23
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgBZJot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:49 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:54445 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbgBZJos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:48 -0500
Received: by mail-pl1-f202.google.com with SMTP id s13so1414097plr.21
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pvcm8MZ0RliZCFtd81lkqdkPVzbXHWhtbZtW9VB8qF8=;
        b=GKYFWXZMT949uGz4XdlCigNh/jwxaX0pc4SSP7+VRrxgUkeD4/n5IBsMsW5pWoQPUv
         bgSn9l1DEuAsreiE/RPKlnZi7zuyBGJl7X/owPouB/BDyfdJGF1cpwGBUxIjTnBHrsEk
         3xETsWcY0KY6W0piMqJeBmd4BfChgMoFExJp6eLAHo1lqBuUzUsWR4lswYgORtlxvIwD
         ptVpnGZIyruiwxQdRIsYfD2pf2WONkjHy74FDOHMEk0uB/OLPByMgTVGZuijzh2/RAur
         XG4KuWlTGekZy1nYedazSGkRO3tnr2DghKhE9GYWs+ad3xJ1JW3LW3MsMzjlxs95HQlc
         UQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pvcm8MZ0RliZCFtd81lkqdkPVzbXHWhtbZtW9VB8qF8=;
        b=CX+pvh2GdT2MK5crCxd2tn1pIcnqBx01YkjsyHhJnEZsQzGoSVM9Srbw7N3KKYJOAX
         jGTLfFW5Cj2XAQn9h3kAN1ghcuOXLdS/pRSM8jzj1sIZFAOlbyRSlERla2Im4dsX/5Pp
         7NE2JuQkoBTymML3oJ1WPSB4shjxkij3aw7cav6+dYUcDYpMSSCvsiAzBXqy8sWoGjM7
         8IfbY3bUWckj4iSvQqc4hsl76w6rqWAczUJMLYuM3KIUOiY5odfwgb0eOtC1W8GrWXC/
         ENJeq8EbcrCvUea42TRoIps/G9q+ayJv3Z+VSuI9eflH8N0wv9euEMdfn4pywIgr5y5L
         ZT5w==
X-Gm-Message-State: APjAAAUS4/4bNeY1i/eSSmb1DQe3Al1En69Vrkx9JAPYGF0F8izGBl37
        MLW5Tg2a1dAkyL4oFyiZBWaR+ZzUOtDCog9HOnCGkAz87krJNqWbX/dpaisxWmtkR2dSUMbToxz
        Vg1fz6x8O6W1Z+SaaoSEwLroC+bjE4zVKQ3KTSSAIyQFHO+TCQH/8dg==
X-Google-Smtp-Source: APXvYqwHmXbP9rkukxJXuE3CdXnMQZsD0VxWHav+57GZr0j9ZCP2jEAanA51bO6CZGw+X+WVe8VA6GU1YQ==
X-Received: by 2002:a63:df02:: with SMTP id u2mr2859344pgg.403.1582710287454;
 Wed, 26 Feb 2020 01:44:47 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:23 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-5-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH v2 2/7] x86: provide enabled and disabled
 variation of the PCID test
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

The PCID test checks for exceptions when PCID=0 or INVPCID=0 in
CPUID.  Cover that by adding a separate testcase with different
CPUID.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/unittests.cfg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index aae1523..f2401eb 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -228,7 +228,12 @@ extra_params = --append "10000000 `date +%s`"
 
 [pcid]
 file = pcid.flat
-extra_params = -cpu qemu64,+pcid
+extra_params = -cpu qemu64,+pcid,+invpcid
+arch = x86_64
+
+[pcid-disabled]
+file = pcid.flat
+extra_params = -cpu qemu64,-pcid,-invpcid
 arch = x86_64
 
 [rdpru]
-- 
2.25.0.265.gbab2e86ba0-goog

