Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9101C000D
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgD3PYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:24:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45875 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgD3PYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oo4ewZBzbISUXtmgWjNPvYau/73/ltqaZVuLGWCX/Co=;
        b=OI3BAgql7FGcrB4+Bd8csQCcG0nmTw8C447OSj8MiH2ypdXGleyYq1364RGLwsBbUpipXx
        s6crnMPP3zc/2qzB/28dI5GsVi4x9lmZhK+vyxXqaLVDVjiJuhqjckXEQ3OnxT1ojPGo5u
        5N+F67O8ezZcRGDeJJ97ZQ0o0P1QPTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-8fhCr_7IN-e_e8CfY9jjuw-1; Thu, 30 Apr 2020 11:24:38 -0400
X-MC-Unique: 8fhCr_7IN-e_e8CfY9jjuw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99481107ACCD;
        Thu, 30 Apr 2020 15:24:37 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C4235EDE3;
        Thu, 30 Apr 2020 15:24:35 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Janosch Frank <frankja@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 01/17] MAINTAINERS: Add Janosch as a s390x maintainer
Date:   Thu, 30 Apr 2020 17:24:14 +0200
Message-Id: <20200430152430.40349-2-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

Both, David and I, often do not have as much spare time for the
kvm-unit-tests as we would like to have, so we could use a little
bit of additional help here. Janosch did some excellent work for
the s390x kvm-unit-tests in the past months and is listed as reviewer
for these patches since quite a while already, so he's a very well
suited for the maintainer job here, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Acked-by: Janosch Frank <frankja@de.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Message-Id: <20200205101935.19219-1-thuth@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 48da1db..082be95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -80,7 +80,7 @@ F: lib/ppc64/*
 S390X
 M: Thomas Huth <thuth@redhat.com>
 M: David Hildenbrand <david@redhat.com>
-R: Janosch Frank <frankja@linux.ibm.com>
+M: Janosch Frank <frankja@linux.ibm.com>
 L: kvm@vger.kernel.org
 F: s390x/*
 F: lib/s390x/*
--=20
2.25.3

