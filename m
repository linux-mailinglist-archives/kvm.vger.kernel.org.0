Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9AB380694
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 11:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbhENJ7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 05:59:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231474AbhENJ7W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 May 2021 05:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620986291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HSHT010IMW+cXEGATjDBIxbVj8q3qsIGaXIjuV1tR8=;
        b=W86PAnTILoKeWhj82zZ/RSetDYC+ou8bDk28izRcKO1gt+Xa04ZYtz/HAdMakJ8jErUhhN
        QS115fi4bB3o/o271CYaS0IGlYRTS+co67YCcgPJWxSzLA/dRxGJ5rbCvZuREHePxmo54M
        +FBPefxxcTa/u3h4F3oUekOPq55/iz8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-RCUx0ZYwO1S6Sp_XF3PkuQ-1; Fri, 14 May 2021 05:58:09 -0400
X-MC-Unique: RCUx0ZYwO1S6Sp_XF3PkuQ-1
Received: by mail-ej1-f69.google.com with SMTP id x20-20020a1709061354b02903cff4894505so2831842ejb.14
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 02:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HSHT010IMW+cXEGATjDBIxbVj8q3qsIGaXIjuV1tR8=;
        b=lnGr9bmlNH9/InTnsvo9fY74jaa9PerdesgQ1TqwHEUeJo88SSGxcAhh585NeVU+tE
         iPoFc8dw77X8RFcgUO/7IgP68a/qOZu5fNZXCEOtC1OJb9RBKFYZTqImDhwzd4yJD+Nc
         qzJtfFok7nkhJqCgwl5j7vyRNYx+RbgsEXaM288bufyppAWkNII2piCmTocysor7jk+n
         H2dWh/DEj29jx7xpzrcETSxOCcRxR4CoKDYPzIa55bpV2mVfy25g7aUcLIJdBk92ss2e
         kCm4yiqBhEqs8sTgBxWfQ8RFOQwUULgTvgVsQYlkS9GBQog/qKPpOKL6JpQ0krt9qKnO
         a06A==
X-Gm-Message-State: AOAM532hnEfOvokLIvlRtCIn8NOgTZiK9ibF8EOcFimGHCeK0GRQlHg+
        Armjf0hlNg4cdLF11/W4iXiCYuGAeCvudiyWWL1qLpGgTAYoTfyts8BfkNXeFKuLb2ZShpTI5ub
        Qwu7RGXeEd1Fn
X-Received: by 2002:a17:906:1997:: with SMTP id g23mr7843645ejd.168.1620986288203;
        Fri, 14 May 2021 02:58:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPiLTB37PBXo7J5oy0OsoquAD37a/9MW+Bd1U/QL7g89/MOzpV8bQHPd1pj3fSSUBuCQnGXg==
X-Received: by 2002:a17:906:1997:: with SMTP id g23mr7843628ejd.168.1620986287995;
        Fri, 14 May 2021 02:58:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bw16sm3420965ejb.50.2021.05.14.02.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 02:58:07 -0700 (PDT)
Subject: Re: [PATCH] KVM: MIPS: Remove a "set but not used" variable
To:     Huacai Chen <chenhuacai@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        kernel test robot <lkp@intel.com>
References: <20210406024911.2008046-1-chenhuacai@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e55e632d-a138-a6ec-d545-299ab858a163@redhat.com>
Date:   Fri, 14 May 2021 11:58:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210406024911.2008046-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/21 04:49, Huacai Chen wrote:
> This fix a build warning:
> 
>     arch/mips/kvm/vz.c: In function '_kvm_vz_restore_htimer':
>>> arch/mips/kvm/vz.c:392:10: warning: variable 'freeze_time' set but not used [-Wunused-but-set-variable]
>       392 |  ktime_t freeze_time;
>           |          ^~~~~~~~~~~
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>   arch/mips/kvm/vz.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index d0d03bddbbba..e81dfdf7309e 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -388,7 +388,6 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
>   				   u32 compare, u32 cause)
>   {
>   	u32 start_count, after_count;
> -	ktime_t freeze_time;
>   	unsigned long flags;
>   
>   	/*
> @@ -396,7 +395,7 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
>   	 * this with interrupts disabled to avoid latency.
>   	 */
>   	local_irq_save(flags);
> -	freeze_time = kvm_mips_freeze_hrtimer(vcpu, &start_count);
> +	kvm_mips_freeze_hrtimer(vcpu, &start_count);
>   	write_c0_gtoffset(start_count - read_c0_count());
>   	local_irq_restore(flags);
>   
> 

Queued, thanks.

Paolo

