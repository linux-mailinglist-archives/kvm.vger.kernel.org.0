Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FE465D591
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 15:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbjADO0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 09:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbjADO0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 09:26:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A6D38AE7
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 06:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672842316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gvXV2IR1Sr0Ci455aooJpTBwTLA+Cuy/i0GBxDOoVEU=;
        b=Sd30uhOEOI3dzTVUtJuQ9bOSU3FKU/W4Zle8keMe8b0Wq7mbhZk1VULnbsaQlO3BwH0jYj
        iHtO/rIjRP2hS5LYEZmXrIa5TLh2AIAqVnLx+ivtJ1jkymxEno6rszNm+iGp0ZPIV3whph
        qHYXJJLGq86W7Mh7IvzX5tIcbZdftN8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-7QCjySavNeeYxUyqk412Rw-1; Wed, 04 Jan 2023 09:25:15 -0500
X-MC-Unique: 7QCjySavNeeYxUyqk412Rw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF95D811E9C;
        Wed,  4 Jan 2023 14:25:14 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF2F6492D8B;
        Wed,  4 Jan 2023 14:25:13 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH] ci/cirrus-ci-macos: Update to the latest macOS version
Date:   Wed,  4 Jan 2023 15:25:11 +0100
Message-Id: <20230104142511.297077-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The big-sur-base image has been decomissioned by Cirrus-CI, so
we have to update to a newer version of macOS now.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 ci/cirrus-ci-macos-i386.yml   | 4 ++--
 ci/cirrus-ci-macos-x86-64.yml | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/ci/cirrus-ci-macos-i386.yml b/ci/cirrus-ci-macos-i386.yml
index ef0861e0..ed580e61 100644
--- a/ci/cirrus-ci-macos-i386.yml
+++ b/ci/cirrus-ci-macos-i386.yml
@@ -1,7 +1,7 @@
 
 macos_i386_task:
   osx_instance:
-    image: big-sur-base
+    image: ghcr.io/cirruslabs/macos-ventura-base:latest
   install_script:
     - brew update
     - brew install coreutils bash git gnu-getopt make qemu i686-elf-gcc
@@ -10,7 +10,7 @@ macos_i386_task:
     - git fetch origin "@CI_COMMIT_REF_NAME@"
     - git reset --hard "@CI_COMMIT_SHA@"
   script:
-    - export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
+    - export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
     - mkdir build
     - cd build
     - ../configure --arch=i386 --cross-prefix=i686-elf-
diff --git a/ci/cirrus-ci-macos-x86-64.yml b/ci/cirrus-ci-macos-x86-64.yml
index 676646fe..861caa16 100644
--- a/ci/cirrus-ci-macos-x86-64.yml
+++ b/ci/cirrus-ci-macos-x86-64.yml
@@ -1,7 +1,7 @@
 
 macos_task:
   osx_instance:
-    image: big-sur-base
+    image: ghcr.io/cirruslabs/macos-ventura-base:latest
   install_script:
     - brew update
     - brew install coreutils bash git gnu-getopt make qemu x86_64-elf-gcc
@@ -10,10 +10,10 @@ macos_task:
     - git fetch origin "@CI_COMMIT_REF_NAME@"
     - git reset --hard "@CI_COMMIT_SHA@"
   script:
-    - export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
+    - export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
     - mkdir build
     - cd build
-    - ../configure --cross-prefix=x86_64-elf-
+    - ../configure --arch=x86_64 --cross-prefix=x86_64-elf-
     - gmake -j$(sysctl -n hw.ncpu)
     - ACCEL=tcg ./run_tests.sh
          eventinj
-- 
2.31.1

