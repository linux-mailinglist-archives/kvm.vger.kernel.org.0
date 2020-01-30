Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B03314DF37
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgA3Qd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:33:57 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25193 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727405AbgA3Qd5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 11:33:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580402036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jQXlB2AB6eUYg0qnVSegVUVg31jjhLlH05OlYfe6MC0=;
        b=h8x9OAMSMAV2ToiPJjTL7A6b6VS7TGbNjhK0KVBnENBbn28dPpsfdbyCanHIk+hqkjHKue
        1ryF0hiNCFdCPe657SZ6gPzlEHVDPPECn+7De799KPJNGzigNBgdz25MFnqFwxI0CVf3Xg
        BogIsbtzjjvDzduIdlEBX80MCz/yDU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-45g4bVZaO4SRFIWyoAHqXQ-1; Thu, 30 Jan 2020 11:33:53 -0500
X-MC-Unique: 45g4bVZaO4SRFIWyoAHqXQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E295800D41;
        Thu, 30 Jan 2020 16:33:52 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4630E5DE53;
        Thu, 30 Jan 2020 16:33:47 +0000 (UTC)
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
Subject: [PATCH v2 07/12] tests/acceptance: Remove shebang header
Date:   Thu, 30 Jan 2020 17:32:27 +0100
Message-Id: <20200130163232.10446-8-philmd@redhat.com>
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
Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 tests/acceptance/virtio_seg_max_adjust.py  | 1 -
 tests/acceptance/x86_cpu_model_versions.py | 1 -
 2 files changed, 2 deletions(-)
 mode change 100755 =3D> 100644 tests/acceptance/virtio_seg_max_adjust.py

diff --git a/tests/acceptance/virtio_seg_max_adjust.py b/tests/acceptance=
/virtio_seg_max_adjust.py
old mode 100755
new mode 100644
index 5458573138..8d4f24da49
--- a/tests/acceptance/virtio_seg_max_adjust.py
+++ b/tests/acceptance/virtio_seg_max_adjust.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 #
 # Test virtio-scsi and virtio-blk queue settings for all machine types
 #
diff --git a/tests/acceptance/x86_cpu_model_versions.py b/tests/acceptanc=
e/x86_cpu_model_versions.py
index 90558d9a71..01ff614ec2 100644
--- a/tests/acceptance/x86_cpu_model_versions.py
+++ b/tests/acceptance/x86_cpu_model_versions.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 #
 # Basic validation of x86 versioned CPU models and CPU model aliases
 #
--=20
2.21.1

