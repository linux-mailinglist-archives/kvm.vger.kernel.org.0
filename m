Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3D363090
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbhDQOT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 10:19:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233008AbhDQOT1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 10:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618669140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtYYs6+IDzu7f6r2LXM43uXXvWpN30iOw52/ER3gq3g=;
        b=OKBfrf1+WiNhy7v3ZV9vMlqWAllVTLXbSkv3J7To0/y7EX0FjMan97jFQYt7X1vw23yL7I
        Dx+gdT5GcT84Auk2lSme1aWn8ou7H85ReWYM0slFKjeB8gRqdgY/C9ZlsiHLRmJFmslDB7
        8r3THfpk76ZDVwGLRR/l5EcZNUDms6Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-cMbox7lGNGeJCv0N_1B0NA-1; Sat, 17 Apr 2021 10:18:58 -0400
X-MC-Unique: cMbox7lGNGeJCv0N_1B0NA-1
Received: by mail-ed1-f69.google.com with SMTP id p16-20020a0564021550b029038522733b66so605416edx.11
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 07:18:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vtYYs6+IDzu7f6r2LXM43uXXvWpN30iOw52/ER3gq3g=;
        b=jJ8f6WaqXy9E6ZLDQIWzme5CFDwsMIkPJ1WzfhsPnHVjBXoZg1TORRvjjkH4XgVA+k
         2IheGhoYEdFaFBu5xkwUk2Q4P3QjaROQzWHc2LP9H7e41dEQGCMFUCgUmnXdxAIW+bsF
         WP/nN3F0l795KTWRaSG2UiS7aW+9QM2uF3zQgU2MwsWbgL4nGrQX/a2gVH62UpeVln4f
         ayEc76v09IszNCvumMfBlsw5GTSyD4D7xTMLHXnGMWSRE6O9Pfe0LYD0G9yPJ1PlcrAJ
         R1lLEX4CpMsGJsXFPTGBKfqknMvEki+KDD4rzJMBSUJwZz1x0Y9YaZPWsthceaeIbwyp
         B1YQ==
X-Gm-Message-State: AOAM530gtgftqp5C+kfwfZVZswxqccZrT50bEgYyJFg/rnnv7L9CKEma
        cAbbe5Pz+pPf0TFbTA7PEnbRzOldM01Vn+LWkuM6yviLbafMpv1Z8ABz19H3rIyuy5akZh9hjTU
        hCE2Gu+lrOQlE
X-Received: by 2002:aa7:cc94:: with SMTP id p20mr15888097edt.353.1618669137770;
        Sat, 17 Apr 2021 07:18:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBRYOSySpVe0ag21hgvxGPf/tQIBoW94r2CWbDSNlwKp7d7dlXMkHsRyx0uK/DkcM7BecwYQ==
X-Received: by 2002:aa7:cc94:: with SMTP id p20mr15888089edt.353.1618669137631;
        Sat, 17 Apr 2021 07:18:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c11sm5278180ede.45.2021.04.17.07.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 07:18:57 -0700 (PDT)
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0202dd6c-bf20-80ed-5fff-e1fb1acb58c2@redhat.com>
Date:   Sat, 17 Apr 2021 16:18:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210412215611.110095-4-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 23:56, Krish Sadhukhan wrote:
> According to APM vol 2, hardware ignores the low 12 bits in MSRPM and IOPM
> bitmaps. Therefore setting/unssetting these bits has no effect as far as
> VMRUN is concerned. Also, setting/unsetting these bits prevents tests from
> verifying hardware behavior.

Tests should only verify KVM behavior, in order to verify hardware 
behavior you have to run them on bare metal.

Still, the patch is okay.

Paolo

> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   arch/x86/kvm/svm/nested.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ae53ae46ebca..fd42c8b7f99a 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -287,8 +287,6 @@ static void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>   
>   	/* Copy it here because nested_svm_check_controls will check it.  */
>   	svm->nested.ctl.asid           = control->asid;
> -	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
> -	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
>   }
>   
>   /*
> 

