Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A794813CB74
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgAOR4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:56:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51875 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728998AbgAOR4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 12:56:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579110971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GV34jCRlj0bUW9Hdc3YVHkEhV3RRfTTy/yTNeGCUOBw=;
        b=g3PE+auB3A0QBgZYLqlQ+SkR9AAz2QN3YJrzUSgRnUEZLdOz/owZhWW/50NH0XruukEcue
        6GMeK/vdSjSyoZ6g5ygxIjMg5f4/pf9blLv+x7DC0gOjfQ8K6jxmLFKX3kKehpT65FTUuK
        tgjsq6758FDe7x9Jsf8it3obr8Ib3ck=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-PRTCNAKWMH2WlViqqvpmqw-1; Wed, 15 Jan 2020 12:56:09 -0500
X-MC-Unique: PRTCNAKWMH2WlViqqvpmqw-1
Received: by mail-wr1-f70.google.com with SMTP id u18so8239515wrn.11
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 09:56:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GV34jCRlj0bUW9Hdc3YVHkEhV3RRfTTy/yTNeGCUOBw=;
        b=cBG4EFcOAkhBd+jQ+AE6PY5DOi5OtURyYZE59AfZc6jhdQaxlXAcL2RCdjCUOlRb7A
         D6iHck/tycdmxzTqxxXrxmfXWuzPEJU+UqWK1CDUrpSQc5oOexM8TlAasMlttpEYgqUF
         FfAvrEt0tASBJFoFWHzPgWUwUXyOIutluSAp1LMWPmla6OwKtn3Gz7o6T/FhqTn6SmNN
         Ox5iw4PyNJ0cdMGKk+0FzEb6Nd3tUdQjOUFHhe3wtpj1sRnIufTmydlGR7TVcrCCb0tA
         qiBoRnrjp3jN4/yOEs1glkcBpo+AywV+87ggpduaYwbXX48V8C6e3yby9dUH6lVAzlDU
         /wtw==
X-Gm-Message-State: APjAAAVmjmF1T2liruTSABkHcbaw4jpaok8/O/NeUoxseB05UNSZf8SI
        xxGXeikQHD8q8PMK3pj4YxZQOxxXkPaa+GgJAbugZlUY6EDO2ITz0VIv3/vDYSilCoEXb4A9nXu
        Waa7wVvKjVHGE
X-Received: by 2002:a1c:6809:: with SMTP id d9mr1192002wmc.70.1579110967952;
        Wed, 15 Jan 2020 09:56:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5jRb9sG9tgaQjC6Z2Vyf9uE+ik/Rcaq0+f+pFjwJrsjDeAZCwq5eCQZSoEbLS+qz7DEnDEw==
X-Received: by 2002:a1c:6809:: with SMTP id d9mr1191984wmc.70.1579110967776;
        Wed, 15 Jan 2020 09:56:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id p18sm747151wmg.4.2020.01.15.09.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 09:56:07 -0800 (PST)
Subject: Re: [PATCH 0/6] Fix various comment errors
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1576045585-8536-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb8d499a-59c9-4b48-2823-ed5339035af8@redhat.com>
Date:   Wed, 15 Jan 2020 18:56:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1576045585-8536-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 07:26, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Fix various comment mistakes, such as typo, grammar mistake, out-dated
> function name, writing error and so on. It is a bit tedious and many
> thanks for review in advance.
> 
> Miaohe Lin (6):
>   KVM: Fix some wrong function names in comment
>   KVM: Fix some out-dated function names in comment
>   KVM: Fix some comment typos and missing parentheses
>   KVM: Fix some grammar mistakes
>   KVM: hyperv: Fix some typos in vcpu unimpl info
>   KVM: Fix some writing mistakes
> 
>  arch/x86/include/asm/kvm_host.h       | 2 +-
>  arch/x86/kvm/hyperv.c                 | 6 +++---
>  arch/x86/kvm/ioapic.c                 | 2 +-
>  arch/x86/kvm/lapic.c                  | 4 ++--
>  arch/x86/kvm/vmx/nested.c             | 2 +-
>  arch/x86/kvm/vmx/vmcs_shadow_fields.h | 4 ++--
>  arch/x86/kvm/vmx/vmx.c                | 8 ++++----
>  virt/kvm/kvm_main.c                   | 6 +++---
>  8 files changed, 17 insertions(+), 17 deletions(-)
> 

Queued, thanks.

Paolo

