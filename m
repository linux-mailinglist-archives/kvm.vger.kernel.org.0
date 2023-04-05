Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79786D7BE1
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237803AbjDELsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 07:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237929AbjDELsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 07:48:17 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9B540C4
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 04:48:09 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-92fcb45a2cdso41842166b.0
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 04:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680695287;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I+t9NSC4vs+WDeNxlA/CK4y2rP39rmcWfv5pck/SpXs=;
        b=LoY28IulkJT7OdLzhh9VlZ+Rdh2zQDE7OYOxqETR0xsAgYVxgRFDtINT09X/kMmRRp
         IduuF5jZPZP15SEnddeAzZrT39JEeoX50spmCL9BstmTkwJLDhIFNDqe8Bfyb3mViSty
         +uf2klSZYHJvDduERn27eTXZJdGbJEfTTlZObjoh9c4SKnsKrcLvzVJA0WoaBquyP0yE
         v7BpH+IsNODAzgawfuTeV/ayM8uLFNuonnCWE451oBFx4+3aE8vaTnpJS0DLkzMbYfb+
         /+QnQcZn7y052Qs4xxMzuEy6kshOdzbWQGO2x5yESFQFrCZnhdE6d88kRFodkZG4SlZZ
         ZReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680695287;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+t9NSC4vs+WDeNxlA/CK4y2rP39rmcWfv5pck/SpXs=;
        b=yf2rCvZvf6QeB8iDuQ9Fz8aEUIlroNugaTYegX5fJkvEiYN6kliU7BbGbWvUe64cja
         +Cm2tvBCwBH3Uk2kfgGCtodouP3JHFnP3fzVKryO0NPFXUGrRJLSfdUkwr0tr1PbIphJ
         mVgjWstZpYtShUuKcEjpSNT1abLq2fQkhieTnsbksS0yISvwpndAeFJlgftF5CnR/eaq
         dHif6p+frnc3+KRkKtC2MaK+8xDMbq8fFvydlnqh8oegahRrZxSvxmirBxG5Dql5qj5s
         cllFMGATScHUoRHL3MaccSvRhWMXLZBbJyC77psYTE9iOF2Ow4lNrmHaUTSaq6Tc7Yb+
         0zaA==
X-Gm-Message-State: AAQBX9dFAVIpjLk2KmcPxNKS54K2x0E2goUfxetMQkcL/ej7QlZnJbvU
        mR1xDHB8suaC+0WC0sQ3aJnp4Q==
X-Google-Smtp-Source: AKy350Z03r6RsSL1DZA3/0rE6NvPPLBKrTCFCqjfDAMqstTL8lSkE7lacNxxAWEuURah1fDl1LnY2A==
X-Received: by 2002:a05:6402:160f:b0:502:9c52:4482 with SMTP id f15-20020a056402160f00b005029c524482mr1726870edv.6.1680695287392;
        Wed, 05 Apr 2023 04:48:07 -0700 (PDT)
Received: from ?IPV6:2003:f6:af39:8900:5941:dee7:da1a:b514? (p200300f6af3989005941dee7da1ab514.dip0.t-ipconnect.de. [2003:f6:af39:8900:5941:dee7:da1a:b514])
        by smtp.gmail.com with ESMTPSA id bq18-20020a056402215200b00501c2a9e16dsm7050020edb.74.2023.04.05.04.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 04:48:07 -0700 (PDT)
Message-ID: <6fcaf791-da24-fae7-af03-3e19a781fd26@grsecurity.net>
Date:   Wed, 5 Apr 2023 13:48:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v4 6/9] x86/access: Try forced emulation
 for CR0.WP test as well
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20230404165341.163500-1-seanjc@google.com>
 <20230404165341.163500-7-seanjc@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230404165341.163500-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.04.23 18:53, Sean Christopherson wrote:
> From: Mathias Krause <minipli@grsecurity.net>
> 
> Enhance the CR0.WP toggling test to do additional tests via the emulator
> as forcing KVM to emulate page protections exercises different flows than
> shoving the correct bits into hardware, e.g. KVM has had at least one bug
> when CR0.WP is guest owned.
> 
> Link: https://lore.kernel.org/kvm/ea3a8fbc-2bf8-7442-e498-3e5818384c83@grsecurity.net
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>

> [sean: check AC_FEP_MASK instead of fep_available()]

Hmm. But this excludes the emulator CR0.WP tests by default, even when
FEP is supported by KVM. :(

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/access.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 4a3ca265..70d81bf0 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -1108,8 +1108,9 @@ static int do_cr0_wp_access(ac_test_t *at, int flags)
>  	set_efer_nx(0);
>  
>  	if (!ac_test_do_access(at)) {
> -		printf("%s: supervisor write with CR0.WP=%d did not %s\n",
> -		       __FUNCTION__, cr0_wp, cr0_wp ? "FAULT" : "SUCCEED");
> +		printf("%s: %ssupervisor write with CR0.WP=%d did not %s\n",
> +		       __FUNCTION__, (flags & AC_FEP_MASK) ? "emulated " : "",
> +		       cr0_wp, cr0_wp ? "FAULT" : "SUCCEED");
>  		return 1;
>  	}
>  
> @@ -1127,6 +1128,10 @@ static int check_toggle_cr0_wp(ac_pt_env_t *pt_env)
>  
>  	err += do_cr0_wp_access(&at, 0);
>  	err += do_cr0_wp_access(&at, AC_CPU_CR0_WP_MASK);

> +	if (!(invalid_mask & AC_FEP_MASK)) {

Can we *please* change this back to 'if (is_fep_available()) {'...? I
really would like to get these tests exercised by default if possible.
Runtime slowdown is no argument here, as that's only a whopping two
emulated accesses.

What was the reason to exclude them? Less test coverage can't be it,
right? ;)

> +		err += do_cr0_wp_access(&at, AC_FEP_MASK);
> +		err += do_cr0_wp_access(&at, AC_FEP_MASK | AC_CPU_CR0_WP_MASK);
> +	}
>  
>  	return err == 0;
>  }
