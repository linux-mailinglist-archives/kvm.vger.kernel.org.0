Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66A544DCD9
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 22:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhKKVGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 16:06:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232666AbhKKVGu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 16:06:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636664639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IydML5DPv4srmsLJbMzm6xiqLfe0nPlKjLPkLPNdgqo=;
        b=KN6QNVlym5bPC7CAap49ZlnH7flnhpw6pS6A248ghwslDEozGdf1vqjoIKfx3RRX1CZw2e
        yvI4cjM7nsdAUfVC7hBSfKBPuRBwAYysD/eMV+PnW53riS46W6uGpAuNsAimiem16im9jP
        QhYaq6lPyOIPjRDyTbJlkHkVVDc5krQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-VvHIn_8ROualJahGoRy_RA-1; Thu, 11 Nov 2021 16:03:58 -0500
X-MC-Unique: VvHIn_8ROualJahGoRy_RA-1
Received: by mail-ed1-f69.google.com with SMTP id f20-20020a0564021e9400b003e2ad3eae74so6449902edf.5
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 13:03:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IydML5DPv4srmsLJbMzm6xiqLfe0nPlKjLPkLPNdgqo=;
        b=Pguv03wt7brfhh6xywUYy8/Na3bptU5rJV55UhD8hConpaRj0x0u9HnSubryWyhVed
         R0Mq9YmFR9dxzqJS7mDKDVz6GEwzlGLmU69f0Q6bifonF0uZJ5vpz1eQoYYBsyXSFGsR
         fyP+oMfWUI5O4bypAIUfCyeChd1r7nISbFxRBt53Tx9JVFRc3IAbsZm++/sg4MC6jKF0
         3/+bRhA/0Bis5aZdWq/cLo5ulNi/WH6PFu4SYYuYtl2+Phqabu68khEmmkFShE+eyeQr
         eSi6wx3pqc5a2lG8/gUMx3rODaudjOqbqIa292VWWrz08cvB0BBm8mrlxzEpUQQnMziC
         mduw==
X-Gm-Message-State: AOAM533TOElT9PjyeQKwyOw5m5a02PzuvjKhKcP2BlcdxD4Arfi8DNQq
        srSyBXCNytnoJ/b8IYEv72VfcL/Vy1aFuqIUxscTWcG79+hpuESRsAzZ6t6i4nEcr0wAlvro19C
        dohfmWp4P2Uqx
X-Received: by 2002:aa7:c783:: with SMTP id n3mr13644458eds.121.1636664637561;
        Thu, 11 Nov 2021 13:03:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMymsHK/1h+hemQOKA4MIl6K93YMxdGgL3ZavyJKSkTQrALPttxKCgsXFeQB+M6xm8rdyTFw==
X-Received: by 2002:aa7:c783:: with SMTP id n3mr13644415eds.121.1636664637276;
        Thu, 11 Nov 2021 13:03:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id m5sm1869497ejc.62.2021.11.11.13.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 13:03:56 -0800 (PST)
Message-ID: <6538605a-0df0-a30f-b30c-7361113cae86@redhat.com>
Date:   Thu, 11 Nov 2021 22:03:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] access: Split the reserved bit test for
 LA57
Content-Language: en-US
To:     Babu Moger <babu.moger@amd.com>, kvm@vger.kernel.org
References: <163666439473.76718.7019768408374724345.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <163666439473.76718.7019768408374724345.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 22:01, Babu Moger wrote:
> The test ./x86/access fails with a timeout when the system supports
> LA57.
> 
> ../tests/access
> BUILD_HEAD=49934b5a
> timeout -k 1s --foreground 180 /usr/local/bin/qemu-system-x86_64 --no-reboot
> -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4
> -vnc none -serial stdio -device pci-testdev -machine accel=kvm
> -kernel /tmp/tmp.X0UHRhah33 -smp 1 -cpu max # -initrd /tmp/tmp.4nqs81FZ5t
> enabling apic
> starting test
> 
> run
> ...........................................................................
> ...........................................................................
> ..................................................................
> 14008327 tests, 0 failures
> starting 5-level paging test.
> 
> run
> ...........................................................................
> ...........................................................................
> ........................................
> qemu-system-x86_64: terminating on signal 15 from pid 56169 (timeout)
> FAIL access (timeout; duration=180)
> 
> The reason is, the test runs twice when LA57 is supported.
> Once with 4-level paging and once with 5-level paging. It cannot complete
> both these tests with default timeout of 180 seconds.
> 
> Fix the problem by splitting the test into two.
> One for the 4-level paging and one for the 5-level paging.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> Note: Let me know if there is a better way to take care of this.

Aaron Lewis posted a series to separate the main() from everything else, 
so we can create two .c files for 4-level and 5-level page tables.

Paolo

> 
>   x86/access.c      |   23 ++++++++++++++++-------
>   x86/unittests.cfg |    6 ++++++
>   2 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 4725bbd..d25066a 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -1141,19 +1141,28 @@ static int ac_test_run(void)
>       return successes == tests;
>   }
>   
> -int main(void)
> +int main(int argc, char *argv[])
>   {
> -    int r;
> -
> -    printf("starting test\n\n");
> -    page_table_levels = 4;
> -    r = ac_test_run();
> +    int r, la57;
> +
> +    if ((argc == 2) && (strcmp(argv[1], "la57") == 0)) {
> +        if (this_cpu_has(X86_FEATURE_LA57))
> +            la57 = 1;
> +        else {
> +            report_skip("5-level paging not supported, skip...");
> +            return report_summary();
> +        }
> +    }
>   
> -    if (this_cpu_has(X86_FEATURE_LA57)) {
> +    if (la57) {
>           page_table_levels = 5;
>           printf("starting 5-level paging test.\n\n");
>           setup_5level_page_table();
>           r = ac_test_run();
> +    } else {
> +        page_table_levels = 4;
> +        printf("starting test.\n\n");
> +        r = ac_test_run();
>       }
>   
>       return r ? 0 : 1;
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 3000e53..475fcc6 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -119,6 +119,12 @@ arch = x86_64
>   extra_params = -cpu max
>   timeout = 180
>   
> +[access-la57]
> +file = access.flat
> +arch = x86_64
> +extra_params = -cpu max -append "la57"
> +timeout = 180
> +
>   [access-reduced-maxphyaddr]
>   file = access.flat
>   arch = x86_64
> 
> 
> 

