Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1C67B5072
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 12:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbjJBKfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 06:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236530AbjJBKfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 06:35:45 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF121D7;
        Mon,  2 Oct 2023 03:35:42 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-405361bb9f7so167403325e9.2;
        Mon, 02 Oct 2023 03:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696242941; x=1696847741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R6KXywotmXA/KObeIwoWwMRfeXeVZZEdCqJZCtARBEE=;
        b=BnbIkcXVaB3i96HLhCsKk2KWF1s1/soW9L14RzIFbHGDNEBaeaRvlsdb/lXSQkBn/d
         WLh0ZnxkXqXI+qtqcMdJAucW7d4l/miDgYcjakGplzqzzZ60I2CSnAWbmnTRbyFL8qx9
         Lra4easKTgqXq71AzZTDCB9LD7n2qkzZF0FxjqGmZP4q+jFx3Lrv5g3mn62DldE1ppM5
         LW/WfWPcdQ8AAO6sH7jWgMd9SCEXeMfAvs0nxyRvXEbwTLH7UArAjl/7jsB670YJQerh
         ZpBsnJNHWheeoGGj/1H+ADtyKKsAcvRUPBLNJbf/WXGKvovTPsNujocmEALxbxvvXsT4
         WRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696242941; x=1696847741;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6KXywotmXA/KObeIwoWwMRfeXeVZZEdCqJZCtARBEE=;
        b=Cgynl3c8n46teGEQgPIAVbWG7Tgs3oeeRBNmmVhwQjDZjnszpMsGDQKGWJb+MT+kz7
         aNVzbDbF+n5no/7s4G66VKdgbOH6yTl7kuJNUgUdm51DHxfs0sSMXj7o6MEhOWbfF8NG
         asaX6GQo/SMAl3z2LEQJeOlCGANGBjxUnyyM0IU/IMuvHe4ReQOQo0wSRPgkRZak/P/G
         Ca4obL9Sr8bP46Xl1UPUkYJnMQKKpxg8k9P+kQSA/Qsf/iLIyfpKma966KV+mdhqij5K
         PrVTIz8d1ciJf6ZWSEECjHQmtY3oIWlucmVJUqzndr/znJQ+BLiFDC0MjvYqRzKdRTg/
         m6cg==
X-Gm-Message-State: AOJu0YzOqOrlmCgZDfutv2EeeLx9JXIz5O4Z+NzBVPzkfZQvC4PB0Egi
        p1Oo+XqNISGEmTJ9hWlpEas=
X-Google-Smtp-Source: AGHT+IFDOlffJnVURr4RV6FUspnNEaQ5wh1PVQ5JaO1cH8UM1PWxzMdAx5UcU21YAQ5oiNhTsy4F7g==
X-Received: by 2002:a05:600c:215:b0:405:1c19:b747 with SMTP id 21-20020a05600c021500b004051c19b747mr8788914wmi.15.1696242941202;
        Mon, 02 Oct 2023 03:35:41 -0700 (PDT)
Received: from [192.168.7.196] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id f21-20020a7bcc15000000b00404719b05b5sm6915006wmh.27.2023.10.02.03.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 03:35:40 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8ddfdcc1-1c28-4ff1-9f4f-3f150a69a7e4@xen.org>
Date:   Mon, 2 Oct 2023 11:35:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3] KVM: x86: Use fast path for Xen timer delivery
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/2023 14:58, David Woodhouse wrote:
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
> However, there was a reason¹ the fast path was dropped when this support
> was first added. The current code holds vcpu->mutex for all operations
> on the kvm->arch.timer_expires field, and the fast path introduces a
> potential race condition. Avoid that race by ensuring the hrtimer is
> (temporarily) cancelled before making changes in kvm_xen_start_timer(),
> and also when reading the values out for KVM_XEN_VCPU_ATTR_TYPE_TIMER.
> 
> ¹ https://lore.kernel.org/kvm/846caa99-2e42-4443-1070-84e49d2f11d2@redhat.com/
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   • v2: Remember, and deal with, those races.
> 
>   • v3: Drop the assertions for vcpu being loaded; those can be done
>         separately if at all.
> 
>         Reorder the code in xen_timer_callback() to make it clearer
>         that kvm->arch.xen.timer_expires is being cleared in the case
>         where the event channel delivery is *complete*, as opposed to
>         the -EWOULDBLOCK deferred path.
> 
>         Drop the 'pending' variable in kvm_xen_vcpu_get_attr() and
>         restart the hrtimer if (kvm->arch.xen.timer_expires), which
>         ought to be exactly the same thing (that's the *point* in
>         cancelling the timer, to make it truthful as we return its
>         value to userspace).
> 
>         Improve comments.
> 
>   arch/x86/kvm/xen.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 49 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

