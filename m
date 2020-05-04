Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD7B1C3FFF
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgEDQfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:35:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729602AbgEDQfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588610107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DrDH6ghGzyKcUJxYpkBmogX/C6/pE28sgM6OjDELncQ=;
        b=VwPnCPx4nlA1K80x7NS+23wOuqsmeQXpqYBdXUIS8pN7E1w2NqOERZYsSju2ZPLNLg1LWf
        hLcUgTBZvGivfDemll5nCSUWzWKEmuwcjr4fYte/xxxH/jsSEK5AOyApDQGZUwS0fhPy9+
        Ph3JRzw+LHS1tiog6lJHj58F4/W2pnU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-gVxqPwPuNDiKQcyi_LGW7g-1; Mon, 04 May 2020 12:35:06 -0400
X-MC-Unique: gVxqPwPuNDiKQcyi_LGW7g-1
Received: by mail-wm1-f72.google.com with SMTP id w2so83429wmc.3
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DrDH6ghGzyKcUJxYpkBmogX/C6/pE28sgM6OjDELncQ=;
        b=l2FlHsEfBCKxQvLJjHPYwF9d6WEG3HgscuLcFt49QFQ9RxttgGeysuKqVAko2rnBJJ
         tGMm8qEFWR2lRXbmoZ3hR5yqZ95Rbc7dE4mR+NHhW2MM8+XP0IMWixLRWbLv9xHTtLSX
         BYdmWMMPLxU+1uyoRsoXbrWjUBUXQ6XFG2OaZme+/SjuIDlzw4QJUjOB7wiZICB4RACi
         A8uTLZlvpummGGUdrSHyNyhbthagWI2DOs705qzQh+6ClTDlvuN3daP9/dwpKpiTbpxh
         XymmEWpS+lA7WQg2vOvXjWnlYQTsYwgx27STB38kHYdecFn5rW2BjdDjj+PSWHO94vh9
         +K1A==
X-Gm-Message-State: AGi0PubqQAgqTH7a+vYCmdTiY8APqF88D1fM24cqSCPOjPpT+nawUhKm
        u2UWXSvVWnI9pZn7eNwPBLSLtWnF1wuGypgR1VYzMlw8AagKQvM2B0pNJ2W8LETekjwYKzvtiEW
        IqLlHLVTxroqT
X-Received: by 2002:adf:e511:: with SMTP id j17mr180986wrm.204.1588610104723;
        Mon, 04 May 2020 09:35:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypK7m8dCZk+3SXvCasKSf+G/63e9F96LovywgNA7XWEzGoHgj0nSbjBYsFZjABk8xp58z4zl1w==
X-Received: by 2002:adf:e511:: with SMTP id j17mr180960wrm.204.1588610104434;
        Mon, 04 May 2020 09:35:04 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id s14sm14546360wme.33.2020.05.04.09.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:35:03 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: msr: Don't test bits 63:32 of
 SYSENTER MSRs on 32-bit builds
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200428231135.12903-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2607f2df-a1a1-509a-d54c-b1bd63c6ec0e@redhat.com>
Date:   Mon, 4 May 2020 18:35:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200428231135.12903-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 01:11, Sean Christopherson wrote:
> Squish the "address" stuffed into SYSENTER_EIP/ESP into an unsigned long
> so as to drop bits 63:32 on 32-bit builds.  VMX diverges from bare metal
> in the sense that the associated VMCS fields are natural width fields,
> whereas the actual MSRs hold 64-bit values, even on CPUs that don't
> support 64-bit mode.  This causes the tests to fail if bits 63:32 are
> non-zero and a VM-Exit/VM-Enter occurs on and/or between WRMSR/RDMSR,
> e.g. when running the tests in L1 or deeper.
> 
> Don't bother trying to actually test that bits 63:32 are dropped, the
> behavior depends on the (virtual) CPU capabilities, not the build, and
> the behavior is specific to VMX as both SVM and bare metal preserve the
> full 64-bit values.  And because practically no one cares about 32-bit
> KVM, let alone an obscure architectural quirk that doesn't affect real
> world kernels.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/msr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/msr.c b/x86/msr.c
> index de2cb6d..f7539c3 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -16,6 +16,7 @@ struct msr_info {
>  
>  
>  #define addr_64 0x0000123456789abcULL
> +#define addr_ul (unsigned long)addr_64
>  
>  struct msr_info msr_info[] =
>  {
> @@ -23,10 +24,10 @@ struct msr_info msr_info[] =
>        .val_pairs = {{ .valid = 1, .value = 0x1234, .expected = 0x1234}}
>      },
>      { .index = 0x00000175, .name = "MSR_IA32_SYSENTER_ESP",
> -      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
> +      .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
>      },
>      { .index = 0x00000176, .name = "IA32_SYSENTER_EIP",
> -      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
> +      .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
>      },
>      { .index = 0x000001a0, .name = "MSR_IA32_MISC_ENABLE",
>        // reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
> 

Queued, thanks.

Paolo

