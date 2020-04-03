Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5DC19D3ED
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 11:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390651AbgDCJk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 05:40:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390228AbgDCJk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 05:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585906825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=52QYJyYJv2m/SL+tJcSL8iQkShlKqG1bBL9lBOP0aCU=;
        b=I6HLiI+5kPnAKiVS2ba9JXJa1AdE4Yk8qffARbaj124KlBLRLygYSSzjaFYTcc63QTJrZK
        rB0snoW7/27HVapZhZGVE2xwf+4iDPTAcAKKGezi7vUJy+UTFrqjvEKkK6K6HyzPFZmJHB
        2IITveBUg2CyiiDbu90TsnkTDlVkv7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-DYiiXnBuNCCYu1zovg25MQ-1; Fri, 03 Apr 2020 05:40:23 -0400
X-MC-Unique: DYiiXnBuNCCYu1zovg25MQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5C95190B2A6;
        Fri,  3 Apr 2020 09:40:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AC3B60BF3;
        Fri,  3 Apr 2020 09:40:18 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, frankja@linux.ibm.com
Subject: [PATCH kvm-unit-tests v2] s390x: unittests: Use smp parameter
Date:   Fri,  3 Apr 2020 11:40:15 +0200
Message-Id: <20200403094015.506838-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---

v2: Really just a repost, but also picked up the tags.

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
2.25.1

