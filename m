Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A404B12E7
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244302AbiBJQgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:36:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244288AbiBJQgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:36:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F934E83
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UqSpSbLAke/1OnLd6EmGmfWxLdKIpRgwdlPw5Vgh4vE=;
        b=ElqIO/0CrkZOnKLP5RogCOAFlI0RNnAcQzDSQVdzxPHP1EMij87lrqHrY9qsmN6gROnogG
        HLp03RliVOm79dnCEHFa03G/9MERhPX6+PoqPZ6tZ0y/jb45YYMwufr5SLuH7efJq3NwQL
        /fzF+SLVz9rCKnnuIWoQ6l2Nbr12IkA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-lCPCgn6VOXuhGT_j14IfOA-1; Thu, 10 Feb 2022 11:36:50 -0500
X-MC-Unique: lCPCgn6VOXuhGT_j14IfOA-1
Received: by mail-ed1-f69.google.com with SMTP id f6-20020a0564021e8600b0040f662b99ffso3660836edf.7
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:36:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UqSpSbLAke/1OnLd6EmGmfWxLdKIpRgwdlPw5Vgh4vE=;
        b=ZvpXXbDavll/A+sFTrDjdEmggr5LIR0qyimiYg+egygycO3bunnWyGYX5BAC00/Pkh
         kUhLxfK+Bgtxi2tim9LNw4lP2D6ZoDGqnDAuEB5vnIKJsFibPOAQZ3YUWvo/P9X81pX5
         3tomsqqSjLXWb8gCMxDmM6W69JiLkFhXn8fa5+af88rkUJY0PKpp6gp86R8wWZJg20b+
         a8HYIXjQbpt9vdNV1b9aqV/nX2trwnfNyAux5wgnDgC4jVlqRCMdsF2j7W0uyYwgbjfa
         X0Jl9aDpRVUPL/r/UMkiohkz3/d2bYkkQxThG+JIvPWhQwOsqPao+4bqONJqugBblQKV
         702w==
X-Gm-Message-State: AOAM5318CQyBoivz2uMeuvhsz7BZ1kWwkGjm5kh0spPWpEB0l6gbzmoC
        ZN5Oh+qI5CyTOA2IsaOnETAspnM28mrK3YPIEXpKxxwBWihB7esvC1trOC+hfInM4ExHUr2j6T4
        lPlG1pBSqFoUf
X-Received: by 2002:a17:907:c01a:: with SMTP id ss26mr7188157ejc.734.1644511008818;
        Thu, 10 Feb 2022 08:36:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsICHo+zXE5V4n/hNFUlselQb7/jJjtRQ0Tylf3AFGMRI+O1AdLAbOvro//iFc+e5nfma5eg==
X-Received: by 2002:a17:907:c01a:: with SMTP id ss26mr7188140ejc.734.1644511008634;
        Thu, 10 Feb 2022 08:36:48 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.240])
        by smtp.googlemail.com with ESMTPSA id m25sm7118243edr.104.2022.02.10.08.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:36:47 -0800 (PST)
Message-ID: <d1d25157-6511-a37d-0e19-2ef8335a7882@redhat.com>
Date:   Thu, 10 Feb 2022 17:35:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.4 1/2] KVM: nVMX: eVMCS: Filter out
 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185733.49157-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185733.49157-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 19:57, Sasha Levin wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ Upstream commit 7a601e2cf61558dfd534a9ecaad09f5853ad8204 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Enlightened VMCS v1 doesn't have VMX_PREEMPTION_TIMER_VALUE field,
> PIN_BASED_VMX_PREEMPTION_TIMER is also filtered out already so it makes
> sense to filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER too.
> 
> Note, none of the currently existing Windows/Hyper-V versions are known
> to enable 'save VMX-preemption timer value' when eVMCS is in use, the
> change is aimed at making the filtering future proof.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220112170134.1904308-3-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/evmcs.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 07ebf6882a458..632bed227152e 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -58,7 +58,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>   	 SECONDARY_EXEC_SHADOW_VMCS |					\
>   	 SECONDARY_EXEC_TSC_SCALING |					\
>   	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
> -#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> +#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
> +	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
> +	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>   #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>   #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>   

