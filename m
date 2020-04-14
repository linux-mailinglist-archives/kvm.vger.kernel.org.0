Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A111A75D1
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 10:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436590AbgDNIWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 04:22:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436563AbgDNIWQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 04:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586852535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=khsYuuaqf4bvQT/Yq3CGFsX0wY63XL0/uUheX8GkUqg=;
        b=drXcEijJ2/p3wq9A5Vw1q4g9XjnLrcj+LOLQSBauLjtCKgNRJLbLs+EHwoWvy0j/WKPbLI
        zKviyXJq89Hi+gFb/cQWGYe1XluCsAHNhdgcrKPsag7o/GKBFG+fFK1xDJfHkJF+B65W0X
        e4OnGXUnWZJ58YgvpiqALdd6ld1ACiE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-myAx_GFLMv6IM0c0NMTLdQ-1; Tue, 14 Apr 2020 04:22:13 -0400
X-MC-Unique: myAx_GFLMv6IM0c0NMTLdQ-1
Received: by mail-wr1-f71.google.com with SMTP id d17so7290230wrr.17
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 01:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=khsYuuaqf4bvQT/Yq3CGFsX0wY63XL0/uUheX8GkUqg=;
        b=P26xgeKXbLWpU5vCzzjt5zfIfVrUAhyWYPqjbK4n69PfREb9xBZBb9m0AZDFXT5hSU
         lnhEirnNBc9EodC3E7kVJ8KybmgYmqnkUnofTnsfHW/fiNzAtZnr3Qx3ZacbDixgjqNO
         JxkhTPd/dooMTqhDqurl8vA1FQnmCA6mTiSEgO/QxOTWnbmO46zWteWCrx8v16l2bnGW
         skGB2K4qR14kwT5vWdBy9xcp9J+q7bhbb7Zm4LvkfEalLFmaD/njGOhEm7OJOIULF0dg
         VjZSoVsUc2Xw/vbNqcTpZ946K8rzkk2fwZ4b7XVyrISI3BA9TGbanV7LfBsG8yAie7gE
         l8nA==
X-Gm-Message-State: AGi0PuZ+Fi79G4x99bTRNg6iAnKDPW+vfXE3SuBJYC8FDR9M2kBR++/K
        FLmaaFOSutZhQA8tnXdySjBWr1QeMpOxdOtekhelpmTuHTWad8bbfQ6LRRtVk5iVX1KCKEnaFXM
        3uhpXGVwfMquS
X-Received: by 2002:adf:f589:: with SMTP id f9mr21599303wro.383.1586852532069;
        Tue, 14 Apr 2020 01:22:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypJXNvwyrDhlIZv6Lqrf27xeg9ssywvSfUWlGqAV2uY+TaUeX/Zn8tG1WxQsOeeksY9aUQ5+FQ==
X-Received: by 2002:adf:f589:: with SMTP id f9mr21599289wro.383.1586852531851;
        Tue, 14 Apr 2020 01:22:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e159:eda1:c472:fcfa? ([2001:b07:6468:f312:e159:eda1:c472:fcfa])
        by smtp.gmail.com with ESMTPSA id t67sm18954537wmg.40.2020.04.14.01.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 01:22:11 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Enable machine check support for 32bit targets
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
References: <20200414071414.45636-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4b74196-703f-fbcb-2b1b-7432ed76301d@redhat.com>
Date:   Tue, 14 Apr 2020 10:22:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414071414.45636-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/20 09:14, Uros Bizjak wrote:
> There is no reason to limit the use of do_machine_check
> to 64bit targets. MCE handling works for both target familes.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: stable@vger.kernel.org
> Fixes: a0861c02a981 ("KVM: Add VT-x machine check support")
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8959514eaf0f..01330096ff3e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4572,7 +4572,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
>   */
>  static void kvm_machine_check(void)
>  {
> -#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
> +#if defined(CONFIG_X86_MCE)
>  	struct pt_regs regs = {
>  		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
>  		.flags = X86_EFLAGS_IF,
> 

Queued, thanks.

Paolo

