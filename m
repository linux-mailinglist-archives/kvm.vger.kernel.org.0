Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E058A389871
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 23:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhESVPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 17:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhESVPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 17:15:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B20C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:13:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e138-20020a25e7900000b029050df4b648fcso13569095ybh.7
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9zgsusKvSePHNG1VC88Yu9jdtYvuwZFYwDQPCcUfxGM=;
        b=Wij+Cym2JywhOF5P4KlcytawxO75fyUG6PlfBILblCCruJzbJiQ9DEdqHC8rLae/Jm
         y1Xn332z3aZjCCD8PNJ6pMUpKHpXoUvczqtznmQ1qrppqdJXIFEL6s7bKFL5AdJBny9y
         dF3drDqqf6VLkFp8f0HSFPpjzG4HQuim4AYsLgwYskHsi+HaViYnsWY2iUfeam2gDU4a
         lC3iCSPHNwmPb5RNjs859ig0mM1fEJRht5RBAz2ofVAygGtCJzDtt2FJaNcAeQR0lRm/
         NcsqcTC+wtDBFXjW2maqXKRAmBZhM6L3gJ6FVHj3TtCXhyrT0krnpJ1OA5R6rJ0EnJwH
         RHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9zgsusKvSePHNG1VC88Yu9jdtYvuwZFYwDQPCcUfxGM=;
        b=hoYJTicPuPgoA/x9Hd5XccqJiGcLWWK3re4ee+SmlEHdqqgKmfClbZQkDvawK8gp2B
         OceBuVtfW9qQlbxxlG6GcpSSY9ij90BbS6HxDkMaGzhZ/L+NcIwinSMaGB7I4qvBRM8F
         LYGI/xnd67k8KaPAkS/Nm3FFlu8v5F/x7ujrgFBfRY3A/mYbyxgfRFLbHZC0O9/mqThs
         0mgSlvnTB6KAOQ3UeQHsffN+Kj/GY59u7NkLwa51EiqrdFI5TE9hQ3ewg0i7RUY6pY0f
         ByYMJgC/SxRxNjDhuYYrWnug+VuwKvTroIBPuJ5GAisN8tbBg/4E+TLHwMSQefe24mHs
         HBxg==
X-Gm-Message-State: AOAM531JeBuc9bEDSCCXnRIYjz8bwxga53aQnVkoVo9HBeh0nB0wKg4L
        VIWP6mMcbAPnsqcfcTdoLzeva52KIfNBtP5ls+kmlJnizezkOZCD2krIuQRevcRGGvxqoICIcWF
        GhBzPCbM5YdHQ391XcccFQqvYK0pfhIMsHpYrfcDvq3Z+S432kTHdGIUACEeNbq4=
X-Google-Smtp-Source: ABdhPJzKSmwQmziFclXp/2+5c1bbbHHTxmJKMCZYFmVEW/cC8li5VL6OsIqM9oeXGV/OXnnqnlTvF/0Jo30o6Q==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:8b08:: with SMTP id
 i8mr2132249ybl.370.1621458829881; Wed, 19 May 2021 14:13:49 -0700 (PDT)
Date:   Wed, 19 May 2021 21:13:45 +0000
Message-Id: <20210519211345.3944063-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH] KVM: selftests: Ignore CPUID.0DH.1H in get_cpuid_test
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to CPUID.0DH.0H this entry depends on the vCPU's XCR0 register
and IA32_XSS MSR. Since this test does not control for either before
assigning the vCPU's CPUID, these entries will not necessarily match
the supported CPUID exposed by KVM.

This fixes get_cpuid_test on Cascade Lake CPUs.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/x86_64/get_cpuid_test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
index 9b78e8889638..8c77537af5a1 100644
--- a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
@@ -19,7 +19,12 @@ struct {
 	u32 function;
 	u32 index;
 } mangled_cpuids[] = {
+	/*
+	 * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR,
+	 * which are not controlled for by this test.
+	 */
 	{.function = 0xd, .index = 0},
+	{.function = 0xd, .index = 1},
 };
 
 static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
-- 
2.31.1.751.gd2f1c929bd-goog

