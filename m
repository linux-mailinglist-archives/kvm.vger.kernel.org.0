Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57551C001F
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgD3PY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:24:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48783 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726814AbgD3PY6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 11:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M8ZcT0j1duyJlrVxhoY+6SuYWTCgaNWIiADLekpznQ4=;
        b=CvrSmEjApNufkLja37rJkW14vTnWIftcAX4f/ihEMdhMZFEDQTk6ZJLu9681ga4okXWg8J
        XkTZ/iXbapqgaHaZy8HyWZWCqfex5eB/WOAHr07mFFjHakVZG7cg+LrTlV2hMWWQqztrxR
        T/8yKYqnyDkiX1HbFknXWrrJzzS2duQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-R04Z7BjrOoa9VA5N7tLTqA-1; Thu, 30 Apr 2020 11:24:54 -0400
X-MC-Unique: R04Z7BjrOoa9VA5N7tLTqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67ED2872FE2;
        Thu, 30 Apr 2020 15:24:53 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8549A5EDE3;
        Thu, 30 Apr 2020 15:24:49 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 08/17] s390x: unittests: Use smp parameter
Date:   Thu, 30 Apr 2020 17:24:21 +0200
Message-Id: <20200430152430.40349-9-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200403094015.506838-1-drjones@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 535db21..b307329 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -75,7 +75,7 @@ extra_params=3D-name kvm-unit-test --uuid 0fb84a86-727c=
-11ea-bc55-0242ac130003 -sm
=20
 [smp]
 file =3D smp.elf
-extra_params =3D-smp 2
+smp =3D 2
=20
 [sclp-1g]
 file =3D sclp.elf
--=20
2.25.3

