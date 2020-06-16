Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B24A1FB0AE
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 14:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgFPM33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 08:29:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49045 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726799AbgFPM33 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 08:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592310568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rRKJse0JMW86mGK8adlvlvs4xmhjb3A71zND/BkT18w=;
        b=BkH9sjk25RaC/PXSELcu1APMwKUpZKnwQlLHxuMPExci0FKwI+8ar8DQK0oOUtu9ra3pkQ
        9gHJwAnmfmgHjxFaUWdnV3zOjHo5K71c77u76EtszD+jY6d0WvCaUaWddYO9iW2GDMlaeM
        EdL41xpOhfkZNes1ABkGY/MlllwTjFo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-K3LstWytPw2jZGWjnnoBug-1; Tue, 16 Jun 2020 08:29:26 -0400
X-MC-Unique: K3LstWytPw2jZGWjnnoBug-1
Received: by mail-wm1-f71.google.com with SMTP id y15so889804wmi.0
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 05:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rRKJse0JMW86mGK8adlvlvs4xmhjb3A71zND/BkT18w=;
        b=gTYs2rYCMAlwf28jdySgR6Q2QqKSStBYURjksTE+0Q27m8Ik5F6RDqePez3V9tJgVE
         EYB/K+VIoHhnP7ZHhZwUym/YasxfxLhMWqTWYDaVCBTD/z1jiUCYH/uK1pN4X+DZHpER
         Wd7pNpZ2v7ZtSnlcGsUmJeqAXstp/3308+YAJiCdY1tMlTFGgbBzoH4RbStEqTAFgJJg
         GaL2kovPfMNAGF7YRjFaxmef6fj4rx5RsTbUVDdTrgJ2UWEX5TDJG7d+5faF+UbwR9Os
         PEtvw9i/GY5uMYHEORcJgqceqbdmW0IAna7nlcm8QNcVHxKQoFfC0j36Jwe8V4bAhiB6
         owxg==
X-Gm-Message-State: AOAM5302RzII0LtBV5IHQhXt6YPTV+/32A0KPpKg2Ltn8/wOYMDp+O+d
        onRKArcTOSD5YIC5ltdhsY7YGhsFTCHIoc+Epq6dqDq+sBHUjkFLsTopRnR2SoubaIKqnmN3lCe
        BpWf5VMaFdkOY
X-Received: by 2002:a05:600c:21c2:: with SMTP id x2mr3033011wmj.33.1592310564695;
        Tue, 16 Jun 2020 05:29:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0fm/qe01HbR9Pkii9kngggq6N96nck354BD6Cd/MGBqZpSUNRC3CrL6mgG8EMTqmhEaCNSA==
X-Received: by 2002:a05:600c:21c2:: with SMTP id x2mr3032996wmj.33.1592310564457;
        Tue, 16 Jun 2020 05:29:24 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.88.161])
        by smtp.gmail.com with ESMTPSA id t189sm3957882wma.4.2020.06.16.05.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 05:29:23 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Fix compilation on 32-bit hosts
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     like.xu@linux.intel.com, vkuznets@redhat.com
References: <20200616105940.2907-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c0c3754d-3c50-2703-5a16-00e343a161f2@redhat.com>
Date:   Tue, 16 Jun 2020 14:29:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200616105940.2907-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/20 12:59, Thomas Huth wrote:
> When building for 32-bit hosts, the compiler currently complains:
> 
>  x86/pmu.c: In function 'check_gp_counters_write_width':
>  x86/pmu.c:490:30: error: left shift count >= width of type
> 
> Use the correct suffix to avoid this problem.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  x86/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 57a2b23..91a6fb4 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -487,7 +487,7 @@ static void do_unsupported_width_counter_write(void *index)
>  static void  check_gp_counters_write_width(void)
>  {
>  	u64 val_64 = 0xffffff0123456789ull;
> -	u64 val_32 = val_64 & ((1ul << 32) - 1);
> +	u64 val_32 = val_64 & ((1ull << 32) - 1);
>  	u64 val_max_width = val_64 & ((1ul << eax.split.bit_width) - 1);
>  	int i;
>  
> 

Oh ok, applied.  Thanks,

Paolo

