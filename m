Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5854B7AADBC
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 11:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjIVJXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 05:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVJXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 05:23:06 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361A4CE;
        Fri, 22 Sep 2023 02:23:00 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-40472c3faadso20622265e9.2;
        Fri, 22 Sep 2023 02:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695374578; x=1695979378; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i6f7B4E5qYHw5TUtVNOvWgw6bCE36R0LeY8Qu2sLRI4=;
        b=ROWLF2NYFg0ze4W84cVfMV+/vwMr0kXAY2LdBjoP+s3FalP5LzbEzD8Xg1hbhKN8Z/
         kAIkmIDzVCQ8i0+BptAfM9hwQa66EYe5/xveyQDA1TP08J1Ele6GHtjIA3dbWc3aW8Az
         PCzwTGZIFjh3XQajOdkPMUQSoEsVvom2MhZbx9wVrVBc/xINTHch20yUPReANt575iUL
         OYGbBH2NIzb9z89zcEQ91Fmdk9vDz8MOsM2anEMbqs8bYj1D8WHm4jq1PKDwoU4pjZsH
         EssKas6mePGjjP1t7gErDxx0N9Gc6Lx/UdViJUikmZc4Muv/rK3JJ/QMd5SYSNAMVjH/
         U9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695374578; x=1695979378;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6f7B4E5qYHw5TUtVNOvWgw6bCE36R0LeY8Qu2sLRI4=;
        b=VKJmu8vYbAG7n6gXMPA7p/czyqcwP1HJqpxo5e4NLMGoQsMkOmEEzR07XH+GNZUaPJ
         b0ie584MBLLIeuYAOrLOZxosVCrkTdNxMk16r19SUllgkyNLAoXKPeY3PGsAgvwrjF8+
         8MDITigXPvntR7CkZftdRGgCd8uy7SD10x/kYC6cdytA6lwnT+SV3MLqDhu6VZcdEMpe
         f8gdTgpm0dFP2MnhF+1dUjBgMXVMOQpPhGXmk7/xgCTI0KASuQAaPNbT8xnX/5+DNbZk
         WDsYe5vjuIWeSwxjIZSvjYs9Y7iF+mzcnu3LC6hVldqC4dDv9SP8W4RkN8aNN8Wub1i3
         7wvQ==
X-Gm-Message-State: AOJu0YzvXz5x+PB0yj5gG5/B5Y6xuqqBJtrLK8pqYWJIwCsxBUFxM/Ho
        cg+7nd7uK1u8tfA0QKefee8=
X-Google-Smtp-Source: AGHT+IE5poE8RItsxxgP9rt1Qzlf8O5KfT3kta3113FL6vXqhsH00jKlpVR0SdwUtBZemWKdtnU/Uw==
X-Received: by 2002:a7b:cd9a:0:b0:402:feff:90d5 with SMTP id y26-20020a7bcd9a000000b00402feff90d5mr7270101wmj.5.1695374578399;
        Fri, 22 Sep 2023 02:22:58 -0700 (PDT)
Received: from [192.168.4.149] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id v4-20020a05600c214400b003fef19bb55csm4078475wml.34.2023.09.22.02.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 02:22:58 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <dff1ad07-8649-4916-bbc1-ab5cc403bb89@xen.org>
Date:   Fri, 22 Sep 2023 10:22:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: x86: Use fast path for Xen timer delivery
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Griffoul, Fred" <fgriffo@amazon.com>
References: <445abd6377cf1621a2d306226cab427820583967.camel@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <445abd6377cf1621a2d306226cab427820583967.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2023 10:20, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Most of the time there's no need to kick the vCPU and deliver the timer
> event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_fast()
> directly from the timer callback, and only fall back to the slow path
> when it's necessary to do so.
> 
> This gives a significant improvement in timer latency testing (using
> nanosleep() for various periods and then measuring the actual time
> elapsed).
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 40edf4d1974c..66c4cf93a55c 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -134,12 +134,23 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
>   {
>   	struct kvm_vcpu *vcpu = container_of(timer, struct kvm_vcpu,
>   					     arch.xen.timer);
> +	struct kvm_xen_evtchn e;
> +	int rc;
> +
>   	if (atomic_read(&vcpu->arch.xen.timer_pending))
>   		return HRTIMER_NORESTART;
>   
> -	atomic_inc(&vcpu->arch.xen.timer_pending);
> -	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> -	kvm_vcpu_kick(vcpu);
> +	e.vcpu_id = vcpu->vcpu_id;
> +	e.vcpu_idx = vcpu->vcpu_idx;
> +	e.port = vcpu->arch.xen.timer_virq;

Don't you need to check the port for validity? The VMM may not have set 
it (and hence be delivering timer VIRQ events itself).

   Paul

> +	e.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
> +
> +	rc = kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
> +	if (rc == -EWOULDBLOCK) {
> +		atomic_inc(&vcpu->arch.xen.timer_pending);
> +		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> +		kvm_vcpu_kick(vcpu);
> +	}
>   
>   	return HRTIMER_NORESTART;
>   }

