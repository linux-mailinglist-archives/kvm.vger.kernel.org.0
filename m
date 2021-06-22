Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0018E3B0648
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 15:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhFVN5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 09:57:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbhFVN5p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 09:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624370128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I4vXGfb12olPaNZAsZiiv1VuvejH/tkrBwhicf+ya/w=;
        b=ER5Rtx/PRdAdom/yUF6xM+ZqOoQuJ+Bht1/FBVZlt+8kxoDUPc8DIcmzNvm7SLm2zg0AIA
        z5bCIILIBg6IUd2zdlE/ivWJXyjisU3tDkV9g2sqxZTpkhWqWtVIahvhWFW4BnuXwypPlY
        QE/EYd2XVcYPNbBjb6Ns0ABV5q7TFB0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-8BXrqVyROi6P6O7aJKkCZQ-1; Tue, 22 Jun 2021 09:55:25 -0400
X-MC-Unique: 8BXrqVyROi6P6O7aJKkCZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2981101C8AA;
        Tue, 22 Jun 2021 13:55:23 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 871791899A;
        Tue, 22 Jun 2021 13:55:19 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH 0/4] Test compiling with Clang in the Travis-CI
Date:   Tue, 22 Jun 2021 15:55:13 +0200
Message-Id: <20210622135517.234801-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Travis-CI recently changed their policy so that builds on the non-x86
build machines are possible without consuming any credits again.
While we're already testing the non-x86 builds in the gitlab-CI with
the GCC cross-compilers, we could still benefit from the non-x86
builders in the Travis-CI by compiling the code with Clang there, too
(since there are AFAIK no Clang cross-compilers available in the usual
distros on x86).

Thomas Huth (4):
  configure: Add the possibility to specify additional cflags
  powerpc: Probe whether the compiler understands -mabi=no-altivec
  lib/s390x: Fix the epsw inline assembly
  Test compilation with Clang on aarch64, ppc64le and s390x in Travis-CI

 .travis.yml              | 44 ++++++++++++++++++++++++++++++++++++++++
 Makefile                 |  3 ---
 configure                | 10 +++++++--
 lib/s390x/asm/arch_def.h |  2 +-
 powerpc/Makefile.common  |  4 +++-
 5 files changed, 56 insertions(+), 7 deletions(-)
 create mode 100644 .travis.yml

-- 
2.27.0

