Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7872DF757
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 01:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgLUA4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 19:56:04 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39123 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbgLUA4D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Dec 2020 19:56:03 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id AA626580429;
        Sun, 20 Dec 2020 19:54:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 20 Dec 2020 19:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=CPk8hWNwTbOuu
        sALCr78eQxjcJr/MxCKc2iZwwjx04g=; b=kjNEuFBxoCZ14wpAhm9PPqL6qGQ8m
        cl2ej1uLe1AOMw/ETGg5RQP+0HesOg+hGA+kyrejc89AncDLoXodmI85586D7M9B
        FV8qQLiZgPspd+3edIYxEg54hURZoHl65Z1eypBbOJwUp85l+qKKPOigy1p4Lgev
        gVqvMEiIc3bt/CnlckiEa/e0i6u7ImdllmffthcDJHyRtrP9dQpETUtfDuV11mPP
        fNVDzOsUR7ModJcUjZ/dYxh4kJmmJIpyY/do0mnWIDfCzZPPsDoNtmUJU+brhsvF
        geWVrZ8h4LoC71NY3NpniUjfqNg5yfhNDMhXmN1C/YGTTg0rnMoKHBktQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=CPk8hWNwTbOuusALCr78eQxjcJr/MxCKc2iZwwjx04g=; b=nkAVKFa/
        nyGYNo7uVY0BqhDYRoAeWeQ3otG3WVBf4idd5vJnInv2/7IoazFwgVxIejP8T9XD
        r+ynH3hT1jyRYyfCu+elV+E/fR0HuSIXe+RNVtMDjSjjmU7e3teOheAlN2zQMilG
        swC+nihDzxJvxZe3nt2+8htbImV3T6pjX2ITU0ns9byO7bS3/m0rYC4pXieiwJCf
        XLn+0TybYEjC5/GaalGyvnxn7tV7tIJh1BeTd0+DzzmuM2Sjx1vd27mDHPEIL/mC
        DlKtw4Hi0IQPuTRYLD282e+K554HM62aliE38dqL//nvqYHMOZ9CFJ96t5qJ2Ass
        3NQAJOGhMVbpqg==
X-ME-Sender: <xms:YfLfX3C95g_2FZV3S6zyDLQR6dLh_WrlaKNnzcSAjPGsTwECS4_qtQ>
    <xme:YfLfX9hkpx76NpTneCKco9e5yE9eD7_QTEiJHR7i8t5vTD2eQfYB-WUhR4D0i57J7
    y5E7PhZdoHt8SHezF8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtuddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepjeeihffgteelkeelffdukedtheevudejvdegkeekjeefhffhhfet
    udetgfdtffeunecukfhppeeghedrfeefrdehtddrvdehgeenucevlhhushhtvghrufhiii
    gvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhih
    ghhorghtrdgtohhm
X-ME-Proxy: <xmx:YfLfXylYYLBXP5Nr2Jdtmnc2naDy0-nL76fD9fXgSMu98MK1cM4z6Q>
    <xmx:YfLfX5zL6cBGHIJyMju8B0YhcNWCZd82Gs5Kb0P4fClxltYRlMbs5Q>
    <xmx:YfLfX8SdjWjvgLaiMe4EOHyny1sUSqGahO5Xuv2KZCYaq0uv72i2Ng>
    <xmx:YfLfX4oLYgqzmYsLZkJsTIKYW3oSpxb5zGq0_dDTzqgcX0Nul3x-xIa9tR0QeH54>
Received: from strike.U-LINK.com (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7DBB224005A;
        Sun, 20 Dec 2020 19:54:49 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Alistair Francis <alistair@alistair23.me>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org
Subject: [PATCH 9/9] gitlab-ci: Add alpine to pipeline
Date:   Mon, 21 Dec 2020 08:53:18 +0800
Message-Id: <20201221005318.11866-10-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We only run build test and check-acceptance as their are too many
failures in checks due to minor string mismatch.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 .gitlab-ci.d/containers.yml |  5 +++++
 .gitlab-ci.yml              | 23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/.gitlab-ci.d/containers.yml b/.gitlab-ci.d/containers.yml
index 892ca8d838..cc4390911d 100644
--- a/.gitlab-ci.d/containers.yml
+++ b/.gitlab-ci.d/containers.yml
@@ -28,6 +28,11 @@
     - if: '$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH'
     - if: '$CI_COMMIT_REF_NAME == "testing/next"'
 
+amd64-alpine-container:
+  <<: *container_job_definition
+  variables:
+    NAME: alpine
+
 amd64-centos7-container:
   <<: *container_job_definition
   variables:
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 98bff03b47..4794fa6289 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -67,6 +67,29 @@ include:
     - python3 -c 'import json; r = json.load(open("tests/results/latest/results.json")); [print(t["logfile"]) for t in r["tests"] if t["status"] not in ("PASS", "SKIP", "CANCEL")]' | xargs cat
     - du -chs ${CI_PROJECT_DIR}/avocado-cache
 
+build-system-alpine:
+  <<: *native_build_job_definition
+  variables:
+    IMAGE: alpine
+    TARGETS: aarch64-softmmu alpha-softmmu cris-softmmu hppa-softmmu
+      moxie-softmmu microblazeel-softmmu mips64el-softmmu
+    MAKE_CHECK_ARGS: check-build
+    CONFIGURE_ARGS: --enable-docs
+  artifacts:
+    expire_in: 2 days
+    paths:
+      - build
+
+acceptance-system-alpine:
+  <<: *native_test_job_definition
+  needs:
+    - job: build-system-alpine
+      artifacts: true
+  variables:
+    IMAGE: alpine
+    MAKE_CHECK_ARGS: check-acceptance
+  <<: *acceptance_definition
+
 build-system-ubuntu:
   <<: *native_build_job_definition
   variables:
-- 
2.29.2

