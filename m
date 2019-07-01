Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B9723E30
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 19:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403948AbfETRRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 13:17:13 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38470 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403896AbfETRRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 13:17:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id f97so7004967plb.5
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 10:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZOAFt+EVBvRQjGvA+lirOOWJZTc+k2CDtH1cV19fpyg=;
        b=Rd0nRkQD2f4HHH4INmwZuwYsxFgRLt+8OhQYgbxOwBKL6TcJfvA3PowEhR5asUThzA
         DSzhna2lZm2ioTFV4Wg1GJM86+JLLpyQZRoGOtRg+Gjrw6ASTeec0NyWLpqxX0hdWt2q
         hzO89+PMfXgBdYxU3asGi+5GvnfiP7PKXWzhD4mvldIyiXOTUjSLZEfBfcwnDpeAA+cr
         OynBoxxZXBsAX+fjfqQb4mHi4C2cto4tLwE/z+5nEh7Y57KnH1Ekm9KRNzOdc0aaKkdc
         muKNVkZrN6IpH1bi+MC6O0cqu5q2eaFHyDvkfuQ5go7ZZU3ACw1vDa1TPcBXjCYgm1UK
         UodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZOAFt+EVBvRQjGvA+lirOOWJZTc+k2CDtH1cV19fpyg=;
        b=rzFzHanGQW+rpXhu++Sf3JiEMUKrQ7xxl47eBSAa0Xlgrbg9opOyUcq4hRBqzE15Vc
         +BzZDhIrNUQQKYvR35mYvfNR/1AUIp2MQXt4tRHZ8J0fbuZepE/hsfpZvcKV8SWZ5J7d
         bgrxaYg5ln6ct3wFIUv81hMJLib/N2Z3jtukA+QdTEgfE8g4I8XEWm/6+LDbL8ZPUR9Q
         QwH1du3yAhEYL6qJc2fBajIdsAd5juqd/zl2UqQf8o/4zsyVn1IK90gebxI+QEjzI7y8
         zW6oYbExA4pNojWVGmv2yVd1qgH8cZwPSz+EOSKWMSvb9H+2zi6pOrqTJOv43RdEiEQr
         3oFQ==
X-Gm-Message-State: APjAAAWzgvvakIpLAFZdapa9g3YrSv97E6jlXLgUL/PEN8jK2U3t+ZKq
        HN0r79CjbAXgqtdaOs63D0A=
X-Google-Smtp-Source: APXvYqwOFfcLiq3R38qcFmdYjhY+JsDleZbKfo4e5pJJsEGGJT7rJjUsnxfYXBDRclSVzyPjgN2jag==
X-Received: by 2002:a17:902:5983:: with SMTP id p3mr74839232pli.224.1558372632370;
        Mon, 20 May 2019 10:17:12 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id i7sm14978114pfo.19.2019.05.20.10.17.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 10:17:11 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH] x86: Remove xfail in entry check in enter_guest_with_bad_controls()
Date:   Mon, 20 May 2019 02:55:16 -0700
Message-Id: <20190520095516.15916-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test succeeds in failing entry. This is not an expected failure.

Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f540e15..014bf50 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1833,8 +1833,7 @@ void enter_guest_with_bad_controls(void)
 			"Called enter_guest() after guest returned.");
 
 	ok = vmx_enter_guest(&failure);
-	report_xfail("vmlaunch fails, as expected",
-		     true, ok);
+	report("vmlaunch fails, as expected", !ok);
 	report("failure occurred early", failure.early);
 	report("FLAGS set correctly",
 	       (failure.flags & VMX_ENTRY_FLAGS) == X86_EFLAGS_ZF);
-- 
2.17.1

