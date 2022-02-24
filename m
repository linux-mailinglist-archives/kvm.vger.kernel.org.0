Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C957E4C2E60
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbiBXOY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbiBXOY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:24:56 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788831637F2;
        Thu, 24 Feb 2022 06:24:24 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m3so3052797eda.10;
        Thu, 24 Feb 2022 06:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=glnlrUuuX5tgZU2yUQ6nQwNeTEYBl1LpBLjBsPtBMTU=;
        b=Ox17SH5QcGsWiwPHDr6vjIXTnZ4/uV9Ti5DbzopFaCwjHI5+2hbSe0LsDQzQr41K4G
         6XO4wJnC+bf9HXVFV79XF5CZQC7JOfwYm420LtbwZ1Q8EscPvX+9P5dOWef5Fuz68xZU
         TbiAHtZkKrS3jtQ23wSY/vr8W8Uemi2m33uh9iDdkVdU1k/NWFswWLSxaapiCpFhz7TN
         Q9S+Z84jf+2nogMQjX7dNq3cKje/tKD4Gkq3dGGSlxd0Sa1tmqYEO7V9C0O7NwKdfLxH
         2jsyVgv8CtkLtq0M5oGalFJnjpFK49vveCnhuJasNHElxaGcy17IbwJXmZC5apQ04Ccy
         DmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=glnlrUuuX5tgZU2yUQ6nQwNeTEYBl1LpBLjBsPtBMTU=;
        b=dKLrapDuj3ERusEfNVnyXCqc0NhxdU/vOGSYsTjXKhYbXp23CDs2qjqErP9GxcB3KL
         85hzO+3xtha4n3pNbRJF99YdspqxbXn6MXP3mPc9f+PoV4u7Nr4L4UIT2Dwg2eiyKmPj
         jq/U/V8mcTwa8PRD9IN9u5V2bAZdMi8dMN4ITQB++Fw6cK0nSMAfSIo+QhRdoxR98kma
         7M2c0HZQCAPcgQ4/ne78SP1N7QHuBzWSFjaEZiJjmmsET4gh983zeG0PGU5ghQiZwHMy
         MxQSlC00/Kiq0gCUNpVNvqMk0DN8iz7XpzD9osVYQIEqSaqnU2e4SFrsqsO/Kd07MiCs
         COJQ==
X-Gm-Message-State: AOAM530AjvB93cYAGog1E2++H0viG1AMWLWGsKHbvO4G81jULk84Yhfh
        Kv2XcUnmZjXG13EsnBljSK7bL52AmKI=
X-Google-Smtp-Source: ABdhPJwGFPNlJQn6+5neCng4W5G6z3NpeGG+rFLu3FGtuZJ8JYSdfVFVWD9X6OLLe1UM5zqVcRWZSQ==
X-Received: by 2002:aa7:de84:0:b0:40f:db98:d0f9 with SMTP id j4-20020aa7de84000000b0040fdb98d0f9mr2498712edv.366.1645712663032;
        Thu, 24 Feb 2022 06:24:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u24sm1430446eje.25.2022.02.24.06.24.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 06:24:22 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f0632f4c-162d-fcf7-6c3b-d19e946009b6@redhat.com>
Date:   Thu, 24 Feb 2022 15:24:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] kvm:vmx: Fix typos comment in __loaded_vmcs_clear()
Content-Language: en-US
To:     Peng Hao <flyingpenghao@gmail.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220222104029.70129-1-flyingpeng@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222104029.70129-1-flyingpeng@tencent.com>
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
> Fix a comment documenting the memory barrier related to clearing a
> loaded_vmcs; loaded_vmcs tracks the host CPU the VMCS is loaded on via
> the field 'cpu', it doesn't have a 'vcpu' field.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6101c2980a9c..75ed7d6f35cc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -644,10 +644,10 @@ static void __loaded_vmcs_clear(void *arg)
>   
>   	/*
>   	 * Ensure all writes to loaded_vmcs, including deleting it from its
> -	 * current percpu list, complete before setting loaded_vmcs->vcpu to
> -	 * -1, otherwise a different cpu can see vcpu == -1 first and add
> -	 * loaded_vmcs to its percpu list before it's deleted from this cpu's
> -	 * list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> +	 * current percpu list, complete before setting loaded_vmcs->cpu to
> +	 * -1, otherwise a different cpu can see loaded_vmcs->cpu == -1 first
> +	 * and add loaded_vmcs to its percpu list before it's deleted from this
> +	 * cpu's list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
>   	 */
>   	smp_wmb();
>   

Queued, thanks.

Paolo
