Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B437C13D40E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 07:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgAPGDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 01:03:15 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51715 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgAPGDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 01:03:15 -0500
Received: by mail-pj1-f67.google.com with SMTP id d15so1024902pjw.1;
        Wed, 15 Jan 2020 22:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dPqB30Bque1a9xdQca0yHVUONu8Rkkk23AZbtBFoqN0=;
        b=Jl3n9t2/YTDOuYoiVgGPHFsJsyZ3+fU3dIIf8t9Iwil/iQtRl6iU+ydPdNETEDxZXQ
         S0mZAwv2gG7bTooBUzPiH+qTTdpUAwmAJEOL8weqbTj9F50Bh1AmkwTQ6uFurcp5Ewzc
         NIKhfnXGn/p2m+FAs59d+4f+Un+V0WomKNDHt2aRbOvGUNwHS3kMo6+4z9dmTCjroJ50
         knbv2fpyA2lYn4IU3OKYMd+Qz9FkwPzCVyruxkfHGZxTgRKux5R17NfoSdBJx4yEcuki
         f8UDl7GSNPArYDNtaK4T4XIyePvR49+MOIAspG1jsChLqP7rEOMZUVzCRXmvTGpDzC1M
         xYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dPqB30Bque1a9xdQca0yHVUONu8Rkkk23AZbtBFoqN0=;
        b=RZWh6WrnvRLxGDJ7zFaLlg70O8+1WloBnI+erZxwVhYZGYDAiBoHySS6FlscQGROSj
         h7loU8yAnFtxbgbEEKzTkGlzc93V+Wl7i6LN0fvNa46b2neh7J7SDNLa386RIr8sYZeb
         KsykIYsuKIymb87fa0GhO+JC7jH+uULa9a/zinaTty/+VJmbJNpyez2+9yPbDSIJ80/K
         3+09zcr3B/QQzQ/rmGYmr5P6+wIOkucJ/VogdreYqRKbqA5crx4oh2iykwDyOpcmQBTB
         zzrP5ipA6OnNpwGOCsgRy/rHJ1d5SdRpNbjBxHGdQbgva+GTlfaniiQQpceHQR19iQ9D
         tg7Q==
X-Gm-Message-State: APjAAAX3XC4+joGzzpHVTorzfjWr84QOdxjlSyDdMAXCCwkiX4wgtQn1
        IPyun4s9Km7t9UNOW9qq/g==
X-Google-Smtp-Source: APXvYqz3LduDxHDVbF5g2WN3h6iZ3dA8WNbXYcZfN0VJe6IA8uAo9nRsS6DW76p0g3x2WMGQiak9lg==
X-Received: by 2002:a17:90a:b30b:: with SMTP id d11mr4723790pjr.22.1579154594426;
        Wed, 15 Jan 2020 22:03:14 -0800 (PST)
Received: from [127.0.0.1] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id q6sm23636677pfh.127.2020.01.15.22.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 22:03:13 -0800 (PST)
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, bp@alien8.de,
        "hpa@zytor.com" <hpa@zytor.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] KVM: Adding 'else' to reduce checking.
Message-ID: <2a1a3b72-acc5-4977-5621-439aac53f243@gmail.com>
Date:   Thu, 16 Jan 2020 14:03:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 From 4e19436679a97e3cee73b4ae613ff91580c721d2 Mon Sep 17 00:00:00 2001
From: Haiwei Li <lihaiwei@tencent.com>
Date: Thu, 16 Jan 2020 13:51:03 +0800
Subject: [PATCH] Adding 'else' to reduce checking.

These two conditions are in conflict, adding 'else' to reduce checking.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  arch/x86/kvm/lapic.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 679692b..ef5802f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1573,7 +1573,7 @@ static void 
kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
         kvm_apic_local_deliver(apic, APIC_LVTT);
         if (apic_lvtt_tscdeadline(apic))
                 ktimer->tscdeadline = 0;
-       if (apic_lvtt_oneshot(apic)) {
+       else if (apic_lvtt_oneshot(apic)) {
                 ktimer->tscdeadline = 0;
                 ktimer->target_expiration = 0;
         }
--
1.8.3.1
