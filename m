Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDB14D36F
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgA2XPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:15:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727096AbgA2XPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580339730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2iIh/NXtnGBQVzIdZ7KJnnwXZo7tGxQ4WxqBfUKd3fI=;
        b=SZVdGNHSwC7B0d0WI/wZJFaHsWAKAi6oRaA0NE/OrYNOwguqHD7iz9rWVVxNzgxZhQn5ka
        vnHhrhlbEK5VGBqd+7JyKA2CFRGnLqxIf1kzPcgaCaNk+gCJJajyNvWBsBS0Keh2/1Pmvv
        6V5N/B65WxLZpQNjyNbXAf3Dp2EvbTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-Wje8MnAhPomzt9-tun-nvg-1; Wed, 29 Jan 2020 18:15:28 -0500
X-MC-Unique: Wje8MnAhPomzt9-tun-nvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2126E18C43C0;
        Wed, 29 Jan 2020 23:15:27 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 811D85DA7E;
        Wed, 29 Jan 2020 23:15:22 +0000 (UTC)
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
Subject: [PATCH 10/10] tests/qemu-iotests/check: Update to match Python 3 interpreter
Date:   Thu, 30 Jan 2020 00:14:02 +0100
Message-Id: <20200129231402.23384-11-philmd@redhat.com>
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

All the iotests Python scripts have been converted to search for
the Python 3 interpreter. Update the ./check script accordingly.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 tests/qemu-iotests/check | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/qemu-iotests/check b/tests/qemu-iotests/check
index 2890785a10..2e7d29d570 100755
--- a/tests/qemu-iotests/check
+++ b/tests/qemu-iotests/check
@@ -825,7 +825,7 @@ do
=20
         start=3D$(_wallclock)
=20
-        if [ "$(head -n 1 "$source_iotests/$seq")" =3D=3D "#!/usr/bin/en=
v python" ]; then
+        if [ "$(head -n 1 "$source_iotests/$seq")" =3D=3D "#!/usr/bin/en=
v python3" ]; then
             if $python_usable; then
                 run_command=3D"$PYTHON $seq"
             else
--=20
2.21.1

