Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459753C16F2
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 18:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhGHQUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 12:20:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhGHQUq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 12:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625761084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m9j0fgT60+2/e0HhcHcfYjSR793UpMTP7LOw8dx+WmU=;
        b=BJYRcCPVIO+sX4d7JP+oHXbV2QHddoz4FO6pViLn35MQgunT2xfxzB+W5QanFADh4zZpvw
        XPCezolJtRADm4I1+PvF2SFehswkdhaznpd7ut/zwINEvXGZ2OK8KzyyJxtN3WosOAgAa7
        5FsXCO/OVD0j7kte0htssHjX40JCdGY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-jzjG6xvQNCuclCihc7RIzA-1; Thu, 08 Jul 2021 12:18:02 -0400
X-MC-Unique: jzjG6xvQNCuclCihc7RIzA-1
Received: by mail-ed1-f72.google.com with SMTP id y18-20020a0564022712b029038ffac1995eso3605450edd.12
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 09:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m9j0fgT60+2/e0HhcHcfYjSR793UpMTP7LOw8dx+WmU=;
        b=ExT0eSktnFTOO1D3C65JnN8NZWnWPNl1lNeuzT9TgJvsQfksp5mtjyFSt4Nk0OjnuQ
         NKRvHmcROW3egxCe8vG5Je11jalIS9CLR9Cyr3x8nyrY07Cako6oubej2ui2zt/rSlvP
         xLcI0T6t1m4mf890Ka8WGAu81BKQ2ucTsJXlraa9QbyLnux1wzwgDHk70yvzRYBbsYFG
         4FfliW/lEYPnhI1UCWVOP/bq2J16cSfTGs92B7aEV+7uIhUZWm506QmKUpyGVs+M2h6U
         HafiKwzWlkgE1SWpWK8B9TxzDGD/Tp2U8o9/4R6Ch3C/Lj9928MRzQn8YCuKgxdJKKxg
         RjjQ==
X-Gm-Message-State: AOAM530050zUCun5EDy4OYizfOTSp18XNtU/8PI1f2VSlm65wDjuV9lL
        piMvsC8s6HVhUsK5UPAheoRJul82uyFWw2Qs6So2gCXWdRcEgTJQPsugc8dk4KI355RtNQZRJgg
        lRakpO2S8E/Y3
X-Received: by 2002:a17:906:8584:: with SMTP id v4mr31620044ejx.301.1625761081746;
        Thu, 08 Jul 2021 09:18:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrusHA0pBCSrA1fd/X22PtmeBy7767Uwpwxg/gdkQaycnP2jWXEycjCC8XUgx7fHyY9loSLg==
X-Received: by 2002:a17:906:8584:: with SMTP id v4mr31620017ejx.301.1625761081541;
        Thu, 08 Jul 2021 09:18:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ja11sm1182528ejc.62.2021.07.08.09.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 09:18:01 -0700 (PDT)
Subject: Re: [PATCH] Revert "KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210625001853.318148-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <28ec9d07-756b-f546-dad1-0af751167838@redhat.com>
Date:   Thu, 8 Jul 2021 18:17:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625001853.318148-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 02:18, Sean Christopherson wrote:
> Let KVM load if EFER.NX=0 even if NX is supported, the analysis and
> testing (or lack thereof) for the non-PAE host case was garbage.
> 
> If the kernel won't be using PAE paging, .Ldefault_entry in head_32.S
> skips over the entire EFER sequence.  Hopefully that can be changed in
> the future to allow KVM to require EFER.NX, but the motivation behind
> KVM's requirement isn't yet merged.  Reverting and revisiting the mess
> at a later date is by far the safest approach.
> 
> This reverts commit 8bbed95d2cb6e5de8a342d761a89b0a04faed7be.
> 
> Fixes: 8bbed95d2cb6 ("KVM: x86: WARN and reject loading KVM if NX is supported but not enabled")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Hopefully it's not too late to just drop the original patch...
> 
>   arch/x86/kvm/x86.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4a597aafe637..1cc02a3685d0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10981,9 +10981,6 @@ int kvm_arch_hardware_setup(void *opaque)
>   	int r;
>   
>   	rdmsrl_safe(MSR_EFER, &host_efer);
> -	if (WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_NX) &&
> -			 !(host_efer & EFER_NX)))
> -		return -EIO;
>   
>   	if (boot_cpu_has(X86_FEATURE_XSAVES))
>   		rdmsrl(MSR_IA32_XSS, host_xss);
> 

So do we want this or "depends on X86_64 || X86_PAE"?

Paolo

