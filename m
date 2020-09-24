Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C041276E29
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 12:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgIXKHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 06:07:03 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39036 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726597AbgIXKHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 06:07:03 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id CE57D57548;
        Thu, 24 Sep 2020 10:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1600942019; x=
        1602756420; bh=/H24eg0W8XTSkggmDnsMYMgefXEpcnRtF6/CGrEiMSo=; b=H
        pxAAJA63LjgPpMl2YKLLIApAo0z97+xbOIzmJ0rVR5Z6eB0rpVxJin7KofbHXkjG
        tRfOSjNxV0lbJ5YT8l3i9AIIuMNkBfnLCisn3V3135h6h3KbeU+rbXuX1rSWqdf4
        MQ/J+8T4xjA2rkm7xLw8zrI+Mh9KR9DSvq8Zh3TX7A=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id T-TfLxkxJUWu; Thu, 24 Sep 2020 13:06:59 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BFD3A57D54;
        Thu, 24 Sep 2020 13:06:59 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 24
 Sep 2020 13:06:59 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH] README: Reflect missing --getopt in configure
Date:   Thu, 24 Sep 2020 13:06:14 +0300
Message-ID: <20200924100613.71136-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

83760814f637 ("configure: Check for new-enough getopt") has replaced
proposed patch and doesn't introduce --getopt option in configure.
Instead, `configure` and `run_tests.sh` expect proper getopt to be
available in PATH.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 README.macOS.md | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/README.macOS.md b/README.macOS.md
index 4ca5a57..62b00be 100644
--- a/README.macOS.md
+++ b/README.macOS.md
@@ -22,10 +22,14 @@ $ brew install i686-elf-gcc
 $ brew install x86_64-elf-gcc
 ```
 
-32-bit x86 tests can be built like that:
+Make enhanced getopt available in the current shell session:
+```
+export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
+```
+
+Then, 32-bit x86 tests can be built like that:
 ```
 $ ./configure \
-  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
   --arch=i386 \
   --cross-prefix=i686-elf-
 $ make -j $(nproc)
@@ -34,7 +38,6 @@ $ make -j $(nproc)
 64-bit x86 tests can be built likewise:
 ```
 $ ./configure \
-  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
   --arch=x86_64 \
   --cross-prefix=x86_64-elf-
 $ make -j $(nproc)
@@ -71,7 +74,6 @@ $ ct-ng -C $X_BUILD_DIR build CT_PREFIX=$X_INSTALL_DIR
 Once compiled, the cross-compiler can be used to build the tests:
 ```
 $ ./configure \
-  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
   --arch=x86_64 \
   --cross-prefix=$X_INSTALL_DIR/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-
 $ make -j $(nproc)
-- 
2.28.0

