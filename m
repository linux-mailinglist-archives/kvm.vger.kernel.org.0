Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DEC14DF38
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgA3QeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:34:05 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40471 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727338AbgA3QeF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 11:34:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580402044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JzCFTXHKbAzJ3GhhPR7g9/CImPjb8Z8Jcz7hUsVhZa8=;
        b=K4FZn5eMbisoiwzQjNKF0PokxlbK5+MCplyAZwFq/2eOyQtPgysncMXExvd+2mU5ggQinz
        Lfo+N/EvKOBvvHa/Vz2dMJp7sSprxquG2i7M5FsvLnihCRAuXdvRRUsJFqgbTO4VJ2nb8S
        IieF1trb4et3AXTQV6F4wQaJFbv1jTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-LyBMNWExOJeK0DDoMd4PhQ-1; Thu, 30 Jan 2020 11:34:01 -0500
X-MC-Unique: LyBMNWExOJeK0DDoMd4PhQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB9BE1800D41;
        Thu, 30 Jan 2020 16:33:59 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CE865E241;
        Thu, 30 Jan 2020 16:33:52 +0000 (UTC)
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
Subject: [PATCH v2 08/12] scripts/tracetool: Remove shebang header
Date:   Thu, 30 Jan 2020 17:32:28 +0100
Message-Id: <20200130163232.10446-9-philmd@redhat.com>
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

Patch created mechanically by running:

  $ chmod 644 $(git grep -lF '#!/usr/bin/env python' \
      | xargs grep -L 'if __name__.*__main__')
  $ sed -i "/^#\!\/usr\/bin\/\(env\ \)\?python.\?$/d" \
      $(git grep -lF '#!/usr/bin/env python' \
      | xargs grep -L 'if __name__.*__main__')

Reported-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 scripts/tracetool/__init__.py                    | 1 -
 scripts/tracetool/backend/__init__.py            | 1 -
 scripts/tracetool/backend/dtrace.py              | 1 -
 scripts/tracetool/backend/ftrace.py              | 1 -
 scripts/tracetool/backend/log.py                 | 1 -
 scripts/tracetool/backend/simple.py              | 1 -
 scripts/tracetool/backend/syslog.py              | 1 -
 scripts/tracetool/backend/ust.py                 | 1 -
 scripts/tracetool/format/__init__.py             | 1 -
 scripts/tracetool/format/c.py                    | 1 -
 scripts/tracetool/format/d.py                    | 1 -
 scripts/tracetool/format/h.py                    | 1 -
 scripts/tracetool/format/log_stap.py             | 1 -
 scripts/tracetool/format/simpletrace_stap.py     | 1 -
 scripts/tracetool/format/stap.py                 | 1 -
 scripts/tracetool/format/tcg_h.py                | 1 -
 scripts/tracetool/format/tcg_helper_c.py         | 1 -
 scripts/tracetool/format/tcg_helper_h.py         | 1 -
 scripts/tracetool/format/tcg_helper_wrapper_h.py | 1 -
 scripts/tracetool/format/ust_events_c.py         | 1 -
 scripts/tracetool/format/ust_events_h.py         | 1 -
 scripts/tracetool/transform.py                   | 1 -
 scripts/tracetool/vcpu.py                        | 1 -
 23 files changed, 23 deletions(-)

