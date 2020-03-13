Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6A6184BD1
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 16:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgCMP4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 11:56:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbgCMP4x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 11:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584115012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nSUTvRWaOhf0z2idnkLURY3042WDleuJ2qFM+BOJcZk=;
        b=U+2zqxOZWlKHDVZRJyN4qmVB3u6+VkrBADnGw57idE0Vyt1wMWOopFPuL89dIG33jq5ixm
        AB4q8JaijxQ/WHt0movMQ9bgKGdscG8gfJ/hOERW7mUqLplX/fhsGnJrDcbhHja9jc6bsY
        7nI6U/ilz/kmS5q1csQkoxVumjwKSlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-XIVbZNo0NjGfp94PLpgu8w-1; Fri, 13 Mar 2020 11:56:50 -0400
X-MC-Unique: XIVbZNo0NjGfp94PLpgu8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA63D100726F
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 15:56:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C873993535;
        Fri, 13 Mar 2020 15:56:45 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/2] KVM: selftests: Introduce steal-time tests for x86_64 and AArch64
Date:   Fri, 13 Mar 2020 16:56:42 +0100
Message-Id: <20200313155644.29779-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test steal/stolen-time on x86 and AArch64 to make sure what gets
reported to the guest is consistent with run-delay.

The first patch of this series is just kvm selftests API cleanup. The
series is based on kvm/queue and some in-flight patches that are also
based on kvm/queue
 KVM: selftests: Share common API documentation
 KVM: selftests: Enable printf format warnings for TEST_ASSERT
 KVM: selftests: Use consistent message for test skipping
 KVM: selftests: s390x: Provide additional num-guest-pages adjustment

Thanks,
drew


Andrew Jones (2):
  KVM: selftests: virt_map should take npages, not size
  KVM: selftests: Introduce steal-time test

 tools/testing/selftests/kvm/.gitignore        |   2 +
 tools/testing/selftests/kvm/Makefile          |  12 +-
 .../selftests/kvm/demand_paging_test.c        |   3 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   7 +-
 .../testing/selftests/kvm/include/test_util.h |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +-
 tools/testing/selftests/kvm/lib/test_util.c   |  15 +
 tools/testing/selftests/kvm/steal_time.c      | 352 ++++++++++++++++++
 .../kvm/x86_64/set_memory_region_test.c       |   2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  11 +-
 11 files changed, 401 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/steal_time.c

--=20
2.21.1

