Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2671C3F38
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgEDP7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:59:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26215 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728158AbgEDP7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 11:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588607958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ddTUPWkbJZYVFUnajNbkHHVyfS6o34xZoLIhU7FW+jg=;
        b=Yi8sXLZjyxTsML+zKt5EODuouNcbfUCwAJ9/0rT25hNqCjY5t3iIaxbvF2TdMnm5YpW+SN
        kZtvRL8FRNhaAy+5JpbT1YqVuKeCdQ4dkNmtW/XUBZsfkYd8hq7oNN9Fgj9fd4EUwD3+T+
        FuJeM7Ytp3lM7TPXXdvPEHhq3wvVEno=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-8rbctE2rMWuiUQSdTTE8hA-1; Mon, 04 May 2020 11:59:16 -0400
X-MC-Unique: 8rbctE2rMWuiUQSdTTE8hA-1
Received: by mail-wr1-f72.google.com with SMTP id p8so207004wrj.5
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 08:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ddTUPWkbJZYVFUnajNbkHHVyfS6o34xZoLIhU7FW+jg=;
        b=OST137tISGhjAhxJuf/0FW3VJYdEXOJqUFib3wiw4NMa+CCMN7NBopG0dwAqo40NdJ
         DJE1YIheUEPEaip5XAvCmnwbWg4UHDKf7vtGN7qoAN/KH4fEj4x5WE4BzyilWnW43eEe
         o5SynJt8k7UDCuQdCaI4HqXCKEJSxe6omyHpXfO5H7VJTigM0zk14/PhepfECQ3fOqWE
         1LJgVah3NTHKbDizBS0HHw0c9AR1GxlWelpowR4RRx1eOsLUZMehIxIe7bCL1yJjp18V
         1fOreL3nAh7hfUDN/PfyuKiNHvWZtDtPrB5xd6IGipDZiCAJfaCsbrfZwdgGX2ABBpAe
         sSpA==
X-Gm-Message-State: AGi0PuZUhJLSIm9SS2FUf0gYjQJDdbZ6a3GOR3LJGLcKSFzHPtj8Ua8q
        xpFHfLX3mYZfw4KKpx5VU2OudurjUfbqiWPCCzm9x6brbVmrIU/SwIcnR99dUG3XRo4iUM4thEc
        8MQB+7SW5r5OU
X-Received: by 2002:adf:978c:: with SMTP id s12mr19581295wrb.312.1588607955104;
        Mon, 04 May 2020 08:59:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypKUqGAxLl3kZdLQFzFsFd2o5zy5mB1ZhUTdut7W7BydbWo04mR7HS8DgBwu2lrAv8x64l5OJw==
X-Received: by 2002:adf:978c:: with SMTP id s12mr19581276wrb.312.1588607954889;
        Mon, 04 May 2020 08:59:14 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id f7sm18140805wrt.10.2020.05.04.08.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 08:59:14 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Replace a BUG_ON(1) with BUG() to squash clang
 warning
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
References: <20200504153506.28898-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5bf03dc1-c5b1-8264-6361-e85c523a2fa4@redhat.com>
Date:   Mon, 4 May 2020 17:59:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504153506.28898-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 17:35, Sean Christopherson wrote:
> Use BUG() in the impossible-to-hit default case when switching on the
> scope of INVEPT to squash a warning with clang 11 due to clang treating
> the BUG_ON() as conditional.
> 
>   >> arch/x86/kvm/vmx/nested.c:5246:3: warning: variable 'roots_to_free'
>      is used uninitialized whenever 'if' condition is false
>      [-Wsometimes-uninitialized]
>                    BUG_ON(1);
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: ce8fe7b77bd8 ("KVM: nVMX: Free only the affected contexts when emulating INVEPT")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2c36f3f53108..669445136144 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5249,7 +5249,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>  		roots_to_free = KVM_MMU_ROOTS_ALL;
>  		break;
>  	default:
> -		BUG_ON(1);
> +		BUG();
>  		break;
>  	}
>  
> 

Queued, thanks.

Paolo

