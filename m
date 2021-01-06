Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E893B2EC33C
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 19:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbhAFSaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 13:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbhAFSaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 13:30:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20D4C06134C
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 10:29:23 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b131so5512788ybc.3
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 10:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=vqdOFJEXH8f+fWCwR3dVWB92iRCynRAkA1NtJxXRz/A=;
        b=YLTV+pfKZtX4PnvgyYfIm7AKkd+zJg6rQm0hn3UsJKVjIVUqVkobDIO4IiP3t3uAD3
         kZncdvXLNjVrvLkj9sin8sPSyAzP3XzgergppzkoKUIlymdw1zHGmWNCrF7qFJJ33ut7
         PBma0K+U9lS/Q6lVYkJBpgFKEBHPoJBLFVJsptKWGFw7r3Arac0hlvZvA9jgUZC7lg+c
         quaw6kejs2qmJhrvGePvuta/IjVaKQd2Z5f5/9fFEWCj1Xusvp+aVQkty6wC1f2iWUfB
         OMMbyazcLEzq6hHKPTYdBmdbQC7ImUf6URxaNyjNguX5oNwrzx1b6sJdB8ZFZ7hOdMnO
         gUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=vqdOFJEXH8f+fWCwR3dVWB92iRCynRAkA1NtJxXRz/A=;
        b=KTxn9AJbvgCH+3AEhJflwYCq36+6/WVWE2tN02/d+rhT7QSk2Q5/s2nNyJMGJUMjmG
         42cUbN8/o9GyTgjpKw35jjb4+XTvtfsooWoTI/asOZrknOkHM1jF0EtqHdkkHV17s2Mx
         A8OPtY272pWuCrnRcOIDnuoO9KuwB6kHfwnzO/49A5j4S/CCA+fTAi8o8ZE+IMphjo9d
         RYNSQ02sVtnqbR2QiwKnTVy1oXxHiNIxRZl8kS8gy+VUXm93OkMQCMkrz6jE6xNAT75j
         ygLkD/jFYXnYFLOF1zi0h9hiIc9v//DT5Jo11zN+SWbhkSAeIYxBPgdxkA7XPONgMKvm
         ehGw==
X-Gm-Message-State: AOAM530Jx/79NnS5m89CBSseFG4FK2xnqXX+ZaEv9uPmxaz8sxMgVYW9
        ER5OWQgTJ5VflC7Vt0zd7jHjMgzi4K8=
X-Google-Smtp-Source: ABdhPJy5Nk7Cr77AbZRfg3A9DCxnmvwiVFW2DlCrmtDO9UTWOO6MrKn3bHVaX4hQ2C/j3ZhAmWVRREMR2ac=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:6981:: with SMTP id e123mr8170015ybc.194.1609957763232;
 Wed, 06 Jan 2021 10:29:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  6 Jan 2021 10:29:16 -0800
Message-Id: <20210106182916.331743-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH] MAINTAINERS: Really update email address for Sean Christopherson
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use my @google.com address in MAINTAINERS, somehow only the .mailmap
entry was added when the original update patch was applied.

Fixes: c2b1209d852f ("MAINTAINERS: Update email address for Sean Christopherson")
Cc: kvm@vger.kernel.org
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c1e45c416b1..9201e6147cba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9776,7 +9776,7 @@ F:	tools/testing/selftests/kvm/s390x/
 
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
 M:	Paolo Bonzini <pbonzini@redhat.com>
-R:	Sean Christopherson <sean.j.christopherson@intel.com>
+R:	Sean Christopherson <seanjc@google.com>
 R:	Vitaly Kuznetsov <vkuznets@redhat.com>
 R:	Wanpeng Li <wanpengli@tencent.com>
 R:	Jim Mattson <jmattson@google.com>
-- 
2.29.2.729.g45daf8777d-goog

