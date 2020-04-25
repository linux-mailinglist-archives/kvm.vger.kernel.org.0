Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301E61B85B8
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 12:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgDYKnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 06:43:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36343 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726073AbgDYKnl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 06:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587811419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zX1gMKclpqnAEoBMDkK5PhMtrskM3KRZZa0iKX4TUNw=;
        b=XIK6D6ehndPRXiFuJisdbweMTv3c5M+y7VQX4Mt4enBFRkBEp334BybcEffF6uaBLRlRev
        kXrZTeZz0s/w9zEXTLvVl2OL892xd9YA7aedjY610iRc22GnTAt7wxtz6te9/NnRzvGJ1t
        ISBmGgV/LXMhhk7/IF8boUBcOunXoVg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-CewJjDqHPWiE2gNzMzs5-g-1; Sat, 25 Apr 2020 06:43:37 -0400
X-MC-Unique: CewJjDqHPWiE2gNzMzs5-g-1
Received: by mail-wr1-f72.google.com with SMTP id p2so6497637wrx.12
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 03:43:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zX1gMKclpqnAEoBMDkK5PhMtrskM3KRZZa0iKX4TUNw=;
        b=Yjf4UkFp50Lli3TkkbQQDPpqJzB/ahHzlQGxjnp3RzF1GpRt8qSfJYfUZwioXQn55g
         KC4XFRAd9uDK36UMwJArJmwal+8JBWlOEh8N3zCbEby5lW6blo9x8HFFYhv18O9QyGO5
         hgBti4xFnziwbURB5eJnXTJakGpYpGXtYaJJ25z9ngxh4wOhvFEvbDT/EkR/FWc2+UrL
         0uuuzvjFzqpcIhOfAE5goqjqnHtbo2+oeLR2XuhIkY0+Hff4oNMPQTlaLhRCrXukHZ+r
         QSoXPZVA/LeaPvloVmR70nhVeHFqZl1a/+ySUCO76iSg3p94CStyhxsQqJ+chTC55qfy
         1Q9Q==
X-Gm-Message-State: AGi0PuZyRGMLcrmeeBVaHBqqK62znMaDszeV2aQCJ7Jalohw80DPNl9z
        v8GO0xm9UTJThFAWu/lSoIJGBK0zVUL7JKpqTCzCsDNOeK5fG48A9hN7YLHgKUxcN3rRvH2s8/L
        WoO2hoeiz1yXZ
X-Received: by 2002:adf:ee88:: with SMTP id b8mr15892428wro.93.1587811416288;
        Sat, 25 Apr 2020 03:43:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypKA9B9pJGKX+0LgDRDvi6v5gXYIEKKnz5THJmcU6hGlhBUcL+S8FEF2XD5VredWlxBdzhvHSQ==
X-Received: by 2002:adf:ee88:: with SMTP id b8mr15892412wro.93.1587811415984;
        Sat, 25 Apr 2020 03:43:35 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id k17sm6631766wmi.10.2020.04.25.03.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 03:43:35 -0700 (PDT)
Subject: Re: [PATCH] kvm/eventfd: remove unneeded conversion to bool
To:     Jason Yan <yanaijie@huawei.com>, peterx@redhat.com,
        tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200420123805.4494-1-yanaijie@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <109d0871-7099-b476-8354-11a628a04b3d@redhat.com>
Date:   Sat, 25 Apr 2020 12:43:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420123805.4494-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/20 14:38, Jason Yan wrote:
> The '==' expression itself is bool, no need to convert it to bool again.
> This fixes the following coccicheck warning:
> 
> virt/kvm/eventfd.c:724:38-43: WARNING: conversion to bool not needed
> here
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  virt/kvm/eventfd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 67b6fc153e9c..0c4ede45e6bd 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -721,7 +721,7 @@ ioeventfd_in_range(struct _ioeventfd *p, gpa_t addr, int len, const void *val)
>  		return false;
>  	}
>  
> -	return _val == p->datamatch ? true : false;
> +	return _val == p->datamatch;
>  }
>  
>  /* MMIO/PIO writes trigger an event if the addr/val match */
> 

Queued, thanks.

Paolo

