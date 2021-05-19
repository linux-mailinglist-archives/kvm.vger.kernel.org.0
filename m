Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DDB38975E
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 22:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhESUFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 16:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbhESUFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 16:05:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F73C061763
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 13:03:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k34-20020a25b2a20000b02905149e86803eso4856575ybj.9
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 13:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NF76M7YPlPLnV5lZxvKeN+qihLtEQ8HfegihjKBXIf0=;
        b=XzHcxVIJslByFngY/1pqnI3iL00i/64SxucLflHWP2YaMPYrtFFt9CdnhJr5O5rcRX
         JkE/zZiBI8NntCkeEMeHVo8cgG9myQgPl6fMvz8XY1xTHqSenqRMj/a5GFiI+OmaUjav
         9rygBBWsmAcIej7/HQJA45cboxevZDIquzdNMUm7P4tMTP87xQWoq6+qRpNMsACmG0VR
         muxQ7KaVXoW4zWu4WDFuZbt9fDkEKovnvzUbJY4DTxfgYmWmQQkJVhGax2BegTxIehh5
         eUdAaH7r/TjF/yIKomjYM2ksxozHyP6yB4YGvrPrpkbGtiBWr5iQh8SALxzSY6cYUE/l
         Vcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NF76M7YPlPLnV5lZxvKeN+qihLtEQ8HfegihjKBXIf0=;
        b=OwhM1ewSVOYfYYOrIa825JMUEo6eDtBR8jEYNQuUUsUQRKFszC6pKsSDun8kMwfY/n
         Wv8lRKbecOjSv4Ny53j504YxLSZycArdSk87RTo1JCDQgw22l+kiboDO7MeMFT7vL97w
         DTzGsU2v51nCi6e7poir37OS7wl8Ed0JSkORvn1XiZ9Ug4dljWXXZFs340NlWNqfAwK3
         hkGhm27wrQ/ndZcJ01eqJjy8ZZJgXY+gm1RugxHXAVSBYn0N+wEdURJwW5bGr4fw0VaK
         F/PX9OGTWse2gQtzZntXyxUQKEp6MQbJDP0Cd8mIBlf0Y9DiqpzwzvcseAjz3Geny5sp
         fcag==
X-Gm-Message-State: AOAM533br9qoukQN228DxsEwQcvFdU5eK7YtpVZW36dWZAsrm0zBzk94
        9geYwifwnaYjawCYPFZkJbPzEMzbENgSJt6C4R4d
X-Google-Smtp-Source: ABdhPJx4J2Yqvr2CG0rRzjRd7777YBkS9k9JN7ZzFPPyeyKgAHRh7Yr2Khndm0Y7ApuG+etMuNop5MitgoUX4yoKcmSy
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2cd:203:7eb5:10bb:834a:d5ec])
 (user=axelrasmussen job=sendgmr) by 2002:a5b:489:: with SMTP id
 n9mr1859006ybp.45.1621454629266; Wed, 19 May 2021 13:03:49 -0700 (PDT)
Date:   Wed, 19 May 2021 13:03:30 -0700
In-Reply-To: <20210519200339.829146-1-axelrasmussen@google.com>
Message-Id: <20210519200339.829146-2-axelrasmussen@google.com>
Mime-Version: 1.0
References: <20210519200339.829146-1-axelrasmussen@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v2 01/10] KVM: selftests: trivial comment/logging fixes
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Gardon <bgardon@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some trivial fixes I found while touching related code in this series,
factored out into a separate commit for easier reviewing:

- s/gor/got/ and add a newline in demand_paging_test.c
- s/backing_src/src_type/ in a comment to be consistent with the real
  function signature in kvm_util.c

Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 5f7a229c3af1..9398ba6ef023 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -169,7 +169,7 @@ static void *uffd_handler_thread_fn(void *arg)
 		if (r == -1) {
 			if (errno == EAGAIN)
 				continue;
-			pr_info("Read of uffd gor errno %d", errno);
+			pr_info("Read of uffd got errno %d\n", errno);
 			return NULL;
 		}
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fc83f6c5902d..f05ca919cccb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -663,8 +663,8 @@ int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, vm_vaddr_t gva, size_t len)
  *
  * Input Args:
  *   vm - Virtual Machine
- *   backing_src - Storage source for this region.
- *                 NULL to use anonymous memory.
+ *   src_type - Storage source for this region.
+ *              NULL to use anonymous memory.
  *   guest_paddr - Starting guest physical address
  *   slot - KVM region slot
  *   npages - Number of physical pages
-- 
2.31.1.751.gd2f1c929bd-goog

