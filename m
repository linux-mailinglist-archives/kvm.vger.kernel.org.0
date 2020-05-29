Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C321E7B68
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 13:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgE2LNQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 07:13:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25675 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbgE2LNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 07:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590750793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k3AfmsRT0TiIWR7m+9uIgkkFYc4AqBIq+Eofk3eZmvk=;
        b=Xg0dglchWyY8s/KRIifDzEzAMIyz6q1ADNCbyGcHX9kaYx68YE25UMu2UeSzElss+pnVDu
        ohtgIk5sbzGyufcDnwrmX8CLxbc1JZ5ziHrcnElB99Pupkwz037NYQeM9coKud3D9oVj2h
        H27ZC8P7heDPzVVbMre0b/HkkJCWEOU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-RhNhB0DzPrq_Yb8m-mOkVQ-1; Fri, 29 May 2020 07:13:12 -0400
X-MC-Unique: RhNhB0DzPrq_Yb8m-mOkVQ-1
Received: by mail-wr1-f72.google.com with SMTP id p10so901526wrn.19
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 04:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k3AfmsRT0TiIWR7m+9uIgkkFYc4AqBIq+Eofk3eZmvk=;
        b=htiIPprqZL0/7puDHW3ommNSuVSRgVWQTiH5S5M4luASVYnbo5AUkqycfIskCNj8yd
         B71P0npjY5UTVwQRsroEAOf/6Bg2kZ2AiV3DomRErhyJxZZTF6s/+YLrRsdWbyqr0cw1
         ipz97vGy/LrinfAtPYXfRI1yiZ+ob7Ch2jonnbiU2siq08P1Ur88xZaoX0beQJ8sk4v6
         Wi/Zkw9a4+dd707n62gYqwu9HOJPxGlA7nvp6hFd5EpvKazY3JUvW6oBop+JRbXT8UmH
         gxw6ZsIMuoV5rZhSsuMPijcJmVd7UWqyg3CJE18kW0FIxCpwb9YbsjgtAaTX5IKFd4OW
         Ot6Q==
X-Gm-Message-State: AOAM531KHU2MemZGe7MOrwYIMT0vDKZHvyDt0KoJ4czQvnd7a3C1Ae5h
        ZHVKOj8N8L3NeEV2mz7csbzNW7oIb017Hu503MZtQDzFawUeS5sOICNuW9uTZbSOb6j21XgWSgG
        E31P8tV2/NDuO
X-Received: by 2002:adf:9f0b:: with SMTP id l11mr4003803wrf.66.1590750790967;
        Fri, 29 May 2020 04:13:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDYEHrheOkcfEc2jUohO+GtONYKzeGu2Vjgv978rRE4MKHlxn9rxABO3lp12HN2dFuTClPmA==
X-Received: by 2002:adf:9f0b:: with SMTP id l11mr4003778wrf.66.1590750790711;
        Fri, 29 May 2020 04:13:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id u130sm10768318wmg.32.2020.05.29.04.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 04:13:10 -0700 (PDT)
Subject: Re: [PATCH v11 2/7] x86/kvm/hyper-v: Simplify addition for custom
 cpuid leafs
To:     Jon Doron <arilou@gmail.com>, Roman Kagan <rvkagan@yandex-team.ru>,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        vkuznets@redhat.com
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-3-arilou@gmail.com>
 <20200513092404.GB29650@rvkaganb.lan> <20200513124915.GM2862@jondnuc>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <df0a2749-ea11-43bb-bf5a-1c37bd931389@redhat.com>
Date:   Fri, 29 May 2020 13:13:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200513124915.GM2862@jondnuc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/20 14:49, Jon Doron wrote:
>>
> 
> To be honest from my understanding of the TLFS it states:
> "The maximum input value for hypervisor CPUID information."
> 
> So we should not expose stuff we wont "answer" to, I agree you can
> always issue CPUID to any leaf and you will get zeroes but if we try to
> follow TLFS it sounds like this needs to be capped here.

I think Roman is right in the reading, but it's also nicer to have a
capped EAX because you can just look at EAX and guess what features are
there (it's simpler than looking for zeroes).

Paolo

