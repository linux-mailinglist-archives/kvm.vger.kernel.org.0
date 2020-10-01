Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB43627FA20
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbgJAHWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:22:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgJAHWp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:22:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601536963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=aCGPvWUx7E7rUnKJq6XsZzdK2CK3flcGFSH/VuFta/4=;
        b=bpB8nc+HXmWLloChulmP1ZaDrQBLVCTNXzZlG5+nINE+cM/Ezqk7KBhgrL9npjTbBBxzia
        U+p7sh/PBEifyBsIIToQWMQVMKVg2iT7pxyxyzJgmnG/Fb6si0rdJbM3SmR6n7iGsHhMmk
        3fsGBVz6WbQZDI3qyhcGPbY0wwcaxxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-3HW-uZKaPVyuNPru6_dw3Q-1; Thu, 01 Oct 2020 03:22:42 -0400
X-MC-Unique: 3HW-uZKaPVyuNPru6_dw3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 570BB425D8
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 07:22:41 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ABA860BF1;
        Thu,  1 Oct 2020 07:22:39 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, lvivier@redhat.com
Subject: [PATCH v2 2/7] travis.yml: Refresh the x86 32-bit test list
Date:   Thu,  1 Oct 2020 09:22:29 +0200
Message-Id: <20201001072234.143703-3-thuth@redhat.com>
In-Reply-To: <20201001072234.143703-1-thuth@redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the new QEMU from Ubuntu Focal, we can now run additional
tests that were failing before.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 0feaec1..5cd6dbf 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -43,8 +43,8 @@ jobs:
       env:
       - CONFIG="--arch=i386"
       - BUILD_DIR="."
-      - TESTS="asyncpf hyperv_stimer hyperv_synic kvmclock_test msr pmu realmode
-               s3 sieve smap smptest smptest3 taskswitch taskswitch2 tsc_adjust"
+      - TESTS="asyncpf kvmclock_test msr pmu realmode s3 setjmp sieve smap
+          smptest smptest3 taskswitch taskswitch2 tsc tsc_adjust tsx-ctrl umip"
       - ACCEL="kvm"
 
     - addons:
@@ -52,9 +52,9 @@ jobs:
       env:
       - CONFIG="--arch=i386"
       - BUILD_DIR="i386-builddir"
-      - TESTS="cmpxchg8b tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ipi_halt
-               vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
-               vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall setjmp"
+      - TESTS="cmpxchg8b vmexit_vmcall vmexit_cpuid vmexit_ipi vmexit_ipi_halt
+          vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
+          vmexit_inl_pmtimer vmexit_tscdeadline vmexit_tscdeadline_immed"
       - ACCEL="kvm"
 
     - addons:
-- 
2.18.2

