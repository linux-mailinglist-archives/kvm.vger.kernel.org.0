Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51EFD14D361
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgA2XOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:14:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20139 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726980AbgA2XOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:14:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580339678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Ci9BaCxgdIZecqR9n7oGxc4Blyawh6fanmUu+mUzfA=;
        b=FAxlsxA8E+e5MVh0i6UCT+S6Un8Ow3z/5LZPwIX+jJImszzbOblLgQYM1ecZc9MCaL/SJU
        eKsrGOFwuYxQi3IUxfoI8jg1B7B72zc4pcBQWXlWBnYzAjv2giPl2Ni9jb20wVDRHhuRfQ
        vFZXVDpLqI/wHSODoV/Lp63mW7/QPfs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-EevXuBfKPmSuYscTDRQ0-A-1; Wed, 29 Jan 2020 18:14:37 -0500
X-MC-Unique: EevXuBfKPmSuYscTDRQ0-A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C583107ACC9;
        Wed, 29 Jan 2020 23:14:35 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 389445E241;
        Wed, 29 Jan 2020 23:14:26 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Kevin Wolf <kwolf@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH 03/10] tests: Explicit usage of Python 3
Date:   Thu, 30 Jan 2020 00:13:55 +0100
Message-Id: <20200129231402.23384-4-philmd@redhat.com>
In-Reply-To: <20200129231402.23384-1-philmd@redhat.com>
References: <20200129231402.23384-1-philmd@redhat.com>
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

