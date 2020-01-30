Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFC614DF33
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgA3Qd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:33:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27317 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727285AbgA3Qd0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 11:33:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580402005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btIG2Fs04Sea/rckERtd/RgbC06coOumAnRdO8Zinws=;
        b=QzFPoieS46xJLXcypJ23im6FOswPDoO+MLMAdtUgeH9M8InGLimIcM9j2K8EuVIpwLC7+h
        36FTDPTBsK+GLamvX0GSgZt1jnwLtu0JeV0HCAs7+ek9b3DndrkeF3qsaehwiNZc+snBCr
        aZoaW7pijwLkDNw1gRQyUWt4x1cfIOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-0vRbD3OhNRi8uRCQmqFMkg-1; Thu, 30 Jan 2020 11:33:19 -0500
X-MC-Unique: 0vRbD3OhNRi8uRCQmqFMkg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 843991005510;
        Thu, 30 Jan 2020 16:33:16 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82B025DE53;
        Thu, 30 Jan 2020 16:33:11 +0000 (UTC)
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
Subject: [PATCH v2 03/12] tests/qemu-iotests: Explicit usage of Python 3 (scripts with __main__)
Date:   Thu, 30 Jan 2020 17:32:23 +0100
Message-Id: <20200130163232.10446-4-philmd@redhat.com>
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
 tests/qemu-iotests/030                   | 2 +-
 tests/qemu-iotests/040                   | 2 +-
 tests/qemu-iotests/041                   | 2 +-
 tests/qemu-iotests/044                   | 2 +-
 tests/qemu-iotests/045                   | 2 +-
 tests/qemu-iotests/055                   | 2 +-
 tests/qemu-iotests/056                   | 2 +-
 tests/qemu-iotests/057                   | 2 +-
 tests/qemu-iotests/065                   | 2 +-
 tests/qemu-iotests/093                   | 2 +-
 tests/qemu-iotests/096                   | 2 +-
 tests/qemu-iotests/118                   | 2 +-
 tests/qemu-iotests/124                   | 2 +-
 tests/qemu-iotests/129                   | 2 +-
 tests/qemu-iotests/132                   | 2 +-
 tests/qemu-iotests/136                   | 2 +-
 tests/qemu-iotests/139                   | 2 +-
 tests/qemu-iotests/147                   | 2 +-
 tests/qemu-iotests/148                   | 2 +-
 tests/qemu-iotests/151                   | 2 +-
 tests/qemu-iotests/152                   | 2 +-
 tests/qemu-iotests/155                   | 2 +-
 tests/qemu-iotests/163                   | 2 +-
 tests/qemu-iotests/165                   | 2 +-
 tests/qemu-iotests/169                   | 2 +-
 tests/qemu-iotests/196                   | 2 +-
 tests/qemu-iotests/199                   | 2 +-
 tests/qemu-iotests/205                   | 2 +-
 tests/qemu-iotests/245                   | 2 +-
 tests/qemu-iotests/257                   | 2 +-
 tests/qemu-iotests/258                   | 2 +-
 tests/qemu-iotests/281                   | 2 +-
 tests/qemu-iotests/nbd-fault-injector.py | 2 +-
 tests/qemu-iotests/qcow2.py              | 2 +-
 tests/qemu-iotests/qed.py                | 2 +-
 35 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/tests/qemu-iotests/030 b/tests/qemu-iotests/030
index 0990681c1e..aa911d266a 100755
--- a/tests/qemu-iotests/030
+++ b/tests/qemu-iotests/030
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for image streaming.
 #
diff --git a/tests/qemu-iotests/040 b/tests/qemu-iotests/040
index 74f62c3c4a..2e7ee0e84f 100755
--- a/tests/qemu-iotests/040
+++ b/tests/qemu-iotests/040
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for image block commit.
 #
diff --git a/tests/qemu-iotests/041 b/tests/qemu-iotests/041
index c07437fda1..219b120b57 100755
--- a/tests/qemu-iotests/041
+++ b/tests/qemu-iotests/041
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for image mirroring.
 #
diff --git a/tests/qemu-iotests/044 b/tests/qemu-iotests/044
index 8b2afa2a11..7e99ea7c68 100755
--- a/tests/qemu-iotests/044
+++ b/tests/qemu-iotests/044
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests growing a large refcount table.
 #
