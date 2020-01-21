Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350F1143DC6
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgAUNRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:17:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30834 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725890AbgAUNRv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 08:17:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579612670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+rAyWKaOF4V9iHT89mVBFivCzH/4/gOEkg/nXvfYvIk=;
        b=NczZE8NOAl3OgBFMgR4TLonq4gN5taQlJxvJXbRla0tC27N230D2iqm91trAj4qimswKYk
        DrU/5eMwJqIQxw8OksrbR2NltfaHhDIZCXfmbZS2QNpFVZ5rqH9yHdaQPWbjW6E8aIRPZa
        ww3MmOIN2nBdu/1pu/F9gYh8eRf+KMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-Ckho5A-dPTu5xvpmp4WBxA-1; Tue, 21 Jan 2020 08:17:49 -0500
X-MC-Unique: Ckho5A-dPTu5xvpmp4WBxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1396100550E;
        Tue, 21 Jan 2020 13:17:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A38E410002A2;
        Tue, 21 Jan 2020 13:17:46 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com
Subject: [PULL kvm-unit-tests 0/3] arm/arm64: Add prefetch abort test
Date:   Tue, 21 Jan 2020 14:17:42 +0100
Message-Id: <20200121131745.7199-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 3c13c64209599d16c1b04655144af5097aabb8=
57:

  Merge branch 'arm/queue' of https://github.com/rhdrjones/kvm-unit-tests=
 into HEAD (2020-01-08 16:39:22 +0100)

are available in the Git repository at:

  https://github.com/rhdrjones/kvm-unit-tests arm/queue

for you to fetch changes up to cf251b7106d54ef239ad0f34a3dbc9716b9f9ffe:

  arm/arm64: selftest: Add prefetch abort test (2020-01-13 13:31:49 +0100=
)

Thanks,
drew

----------------------------------------------------------------
Andrew Jones (3):
      arm/arm64: Improve memory region management
      arm/arm64: selftest: Allow test_exception clobber list to be extend=
ed
      arm/arm64: selftest: Add prefetch abort test

 arm/selftest.c      | 199 ++++++++++++++++++++++++++++++++++++++--------=
------
 lib/arm/asm/setup.h |   8 ++-
 lib/arm/mmu.c       |  24 ++-----
 lib/arm/setup.c     |  56 +++++++++++----
 lib/arm64/asm/esr.h |   3 +
 5 files changed, 203 insertions(+), 87 deletions(-)

--=20
2.21.1

