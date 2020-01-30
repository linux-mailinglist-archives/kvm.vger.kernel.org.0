Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9146314DF34
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgA3Qdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:33:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20952 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727378AbgA3Qdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 11:33:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580402015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tl+Yh/nsfcb/XxIVsapr7K9sgBQAjDanHTGoCcXw5jc=;
        b=PZIeBcMNPXjm2sl3hGtwIp1FO2njKvtsBDAxOpyadOJuS44f3FEXSCXPot7sXR0IMTxtUp
        zKzwqI4rzhF0D/S/7U2Ql3okCJ/A61XKF2xBb0eO7Yniy5OruY5uldoplnPDpYS2z9ePBh
        RzY91CSeggb5ADtallq+G1PPr9k83Ls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-Grbo7aG9OYCjo1HDnDT5hA-1; Thu, 30 Jan 2020 11:33:30 -0500
X-MC-Unique: Grbo7aG9OYCjo1HDnDT5hA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B2F018CA246;
        Thu, 30 Jan 2020 16:33:29 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 072E35E241;
        Thu, 30 Jan 2020 16:33:16 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Max Reitz <mreitz@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH v2 04/12] tests: Explicit usage of Python 3
Date:   Thu, 30 Jan 2020 17:32:24 +0100
Message-Id: <20200130163232.10446-5-philmd@redhat.com>
In-Reply-To: <20200130163232.10446-1-philmd@redhat.com>
References: <20200130163232.10446-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the program search path to find the Python 3 interpreter.

Patch created mechanically by running:

  $ sed -i "s,^#\!/usr/bin/\(env\ \)\?python$,#\!/usr/bin/env python3," \
       $(git grep -l 'if __name__.*__main__')

Reported-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Suggested-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 tests/docker/travis.py         | 2 +-
 tests/qapi-schema/test-qapi.py | 2 +-
 tests/vm/centos                | 2 +-
 tests/vm/fedora                | 2 +-
 tests/vm/freebsd               | 2 +-
 tests/vm/netbsd                | 2 +-
 tests/vm/openbsd               | 2 +-
 tests/vm/ubuntu.i386           | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/docker/travis.py b/tests/docker/travis.py
index e1433012bd..62fccc5ebb 100755
--- a/tests/docker/travis.py
+++ b/tests/docker/travis.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Travis YAML config parser
 #
diff --git a/tests/qapi-schema/test-qapi.py b/tests/qapi-schema/test-qapi=
.py
index bad14edb47..503fb8ad25 100755
--- a/tests/qapi-schema/test-qapi.py
+++ b/tests/qapi-schema/test-qapi.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # QAPI parser test harness
 #
diff --git a/tests/vm/centos b/tests/vm/centos
index f2f0befd84..a41ff109eb 100755
--- a/tests/vm/centos
+++ b/tests/vm/centos
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # CentOS image
 #
diff --git a/tests/vm/fedora b/tests/vm/fedora
index 8e270fc0f0..4d7d6049f4 100755
--- a/tests/vm/fedora
+++ b/tests/vm/fedora
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Fedora VM image
 #
diff --git a/tests/vm/freebsd b/tests/vm/freebsd
index 33a736298a..fb54334696 100755
--- a/tests/vm/freebsd
+++ b/tests/vm/freebsd
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # FreeBSD VM image
 #
diff --git a/tests/vm/netbsd b/tests/vm/netbsd
index ec6f3563b2..c5069a45f4 100755
--- a/tests/vm/netbsd
+++ b/tests/vm/netbsd
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # NetBSD VM image
 #
diff --git a/tests/vm/openbsd b/tests/vm/openbsd
index d6173506f7..22cd9513dd 100755
--- a/tests/vm/openbsd
+++ b/tests/vm/openbsd
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # OpenBSD VM image
 #
diff --git a/tests/vm/ubuntu.i386 b/tests/vm/ubuntu.i386
index 3834cd7a8d..48e9cb1ad3 100755
--- a/tests/vm/ubuntu.i386
+++ b/tests/vm/ubuntu.i386
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Ubuntu i386 image
 #
--=20
2.21.1

