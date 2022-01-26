Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3D349CE17
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiAZPXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:23:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236147AbiAZPXH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 10:23:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643210586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4a54KaRYc7nXHLtavTkK/qlCZX6HnlHMPvKgqmWcUio=;
        b=MZsyvij8h0uJgb/KkN0tv1nMUtBhMUnza8eFhMyg6G6PR+sU5Y23EOWOpJyhaHsdYGlgyx
        FwOuiF7+AkSA1HM/BBwlU2HsB/YFcC+fum6WNojPHpuC8HTpnAkrT0f7wMZALWLMQA+Kx6
        MNEZOOUicqNErX9a0iF+KfytHyWl3J0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-RtH6v4W1OrmK5QVvk-DoSQ-1; Wed, 26 Jan 2022 10:23:05 -0500
X-MC-Unique: RtH6v4W1OrmK5QVvk-DoSQ-1
Received: by mail-wr1-f70.google.com with SMTP id m17-20020adfa3d1000000b001dd66c10c0cso1922274wrb.19
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 07:23:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4a54KaRYc7nXHLtavTkK/qlCZX6HnlHMPvKgqmWcUio=;
        b=Kct8ah2TlFa+tm5x/fLX36/Ja+8RVwD9IG3rWjf9/sciWOv7qRLzF/qPe4nkiqsMRm
         /1ZAh8yrBUwqFHL5qTWTs8YbcJdeDADHCoKnHTm7oCbTmMPGztSb1suvhvzimMfM8jSt
         tclLx6LiIydEPGNyRYDf+WkPyFyFZA9oght+sUkGrWgQkQdRH1DDCTHVEPNeGzYVda1n
         1iWzlSvqhNXOSteQpjxJVj5+SLrPxtyM0U8wylkWTPqfvCi/jtcmJBl1gbmZtg5ChhB4
         xMPoqKeg3uRSozLlUuq8y8NO+tvw1tFAnZWER3vZKq2/E7J3c/LQTiq+F1RVeGpW/VEQ
         2iOw==
X-Gm-Message-State: AOAM530CoodjvVWmW4kRVL5O65D3XsAZsiotq7t9kiSobTvu8zosE/lG
        jf2GP6P7SEIhDnI4FPNGAGdYevOwOAUoRWwXSgQSjJ/srXyPqYLgJa1MmCrk3Oez+bcgg9+f85Y
        9JHgTfFtN7hn3
X-Received: by 2002:a7b:cb18:: with SMTP id u24mr8034885wmj.15.1643210584097;
        Wed, 26 Jan 2022 07:23:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw82k25wkMbrJVhNhjzzuRNIDR0IA7s/6PDVDf+0JaO6ZAgOVzYAYjs7DyqM0oyeoso8SH7Fw==
X-Received: by 2002:a7b:cb18:: with SMTP id u24mr8034859wmj.15.1643210583850;
        Wed, 26 Jan 2022 07:23:03 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i11sm6080210wry.102.2022.01.26.07.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 07:23:03 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Don't skip L2's VMCALL in SMM test for
 SVM guest
In-Reply-To: <20220125221725.2101126-1-seanjc@google.com>
References: <20220125221725.2101126-1-seanjc@google.com>
Date:   Wed, 26 Jan 2022 16:23:02 +0100
Message-ID: <87tudqh67d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Don't skip the vmcall() in l2_guest_code() prior to re-entering L2, doing
> so will result in L2 running to completion, popping '0' off the stack for
> RET, jumping to address '0', and ultimately dying with a triple fault
> shutdown.
>
> It's not at all obvious why the test re-enters L2 and re-executes VMCALL,
> but presumably it serves a purpose.  

I managed to forget everything but it seems my intentions were to test
two things:

- "Enter SMM during L2 execution and check that we correctly return from
  it."
- "Perform save/restore while the guest is in SMM triggered during L2
  execution" 

the later could've been complemented with "and try running L2 after".

> The VMX path doesn't skip vmcall(), and the test can't possibly have
> passed on SVM

Well, it kind of works for me (pre-patch) :-) I do see #DF in the trace
but not #TF.

>, so just do what VMX does.
>

Makes sense. I can't recall how "+= 3" appeared.

> Fixes: d951b2210c1a ("KVM: selftests: smm_test: Test SMM enter from L2")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/smm_test.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
> index 2da8eb8e2d96..a626d40fdb48 100644
> --- a/tools/testing/selftests/kvm/x86_64/smm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
> @@ -105,7 +105,6 @@ static void guest_code(void *arg)
>  
>  		if (cpu_has_svm()) {
>  			run_guest(svm->vmcb, svm->vmcb_gpa);
> -			svm->vmcb->save.rip += 3;
>  			run_guest(svm->vmcb, svm->vmcb_gpa);
>  		} else {
>  			vmlaunch();
>
> base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4

Reviewed-and-tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

