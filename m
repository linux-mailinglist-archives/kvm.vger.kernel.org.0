Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5160415C07E
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 15:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgBMOjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 09:39:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28616 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgBMOjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 09:39:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581604742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o6W3XBfbdiVfU6zyxBNjQLFll+Vg04rm8+GTn0/p2LU=;
        b=HzURuKi4GnAzbWAfIjZXVivz4xmV4SypDaVbczKo4SloyhXTUU4BlECTJYsFz31oldJ3qU
        HSsAbw7lWQn0kW0Wn9BhI25C/omtuUeQGIN1f0LlELJ2l/cIUt9svJUfcZBvQYTFas6OkA
        mhIHTMtp+2vY8mTAQ7IuiD+bTdhsbhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-E2SH1OabNqSYpNdEUpoIWw-1; Thu, 13 Feb 2020 09:39:01 -0500
X-MC-Unique: E2SH1OabNqSYpNdEUpoIWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB3108EC828;
        Thu, 13 Feb 2020 14:38:59 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21DB21001B0B;
        Thu, 13 Feb 2020 14:38:55 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, frankja@linux.ibm.com
Subject: [PATCH kvm-unit-tests] s390x: unittests: Use smp parameter
Date:   Thu, 13 Feb 2020 15:38:55 +0100
Message-Id: <20200213143855.2965-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 s390x/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 07013b2b8748..aa6d5d96e292 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -74,7 +74,7 @@ file =3D stsi.elf
=20
 [smp]
 file =3D smp.elf
-extra_params =3D-smp 2
+smp =3D 2
=20
 [sclp-1g]
 file =3D sclp.elf
--=20
2.21.1

