Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1F4562D2
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhKRSuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbhKRSt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:49:59 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA8AC061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:59 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so552893wmj.5
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eaPUXaq41WZH/h6GYRFaezaVsEA4ttJDyJAW7JSISJY=;
        b=F2gHMH6vwR4xvqpoXWpgXJXoDksN1UxSEkEmbqmlD8hyupOtNFO3mGg1RFg2TX62I0
         xaVKX0aL2NMGzFQ7eMYjleeolRXafF/TqwYxwneEasRcGVHXl9epK3WPRzqcTmi+iari
         8D1slSEtOH3Kcb+9lMZCC5DUr/4MEXsoYBE5MKGETfA15XQ6FsHrOCcgkCH8hu/Ar5LW
         w+aYUP1y+h/3dKHWBAedUL1pTKEzA2KvVoU2gHvciE3OMO5GFXa9/4ysbEzpyvaNQaO/
         BibROcRlDz9v5WAQZTmIZvB17dBLXL1BiGJytnG6W9zHQHW0EGbhak1/43tvnoirJFAe
         wCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eaPUXaq41WZH/h6GYRFaezaVsEA4ttJDyJAW7JSISJY=;
        b=2d3pyrbFPUhDHNI9Ih/UEjvOZl9i8GBhUuRiNfTXpBYBZ9Oa9oGs65A6EYr5p26XxA
         YEykhyk9+ftUXlNYXbhPqeaGvCqwmmhM/4sf2XXNACT4mYVNYAFqpIpnZySqSUZh1PoW
         Srt2Nk8Ntzchorl/mtVIUNSYi6UgKrrbLPrj3BAyAPwUtJLBCM4Crt8VsrUR96+1aDty
         SRCDoa40Kx760mRFckzlYEUoz4ZaxdvX/2vHrpyGLP/a9Sa5KRkLKtmRnCb8cpMhBRnt
         bddnGBfPNDoLJ3Gkosx1YE0L6FnBwxUUB2MiRmgKdV4ecV3QodZ+vNbAp5CNNHnpZeiB
         ATOA==
X-Gm-Message-State: AOAM531dkDSzFRYsW4GBLz27tlSpBRqExw02sixu4dLHpwN2T8CJL99b
        2xm1D0HZYLqcVdWBtmSM54SAgQ==
X-Google-Smtp-Source: ABdhPJxi0gHTPCkCLhwz4sZpESe0ZsiFVHaJxtTlU8ot0566wwXQutX6kiYchOOZ+lORo2U9U57Iog==
X-Received: by 2002:a1c:9a4f:: with SMTP id c76mr12329695wme.162.1637261217715;
        Thu, 18 Nov 2021 10:46:57 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id q26sm654555wrc.39.2021.11.18.10.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:46:54 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 583341FF9B;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config option for alt test set
Date:   Thu, 18 Nov 2021 18:46:44 +0000
Message-Id: <20211118184650.661575-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The upcoming MTTCG tests don't need to be run for normal KVM unit
tests so lets add the facility to have a custom set of tests.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 run_tests.sh | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 9f233c5..b1088d2 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -15,7 +15,7 @@ function usage()
 {
 cat <<EOF
 
-Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
+Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-c CONFIG]
 
     -h, --help      Output this help text
     -v, --verbose   Enables verbose mode
@@ -24,6 +24,7 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
     -g, --group     Only execute tests in the given group
     -j, --parallel  Execute tests in parallel
     -t, --tap13     Output test results in TAP format
+    -c, --config    Override default unittests.cfg
 
 Set the environment variable QEMU=/path/to/qemu-system-ARCH to
 specify the appropriate qemu binary for ARCH-run.
@@ -42,7 +43,7 @@ if [ $? -ne 4 ]; then
 fi
 
 only_tests=""
-args=$(getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*)
+args=$(getopt -u -o ag:htj:vc: -l all,group:,help,tap13,parallel:,verbose,config: -- $*)
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
@@ -73,6 +74,10 @@ while [ $# -gt 0 ]; do
         -t | --tap13)
             tap_output="yes"
             ;;
+        -c | --config)
+            shift
+            config=$1
+            ;;
         --)
             ;;
         *)
@@ -152,7 +157,7 @@ function run_task()
 
 : ${unittest_log_dir:=logs}
 : ${unittest_run_queues:=1}
-config=$TEST_DIR/unittests.cfg
+: ${config:=$TEST_DIR/unittests.cfg}
 
 rm -rf $unittest_log_dir.old
 [ -d $unittest_log_dir ] && mv $unittest_log_dir $unittest_log_dir.old
-- 
2.30.2

