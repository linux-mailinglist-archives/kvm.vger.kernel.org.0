Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8D714D366
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgA2XPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:15:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727024AbgA2XPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:15:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580339709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcvlDXM/cgtCtcBXzfb/LXQ9lWiWubNrUXOxCz+oZZ8=;
        b=gzOPxenf/FNCvRVcv8gKpaWScoYWAEywtKNEVhWzPgOoacUqu2GSCFTFdzB7ZBKUeZa75P
        W7nLym4VXCDHQO+uTLoi7XJAMRn2eSYWO/ZoMM0NZZlWslcn5yenmf5Khh+crFNFa/jeov
        PG9KjgiyJ2XXtN/zvWQzlharGLqdgjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-4NPQyif1MPmmrP4XJo3wDw-1; Wed, 29 Jan 2020 18:15:07 -0500
X-MC-Unique: 4NPQyif1MPmmrP4XJo3wDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B229800D5A;
        Wed, 29 Jan 2020 23:15:06 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23BF25DA7E;
        Wed, 29 Jan 2020 23:14:57 +0000 (UTC)
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
Subject: [PATCH 07/10] tests/vm: Remove shebang header
Date:   Thu, 30 Jan 2020 00:13:59 +0100
Message-Id: <20200129231402.23384-8-philmd@redhat.com>
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

Patch created mechanically by running:

  $ chmod 644 $(git grep -lF '#!/usr/bin/env python' | xargs grep -L 'if =
__name__.*__main__')
  $ sed -i "/^#\!\/usr\/bin\/\(env\ \)\?python.\?$/d" $(git grep -lF '#!/=
usr/bin/env python' | xargs grep -L 'if __name__.*__main__')

Reported-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 tests/vm/basevm.py | 1 -
 1 file changed, 1 deletion(-)
 mode change 100755 =3D> 100644 tests/vm/basevm.py

diff --git a/tests/vm/basevm.py b/tests/vm/basevm.py
old mode 100755
new mode 100644
index ed5dd4f3d0..30714fa1a8
--- a/tests/vm/basevm.py
+++ b/tests/vm/basevm.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python
 #
 # VM testing base class
 #
--=20
2.21.1

