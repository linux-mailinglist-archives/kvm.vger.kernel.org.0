Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5184D263DF1
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgIJHE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:04:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33300 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730315AbgIJHCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 03:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599721331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lGs5ABKm8y9Jc/D3T2fzKVj+EYzhUQk9uXM+DI2xiY8=;
        b=aSW2TyJKeyLdUYM+l6xhi/NCYEoQENnwlhdWKv4MrcsbbDXK3N8PfeYXPM82ZzQikzKTIU
        mK6YGB3UFHQhyh05YFbb+1NLs4nztyuYtSk/Grwz9hOCt7r23Q8DXFKkjhgQwyE2I2TJnD
        ALbefaCDbBx0oFt9bVHwHo1ceqSW/3I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-x5wQozj4Oj6B1hO8-FcuGA-1; Thu, 10 Sep 2020 03:02:09 -0400
X-MC-Unique: x5wQozj4Oj6B1hO8-FcuGA-1
Received: by mail-wr1-f69.google.com with SMTP id r16so1872842wrm.18
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 00:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGs5ABKm8y9Jc/D3T2fzKVj+EYzhUQk9uXM+DI2xiY8=;
        b=C9YbaKfuJBMP0XrCR4lWaeZxYq1UzH5IFHLUCHe/7U0JYgZLFg6mA3eEmDNaYyNSDq
         YgA8nh6XU5gl/ZDE3oPnmptUy94LC6fqVJVqSr9vNPXvpW2ZRL4d3sMD040bpylvHsEY
         ANtfNWB9If19e2JMynXhHKbo0U1Oh9T6tK4EpaOttzrf3/QvtzmwG+MQz+1crPvxclMs
         +f9a53niiAF2X5zUJkATbj8yc/eZCIraO2j200S05FlSw6fywR7uQDJzukhD1kE87Zfa
         16f42dLrKtYRgFT4xUDK/SxV5BnfPKWaMhN4se8H7Kcab+agVowqzqReUgQNBhQNe49n
         pMhQ==
X-Gm-Message-State: AOAM531RoVy/sWYQCB8dEL5c3hs+oswq7xDpiTKAP5I8nJOw1GL6wXd2
        GyRtz5WBRc7pEJeGRx2/zrn1Xx/iGY8I0DZt/Q0cdMoWI3Ie5U2DuQtrqJq+aG/+qaRUi6M3dGo
        QFofWAiMOUoU4
X-Received: by 2002:a1c:4b04:: with SMTP id y4mr6890998wma.111.1599721328157;
        Thu, 10 Sep 2020 00:02:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE0Z695VXU3e9M0JVMx/m5jixlhhfySuGaTkiZxpc9kM9WGt9z1mdGK0NlEetghntMunzOLg==
X-Received: by 2002:a1c:4b04:: with SMTP id y4mr6890972wma.111.1599721327946;
        Thu, 10 Sep 2020 00:02:07 -0700 (PDT)
Received: from x1w.redhat.com (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id m185sm2221410wmf.5.2020.09.10.00.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:02:07 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 6/6] target/i386/kvm: Rename host_tsx_blacklisted() as host_tsx_broken()
Date:   Thu, 10 Sep 2020 09:01:31 +0200
Message-Id: <20200910070131.435543-7-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910070131.435543-1-philmd@redhat.com>
References: <20200910070131.435543-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to use inclusive terminology, rename host_tsx_blacklisted()
as host_tsx_broken().

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 205b68bc0ce..3d640a8decf 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -302,7 +302,7 @@ static int get_para_features(KVMState *s)
     return features;
 }
 
-static bool host_tsx_blacklisted(void)
+static bool host_tsx_broken(void)
 {
     int family, model, stepping;\
     char vendor[CPUID_VENDOR_SZ + 1];
@@ -408,7 +408,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
     } else if (function == 6 && reg == R_EAX) {
         ret |= CPUID_6_EAX_ARAT; /* safe to allow because of emulated APIC */
     } else if (function == 7 && index == 0 && reg == R_EBX) {
-        if (host_tsx_blacklisted()) {
+        if (host_tsx_broken()) {
             ret &= ~(CPUID_7_0_EBX_RTM | CPUID_7_0_EBX_HLE);
         }
     } else if (function == 7 && index == 0 && reg == R_EDX) {
-- 
2.26.2

