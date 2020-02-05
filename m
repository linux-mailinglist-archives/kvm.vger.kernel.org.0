Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198F7152901
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 11:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgBEKTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 05:19:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44901 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727068AbgBEKTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 05:19:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580897985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=x7meg38MKtijGXRTHPEaSDs6h9nv3HE6yGYEcRdm//I=;
        b=RYykSmCWvzPFqs5h+Ono4uhkKoMjBzu/jM89AuIAy0sDG5lDbeNWrlvEoPgyi9tI+a1DUU
        rLX5OnbE/1l7Rw31sX5YnOWVNlxZGnSuHsR2fAveRUP3oXfFVuSQr+SLoklCzfk+w60tGx
        YrLtJQfeLEuwVZaf921N0EaBLH105LI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-l8dsE0TiN5yLz9_gEWufbA-1; Wed, 05 Feb 2020 05:19:44 -0500
X-MC-Unique: l8dsE0TiN5yLz9_gEWufbA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C12C1835A01;
        Wed,  5 Feb 2020 10:19:43 +0000 (UTC)
Received: from thuth.com (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5A368DC09;
        Wed,  5 Feb 2020 10:19:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH] Add Janosch as a s390x maintainer
Date:   Wed,  5 Feb 2020 11:19:35 +0100
Message-Id: <20200205101935.19219-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both, David and I, often do not have as much spare time for the
kvm-unit-tests as we would like to have, so we could use a little
bit of additional help here. Janosch did some excellent work for
the s390x kvm-unit-tests in the past months and is listed as reviewer
for these patches since quite a while already, so he's a very well
suited for the maintainer job here, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
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
-- 
2.18.1

