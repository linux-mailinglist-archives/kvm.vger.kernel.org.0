Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F6845E1A9
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242258AbhKYUgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:36:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357135AbhKYUeG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 15:34:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637872254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dEpF0Ya03y+5CSbJ4wmHYDmPmNwCt74NIwf3iLZqZgg=;
        b=TASQIoYmL2vjnHpoNdfU97cmT0YpWCmIYRiyv7BcXfMtqCjtWSSmmK+WAcbBuMASdFHQoa
        ohunlHd2WS2R9GU6L0oQjQlLI8MaMyHRyEn2HG363FFLYnuYryE9V0W0whcs6lPuPVVvTC
        igqVvPg2YEswJLF6XugT+Wh2x+eKuvM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-gHNA8ShbNOqfyUga9CZ0jQ-1; Thu, 25 Nov 2021 15:30:53 -0500
X-MC-Unique: gHNA8ShbNOqfyUga9CZ0jQ-1
Received: by mail-wm1-f72.google.com with SMTP id 187-20020a1c02c4000000b003335872db8dso3770945wmc.2
        for <kvm@vger.kernel.org>; Thu, 25 Nov 2021 12:30:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dEpF0Ya03y+5CSbJ4wmHYDmPmNwCt74NIwf3iLZqZgg=;
        b=PWKISvHD42xeteCSVz/qUdbxelKpUapxpBCIOkO/F1hU999cLtbeVXNRapzw3xspsx
         +tD+XYMAFJmjjf2TJXUN/Hha/PMpv5NpG+koz6oPXSRkHX9HM6fymKqIvobro8wo/eqJ
         L1OihnX56w8n/3h9XkzdI1jwqFA0Ed5knAmPomdKZtJOVSFJBCGW2vW9s1t1T8loPqBa
         SO+LIutGBFnx9o+JYLTt8sB0wKLHUm7uahqREyEIG0JLH7GZuc2INhhA9OZiH6Axez0l
         hPN+hAoA6IyCmQ/vcpdFTIkmAcmcY4Njv6fz2o1evUP3kVl4VphSlPYV4TaMAVvvWpVa
         KOhw==
X-Gm-Message-State: AOAM530qs/8dESDL1TnS2hCb9y/x5saN6M+oM8EhxzIVjO+lq1AGwhCV
        zMpX3jJUT5h0Uw1dEXP+7S8K6Ls3B7Seg8CqZ0EaGHwdnKgDZDVYJbbUb8W+vuYmvaBwTvBbcsh
        K+EltVheazcua
X-Received: by 2002:a5d:6312:: with SMTP id i18mr10186648wru.475.1637872251640;
        Thu, 25 Nov 2021 12:30:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0gaKevT6dubAbNdgl8Mlg1Ca3d8cwo7W4YwZVK8nM2ffYuZwM+HX5qjU1mVul0Cey+e9psA==
X-Received: by 2002:a5d:6312:: with SMTP id i18mr10186629wru.475.1637872251479;
        Thu, 25 Nov 2021 12:30:51 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h2sm3566055wrz.23.2021.11.25.12.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 12:30:50 -0800 (PST)
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
Date:   Thu, 25 Nov 2021 21:30:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-10-reijiw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> expose the value for the guest as it is.  Since KVM doesn't support
> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> exopse 0x0 (PMU is not implemented) instead.
s/exopse/expose
> 
> Change cpuid_feature_cap_perfmon_field() to update the field value
> to 0x0 when it is 0xf.
is it wrong to expose the guest with a Perfmon value of 0xF? Then the
guest should not use it as a PMUv3?

Eric
> 
> Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index ef6be92b1921..fd7ad8193827 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
>  
>  	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
>  	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
> -		val = 0;
> +		return (features & ~mask);
>  
>  	if (val > cap) {
>  		features &= ~mask;
> 

