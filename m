Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6A0277667
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgIXQQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726815AbgIXQQh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=X3I8HQJdorldZH9Gq+yptK0JPlaibQ/8bGz4iMDDXZY=;
        b=JuG6VYPiYdRh6y/P7+IllItQH6HhuDUbSTCik6cdVedJcg3bzg4AsbWOptp2gq+e1LnNHl
        tnsboH2vXyoTT78EaOu66FqSWZXMDmpOjwqYB6tC91zZ8Dy+Kb46eF5GbTbT8xi0LEoEip
        r54H0EWIBYr6wstts5TkV3tSshMPxA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-thY9wklHO3en_15yj5R4Vw-1; Thu, 24 Sep 2020 12:16:33 -0400
X-MC-Unique: thY9wklHO3en_15yj5R4Vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEACC84E247;
        Thu, 24 Sep 2020 16:16:32 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B9F273662;
        Thu, 24 Sep 2020 16:16:30 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 3/9] travis.yml: Refresh the x86 32-bit test list
Date:   Thu, 24 Sep 2020 18:16:06 +0200
Message-Id: <20200924161612.144549-4-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the new QEMU from Ubuntu Focal, we can now run additional
tests that were failing before.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 4c35509..01951dc 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -43,8 +43,9 @@ jobs:
       env:
       - CONFIG="--arch=i386"
       - BUILD_DIR="."
-      - TESTS="asyncpf hyperv_stimer hyperv_synic kvmclock_test msr pmu realmode
-               s3 sieve smap smptest smptest3 taskswitch taskswitch2 tsc_adjust"
+      - TESTS="asyncpf hyperv_connections hyperv_stimer hyperv_synic
+          kvmclock_test msr pmu realmode s3 setjmp sieve smap smptest smptest3
+          taskswitch taskswitch2 tsc tsc_adjust"
       - ACCEL="kvm"
 
     - addons:
@@ -53,8 +54,9 @@ jobs:
       - CONFIG="--arch=i386"
       - BUILD_DIR="i386-builddir"
       - TESTS="cmpxchg8b tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ipi_halt
-               vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
-               vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall setjmp"
+          vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
+          vmexit_inl_pmtimer vmexit_tscdeadline vmexit_tscdeadline_immed
+          vmexit_vmcall"
       - ACCEL="kvm"
 
     - addons:
-- 
2.18.2

