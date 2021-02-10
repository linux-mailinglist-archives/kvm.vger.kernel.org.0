Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC603173EA
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhBJXHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbhBJXHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:07:15 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9E1C061756
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:35 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i2so4266935ybl.16
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9BlnMuser/5aLl05HhZkUCOrJicW6mziHT+6ZDrlT3k=;
        b=uD1oQi/XgHbJocPshzs4uxf+8sEIkro4p5Pt6vXNMqYLjlqe7BKcGvmCkZmmxD9Q4T
         wXBY79Rz46BuMW3PGaUq8FwjrtCi1c/qtKrzgyDyLcqiIq0emOGRzByh+8xIpA30AyO1
         UqAqut7h1XH1rAxFoS1xiNPsCEY/ehI2LbXTJsp0h/WscqbgmrvJdn8ZTQsZ8Q32sSLP
         fgRPATFHbio9RIPXxyyTS7V1Amf9fWGKySQhYk3dERXY4eqiRLIsVowri/OR/Rjo8nM7
         1AFetEyynXOUZRMLhbm6oWjwgBURqLMxlQWlAGGWXy2Uk7VNnjh66h1TAdLSMg54Tuj7
         R1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9BlnMuser/5aLl05HhZkUCOrJicW6mziHT+6ZDrlT3k=;
        b=LkpyYE2SPO4zqB6JltzYm6/QmyUFUpNMujWNn0bsb9oUpnLD+TLCodigelOUK24+uM
         giWFcARdVWDPQ+8pTUwvpispDHN/Vbf2TS+ctMCGEjxz0OoIms4LRF2o9Csr24ovbt29
         X2tuh0LzQ++XhHYWJ6l4Jj7F/W0wbS56ZJTW11O08FDG0ePSVW9oIPGETsgM5tk/ayv1
         HX7WjiHI0wH6GZXaEb8u/x773cFuF45QpDO48fSHiv3YGZ+3u0qnPn6zIvNKNEabVt5y
         XV/7fMNTMAK0W2uTMfG02V/ABTszwCJ12SkwVi9YzFm8XKHeuZc4EMe6dTkuaLY1uT7r
         DCug==
X-Gm-Message-State: AOAM530kp43vGaGe0FnDjvdTnk92bs67YmQASblwkerDjuUwVr5uCDod
        QVMQ3b9QHPASZCDLQ27YoK740L4uGVc=
X-Google-Smtp-Source: ABdhPJxQOWTkw0mcemLh5AcZugeeMfQsDqf22jm4kKkdIWXdcBz97VorZWgpRmsZhYmDZnv2WNF+2VGsBzU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:4fc3:: with SMTP id d186mr6925674ybb.343.1612998394331;
 Wed, 10 Feb 2021 15:06:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:11 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 01/15] KVM: selftests: Explicitly state indicies for
 vm_guest_mode_params array
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly state the indices when populating vm_guest_mode_params to
make it marginally easier to visualize what's going on.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d787cb802b4a..960f4c5129ff 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -154,13 +154,13 @@ _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
 	       "Missing new mode strings?");
 
 const struct vm_guest_mode_params vm_guest_mode_params[] = {
-	{ 52, 48,  0x1000, 12 },
-	{ 52, 48, 0x10000, 16 },
-	{ 48, 48,  0x1000, 12 },
-	{ 48, 48, 0x10000, 16 },
-	{ 40, 48,  0x1000, 12 },
-	{ 40, 48, 0x10000, 16 },
-	{  0,  0,  0x1000, 12 },
+	[VM_MODE_P52V48_4K]	= { 52, 48,  0x1000, 12 },
+	[VM_MODE_P52V48_64K]	= { 52, 48, 0x10000, 16 },
+	[VM_MODE_P48V48_4K]	= { 48, 48,  0x1000, 12 },
+	[VM_MODE_P48V48_64K]	= { 48, 48, 0x10000, 16 },
+	[VM_MODE_P40V48_4K]	= { 40, 48,  0x1000, 12 },
+	[VM_MODE_P40V48_64K]	= { 40, 48, 0x10000, 16 },
+	[VM_MODE_PXXV48_4K]	= {  0,  0,  0x1000, 12 },
 };
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
-- 
2.30.0.478.g8a0d178c01-goog

