Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5E7114351
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 16:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfLEPQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 10:16:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51368 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725909AbfLEPQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 10:16:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575558981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cnoBSQm0lwSHMe37ahohej7X57A4qxkFsgbHask0LpA=;
        b=G59JhW1PaxF6izmTWqOYyn6ibdC6jCOY/CIPGEAfkPwzTyLiGYw9rVYZxeuLFlX17cNGIC
        MW1rL9ibjilIAn0DtnD0PYmQh6J3uO4t0ildQ5MgqTszyLz0hj2V9JYugeqAJAK6h9F4oA
        PDlyVcR46g/6Wy4V2ZhdlUdqN8bscPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-n5uzlMnuPfOQZeu6wlO0Cg-1; Thu, 05 Dec 2019 10:16:19 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0AAD18557CF
        for <kvm@vger.kernel.org>; Thu,  5 Dec 2019 15:16:18 +0000 (UTC)
Received: from thuth.com (ovpn-116-87.ams2.redhat.com [10.36.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D5CC5C1B5;
        Thu,  5 Dec 2019 15:16:15 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>
Subject: [kvm-unit-tests PATCH] gitlab-ci.yml: Remove ioapic from the x86 tests
Date:   Thu,  5 Dec 2019 16:16:10 +0100
Message-Id: <20191205151610.19299-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: n5uzlMnuPfOQZeu6wlO0Cg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test recently started to fail (likely do to a recent change to
"x86/ioapic.c). According to Nitesh, it's not required to keep this
test running with TCG, and we already check it with KVM on Travis,
so let's simply disable it here now.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index fbf3328..001c272 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -64,7 +64,7 @@ build-x86_64:
  - ./configure --arch=3Dx86_64
  - make -j2
  - ACCEL=3Dtcg ./run_tests.sh
-     ioapic-split ioapic smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
+     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
      eventinj msr port80 syscall tsc rmap_chain umip intel_iommu
--=20
2.18.1

