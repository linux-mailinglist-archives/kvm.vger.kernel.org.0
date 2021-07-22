Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D403D22B3
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 13:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhGVKqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 06:46:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231727AbhGVKqi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 06:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626953233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RwooZuX+T4UwbqH1NuEg8JcZz0cwsNi4PKDnQUP8J18=;
        b=beGLPr8pALzHzsWraB2AAVwtCCjBbuBgxaUmRrfy5ObJzXtJ4HfdLF0fSma9KGktAXGPr/
        ZRxCJ9pqVEWxn9WYThW4Qeaq1zmJzI2J9npcKi0h0Fb5zPdmUZzIsyeizJhvKHeVF7SJNF
        Q/qOWdjYACutCzYDOkI0Uwvao6diV2I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-zyVa9UfwPGqp8DN8ZtmfMg-1; Thu, 22 Jul 2021 07:27:12 -0400
X-MC-Unique: zyVa9UfwPGqp8DN8ZtmfMg-1
Received: by mail-wr1-f71.google.com with SMTP id m9-20020a5d4a090000b029013e2b4a9d1eso2349650wrq.4
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 04:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RwooZuX+T4UwbqH1NuEg8JcZz0cwsNi4PKDnQUP8J18=;
        b=rdlgXyhcfUudY/kYdaNHjPb84/y1+YTEBZV3SGX8MURgK2inLY0m9TIwLw2otMu/Jx
         7zImXqFC6z2U7DCj6sT2fRXGKullf5jvQpAjAykZ+ENoS27zI0/vp7y9E44WaMlsEh7X
         VIttuj0ca/r9VTlLnz29zOHH6XKrZnyzgOqOsjndiFaFrsB/Hof4bKk2ot4lsGdz/Cn0
         C3sZBMvP1s1Lki7BLztqzYPfXMTCCuEU/FMxG5X0wnt8DuWXm1QMDSy3Tys9ZyfwnMMW
         ehEgSgnyq5J7CEq6AjDgicZirj1eYAk4Kii+pu3qEdqu0aApiool57/UFgIrrZRuafR6
         s5DA==
X-Gm-Message-State: AOAM530b3+uBxJoJ+RgDT9xGc0gaG4tqpN6q0Sq2e7p9iiFnyILzDB4s
        Rr3YXEVqzpdxDwWyG9cD5DXGRgAg2dvwJkoM0dBUmhb8kejAzD+eZAue0uFyWgbMfSh+hiVDXzx
        R1Xu/qtIOlJNKP+rCj6mVapIPqpHZp1SMfPycNaRVzBxVR/ZVHAQwKOb61z52
X-Received: by 2002:adf:dec4:: with SMTP id i4mr47706011wrn.191.1626953231011;
        Thu, 22 Jul 2021 04:27:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzW9xmWmsEhCPl8LB7BvkEB1Gyh7A5gM8w8fbG44sltukHqjyKmYr/b4yTiip6cvjn+CiLlaw==
X-Received: by 2002:adf:dec4:: with SMTP id i4mr47705982wrn.191.1626953230743;
        Thu, 22 Jul 2021 04:27:10 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83f5d.dip0.t-ipconnect.de. [217.232.63.93])
        by smtp.gmail.com with ESMTPSA id p5sm32527297wrd.25.2021.07.22.04.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 04:27:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] README.md: remove duplicate "to adhere"
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20210614100151.123622-1-cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <36746886-326e-f116-7783-2579993c3027@redhat.com>
Date:   Thu, 22 Jul 2021 13:27:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210614100151.123622-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/2021 12.01, Cornelia Huck wrote:
> Fixes: 844669a9631d ("README.md: add guideline for header guards format")
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   README.md | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/README.md b/README.md
> index 687ff50d0af1..b498aafd1a77 100644
> --- a/README.md
> +++ b/README.md
> @@ -158,7 +158,7 @@ Exceptions:
>   
>   Header guards:
>   
> -Please try to adhere to adhere to the following patterns when adding
> +Please try to adhere to the following patterns when adding
>   "#ifndef <...> #define <...>" header guards:
>       ./lib:             _HEADER_H_
>       ./lib/<ARCH>:      _ARCH_HEADER_H_
> 

Thanks, finally pushed to the repo.

  Thomas