diff --git a/tests/qemu-iotests/045 b/tests/qemu-iotests/045
index 01cc038884..5acc89099c 100755
--- a/tests/qemu-iotests/045
+++ b/tests/qemu-iotests/045
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for fdsets and getfd.
 #
diff --git a/tests/qemu-iotests/055 b/tests/qemu-iotests/055
index c732a112d6..82b9f5f47d 100755
--- a/tests/qemu-iotests/055
+++ b/tests/qemu-iotests/055
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for drive-backup and blockdev-backup
 #
diff --git a/tests/qemu-iotests/056 b/tests/qemu-iotests/056
index f39287c162..f73fc74457 100755
--- a/tests/qemu-iotests/056
+++ b/tests/qemu-iotests/056
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for drive-backup
 #
diff --git a/tests/qemu-iotests/057 b/tests/qemu-iotests/057
index 9fbba759b6..a8b4bb60e0 100755
--- a/tests/qemu-iotests/057
+++ b/tests/qemu-iotests/057
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for internal snapshot.
 #
diff --git a/tests/qemu-iotests/065 b/tests/qemu-iotests/065
index 5b21eb96bd..6426474271 100755
--- a/tests/qemu-iotests/065
+++ b/tests/qemu-iotests/065
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test for additional information emitted by qemu-img info on qcow2
 # images
diff --git a/tests/qemu-iotests/093 b/tests/qemu-iotests/093
index f03fa24a07..32ded11430 100755
--- a/tests/qemu-iotests/093
+++ b/tests/qemu-iotests/093
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for IO throttling
 #
diff --git a/tests/qemu-iotests/096 b/tests/qemu-iotests/096
index ab9cb47822..5915f92786 100755
--- a/tests/qemu-iotests/096
+++ b/tests/qemu-iotests/096
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test that snapshots move the throttling configuration to the active
 # layer
diff --git a/tests/qemu-iotests/118 b/tests/qemu-iotests/118
index e20080e9a6..adc8a848b5 100755
--- a/tests/qemu-iotests/118
+++ b/tests/qemu-iotests/118
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test case for the QMP 'change' command and all other associated
 # commands
diff --git a/tests/qemu-iotests/124 b/tests/qemu-iotests/124
index d3e851e1ae..3705cbb6b3 100755
--- a/tests/qemu-iotests/124
+++ b/tests/qemu-iotests/124
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for incremental drive-backup
 #
diff --git a/tests/qemu-iotests/129 b/tests/qemu-iotests/129
index cd6b9e9ce7..b0da4a5541 100755
--- a/tests/qemu-iotests/129
+++ b/tests/qemu-iotests/129
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests that "bdrv_drain_all" doesn't drain block jobs
 #
diff --git a/tests/qemu-iotests/132 b/tests/qemu-iotests/132
index 0f2a106c81..39ea43067e 100755
--- a/tests/qemu-iotests/132
+++ b/tests/qemu-iotests/132
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test mirror with unmap
 #
diff --git a/tests/qemu-iotests/136 b/tests/qemu-iotests/136
index 012ea111ac..d59400c9fc 100755
--- a/tests/qemu-iotests/136
+++ b/tests/qemu-iotests/136
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for block device statistics
 #
diff --git a/tests/qemu-iotests/139 b/tests/qemu-iotests/139
index cbb5a76530..6b1a444364 100755
--- a/tests/qemu-iotests/139
+++ b/tests/qemu-iotests/139
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test cases for the QMP 'blockdev-del' command
 #
diff --git a/tests/qemu-iotests/147 b/tests/qemu-iotests/147
index 03fc2fabcf..51290829cd 100755
--- a/tests/qemu-iotests/147
+++ b/tests/qemu-iotests/147
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test case for NBD's blockdev-add interface
 #
diff --git a/tests/qemu-iotests/148 b/tests/qemu-iotests/148
index 8c11c53cba..90931948e3 100755
--- a/tests/qemu-iotests/148
+++ b/tests/qemu-iotests/148
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test the rate limit of QMP events
 #
diff --git a/tests/qemu-iotests/151 b/tests/qemu-iotests/151
index 76ae265cc1..f2df72c29c 100755
--- a/tests/qemu-iotests/151
+++ b/tests/qemu-iotests/151
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for active mirroring
 #
