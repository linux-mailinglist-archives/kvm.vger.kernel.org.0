Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969B44D3022
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiCINnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiCINnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:43:04 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0A817B0F5;
        Wed,  9 Mar 2022 05:42:05 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w4so2888772edc.7;
        Wed, 09 Mar 2022 05:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zt0JZXd3BcUZQg6JhqB3BFQru0cX6brxk1RPv5xOa4I=;
        b=juMUTyXdz5Y8mNC7gU87ZBtfM22WHmaFsNZdEl7vgwy6xH6uKh2pcpRXnkEu0Zh3Xg
         0dToXIjny5YentlxxLc43ytz32FY3QnYUZam83CtoYL2YYYS+6/KQgRXwaF0I4ni/QDC
         +9i5DQWJCU/5ottdA/p8u0a7UYkaxOCdOKHV0dexABPuA9nwManlCHnTzODjJGjYiyeU
         RIyAsnfpGk7ejTZFcczUNh35pR19DbCBZ/HGIDEn61BE0CqTipOGmv5Kqt5iq7oZioTQ
         lM9mLJ3OfGtoIQRs2rgF0RKnt+8wQa8AJaYgVSB+RvrzUIrWrpBIyRlq5NCLbG+ZkiXQ
         KxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zt0JZXd3BcUZQg6JhqB3BFQru0cX6brxk1RPv5xOa4I=;
        b=5vS+CVCKpFk2zWOI+5DKbIdnrNpgIS5Y1hqvTZHD1uzB8HSMz1wTF2LwlYc6Fucuso
         NcOJoYafMxZvMlbbM+Epch4kVmh4tiIEiDKHtnONVkzVBZlPVGugugL8OfKKNfUKxmhi
         oh6dXk+MO7pygp4eUFYyAMGd2zx2rfX8WI7fBSuspoHy4kP+tahcZLTWl8ATU9Zs9yuz
         SYornrf0NzKK2eZ4hs99ZZ3MMLR2bPVLpAZOOqTyVw4tOu/quZ3+eKgm8C3h2smARfAO
         9r52PYqMKeGL0H4SJamUWm0fCHt73Ssk9FKSCAM0huCdOs9xiQ5ofWfYotM2EUNsA9FC
         drwg==
X-Gm-Message-State: AOAM532viTqm/8e7zHxemPdmVOb1IDlnHqIxJ0kS6bDRBLR3/CBPnM62
        Nn6Cxuk7QR/qCowMTF1fmMc=
X-Google-Smtp-Source: ABdhPJxe7XnM8UWkKCp9IqePxJ945fWMdQbUJYAX1y6i3UJT1vVuZXwrphdBDdvO2iek8Tvj0/nNSQ==
X-Received: by 2002:a50:9505:0:b0:416:4496:5ec4 with SMTP id u5-20020a509505000000b0041644965ec4mr15590109eda.309.1646833323973;
        Wed, 09 Mar 2022 05:42:03 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e5-20020a170906374500b006d5825520a7sm752037ejc.71.2022.03.09.05.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 05:42:03 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <68233503-3ac5-9161-c83d-6b8189dedc8f@redhat.com>
Date:   Wed, 9 Mar 2022 14:41:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 6/7] KVM: x86: SVM: allow to force AVIC to be enabled
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
 <20220301143650.143749-7-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301143650.143749-7-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 15:36, Maxim Levitsky wrote:
> Apparently on some systems AVIC is disabled in CPUID but still usable.
> 
> Allow the user to override the CPUID if the user is willing to
> take the risk.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/svm.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 776585dd77769..a26b4c899899e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -202,6 +202,9 @@ module_param(tsc_scaling, int, 0444);
>   static bool avic;
>   module_param(avic, bool, 0444);
>   
> +static bool force_avic;
> +module_param_unsafe(force_avic, bool, 0444);
> +
>   bool __read_mostly dump_invalid_vmcb;
>   module_param(dump_invalid_vmcb, bool, 0644);
>   
> @@ -4896,10 +4899,14 @@ static __init int svm_hardware_setup(void)
>   			nrips = false;
>   	}
>   
> -	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
> +	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
>   
>   	if (enable_apicv) {
> -		pr_info("AVIC enabled\n");
> +		if (!boot_cpu_has(X86_FEATURE_AVIC)) {
> +			pr_warn("AVIC is not supported in CPUID but force enabled");
> +			pr_warn("Your system might crash and burn");
> +		} else
> +			pr_info("AVIC enabled\n");
>   
>   		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>   	} else {

Queued, thanks.

Paolo
