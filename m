Return-Path: <kvm+bounces-3961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CABE180ACB0
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0837A1C20B4C
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A63057300;
	Fri,  8 Dec 2023 19:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0+dRoyP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C440911F
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702062602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2/ZJBxQx+a/oBJOsQBV1mcDu69d7gKxirFUm2tSNNUI=;
	b=M0+dRoyPBLX43IlqiA8kTyioO2W0yIxiFiYX/3lZCYQuRR7MbJCWgXZdq9gzHwfypmzndp
	57cRq1DR4awek6+1vmQq9O18eXKQk9XVp31kP+TQdPqAmCTB47olGP7c8h3Dy38wkGlGFy
	eZd5gTli9XAew/pSJ/q3Y4wj1VoJU9c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302--3UFl49BNJGS3COW1tbAWg-1; Fri, 08 Dec 2023 14:09:55 -0500
X-MC-Unique: -3UFl49BNJGS3COW1tbAWg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68F6F85A589;
	Fri,  8 Dec 2023 19:09:54 +0000 (UTC)
Received: from p1.localdomain.com (ovpn-114-104.gru2.redhat.com [10.97.114.104])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63036112131D;
	Fri,  8 Dec 2023 19:09:51 +0000 (UTC)
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
Subject: [PATCH 10/10] tests/avocado/boot_xen.py: use class attribute
Date: Fri,  8 Dec 2023 14:09:11 -0500
Message-ID: <20231208190911.102879-11-crosa@redhat.com>
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

Rather than defining a single use variable, let's just use the class
attribute directly.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/boot_xen.py | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/avocado/boot_xen.py b/tests/avocado/boot_xen.py
index f4b63c1ef2..f29bc58b9e 100644
--- a/tests/avocado/boot_xen.py
+++ b/tests/avocado/boot_xen.py
@@ -50,11 +50,10 @@ def launch_xen(self, xen_path):
 
         self.vm.set_console()
 
-        xen_command_line = self.XEN_COMMON_COMMAND_LINE
         self.vm.add_args('-machine', 'virtualization=on',
                          '-m', '768',
                          '-kernel', xen_path,
-                         '-append', xen_command_line,
+                         '-append', self.XEN_COMMON_COMMAND_LINE,
                          '-device',
                          'guest-loader,addr=0x47000000,kernel=%s,bootargs=console=hvc0'
                          % (kernel_path))
-- 
2.43.0


