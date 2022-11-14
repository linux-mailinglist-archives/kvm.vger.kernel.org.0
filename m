Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E92E627618
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 07:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiKNGuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 01:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiKNGuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 01:50:39 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8A3BE1C;
        Sun, 13 Nov 2022 22:50:38 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gw22so9517150pjb.3;
        Sun, 13 Nov 2022 22:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LAEqOoo++cDNUavOXMvxnz9URP/qnKWDn64WrzwAHJ4=;
        b=QflVfTQ2TITbJtk6jYTRW1tbRSgnZjp7Jnm72rZjczFjrdbOt3NpEWT82/hkmASm1r
         y55qwG/BOJz+VWNV9UjbSIEGGc5dtGj/75we45XIubPVHd1IwaHnzX6boB782cfAOrOH
         E9Pd4xRChQkeAZ37NxripEG2g8JB7/d/Zd/ShCJtGRu78/tYhCDbi4Xa321ztvzddu3O
         tAO1Ktn0xdt3YQAmFxGw51TofewTwhMXHf8iwc7Vey5aLoxBUlSKL/iutDp3DSdjvBQp
         t572p0gb7LwJjocSuxH/GehU15/e/Rm6uVaTvsJG5wF5dt4TkFH7g03e/2fq5mMapVsg
         k/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAEqOoo++cDNUavOXMvxnz9URP/qnKWDn64WrzwAHJ4=;
        b=bK6ItvWgcKFBcbHSvnvkUHS49OPI70dYP6Gr39ujnJDitxzrzCO875qEN0wp8ih7VK
         3Cv0mQBUKqXNcPGoSxhAfFM8HG4OHjpYIVglCR4rAddYac6CLYGL+T0yyt80WhdPwh+1
         N06qSUXmMEXIgelXxaSkP3smJXtUG/tO7bD5dB8OXL4VYQ2S91X4EQTh7qXLPbZR7mTY
         L5NUbrxBj3E4/MPfWmJyDfaB27zyH59VcQCcHDtjso0l8wgmTRIY+/AvTFWnTphyqX+h
         VRnxrqGPqs8KFT697yFac8Ii1phXb7Tyd/XK0h7uyjzRH5yrsqWmLphL3/M0JQuspUK3
         lBJQ==
X-Gm-Message-State: ANoB5pkbPRMZ1JUNQlIvy2g6PCDBCv31IXMqe8tP+18IxUEEpp4HxDUg
        9bdoIK+UA4YQcyCnDjUHCzFHdMYqbGbfMJgn
X-Google-Smtp-Source: AA0mqf5F3jytpYh4Bjb7UwRCa7naz3UGdXYbgwxXsZaY8KJqHsfYCMlliiPrtF9IX07cwUKmQiCADw==
X-Received: by 2002:a17:90a:b108:b0:212:d484:b410 with SMTP id z8-20020a17090ab10800b00212d484b410mr12621700pjq.211.1668408638152;
        Sun, 13 Nov 2022 22:50:38 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g12-20020a63fa4c000000b004768ce9e4fasm981959pgk.59.2022.11.13.22.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Nov 2022 22:50:35 -0800 (PST)
Message-ID: <2487aaab-c6fa-72b1-b1bb-c5a34a9b4163@gmail.com>
Date:   Mon, 14 Nov 2022 14:50:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH] KVM: x86: Remove unnecessary export of
 kvm_cpu_has_pending_timer()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221110010354.1342128-1-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221110010354.1342128-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/2022 9:03 am, Sean Christopherson wrote:
> Don't export x86's kvm_cpu_has_pending_timer(), the helper isn't used by
> KVM x86's vendor modules.
> 
> No functional change intended.

The callers of EXPORT_SYMBOL (considering that this line of code has been around
for a long time) will not be public like the callers of EXPORT_SYMBOL_GPL.

Whether we close this door in the future or not, this description is inappropriate.

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/irq.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index d8d50558f165..04a009fbdf8a 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -31,7 +31,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>   
>   	return r;
>   }
> -EXPORT_SYMBOL(kvm_cpu_has_pending_timer);

Not sure if the kernel's symbol or kbuild sub-system has tools to
automatically warn or turn off similar interface exposures.

>   
>   /*
>    * check if there is a pending userspace external interrupt
> 
> base-commit: d663b8a285986072428a6a145e5994bc275df994
