Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECD4580357
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 19:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbiGYRJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 13:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiGYRJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 13:09:20 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AB517A8C;
        Mon, 25 Jul 2022 10:09:19 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ss3so21654663ejc.11;
        Mon, 25 Jul 2022 10:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xhWpC8JbYbPY2K4E0t5gdrGAdCwvkqCy1aHXAcFQrpI=;
        b=QNFIa3/xRREtNeYRud5jAVpPgouu92NjB03+0S/yoLPGepemhUp6xf0I3xMz6ULt05
         Qh/1MInQvQcvxoZE0Ib2KUIOLecrVMLrVDSnR5ngvVZ5lCVphPXc8AKRSTgSiVbo6voZ
         pKcNxufUXme7DsnrJHtpcx3krQ+qDiq29hN29yfzd50hoGznhnZZyjD3TpnkFsGG2ZL5
         GkGV9w06caUMCxD6kWXuar/XYKi7XWR7dmjuxYRBPABOG2UdmNV1N+RrqnsTZ8/S656q
         d1oJReA5Lb7C4i+SXOnBwrHCYkNiIrWjNnv0TYglrFquvQu52Tc2yzOEEHTE3ALoAAQV
         rppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xhWpC8JbYbPY2K4E0t5gdrGAdCwvkqCy1aHXAcFQrpI=;
        b=1z1XVOayuvhlHLMKLSVjm6B0/YzyrnGhveg7+8B5IR97YtiArkdAQNPHehLX7TnugY
         DS4jnLDi+srzxNw7+7gONx+WGlem0Y/A350MNt4xh6a9VU3CWv/m46BuznXv8a1ceztQ
         XGAjh82rhZyTH1OEyL5GJji3UQTPwH7JrE6AfMeRgWZG2sbvMzdMY7xddmMhiXlaTv5o
         ldyviHWHYbsHNe5+3jDOeoapH39A+HS0r6odP7JW7qoXPz0QzFc9U1cHxC3EkFslD2b9
         Pytwr5I/m98ZHq4I7Z5vrIfX9Pd/rO087T7l7d6aeaYJzYWMpAL50WevZTygQQiq1jmP
         qIYw==
X-Gm-Message-State: AJIora8nv3tXsi+ZmMfNJQVigRwGRqTmiDQLFDxgBTZtoI0TsLiURHlZ
        yIML2xPzp2KiI2lUH32Ep3s=
X-Google-Smtp-Source: AGRyM1usTswj3cKvI95R+nrvoKBYTgtax0V4MeljgNejZmXtPNuyq9jJuFsyWlRbgPoQuy0VD/5SyA==
X-Received: by 2002:a17:907:1c95:b0:72b:4e37:7736 with SMTP id nb21-20020a1709071c9500b0072b4e377736mr10743421ejc.516.1658768958328;
        Mon, 25 Jul 2022 10:09:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t25-20020aa7d719000000b0043a6c9e50f4sm7396662edq.29.2022.07.25.10.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 10:09:17 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <48de7ea7-fc1a-6a83-3d6f-e04d26ea2f05@redhat.com>
Date:   Mon, 25 Jul 2022 19:09:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 09/25] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-10-vkuznets@redhat.com> <YtnMIkFI469Ub9vB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtnMIkFI469Ub9vB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 23:58, Sean Christopherson wrote:
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index b5cfbf7d487b..7b348a03e096 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -355,11 +355,6 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>          return 0;
>   }
> 
> -enum evmcs_v1_revision {
> -       EVMCSv1_2016,
> -       EVMCSv1_2022,
> -};
> -
>   enum evmcs_unsupported_ctrl_type {
>          EVMCS_EXIT_CTLS,
>          EVMCS_ENTRY_CTLS,
> @@ -372,29 +367,29 @@ static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
>                                        enum evmcs_unsupported_ctrl_type ctrl_type)
>   {
>          struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> -       enum evmcs_v1_revision evmcs_rev = EVMCSv1_2016;
> +       bool has_evmcs_2022_features;
> 
>          if (!hv_vcpu)
>                  return 0;
> 
> -       if (hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
> -               evmcs_rev = EVMCSv1_2022;
> +       has_evmcs_2022_features = hv_vcpu->cpuid_cache.nested_ebx &
> +                                 HV_X64_NESTED_EVMCS1_2022_UPDATE;
> 
>          switch (ctrl_type) {
>          case EVMCS_EXIT_CTLS:
> -               if (evmcs_rev == EVMCSv1_2016)
> +               if (!has_evmcs_2022_features)
>                          return EVMCS1_UNSUPPORTED_VMEXIT_CTRL |
>                                  VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
>                  else
>                          return EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>          case EVMCS_ENTRY_CTLS:
> -               if (evmcs_rev == EVMCSv1_2016)
> +               if (!has_evmcs_2022_features)
>                          return EVMCS1_UNSUPPORTED_VMENTRY_CTRL |
>                                  VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>                  else
>                          return EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
>          case EVMCS_2NDEXEC:
> -               if (evmcs_rev == EVMCSv1_2016)
> +               if (!has_evmcs_2022_features)
>                          return EVMCS1_UNSUPPORTED_2NDEXEC |
>                                  SECONDARY_EXEC_TSC_SCALING;
>                  else
> 

I kind of like the idea of having a two-dimensional array based on the 
enums instead of switch statements, so for now I'll keep Vitaly's enums.

Paolo
