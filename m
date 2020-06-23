Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8689B204D64
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbgFWJGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:06:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31046 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731921AbgFWJGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592903194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NFodWqskMtC/5PQ2GwuPpH+2hReee1VihIY8eKIqRQU=;
        b=cqVXgBlgosFUCtjYcJNO5iyObAlRtXeyepTiZ7e+r3aKU1WIpsJ87weP+aWr9vRh5nHqQx
        SAa3n+y0y7c3a8kWz7LMHCSJ27Fxg9qRH3iTo5BMPDuOMpgRyATciL2YoTRebuZLxQXWp+
        S36Nrdy+tHoyLGQO9OqfeNYgjxaEUuo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-uwLtroUHPGSPCrBybJSE9Q-1; Tue, 23 Jun 2020 05:06:32 -0400
X-MC-Unique: uwLtroUHPGSPCrBybJSE9Q-1
Received: by mail-wr1-f69.google.com with SMTP id y13so1388965wrp.13
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NFodWqskMtC/5PQ2GwuPpH+2hReee1VihIY8eKIqRQU=;
        b=KPHQNYwY3414r041f7FJ52VjJv6yf1qk46UYyc9csGrVebrnBTmFg1xP9Lcl0zUSAW
         E0ti8zL5Z5NXa1SNYZoIgD9zAG25fMvc8bVkrVJQ+V0WdnfMTd75fTFORNrpCFSj3luv
         NsPiqC0/dpuWXnHxtKMGRjFfPLgkfWdfdJ7K7gngky61j8malhtBOr/Oy0chqlRizncf
         zh2dTOY+gFQ5T1peAe49UodShgFoHBGmfug3Nx3MD1b2YLUhNUdHIaDygYjyyUukZOc7
         zdhwssm9ES1MtwppEigiJWfndWEz1hL4YXuuBysR9r93Mh8opvOCZjwjvAvkhZKUDwGH
         9WkA==
X-Gm-Message-State: AOAM530MvtYddu/r1mXnZD57Wp6WN+v3uzm0S57cQ+k8XIn54+/JOIni
        PSyD6f7Ce9pFrGTQqRun8u4KcQFhyq7SCumRcDsHsBEnBrDlcghuAQOeRIUsdLrmLJYoAurpsrm
        hkZAoqXfB5dLv
X-Received: by 2002:adf:fa81:: with SMTP id h1mr13967365wrr.266.1592903190739;
        Tue, 23 Jun 2020 02:06:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYp7EOW24aIihuYBSTeyCt0a8qu7PFtl2vjpx6/D5IDweqkFR4nJCyT8X1HMCfow4T+lhWtA==
X-Received: by 2002:adf:fa81:: with SMTP id h1mr13967350wrr.266.1592903190490;
        Tue, 23 Jun 2020 02:06:30 -0700 (PDT)
Received: from localhost.localdomain (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id g195sm2896048wme.38.2020.06.23.02.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 02:06:30 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v3 1/2] tests/qtest/arm-cpu-features: Add feature setting tests
Date:   Tue, 23 Jun 2020 11:06:21 +0200
Message-Id: <20200623090622.30365-2-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200623090622.30365-1-philmd@redhat.com>
References: <20200623090622.30365-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

Some cpu features may be enabled and disabled for all configurations
that support the feature. Let's test that.

A recent regression[*] inspired adding these tests.

[*] '-cpu host,pmu=on' caused a segfault

Signed-off-by: Andrew Jones <drjones@redhat.com>
Message-Id: <20200623082310.17577-1-drjones@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/qtest/arm-cpu-features.c | 38 ++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
index 4692173676..f7e062c189 100644
--- a/tests/qtest/arm-cpu-features.c
+++ b/tests/qtest/arm-cpu-features.c
@@ -159,16 +159,35 @@ static bool resp_get_feature(QDict *resp, const char *feature)
     qobject_unref(_resp);                                              \
 })
 
-#define assert_feature(qts, cpu_type, feature, expected_value)         \
+#define resp_assert_feature(resp, feature, expected_value)             \
 ({                                                                     \
-    QDict *_resp, *_props;                                             \
+    QDict *_props;                                                     \
                                                                        \
-    _resp = do_query_no_props(qts, cpu_type);                          \
     g_assert(_resp);                                                   \
     g_assert(resp_has_props(_resp));                                   \
     _props = resp_get_props(_resp);                                    \
     g_assert(qdict_get(_props, feature));                              \
     g_assert(qdict_get_bool(_props, feature) == (expected_value));     \
+})
+
+#define assert_feature(qts, cpu_type, feature, expected_value)         \
+({                                                                     \
+    QDict *_resp;                                                      \
+                                                                       \
+    _resp = do_query_no_props(qts, cpu_type);                          \
+    g_assert(_resp);                                                   \
+    resp_assert_feature(_resp, feature, expected_value);               \
+    qobject_unref(_resp);                                              \
+})
+
+#define assert_set_feature(qts, cpu_type, feature, value)              \
+({                                                                     \
+    const char *_fmt = (value) ? "{ %s: true }" : "{ %s: false }";     \
+    QDict *_resp;                                                      \
+                                                                       \
+    _resp = do_query(qts, cpu_type, _fmt, feature);                    \
+    g_assert(_resp);                                                   \
+    resp_assert_feature(_resp, feature, value);                        \
     qobject_unref(_resp);                                              \
 })
 
@@ -424,10 +443,14 @@ static void test_query_cpu_model_expansion(const void *data)
     assert_error(qts, "host", "The CPU type 'host' requires KVM", NULL);
 
     /* Test expected feature presence/absence for some cpu types */
-    assert_has_feature_enabled(qts, "max", "pmu");
     assert_has_feature_enabled(qts, "cortex-a15", "pmu");
     assert_has_not_feature(qts, "cortex-a15", "aarch64");
 
+    /* Enabling and disabling pmu should always work. */
+    assert_has_feature_enabled(qts, "max", "pmu");
+    assert_set_feature(qts, "max", "pmu", false);
+    assert_set_feature(qts, "max", "pmu", true);
+
     assert_has_not_feature(qts, "max", "kvm-no-adjvtime");
 
     if (g_str_equal(qtest_get_arch(), "aarch64")) {
@@ -464,7 +487,10 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
         return;
     }
 
+    /* Enabling and disabling kvm-no-adjvtime should always work. */
     assert_has_feature_disabled(qts, "host", "kvm-no-adjvtime");
+    assert_set_feature(qts, "host", "kvm-no-adjvtime", true);
+    assert_set_feature(qts, "host", "kvm-no-adjvtime", false);
 
     if (g_str_equal(qtest_get_arch(), "aarch64")) {
         bool kvm_supports_sve;
@@ -475,7 +501,11 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
         char *error;
 
         assert_has_feature_enabled(qts, "host", "aarch64");
+
+        /* Enabling and disabling pmu should always work. */
         assert_has_feature_enabled(qts, "host", "pmu");
+        assert_set_feature(qts, "host", "pmu", false);
+        assert_set_feature(qts, "host", "pmu", true);
 
         assert_error(qts, "cortex-a15",
             "We cannot guarantee the CPU type 'cortex-a15' works "
-- 
2.21.3

