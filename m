Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4D52D82DC
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 00:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437435AbgLKXoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 18:44:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437411AbgLKXoD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 18:44:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607730158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jotAI/z0SgHF4RKYgh49UHm2UtBNvCYayLKxMawgge0=;
        b=OSCZkxt9x2BbM0YbyzLK+LZK+zguJ63mS+8/uWuXmELgky8+GTL718yBXpT5/1HZmgtmdz
        GciYzUFYUr5LjKlmo5yhEfvuqSapMlnDNJdouna8XpZdU5QNcvj5w/yQrtQtktOaDlIsCo
        igglNWbej4+Yts6hA+kIKIDHxycsuls=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215--Y9RIs1sO8WO1YekMfHqMg-1; Fri, 11 Dec 2020 18:42:32 -0500
X-MC-Unique: -Y9RIs1sO8WO1YekMfHqMg-1
Received: by mail-ed1-f70.google.com with SMTP id u18so4652316edy.5
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 15:42:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jotAI/z0SgHF4RKYgh49UHm2UtBNvCYayLKxMawgge0=;
        b=PaqG3jbxdZ3AWJ074thN9t/Zm4Vg+h/9BR+CcnJaftVX1ZSTRC19hWqcvUjkRWKJ3E
         kaRjvhhkJfFHevW8nDlR1d3oWzsivLU8Ea5SncD2Nw3+uHPw2JSFpXuGuiQbdK0xv360
         WdqgGN6DTZv+ZSOAFbeE+lflNjLPW6zpx8OuVgK6jaCqqZK/rsat5sN2ZqQ44Tg4D2Db
         qfJDjKdJzu2IJLbg2JhBhLl9zYdshqFVCDEvzIX1lsCWKFBrefBKGNr3EsTI111KcQN6
         eBI4n9q6Ft1/lCpHI6NX7sC59ZXxxOZ+Fm9bLldv2Y4aDIxZx0M6qKUyD46u0prybwCr
         6QKw==
X-Gm-Message-State: AOAM532xdlq6AkF3zI6XClbB0flXv4fDIGXly/RsrPj/JTq0BliELxhQ
        3BNY2qLBnlF1oRYmkU+tseIZw1k+6u7qgUQvVkINCxvrHm7wNlE9cJBFTlM0lEL9+qGqgEsRvF6
        tOxv1NxbFs0kz
X-Received: by 2002:a17:906:9345:: with SMTP id p5mr2495289ejw.40.1607730151327;
        Fri, 11 Dec 2020 15:42:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx3LVgCNtTtC0f4GHARhc60LCk+APdTa24DP118eIdFTFQMJEjB/X9/zS+fDV5WyBMGTsD2pQ==
X-Received: by 2002:a17:906:9345:: with SMTP id p5mr2495273ejw.40.1607730151120;
        Fri, 11 Dec 2020 15:42:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n4sm9021138edt.46.2020.12.11.15.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 15:42:30 -0800 (PST)
To:     Kyung Min Park <kyung.min.park@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        cathy.zhang@intel.com
References: <20201208033441.28207-1-kyung.min.park@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] Enumerate and expose AVX512_FP16 feature
Message-ID: <a10c6b11-9e70-23ac-cdb2-141bb913de3d@redhat.com>
Date:   Sat, 12 Dec 2020 00:42:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208033441.28207-1-kyung.min.park@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/12/20 04:34, Kyung Min Park wrote:
> Introduce AVX512_FP16 feature and expose it to KVM CPUID for processors
> that support it. KVM reports this information and guests can make use
> of it.
> 
> Detailed information on the instruction and CPUID feature flag can be found
> in the latest "extensions" manual [1].
> 
> Reference:
> [1]. https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
> 
> Cathy Zhang (1):
>    x86: Expose AVX512_FP16 for supported CPUID
> 
> Kyung Min Park (1):
>    Enumerate AVX512 FP16 CPUID feature flag
> 
>   arch/x86/include/asm/cpufeatures.h | 1 +
>   arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
>   arch/x86/kvm/cpuid.c               | 2 +-
>   3 files changed, 3 insertions(+), 1 deletion(-)
> 

Queued, with adjusted commit message according to Sean's review.

Paolo

