Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D146523F0
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 16:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiLTPso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 10:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLTPse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 10:48:34 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B001186D5
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 07:48:25 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id f18so12149279wrj.5
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 07:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RhFtHZ+QjsDupGH4qz8UINzGqRrH3VltWVcWI44I3rA=;
        b=L2CeipNQqdFuDRphU/hivqJxhL/uLxehlF1h9KST8Sp4vPSD9vqdHCgD5S6oxBE4KH
         LePrJAPFhu3l8KmqwIUwBBcSfCdFDsTN40CIxwUVvju349rGHdtaHqvpM0Mc1t9QdyFx
         j4XiUyjznH2eGekbFZtXm7DJ4J5xRmU1LdgohszPwznjEQXrKNvYUDUml9sS7xsE9htn
         GyGZigKojNNqEM4qO9GyR0WrtflqvP2iKP5BWFIhBE7/besZDjSVTSxc+SP42zm7ADdK
         4RENfH8g2+C1LtZuNwwh1yLP7FwnqtqnuTFHkSigJgCDSX3uTlxLvX3s58GH6y/jWqQ6
         2uwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RhFtHZ+QjsDupGH4qz8UINzGqRrH3VltWVcWI44I3rA=;
        b=bqotrGb5h0WG43+xhwG9+exC773Ni8Rb3fAitW0a4xZrEkDWkkUP5WAcGGhRXp/0z5
         Q1O8ufko1+pEl+zB/hH6tTwMgiXQgOAN0hmC5AYXADDmYvk8WgF2K0fp4RTYp768fjL9
         dO+9UOU3EqrmE5et3fu/xRPfJHTlcePxXd2qPLso5PzDs/H0/hgRtc1LpNl15+M1lNW0
         wWPrGW/SUW2kC05Z8AyPAXF2ecAbWUc/cYXubf9J6mSAmBUt3kaIsYo6pgzez8QKqH5m
         DXP6XYWTUZ+LEhVq/BNRFuK0nBEqXtKorI9MpCLP4WL+iQ0rEXPH00EQwKsROFV2F9yY
         u1iQ==
X-Gm-Message-State: ANoB5pkaDI4zdxDH73F8qTyVaGfoiEojepBXNHVZAREqdCAl55IhSfCR
        x8Z+BOeDyCE8I+OsB8HnaF4=
X-Google-Smtp-Source: AA0mqf7G4BOVMkVEsTbsMmz3pGtBVyy1ze7ADRPAc4G+HUARrRvJQEQHBKneqlaeYPSkIUEhHJvUSQ==
X-Received: by 2002:a5d:464d:0:b0:242:19ba:c325 with SMTP id j13-20020a5d464d000000b0024219bac325mr26927050wrs.30.1671551303677;
        Tue, 20 Dec 2022 07:48:23 -0800 (PST)
Received: from [192.168.6.89] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id u18-20020adfeb52000000b002423dc3b1a9sm12956118wrn.52.2022.12.20.07.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 07:48:23 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <e388cfb3-0863-8a22-4305-b3b04bbd08ea@xen.org>
Date:   Tue, 20 Dec 2022 15:48:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2] KVM: x86/xen: Fix memory leak in
 kvm_xen_write_hypercall_page()
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, seanjc@google.com, pbonzini@redhat.com
References: <20221220151454.712165-1-mhal@rbox.co>
Organization: Xen Project
In-Reply-To: <20221220151454.712165-1-mhal@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/12/2022 15:14, Michal Luczaj wrote:
> Release page irrespectively of kvm_vcpu_write_guest() return value.
> 
> Suggested-by: Paul Durrant <paul@xen.org>
> Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>   arch/x86/kvm/xen.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index f3098c0e386a..439a65437075 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -889,6 +889,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
>   				  : kvm->arch.xen_hvm_config.blob_size_32;
>   		u8 *page;
> +		int ret;
>   
>   		if (page_num >= blob_size)
>   			return 1;
> @@ -899,10 +900,10 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   		if (IS_ERR(page))
>   			return PTR_ERR(page);
>   
> -		if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
> -			kfree(page);
> +		ret = kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE);
> +		kfree(page);
> +		if (ret)
>   			return 1;
> -		}
>   	}
>   	return 0;
>   }

Thanks.

Reviewed-by: Paul Durrant <paul@xen.org>

