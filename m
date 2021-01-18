Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ECE2F9A0E
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732765AbhARGlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:41:17 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:34197 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732718AbhARGkq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:40:46 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 460DE16B6;
        Mon, 18 Jan 2021 01:39:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 01:39:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=xp8rMS5fYi67I
        zBTztXoRRHYHPvcz6CsxRtqujbiTX8=; b=XRkZhcuwfbvDW9WPlzqGCkZpgCxXo
        Ya7cEM0p3uGKSWcWUe+lpfY7E4j+t/Ip4ts+Vih9+Ym7V8pJqU98FfCIFgjwa9xw
        /kQkhEbnpjj8tZ1wEyDmMAUzee3T0T6YdySmQssumueg5MBII6fH5SmW9tRNRda/
        h3wVxdVY695O7rP7RH6pOu6ap+GFtgOX5HzIfzJKFD5T1H3s+XeAVMRK6EWlgaT3
        nA5rGqLC2Kjg7K9Gn7j0sGzTpJOzBP0mFoXsrFfa0J/23I2eUliBRFa+NmbdThdj
        IYyH5VijUXyYrSauFE3v1Taw3XegnyZFKOGStJRBK/kuOKxhYxGfvgGQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=xp8rMS5fYi67IzBTztXoRRHYHPvcz6CsxRtqujbiTX8=; b=GJpW6OMA
        OhUqFDRpb15U6GX0ZPNwReD2/b3m4gaptaPIBWUCXpVoAEAMAFtgcsDt7qK7VAIV
        96IC7lAbGXh7ZcXAhxHKMvCH+EBJuTbV4CUvPj/4EshTdh5zYWx+F1yxqk18bIUQ
        nFj2mYcGEAfsi6FUriEhRw2WtqM/chpKmrFGM6/3NcZM2LOcDKB0jYd1+nJaFash
        cgvVC50ZDUcWHCRYm0oEVlPEUU/TSgyCvywHJkEqVaQcJqk193QnlVCl47Jrbd6q
        Gb369STdGyYzopKxavO1oWh9BXGh4rbro6sebIX/2vj0qABh7hyxyr9wcItTmiUh
        wLDoWim57UP5tg==
X-ME-Sender: <xms:Fi0FYK79gFPV_Y-8OLeI4LB_mcQRAjI3uNTBVm1Kmq6pcSsPRoremQ>
    <xme:Fi0FYD5zNHo8oAuacHYEtimpGnrFYKcuomvbRGBrCtwKVIUZhXcuZ93rnPsJqzieT
    23DP3gKXrdvW4jdFqM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucfkphepudduiedrvddvkedrkeegrddvnecuvehluhhsthgvrhfuihiivg
    epfeenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihg
    ohgrthdrtghomh
X-ME-Proxy: <xmx:Fi0FYJcdZyCEaydEtjSY3UhyuZY6ZBagLJ6Gz9A4TpYjeAZoYVrt-A>
    <xmx:Fi0FYHKvlO5Ac5pdlI7kgZfcdNmZokVr4cAYlv2yBLntqurgb0I6EQ>
    <xmx:Fi0FYOLjSgBNXJM1ArpoH4VhuBugq81wAHryRyCbA0tPbmICtenGfQ>
    <xmx:Fi0FYD66NSDWoMTHgOES0DwHlT44gIuHwL_d5y5t3oVo4cTMZu5YxaUcAGtdgu8w>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id EE8D9240062;
        Mon, 18 Jan 2021 01:39:11 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
Date:   Mon, 18 Jan 2021 14:38:08 +0800
Message-Id: <20210118063808.12471-10-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
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
index 910754a699..90fac85ce4 100644
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
index 4532f1718a..6cc922aedb 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -72,6 +72,29 @@ include:
     - cd build
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
2.30.0

