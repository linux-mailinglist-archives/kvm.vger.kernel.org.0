Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAA21AAB07
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409945AbgDOOyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:54:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23320 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2408882AbgDOOyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 10:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36E4N7q+94RvweaZXTmr5UhjWWpdGRQf/CnIVV4HQ7Q=;
        b=LLuv34Qjfuuux7XynSbluXiI4vKU+D679S0DdZuMp4g6jdBiNHLsQRGb3ZNfaAHnRiGFdf
        DyWWgxeROdRjYefoW3+p4f0X7sJjFOavMcqkDkDATrHoST/Bc23/NRsfYbcwDL0fIBLzIl
        etroVHW5/WFe2tbokR0B6QvHptDVseE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-s0ivc6etPQinDJsP0METiw-1; Wed, 15 Apr 2020 10:53:54 -0400
X-MC-Unique: s0ivc6etPQinDJsP0METiw-1
Received: by mail-wm1-f69.google.com with SMTP id b203so5047130wmd.6
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=36E4N7q+94RvweaZXTmr5UhjWWpdGRQf/CnIVV4HQ7Q=;
        b=PatFODD+91ZuHptmikowDHkt6Von9SOY+Hj+VWUGHs4bWC/HGu/zkfgXJby1LFQfxj
         A1B77Ivt9UUmhY3P/0qrmLwmY+dluyim6IVNJeSsALfBHSWmwOhsLO8E6bDvywphg79M
         U12/0qNNKLbXzmLfTZHgPSZSm2akWnc0xsG9uNe7UOtBoP4QMwco0q/zv0MnxUqKNtwj
         l5DWXkc3AgROTxr0evcGstG8+0pM+ZB4fWXxulY1+jdEvbqzwoMgxm3Zay6WXV5nAYeV
         WwYKNz558yUMCoztb5DzFHUqVab8yhHjEhuGPPqiC6kAEudtEJCMI0mICi43P8j7m+Wz
         PPRg==
X-Gm-Message-State: AGi0PuYnvQZEY0oE8U6bsXneKmdqqtKQ4g9BgGts3lFewrhuW+eVIafu
        dqN4CGbe1eGuFzW83BBYQlZzjz5ZGC/Hb3T+M3bTGff6OJOhz8Rt7Ndg81772U9gMZ7AbnqFBpl
        LkwK/wwjIoKc0
X-Received: by 2002:adf:904a:: with SMTP id h68mr27495440wrh.291.1586962433427;
        Wed, 15 Apr 2020 07:53:53 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ/cAvGQw1YkBGC6okX7zE61HyLuQq2hlX8Pbvb6qNBrcmDX5EvBomqGUFPNgHPYY5OVR7fYQ==
X-Received: by 2002:adf:904a:: with SMTP id h68mr27495417wrh.291.1586962433189;
        Wed, 15 Apr 2020 07:53:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id t2sm16563569wmt.15.2020.04.15.07.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:53:52 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Fix build error due to missing release_pages()
 include
To:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
Cc:     KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20200411160927.27954-1-bp@alien8.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <26c86223-6e5b-169b-7967-a406a3b1678b@redhat.com>
Date:   Wed, 15 Apr 2020 16:53:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200411160927.27954-1-bp@alien8.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/04/20 18:09, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Fix:
> 
>   arch/x86/kvm/svm/sev.c: In function ‘sev_pin_memory’:
>   arch/x86/kvm/svm/sev.c:360:3: error: implicit declaration of function ‘release_pages’;\
> 	  did you mean ‘reclaim_pages’? [-Werror=implicit-function-declaration]
>     360 |   release_pages(pages, npinned);
>         |   ^~~~~~~~~~~~~
>         |   reclaim_pages
> 
> because svm.c includes pagemap.h but the carved out sev.c needs it too.
> Triggered by a randconfig build.
> 
> Fixes: eaf78265a4ab ("KVM: SVM: Move SEV code to separate file")
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kvm/svm/sev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0e3fc311d7da..0208ab2179d5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -12,6 +12,7 @@
>  #include <linux/kernel.h>
>  #include <linux/highmem.h>
>  #include <linux/psp-sev.h>
> +#include <linux/pagemap.h>
>  #include <linux/swap.h>
>  
>  #include "x86.h"
> 

Queued, thanks.

Paolo

