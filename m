Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D1848A164
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 22:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343767AbiAJVFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 16:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbiAJVFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 16:05:06 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7A8C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:05:06 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b11-20020a17090a6e0b00b001b34cd8941bso11180453pjk.1
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vBy+mErr/Ri6TNTRhXUfpamv23OXSo9DbZDSg0SsleA=;
        b=j4wxxxti3g07KeR5JHvFJjSWeBtiIqEnlJZMlLN+QAnslR8j6tBWxo5GU+hia2wTGw
         W4jmM4Uh7jDA0RFkEjTe29a6Xs+Im3R7Oeir+9fg4a5+fcwiPsflg7OKLwo/qOOfKE2g
         skORzCFyO2ZQiMpz5MIDa1Cvo7YG4v/3cVutqX1mm6lkfEQZTD0NSXrpDN145MyFPWhj
         MAf0jDXO36ivf9Dm/Hhz8vXmZ4A7ai5SiRUy52hLcycYaMgnorvd/x90eWjdPGjL4UlU
         Q1vCcaJMoMfzLf/JS/Co/U0KZcX4Dnt+zug3KcIOu++dR9VgtyZWhGIJqgFyhQznpNUx
         C2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vBy+mErr/Ri6TNTRhXUfpamv23OXSo9DbZDSg0SsleA=;
        b=ED7gCDzAn03GwGLpx3djYmWcR8uEPw1039L5Ziffj+NH9d0fytB74t9vUQBoH0veXz
         91hZYBHVXq0rl2Klef+xC6srlsb3nQbt2QV5UFUU7ypVkPOO3z3uLpZTSAJEo3MQTXCs
         uunscngLJnJ2aiDY5NKO6UJSNqFtyqmc+f7M1iyom5nxGRNLKFOPH0nL0rDf0P6q2iKi
         3GF4ONAjfhyLObZQeLEGmswbVaTxkJnUHhCj+7dmWMjeILW8oLSsmBVySpkpYnh1J+da
         SIVa3jG+3BYRw2hB0gsu2SZ59vbqtYWBDPMEcZ12D7OKGkZUfM0arMchkFjW7O+bGNep
         FbNg==
X-Gm-Message-State: AOAM532xWc3NnwTbhioMTJly5Y9ubdUGnfRimO3J/uCFgE7VFYdz23YB
        x82QD02GYMv3LdnohHjq14Gp73iWyv1tAo0S6BZerREpMApOC6UQ9ezDkjQOTv98mU5iGn9MypO
        s2xKW6jOyUIuYFPHPntlMQ2ZRO+94MQqeQd0UONvxEdGDZdhN1/m3ZGA17VzQ3Uo+nYLSJ88=
X-Google-Smtp-Source: ABdhPJyA6eTvWUsrJk2S/OyaiGDE/FsFt0ITd8LARBlVorREgJZxAx6nOm6HJvMjiBTPntB3YG6byKs1bXRAzVy7wA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:1819:b0:4ba:eaa6:d1b8 with
 SMTP id y25-20020a056a00181900b004baeaa6d1b8mr1349363pfa.78.1641848705619;
 Mon, 10 Jan 2022 13:05:05 -0800 (PST)
Date:   Mon, 10 Jan 2022 21:04:41 +0000
In-Reply-To: <20220110210441.2074798-1-jingzhangos@google.com>
Message-Id: <20220110210441.2074798-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for dirty log
 perf test for ARM
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For ARM64, if no vgic is setup before the dirty log perf test, the
userspace irqchip would be used, which would affect the dirty log perf
test result.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1954b964d1cf..b501338d9430 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -18,6 +18,12 @@
 #include "test_util.h"
 #include "perf_test_util.h"
 #include "guest_modes.h"
+#ifdef __aarch64__
+#include "aarch64/vgic.h"
+
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
+#endif
 
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
@@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_enable_cap(vm, &cap);
 	}
 
+#ifdef __aarch64__
+	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+#endif
+
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
-- 
2.34.1.575.g55b058a8bb-goog

