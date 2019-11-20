Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0704103D24
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbfKTOTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 09:19:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729490AbfKTOTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 09:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574259572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pethWT0UbnfrUscN97QLS4gJaPBeIS0NMTqV57F0VQE=;
        b=JNxbbZgO3cRu40hC1IAmHkjP8WlZKquhkLKzj60Bkw9NgyAqu9UpIsEtMESsIgXpPiHrVn
        tf2g+ya5jhwOKsWHqh18qhLhAlTLs2AX3BHH5xqe56iHlDHKVWE1wU26OJXxq1soxkJjlp
        IVWjc8JhDZE23po0M+kXWzxTmcN6cLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-rg5THV9WPIu6GvUykGlzXg-1; Wed, 20 Nov 2019 09:19:31 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9054D1883524
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 14:19:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDD8B5F77B;
        Wed, 20 Nov 2019 14:19:29 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] runtime: set MAX_SMP to number of online cpus
Date:   Wed, 20 Nov 2019 15:19:28 +0100
Message-Id: <20191120141928.6849-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: rg5THV9WPIu6GvUykGlzXg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can only use online cpus, so make sure we check specifically for
those.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 200d5b67290c..fbad0bd05fc5 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -1,5 +1,5 @@
 : "${RUNTIME_arch_run?}"
-: ${MAX_SMP:=3D$(getconf _NPROCESSORS_CONF)}
+: ${MAX_SMP:=3D$(getconf _NPROCESSORS_ONLN)}
 : ${TIMEOUT:=3D90s}
=20
 PASS() { echo -ne "\e[32mPASS\e[0m"; }
--=20
2.21.0

