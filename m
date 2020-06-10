Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97841F5EEB
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 01:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFJXy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 19:54:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726722AbgFJXy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 19:54:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591833265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCtwfxayuox1/yPqLw5A7CnfLtpo4UULn1Kziha2I2Q=;
        b=fV59C0F9CHBDDB9Kg9ZpRnHFXlEPjaY9XFeSoV+ymB1S4kKway1z5k4j+3YYumutmfoy4g
        hbUA1SgKkab71pUcjl9u395CLdTXH6PW9hPTUy4d8Fw8kiDuvtyFiFSwc+qodIooEJw0Wp
        BkojvI5MQ8IfujwIT/zLRRYH+adD52A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-9XjztBmRMr-cB9LEHUhF6w-1; Wed, 10 Jun 2020 19:54:24 -0400
X-MC-Unique: 9XjztBmRMr-cB9LEHUhF6w-1
Received: by mail-wr1-f69.google.com with SMTP id c14so1755051wrm.15
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 16:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SCtwfxayuox1/yPqLw5A7CnfLtpo4UULn1Kziha2I2Q=;
        b=qyhYAyGH6XwcAc7fAPIIfOxlGBul5t8p7/i/Wyeg0DrLQwJUuWXSszYLxKYqFvsuTk
         VPwb/gM1fgHMpixuzigELKbl6yHoQT810bYvbN9I5in1dszCh+N+deTAZp+VA9x/tqAm
         uEXEQCUd+gBvQQv6N0uij1Ejk7v1My6whPYJUc7czXTyDdvfbr3fGMHLUKulm7aFz66y
         tJqKVZU0krh7OcO/jS1IRgXJw33ZyADF86hRT7F6/KNoe1hwih2Knr4bgUBgkTJqb6Nc
         6SU+41+DYUOaXS7br7jiRC2/EvsVB4JwKRyNMqf2qtqFX9s2+NsCT3YZgwtR5KXwpVWJ
         wfvg==
X-Gm-Message-State: AOAM530IIhsIkkxy9akklOWozvVwrMtlL1hXaGc44KP0ikSz8+gVVfcq
        k0vIGFBvSWn/gat1MA9ip6hHnksET0SstAzQBzYnItd7tUOWwpQA61kR8EcqeE+7yaMWjKfNTBV
        OeWwHrMXibzFl
X-Received: by 2002:adf:f64c:: with SMTP id x12mr5965177wrp.281.1591833263032;
        Wed, 10 Jun 2020 16:54:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysclxi3majveRTpBVh4uGlZRNlhlB/11mmXMMl39Dgc4rltBvvupYmUCE0PccDrtKt6N0wEw==
X-Received: by 2002:adf:f64c:: with SMTP id x12mr5965158wrp.281.1591833262819;
        Wed, 10 Jun 2020 16:54:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d? ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
        by smtp.gmail.com with ESMTPSA id q1sm1469054wmc.12.2020.06.10.16.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 16:54:22 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: fix sync_with_host() in smm_test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200610164116.770811-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c9a42060-a951-aadc-93db-c22b86a9a0de@redhat.com>
Date:   Thu, 11 Jun 2020 01:54:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200610164116.770811-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/20 18:41, Vitaly Kuznetsov wrote:
> It was reported that older GCCs compile smm_test in a way that breaks
> it completely:
> 
>   kvm_exit:             reason EXIT_CPUID rip 0x4014db info 0 0
>   func 7ffffffd idx 830 rax 0 rbx 0 rcx 0 rdx 0, cpuid entry not found
>   ...
>   kvm_exit:             reason EXIT_MSR rip 0x40abd9 info 0 0
>   kvm_msr:              msr_read 487 = 0x0 (#GP)
>   ...
> 
> Note, '7ffffffd' was supposed to be '80000001' as we're checking for
> SVM. Dropping '-O2' from compiler flags help. Turns out, asm block in
> sync_with_host() is wrong. We us 'in 0xe, %%al' instruction to sync
> with the host and in 'AL' register we actually pass the parameter
> (stage) but after sync 'AL' gets written to but GCC thinks the value
> is still there and uses it to compute 'EAX' for 'cpuid'.
> 
> smm_test can't fully use standard ucall() framework as we need to
> write a very simple SMI handler there. Fix the immediate issue by
> making RAX input/output operand. While on it, make sync_with_host()
> static inline.
> 
> Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/x86_64/smm_test.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
> index 36314152943d..ae39a220609f 100644
> --- a/tools/testing/selftests/kvm/x86_64/smm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
> @@ -47,10 +47,10 @@ uint8_t smi_handler[] = {
>  	0x0f, 0xaa,           /* rsm */
>  };
>  
> -void sync_with_host(uint64_t phase)
> +static inline void sync_with_host(uint64_t phase)
>  {
>  	asm volatile("in $" XSTR(SYNC_PORT)", %%al \n"
> -		     : : "a" (phase));
> +		     : "+a" (phase));
>  }
>  
>  void self_smi(void)
> 

Queued, thanks.

Paolo

