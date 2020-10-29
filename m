Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DAD29F5FB
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 21:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgJ2URW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 16:17:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbgJ2URW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 16:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604002641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ltpz2/Hz4oVkjN93TuB3I8u7KEjzYrl7GXEUqyfdxy8=;
        b=HG0kIHgYb2QCmrdHvydHadIsrq9LVqD+UxQofPeHJ2y31sKUPj8ANb2Y4oRTTiOiedxv0/
        NULv6Xc4Z+i4jTJHmjGCp87dqeFhpiP9K9P/tb6QYSCN7NLDcOzvjFqzTRfhgefUjRuOs/
        jSitBPkReCGrI5bnpRPmrinnv5xrDwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-xK6RrBBtMOuLHZ5DUdairw-1; Thu, 29 Oct 2020 16:17:12 -0400
X-MC-Unique: xK6RrBBtMOuLHZ5DUdairw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 601EF8030A0;
        Thu, 29 Oct 2020 20:17:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5DA66EF6D;
        Thu, 29 Oct 2020 20:17:04 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org, eric.auger@redhat.com
Subject: [PATCH 0/4] KVM: selftests: Add get-reg-list regression test
Date:   Thu, 29 Oct 2020 21:16:59 +0100
Message-Id: <20201029201703.102716-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since Eric complained in his KVM Forum talk that there weren't any
aarch64-specific KVM selftests, now he gets to review one. This test
was inspired by recent regression report about get-reg-list losing
a register between an old kernel version and a new one.

Thanks,
drew


Andrew Jones (4):
  KVM: selftests: Don't require THP to run tests
  KVM: selftests: Add aarch64 get-reg-list test
  KVM: selftests: Update aarch64 get-reg-list blessed list
  KVM: selftests: Add blessed SVE registers to get-reg-list

 tools/testing/selftests/kvm/.gitignore        |   2 +
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 +
 .../selftests/kvm/aarch64/get-reg-list.c      | 841 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  52 +-
 6 files changed, 894 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list.c

-- 
2.27.0

