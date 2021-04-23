Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF46368DA3
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 09:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbhDWHIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 03:08:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229486AbhDWHIw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 03:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619161696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6nTxmdqew/u6s+lOFo4xVX1inakg0kuwdWkPa9JRN4=;
        b=F44oXdJXyCWHPauIilrmPj5ggybeu2/A/1p0+z3SMNqeBqhNLZvJkjMH8Pvlt7U85bY/hG
        yIY0xG6c22Iej1hYEkx0N5yBnGTk/8K6jmFGYeOzciyPrUjcMieNxvzK+gCCQ+3uuf5Hf/
        KilLIOnyNQFOEAvndqhEt9AyF7L+jr8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-KoHEssDZNyqPxNr88m-0Cw-1; Fri, 23 Apr 2021 03:08:14 -0400
X-MC-Unique: KoHEssDZNyqPxNr88m-0Cw-1
Received: by mail-ej1-f72.google.com with SMTP id i10-20020a1709067a4ab029037c5dba8400so8104430ejo.8
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 00:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s6nTxmdqew/u6s+lOFo4xVX1inakg0kuwdWkPa9JRN4=;
        b=ExQ0vuZRbDQFtMSHQ8xyPCh6eaRmbRXH8JyaKbpDynVRfQ++AJ8nmeqgrjEyFax8Nv
         XiKCjU/0hhiBruYc7GGk2KYL4HTcAG4BFwXDAB8ehJYCDlYpw3nNSLYEKkZFSeAKvU/B
         EtNOcJIi6+6g3dWdiWiKs3Q/MWZelQwcu6acHizD0y276t2lOqPwXd53vuUJCsUczTkx
         /tkf1jcvclavqeffmbn+XwOjAsDwXOmOmMDi9a5aYi5BycwG1dJlWITVLkqlP2iEA0bs
         UJi33sqd5RVcVKkMkkEa9UEcexrkzqUnLTNaNiLtivS1aifvx6g2dz/i+ZkIQ0GIaSWI
         C/fA==
X-Gm-Message-State: AOAM532/DheIJhffAGei5Gi7JKnFuMjJbwSqDubTO+rlnJDM+xPj5hUZ
        yAg4YiA+xgzgO0XZPE3FhGkvcgtZg74k/GNcsZZo7GL7IcmnEeq2BF8on/zOOu6PlMXDK5HbBjT
        k/bQc0Rv7+N9A
X-Received: by 2002:a17:906:36da:: with SMTP id b26mr2772503ejc.8.1619161693241;
        Fri, 23 Apr 2021 00:08:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhjQ/5A0AMXJ/oTAsivkhjGXT0QdCZlC/+ol6RTxlqAGpcL15cTSSJBoKA0Bo+y4Xe9v9/GA==
X-Received: by 2002:a17:906:36da:: with SMTP id b26mr2772488ejc.8.1619161693095;
        Fri, 23 Apr 2021 00:08:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lr27sm3270158ejb.8.2021.04.23.00.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 00:08:12 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Fix implicit enum conversion goof in scattered
 reverse CPUID code
To:     Nathan Chancellor <nathan@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
References: <20210421010850.3009718-1-seanjc@google.com>
 <YIBcd+5NKJFnkTC1@archlinux-ax161>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c469d222-a082-a984-eedd-f6111e03917c@redhat.com>
Date:   Fri, 23 Apr 2021 09:08:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YIBcd+5NKJFnkTC1@archlinux-ax161>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/21 19:10, Nathan Chancellor wrote:
> arch/x86/kvm/cpuid.c:499:29: warning: implicit conversion from enumeration type 'enum kvm_only_cpuid_leafs' to different enumeration type 'enum cpuid_leafs' [-Wenum-conversion]
>          kvm_cpu_cap_init_scattered(CPUID_12_EAX,
>          ~~~~~~~~~~~~~~~~~~~~~~~~~~ ^~~~~~~~~~~~
> arch/x86/kvm/cpuid.c:837:31: warning: implicit conversion from enumeration type 'enum kvm_only_cpuid_leafs' to different enumeration type 'enum cpuid_leafs' [-Wenum-conversion]
>                  cpuid_entry_override(entry, CPUID_12_EAX);
>                  ~~~~~~~~~~~~~~~~~~~~        ^~~~~~~~~~~~
> 2 warnings generated.

Added this to the commit message, thanks!

Paolo

