Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002C01B2BEC
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 18:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgDUQIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 12:08:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24669 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726063AbgDUQIU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 12:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587485299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zX1gMKclpqnAEoBMDkK5PhMtrskM3KRZZa0iKX4TUNw=;
        b=WyWwj2aQ3qVceVdxWqI7nuA+EvT9gXvExqQ5uQXWp5hdHaen77U5jxcd8ZKQSQC4kM5LQY
        DnDEoKrkFjXg5su1CX6C0Eo5jYvmO60b+klQS7+suO5Bhh/vX6YlilsOLe7AjvaRdS1tLk
        FoUcWUytWTUpm49DY1tqU+MTrH1/GxI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-kNTBKjNKOpusKskfCTihWA-1; Tue, 21 Apr 2020 12:08:16 -0400
X-MC-Unique: kNTBKjNKOpusKskfCTihWA-1
Received: by mail-wr1-f69.google.com with SMTP id p16so7745173wro.16
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 09:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zX1gMKclpqnAEoBMDkK5PhMtrskM3KRZZa0iKX4TUNw=;
        b=tRxrKcOVBkhlnBgCkSegTj7stN8/P4X3a/aArjMg5dlhDADHSUDGbCQe/NGcuMgk56
         0tNmqbk8azjSSSgTTIPlUpBJ4clVtPNtWyTwONmlUQ6TzB9krZ3xWqdDHYS/pSzfIfrV
         GXCnZSYjLFE8ljKhCozkxQ+l0kQqdgL9OeuKYiQazsGYT9FPUf1Ty4bjJHonTasqlFtQ
         67Lr6vtnenVGtPysaDdcouxQxTObFbuyf41f0Wx0G7sjOCSu9j5erlnUZBKUGEjR7pwz
         yk8zG5bj7+HiP1iYjmnZo8N/k66HnbFu+KsiHYrwytR7Nrfgx+zhdP4PvNecNP5QmeU1
         7pYQ==
X-Gm-Message-State: AGi0PuZg5lMMJA6RoW2VKQJpBHYfE1C5DJqZUAkrAepwPVWbk9FWePmK
        Esof8czbwO62+Jpi/j0Ue/ZdOjcp/qP6DgCK0GjnQVcuXt/ApW6IqEdIGhNpLA7tR+nfVnKOZG5
        U+xdHk+Ovco/1
X-Received: by 2002:a5d:4cc2:: with SMTP id c2mr7833692wrt.130.1587485295142;
        Tue, 21 Apr 2020 09:08:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypLvIubcHMY+bL+zO//2Pbr43uhrB1dGEYg7deIwhIyQZYcUlf8RLmjST2V4p2KxDgWpDL0OHQ==
X-Received: by 2002:a5d:4cc2:: with SMTP id c2mr7833673wrt.130.1587485294887;
        Tue, 21 Apr 2020 09:08:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id x18sm4235851wrs.11.2020.04.21.09.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 09:08:14 -0700 (PDT)
Subject: Re: [PATCH] kvm/eventfd: remove unneeded conversion to bool
To:     Jason Yan <yanaijie@huawei.com>, peterx@redhat.com,
        tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200420123805.4494-1-yanaijie@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a0d78d8-e5db-30fb-a2a2-62113a791e49@redhat.com>
Date:   Tue, 21 Apr 2020 18:08:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420123805.4494-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8
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

