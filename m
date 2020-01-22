Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFBD1457CB
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAVO0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:26:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21527 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726207AbgAVO0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 09:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579703189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=74zVfBisM/fXNSi+DgdTbspPHZzuoedJluaHmqcq+lY=;
        b=GoXCJdOVC7ZtBOa2CYV6rVhu8pBNDOvmVbKChe1P2+1hOBDyBRfIeFzdlAKjBOKBIJLaZh
        JBXBgCtsrB9fn3iQObVQuhn6b4R+HHU3yQT5w2dbFEoRhYTcILmaS5TVQEdbWo7Z9Dmgbn
        r/5DVCksNMQFvAvP+23YCLVQBBWkD7A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-SNpWBTY4NG6D2YjoNfPM4g-1; Wed, 22 Jan 2020 09:26:25 -0500
X-MC-Unique: SNpWBTY4NG6D2YjoNfPM4g-1
Received: by mail-wm1-f69.google.com with SMTP id c4so2173151wmb.8
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 06:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=74zVfBisM/fXNSi+DgdTbspPHZzuoedJluaHmqcq+lY=;
        b=r6paRXecmKhinpUZEFY2/h/0Xtjrvsy1My2jHU9jKI35DuAdMVnZNFoMscjWdEMJou
         eYnDB7Ubjz14UqvQcdZ9dkP9u9IAjMWbhAMOMHcBKI9MkLEIiB2mEPnsV0cmFc8w2XZK
         eAOjpTt7aO4DqaJUr82MDFSQ/LZeSOJULLiOeviwPNYMFyMw+ttBa9JOvWiP4EvnY4R2
         71n7TQ7EhD65ui2zouxky1/xCanQfCl5tiWQh8n5z6t1zbDkxkLCAyChdC/pnJoGE1ia
         9LWCUpV9yUF17nQH3qSOknVqVX/Mdq+J8N0PpzN5CkowVcRIHeHbMjBJ8w/kvYMXCuNT
         auZQ==
X-Gm-Message-State: APjAAAXmcgXEkva68iA9ZnoDSiVdsq0Q71IvdzR1Qh89QvAe+c5Ch7cb
        9dHhXM42RtsFKqtmh8JalE2GkoMAiH+7wnvFJVinV+LR9mhNiYaVM9XdXgrA4rn3eKeE6aGzUd5
        STAZf6TzqpybM
X-Received: by 2002:a1c:a5c5:: with SMTP id o188mr3445035wme.73.1579703183999;
        Wed, 22 Jan 2020 06:26:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7M3zbICGt1w0uX2jwfa0uCtpA8SGtOYCzmuE8diqxSmMieCW36d1e+xWtVOfN5k0M0bVu4g==
X-Received: by 2002:a1c:a5c5:: with SMTP id o188mr3445017wme.73.1579703183795;
        Wed, 22 Jan 2020 06:26:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id k7sm4029479wmi.19.2020.01.22.06.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:26:23 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Check preconditions for RDTSC
 test
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
References: <20200122073959.192050-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2131400d-b92e-dcde-72e7-501081ab9ffe@redhat.com>
Date:   Wed, 22 Jan 2020 15:26:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200122073959.192050-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/20 08:39, Oliver Upton wrote:
> The RDTSC VM-exit test requires the 'use TSC offsetting' processor-based
> VM-execution control be allowed on the host. Check this precondition
> before running the test rather than asserting it later on to avoid
> erroneous failures on a host without TSC offsetting.
> 
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/vmx_tests.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3b150323b325..de9a931216e2 100644
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
> @@ -9210,6 +9207,11 @@ static void rdtsc_vmexit_diff_test(void)
>  	int fail = 0;
>  	int i;
>  
> +	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET)) {
> +		printf("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
> +		return;
> +	}
> +
>  	test_set_guest(rdtsc_vmexit_diff_test_guest);
>  
>  	reset_guest_tsc_to_zero();
> 

Queued, thanks.

Paolo

