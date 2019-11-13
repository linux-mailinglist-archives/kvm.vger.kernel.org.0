Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99185FAFAB
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 12:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfKML1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 06:27:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727733AbfKML1M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 06:27:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573644431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DRnn3I7+CMe5tSFVJiYe3vzKe25C9XarD+qgUqrzjoM=;
        b=FxLv3krxvD4bb4FXHQAXf9URkDDnS66LweykYAjmUgQG9UgJEFHZFuPpwvzHfPtZBB00Ic
        88xSuaQRej+L2KfkSdFgy/1oLrmAzDNRjFU3oPgex4diDlKTpsS/2s+LVHY+20LFzLCIls
        EsDM9p53W/qBaKeC+9s9nFkA/RNyghs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-nFCej38CMEOthDgBZL7D0Q-1; Wed, 13 Nov 2019 06:27:10 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC72F477;
        Wed, 13 Nov 2019 11:27:09 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D3ED6046B;
        Wed, 13 Nov 2019 11:27:02 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-test PATCH 4/5] travis.yml: Test the i386 build, too
Date:   Wed, 13 Nov 2019 12:26:48 +0100
Message-Id: <20191113112649.14322-5-thuth@redhat.com>
In-Reply-To: <20191113112649.14322-1-thuth@redhat.com>
References: <20191113112649.14322-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: nFCej38CMEOthDgBZL7D0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After installing gcc-multilib, we can also test the 32-bit builds
on Travis.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index f91118c..9ceb04d 100644
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
2.23.0

