Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A751B3CB37B
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 09:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhGPHtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 03:49:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236765AbhGPHtQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 03:49:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626421582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pjmFcds/WV8dhcYGpd0lRbK9Jq1LDuZxIF1yKejxoxk=;
        b=NYGaNyIH7kUdhxWiVvC+Wb60BLh5aLtwGls9E2GN6CYcUqdlCPLE5swrXCmVYcZzO2+la4
        /DY07gbnDlXDhTT+XmY6rJVyjdn9UFvXvPuFbuYcPXJ2PyH+oOTGaEs0YdlWQY2fQ69pc2
        uTnqj6wvMCjFAlkwMzsMKR5Km44Yu7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-GJjTJkMrPlmJehhbE42pnA-1; Fri, 16 Jul 2021 03:46:20 -0400
X-MC-Unique: GJjTJkMrPlmJehhbE42pnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EED9804142
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 07:46:19 +0000 (UTC)
Received: from thuth.com (ovpn-112-45.ams2.redhat.com [10.36.112.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 885EF5C1A1;
        Fri, 16 Jul 2021 07:46:18 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH] ci: Update the macOS CI jobs to Big Sur
Date:   Fri, 16 Jul 2021 09:46:16 +0200
Message-Id: <20210716074616.1176282-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Homebrew stopped working for the Catalina-based images. After updating
to Big Sur and adding an explicit "brew update", the pipelines go green
again.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 ci/cirrus-ci-macos-i386.yml   | 3 ++-
 ci/cirrus-ci-macos-x86-64.yml | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/ci/cirrus-ci-macos-i386.yml b/ci/cirrus-ci-macos-i386.yml
index b837101..ef0861e 100644
--- a/ci/cirrus-ci-macos-i386.yml
+++ b/ci/cirrus-ci-macos-i386.yml
@@ -1,8 +1,9 @@
 
 macos_i386_task:
   osx_instance:
-    image: catalina-base
+    image: big-sur-base
   install_script:
+    - brew update
     - brew install coreutils bash git gnu-getopt make qemu i686-elf-gcc
   clone_script:
     - git clone --depth 100 "@CI_REPOSITORY_URL@" .
diff --git a/ci/cirrus-ci-macos-x86-64.yml b/ci/cirrus-ci-macos-x86-64.yml
index f72c8e1..676646f 100644
--- a/ci/cirrus-ci-macos-x86-64.yml
+++ b/ci/cirrus-ci-macos-x86-64.yml
@@ -1,8 +1,9 @@
 
 macos_task:
   osx_instance:
-    image: catalina-base
+    image: big-sur-base
   install_script:
+    - brew update
     - brew install coreutils bash git gnu-getopt make qemu x86_64-elf-gcc
   clone_script:
     - git clone --depth 100 "@CI_REPOSITORY_URL@" .
-- 
2.27.0

