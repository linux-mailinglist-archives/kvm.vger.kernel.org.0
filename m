Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AB34C2E55
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbiBXOYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiBXOYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:24:18 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068651637EC;
        Thu, 24 Feb 2022 06:23:49 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id p14so4649483ejf.11;
        Thu, 24 Feb 2022 06:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5JGNf6R+a4FEuW/ji5APSj/Q79D/fkN75qzklV7FvH4=;
        b=ZBGEBTFHNMUajRMJJjvqdUjh5iq8V84lSTRqwpuHGonlCbH1JWx56BLlCxbuwBnU4V
         3rRTnO/lKVHMf81GYjl3cGgHJhjnHvuWSM6HigTBgsBRFc5drLxCHOdFcyZ5ofeOayca
         UwgFJKncS3gat2G/p7XRXnQdLjX8LslPwHnIkTIU4pbMdQkzJ9UYrO5/g66XoxZXU6ta
         K1RhwezAqIvD2cHIDYsRazZ/6SuQLa2599PhM7t1u5qQoTE0BUfr5NB/7lmK+lyPaxkP
         tprkCo30QmxLisCXiPmOeEBFKVFHCrj7/yTrdBFl9moGgmAk/js3gITFxoF9f4XWTEx2
         eX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5JGNf6R+a4FEuW/ji5APSj/Q79D/fkN75qzklV7FvH4=;
        b=iAb54/OUV2o8E1smbMJ2U1+myz3AJURIhWtw3vHCYYlEKd2aE781t4wv1A+po8JNGz
         ZyL//KnedBV8+hbKylydMiQZY8irUISPYPEjiz5qtzp+eVesB7SMy/0PmuOdaVffuFl5
         zRo8mXTDViAYOAR5Gjlic78YCuG4G6Xvh1THfdnTwcmh7D4H1P3qvZNNqzvJ3OIj5UTa
         OVl326Lj6QBdI50pvK0SQg1BsaekJOI+Nbf+1xna8DYeEiuFsjGrYsNujpzJtGXhqIFP
         fY31y8xMqkaDvG59jvFCSxz9f0Nlxs4a54GxDy8niKp4w9vfUdJVnBsCx599rKKTWYTQ
         uFmA==
X-Gm-Message-State: AOAM531EO6q92wMFEhdt+naMxPPD9Y49LvSd+ObEWRke9NnpZ4T8LS/e
        N7g0F5P+QpE6TjuP2gyFQNs=
X-Google-Smtp-Source: ABdhPJwGN4xiUcoXTD/FQvJ2bStNWBAE/ICRfkmV2/p1JQBTRb1PsXZeTnDslyeNkUZYvmeWUQkjSw==
X-Received: by 2002:a17:906:b052:b0:6ce:88a5:e42a with SMTP id bj18-20020a170906b05200b006ce88a5e42amr2495431ejb.237.1645712627596;
        Thu, 24 Feb 2022 06:23:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n25sm1443342eds.89.2022.02.24.06.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 06:23:47 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3896e3b5-0e6c-858a-8e4f-732ab03b7286@redhat.com>
Date:   Thu, 24 Feb 2022 15:23:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] KVM:nVMX: Make setup/unsetup under the same conditions
Content-Language: en-US
To:     Peng Hao <flyingpenghao@gmail.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220222104054.70286-1-flyingpeng@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222104054.70286-1-flyingpeng@tencent.com>
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

On 2/22/22 11:40, Peng Hao wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> Make sure nested_vmx_hardware_setup/unsetup() are called in pairs under
> the same conditions.  Calling nested_vmx_hardware_unsetup() when nested
> is false "works" right now because it only calls free_page() on zero-
> initialized pointers, but it's possible that more code will be added to
> nested_vmx_hardware_unsetup() in the future.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 75ed7d6f35cc..9fad3c73395a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7852,7 +7852,7 @@ static __init int hardware_setup(void)
>   	vmx_set_cpu_caps();
>   
>   	r = alloc_kvm_area();
> -	if (r)
> +	if (r && nested)
>   		nested_vmx_hardware_unsetup();
>   
>   	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);

Queued, thanks.

Paolo
