Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC9611A7A4
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 10:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfLKJmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 04:42:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28980 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728605AbfLKJmf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 04:42:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576057354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kVF+fz1ywtiAYHxQZ2KvFTuGKQt/bQcp8p2wEMicvdo=;
        b=GcMdXq73EAxOSZkhSRnP/H+jn6k7a6a4pIqdxs65O7bJ94P+bfghbbgNdwCrL8eJI4coAb
        NM2DdM+IdkL/0A0dx98RV47w22EfnQPoxbG/k3pfyu5Yks66f1zaPV7/NJmr+EhciGa1T1
        zMJVpz2yWGToSxS0YP+11hc3bS8S880=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-zTJgb5QKPvmALwIzM7kvOg-1; Wed, 11 Dec 2019 04:42:32 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CA7C1005510
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 09:42:31 +0000 (UTC)
Received: from thuth.com (ovpn-117-11.ams2.redhat.com [10.36.117.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB5B463629;
        Wed, 11 Dec 2019 09:42:30 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 4/4] x86: Add the cmpxchg8b test to the CI
Date:   Wed, 11 Dec 2019 10:42:21 +0100
Message-Id: <20191211094221.7030-5-thuth@redhat.com>
In-Reply-To: <20191211094221.7030-1-thuth@redhat.com>
References: <20191211094221.7030-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: zTJgb5QKPvmALwIzM7kvOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an entry for this test to the unittests.cfg file and
enable it in the CI pipelines.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml    | 2 +-
 .travis.yml       | 2 +-
 x86/unittests.cfg | 4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index ea1aeaf..67f7d80 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -77,6 +77,6 @@ build-i386:
  - ./configure --arch=3Di386
  - make -j2
  - ACCEL=3Dtcg ./run_tests.sh
-     eventinj port80 setjmp sieve tsc taskswitch taskswitch2 umip
+     cmpxchg8b eventinj port80 setjmp sieve tsc taskswitch taskswitch2 umi=
p
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
diff --git a/.travis.yml b/.travis.yml
index 53f8d7d..091d071 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -43,7 +43,7 @@ matrix:
       env:
       - CONFIG=3D"--arch=3Di386"
       - BUILD_DIR=3D"i386-builddir"
-      - TESTS=3D"tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ipi_halt
+      - TESTS=3D"cmpxchg8b tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ip=
i_halt
                vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robi=
n
                vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall s=
etjmp"
       - ACCEL=3D"kvm"
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index acdde10..51e4ba5 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -49,6 +49,10 @@ smp =3D 4
 extra_params =3D -cpu qemu64
 arch =3D x86_64
=20
+[cmpxchg8b]
+file =3D cmpxchg8b.flat
+arch =3D i386
+
 [smptest]
 file =3D smptest.flat
 smp =3D 2
--=20
2.18.1

