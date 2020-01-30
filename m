Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9537614DF32
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgA3QdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:33:16 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28521 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727285AbgA3QdQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 11:33:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580401995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Psv1XrYMRp6/bio5BGEkLgfD58ErvuUMr6pDtw2Fzdk=;
        b=G5SEht04vyACEgCdJnWoJNYNAPs6i2MOU6KbpcXmGpsywEOrW7BhsAUJ2WNx2EJCQK00+P
        4KdSvqo0+ovcpYAZHwStsrjiAmrS7UufCCLhUV9hMhTGoeIKYEnrgGUaPZFbCrp7XEQuln
        nKMVJ/e3+3PujkE5PKchKCbfr+5J9YE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-ndvTu8k8M1myO9PxOaoeMQ-1; Thu, 30 Jan 2020 11:33:00 -0500
X-MC-Unique: ndvTu8k8M1myO9PxOaoeMQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E899DB63;
        Thu, 30 Jan 2020 16:32:58 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-184.brq.redhat.com [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6C345DA75;
        Thu, 30 Jan 2020 16:32:47 +0000 (UTC)
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
        kvm@vger.kernel.org, John Snow <jsnow@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH v2 01/12] scripts/checkpatch.pl: Only allow Python 3 interpreter
Date:   Thu, 30 Jan 2020 17:32:21 +0100
Message-Id: <20200130163232.10446-2-philmd@redhat.com>
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

Since commit ddf9069963 QEMU requires Python >=3D 3.5.

PEP 0394 [*] states that 'python3' should be available and
that 'python' is optional.

To avoid problem with unsupported versions, enforce the
shebang interpreter to Python 3.

[*] https://www.python.org/dev/peps/pep-0394/

Reported-by: John Snow <jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
Cc: Eric Blake <eblake@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3aef6e3dfe..ce43a306f8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1460,6 +1460,12 @@ sub process {
 			}
 		}
=20
+# Only allow Python 3 interpreter
+		if ($realline =3D=3D 1 &&
+			$line =3D~ /^\+#!\ *\/usr\/bin\/(?:env )?python$/) {
+			ERROR("please use python3 interpreter\n" . $herecurr);
+		}
+
 # Accept git diff extended headers as valid patches
 		if ($line =3D~ /^(?:rename|copy) (?:from|to) [\w\/\.\-]+\s*$/) {
 			$is_patch =3D 1;
--=20
2.21.1

