Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C3EB15A7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 23:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfILVAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 17:00:07 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:43904 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfILVAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 17:00:07 -0400
Received: by mail-pg1-f202.google.com with SMTP id z35so15492145pgk.10
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 14:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KEnCjWSN0RCUKFn6Yi+r4JQOxCeOZvptNzKeCzkkya8=;
        b=XaBCzTB7Cg4gcPNf/BRm1CP5zmDjRJF8/2uuZ8WqCdcZ6APofH7Rdq4roiQR+wNfym
         sOP89AlcBgks14wWHUhZWB873NOASm1fIBxHHuQ7aWd5fF6fmpdSodQXfldKvYF5Jtpd
         fQV7MeWRHcEEU1J9PLoC2O3jkqJiLzz4W1MoPCRLyOHN9+kkW7WhdCz8k+KRX/87sZ1Z
         k0DYzpPFtDY5094GAz2FxKArXewwu7YYz4AW+4setCAxjHbMZBgVNJ751ZTf/QC9aoFE
         l70jNB7rCLlee5RyQoMmD5K7FyVD7npk8JncbyMlF5FnRbqCrYFgKXYShfOYt/+qbOFP
         MVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KEnCjWSN0RCUKFn6Yi+r4JQOxCeOZvptNzKeCzkkya8=;
        b=nXaRC+eyFYNAxqKV9sCXWFGkB5JR2EizjifxDJR/2qKTavYCfd7YgpcFrjizy5QkZD
         UTP9y84N7yXE+X2/+qfVshktWjGGBUu6RHJ+bpHYb4Khi8IKmBHIFzmsCihijhO+EYVi
         QoQ0M920J0qJzKEO4OfCgfR/4ypfFZd8wv336mk6WBs0TMH+WRY44QwwdqMNPn9Ju4WW
         lR4i3iIW7fFbzyPSleMuCfRXGpx/gWVM4UPcKJ5MVpf3syWXVvgls9ZHdKLcR/sUK+J0
         OA3mJqPHQaCoxqhOpS9h4XerN3cbFEt9Bl7ZGUROjDM4GV3/463RkGmHcbvk5AdgaoKa
         29gw==
X-Gm-Message-State: APjAAAV65PTBAlPED11r0Bt1Xh/ZdDCBBmLpjL8ucjoQItJBllfB6TIS
        SDHCBz+XKUNbv5po9QmgJ9qwF1j2JNEzlE3p8jFYQe0bLRUV82yEjx9gh0LEm0b9QSi9IHBPIIc
        k1BMHJ1g0iPK68whY4H6sHUAA6myrKSMLiTaxDsRefAhkLf4sNGlobw==
X-Google-Smtp-Source: APXvYqwyYgXVin35pBIYe1ELFKzmpN+CzIJcAcpFD17naVTg385Tt6qCR03TR3nScpyfJQu9N4S4yvbXkQ==
X-Received: by 2002:a65:6256:: with SMTP id q22mr40025673pgv.408.1568322006020;
 Thu, 12 Sep 2019 14:00:06 -0700 (PDT)
Date:   Thu, 12 Sep 2019 13:59:44 -0700
In-Reply-To: <CAGG=3QXxGVs-s0H2Emw1tYMtcGtQsEHrYnmHztL=vOFanZegMw@mail.gmail.com>
Message-Id: <20190912205944.120303-1-morbo@google.com>
Mime-Version: 1.0
References: <CAGG=3QXxGVs-s0H2Emw1tYMtcGtQsEHrYnmHztL=vOFanZegMw@mail.gmail.com>
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [PATCH] x86: remove memory constraint from "mov" instruction
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a bogus memory constraint as x86 does not have a generic
memory-to-memory "mov" instruction.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/x86/desc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 5f37cef..451f504 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -263,7 +263,7 @@ unsigned exception_error_code(void)
 {
     unsigned short error_code;
 
-    asm("mov %%gs:6, %0" : "=rm"(error_code));
+    asm("mov %%gs:6, %0" : "=r"(error_code));
     return error_code;
 }
 
-- 
2.23.0.237.gc6a4ce50a0-goog

