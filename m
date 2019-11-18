Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A835D10021B
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfKRKI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47336 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726911AbfKRKI3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 05:08:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJtIoVFxnvQq0GiDnYNrdlkt26kdN31589zuSnD4DfY=;
        b=QTPTv3a+J22F+qJcutAfTIodxQLKM1ik/S3bxHajsIpewXw/MxujHXNCOC+sMz4jZyvzGS
        3YRlU2BZeAuD7+mFLcZvWt6zWG5OzEZT8Cg91sBekC29DrgaCSwsM0ZlGSPLie6kZ5kMHx
        i6omKJFcx0rqOmZmt7hVdPsZM2RX3Mc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-qTlVN3wwNOWmjIDDy7Sq-w-1; Mon, 18 Nov 2019 05:08:26 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2002B802482;
        Mon, 18 Nov 2019 10:08:25 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3990466856;
        Mon, 18 Nov 2019 10:08:23 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 08/12] travis.yml: Re-arrange the test matrix
Date:   Mon, 18 Nov 2019 11:07:15 +0100
Message-Id: <20191118100719.7968-9-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: qTlVN3wwNOWmjIDDy7Sq-w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

We will soon need more control over the individual test matrix
entries, so we should not limit the matrix to "env" sections,
i.e. put the "matrix:" keyword on the top, not the "env:".

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Message-Id: <20191113112649.14322-2-thuth@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
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
2.21.0

