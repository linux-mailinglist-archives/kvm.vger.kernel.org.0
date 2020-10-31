Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D242A1835
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgJaOfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:35:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbgJaOfT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604154917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xNMGJbncedY4odTpBETPY1PV0jVmJfkfKqxmekO5gI=;
        b=VXl63xRj2zgZUimJqI9wrzp7oQGHaXIzaa+KZw7ne06OWhdTbn7pBOtlfkudVlSw5R0Uzs
        Xsn1QsHARsoY6yi0WrrFpPpg5Yrj46ZxHCSTSZr0Ev0FqQRNrnlz2LU98PgAOftVxrDfXB
        fiTYcSx4WTWJX9DMV4+5BzFZIRkIY2g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-poE7WM7bMDG3JB22RRciaQ-1; Sat, 31 Oct 2020 10:35:15 -0400
X-MC-Unique: poE7WM7bMDG3JB22RRciaQ-1
Received: by mail-wr1-f69.google.com with SMTP id m20so4069831wrb.21
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xNMGJbncedY4odTpBETPY1PV0jVmJfkfKqxmekO5gI=;
        b=nv5+oeglz4kQG3OdvYvu6wVk4yxdmWF4gAs5IBeltRCr9821iPBuFXSZ4Jtq00klUZ
         NNa6+CVicVBK47ObNJNIpf4u5E/mjQj4wj2Tv/qQcWH2U7ZMGF+s9dzQMYorW3jRD4A1
         RNWg69gXs2SvGzND0pW3lp5/4qk+gVG6KGgiB5LsG/poy3Fmf8QNbmr8PpuzmgS5j9zb
         JtZlfDVstJ5XehkuiR0r9nUTytbIApNuDzfXMi+azhUCbuCY3CDNrBFPhv2jqYyuUbWR
         3bJ/f4tyR70E/v4nal6KQxiTDJ9A5P9awDAXrHOC+jDLL5s5ynYoFoRw1HcUjDGX8EfO
         Pw0w==
X-Gm-Message-State: AOAM532BYCC2MUyzHAOJTggAV7yJkuseiZ5H8I8acpkPdSRmbFHMr3yi
        JZVzqCHik9YLFfL0CUsWxNsXE3QfixJdMt5uwLXsiwf3rOdmKfWetcV+9i4em2ICSm1raPHWTbI
        vaS3PHI9mpyd5
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr8467085wmj.109.1604154914177;
        Sat, 31 Oct 2020 07:35:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkzh6ac8+l3fbNIVrRuwb/qHtLvd2rryu/cOYN4UisGtQ8+VXb156E1QEMCYmlNdhh2qbc0Q==
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr8467067wmj.109.1604154913971;
        Sat, 31 Oct 2020 07:35:13 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id f20sm8711348wmc.26.2020.10.31.07.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:35:13 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: apic: test self-IPI in xAPIC mode
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
References: <20201029225642.1130237-1-ricarkol@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0b21a5a-e9a0-cc56-9189-516eadce66f9@redhat.com>
Date:   Sat, 31 Oct 2020 15:35:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201029225642.1130237-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/10/20 23:56, Ricardo Koller wrote:
> Add self-IPI checks for both xAPIC and x2APIC explicitly as two separate
> tests.  Both tests try to set up their respective mode (xAPIC or x2APIC)
> and reset the mode to what was enabled before. If x2APIC is unsupported,
> the x2APIC test is just skipped.
> 
> There was already a self-IPI test, test_self_ipi, that used x2APIC mode
> if supported, and xAPIC otherwise.  This happened because test_self_ipi
> used whatever mode was enabled before, and test_enable_x2apic (which
> runs before) tries to enable x2APIC mode but falls back to legacy xAPIC
> mode when x2APIC is unsupported.
> 
> Tested the case where x2apic is unsupported with:
> ./x86-run ./x86/apic.flat -smp 2 -cpu qemu64,-x2apic
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  x86/apic.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 48 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/apic.c b/x86/apic.c
> index a7681fea836c7..735022b7891f5 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -266,7 +266,7 @@ static void self_ipi_isr(isr_regs_t *regs)
>      eoi();
>  }
>  
> -static void test_self_ipi(void)
> +static void __test_self_ipi(void)
>  {
>      u64 start = rdtsc();
>      int vec = 0xf1;
> @@ -279,8 +279,53 @@ static void test_self_ipi(void)
>      do {
>          pause();
>      } while (rdtsc() - start < 1000000000 && ipi_count == 0);
> +}
> +
> +static void test_self_ipi_xapic(void)
> +{
> +    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
> +
> +    report_prefix_push("self_ipi_xapic");
> +
> +    /* Reset to xAPIC mode. */
> +    reset_apic();
> +    report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
> +           "Local apic enabled in xAPIC mode");
>  
> +    ipi_count = 0;
> +    __test_self_ipi();
>      report(ipi_count == 1, "self ipi");
> +
> +    /* Enable x2APIC mode if it was already enabled. */
> +    if (orig_apicbase & APIC_EXTD)
> +        enable_x2apic();
> +
> +    report_prefix_pop();
> +}
> +
> +static void test_self_ipi_x2apic(void)
> +{
> +    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
> +
> +    report_prefix_push("self_ipi_x2apic");
> +
> +    if (enable_x2apic()) {
> +        report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) ==
> +               (APIC_EN | APIC_EXTD),
> +               "Local apic enabled in x2APIC mode");
> +
> +        ipi_count = 0;
> +        __test_self_ipi();
> +        report(ipi_count == 1, "self ipi");
> +
> +        /* Reset to xAPIC mode unless x2APIC was already enabled. */
> +        if (!(orig_apicbase & APIC_EXTD))
> +            reset_apic();
> +    } else {
> +        report_skip("x2apic not detected");
> +    }
> +
> +    report_prefix_pop();
>  }
>  
>  volatile int nmi_counter_private, nmi_counter, nmi_hlt_counter, sti_loop_active;
> @@ -657,7 +702,8 @@ int main(void)
>      test_enable_x2apic();
>      test_apicbase();
>  
> -    test_self_ipi();
> +    test_self_ipi_xapic();
> +    test_self_ipi_x2apic();
>      test_physical_broadcast();
>      if (test_device_enabled())
>          test_pv_ipi();
> 

Queued, thanks.

Paolo

