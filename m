Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3674F6378
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiDFPga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbiDFPgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:36:11 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03E1228A80;
        Wed,  6 Apr 2022 05:50:24 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id p23so2469881edi.8;
        Wed, 06 Apr 2022 05:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6mOjh8/nxxO7FhJS1LLehXmSXTMaZJKRB8nObFfsNbo=;
        b=n+wftPKFdTcnrOBFRPl1sie5LmQbBV4Wig3BYMdGK9jlCXGD33qoIKnOoA0hKOgrOg
         hl4p1bitVM7Po252GRKkBE9NVRvnOgcgYBLJrXPiJmzsaN1C4fF8NPFf+P17qmT4XDtT
         05kJ9L7ZeM/UeCe98MqHbLKj+Zy9AxnU3tQDO5fHP/SETPCw+6HFa6S7hd0BgqaHDLR0
         K3UChqnPPrp3NBrMpBCSbxfFlsAPAKQWLJSBoddpujVLTqD+2W24YYH4HO1SDYc2XEQH
         rtvC74nkItGO4r2tuFUoiLQR8ImnindXq9xbT1JxZDXKaV1VY4vTYUsr5SeYKcliT3N8
         xAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6mOjh8/nxxO7FhJS1LLehXmSXTMaZJKRB8nObFfsNbo=;
        b=zXcSocR2KE7NHYif7KBQkOb86wYN8I+x1b4Qc+yUXp4RiVm3RhhKnocfWYfGeZ5LNa
         4LUcqYt93CMY2e/1lrQxdub7QzXeSiCyXjdKNREjeRlFehmvz4leRSKgaBVPRWCHEBr3
         hKNXk4CFhFqpNFu2BfxEXfx+pvD1dFbw4jyGV99X4Vywjnlq890MZP3fyRynhwEnRP2B
         f3MiBupp3tEgBTzJeKMck4iV1SUj3QFjZ/Dw94DHG+dh1Vq8wJvKL2dr5WjtQuy/H/kB
         1Z/aB5V1pc5ikge4cUHOKW34bSnbe2rsSA3wKe8Wj9+o+xqNW72TV/bt6ld927DLhUTJ
         H+AA==
X-Gm-Message-State: AOAM532IpadvOUrQmcTYdS2KWKcU1TMGsJQWoSPLbRHhtM/kiS6JOd8k
        Ug4BU88wwtL+k2IQ8ZtuvPNN4d9XSkmsFg==
X-Google-Smtp-Source: ABdhPJzyNssuXxZzNjgnttY/wMDEhKqO5YSC/ufOaEXOMyVe2Hf2bJ3Aw7FVyWc7xv7gXzUS+eWR9w==
X-Received: by 2002:a05:6402:40cb:b0:419:42de:65b6 with SMTP id z11-20020a05640240cb00b0041942de65b6mr8624261edb.66.1649249357935;
        Wed, 06 Apr 2022 05:49:17 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j17-20020a05640211d100b00419357a2647sm8143114edw.25.2022.04.06.05.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 05:49:17 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <24bf735f-1f63-277e-02f1-dff90d5cfbab@redhat.com>
Date:   Wed, 6 Apr 2022 14:49:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 079/104] KVM: TDX: Implements vcpu
 request_immediate_exit
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <22f86f34055452b99a8d5bf2a707e40645e03334.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <22f86f34055452b99a8d5bf2a707e40645e03334.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Now we are able to inject interrupts into TDX vcpu, it's ready to block TDX
> vcpu.  Wire up kvm x86 methods for blocking/unblocking vcpu for TDX.  To
> unblock on pending events, request immediate exit methods is also needed.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index a0bcc4dca678..404a260796e4 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -280,6 +280,14 @@ static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
>   	vmx_enable_irq_window(vcpu);
>   }
>   
> +static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return __kvm_request_immediate_exit(vcpu);
> +
> +	vmx_request_immediate_exit(vcpu);
> +}
> +
>   static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -402,7 +410,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.check_intercept = vmx_check_intercept,
>   	.handle_exit_irqoff = vmx_handle_exit_irqoff,
>   
> -	.request_immediate_exit = vmx_request_immediate_exit,
> +	.request_immediate_exit = vt_request_immediate_exit,
>   
>   	.sched_in = vt_sched_in,
>   

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
