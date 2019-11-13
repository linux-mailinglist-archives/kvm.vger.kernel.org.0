Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4281FAFA7
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 12:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfKML1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 06:27:03 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53000 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727733AbfKML1C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 06:27:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573644421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d6Riu+/ym+X+cIktyE0yWSvwwZI/0+zJLjKnzOMk7Hw=;
        b=esns6A4a18lSwEOwaSIBh7mruK5zGCNh1jRdVixu2XTgic+vhvYR101Y59Ph1OQNX7NHSB
        N++8s4Udq3CNo6yqpPSQR5JhzdKsh0WtepsrPPzVgfUwnyb1fnb6cgmI+/cKUJoBLQYY5k
        +vWXJLCPaSWRdFGTTeQiBqo6l8m+rpo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-gv5n0D3tOR6tk2aQof73Ig-1; Wed, 13 Nov 2019 06:27:00 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 527691005509;
        Wed, 13 Nov 2019 11:26:59 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38F0D60464;
        Wed, 13 Nov 2019 11:26:56 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-test PATCH 1/5] travis.yml: Re-arrange the test matrix
Date:   Wed, 13 Nov 2019 12:26:45 +0100
Message-Id: <20191113112649.14322-2-thuth@redhat.com>
In-Reply-To: <20191113112649.14322-1-thuth@redhat.com>
References: <20191113112649.14322-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: gv5n0D3tOR6tk2aQof73Ig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will soon need more control over the individual test matrix
entries, so we should not limit the matrix to "env" sections,
i.e. put the "matrix:" keyword on the top, not the "env:".

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 92 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 36 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 6c14953..611bbdc 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -16,44 +16,64 @@ addons:
       - qemu-system
 git:
   submodules: false
-env:
-  matrix:
-    - CONFIG=3D""
-      BUILD_DIR=3D"."
-      TESTS=3D"vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_i=
pi
+
+matrix:
+  include:
+    - env:
+      - CONFIG=3D""
+      - BUILD_DIR=3D"."
+      - TESTS=3D"vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit=
_ipi
              vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_=
immed"
-    - CONFIG=3D""
-      BUILD_DIR=3D"x86-builddir"
-      TESTS=3D"ioapic-split ioapic smptest smptest3 eventinj msr port80 sy=
scall
+
+    - env:
+      - CONFIG=3D""
+      - BUILD_DIR=3D"x86-builddir"
+      - TESTS=3D"ioapic-split ioapic smptest smptest3 eventinj msr port80 =
syscall
              tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_ipi=
_halt"
-    - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
-      BUILD_DIR=3D"."
-      TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-smp"
-    - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
-      BUILD_DIR=3D"arm-buildir"
-      TESTS=3D"pci-test pmu gicv2-active gicv3-active psci selftest-setup"
-    - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
-      BUILD_DIR=3D"."
-      TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-smp"
-    - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
-      BUILD_DIR=3D"arm64-buildir"
-      TESTS=3D"pci-test pmu gicv2-active gicv3-active psci timer selftest-=
setup"
-    - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerpc6=
4le-linux-gnu-"
-      BUILD_DIR=3D"."
-      TESTS=3D"spapr_hcall emulator rtas-set-time-of-day"
-      ACCEL=3D"tcg,cap-htm=3Doff"
-    - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerpc6=
4le-linux-gnu-"
-      BUILD_DIR=3D"ppc64le-buildir"
-      TESTS=3D"rtas-get-time-of-day rtas-get-time-of-day-base"
-      ACCEL=3D"tcg,cap-htm=3Doff"
-    - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
-      BUILD_DIR=3D"."
-      TESTS=3D"diag10 diag308"
-      ACCEL=3D"tcg,firmware=3Ds390x/run"
-    - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
-      BUILD_DIR=3D"s390x-builddir"
-      TESTS=3D"sieve"
-      ACCEL=3D"tcg,firmware=3Ds390x/run"
+
+    - env:
+      - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
+      - BUILD_DIR=3D"."
+      - TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-sm=
p"
+
+    - env:
+      - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
+      - BUILD_DIR=3D"arm-buildir"
+      - TESTS=3D"pci-test pmu gicv2-active gicv3-active psci selftest-setu=
p"
+
+    - env:
+      - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
+      - BUILD_DIR=3D"."
+      - TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-sm=
p"
+
+    - env:
+      - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
+      - BUILD_DIR=3D"arm64-buildir"
+      - TESTS=3D"pci-test pmu gicv2-active gicv3-active psci timer selftes=
t-setup"
+
+    - env:
+      - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerp=
c64le-linux-gnu-"
+      - BUILD_DIR=3D"."
+      - TESTS=3D"spapr_hcall emulator rtas-set-time-of-day"
+      - ACCEL=3D"tcg,cap-htm=3Doff"
+
+    - env:
+      - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerp=
c64le-linux-gnu-"
+      - BUILD_DIR=3D"ppc64le-buildir"
+      - TESTS=3D"rtas-get-time-of-day rtas-get-time-of-day-base"
+      - ACCEL=3D"tcg,cap-htm=3Doff"
+
+    - env:
+      - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
+      - BUILD_DIR=3D"."
+      - TESTS=3D"diag10 diag308"
+      - ACCEL=3D"tcg,firmware=3Ds390x/run"
+
+    - env:
+      - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
+      - BUILD_DIR=3D"s390x-builddir"
+      - TESTS=3D"sieve"
+      - ACCEL=3D"tcg,firmware=3Ds390x/run"
=20
 before_script:
   - mkdir -p $BUILD_DIR && cd $BUILD_DIR
--=20
2.23.0

