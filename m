Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B31439D2A
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhJYRMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 13:12:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234713AbhJYRL7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 13:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635181776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7VgV8J8M68X7FsFm+kLhyb9kPwgpFCC0ZlbVrVQHUVU=;
        b=gbRxT/2AC1MPCApTA/BQDqg9IPNe2pBTLE76U5ycJcqzWg1rRbPbdR4D+jk7SfMUJet1Eg
        /vFTj56peAZLbug5BNnI1tryIGLBdqqOY8bJhhVPR1DbuWUF8dP0VyYvZWPq/KiUbiVTFr
        Ks3G7sJrF9JkhR85lCZZhfkXqOU4T9E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-Q2Xfu4KzPsajdflWY_pOYQ-1; Mon, 25 Oct 2021 13:09:34 -0400
X-MC-Unique: Q2Xfu4KzPsajdflWY_pOYQ-1
Received: by mail-wr1-f72.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso3394308wrg.1
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 10:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7VgV8J8M68X7FsFm+kLhyb9kPwgpFCC0ZlbVrVQHUVU=;
        b=wsl7OHALoUEaBlFlx7vhvW82GnFi5z8AobR5hZ/g2DpnN4cV0yaC7/ea/fgWJe0b7t
         NGxeBrAFrTrdUgpic6BmK4+lA/EzKUFVZ1lUPfi1Zitx0fpzPc9eVFUPshczfCEmS6Ly
         oaiwWeA11j13TR5E+fdVZL7s+ZAp2venabWJJ4jetXCIgVj34lz1HTlq2zhf7QWBA9ea
         8mvuM40ezw1DJoura5oEz2UBTEnGoJIaTKz/0JfHmh9yn4qp2920/bQqiAxsXWhKbLSy
         2CliLRBOvMJJ7eBTspUtCUEWwxnILHQT3sVrKv8i3kzpd7GH/jcAmfw1tqqCbIVpwHow
         nM8Q==
X-Gm-Message-State: AOAM530e582ot5DG/fOmlzf8xx7Iz2LDvytqe4aiXNUhe0ydS36aw+hB
        Jq/2FEdAbd7f46l/fpLljet/yMOW4HI3nofUjwvtljPVdhZBVWaVg0M4pbwJ4rIrzwXLAprIuKu
        xHozHjpUW0sfK
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr25488474wrd.73.1635181773523;
        Mon, 25 Oct 2021 10:09:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7iBirqneThYpe55mmEY2fmAX0kuVQkYB48qDjmRaM0sTyADUamlOJtZRya6UOvDrPg3cmOQ==
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr25488431wrd.73.1635181773261;
        Mon, 25 Oct 2021 10:09:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g10sm20018005wmq.13.2021.10.25.10.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 10:09:32 -0700 (PDT)
Message-ID: <b7ce2d41-a14c-cd17-d60f-2962b3df8826@redhat.com>
Date:   Mon, 25 Oct 2021 19:09:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH] x86: SEV-ES: add port string IO test case
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        Thomas.Lendacky@amd.com, zxwang42@gmail.com, fwilhelm@google.com,
        seanjc@google.com, oupton@google.com, mlevitsk@redhat.com,
        pgonda@google.com, drjones@redhat.com
References: <20211025052829.2062623-1-marcorr@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211025052829.2062623-1-marcorr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/21 07:28, Marc Orr wrote:
> Add a test case to verify that string IO works as expected under SEV-ES.
> This test case is based on the `test_stringio()` test case in emulator.c.
> However, emulator.c does not currently run under UEFI.
> 
> Only the first half of the test case, which processes a string from
> beginning to end, was taken for now. The second test case did not work
> and is thus left out of the amd_sev.c setup for now.
> 
> Also, the first test case was modified to do port IO at word granularity
> rather than byte granularity. The reason is to ensure that using the
> port IO size in a calculation within the kernel does not multiply or
> divide by 1. In particular, this tweak is useful to demonstrate that a
> recent KVM patch [1] does not behave correctly.
> 
> * This patch is based on the `uefi` branch.
> 
> [1] https://patchwork.kernel.org/project/kvm/patch/20211013165616.19846-2-pbonzini@redhat.com/
> 
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>   x86/amd_sev.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
> diff --git a/x86/amd_sev.c b/x86/amd_sev.c
> index 061c50514545..7757d4f85b7a 100644
> --- a/x86/amd_sev.c
> +++ b/x86/amd_sev.c
> @@ -18,6 +18,10 @@
>   #define EXIT_SUCCESS 0
>   #define EXIT_FAILURE 1
>   
> +#define TESTDEV_IO_PORT 0xe0
> +
> +static char st1[] = "abcdefghijklmnop";
> +
>   static int test_sev_activation(void)
>   {
>   	struct cpuid cpuid_out;
> @@ -65,11 +69,29 @@ static void test_sev_es_activation(void)
>   	}
>   }
>   
> +static void test_stringio(void)
> +{
> +	int st1_len = sizeof(st1) - 1;
> +	u16 got;
> +
> +	asm volatile("cld \n\t"
> +		     "movw %0, %%dx \n\t"
> +		     "rep outsw \n\t"
> +		     : : "i"((short)TESTDEV_IO_PORT),
> +		         "S"(st1), "c"(st1_len / 2));
> +
> +	asm volatile("inw %1, %0\n\t" : "=a"(got) : "i"((short)TESTDEV_IO_PORT));
> +
> +	report((got & 0xff) == st1[sizeof(st1) - 3], "outsb nearly up");
> +	report((got & 0xff00) >> 8 == st1[sizeof(st1) - 2], "outsb up");
> +}
> +
>   int main(void)
>   {
>   	int rtn;
>   	rtn = test_sev_activation();
>   	report(rtn == EXIT_SUCCESS, "SEV activation test.");
>   	test_sev_es_activation();
> +	test_stringio();
>   	return report_summary();
>   }
> 

Applied to uefi branch, thanks (and tested both before and after the 
patch I've sent with subject "[PATCH] KVM: SEV-ES: fix another issue 
with string I/O VMGEXITs").

Paolo

