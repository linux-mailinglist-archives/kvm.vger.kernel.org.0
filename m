Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975053D6928
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 00:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhGZVTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 17:19:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229687AbhGZVTf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 17:19:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627336803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7a0CX6RMndHH/RZRwrUawBFHC5AJmpLRnH2PCbgNOQo=;
        b=MlUssT/xfiIDyvwRZ2h8yjsO8CHODHRbcIQnFuWYWzkYV6yCsGxSmoWdUTps8zUIRXB+JS
        Gwy/3xkpOHRkoCcu3gZtcQJF150ViOlCD5N24C5/xksypHX9y6raGs0Jf1vreraMHjirSw
        KGoA7pil7YIvt8ZGFVfnBShsA/ohhkw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-t8XTfttyOu-JYOyF07u6tw-1; Mon, 26 Jul 2021 18:00:00 -0400
X-MC-Unique: t8XTfttyOu-JYOyF07u6tw-1
Received: by mail-ed1-f69.google.com with SMTP id p2-20020a50c9420000b02903a12bbba1ebso5405086edh.6
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 14:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7a0CX6RMndHH/RZRwrUawBFHC5AJmpLRnH2PCbgNOQo=;
        b=mg0JM4uoUNXXjMYRXAnLR8+A5wMSyB6UP+wYp26t7r9hpNcw9eGKSQ2/Gki93HNIOb
         1Q7yjbMUAkFGPY8V3ii6C9K0FLD4BNLyJ3fl530JUjcQoR12+JwevH0pfhHO3lwdH3Dn
         q8ZN7HKw4HAaxrUgNU6v3Hx/l1TySs4Oszbyj2hCVK/YptOwf7Rj+R4g7YD2upk4QbkL
         eOvwVxmgSDKcQZhNokSGc7kpSUTWJM+KidkAsdz9pzhFVUmSk0E0MmRR0hTVKBhNFvWB
         Yqt1e3C6VoFqL7O2X9N/DUBGGlrvyRaeZyxLbX1KTmtBbvnePgT/vfm3yN3ntUHSoZ7W
         7Tmg==
X-Gm-Message-State: AOAM5327dJnN6Velc9K56abOaEcWP2D+wQr+QslLBUhQA53QreTIXqMJ
        NiIziArkmHDnU41ubTBN7nCdU7RyUyWQG6zmeOzwKyshgwY7NsRrcmC72SET/XXm9Bkb5XsXVJ2
        fu3fiOBEk4Rcg
X-Received: by 2002:a17:906:82d3:: with SMTP id a19mr4632848ejy.244.1627336799061;
        Mon, 26 Jul 2021 14:59:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxntUcaSgo4ELAXDaBa6YLrkV4LtRBpRHCzpnKOBy9ZMoLTmuz0QCqB1S8czRcNksBFX0dsJw==
X-Received: by 2002:a17:906:82d3:: with SMTP id a19mr4632837ejy.244.1627336798871;
        Mon, 26 Jul 2021 14:59:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id d19sm411540eds.54.2021.07.26.14.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 14:59:58 -0700 (PDT)
Subject: Re: [PATCH 0/3] Test: nSVM: Test effects of host EFLAGS.RF on VMRUN
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org, thomas.lendacky@amd.com
References: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff0faf5c-97c6-4a80-2773-86f3f4f3380a@redhat.com>
Date:   Mon, 26 Jul 2021 23:59:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/07/21 20:02, Krish Sadhukhan wrote:
> Patch# 1: Moves the setter/getter functions for the DR registers, to the
> 	  common library so that other tests can re-use them.
> Patch# 2: Adds the #define for the RF bit in EFLAGS register.
> Patch# 3: Adds a test for the behavior of host EFLAGS.RF bit on VMRUN,
> 	  based on the following from section "VMRUN and TF/RF Bits in
> 	  EFLAGS" in APM vol 2,
> 
> 	      "EFLAGS.RF suppresses any potential instruction breakpoint
> 	       match on the VMRUN. Completion of the VMRUN instruction
> 	       instruction clears the host EFLAGS.RF bit."
> 
> 
> [PATCH 1/3] Test: x86: Move setter/getter for Debug registers to
> [PATCH 2/3] Test: x86: Add a #define for the RF bit in EFLAGS
> [PATCH 3/3] Test: nSVM: Test effects of host EFLAGS.RF on VMRUN
> 
>   lib/x86/processor.h | 33 ++++++++++++++++++++++
>   x86/debug.c         | 79 +++++++++++++---------------------------------------
>   x86/svm_tests.c     | 74 ++++++++++++++++++++++++++++++++++++++----------
>   3 files changed, 111 insertions(+), 75 deletions(-)
> 
> Krish Sadhukhan (3):
>        Test: x86: Move setter/getter for Debug registers to common library
>        Test: x86: Add a #define for the RF bit in EFLAGS register
>        Test: nSVM: Test effects of host EFLAGS.RF on VMRUN
> 

Queued, thanks.

Paolo

