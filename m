Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B14173364
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 09:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgB1I71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 03:59:27 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50327 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgB1I71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 03:59:27 -0500
Received: by mail-pf1-f201.google.com with SMTP id r13so1582847pfr.17
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 00:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DC9Dr2U6wvnIG9u1LjZFIqDbiUYzoga4sFSPARDkVp8=;
        b=lFxVH7gdKFwR8I/kc/yt0XIhW2pUcfL23CcZEAEXcvWSOu/qM8edtY0DRzRmm+iyef
         5FHNoqDfi9luJKkwJ651hBpt85BD1Ui5aouS8ndAPHNHFu+sxesXwjmsjPGsDpm0ceNS
         1m0UzaDWzAcRXWqXH9jIhMlPaOjsplKPMGLeGZ7kWSOf4AODiHqXfCduaG0DuCke+ZvJ
         ibsCvmiVg3KCGGO/6AAxTJvZ0zp+sZ4t6knPpq3P5Y7DlN1l7G0hhPxRAgQ5u0zL/vEn
         O4X4U3eJ+0YlVB7Ee/NYY9B7hPneACRYWd5JjO4yygi0nBdvec2UUyJ7xQrbnGC+iThr
         jY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DC9Dr2U6wvnIG9u1LjZFIqDbiUYzoga4sFSPARDkVp8=;
        b=UKpjQf8mxZsKnPVzjs59x5fFmbX1FcSCuh1gb8gXJvqXBdgX1wtfnu/NOl9sgxJdrj
         2tpxQQOo4OfA7z22CYmGfE+R+61PaNPPn9MTupJixv1jIe7Vped7IKiCZoGGKvZALeOj
         CXvr+PaPrslZjVHB5SMwdrnRb/GWVWMVgPPI9zJJNJ+7GOmrcOh/qzKEzsz3qrOdvyUP
         BONV0sxzIHmfd70yaygxrdpY/Dk0s6/nbm1P8T43jEbXZHXAa8sQBHGZl57JOcbH19gT
         DlaiK1ZygldmQj3oICnQ6xpGnVU1UyHTbtHaZBUj+HYP/VwKMw/Mo46gwLyZndvk74Ba
         hARg==
X-Gm-Message-State: APjAAAUYOW8oMNa3jbxwgZOvDjlhniKezNTZDlQ5jCi++xxGkvQxfq+F
        +LaK/AsdXfpgMwfp6JYoGlx52tEF/+UMf+YCXfp/lEx32fWOYehf+sD5VVT5fAQgGAJ11vb4vWN
        9c3+fJAaHJDTMY+wfsK65kQ9doPK5w3aSqUAh7HRtzQKR+FX8uFWAXZQRNA==
X-Google-Smtp-Source: APXvYqww2B/p/THhnO5vUYlgorA2EOseM8PZK+P1OocS3fuV3RsoyosDoanCqRvJAN0fVTt4b4NBwBfEe1U=
X-Received: by 2002:a63:8342:: with SMTP id h63mr3635338pge.141.1582880366122;
 Fri, 28 Feb 2020 00:59:26 -0800 (PST)
Date:   Fri, 28 Feb 2020 00:59:05 -0800
In-Reply-To: <20200228085905.22495-1-oupton@google.com>
Message-Id: <20200228085905.22495-2-oupton@google.com>
Mime-Version: 1.0
References: <20200228085905.22495-1-oupton@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v2 2/2] KVM: SVM: Enable AVIC by default
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Switch the default value of the 'avic' module parameter to 1.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b82a500bccb7..70d2df13eb02 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -358,7 +358,7 @@ static int nested = true;
 module_param(nested, int, S_IRUGO);
 
 /* enable / disable AVIC */
-static int avic;
+static int avic = 1;
 #ifdef CONFIG_X86_LOCAL_APIC
 module_param(avic, int, S_IRUGO);
 #endif
-- 
2.25.1.481.gfbce0eb801-goog

