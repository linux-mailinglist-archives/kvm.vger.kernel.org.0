Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D0404048
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 22:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350992AbhIHUrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 16:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351315AbhIHUrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 16:47:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5622CC061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 13:46:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i189-20020a256dc6000000b005a04d42ebf2so3389874ybc.22
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 13:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1Z8arWG7n7nYSLAB5sIY84HSS8RK8P5QJTtRdR1uUKo=;
        b=NigS/8vceRrPawisJsT2RAeCwXW2cDmeCGHtiEqnZM6v+rYAUZLxH30nmHmIda1bP/
         RHfenja7vSN78qc/tOqU2gJ1q1mSfYga6rIFn80LglngowHsJetGnZcQOs4QOCM4cWTM
         uaoXZ9bONwbVt6MOI8wOcXUsufBqF7iGEwYe5YgrmbPtv23PdNNDh0eyFLZjW/N/nblc
         mLUXU6k5gtj4tk5ilr9DpnEa80Zt0bGxsh9fVILwsXMHt/lGySpd0t8qc/e7pgfceIBb
         NrnFUAyJa29T5LPNufbHfAFPaNTzIxSsmaCqaSPJcZdm0E52Yw3sT8tA13wU+BkE8NoD
         X/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1Z8arWG7n7nYSLAB5sIY84HSS8RK8P5QJTtRdR1uUKo=;
        b=z03gy3bqfLfLgx3afmCSBHIpOOoSNKys3JJB6+EKLpOeJ7Yn7HJHeKXV4TCddrDOot
         /3WsHQU41rTokYxZ3qZrA/KLzdX7i5PSJtOPVjNIi6ctYeO9MqhPbiZ47z6Eb8B5vDw+
         UFzX0Fw7DAKqvm8MUtJr/6VkwgcDWeBIC3K57nAVnHYZyWLbBzL5uGa/dFMwXbTAycNd
         cddurUUJvh8cwC4HLBrgC+GB+JQ/PvbdCCRkBfCRDgGnwjmJtKzvn+vPpWzEfRYPSLqb
         qOPCRj1SZ7dfhRR3DIfYUEvy6R/imVnho3p0roGCh2YCB89lZxdQ49SjhNI9ZAknrFh5
         fciw==
X-Gm-Message-State: AOAM532a/0AAHaglLhiqCTpv8ODRDtMmmgqec0AqDGoMmJqpsQ3cW1k2
        qfie1ltumm+hIjf/vJg5gvE+jaiMDRyk7hATvgsaEuQQcdb8ky4p9vY5h1ONudnu4P5qzUys0rt
        Q4Pr3ucu8bOikt0159uxMmZl51hK7YTMUHFvzCrhJF8Z5EdVqBEnwcA==
X-Google-Smtp-Source: ABdhPJwUhua9LMW9p3aN5OcLK1vUqCl37G8usXaAuajX4fohNRT7ReYhpZWEfpi4r/sA+1HsbdxMS/EzXg==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:2d44:9018:fc46:57b])
 (user=morbo job=sendgmr) by 2002:a25:188b:: with SMTP id 133mr275663yby.80.1631133963471;
 Wed, 08 Sep 2021 13:46:03 -0700 (PDT)
Date:   Wed,  8 Sep 2021 13:45:40 -0700
In-Reply-To: <20210908204541.3632269-1-morbo@google.com>
Message-Id: <20210908204541.3632269-5-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com> <20210908204541.3632269-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v2 4/5] x86: umip: mark do_ring3 as noinline
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

do_ring3 uses inline asm that has labels. Clang decides that it can
inline this function, which causes the assembler to complain about
duplicate symbols. Mark the function as "noinline" to prevent this.

Signed-off-by: Bill Wendling <morbo@google.com>
---
v2: Use "noinline" instead of "__attribute__((noinline)).
---
 x86/umip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/umip.c b/x86/umip.c
index c5700b3..0fc1f65 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -114,7 +114,7 @@ static void test_umip_gp(const char *msg)
 
 /* The ugly mode switching code */
 
-static int do_ring3(void (*fn)(const char *), const char *arg)
+static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 {
     static unsigned char user_stack[4096];
     int ret;
-- 
2.33.0.309.g3052b89438-goog

