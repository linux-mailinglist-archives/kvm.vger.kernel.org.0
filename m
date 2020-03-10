Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA0517F340
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 10:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCJJQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 05:16:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35528 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726205AbgCJJQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 05:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583831767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s05C/YvWsTJ9Ho/uMXOcY/OoycpWuoeOVEWtOZICQtA=;
        b=QQWLBOFUOE8dfStOU0rzB41XMpgdH3sxYel6hAcc9ELE7TFA+l6Q6xdA0C7udtNon8YIBP
        glS93ERk5H+tiKrXNoAgCXXFqF4KlVJEVl2ovSFpKuSTg/a4JyDD+Dr0WDig70DUgs1yNa
        wm7IZDoeabDaCz24oqYjYtUf1FSZrm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-Y6JvnMlUPu6uJD4-GUa9Xw-1; Tue, 10 Mar 2020 05:16:06 -0400
X-MC-Unique: Y6JvnMlUPu6uJD4-GUa9Xw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3D02800D4E;
        Tue, 10 Mar 2020 09:16:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F8BD60C05;
        Tue, 10 Mar 2020 09:15:57 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        thuth@redhat.com
Subject: [PATCH 0/4] KVM: selftests: Various cleanups and fixes
Date:   Tue, 10 Mar 2020 10:15:52 +0100
Message-Id: <20200310091556.4701-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones (4):
  fixup! selftests: KVM: SVM: Add vmcall test
  KVM: selftests: Share common API documentation
  KVM: selftests: Enable printf format warnings for TEST_ASSERT
  KVM: selftests: Use consistent message for test skipping

 tools/testing/selftests/kvm/.gitignore        |   5 +-
 .../selftests/kvm/demand_paging_test.c        |   6 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 100 ++++++++-
 .../testing/selftests/kvm/include/test_util.h |   5 +-
 .../selftests/kvm/lib/aarch64/processor.c     |  17 --
 tools/testing/selftests/kvm/lib/assert.c      |   6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  10 +-
 .../selftests/kvm/lib/kvm_util_internal.h     |  48 +++++
 .../selftests/kvm/lib/s390x/processor.c       |  74 -------
 tools/testing/selftests/kvm/lib/test_util.c   |  12 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 196 ++++--------------
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   2 +-
 tools/testing/selftests/kvm/s390x/memop.c     |   2 +-
 .../selftests/kvm/s390x/sync_regs_test.c      |   2 +-
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |   2 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |   6 +-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |   8 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c  |   4 +-
 .../selftests/kvm/x86_64/platform_info_test.c |   3 +-
 .../kvm/x86_64/set_memory_region_test.c       |   3 +-
 .../testing/selftests/kvm/x86_64/state_test.c |   4 +-
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |   3 +-
 .../selftests/kvm/x86_64/sync_regs_test.c     |   4 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   2 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c    |   4 +-
 .../selftests/kvm/x86_64/xss_msr_test.c       |   2 +-
 28 files changed, 243 insertions(+), 292 deletions(-)

--=20
2.21.1

