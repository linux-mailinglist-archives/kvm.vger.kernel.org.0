Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D1F12406E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 08:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfLRHg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 02:36:58 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46803 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRHg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 02:36:58 -0500
Received: by mail-pf1-f194.google.com with SMTP id y14so719504pfm.13;
        Tue, 17 Dec 2019 23:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pg4QWq+v6GL4Rqi0KrNkbBy7ChOwtldNf1BCqo0xgwg=;
        b=DKDNn88wkruXoKMY1NzZ+hXIuRTXdUdicFpgelALcHp9N4xyLCsxLi5GwVSTFTLFPB
         NuNjJZNsFTtBWqAQybCg4hv2eZJQJiLs+Cn4EsUzKfXBsMTbWLkxKopWRDO+7AYORErt
         na5p8Q0Y3ZEbZPYoHMFBGk/lNnBJoADJdIj+ootuVfG0vnS8BhysFdAV/xR2rZ4rJV8f
         ND46h0fXkMgjBGmS1t5Uc9YeVJdu3koRvqxoxTO/NsC/k6uQxmki3l0lR6S1HX9b8b0h
         ofkdTxibe6A7We+wtvJNjjVyfeyVIceOjFHj29uVo6fWWi5hi9WgGbB2AE3kvPje6ZNx
         ZfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pg4QWq+v6GL4Rqi0KrNkbBy7ChOwtldNf1BCqo0xgwg=;
        b=X1hNL8Paq0bO7Vzb1aled7yUT8pbjl9iQ9EvVsBJO7x946+Q2krN6m3YoApF6aY2Td
         TuPUU6TK56FswjlVwUJKmTNNTDpwsrfi4sJz6pQwPTw2cEQig5e9DFQUZebjmr86dVJ1
         TQZz9qtqnl3VtuddftoPo776HHc4NJs3Vgp0ii186gx09wdx5XVwCcGNtDqL4P8wTx+f
         YjAmomH0llsB9RtnLSPlhOIUIyjAl9uvZvwkMAKZHyR8ZnSMtzzt2AaN5lWudGVOBfRj
         q5pJj2trekDNAvUWc2s6E/DSLdjFkIqJ5A7mFHZdqBUXEiqA63ielbtNDOq/sm3qsOyw
         9H+A==
X-Gm-Message-State: APjAAAXY9V8cPTlGzIHWwIQDlR6HuE6OQbkJJNS0hLSicd8hieY0x/+t
        RiXC+8Sh5nWbojTpUXiZiQ==
X-Google-Smtp-Source: APXvYqykzcjQaYHwHiQ0EjzUn6HtCHp8hGSiRRNg6WpcmmBHBfrcz8LxD6SEJ0MBpJ8PhtL88V8d/w==
X-Received: by 2002:a62:1857:: with SMTP id 84mr1485263pfy.257.1576654617070;
        Tue, 17 Dec 2019 23:36:57 -0800 (PST)
Received: from [127.0.0.1] ([203.205.141.36])
        by smtp.gmail.com with ESMTPSA id j3sm1697366pfi.8.2019.12.17.23.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 23:36:56 -0800 (PST)
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
        "bp@alien8.de" <bp@alien8.de>, hpa@zytor.com
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] KVM: VMX: Clean up the spaces redundant.
Message-ID: <5c33f601-0bee-7958-7295-541b87b95138@gmail.com>
Date:   Wed, 18 Dec 2019 15:36:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 From 6b2634f16cfd5d48896a7c0a094b59410ce078c5 Mon Sep 17 00:00:00 2001
From: Haiwei Li <lihaiwei@tencent.com>
Date: Wed, 18 Dec 2019 15:21:10 +0800
Subject: [PATCH] Clean up the spaces redundant.

Clean up the spaces redundant in vmx.c.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  arch/x86/kvm/vmx/vmx.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51e3b27..94a7456 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -173,7 +173,7 @@
  module_param(ple_window_shrink, uint, 0444);

  /* Default is to compute the maximum so we can never overflow. */
-static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
+static unsigned int ple_window_max = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
  module_param(ple_window_max, uint, 0444);

  /* Default is SYSTEM mode, 1 for host-guest mode */
--
1.8.3.1
