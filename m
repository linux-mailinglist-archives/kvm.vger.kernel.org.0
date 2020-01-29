Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2414D35F
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgA2XOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:14:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726618AbgA2XOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580339664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHZJzgbxiP0lfWFcHSQGEpHjQEUxlo3iHUb+GCFbfp4=;
        b=LoxnD+RRomoaR8mFc5lzwE2iMORgvQ4lwGAfOcb41toVfHL+pTl+ZVoRsL9V1QmUO1JPZa
        UgS6+RfBHqM/a5+QLhah11Wb75xfJ17yVyNvnT63qqxqTkfewy1/RIFaE3MCxiBkUxp0es
        hRQG8JmXb7A0FCiJjeY+ltX69bU95ZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-eQjvIKthMpa5k55YKBcyRg-1; Wed, 29 Jan 2020 18:14:21 -0500
X-MC-Unique: eQjvIKthMpa5k55YKBcyRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42891801E76;
        Wed, 29 Jan 2020 23:14:20 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1AD15E241;
        Wed, 29 Jan 2020 23:14:15 +0000 (UTC)
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
Subject: [PATCH 01/10] scripts: Explicit usage of Python 3
Date:   Thu, 30 Jan 2020 00:13:53 +0100
Message-Id: <20200129231402.23384-2-philmd@redhat.com>
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
 scripts/analyse-locks-simpletrace.py | 2 +-
 scripts/decodetree.py                | 2 +-
 scripts/device-crash-test            | 2 +-
 scripts/kvm/kvm_flightrecorder       | 2 +-
 scripts/qapi-gen.py                  | 2 +-
 scripts/qmp/qemu-ga-client           | 2 +-
 scripts/qmp/qmp                      | 2 +-
 scripts/qmp/qmp-shell                | 2 +-
 scripts/qmp/qom-fuse                 | 2 +-
 scripts/render_block_graph.py        | 2 +-
 scripts/replay-dump.py               | 2 +-
 scripts/simpletrace.py               | 2 +-
 scripts/tracetool.py                 | 2 +-
 scripts/vmstate-static-checker.py    | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/scripts/analyse-locks-simpletrace.py b/scripts/analyse-locks=
-simpletrace.py
index 7d9b574300..9c263d6e79 100755
--- a/scripts/analyse-locks-simpletrace.py
+++ b/scripts/analyse-locks-simpletrace.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # -*- coding: utf-8 -*-
 #
 # Analyse lock events and compute statistics
diff --git a/scripts/decodetree.py b/scripts/decodetree.py
index d8c59cab60..2a8f2b6e06 100755
--- a/scripts/decodetree.py
+++ b/scripts/decodetree.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # Copyright (c) 2018 Linaro Limited
 #
 # This library is free software; you can redistribute it and/or
diff --git a/scripts/device-crash-test b/scripts/device-crash-test
index 15f213a6cd..25ee968b66 100755
--- a/scripts/device-crash-test
+++ b/scripts/device-crash-test
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 #  Copyright (c) 2017 Red Hat Inc
 #
diff --git a/scripts/kvm/kvm_flightrecorder b/scripts/kvm/kvm_flightrecor=
der
index 54a56745e4..1391a84409 100755
--- a/scripts/kvm/kvm_flightrecorder
+++ b/scripts/kvm/kvm_flightrecorder
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # KVM Flight Recorder - ring buffer tracing script
 #
diff --git a/scripts/qapi-gen.py b/scripts/qapi-gen.py
index f93f3c7c23..c7b0070db2 100755
--- a/scripts/qapi-gen.py
+++ b/scripts/qapi-gen.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # QAPI generator
 #
 # This work is licensed under the terms of the GNU GPL, version 2 or lat=
er.
diff --git a/scripts/qmp/qemu-ga-client b/scripts/qmp/qemu-ga-client
index 30cf8a9a0d..e4568aff68 100755
--- a/scripts/qmp/qemu-ga-client
+++ b/scripts/qmp/qemu-ga-client
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
=20
 # QEMU Guest Agent Client
 #
diff --git a/scripts/qmp/qmp b/scripts/qmp/qmp
index 6cb46fdae2..f85a14a627 100755
--- a/scripts/qmp/qmp
+++ b/scripts/qmp/qmp
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # QMP command line tool
 #
diff --git a/scripts/qmp/qmp-shell b/scripts/qmp/qmp-shell
index f1cddeafbc..9e122ad0c6 100755
--- a/scripts/qmp/qmp-shell
+++ b/scripts/qmp/qmp-shell
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Low-level QEMU shell on top of QMP.
 #
diff --git a/scripts/qmp/qom-fuse b/scripts/qmp/qom-fuse
index 4d85970a78..6bada2c33d 100755
--- a/scripts/qmp/qom-fuse
+++ b/scripts/qmp/qom-fuse
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
diff --git a/scripts/render_block_graph.py b/scripts/render_block_graph.p=
y
index 656f0388ad..409b4321f2 100755
--- a/scripts/render_block_graph.py
+++ b/scripts/render_block_graph.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Render Qemu Block Graph
 #
diff --git a/scripts/replay-dump.py b/scripts/replay-dump.py
index ee7fda2638..0cdae879b7 100755
--- a/scripts/replay-dump.py
+++ b/scripts/replay-dump.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # -*- coding: utf-8 -*-
 #
 # Dump the contents of a recorded execution stream
diff --git a/scripts/simpletrace.py b/scripts/simpletrace.py
index 45485b864b..2bc043112a 100755
--- a/scripts/simpletrace.py
+++ b/scripts/simpletrace.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Pretty-printer for simple trace backend binary trace files
 #
diff --git a/scripts/tracetool.py b/scripts/tracetool.py
index 3beaa66bd8..264cc9eecc 100755
--- a/scripts/tracetool.py
+++ b/scripts/tracetool.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/vmstate-static-checker.py b/scripts/vmstate-static-c=
hecker.py
index f8b7b8f772..d44dedd9e9 100755
--- a/scripts/vmstate-static-checker.py
+++ b/scripts/vmstate-static-checker.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Compares vmstate information stored in JSON format, obtained from
 # the -dump-vmstate QEMU command.
--=20
2.21.1

