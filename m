Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0DE4B1318
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244469AbiBJQkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:40:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiBJQkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:40:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 056D9128
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kYbtrys6O/G8myu/5FfO900MqezhEujmkQ1qd2Z++7E=;
        b=d4zkNxT3nYex74RG8BGZxFkBeRYyh+CcyhGOjahPxn4o0fjh+85YY0mL8ObClDS0WXUVK8
        axg/t6sisFF++knE7j726cAIJniAAYegKPedSihSK/IWh27LaOGuuDGMQps7BMrpjBL0d3
        HPO0J96rGLe60CPIO8XFB55PXKegMRI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620--qKfUCcYPoqE7PeZm7H99A-1; Thu, 10 Feb 2022 11:40:18 -0500
X-MC-Unique: -qKfUCcYPoqE7PeZm7H99A-1
Received: by mail-ed1-f71.google.com with SMTP id f6-20020a0564021e8600b0040f662b99ffso3666367edf.7
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kYbtrys6O/G8myu/5FfO900MqezhEujmkQ1qd2Z++7E=;
        b=t8wDMnW9qfyRgDo/6IJVGIaSk0xx3/92Cb7fZVssownPVA7B1tFlXUn1aPSLMFc1gF
         +4El1Gcoi+BydOC/NWlt/wFwydNbsmGp4IG5+U+ePbEcizOio/Sx3Ll9QT8wKBtFMBq6
         chAaBXsQRz20ckGg2xzo6cO1Unzoz4F7cSThHIT6L1o5W5hEE98L/3pMCdi1rbsVGiO+
         E/ePBv5ioTIVb4DIENzR4AJwOFh+Lr0yHl6tRECkGkGov4A+KdD2Y56PVRBdRfwOStvi
         J8bGqPRgps5/NV152seLY6SnzgWyrqj4PADKlV17NKbOLEaygnsyPZW8TNTvfV1H4/cH
         3G0g==
X-Gm-Message-State: AOAM532b4hlFgwxgxd2jU6B289f97gzcHEz06XxJPh+DIMfsl54LzwDd
        4NvIv2EB345N1AY4KZRq5YJxyFpO+Yf3/wf5mX07Gp7VtehVNXj4ypAuXt20ItZWzpUEY7kSsrX
        SxLu2+UuMcM1D
X-Received: by 2002:a05:6402:1e92:: with SMTP id f18mr9091390edf.347.1644511216918;
        Thu, 10 Feb 2022 08:40:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTFOTCswQjhyOzYxQBHk4nDjaeCftIyJxXIZQ0G+0kIFDYPeXBEraXDJjtTI3TpPMCy9j4BQ==
X-Received: by 2002:a05:6402:1e92:: with SMTP id f18mr9091348edf.347.1644511216536;
        Thu, 10 Feb 2022 08:40:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p1sm7135746edy.69.2022.02.10.08.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:15 -0800 (PST)
Message-ID: <87b783e6-2bc7-636d-334e-1b09e05724d4@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 3/8] KVM: nVMX: Also filter
 MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185653.48833-1-sashal@kernel.org>
 <20220209185653.48833-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185653.48833-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 19:56, Sasha Levin wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ Upstream commit f80ae0ef089a09e8c18da43a382c3caac9a424a7 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Similar to MSR_IA32_VMX_EXIT_CTLS/MSR_IA32_VMX_TRUE_EXIT_CTLS,
> MSR_IA32_VMX_ENTRY_CTLS/MSR_IA32_VMX_TRUE_ENTRY_CTLS pair,
> MSR_IA32_VMX_TRUE_PINBASED_CTLS needs to be filtered the same way
> MSR_IA32_VMX_PINBASED_CTLS is currently filtered as guests may solely rely
> on 'true' MSR data.
> 
> Note, none of the currently existing Windows/Hyper-V versions are known
> to stumble upon the unfiltered MSR_IA32_VMX_TRUE_PINBASED_CTLS, the change
> is aimed at making the filtering future proof.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220112170134.1904308-2-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/evmcs.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index ba6f99f584ac3..a7ed30d5647af 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -362,6 +362,7 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>   	case MSR_IA32_VMX_PROCBASED_CTLS2:
>   		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
>   		break;
> +	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>   	case MSR_IA32_VMX_PINBASED_CTLS:
>   		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
>   		break;

