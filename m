Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4A014DF3F
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgA3Qei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:34:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42261 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727267AbgA3Qei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 11:34:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580402077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1qnDsqImwz/Uv9R8giOqJwFHxTUvFqTQrHir4xcVefQ=;
        b=b1zdKxyUqaHOQ2q1syJQ7l17GLH7h6RLbbYk+7GZ65le4Y8leAL3iKwA4ZI8jZ7Z1txWAd
        o4ATuuwmfVI22XYRv5YoKRUpjfwhNO/uH+BikggSpESrUwQ9q+JlODrAIFykGtMRPKHSW0
        f1ur4qXTdCXmwaCpswLh6s2pCu6OR4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-LHOElC_kPPujkg5t4gV6qw-1; Thu, 30 Jan 2020 11:34:35 -0500
X-MC-Unique: LHOElC_kPPujkg5t4gV6qw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C71E88010CC;
        Thu, 30 Jan 2020 16:34:33 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0280A5DA75;
        Thu, 30 Jan 2020 16:34:28 +0000 (UTC)
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
Subject: [PATCH v2 12/12] tests/qemu-iotests/check: Only check for Python 3 interpreter
Date:   Thu, 30 Jan 2020 17:32:32 +0100
Message-Id: <20200130163232.10446-13-philmd@redhat.com>
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

All the iotests Python scripts have been converted to search for
the Python 3 interpreter. Update the ./check script accordingly.

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 tests/qemu-iotests/check | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/qemu-iotests/check b/tests/qemu-iotests/check
index bdcd64aea4..2e7d29d570 100755
--- a/tests/qemu-iotests/check
+++ b/tests/qemu-iotests/check
@@ -825,8 +825,7 @@ do
=20
         start=3D$(_wallclock)
=20
-        if [ "$(head -n 1 "$source_iotests/$seq" | sed 's/3$//')" \
-            =3D=3D "#!/usr/bin/env python" ]; then
+        if [ "$(head -n 1 "$source_iotests/$seq")" =3D=3D "#!/usr/bin/en=
v python3" ]; then
             if $python_usable; then
                 run_command=3D"$PYTHON $seq"
             else
--=20
2.21.1

