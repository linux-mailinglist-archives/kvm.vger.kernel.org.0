Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0127D100221
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKRKIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29623 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726918AbfKRKIu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 05:08:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F8vgWb5qUnWEwR+Fluif1KFc66Z2f+jFG4Lwyq0kh4Q=;
        b=RtDf8GxJefYYvnHkVi2jI4OQPB1tZ2AAbX3MN5GdFsW6EJcNSvGpa/hlmDAXARGvM5KpEL
        duEq04kc3Nh4Gs49991wMpY7SepwoeMb951Uax/jtgeVcUmDP3xlm6cWkChmBRk++cdTqm
        yCczknwiwByOqiJLKDqyeUf7XO5hZLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-iHNB-VPFPx6HIk7cGV9rzQ-1; Mon, 18 Nov 2019 05:08:35 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC780107ACC6;
        Mon, 18 Nov 2019 10:08:33 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A78766856;
        Mon, 18 Nov 2019 10:08:29 +0000 (UTC)
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
Subject: [kvm-unit-tests PULL 11/12] travis.yml: Test the i386 build, too
Date:   Mon, 18 Nov 2019 11:07:18 +0100
Message-Id: <20191118100719.7968-12-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: iHNB-VPFPx6HIk7cGV9rzQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

After installing gcc-multilib, we can also test the 32-bit builds
on Travis.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Message-Id: <20191113112649.14322-5-thuth@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 .travis.yml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index 89c50fe..6858c3a 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -29,6 +29,21 @@ matrix:
                vmexit_tscdeadline_immed  vmx_apic_passthrough_thread sysca=
ll"
       - ACCEL=3D"kvm"
=20
+    - addons:
+        apt_packages: gcc gcc-multilib qemu-system-x86
+      env:
+      - CONFIG=3D"--arch=3Di386"
+      - BUILD_DIR=3D"."
+      - TESTS=3D"eventinj port80 sieve tsc taskswitch umip vmexit_ple_roun=
d_robin"
+
+    - addons:
+        apt_packages: gcc gcc-multilib qemu-system-x86
+      env:
+      - CONFIG=3D"--arch=3Di386"
+      - BUILD_DIR=3D"i386-builddir"
+      - TESTS=3D"vmexit_mov_from_cr8 vmexit_ipi vmexit_ipi_halt vmexit_mov=
_to_cr8
+               vmexit_cpuid vmexit_tscdeadline vmexit_tscdeadline_immed"
+
     - addons:
         apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
       env:
--=20
2.21.0

