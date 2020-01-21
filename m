Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C5143C9A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 13:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAUMPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 07:15:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728655AbgAUMPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 07:15:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579608936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K7uxOa/zMccI1hlwQjdK023gkBaUsZFJKD86fyOIwdY=;
        b=U3wWQRl6TMbLae1Hka2E+hBZA5DcnLwJDAFjL4Q+oq1KF52j5NQiK7y2NZqGapK0qzCgOd
        SUlBH83UrpqKp0gOCuyu6mNEpAww2bp9X9gtTlbgrcresstiyHcEn7mvQX+9TMvQgfA9jl
        jnHSGH+OgxBij3FcCB+Lz9HzojO1jvk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-3vOaJ-VYMoyYOdatJl2x6Q-1; Tue, 21 Jan 2020 07:15:35 -0500
X-MC-Unique: 3vOaJ-VYMoyYOdatJl2x6Q-1
Received: by mail-wr1-f69.google.com with SMTP id z10so1213505wrt.21
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 04:15:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K7uxOa/zMccI1hlwQjdK023gkBaUsZFJKD86fyOIwdY=;
        b=a2gxLfE1q+zZA2NHq/xpX3awS1ctszLMvjVfn86jmNQEHnNkHHd92rW9b6MvAQDV38
         ij9rEspzmQyAh2hcTPbHCC+XStIJ84dtao/9bH2TKC72QB+kqeFnQ/5JtQcbabtNy+RH
         QpQ9Kb2T5XiyyG15Urc2Y5uh192a9jgt7LSL2qpKtdgR9qjY86rSR4jpHKw0D6q59rEo
         z1yYIJnw6Qfdw+nAZBPGvN+rATQwLOoSOzDfbqpRlzn6Cfg9JAlE3wzJNyQlTlo8sLzA
         x/K94Xku9wcyH3Fvk8rXo11FLTvrWPzE9TmtmCv2bCJk/6m6UmSUNLBqNbKzuMeRcrcq
         +OYQ==
X-Gm-Message-State: APjAAAXlvgUBNiPBcuUZ4Soenkg5hzVyOTl/YaJMfwS+qcEyPZqg9BeV
        Gpb9uqLDXtr82rrPlOMIN9D4gtJyuivX/GBvojExUUxGmQP49VBl35LsEPHb/5F9Tq55Rm+hnS2
        kk6r8fivPCapO
X-Received: by 2002:a5d:6406:: with SMTP id z6mr4954840wru.294.1579608933893;
        Tue, 21 Jan 2020 04:15:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyVbq65dVzapzaZwnuI8J74z85tvEX9mBSp5IwckHTxpR5vFcgnPbOoJoVjP/9/uvX9ZxZzMQ==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr4954809wru.294.1579608933585;
        Tue, 21 Jan 2020 04:15:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id g18sm3451669wmh.48.2020.01.21.04.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 04:15:33 -0800 (PST)
Subject: Re: [PATCH v2] KVM: Adding 'else' to reduce checking.
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
References: <abea81a5-266f-7e0d-558a-b4b7aa49d3d4@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <68afcc3a-f32c-0e0e-5c2d-5fddfc98d1fd@redhat.com>
Date:   Tue, 21 Jan 2020 13:15:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <abea81a5-266f-7e0d-558a-b4b7aa49d3d4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/20 10:03, Haiwei Li wrote:
> From 009bfba9b6f6b41018708323d9ca651ae2075900 Mon Sep 17 00:00:00 2001
> From: Haiwei Li <lihaiwei@tencent.com>
> Date: Thu, 16 Jan 2020 16:50:21 +0800
> Subject: [PATCH] Adding 'else' to reduce checking.
> 
> These two conditions are in conflict, adding 'else' to reduce checking.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/lapic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 679692b..f1cfb94 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1571,9 +1571,9 @@ static void
> kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
>         struct kvm_timer *ktimer = &apic->lapic_timer;
> 
>         kvm_apic_local_deliver(apic, APIC_LVTT);
> -       if (apic_lvtt_tscdeadline(apic))
> +       if (apic_lvtt_tscdeadline(apic)) {
>                 ktimer->tscdeadline = 0;
> -       if (apic_lvtt_oneshot(apic)) {
> +       } else if (apic_lvtt_oneshot(apic)) {
>                 ktimer->tscdeadline = 0;
>                 ktimer->target_expiration = 0;
>         }
> -- 
> 1.8.3.1
> 

Queued, thanks.

Paolo

