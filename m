Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B509D5F7C7
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 14:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfGDMPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 08:15:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51413 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbfGDMPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 08:15:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so5548290wma.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2019 05:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8JdSYBAH2R4iWrp9AtOPbWAInLP5rvqtz8MW15QLPWQ=;
        b=CzAArVY9KhFuJ3nPCmZA/guMQMpuv3t4L7anGAEUj7yFh+LBqQYW9tRG/Iljz/jWP+
         5AAXqDglkYs4fthDL7c0VffsjyX0/vjdTPl3cjIWq88Z8NHyjQgf2SD8algvTYL/fKfZ
         U/gzSl3fhV09CF8lsAvNf1y0JMxyN3fRS7nUBUEMRb/+WBqRwX5MxyE9SUL1FZxLgDX4
         9gsfcxCWGJSOPzXqrLGGcX89O2489DUV9wU8OoRJ9bwklPcCZleNUfAKpnGmnUm3LkHe
         cWUxXrN4Im7y0ul2mkOUjh1UVkN9Rps/cFM7+XzFKP1546MgpvVpP7trZgOiaA/mOS+t
         tGDg==
X-Gm-Message-State: APjAAAXQ1Eo0S3r0zWL4izcPkdi8cXnRv8fsFklcmOpLnT/oiQ7aLEAK
        4kgfP5z12XgY7fHz6kq4CU//Tg==
X-Google-Smtp-Source: APXvYqy/XHnwIGPw3Dn1ZxQ7L3TYQ6Pb9iT7u8RaTpass6DNag8j7SGxnuaZVAoXb/QEGM7J2cMXWg==
X-Received: by 2002:a7b:cb94:: with SMTP id m20mr11914655wmi.144.1562242515927;
        Thu, 04 Jul 2019 05:15:15 -0700 (PDT)
Received: from [10.201.49.68] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id n14sm11624948wra.75.2019.07.04.05.15.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 05:15:13 -0700 (PDT)
Subject: Re: [PATCH 1/2] kvm: x86: add likely to sched_info_on()
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        xue.zhihong@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
References: <1562240775-16086-1-git-send-email-wang.yi59@zte.com.cn>
 <1562240775-16086-2-git-send-email-wang.yi59@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <59ce6a26-f35f-8bb9-7392-13bcce6434e3@redhat.com>
Date:   Thu, 4 Jul 2019 14:15:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562240775-16086-2-git-send-email-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/19 13:46, Yi Wang wrote:
> The condition to test is likely() to be true when make defconfig.
> Add the hint.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4992e7c..64fff41 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -642,7 +642,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
>  			     (1 << KVM_FEATURE_PV_SEND_IPI);
>  
> -		if (sched_info_on())
> +		if (likely(sched_info_on()))
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);

This is not a fast path, so adding likely/unlikely is unnecessary.

Paolo

>  		entry->ebx = 0;
> 

