Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA4A114554
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 18:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfLEREr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 12:04:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43029 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726028AbfLEREq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 12:04:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575565485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=16IYc5dS6zYO/z7QMm0aTUaEXtYpTed94MKFrF8nPi0=;
        b=CaTmBXyYZykR1f9h4HaF3Q5KlvU66DErScSwWNAX2SQ1o13MFkivDKeRb+lH0P50ZmAs2I
        n1/bs52t21iN8OvNQxZDd9ykOWrrM7jFLTqdZRsdw44CJkDoyZj2MHNGCRpa/AoD9TdHkZ
        rBsAkV6H/4Sf79yQF8fcR/wMlImyyFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-EU3TYODrN9K18sfHxsP0rw-1; Thu, 05 Dec 2019 12:04:44 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 528A889A084
        for <kvm@vger.kernel.org>; Thu,  5 Dec 2019 17:04:43 +0000 (UTC)
Received: from thuth.com (ovpn-116-87.ams2.redhat.com [10.36.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C70B77340;
        Thu,  5 Dec 2019 17:04:42 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] travis.yml: Run 32-bit tests with KVM, too
Date:   Thu,  5 Dec 2019 18:04:39 +0100
Message-Id: <20191205170439.11607-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: EU3TYODrN9K18sfHxsP0rw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM works on Travis in 32-bit, too, so we can enable more tests there.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 4162366..75bcf08 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -34,15 +34,19 @@ matrix:
       env:
       - CONFIG=3D"--arch=3Di386"
       - BUILD_DIR=3D"."
-      - TESTS=3D"eventinj port80 sieve tsc taskswitch umip vmexit_ple_roun=
d_robin"
+      - TESTS=3D"asyncpf hyperv_stimer hyperv_synic kvmclock_test msr pmu =
realmode
+               s3 sieve smap smptest smptest3 taskswitch taskswitch2 tsc_a=
djust"
+      - ACCEL=3D"kvm"
=20
     - addons:
         apt_packages: gcc gcc-multilib qemu-system-x86
       env:
       - CONFIG=3D"--arch=3Di386"
       - BUILD_DIR=3D"i386-builddir"
-      - TESTS=3D"vmexit_mov_from_cr8 vmexit_ipi vmexit_ipi_halt vmexit_mov=
_to_cr8
-               vmexit_cpuid vmexit_tscdeadline vmexit_tscdeadline_immed"
+      - TESTS=3D"tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ipi_halt
+               vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robi=
n
+               vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall"
+      - ACCEL=3D"kvm"
=20
     - addons:
         apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
--=20
2.18.1

