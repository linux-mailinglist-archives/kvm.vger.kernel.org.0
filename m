Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B220145801
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgAVOkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:40:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53016 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725884AbgAVOkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 09:40:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579704019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2flCz3mos0mD2ZyqMjCI0w1o6EZ0Fp/koD/uKzxS9Q=;
        b=QM1ssIocI6mw1skC1lof3c+m8OUJP6OAlvj7Zq+67F4jzKV/Jr7/gPIsnW8KMheQpIol7k
        k58VjCidrjRjQGjFAv3dI5LtMB6iglrIxHkQRjMdwOxGvW8Epuhnhzd78oZS6ba1eJdaou
        7GlSZznMiacrK0ty0HMLwKCa9D290zA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-EkOhl4v_MeusSJ30wDlkTw-1; Wed, 22 Jan 2020 09:40:18 -0500
X-MC-Unique: EkOhl4v_MeusSJ30wDlkTw-1
Received: by mail-wr1-f72.google.com with SMTP id f15so3182082wrr.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 06:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H2flCz3mos0mD2ZyqMjCI0w1o6EZ0Fp/koD/uKzxS9Q=;
        b=nBoeT9Y889I6/vjhiGh4xB0ywgM0CwO4QJQflkkpYgDcI0omHAl+q8zLqxnpoQouxd
         RSxWX8HAc0CJsQ0FCsaX+UeOS7K5n+9Xzn37/zZ5eB/M2B5R2wUSVTdTg3zLqe1/qw7o
         FHA1SYsbLB5CP/hHn0ns+Y0eyF2idwi4rIFdD0y/67ILLukx0eUu+PgG6vZKvCLHg26S
         sfg7xXfNJTbNTr4v9HNl0cLTV878owdJkHBemHLk0m8/SC+oJT7VPP7mcsrl6iVvhlRF
         +tE368Ytd6lbxw4GXGX+X6k7RgNtVQwzqCp0VnlvTeyh1KjYlF64cGtjLkhqWLv5sJ2r
         6MRA==
X-Gm-Message-State: APjAAAXzRYUZnYG3Ps8IyPiT8x5RwINE0y03EvcL9a4zfBOsFch2Z/E4
        LSOnzvdYmORmtzzWuOVTmg/OjRY199b0D6XYGjCOtTOYK94mQAJyahL7K3DtMUW2NG1A7vpMS5P
        dpeGfbjmMIfId
X-Received: by 2002:a1c:61d6:: with SMTP id v205mr3489541wmb.91.1579704016962;
        Wed, 22 Jan 2020 06:40:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2ZMUiDIkmlsE68MeXhiEELDtRidu/bYbc/Mo0KtHbzfLchs2nkKy8jR/RdM7Q5J10ppRjyg==
X-Received: by 2002:a1c:61d6:: with SMTP id v205mr3489520wmb.91.1579704016756;
        Wed, 22 Jan 2020 06:40:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id n16sm58392397wro.88.2020.01.22.06.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:40:16 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2] x86: VMX: Check precondition for RDTSC
 test
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200122100356.240412-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1612dc60-1303-bec1-2c53-85872d887c42@redhat.com>
Date:   Wed, 22 Jan 2020 15:40:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200122100356.240412-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/20 11:03, Oliver Upton wrote:
> The RDTSC VM-exit test requires the 'use TSC offsetting' processor-based
> VM-execution control be allowed on the host. Check this precondition
> before running the test rather than asserting it later on to avoid
> erroneous failures on a host without TSC offsetting.
> 
> Cc: Aaron Lewis <aaronlewis@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/vmx_tests.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3b150323b325..b31c360c5f3c 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9161,9 +9161,6 @@ static void vmx_vmcs_shadow_test(void)
>   */
>  static void reset_guest_tsc_to_zero(void)
>  {
> -	TEST_ASSERT_MSG(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET,
> -			"Expected support for 'use TSC offsetting'");
> -
>  	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
>  	vmcs_write(TSC_OFFSET, -rdtsc());
>  }
> @@ -9210,6 +9207,9 @@ static void rdtsc_vmexit_diff_test(void)
>  	int fail = 0;
>  	int i;
>  
> +	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET))
> +		test_skip("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
> +
>  	test_set_guest(rdtsc_vmexit_diff_test_guest);
>  
>  	reset_guest_tsc_to_zero();
> 

Queued this one now, thanks.

Paolo

