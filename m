Return-Path: <kvm+bounces-1654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2617EB26A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7A41B20B9E
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D64C41745;
	Tue, 14 Nov 2023 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FRG7FV+Z"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990B44174A
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:38:31 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D3ED5E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:29 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9c773ac9b15so803904466b.2
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972707; x=1700577507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7bjOOh298/gVm20zFogtcW7Ag9vjCtjGY9z1KnDRo3U=;
        b=FRG7FV+ZTGvdXzNfcoLFDhRMPWSanfD+FO7abxOP+6zEV8QEhJqK79MdhIe4WcK9sM
         GsgnalzmC61NjTXaBXg2n/1+vjMbMHqFwunh0kr9k0fe+rzkBtc4OKoBecaTdUfJ0p5o
         hpAxVEtvGnsxPk6NDKILPwPv8Vc6jnshOcEiimoDhjTmwy8lxrVvCVQSn5MRQzNGCv0p
         FRlfxDmg5A9QdxGYMddgkOo9gK7qtO8rNwvsJ3eL0j4X1MuEoqcEzqv630Fj7ngNCja6
         09lMCvuueVn29DY0cIQUDA7mKT269nGPz3zWcQr0xtRmpytRFfjtL6Dlp8oMD9m7Wh/a
         L77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972707; x=1700577507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7bjOOh298/gVm20zFogtcW7Ag9vjCtjGY9z1KnDRo3U=;
        b=w8bqbv6wcg/PS91gw/KmmgIHNF68EXfWtYOd2ALDiNcch6Tc4oxdxzO9SMlKYlrVLP
         v1RPIgnmVgf2ueIZkH2hhKc2TxhBQY1PWYuqalxY/LsapzKoepfELICreAek1mSk0z0p
         8Z4inPnDR7vmRQPwgMGzKtdGjqYiGRN/8yFgCoU6pO0RxoIQVf9Xslzzc6OPvO+nhVtn
         aWZzAWZrtjJlb1ilqrpyl/28Y3OtUYjWVMZ9sG9vkllAeOEtDTGKY7Vzs9+f1N3NF5qK
         Mc2J1vX5HyYk0nVw0Jz1ODJOdl8qDpN2TZupPO4i3xdQoVnTS2zDoRuJkeFPZS0WnrPA
         PstQ==
X-Gm-Message-State: AOJu0YyLR9ub33KB8amQzoApLB1FYx8tY8gwL6/ROcpvfRFn9z/mUacc
	UfrPL4ChWQ0gwU62Ld7s8FFmBA==
X-Google-Smtp-Source: AGHT+IGmC/f0NBuJq3lX6zmQbmq53YN/p3zW7ekfEdUOO96zzY8Hw2NKquJgt5a7Y31IS7pqqhAiDQ==
X-Received: by 2002:a17:906:e084:b0:9c6:64be:a3c9 with SMTP id gh4-20020a170906e08400b009c664bea3c9mr7562718ejb.39.1699972707580;
        Tue, 14 Nov 2023 06:38:27 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id v21-20020a1709064e9500b009df5d874ca7sm5636254eju.23.2023.11.14.06.38.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:38:27 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cleber Rosa <crosa@redhat.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Beraldo Leal <bleal@redhat.com>
Subject: [PATCH-for-9.0 v2 01/19] tests/avocado: Add 'guest:xen' tag to tests running Xen guest
Date: Tue, 14 Nov 2023 15:37:57 +0100
Message-ID: <20231114143816.71079-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231114143816.71079-1-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a tag to run all Xen-specific tests using:

  $ make check-avocado AVOCADO_TAGS='guest:xen'

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 tests/avocado/boot_xen.py      | 3 +++
 tests/avocado/kvm_xen_guest.py | 1 +
 2 files changed, 4 insertions(+)

diff --git a/tests/avocado/boot_xen.py b/tests/avocado/boot_xen.py
index fc2faeedb5..f7f35d4740 100644
--- a/tests/avocado/boot_xen.py
+++ b/tests/avocado/boot_xen.py
@@ -61,6 +61,9 @@ def launch_xen(self, xen_path):
 
 
 class BootXen(BootXenBase):
+    """
+    :avocado: tags=guest:xen
+    """
 
     def test_arm64_xen_411_and_dom0(self):
         """
diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
index 5391283113..63607707d6 100644
--- a/tests/avocado/kvm_xen_guest.py
+++ b/tests/avocado/kvm_xen_guest.py
@@ -22,6 +22,7 @@ class KVMXenGuest(QemuSystemTest, LinuxSSHMixIn):
     :avocado: tags=arch:x86_64
     :avocado: tags=machine:q35
     :avocado: tags=accel:kvm
+    :avocado: tags=guest:xen
     :avocado: tags=kvm_xen_guest
     """
 
-- 
2.41.0