diff --git a/tests/qemu-iotests/152 b/tests/qemu-iotests/152
index 732bf5f062..cc2ea09654 100755
--- a/tests/qemu-iotests/152
+++ b/tests/qemu-iotests/152
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for drive-mirror with source size unaligned to granularity
 #
diff --git a/tests/qemu-iotests/155 b/tests/qemu-iotests/155
index e19485911c..e35b1d534b 100755
--- a/tests/qemu-iotests/155
+++ b/tests/qemu-iotests/155
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test whether the backing BDSs are correct after completion of a
 # mirror block job; in "existing" modes (drive-mirror with
diff --git a/tests/qemu-iotests/163 b/tests/qemu-iotests/163
index d94728e080..5a3cc840a5 100755
--- a/tests/qemu-iotests/163
+++ b/tests/qemu-iotests/163
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for shrinking images
 #
diff --git a/tests/qemu-iotests/165 b/tests/qemu-iotests/165
index 951ea011a2..b60a803dae 100755
--- a/tests/qemu-iotests/165
+++ b/tests/qemu-iotests/165
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for persistent dirty bitmaps.
 #
diff --git a/tests/qemu-iotests/169 b/tests/qemu-iotests/169
index 9656a7f620..2c5a132aa3 100755
--- a/tests/qemu-iotests/169
+++ b/tests/qemu-iotests/169
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for dirty bitmaps migration.
 #
diff --git a/tests/qemu-iotests/196 b/tests/qemu-iotests/196
index 92fe9244f8..e8fcf37273 100755
--- a/tests/qemu-iotests/196
+++ b/tests/qemu-iotests/196
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test clearing unknown autoclear_features flag by qcow2 after
 # migration. This test mimics migration to older qemu.
diff --git a/tests/qemu-iotests/199 b/tests/qemu-iotests/199
index a2c8ecab5a..40774eed74 100755
--- a/tests/qemu-iotests/199
+++ b/tests/qemu-iotests/199
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for dirty bitmaps postcopy migration.
 #
diff --git a/tests/qemu-iotests/205 b/tests/qemu-iotests/205
index 4bb2c21e8b..43432cb599 100755
--- a/tests/qemu-iotests/205
+++ b/tests/qemu-iotests/205
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tests for qmp command nbd-server-remove.
 #
diff --git a/tests/qemu-iotests/245 b/tests/qemu-iotests/245
index d12b253065..489bf78bd0 100644
--- a/tests/qemu-iotests/245
+++ b/tests/qemu-iotests/245
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test cases for the QMP 'x-blockdev-reopen' command
 #
diff --git a/tests/qemu-iotests/257 b/tests/qemu-iotests/257
index a9828251cf..004a433b8b 100755
--- a/tests/qemu-iotests/257
+++ b/tests/qemu-iotests/257
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test bitmap-sync backups (incremental, differential, and partials)
 #
diff --git a/tests/qemu-iotests/258 b/tests/qemu-iotests/258
index b84cf02254..091755a45c 100755
--- a/tests/qemu-iotests/258
+++ b/tests/qemu-iotests/258
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Very specific tests for adjacent commit/stream block jobs
 #
diff --git a/tests/qemu-iotests/281 b/tests/qemu-iotests/281
index 269d583b2c..0bf973bca6 100755
--- a/tests/qemu-iotests/281
+++ b/tests/qemu-iotests/281
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Test cases for blockdev + IOThread interactions
 #
diff --git a/tests/qemu-iotests/nbd-fault-injector.py b/tests/qemu-iotest=
s/nbd-fault-injector.py
index 7e2dab6ea4..b158dd65a2 100755
--- a/tests/qemu-iotests/nbd-fault-injector.py
+++ b/tests/qemu-iotests/nbd-fault-injector.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # NBD server - fault injection utility
 #
 # Configuration file syntax:
diff --git a/tests/qemu-iotests/qcow2.py b/tests/qemu-iotests/qcow2.py
index 91e4420b9f..1c4fa2b09f 100755
--- a/tests/qemu-iotests/qcow2.py
+++ b/tests/qemu-iotests/qcow2.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
=20
 from __future__ import print_function
 import sys
diff --git a/tests/qemu-iotests/qed.py b/tests/qemu-iotests/qed.py
index 8adaaf46c4..36bca1de23 100755
--- a/tests/qemu-iotests/qed.py
+++ b/tests/qemu-iotests/qed.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Tool to manipulate QED image files
 #
--=20
2.21.1

