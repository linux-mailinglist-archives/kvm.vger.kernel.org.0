Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD7FB0CE
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKMMvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:51:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22546 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725908AbfKMMvV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 07:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573649480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AEYP6d5aalZAfcFv0NrW7o6lXGeRFq/9ZDlpjwAiWdQ=;
        b=Qv+QCjhnD0UYP1bY+Kn48W8Oq7s9S8TJhyjSW1zZuujL9TXIx9/zIIG+waOwfzar/822JM
        KYJHDl19bNL5B5XRx32Z1tO5s4pURIIQWDnXimGAwxXD6ljIKzPHlz3YSYd7ZfPtfqYl7/
        pu1ZYZNjyxIEYkbfn3qmvIC7qwLlN6I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-y6qiLg7VOXSE0hHxz9-XTw-1; Wed, 13 Nov 2019 07:51:19 -0500
Received: by mail-wr1-f70.google.com with SMTP id c16so1560134wro.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 04:51:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=miLVHytVLBaZY4qRF4Hh54R/kGdync3E1wgmyFgh4so=;
        b=BRL+covJS63WbcxaMyZlCtyhZI2LxwUP14IP+QSt7vM1xCYsKBXJGn+fWA8s6TOcOH
         s9Nrx+EpzTZAxqbdJHoqa2tOePICmxm3Ppmh4F+eN3mOypuuBpr4NVHrRrQIpj7GcvIk
         wYr0iiVUqjyQbJgZlHcuRn8+8t5GZtPE0dB/MsYfk1TbehH3bDU1G/GeNyozBEF3CEB5
         fOIL2U7QHKgBKql1/ztuGuTpauo6FctTifpA0IUl2QI2dThdrAzCxw9ueWiV7+aTwkH4
         NMVJ532nwv1MdSxcLVjSSN8GsUjHa+QGTDMI5Q5Lov+WeDx/EW612QcVZvm+Hs8eGSUg
         HO6Q==
X-Gm-Message-State: APjAAAVySW/Zuug2/GBZz7as1M4tNGqjRJGjo2AGcSKxLHXc3PPslByn
        0Y0SHL+MEz8OguiLZk0O6G3VNJ94419I6jcHtswDUHSef4QTA2TuFHaASlyWDug4Qvgr0b5mg6I
        utbDR3yo9trlR
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr2582106wrj.391.1573649477835;
        Wed, 13 Nov 2019 04:51:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqwqi8MVjGYsZE1Fd2uuOZsh+3k4ruvI3QhtSRwtPfnv/LsKOAMb2NX00BIk78fbl0gKHRqQHQ==
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr2582087wrj.391.1573649477582;
        Wed, 13 Nov 2019 04:51:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u26sm2207436wmj.9.2019.11.13.04.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 04:51:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] selftests: kvm: fix build with glibc >= 2.30
Date:   Wed, 13 Nov 2019 13:51:15 +0100
Message-Id: <20191113125115.23100-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-MC-Unique: y6qiLg7VOXSE0hHxz9-XTw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Glibc-2.30 gained gettid() wrapper, selftests fail to compile:

lib/assert.c:58:14: error: static declaration of =E2=80=98gettid=E2=80=99 f=
ollows non-static declaration
   58 | static pid_t gettid(void)
      |              ^~~~~~
In file included from /usr/include/unistd.h:1170,
                 from include/test_util.h:18,
                 from lib/assert.c:10:
/usr/include/bits/unistd_ext.h:34:16: note: previous declaration of =E2=80=
=98gettid=E2=80=99 was here
   34 | extern __pid_t gettid (void) __THROW;
      |                ^~~~~~

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/lib/assert.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selft=
ests/kvm/lib/assert.c
index 4911fc77d0f6..d1cf9f6e0e6b 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -55,7 +55,7 @@ static void test_dump_stack(void)
 #pragma GCC diagnostic pop
 }
=20
-static pid_t gettid(void)
+static pid_t _gettid(void)
 {
 =09return syscall(SYS_gettid);
 }
@@ -72,7 +72,7 @@ test_assert(bool exp, const char *exp_str,
 =09=09fprintf(stderr, "=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D\n"
 =09=09=09"  %s:%u: %s\n"
 =09=09=09"  pid=3D%d tid=3D%d - %s\n",
-=09=09=09file, line, exp_str, getpid(), gettid(),
+=09=09=09file, line, exp_str, getpid(), _gettid(),
 =09=09=09strerror(errno));
 =09=09test_dump_stack();
 =09=09if (fmt) {
--=20
2.20.1

