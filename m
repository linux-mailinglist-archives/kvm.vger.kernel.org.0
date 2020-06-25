Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C87F209E7D
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 14:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404578AbgFYMdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 08:33:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404343AbgFYMdC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 08:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593088381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4QAA6xTzivbUQMA9MfIr8KswP1KP4qpqOKsLkXMz+OE=;
        b=hquYfcFjFb3GQTuEInUnMWpfkFSqcr3qx+4jDfZwggx1P6M5iJciZu5ipc/PhmM4FMZ99i
        1TnZ1GMsnTjqXaTGY5N/95O3AI7Yy+Iw9MoPTn1KikKcK5k01gz/Wxrk6RP9tcee3wnzJd
        YSvNPXV/7Bbr4N2J4f84ZzcGuPIxOvw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-fEUBl5GKPM-poKqdBgnlAg-1; Thu, 25 Jun 2020 08:32:59 -0400
X-MC-Unique: fEUBl5GKPM-poKqdBgnlAg-1
Received: by mail-wm1-f69.google.com with SMTP id t18so6904010wmj.5
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 05:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4QAA6xTzivbUQMA9MfIr8KswP1KP4qpqOKsLkXMz+OE=;
        b=FdX+VLCiFga/saki6ldwhnbwifTLQCx7CXzaQfo8JkcUAW1F44h3zzzKnUCH9Vi3yH
         RIPIFdYd1VG0Tz3NvOMWyRuezFHtbr9vUTb6v9kQYqX4JV42dUGUKHBwcvWfR+y84OZv
         weA5whVSJXhWIIfpBFF1zepqx4UXn5ZhRAA8Y6Uf94OinKdM6rCZ2iOdxVKPAmOhHaBn
         geJCHqf+YLZQ4ZX0GcqdDN/yQ0nM8bk8xbp1/IfJwvLyzvRhjTGCHuMxCbk7PNn5E6gL
         8vTtbBMcxj0qfhS4mwe1UdrZpppE0hZ2WvNfJ9bqkcBnsSoi6D7smb3UMlqM110eTqBc
         zlGg==
X-Gm-Message-State: AOAM530Mt0lcbKvACmbjSATcf1MnPX9h4nEk1GceoGR4fyCLYd4de+g4
        OGvCHxDyeMDXVrkaqWE3WgXfLiHKl+VGe5bb++oQ6jW30Py8yH1lvI5efCdtx+nituUTXPcnSEG
        gertK5BpTI83z
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr36129918wrr.230.1593088378326;
        Thu, 25 Jun 2020 05:32:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJza6yC5dQ/KR4rQM92i44NL4zzevHmVpFRpkaZKX3IcBVU9bdyAaS6xr67Dsr0Uv3NHlppSyg==
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr36129899wrr.230.1593088378068;
        Thu, 25 Jun 2020 05:32:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id b18sm30801881wrn.88.2020.06.25.05.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 05:32:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Use VMCALL and VMMCALL mnemonics in kvm_para.h
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200623183439.5526-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30a01d1f-5b36-5171-3d0a-e14fa7afa62e@redhat.com>
Date:   Thu, 25 Jun 2020 14:32:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200623183439.5526-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 20:34, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.23,
> which supports VMCALL and VMMCALL instruction mnemonics.
> 
> Replace the byte-wise specification of VMCALL and
> VMMCALL with these proper mnemonics.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_para.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 49d3a9edb06f..01317493807e 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -18,7 +18,7 @@ static inline bool kvm_check_and_clear_guest_paused(void)
>  #endif /* CONFIG_KVM_GUEST */
>  
>  #define KVM_HYPERCALL \
> -        ALTERNATIVE(".byte 0x0f,0x01,0xc1", ".byte 0x0f,0x01,0xd9", X86_FEATURE_VMMCALL)
> +        ALTERNATIVE("vmcall", "vmmcall", X86_FEATURE_VMMCALL)
>  
>  /* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
>   * instruction.  The hypervisor may replace it with something else but only the
> 

Queued, thanks.

