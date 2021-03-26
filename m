Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB1234ADAD
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhCZRgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:36:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230194AbhCZRf6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616780158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KDgcyqOYgOE9oifFS5sLSPl9zdj81Zvg5IkXdmzuAVI=;
        b=DouMdUnSQYbF1KXE08k9KKMwVe/MDL/lkvuMlgDP3GYjln1HIc5zZ03gpwJFvXx8PpVfIo
        hAiLk8yE5rMlLQ1LQoXCxSO70WuTu26rL3gytZddsdS8nBe1I3ywBqRP0MfY2c/8Q+PGNF
        xRwxIQvbH75Y1ornkoGToUtEbd0cU2U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-oya6wINnO7y5qkipgxkauQ-1; Fri, 26 Mar 2021 13:35:56 -0400
X-MC-Unique: oya6wINnO7y5qkipgxkauQ-1
Received: by mail-ed1-f71.google.com with SMTP id i6so4819491edq.12
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 10:35:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KDgcyqOYgOE9oifFS5sLSPl9zdj81Zvg5IkXdmzuAVI=;
        b=QGG09LLvk7yrirZVo7YeHFMO49cb+GAEeLdn7d2eAe9YegMxc86lFK2PrCOOrfcji8
         sfM7riYQX3DGLWO2fFkFdOglfQQD9ps2JK1j1VgamZ6mxzhvZO4XFrnkldjLKCS2JFbk
         keK6YeauVxDZHGfJX3tHfAS9bq/XALLzvpVPessqa0Anm77hgZ+bJlj3p2lIN/tXa8IT
         2hQOdh0uoGXT+0CByVdITMenlDX3uSVoSdjIvPlOGQmYJMxIbhfP6hKfGZdTKEGoMatb
         JNuydjERkMfZ5fryi8wvCNFnGbrZa0JM6OtN5LZ2ulRZq0ATX6ODZvWq8FM4kb8OqfAD
         Sewg==
X-Gm-Message-State: AOAM5339J+dlVxhGHk72Gy1Sil36eV316xLqhMcFTE4BqG55eTqC9Ldv
        LNf//Qn9pBcttlZ34q+qgBSpoyJr+BBS6ZE3jjNrHF2Ah5TGsOErM69q/mZIFOvddI+lZjpxNSN
        69gq2z6N4csTX
X-Received: by 2002:a17:906:1519:: with SMTP id b25mr16519038ejd.254.1616780154386;
        Fri, 26 Mar 2021 10:35:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHnNqPzyckiQbkoCN/uHMcBjRjfxM5z5Y/UaIb1aX9LitqIIfRgVWHPKYG0iLdSNpRalElTg==
X-Received: by 2002:a17:906:1519:: with SMTP id b25mr16519023ejd.254.1616780154239;
        Fri, 26 Mar 2021 10:35:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a22sm4143395ejr.89.2021.03.26.10.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:35:53 -0700 (PDT)
Subject: Re: [PATCH 0/4 v5] nSVM: Test host RFLAGS.TF on VMRUN
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <474b77d4-ef2c-507c-201a-d22f9e6567cf@redhat.com>
Date:   Fri, 26 Mar 2021 18:35:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/21 18:50, Krish Sadhukhan wrote:
> v4 -> v5:
>          1. The fix in patch# 1 has been modified. We are queue'ing the
>             pending #DB intercept via nested_svm_vmexit() if the VMRUN is
>             found to be single-stepped.
>          2. In patch# 3, the assembly label for tracking the VMRUN RIP has
>             been changed to u64* from void*.
> 
> [PATCH 1/4 v5] KVM: nSVM: If VMRUN is single-stepped, queue the #DB
> [PATCH 2/4 v5] KVM: X86: Add a utility function to read current RIP
> [PATCH 3/4 v5] KVM: nSVM: Add assembly label to VMRUN instruction
> [PATCH 4/4 v5] nSVM: Test effect of host RFLAGS.TF on VMRUN
> 
>   arch/x86/kvm/svm/nested.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> Krish Sadhukhan (1):
>        KVM: nSVM: If VMRUN is single-stepped, queue the #DB intercept in nested_svm_vmexit()
> 
>   lib/x86/processor.h |   7 ++++
>   x86/svm.c           |  16 ++++++--
>   x86/svm_tests.c     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 134 insertions(+), 4 deletions(-)
> 
> Krish Sadhukhan (3):
>        KVM: X86: Add a utility function to read current RIP
>        KVM: nSVM: Add assembly label to VMRUN instruction
>        nSVM: Test effect of host RFLAGS.TF on VMRUN
> 

Queued 1-3-4, 2 is not needed.

Paolo

