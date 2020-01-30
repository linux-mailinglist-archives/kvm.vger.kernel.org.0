Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C4C14DB4E
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgA3NLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:11:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27982 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727238AbgA3NLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:11:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XBMa3GA9+Z69J+0qyMG4e8UDKuY5yp6ewHjpP4yVla4=;
        b=XqXR1qU3+98B8o3I3drqHO7/Fb/GB71gRf249GZbu0ph95z1+web3tSWfpmqVhw42IFZKR
        Qoj7/IXXQnRrSxpxMFwCx7oRwScg7dPgib86LmJ3FLm9+Jw+LQeOJRVHmPC5uVgK9hXsaG
        apT6TUuOCGlh2r/m0RRddv1gH8pgJ2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-0HfNKhCdNqCniYDeJ-Kl5A-1; Thu, 30 Jan 2020 08:11:25 -0500
X-MC-Unique: 0HfNKhCdNqCniYDeJ-Kl5A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E51728017CC;
        Thu, 30 Jan 2020 13:11:24 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-219.ams2.redhat.com [10.36.117.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F30977927;
        Thu, 30 Jan 2020 13:11:17 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PULL 0/6] s390x updates
Date:   Thu, 30 Jan 2020 14:11:10 +0100
Message-Id: <20200130131116.12386-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

The following changes since commit f2606a873e805f9aff4c4879ec75e65d7e30af=
73:

  Makefile: Compile the kvm-unit-tests with -fno-strict-aliasing (2020-01=
-22 16:29:43 +0100)

are available in the Git repository at:

  https://github.com/davidhildenbrand/kvm-unit-tests.git tags/s390x-2020-=
01-30

for you to fetch changes up to 1cbda07c1cc63589686048866ee24459c38c42f5:

  s390x: SCLP unit test (2020-01-24 09:47:00 +0100)

----------------------------------------------------------------
Add new SCLP unit test

----------------------------------------------------------------
Claudio Imbrenda (6):
      s390x: export sclp_setup_int
      s390x: sclp: add service call instruction wrapper
      s390x: lib: fix stfl wrapper asm
      s390x: lib: add SPX and STPX instruction wrapper
      s390x: lib: fix program interrupt handler if sclp_busy was set
      s390x: SCLP unit test

 lib/s390x/asm/arch_def.h |  26 +++
 lib/s390x/asm/facility.h |   2 +-
 lib/s390x/interrupt.c    |   5 +-
 lib/s390x/sclp.c         |   9 +-
 lib/s390x/sclp.h         |   1 +
 s390x/Makefile           |   1 +
 s390x/intercept.c        |  24 +--
 s390x/sclp.c             | 479 +++++++++++++++++++++++++++++++++++++++++=
++++++
 s390x/unittests.cfg      |   8 +
 9 files changed, 531 insertions(+), 24 deletions(-)
 create mode 100644 s390x/sclp.c

--=20
2.24.1

