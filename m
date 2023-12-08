Return-Path: <kvm+bounces-3960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7439B80ACAF
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02830B20DC7
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4B755C2F;
	Fri,  8 Dec 2023 19:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DnGqK/30"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88CF10D
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702062595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aONzR2W5AGaoRzocN4fiH9lBklHZJB74jzBc5TX6OPU=;
	b=DnGqK/30YVEzorERHKaVw1tNfrgqjCy4xOJLHMA+1r9Fz/HybEs+CnOR7+HDX0Ph/Ek1Jk
	LkHaoKA9pfszLN/dweXvKnWeKB2qHTQ8TaED4vW74HM6WUC22fNFvoEO5cSYUdsXHa1rvY
	1zG2zyZX1jiuMF8Ptp0JxtbL5ESPmgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-JwBPCelKNQqVsZnDr9QaLA-1; Fri, 08 Dec 2023 14:09:52 -0500
X-MC-Unique: JwBPCelKNQqVsZnDr9QaLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18824185A781;
	Fri,  8 Dec 2023 19:09:51 +0000 (UTC)
Received: from p1.localdomain.com (ovpn-114-104.gru2.redhat.com [10.97.114.104])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14AD0112131D;
	Fri,  8 Dec 2023 19:09:47 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Paul Durrant <paul@xen.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Beraldo Leal <bleal@redhat.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Cleber Rosa <crosa@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 09/10] tests/avocado/boot_xen.py: unify tags
Date: Fri,  8 Dec 2023 14:09:10 -0500
Message-ID: <20231208190911.102879-10-crosa@redhat.com>
In-Reply-To: <20231208190911.102879-1-crosa@redhat.com>
References: <20231208190911.102879-1-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Because all tests share the same tags, it's possible to have all of
them at the class level.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/boot_xen.py | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/tests/avocado/boot_xen.py b/tests/avocado/boot_xen.py
index f80cbcb8fb..f4b63c1ef2 100644
--- a/tests/avocado/boot_xen.py
+++ b/tests/avocado/boot_xen.py
@@ -20,6 +20,11 @@
 class BootXen(LinuxKernelTest):
     """
     Boots a Xen hypervisor with a Linux DomU kernel.
+
+    :avocado: tags=arch:aarch64
+    :avocado: tags=accel:tcg
+    :avocado: tags=cpu:cortex-a57
+    :avocado: tags=machine:virt
     """
 
     timeout = 90
@@ -60,13 +65,6 @@ def launch_xen(self, xen_path):
         wait_for_console_pattern(self, console_pattern, "Panic on CPU 0:")
 
     def test_arm64_xen_411_and_dom0(self):
-        """
-        :avocado: tags=arch:aarch64
-        :avocado: tags=accel:tcg
-        :avocado: tags=cpu:cortex-a57
-        :avocado: tags=machine:virt
-        """
-
         # archive of file from https://deb.debian.org/debian/pool/main/x/xen/
         xen_url = ('https://fileserver.linaro.org/s/JSsewXGZ6mqxPr5/'
                    'download?path=%2F&files='
@@ -78,13 +76,6 @@ def test_arm64_xen_411_and_dom0(self):
         self.launch_xen(xen_path)
 
     def test_arm64_xen_414_and_dom0(self):
-        """
-        :avocado: tags=arch:aarch64
-        :avocado: tags=accel:tcg
-        :avocado: tags=cpu:cortex-a57
-        :avocado: tags=machine:virt
-        """
-
         # archive of file from https://deb.debian.org/debian/pool/main/x/xen/
         xen_url = ('https://fileserver.linaro.org/s/JSsewXGZ6mqxPr5/'
                    'download?path=%2F&files='
@@ -96,13 +87,6 @@ def test_arm64_xen_414_and_dom0(self):
         self.launch_xen(xen_path)
 
     def test_arm64_xen_415_and_dom0(self):
-        """
-        :avocado: tags=arch:aarch64
-        :avocado: tags=accel:tcg
-        :avocado: tags=cpu:cortex-a57
-        :avocado: tags=machine:virt
-        """
-
         xen_url = ('https://fileserver.linaro.org/'
                    's/JSsewXGZ6mqxPr5/download'
                    '?path=%2F&files=xen-upstream-4.15-unstable.deb')
-- 
2.43.0


