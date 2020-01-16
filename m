Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55F313D65A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 10:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgAPJEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 04:04:07 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35320 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgAPJEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 04:04:07 -0500
Received: by mail-pj1-f67.google.com with SMTP id s7so1281783pjc.0;
        Thu, 16 Jan 2020 01:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=U+3BCSnWn4TsegpodIg+CCuuc8hYDYmEd54pNj+hQe8=;
        b=umn+IqrAkUg8Lczfv/av+jmNOPAaBCCOriIQM0WcqEyLpzjtkocNVLbEa7HftEDRCp
         ZXrgkUD/Q8sbt85K9wh9BNGjWywMrU348smx5dZlr7zow7tbxh81IZg9j6v3yfsbWOab
         r6o+KuBm8NxqDy3DaRLejhSGZ5oR9PGwbL3n5sY5WG0g7DnpcE6hxt1YdENgv5vsQopZ
         kC5zM/ktRUwjGnmlKrT4/zl87zRwnno7CzLsYApMSABEJYU9o1glLtqbYhAKssFDYJk8
         OrD7gC9jgvYm6xZLBRn96UidFDSwYaCjiUnXuUeHE4261LVOm1JiyWYfnUbuIpnve7fr
         AOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=U+3BCSnWn4TsegpodIg+CCuuc8hYDYmEd54pNj+hQe8=;
        b=ge7tcrX56Da29lm7zsrVSlvS6o6jutM3CBVSfu0U1uUUokGGvS64ihWdS/oXvRqDpP
         v9OorUlPNLbDj8vT+NOyHY0k9io4jRC5+t/Ug37uv83Y6oWu9AajHKXjuTHjvHQogixE
         TWeMi+wUkB+nHWK76hn+bAFjP0XS8zwXKg+eQu7aSt8zIfdjh9S32HB62a0XHox00Zeb
         WbamovQw4blHKkWZeWRvfW25Gy2QhCj2hbd6FdP+JeK/O2lgdGXu1+z/Qoqp5OtPFC8m
         /pMq5Mvj2XwAxhyY7UvNw8fVuosskWQba8aD2ScbsdtWMhLb6vieJf6GlDUPXlhzNKsJ
         VPTA==
X-Gm-Message-State: APjAAAWq+szGLfqqrmxWu+Qlxk03glccqwqA4r/T2SSeP4hmX/taB0Kw
        bUdNGd8t/WEsV44XmcW0/Q==
X-Google-Smtp-Source: APXvYqzw0XcAtZanZ7artcVDGxxVLV/xsH+qbe+U725HIgRi07bmtp2XMXD8Wos42K2GvIsNfJAESA==
X-Received: by 2002:a17:90b:2286:: with SMTP id kx6mr5562347pjb.95.1579165446729;
        Thu, 16 Jan 2020 01:04:06 -0800 (PST)
Received: from [127.0.0.1] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id 3sm2646801pjg.27.2020.01.16.01.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 01:04:06 -0800 (PST)
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
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH v2] KVM: Adding 'else' to reduce checking.
Message-ID: <abea81a5-266f-7e0d-558a-b4b7aa49d3d4@gmail.com>
Date:   Thu, 16 Jan 2020 17:03:56 +0800
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

 From 009bfba9b6f6b41018708323d9ca651ae2075900 Mon Sep 17 00:00:00 2001
From: Haiwei Li <lihaiwei@tencent.com>
Date: Thu, 16 Jan 2020 16:50:21 +0800
Subject: [PATCH] Adding 'else' to reduce checking.

These two conditions are in conflict, adding 'else' to reduce checking.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
---
  arch/x86/kvm/lapic.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 679692b..f1cfb94 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1571,9 +1571,9 @@ static void 
kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
         struct kvm_timer *ktimer = &apic->lapic_timer;

         kvm_apic_local_deliver(apic, APIC_LVTT);
-       if (apic_lvtt_tscdeadline(apic))
+       if (apic_lvtt_tscdeadline(apic)) {
                 ktimer->tscdeadline = 0;
-       if (apic_lvtt_oneshot(apic)) {
+       } else if (apic_lvtt_oneshot(apic)) {
                 ktimer->tscdeadline = 0;
                 ktimer->target_expiration = 0;
         }
--
1.8.3.1
