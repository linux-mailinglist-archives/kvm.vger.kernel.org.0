Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B76525D729
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 13:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgIDL1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 07:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730185AbgIDL1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 07:27:08 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19C7C06123F;
        Fri,  4 Sep 2020 04:25:42 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kk9so540923pjb.2;
        Fri, 04 Sep 2020 04:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4iF/KxJRf6RUN8ireZqNsFjdJniXRQCA0m2V2VdM7aY=;
        b=rmly/Hi26HxZ+lf1DtFGWTwggsOa+IuyWuUP6RCnfw6k7QWod4onfRB1eQGLonapfA
         mp48rqLbdh4MERxOKwp7yA5dvcmxZHdG0sLRkO9GHO2eH09WBeQJCj+oXN680YkMT/Vy
         5BriiWyC1iIlLFf38pw5AlucY1drz+Zn207Z7ywoQrJqIEG4OMwUIVx7VPTWJxxHWUwT
         TXFldnzkaBvcItl2YAsxsTBs02qrayxmEAil7cGau2+XbuOcPsoNNDUrRBUABJbxoq3j
         jvzm0OEXspY6rVCxSOvHkOIehW8NR0Jjd9g+bLyPbwTylxLj2rxXnfJ7eM08Oxih6Zi2
         2X2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=4iF/KxJRf6RUN8ireZqNsFjdJniXRQCA0m2V2VdM7aY=;
        b=TDqo1WvdwwYIH8hK/QbDwfpb5225Mv/mKxO2+KlHieFBZpvO5nx5stcYc/YYfwGSH1
         K3kVoMVF/ZHDNIlT6Lh1fykBRyrzDcyPMDW0AwbgjlYrb2vgwztS4SAIy0wPIZVfq+7G
         qVyhplPtk8yZheWz9Xm6ZcCQ0NRaV2lUGPs0BHjpqzMtNgg70he/ZREFig+uFnqHuXoG
         ZWlMh7gXbo8jsICMK6/B6l6rWPyxyr4j5k3UYXodslSa0+WRnramsNnCw+eSSCfb+BYs
         yStGYBUFwmTuiWSxvqVuoqL7v84nFtqi8c5RXwydiOGhFfwzCAFnsTjZrGwq7mNXgc4p
         glOA==
X-Gm-Message-State: AOAM533iaKG1WmrqCU0KlmE8S44PhSWHIWDA8/JteKXdbv8dwhwBkVKC
        BsLNEVgH8HKdbFFBPZ8xWw==
X-Google-Smtp-Source: ABdhPJwA6BUd2QTxpgWoADDjuuNYMmhS0f6lh9N/5x3Gvo3/JYPUwvc7iWOFYYyvAimk0pavjAATMw==
X-Received: by 2002:a17:90a:9382:: with SMTP id q2mr7622795pjo.118.1599218742271;
        Fri, 04 Sep 2020 04:25:42 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id 72sm6298793pfx.79.2020.09.04.04.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 04:25:41 -0700 (PDT)
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>, joro@8bytes.org,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] KVM: SVM: Add tracepoint for cr_interception
Message-ID: <f3031602-db3b-c4fe-b719-d402663b0a2b@gmail.com>
Date:   Fri, 4 Sep 2020 19:25:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

Add trace_kvm_cr_write and trace_kvm_cr_read for svm.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  arch/x86/kvm/svm/svm.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 03dd7bac8034..2c6dea48ba62 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2261,6 +2261,7 @@ static int cr_interception(struct vcpu_svm *svm)
  	if (cr >= 16) { /* mov to cr */
  		cr -= 16;
  		val = kvm_register_read(&svm->vcpu, reg);
+		trace_kvm_cr_write(cr, val);
  		switch (cr) {
  		case 0:
  			if (!check_selective_cr0_intercepted(svm, val))
@@ -2306,6 +2307,7 @@ static int cr_interception(struct vcpu_svm *svm)
  			return 1;
  		}
  		kvm_register_write(&svm->vcpu, reg, val);
+		trace_kvm_cr_read(cr, val);
  	}
  	return kvm_complete_insn_gp(&svm->vcpu, err);
  }
--
2.18.4
