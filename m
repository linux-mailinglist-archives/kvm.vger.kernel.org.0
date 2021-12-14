Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A7847421B
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 13:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbhLNMI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 07:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbhLNMIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 07:08:54 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E1CC061748
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:08:54 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r11so61499527edd.9
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fgspqCXaWhYem1uQlcfbegUecJ6LzWCoGKppdvh9p+k=;
        b=noSw8eEUkx3Bm+UvLghSGJgEivwzJVtPVqzu3k6F2fYqQ0y+y3RuM8dr+10J6z29Vi
         Adq6FdF4fMCxsQ4thgtzghr1+PIUKVDNgnB6TitLuqF5AE+zonv5zlGjlKH1oeAtqDLD
         Co2on6BwB/+XXufWYkDeL6vSVwmUC0yAZ7rHKVS2bHkw9butDjtSmf+r21FcpScNuXN9
         s3DXKY82ybaCJUf5eXEUZ9JRnxcq82kpgAQqq2B/3rEaZfvKPuHxV0yhK79twqO9oS1Y
         0xvZ+Isp9UBsLO1yYfvWsJawprUJr/W5CGOH41vnTZpNpetggM1Dz/KP4l8hh7eB3Adq
         2dTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fgspqCXaWhYem1uQlcfbegUecJ6LzWCoGKppdvh9p+k=;
        b=geGVo6veSX5h8N0v6wSmDVxknww1Cm1MHsY4L+UAn8nmAsGG79+J4GwL247lpFbNDT
         1DwztG1oTiPL5L5Z8EzMrMRl+AJyiJFlflSm6k8rjdWTAvyZn7GHl0apmtcMIaPTvrvS
         95CGGRqtK0hYnYeBTTwWbi7ScyKftXkDk0R3ohHklaPKThYBdateVL7c3dXGh8HLnSA8
         ffP2T6CU4ZrvLVDNaJ9PaL/aw3005mEwLi4NbMe9cfyDHczIwji673IjIQuiRzNxIzZ9
         8cBs01JhxcRclTz/SoKV1ZQkZ1QwdCEGOaR0O8dR7V6mSRE8ripdLW5g1K8wO6bJQ7kl
         23wA==
X-Gm-Message-State: AOAM531CBse78GvOIMc210L2BbLluxf+V1FiqSOdRsksK1GldydRCH3u
        cAiDYnlwdHhJOtaq27LkH18=
X-Google-Smtp-Source: ABdhPJxSiXds77+ftr8Z/dbuzIbes1oRnLDhhvnlVdxBMfprj375eMJoA2dZaXZgE86Nn41+CVm2+w==
X-Received: by 2002:a17:906:e103:: with SMTP id gj3mr5356905ejb.456.1639483732706;
        Tue, 14 Dec 2021 04:08:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z16sm978766ejl.202.2021.12.14.04.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 04:08:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <417a6da6-1d69-5350-585d-8165b97b3bb1@redhat.com>
Date:   Tue, 14 Dec 2021 13:08:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] x86: Increase timeout for
 vmx_vmcs_shadow_test
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com
References: <20211213195912.447258-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213195912.447258-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 20:59, David Matlack wrote:
> When testing with debug kernels (e.g. CONFIG_DEBUG_VM)
> vmx_vmcs_shadow_test exceeds the default 90s timeout. The test ends up
> taking about 120s to complete (on a barmetal host), so increase the
> timeout to 180s.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   x86/unittests.cfg | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 3000e53c790f..133a2a1501dd 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -346,6 +346,7 @@ file = vmx.flat
>   extra_params = -cpu max,+vmx -append vmx_vmcs_shadow_test
>   arch = x86_64
>   groups = vmx
> +timeout = 180
>   
>   [debug]
>   file = debug.flat
> 
> base-commit: 0c111b370ad3c5a89e11caee79bc93a66fd004f2
> 

Applied, thanks.

Paolo