diff --git a/scripts/tracetool/__init__.py b/scripts/tracetool/__init__.p=
y
index 44c118bc2a..13d29f1e42 100644
--- a/scripts/tracetool/__init__.py
+++ b/scripts/tracetool/__init__.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/backend/__init__.py b/scripts/tracetool/ba=
ckend/__init__.py
index 259c6a6531..54cab2c4de 100644
--- a/scripts/tracetool/backend/__init__.py
+++ b/scripts/tracetool/backend/__init__.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/backend/dtrace.py b/scripts/tracetool/back=
end/dtrace.py
index c2f3a4e5a8..638990db79 100644
--- a/scripts/tracetool/backend/dtrace.py
+++ b/scripts/tracetool/backend/dtrace.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/backend/ftrace.py b/scripts/tracetool/back=
end/ftrace.py
index 92f71b28f9..e9844dd335 100644
--- a/scripts/tracetool/backend/ftrace.py
+++ b/scripts/tracetool/backend/ftrace.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/backend/log.py b/scripts/tracetool/backend=
/log.py
index 33c95af8e9..23b274c0fd 100644
--- a/scripts/tracetool/backend/log.py
+++ b/scripts/tracetool/backend/log.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/backend/simple.py b/scripts/tracetool/back=
end/simple.py
index c2fd1c24c4..b650c262b5 100644
--- a/scripts/tracetool/backend/simple.py
+++ b/scripts/tracetool/backend/simple.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/backend/syslog.py b/scripts/tracetool/back=
end/syslog.py
index 668fb73fee..1373a90192 100644
--- a/scripts/tracetool/backend/syslog.py
+++ b/scripts/tracetool/backend/syslog.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/backend/ust.py b/scripts/tracetool/backend=
/ust.py
index 280cb7c106..a772a3b53b 100644
--- a/scripts/tracetool/backend/ust.py
+++ b/scripts/tracetool/backend/ust.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/__init__.py b/scripts/tracetool/for=
mat/__init__.py
index cf6e0e2da5..aba2f7a441 100644
--- a/scripts/tracetool/format/__init__.py
+++ b/scripts/tracetool/format/__init__.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/c.py b/scripts/tracetool/format/c.p=
y
index 31207961b0..78af8aff72 100644
--- a/scripts/tracetool/format/c.py
+++ b/scripts/tracetool/format/c.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/d.py b/scripts/tracetool/format/d.p=
y
index c7cb2a93a6..d3980b914b 100644
--- a/scripts/tracetool/format/d.py
+++ b/scripts/tracetool/format/d.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/h.py b/scripts/tracetool/format/h.p=
y
index 5596b304e6..83e1a2f355 100644
--- a/scripts/tracetool/format/h.py
+++ b/scripts/tracetool/format/h.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/log_stap.py b/scripts/tracetool/for=
mat/log_stap.py
index 9ab0cf2cce..b486beb672 100644
--- a/scripts/tracetool/format/log_stap.py
+++ b/scripts/tracetool/format/log_stap.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/simpletrace_stap.py b/scripts/trace=
tool/format/simpletrace_stap.py
index 57b04061cf..4f4633b4e6 100644
--- a/scripts/tracetool/format/simpletrace_stap.py
+++ b/scripts/tracetool/format/simpletrace_stap.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/stap.py b/scripts/tracetool/format/=
stap.py
index e8ef3e762d..8fc808f2ef 100644
--- a/scripts/tracetool/format/stap.py
+++ b/scripts/tracetool/format/stap.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/tcg_h.py b/scripts/tracetool/format=
/tcg_h.py
index 1651cc3f71..0180e3d76c 100644
--- a/scripts/tracetool/format/tcg_h.py
+++ b/scripts/tracetool/format/tcg_h.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/tcg_helper_c.py b/scripts/tracetool=
/format/tcg_helper_c.py
index 1b3522a716..6527b69afd 100644
--- a/scripts/tracetool/format/tcg_helper_c.py
+++ b/scripts/tracetool/format/tcg_helper_c.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/tcg_helper_h.py b/scripts/tracetool=
/format/tcg_helper_h.py
index 6b184b641b..98ebe52f18 100644
--- a/scripts/tracetool/format/tcg_helper_h.py
+++ b/scripts/tracetool/format/tcg_helper_h.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/tcg_helper_wrapper_h.py b/scripts/t=
racetool/format/tcg_helper_wrapper_h.py
index ff53447512..6adeab74df 100644
--- a/scripts/tracetool/format/tcg_helper_wrapper_h.py
+++ b/scripts/tracetool/format/tcg_helper_wrapper_h.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/ust_events_c.py b/scripts/tracetool=
/format/ust_events_c.py
index 264784cdf2..deced9533d 100644
--- a/scripts/tracetool/format/ust_events_c.py
+++ b/scripts/tracetool/format/ust_events_c.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/format/ust_events_h.py b/scripts/tracetool=
/format/ust_events_h.py
index b14054ac01..6ce559f6cc 100644
--- a/scripts/tracetool/format/ust_events_h.py
+++ b/scripts/tracetool/format/ust_events_h.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/transform.py b/scripts/tracetool/transform=
.py
index 2ca9286046..8fd4dcf20d 100644
--- a/scripts/tracetool/transform.py
+++ b/scripts/tracetool/transform.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
diff --git a/scripts/tracetool/vcpu.py b/scripts/tracetool/vcpu.py
index 452c7f589d..0b104e4f15 100644
--- a/scripts/tracetool/vcpu.py
+++ b/scripts/tracetool/vcpu.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 # -*- coding: utf-8 -*-
=20
 """
--=20
2.21.1

