Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC5C10020F
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKRKHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:07:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60130 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726460AbfKRKHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 05:07:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8Ugn3Cz/f8rnjt3uw+r8vxX5hhvE9eXGQ0OTfbBMuGo=;
        b=MrGaIBzNZTYh8JAJ7ugG14CgFiCeAXeYsekWG+ai80L7BmD0tytg6Pbyo4eYmsQcZznj3i
        zQOWRDSAEYN7a316aoH0uLtRHyCMyEXQIV9jVBgnJciKfE7Q1+FZcmVrvxThDRnLyIzrU4
        KHaPxh2u4Ypsv9yeOLiTvvdd/q51ZKg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-QQJwjIcHPMG9jhU1yRwWkQ-1; Mon, 18 Nov 2019 05:07:33 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66A4C802481;
        Mon, 18 Nov 2019 10:07:32 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B977675E30;
        Mon, 18 Nov 2019 10:07:20 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 00/12] s390x and Travis CI updates
Date:   Mon, 18 Nov 2019 11:07:07 +0100
Message-Id: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: QQJwjIcHPMG9jhU1yRwWkQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

The following changes since commit af8dfe97b47d03876041506e8b38f718914aeea4=
:

  x86/unittests.cfg: Increase the timeout of the sieve test to 180s (2019-1=
1-15 15:56:19 +0100)

are available in the Git repository at:

  https://github.com/davidhildenbrand/kvm-unit-tests.git tags/s390x-2019-11=
-18

for you to fetch changes up to c71d8a9fab524269785d688eb0db7f6391b5510c:

  travis.yml: Expect that at least one test succeeds (2019-11-18 10:47:27 +=
0100)

----------------------------------------------------------------
Cleanups and bugfixes (especially to make the tests run natively under
LPAR). Travis CI improvements (e.g., x86 support, KVM support on x86_64).

----------------------------------------------------------------
Claudio Imbrenda (3):
  s390x: remove redundant defines
  s390x: improve error reporting for interrupts
  s390x: sclp: expose ram_size and max_ram_size

Janosch Frank (4):
  s390x: Use loop to save and restore fprs
  s390x: Fix initial cr0 load comments
  s390x: Add CR save area
  s390x: Load reset psw on diag308 reset

Thomas Huth (5):
  travis.yml: Re-arrange the test matrix
  travis.yml: Install only the required packages for each entry in the
    matrix
  travis.yml: Test with KVM instead of TCG (on x86)
  travis.yml: Test the i386 build, too
  travis.yml: Expect that at least one test succeeds

 .travis.yml              | 156 ++++++++++++++++++++++++++-------------
 lib/s390x/asm-offsets.c  |   3 +-
 lib/s390x/asm/arch_def.h |   6 +-
 lib/s390x/interrupt.c    |   8 +-
 lib/s390x/sclp.c         |  10 +++
 lib/s390x/sclp.h         |   4 +-
 lib/s390x/smp.c          |   2 +-
 s390x/cstart64.S         |  76 ++++++++-----------
 8 files changed, 158 insertions(+), 107 deletions(-)

--=20
2.21.0

