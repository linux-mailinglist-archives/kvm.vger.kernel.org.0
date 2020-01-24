Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E46148B5A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 16:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388639AbgAXPhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 10:37:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388568AbgAXPhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 10:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579880261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Brgw6GVwy3CvgHQuefLbql5hhy8ODrGyqdPirPSGpyQ=;
        b=JxNPj6PJF+6tGD3pds9gTd1jhZUfxsxrhrHEpSYfSyE9e0/kOZw2kOCW+zfHH0BJG25Ubh
        eyadYAqxmGRGdQlEzDVp8EQB2BdOqGaXxBlj1pK66dJvObzk2iDN6I5vIelazIcLU5o3RM
        vS1fdAaLBGgqNiLK6I1g/yJk4IRjmJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-M2yXUG6rOFq1gU3qzpsirQ-1; Fri, 24 Jan 2020 10:37:38 -0500
X-MC-Unique: M2yXUG6rOFq1gU3qzpsirQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BB52B1B73
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 15:37:29 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7120F1001B28;
        Fri, 24 Jan 2020 15:37:28 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/2] KVM: selftests: Rework debug message printing
Date:   Fri, 24 Jan 2020 16:37:24 +0100
Message-Id: <20200124153726.15455-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix some issues with how we output debug and info messages.

Andrew Jones (2):
  KVM: selftests: Rework debug message printing
  KVM: selftests: Convert some printf's to pr_info's

 tools/testing/selftests/kvm/dirty_log_test.c     | 16 +++++++++-------
 tools/testing/selftests/kvm/include/kvm_util.h   | 13 ++++++++++---
 .../testing/selftests/kvm/kvm_create_max_vcpus.c |  8 ++++----
 .../selftests/kvm/lib/aarch64/processor.c        |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c       |  7 ++++---
 .../selftests/kvm/x86_64/mmio_warning_test.c     |  2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c    |  2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c  |  2 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c   |  4 ++--
 .../testing/selftests/kvm/x86_64/xss_msr_test.c  |  2 +-
 10 files changed, 34 insertions(+), 24 deletions(-)

--=20
2.21.1

