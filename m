Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A037D3B160D
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 10:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhFWInS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 04:43:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhFWInR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 04:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624437659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ld36iI6CJbK052bnFVTBuWxw3HHNZj3O8BLNvtmlPXo=;
        b=KCtocj1/LSdaHjkjtd4dR0NTqqbLbH7Pky1OXEHLTkWcq+qbvdBl0y7k9BcLgSl+TDMa2H
        tW678P+mkIkgrb8l8O9cFNKv2qr2vq5i3hv2EQnyBGKJBGGdpu8Cwnm42ZJjxdjKZ7KTHy
        KQRHXRWuAfXsom/xtJ3Ec+7YEInx2+g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-CneUkXjMM7uncHnEilyu7g-1; Wed, 23 Jun 2021 04:40:58 -0400
X-MC-Unique: CneUkXjMM7uncHnEilyu7g-1
Received: by mail-wm1-f71.google.com with SMTP id m6-20020a7bce060000b02901d2a0c361bfso1284177wmc.4
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 01:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ld36iI6CJbK052bnFVTBuWxw3HHNZj3O8BLNvtmlPXo=;
        b=DiyJt8VjVvtm1SIW6zr1UlvoufT/UvFK1o0kn4QaKhYlIVzFcFbggT9u8XxcOXJKsT
         Qy9ulahIe3oAFMS8pvIZ1ErpiGIok9MWr/0XVTXRsjDtyNht5eEBKYveyyl639cx7L2z
         diP2xtGV9SRzwAFZTS88kj5bKHLqacMzk8Ls6DTaF7FVd6vK5ffaD6CTTixRQAFBaky/
         qMLYYM5o6FbqlbCSVYagwRMpeEb0koVgfmEYcfT/CjzmllDJ1jgDZhuAU3nr189dirIj
         0mYLJCAEYuUQM5O4O+rc3FfgLQF0FRyTJ0+zLh5+3CtHdvl07cav8J43daKQ3kSafGB3
         1a2Q==
X-Gm-Message-State: AOAM533NXbKVW1iBQaxZXvCkDTyhJJkiS9i37/+FPZOLCrgKD2lb8uZc
        cdQXrLF8oE3zfGhHMIMzpCmp+QAkyKvuGt/NdDWDby1t2h/N3fD5dHBlToqmO6dDivbbU4Q4WKp
        YDmpRs2/iF5qT4C2rdTSiEcJoFHDH2UwNoF5BnJW0tgttqeIHli90+vdl8YtoCRgN
X-Received: by 2002:a7b:c24f:: with SMTP id b15mr9429506wmj.96.1624437657029;
        Wed, 23 Jun 2021 01:40:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSscuwfwiI47KY2nibL6R0QqrX+7l1qj+KjrZIJUIEukNJtCFkKVyJXopwV/cIGxSYf2yU3A==
X-Received: by 2002:a7b:c24f:: with SMTP id b15mr9429493wmj.96.1624437656848;
        Wed, 23 Jun 2021 01:40:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w13sm2272239wrc.31.2021.06.23.01.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 01:40:56 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: svm: Skip NPT-only part of guest CR3
 tests when NPT is disabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210422025448.3475200-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f740edc-4c5b-97d0-65eb-58d13f8ee245@redhat.com>
Date:   Wed, 23 Jun 2021 10:40:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210422025448.3475200-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 04:54, Sean Christopherson wrote:
> Skip the sub-tests for guest CR3 that rely on NPT, unsurprisingly they
> fail when running with NPT disabled.  Alternatively, the test could be
> modified to poke into the legacy page tables, but obviously no one
> actually cares that much about shadow paging.
> 
> Fixes: 6d0ecbf ("nSVM: Test non-MBZ reserved bits in CR3 in long mode and legacy PAE mode")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   x86/svm_tests.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 29a0b59..353ab6b 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2237,6 +2237,9 @@ static void test_cr3(void)
>   
>   	vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
>   
> +	if (!npt_supported())
> +		goto skip_npt_only;
> +
>   	/* Clear P (Present) bit in NPT in order to trigger #NPF */
>   	pdpe[0] &= ~1ULL;
>   
> @@ -2255,6 +2258,8 @@ static void test_cr3(void)
>   	    SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
>   
>   	pdpe[0] |= 1ULL;
> +
> +skip_npt_only:
>   	vmcb->save.cr3 = cr3_saved;
>   	vmcb->save.cr4 = cr4_saved;
>   }
> 

Queued now, thanks!

Paolo

