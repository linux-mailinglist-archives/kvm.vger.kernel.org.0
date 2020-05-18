Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078AA1D75AC
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgERKz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 06:55:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55636 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726270AbgERKz5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 06:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589799356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4qCPvl+Kzxwr6u2SnFhTAgqF+P+2b9DjFZ38t/g4QD4=;
        b=P+oHmq9eLc3xlGGsiFlu6Lbbx2vl85GCJKXz4D7+IY9aPf1SXLf203a+hHFMu9bqWETF51
        gC7xf3iGFdo26xdGRN4mcNgpDBNyKCjvN1MN6qVxVhDmQaxx+ig6erYsstFqKoijdOJklF
        5yZ1vZcUlWOkKRSQ5Oc3tBHHAiUJiaQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-ru9daOfENT-t_sLpo-anRQ-1; Mon, 18 May 2020 06:55:54 -0400
X-MC-Unique: ru9daOfENT-t_sLpo-anRQ-1
Received: by mail-wm1-f71.google.com with SMTP id n66so5633526wme.4
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 03:55:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4qCPvl+Kzxwr6u2SnFhTAgqF+P+2b9DjFZ38t/g4QD4=;
        b=mzfswK+zV+2PQz/A6VJb7UG5jf9L9dnmukW1wheeM1U3YRv60x9ayMqhynpB8gcEL/
         fZqyB6nzgBLQxvrgpO4uyKuEEhxL+NFQeLCj+/c9eMeDXlQJpzr4zayscgceKlLbLYT9
         c33DJcprxBBNWO8icjl9bmJLz9USg2Je8j4LoumQMwv9ByCudb3XI0XYzipV/Ix9OEnb
         FBJX6Y4x1qJsuU3W2nT8Xnd+lXsgmFlLUxxUny5REwUPP6FCthD4EaNAdCEHaNSQojYH
         1cWgTtY0CJE0yEkPKXKNV9zEe5ZXpCWxtWdqtMlf/4w2x1Nbu/rIyRY2VKhdBkBqPQGN
         lf2Q==
X-Gm-Message-State: AOAM532SwKYWlieZNX04DqgM0mpLj5i4uzNmE/lDyUud12SDK9tu3saa
        CVX8Jf65YsAJUbO27CkXLVnu+1ZgH7VHAmuJz15G2nVMIPTDEYj0iakcT1OT0dK3HlYl9nPVf5W
        HNqpOv/b1M+c2
X-Received: by 2002:a1c:f312:: with SMTP id q18mr18869330wmq.175.1589799353627;
        Mon, 18 May 2020 03:55:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsnCM+6ovpWCbwXHDYfwN2IAiPYSCAAfCLhQaa+AbmlDlCkZMMg/BjMjagVdget3fEYHegKA==
X-Received: by 2002:a1c:f312:: with SMTP id q18mr18869311wmq.175.1589799353431;
        Mon, 18 May 2020 03:55:53 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id r3sm15448334wmh.48.2020.05.18.03.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 03:55:52 -0700 (PDT)
Subject: Re: [PATCH] KVM: Fix the indentation to match coding style
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>, wanpengli@tencent.com,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, hpa@zytor.com
Cc:     "x86@kernel.org" <x86@kernel.org>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <2f78457e-f3a7-3bc9-e237-3132ee87f71e@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b4443a42-bd06-4b67-64e6-6c636507713b@redhat.com>
Date:   Mon, 18 May 2020 12:55:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2f78457e-f3a7-3bc9-e237-3132ee87f71e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/20 03:31, Haiwei Li wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> There is a bad indentation in next&queue branch. The patch looks like
> fixes nothing though it fixes the indentation.
> 
> Before fixing:
> 
>                 if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
>                         kvm_skip_emulated_instruction(vcpu);
>                         ret = EXIT_FASTPATH_EXIT_HANDLED;
>                }
>                 break;
>         case MSR_IA32_TSCDEADLINE:
> 
> After fixing:
> 
>                 if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
>                         kvm_skip_emulated_instruction(vcpu);
>                         ret = EXIT_FASTPATH_EXIT_HANDLED;
>                 }
>                 break;
>         case MSR_IA32_TSCDEADLINE:
> 
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 471fccf..446f747 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1631,7 +1631,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct
> kvm_vcpu *vcpu)
>                 if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
>                         kvm_skip_emulated_instruction(vcpu);
>                         ret = EXIT_FASTPATH_EXIT_HANDLED;
> -               }
> +               }
>                 break;
>         case MSR_IA32_TSCDEADLINE:
>                 data = kvm_read_edx_eax(vcpu);
> -- 
> 1.8.3.1
> 

Queued, thanks.

Paolo

