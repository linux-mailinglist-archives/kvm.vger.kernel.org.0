Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5212B3546
	for <lists+kvm@lfdr.de>; Sun, 15 Nov 2020 15:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgKOO3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 09:29:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727231AbgKOO3i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 15 Nov 2020 09:29:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605450576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8R4xp4uJWeN1dPguU8tAoffACRZz7e8sb6txf++v260=;
        b=VoMD6jpZF6RM+EXMLgqrt0WjKsu9Mh1dgwIXy0tftkU2vXv84l77yBk1EjuqjGjrK1vMLq
        YUjCOn3ilV68QCwD6XOG4j7XQ45FZTS5fZQyPMvskTbJMkofD/+9+CFCrsGAgkd+B7xYNK
        sG/ttx1mpnJCZutL8tWUF1Wllj/Ya6Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-B23Ccy9aP36lC0wvX7bYPA-1; Sun, 15 Nov 2020 09:29:34 -0500
X-MC-Unique: B23Ccy9aP36lC0wvX7bYPA-1
Received: by mail-wr1-f71.google.com with SMTP id y2so9310881wrl.3
        for <kvm@vger.kernel.org>; Sun, 15 Nov 2020 06:29:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8R4xp4uJWeN1dPguU8tAoffACRZz7e8sb6txf++v260=;
        b=I617ufLLXdG5pf9X/X1d+GjBAfjKKbjYmWvLk9RHDgtQnx1KID56xIUOQ4m1L2nfKJ
         GHtDprCBDs2CqyPQZcaijUSukiRvRdxs0Q9t083MH24qr+JgNZcjH2AcBUBo6tl6xIFG
         keNdDIO1AOsgvCg/6onLm1rj2UZgm37/nhPiYprWcQgp17n4fOrmX6ff7pSXPEgMXd0z
         qLSJgGDzNCZIoqj3WVOIGH2VTEF7xTlhLGrmwEn8tZjK9fhFm9BVCczIkGG3wWsO6Mzr
         lnkSbOynAWMVuCQa7kDdWRty/9+I1fVwpE+Ltn1VzHkYAQbbt/Ve4WUikkJvYV6OuOy9
         W4zA==
X-Gm-Message-State: AOAM533MBJvDHxAes9Q+tnmY2r6Sp5AadVmI4g9w8dCZKUWSw1PUl2As
        wJ0NKyZPZMeHKtUvgU2ZXjCzvUmALF1eu+cM9YAS0RS2MeR+OPs3EkPRp1+wXajUZYsAohickCU
        4IOAqRvh8HoR2
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr14486944wrs.331.1605450573831;
        Sun, 15 Nov 2020 06:29:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz50K27m6e63aL535TvlL4FLaa6oBgNnC2PcfqKs815ngC5egIbXZAHW1Hr1cpJR9uT84he/g==
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr14486928wrs.331.1605450573627;
        Sun, 15 Nov 2020 06:29:33 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id b1sm17024557wmd.43.2020.11.15.06.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2020 06:29:32 -0800 (PST)
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "lkp@intel.com" <lkp@intel.com>
Cc:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "farrah.chen@intel.com" <farrah.chen@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "robert.hu@intel.com" <robert.hu@intel.com>,
        "danmei.wei@intel.com" <danmei.wei@intel.com>
References: <202011151341.2stsjDsg-lkp@intel.com>
 <f90cf58df3aee209e08bc6293da3be79b7262696.camel@amazon.co.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm:queue 40/54]
 arch/x86/kvm/../../../virt/kvm/eventfd.c:198:23: error: passing argument 1 of
 'eventfd_ctx_do_read' from incompatible pointer type
Message-ID: <acaf902f-3a12-d807-4950-d915024fa009@redhat.com>
Date:   Sun, 15 Nov 2020 15:29:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <f90cf58df3aee209e08bc6293da3be79b7262696.camel@amazon.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/11/20 09:50, Woodhouse, David wrote:
> On Sun, 2020-11-15 at 13:14 +0800, kernel test robot wrote:
>>
>> All errors (new ones prefixed by >>):
>>
>>     arch/x86/kvm/../../../virt/kvm/eventfd.c: In function
>> 'irqfd_wakeup':
>>>> arch/x86/kvm/../../../virt/kvm/eventfd.c:198:23: error: passing
>> argument 1 of 'eventfd_ctx_do_read' from incompatible pointer type [-
>> Werror=incompatible-pointer-types]
>>       198 |   eventfd_ctx_do_read(&irqfd->eventfd, &cnt);
>>           |                       ^~~~~~~~~~~~~~~
>>           |                       |
>>           |                       struct eventfd_ctx **
> 
> Hm, that ampersand isn't supposed to be there; it arrived when I moved
> the 'drain events' part of the series after the exclusivity.
> 
> There was a new version of the patch, and I thought we'd discussed on
> IRC that it wasn't worth resending in email and you'd fix it up on
> applying?

Yes, I just pushed what I had quickly last week so that people could see 
what I had processed already, but I hadn't even compile-tested it 
(because it's not a permanent branch).

I had a couple more patches for 5.10-rc before I could branch kvm/next. 
I should be able to test the current queue and push to kvm/next 
tomorrow.  In the meanwhile there's no need for you to do anything.

Paolo

> 
> Since this is still only in the queue and not yet in a permanent branch
> you can still fix it up, right?
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 147adc862b95..e996989cd580 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -195,7 +195,7 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
>   
>   	if (flags & EPOLLIN) {
>   		u64 cnt;
> -		eventfd_ctx_do_read(&irqfd->eventfd, &cnt);
> +		eventfd_ctx_do_read(irqfd->eventfd, &cnt);
>   
>   		idx = srcu_read_lock(&kvm->irq_srcu);
>   		do {
> 
> 
> 
> Amazon Development Centre (London) Ltd. Registered in England and Wales with registration number 04543232 with its registered office at 1 Principal Place, Worship Street, London EC2A 2FA, United Kingdom.
> 
> 

