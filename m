Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1303A4944DA
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiATAid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiATAi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:38:29 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F85C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:38:29 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t18-20020a63dd12000000b00342725203b5so2618410pgg.16
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JcxsUGoLkTPVyhoQhkOKqpMUlYmQwaBH44AN1S2xDuM=;
        b=Ivmu9MriEiRe73VhNf3gzE9uP/5oTFFK1I/hgi3SRrWWgMp8gZgjfoArPF5zFeI8Kv
         CIEf950Xks8/0aFRtGz5QdCHtSa+UC5jgDtiqDymJNZNOLDY23srEHUs77VkXWSCmhEF
         q+xxyAxPW8KZvsPQP/DA1e0aOWg+M+nIVJpSBoTrZ9wAECUGiERd0RMNuN2ekGq5jjel
         mF40r0dJStJpotHjBwBLWhGk5NkFzpm9rIYf+mBKTuqiOKaJ+yatSCvCZdu+bjpAZHxu
         6GA42H2zTPQ+wOc5FihpyKfH28x/Yzqvj8YsHdSjVSNOEUUwxmFPFXa84cLCnEjdZqI1
         KsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JcxsUGoLkTPVyhoQhkOKqpMUlYmQwaBH44AN1S2xDuM=;
        b=8MOO4Jznin4mVFn92XYMNwWJ1qDV3ca0Pqf8/XjTmT061BLAGyKfiLuN4HQ3hOBryx
         R+PJK7Vpw0quI+V/jIuA4Aw+QtigxuI7SKHbYjwvWPCSt5w82hWb/+fv9/bq/nHWdSnj
         aGtjQ835h2bfAahCn047UXUptOMzP9+H6PM6SpPMHU5MQxUM2/68DzVXutn0eibj9YyQ
         DPiGBCHRQ/ss8WceZ7eX2p1cRLxHWR+oeXSI4dp9eMrRWjucAeXIf207ApdG1+pfdcL8
         teVVTHxBLk+ulWbrIhKzWDVPJKgGoEfiyrWZOxo9GFCzHyZjSiordG/SsDoM8e2713cH
         xlig==
X-Gm-Message-State: AOAM531ZIiPshS81Q2gPkgjVndYjjrRUbQUW915v9bg0WKU/okyb5c3I
        q4v+wamkx+w4HzY5JoBcWdBN1k0cTK9XxQ==
X-Google-Smtp-Source: ABdhPJxwTcU+Q6B8TH8Nd2zy9K+oVMtijfHFgvpxgcvrkjB6D4ja4jkdlgOADxEXAHgWFR78rw6/AUgYq7OINg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:3f09:: with SMTP id
 l9mr7486278pjc.38.1642639108708; Wed, 19 Jan 2022 16:38:28 -0800 (PST)
Date:   Thu, 20 Jan 2022 00:38:26 +0000
Message-Id: <20220120003826.2805036-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] KVM: selftests: Re-enable access_tracking_perf_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This selftest was accidentally removed by commit 6a58150859fd
("selftest: KVM: Add intra host migration tests"). Add it back.

Fixes: 6a58150859fd ("selftest: KVM: Add intra host migration tests")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 81ebf99d6ff0..0e4926bc9a58 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -85,6 +85,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
+TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test

base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33
-- 
2.35.0.rc0.227.g00780c9af4-goog

